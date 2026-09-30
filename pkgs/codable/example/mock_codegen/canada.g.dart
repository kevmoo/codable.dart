// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: lines_longer_than_80_chars, unnecessary_lambdas, deprecated_member_use, unused_element

part of 'canada.dart';

// =============================================================================
// 1. Unified Schema Descriptor for CanadaProperties
// =============================================================================
extension type const _$CanadaPropertiesSchema(int _value) {
  // String Name Constants
  static const String nameName = 'name';

  // Key Indices for selectKeyIndex()
  static const int keyName = 0;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
    _$CanadaPropertiesSchema.nameName,
  ]);
  static final KeyOptions keyOptions = options;

  // Bitmask Flags strictly for Required Fields
  static const _$CanadaPropertiesSchema none = _$CanadaPropertiesSchema(0);
  static const int _nameBit = 1 << 0;
  static const _$CanadaPropertiesSchema name = _$CanadaPropertiesSchema(
    _nameBit,
  );

  // Combined Golden Bitmask for fast single-instruction check
  static const _$CanadaPropertiesSchema golden = _$CanadaPropertiesSchema(
    _nameBit,
  );

  @pragma('vm:prefer-inline')
  _$CanadaPropertiesSchema operator |(_$CanadaPropertiesSchema other) =>
      _$CanadaPropertiesSchema(_value | other._value);

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
    if ((_value & _nameBit) == 0) {
      missing.add(nameName);
    }
    throw CodableException(
      'Missing required fields for CanadaProperties: ${missing.join(", ")}',
    );
  }
}

// =============================================================================
// 2. Companion Codable for CanadaProperties
// =============================================================================
final class CanadaPropertiesCodable implements Codable<CanadaProperties> {
  const CanadaPropertiesCodable();

  @override
  CanadaProperties decode(Decoder decoder) {
    final keyed = decoder.keyed(options: _$CanadaPropertiesSchema.keyOptions);

    String? name;
    var seen = _$CanadaPropertiesSchema.none;

    while (keyed.moveNextKey()) {
      switch (keyed.selectKeyIndex(_$CanadaPropertiesSchema.keyOptions)) {
        case _$CanadaPropertiesSchema.keyName:
          if ((seen._value & _$CanadaPropertiesSchema.name._value) != 0) {
            throw const CodableException('Duplicate field "name"');
          }
          name = keyed.readString();
          seen |= _$CanadaPropertiesSchema.name;
          break;
        default:
          keyed.skipValue();
          break;
      }
    }

    // Inlined fast-path check
    seen.validate();

    return CanadaProperties(name: name!);
  }

  @override
  void encode(CanadaProperties instance, Encoder encoder) {
    final keyed = encoder.keyed();
    keyed.encodeString(_$CanadaPropertiesSchema.nameName, instance.name);
  }
}

// =============================================================================
// 1. Unified Schema Descriptor for CanadaGeometry
// =============================================================================
extension type const _$CanadaGeometrySchema(int _value) {
  // String Name Constants
  static const String nameType = 'type';
  static const String nameCoordinates = 'coordinates';

  // Key Indices for selectKeyIndex()
  static const int keyType = 0;
  static const int keyCoordinates = 1;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
    _$CanadaGeometrySchema.nameType,
    _$CanadaGeometrySchema.nameCoordinates,
  ]);
  static final KeyOptions keyOptions = options;

  // Bitmask Flags strictly for Required Fields
  static const _$CanadaGeometrySchema none = _$CanadaGeometrySchema(0);
  static const int _typeBit = 1 << 0;
  static const _$CanadaGeometrySchema type = _$CanadaGeometrySchema(_typeBit);

  // Combined Golden Bitmask for fast single-instruction check
  static const _$CanadaGeometrySchema golden = _$CanadaGeometrySchema(_typeBit);

  @pragma('vm:prefer-inline')
  _$CanadaGeometrySchema operator |(_$CanadaGeometrySchema other) =>
      _$CanadaGeometrySchema(_value | other._value);

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
    if ((_value & _typeBit) == 0) {
      missing.add(nameType);
    }
    throw CodableException(
      'Missing required fields for CanadaGeometry: ${missing.join(", ")}',
    );
  }
}

// =============================================================================
// 2. Companion Codable for CanadaGeometry
// =============================================================================
final class CanadaGeometryCodable implements Codable<CanadaGeometry> {
  const CanadaGeometryCodable();

  @override
  CanadaGeometry decode(Decoder decoder) {
    final keyed = decoder.keyed(options: _$CanadaGeometrySchema.keyOptions);

    String? type;
    var coordinates = const <List<Float64List>>[];
    var seen = _$CanadaGeometrySchema.none;

    while (keyed.moveNextKey()) {
      switch (keyed.selectKeyIndex(_$CanadaGeometrySchema.keyOptions)) {
        case _$CanadaGeometrySchema.keyType:
          if ((seen._value & _$CanadaGeometrySchema.type._value) != 0) {
            throw const CodableException('Duplicate field "type"');
          }
          type = keyed.readString();
          seen |= _$CanadaGeometrySchema.type;
          break;
        case _$CanadaGeometrySchema.keyCoordinates:
          coordinates = keyed.decodeValue(const CanadaCoordinatesDecoder());
          break;
        default:
          keyed.skipValue();
          break;
      }
    }

    // Inlined fast-path check
    seen.validate();

    return CanadaGeometry(type: type!, coordinates: coordinates);
  }

  @override
  void encode(CanadaGeometry instance, Encoder encoder) {
    final keyed = encoder.keyed();
    keyed.encodeString(_$CanadaGeometrySchema.nameType, instance.type);
    keyed.encodeValue(
      _$CanadaGeometrySchema.nameCoordinates,
      instance.coordinates,
      const CanadaCoordinatesDecoder(),
    );
  }
}

// =============================================================================
// 1. Unified Schema Descriptor for CanadaFeature
// =============================================================================
extension type const _$CanadaFeatureSchema(int _value) {
  // String Name Constants
  static const String nameType = 'type';
  static const String nameProperties = 'properties';
  static const String nameGeometry = 'geometry';

  // Key Indices for selectKeyIndex()
  static const int keyType = 0;
  static const int keyProperties = 1;
  static const int keyGeometry = 2;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
    _$CanadaFeatureSchema.nameType,
    _$CanadaFeatureSchema.nameProperties,
    _$CanadaFeatureSchema.nameGeometry,
  ]);
  static final KeyOptions keyOptions = options;

  // Bitmask Flags strictly for Required Fields
  static const _$CanadaFeatureSchema none = _$CanadaFeatureSchema(0);
  static const int _typeBit = 1 << 0;
  static const _$CanadaFeatureSchema type = _$CanadaFeatureSchema(_typeBit);
  static const int _propertiesBit = 1 << 1;
  static const _$CanadaFeatureSchema properties = _$CanadaFeatureSchema(
    _propertiesBit,
  );
  static const int _geometryBit = 1 << 2;
  static const _$CanadaFeatureSchema geometry = _$CanadaFeatureSchema(
    _geometryBit,
  );

  // Combined Golden Bitmask for fast single-instruction check
  static const _$CanadaFeatureSchema golden = _$CanadaFeatureSchema(
    _typeBit | _propertiesBit | _geometryBit,
  );

  @pragma('vm:prefer-inline')
  _$CanadaFeatureSchema operator |(_$CanadaFeatureSchema other) =>
      _$CanadaFeatureSchema(_value | other._value);

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
    if ((_value & _typeBit) == 0) {
      missing.add(nameType);
    }
    if ((_value & _propertiesBit) == 0) {
      missing.add(nameProperties);
    }
    if ((_value & _geometryBit) == 0) {
      missing.add(nameGeometry);
    }
    throw CodableException(
      'Missing required fields for CanadaFeature: ${missing.join(", ")}',
    );
  }
}

// =============================================================================
// 2. Companion Codable for CanadaFeature
// =============================================================================
final class CanadaFeatureCodable implements Codable<CanadaFeature> {
  const CanadaFeatureCodable();

  @override
  CanadaFeature decode(Decoder decoder) {
    final keyed = decoder.keyed(options: _$CanadaFeatureSchema.keyOptions);

    String? type;
    CanadaProperties? properties;
    CanadaGeometry? geometry;
    var seen = _$CanadaFeatureSchema.none;

    while (keyed.moveNextKey()) {
      switch (keyed.selectKeyIndex(_$CanadaFeatureSchema.keyOptions)) {
        case _$CanadaFeatureSchema.keyType:
          if ((seen._value & _$CanadaFeatureSchema.type._value) != 0) {
            throw const CodableException('Duplicate field "type"');
          }
          type = keyed.readString();
          seen |= _$CanadaFeatureSchema.type;
          break;
        case _$CanadaFeatureSchema.keyProperties:
          if ((seen._value & _$CanadaFeatureSchema.properties._value) != 0) {
            throw const CodableException('Duplicate field "properties"');
          }
          properties = const CanadaPropertiesCodable().decode(
            keyed.nestedDecoder(),
          );
          seen |= _$CanadaFeatureSchema.properties;
          break;
        case _$CanadaFeatureSchema.keyGeometry:
          if ((seen._value & _$CanadaFeatureSchema.geometry._value) != 0) {
            throw const CodableException('Duplicate field "geometry"');
          }
          geometry = const CanadaGeometryCodable().decode(
            keyed.nestedDecoder(),
          );
          seen |= _$CanadaFeatureSchema.geometry;
          break;
        default:
          keyed.skipValue();
          break;
      }
    }

    // Inlined fast-path check
    seen.validate();

    return CanadaFeature(
      type: type!,
      properties: properties!,
      geometry: geometry!,
    );
  }

  @override
  void encode(CanadaFeature instance, Encoder encoder) {
    final keyed = encoder.keyed();
    keyed.encodeString(_$CanadaFeatureSchema.nameType, instance.type);
    keyed.encodeValue(
      _$CanadaFeatureSchema.nameProperties,
      instance.properties,
      const CanadaPropertiesCodable(),
    );
    keyed.encodeValue(
      _$CanadaFeatureSchema.nameGeometry,
      instance.geometry,
      const CanadaGeometryCodable(),
    );
  }
}

// =============================================================================
// 1. Unified Schema Descriptor for CanadaFeatureCollection
// =============================================================================
extension type const _$CanadaFeatureCollectionSchema(int _value) {
  // String Name Constants
  static const String nameType = 'type';
  static const String nameFeatures = 'features';

  // Key Indices for selectKeyIndex()
  static const int keyType = 0;
  static const int keyFeatures = 1;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
    _$CanadaFeatureCollectionSchema.nameType,
    _$CanadaFeatureCollectionSchema.nameFeatures,
  ]);
  static final KeyOptions keyOptions = options;

  // Bitmask Flags strictly for Required Fields
  static const _$CanadaFeatureCollectionSchema none =
      _$CanadaFeatureCollectionSchema(0);
  static const int _typeBit = 1 << 0;
  static const _$CanadaFeatureCollectionSchema type =
      _$CanadaFeatureCollectionSchema(_typeBit);

  // Combined Golden Bitmask for fast single-instruction check
  static const _$CanadaFeatureCollectionSchema golden =
      _$CanadaFeatureCollectionSchema(_typeBit);

  @pragma('vm:prefer-inline')
  _$CanadaFeatureCollectionSchema operator |(
    _$CanadaFeatureCollectionSchema other,
  ) => _$CanadaFeatureCollectionSchema(_value | other._value);

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
    if ((_value & _typeBit) == 0) {
      missing.add(nameType);
    }
    throw CodableException(
      'Missing required fields for CanadaFeatureCollection: ${missing.join(", ")}',
    );
  }
}

// =============================================================================
// 2. Companion Codable for CanadaFeatureCollection
// =============================================================================
final class CanadaFeatureCollectionCodable
    implements Codable<CanadaFeatureCollection> {
  const CanadaFeatureCollectionCodable();

  @override
  CanadaFeatureCollection decode(Decoder decoder) {
    final keyed = decoder.keyed(
      options: _$CanadaFeatureCollectionSchema.keyOptions,
    );

    String? type;
    var features = const <CanadaFeature>[];
    var seen = _$CanadaFeatureCollectionSchema.none;

    while (keyed.moveNextKey()) {
      switch (keyed.selectKeyIndex(
        _$CanadaFeatureCollectionSchema.keyOptions,
      )) {
        case _$CanadaFeatureCollectionSchema.keyType:
          if ((seen._value & _$CanadaFeatureCollectionSchema.type._value) !=
              0) {
            throw const CodableException('Duplicate field "type"');
          }
          type = keyed.readString();
          seen |= _$CanadaFeatureCollectionSchema.type;
          break;
        case _$CanadaFeatureCollectionSchema.keyFeatures:
          features = const CanadaFeatureCodable().decodeList(
            keyed.nestedDecoder(),
          );
          break;
        default:
          keyed.skipValue();
          break;
      }
    }

    // Inlined fast-path check
    seen.validate();

    return CanadaFeatureCollection(type: type!, features: features);
  }

  @override
  void encode(CanadaFeatureCollection instance, Encoder encoder) {
    final keyed = encoder.keyed();
    keyed.encodeString(_$CanadaFeatureCollectionSchema.nameType, instance.type);
    keyed.encodeList(
      _$CanadaFeatureCollectionSchema.nameFeatures,
      instance.features,
      const CanadaFeatureCodable(),
    );
  }
}
