import 'dart:convert';
import 'dart:typed_data';

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

const List<double> _powersOfTen = [
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
];

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

int _digitCountNegative(int v) {
  if (v > -10) return 1;
  if (v > -100) return 2;
  if (v > -1000) return 3;
  if (v > -10000) return 4;
  if (v > -100000) return 5;
  if (v > -1000000) return 6;
  if (v > -10000000) return 7;
  if (v > -100000000) return 8;
  if (v > -1000000000) return 9;
  if (v > -10000000000) return 10;
  if (v > -100000000000) return 11;
  if (v > -1000000000000) return 12;
  if (v > -10000000000000) return 13;
  if (v > -100000000000000) return 14;
  if (v > -1000000000000000) return 15;
  if (v > -10000000000000000) return 16;
  if (v > -100000000000000000) return 17;
  if (v > -1000000000000000000) return 18;
  return 19;
}

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

int _writeStringToBuffer(String value, Uint8List buffer, int offset) {
  final len = value.length;
  var isPureAscii = true;
  for (var i = 0; i < len; i++) {
    final c = value.codeUnitAt(i);
    if (c < 0x20 || c == 0x22 || c == 0x5C || c >= 0x80) {
      isPureAscii = false;
      break;
    }
  }

  if (isPureAscii) {
    buffer[offset] = 0x22; // '"'
    for (var i = 0; i < len; i++) {
      buffer[offset + 1 + i] = value.codeUnitAt(i);
    }
    buffer[offset + 1 + len] = 0x22; // '"'
    return len + 2;
  }

  var cursor = offset;
  buffer[cursor++] = 0x22; // '"'
  for (var i = 0; i < len; i++) {
    final c = value.codeUnitAt(i);
    switch (c) {
      case 0x22:
        buffer[cursor++] = 0x5C;
        buffer[cursor++] = 0x22;
      case 0x5C:
        buffer[cursor++] = 0x5C;
        buffer[cursor++] = 0x5C;
      case 0x08:
        buffer[cursor++] = 0x5C;
        buffer[cursor++] = 0x62;
      case 0x0C:
        buffer[cursor++] = 0x5C;
        buffer[cursor++] = 0x66;
      case 0x0A:
        buffer[cursor++] = 0x5C;
        buffer[cursor++] = 0x6E;
      case 0x0D:
        buffer[cursor++] = 0x5C;
        buffer[cursor++] = 0x72;
      case 0x09:
        buffer[cursor++] = 0x5C;
        buffer[cursor++] = 0x74;
      default:
        if (c < 0x20) {
          buffer[cursor++] = 0x5C;
          buffer[cursor++] = 0x75;
          buffer[cursor++] = 0x30;
          buffer[cursor++] = 0x30;
          buffer[cursor++] = _hexDigits.codeUnitAt((c >> 4) & 0xF);
          buffer[cursor++] = _hexDigits.codeUnitAt(c & 0xF);
        } else if (c <= 0x7F) {
          buffer[cursor++] = c;
        } else if (c <= 0x7FF) {
          buffer[cursor++] = 0xC0 | (c >> 6);
          buffer[cursor++] = 0x80 | (c & 0x3F);
        } else if (c >= 0xD800 && c <= 0xDBFF) {
          if (i + 1 < len) {
            final next = value.codeUnitAt(i + 1);
            if (next >= 0xDC00 && next <= 0xDFFF) {
              final codePoint =
                  0x10000 + ((c - 0xD800) << 10) + (next - 0xDC00);
              buffer[cursor++] = 0xF0 | (codePoint >> 18);
              buffer[cursor++] = 0x80 | ((codePoint >> 12) & 0x3F);
              buffer[cursor++] = 0x80 | ((codePoint >> 6) & 0x3F);
              buffer[cursor++] = 0x80 | (codePoint & 0x3F);
              i++;
              continue;
            }
          }
          buffer[cursor++] = 0x5C;
          buffer[cursor++] = 0x75;
          buffer[cursor++] = _hexDigits.codeUnitAt((c >> 12) & 0xF);
          buffer[cursor++] = _hexDigits.codeUnitAt((c >> 8) & 0xF);
          buffer[cursor++] = _hexDigits.codeUnitAt((c >> 4) & 0xF);
          buffer[cursor++] = _hexDigits.codeUnitAt(c & 0xF);
        } else if (c >= 0xDC00 && c <= 0xDFFF) {
          buffer[cursor++] = 0x5C;
          buffer[cursor++] = 0x75;
          buffer[cursor++] = _hexDigits.codeUnitAt((c >> 12) & 0xF);
          buffer[cursor++] = _hexDigits.codeUnitAt((c >> 8) & 0xF);
          buffer[cursor++] = _hexDigits.codeUnitAt((c >> 4) & 0xF);
          buffer[cursor++] = _hexDigits.codeUnitAt(c & 0xF);
        } else {
          buffer[cursor++] = 0xE0 | (c >> 12);
          buffer[cursor++] = 0x80 | ((c >> 6) & 0x3F);
          buffer[cursor++] = 0x80 | (c & 0x3F);
        }
    }
  }
  buffer[cursor++] = 0x22; // '"'
  return cursor - offset;
}

int _writeDoubleToBuffer(double value, Uint8List buffer, int offset) {
  if (value == 0.0) {
    if (value.isNegative) {
      buffer[offset] = 0x2D;
      buffer[offset + 1] = 0x30;
      buffer[offset + 2] = 0x2E;
      buffer[offset + 3] = 0x30;
      return 4;
    } else {
      buffer[offset] = 0x30;
      buffer[offset + 1] = 0x2E;
      buffer[offset + 2] = 0x30;
      return 3;
    }
  }

  final isNeg = value.isNegative;
  final absVal = isNeg ? -value : value;
  final trunc = absVal.truncateToDouble();

  if (absVal == trunc && absVal <= 9007199254740991.0) {
    final intVal = absVal.toInt();
    final negVal = -intVal;
    final digitCount = _digitCountNegative(negVal);
    final totalLen = (isNeg ? 1 : 0) + digitCount + 2;
    var cursor = offset;
    if (isNeg) {
      buffer[cursor++] = 0x2D;
    }
    final writePos = cursor + digitCount - 1;
    _emitDigitsBackwardNegative(buffer, writePos, negVal);
    cursor += digitCount;
    buffer[cursor++] = 0x2E;
    buffer[cursor++] = 0x30;
    return totalLen;
  }

  if (absVal >= 1e-15 && absVal <= 1e15) {
    final intPart = absVal.toInt();
    final intPartDigits = intPart == 0 ? 0 : _digitCountNegative(-intPart);
    final maxFrac = 15 - intPartDigits;
    if (maxFrac > 0 && maxFrac <= 15) {
      final p10 = _powersOfTen[maxFrac];
      final scaled = absVal * p10;
      if (scaled <= 9007199254740991.0) {
        var intVal = scaled.round();
        if (intVal / p10 == absVal) {
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
          if (k == 0) {
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

          final negVal = -intVal;
          final numDigits = _digitCountNegative(negVal);
          if (numDigits > k) {
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
          } else {
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
        }
      }
    }
  }

  final s = value.toString();
  for (var i = 0; i < s.length; i++) {
    buffer[offset + i] = s.codeUnitAt(i);
  }
  return s.length;
}

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
    if (len <= 32) {
      var isAscii = true;
      for (var i = 0; i < len; i++) {
        final c = name.codeUnitAt(i);
        if (c < 0x20 || c == 0x22 || c == 0x5C || c >= 0x80) {
          isAscii = false;
          break;
        }
      }
      if (isAscii) {
        _ensureCapacity(len + 3);
        _buffer[_cursor++] = 0x22; // '"'
        for (var i = 0; i < len; i++) {
          _buffer[_cursor++] = name.codeUnitAt(i);
        }
        _buffer[_cursor++] = 0x22; // '"'
        _buffer[_cursor++] = 0x3A; // ':'
        return;
      }
    }
    _ensureCapacity(len * 6 + 4);
    final written = _writeStringToBuffer(name, _buffer, _cursor);
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
          _buffer[_cursor++] = _hexDigits.codeUnitAt((b >> 4) & 0xF);
          _buffer[_cursor++] = _hexDigits.codeUnitAt(b & 0xF);
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
    if (len <= 32) {
      var isAscii = true;
      for (var i = 0; i < len; i++) {
        final c = value.codeUnitAt(i);
        if (c < 0x20 || c == 0x22 || c == 0x5C || c >= 0x80) {
          isAscii = false;
          break;
        }
      }
      if (isAscii) {
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
    }
    _beforeValue();
    _ensureCapacity(len * 6 + 2);
    final written = _writeStringToBuffer(value, _buffer, _cursor);
    _cursor += written;
    if (_stackLength == 0) {
      _flushBuffer();
    }
  }

  @override
  void writeInt(int value) {
    _beforeValue();
    _ensureCapacity(24);
    final written = _writeIntToBuffer(value, _buffer, _cursor);
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
    final written = _writeDoubleToBuffer(value, _buffer, _cursor);
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
