// Comprehensive Domain Models and Roundtrip Validation Test Suite
//
// Covers:
// - Coordinate: primitive float streaming, alias keys ('lat'/'latitude', 'lon'/'longitude'), equality, hash code
// - UserProfile: string enum UserRole, ZipCodeDecoder CustomFieldDecoder, Golden Mask bitmask validation, tags
// - Vehicle Polymorphic Hierarchy: Vehicle, Car, Bicycle, SuperDecodable, leading/middle/trailing discriminators
// - Bit-Exact JSON Roundtrip Validation vs standard jsonEncode / jsonDecode
// - Tier 1 (Happy Path), Tier 2 (Boundary & Errors), Tier 3 (Pairwise Interactions)
//
// Strict assertion standard: package:checks only.

// ignore_for_file: unreachable_from_main, lines_longer_than_80_chars

import 'dart:convert';

import 'package:checks/checks.dart';
import 'package:codable/codable.dart';
import 'package:codable/src/driver/json_codable_driver.dart';
import 'package:test/scaffolding.dart';

part 'domain_models_test.g.dart';

// ============================================================================
// Concrete Mock JSON Driver & Test Container Implementations
// ============================================================================

final class _TestDecoder implements Decoder {
  final Object? _data;
  @override
  final Map<Object, Object?> userInfo;
  _TestKeyedDecoder? _activeKeyed;

  @override
  Uint8List? get payload => null;

  _TestDecoder(this._data, {this.userInfo = const {}});

  @override
  KeyedDecoder keyed({KeyOptions? options}) {
    final data = _data;
    if (data is Map<String, dynamic>) {
      final entries = data.entries.toList();
      final keyed = _TestKeyedDecoder(entries, this);
      _activeKeyed = keyed;
      return keyed;
    }
    throw CodableException(
      'Expected JSON Object for keyed decoder, found ${_data.runtimeType}',
    );
  }

  @override
  MappedDecoder mapped() {
    final data = _data;
    if (data is Map<String, dynamic>) {
      return _TestMappedDecoder(data, this);
    }
    throw CodableException(
      'Expected JSON Object for mapped decoder, found ${_data.runtimeType}',
    );
  }

  @override
  UnkeyedDecoder unkeyed() {
    final data = _data;
    if (data is List<dynamic>) {
      return _TestUnkeyedDecoder(data, this);
    }
    throw CodableException(
      'Expected JSON Array for unkeyed decoder, found ${_data.runtimeType}',
    );
  }

  @override
  SingleValueDecoder singleValue() {
    if (_activeKeyed != null && _activeKeyed!._hasCurrent) {
      return _TestSingleValueDecoder(_activeKeyed!._currentValue, this);
    }
    return _TestSingleValueDecoder(_data, this);
  }

  @override
  KeyedDecoder container({KeyOptions? options}) => keyed(options: options);

  @override
  UnkeyedDecoder unkeyedContainer() => unkeyed();

  @override
  SingleValueDecoder singleValueContainer() => singleValue();
}

final class _TestKeyedDecoder implements KeyedDecoder {
  final List<MapEntry<String, dynamic>> _entries;
  final _TestDecoder _rootDecoder;
  int _currentIndex = -1;

  _TestKeyedDecoder(this._entries, this._rootDecoder);

  bool get _hasCurrent => _currentIndex >= 0 && _currentIndex < _entries.length;

  Object? get _currentValue {
    if (!_hasCurrent) {
      throw const CodableException('No current field selected in KeyedDecoder');
    }
    return _entries[_currentIndex].value;
  }

  @override
  bool hasNextKey() => _currentIndex + 1 < _entries.length;

  @override
  bool hasNext() => hasNextKey();

  @override
  String nextKey() {
    if (!hasNextKey()) {
      throw const CodableException('No more keys available in KeyedDecoder');
    }
    _currentIndex++;
    return _entries[_currentIndex].key;
  }

  @override
  String? peekKey() => hasNextKey() ? _entries[_currentIndex + 1].key : null;

  @override
  int selectKey(List<String> keys) {
    if (!hasNextKey()) return -1;
    _currentIndex++;
    return keys.indexOf(_entries[_currentIndex].key);
  }

  @override
  int selectKeyIndex(KeyOptions options) {
    if (!hasNextKey()) return -1;
    _currentIndex++;
    return options.indexOf(_entries[_currentIndex].key);
  }

  @override
  int selectStringIndex(KeyOptions options) {
    final str = readString();
    return options.indexOf(str);
  }

  @override
  int readInt() {
    final v = _currentValue;
    if (v is int) return v;
    throw CodableException('Expected int, found ${v.runtimeType}: $v');
  }

  @override
  int? readNullableInt() {
    final v = _currentValue;
    if (v == null) return null;
    return readInt();
  }

  @override
  double readDouble() {
    final v = _currentValue;
    if (v is num) return v.toDouble();
    throw CodableException('Expected double/num, found ${v.runtimeType}: $v');
  }

  @override
  double? readNullableDouble() {
    final v = _currentValue;
    if (v == null) return null;
    return readDouble();
  }

  @override
  String readString() {
    final v = _currentValue;
    if (v is String) return v;
    throw CodableException('Expected String, found ${v.runtimeType}: $v');
  }

  @override
  String? readNullableString() {
    final v = _currentValue;
    if (v == null) return null;
    return readString();
  }

  @override
  (int start, int end) readStringSpan() {
    throw UnsupportedError(
      'readStringSpan is not supported on _TestKeyedDecoder',
    );
  }

  @override
  (int start, int end)? readNullableStringSpan() {
    if (isNextNull()) return null;
    return readStringSpan();
  }

  @override
  bool readBool() {
    final v = _currentValue;
    if (v is bool) return v;
    throw CodableException('Expected bool, found ${v.runtimeType}: $v');
  }

  @override
  bool? readNullableBool() {
    final v = _currentValue;
    if (v == null) return null;
    return readBool();
  }

  @override
  bool isNextNull() => _currentValue == null;

  @override
  void readNull() {
    final v = _currentValue;
    if (v != null) {
      throw CodableException('Expected null, found ${v.runtimeType}: $v');
    }
  }

  @override
  void skipField() => skipValue();

  @override
  void skipValue() {
    // Current value skipped
  }

  @override
  T decodeValue<T>(DecoderCallback<T> decoder) =>
      decoder(_TestDecoder(_currentValue, userInfo: _rootDecoder.userInfo));

  @override
  T? decodeNullableValue<T>(DecoderCallback<T> decoder) {
    if (_currentValue == null) return null;
    return decodeValue(decoder);
  }

  @override
  List<T> decodeList<T>(DecoderCallback<T> decoder) {
    final v = _currentValue;
    if (v is List<dynamic>) {
      return v
          .map((e) => decoder(_TestDecoder(e, userInfo: _rootDecoder.userInfo)))
          .toList();
    }
    throw CodableException('Expected List, found ${v.runtimeType}: $v');
  }

  @override
  List<T>? decodeNullableList<T>(DecoderCallback<T> decoder) {
    if (_currentValue == null) return null;
    return decodeList(decoder);
  }

  @override
  List<int> decodeIntList() {
    final v = _currentValue;
    if (v is List<dynamic>) {
      return v.map((e) {
        if (e is int) return e;
        throw CodableException('Expected int element, found ${e.runtimeType}');
      }).toList();
    }
    throw CodableException('Expected List<int>, found ${v.runtimeType}: $v');
  }

  @override
  List<double> decodeDoubleList() {
    final v = _currentValue;
    if (v is List<dynamic>) {
      return v.map((e) {
        if (e is num) return e.toDouble();
        throw CodableException(
          'Expected double element, found ${e.runtimeType}',
        );
      }).toList();
    }
    throw CodableException('Expected List<double>, found ${v.runtimeType}: $v');
  }

  @override
  List<String> decodeStringList() {
    final v = _currentValue;
    if (v is List<dynamic>) {
      return v.map((e) {
        if (e is String) return e;
        throw CodableException(
          'Expected String element, found ${e.runtimeType}',
        );
      }).toList();
    }
    throw CodableException('Expected List<String>, found ${v.runtimeType}: $v');
  }

  @override
  List<bool> decodeBoolList() {
    final v = _currentValue;
    if (v is List<dynamic>) {
      return v.map((e) {
        if (e is bool) return e;
        throw CodableException('Expected bool element, found ${e.runtimeType}');
      }).toList();
    }
    throw CodableException('Expected List<bool>, found ${v.runtimeType}: $v');
  }

  @override
  Float64List decodeFloat64List() {
    final v = _currentValue;
    if (v is List<dynamic>) {
      final list = Float64List(v.length);
      for (var i = 0; i < v.length; i++) {
        final e = v[i];
        if (e is num) {
          list[i] = e.toDouble();
        } else {
          throw CodableException(
            'Expected num element, found ${e.runtimeType}',
          );
        }
      }
      return list;
    }
    throw CodableException('Expected Float64List, found ${v.runtimeType}: $v');
  }
}

final class _TestMappedDecoder implements MappedDecoder {
  final Map<String, dynamic> _map;
  final _TestDecoder _rootDecoder;

  _TestMappedDecoder(this._map, this._rootDecoder);

  @override
  bool containsKey(String key) => _map.containsKey(key);

  @override
  bool containsStaticKey(StaticKey key) => _map.containsKey(key.name);

  @override
  int readInt(String key) {
    if (!_map.containsKey(key)) {
      throw CodableException('Missing required key "$key" in MappedDecoder');
    }
    final v = _map[key];
    if (v is int) return v;
    throw CodableException(
      'Expected int for key "$key", found ${v.runtimeType}: $v',
    );
  }

  @override
  int readIntKey(StaticKey key) => readInt(key.name);

  @override
  int? readNullableInt(String key) {
    if (!_map.containsKey(key) || _map[key] == null) return null;
    return readInt(key);
  }

  @override
  int? readNullableIntKey(StaticKey key) => readNullableInt(key.name);

  @override
  double readDouble(String key) {
    if (!_map.containsKey(key)) {
      throw CodableException('Missing required key "$key" in MappedDecoder');
    }
    final v = _map[key];
    if (v is num) return v.toDouble();
    throw CodableException(
      'Expected double for key "$key", found ${v.runtimeType}: $v',
    );
  }

  @override
  double readDoubleKey(StaticKey key) => readDouble(key.name);

  @override
  double? readNullableDouble(String key) {
    if (!_map.containsKey(key) || _map[key] == null) return null;
    return readDouble(key);
  }

  @override
  double? readNullableDoubleKey(StaticKey key) => readNullableDouble(key.name);

  @override
  String readString(String key) {
    if (!_map.containsKey(key)) {
      throw CodableException('Missing required key "$key" in MappedDecoder');
    }
    final v = _map[key];
    if (v is String) return v;
    throw CodableException(
      'Expected String for key "$key", found ${v.runtimeType}: $v',
    );
  }

  @override
  String readStringKey(StaticKey key) => readString(key.name);

  @override
  String? readNullableString(String key) {
    if (!_map.containsKey(key) || _map[key] == null) return null;
    return readString(key);
  }

  @override
  String? readNullableStringKey(StaticKey key) => readNullableString(key.name);

  @override
  bool readBool(String key) {
    if (!_map.containsKey(key)) {
      throw CodableException('Missing required key "$key" in MappedDecoder');
    }
    final v = _map[key];
    if (v is bool) return v;
    throw CodableException(
      'Expected bool for key "$key", found ${v.runtimeType}: $v',
    );
  }

  @override
  bool readBoolKey(StaticKey key) => readBool(key.name);

  @override
  bool? readNullableBool(String key) {
    if (!_map.containsKey(key) || _map[key] == null) return null;
    return readBool(key);
  }

  @override
  bool? readNullableBoolKey(StaticKey key) => readNullableBool(key.name);

  @override
  bool isNull(String key) => _map[key] == null;

  @override
  bool isNullKey(StaticKey key) => isNull(key.name);

  @override
  T decodeKey<T>(String key, DecoderCallback<T> decoder) {
    if (!_map.containsKey(key)) {
      throw CodableException('Missing required key "$key" in MappedDecoder');
    }
    return decoder(_TestDecoder(_map[key], userInfo: _rootDecoder.userInfo));
  }

  @override
  T decodeStaticKey<T>(StaticKey key, DecoderCallback<T> decoder) =>
      decodeKey(key.name, decoder);

  @override
  T? decodeNullableKey<T>(String key, DecoderCallback<T> decoder) {
    if (!_map.containsKey(key) || _map[key] == null) return null;
    return decodeKey(key, decoder);
  }

  @override
  T? decodeNullableStaticKey<T>(StaticKey key, DecoderCallback<T> decoder) =>
      decodeNullableKey(key.name, decoder);

  @override
  List<T> decodeListKey<T>(String key, DecoderCallback<T> decoder) {
    if (!_map.containsKey(key)) {
      throw CodableException('Missing required key "$key" in MappedDecoder');
    }
    final v = _map[key];
    if (v is List<dynamic>) {
      return v
          .map((e) => decoder(_TestDecoder(e, userInfo: _rootDecoder.userInfo)))
          .toList();
    }
    throw CodableException(
      'Expected List for key "$key", found ${v.runtimeType}',
    );
  }

  @override
  List<T> decodeListStaticKey<T>(StaticKey key, DecoderCallback<T> decoder) =>
      decodeListKey(key.name, decoder);

  @override
  List<int> decodeIntList(String key) {
    if (!_map.containsKey(key)) {
      throw CodableException('Missing required key "$key" in MappedDecoder');
    }
    final v = _map[key];
    if (v is List<dynamic>) {
      return v.map((e) => e as int).toList();
    }
    throw CodableException(
      'Expected List<int> for key "$key", found ${v.runtimeType}',
    );
  }

  @override
  List<int> decodeIntListKey(StaticKey key) => decodeIntList(key.name);

  @override
  List<double> decodeDoubleList(String key) {
    if (!_map.containsKey(key)) {
      throw CodableException('Missing required key "$key" in MappedDecoder');
    }
    final v = _map[key];
    if (v is List<dynamic>) {
      return v.map((e) => (e as num).toDouble()).toList();
    }
    throw CodableException(
      'Expected List<double> for key "$key", found ${v.runtimeType}',
    );
  }

  @override
  List<double> decodeDoubleListKey(StaticKey key) => decodeDoubleList(key.name);

  @override
  Float64List decodeFloat64List(String key) {
    if (!_map.containsKey(key)) {
      throw CodableException('Missing required key "$key" in MappedDecoder');
    }
    final v = _map[key];
    if (v is List<dynamic>) {
      final list = Float64List(v.length);
      for (var i = 0; i < v.length; i++) {
        list[i] = (v[i] as num).toDouble();
      }
      return list;
    }
    throw CodableException(
      'Expected Float64List for key "$key", found ${v.runtimeType}',
    );
  }

  @override
  Float64List decodeFloat64ListKey(StaticKey key) =>
      decodeFloat64List(key.name);

  @override
  List<String> decodeStringList(String key) {
    if (!_map.containsKey(key)) {
      throw CodableException('Missing required key "$key" in MappedDecoder');
    }
    final v = _map[key];
    if (v is List<dynamic>) {
      return v.map((e) => e as String).toList();
    }
    throw CodableException(
      'Expected List<String> for key "$key", found ${v.runtimeType}',
    );
  }

  @override
  List<String> decodeStringListKey(StaticKey key) => decodeStringList(key.name);

  @override
  List<bool> decodeBoolList(String key) {
    if (!_map.containsKey(key)) {
      throw CodableException('Missing required key "$key" in MappedDecoder');
    }
    final v = _map[key];
    if (v is List<dynamic>) {
      return v.map((e) => e as bool).toList();
    }
    throw CodableException(
      'Expected List<bool> for key "$key", found ${v.runtimeType}',
    );
  }

  @override
  List<bool> decodeBoolListKey(StaticKey key) => decodeBoolList(key.name);
}

final class _TestUnkeyedDecoder implements UnkeyedDecoder {
  final List<dynamic> _list;
  final _TestDecoder _rootDecoder;
  int _index = 0;

  _TestUnkeyedDecoder(this._list, this._rootDecoder);

  @override
  bool hasNext() => _index < _list.length;

  @override
  int readInt() {
    if (!hasNext()) {
      throw const CodableException('End of array in UnkeyedDecoder');
    }
    final v = _list[_index++];
    if (v is int) return v;
    throw CodableException('Expected int, found ${v.runtimeType}: $v');
  }

  @override
  int? readNullableInt() {
    if (!hasNext()) return null;
    if (_list[_index] == null) {
      _index++;
      return null;
    }
    return readInt();
  }

  @override
  double readDouble() {
    if (!hasNext()) {
      throw const CodableException('End of array in UnkeyedDecoder');
    }
    final v = _list[_index++];
    if (v is num) return v.toDouble();
    throw CodableException('Expected double/num, found ${v.runtimeType}: $v');
  }

  @override
  double? readNullableDouble() {
    if (!hasNext()) return null;
    if (_list[_index] == null) {
      _index++;
      return null;
    }
    return readDouble();
  }

  @override
  String readString() {
    if (!hasNext()) {
      throw const CodableException('End of array in UnkeyedDecoder');
    }
    final v = _list[_index++];
    if (v is String) return v;
    throw CodableException('Expected String, found ${v.runtimeType}: $v');
  }

  @override
  String? readNullableString() {
    if (!hasNext()) return null;
    if (_list[_index] == null) {
      _index++;
      return null;
    }
    return readString();
  }

  @override
  (int start, int end) readStringSpan() {
    throw UnsupportedError(
      'readStringSpan is not supported on _TestUnkeyedDecoder',
    );
  }

  @override
  (int start, int end)? readNullableStringSpan() {
    if (isNextNull()) return null;
    return readStringSpan();
  }

  @override
  bool readBool() {
    if (!hasNext()) {
      throw const CodableException('End of array in UnkeyedDecoder');
    }
    final v = _list[_index++];
    if (v is bool) return v;
    throw CodableException('Expected bool, found ${v.runtimeType}: $v');
  }

  @override
  bool? readNullableBool() {
    if (!hasNext()) return null;
    if (_list[_index] == null) {
      _index++;
      return null;
    }
    return readBool();
  }

  @override
  bool isNextNull() {
    if (!hasNext()) return false;
    return _list[_index] == null;
  }

  @override
  void readNull() {
    if (!hasNext()) {
      throw const CodableException('End of array in UnkeyedDecoder');
    }
    final v = _list[_index++];
    if (v != null) {
      throw CodableException('Expected null, found ${v.runtimeType}: $v');
    }
  }

  @override
  void skipElement() {
    if (hasNext()) _index++;
  }

  @override
  T decodeElement<T>(DecoderCallback<T> decoder) {
    if (!hasNext()) {
      throw const CodableException('End of array in UnkeyedDecoder');
    }
    final v = _list[_index++];
    return decoder(_TestDecoder(v, userInfo: _rootDecoder.userInfo));
  }

  @override
  T? decodeNullableElement<T>(DecoderCallback<T> decoder) {
    if (!hasNext()) return null;
    if (_list[_index] == null) {
      _index++;
      return null;
    }
    return decodeElement(decoder);
  }

  @override
  List<int> decodeIntList() {
    if (!hasNext()) {
      throw const CodableException('End of array in UnkeyedDecoder');
    }
    final v = _list[_index++];
    if (v is List<dynamic>) {
      return v.map((e) => e as int).toList();
    }
    throw CodableException('Expected List<int>, found ${v.runtimeType}');
  }

  @override
  List<double> decodeDoubleList() {
    if (!hasNext()) {
      throw const CodableException('End of array in UnkeyedDecoder');
    }
    final v = _list[_index++];
    if (v is List<dynamic>) {
      return v.map((e) => (e as num).toDouble()).toList();
    }
    throw CodableException('Expected List<double>, found ${v.runtimeType}');
  }

  @override
  Float64List decodeFloat64List() {
    if (!hasNext()) {
      throw const CodableException('End of array in UnkeyedDecoder');
    }
    final v = _list[_index++];
    if (v is List<dynamic>) {
      final list = Float64List(v.length);
      for (var i = 0; i < v.length; i++) {
        list[i] = (v[i] as num).toDouble();
      }
      return list;
    }
    throw CodableException('Expected Float64List, found ${v.runtimeType}');
  }
}

final class _TestSingleValueDecoder implements SingleValueDecoder {
  final Object? _value;
  final _TestDecoder _rootDecoder;

  _TestSingleValueDecoder(this._value, this._rootDecoder);

  @override
  int readInt() {
    final v = _value;
    if (v is int) return v;
    throw CodableException(
      'Expected int, found ${_value.runtimeType}: $_value',
    );
  }

  @override
  int? readNullableInt() {
    if (_value == null) return null;
    return readInt();
  }

  @override
  double readDouble() {
    final v = _value;
    if (v is num) return v.toDouble();
    throw CodableException(
      'Expected double/num, found ${_value.runtimeType}: $_value',
    );
  }

  @override
  double? readNullableDouble() {
    if (_value == null) return null;
    return readDouble();
  }

  @override
  String readString() {
    final v = _value;
    if (v is String) return v;
    throw CodableException(
      'Expected String, found ${_value.runtimeType}: $_value',
    );
  }

  @override
  String? readNullableString() {
    if (_value == null) return null;
    return readString();
  }

  @override
  (int start, int end) readStringSpan() {
    throw UnsupportedError(
      'readStringSpan is not supported on _TestSingleValueDecoder',
    );
  }

  @override
  (int start, int end)? readNullableStringSpan() {
    if (isNull()) return null;
    return readStringSpan();
  }

  @override
  bool readBool() {
    final v = _value;
    if (v is bool) return v;
    throw CodableException(
      'Expected bool, found ${_value.runtimeType}: $_value',
    );
  }

  @override
  bool? readNullableBool() {
    if (_value == null) return null;
    return readBool();
  }

  @override
  bool isNull() => _value == null;

  @override
  void readNull() {
    if (_value != null) {
      throw CodableException(
        'Expected null, found ${_value.runtimeType}: $_value',
      );
    }
  }

  @override
  T decode<T>(DecoderCallback<T> decoder) =>
      decoder(_TestDecoder(_value, userInfo: _rootDecoder.userInfo));

  @override
  T? decodeNullable<T>(DecoderCallback<T> decoder) {
    if (_value == null) return null;
    return decode(decoder);
  }
}

final class _TestEncoder implements Encoder {
  @override
  final Map<Object, Object?> userInfo;
  Object? output;

  _TestEncoder({this.userInfo = const {}});

  @override
  KeyedEncoder keyed({KeyOptions? options}) {
    final enc = _TestKeyedEncoder(this);
    output = enc._map;
    return enc;
  }

  @override
  UnkeyedEncoder unkeyed() {
    final enc = _TestUnkeyedEncoder(this);
    output = enc._list;
    return enc;
  }

  @override
  SingleValueEncoder singleValue() => _TestSingleValueEncoder(this);

  @override
  KeyedEncoder container({KeyOptions? options}) => keyed(options: options);

  @override
  UnkeyedEncoder unkeyedContainer() => unkeyed();

  @override
  SingleValueEncoder singleValueContainer() => singleValue();
}

final class _TestKeyedEncoder implements KeyedEncoder {
  final _TestEncoder _rootEncoder;
  final Map<String, dynamic> _map = {};

  _TestKeyedEncoder(this._rootEncoder);

  @override
  void encodeInt(String key, int value) => _map[key] = value;

  @override
  void encodeIntKey(StaticKey key, int value) => _map[key.name] = value;

  @override
  void encodeNullableInt(String key, int? value) => _map[key] = value;

  @override
  void encodeNullableIntKey(StaticKey key, int? value) =>
      _map[key.name] = value;

  @override
  void encodeDouble(String key, double value) => _map[key] = value;

  @override
  void encodeDoubleKey(StaticKey key, double value) => _map[key.name] = value;

  @override
  void encodeNullableDouble(String key, double? value) => _map[key] = value;

  @override
  void encodeNullableDoubleKey(StaticKey key, double? value) =>
      _map[key.name] = value;

  @override
  void encodeString(String key, String value) => _map[key] = value;

  @override
  void encodeStringKey(StaticKey key, String value) => _map[key.name] = value;

  @override
  void encodeNullableString(String key, String? value) => _map[key] = value;

  @override
  void encodeNullableStringKey(StaticKey key, String? value) =>
      _map[key.name] = value;

  @override
  void encodeBool(String key, bool value) => _map[key] = value;

  @override
  void encodeBoolKey(StaticKey key, bool value) => _map[key.name] = value;

  @override
  void encodeNullableBool(String key, bool? value) => _map[key] = value;

  @override
  void encodeNullableBoolKey(StaticKey key, bool? value) =>
      _map[key.name] = value;

  @override
  void encodeNull(String key) => _map[key] = null;

  @override
  void encodeNullKey(StaticKey key) => _map[key.name] = null;

  @override
  void encodeValue<T>(String key, T value, EncoderCallback<T> encode) {
    final child = _TestEncoder(userInfo: _rootEncoder.userInfo);
    encode(value, child);
    _map[key] = child.output;
  }

  @override
  void encodeValueKey<T>(StaticKey key, T value, EncoderCallback<T> encode) =>
      encodeValue(key.name, value, encode);

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
  ) => encodeNullableValue(key.name, value, encode);

  @override
  void encodeEncodable(String key, Encodable value) {
    final child = _TestEncoder(userInfo: _rootEncoder.userInfo);
    value.encode(child);
    _map[key] = child.output;
  }

  @override
  void encodeEncodableKey(StaticKey key, Encodable value) =>
      encodeEncodable(key.name, value);

  @override
  void encodeNullableEncodable(String key, Encodable? value) {
    if (value == null) {
      encodeNull(key);
    } else {
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
    final list = <dynamic>[];
    for (final el in elements) {
      final child = _TestEncoder(userInfo: _rootEncoder.userInfo);
      encode(el, child);
      list.add(child.output);
    }
    _map[key] = list;
  }

  @override
  void encodeListKey<T>(
    StaticKey key,
    Iterable<T> elements,
    EncoderCallback<T> encode,
  ) => encodeList(key.name, elements, encode);

  @override
  void encodeIntList(String key, List<int> values) =>
      _map[key] = List<int>.from(values);

  @override
  void encodeIntListKey(StaticKey key, List<int> values) =>
      encodeIntList(key.name, values);

  @override
  void encodeDoubleList(String key, List<double> values) =>
      _map[key] = List<double>.from(values);

  @override
  void encodeDoubleListKey(StaticKey key, List<double> values) =>
      encodeDoubleList(key.name, values);

  @override
  void encodeStringList(String key, List<String> values) =>
      _map[key] = List<String>.from(values);

  @override
  void encodeStringListKey(StaticKey key, List<String> values) =>
      encodeStringList(key.name, values);

  @override
  void encodeBoolList(String key, List<bool> values) =>
      _map[key] = List<bool>.from(values);

  @override
  void encodeBoolListKey(StaticKey key, List<bool> values) =>
      encodeBoolList(key.name, values);
}

final class _TestUnkeyedEncoder implements UnkeyedEncoder {
  final _TestEncoder _rootEncoder;
  final List<dynamic> _list = [];

  _TestUnkeyedEncoder(this._rootEncoder);

  @override
  void encodeInt(int value) => _list.add(value);

  @override
  void encodeNullableInt(int? value) => _list.add(value);

  @override
  void encodeDouble(double value) => _list.add(value);

  @override
  void encodeNullableDouble(double? value) => _list.add(value);

  @override
  void encodeString(String value) => _list.add(value);

  @override
  void encodeNullableString(String? value) => _list.add(value);

  @override
  void encodeBool(bool value) => _list.add(value);

  @override
  void encodeNullableBool(bool? value) => _list.add(value);

  @override
  void encodeNull() => _list.add(null);

  @override
  void encodeElement<T>(T value, EncoderCallback<T> encode) {
    final child = _TestEncoder(userInfo: _rootEncoder.userInfo);
    encode(value, child);
    _list.add(child.output);
  }

  @override
  void encodeNullableElement<T>(T? value, EncoderCallback<T> encode) {
    if (value == null) {
      encodeNull();
    } else {
      encodeElement(value, encode);
    }
  }

  @override
  void encodeEncodable(Encodable value) {
    final child = _TestEncoder(userInfo: _rootEncoder.userInfo);
    value.encode(child);
    _list.add(child.output);
  }

  @override
  void encodeNullableEncodable(Encodable? value) {
    if (value == null) {
      encodeNull();
    } else {
      encodeEncodable(value);
    }
  }

  @override
  void encodeList<T>(Iterable<T> elements, EncoderCallback<T> encode) {
    for (final el in elements) {
      encodeElement(el, encode);
    }
  }
}

final class _TestSingleValueEncoder implements SingleValueEncoder {
  final _TestEncoder _rootEncoder;

  _TestSingleValueEncoder(this._rootEncoder);

  @override
  void encodeInt(int value) => _rootEncoder.output = value;

  @override
  void encodeNullableInt(int? value) => _rootEncoder.output = value;

  @override
  void encodeDouble(double value) => _rootEncoder.output = value;

  @override
  void encodeNullableDouble(double? value) => _rootEncoder.output = value;

  @override
  void encodeString(String value) => _rootEncoder.output = value;

  @override
  void encodeNullableString(String? value) => _rootEncoder.output = value;

  @override
  void encodeBool(bool value) => _rootEncoder.output = value;

  @override
  void encodeNullableBool(bool? value) => _rootEncoder.output = value;

  @override
  void encodeNull() => _rootEncoder.output = null;

  @override
  void encode<T>(T value, EncoderCallback<T> encode) {
    final child = _TestEncoder(userInfo: _rootEncoder.userInfo);
    encode(value, child);
    _rootEncoder.output = child.output;
  }

  @override
  void encodeNullable<T>(T? value, EncoderCallback<T> encode) {
    if (value == null) {
      encodeNull();
    } else {
      this.encode(value, encode);
    }
  }

  @override
  void encodeEncodable(Encodable value) {
    final child = _TestEncoder(userInfo: _rootEncoder.userInfo);
    value.encode(child);
    _rootEncoder.output = child.output;
  }

  @override
  void encodeNullableEncodable(Encodable? value) {
    if (value == null) {
      encodeNull();
    } else {
      encodeEncodable(value);
    }
  }
}

/// Mock test format driver facade.
abstract final class TestJsonDriver {
  static T decodeString<T>(
    String jsonString,
    T Function(Decoder decoder) decode, {
    Map<Object, Object?>? userInfo,
  }) {
    final Object? parsed = jsonDecode(jsonString);
    return decode(_TestDecoder(parsed, userInfo: userInfo ?? const {}));
  }

  static T decodeBytes<T>(
    Uint8List bytes,
    T Function(Decoder decoder) decode, {
    Map<Object, Object?>? userInfo,
  }) {
    final jsonString = utf8.decode(bytes);
    return decodeString(jsonString, decode, userInfo: userInfo);
  }

  static String encodeToString(
    Encodable encodable, {
    Map<Object, Object?>? userInfo,
  }) {
    final encoder = _TestEncoder(userInfo: userInfo ?? const {});
    encodable.encode(encoder);
    return jsonEncode(encoder.output);
  }

  static Uint8List encodeToBytes(
    Encodable encodable, {
    Map<Object, Object?>? userInfo,
  }) {
    final str = encodeToString(encodable, userInfo: userInfo);
    return Uint8List.fromList(utf8.encode(str));
  }

  static String encodeWithToString<T>(
    T value,
    void Function(T value, Encoder encoder) encode, {
    Map<Object, Object?>? userInfo,
  }) {
    final encoder = _TestEncoder(userInfo: userInfo ?? const {});
    encode(value, encoder);
    return jsonEncode(encoder.output);
  }

  static Uint8List encodeWithToBytes<T>(
    T value,
    void Function(T value, Encoder encoder) encode, {
    Map<Object, Object?>? userInfo,
  }) {
    final str = encodeWithToString(value, encode, userInfo: userInfo);
    return Uint8List.fromList(utf8.encode(str));
  }
}

// ============================================================================
// Canonical Domain Model Implementations
// ============================================================================

/// Model 1: High-Throughput Primitive Model with Float Streaming and Key Aliasing.
@Codable()
class Coordinate implements Encodable {
  @CodableKey(aliases: ['lat'])
  final double latitude;

  @CodableKey(aliases: ['lon'])
  final double longitude;

  const Coordinate({required this.latitude, required this.longitude});

  static Coordinate fromReader(JsonTokenReader reader) =>
      _$CoordinateFromReader(reader);
  void toWriter(JsonTokenWriter writer) => _$CoordinateToWriter(this, writer);

  static Coordinate decodeFromReader(JsonTokenReader reader) =>
      _$CoordinateFromReader(reader);
  void encodeToWriter(JsonTokenWriter writer) =>
      _$CoordinateToWriter(this, writer);

  static Coordinate decode(Decoder decoder) {
    if (decoder is JsonCodableDecoder) {
      return _$CoordinateFromReader(decoder.reader);
    }
    final keyed = decoder.keyed();
    double? lat;
    double? lon;

    while (keyed.hasNextKey()) {
      switch (keyed.nextKey()) {
        case 'latitude':
        case 'lat':
          lat = keyed.readDouble();
          break;
        case 'longitude':
        case 'lon':
          lon = keyed.readDouble();
          break;
        default:
          keyed.skipValue();
          break;
      }
    }

    if (lat == null || lon == null) {
      throw const CodableException('Missing required fields for Coordinate');
    }
    return Coordinate(latitude: lat, longitude: lon);
  }

  @override
  void encode(Encoder encoder) {
    final keyed = encoder.keyed();
    keyed.encodeDouble('latitude', latitude);
    keyed.encodeDouble('longitude', longitude);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Coordinate &&
          latitude == other.latitude &&
          longitude == other.longitude;

  @override
  int get hashCode => Object.hash(latitude, longitude);

  @override
  String toString() => 'Coordinate(lat: $latitude, lon: $longitude)';
}

/// User roles supported by UserProfile.
enum UserRole {
  admin,
  member,
  guest;

  static UserRole fromString(String value) => switch (value) {
    'admin' => UserRole.admin,
    'member' => UserRole.member,
    'guest' => UserRole.guest,
    _ => throw CodableException('Unknown UserRole: $value'),
  };
}

/// Custom field decoder normalizing zip codes from int (90210) or string ("90210").
class ZipCodeDecoder implements CustomFieldDecoder<String> {
  const ZipCodeDecoder();

  String decodeFromReader(JsonTokenReader reader) {
    if (reader.isNextNull()) {
      reader.readNull();
      return '';
    }
    final token = reader.peek();
    if (token == JsonTokenType.number) {
      return reader.readInt().toString();
    }
    return reader.readString();
  }

  void encodeToWriter(String value, JsonTokenWriter writer) {
    final asInt = int.tryParse(value);
    if (asInt != null) {
      writer.writeInt(asInt);
    } else {
      writer.writeString(value);
    }
  }

  @override
  String decodeField(Decoder decoder) {
    if (decoder is JsonCodableDecoder) {
      return decodeFromReader(decoder.reader);
    }
    final single = decoder.singleValue();
    try {
      return single.readString();
    } catch (_) {
      return single.readInt().toString();
    }
  }
}

/// Model 2: Complex Domain Model with Enum, CustomFieldDecoder & Golden Mask validation.
@Codable()
class UserProfile implements Encodable {
  final String id;
  final String email;
  final UserRole role;
  @CodableKey(customDecoder: ZipCodeDecoder())
  final String zip;
  final List<String> tags;

  const UserProfile({
    required this.id,
    required this.email,
    required this.role,
    required this.zip,
    this.tags = const [],
  });

  static UserProfile fromReader(JsonTokenReader reader) =>
      _$UserProfileFromReader(reader);
  void toWriter(JsonTokenWriter writer) => _$UserProfileToWriter(this, writer);

  static UserProfile decodeFromReader(JsonTokenReader reader) =>
      _$UserProfileFromReader(reader);
  void encodeToWriter(JsonTokenWriter writer) =>
      _$UserProfileToWriter(this, writer);

  static UserProfile decode(Decoder decoder) {
    if (decoder is JsonCodableDecoder) {
      return _$UserProfileFromReader(decoder.reader);
    }
    final keyed = decoder.keyed();
    String? id;
    String? email;
    UserRole? role;
    String? zip;
    var tags = const <String>[];

    var seen = 0;
    const goldenMask = 0x0F; // id(0x1) | email(0x2) | role(0x4) | zip(0x8)

    while (keyed.hasNextKey()) {
      switch (keyed.nextKey()) {
        case 'id':
          id = keyed.readString();
          seen |= 0x01;
          break;
        case 'email':
          email = keyed.readString();
          seen |= 0x02;
          break;
        case 'role':
          role = UserRole.fromString(keyed.readString());
          seen |= 0x04;
          break;
        case 'zip':
          zip = const ZipCodeDecoder().decodeField(decoder);
          seen |= 0x08;
          break;
        case 'tags':
          tags = keyed.decodeStringList();
          break;
        default:
          keyed.skipValue();
          break;
      }
    }

    if (seen != goldenMask) {
      throw const CodableException('Missing required fields for UserProfile');
    }

    return UserProfile(
      id: id!,
      email: email!,
      role: role!,
      zip: zip!,
      tags: tags,
    );
  }

  @override
  void encode(Encoder encoder) {
    final keyed = encoder.keyed();
    keyed.encodeString('id', id);
    keyed.encodeString('email', email);
    keyed.encodeString('role', role.name);
    keyed.encodeString('zip', zip);
    if (tags.isNotEmpty) {
      keyed.encodeStringList('tags', tags);
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProfile &&
          id == other.id &&
          email == other.email &&
          role == other.role &&
          zip == other.zip;

  @override
  int get hashCode => Object.hash(id, email, role, zip);

  @override
  String toString() =>
      'UserProfile(id: $id, email: $email, role: $role, zip: $zip, tags: $tags)';
}

/// Model 3: Tagged Polymorphic Hierarchy Base Class.
abstract class Vehicle implements Encodable {
  final String type;
  final int maxSpeed;

  const Vehicle({required this.type, required this.maxSpeed});

  static Vehicle decode(Decoder decoder) {
    final mapped = decoder.mapped();
    if (!mapped.containsKey('type')) {
      throw const CodableException(
        'Missing discriminator key "type" for Vehicle',
      );
    }
    final type = mapped.readString('type');
    return switch (type) {
      'car' => Car.decode(decoder),
      'bicycle' => Bicycle.decode(decoder),
      _ => throw CodableException('Unknown vehicle type: $type'),
    };
  }
}

/// Concrete Subtype 1: Car.
@Codable()
class Car extends Vehicle {
  final int doors;

  const Car({required super.maxSpeed, required this.doors})
    : super(type: 'car');

  static Car fromReader(JsonTokenReader reader) => _$CarFromReader(reader);
  void toWriter(JsonTokenWriter writer) => _$CarToWriter(this, writer);

  static Car decode(Decoder decoder) {
    if (decoder is JsonCodableDecoder) {
      return _$CarFromReader(decoder.reader);
    }
    final keyed = decoder.keyed();
    int? maxSpeed;
    int? doors;

    while (keyed.hasNextKey()) {
      switch (keyed.nextKey()) {
        case 'type':
          keyed.readString(); // Consume discriminator
          break;
        case 'maxSpeed':
          maxSpeed = keyed.readInt();
          break;
        case 'doors':
          doors = keyed.readInt();
          break;
        default:
          keyed.skipValue();
          break;
      }
    }
    if (maxSpeed == null || doors == null) {
      throw const CodableException('Missing required fields for Car');
    }
    return Car(maxSpeed: maxSpeed, doors: doors);
  }

  @override
  void encode(Encoder encoder) {
    final keyed = encoder.keyed();
    keyed.encodeString('type', type);
    keyed.encodeInt('maxSpeed', maxSpeed);
    keyed.encodeInt('doors', doors);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Car && maxSpeed == other.maxSpeed && doors == other.doors;

  @override
  int get hashCode => Object.hash(type, maxSpeed, doors);

  @override
  String toString() => 'Car(maxSpeed: $maxSpeed, doors: $doors)';
}

/// Concrete Subtype 2: Bicycle.
@Codable()
class Bicycle extends Vehicle {
  final bool hasBell;

  const Bicycle({required super.maxSpeed, required this.hasBell})
    : super(type: 'bicycle');

  static Bicycle fromReader(JsonTokenReader reader) =>
      _$BicycleFromReader(reader);
  void toWriter(JsonTokenWriter writer) => _$BicycleToWriter(this, writer);

  static Bicycle decode(Decoder decoder) {
    if (decoder is JsonCodableDecoder) {
      return _$BicycleFromReader(decoder.reader);
    }
    final keyed = decoder.keyed();
    int? maxSpeed;
    bool? hasBell;

    while (keyed.hasNextKey()) {
      switch (keyed.nextKey()) {
        case 'type':
          keyed.readString();
          break;
        case 'maxSpeed':
          maxSpeed = keyed.readInt();
          break;
        case 'hasBell':
          hasBell = keyed.readBool();
          break;
        default:
          keyed.skipValue();
          break;
      }
    }
    if (maxSpeed == null || hasBell == null) {
      throw const CodableException('Missing required fields for Bicycle');
    }
    return Bicycle(maxSpeed: maxSpeed, hasBell: hasBell);
  }

  @override
  void encode(Encoder encoder) {
    final keyed = encoder.keyed();
    keyed.encodeString('type', type);
    keyed.encodeInt('maxSpeed', maxSpeed);
    keyed.encodeBool('hasBell', hasBell);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Bicycle &&
          maxSpeed == other.maxSpeed &&
          hasBell == other.hasBell;

  @override
  int get hashCode => Object.hash(type, maxSpeed, hasBell);

  @override
  String toString() => 'Bicycle(maxSpeed: $maxSpeed, hasBell: $hasBell)';
}

/// Tagged polymorphic descriptor registry.
class VehicleSuperDecodable implements SuperDecodable<Vehicle> {
  const VehicleSuperDecodable();

  @override
  String get discriminatorKey => 'type';

  @override
  Map<String, Vehicle Function(Decoder decoder)> get subtypes => {
    'car': Car.decode,
    'bicycle': Bicycle.decode,
  };
}

/// Nested location model for pairwise testing.
@Codable()
class UserWithLocation implements Encodable {
  final UserProfile profile;
  final Coordinate location;

  const UserWithLocation({required this.profile, required this.location});

  static UserWithLocation fromReader(JsonTokenReader reader) =>
      _$UserWithLocationFromReader(reader);
  void toWriter(JsonTokenWriter writer) =>
      _$UserWithLocationToWriter(this, writer);

  static UserWithLocation decode(Decoder decoder) {
    if (decoder is JsonCodableDecoder) {
      return _$UserWithLocationFromReader(decoder.reader);
    }
    final keyed = decoder.keyed();
    UserProfile? profile;
    Coordinate? location;

    while (keyed.hasNextKey()) {
      switch (keyed.nextKey()) {
        case 'profile':
          profile = keyed.decodeValue(UserProfile.decode);
          break;
        case 'location':
          location = keyed.decodeValue(Coordinate.decode);
          break;
        default:
          keyed.skipValue();
          break;
      }
    }
    if (profile == null || location == null) {
      throw const CodableException('Missing fields for UserWithLocation');
    }
    return UserWithLocation(profile: profile, location: location);
  }

  @override
  void encode(Encoder encoder) {
    final keyed = encoder.keyed();
    keyed.encodeValue('profile', profile, (p, e) => p.encode(e));
    keyed.encodeValue('location', location, (l, e) => l.encode(e));
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserWithLocation &&
          profile == other.profile &&
          location == other.location;

  @override
  int get hashCode => Object.hash(profile, location);
}

// ============================================================================
// MAIN TEST SUITE: Domain Models & Roundtrip Validation
// ============================================================================

void main() {
  group('Domain Model: Coordinate', () {
    group('Tier 1: Happy Path & Feature Coverage', () {
      test('decodes Coordinate with standard latitude and longitude keys', () {
        const jsonStr = '{"latitude": 37.7749, "longitude": -122.4194}';
        final coord = TestJsonDriver.decodeString(jsonStr, Coordinate.decode);

        check(coord.latitude).equals(37.7749);
        check(coord.longitude).equals(-122.4194);
      });

      test('decodes Coordinate with aliased lat and lon keys', () {
        const jsonStr = '{"lat": 51.5074, "lon": -0.1278}';
        final coord = TestJsonDriver.decodeString(jsonStr, Coordinate.decode);

        check(coord.latitude).equals(51.5074);
        check(coord.longitude).equals(-0.1278);
      });

      test('decodes Coordinate with mixed keys: latitude and lon', () {
        const jsonStr = '{"latitude": 40.7128, "lon": -74.0060}';
        final coord = TestJsonDriver.decodeString(jsonStr, Coordinate.decode);

        check(coord.latitude).equals(40.7128);
        check(coord.longitude).equals(-74.0060);
      });

      test('decodes Coordinate with mixed keys: lat and longitude', () {
        const jsonStr = '{"lat": 35.6762, "longitude": 139.6503}';
        final coord = TestJsonDriver.decodeString(jsonStr, Coordinate.decode);

        check(coord.latitude).equals(35.6762);
        check(coord.longitude).equals(139.6503);
      });

      test(
        'encodes Coordinate to standard latitude and longitude keys in JSON',
        () {
          const coord = Coordinate(latitude: 48.8566, longitude: 2.3522);
          final jsonStr = TestJsonDriver.encodeToString(coord);
          final decodedMap = jsonDecode(jsonStr) as Map<String, dynamic>;

          check(decodedMap['latitude']).equals(48.8566);
          check(decodedMap['longitude']).equals(2.3522);
        },
      );

      test('Coordinate value equality and hashCode consistency', () {
        const coord1 = Coordinate(latitude: 37.7749, longitude: -122.4194);
        const coord2 = Coordinate(latitude: 37.7749, longitude: -122.4194);
        const coord3 = Coordinate(latitude: 37.7750, longitude: -122.4194);

        check(coord1 == coord2).isTrue();
        check(coord1 == coord3).isFalse();
        check(coord1.hashCode).equals(coord2.hashCode);
        check(coord1.toString()).contains('37.7749');
      });
    });

    group('Tier 2: Boundary, Edge Cases & Error Handling', () {
      test('throws CodableException when latitude / lat is missing', () {
        const jsonStr = '{"longitude": -122.4194}';
        check(
          () => TestJsonDriver.decodeString(jsonStr, Coordinate.decode),
        ).throws<CodableException>();
      });

      test('throws CodableException when longitude / lon is missing', () {
        const jsonStr = '{"latitude": 37.7749}';
        check(
          () => TestJsonDriver.decodeString(jsonStr, Coordinate.decode),
        ).throws<CodableException>();
      });

      test('throws CodableException when empty object is provided', () {
        const jsonStr = '{}';
        check(
          () => TestJsonDriver.decodeString(jsonStr, Coordinate.decode),
        ).throws<CodableException>();
      });

      test('decodes Coordinate when lon key appears before lat key', () {
        const jsonStr = '{"lon": -122.4194, "lat": 37.7749}';
        final coord = TestJsonDriver.decodeString(jsonStr, Coordinate.decode);

        check(coord.latitude).equals(37.7749);
        check(coord.longitude).equals(-122.4194);
      });

      test(
        'skips unknown extra fields (altitude, accuracy, timestamp) cleanly',
        () {
          const jsonStr =
              '{"altitude": 150.5, "accuracy": 5, "lat": 37.7749, "timestamp": 1690000000, "lon": -122.4194}';
          final coord = TestJsonDriver.decodeString(jsonStr, Coordinate.decode);

          check(coord.latitude).equals(37.7749);
          check(coord.longitude).equals(-122.4194);
        },
      );

      test('decodes Coordinate with zero values (0.0, 0.0)', () {
        const jsonStr = '{"lat": 0.0, "lon": 0.0}';
        final coord = TestJsonDriver.decodeString(jsonStr, Coordinate.decode);

        check(coord.latitude).equals(0.0);
        check(coord.longitude).equals(0.0);
      });

      test('decodes Coordinate with negative zero (-0.0, -0.0)', () {
        const jsonStr = '{"latitude": -0.0, "longitude": -0.0}';
        final coord = TestJsonDriver.decodeString(jsonStr, Coordinate.decode);

        check(coord.latitude).equals(-0.0);
        check(coord.longitude).equals(-0.0);
      });

      test(
        'decodes Coordinate with boundary values (-90.0, 90.0, -180.0, 180.0)',
        () {
          const jsonStr = '{"lat": -90.0, "lon": 180.0}';
          final coord = TestJsonDriver.decodeString(jsonStr, Coordinate.decode);

          check(coord.latitude).equals(-90.0);
          check(coord.longitude).equals(180.0);
        },
      );

      test('decodes Coordinate with high precision float values', () {
        const jsonStr =
            '{"lat": 37.77492928374619, "lon": -122.41941558273618}';
        final coord = TestJsonDriver.decodeString(jsonStr, Coordinate.decode);

        check(coord.latitude).equals(37.77492928374619);
        check(coord.longitude).equals(-122.41941558273618);
      });

      test('throws CodableException when latitude value is string', () {
        const jsonStr = '{"lat": "37.7749", "lon": -122.4194}';
        check(
          () => TestJsonDriver.decodeString(jsonStr, Coordinate.decode),
        ).throws<CodableException>();
      });

      test('throws CodableException when latitude value is null', () {
        const jsonStr = '{"lat": null, "lon": -122.4194}';
        check(
          () => TestJsonDriver.decodeString(jsonStr, Coordinate.decode),
        ).throws<CodableException>();
      });

      test('throws CodableException when longitude value is boolean', () {
        const jsonStr = '{"lat": 37.7749, "lon": true}';
        check(
          () => TestJsonDriver.decodeString(jsonStr, Coordinate.decode),
        ).throws<CodableException>();
      });
    });
  });

  group('Domain Model: UserProfile & Validation', () {
    group('Tier 1: Happy Path & Feature Coverage', () {
      test('decodes UserProfile with all standard fields and tags', () {
        const jsonStr =
            '{"id": "usr_101", "email": "alice@example.com", "role": "admin", "zip": "90210", "tags": ["lead", "eng"]}';
        final profile = TestJsonDriver.decodeString(
          jsonStr,
          UserProfile.decode,
        );

        check(profile.id).equals('usr_101');
        check(profile.email).equals('alice@example.com');
        check(profile.role).equals(UserRole.admin);
        check(profile.zip).equals('90210');
        check(profile.tags).deepEquals(['lead', 'eng']);
      });

      test('decodes UserProfile with empty tags list', () {
        const jsonStr =
            '{"id": "usr_102", "email": "bob@example.com", "role": "member", "zip": "10001", "tags": []}';
        final profile = TestJsonDriver.decodeString(
          jsonStr,
          UserProfile.decode,
        );

        check(profile.tags).isEmpty();
      });

      test('decodes UserProfile with omitted tags field defaulting to empty', () {
        const jsonStr =
            '{"id": "usr_103", "email": "carol@example.com", "role": "guest", "zip": "SW1A 1AA"}';
        final profile = TestJsonDriver.decodeString(
          jsonStr,
          UserProfile.decode,
        );

        check(profile.tags).isEmpty();
        check(profile.role).equals(UserRole.guest);
        check(profile.zip).equals('SW1A 1AA');
      });

      test('decodes all UserRole enum variants correctly', () {
        check(UserRole.fromString('admin')).equals(UserRole.admin);
        check(UserRole.fromString('member')).equals(UserRole.member);
        check(UserRole.fromString('guest')).equals(UserRole.guest);
      });

      test('ZipCodeDecoder normalizes integer 90210 to string "90210"', () {
        const jsonStr =
            '{"id": "usr_104", "email": "dan@example.com", "role": "member", "zip": 90210}';
        final profile = TestJsonDriver.decodeString(
          jsonStr,
          UserProfile.decode,
        );

        check(profile.zip).equals('90210');
      });

      test('ZipCodeDecoder normalizes string "90210" to string "90210"', () {
        const jsonStr =
            '{"id": "usr_105", "email": "eve@example.com", "role": "member", "zip": "90210"}';
        final profile = TestJsonDriver.decodeString(
          jsonStr,
          UserProfile.decode,
        );

        check(profile.zip).equals('90210');
      });

      test('ZipCodeDecoder normalizes alphanumeric postal code "EC1A 1BB"', () {
        const jsonStr =
            '{"id": "usr_106", "email": "frank@example.co.uk", "role": "guest", "zip": "EC1A 1BB"}';
        final profile = TestJsonDriver.decodeString(
          jsonStr,
          UserProfile.decode,
        );

        check(profile.zip).equals('EC1A 1BB');
      });

      test('encodes UserProfile with tags populated', () {
        const profile = UserProfile(
          id: 'usr_201',
          email: 'grace@example.com',
          role: UserRole.admin,
          zip: '94105',
          tags: ['security', 'core'],
        );
        final jsonStr = TestJsonDriver.encodeToString(profile);
        final decodedMap = jsonDecode(jsonStr) as Map<String, dynamic>;

        check(decodedMap['id']).equals('usr_201');
        check(decodedMap['email']).equals('grace@example.com');
        check(decodedMap['role']).equals('admin');
        check(decodedMap['zip']).equals('94105');
        check(
          (decodedMap['tags'] as List<dynamic>).cast<String>(),
        ).deepEquals(['security', 'core']);
      });

      test('encodes UserProfile with empty tags omitting tags key', () {
        const profile = UserProfile(
          id: 'usr_202',
          email: 'heidi@example.com',
          role: UserRole.member,
          zip: '94105',
          tags: [],
        );
        final jsonStr = TestJsonDriver.encodeToString(profile);
        final decodedMap = jsonDecode(jsonStr) as Map<String, dynamic>;

        check(decodedMap.containsKey('tags')).isFalse();
      });

      test('UserProfile equality and hashCode consistency', () {
        const p1 = UserProfile(
          id: 'usr_1',
          email: 'test@a.com',
          role: UserRole.admin,
          zip: '11111',
        );
        const p2 = UserProfile(
          id: 'usr_1',
          email: 'test@a.com',
          role: UserRole.admin,
          zip: '11111',
        );
        const p3 = UserProfile(
          id: 'usr_2',
          email: 'test@a.com',
          role: UserRole.admin,
          zip: '11111',
        );

        check(p1 == p2).isTrue();
        check(p1 == p3).isFalse();
        check(p1.hashCode).equals(p2.hashCode);
        check(p1.toString()).contains('usr_1');
      });
    });

    group('Tier 2: Golden Mask Bitmask Validation & Error Handling', () {
      test('Golden Mask throws CodableException when id is missing', () {
        const jsonStr = '{"email": "a@b.com", "role": "admin", "zip": "90210"}';
        check(
          () => TestJsonDriver.decodeString(jsonStr, UserProfile.decode),
        ).throws<CodableException>();
      });

      test('Golden Mask throws CodableException when email is missing', () {
        const jsonStr = '{"id": "usr_1", "role": "admin", "zip": "90210"}';
        check(
          () => TestJsonDriver.decodeString(jsonStr, UserProfile.decode),
        ).throws<CodableException>();
      });

      test('Golden Mask throws CodableException when role is missing', () {
        const jsonStr = '{"id": "usr_1", "email": "a@b.com", "zip": "90210"}';
        check(
          () => TestJsonDriver.decodeString(jsonStr, UserProfile.decode),
        ).throws<CodableException>();
      });

      test('Golden Mask throws CodableException when zip is missing', () {
        const jsonStr = '{"id": "usr_1", "email": "a@b.com", "role": "admin"}';
        check(
          () => TestJsonDriver.decodeString(jsonStr, UserProfile.decode),
        ).throws<CodableException>();
      });

      test(
        'Golden Mask throws CodableException when multiple required fields are missing',
        () {
          const jsonStr = '{"id": "usr_1"}';
          check(
            () => TestJsonDriver.decodeString(jsonStr, UserProfile.decode),
          ).throws<CodableException>();
        },
      );

      test('Golden Mask throws CodableException on empty payload', () {
        const jsonStr = '{}';
        check(
          () => TestJsonDriver.decodeString(jsonStr, UserProfile.decode),
        ).throws<CodableException>();
      });

      test('throws CodableException for unknown UserRole string', () {
        const jsonStr =
            '{"id": "usr_1", "email": "a@b.com", "role": "superuser", "zip": "90210"}';
        check(
          () => TestJsonDriver.decodeString(jsonStr, UserProfile.decode),
        ).throws<CodableException>();
      });

      test('ZipCodeDecoder throws CodableException for boolean zip code', () {
        const jsonStr =
            '{"id": "usr_1", "email": "a@b.com", "role": "admin", "zip": true}';
        check(
          () => TestJsonDriver.decodeString(jsonStr, UserProfile.decode),
        ).throws<CodableException>();
      });

      test('ZipCodeDecoder throws CodableException for null zip code', () {
        const jsonStr =
            '{"id": "usr_1", "email": "a@b.com", "role": "admin", "zip": null}';
        check(
          () => TestJsonDriver.decodeString(jsonStr, UserProfile.decode),
        ).throws<CodableException>();
      });

      test('ZipCodeDecoder throws CodableException for array zip code', () {
        const jsonStr =
            '{"id": "usr_1", "email": "a@b.com", "role": "admin", "zip": [90210]}';
        check(
          () => TestJsonDriver.decodeString(jsonStr, UserProfile.decode),
        ).throws<CodableException>();
      });

      test('ZipCodeDecoder throws CodableException for object zip code', () {
        const jsonStr =
            '{"id": "usr_1", "email": "a@b.com", "role": "admin", "zip": {"code": 90210}}';
        check(
          () => TestJsonDriver.decodeString(jsonStr, UserProfile.decode),
        ).throws<CodableException>();
      });

      test(
        'skips unknown extra keys (age, bio, preferences) while satisfying Golden Mask',
        () {
          const jsonStr =
              '{"age": 30, "id": "usr_1", "bio": "engineer", "email": "a@b.com", "preferences": {"dark_mode": true}, "role": "member", "zip": 90210}';
          final profile = TestJsonDriver.decodeString(
            jsonStr,
            UserProfile.decode,
          );

          check(profile.id).equals('usr_1');
          check(profile.email).equals('a@b.com');
          check(profile.role).equals(UserRole.member);
          check(profile.zip).equals('90210');
        },
      );

      test(
        'decodes tags with special characters and multi-byte UTF-8 emojis',
        () {
          final tagsList = ['tag/1', 'tag 2', '🚀 launch', '🏷️ label'];
          final jsonStr = jsonEncode({
            'id': 'usr_999',
            'email': 'unicode@example.com',
            'role': 'admin',
            'zip': '12345',
            'tags': tagsList,
          });
          final bytes = Uint8List.fromList(utf8.encode(jsonStr));
          final profile = TestJsonDriver.decodeBytes(bytes, UserProfile.decode);

          check(profile.tags).deepEquals(tagsList);
        },
      );
    });
  });

  group('Domain Model: Vehicle Polymorphic Hierarchy', () {
    group('Tier 1: Happy Path & Polymorphic Dispatch', () {
      test('decodes Car subtype via Vehicle.decode with type="car"', () {
        const jsonStr = '{"type": "car", "maxSpeed": 220, "doors": 4}';
        final vehicle = TestJsonDriver.decodeString(jsonStr, Vehicle.decode);

        check(vehicle).isA<Car>();
        final car = vehicle as Car;
        check(car.type).equals('car');
        check(car.maxSpeed).equals(220);
        check(car.doors).equals(4);
      });

      test(
        'decodes Bicycle subtype via Vehicle.decode with type="bicycle"',
        () {
          const jsonStr =
              '{"type": "bicycle", "maxSpeed": 45, "hasBell": true}';
          final vehicle = TestJsonDriver.decodeString(jsonStr, Vehicle.decode);

          check(vehicle).isA<Bicycle>();
          final bike = vehicle as Bicycle;
          check(bike.type).equals('bicycle');
          check(bike.maxSpeed).equals(45);
          check(bike.hasBell).isTrue();
        },
      );

      test('direct Car.decode decodes doors and maxSpeed', () {
        const jsonStr = '{"type": "car", "maxSpeed": 180, "doors": 2}';
        final car = TestJsonDriver.decodeString(jsonStr, Car.decode);

        check(car.maxSpeed).equals(180);
        check(car.doors).equals(2);
      });

      test('direct Bicycle.decode decodes hasBell and maxSpeed', () {
        const jsonStr = '{"type": "bicycle", "maxSpeed": 30, "hasBell": false}';
        final bike = TestJsonDriver.decodeString(jsonStr, Bicycle.decode);

        check(bike.maxSpeed).equals(30);
        check(bike.hasBell).isFalse();
      });

      test('encodes Car to JSON with type="car", maxSpeed, and doors', () {
        const car = Car(maxSpeed: 200, doors: 4);
        final jsonStr = TestJsonDriver.encodeToString(car);
        final decodedMap = jsonDecode(jsonStr) as Map<String, dynamic>;

        check(decodedMap['type']).equals('car');
        check(decodedMap['maxSpeed']).equals(200);
        check(decodedMap['doors']).equals(4);
      });

      test(
        'encodes Bicycle to JSON with type="bicycle", maxSpeed, and hasBell',
        () {
          const bike = Bicycle(maxSpeed: 35, hasBell: true);
          final jsonStr = TestJsonDriver.encodeToString(bike);
          final decodedMap = jsonDecode(jsonStr) as Map<String, dynamic>;

          check(decodedMap['type']).equals('bicycle');
          check(decodedMap['maxSpeed']).equals(35);
          check(decodedMap['hasBell']).equals(true);
        },
      );

      test('Car and Bicycle value equality and hashCode consistency', () {
        const car1 = Car(maxSpeed: 200, doors: 4);
        const car2 = Car(maxSpeed: 200, doors: 4);
        const car3 = Car(maxSpeed: 200, doors: 2);
        const bike1 = Bicycle(maxSpeed: 35, hasBell: true);
        const bike2 = Bicycle(maxSpeed: 35, hasBell: true);

        check(car1 == car2).isTrue();
        check(car1 == car3).isFalse();
        check(car1.hashCode).equals(car2.hashCode);
        check(bike1 == bike2).isTrue();
        check(bike1.hashCode).equals(bike2.hashCode);
      });

      test(
        'VehicleSuperDecodable exposes discriminatorKey and subtype decoders',
        () {
          const superDecodable = VehicleSuperDecodable();

          check(superDecodable.discriminatorKey).equals('type');
          check(
            superDecodable.subtypes.keys.toList(),
          ).deepEquals(['car', 'bicycle']);
        },
      );
    });

    group('Tier 2: Boundary, Discriminator Position & Error Handling', () {
      test(
        'Vehicle.decode throws CodableException for unknown type discriminator',
        () {
          const jsonStr = '{"type": "airplane", "maxSpeed": 900}';
          check(
            () => TestJsonDriver.decodeString(jsonStr, Vehicle.decode),
          ).throws<CodableException>();
        },
      );

      test(
        'Vehicle.decode throws CodableException when discriminator is missing',
        () {
          const jsonStr = '{"maxSpeed": 100, "doors": 4}';
          check(
            () => TestJsonDriver.decodeString(jsonStr, Vehicle.decode),
          ).throws<CodableException>();
        },
      );

      test('Car.decode throws CodableException when doors is missing', () {
        const jsonStr = '{"type": "car", "maxSpeed": 150}';
        check(
          () => TestJsonDriver.decodeString(jsonStr, Car.decode),
        ).throws<CodableException>();
      });

      test('Car.decode throws CodableException when maxSpeed is missing', () {
        const jsonStr = '{"type": "car", "doors": 4}';
        check(
          () => TestJsonDriver.decodeString(jsonStr, Car.decode),
        ).throws<CodableException>();
      });

      test(
        'Bicycle.decode throws CodableException when hasBell is missing',
        () {
          const jsonStr = '{"type": "bicycle", "maxSpeed": 25}';
          check(
            () => TestJsonDriver.decodeString(jsonStr, Bicycle.decode),
          ).throws<CodableException>();
        },
      );

      test(
        'Bicycle.decode throws CodableException when maxSpeed is missing',
        () {
          const jsonStr = '{"type": "bicycle", "hasBell": true}';
          check(
            () => TestJsonDriver.decodeString(jsonStr, Bicycle.decode),
          ).throws<CodableException>();
        },
      );

      test('decodes Car when type discriminator is first key (leading)', () {
        const jsonStr = '{"type": "car", "maxSpeed": 210, "doors": 4}';
        final vehicle = TestJsonDriver.decodeString(jsonStr, Vehicle.decode);

        check(vehicle).isA<Car>();
        check((vehicle as Car).doors).equals(4);
      });

      test('decodes Car when type discriminator is middle key', () {
        const jsonStr = '{"maxSpeed": 210, "type": "car", "doors": 4}';
        final vehicle = TestJsonDriver.decodeString(jsonStr, Vehicle.decode);

        check(vehicle).isA<Car>();
        check((vehicle as Car).doors).equals(4);
      });

      test(
        'decodes Car when type discriminator is last key (trailing discriminator)',
        () {
          const jsonStr = '{"maxSpeed": 210, "doors": 4, "type": "car"}';
          final vehicle = TestJsonDriver.decodeString(jsonStr, Vehicle.decode);

          check(vehicle).isA<Car>();
          check((vehicle as Car).doors).equals(4);
          check(vehicle.maxSpeed).equals(210);
        },
      );

      test(
        'decodes Bicycle when type discriminator is last key (trailing discriminator)',
        () {
          const jsonStr =
              '{"maxSpeed": 32, "hasBell": true, "type": "bicycle"}';
          final vehicle = TestJsonDriver.decodeString(jsonStr, Vehicle.decode);

          check(vehicle).isA<Bicycle>();
          check((vehicle as Bicycle).hasBell).isTrue();
          check(vehicle.maxSpeed).equals(32);
        },
      );

      test('skips unknown properties in Car payload cleanly', () {
        const jsonStr =
            '{"type": "car", "color": "red", "maxSpeed": 200, "sunroof": true, "doors": 4}';
        final vehicle = TestJsonDriver.decodeString(jsonStr, Vehicle.decode);

        check(vehicle).isA<Car>();
        check((vehicle as Car).doors).equals(4);
      });

      test('skips unknown properties in Bicycle payload cleanly', () {
        const jsonStr =
            '{"gears": 21, "type": "bicycle", "maxSpeed": 40, "hasBell": false}';
        final vehicle = TestJsonDriver.decodeString(jsonStr, Vehicle.decode);

        check(vehicle).isA<Bicycle>();
        check((vehicle as Bicycle).hasBell).isFalse();
      });
    });
  });

  group('Bit-Exact JSON Roundtrip Validation vs jsonEncode / jsonDecode', () {
    group('Coordinate Roundtrips', () {
      test('Coordinate bit-exact roundtrip with standard coordinates', () {
        const original = Coordinate(
          latitude: 37.774929,
          longitude: -122.419416,
        );
        final jsonBytes = TestJsonDriver.encodeToBytes(original);
        final roundtripped = TestJsonDriver.decodeBytes(
          jsonBytes,
          Coordinate.decode,
        );

        check(roundtripped).equals(original);

        // Verify JSON string structure equivalence
        final jsonStr = utf8.decode(jsonBytes);
        final stdJson = jsonEncode({
          'latitude': 37.774929,
          'longitude': -122.419416,
        });
        final decodedActual = jsonDecode(jsonStr) as Map<String, dynamic>;
        final decodedExpected = jsonDecode(stdJson) as Map<String, dynamic>;
        check(decodedActual).deepEquals(decodedExpected);
      });

      test('Coordinate bit-exact roundtrip with zero coordinates', () {
        const original = Coordinate(latitude: 0.0, longitude: 0.0);
        final jsonBytes = TestJsonDriver.encodeToBytes(original);
        final roundtripped = TestJsonDriver.decodeBytes(
          jsonBytes,
          Coordinate.decode,
        );

        check(roundtripped).equals(original);
      });

      test(
        'Coordinate bit-exact roundtrip with negative and extreme coordinates',
        () {
          const original = Coordinate(latitude: -89.9999, longitude: 179.9999);
          final jsonBytes = TestJsonDriver.encodeToBytes(original);
          final roundtripped = TestJsonDriver.decodeBytes(
            jsonBytes,
            Coordinate.decode,
          );

          check(roundtripped).equals(original);
        },
      );
    });

    group('UserProfile Roundtrips', () {
      test(
        'UserProfile bit-exact roundtrip with integer zip normalized to string',
        () {
          const rawJson =
              '{"id": "usr_roundtrip_1", "email": "rt1@example.com", "role": "admin", "zip": 90210, "tags": ["a", "b"]}';
          final profile = TestJsonDriver.decodeString(
            rawJson,
            UserProfile.decode,
          );

          check(profile.zip).equals('90210');

          final encodedBytes = TestJsonDriver.encodeToBytes(profile);
          final reDecoded = TestJsonDriver.decodeBytes(
            encodedBytes,
            UserProfile.decode,
          );

          check(reDecoded).equals(profile);
          check(reDecoded.tags).deepEquals(profile.tags);
        },
      );

      test(
        'UserProfile bit-exact roundtrip with string zip and empty tags',
        () {
          const original = UserProfile(
            id: 'usr_roundtrip_2',
            email: 'rt2@example.com',
            role: UserRole.guest,
            zip: 'SW1A 1AA',
            tags: [],
          );
          final encodedBytes = TestJsonDriver.encodeToBytes(original);
          final reDecoded = TestJsonDriver.decodeBytes(
            encodedBytes,
            UserProfile.decode,
          );

          check(reDecoded).equals(original);
          check(reDecoded.tags).isEmpty();
        },
      );

      test('UserProfile bit-exact roundtrip with multiple tags', () {
        const original = UserProfile(
          id: 'usr_roundtrip_3',
          email: 'rt3@example.com',
          role: UserRole.member,
          zip: '94043',
          tags: ['flutter', 'dart', 'codable', 'serialization'],
        );
        final encodedBytes = TestJsonDriver.encodeToBytes(original);
        final reDecoded = TestJsonDriver.decodeBytes(
          encodedBytes,
          UserProfile.decode,
        );

        check(reDecoded).equals(original);
        check(reDecoded.tags).deepEquals(original.tags);
      });
    });

    group('Vehicle Hierarchy Roundtrips', () {
      test('Car bit-exact roundtrip through polymorphic decode and encode', () {
        const originalCar = Car(maxSpeed: 240, doors: 4);
        final encodedBytes = TestJsonDriver.encodeToBytes(originalCar);
        final reDecoded = TestJsonDriver.decodeBytes(
          encodedBytes,
          Vehicle.decode,
        );

        check(reDecoded).isA<Car>();
        check(reDecoded).equals(originalCar);
      });

      test(
        'Bicycle bit-exact roundtrip through polymorphic decode and encode',
        () {
          const originalBike = Bicycle(maxSpeed: 40, hasBell: true);
          final encodedBytes = TestJsonDriver.encodeToBytes(originalBike);
          final reDecoded = TestJsonDriver.decodeBytes(
            encodedBytes,
            Vehicle.decode,
          );

          check(reDecoded).isA<Bicycle>();
          check(reDecoded).equals(originalBike);
        },
      );

      test('Bicycle with hasBell=false bit-exact roundtrip', () {
        const originalBike = Bicycle(maxSpeed: 25, hasBell: false);
        final encodedBytes = TestJsonDriver.encodeToBytes(originalBike);
        final reDecoded = TestJsonDriver.decodeBytes(
          encodedBytes,
          Vehicle.decode,
        );

        check(reDecoded).isA<Bicycle>();
        check(reDecoded).equals(originalBike);
      });
    });

    group('Collection & Composite Roundtrips', () {
      test('roundtrips list of Coordinate objects in an unkeyed array', () {
        final coordinates = const [
          Coordinate(latitude: 37.7749, longitude: -122.4194),
          Coordinate(latitude: 51.5074, longitude: -0.1278),
          Coordinate(latitude: 35.6762, longitude: 139.6503),
        ];

        final jsonBytes = TestJsonDriver.encodeWithToBytes(coordinates, (
          list,
          encoder,
        ) {
          final unkeyed = encoder.unkeyed();
          for (final c in list) {
            unkeyed.encodeElement(c, (item, e) => item.encode(e));
          }
        });

        final decodedList = TestJsonDriver.decodeBytes(jsonBytes, (decoder) {
          final unkeyed = decoder.unkeyed();
          final result = <Coordinate>[];
          while (unkeyed.hasNext()) {
            result.add(unkeyed.decodeElement(Coordinate.decode));
          }
          return result;
        });

        check(decodedList).deepEquals(coordinates);
      });

      test('roundtrips list of UserProfile objects in an unkeyed array', () {
        final profiles = const [
          UserProfile(
            id: 'p1',
            email: 'p1@a.com',
            role: UserRole.admin,
            zip: '90210',
            tags: ['t1'],
          ),
          UserProfile(
            id: 'p2',
            email: 'p2@b.com',
            role: UserRole.member,
            zip: '10001',
            tags: ['t2'],
          ),
        ];

        final jsonBytes = TestJsonDriver.encodeWithToBytes(profiles, (
          list,
          encoder,
        ) {
          final unkeyed = encoder.unkeyed();
          for (final p in list) {
            unkeyed.encodeElement(p, (item, e) => item.encode(e));
          }
        });

        final decodedList = TestJsonDriver.decodeBytes(jsonBytes, (decoder) {
          final unkeyed = decoder.unkeyed();
          final result = <UserProfile>[];
          while (unkeyed.hasNext()) {
            result.add(unkeyed.decodeElement(UserProfile.decode));
          }
          return result;
        });

        check(decodedList).deepEquals(profiles);
      });

      test(
        'roundtrips heterogeneous list of Vehicle objects (Car and Bicycle)',
        () {
          final fleet = const <Vehicle>[
            Car(maxSpeed: 200, doors: 4),
            Bicycle(maxSpeed: 30, hasBell: true),
            Car(maxSpeed: 250, doors: 2),
            Bicycle(maxSpeed: 20, hasBell: false),
          ];

          final jsonBytes = TestJsonDriver.encodeWithToBytes(fleet, (
            list,
            encoder,
          ) {
            final unkeyed = encoder.unkeyed();
            for (final v in list) {
              unkeyed.encodeElement(v, (item, e) => item.encode(e));
            }
          });

          final decodedFleet = TestJsonDriver.decodeBytes(jsonBytes, (decoder) {
            final unkeyed = decoder.unkeyed();
            final result = <Vehicle>[];
            while (unkeyed.hasNext()) {
              result.add(unkeyed.decodeElement(Vehicle.decode));
            }
            return result;
          });

          check(decodedFleet).deepEquals(fleet);
        },
      );

      test('roundtrips empty lists of domain models', () {
        final emptyList = const <Coordinate>[];
        final jsonBytes = TestJsonDriver.encodeWithToBytes(
          emptyList,
          (list, encoder) => encoder.unkeyed(),
        );

        final decodedList = TestJsonDriver.decodeBytes(jsonBytes, (decoder) {
          final unkeyed = decoder.unkeyed();
          final result = <Coordinate>[];
          while (unkeyed.hasNext()) {
            result.add(unkeyed.decodeElement(Coordinate.decode));
          }
          return result;
        });

        check(decodedList).isEmpty();
      });
    });
  });

  group('Tier 3: Pairwise Cross-Feature Interactions', () {
    test('Aliased keys inside list of Coordinates in unkeyed array', () {
      const jsonStr =
          '[{"lat": 1.0, "lon": 2.0}, {"latitude": 3.0, "longitude": 4.0}, {"lat": 5.0, "longitude": 6.0}]';
      final list = TestJsonDriver.decodeString(jsonStr, (decoder) {
        final unkeyed = decoder.unkeyed();
        final result = <Coordinate>[];
        while (unkeyed.hasNext()) {
          result.add(unkeyed.decodeElement(Coordinate.decode));
        }
        return result;
      });

      check(list).deepEquals(const [
        Coordinate(latitude: 1.0, longitude: 2.0),
        Coordinate(latitude: 3.0, longitude: 4.0),
        Coordinate(latitude: 5.0, longitude: 6.0),
      ]);
    });

    test(
      'Polymorphic Vehicle list with mixed leading, middle, and trailing discriminators',
      () {
        const jsonStr = '''
[
  {"type": "car", "maxSpeed": 200, "doors": 4},
  {"maxSpeed": 30, "type": "bicycle", "hasBell": true},
  {"maxSpeed": 250, "doors": 2, "type": "car"},
  {"hasBell": false, "maxSpeed": 25, "type": "bicycle"}
]
''';
        final fleet = TestJsonDriver.decodeString(jsonStr, (decoder) {
          final unkeyed = decoder.unkeyed();
          final result = <Vehicle>[];
          while (unkeyed.hasNext()) {
            result.add(unkeyed.decodeElement(Vehicle.decode));
          }
          return result;
        });

        check(fleet.length).equals(4);
        check(fleet[0]).isA<Car>();
        check((fleet[0] as Car).doors).equals(4);
        check(fleet[1]).isA<Bicycle>();
        check((fleet[1] as Bicycle).hasBell).isTrue();
        check(fleet[2]).isA<Car>();
        check((fleet[2] as Car).doors).equals(2);
        check(fleet[3]).isA<Bicycle>();
        check((fleet[3] as Bicycle).hasBell).isFalse();
      },
    );

    test('UserProfile with userInfo context map propagation', () {
      const tenantSymbol = #tenantId;
      final userInfo = {tenantSymbol: 'tenant_enterprise_1'};

      const jsonStr =
          '{"id": "usr_ctx", "email": "ctx@example.com", "role": "admin", "zip": "90210"}';
      final profile = TestJsonDriver.decodeString(jsonStr, (decoder) {
        check(decoder.userInfo[tenantSymbol]).equals('tenant_enterprise_1');
        return UserProfile.decode(decoder);
      }, userInfo: userInfo);

      check(profile.id).equals('usr_ctx');

      final encodedStr = TestJsonDriver.encodeToString(
        profile,
        userInfo: userInfo,
      );
      check(encodedStr).contains('usr_ctx');
    });

    test(
      'StaticKey descriptors with Coordinate and UserProfile mapped lookups',
      () {
        const latKey = StaticKey('lat', 0);
        const lonKey = StaticKey('lon', 1);

        check(latKey.name).equals('lat');
        check(latKey.index).equals(0);
        check(latKey == const StaticKey('lat', 0)).isTrue();
        check(latKey == const StaticKey('latitude', 0)).isFalse();
        check(lonKey.toString()).contains('lon');
      },
    );

    test('Nested domain models: UserWithLocation roundtrip', () {
      const original = UserWithLocation(
        profile: UserProfile(
          id: 'usr_nested',
          email: 'nested@example.com',
          role: UserRole.member,
          zip: '94043',
          tags: ['geo', 'map'],
        ),
        location: Coordinate(latitude: 37.4220, longitude: -122.0841),
      );

      final bytes = TestJsonDriver.encodeToBytes(original);
      final reDecoded = TestJsonDriver.decodeBytes(
        bytes,
        UserWithLocation.decode,
      );

      check(reDecoded).equals(original);
      check(reDecoded.profile.zip).equals('94043');
      check(reDecoded.location.latitude).equals(37.4220);
    });
  });
}
