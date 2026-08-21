// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:typed_data';

import '../contracts/codable.dart';
import '../contracts/decoder.dart';
import '../contracts/exceptions.dart';
import '../contracts/static_key.dart';
import '../substrate/substrate.dart';

final class JsonCodableDecoder implements Decoder {
  final Object? _decoded;
  final Uint8List? _bytes;
  @override
  final Map<Object, Object?> userInfo;

  Object? _activeValue;

  JsonCodableDecoder._(this._decoded, this._bytes, {this.userInfo = const {}});

  factory JsonCodableDecoder.fromBytes(
    Uint8List bytes, {
    Map<Object, Object?> userInfo = const {},
  }) {
    final decoded = jsonDecode(utf8.decode(bytes));
    return JsonCodableDecoder._(decoded, bytes, userInfo: userInfo);
  }

  JsonCodableDecoder.fromReader(
    JsonTokenReader reader, {
    this.userInfo = const {},
  }) : _bytes = null,
       _decoded = _readAll(reader);

  static Object? _readAll(JsonTokenReader reader) {
    if (!reader.hasNext()) return null;
    switch (reader.peek()) {
      case JsonTokenType.beginObject:
        reader.beginObject();
        final map = <String, Object?>{};
        while (reader.hasNext()) {
          final key = reader.nextName();
          map[key] = _readAll(reader);
        }
        reader.endObject();
        return map;
      case JsonTokenType.beginArray:
        reader.beginArray();
        final list = <Object?>[];
        while (reader.hasNext()) {
          list.add(_readAll(reader));
        }
        reader.endArray();
        return list;
      case JsonTokenType.string:
        return reader.readString();
      case JsonTokenType.number:
        return reader.readDouble();
      case JsonTokenType.boolean:
        return reader.readBool();
      case JsonTokenType.nullValue:
        reader.readNull();
        return null;
      default:
        return null;
    }
  }

  JsonTokenReader get reader {
    final target = _activeValue ?? _decoded;
    final bytes = (target == _decoded && _bytes != null)
        ? _bytes
        : Uint8List.fromList(utf8.encode(jsonEncode(target)));
    _activeValue = null;
    return JsonTokenReader.fromBytes(bytes);
  }

  @override
  KeyedDecoder keyed({KeyOptions? options}) => _JsonCodableMappedKeyedDecoder(
    this,
    (_activeValue ?? _decoded) as Map<dynamic, dynamic>,
  );

  @override
  MappedDecoder mapped() => _JsonCodableMappedDecoder(
    this,
    (_activeValue ?? _decoded) as Map<dynamic, dynamic>,
  );

  @override
  UnkeyedDecoder unkeyed() => _JsonCodableUnkeyedDecoder(
    this,
    (_activeValue ?? _decoded) as List<dynamic>,
  );

  @override
  SingleValueDecoder singleValue() =>
      _JsonCodableSingleValueDecoder(this, _activeValue ?? _decoded);

  @override
  KeyedDecoder container({KeyOptions? options}) => keyed(options: options);

  @override
  Uint8List? get payload => _bytes;

  @override
  SingleValueDecoder singleValueContainer() => singleValue();

  @override
  UnkeyedDecoder unkeyedContainer() => unkeyed();
}

final class _JsonCodableMappedKeyedDecoder implements KeyedDecoder {
  final JsonCodableDecoder _rootDecoder;
  final Map<dynamic, dynamic> _map;
  final List<String> _keys;
  int _currentIndex = 0;
  Object? _activeValue;

  _JsonCodableMappedKeyedDecoder(this._rootDecoder, this._map)
    : _keys = _map.keys.cast<String>().toList();

  @override
  bool hasNextKey() => _currentIndex < _keys.length || _activeValue != null;

  @override
  bool isNextNull() {
    if (_activeValue != null) return _activeValue == null;
    if (!hasNextKey()) return false;
    final key = _keys[_currentIndex];
    return _map[key] == null;
  }

  @override
  void readNull() {
    if (_activeValue != null) {
      _activeValue = null;
    } else if (hasNextKey()) {
      _currentIndex++;
    }
  }

  @override
  (int start, int end) readStringSpan() =>
      throw UnsupportedError('String spans not supported on JS backend');

  @override
  (int start, int end)? readNullableStringSpan() =>
      throw UnsupportedError('String spans not supported on JS backend');

  @override
  bool hasNext() => hasNextKey();

  @override
  String nextKey() {
    if (!hasNextKey()) {
      throw const CodableException('No more keys in object');
    }
    final key = _keys[_currentIndex++];
    _activeValue = _map[key];
    _rootDecoder._activeValue = _activeValue;
    return key;
  }

  @override
  String? peekKey() => hasNextKey() ? _keys[_currentIndex] : null;

  @override
  int selectKeyIndex(KeyOptions options) {
    if (!hasNextKey()) return -1;
    final key = _keys[_currentIndex];
    return options.keys.indexOf(key);
  }

  @override
  int selectKey(List<String> keys) {
    if (!hasNextKey()) return -1;
    final key = _keys[_currentIndex];
    return keys.indexOf(key);
  }

  @override
  int selectStringIndex(KeyOptions options) => selectKeyIndex(options);

  @override
  void skipField() => skipValue();

  @override
  void skipValue() {
    if (_activeValue != null) {
      _activeValue = null;
    } else if (hasNextKey()) {
      _currentIndex++;
    }
  }

  Object? _consumeValue() {
    if (_activeValue != null) {
      final v = _activeValue;
      _activeValue = null;
      return v;
    }
    if (!hasNextKey()) {
      throw const CodableException('No more keys in object');
    }
    final key = _keys[_currentIndex++];
    return _map[key];
  }

  @override
  T decodeValue<T>(DecoderCallback<T> decoder) {
    final val = _consumeValue();
    return decoder(
      JsonCodableDecoder._(val, null, userInfo: _rootDecoder.userInfo),
    );
  }

  @override
  T? decodeNullableValue<T>(DecoderCallback<T> decoder) {
    final val = _consumeValue();
    if (val == null) return null;
    return decoder(
      JsonCodableDecoder._(val, null, userInfo: _rootDecoder.userInfo),
    );
  }

  @override
  List<T> decodeList<T>(DecoderCallback<T> decoder) {
    final val = _consumeValue();
    if (val is List) {
      return val
          .map(
            (e) => decoder(
              JsonCodableDecoder._(e, null, userInfo: _rootDecoder.userInfo),
            ),
          )
          .toList();
    }
    throw const CodableException('Expected List');
  }

  @override
  List<T>? decodeNullableList<T>(DecoderCallback<T> decoder) {
    final val = _consumeValue();
    if (val == null) return null;
    if (val is List) {
      return val
          .map(
            (e) => decoder(
              JsonCodableDecoder._(e, null, userInfo: _rootDecoder.userInfo),
            ),
          )
          .toList();
    }
    throw const CodableException('Expected List');
  }

  @override
  List<int> decodeIntList() {
    final val = _consumeValue();
    return (val as List).map((e) => (e as num).toInt()).toList();
  }

  @override
  List<double> decodeDoubleList() {
    final val = _consumeValue();
    return (val as List).map((e) => (e as num).toDouble()).toList();
  }

  @override
  Float64List decodeFloat64List() {
    final val = _consumeValue();
    return Float64List.fromList(
      (val as List).map((e) => (e as num).toDouble()).toList(),
    );
  }

  @override
  List<String> decodeStringList() {
    final val = _consumeValue();
    return (val as List).map((e) => e as String).toList();
  }

  @override
  List<bool> decodeBoolList() {
    final val = _consumeValue();
    return (val as List).map((e) => e as bool).toList();
  }

  @override
  int readInt() {
    final val = _consumeValue();
    if (val is num) return val.toInt();
    throw CodableException('Expected int, found $val');
  }

  @override
  int? readNullableInt() {
    final val = _consumeValue();
    if (val == null) return null;
    if (val is num) return val.toInt();
    throw CodableException('Expected int?, found $val');
  }

  @override
  double readDouble() {
    final val = _consumeValue();
    if (val is num) return val.toDouble();
    throw CodableException('Expected double, found $val');
  }

  @override
  double? readNullableDouble() {
    final val = _consumeValue();
    if (val == null) return null;
    if (val is num) return val.toDouble();
    throw CodableException('Expected double?, found $val');
  }

  @override
  String readString() {
    final val = _consumeValue();
    if (val is String) return val;
    throw CodableException('Expected String, found $val');
  }

  @override
  String? readNullableString() {
    final val = _consumeValue();
    if (val == null) return null;
    if (val is String) return val;
    throw CodableException('Expected String?, found $val');
  }

  @override
  bool readBool() {
    final val = _consumeValue();
    if (val is bool) return val;
    throw CodableException('Expected bool, found $val');
  }

  @override
  bool? readNullableBool() {
    final val = _consumeValue();
    if (val == null) return null;
    if (val is bool) return val;
    throw CodableException('Expected bool?, found $val');
  }
}

final class _JsonCodableMappedDecoder implements MappedDecoder {
  final JsonCodableDecoder _rootDecoder;
  final Map<dynamic, dynamic> _map;

  _JsonCodableMappedDecoder(this._rootDecoder, this._map);

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
  T decodeKey<T>(String key, DecoderCallback<T> decoder) => decoder(
    JsonCodableDecoder._(_map[key], null, userInfo: _rootDecoder.userInfo),
  );

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
      return v
          .map(
            (e) => decoder(
              JsonCodableDecoder._(e, null, userInfo: _rootDecoder.userInfo),
            ),
          )
          .toList();
    }
    throw CodableException('Expected list for $key');
  }

  @override
  List<T> decodeListStaticKey<T>(StaticKey key, DecoderCallback<T> decoder) =>
      decodeListKey(key.name, decoder);

  @override
  List<int> decodeIntList(String key) =>
      (_map[key] as List).map((e) => (e as num).toInt()).toList();

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
      (_map[key] as List).map((e) => e as String).toList();

  @override
  List<String> decodeStringListKey(StaticKey key) => decodeStringList(key.name);

  @override
  List<bool> decodeBoolList(String key) =>
      (_map[key] as List).map((e) => e as bool).toList();

  @override
  List<bool> decodeBoolListKey(StaticKey key) => decodeBoolList(key.name);
}

final class _JsonCodableUnkeyedDecoder implements UnkeyedDecoder {
  final JsonCodableDecoder _rootDecoder;
  final List<dynamic> _list;
  int _currentIndex = 0;

  _JsonCodableUnkeyedDecoder(this._rootDecoder, this._list);

  @override
  bool hasNext() => _currentIndex < _list.length;

  @override
  bool isNextNull() {
    if (!hasNext()) return false;
    return _list[_currentIndex] == null;
  }

  @override
  void readNull() {
    _currentIndex++;
  }

  @override
  (int start, int end) readStringSpan() =>
      throw UnsupportedError('String spans not supported on JS backend');

  @override
  (int start, int end)? readNullableStringSpan() =>
      throw UnsupportedError('String spans not supported on JS backend');

  @override
  void skipElement() {
    _currentIndex++;
  }

  @override
  T decodeElement<T>(DecoderCallback<T> decoder) {
    final value = _list[_currentIndex++];
    return decoder(
      JsonCodableDecoder._(value, null, userInfo: _rootDecoder.userInfo),
    );
  }

  @override
  T? decodeNullableElement<T>(DecoderCallback<T> decoder) {
    final value = _list[_currentIndex++];
    if (value == null) return null;
    return decoder(
      JsonCodableDecoder._(value, null, userInfo: _rootDecoder.userInfo),
    );
  }

  @override
  List<int> decodeIntList() {
    final value = _list[_currentIndex++];
    return (value as List).map((e) => (e as num).toInt()).toList();
  }

  @override
  List<double> decodeDoubleList() {
    final value = _list[_currentIndex++];
    return (value as List).map((e) => (e as num).toDouble()).toList();
  }

  @override
  Float64List decodeFloat64List() {
    final value = _list[_currentIndex++];
    return Float64List.fromList(
      (value as List).map((e) => (e as num).toDouble()).toList(),
    );
  }

  @override
  bool readBool() {
    final v = _list[_currentIndex++];
    if (v is bool) return v;
    throw CodableException('Expected bool, found $v');
  }

  @override
  bool? readNullableBool() {
    final v = _list[_currentIndex++];
    if (v == null) return null;
    if (v is bool) return v;
    throw CodableException('Expected bool?, found $v');
  }

  @override
  double readDouble() {
    final v = _list[_currentIndex++];
    if (v is num) return v.toDouble();
    throw CodableException('Expected double, found $v');
  }

  @override
  double? readNullableDouble() {
    final v = _list[_currentIndex++];
    if (v == null) return null;
    if (v is num) return v.toDouble();
    throw CodableException('Expected double?, found $v');
  }

  @override
  int readInt() {
    final v = _list[_currentIndex++];
    if (v is num) return v.toInt();
    throw CodableException('Expected int, found $v');
  }

  @override
  int? readNullableInt() {
    final v = _list[_currentIndex++];
    if (v == null) return null;
    if (v is num) return v.toInt();
    throw CodableException('Expected int?, found $v');
  }

  @override
  String readString() {
    final v = _list[_currentIndex++];
    if (v is String) return v;
    throw CodableException('Expected String, found $v');
  }

  @override
  String? readNullableString() {
    final v = _list[_currentIndex++];
    if (v == null) return null;
    if (v is String) return v;
    throw CodableException('Expected String?, found $v');
  }
}

final class _JsonCodableSingleValueDecoder implements SingleValueDecoder {
  final JsonCodableDecoder _rootDecoder;
  final Object? _val;

  _JsonCodableSingleValueDecoder(this._rootDecoder, this._val);

  @override
  void readNull() {}

  @override
  (int start, int end) readStringSpan() =>
      throw UnsupportedError('String spans not supported on JS backend');

  @override
  (int start, int end)? readNullableStringSpan() =>
      throw UnsupportedError('String spans not supported on JS backend');

  @override
  bool readBool() {
    final v = _val;
    if (v is bool) return v;
    throw CodableException('Expected bool, found $v');
  }

  @override
  bool? readNullableBool() {
    final v = _val;
    if (v == null) return null;
    if (v is bool) return v;
    throw CodableException('Expected bool?, found $v');
  }

  @override
  double readDouble() {
    final v = _val;
    if (v is num) return v.toDouble();
    throw CodableException('Expected double, found $v');
  }

  @override
  double? readNullableDouble() {
    final v = _val;
    if (v == null) return null;
    if (v is num) return v.toDouble();
    throw CodableException('Expected double?, found $v');
  }

  @override
  int readInt() {
    final v = _val;
    if (v is num) return v.toInt();
    throw CodableException('Expected int, found $v');
  }

  @override
  int? readNullableInt() {
    final v = _val;
    if (v == null) return null;
    if (v is num) return v.toInt();
    throw CodableException('Expected int?, found $v');
  }

  @override
  String readString() {
    final v = _val;
    if (v is String) return v;
    throw CodableException('Expected String, found $v');
  }

  @override
  String? readNullableString() {
    final v = _val;
    if (v == null) return null;
    if (v is String) return v;
    throw CodableException('Expected String?, found $v');
  }

  @override
  bool isNull() => _val == null;

  @override
  T decode<T>(DecoderCallback<T> decoder) => decoder(_rootDecoder);

  @override
  T? decodeNullable<T>(DecoderCallback<T> decoder) =>
      isNull() ? null : decode(decoder);
}
