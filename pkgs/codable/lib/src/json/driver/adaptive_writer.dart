// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:typed_data';

import '../substrate/substrate.dart';
import '../substrate/writer_formatting.dart';

/// A high-performance JSON token writer that starts with an adaptive compact
/// buffer (e.g. 1024 bytes) and dynamically transitions to chunked buffer
/// builder output only if the payload exceeds initial capacity.
final class AdaptiveJsonTokenWriter implements JsonTokenWriter {
  static const int _chunkSize = 32768;
  static const int _maxDepth = 1024;

  BytesBuilder? _sink;
  Uint8List _buffer;
  int _cursor = 0;

  Uint8List _typeStack = Uint8List(16);
  Uint8List _stateStack = Uint8List(16);
  int _stackLength = 0;
  int _topType = -1;
  int _topState = 0;
  bool _hasRootValue = false;

  AdaptiveJsonTokenWriter([int initialCapacity = 1024])
    : _buffer = Uint8List(initialCapacity);

  @pragma('vm:prefer-inline')
  void _ensureCapacity(int needed) {
    if (_cursor + needed > _buffer.length) {
      _flushBuffer(needed);
    }
  }

  void _flushBuffer([int needed = 0]) {
    _sink ??= BytesBuilder(copy: false);
    if (_cursor > 0) {
      _sink!.add(Uint8List.sublistView(_buffer, 0, _cursor));
      _cursor = 0;
    }
    final nextSize = needed > _chunkSize ? needed : _chunkSize;
    _buffer = Uint8List(nextSize);
  }

  @pragma('vm:prefer-inline')
  void _writeDirectByte(int byte) {
    if (_cursor >= _buffer.length) {
      _flushBuffer(1);
    }
    _buffer[_cursor++] = byte;
  }

  @pragma('vm:prefer-inline')
  void _beforeValue() {
    if (_stackLength > 0) {
      if (_topType == 0) {
        if (_topState != 1) {
          throw StateError('Expected property name before value in object');
        }
        _topState = 2;
      } else {
        if (_topState != 0) {
          _writeDirectByte(44); // ','
        }
        _topState = 1;
      }
    } else {
      if (_hasRootValue) {
        throw StateError('Cannot write multiple root values');
      }
      _hasRootValue = true;
    }
  }

  @override
  void beginObject() {
    if (_stackLength >= _maxDepth) {
      throw StateError('Nesting depth exceeds limit of $_maxDepth');
    }
    _beforeValue();
    _writeDirectByte(123); // '{'
    if (_stackLength > 0) {
      if (_stackLength >= _typeStack.length) {
        final newCap = _typeStack.length * 2;
        final newType = Uint8List(newCap);
        newType.setRange(0, _typeStack.length, _typeStack);
        _typeStack = newType;
        final newState = Uint8List(newCap);
        newState.setRange(0, _stateStack.length, _stateStack);
        _stateStack = newState;
      }
      _typeStack[_stackLength - 1] = _topType;
      _stateStack[_stackLength - 1] = _topState;
    }
    _stackLength++;
    _topType = 0;
    _topState = 0;
  }

  @override
  void endObject() {
    if (_stackLength == 0 || _topType != 0) {
      throw StateError('Cannot endObject: not inside an object');
    }
    if (_topState == 1) {
      throw StateError('Cannot endObject: expected value after property name');
    }
    _writeDirectByte(125); // '}'
    _stackLength--;
    if (_stackLength > 0) {
      _topType = _typeStack[_stackLength - 1];
      _topState = _stateStack[_stackLength - 1];
    } else {
      _topType = -1;
      _topState = 0;
    }
  }

  @override
  void beginArray() {
    if (_stackLength >= _maxDepth) {
      throw StateError('Nesting depth exceeds limit of $_maxDepth');
    }
    _beforeValue();
    _writeDirectByte(91); // '['
    if (_stackLength > 0) {
      if (_stackLength >= _typeStack.length) {
        final newCap = _typeStack.length * 2;
        final newType = Uint8List(newCap);
        newType.setRange(0, _typeStack.length, _typeStack);
        _typeStack = newType;
        final newState = Uint8List(newCap);
        newState.setRange(0, _stateStack.length, _stateStack);
        _stateStack = newState;
      }
      _typeStack[_stackLength - 1] = _topType;
      _stateStack[_stackLength - 1] = _topState;
    }
    _stackLength++;
    _topType = 1;
    _topState = 0;
  }

  @override
  void endArray() {
    if (_stackLength == 0 || _topType != 1) {
      throw StateError('Cannot endArray: not inside an array');
    }
    _writeDirectByte(93); // ']'
    _stackLength--;
    if (_stackLength > 0) {
      _topType = _typeStack[_stackLength - 1];
      _topState = _stateStack[_stackLength - 1];
    } else {
      _topType = -1;
      _topState = 0;
    }
  }

  @override
  void writeName(String name) {
    if (_stackLength == 0 || _topType != 0) {
      throw StateError('Cannot writeName: not inside an object');
    }
    if (_topState != 0 && _topState != 2) {
      throw StateError('Cannot writeName: expected value before next property');
    }
    if (_topState == 2) {
      _writeDirectByte(44); // ','
    }
    _topState = 1;
    final len = name.length;
    _ensureCapacity(len * 6 + 3);
    final written = writeStringToBuffer(name, _buffer, _cursor);
    _cursor += written;
    _buffer[_cursor++] = 58; // ':'
  }

  @override
  void writeNameBytes(Uint8List asciiKey) {
    if (_stackLength == 0 || _topType != 0) {
      throw StateError('Cannot writeNameBytes: not inside an object');
    }
    if (_topState != 0 && _topState != 2) {
      throw StateError(
        'Cannot writeNameBytes: expected value before next property',
      );
    }
    if (_topState == 2) {
      _writeDirectByte(44); // ','
    }
    _topState = 1;
    final len = asciiKey.length;
    if (len >= 3 && asciiKey[0] == 0x22 && asciiKey[len - 1] == 0x3A) {
      _ensureCapacity(len);
      _buffer.setRange(_cursor, _cursor + len, asciiKey);
      _cursor += len;
    } else if (len >= 2 && asciiKey[0] == 0x22 && asciiKey[len - 1] == 0x22) {
      _ensureCapacity(len + 1);
      _buffer.setRange(_cursor, _cursor + len, asciiKey);
      _cursor += len;
      _buffer[_cursor++] = 58; // ':'
    } else {
      _ensureCapacity(len + 3);
      _buffer[_cursor++] = 0x22; // '"'
      _buffer.setRange(_cursor, _cursor + len, asciiKey);
      _cursor += len;
      _buffer[_cursor++] = 0x22; // '"'
      _buffer[_cursor++] = 58; // ':'
    }
  }

  @override
  void writeAsciiLiteral(Uint8List preEncoded) {
    _beforeValue();
    final len = preEncoded.length;
    _ensureCapacity(len);
    _buffer.setRange(_cursor, _cursor + len, preEncoded);
    _cursor += len;
  }

  @override
  void writeRawJson(Uint8List rawJson) {
    _beforeValue();
    final len = rawJson.length;
    _ensureCapacity(len);
    _buffer.setRange(_cursor, _cursor + len, rawJson);
    _cursor += len;
  }

  @override
  void writeString(String value) {
    _beforeValue();
    final len = value.length;
    _ensureCapacity(len * 6 + 2);
    final written = writeStringToBuffer(value, _buffer, _cursor);
    _cursor += written;
  }

  @override
  void writeInt(int value) {
    _beforeValue();
    _ensureCapacity(24);
    final written = writeIntToBuffer(value, _buffer, _cursor);
    _cursor += written;
  }

  @override
  void writeDouble(double value) {
    if (value.isNaN || value.isInfinite) {
      throw UnsupportedError('NaN and Infinity are not supported in JSON');
    }
    if (_stackLength > 0 && _topType == 1) {
      if (_topState != 0) {
        if (_cursor + 33 > _buffer.length) {
          _flushBuffer(33);
        }
        _buffer[_cursor++] = 44; // ','
      } else {
        if (_cursor + 32 > _buffer.length) {
          _flushBuffer(32);
        }
        _topState = 1;
      }
      final written = writeDoubleToBuffer(value, _buffer, _cursor);
      _cursor += written;
      return;
    }
    _beforeValue();
    _ensureCapacity(32);
    final written = writeDoubleToBuffer(value, _buffer, _cursor);
    _cursor += written;
  }

  @override
  void writeBool(bool value) {
    _beforeValue();
    if (value) {
      _ensureCapacity(4);
      _buffer[_cursor++] = 116;
      _buffer[_cursor++] = 114;
      _buffer[_cursor++] = 117;
      _buffer[_cursor++] = 101;
    } else {
      _ensureCapacity(5);
      _buffer[_cursor++] = 102;
      _buffer[_cursor++] = 97;
      _buffer[_cursor++] = 108;
      _buffer[_cursor++] = 115;
      _buffer[_cursor++] = 101;
    }
  }

  @override
  void writeNull() {
    _beforeValue();
    _ensureCapacity(4);
    _buffer[_cursor++] = 110;
    _buffer[_cursor++] = 117;
    _buffer[_cursor++] = 108;
    _buffer[_cursor++] = 108;
  }

  @override
  void flush() {
    if (_sink != null && _cursor > 0) {
      _sink!.add(Uint8List.sublistView(_buffer, 0, _cursor));
      _cursor = 0;
      _buffer = Uint8List(_chunkSize);
    }
  }

  Uint8List takeBytes() {
    if (_sink == null) {
      return Uint8List.sublistView(_buffer, 0, _cursor);
    }
    if (_cursor > 0) {
      _sink!.add(Uint8List.sublistView(_buffer, 0, _cursor));
      _cursor = 0;
    }
    return _sink!.takeBytes();
  }
}
