// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:typed_data';

import '../substrate/substrate.dart';

final Float64List _powersOfTen = Float64List.fromList([
  1.0,
  1e1,
  1e2,
  1e3,
  1e4,
  1e5,
  1e6,
  1e7,
  1e8,
  1e9,
  1e10,
  1e11,
  1e12,
  1e13,
  1e14,
  1e15,
  1e16,
]);

const String _digitPairs =
    '00010203040506070809'
    '10111213141516171819'
    '20212223242526272829'
    '30313233343536373839'
    '40414243444546474849'
    '50515253545556575859'
    '60616263646566676869'
    '70717273747576777879'
    '80818283848586878889'
    '90919293949596979899';

const String _hexDigits = '0123456789abcdef';

@pragma('vm:prefer-inline')
void _emitDigitsBackwardNegative(Uint8List buffer, int writePos, int negVal) {
  var temp = negVal;
  while (temp <= -100) {
    final next = temp ~/ 100;
    final rem = -(temp - next * 100);
    final pairIdx = rem << 1;
    buffer[writePos] = _digitPairs.codeUnitAt(pairIdx + 1);
    buffer[writePos - 1] = _digitPairs.codeUnitAt(pairIdx);
    writePos -= 2;
    temp = next;
  }
  if (temp <= -10) {
    final rem = -temp;
    final pairIdx = rem << 1;
    buffer[writePos] = _digitPairs.codeUnitAt(pairIdx + 1);
    buffer[writePos - 1] = _digitPairs.codeUnitAt(pairIdx);
  } else {
    buffer[writePos] = 48 - temp;
  }
}

const List<int> _digitCountThresholds = [
  -10,
  -100,
  -1000,
  -10000,
  -100000,
  -1000000,
  -10000000,
  -100000000,
  -1000000000,
  -10000000000,
  -100000000000,
  -1000000000000,
  -10000000000000,
  -100000000000000,
  -1000000000000000,
  -10000000000000000,
  -100000000000000000,
  -1000000000000000000,
];

@pragma('vm:prefer-inline')
int _digitCountNegative(int v) {
  for (var i = 0; i < 18; i++) {
    if (v > _digitCountThresholds[i]) return i + 1;
  }
  return 19;
}

@pragma('vm:prefer-inline')
int _writeIntToBuffer(int value, Uint8List buffer, int offset) {
  if (value == 0) {
    buffer[offset] = 48; // '0'
    return 1;
  }
  var v = value;
  final isNeg = v < 0;
  if (!isNeg) {
    v = -v;
  }
  final digitCount = _digitCountNegative(v);
  final totalLen = (isNeg ? 1 : 0) + digitCount;
  var cursor = offset;
  if (isNeg) {
    buffer[cursor++] = 45; // '-'
  }
  final writePos = cursor + digitCount - 1;
  _emitDigitsBackwardNegative(buffer, writePos, v);
  return totalLen;
}

@pragma('vm:prefer-inline')
bool _isSimpleAsciiString(String value) {
  final len = value.length;
  for (var i = 0; i < len; i++) {
    final c = value.codeUnitAt(i);
    if (c < 0x20 || c == 0x22 || c == 0x5C || c >= 0x80) {
      return false;
    }
  }
  return true;
}

@pragma('vm:prefer-inline')
int _writeEscapedChar(int c, Uint8List buffer, int cursor) {
  buffer[cursor] = 0x5C;
  switch (c) {
    case 0x22:
      buffer[cursor + 1] = 0x22;
      return 2;
    case 0x5C:
      buffer[cursor + 1] = 0x5C;
      return 2;
    case 0x08:
      buffer[cursor + 1] = 0x62;
      return 2;
    case 0x0C:
      buffer[cursor + 1] = 0x66;
      return 2;
    case 0x0A:
      buffer[cursor + 1] = 0x6E;
      return 2;
    case 0x0D:
      buffer[cursor + 1] = 0x72;
      return 2;
    case 0x09:
      buffer[cursor + 1] = 0x74;
      return 2;
    default:
      buffer[cursor + 1] = 0x75;
      buffer[cursor + 2] = 0x30;
      buffer[cursor + 3] = 0x30;
      buffer[cursor + 4] = _hexDigits.codeUnitAt((c >> 4) & 0xF);
      buffer[cursor + 5] = _hexDigits.codeUnitAt(c & 0xF);
      return 6;
  }
}

@pragma('vm:prefer-inline')
int _writeUnicodeHexEscape(int c, Uint8List buffer, int cursor) {
  buffer[cursor] = 0x5C;
  buffer[cursor + 1] = 0x75;
  buffer[cursor + 2] = _hexDigits.codeUnitAt((c >> 12) & 0xF);
  buffer[cursor + 3] = _hexDigits.codeUnitAt((c >> 8) & 0xF);
  buffer[cursor + 4] = _hexDigits.codeUnitAt((c >> 4) & 0xF);
  buffer[cursor + 5] = _hexDigits.codeUnitAt(c & 0xF);
  return 6;
}

@pragma('vm:prefer-inline')
int _writeSurrogatePair(int c, int next, Uint8List buffer, int cursor) {
  final codePoint = 0x10000 + ((c - 0xD800) << 10) + (next - 0xDC00);
  buffer[cursor] = 0xF0 | (codePoint >> 18);
  buffer[cursor + 1] = 0x80 | ((codePoint >> 12) & 0x3F);
  buffer[cursor + 2] = 0x80 | ((codePoint >> 6) & 0x3F);
  buffer[cursor + 3] = 0x80 | (codePoint & 0x3F);
  return 4;
}

@pragma('vm:prefer-inline')
int _writeNonAsciiCodeUnit(int c, Uint8List buffer, int cursor) {
  if (c <= 0x7FF) {
    buffer[cursor] = 0xC0 | (c >> 6);
    buffer[cursor + 1] = 0x80 | (c & 0x3F);
    return 2;
  }
  buffer[cursor] = 0xE0 | (c >> 12);
  buffer[cursor + 1] = 0x80 | ((c >> 6) & 0x3F);
  buffer[cursor + 2] = 0x80 | (c & 0x3F);
  return 3;
}

int _writeEscapedStringToBuffer(String value, Uint8List buffer, int offset) {
  var cursor = offset;
  buffer[cursor++] = 0x22; // '"'
  final len = value.length;
  for (var i = 0; i < len; i++) {
    final c = value.codeUnitAt(i);
    if (c < 0x20 || c == 0x22 || c == 0x5C) {
      cursor += _writeEscapedChar(c, buffer, cursor);
    } else if (c <= 0x7F) {
      buffer[cursor++] = c;
    } else if (c >= 0xD800 && c <= 0xDBFF) {
      if (i + 1 < len &&
          value.codeUnitAt(i + 1) >= 0xDC00 &&
          value.codeUnitAt(i + 1) <= 0xDFFF) {
        cursor += _writeSurrogatePair(
          c,
          value.codeUnitAt(i + 1),
          buffer,
          cursor,
        );
        i++;
      } else {
        cursor += _writeUnicodeHexEscape(c, buffer, cursor);
      }
    } else if (c >= 0xDC00 && c <= 0xDFFF) {
      cursor += _writeUnicodeHexEscape(c, buffer, cursor);
    } else {
      cursor += _writeNonAsciiCodeUnit(c, buffer, cursor);
    }
  }
  buffer[cursor++] = 0x22; // '"'
  return cursor - offset;
}

@pragma('vm:prefer-inline')
int _writeStringToBuffer(String value, Uint8List buffer, int offset) {
  final len = value.length;
  if (_isSimpleAsciiString(value)) {
    buffer[offset] = 0x22; // '"'
    for (var i = 0; i < len; i++) {
      buffer[offset + 1 + i] = value.codeUnitAt(i);
    }
    buffer[offset + 1 + len] = 0x22; // '"'
    return len + 2;
  }
  return _writeEscapedStringToBuffer(value, buffer, offset);
}

@pragma('vm:prefer-inline')
int _writeZeroDouble(bool isNeg, Uint8List buffer, int offset) {
  var cursor = offset;
  if (isNeg) buffer[cursor++] = 0x2D;
  buffer[cursor++] = 0x30;
  buffer[cursor++] = 0x2E;
  buffer[cursor++] = 0x30;
  return cursor - offset;
}

@pragma('vm:prefer-inline')
int _tryWriteExactIntDouble(
  double absVal,
  bool isNeg,
  Uint8List buffer,
  int offset,
) {
  final trunc = absVal.truncateToDouble();
  if (absVal != trunc || absVal > 9007199254740991.0) {
    return 0;
  }
  final intVal = absVal.toInt();
  final negVal = -intVal;
  final digitCount = _digitCountNegative(negVal);
  final totalLen = (isNeg ? 1 : 0) + digitCount + 2;
  var cursor = offset;
  if (isNeg) buffer[cursor++] = 0x2D;
  final writePos = cursor + digitCount - 1;
  _emitDigitsBackwardNegative(buffer, writePos, negVal);
  cursor += digitCount;
  buffer[cursor++] = 0x2E;
  buffer[cursor++] = 0x30;
  return totalLen;
}

@pragma('vm:prefer-inline')
int _writeFractionWhole(Uint8List buffer, int offset, bool isNeg, int negVal) {
  final digitCount = _digitCountNegative(negVal);
  final totalLen = (isNeg ? 1 : 0) + digitCount + 2;
  var cursor = offset;
  if (isNeg) buffer[cursor++] = 0x2D;
  final writePos = cursor + digitCount - 1;
  _emitDigitsBackwardNegative(buffer, writePos, negVal);
  cursor += digitCount;
  buffer[cursor++] = 0x2E;
  buffer[cursor++] = 0x30;
  return totalLen;
}

@pragma('vm:prefer-inline')
int _writeFractionSplitDigits(
  Uint8List buffer,
  int offset,
  bool isNeg,
  int negVal,
  int numDigits,
  int k,
) {
  final totalLen = (isNeg ? 1 : 0) + numDigits + 1;
  var cursor = offset;
  if (isNeg) buffer[cursor++] = 0x2D;
  final digitsStart = cursor;
  var writePos = digitsStart + numDigits;
  var temp = negVal;
  var digitsWritten = 0;
  while (digitsWritten < k) {
    final next = temp ~/ 10;
    final rem = -(temp - next * 10);
    buffer[writePos--] = 48 + rem;
    temp = next;
    digitsWritten++;
  }
  buffer[writePos--] = 0x2E;
  _emitDigitsBackwardNegative(buffer, writePos, temp);
  return totalLen;
}

@pragma('vm:prefer-inline')
int _writeFractionLeadingZeros(
  Uint8List buffer,
  int offset,
  bool isNeg,
  int negVal,
  int numDigits,
  int k,
) {
  final leadingZeros = k - numDigits;
  final totalLen = (isNeg ? 1 : 0) + 2 + leadingZeros + numDigits;
  var cursor = offset;
  if (isNeg) buffer[cursor++] = 0x2D;
  buffer[cursor++] = 0x30;
  buffer[cursor++] = 0x2E;
  for (var z = 0; z < leadingZeros; z++) {
    buffer[cursor++] = 0x30;
  }
  final writePos = cursor + numDigits - 1;
  _emitDigitsBackwardNegative(buffer, writePos, negVal);
  return totalLen;
}

@pragma('vm:prefer-inline')
int _writeDecimalFraction(
  Uint8List buffer,
  int offset,
  bool isNeg,
  int intVal,
  int k,
) {
  final negVal = -intVal;
  if (k == 0) {
    return _writeFractionWhole(buffer, offset, isNeg, negVal);
  }
  final numDigits = _digitCountNegative(negVal);
  if (numDigits > k) {
    return _writeFractionSplitDigits(
      buffer,
      offset,
      isNeg,
      negVal,
      numDigits,
      k,
    );
  }
  return _writeFractionLeadingZeros(
    buffer,
    offset,
    isNeg,
    negVal,
    numDigits,
    k,
  );
}

@pragma('vm:prefer-inline')
int _tryWriteScaledFractionDouble(
  double absVal,
  bool isNeg,
  Uint8List buffer,
  int offset,
) {
  if (absVal < 1e-16 || absVal > 1e16) {
    return 0;
  }
  final intPart = absVal.toInt();
  final intPartDigits = intPart == 0 ? 0 : _digitCountNegative(-intPart);
  final maxFrac = 16 - intPartDigits;
  if (maxFrac <= 0 || maxFrac > 16) {
    return 0;
  }
  final p10 = _powersOfTen[maxFrac];
  final scaled = absVal * p10;
  if (scaled > 9007199254740991.0) {
    return 0;
  }
  var intVal = scaled.round();
  if (intVal / p10 != absVal) {
    return 0;
  }
  var k = maxFrac;
  while (k >= 4 && intVal % 10000 == 0) {
    intVal ~/= 10000;
    k -= 4;
  }
  while (k >= 2 && intVal % 100 == 0) {
    intVal ~/= 100;
    k -= 2;
  }
  if (k > 0 && intVal % 10 == 0) {
    intVal ~/= 10;
    k--;
  }
  return _writeDecimalFraction(buffer, offset, isNeg, intVal, k);
}

@pragma('vm:prefer-inline')
int _writeDoubleToBuffer(double value, Uint8List buffer, int offset) {
  if (value == 0.0) {
    return _writeZeroDouble(value.isNegative, buffer, offset);
  }

  final isNeg = value.isNegative;
  final absVal = isNeg ? -value : value;

  final intLen = _tryWriteExactIntDouble(absVal, isNeg, buffer, offset);
  if (intLen > 0) return intLen;

  final fracLen = _tryWriteScaledFractionDouble(absVal, isNeg, buffer, offset);
  if (fracLen > 0) return fracLen;

  final s = value.toString();
  for (var i = 0; i < s.length; i++) {
    buffer[offset + i] = s.codeUnitAt(i);
  }
  return s.length;
}

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
    final written = _writeStringToBuffer(name, _buffer, _cursor);
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
    _ensureCapacity(len + 1);
    _buffer.setRange(_cursor, _cursor + len, asciiKey);
    _cursor += len;
    _buffer[_cursor++] = 58; // ':'
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
    final written = _writeStringToBuffer(value, _buffer, _cursor);
    _cursor += written;
  }

  @override
  void writeInt(int value) {
    _beforeValue();
    _ensureCapacity(24);
    final written = _writeIntToBuffer(value, _buffer, _cursor);
    _cursor += written;
  }

  @override
  void writeDouble(double value) {
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
      final written = _writeDoubleToBuffer(value, _buffer, _cursor);
      _cursor += written;
      return;
    }
    _beforeValue();
    _ensureCapacity(32);
    final written = _writeDoubleToBuffer(value, _buffer, _cursor);
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
