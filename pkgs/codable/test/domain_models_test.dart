// Comprehensive Domain Models and Roundtrip Validation Test Suite
//
// Covers:
// - Coordinate: primitive float streaming, alias keys ('lat'/'latitude', 'lon'/'longitude'), equality, hash code
// - UserProfile: string enum UserRole, ZipCodeDecoder CustomCodable, Golden Mask bitmask validation, tags
// - Vehicle Polymorphic Hierarchy: Vehicle, Car, Bicycle, SuperDecodable, leading/middle/trailing discriminators
// - Bit-Exact JSON Roundtrip Validation vs standard jsonEncode / jsonDecode
// - Tier 1 (Happy Path), Tier 2 (Boundary & Errors), Tier 3 (Pairwise Interactions)
//
// Strict assertion standard: package:checks only.

// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';

import 'package:checks/checks.dart';
import 'package:codable/codable_json.dart';
import 'package:test/scaffolding.dart';

part 'domain_models_test.g.dart';

// ============================================================================
// Concrete Mock JSON Driver & Test Container Implementations
// ============================================================================

ValueKind _testValueKind(Object? v) => switch (v) {
  null => ValueKind.nullValue,
  bool() => ValueKind.boolean,
  num() => ValueKind.number,
  String() => ValueKind.string,
  List() => ValueKind.list,
  Map() => ValueKind.map,
  _ => throw CodableException('Unexpected test value kind for $v'),
};

final class _TestDecoder implements Decoder {
  final Object? _data;
  @override
  final Map<Object, Object?> userInfo;
  _TestKeyedDecoder? _activeKeyed;

  @override
  Uint8List? get payload => null;

  _TestDecoder(this._data, {this.userInfo = const {}});

  @override
  ValueKind peekKind() {
    if (_activeKeyed != null && _activeKeyed!._hasCurrent) {
      return _testValueKind(_activeKeyed!._currentValue);
    }
    return _testValueKind(_data);
  }

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
  Float64List? decodeUniformDoubleList(List<List<String>> propertyAliases) =>
      null;
}

mixin _TestSequentialDecoderMixin {
  _TestDecoder get _rootDecoder;
  bool get _canReadCurrent;
  Object? _peekTestValue();
  void _commitTestValue();

  Object? _takeTestValue() {
    final v = _peekTestValue();
    _commitTestValue();
    return v;
  }

  ValueKind peekKind() => _testValueKind(_peekTestValue());

  bool isNextNull() => _canReadCurrent && _peekTestValue() == null;

  void readNull() {
    final v = _peekTestValue();
    if (v != null) {
      throw CodableException('Expected null, found ${v.runtimeType}: $v');
    }
    _commitTestValue();
  }

  int readInt() {
    final v = _peekTestValue();
    if (v is int) {
      _commitTestValue();
      return v;
    }
    throw CodableException('Expected int, found ${v.runtimeType}: $v');
  }

  double readDouble() {
    final v = _peekTestValue();
    if (v is num) {
      _commitTestValue();
      return v.toDouble();
    }
    throw CodableException('Expected double/num, found ${v.runtimeType}: $v');
  }

  num readNum() {
    final v = _peekTestValue();
    if (v is num) {
      _commitTestValue();
      return v;
    }
    throw CodableException('Expected num, found ${v.runtimeType}: $v');
  }

  String readString() {
    final v = _peekTestValue();
    if (v is String) {
      _commitTestValue();
      return v;
    }
    throw CodableException('Expected String, found ${v.runtimeType}: $v');
  }

  bool readBool() {
    final v = _peekTestValue();
    if (v is bool) {
      _commitTestValue();
      return v;
    }
    throw CodableException('Expected bool, found ${v.runtimeType}: $v');
  }

  Decoder nestedDecoder() =>
      _TestDecoder(_takeTestValue(), userInfo: _rootDecoder.userInfo);
}

final class _TestKeyedDecoder
    with BaseKeyedDecoderMixin, _TestSequentialDecoderMixin
    implements KeyedDecoder {
  final List<MapEntry<String, dynamic>> _entries;
  @override
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
  bool get _canReadCurrent => _hasCurrent;

  @override
  Object? _peekTestValue() => _currentValue;

  @override
  void _commitTestValue() {}

  @override
  bool moveNextKey() => _currentIndex + 1 < _entries.length;

  @override
  String nextKey() {
    if (!moveNextKey()) {
      throw const CodableException('No more keys available in KeyedDecoder');
    }
    _currentIndex++;
    return _entries[_currentIndex].key;
  }

  @override
  String? peekKey() => moveNextKey() ? _entries[_currentIndex + 1].key : null;

  @override
  void skipValue() {}
}

final class _TestMappedDecoder
    with BaseMappedDecoderMixin
    implements MappedDecoder {
  final Map<String, dynamic> _map;
  final _TestDecoder _rootDecoder;

  _TestMappedDecoder(this._map, this._rootDecoder);

  Object? _requireKey(String key) {
    if (!_map.containsKey(key)) {
      throw CodableException('Missing required key "$key" in MappedDecoder');
    }
    return _map[key];
  }

  @override
  bool containsKey(String key) => _map.containsKey(key);

  @override
  bool isNull(String key) => _map[key] == null;

  @override
  ValueKind peekKind(String key) => _testValueKind(_map[key]);

  @override
  int readInt(String key) {
    final v = _requireKey(key);
    if (v is int) return v;
    throw CodableException(
      'Expected int for key "$key", found ${v.runtimeType}: $v',
    );
  }

  @override
  double readDouble(String key) {
    final v = _requireKey(key);
    if (v is num) return v.toDouble();
    throw CodableException(
      'Expected double for key "$key", found ${v.runtimeType}: $v',
    );
  }

  @override
  num readNum(String key) {
    final v = _requireKey(key);
    if (v is num) return v;
    throw CodableException(
      'Expected num for key "$key", found ${v.runtimeType}: $v',
    );
  }

  @override
  String readString(String key) {
    final v = _requireKey(key);
    if (v is String) return v;
    throw CodableException(
      'Expected String for key "$key", found ${v.runtimeType}: $v',
    );
  }

  @override
  bool readBool(String key) {
    final v = _requireKey(key);
    if (v is bool) return v;
    throw CodableException(
      'Expected bool for key "$key", found ${v.runtimeType}: $v',
    );
  }

  @override
  Decoder nestedDecoder(String key) =>
      _TestDecoder(_requireKey(key), userInfo: _rootDecoder.userInfo);
}

final class _TestUnkeyedDecoder
    with BaseUnkeyedDecoderMixin, _TestSequentialDecoderMixin
    implements UnkeyedDecoder {
  final List<dynamic> _list;
  @override
  final _TestDecoder _rootDecoder;
  int _index = 0;

  _TestUnkeyedDecoder(this._list, this._rootDecoder);

  @override
  int? get length => _list.length;

  @override
  bool moveNext() => _index < _list.length;

  @override
  bool get _canReadCurrent => moveNext();

  @override
  Object? _peekTestValue() {
    if (!moveNext()) {
      throw const CodableException('End of array in UnkeyedDecoder');
    }
    return _list[_index];
  }

  @override
  void _commitTestValue() {
    _index++;
  }

  @override
  void skipElement() {
    if (moveNext()) _index++;
  }
}

final class _TestSingleValueDecoder
    with BaseSingleValueDecoderMixin, _TestSequentialDecoderMixin
    implements SingleValueDecoder {
  final Object? _value;
  @override
  final _TestDecoder _rootDecoder;

  _TestSingleValueDecoder(this._value, this._rootDecoder);

  @override
  bool get _canReadCurrent => true;

  @override
  Object? _peekTestValue() => _value;

  @override
  void _commitTestValue() {}

  @override
  bool isNull() => _value == null;
}

final class _TestEncoder implements Encoder {
  @override
  final Map<Object, Object?> userInfo;
  final void Function(Object?)? onOutput;
  Object? output;

  _TestEncoder({this.userInfo = const {}, this.onOutput});

  void _setOutput(Object? value) {
    output = value;
    onOutput?.call(value);
  }

  @override
  KeyedEncoder keyed({KeyOptions? options, int? length}) {
    final enc = _TestKeyedEncoder(this);
    _setOutput(enc._map);
    return enc;
  }

  @override
  UnkeyedEncoder unkeyed({int? length}) {
    final enc = _TestUnkeyedEncoder(this);
    _setOutput(enc._list);
    return enc;
  }

  @override
  SingleValueEncoder singleValue() => _TestSingleValueEncoder(this);
}

final class _TestKeyedEncoder
    with BaseKeyedEncoderMixin
    implements KeyedEncoder {
  final _TestEncoder _rootEncoder;
  final Map<String, dynamic> _map = {};

  _TestKeyedEncoder(this._rootEncoder);

  @override
  void encodeInt(String key, int value) => _map[key] = value;

  @override
  void encodeDouble(String key, double value) => _map[key] = value;

  @override
  void encodeString(String key, String value) => _map[key] = value;

  @override
  void encodeBool(String key, bool value) => _map[key] = value;

  @override
  void encodeNull(String key) => _map[key] = null;

  @override
  Encoder nestedEncoder(String key) => _TestEncoder(
    userInfo: _rootEncoder.userInfo,
    onOutput: (val) => _map[key] = val,
  );
}

final class _TestUnkeyedEncoder
    with BaseUnkeyedEncoderMixin
    implements UnkeyedEncoder {
  final _TestEncoder _rootEncoder;
  final List<dynamic> _list = [];

  _TestUnkeyedEncoder(this._rootEncoder);

  @override
  void encodeInt(int value) => _list.add(value);

  @override
  void encodeDouble(double value) => _list.add(value);

  @override
  void encodeString(String value) => _list.add(value);

  @override
  void encodeBool(bool value) => _list.add(value);

  @override
  void encodeNull() => _list.add(null);

  @override
  Encoder nestedEncoder() {
    final slot = _list.length;
    _list.add(null);
    return _TestEncoder(
      userInfo: _rootEncoder.userInfo,
      onOutput: (val) => _list[slot] = val,
    );
  }
}

final class _TestSingleValueEncoder
    with BaseSingleValueEncoderMixin
    implements SingleValueEncoder {
  final _TestEncoder _rootEncoder;

  _TestSingleValueEncoder(this._rootEncoder);

  @override
  void encodeInt(int value) => _rootEncoder._setOutput(value);

  @override
  void encodeDouble(double value) => _rootEncoder._setOutput(value);

  @override
  void encodeString(String value) => _rootEncoder._setOutput(value);

  @override
  void encodeBool(bool value) => _rootEncoder._setOutput(value);

  @override
  void encodeNull() => _rootEncoder._setOutput(null);

  @override
  void encode<T>(T value, Encodable<T> encodable) {
    final child = _TestEncoder(userInfo: _rootEncoder.userInfo);
    encodable.encode(value, child);
    _rootEncoder._setOutput(child.output);
  }
}

/// Mock test format driver facade.
abstract final class TestJsonDriver {
  static T decodeString<T>(
    String jsonString,
    Decodable<T> decodable, {
    Map<Object, Object?>? userInfo,
  }) {
    final Object? parsed = jsonDecode(jsonString);
    return decodable.decode(
      _TestDecoder(parsed, userInfo: userInfo ?? const {}),
    );
  }

  static T decodeBytes<T>(
    Uint8List bytes,
    Decodable<T> decodable, {
    Map<Object, Object?>? userInfo,
  }) {
    final jsonString = utf8.decode(bytes);
    return decodeString(jsonString, decodable, userInfo: userInfo);
  }

  static String encodeToString<T>(
    T value,
    Encodable<T> encodable, {
    Map<Object, Object?>? userInfo,
  }) {
    final encoder = _TestEncoder(userInfo: userInfo ?? const {});
    encodable.encode(value, encoder);
    return jsonEncode(encoder.output);
  }

  static Uint8List encodeToBytes<T>(
    T value,
    Encodable<T> encodable, {
    Map<Object, Object?>? userInfo,
  }) {
    final str = encodeToString(value, encodable, userInfo: userInfo);
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
class Coordinate {
  @CodableKey(aliases: ['lat'])
  final double latitude;

  @CodableKey(aliases: ['lon'])
  final double longitude;

  const Coordinate({required this.latitude, required this.longitude});

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
class ZipCodeDecoder implements Codable<String> {
  const ZipCodeDecoder();

  @override
  String decode(Decoder decoder) {
    final single = decoder.singleValue();
    return switch (single.peekKind()) {
      ValueKind.string => single.readString(),
      ValueKind.number => single.readInt().toString(),
      final kind => throw CodableException(
        'Expected string or int for zip, found $kind',
      ),
    };
  }

  @override
  void encode(String value, Encoder encoder) {
    encoder.singleValue().encodeString(value);
  }
}

/// Model 2: Complex Domain Model with Enum, Codable & Golden Mask validation.
@Codable()
class UserProfile {
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
sealed class Vehicle {
  final String type;
  final int maxSpeed;

  const Vehicle({required this.type, required this.maxSpeed});
}

/// Companion [Codable] for polymorphic [Vehicle] hierarchy.
final class VehicleCodable implements Codable<Vehicle> {
  const VehicleCodable();

  @override
  Vehicle decode(Decoder decoder) {
    final mapped = decoder.mapped();
    if (!mapped.containsKey('type')) {
      throw const CodableException(
        'Missing discriminator key "type" for Vehicle',
      );
    }
    final type = mapped.readString('type');
    return switch (type) {
      'car' => const CarCodable().decode(decoder),
      'bicycle' => const BicycleCodable().decode(decoder),
      _ => throw CodableException('Unknown vehicle type: $type'),
    };
  }

  @override
  void encode(Vehicle value, Encoder encoder) {
    final keyed = encoder.keyed();
    keyed.encodeString('type', value.type);
    switch (value) {
      case Car():
        keyed.encodeInt(_$CarSchema.nameMaxSpeed, value.maxSpeed);
        keyed.encodeInt(_$CarSchema.nameDoors, value.doors);
      case Bicycle():
        keyed.encodeInt(_$BicycleSchema.nameMaxSpeed, value.maxSpeed);
        keyed.encodeBool(_$BicycleSchema.nameHasBell, value.hasBell);
    }
  }
}

/// Concrete Subtype 1: Car.
@Codable()
class Car extends Vehicle {
  final int doors;

  const Car({required super.maxSpeed, required this.doors})
    : super(type: 'car');

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
class VehicleSuperDecodable extends SuperDecodable<Vehicle> {
  const VehicleSuperDecodable();

  @override
  String get discriminatorKey => 'type';

  @override
  Map<String, Decodable<Vehicle>> get subtypes => const {
    'car': CarCodable(),
    'bicycle': BicycleCodable(),
  };
}

/// Decode-only custom converter normalizing int or string IDs.
final class FlexibleIdDecoder implements Decodable<String> {
  const FlexibleIdDecoder();

  @override
  String decode(Decoder decoder) {
    final sv = decoder.singleValue();
    return switch (sv.peekKind()) {
      ValueKind.string => sv.readString(),
      ValueKind.number => sv.readInt().toString(),
      ValueKind.boolean => sv.readBool().toString(),
      final kind => throw CodableException('Unsupported id kind: $kind'),
    };
  }
}

/// Encode-only custom converter uppercasing string codes.
final class UpperCodeEncoder implements Encodable<String> {
  const UpperCodeEncoder();

  @override
  void encode(String value, Encoder encoder) {
    encoder.singleValue().encodeString(value.toUpperCase());
  }
}

/// Domain model exercising `num`, `List<num>`, `codable:`, `customDecoder:`,
/// `customEncoder:`, and `SuperDecodable<Vehicle>` on real `JsonCodableDecoder`.
@Codable()
class TelemetryPacket {
  @CodableKey(customDecoder: FlexibleIdDecoder())
  final String packetId;

  @CodableKey(codable: ZipCodeDecoder())
  final String regionZip;

  @CodableKey(customEncoder: UpperCodeEncoder())
  final String statusCode;

  final num reading;
  final num? delta;
  final List<num> history;
  final Map<String, num> counters;

  @CodableKey(
    customDecoder: VehicleSuperDecodable(),
    customEncoder: VehicleCodable(),
  )
  final Vehicle vehicle;

  final String? notes;

  const TelemetryPacket({
    required this.packetId,
    required this.regionZip,
    required this.statusCode,
    required this.reading,
    this.delta,
    this.history = const [],
    this.counters = const {},
    required this.vehicle,
    this.notes,
  });
}

/// Nested location model for pairwise testing.
@Codable()
class UserWithLocation {
  final UserProfile profile;
  final Coordinate location;

  const UserWithLocation({required this.profile, required this.location});

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
        final coord = TestJsonDriver.decodeString(
          jsonStr,
          const CoordinateCodable(),
        );

        check(coord.latitude).equals(37.7749);
        check(coord.longitude).equals(-122.4194);
      });

      test('decodes Coordinate with aliased lat and lon keys', () {
        const jsonStr = '{"lat": 51.5074, "lon": -0.1278}';
        final coord = TestJsonDriver.decodeString(
          jsonStr,
          const CoordinateCodable(),
        );

        check(coord.latitude).equals(51.5074);
        check(coord.longitude).equals(-0.1278);
      });

      test('decodes Coordinate with mixed keys: latitude and lon', () {
        const jsonStr = '{"latitude": 40.7128, "lon": -74.0060}';
        final coord = TestJsonDriver.decodeString(
          jsonStr,
          const CoordinateCodable(),
        );

        check(coord.latitude).equals(40.7128);
        check(coord.longitude).equals(-74.0060);
      });

      test('decodes Coordinate with mixed keys: lat and longitude', () {
        const jsonStr = '{"lat": 35.6762, "longitude": 139.6503}';
        final coord = TestJsonDriver.decodeString(
          jsonStr,
          const CoordinateCodable(),
        );

        check(coord.latitude).equals(35.6762);
        check(coord.longitude).equals(139.6503);
      });

      test(
        'encodes Coordinate to standard latitude and longitude keys in JSON',
        () {
          const coord = Coordinate(latitude: 48.8566, longitude: 2.3522);
          final jsonStr = TestJsonDriver.encodeToString(
            coord,
            const CoordinateCodable(),
          );
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
          () => TestJsonDriver.decodeString(jsonStr, const CoordinateCodable()),
        ).throws<CodableException>();
      });

      test('throws CodableException when longitude / lon is missing', () {
        const jsonStr = '{"latitude": 37.7749}';
        check(
          () => TestJsonDriver.decodeString(jsonStr, const CoordinateCodable()),
        ).throws<CodableException>();
      });

      test('throws CodableException when empty object is provided', () {
        const jsonStr = '{}';
        check(
          () => TestJsonDriver.decodeString(jsonStr, const CoordinateCodable()),
        ).throws<CodableException>();
      });

      test('decodes Coordinate when lon key appears before lat key', () {
        const jsonStr = '{"lon": -122.4194, "lat": 37.7749}';
        final coord = TestJsonDriver.decodeString(
          jsonStr,
          const CoordinateCodable(),
        );

        check(coord.latitude).equals(37.7749);
        check(coord.longitude).equals(-122.4194);
      });

      test('skips unknown extra fields (altitude, accuracy, timestamp) cleanly', () {
        const jsonStr =
            '{"altitude": 150.5, "accuracy": 5, "lat": 37.7749, "timestamp": 1690000000, "lon": -122.4194}';
        final coord = TestJsonDriver.decodeString(
          jsonStr,
          const CoordinateCodable(),
        );

        check(coord.latitude).equals(37.7749);
        check(coord.longitude).equals(-122.4194);
      });

      test('decodes Coordinate with zero values (0.0, 0.0)', () {
        const jsonStr = '{"lat": 0.0, "lon": 0.0}';
        final coord = TestJsonDriver.decodeString(
          jsonStr,
          const CoordinateCodable(),
        );

        check(coord.latitude).equals(0.0);
        check(coord.longitude).equals(0.0);
      });

      test('decodes Coordinate with negative zero (-0.0, -0.0)', () {
        const jsonStr = '{"latitude": -0.0, "longitude": -0.0}';
        final coord = TestJsonDriver.decodeString(
          jsonStr,
          const CoordinateCodable(),
        );

        check(coord.latitude).equals(-0.0);
        check(coord.longitude).equals(-0.0);
      });

      test(
        'decodes Coordinate with boundary values (-90.0, 90.0, -180.0, 180.0)',
        () {
          const jsonStr = '{"lat": -90.0, "lon": 180.0}';
          final coord = TestJsonDriver.decodeString(
            jsonStr,
            const CoordinateCodable(),
          );

          check(coord.latitude).equals(-90.0);
          check(coord.longitude).equals(180.0);
        },
      );

      test('decodes Coordinate with high precision float values', () {
        const jsonStr =
            '{"lat": 37.77492928374619, "lon": -122.41941558273618}';
        final coord = TestJsonDriver.decodeString(
          jsonStr,
          const CoordinateCodable(),
        );

        check(coord.latitude).equals(37.77492928374619);
        check(coord.longitude).equals(-122.41941558273618);
      });

      test('throws CodableException when latitude value is string', () {
        const jsonStr = '{"lat": "37.7749", "lon": -122.4194}';
        check(
          () => TestJsonDriver.decodeString(jsonStr, const CoordinateCodable()),
        ).throws<CodableException>();
      });

      test('throws CodableException when latitude value is null', () {
        const jsonStr = '{"lat": null, "lon": -122.4194}';
        check(
          () => TestJsonDriver.decodeString(jsonStr, const CoordinateCodable()),
        ).throws<CodableException>();
      });

      test('throws CodableException when longitude value is boolean', () {
        const jsonStr = '{"lat": 37.7749, "lon": true}';
        check(
          () => TestJsonDriver.decodeString(jsonStr, const CoordinateCodable()),
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
          const UserProfileCodable(),
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
          const UserProfileCodable(),
        );

        check(profile.tags).isEmpty();
      });

      test('decodes UserProfile with omitted tags field defaulting to empty', () {
        const jsonStr =
            '{"id": "usr_103", "email": "carol@example.com", "role": "guest", "zip": "SW1A 1AA"}';
        final profile = TestJsonDriver.decodeString(
          jsonStr,
          const UserProfileCodable(),
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
          const UserProfileCodable(),
        );

        check(profile.zip).equals('90210');
      });

      test('ZipCodeDecoder normalizes string "90210" to string "90210"', () {
        const jsonStr =
            '{"id": "usr_105", "email": "eve@example.com", "role": "member", "zip": "90210"}';
        final profile = TestJsonDriver.decodeString(
          jsonStr,
          const UserProfileCodable(),
        );

        check(profile.zip).equals('90210');
      });

      test('ZipCodeDecoder normalizes alphanumeric postal code "EC1A 1BB"', () {
        const jsonStr =
            '{"id": "usr_106", "email": "frank@example.co.uk", "role": "guest", "zip": "EC1A 1BB"}';
        final profile = TestJsonDriver.decodeString(
          jsonStr,
          const UserProfileCodable(),
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
        final jsonStr = TestJsonDriver.encodeToString(
          profile,
          const UserProfileCodable(),
        );
        final decodedMap = jsonDecode(jsonStr) as Map<String, dynamic>;

        check(decodedMap['id']).equals('usr_201');
        check(decodedMap['email']).equals('grace@example.com');
        check(decodedMap['role']).equals('admin');
        check(decodedMap['zip']).equals('94105');
        check((decodedMap['tags'] as List<dynamic>).cast<String>())
            .deepEquals(['security', 'core']);
      });

      test('encodes UserProfile with empty tags as empty list', () {
        const profile = UserProfile(
          id: 'usr_202',
          email: 'heidi@example.com',
          role: UserRole.member,
          zip: '94105',
          tags: [],
        );
        final jsonStr = TestJsonDriver.encodeToString(
          profile,
          const UserProfileCodable(),
        );
        final decodedMap = jsonDecode(jsonStr) as Map<String, dynamic>;

        check(decodedMap['tags']).isA<List<dynamic>>().isEmpty();
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
          () =>
              TestJsonDriver.decodeString(jsonStr, const UserProfileCodable()),
        ).throws<CodableException>();
      });

      test('Golden Mask throws CodableException when email is missing', () {
        const jsonStr = '{"id": "usr_1", "role": "admin", "zip": "90210"}';
        check(
          () =>
              TestJsonDriver.decodeString(jsonStr, const UserProfileCodable()),
        ).throws<CodableException>();
      });

      test('Golden Mask throws CodableException when role is missing', () {
        const jsonStr = '{"id": "usr_1", "email": "a@b.com", "zip": "90210"}';
        check(
          () =>
              TestJsonDriver.decodeString(jsonStr, const UserProfileCodable()),
        ).throws<CodableException>();
      });

      test('Golden Mask throws CodableException when zip is missing', () {
        const jsonStr = '{"id": "usr_1", "email": "a@b.com", "role": "admin"}';
        check(
          () =>
              TestJsonDriver.decodeString(jsonStr, const UserProfileCodable()),
        ).throws<CodableException>();
      });

      test('Golden Mask throws CodableException when multiple required fields are missing', () {
        const jsonStr = '{"id": "usr_1"}';
        check(
          () =>
              TestJsonDriver.decodeString(jsonStr, const UserProfileCodable()),
        ).throws<CodableException>();
      });

      test('Golden Mask throws CodableException on empty payload', () {
        const jsonStr = '{}';
        check(
          () =>
              TestJsonDriver.decodeString(jsonStr, const UserProfileCodable()),
        ).throws<CodableException>();
      });

      test('throws CodableException for unknown UserRole string', () {
        const jsonStr =
            '{"id": "usr_1", "email": "a@b.com", "role": "superuser", "zip": "90210"}';
        check(
          () =>
              TestJsonDriver.decodeString(jsonStr, const UserProfileCodable()),
        ).throws<CodableException>();
      });

      test('ZipCodeDecoder throws CodableException for boolean zip code', () {
        const jsonStr =
            '{"id": "usr_1", "email": "a@b.com", "role": "admin", "zip": true}';
        check(
          () =>
              TestJsonDriver.decodeString(jsonStr, const UserProfileCodable()),
        ).throws<CodableException>();
      });

      test('ZipCodeDecoder throws CodableException for null zip code', () {
        const jsonStr =
            '{"id": "usr_1", "email": "a@b.com", "role": "admin", "zip": null}';
        check(
          () =>
              TestJsonDriver.decodeString(jsonStr, const UserProfileCodable()),
        ).throws<CodableException>();
      });

      test('ZipCodeDecoder throws CodableException for array zip code', () {
        const jsonStr =
            '{"id": "usr_1", "email": "a@b.com", "role": "admin", "zip": [90210]}';
        check(
          () =>
              TestJsonDriver.decodeString(jsonStr, const UserProfileCodable()),
        ).throws<CodableException>();
      });

      test('ZipCodeDecoder throws CodableException for object zip code', () {
        const jsonStr =
            '{"id": "usr_1", "email": "a@b.com", "role": "admin", "zip": {"code": 90210}}';
        check(
          () =>
              TestJsonDriver.decodeString(jsonStr, const UserProfileCodable()),
        ).throws<CodableException>();
      });

      test('skips unknown extra keys (age, bio, preferences) while satisfying Golden Mask', () {
        const jsonStr =
            '{"age": 30, "id": "usr_1", "bio": "engineer", "email": "a@b.com", "preferences": {"dark_mode": true}, "role": "member", "zip": 90210}';
        final profile = TestJsonDriver.decodeString(
          jsonStr,
          const UserProfileCodable(),
        );

        check(profile.id).equals('usr_1');
        check(profile.email).equals('a@b.com');
        check(profile.role).equals(UserRole.member);
        check(profile.zip).equals('90210');
      });

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
          final profile = TestJsonDriver.decodeBytes(
            bytes,
            const UserProfileCodable(),
          );

          check(profile.tags).deepEquals(tagsList);
        },
      );
    });
  });

  group('Domain Model: Vehicle Polymorphic Hierarchy', () {
    group('Tier 1: Happy Path & Polymorphic Dispatch', () {
      test('decodes Car subtype via VehicleCodable with type="car"', () {
        const jsonStr = '{"type": "car", "maxSpeed": 220, "doors": 4}';
        final vehicle = TestJsonDriver.decodeString(
          jsonStr,
          const VehicleCodable(),
        );

        check(vehicle).isA<Car>();
        final car = vehicle as Car;
        check(car.type).equals('car');
        check(car.maxSpeed).equals(220);
        check(car.doors).equals(4);
      });

      test(
        'decodes Bicycle subtype via VehicleCodable with type="bicycle"',
        () {
          const jsonStr =
              '{"type": "bicycle", "maxSpeed": 45, "hasBell": true}';
          final vehicle = TestJsonDriver.decodeString(
            jsonStr,
            const VehicleCodable(),
          );

          check(vehicle).isA<Bicycle>();
          final bike = vehicle as Bicycle;
          check(bike.type).equals('bicycle');
          check(bike.maxSpeed).equals(45);
          check(bike.hasBell).isTrue();
        },
      );

      test('direct CarCodable decodes doors and maxSpeed', () {
        const jsonStr = '{"type": "car", "maxSpeed": 180, "doors": 2}';
        final car = TestJsonDriver.decodeString(jsonStr, const CarCodable());

        check(car.maxSpeed).equals(180);
        check(car.doors).equals(2);
      });

      test('direct BicycleCodable decodes hasBell and maxSpeed', () {
        const jsonStr = '{"type": "bicycle", "maxSpeed": 30, "hasBell": false}';
        final bike = TestJsonDriver.decodeString(
          jsonStr,
          const BicycleCodable(),
        );

        check(bike.maxSpeed).equals(30);
        check(bike.hasBell).isFalse();
      });

      test('encodes Car to JSON with type="car", maxSpeed, and doors', () {
        const car = Car(maxSpeed: 200, doors: 4);
        final jsonStr = TestJsonDriver.encodeToString(
          car,
          const VehicleCodable(),
        );
        final decodedMap = jsonDecode(jsonStr) as Map<String, dynamic>;

        check(decodedMap['type']).equals('car');
        check(decodedMap['maxSpeed']).equals(200);
        check(decodedMap['doors']).equals(4);
      });

      test(
        'encodes Bicycle to JSON with type="bicycle", maxSpeed, and hasBell',
        () {
          const bike = Bicycle(maxSpeed: 35, hasBell: true);
          final jsonStr = TestJsonDriver.encodeToString(
            bike,
            const VehicleCodable(),
          );
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
          check(superDecodable.subtypes.keys.toList())
              .deepEquals(['car', 'bicycle']);
        },
      );
    });

    group('Tier 2: Boundary, Discriminator Position & Error Handling', () {
      test(
        'VehicleCodable throws CodableException for unknown type discriminator',
        () {
          const jsonStr = '{"type": "airplane", "maxSpeed": 900}';
          check(
            () => TestJsonDriver.decodeString(jsonStr, const VehicleCodable()),
          ).throws<CodableException>();
        },
      );

      test(
        'VehicleCodable throws CodableException when discriminator is missing',
        () {
          const jsonStr = '{"maxSpeed": 100, "doors": 4}';
          check(
            () => TestJsonDriver.decodeString(jsonStr, const VehicleCodable()),
          ).throws<CodableException>();
        },
      );

      test('CarCodable throws CodableException when doors is missing', () {
        const jsonStr = '{"type": "car", "maxSpeed": 150}';
        check(() => TestJsonDriver.decodeString(jsonStr, const CarCodable()))
            .throws<CodableException>();
      });

      test('CarCodable throws CodableException when maxSpeed is missing', () {
        const jsonStr = '{"type": "car", "doors": 4}';
        check(() => TestJsonDriver.decodeString(jsonStr, const CarCodable()))
            .throws<CodableException>();
      });

      test(
        'BicycleCodable throws CodableException when hasBell is missing',
        () {
          const jsonStr = '{"type": "bicycle", "maxSpeed": 25}';
          check(
            () => TestJsonDriver.decodeString(jsonStr, const BicycleCodable()),
          ).throws<CodableException>();
        },
      );

      test(
        'BicycleCodable throws CodableException when maxSpeed is missing',
        () {
          const jsonStr = '{"type": "bicycle", "hasBell": true}';
          check(
            () => TestJsonDriver.decodeString(jsonStr, const BicycleCodable()),
          ).throws<CodableException>();
        },
      );

      test('decodes Car when type discriminator is first key (leading)', () {
        const jsonStr = '{"type": "car", "maxSpeed": 210, "doors": 4}';
        final vehicle = TestJsonDriver.decodeString(
          jsonStr,
          const VehicleCodable(),
        );

        check(vehicle).isA<Car>();
        check((vehicle as Car).doors).equals(4);
      });

      test('decodes Car when type discriminator is middle key', () {
        const jsonStr = '{"maxSpeed": 210, "type": "car", "doors": 4}';
        final vehicle = TestJsonDriver.decodeString(
          jsonStr,
          const VehicleCodable(),
        );

        check(vehicle).isA<Car>();
        check((vehicle as Car).doors).equals(4);
      });

      test('decodes Car when type discriminator is last key (trailing discriminator)', () {
        const jsonStr = '{"maxSpeed": 210, "doors": 4, "type": "car"}';
        final vehicle = TestJsonDriver.decodeString(
          jsonStr,
          const VehicleCodable(),
        );

        check(vehicle).isA<Car>();
        check((vehicle as Car).doors).equals(4);
        check(vehicle.maxSpeed).equals(210);
      });

      test('decodes Bicycle when type discriminator is last key (trailing discriminator)', () {
        const jsonStr = '{"maxSpeed": 32, "hasBell": true, "type": "bicycle"}';
        final vehicle = TestJsonDriver.decodeString(
          jsonStr,
          const VehicleCodable(),
        );

        check(vehicle).isA<Bicycle>();
        check((vehicle as Bicycle).hasBell).isTrue();
        check(vehicle.maxSpeed).equals(32);
      });

      test('skips unknown properties in Car payload cleanly', () {
        const jsonStr =
            '{"type": "car", "color": "red", "maxSpeed": 200, "sunroof": true, "doors": 4}';
        final vehicle = TestJsonDriver.decodeString(
          jsonStr,
          const VehicleCodable(),
        );

        check(vehicle).isA<Car>();
        check((vehicle as Car).doors).equals(4);
      });

      test('skips unknown properties in Bicycle payload cleanly', () {
        const jsonStr =
            '{"gears": 21, "type": "bicycle", "maxSpeed": 40, "hasBell": false}';
        final vehicle = TestJsonDriver.decodeString(
          jsonStr,
          const VehicleCodable(),
        );

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
        final jsonBytes = TestJsonDriver.encodeToBytes(
          original,
          const CoordinateCodable(),
        );
        final roundtripped = TestJsonDriver.decodeBytes(
          jsonBytes,
          const CoordinateCodable(),
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
        final jsonBytes = TestJsonDriver.encodeToBytes(
          original,
          const CoordinateCodable(),
        );
        final roundtripped = TestJsonDriver.decodeBytes(
          jsonBytes,
          const CoordinateCodable(),
        );

        check(roundtripped).equals(original);
      });

      test(
        'Coordinate bit-exact roundtrip with negative and extreme coordinates',
        () {
          const original = Coordinate(latitude: -89.9999, longitude: 179.9999);
          final jsonBytes = TestJsonDriver.encodeToBytes(
            original,
            const CoordinateCodable(),
          );
          final roundtripped = TestJsonDriver.decodeBytes(
            jsonBytes,
            const CoordinateCodable(),
          );

          check(roundtripped).equals(original);
        },
      );
    });

    group('UserProfile Roundtrips', () {
      test('UserProfile bit-exact roundtrip with integer zip normalized to string', () {
        const rawJson =
            '{"id": "usr_roundtrip_1", "email": "rt1@example.com", "role": "admin", "zip": 90210, "tags": ["a", "b"]}';
        final profile = TestJsonDriver.decodeString(
          rawJson,
          const UserProfileCodable(),
        );

        check(profile.zip).equals('90210');

        final encodedBytes = TestJsonDriver.encodeToBytes(
          profile,
          const UserProfileCodable(),
        );
        final reDecoded = TestJsonDriver.decodeBytes(
          encodedBytes,
          const UserProfileCodable(),
        );

        check(reDecoded).equals(profile);
        check(reDecoded.tags).deepEquals(profile.tags);
      });

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
          final encodedBytes = TestJsonDriver.encodeToBytes(
            original,
            const UserProfileCodable(),
          );
          final reDecoded = TestJsonDriver.decodeBytes(
            encodedBytes,
            const UserProfileCodable(),
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
        final encodedBytes = TestJsonDriver.encodeToBytes(
          original,
          const UserProfileCodable(),
        );
        final reDecoded = TestJsonDriver.decodeBytes(
          encodedBytes,
          const UserProfileCodable(),
        );

        check(reDecoded).equals(original);
        check(reDecoded.tags).deepEquals(original.tags);
      });
    });

    group('Vehicle Hierarchy Roundtrips', () {
      test('Car bit-exact roundtrip through polymorphic decode and encode', () {
        const originalCar = Car(maxSpeed: 240, doors: 4);
        final encodedBytes = TestJsonDriver.encodeToBytes(
          originalCar,
          const VehicleCodable(),
        );
        final reDecoded = TestJsonDriver.decodeBytes(
          encodedBytes,
          const VehicleCodable(),
        );

        check(reDecoded).isA<Car>();
        check(reDecoded).equals(originalCar);
      });

      test(
        'Bicycle bit-exact roundtrip through polymorphic decode and encode',
        () {
          const originalBike = Bicycle(maxSpeed: 40, hasBell: true);
          final encodedBytes = TestJsonDriver.encodeToBytes(
            originalBike,
            const VehicleCodable(),
          );
          final reDecoded = TestJsonDriver.decodeBytes(
            encodedBytes,
            const VehicleCodable(),
          );

          check(reDecoded).isA<Bicycle>();
          check(reDecoded).equals(originalBike);
        },
      );

      test('Bicycle with hasBell=false bit-exact roundtrip', () {
        const originalBike = Bicycle(maxSpeed: 25, hasBell: false);
        final encodedBytes = TestJsonDriver.encodeToBytes(
          originalBike,
          const VehicleCodable(),
        );
        final reDecoded = TestJsonDriver.decodeBytes(
          encodedBytes,
          const VehicleCodable(),
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
            unkeyed.encodeElement(c, const CoordinateCodable());
          }
        });

        final decodedList = TestJsonDriver.decodeBytes(
          jsonBytes,
          Decodable.fromFunction((decoder) {
            final unkeyed = decoder.unkeyed();
            final result = <Coordinate>[];
            while (unkeyed.moveNext()) {
              result.add(unkeyed.decodeElement(const CoordinateCodable()));
            }
            return result;
          }),
        );

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
            unkeyed.encodeElement(p, const UserProfileCodable());
          }
        });

        final decodedList = TestJsonDriver.decodeBytes(
          jsonBytes,
          Decodable.fromFunction((decoder) {
            final unkeyed = decoder.unkeyed();
            final result = <UserProfile>[];
            while (unkeyed.moveNext()) {
              result.add(unkeyed.decodeElement(const UserProfileCodable()));
            }
            return result;
          }),
        );

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
              unkeyed.encodeElement(v, const VehicleCodable());
            }
          });

          final decodedFleet = TestJsonDriver.decodeBytes(
            jsonBytes,
            Decodable.fromFunction((decoder) {
              final unkeyed = decoder.unkeyed();
              final result = <Vehicle>[];
              while (unkeyed.moveNext()) {
                result.add(unkeyed.decodeElement(const VehicleCodable()));
              }
              return result;
            }),
          );

          check(decodedFleet).deepEquals(fleet);
        },
      );

      test('roundtrips empty lists of domain models', () {
        final emptyList = const <Coordinate>[];
        final jsonBytes = TestJsonDriver.encodeWithToBytes(
          emptyList,
          (list, encoder) => encoder.unkeyed(),
        );

        final decodedList = TestJsonDriver.decodeBytes(
          jsonBytes,
          Decodable.fromFunction((decoder) {
            final unkeyed = decoder.unkeyed();
            final result = <Coordinate>[];
            while (unkeyed.moveNext()) {
              result.add(unkeyed.decodeElement(const CoordinateCodable()));
            }
            return result;
          }),
        );

        check(decodedList).isEmpty();
      });
    });
  });

  group('Tier 3: Pairwise Cross-Feature Interactions', () {
    test('Aliased keys inside list of Coordinates in unkeyed array', () {
      const jsonStr =
          '[{"lat": 1.0, "lon": 2.0}, {"latitude": 3.0, "longitude": 4.0}, {"lat": 5.0, "longitude": 6.0}]';
      final list = TestJsonDriver.decodeString(
        jsonStr,
        Decodable.fromFunction((decoder) {
          final unkeyed = decoder.unkeyed();
          final result = <Coordinate>[];
          while (unkeyed.moveNext()) {
            result.add(unkeyed.decodeElement(const CoordinateCodable()));
          }
          return result;
        }),
      );

      check(list).deepEquals(const [
        Coordinate(latitude: 1.0, longitude: 2.0),
        Coordinate(latitude: 3.0, longitude: 4.0),
        Coordinate(latitude: 5.0, longitude: 6.0),
      ]);
    });

    test('Polymorphic Vehicle list with mixed leading, middle, and trailing discriminators', () {
      const jsonStr = '''
[
  {"type": "car", "maxSpeed": 200, "doors": 4},
  {"maxSpeed": 30, "type": "bicycle", "hasBell": true},
  {"maxSpeed": 250, "doors": 2, "type": "car"},
  {"hasBell": false, "maxSpeed": 25, "type": "bicycle"}
]
''';
      final fleet = TestJsonDriver.decodeString(
        jsonStr,
        Decodable.fromFunction((decoder) {
          final unkeyed = decoder.unkeyed();
          final result = <Vehicle>[];
          while (unkeyed.moveNext()) {
            result.add(unkeyed.decodeElement(const VehicleCodable()));
          }
          return result;
        }),
      );

      check(fleet.length).equals(4);
      check(fleet[0]).isA<Car>();
      check((fleet[0] as Car).doors).equals(4);
      check(fleet[1]).isA<Bicycle>();
      check((fleet[1] as Bicycle).hasBell).isTrue();
      check(fleet[2]).isA<Car>();
      check((fleet[2] as Car).doors).equals(2);
      check(fleet[3]).isA<Bicycle>();
      check((fleet[3] as Bicycle).hasBell).isFalse();
    });

    test('UserProfile with userInfo context map propagation', () {
      const tenantSymbol = #tenantId;
      final userInfo = {tenantSymbol: 'tenant_enterprise_1'};

      const jsonStr =
          '{"id": "usr_ctx", "email": "ctx@example.com", "role": "admin", "zip": "90210"}';
      final profile = TestJsonDriver.decodeString(
        jsonStr,
        Decodable.fromFunction((decoder) {
          check(decoder.userInfo[tenantSymbol]).equals('tenant_enterprise_1');
          return const UserProfileCodable().decode(decoder);
        }),
        userInfo: userInfo,
      );

      check(profile.id).equals('usr_ctx');

      final encodedStr = TestJsonDriver.encodeToString(
        profile,
        const UserProfileCodable(),
        userInfo: userInfo,
      );
      check(encodedStr).contains('usr_ctx');
    });

    test(
      'KeyOptions descriptors with Coordinate and UserProfile key lookups',
      () {
        final options = KeyOptions.of(const [
          'lat',
          'latitude',
          'lon',
          'longitude',
        ]);

        check(options.length).equals(4);
        check(options.indexOf('lat')).equals(0);
        check(options.indexOf('longitude')).equals(3);
        check(options.indexOf('unknown')).equals(-1);
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

      final bytes = TestJsonDriver.encodeToBytes(
        original,
        const UserWithLocationCodable(),
      );
      final reDecoded = TestJsonDriver.decodeBytes(
        bytes,
        const UserWithLocationCodable(),
      );

      check(reDecoded).equals(original);
      check(reDecoded.profile.zip).equals('94043');
      check(reDecoded.location.latitude).equals(37.4220);
    });

    group('Defensive validation & error handling regression tests', () {
      test('decodeIntList throws CodableException on malformed non-array', () {
        const jsonStr = '{"nums": "not_an_array"}';
        check(() {
          TestJsonDriver.decodeString(
            jsonStr,
            Decodable.fromFunction((decoder) {
              final mapped = decoder.mapped();
              return mapped.decodeIntList('nums');
            }),
          );
        }).throws<CodableException>();
      });

      test('decodeIntList throws CodableException on missing key', () {
        const jsonStr = '{"other": [1, 2, 3]}';
        check(() {
          TestJsonDriver.decodeString(
            jsonStr,
            Decodable.fromFunction((decoder) {
              final mapped = decoder.mapped();
              return mapped.decodeIntList('missing');
            }),
          );
        }).throws<CodableException>();
      });

      test('decodeIntList throws CodableException on invalid element type', () {
        const jsonStr = '{"nums": [1, "two", 3]}';
        check(() {
          TestJsonDriver.decodeString(
            jsonStr,
            Decodable.fromFunction((decoder) {
              final mapped = decoder.mapped();
              return mapped.decodeIntList('nums');
            }),
          );
        }).throws<CodableException>();
      });

      test('decodeDoubleList throws CodableException on malformed type', () {
        const jsonStr = '{"doubles": false}';
        check(() {
          TestJsonDriver.decodeString(
            jsonStr,
            Decodable.fromFunction((decoder) {
              final mapped = decoder.mapped();
              return mapped.decodeDoubleList('doubles');
            }),
          );
        }).throws<CodableException>();
      });

      test('decodeStringList throws CodableException on malformed type', () {
        const jsonStr = '{"tags": 123}';
        check(() {
          TestJsonDriver.decodeString(
            jsonStr,
            Decodable.fromFunction((decoder) {
              final mapped = decoder.mapped();
              return mapped.decodeStringList('tags');
            }),
          );
        }).throws<CodableException>();
      });

      test('decodeBoolList throws CodableException on malformed type', () {
        const jsonStr = '{"flags": "true"}';
        check(() {
          TestJsonDriver.decodeString(
            jsonStr,
            Decodable.fromFunction((decoder) {
              final mapped = decoder.mapped();
              return mapped.decodeBoolList('flags');
            }),
          );
        }).throws<CodableException>();
      });

      test('readNull throws CodableException on non-null field value', () {
        const jsonStr = '{"count": 42}';
        check(() {
          TestJsonDriver.decodeString(
            jsonStr,
            Decodable.fromFunction((decoder) {
              final keyed = decoder.keyed();
              keyed.nextKey();
              keyed.readNull();
            }),
          );
        }).throws<CodableException>();
      });

      test('uniform double list decoding throws on missing required field', () {
        const jsonStr = '[{"x": 1.0, "y": 2.0}]';
        check(() {
          TestJsonDriver.decodeString(
            jsonStr,
            Decodable<List<Coordinate>>.fromFunction(
              const CoordinateCodable().decodeList,
            ),
          );
        }).throws<CodableException>();
      });

      test('uniform double list decoding throws on explicit null field', () {
        const jsonStr = '[{"x": 1.0, "y": 2.0, "z": null}]';
        check(() {
          TestJsonDriver.decodeString(
            jsonStr,
            Decodable<List<Coordinate>>.fromFunction(
              const CoordinateCodable().decodeList,
            ),
          );
        }).throws<CodableException>();
      });

      test(
        'uniform double list decoding throws on non-numeric string field',
        () {
          const jsonStr = '[{"x": "not_a_number", "y": 2.0, "z": 3.0}]';
          check(() {
            TestJsonDriver.decodeString(
              jsonStr,
              Decodable<List<Coordinate>>.fromFunction(
                const CoordinateCodable().decodeList,
              ),
            );
          }).throws<CodableException>();
        },
      );

      test('Float64List decoding throws on non-numeric element', () {
        const jsonStr = '{"coordinates": [1.0, "invalid", 3.0]}';
        check(() {
          TestJsonDriver.decodeString(
            jsonStr,
            Decodable.fromFunction((decoder) {
              final mapped = decoder.mapped();
              return mapped.decodeFloat64List('coordinates');
            }),
          );
        }).throws<CodableException>();
      });

      test('adaptive payload thresholding <= 2048 bytes fast-path parity', () {
        final smallJson = utf8.encode('{"id": 42, "name": "Alice"}');
        check(smallJson.length).isLessOrEqual(2048);
        final decoder = JsonCodableDecoder.fromBytes(
          Uint8List.fromList(smallJson),
        );
        final mapped = decoder.mapped();
        check(mapped.readInt('id')).equals(42);
        check(mapped.readString('name')).equals('Alice');
      });

      test(
        'adaptive payload thresholding > 2048 bytes large payload parity',
        () {
          final padding = 'a' * 2100;
          final largeJson = utf8.encode('{"id": 100, "data": "$padding"}');
          check(largeJson.length).isGreaterThan(2048);
          final decoder = JsonCodableDecoder.fromBytes(
            Uint8List.fromList(largeJson),
          );
          final mapped = decoder.mapped();
          check(mapped.readInt('id')).equals(100);
          check(mapped.readString('data')).equals(padding);
        },
      );
    });

    group('JSON Contract Fixes: peekKind, speculative recovery, num, CodableKey, and MappedDecoder/SuperDecodable', () {
      for (final (label, padLen) in [
        ('<= 2048 bytes', 0),
        ('> 2048 bytes', 2200),
      ]) {
        group('Payload size $label', () {
          Uint8List makeBytes(String json) =>
              Uint8List.fromList(utf8.encode(json));

          test('peekKind() inspects all ValueKind variants across Decoder, Keyed, Unkeyed, SingleValue, and Mapped', () {
            final pad = 'p' * padLen;
            final raw =
                '{"n": null, "b": true, "i": 42, "d": 3.5, "s": "hello$pad", "l": [1, "two", false, null, [], {}], "m": {"k": 7}}';
            final bytes = makeBytes(raw);
            if (padLen == 0) {
              check(bytes.length).isLessOrEqual(2048);
            } else {
              check(bytes.length).isGreaterThan(2048);
            }

            // Streaming decoder path
            final dec = JsonCodableDecoder.fromBytes(bytes);
            check(dec.peekKind()).equals(ValueKind.map);
            final keyed = dec.keyed();
            final seenKinds = <String, ValueKind>{};
            while (keyed.moveNextKey()) {
              final k = keyed.nextKey();
              seenKinds[k] = keyed.peekKind();
              if (k == 'l') {
                final u = keyed.nestedDecoder().unkeyed();
                final elemKinds = <ValueKind>[];
                while (u.moveNext()) {
                  elemKinds.add(u.peekKind());
                  u.skipElement();
                }
                check(elemKinds).deepEquals([
                  ValueKind.number,
                  ValueKind.string,
                  ValueKind.boolean,
                  ValueKind.nullValue,
                  ValueKind.list,
                  ValueKind.map,
                ]);
              } else {
                keyed.skipValue();
              }
            }
            check(seenKinds['n']).equals(ValueKind.nullValue);
            check(seenKinds['b']).equals(ValueKind.boolean);
            check(seenKinds['i']).equals(ValueKind.number);
            check(seenKinds['d']).equals(ValueKind.number);
            check(seenKinds['s']).equals(ValueKind.string);
            check(seenKinds['l']).equals(ValueKind.list);
            check(seenKinds['m']).equals(ValueKind.map);

            // Mapped / _DartObjectDecoder path
            final mapped = JsonCodableDecoder.fromBytes(bytes).mapped();
            check(mapped.peekKind('n')).equals(ValueKind.nullValue);
            check(mapped.peekKind('b')).equals(ValueKind.boolean);
            check(mapped.peekKind('i')).equals(ValueKind.number);
            check(mapped.peekKind('s')).equals(ValueKind.string);
            check(mapped.peekKind('l')).equals(ValueKind.list);
            check(mapped.peekKind('m')).equals(ValueKind.map);
            check(mapped.nestedDecoder('i').singleValue().peekKind())
                .equals(ValueKind.number);
            check(mapped.nestedDecoder('s').singleValue().peekKind())
                .equals(ValueKind.string);
          });

          test('speculative primitive read failure does not advance cursor in streaming or object-tree decoders', () {
            final pad = 'x' * padLen;
            final raw =
                '{"zipStr": "02138", "zipInt": 90210, "arr": ["abc", 77], "pad": "$pad"}';
            final bytes = makeBytes(raw);

            // Reverse order: try readInt() first on a string, then fallback to readString()
            final reverseCodec = Decodable<String>.fromFunction((d) {
              final sv = d.singleValue();
              try {
                return sv.readInt().toString();
              } on Object {
                return sv.readString();
              }
            });

            // 1. Streaming JsonCodableDecoder
            final streamDec = JsonCodableDecoder.fromBytes(bytes);
            final k = streamDec.keyed();
            String? zipStr;
            String? zipInt;
            final arrItems = <String>[];
            while (k.moveNextKey()) {
              switch (k.nextKey()) {
                case 'zipStr':
                  zipStr = k.decodeValue(reverseCodec);
                case 'zipInt':
                  zipInt = k.decodeValue(reverseCodec);
                case 'arr':
                  final u = k.nestedDecoder().unkeyed();
                  while (u.moveNext()) {
                    try {
                      arrItems.add(u.readInt().toString());
                    } on Object {
                      arrItems.add(u.readString());
                    }
                  }
                default:
                  k.skipValue();
              }
            }
            check(zipStr).equals('02138');
            check(zipInt).equals('90210');
            check(arrItems).deepEquals(['abc', '77']);

            // 2. Object-tree _DartObjectDecoder via mapped()
            final mapped = JsonCodableDecoder.fromBytes(bytes).mapped();
            check(mapped.decodeKey('zipStr', reverseCodec)).equals('02138');
            check(mapped.decodeKey('zipInt', reverseCodec)).equals('90210');
          });

          test('VehicleCodable and VehicleSuperDecodable decode directly from JsonCodableDecoder.fromBytes', () {
            final pad = 'v' * padLen;
            final trailingCarJson =
                '{"pad": "$pad", "maxSpeed": 240, "doors": 2, "type": "car"}';
            final leadingBikeJson =
                '{"type": "bicycle", "pad": "$pad", "maxSpeed": 32, "hasBell": true}';

            final car1 = const VehicleCodable().decode(
              JsonCodableDecoder.fromBytes(makeBytes(trailingCarJson)),
            );
            check(car1).equals(const Car(maxSpeed: 240, doors: 2));

            final car2 = const VehicleSuperDecodable().decode(
              JsonCodableDecoder.fromBytes(makeBytes(trailingCarJson)),
            );
            check(car2).equals(const Car(maxSpeed: 240, doors: 2));

            final bike = const VehicleSuperDecodable().decode(
              JsonCodableDecoder.fromBytes(makeBytes(leadingBikeJson)),
            );
            check(bike).equals(const Bicycle(maxSpeed: 32, hasBell: true));
          });

          test('TelemetryPacket roundtrips num, List<num>, Map<String, num>, CodableKey variants, and SuperDecodable', () {
            final pad = 'n' * padLen;
            final raw = jsonEncode({
              'packetId': 9988,
              'regionZip': 94107,
              'statusCode': 'ok',
              'reading': 42,
              'delta': -1.25,
              'history': [10, 20.5, 30],
              'counters': {'hits': 7, 'ratio': 0.75},
              'vehicle': {'maxSpeed': 180, 'doors': 4, 'type': 'car'},
              'notes': pad,
            });
            final bytes = makeBytes(raw);

            // Decode via streaming JsonCodableDecoder
            final decoded = const TelemetryPacketCodable().decode(
              JsonCodableDecoder.fromBytes(bytes),
            );
            check(decoded.packetId).equals('9988');
            check(decoded.regionZip).equals('94107');
            check(decoded.statusCode).equals('ok');
            check(decoded.reading).isA<int>().equals(42);
            check(decoded.delta).isA<double>().equals(-1.25);
            check(decoded.history.length).equals(3);
            check(decoded.history[0]).isA<int>().equals(10);
            check(decoded.history[1]).isA<double>().equals(20.5);
            check(decoded.history[2]).isA<int>().equals(30);
            check(decoded.counters['hits']).isA<int>().equals(7);
            check(decoded.counters['ratio']).isA<double>().equals(0.75);
            check(decoded.vehicle).equals(const Car(maxSpeed: 180, doors: 4));

            // Decode via mapped() -> _DartObjectKeyedDecoder handoff
            final handoffDec = JsonCodableDecoder.fromBytes(bytes);
            check(handoffDec.mapped().readNum('reading')).isA<int>().equals(42);
            final fromHandoff = const TelemetryPacketCodable().decode(
              handoffDec,
            );
            check(fromHandoff.history[0]).isA<int>().equals(10);
            check(fromHandoff.vehicle)
                .equals(const Car(maxSpeed: 180, doors: 4));

            // Encode via JsonCodableEncoder and verify wire types & customEncoder
            final outBytes = JsonCodableEncoder.toBytes(
              decoded,
              const TelemetryPacketCodable(),
            );
            final outStr = utf8.decode(outBytes);
            check(outStr).contains('"statusCode":"OK"');
            check(outStr).contains('"reading":42');
            check(outStr).contains('"history":[10,20.5,30]');

            // Roundtrip via TestJsonDriver as well
            final testDecoded = TestJsonDriver.decodeBytes(
              outBytes,
              const TelemetryPacketCodable(),
            );
            check(testDecoded.statusCode).equals('OK');
            check(testDecoded.reading).isA<int>().equals(42);
            check(testDecoded.history[0]).isA<int>().equals(10);
            check(testDecoded.vehicle)
                .equals(const Car(maxSpeed: 180, doors: 4));
          });

          test('decodeIntList rejects fractional floats across streaming, object-tree, and JS DOM drivers', () {
            final pad = 'f' * padLen;
            final raw = '{"nums": [1, 2.9, 3], "pad": "$pad"}';
            final bytes = makeBytes(raw);

            // 1. Streaming KeyedDecoder (JsonTokenReader throws FormatException)
            check(() {
              final k = JsonCodableDecoder.fromBytes(bytes).keyed();
              while (k.moveNextKey()) {
                if (k.nextKey() == 'nums') {
                  k.decodeIntList();
                } else {
                  k.skipValue();
                }
              }
            }).throws<Exception>();

            // 2. Object-tree MappedDecoder & KeyedDecoder handoff
            check(() {
              JsonCodableDecoder.fromBytes(bytes)
                  .mapped()
                  .decodeIntList('nums');
            }).throws<CodableException>();

            check(() {
              final d = JsonCodableDecoder.fromBytes(bytes);
              d.mapped();
              final k = d.keyed();
              while (k.moveNextKey()) {
                if (k.nextKey() == 'nums') {
                  k.decodeIntList();
                } else {
                  k.skipValue();
                }
              }
            }).throws<CodableException>();

            // 3. Forced JS DOM path on web/wasm (streaming on VM)
            check(() {
              final k = JsonCodableDecoder.fromBytes(
                bytes,
                userInfo: const {#forceJsDom: true},
              ).keyed();
              while (k.moveNextKey()) {
                if (k.nextKey() == 'nums') {
                  k.decodeIntList();
                } else {
                  k.skipValue();
                }
              }
            }).throws<Exception>();

            // 4. TestJsonDriver oracle
            check(() {
              TestJsonDriver.decodeBytes(
                bytes,
                Decodable.fromFunction((d) => d.mapped().decodeIntList('nums')),
              );
            }).throws<CodableException>();
          });

          test('unconsumed nested mapped() buffer does not leak into sibling keyed() field', () {
            final pad = 'b' * padLen;
            final raw =
                '{"first": {"tag": "stale", "pad": "$pad"}, "second": {"tag": "fresh"}}';
            final bytes = makeBytes(raw);
            final k = JsonCodableDecoder.fromBytes(bytes).keyed();
            String? firstTag;
            String? secondTag;
            while (k.moveNextKey()) {
              switch (k.nextKey()) {
                case 'first':
                  // Inspect via mapped() WITHOUT consuming via keyed()
                  firstTag = k.nestedDecoder().mapped().readString('tag');
                case 'second':
                  final inner = k.nestedDecoder().keyed();
                  while (inner.moveNextKey()) {
                    if (inner.nextKey() == 'tag') {
                      secondTag = inner.readString();
                    } else {
                      inner.skipValue();
                    }
                  }
                default:
                  k.skipValue();
              }
            }
            check(firstTag).equals('stale');
            check(secondTag).equals('fresh');
          });
        });
      }
    });
  });

  _registerDriverFoundationsTests();
}

void _registerDriverFoundationsTests() {
  group(
    'Driver Foundations (KeyOptions, Base*Mixin, nestedEncoder, length)',
    () {
      test('length hints on UnkeyedDecoder match driver backing', () {
        const isJs = identical(1, 1.0);
        final listBytes = Uint8List.fromList(utf8.encode('[10, 20, 30]'));

        // Streaming / default fromBytes: null on VM/Wasm, 3 on dart2js DOM
        final streamList = JsonCodableDecoder.fromBytes(listBytes).unkeyed();
        check(streamList.length).equals(isJs ? 3 : null);

        // DartObject handoff via mapped() and nested array: exact length
        final handoffDec = JsonCodableDecoder.fromBytes(
          Uint8List.fromList(utf8.encode('{"a": 1, "b": 2, "arr": [5, 6, 7]}')),
        );
        final mapped = handoffDec.mapped();
        check(mapped.nestedDecoder('arr').unkeyed().length).equals(3);

        // TestJsonDriver: exact length
        check(
          TestJsonDriver.decodeString(
            '[1, 2, 3, 4]',
            Decodable.fromFunction((d) => d.unkeyed().length),
          ),
        ).equals(4);
      });

      test(
        'nestedEncoder auto-closes multi-level containers before siblings and parent close',
        _verifyNestedEncoderAutoClosing,
      );

      test(
        'KeyOptions.compiled<T> isolates distinct driver cache types on a shared instance',
        _verifyKeyOptionsMultiTypeCompiledCache,
      );

      test(
        'Base*Mixin defaults support minimal drivers across all 7 decoder and encoder mixins',
        _verifyBaseMixinsDefaults,
      );
    },
  );
}

void _verifyNestedEncoderAutoClosing() {
  void encodeComplex(int _, Encoder encoder) {
    final root = encoder.keyed(length: 3);
    final nested = root.nestedEncoder('matrix').keyed(length: 2);

    final list1 = nested.nestedEncoder('1').unkeyed(length: 2);
    final obj1 = list1.nestedEncoder().keyed(length: 1);
    obj1.encodeString('tag', 'a');
    list1.encodeInt(99);

    final list2 = nested.nestedEncoder('2').unkeyed(length: 1);
    list2.encodeInt(7);

    root.encodeBool('active', true);

    final tail = root.nestedEncoder('tail').unkeyed(length: 1);
    final tailObj = tail.nestedEncoder().keyed(length: 1);
    tailObj.encodeInt('done', 1);
  }

  final encodable = Encodable.fromFunction(encodeComplex);
  final jsonOut = JsonCodableEncoder.encode(0, encodable);
  const expected =
      '{"matrix":{"1":[{"tag":"a"},99],"2":[7]},"active":true,"tail":[{"done":1}]}';
  check(jsonOut).equals(expected);

  final bytesOut = JsonCodableEncoder.toBytes(0, encodable);
  check(utf8.decode(bytesOut)).equals(expected);

  final testOut = TestJsonDriver.encodeToString(0, encodable);
  check(testOut).equals(expected);
}

final class _FakeDriverCompiledA {
  final List<int> lengths;
  _FakeDriverCompiledA(List<String> keys)
    : lengths = [for (final k in keys) k.length];
}

final class _FakeDriverCompiledB {
  final String joined;
  _FakeDriverCompiledB(List<String> keys) : joined = keys.join('|');
}

final class _FakeDriverCompiledC {
  final Map<String, String> upper;
  _FakeDriverCompiledC(List<String> keys)
    : upper = {for (final k in keys) k: k.toUpperCase()};
}

void _verifyKeyOptionsMultiTypeCompiledCache() {
  final options = KeyOptions.of(['alpha', 'beta', 'gamma']);
  var countA = 0;
  var countB = 0;
  var countC = 0;

  final a1 = options.compiled<_FakeDriverCompiledA>((keys) {
    countA++;
    return _FakeDriverCompiledA(keys);
  });
  check(countA).equals(1);
  check(a1.lengths).deepEquals([5, 4, 5]);

  // Repeated primary-slot hit does not re-run compile callback.
  final a2 = options.compiled<_FakeDriverCompiledA>((keys) {
    countA++;
    return _FakeDriverCompiledA(keys);
  });
  check(identical(a1, a2)).isTrue();
  check(countA).equals(1);

  // Distinct driver types populate secondary storage without clobbering A.
  final b1 = options.compiled<_FakeDriverCompiledB>((keys) {
    countB++;
    return _FakeDriverCompiledB(keys);
  });
  final c1 = options.compiled<_FakeDriverCompiledC>((keys) {
    countC++;
    return _FakeDriverCompiledC(keys);
  });
  check(countB).equals(1);
  check(countC).equals(1);
  check(b1.joined).equals('alpha|beta|gamma');
  check(c1.upper['beta']).equals('BETA');

  // Interleaved JSON streaming decode on the exact same KeyOptions instance.
  final jsonBytes = Uint8List.fromList(
    utf8.encode('{"beta": 42, "gamma": "ok"}'),
  );
  final keyed = JsonCodableDecoder.fromBytes(jsonBytes).keyed(options: options);
  check(keyed.moveNextKey()).isTrue();
  check(keyed.selectKeyIndex(options)).equals(1);
  check(keyed.readInt()).equals(42);
  check(keyed.moveNextKey()).isTrue();
  check(keyed.selectKeyIndex(options)).equals(2);
  check(keyed.selectStringIndex(KeyOptions.of(['no', 'ok']))).equals(1);
  check(keyed.moveNextKey()).isFalse();

  // All previously cached representations remain intact and identical.
  check(
    identical(
      a1,
      options.compiled<_FakeDriverCompiledA>((_) => throw StateError('cached')),
    ),
  ).isTrue();
  check(
    identical(
      b1,
      options.compiled<_FakeDriverCompiledB>((_) => throw StateError('cached')),
    ),
  ).isTrue();
  check(
    identical(
      c1,
      options.compiled<_FakeDriverCompiledC>((_) => throw StateError('cached')),
    ),
  ).isTrue();
}

final class _MinimalDriverDecoder implements Decoder {
  final Object? _node;
  final bool reportUnkeyedLength;
  @override
  final Map<Object, Object?> userInfo;

  _MinimalDriverDecoder(
    this._node, {
    this.reportUnkeyedLength = false,
    this.userInfo = const {},
  });

  @override
  Uint8List? get payload => null;

  @override
  ValueKind peekKind() => _testValueKind(_node);

  @override
  KeyedDecoder keyed({KeyOptions? options}) => _MinimalKeyedDecoder(
    (_node as Map<String, Object?>).entries.toList(),
    reportUnkeyedLength,
    userInfo,
  );

  @override
  MappedDecoder mapped() => _MinimalMappedDecoder(
    _node as Map<String, Object?>,
    reportUnkeyedLength,
    userInfo,
  );

  @override
  UnkeyedDecoder unkeyed() => _MinimalUnkeyedDecoder(
    _node as List<Object?>,
    reportUnkeyedLength,
    userInfo,
  );

  @override
  SingleValueDecoder singleValue() =>
      _MinimalSingleValueDecoder(_node, reportUnkeyedLength, userInfo);

  @override
  Float64List? decodeUniformDoubleList(List<List<String>> propertyAliases) =>
      null;
}

final class _MinimalKeyedDecoder with BaseKeyedDecoderMixin {
  final List<MapEntry<String, Object?>> _entries;
  final bool _reportUnkeyedLength;
  final Map<Object, Object?> _userInfo;
  int _idx = -1;

  _MinimalKeyedDecoder(
    this._entries,
    this._reportUnkeyedLength,
    this._userInfo,
  );

  Object? get _val => _entries[_idx].value;

  @override
  bool moveNextKey() => _idx + 1 < _entries.length;

  @override
  String nextKey() => _entries[++_idx].key;

  @override
  ValueKind peekKind() => _testValueKind(_val);

  @override
  void skipValue() {}

  @override
  void readNull() {
    if (_val != null) throw const CodableException('Expected null');
  }

  @override
  int readInt() => _val as int;

  @override
  double readDouble() => (_val as num).toDouble();

  @override
  num readNum() => _val as num;

  @override
  String readString() => _val as String;

  @override
  bool readBool() => _val as bool;

  @override
  Decoder nestedDecoder() => _MinimalDriverDecoder(
    _val,
    reportUnkeyedLength: _reportUnkeyedLength,
    userInfo: _userInfo,
  );
}

final class _MinimalMappedDecoder with BaseMappedDecoderMixin {
  final Map<String, Object?> _map;
  final bool _reportUnkeyedLength;
  final Map<Object, Object?> _userInfo;

  _MinimalMappedDecoder(this._map, this._reportUnkeyedLength, this._userInfo);

  @override
  bool containsKey(String key) => _map.containsKey(key);

  @override
  ValueKind peekKind(String key) => _testValueKind(_map[key]);

  @override
  int readInt(String key) => _map[key] as int;

  @override
  double readDouble(String key) => (_map[key] as num).toDouble();

  @override
  num readNum(String key) => _map[key] as num;

  @override
  String readString(String key) => _map[key] as String;

  @override
  bool readBool(String key) => _map[key] as bool;

  @override
  Decoder nestedDecoder(String key) => _MinimalDriverDecoder(
    _map[key],
    reportUnkeyedLength: _reportUnkeyedLength,
    userInfo: _userInfo,
  );
}

final class _MinimalUnkeyedDecoder with BaseUnkeyedDecoderMixin {
  final List<Object?> _items;
  final bool _reportLength;
  final Map<Object, Object?> _userInfo;
  int _idx = -1;

  _MinimalUnkeyedDecoder(this._items, this._reportLength, this._userInfo);

  @override
  int? get length => _reportLength ? _items.length : super.length;

  Object? get _val => _items[_idx];

  @override
  bool moveNext() {
    if (_idx + 1 >= _items.length) return false;
    _idx++;
    return true;
  }

  @override
  ValueKind peekKind() => _testValueKind(_val);

  @override
  void readNull() {
    if (_val != null) throw const CodableException('Expected null');
  }

  @override
  void skipElement() {}

  @override
  int readInt() => _val as int;

  @override
  double readDouble() => (_val as num).toDouble();

  @override
  num readNum() => _val as num;

  @override
  String readString() => _val as String;

  @override
  bool readBool() => _val as bool;

  @override
  Decoder nestedDecoder() => _MinimalDriverDecoder(
    _val,
    reportUnkeyedLength: _reportLength,
    userInfo: _userInfo,
  );
}

final class _MinimalSingleValueDecoder with BaseSingleValueDecoderMixin {
  final Object? _val;
  final bool _reportLength;
  final Map<Object, Object?> _userInfo;

  _MinimalSingleValueDecoder(this._val, this._reportLength, this._userInfo);

  @override
  ValueKind peekKind() => _testValueKind(_val);

  @override
  void readNull() {
    if (_val != null) throw const CodableException('Expected null');
  }

  @override
  int readInt() => _val as int;

  @override
  double readDouble() => (_val as num).toDouble();

  @override
  num readNum() => _val as num;

  @override
  String readString() => _val as String;

  @override
  bool readBool() => _val as bool;

  @override
  Decoder nestedDecoder() => _MinimalDriverDecoder(
    _val,
    reportUnkeyedLength: _reportLength,
    userInfo: _userInfo,
  );
}

final class _MinimalDriverEncoder implements Encoder {
  final void Function(Object?)? onOut;
  final List<int?> recordedUnkeyedLengths;
  Object? output;
  @override
  final Map<Object, Object?> userInfo;

  _MinimalDriverEncoder({
    this.onOut,
    List<int?>? recordedUnkeyedLengths,
    this.userInfo = const {},
  }) : recordedUnkeyedLengths = recordedUnkeyedLengths ?? <int?>[];

  void _emit(Object? v) {
    output = v;
    onOut?.call(v);
  }

  @override
  KeyedEncoder keyed({KeyOptions? options, int? length}) {
    final map = <String, Object?>{};
    _emit(map);
    return _MinimalKeyedEncoder(map, recordedUnkeyedLengths, userInfo);
  }

  @override
  UnkeyedEncoder unkeyed({int? length}) {
    recordedUnkeyedLengths.add(length);
    final list = <Object?>[];
    _emit(list);
    return _MinimalUnkeyedEncoder(list, recordedUnkeyedLengths, userInfo);
  }

  @override
  SingleValueEncoder singleValue() => _MinimalSingleValueEncoder(this);
}

final class _MinimalKeyedEncoder with BaseKeyedEncoderMixin {
  final Map<String, Object?> _map;
  final List<int?> _lengths;
  final Map<Object, Object?> _userInfo;

  _MinimalKeyedEncoder(this._map, this._lengths, this._userInfo);

  @override
  void encodeInt(String key, int value) => _map[key] = value;

  @override
  void encodeDouble(String key, double value) => _map[key] = value;

  @override
  void encodeString(String key, String value) => _map[key] = value;

  @override
  void encodeBool(String key, bool value) => _map[key] = value;

  @override
  void encodeNull(String key) => _map[key] = null;

  @override
  Encoder nestedEncoder(String key) => _MinimalDriverEncoder(
    onOut: (v) => _map[key] = v,
    recordedUnkeyedLengths: _lengths,
    userInfo: _userInfo,
  );
}

final class _MinimalUnkeyedEncoder with BaseUnkeyedEncoderMixin {
  final List<Object?> _list;
  final List<int?> _lengths;
  final Map<Object, Object?> _userInfo;

  _MinimalUnkeyedEncoder(this._list, this._lengths, this._userInfo);

  @override
  void encodeInt(int value) => _list.add(value);

  @override
  void encodeDouble(double value) => _list.add(value);

  @override
  void encodeString(String value) => _list.add(value);

  @override
  void encodeBool(bool value) => _list.add(value);

  @override
  void encodeNull() => _list.add(null);

  @override
  Encoder nestedEncoder() {
    final slot = _list.length;
    _list.add(null);
    return _MinimalDriverEncoder(
      onOut: (v) => _list[slot] = v,
      recordedUnkeyedLengths: _lengths,
      userInfo: _userInfo,
    );
  }
}

final class _MinimalSingleValueEncoder with BaseSingleValueEncoderMixin {
  final _MinimalDriverEncoder _parent;

  _MinimalSingleValueEncoder(this._parent);

  @override
  void encodeInt(int value) => _parent._emit(value);

  @override
  void encodeDouble(double value) => _parent._emit(value);

  @override
  void encodeString(String value) => _parent._emit(value);

  @override
  void encodeBool(bool value) => _parent._emit(value);

  @override
  void encodeNull() => _parent._emit(null);

  @override
  void encode<T>(T value, Encodable<T> encodable) =>
      encodable.encode(value, _parent);
}

void _verifyBaseMixinsDefaults() {
  final enc = _MinimalDriverEncoder();
  final kEnc = enc.keyed();
  kEnc.encodeNullableInt('ni', null);
  kEnc.encodeNullableInt('pi', 7);
  kEnc.encodeNullableDouble('nd', null);
  kEnc.encodeNullableDouble('pd', 3.5);
  kEnc.encodeNullableString('ns', null);
  kEnc.encodeNullableString('ps', 'role_a');
  kEnc.encodeNullableBool('nb', null);
  kEnc.encodeNullableBool('pb', true);
  kEnc.encodeNullableValue('ncoord', null, const CoordinateCodable());
  kEnc.encodeNullableValue(
    'coord',
    const Coordinate(latitude: 10.0, longitude: 20.0),
    const CoordinateCodable(),
  );
  kEnc.encodeList(
    'lazyCoords',
    [const Coordinate(latitude: 1.0, longitude: 2.0)].where((_) => true),
    const CoordinateCodable(),
  );
  kEnc.encodeList('sizedCoords', const [
    Coordinate(latitude: 3.0, longitude: 4.0),
  ], const CoordinateCodable());
  kEnc.encodeIntList('ints', [10, 20]);
  kEnc.encodeDoubleList('doubles', [1.25, 2.5]);
  kEnc.encodeStringList('strings', ['x', 'y']);
  kEnc.encodeBoolList('bools', [true, false]);

  final outMap = enc.output as Map<String, Object?>;
  // BaseKeyedEncoderMixin omits null keys and passes length hints appropriately.
  check(outMap.containsKey('ni')).isFalse();
  check(outMap.containsKey('nd')).isFalse();
  check(outMap.containsKey('ns')).isFalse();
  check(outMap.containsKey('nb')).isFalse();
  check(outMap.containsKey('ncoord')).isFalse();
  check(enc.recordedUnkeyedLengths).deepEquals([null, 1, 2, 2, 2, 2]);

  outMap['nullField'] = null;

  _verifyMinimalKeyedAndMappedDecode(outMap, reportLength: false);
  _verifyMinimalKeyedAndMappedDecode(outMap, reportLength: true);
  _verifyMinimalUnkeyedAndSingleValueMixins();
}

void _verifyMinimalKeyedAndMappedDecode(
  Map<String, Object?> source, {
  required bool reportLength,
}) {
  final options = KeyOptions.of([
    'pi',
    'pd',
    'ps',
    'pb',
    'coord',
    'lazyCoords',
    'sizedCoords',
    'ints',
    'doubles',
    'strings',
    'bools',
    'nullField',
  ]);
  final roleOpts = KeyOptions.of(['other', 'role_a']);

  final kd = _MinimalDriverDecoder(
    source,
    reportUnkeyedLength: reportLength,
  ).keyed(options: options);
  check(kd.peekKey()).isNull();

  check(kd.selectKeyIndex(options)).equals(0);
  check(kd.readNullableInt()).equals(7);
  check(kd.selectKeyIndex(options)).equals(1);
  check(kd.readNullableDouble()).equals(3.5);
  check(kd.selectKeyIndex(options)).equals(2);
  check(kd.readStringSpan).throws<UnsupportedError>();
  check(kd.readNullableStringSpan).throws<UnsupportedError>();
  check(kd.selectStringIndex(roleOpts)).equals(1);
  check(kd.selectKeyIndex(options)).equals(3);
  check(kd.readNullableBool()).equals(true);
  check(kd.selectKeyIndex(options)).equals(4);
  check(kd.decodeNullableValue(const CoordinateCodable()))
      .equals(const Coordinate(latitude: 10.0, longitude: 20.0));
  check(kd.selectKeyIndex(options)).equals(5);
  check(kd.decodeNullableList(const CoordinateCodable()))
      .isNotNull()
      .deepEquals([const Coordinate(latitude: 1.0, longitude: 2.0)]);
  check(kd.selectKeyIndex(options)).equals(6);
  check(kd.decodeList(const CoordinateCodable()))
      .deepEquals([const Coordinate(latitude: 3.0, longitude: 4.0)]);
  check(kd.selectKeyIndex(options)).equals(7);
  check(kd.decodeIntList()).deepEquals([10, 20]);
  check(kd.selectKeyIndex(options)).equals(8);
  check(kd.decodeFloat64List()).deepEquals([1.25, 2.5]);
  check(kd.selectKeyIndex(options)).equals(9);
  check(kd.decodeStringList()).deepEquals(['x', 'y']);
  check(kd.selectKeyIndex(options)).equals(10);
  check(kd.decodeBoolList()).deepEquals([true, false]);
  check(kd.selectKeyIndex(options)).equals(11);
  check(kd.readNullableStringSpan()).isNull();
  check(kd.readNullableNum()).isNull();
  check(kd.decodeNullableValue(const CoordinateCodable())).isNull();
  check(kd.decodeNullableList(const CoordinateCodable())).isNull();
  check(kd.selectKeyIndex(options)).equals(-1);

  final md = _MinimalDriverDecoder(
    source,
    reportUnkeyedLength: reportLength,
  ).mapped();
  check(md.isNull('missing')).isTrue();
  check(md.isNull('nullField')).isTrue();
  check(md.readNullableInt('missing')).isNull();
  check(md.readNullableDouble('nullField')).isNull();
  check(md.readNullableNum('pi')).equals(7);
  check(md.readNullableString('ps')).equals('role_a');
  check(md.readNullableBool('pb')).equals(true);
  check(md.decodeNullableKey('missing', const CoordinateCodable())).isNull();
  check(md.decodeNullableKey('coord', const CoordinateCodable()))
      .equals(const Coordinate(latitude: 10.0, longitude: 20.0));
  check(md.decodeListKey('sizedCoords', const CoordinateCodable()))
      .deepEquals([const Coordinate(latitude: 3.0, longitude: 4.0)]);
  check(md.decodeIntList('ints')).deepEquals([10, 20]);
  check(md.decodeDoubleList('doubles')).deepEquals([1.25, 2.5]);
  check(md.decodeFloat64List('doubles')).deepEquals([1.25, 2.5]);
  check(md.decodeStringList('strings')).deepEquals(['x', 'y']);
  check(md.decodeBoolList('bools')).deepEquals([true, false]);
}

void _verifyMinimalUnkeyedAndSingleValueMixins() {
  final uEnc = _MinimalDriverEncoder();
  final u = uEnc.unkeyed();
  u.encodeNullableInt(null);
  u.encodeNullableInt(3);
  u.encodeNullableDouble(null);
  u.encodeNullableString(null);
  u.encodeNullableBool(null);
  u.encodeNullableElement(null, const CoordinateCodable());
  u.encodeNullableElement(
    const Coordinate(latitude: 5.0, longitude: 6.0),
    const CoordinateCodable(),
  );

  final ud = _MinimalDriverDecoder(uEnc.output).unkeyed();
  check(ud.length).isNull();
  check(ud.moveNext()).isTrue();
  check(ud.readNullableInt()).isNull();
  check(ud.moveNext()).isTrue();
  check(ud.readNullableInt()).equals(3);
  check(ud.moveNext()).isTrue();
  check(ud.readNullableDouble()).isNull();
  check(ud.moveNext()).isTrue();
  check(ud.readNullableString()).isNull();
  check(ud.moveNext()).isTrue();
  check(ud.readNullableBool()).isNull();
  check(ud.moveNext()).isTrue();
  check(ud.decodeNullableElement(const CoordinateCodable())).isNull();
  check(ud.moveNext()).isTrue();
  check(ud.decodeNullableElement(const CoordinateCodable()))
      .equals(const Coordinate(latitude: 5.0, longitude: 6.0));
  check(ud.moveNext()).isFalse();

  // SingleValueEncoder & SingleValueDecoder nullable defaults
  final svEnc = _MinimalDriverEncoder();
  svEnc.singleValue().encodeNullableInt(null);
  check(_MinimalDriverDecoder(svEnc.output).singleValue().readNullableInt())
      .isNull();
  check(
    _MinimalDriverDecoder(svEnc.output).singleValue().readNullableStringSpan(),
  ).isNull();
}
