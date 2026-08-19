// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: lines_longer_than_80_chars

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

  // Pre-Encoded UTF-8 Wire Bytes
  static final Uint8List nameLatitudeBytes = Uint8List.fromList(const [
    108,
    97,
    116,
    105,
    116,
    117,
    100,
    101,
  ]);
  static final Uint8List nameLongitudeBytes = Uint8List.fromList(const [
    108,
    111,
    110,
    103,
    105,
    116,
    117,
    100,
    101,
  ]);

  // Key Indices for selectName()
  static const int keyLatitude = 0;
  static const String aliasLatitudeLat = 'lat';
  static const int aliasKeyLatitudeLat = 1;
  static const int keyLongitude = 2;
  static const String aliasLongitudeLon = 'lon';
  static const int aliasKeyLongitudeLon = 3;

  // Pre-Compiled JsonKeyOptions
  static final JsonKeyOptions options = JsonKeyOptions.of(const [
    _$CoordinateSchema.nameLatitude,
    _$CoordinateSchema.aliasLatitudeLat,
    _$CoordinateSchema.nameLongitude,
    _$CoordinateSchema.aliasLongitudeLon,
  ]);

  // Bitmask Flags strictly for Required Fields
  static const _$CoordinateSchema none = _$CoordinateSchema(0);
  static const int _latitudeBit = 1 << 0;
  static const _$CoordinateSchema latitude = _$CoordinateSchema(_latitudeBit);
  static const int _longitudeBit = 1 << 1;
  static const _$CoordinateSchema longitude = _$CoordinateSchema(_longitudeBit);

  // Composite Golden Mask for Required Fields
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
// 2. Single-Pass Streaming Deserializer for Coordinate
// =============================================================================
Coordinate _$CoordinateFromReader(JsonTokenReader reader) {
  reader.beginObject();

  double? latitude;
  double? longitude;
  var seen = _$CoordinateSchema.none;

  while (reader.hasNext()) {
    switch (reader.selectName(_$CoordinateSchema.options)) {
      case _$CoordinateSchema.keyLatitude:
      case _$CoordinateSchema.aliasKeyLatitudeLat:
        if ((seen._value & _$CoordinateSchema.latitude._value) != 0) {
          throw const CodableException('Duplicate field "latitude"');
        }
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          latitude = reader.readDouble();
          seen |= _$CoordinateSchema.latitude;
        }
        break;
      case _$CoordinateSchema.keyLongitude:
      case _$CoordinateSchema.aliasKeyLongitudeLon:
        if ((seen._value & _$CoordinateSchema.longitude._value) != 0) {
          throw const CodableException('Duplicate field "longitude"');
        }
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          longitude = reader.readDouble();
          seen |= _$CoordinateSchema.longitude;
        }
        break;
      default:
        reader.skipValue();
        break;
    }
  }
  reader.endObject();

  // Inlined fast-path check
  seen.validate();

  return Coordinate(latitude: latitude!, longitude: longitude!);
}

// =============================================================================
// 3. Single-Pass Streaming Serializer for Coordinate
// =============================================================================
void _$CoordinateToWriter(Coordinate instance, JsonTokenWriter writer) {
  writer.beginObject();
  writer.writeNameBytes(_$CoordinateSchema.nameLatitudeBytes);
  writer.writeDouble(instance.latitude);
  writer.writeNameBytes(_$CoordinateSchema.nameLongitudeBytes);
  writer.writeDouble(instance.longitude);
  writer.endObject();
}
