// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: lines_longer_than_80_chars, unnecessary_lambdas, deprecated_member_use, unused_element

part of 'coordinate.dart';

// **************************************************************************
// CodableGenerator
// **************************************************************************

// =============================================================================
// 1. Unified Schema Descriptor for Coordinate
// =============================================================================
extension type const _$CoordinateSchema(int _value) {
  // String Name Constants
  static const String nameLatitude = 'latitude';
  static const String nameLongitude = 'longitude';

  // Pre-encoded UTF-8 Wire Name Bytes and StaticKeys
  static const List<int> wireNameBytesLatitude = [
    34,
    108,
    97,
    116,
    105,
    116,
    117,
    100,
    101,
    34,
  ];
  static const StaticKey staticKeyLatitude = StaticKey(
    nameLatitude,
    keyLatitude,
    wireNameBytesLatitude,
  );
  static const List<int> wireNameBytesLongitude = [
    34,
    108,
    111,
    110,
    103,
    105,
    116,
    117,
    100,
    101,
    34,
  ];
  static const StaticKey staticKeyLongitude = StaticKey(
    nameLongitude,
    keyLongitude,
    wireNameBytesLongitude,
  );

  // Key Indices for selectKeyIndex()
  static const int keyLatitude = 0;
  static const String aliasLatitudeLat = 'lat';
  static const int aliasKeyLatitudeLat = 1;
  static const int keyLongitude = 2;
  static const String aliasLongitudeLon = 'lon';
  static const int aliasKeyLongitudeLon = 3;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
    _$CoordinateSchema.nameLatitude,
    _$CoordinateSchema.aliasLatitudeLat,
    _$CoordinateSchema.nameLongitude,
    _$CoordinateSchema.aliasLongitudeLon,
  ]);
  static final KeyOptions keyOptions = options;

  // Bitmask Flags strictly for Required Fields
  static const _$CoordinateSchema none = _$CoordinateSchema(0);
  static const int _latitudeBit = 1 << 0;
  static const _$CoordinateSchema latitude = _$CoordinateSchema(_latitudeBit);
  static const int _longitudeBit = 1 << 1;
  static const _$CoordinateSchema longitude = _$CoordinateSchema(_longitudeBit);

  // Combined Golden Bitmask for fast single-instruction check
  static const _$CoordinateSchema golden = _$CoordinateSchema(
    _latitudeBit | _longitudeBit,
  );

  @pragma('vm:prefer-inline')
  _$CoordinateSchema operator |(_$CoordinateSchema other) =>
      _$CoordinateSchema(_value | other._value);

  /// Validates required fields in 1 CPU test instruction on the fast path.
  @pragma('vm:prefer-inline')
  void validate() {
    if ((_value & golden._value) != golden._value) {
      _throwMissingFields();
    }
  }

  /// Out-of-line cold diagnostic reporting
  void _throwMissingFields() {
    final missing = <String>[];
    if ((_value & _latitudeBit) == 0) {
      missing.add(nameLatitude);
    }
    if ((_value & _longitudeBit) == 0) {
      missing.add(nameLongitude);
    }
    throw CodableException(
      'Missing required fields for Coordinate: ${missing.join(", ")}',
    );
  }
}

// =============================================================================
// 2. Universal Keyed Deserializer for Coordinate
// =============================================================================
Coordinate _$CoordinateFromDecoder(Decoder decoder) {
  final keyed = decoder.keyed(options: _$CoordinateSchema.keyOptions);

  double? latitude;
  double? longitude;
  var seen = _$CoordinateSchema.none;

  while (keyed.hasNextKey()) {
    switch (keyed.selectKeyIndex(_$CoordinateSchema.keyOptions)) {
      case _$CoordinateSchema.keyLatitude:
      case _$CoordinateSchema.aliasKeyLatitudeLat:
        if ((seen._value & _$CoordinateSchema.latitude._value) != 0) {
          throw const CodableException('Duplicate field "latitude"');
        }
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          latitude = keyed.readDouble();
          seen |= _$CoordinateSchema.latitude;
        }
        break;
      case _$CoordinateSchema.keyLongitude:
      case _$CoordinateSchema.aliasKeyLongitudeLon:
        if ((seen._value & _$CoordinateSchema.longitude._value) != 0) {
          throw const CodableException('Duplicate field "longitude"');
        }
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          longitude = keyed.readDouble();
          seen |= _$CoordinateSchema.longitude;
        }
        break;
      default:
        keyed.skipValue();
        break;
    }
  }

  // Inlined fast-path check
  seen.validate();

  return Coordinate(latitude: latitude!, longitude: longitude!);
}

// =============================================================================
// 3. Universal Serializer for Coordinate
// =============================================================================
void _$CoordinateToEncoder(Coordinate instance, Encoder encoder) {
  final keyed = encoder.keyed();
  keyed.encodeDoubleKey(
    _$CoordinateSchema.staticKeyLatitude,
    instance.latitude,
  );
  keyed.encodeDoubleKey(
    _$CoordinateSchema.staticKeyLongitude,
    instance.longitude,
  );
}
