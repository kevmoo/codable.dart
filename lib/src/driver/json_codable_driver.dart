import 'dart:typed_data';

import '../contracts/codable.dart';
import '../contracts/decoder.dart';
import '../contracts/encoder.dart';
import '../contracts/exceptions.dart';
import '../contracts/static_key.dart';
import 'dart:convert';

/// Concrete high-performance driver connecting `package:codable` contracts
/// directly to `JsonTokenReader` and `JsonTokenWriter`.
final class JsonCodableDecoder implements Decoder {
  final JsonTokenReader _reader;
  @override
  final Map<Object, Object?> userInfo;

  JsonCodableDecoder.fromReader(this._reader, {this.userInfo = const {}});

  factory JsonCodableDecoder.fromBytes(
    Uint8List bytes, {
    Map<Object, Object?> userInfo = const {},
  }) {
    return JsonCodableDecoder.fromReader(
      JsonTokenReader.fromBytes(bytes),
      userInfo: userInfo,
    );
  }

  @override
  KeyedDecoder keyed({KeyOptions? options}) =>
      _JsonCodableKeyedDecoder(_reader, this, options: options);

  @override
  MappedDecoder mapped() => _JsonCodableMappedDecoder(this);

  @override
  UnkeyedDecoder unkeyed() => _JsonCodableUnkeyedDecoder(_reader, this);

  @override
  SingleValueDecoder singleValue() =>
      _JsonCodableSingleValueDecoder(_reader, this);

  @override
  KeyedDecoder container({KeyOptions? options}) => keyed(options: options);

  @override
  UnkeyedDecoder unkeyedContainer() => unkeyed();

  @override
  SingleValueDecoder singleValueContainer() => singleValue();
}

final class _JsonCodableKeyedDecoder implements KeyedDecoder {
  final JsonTokenReader _reader;
  final JsonCodableDecoder _rootDecoder;
  bool _started = false;

  _JsonCodableKeyedDecoder(
    this._reader,
    this._rootDecoder, {
    KeyOptions? options,
  });

  void _ensureStarted() {
    if (!_started) {
      _reader.beginObject();
      _started = true;
    }
  }

  @override
  bool hasNextKey() {
    _ensureStarted();
    final has = _reader.hasNext();
    if (!has) {
      _reader.endObject();
    }
    return has;
  }

  @override
  bool hasNext() => hasNextKey();

  @override
  String nextKey() {
    _ensureStarted();
    return _reader.nextName();
  }

  @override
  String? peekKey() {
    _ensureStarted();
    return null;
  }

  @override
  int selectKeyIndex(KeyOptions options) {
    _ensureStarted();
    return _reader.selectName(JsonKeyOptions.of(options.keys));
  }

  @override
  int selectKey(List<String> keys) {
    _ensureStarted();
    return _reader.selectName(JsonKeyOptions.of(keys));
  }

  @override
  int selectStringIndex(KeyOptions options) {
    _ensureStarted();
    return _reader.selectString(JsonKeyOptions.of(options.keys));
  }

  @override
  void skipField() => skipValue();

  @override
  void skipValue() {
    _ensureStarted();
    _reader.skipValue();
  }

  @override
  bool isNextNull() {
    _ensureStarted();
    return _reader.peek() == JsonTokenType.nullValue;
  }

  @override
  void readNull() {
    _ensureStarted();
    _reader.readNull();
  }

  @override
  int readInt() {
    _ensureStarted();
    return _reader.readInt();
  }

  @override
  int? readNullableInt() {
    _ensureStarted();
    if (isNextNull()) {
      readNull();
      return null;
    }
    return readInt();
  }

  @override
  double readDouble() {
    _ensureStarted();
    return _reader.readDouble();
  }

  @override
  double? readNullableDouble() {
    _ensureStarted();
    if (isNextNull()) {
      readNull();
      return null;
    }
    return readDouble();
  }

  @override
  String readString() {
    _ensureStarted();
    return _reader.readString();
  }

  @override
  String? readNullableString() {
    _ensureStarted();
    if (isNextNull()) {
      readNull();
      return null;
    }
    return readString();
  }

  @override
  bool readBool() {
    _ensureStarted();
    return _reader.readBool();
  }

  @override
  bool? readNullableBool() {
    _ensureStarted();
    if (isNextNull()) {
      readNull();
      return null;
    }
    return readBool();
  }

  @override
  T decodeValue<T>(DecoderCallback<T> decoder) => decoder(_rootDecoder);

  @override
  T? decodeNullableValue<T>(DecoderCallback<T> decoder) {
    if (isNextNull()) {
      readNull();
      return null;
    }
    return decodeValue(decoder);
  }

  @override
  List<T> decodeList<T>(DecoderCallback<T> decoder) {
    _ensureStarted();
    final list = <T>[];
    _reader.beginArray();
    while (_reader.hasNext()) {
      list.add(decoder(_rootDecoder));
    }
    _reader.endArray();
    return list;
  }

  @override
  List<T>? decodeNullableList<T>(DecoderCallback<T> decoder) {
    if (isNextNull()) {
      readNull();
      return null;
    }
    return decodeList(decoder);
  }

  @override
  List<int> decodeIntList() {
    _ensureStarted();
    final list = <int>[];
    _reader.beginArray();
    while (_reader.hasNext()) {
      list.add(_reader.readInt());
    }
    _reader.endArray();
    return list;
  }

  @override
  List<double> decodeDoubleList() {
    _ensureStarted();
    final list = <double>[];
    _reader.beginArray();
    while (_reader.hasNext()) {
      list.add(_reader.readDouble());
    }
    _reader.endArray();
    return list;
  }

  @override
  List<String> decodeStringList() {
    _ensureStarted();
    final list = <String>[];
    _reader.beginArray();
    while (_reader.hasNext()) {
      list.add(_reader.readString());
    }
    _reader.endArray();
    return list;
  }

  @override
  List<bool> decodeBoolList() {
    _ensureStarted();
    final list = <bool>[];
    _reader.beginArray();
    while (_reader.hasNext()) {
      list.add(_reader.readBool());
    }
    _reader.endArray();
    return list;
  }
}

final class _JsonCodableMappedDecoder implements MappedDecoder {
  final JsonCodableDecoder _rootDecoder;
  final Map<String, Object?> _map = {};

  _JsonCodableMappedDecoder(this._rootDecoder);

  @override
  bool containsKey(String key) => _map.containsKey(key);

  @override
  bool containsStaticKey(StaticKey key) => containsKey(key.name);

  @override
  bool isNull(String key) => _map[key] == null;

  @override
  bool isNullKey(StaticKey key) => isNull(key.name);

  @override
  int readInt(String key) {
    final v = _map[key];
    if (v is int) return v;
    throw CodableException('Expected int for $key, found $v');
  }

  @override
  int readIntKey(StaticKey key) => readInt(key.name);

  @override
  int? readNullableInt(String key) => _map[key] == null ? null : readInt(key);

  @override
  int? readNullableIntKey(StaticKey key) => readNullableInt(key.name);

  @override
  double readDouble(String key) {
    final v = _map[key];
    if (v is num) return v.toDouble();
    throw CodableException('Expected double for $key, found $v');
  }

  @override
  double readDoubleKey(StaticKey key) => readDouble(key.name);

  @override
  double? readNullableDouble(String key) =>
      _map[key] == null ? null : readDouble(key);

  @override
  double? readNullableDoubleKey(StaticKey key) => readNullableDouble(key.name);

  @override
  String readString(String key) {
    final v = _map[key];
    if (v is String) return v;
    throw CodableException('Expected String for $key, found $v');
  }

  @override
  String readStringKey(StaticKey key) => readString(key.name);

  @override
  String? readNullableString(String key) =>
      _map[key] == null ? null : readString(key);

  @override
  String? readNullableStringKey(StaticKey key) => readNullableString(key.name);

  @override
  bool readBool(String key) {
    final v = _map[key];
    if (v is bool) return v;
    throw CodableException('Expected bool for $key, found $v');
  }

  @override
  bool readBoolKey(StaticKey key) => readBool(key.name);

  @override
  bool? readNullableBool(String key) =>
      _map[key] == null ? null : readBool(key);

  @override
  bool? readNullableBoolKey(StaticKey key) => readNullableBool(key.name);

  @override
  T decodeKey<T>(String key, DecoderCallback<T> decoder) =>
      decoder(_rootDecoder);

  @override
  T decodeStaticKey<T>(StaticKey key, DecoderCallback<T> decoder) =>
      decodeKey(key.name, decoder);

  @override
  T? decodeNullableKey<T>(String key, DecoderCallback<T> decoder) =>
      isNull(key) ? null : decodeKey(key, decoder);

  @override
  T? decodeNullableStaticKey<T>(StaticKey key, DecoderCallback<T> decoder) =>
      decodeNullableKey(key.name, decoder);

  @override
  List<T> decodeListKey<T>(String key, DecoderCallback<T> decoder) {
    final v = _map[key];
    if (v is List) {
      return v.map((e) => decoder(_rootDecoder)).toList();
    }
    throw CodableException('Expected list for $key');
  }

  @override
  List<T> decodeListStaticKey<T>(StaticKey key, DecoderCallback<T> decoder) =>
      decodeListKey(key.name, decoder);

  @override
  List<int> decodeIntList(String key) => (_map[key] as List).cast<int>();

  @override
  List<int> decodeIntListKey(StaticKey key) => decodeIntList(key.name);

  @override
  List<double> decodeDoubleList(String key) =>
      (_map[key] as List).map((e) => (e as num).toDouble()).toList();

  @override
  List<double> decodeDoubleListKey(StaticKey key) => decodeDoubleList(key.name);

  @override
  List<String> decodeStringList(String key) =>
      (_map[key] as List).cast<String>();

  @override
  List<String> decodeStringListKey(StaticKey key) => decodeStringList(key.name);

  @override
  List<bool> decodeBoolList(String key) => (_map[key] as List).cast<bool>();

  @override
  List<bool> decodeBoolListKey(StaticKey key) => decodeBoolList(key.name);
}

final class _JsonCodableUnkeyedDecoder implements UnkeyedDecoder {
  final JsonTokenReader _reader;
  final JsonCodableDecoder _rootDecoder;
  bool _started = false;

  _JsonCodableUnkeyedDecoder(this._reader, this._rootDecoder);

  void _ensureStarted() {
    if (!_started) {
      _reader.beginArray();
      _started = true;
    }
  }

  @override
  bool hasNext() {
    _ensureStarted();
    final has = _reader.hasNext();
    if (!has) {
      _reader.endArray();
    }
    return has;
  }

  @override
  bool isNextNull() {
    _ensureStarted();
    return _reader.peek() == JsonTokenType.nullValue;
  }

  @override
  void readNull() {
    _ensureStarted();
    _reader.readNull();
  }

  @override
  void skipElement() {
    _ensureStarted();
    _reader.skipValue();
  }

  @override
  int readInt() {
    _ensureStarted();
    return _reader.readInt();
  }

  @override
  int? readNullableInt() {
    _ensureStarted();
    if (isNextNull()) {
      readNull();
      return null;
    }
    return readInt();
  }

  @override
  double readDouble() {
    _ensureStarted();
    return _reader.readDouble();
  }

  @override
  double? readNullableDouble() {
    _ensureStarted();
    if (isNextNull()) {
      readNull();
      return null;
    }
    return readDouble();
  }

  @override
  String readString() {
    _ensureStarted();
    return _reader.readString();
  }

  @override
  String? readNullableString() {
    _ensureStarted();
    if (isNextNull()) {
      readNull();
      return null;
    }
    return readString();
  }

  @override
  bool readBool() {
    _ensureStarted();
    return _reader.readBool();
  }

  @override
  bool? readNullableBool() {
    _ensureStarted();
    if (isNextNull()) {
      readNull();
      return null;
    }
    return readBool();
  }

  @override
  T decodeElement<T>(DecoderCallback<T> decoder) => decoder(_rootDecoder);

  @override
  T? decodeNullableElement<T>(DecoderCallback<T> decoder) {
    if (isNextNull()) {
      readNull();
      return null;
    }
    return decodeElement(decoder);
  }
}

final class _JsonCodableSingleValueDecoder implements SingleValueDecoder {
  final JsonTokenReader _reader;
  final JsonCodableDecoder _rootDecoder;

  _JsonCodableSingleValueDecoder(this._reader, this._rootDecoder);

  @override
  bool isNull() => _reader.peek() == JsonTokenType.nullValue;

  @override
  void readNull() => _reader.readNull();

  @override
  int readInt() => _reader.readInt();

  @override
  int? readNullableInt() => isNull() ? null : readInt();

  @override
  double readDouble() => _reader.readDouble();

  @override
  double? readNullableDouble() => isNull() ? null : readDouble();

  @override
  String readString() => _reader.readString();

  @override
  String? readNullableString() => isNull() ? null : readString();

  @override
  bool readBool() => _reader.readBool();

  @override
  bool? readNullableBool() => isNull() ? null : readBool();

  @override
  T decode<T>(DecoderCallback<T> decoder) => decoder(_rootDecoder);

  @override
  T? decodeNullable<T>(DecoderCallback<T> decoder) =>
      isNull() ? null : decode(decoder);
}

final class JsonCodableEncoder implements Encoder {
  final JsonTokenWriter _writer;
  @override
  final Map<Object, Object?> userInfo;

  JsonCodableEncoder.fromWriter(this._writer, {this.userInfo = const {}});

  factory JsonCodableEncoder.toSink(
    BytesBuilder sink, {
    Map<Object, Object?> userInfo = const {},
  }) {
    return JsonCodableEncoder.fromWriter(
      JsonTokenWriter.toSink(sink),
      userInfo: userInfo,
    );
  }

  @override
  KeyedEncoder keyed({KeyOptions? options}) =>
      _JsonCodableKeyedEncoder(_writer, this);

  @override
  UnkeyedEncoder unkeyed() => _JsonCodableUnkeyedEncoder(_writer, this);

  @override
  SingleValueEncoder singleValue() =>
      _JsonCodableSingleValueEncoder(_writer, this);

  @override
  KeyedEncoder container({KeyOptions? options}) => keyed(options: options);

  @override
  UnkeyedEncoder unkeyedContainer() => unkeyed();

  @override
  SingleValueEncoder singleValueContainer() => singleValue();
}

final class _JsonCodableKeyedEncoder implements KeyedEncoder {
  final JsonTokenWriter _writer;
  final JsonCodableEncoder _rootEncoder;
  bool _started = false;

  _JsonCodableKeyedEncoder(this._writer, this._rootEncoder) {
    _writer.beginObject();
    _started = true;
  }

  void close() {
    if (_started) {
      _writer.endObject();
      _started = false;
    }
  }

  @override
  void encodeInt(String key, int value) {
    _writer.writeName(key);
    _writer.writeInt(value);
  }

  @override
  void encodeIntKey(StaticKey key, int value) {
    _writer.writeName(key.name);
    _writer.writeInt(value);
  }

  @override
  void encodeNullableInt(String key, int? value) {
    if (value == null) {
      encodeNull(key);
    } else {
      encodeInt(key, value);
    }
  }

  @override
  void encodeNullableIntKey(StaticKey key, int? value) {
    if (value == null) {
      encodeNullKey(key);
    } else {
      encodeIntKey(key, value);
    }
  }

  @override
  void encodeDouble(String key, double value) {
    _writer.writeName(key);
    _writer.writeDouble(value);
  }

  @override
  void encodeDoubleKey(StaticKey key, double value) {
    _writer.writeName(key.name);
    _writer.writeDouble(value);
  }

  @override
  void encodeNullableDouble(String key, double? value) {
    if (value == null) {
      encodeNull(key);
    } else {
      encodeDouble(key, value);
    }
  }

  @override
  void encodeNullableDoubleKey(StaticKey key, double? value) {
    if (value == null) {
      encodeNullKey(key);
    } else {
      encodeDoubleKey(key, value);
    }
  }

  @override
  void encodeString(String key, String value) {
    _writer.writeName(key);
    _writer.writeString(value);
  }

  @override
  void encodeStringKey(StaticKey key, String value) {
    _writer.writeName(key.name);
    _writer.writeString(value);
  }

  @override
  void encodeNullableString(String key, String? value) {
    if (value == null) {
      encodeNull(key);
    } else {
      encodeString(key, value);
    }
  }

  @override
  void encodeNullableStringKey(StaticKey key, String? value) {
    if (value == null) {
      encodeNullKey(key);
    } else {
      encodeStringKey(key, value);
    }
  }

  @override
  void encodeBool(String key, bool value) {
    _writer.writeName(key);
    _writer.writeBool(value);
  }

  @override
  void encodeBoolKey(StaticKey key, bool value) {
    _writer.writeName(key.name);
    _writer.writeBool(value);
  }

  @override
  void encodeNullableBool(String key, bool? value) {
    if (value == null) {
      encodeNull(key);
    } else {
      encodeBool(key, value);
    }
  }

  @override
  void encodeNullableBoolKey(StaticKey key, bool? value) {
    if (value == null) {
      encodeNullKey(key);
    } else {
      encodeBoolKey(key, value);
    }
  }

  @override
  void encodeNull(String key) {
    _writer.writeName(key);
    _writer.writeNull();
  }

  @override
  void encodeNullKey(StaticKey key) {
    _writer.writeName(key.name);
    _writer.writeNull();
  }

  @override
  void encodeValue<T>(String key, T value, EncoderCallback<T> encode) {
    _writer.writeName(key);
    encode(value, _rootEncoder);
  }

  @override
  void encodeValueKey<T>(StaticKey key, T value, EncoderCallback<T> encode) {
    _writer.writeName(key.name);
    encode(value, _rootEncoder);
  }

  @override
  void encodeNullableValue<T>(String key, T? value, EncoderCallback<T> encode) {
    if (value == null) {
      encodeNull(key);
    } else {
      encodeValue(key, value, encode);
    }
  }

  @override
  void encodeNullableValueKey<T>(
    StaticKey key,
    T? value,
    EncoderCallback<T> encode,
  ) {
    if (value == null) {
      encodeNullKey(key);
    } else {
      encodeValueKey(key, value, encode);
    }
  }

  @override
  void encodeEncodable(String key, Encodable value) {
    _writer.writeName(key);
    value.encode(_rootEncoder);
  }

  @override
  void encodeEncodableKey(StaticKey key, Encodable value) {
    _writer.writeName(key.name);
    value.encode(_rootEncoder);
  }

  @override
  void encodeNullableEncodable(String key, Encodable? value) {
    if (value == null) {
      encodeNull(key);
    } else {
      encodeEncodable(key, value);
    }
  }

  @override
  void encodeNullableEncodableKey(StaticKey key, Encodable? value) {
    if (value == null) {
      encodeNullKey(key);
    } else {
      encodeEncodableKey(key, value);
    }
  }

  @override
  void encodeList<T>(
    String key,
    Iterable<T> elements,
    EncoderCallback<T> encode,
  ) {
    _writer.writeName(key);
    _writer.beginArray();
    for (final e in elements) {
      encode(e, _rootEncoder);
    }
    _writer.endArray();
  }

  @override
  void encodeListKey<T>(
    StaticKey key,
    Iterable<T> elements,
    EncoderCallback<T> encode,
  ) {
    _writer.writeName(key.name);
    _writer.beginArray();
    for (final e in elements) {
      encode(e, _rootEncoder);
    }
    _writer.endArray();
  }

  @override
  void encodeIntList(String key, List<int> values) {
    _writer.writeName(key);
    _writer.beginArray();
    for (final v in values) {
      _writer.writeInt(v);
    }
    _writer.endArray();
  }

  @override
  void encodeIntListKey(StaticKey key, List<int> values) =>
      encodeIntList(key.name, values);

  @override
  void encodeDoubleList(String key, List<double> values) {
    _writer.writeName(key);
    _writer.beginArray();
    for (final v in values) {
      _writer.writeDouble(v);
    }
    _writer.endArray();
  }

  @override
  void encodeDoubleListKey(StaticKey key, List<double> values) =>
      encodeDoubleList(key.name, values);

  @override
  void encodeStringList(String key, List<String> values) {
    _writer.writeName(key);
    _writer.beginArray();
    for (final v in values) {
      _writer.writeString(v);
    }
    _writer.endArray();
  }

  @override
  void encodeStringListKey(StaticKey key, List<String> values) =>
      encodeStringList(key.name, values);

  @override
  void encodeBoolList(String key, List<bool> values) {
    _writer.writeName(key);
    _writer.beginArray();
    for (final v in values) {
      _writer.writeBool(v);
    }
    _writer.endArray();
  }

  @override
  void encodeBoolListKey(StaticKey key, List<bool> values) =>
      encodeBoolList(key.name, values);
}

final class _JsonCodableUnkeyedEncoder implements UnkeyedEncoder {
  final JsonTokenWriter _writer;
  final JsonCodableEncoder _rootEncoder;

  _JsonCodableUnkeyedEncoder(this._writer, this._rootEncoder);

  @override
  void encodeInt(int value) => _writer.writeInt(value);

  @override
  void encodeNullableInt(int? value) =>
      value == null ? encodeNull() : encodeInt(value);

  @override
  void encodeDouble(double value) => _writer.writeDouble(value);

  @override
  void encodeNullableDouble(double? value) =>
      value == null ? encodeNull() : encodeDouble(value);

  @override
  void encodeString(String value) => _writer.writeString(value);

  @override
  void encodeNullableString(String? value) =>
      value == null ? encodeNull() : encodeString(value);

  @override
  void encodeBool(bool value) => _writer.writeBool(value);

  @override
  void encodeNullableBool(bool? value) =>
      value == null ? encodeNull() : encodeBool(value);

  @override
  void encodeNull() => _writer.writeNull();

  @override
  void encodeElement<T>(T value, EncoderCallback<T> encode) =>
      encode(value, _rootEncoder);

  @override
  void encodeNullableElement<T>(T? value, EncoderCallback<T> encode) =>
      value == null ? encodeNull() : encodeElement(value, encode);

  @override
  void encodeEncodable(Encodable value) => value.encode(_rootEncoder);

  @override
  void encodeNullableEncodable(Encodable? value) =>
      value == null ? encodeNull() : encodeEncodable(value);

  @override
  void encodeList<T>(Iterable<T> elements, EncoderCallback<T> encode) {
    _writer.beginArray();
    for (final e in elements) {
      encode(e, _rootEncoder);
    }
    _writer.endArray();
  }
}

final class _JsonCodableSingleValueEncoder implements SingleValueEncoder {
  final JsonTokenWriter _writer;
  final JsonCodableEncoder _rootEncoder;

  _JsonCodableSingleValueEncoder(this._writer, this._rootEncoder);

  @override
  void encodeInt(int value) => _writer.writeInt(value);

  @override
  void encodeNullableInt(int? value) =>
      value == null ? encodeNull() : encodeInt(value);

  @override
  void encodeDouble(double value) => _writer.writeDouble(value);

  @override
  void encodeNullableDouble(double? value) =>
      value == null ? encodeNull() : encodeDouble(value);

  @override
  void encodeString(String value) => _writer.writeString(value);

  @override
  void encodeNullableString(String? value) =>
      value == null ? encodeNull() : encodeString(value);

  @override
  void encodeBool(bool value) => _writer.writeBool(value);

  @override
  void encodeNullableBool(bool? value) =>
      value == null ? encodeNull() : encodeBool(value);

  @override
  void encodeNull() => _writer.writeNull();

  @override
  void encode<T>(T value, EncoderCallback<T> encode) =>
      encode(value, _rootEncoder);

  @override
  void encodeNullable<T>(T? value, EncoderCallback<T> encode) =>
      value == null ? encodeNull() : encode(value, _rootEncoder);

  @override
  void encodeEncodable(Encodable value) => value.encode(_rootEncoder);

  @override
  void encodeNullableEncodable(Encodable? value) =>
      value == null ? encodeNull() : encodeEncodable(value);
}
