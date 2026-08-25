// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'dart:typed_data';

import '../../contracts/codable.dart';
import '../../contracts/decoder.dart';
import '../../contracts/encoder.dart';
import '../../contracts/exceptions.dart';
import '../../contracts/static_key.dart';
import '../substrate/substrate.dart';

@JS('JSON.parse')
external JSAny? _jsonParse(String text);

@JS('Object.keys')
external JSArray<JSAny?> _objectKeys(JSObject object);

List<String> _getKeys(JSObject obj) {
  final keys = _objectKeys(obj);
  return List.generate(
    keys.length,
    (i) => keys.getProperty<JSString>(i.toJS).toDart,
  );
}

Object? _jsToDart(JSAny? value) {
  if (value == null) return null;
  if (value.isA<JSString>()) return (value as JSString).toDart;
  if (value.isA<JSNumber>()) return (value as JSNumber).toDartDouble;
  if (value.isA<JSBoolean>()) return (value as JSBoolean).toDart;
  if (value.isA<JSArray>()) {
    final arr = value as JSArray;
    final list = <Object?>[];
    for (var i = 0; i < arr.length; i++) {
      list.add(_jsToDart(arr.getProperty<JSAny?>(i.toJS)));
    }
    return list;
  }
  if (value.isA<JSObject>()) {
    final obj = value as JSObject;
    final map = <String, Object?>{};
    final keys = _getKeys(obj);
    for (final key in keys) {
      map[key] = _jsToDart(obj.getProperty<JSAny?>(key.toJS));
    }
    return map;
  }
  return null;
}

final class JsonCodableDecoder implements Decoder {
  final JSAny? _decoded;
  final Uint8List? _bytes;
  @override
  final Map<Object, Object?> userInfo;

  JSAny? _activeValue;

  JsonCodableDecoder._(this._decoded, this._bytes, {this.userInfo = const {}});

  factory JsonCodableDecoder.fromBytes(
    Uint8List bytes, {
    Map<Object, Object?> userInfo = const {},
  }) {
    final decoded = _jsonParse(utf8.decode(bytes));
    return JsonCodableDecoder._(decoded, bytes, userInfo: userInfo);
  }

  JsonCodableDecoder.fromReader(
    JsonTokenReader reader, {
    this.userInfo = const {},
  }) : _bytes = null,
       _decoded = _readAll(reader);

  static JSAny? _readAll(JsonTokenReader reader) {
    if (!reader.hasNext()) return null;
    switch (reader.peek()) {
      case JsonTokenType.beginObject:
        reader.beginObject();
        final map = JSObject();
        while (reader.hasNext()) {
          final key = reader.nextName();
          map.setProperty(key.toJS, _readAll(reader));
        }
        reader.endObject();
        return map;
      case JsonTokenType.beginArray:
        reader.beginArray();
        final list = JSArray<JSAny?>();
        while (reader.hasNext()) {
          list.add(_readAll(reader));
        }
        reader.endArray();
        return list;
      case JsonTokenType.string:
        return reader.readString().toJS;
      case JsonTokenType.number:
        return reader.readDouble().toJS;
      case JsonTokenType.boolean:
        return reader.readBool().toJS;
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
        : Uint8List.fromList(utf8.encode(jsonEncode(_jsToDart(target))));
    _activeValue = null;
    return JsonTokenReader.fromBytes(bytes);
  }

  @override
  KeyedDecoder keyed({KeyOptions? options}) => _JsonCodableMappedKeyedDecoder(
    this,
    (_activeValue ?? _decoded) as JSObject,
  );

  @override
  MappedDecoder mapped() =>
      _JsonCodableMappedDecoder(this, (_activeValue ?? _decoded) as JSObject);

  @override
  UnkeyedDecoder unkeyed() =>
      _JsonCodableUnkeyedDecoder(this, (_activeValue ?? _decoded) as JSArray);

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
  final JSObject _map;
  final List<String> _keys;
  int _currentIndex = 0;
  JSAny? _activeValue;
  bool _hasActiveValue = false;

  _JsonCodableMappedKeyedDecoder(this._rootDecoder, this._map)
    : _keys = _getKeys(_map);

  @override
  bool hasNextKey() => _currentIndex < _keys.length || _hasActiveValue;

  @override
  bool isNextNull() {
    if (_hasActiveValue) return _activeValue == null;
    if (!hasNextKey()) return false;
    final key = _keys[_currentIndex];
    return _map.getProperty<JSAny?>(key.toJS) == null;
  }

  @override
  void readNull() {
    if (_hasActiveValue) {
      _hasActiveValue = false;
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
    _activeValue = _map.getProperty<JSAny?>(key.toJS);
    _hasActiveValue = true;
    return key;
  }

  @override
  String? peekKey() =>
      _currentIndex < _keys.length ? _keys[_currentIndex] : null;

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
  int selectStringIndex(KeyOptions options) {
    final str = readString();
    return options.keys.indexOf(str);
  }

  @override
  void skipField() => skipValue();

  @override
  void skipValue() {
    if (_hasActiveValue) {
      _hasActiveValue = false;
      _activeValue = null;
    } else if (hasNextKey()) {
      _currentIndex++;
    }
  }

  JSAny? _consumeValue() {
    if (_hasActiveValue) {
      _hasActiveValue = false;
      final v = _activeValue;
      _activeValue = null;
      return v;
    }
    if (!hasNextKey()) {
      throw const CodableException('No more keys in object');
    }
    final key = _keys[_currentIndex++];
    return _map.getProperty<JSAny?>(key.toJS);
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
    if (val != null && val.isA<JSArray>()) {
      final arr = val as JSArray;
      final result = <T>[];
      for (var i = 0; i < arr.length; i++) {
        result.add(
          decoder(
            JsonCodableDecoder._(
              arr.getProperty<JSAny?>(i.toJS),
              null,
              userInfo: _rootDecoder.userInfo,
            ),
          ),
        );
      }
      return result;
    }
    throw const CodableException('Expected List');
  }

  @override
  List<T>? decodeNullableList<T>(DecoderCallback<T> decoder) {
    final val = _consumeValue();
    if (val == null) return null;
    if (val.isA<JSArray>()) {
      final arr = val as JSArray;
      final result = <T>[];
      for (var i = 0; i < arr.length; i++) {
        result.add(
          decoder(
            JsonCodableDecoder._(
              arr.getProperty<JSAny?>(i.toJS),
              null,
              userInfo: _rootDecoder.userInfo,
            ),
          ),
        );
      }
      return result;
    }
    throw const CodableException('Expected List');
  }

  @override
  List<int> decodeIntList() {
    final val = _consumeValue();
    final arr = val as JSArray;
    final result = <int>[];
    for (var i = 0; i < arr.length; i++) {
      final e = arr.getProperty<JSAny?>(i.toJS);
      result.add((e as JSNumber).toDartDouble.toInt());
    }
    return result;
  }

  @override
  List<double> decodeDoubleList() {
    final val = _consumeValue();
    final arr = val as JSArray;
    final result = <double>[];
    for (var i = 0; i < arr.length; i++) {
      final e = arr.getProperty<JSAny?>(i.toJS);
      result.add((e as JSNumber).toDartDouble);
    }
    return result;
  }

  @override
  Float64List decodeFloat64List() {
    final val = _consumeValue();
    final arr = val as JSArray;
    final result = Float64List(arr.length);
    for (var i = 0; i < arr.length; i++) {
      final e = arr.getProperty<JSAny?>(i.toJS);
      result[i] = (e as JSNumber).toDartDouble;
    }
    return result;
  }

  @override
  List<String> decodeStringList() {
    final val = _consumeValue();
    final arr = val as JSArray;
    final result = <String>[];
    for (var i = 0; i < arr.length; i++) {
      final e = arr.getProperty<JSAny?>(i.toJS);
      result.add((e as JSString).toDart);
    }
    return result;
  }

  @override
  List<bool> decodeBoolList() {
    final val = _consumeValue();
    final arr = val as JSArray;
    final result = <bool>[];
    for (var i = 0; i < arr.length; i++) {
      final e = arr.getProperty<JSAny?>(i.toJS);
      result.add((e as JSBoolean).toDart);
    }
    return result;
  }

  @override
  int readInt() {
    final val = _consumeValue();
    if (val != null && val.isA<JSNumber>()) {
      return (val as JSNumber).toDartDouble.toInt();
    }
    throw CodableException('Expected int, found $val');
  }

  @override
  int? readNullableInt() {
    final val = _consumeValue();
    if (val == null) return null;
    if (val.isA<JSNumber>()) return (val as JSNumber).toDartDouble.toInt();
    throw CodableException('Expected int?, found $val');
  }

  @override
  double readDouble() {
    final val = _consumeValue();
    if (val != null && val.isA<JSNumber>()) {
      return (val as JSNumber).toDartDouble;
    }
    throw CodableException('Expected double, found $val');
  }

  @override
  double? readNullableDouble() {
    final val = _consumeValue();
    if (val == null) return null;
    if (val.isA<JSNumber>()) return (val as JSNumber).toDartDouble;
    throw CodableException('Expected double?, found $val');
  }

  @override
  String readString() {
    final val = _consumeValue();
    if (val != null && val.isA<JSString>()) return (val as JSString).toDart;
    throw CodableException('Expected String, found $val');
  }

  @override
  String? readNullableString() {
    final val = _consumeValue();
    if (val == null) return null;
    if (val.isA<JSString>()) return (val as JSString).toDart;
    throw CodableException('Expected String?, found $val');
  }

  @override
  bool readBool() {
    final val = _consumeValue();
    if (val != null && val.isA<JSBoolean>()) return (val as JSBoolean).toDart;
    throw CodableException('Expected bool, found $val');
  }

  @override
  bool? readNullableBool() {
    final val = _consumeValue();
    if (val == null) return null;
    if (val.isA<JSBoolean>()) return (val as JSBoolean).toDart;
    throw CodableException('Expected bool?, found $val');
  }
}

final class _JsonCodableMappedDecoder
    with MappedDecoderBase
    implements MappedDecoder {
  final JsonCodableDecoder _rootDecoder;
  final JSObject _map;

  _JsonCodableMappedDecoder(this._rootDecoder, this._map);

  @override
  bool containsKey(String key) => _map.hasProperty(key.toJS).toDart;

  @override
  bool isNull(String key) => _map.getProperty<JSAny?>(key.toJS) == null;

  @override
  int readInt(String key) {
    final v = _map.getProperty<JSAny?>(key.toJS);
    if (v != null && v.isA<JSNumber>()) {
      return (v as JSNumber).toDartDouble.toInt();
    }
    throw CodableException('Expected int for $key, found $v');
  }

  @override
  int? readNullableInt(String key) {
    final v = _map.getProperty<JSAny?>(key.toJS);
    if (v == null) return null;
    if (v.isA<JSNumber>()) {
      return (v as JSNumber).toDartDouble.toInt();
    }
    throw CodableException('Expected int for $key, found $v');
  }

  @override
  double readDouble(String key) {
    final v = _map.getProperty<JSAny?>(key.toJS);
    if (v != null && v.isA<JSNumber>()) return (v as JSNumber).toDartDouble;
    throw CodableException('Expected double for $key, found $v');
  }

  @override
  double? readNullableDouble(String key) {
    final v = _map.getProperty<JSAny?>(key.toJS);
    if (v == null) return null;
    if (v.isA<JSNumber>()) {
      return (v as JSNumber).toDartDouble;
    }
    throw CodableException('Expected double for $key, found $v');
  }

  @override
  String readString(String key) {
    final v = _map.getProperty<JSAny?>(key.toJS);
    if (v != null && v.isA<JSString>()) return (v as JSString).toDart;
    throw CodableException('Expected String for $key, found $v');
  }

  @override
  String? readNullableString(String key) {
    final v = _map.getProperty<JSAny?>(key.toJS);
    if (v == null) return null;
    if (v.isA<JSString>()) {
      return (v as JSString).toDart;
    }
    throw CodableException('Expected String for $key, found $v');
  }

  @override
  bool readBool(String key) {
    final v = _map.getProperty<JSAny?>(key.toJS);
    if (v != null && v.isA<JSBoolean>()) return (v as JSBoolean).toDart;
    throw CodableException('Expected bool for $key, found $v');
  }

  @override
  bool? readNullableBool(String key) {
    final v = _map.getProperty<JSAny?>(key.toJS);
    if (v == null) return null;
    if (v.isA<JSBoolean>()) {
      return (v as JSBoolean).toDart;
    }
    throw CodableException('Expected bool for $key, found $v');
  }

  @override
  T decodeKey<T>(String key, DecoderCallback<T> decoder) => decoder(
    JsonCodableDecoder._(
      _map.getProperty<JSAny?>(key.toJS),
      null,
      userInfo: _rootDecoder.userInfo,
    ),
  );

  @override
  T? decodeNullableKey<T>(String key, DecoderCallback<T> decoder) =>
      isNull(key) ? null : decodeKey(key, decoder);

  @override
  List<T> decodeListKey<T>(String key, DecoderCallback<T> decoder) {
    final v = _map.getProperty<JSAny?>(key.toJS);
    if (v != null && v.isA<JSArray>()) {
      final arr = v as JSArray;
      final result = <T>[];
      for (var i = 0; i < arr.length; i++) {
        result.add(
          decoder(
            JsonCodableDecoder._(
              arr.getProperty<JSAny?>(i.toJS),
              null,
              userInfo: _rootDecoder.userInfo,
            ),
          ),
        );
      }
      return result;
    }
    throw CodableException('Expected list for $key');
  }

  @override
  List<int> decodeIntList(String key) {
    final arr = _map.getProperty<JSAny?>(key.toJS) as JSArray;
    final result = <int>[];
    for (var i = 0; i < arr.length; i++) {
      final e = arr.getProperty<JSAny?>(i.toJS);
      result.add((e as JSNumber).toDartDouble.toInt());
    }
    return result;
  }

  @override
  List<double> decodeDoubleList(String key) {
    final arr = _map.getProperty<JSAny?>(key.toJS) as JSArray;
    final result = <double>[];
    for (var i = 0; i < arr.length; i++) {
      final e = arr.getProperty<JSAny?>(i.toJS);
      result.add((e as JSNumber).toDartDouble);
    }
    return result;
  }

  @override
  Float64List decodeFloat64List(String key) {
    final arr = _map.getProperty<JSAny?>(key.toJS) as JSArray;
    final result = Float64List(arr.length);
    for (var i = 0; i < arr.length; i++) {
      final e = arr.getProperty<JSAny?>(i.toJS);
      result[i] = (e as JSNumber).toDartDouble;
    }
    return result;
  }

  @override
  List<String> decodeStringList(String key) {
    final arr = _map.getProperty<JSAny?>(key.toJS) as JSArray;
    final result = <String>[];
    for (var i = 0; i < arr.length; i++) {
      final e = arr.getProperty<JSAny?>(i.toJS);
      result.add((e as JSString).toDart);
    }
    return result;
  }

  @override
  List<bool> decodeBoolList(String key) {
    final arr = _map.getProperty<JSAny?>(key.toJS) as JSArray;
    final result = <bool>[];
    for (var i = 0; i < arr.length; i++) {
      final e = arr.getProperty<JSAny?>(i.toJS);
      result.add((e as JSBoolean).toDart);
    }
    return result;
  }
}

final class _JsonCodableUnkeyedDecoder implements UnkeyedDecoder {
  final JsonCodableDecoder _rootDecoder;
  final JSArray _list;
  int _currentIndex = 0;

  _JsonCodableUnkeyedDecoder(this._rootDecoder, this._list);

  @override
  bool hasNext() => _currentIndex < _list.length;

  @override
  bool isNextNull() {
    if (!hasNext()) return false;
    return _list.getProperty<JSAny?>(_currentIndex.toJS) == null;
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
    final value = _list.getProperty<JSAny?>(_currentIndex.toJS);
    _currentIndex++;
    return decoder(
      JsonCodableDecoder._(value, null, userInfo: _rootDecoder.userInfo),
    );
  }

  @override
  T? decodeNullableElement<T>(DecoderCallback<T> decoder) {
    final value = _list.getProperty<JSAny?>(_currentIndex.toJS);
    _currentIndex++;
    if (value == null) return null;
    return decoder(
      JsonCodableDecoder._(value, null, userInfo: _rootDecoder.userInfo),
    );
  }

  @override
  List<int> decodeIntList() {
    final arr = _list.getProperty<JSAny?>(_currentIndex.toJS) as JSArray;
    _currentIndex++;
    final result = <int>[];
    for (var i = 0; i < arr.length; i++) {
      final e = arr.getProperty<JSAny?>(i.toJS);
      result.add((e as JSNumber).toDartDouble.toInt());
    }
    return result;
  }

  @override
  List<double> decodeDoubleList() {
    final arr = _list.getProperty<JSAny?>(_currentIndex.toJS) as JSArray;
    _currentIndex++;
    final result = <double>[];
    for (var i = 0; i < arr.length; i++) {
      final e = arr.getProperty<JSAny?>(i.toJS);
      result.add((e as JSNumber).toDartDouble);
    }
    return result;
  }

  @override
  Float64List decodeFloat64List() {
    final arr = _list.getProperty<JSAny?>(_currentIndex.toJS) as JSArray;
    _currentIndex++;
    final result = Float64List(arr.length);
    for (var i = 0; i < arr.length; i++) {
      final e = arr.getProperty<JSAny?>(i.toJS);
      result[i] = (e as JSNumber).toDartDouble;
    }
    return result;
  }

  @override
  bool readBool() {
    final v = _list.getProperty<JSAny?>(_currentIndex.toJS);
    _currentIndex++;
    if (v != null && v.isA<JSBoolean>()) return (v as JSBoolean).toDart;
    throw CodableException('Expected bool, found $v');
  }

  @override
  bool? readNullableBool() {
    final v = _list.getProperty<JSAny?>(_currentIndex.toJS);
    _currentIndex++;
    if (v == null) return null;
    if (v.isA<JSBoolean>()) return (v as JSBoolean).toDart;
    throw CodableException('Expected bool?, found $v');
  }

  @override
  double readDouble() {
    final v = _list.getProperty<JSAny?>(_currentIndex.toJS);
    _currentIndex++;
    if (v != null && v.isA<JSNumber>()) return (v as JSNumber).toDartDouble;
    throw CodableException('Expected double, found $v');
  }

  @override
  double? readNullableDouble() {
    final v = _list.getProperty<JSAny?>(_currentIndex.toJS);
    _currentIndex++;
    if (v == null) return null;
    if (v.isA<JSNumber>()) return (v as JSNumber).toDartDouble;
    throw CodableException('Expected double?, found $v');
  }

  @override
  int readInt() {
    final v = _list.getProperty<JSAny?>(_currentIndex.toJS);
    _currentIndex++;
    if (v != null && v.isA<JSNumber>()) {
      return (v as JSNumber).toDartDouble.toInt();
    }
    throw CodableException('Expected int, found $v');
  }

  @override
  int? readNullableInt() {
    final v = _list.getProperty<JSAny?>(_currentIndex.toJS);
    _currentIndex++;
    if (v == null) return null;
    if (v.isA<JSNumber>()) return (v as JSNumber).toDartDouble.toInt();
    throw CodableException('Expected int?, found $v');
  }

  @override
  String readString() {
    final v = _list.getProperty<JSAny?>(_currentIndex.toJS);
    _currentIndex++;
    if (v != null && v.isA<JSString>()) return (v as JSString).toDart;
    throw CodableException('Expected String, found $v');
  }

  @override
  String? readNullableString() {
    final v = _list.getProperty<JSAny?>(_currentIndex.toJS);
    _currentIndex++;
    if (v == null) return null;
    if (v.isA<JSString>()) return (v as JSString).toDart;
    throw CodableException('Expected String?, found $v');
  }
}

final class _JsonCodableSingleValueDecoder implements SingleValueDecoder {
  final JsonCodableDecoder _rootDecoder;
  final JSAny? _val;

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
    if (v != null && v.isA<JSBoolean>()) return (v as JSBoolean).toDart;
    throw CodableException('Expected bool, found $v');
  }

  @override
  bool? readNullableBool() {
    final v = _val;
    if (v == null) return null;
    if (v.isA<JSBoolean>()) return (v as JSBoolean).toDart;
    throw CodableException('Expected bool?, found $v');
  }

  @override
  double readDouble() {
    final v = _val;
    if (v != null && v.isA<JSNumber>()) return (v as JSNumber).toDartDouble;
    throw CodableException('Expected double, found $v');
  }

  @override
  double? readNullableDouble() {
    final v = _val;
    if (v == null) return null;
    if (v.isA<JSNumber>()) return (v as JSNumber).toDartDouble;
    throw CodableException('Expected double?, found $v');
  }

  @override
  int readInt() {
    final v = _val;
    if (v != null && v.isA<JSNumber>()) {
      return (v as JSNumber).toDartDouble.toInt();
    }
    throw CodableException('Expected int, found $v');
  }

  @override
  int? readNullableInt() {
    final v = _val;
    if (v == null) return null;
    if (v.isA<JSNumber>()) return (v as JSNumber).toDartDouble.toInt();
    throw CodableException('Expected int?, found $v');
  }

  @override
  String readString() {
    final v = _val;
    if (v != null && v.isA<JSString>()) return (v as JSString).toDart;
    throw CodableException('Expected String, found $v');
  }

  @override
  String? readNullableString() {
    final v = _val;
    if (v == null) return null;
    if (v.isA<JSString>()) return (v as JSString).toDart;
    throw CodableException('Expected String?, found $v');
  }

  @override
  bool isNull() => _val == null;

  @override
  T decode<T>(DecoderCallback<T> decoder) => decoder(
    JsonCodableDecoder._(_val, null, userInfo: _rootDecoder.userInfo),
  );

  @override
  T? decodeNullable<T>(DecoderCallback<T> decoder) =>
      isNull() ? null : decode(decoder);
}

@JS('JSON.stringify')
external String _jsonStringify(JSAny? value);

/// Concrete high-performance DOM/JS JSON encoder connecting `package:codable`
/// contracts directly to native JavaScript objects and `JSON.stringify`.
final class JsonCodableEncoder implements Encoder {
  JSAny? _root;
  @override
  final Map<Object, Object?> userInfo;

  JsonCodableEncoder({this.userInfo = const {}});

  /// Encodes a value to a JSON String.
  static String encode(
    void Function(Encoder encoder) encode, {
    Map<Object, Object?> userInfo = const {},
  }) {
    final encoder = JsonCodableEncoder(userInfo: userInfo);
    encode(encoder);
    return _jsonStringify(encoder._root);
  }

  /// Encodes a value to a newly allocated UTF-8 byte buffer.
  static Uint8List toBytes(
    void Function(Encoder encoder) encode, {
    Map<Object, Object?> userInfo = const {},
  }) {
    final str = JsonCodableEncoder.encode(encode, userInfo: userInfo);
    return Uint8List.fromList(utf8.encode(str));
  }

  @override
  KeyedEncoder keyed({KeyOptions? options}) {
    final obj = JSObject();
    _root = obj;
    return _JsonCodableJsKeyedEncoder(this, obj);
  }

  @override
  UnkeyedEncoder unkeyed() {
    final array = JSArray<JSAny?>();
    _root = array;
    return _JsonCodableJsUnkeyedEncoder(this, array);
  }

  @override
  SingleValueEncoder singleValue() => _JsonCodableJsSingleValueEncoder(this);

  @override
  KeyedEncoder container({KeyOptions? options}) => keyed(options: options);

  @override
  UnkeyedEncoder unkeyedContainer() => unkeyed();

  @override
  SingleValueEncoder singleValueContainer() => singleValue();
}

final class _JsonCodableJsKeyedEncoder implements KeyedEncoder {
  final JsonCodableEncoder _rootEncoder;
  final JSObject _object;

  _JsonCodableJsKeyedEncoder(this._rootEncoder, this._object);

  @override
  void encodeInt(String key, int value) => _object[key] = value.toJS;

  @override
  void encodeIntKey(StaticKey key, int value) => encodeInt(key.name, value);

  @override
  void encodeNullableInt(String key, int? value) {
    if (value != null) _object[key] = value.toJS;
  }

  @override
  void encodeNullableIntKey(StaticKey key, int? value) =>
      encodeNullableInt(key.name, value);

  @override
  void encodeDouble(String key, double value) => _object[key] = value.toJS;

  @override
  void encodeDoubleKey(StaticKey key, double value) =>
      encodeDouble(key.name, value);

  @override
  void encodeNullableDouble(String key, double? value) {
    if (value != null) _object[key] = value.toJS;
  }

  @override
  void encodeNullableDoubleKey(StaticKey key, double? value) =>
      encodeNullableDouble(key.name, value);

  @override
  void encodeString(String key, String value) => _object[key] = value.toJS;

  @override
  void encodeStringKey(StaticKey key, String value) =>
      encodeString(key.name, value);

  @override
  void encodeNullableString(String key, String? value) {
    if (value != null) _object[key] = value.toJS;
  }

  @override
  void encodeNullableStringKey(StaticKey key, String? value) =>
      encodeNullableString(key.name, value);

  @override
  void encodeBool(String key, bool value) => _object[key] = value.toJS;

  @override
  void encodeBoolKey(StaticKey key, bool value) => encodeBool(key.name, value);

  @override
  void encodeNullableBool(String key, bool? value) {
    if (value != null) _object[key] = value.toJS;
  }

  @override
  void encodeNullableBoolKey(StaticKey key, bool? value) =>
      encodeNullableBool(key.name, value);

  @override
  void encodeNull(String key) => _object[key] = null;

  @override
  void encodeNullKey(StaticKey key) => encodeNull(key.name);

  @override
  void encodeValue<T>(String key, T value, EncoderCallback<T> encode) {
    final child = JsonCodableEncoder(userInfo: _rootEncoder.userInfo);
    encode(value, child);
    _object[key] = child._root;
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
    final child = JsonCodableEncoder(userInfo: _rootEncoder.userInfo);
    value.encode(child);
    _object[key] = child._root;
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
    final array = JSArray<JSAny?>();
    for (final e in elements) {
      final child = JsonCodableEncoder(userInfo: _rootEncoder.userInfo);
      encode(e, child);
      array.add(child._root);
    }
    _object[key] = array;
  }

  @override
  void encodeListKey<T>(
    StaticKey key,
    Iterable<T> elements,
    EncoderCallback<T> encode,
  ) => encodeList(key.name, elements, encode);

  @override
  void encodeIntList(String key, List<int> values) {
    final array = JSArray<JSNumber>.withLength(values.length);
    for (var i = 0; i < values.length; i++) {
      array[i] = values[i].toJS;
    }
    _object[key] = array;
  }

  @override
  void encodeIntListKey(StaticKey key, List<int> values) =>
      encodeIntList(key.name, values);

  @override
  void encodeDoubleList(String key, List<double> values) {
    final array = JSArray<JSNumber>.withLength(values.length);
    for (var i = 0; i < values.length; i++) {
      array[i] = values[i].toJS;
    }
    _object[key] = array;
  }

  @override
  void encodeDoubleListKey(StaticKey key, List<double> values) =>
      encodeDoubleList(key.name, values);

  @override
  void encodeStringList(String key, List<String> values) {
    final array = JSArray<JSString>.withLength(values.length);
    for (var i = 0; i < values.length; i++) {
      array[i] = values[i].toJS;
    }
    _object[key] = array;
  }

  @override
  void encodeStringListKey(StaticKey key, List<String> values) =>
      encodeStringList(key.name, values);

  @override
  void encodeBoolList(String key, List<bool> values) {
    final array = JSArray<JSBoolean>.withLength(values.length);
    for (var i = 0; i < values.length; i++) {
      array[i] = values[i].toJS;
    }
    _object[key] = array;
  }

  @override
  void encodeBoolListKey(StaticKey key, List<bool> values) =>
      encodeBoolList(key.name, values);
}

final class _JsonCodableJsUnkeyedEncoder implements UnkeyedEncoder {
  final JsonCodableEncoder _rootEncoder;
  final JSArray<JSAny?> _array;

  _JsonCodableJsUnkeyedEncoder(this._rootEncoder, this._array);

  @override
  void encodeInt(int value) => _array.add(value.toJS);

  @override
  void encodeNullableInt(int? value) => _array.add(value?.toJS);

  @override
  void encodeDouble(double value) => _array.add(value.toJS);

  @override
  void encodeNullableDouble(double? value) => _array.add(value?.toJS);

  @override
  void encodeString(String value) => _array.add(value.toJS);

  @override
  void encodeNullableString(String? value) => _array.add(value?.toJS);

  @override
  void encodeBool(bool value) => _array.add(value.toJS);

  @override
  void encodeNullableBool(bool? value) => _array.add(value?.toJS);

  @override
  void encodeNull() => _array.add(null);

  @override
  void encodeElement<T>(T value, EncoderCallback<T> encode) {
    final child = JsonCodableEncoder(userInfo: _rootEncoder.userInfo);
    encode(value, child);
    _array.add(child._root);
  }

  @override
  void encodeNullableElement<T>(T? value, EncoderCallback<T> encode) {
    if (value == null) {
      _array.add(null);
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
    final child = JsonCodableEncoder(userInfo: _rootEncoder.userInfo);
    value.encode(child);
    _array.add(child._root);
  }

  @override
  void encodeNullableEncodable(Encodable? value) {
    if (value == null) {
      _array.add(null);
    } else {
      encodeEncodable(value);
    }
  }
}

final class _JsonCodableJsSingleValueEncoder implements SingleValueEncoder {
  final JsonCodableEncoder _rootEncoder;

  _JsonCodableJsSingleValueEncoder(this._rootEncoder);

  @override
  void encodeInt(int value) => _rootEncoder._root = value.toJS;

  @override
  void encodeNullableInt(int? value) => _rootEncoder._root = value?.toJS;

  @override
  void encodeDouble(double value) => _rootEncoder._root = value.toJS;

  @override
  void encodeNullableDouble(double? value) => _rootEncoder._root = value?.toJS;

  @override
  void encodeString(String value) => _rootEncoder._root = value.toJS;

  @override
  void encodeNullableString(String? value) => _rootEncoder._root = value?.toJS;

  @override
  void encodeBool(bool value) => _rootEncoder._root = value.toJS;

  @override
  void encodeNullableBool(bool? value) => _rootEncoder._root = value?.toJS;

  @override
  void encodeNull() => _rootEncoder._root = null;

  @override
  void encode<T>(T value, EncoderCallback<T> encode) {
    final child = JsonCodableEncoder(userInfo: _rootEncoder.userInfo);
    encode(value, child);
    _rootEncoder._root = child._root;
  }

  @override
  void encodeNullable<T>(T? value, EncoderCallback<T> encode) {
    if (value == null) {
      _rootEncoder._root = null;
    } else {
      final child = JsonCodableEncoder(userInfo: _rootEncoder.userInfo);
      encode(value, child);
      _rootEncoder._root = child._root;
    }
  }

  @override
  void encodeEncodable(Encodable value) {
    final child = JsonCodableEncoder(userInfo: _rootEncoder.userInfo);
    value.encode(child);
    _rootEncoder._root = child._root;
  }

  @override
  void encodeNullableEncodable(Encodable? value) {
    if (value == null) {
      _rootEncoder._root = null;
    } else {
      encodeEncodable(value);
    }
  }
}
