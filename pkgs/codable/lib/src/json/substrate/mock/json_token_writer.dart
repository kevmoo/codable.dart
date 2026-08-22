import 'dart:convert';
import 'dart:typed_data';

/// Push-based JSON token writer emitting to a [BytesBuilder].
abstract interface class JsonTokenWriter {
  /// Instantiates a token writer emitting to [sink].
  factory JsonTokenWriter.toSink(BytesBuilder sink) = _MockJsonTokenWriter;

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
}

final class _MockJsonTokenWriter implements JsonTokenWriter {
  final BytesBuilder _sink;
  final List<bool> _isFirstStack = [];
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
    _sink.add(utf8.encode(jsonEncode(name)));
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
  void writeAsciiLiteral(Uint8List preEncoded) {
    _beforeValue();
    _sink.add(preEncoded);
  }

  @override
  void writeRawJson(Uint8List rawJson) {
    _beforeValue();
    _sink.add(rawJson);
  }

  @override
  void writeString(String value) {
    _beforeValue();
    _sink.add(utf8.encode(jsonEncode(value)));
  }

  @override
  void writeInt(int value) {
    _beforeValue();
    _sink.add(utf8.encode(value.toString()));
  }

  @override
  void writeDouble(double value) {
    _beforeValue();
    _sink.add(utf8.encode(value.toString()));
  }

  @override
  void writeBool(bool value) {
    _beforeValue();
    _sink.add(utf8.encode(value ? 'true' : 'false'));
  }

  @override
  void writeNull() {
    _beforeValue();
    _sink.add(utf8.encode('null'));
  }
}
