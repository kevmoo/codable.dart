// ignore_for_file: avoid_dynamic_calls

import 'dart:convert';
import 'dart:typed_data';

import '../../contracts/codable.dart';
import '../../contracts/decoder.dart';
import '../../contracts/encoder.dart';
import '../../contracts/exceptions.dart';
import '../../contracts/static_key.dart';
import '../substrate/substrate.dart';

/// Concrete high-performance driver connecting `package:codable` contracts
/// directly to `JsonTokenReader` and `JsonTokenWriter`.
final class JsonCodableDecoder implements Decoder {
  final JsonTokenReader _reader;
  final Uint8List? _bytes;
  @override
  final Map<Object, Object?> userInfo;

  /// Exposes the underlying pull-based token reader for direct, devirtualized
  /// decoding.
  JsonTokenReader get reader => _reader;

  @override
  Uint8List? get payload {
    if (_bytes != null) return _bytes;
    final dynamic r = _reader;
    try {
      return r.bytes as Uint8List?;
    } catch (_) {
      return null;
    }
  }

  JsonCodableDecoder.fromReader(this._reader, {this.userInfo = const {}})
    : _bytes = null;

  factory JsonCodableDecoder.fromBytes(
    Uint8List bytes, {
    Map<Object, Object?> userInfo = const {},
  }) {
    return JsonCodableDecoder._(
      JsonTokenReader.fromBytes(bytes),
      bytes,
      userInfo: userInfo,
    );
  }

  factory JsonCodableDecoder.fromString(
    String source, {
    Map<Object, Object?> userInfo = const {},
  }) {
    final bytes = Uint8List.fromList(utf8.encode(source));
    return JsonCodableDecoder.fromBytes(bytes, userInfo: userInfo);
  }

  JsonCodableDecoder._(this._reader, this._bytes, {this.userInfo = const {}});

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

mixin _JsonPrimitiveDecoderMixin {
  JsonTokenReader get _reader;
  void _ensureStarted();

  bool isNextNull() {
    _ensureStarted();
    return _reader.peek() == JsonTokenType.nullValue;
  }

  void readNull() {
    _ensureStarted();
    _reader.readNull();
  }

  int readInt() {
    _ensureStarted();
    return _reader.readInt();
  }

  int? readNullableInt() {
    _ensureStarted();
    if (isNextNull()) {
      readNull();
      return null;
    }
    return readInt();
  }

  double readDouble() {
    _ensureStarted();
    return _reader.readDouble();
  }

  double? readNullableDouble() {
    _ensureStarted();
    if (isNextNull()) {
      readNull();
      return null;
    }
    return readDouble();
  }

  String readString() {
    _ensureStarted();
    return _reader.readString();
  }

  String? readNullableString() {
    _ensureStarted();
    if (isNextNull()) {
      readNull();
      return null;
    }
    return readString();
  }

  (int start, int end) readStringSpan() {
    _ensureStarted();
    final dynamic r = _reader;
    return r.readStringSpan() as (int, int);
  }

  (int start, int end)? readNullableStringSpan() {
    _ensureStarted();
    if (isNextNull()) {
      readNull();
      return null;
    }
    return readStringSpan();
  }

  bool readBool() {
    _ensureStarted();
    return _reader.readBool();
  }

  bool? readNullableBool() {
    _ensureStarted();
    if (isNextNull()) {
      readNull();
      return null;
    }
    return readBool();
  }
}

final class _JsonCodableKeyedDecoder
    with _JsonPrimitiveDecoderMixin
    implements KeyedDecoder {
  @override
  final JsonTokenReader _reader;
  final JsonCodableDecoder _rootDecoder;
  bool _started = false;
  bool _ended = false;

  _JsonCodableKeyedDecoder(
    this._reader,
    this._rootDecoder, {
    KeyOptions? options,
  });

  @override
  void _ensureStarted() {
    if (!_started) {
      _reader.beginObject();
      _started = true;
    }
  }

  @override
  bool hasNextKey() {
    if (_ended) return false;
    _ensureStarted();
    final has = _reader.hasNext();
    if (!has) {
      _reader.endObject();
      _ended = true;
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
    final compiled = options.compiled ??= JsonKeyOptions.of(options.keys);
    return _reader.selectName(compiled as JsonKeyOptions);
  }

  @override
  int selectKey(List<String> keys) {
    _ensureStarted();
    return _reader.selectName(JsonKeyOptions.of(keys));
  }

  @override
  int selectStringIndex(KeyOptions options) {
    _ensureStarted();
    final compiled = options.compiled ??= JsonKeyOptions.of(options.keys);
    return _reader.selectString(compiled as JsonKeyOptions);
  }

  @override
  void skipField() => skipValue();

  @override
  void skipValue() {
    _ensureStarted();
    _reader.skipValue();
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
  Float64List decodeFloat64List() {
    _ensureStarted();
    final list = <double>[];
    _reader.beginArray();
    while (_reader.hasNext()) {
      list.add(_reader.readDouble());
    }
    _reader.endArray();
    return Float64List.fromList(list);
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

final class _JsonCodableMappedDecoder
    with MappedDecoderBase
    implements MappedDecoder {
  final JsonCodableDecoder _rootDecoder;
  late final Map<String, Object?> _map;

  _JsonCodableMappedDecoder(this._rootDecoder) {
    _map = _readObject(_rootDecoder._reader);
  }

  static Map<String, Object?> _readObject(JsonTokenReader reader) {
    reader.beginObject();
    final map = <String, Object?>{};
    while (reader.hasNext()) {
      final key = reader.nextName();
      map[key] = _readValue(reader);
    }
    reader.endObject();
    return map;
  }

  static Object? _readValue(JsonTokenReader reader) {
    final type = reader.peek();
    switch (type) {
      case JsonTokenType.nullValue:
        reader.readNull();
        return null;
      case JsonTokenType.boolean:
        return reader.readBool();
      case JsonTokenType.number:
        return reader.readDouble();
      case JsonTokenType.string:
        return reader.readString();
      case JsonTokenType.beginObject:
        return _readObject(reader);
      case JsonTokenType.beginArray:
        reader.beginArray();
        final list = <Object?>[];
        while (reader.hasNext()) {
          list.add(_readValue(reader));
        }
        reader.endArray();
        return list;
      default:
        reader.skipValue();
        return null;
    }
  }

  @override
  bool containsKey(String key) => _map.containsKey(key);

  @override
  bool isNull(String key) => _map[key] == null;

  @override
  int readInt(String key) {
    final v = _map[key];
    if (v is num) return v.toInt();
    throw CodableException('Expected int for $key, found $v');
  }

  @override
  int? readNullableInt(String key) => _map[key] == null ? null : readInt(key);

  @override
  double readDouble(String key) {
    final v = _map[key];
    if (v is num) return v.toDouble();
    throw CodableException('Expected double for $key, found $v');
  }

  @override
  double? readNullableDouble(String key) =>
      _map[key] == null ? null : readDouble(key);

  @override
  String readString(String key) {
    final v = _map[key];
    if (v is String) return v;
    throw CodableException('Expected String for $key, found $v');
  }

  @override
  String? readNullableString(String key) =>
      _map[key] == null ? null : readString(key);

  @override
  bool readBool(String key) {
    final v = _map[key];
    if (v is bool) return v;
    throw CodableException('Expected bool for $key, found $v');
  }

  @override
  bool? readNullableBool(String key) =>
      _map[key] == null ? null : readBool(key);

  @override
  T decodeKey<T>(String key, DecoderCallback<T> decoder) {
    final v = _map[key];
    if (v == null) {
      throw CodableException('Missing required key $key in mapped decoder');
    }
    return decoder(JsonCodableDecoder.fromString(jsonEncode(v)));
  }

  @override
  T? decodeNullableKey<T>(String key, DecoderCallback<T> decoder) {
    final v = _map[key];
    if (v == null) return null;
    return decoder(JsonCodableDecoder.fromString(jsonEncode(v)));
  }

  @override
  List<T> decodeListKey<T>(String key, DecoderCallback<T> decoder) {
    final v = _map[key];
    if (v is List) {
      return v
          .map((e) => decoder(JsonCodableDecoder.fromString(jsonEncode(e))))
          .toList();
    }
    throw CodableException('Expected list for $key, found $v');
  }

  @override
  List<int> decodeIntList(String key) => (_map[key] as List).cast<int>();

  @override
  List<double> decodeDoubleList(String key) =>
      (_map[key] as List).map((e) => (e as num).toDouble()).toList();

  @override
  Float64List decodeFloat64List(String key) => Float64List.fromList(
    (_map[key] as List).map((e) => (e as num).toDouble()).toList(),
  );

  @override
  List<String> decodeStringList(String key) =>
      (_map[key] as List).cast<String>();

  @override
  List<bool> decodeBoolList(String key) => (_map[key] as List).cast<bool>();
}

final class _JsonCodableUnkeyedDecoder
    with _JsonPrimitiveDecoderMixin
    implements UnkeyedDecoder {
  @override
  final JsonTokenReader _reader;
  final JsonCodableDecoder _rootDecoder;
  bool _started = false;

  _JsonCodableUnkeyedDecoder(this._reader, this._rootDecoder);

  @override
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
  void skipElement() {
    _ensureStarted();
    _reader.skipValue();
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
  Float64List decodeFloat64List() {
    _ensureStarted();
    final list = <double>[];
    _reader.beginArray();
    while (_reader.hasNext()) {
      list.add(_reader.readDouble());
    }
    _reader.endArray();
    return Float64List.fromList(list);
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

final class _JsonCodableSingleValueDecoder
    with _JsonPrimitiveDecoderMixin
    implements SingleValueDecoder {
  @override
  final JsonTokenReader _reader;
  final JsonCodableDecoder _rootDecoder;

  _JsonCodableSingleValueDecoder(this._reader, this._rootDecoder);

  @override
  void _ensureStarted() {}

  @override
  bool isNull() => isNextNull();

  @override
  T decode<T>(DecoderCallback<T> decoder) => decoder(_rootDecoder);

  @override
  T? decodeNullable<T>(DecoderCallback<T> decoder) =>
      isNull() ? null : decode(decoder);
}

/// Concrete high-performance streaming JSON encoder connecting
/// `package:codable` contracts directly to `JsonTokenWriter`.
final class JsonCodableEncoder implements Encoder {
  final JsonTokenWriter _writer;

  @override
  final Map<Object, Object?> userInfo;

  _JsonCodableKeyedEncoder? _activeKeyed;
  _JsonCodableUnkeyedEncoder? _activeUnkeyed;

  JsonCodableEncoder(this._writer, {this.userInfo = const {}});

  /// Encodes a value to a newly allocated UTF-8 byte buffer.
  static Uint8List toBytes(
    void Function(Encoder encoder) encode, {
    Map<Object, Object?> userInfo = const {},
    int? capacityHint,
  }) {
    final sink = BytesBuilder(copy: false);
    final writer = JsonUtf8TokenWriter(sink);
    final encoder = JsonCodableEncoder(writer, userInfo: userInfo);
    encode(encoder);
    encoder._finish();
    writer.flush();
    return sink.takeBytes();
  }

  /// Encodes a value to a JSON String.
  static String encode(
    void Function(Encoder encoder) encode, {
    Map<Object, Object?> userInfo = const {},
  }) {
    final bytes = toBytes(encode, userInfo: userInfo);
    return utf8.decode(bytes);
  }

  void _finish() {
    _activeKeyed?._close();
    _activeKeyed = null;
    _activeUnkeyed?._close();
    _activeUnkeyed = null;
  }

  @override
  KeyedEncoder keyed({KeyOptions? options}) {
    _activeKeyed = _JsonCodableKeyedEncoder(this, _writer);
    return _activeKeyed!;
  }

  @override
  UnkeyedEncoder unkeyed() {
    _activeUnkeyed = _JsonCodableUnkeyedEncoder(this, _writer);
    return _activeUnkeyed!;
  }

  @override
  SingleValueEncoder singleValue() =>
      _JsonCodableSingleValueEncoder(this, _writer);

  @override
  KeyedEncoder container({KeyOptions? options}) => keyed(options: options);

  @override
  UnkeyedEncoder unkeyedContainer() => unkeyed();

  @override
  SingleValueEncoder singleValueContainer() => singleValue();
}

final class _JsonCodableKeyedEncoder implements KeyedEncoder {
  final JsonCodableEncoder _rootEncoder;
  final JsonTokenWriter _writer;
  bool _closed = false;

  void _writeFastKey(StaticKey key) {
    final metadata = key.wireMetadata;
    if (metadata is Uint8List) {
      _writer.writeNameBytes(metadata);
    } else {
      _writer.writeName(key.name);
    }
  }

  _JsonCodableKeyedEncoder(this._rootEncoder, this._writer) {
    _writer.beginObject();
  }

  void _close() {
    if (!_closed) {
      _writer.endObject();
      _closed = true;
    }
  }

  @override
  void encodeInt(String key, int value) {
    _writer.writeName(key);
    _writer.writeInt(value);
  }

  @override
  void encodeIntKey(StaticKey key, int value) {
    _writeFastKey(key);
    _writer.writeInt(value);
  }

  @override
  void encodeNullableInt(String key, int? value) {
    if (value != null) {
      encodeInt(key, value);
    }
  }

  @override
  void encodeNullableIntKey(StaticKey key, int? value) {
    if (value != null) {
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
    _writeFastKey(key);
    _writer.writeDouble(value);
  }

  @override
  void encodeNullableDouble(String key, double? value) {
    if (value != null) {
      encodeDouble(key, value);
    }
  }

  @override
  void encodeNullableDoubleKey(StaticKey key, double? value) {
    if (value != null) {
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
    _writeFastKey(key);
    _writer.writeString(value);
  }

  @override
  void encodeNullableString(String key, String? value) {
    if (value != null) {
      encodeString(key, value);
    }
  }

  @override
  void encodeNullableStringKey(StaticKey key, String? value) {
    if (value != null) {
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
    _writeFastKey(key);
    _writer.writeBool(value);
  }

  @override
  void encodeNullableBool(String key, bool? value) {
    if (value != null) {
      encodeBool(key, value);
    }
  }

  @override
  void encodeNullableBoolKey(StaticKey key, bool? value) {
    if (value != null) {
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
    _writeFastKey(key);
    _writer.writeNull();
  }

  @override
  void encodeValue<T>(String key, T value, EncoderCallback<T> encode) {
    _writer.writeName(key);
    final child = JsonCodableEncoder(_writer, userInfo: _rootEncoder.userInfo);
    encode(value, child);
    child._finish();
  }

  @override
  void encodeValueKey<T>(StaticKey key, T value, EncoderCallback<T> encode) =>
      encodeValue(key.name, value, encode);

  @override
  void encodeNullableValue<T>(String key, T? value, EncoderCallback<T> encode) {
    if (value != null) {
      encodeValue(key, value, encode);
    }
  }

  @override
  void encodeNullableValueKey<T>(
    StaticKey key,
    T? value,
    EncoderCallback<T> encode,
  ) => encodeNullableValue(key.name, value, encode);

  @override
  void encodeEncodable(String key, Encodable value) {
    _writer.writeName(key);
    final child = JsonCodableEncoder(_writer, userInfo: _rootEncoder.userInfo);
    value.encode(child);
    child._finish();
  }

  @override
  void encodeEncodableKey(StaticKey key, Encodable value) =>
      encodeEncodable(key.name, value);

  @override
  void encodeNullableEncodable(String key, Encodable? value) {
    if (value != null) {
      encodeEncodable(key, value);
    }
  }

  @override
  void encodeNullableEncodableKey(StaticKey key, Encodable? value) =>
      encodeNullableEncodable(key.name, value);

  @override
  void encodeList<T>(
    String key,
    Iterable<T> elements,
    EncoderCallback<T> encode,
  ) {
    _writer.writeName(key);
    _writer.beginArray();
    for (final e in elements) {
      final child = JsonCodableEncoder(
        _writer,
        userInfo: _rootEncoder.userInfo,
      );
      encode(e, child);
      child._finish();
    }
    _writer.endArray();
  }

  @override
  void encodeListKey<T>(
    StaticKey key,
    Iterable<T> elements,
    EncoderCallback<T> encode,
  ) => encodeList(key.name, elements, encode);

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
  void encodeIntListKey(StaticKey key, List<int> values) {
    _writeFastKey(key);
    _writer.beginArray();
    for (final value in values) {
      _writer.writeInt(value);
    }
    _writer.endArray();
  }

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
  void encodeDoubleListKey(StaticKey key, List<double> values) {
    _writeFastKey(key);
    _writer.beginArray();
    for (final value in values) {
      _writer.writeDouble(value);
    }
    _writer.endArray();
  }

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
  void encodeStringListKey(StaticKey key, List<String> values) {
    _writeFastKey(key);
    _writer.beginArray();
    for (final value in values) {
      _writer.writeString(value);
    }
    _writer.endArray();
  }

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
  void encodeBoolListKey(StaticKey key, List<bool> values) {
    _writeFastKey(key);
    _writer.beginArray();
    for (final value in values) {
      _writer.writeBool(value);
    }
    _writer.endArray();
  }
}

final class _JsonCodableUnkeyedEncoder implements UnkeyedEncoder {
  final JsonCodableEncoder _rootEncoder;
  final JsonTokenWriter _writer;
  bool _closed = false;

  _JsonCodableUnkeyedEncoder(this._rootEncoder, this._writer) {
    _writer.beginArray();
  }

  void _close() {
    if (!_closed) {
      _writer.endArray();
      _closed = true;
    }
  }

  @override
  void encodeInt(int value) => _writer.writeInt(value);

  @override
  void encodeNullableInt(int? value) {
    if (value == null) {
      _writer.writeNull();
    } else {
      _writer.writeInt(value);
    }
  }

  @override
  void encodeDouble(double value) => _writer.writeDouble(value);

  @override
  void encodeNullableDouble(double? value) {
    if (value == null) {
      _writer.writeNull();
    } else {
      _writer.writeDouble(value);
    }
  }

  @override
  void encodeString(String value) => _writer.writeString(value);

  @override
  void encodeNullableString(String? value) {
    if (value == null) {
      _writer.writeNull();
    } else {
      _writer.writeString(value);
    }
  }

  @override
  void encodeBool(bool value) => _writer.writeBool(value);

  @override
  void encodeNullableBool(bool? value) {
    if (value == null) {
      _writer.writeNull();
    } else {
      _writer.writeBool(value);
    }
  }

  @override
  void encodeNull() => _writer.writeNull();

  @override
  void encodeElement<T>(T value, EncoderCallback<T> encode) {
    final child = JsonCodableEncoder(_writer, userInfo: _rootEncoder.userInfo);
    encode(value, child);
    child._finish();
  }

  @override
  void encodeNullableElement<T>(T? value, EncoderCallback<T> encode) {
    if (value == null) {
      _writer.writeNull();
    } else {
      encodeElement(value, encode);
    }
  }

  @override
  void encodeList<T>(Iterable<T> elements, EncoderCallback<T> encode) {
    for (final e in elements) {
      encodeElement(e, encode);
    }
  }

  @override
  void encodeEncodable(Encodable value) {
    final child = JsonCodableEncoder(_writer, userInfo: _rootEncoder.userInfo);
    value.encode(child);
    child._finish();
  }

  @override
  void encodeNullableEncodable(Encodable? value) {
    if (value == null) {
      _writer.writeNull();
    } else {
      encodeEncodable(value);
    }
  }
}

final class _JsonCodableSingleValueEncoder implements SingleValueEncoder {
  final JsonCodableEncoder _rootEncoder;
  final JsonTokenWriter _writer;

  _JsonCodableSingleValueEncoder(this._rootEncoder, this._writer);

  @override
  void encodeInt(int value) => _writer.writeInt(value);

  @override
  void encodeNullableInt(int? value) {
    if (value == null) {
      _writer.writeNull();
    } else {
      _writer.writeInt(value);
    }
  }

  @override
  void encodeDouble(double value) => _writer.writeDouble(value);

  @override
  void encodeNullableDouble(double? value) {
    if (value == null) {
      _writer.writeNull();
    } else {
      _writer.writeDouble(value);
    }
  }

  @override
  void encodeString(String value) => _writer.writeString(value);

  @override
  void encodeNullableString(String? value) {
    if (value == null) {
      _writer.writeNull();
    } else {
      _writer.writeString(value);
    }
  }

  @override
  void encodeBool(bool value) => _writer.writeBool(value);

  @override
  void encodeNullableBool(bool? value) {
    if (value == null) {
      _writer.writeNull();
    } else {
      _writer.writeBool(value);
    }
  }

  @override
  void encodeNull() => _writer.writeNull();

  @override
  void encode<T>(T value, EncoderCallback<T> encode) {
    final child = JsonCodableEncoder(_writer, userInfo: _rootEncoder.userInfo);
    encode(value, child);
    child._finish();
  }

  @override
  void encodeNullable<T>(T? value, EncoderCallback<T> encode) {
    if (value == null) {
      _writer.writeNull();
    } else {
      final child = JsonCodableEncoder(
        _writer,
        userInfo: _rootEncoder.userInfo,
      );
      encode(value, child);
      child._finish();
    }
  }

  @override
  void encodeEncodable(Encodable value) {
    final child = JsonCodableEncoder(_writer, userInfo: _rootEncoder.userInfo);
    value.encode(child);
    child._finish();
  }

  @override
  void encodeNullableEncodable(Encodable? value) {
    if (value == null) {
      _writer.writeNull();
    } else {
      encodeEncodable(value);
    }
  }
}
