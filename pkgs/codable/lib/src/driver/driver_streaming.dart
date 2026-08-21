// ignore_for_file: avoid_dynamic_calls

import 'dart:convert';
import 'dart:typed_data';

import '../contracts/codable.dart';
import '../contracts/decoder.dart';
import '../contracts/exceptions.dart';
import '../contracts/static_key.dart';
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

final class _JsonCodableMappedDecoder implements MappedDecoder {
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
  bool containsStaticKey(StaticKey key) => containsKey(key.name);

  @override
  bool isNull(String key) => _map[key] == null;

  @override
  bool isNullKey(StaticKey key) => isNull(key.name);

  @override
  int readInt(String key) {
    final v = _map[key];
    if (v is num) return v.toInt();
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
  T decodeKey<T>(String key, DecoderCallback<T> decoder) {
    final v = _map[key];
    if (v == null) {
      throw CodableException('Missing required key $key in mapped decoder');
    }
    return decoder(JsonCodableDecoder.fromString(jsonEncode(v)));
  }

  @override
  T decodeStaticKey<T>(StaticKey key, DecoderCallback<T> decoder) =>
      decodeKey(key.name, decoder);

  @override
  T? decodeNullableKey<T>(String key, DecoderCallback<T> decoder) {
    final v = _map[key];
    if (v == null) return null;
    return decoder(JsonCodableDecoder.fromString(jsonEncode(v)));
  }

  @override
  T? decodeNullableStaticKey<T>(StaticKey key, DecoderCallback<T> decoder) =>
      decodeNullableKey(key.name, decoder);

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
  Float64List decodeFloat64List(String key) => Float64List.fromList(
    (_map[key] as List).map((e) => (e as num).toDouble()).toList(),
  );

  @override
  Float64List decodeFloat64ListKey(StaticKey key) =>
      decodeFloat64List(key.name);

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
