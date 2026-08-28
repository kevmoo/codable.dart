import 'dart:convert';
import 'dart:typed_data';

enum _ContainerType { object, array }

enum _ObjectState { empty, key, value }

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

  final List<_ContainerType> _stateStack = [];
  final List<_ObjectState> _objectStateStack = [];
  final List<bool> _isArrayFirstStack = [];
  bool _hasRootValue = false;

  JsonUtf8TokenWriter(this._sink);

  void _ensureCapacity(int needed) {
    if (_cursor + needed > _buffer.length) {
      _flushBuffer();
      if (needed > _buffer.length) {
        _buffer = Uint8List(needed * 2);
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

  void _beforeValue() {
    if (_stateStack.isNotEmpty) {
      final inObject = _stateStack.last == _ContainerType.object;
      if (inObject) {
        if (_objectStateStack.last != _ObjectState.key) {
          throw StateError('Expected property name before value in object');
        }
        _objectStateStack.last = _ObjectState.value;
      } else {
        if (!_isArrayFirstStack.last) {
          _ensureCapacity(1);
          _buffer[_cursor++] = 44; // ','
        }
        _isArrayFirstStack.last = false;
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
    if (_stateStack.length >= _maxDepth) {
      throw StateError('Nesting depth exceeds limit of $_maxDepth');
    }
    _beforeValue();
    _ensureCapacity(1);
    _buffer[_cursor++] = 123; // '{'
    _stateStack.add(_ContainerType.object);
    _objectStateStack.add(_ObjectState.empty);
  }

  @override
  void endObject() {
    if (_stateStack.isEmpty || _stateStack.last != _ContainerType.object) {
      throw StateError('Cannot endObject: not inside an object');
    }
    if (_objectStateStack.last == _ObjectState.key) {
      throw StateError('Cannot endObject: expected value after property name');
    }
    _ensureCapacity(1);
    _buffer[_cursor++] = 125; // '}'
    _stateStack.removeLast();
    _objectStateStack.removeLast();
    if (_stateStack.isEmpty) {
      _flushBuffer();
    }
  }

  @override
  void beginArray() {
    if (_stateStack.length >= _maxDepth) {
      throw StateError('Nesting depth exceeds limit of $_maxDepth');
    }
    _beforeValue();
    _ensureCapacity(1);
    _buffer[_cursor++] = 91; // '['
    _stateStack.add(_ContainerType.array);
    _isArrayFirstStack.add(true);
  }

  @override
  void endArray() {
    if (_stateStack.isEmpty || _stateStack.last != _ContainerType.array) {
      throw StateError('Cannot endArray: not inside an array');
    }
    _ensureCapacity(1);
    _buffer[_cursor++] = 93; // ']'
    _stateStack.removeLast();
    _isArrayFirstStack.removeLast();
    if (_stateStack.isEmpty) {
      _flushBuffer();
    }
  }

  @override
  void writeName(String name) {
    if (_stateStack.isEmpty || _stateStack.last != _ContainerType.object) {
      throw StateError('Cannot writeName: not inside an object');
    }
    final objState = _objectStateStack.last;
    if (objState == _ObjectState.key) {
      throw StateError(
        'Cannot writeName: already expecting a value for previous property',
      );
    }
    if (objState == _ObjectState.value) {
      _ensureCapacity(1);
      _buffer[_cursor++] = 44; // ','
    }
    _objectStateStack.last = _ObjectState.key;
    final len = name.length;
    _ensureCapacity(len * 6 + 4);
    _cursor += _writeStringToBuffer(name, _buffer, _cursor);
    _buffer[_cursor++] = 58; // ':'
  }

  @override
  void writeNameBytes(Uint8List asciiKey) {
    if (_stateStack.isEmpty || _stateStack.last != _ContainerType.object) {
      throw StateError('Cannot writeNameBytes: not inside an object');
    }
    final objState = _objectStateStack.last;
    if (objState == _ObjectState.key) {
      throw StateError(
        'Cannot writeNameBytes: already expecting a value for previous '
        'property',
      );
    }
    if (objState == _ObjectState.value) {
      _ensureCapacity(1);
      _buffer[_cursor++] = 44; // ','
    }
    _objectStateStack.last = _ObjectState.key;
    final isQuoted =
        asciiKey.length >= 2 && asciiKey.first == 34 && asciiKey.last == 34;
    if (isQuoted) {
      _ensureCapacity(asciiKey.length + 1);
      _buffer.setRange(_cursor, _cursor + asciiKey.length, asciiKey);
      _cursor += asciiKey.length;
    } else {
      _ensureCapacity(asciiKey.length + 3);
      _buffer[_cursor++] = 34; // '"'
      _buffer.setRange(_cursor, _cursor + asciiKey.length, asciiKey);
      _cursor += asciiKey.length;
      _buffer[_cursor++] = 34; // '"'
    }
    _buffer[_cursor++] = 58; // ':'
  }

  @override
  void writeAsciiLiteral(Uint8List preEncoded) {
    _beforeValue();
    _ensureCapacity(preEncoded.length);
    _buffer.setRange(_cursor, _cursor + preEncoded.length, preEncoded);
    _cursor += preEncoded.length;
  }

  @override
  void writeRawJson(Uint8List rawJson) {
    _beforeValue();
    _ensureCapacity(rawJson.length);
    _buffer.setRange(_cursor, _cursor + rawJson.length, rawJson);
    _cursor += rawJson.length;
  }

  @override
  void writeString(String value) {
    _beforeValue();
    final len = value.length;
    _ensureCapacity(len * 6 + 2);
    _cursor += _writeStringToBuffer(value, _buffer, _cursor);
  }

  @override
  void writeInt(int value) {
    _beforeValue();
    _ensureCapacity(32);
    _cursor += _writeIntToBuffer(value, _buffer, _cursor);
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
    _cursor += _writeDoubleToBuffer(value, _buffer, _cursor);
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
  }

  @override
  void writeNull() {
    _beforeValue();
    _ensureCapacity(4);
    _buffer[_cursor++] = 110; // 'n'
    _buffer[_cursor++] = 117; // 'u'
    _buffer[_cursor++] = 108; // 'l'
    _buffer[_cursor++] = 108; // 'l'
  }

  @override
  void flush() {
    _flushBuffer();
  }
}
