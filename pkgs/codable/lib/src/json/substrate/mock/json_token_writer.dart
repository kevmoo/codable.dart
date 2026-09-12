import 'dart:convert';
import 'dart:typed_data';

import '../writer_formatting.dart';

/// Push-based JSON token writer emitting to a [BytesBuilder].
abstract interface class JsonTokenWriter {
  /// Instantiates a token writer emitting to [sink].
  factory JsonTokenWriter.toSink(BytesBuilder sink) = JsonUtf8TokenWriter;

  void beginObject();
  void endObject();
  void beginArray();
  void endArray();
  void writeName(String name);
  void writeNameBytes(Uint8List asciiKey);
  void writeAsciiLiteral(Uint8List preEncoded);
  void writeRawJson(Uint8List rawJson);
  void writeString(String value);
  void writeInt(int value);
  void writeDouble(double value);
  void writeBool(bool value);
  void writeNull();

  /// Flushes any buffered bytes to the underlying sink.
  void flush();
}

final class JsonUtf8TokenWriter implements JsonTokenWriter {
  static const int _maxDepth = 1024;
  static const int _chunkSize = 32768;

  final BytesBuilder _sink;
  Uint8List _buffer = Uint8List(_chunkSize);
  int _cursor = 0;

  Uint8List _typeStack = Uint8List(64);
  Uint8List _stateStack = Uint8List(64);
  int _stackLength = 0;
  int _topType = -1; // -1: none, 0: object, 1: array
  // in object: 0: empty, 1: key, 2: value; in array: 0: first, 1: not first
  int _topState = 0;
  bool _hasRootValue = false;

  JsonUtf8TokenWriter(this._sink);

  void _ensureCapacity(int needed) {
    if (_cursor + needed > _buffer.length) {
      _flushBuffer();
      if (needed > _buffer.length) {
        _buffer = Uint8List(needed > _chunkSize ? needed : _chunkSize);
      }
    }
  }

  void _flushBuffer() {
    if (_cursor > 0) {
      _sink.add(Uint8List.sublistView(_buffer, 0, _cursor));
      _buffer = Uint8List(_chunkSize);
      _cursor = 0;
    }
  }

  void _writeDirectByte(int byte) {
    if (_cursor >= _buffer.length) {
      _flushBuffer();
    }
    _buffer[_cursor++] = byte;
  }

  @override
  void flush() => _flushBuffer();

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
        final newTypeStack = Uint8List(newCap);
        newTypeStack.setRange(0, _typeStack.length, _typeStack);
        _typeStack = newTypeStack;
        final newStateStack = Uint8List(newCap);
        newStateStack.setRange(0, _stateStack.length, _stateStack);
        _stateStack = newStateStack;
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
      _flushBuffer();
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
        final newTypeStack = Uint8List(newCap);
        newTypeStack.setRange(0, _typeStack.length, _typeStack);
        _typeStack = newTypeStack;
        final newStateStack = Uint8List(newCap);
        newStateStack.setRange(0, _stateStack.length, _stateStack);
        _stateStack = newStateStack;
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
      _flushBuffer();
    }
  }

  @override
  void writeName(String name) {
    if (_stackLength == 0 || _topType != 0) {
      throw StateError('Cannot writeName: not inside an object');
    }
    if (_topState == 1) {
      throw StateError(
        'Cannot writeName: already expecting a value for previous property',
      );
    }
    if (_topState == 2) {
      _writeDirectByte(44); // ','
    }
    _topState = 1;
    final len = name.length;
    if (len <= 32 && isSimpleAsciiString(name)) {
      _ensureCapacity(len + 3);
      _buffer[_cursor++] = 0x22; // '"'
      for (var i = 0; i < len; i++) {
        _buffer[_cursor++] = name.codeUnitAt(i);
      }
      _buffer[_cursor++] = 0x22; // '"'
      _buffer[_cursor++] = 0x3A; // ':'
      return;
    }
    _ensureCapacity(len * 6 + 4);
    final written = writeStringToBuffer(name, _buffer, _cursor);
    _cursor += written;
    _buffer[_cursor++] = 0x3A; // ':'
  }

  @override
  void writeNameBytes(Uint8List asciiKey) {
    if (_stackLength == 0 || _topType != 0) {
      throw StateError('Cannot writeNameBytes: not inside an object');
    }
    if (_topState == 1) {
      throw StateError(
        'Cannot writeNameBytes: already expecting a value for previous '
        'property',
      );
    }
    if (_topState == 2) {
      _writeDirectByte(44); // ','
    }
    _topState = 1;
    final isColonTerminated =
        asciiKey.length >= 3 &&
        asciiKey.first == 0x22 &&
        asciiKey.last == 0x3A &&
        _isSingleQuotedSlice(asciiKey, 0, asciiKey.length - 1);
    if (isColonTerminated) {
      final len = asciiKey.length;
      _ensureCapacity(len);
      _buffer.setRange(_cursor, _cursor + len, asciiKey);
      _cursor += len;
      return;
    }
    final isQuoted = _isSingleQuotedString(asciiKey);
    if (isQuoted) {
      final len = asciiKey.length;
      _ensureCapacity(len + 1);
      _buffer.setRange(_cursor, _cursor + len, asciiKey);
      _cursor += len;
      _buffer[_cursor++] = 0x3A; // ':'
    } else {
      final len = asciiKey.length;
      _ensureCapacity(len * 6 + 3);
      _buffer[_cursor++] = 0x22; // '"'
      for (var i = 0; i < len; i++) {
        final b = asciiKey[i];
        if (b == 0x22) {
          _buffer[_cursor++] = 0x5C;
          _buffer[_cursor++] = 0x22;
        } else if (b == 0x5C) {
          _buffer[_cursor++] = 0x5C;
          _buffer[_cursor++] = 0x5C;
        } else if (b < 0x20) {
          _buffer[_cursor++] = 0x5C;
          _buffer[_cursor++] = 0x75; // 'u'
          _buffer[_cursor++] = 0x30; // '0'
          _buffer[_cursor++] = 0x30; // '0'
          _buffer[_cursor++] = hexDigits.codeUnitAt((b >> 4) & 0xF);
          _buffer[_cursor++] = hexDigits.codeUnitAt(b & 0xF);
        } else {
          _buffer[_cursor++] = b;
        }
      }
      _buffer[_cursor++] = 0x22; // '"'
      _buffer[_cursor++] = 0x3A; // ':'
    }
  }

  @override
  void writeAsciiLiteral(Uint8List preEncoded) {
    _beforeValue();
    final len = preEncoded.length;
    _ensureCapacity(len);
    _buffer.setRange(_cursor, _cursor + len, preEncoded);
    _cursor += len;
    if (_stackLength == 0) {
      _flushBuffer();
    }
  }

  @override
  void writeRawJson(Uint8List rawJson) {
    _beforeValue();
    final len = rawJson.length;
    _ensureCapacity(len);
    _buffer.setRange(_cursor, _cursor + len, rawJson);
    _cursor += len;
    if (_stackLength == 0) {
      _flushBuffer();
    }
  }

  @override
  void writeString(String value) {
    final len = value.length;
    if (len <= 32 && isSimpleAsciiString(value)) {
      _beforeValue();
      _ensureCapacity(len + 2);
      _buffer[_cursor++] = 0x22; // '"'
      for (var i = 0; i < len; i++) {
        _buffer[_cursor++] = value.codeUnitAt(i);
      }
      _buffer[_cursor++] = 0x22; // '"'
      if (_stackLength == 0) {
        _flushBuffer();
      }
      return;
    }
    _beforeValue();
    _ensureCapacity(len * 6 + 2);
    final written = writeStringToBuffer(value, _buffer, _cursor);
    _cursor += written;
    if (_stackLength == 0) {
      _flushBuffer();
    }
  }

  @override
  void writeInt(int value) {
    _beforeValue();
    _ensureCapacity(24);
    final written = writeIntToBuffer(value, _buffer, _cursor);
    _cursor += written;
    if (_stackLength == 0) {
      _flushBuffer();
    }
  }

  @override
  void writeDouble(double value) {
    _beforeValue();
    if (value.isNaN || value.isInfinite) {
      throw JsonUnsupportedObjectError(
        value,
        cause: '${value.isNaN ? "NaN" : "Infinity"} is not supported in JSON',
      );
    }
    _ensureCapacity(32);
    final written = writeDoubleToBuffer(value, _buffer, _cursor);
    _cursor += written;
    if (_stackLength == 0) {
      _flushBuffer();
    }
  }

  @override
  void writeBool(bool value) {
    _beforeValue();
    if (value) {
      _ensureCapacity(4);
      _buffer[_cursor++] = 116; // 't'
      _buffer[_cursor++] = 114; // 'r'
      _buffer[_cursor++] = 117; // 'u'
      _buffer[_cursor++] = 101; // 'e'
    } else {
      _ensureCapacity(5);
      _buffer[_cursor++] = 102; // 'f'
      _buffer[_cursor++] = 97; // 'a'
      _buffer[_cursor++] = 108; // 'l'
      _buffer[_cursor++] = 115; // 's'
      _buffer[_cursor++] = 101; // 'e'
    }
    if (_stackLength == 0) {
      _flushBuffer();
    }
  }

  @override
  void writeNull() {
    _beforeValue();
    _ensureCapacity(4);
    _buffer[_cursor++] = 110; // 'n'
    _buffer[_cursor++] = 117; // 'u'
    _buffer[_cursor++] = 108; // 'l'
    _buffer[_cursor++] = 108; // 'l'
    if (_stackLength == 0) {
      _flushBuffer();
    }
  }
}

bool _isSingleQuotedString(Uint8List bytes) {
  return _isSingleQuotedSlice(bytes, 0, bytes.length);
}

bool _isSingleQuotedSlice(Uint8List bytes, int start, int end) {
  if (start < 0 ||
      end > bytes.length ||
      end - start < 2 ||
      bytes[start] != 0x22 ||
      bytes[end - 1] != 0x22) {
    return false;
  }
  var i = start + 1;
  final last = end - 1;
  while (i < last) {
    final b = bytes[i];
    if (b == 0x22 || b < 0x20) {
      return false;
    }
    if (b == 0x5C) {
      if (i + 1 >= last) return false;
      final next = bytes[i + 1];
      if (next == 0x22 || // '"'
          next == 0x5C || // '\'
          next == 0x2F || // '/'
          next == 0x62 || // 'b'
          next == 0x66 || // 'f'
          next == 0x6E || // 'n'
          next == 0x72 || // 'r'
          next == 0x74) {
        // 't'
        i += 2;
      } else if (next == 0x75) {
        // 'u'
        if (i + 5 >= last + 1) return false;
        for (var j = i + 2; j <= i + 5; j++) {
          final c = bytes[j];
          final isHex =
              (c >= 48 && c <= 57) ||
              (c >= 65 && c <= 70) ||
              (c >= 97 && c <= 102);
          if (!isHex) return false;
        }
        i += 6;
      } else {
        return false;
      }
    } else {
      i++;
    }
  }
  return true;
}
