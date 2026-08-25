import 'dart:convert';
import 'dart:typed_data';

/// Push-based JSON token writer emitting to a [BytesBuilder].
abstract interface class JsonTokenWriter {
  /// Instantiates a token writer emitting to [sink].
  factory JsonTokenWriter.toSink(BytesBuilder sink) = _MockJsonTokenWriter;

  /// Instantiates a token writer emitting to a newly allocated internal buffer.
  factory JsonTokenWriter.toBuffer({int capacity = 1024}) {
    return _BufferJsonTokenWriter(capacity);
  }

  void beginObject();
  void endObject();
  void beginArray();
  void endArray();
  void writeName(String name);
  void writeNameBytes(Uint8List asciiKey);
  void writeAsciiLiteral(String asciiString);
  void writeRawJson(Uint8List rawJson);
  void writeString(String value);
  void writeInt(int value);
  void writeDouble(double value);
  void writeBool(bool value);
  void writeNull();

  /// Extracts the written byte buffer. Only supported in `toBuffer`
  /// configurations.
  Uint8List takeBytes();
}

final class _MockJsonTokenWriter implements JsonTokenWriter {
  static final Uint8List _nullBytes = Uint8List.fromList(
    [110, 117, 108, 108], // 'null'
  );
  static final Uint8List _trueBytes = Uint8List.fromList(
    [116, 114, 117, 101], // 'true'
  );
  static final Uint8List _falseBytes = Uint8List.fromList(
    [102, 97, 108, 115, 101], // 'false'
  );
  static final Uint8List _minInt64Bytes = Uint8List.fromList(
    '-9223372036854775808'.codeUnits,
  );
  static final Uint8List _zeroDotZeroBytes = Uint8List.fromList(
    [48, 46, 48], // '0.0'
  );
  static final Uint8List _negZeroDotZeroBytes = Uint8List.fromList(
    [45, 48, 46, 48], // '-0.0'
  );

  final BytesBuilder _sink;
  final List<bool> _isFirstStack = [];
  final Uint8List _scratch = Uint8List(24);
  bool _needsColon = false;

  _MockJsonTokenWriter(this._sink);

  void _beforeValue() {
    if (_needsColon) {
      _sink.addByte(58); // ':'
      _needsColon = false;
    } else if (_isFirstStack.isNotEmpty) {
      if (!_isFirstStack.last) {
        _sink.addByte(44); // ','
      }
      _isFirstStack[_isFirstStack.length - 1] = false;
    }
  }

  @override
  void beginObject() {
    _beforeValue();
    _sink.addByte(123); // '{'
    _isFirstStack.add(true);
  }

  @override
  void endObject() {
    _sink.addByte(125); // '}'
    if (_isFirstStack.isNotEmpty) _isFirstStack.removeLast();
  }

  @override
  void beginArray() {
    _beforeValue();
    _sink.addByte(91); // '['
    _isFirstStack.add(true);
  }

  @override
  void endArray() {
    _sink.addByte(93); // ']'
    if (_isFirstStack.isNotEmpty) _isFirstStack.removeLast();
  }

  @override
  void writeName(String name) {
    if (_isFirstStack.isNotEmpty) {
      if (!_isFirstStack.last) {
        _sink.addByte(44); // ','
      }
      _isFirstStack[_isFirstStack.length - 1] = false;
    }
    _writeEscapedString(name);
    _needsColon = true;
  }

  @override
  void writeNameBytes(Uint8List asciiKey) {
    if (_isFirstStack.isNotEmpty) {
      if (!_isFirstStack.last) {
        _sink.addByte(44); // ','
      }
      _isFirstStack[_isFirstStack.length - 1] = false;
    }
    if (asciiKey.isNotEmpty && asciiKey.first == 34 && asciiKey.last == 34) {
      _sink.add(asciiKey);
    } else {
      _sink.addByte(34); // '"'
      _sink.add(asciiKey);
      _sink.addByte(34); // '"'
    }
    _needsColon = true;
  }

  @override
  void writeAsciiLiteral(String asciiString) {
    _beforeValue();
    for (var i = 0; i < asciiString.length; i++) {
      _sink.addByte(asciiString.codeUnitAt(i));
    }
  }

  @override
  void writeRawJson(Uint8List rawJson) {
    _beforeValue();
    _sink.add(rawJson);
  }

  @override
  void writeString(String value) {
    _beforeValue();
    _writeEscapedString(value);
  }

  void _writeEscapedString(String value) {
    // Fast path: check if string is pure printable ASCII with no quotes
    // or escapes.
    var isSimpleAscii = true;
    for (var i = 0; i < value.length; i++) {
      final code = value.codeUnitAt(i);
      if (code < 32 || code > 126 || code == 34 || code == 92) {
        isSimpleAscii = false;
        break;
      }
    }
    if (isSimpleAscii) {
      _sink.addByte(34); // '"'
      for (var i = 0; i < value.length; i++) {
        _sink.addByte(value.codeUnitAt(i));
      }
      _sink.addByte(34); // '"'
    } else {
      _sink.add(utf8.encode(jsonEncode(value)));
    }
  }

  @override
  void writeInt(int value) {
    _beforeValue();
    if (value == 0) {
      _sink.addByte(48); // '0'
      return;
    }
    if (value == -9223372036854775808) {
      _sink.add(_minInt64Bytes);
      return;
    }
    var v = value;
    if (v < 0) {
      _sink.addByte(45); // '-'
      v = -v;
    }
    _writePositiveInt(v);
  }

  void _writePositiveInt(int v) {
    if (v < 10) {
      _sink.addByte(48 + v);
      return;
    }
    if (v < 100) {
      _sink.addByte(48 + (v ~/ 10));
      _sink.addByte(48 + (v % 10));
      return;
    }
    _writePositiveIntDigits(v);
  }

  void _writePositiveIntDigits(int v) {
    var val = v;
    var pos = 24;
    while (val >= 10) {
      final rem = val % 10;
      val ~/= 10;
      _scratch[--pos] = 48 + rem;
    }
    _scratch[--pos] = 48 + val;
    for (var i = pos; i < 24; i++) {
      _sink.addByte(_scratch[i]);
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
    if (value == 0.0) {
      if (value.isNegative) {
        _sink.add(_negZeroDotZeroBytes);
      } else {
        _sink.add(_zeroDotZeroBytes);
      }
      return;
    }
    final intVal = value.toInt();
    if (intVal.toDouble() == value &&
        intVal >= -9007199254740992 &&
        intVal <= 9007199254740992) {
      if (intVal < 0) {
        _sink.addByte(45); // '-'
        _writePositiveInt(-intVal);
      } else {
        _writePositiveInt(intVal);
      }
      _sink.addByte(46); // '.'
      _sink.addByte(48); // '0'
      return;
    }
    final s = value.toString();
    for (var i = 0; i < s.length; i++) {
      _sink.addByte(s.codeUnitAt(i));
    }
  }

  @override
  void writeBool(bool value) {
    _beforeValue();
    _sink.add(value ? _trueBytes : _falseBytes);
  }

  @override
  void writeNull() {
    _beforeValue();
    _sink.add(_nullBytes);
  }

  @override
  Uint8List takeBytes() {
    return _sink.takeBytes();
  }
}

final class _BufferJsonTokenWriter implements JsonTokenWriter {
  static final Uint8List _nullBytes = Uint8List.fromList([110, 117, 108, 108]);
  static final Uint8List _trueBytes = Uint8List.fromList([116, 114, 117, 101]);
  static final Uint8List _falseBytes = Uint8List.fromList([
    102,
    97,
    108,
    115,
    101,
  ]);
  static final Uint8List _minInt64Bytes = Uint8List.fromList(
    '-9223372036854775808'.codeUnits,
  );
  static final Uint8List _zeroDotZeroBytes = Uint8List.fromList([48, 46, 48]);
  static final Uint8List _negZeroDotZeroBytes = Uint8List.fromList([
    45,
    48,
    46,
    48,
  ]);

  Uint8List _buf;
  int _offset = 0;
  final List<bool> _isFirstStack = [];
  final Uint8List _scratch = Uint8List(24);
  bool _needsColon = false;

  _BufferJsonTokenWriter(int capacity) : _buf = Uint8List(capacity);

  void _ensureSpace(int required) {
    if (_offset + required > _buf.length) {
      var newLen = _buf.length;
      while (_offset + required > newLen) {
        newLen *= 2;
      }
      final newBuf = Uint8List(newLen);
      newBuf.setRange(0, _offset, _buf);
      _buf = newBuf;
    }
  }

  void _addByte(int byte) {
    _ensureSpace(1);
    _buf[_offset++] = byte;
  }

  void _add(Uint8List bytes) {
    final len = bytes.length;
    _ensureSpace(len);
    _buf.setRange(_offset, _offset + len, bytes);
    _offset += len;
  }

  void _beforeValue() {
    if (_needsColon) {
      _addByte(58); // ':'
      _needsColon = false;
    } else if (_isFirstStack.isNotEmpty) {
      if (!_isFirstStack.last) {
        _addByte(44); // ','
      }
      _isFirstStack[_isFirstStack.length - 1] = false;
    }
  }

  @override
  void beginObject() {
    _beforeValue();
    _addByte(123);
    _isFirstStack.add(true);
  }

  @override
  void endObject() {
    _addByte(125);
    if (_isFirstStack.isNotEmpty) _isFirstStack.removeLast();
  }

  @override
  void beginArray() {
    _beforeValue();
    _addByte(91);
    _isFirstStack.add(true);
  }

  @override
  void endArray() {
    _addByte(93);
    if (_isFirstStack.isNotEmpty) _isFirstStack.removeLast();
  }

  @override
  void writeName(String name) {
    if (_isFirstStack.isNotEmpty) {
      if (!_isFirstStack.last) _addByte(44);
      _isFirstStack[_isFirstStack.length - 1] = false;
    }
    _writeEscapedString(name);
    _needsColon = true;
  }

  @override
  void writeNameBytes(Uint8List asciiKey) {
    if (_isFirstStack.isNotEmpty) {
      if (!_isFirstStack.last) _addByte(44);
      _isFirstStack[_isFirstStack.length - 1] = false;
    }
    if (asciiKey.isNotEmpty && asciiKey.first == 34 && asciiKey.last == 34) {
      _add(asciiKey);
    } else {
      _addByte(34);
      _add(asciiKey);
      _addByte(34);
    }
    _needsColon = true;
  }

  @override
  void writeAsciiLiteral(String asciiString) {
    _beforeValue();
    final len = asciiString.length;
    _ensureSpace(len);
    for (var i = 0; i < len; i++) {
      _buf[_offset++] = asciiString.codeUnitAt(i);
    }
  }

  @override
  void writeRawJson(Uint8List rawJson) {
    _beforeValue();
    _add(rawJson);
  }

  @override
  void writeString(String value) {
    _beforeValue();
    _writeEscapedString(value);
  }

  void _writeEscapedString(String value) {
    var isSimpleAscii = true;
    for (var i = 0; i < value.length; i++) {
      final code = value.codeUnitAt(i);
      if (code < 32 || code > 126 || code == 34 || code == 92) {
        isSimpleAscii = false;
        break;
      }
    }
    if (isSimpleAscii) {
      final len = value.length;
      _ensureSpace(len + 2);
      _buf[_offset++] = 34;
      for (var i = 0; i < len; i++) {
        _buf[_offset++] = value.codeUnitAt(i);
      }
      _buf[_offset++] = 34;
    } else {
      _add(utf8.encode(jsonEncode(value)));
    }
  }

  @override
  void writeInt(int value) {
    _beforeValue();
    if (value == 0) {
      _addByte(48);
      return;
    }
    if (value == -9223372036854775808) {
      _add(_minInt64Bytes);
      return;
    }
    var v = value;
    if (v < 0) {
      _addByte(45);
      v = -v;
    }
    if (v < 10) {
      _addByte(48 + v);
      return;
    }
    if (v < 100) {
      _addByte(48 + (v ~/ 10));
      _addByte(48 + (v % 10));
      return;
    }
    var val = v;
    var pos = 24;
    while (val >= 10) {
      final rem = val % 10;
      val ~/= 10;
      _scratch[--pos] = 48 + rem;
    }
    _scratch[--pos] = 48 + val;
    final len = 24 - pos;
    _ensureSpace(len);
    for (var i = pos; i < 24; i++) {
      _buf[_offset++] = _scratch[i];
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
    if (value == 0.0) {
      if (value.isNegative) {
        _add(_negZeroDotZeroBytes);
      } else {
        _add(_zeroDotZeroBytes);
      }
      return;
    }
    final intVal = value.toInt();
    if (intVal.toDouble() == value &&
        intVal >= -9007199254740992 &&
        intVal <= 9007199254740992) {
      if (intVal < 0) {
        _addByte(45);
        _writePositiveInt(-intVal);
      } else {
        _writePositiveInt(intVal);
      }
      _addByte(46);
      _addByte(48);
      return;
    }
    final s = value.toString();
    final len = s.length;
    _ensureSpace(len);
    for (var i = 0; i < len; i++) {
      _buf[_offset++] = s.codeUnitAt(i);
    }
  }

  void _writePositiveInt(int v) {
    if (v < 10) {
      _addByte(48 + v);
      return;
    }
    if (v < 100) {
      _addByte(48 + (v ~/ 10));
      _addByte(48 + (v % 10));
      return;
    }
    var val = v;
    var pos = 24;
    while (val >= 10) {
      final rem = val % 10;
      val ~/= 10;
      _scratch[--pos] = 48 + rem;
    }
    _scratch[--pos] = 48 + val;
    final len = 24 - pos;
    _ensureSpace(len);
    for (var i = pos; i < 24; i++) {
      _buf[_offset++] = _scratch[i];
    }
  }

  @override
  void writeBool(bool value) {
    _beforeValue();
    _add(value ? _trueBytes : _falseBytes);
  }

  @override
  void writeNull() {
    _beforeValue();
    _add(_nullBytes);
  }

  @override
  Uint8List takeBytes() {
    return Uint8List.sublistView(_buf, 0, _offset);
  }
}
