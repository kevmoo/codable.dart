// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: lines_longer_than_80_chars, unnecessary_lambdas, deprecated_member_use, unused_element

part of 'canada.dart';

// =============================================================================
// 1. Unified Schema Descriptor for CanadaProperties
// =============================================================================
extension type const _$CanadaPropertiesSchema(int _value) {
  // String Name Constants
  static const String nameName = 'name';

  // Pre-encoded UTF-8 Wire Name Bytes and StaticKeys
  static const List<int> wireNameBytesName = [34, 110, 97, 109, 101, 34];
  static const StaticKey staticKeyName = StaticKey(
    nameName,
    keyName,
    wireNameBytesName,
  );

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
// 2. Universal Keyed Deserializer for CanadaProperties
// =============================================================================
CanadaProperties _$CanadaPropertiesFromDecoder(Decoder decoder) {
  final keyed = decoder.keyed(options: _$CanadaPropertiesSchema.keyOptions);

  String? name;
  var seen = _$CanadaPropertiesSchema.none;

  while (keyed.hasNextKey()) {
    switch (keyed.selectKeyIndex(_$CanadaPropertiesSchema.keyOptions)) {
      case _$CanadaPropertiesSchema.keyName:
        if ((seen._value & _$CanadaPropertiesSchema.name._value) != 0) {
          throw const CodableException('Duplicate field "name"');
        }
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          name = keyed.readString();
          seen |= _$CanadaPropertiesSchema.name;
        }
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

// =============================================================================
// 2b. Universal List Deserializer for CanadaProperties
// =============================================================================
List<CanadaProperties> _$CanadaPropertiesListFromDecoder(Decoder decoder) {
  final unkeyed = decoder.unkeyed();
  final list = <CanadaProperties>[];
  while (unkeyed.hasNext()) {
    list.add(unkeyed.decodeElement(_$CanadaPropertiesFromDecoder));
  }
  return list;
}

// =============================================================================
// 3. Universal Serializer for CanadaProperties
// =============================================================================
void _$CanadaPropertiesToEncoder(CanadaProperties instance, Encoder encoder) {
  final keyed = encoder.keyed();
  keyed.encodeStringKey(_$CanadaPropertiesSchema.staticKeyName, instance.name);
}

// =============================================================================
// 1. Unified Schema Descriptor for CanadaGeometry
// =============================================================================
extension type const _$CanadaGeometrySchema(int _value) {
  // String Name Constants
  static const String nameType = 'type';
  static const String nameCoordinates = 'coordinates';

  // Pre-encoded UTF-8 Wire Name Bytes and StaticKeys
  static const List<int> wireNameBytesType = [34, 116, 121, 112, 101, 34];
  static const StaticKey staticKeyType = StaticKey(
    nameType,
    keyType,
    wireNameBytesType,
  );
  static const List<int> wireNameBytesCoordinates = [
    34,
    99,
    111,
    111,
    114,
    100,
    105,
    110,
    97,
    116,
    101,
    115,
    34,
  ];
  static const StaticKey staticKeyCoordinates = StaticKey(
    nameCoordinates,
    keyCoordinates,
    wireNameBytesCoordinates,
  );

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
// 2. Universal Keyed Deserializer for CanadaGeometry
// =============================================================================
CanadaGeometry _$CanadaGeometryFromDecoder(Decoder decoder) {
  final keyed = decoder.keyed(options: _$CanadaGeometrySchema.keyOptions);

  String? type;
  var coordinates = const <List<Float64List>>[];
  var seen = _$CanadaGeometrySchema.none;

  while (keyed.hasNextKey()) {
    switch (keyed.selectKeyIndex(_$CanadaGeometrySchema.keyOptions)) {
      case _$CanadaGeometrySchema.keyType:
        if ((seen._value & _$CanadaGeometrySchema.type._value) != 0) {
          throw const CodableException('Duplicate field "type"');
        }
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          type = keyed.readString();
          seen |= _$CanadaGeometrySchema.type;
        }
        break;
      case _$CanadaGeometrySchema.keyCoordinates:
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          coordinates = keyed.decodeValue(
            const CanadaCoordinatesDecoder().decode,
          );
        }
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

// =============================================================================
// 2b. Universal List Deserializer for CanadaGeometry
// =============================================================================
List<CanadaGeometry> _$CanadaGeometryListFromDecoder(Decoder decoder) {
  final unkeyed = decoder.unkeyed();
  final list = <CanadaGeometry>[];
  while (unkeyed.hasNext()) {
    list.add(unkeyed.decodeElement(_$CanadaGeometryFromDecoder));
  }
  return list;
}

// =============================================================================
// 3. Universal Serializer for CanadaGeometry
// =============================================================================
void _$CanadaGeometryToEncoder(CanadaGeometry instance, Encoder encoder) {
  final keyed = encoder.keyed();
  keyed.encodeStringKey(_$CanadaGeometrySchema.staticKeyType, instance.type);
  keyed.encodeValueKey(
    _$CanadaGeometrySchema.staticKeyCoordinates,
    instance.coordinates,
    (v, e) => const CanadaCoordinatesDecoder().encodeToEncoder(v, e),
  );
}

// =============================================================================
// 1. Unified Schema Descriptor for CanadaFeature
// =============================================================================
extension type const _$CanadaFeatureSchema(int _value) {
  // String Name Constants
  static const String nameType = 'type';
  static const String nameProperties = 'properties';
  static const String nameGeometry = 'geometry';

  // Pre-encoded UTF-8 Wire Name Bytes and StaticKeys
  static const List<int> wireNameBytesType = [34, 116, 121, 112, 101, 34];
  static const StaticKey staticKeyType = StaticKey(
    nameType,
    keyType,
    wireNameBytesType,
  );
  static const List<int> wireNameBytesProperties = [
    34,
    112,
    114,
    111,
    112,
    101,
    114,
    116,
    105,
    101,
    115,
    34,
  ];
  static const StaticKey staticKeyProperties = StaticKey(
    nameProperties,
    keyProperties,
    wireNameBytesProperties,
  );
  static const List<int> wireNameBytesGeometry = [
    34,
    103,
    101,
    111,
    109,
    101,
    116,
    114,
    121,
    34,
  ];
  static const StaticKey staticKeyGeometry = StaticKey(
    nameGeometry,
    keyGeometry,
    wireNameBytesGeometry,
  );

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
// 2. Universal Keyed Deserializer for CanadaFeature
// =============================================================================
CanadaFeature _$CanadaFeatureFromDecoder(Decoder decoder) {
  final keyed = decoder.keyed(options: _$CanadaFeatureSchema.keyOptions);

  String? type;
  CanadaProperties? properties;
  CanadaGeometry? geometry;
  var seen = _$CanadaFeatureSchema.none;

  while (keyed.hasNextKey()) {
    switch (keyed.selectKeyIndex(_$CanadaFeatureSchema.keyOptions)) {
      case _$CanadaFeatureSchema.keyType:
        if ((seen._value & _$CanadaFeatureSchema.type._value) != 0) {
          throw const CodableException('Duplicate field "type"');
        }
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          type = keyed.readString();
          seen |= _$CanadaFeatureSchema.type;
        }
        break;
      case _$CanadaFeatureSchema.keyProperties:
        if ((seen._value & _$CanadaFeatureSchema.properties._value) != 0) {
          throw const CodableException('Duplicate field "properties"');
        }
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          properties = keyed.decodeValue(_$CanadaPropertiesFromDecoder);
          seen |= _$CanadaFeatureSchema.properties;
        }
        break;
      case _$CanadaFeatureSchema.keyGeometry:
        if ((seen._value & _$CanadaFeatureSchema.geometry._value) != 0) {
          throw const CodableException('Duplicate field "geometry"');
        }
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          geometry = keyed.decodeValue(_$CanadaGeometryFromDecoder);
          seen |= _$CanadaFeatureSchema.geometry;
        }
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

// =============================================================================
// 2b. Universal List Deserializer for CanadaFeature
// =============================================================================
List<CanadaFeature> _$CanadaFeatureListFromDecoder(Decoder decoder) {
  final unkeyed = decoder.unkeyed();
  final list = <CanadaFeature>[];
  while (unkeyed.hasNext()) {
    list.add(unkeyed.decodeElement(_$CanadaFeatureFromDecoder));
  }
  return list;
}

// =============================================================================
// 3. Universal Serializer for CanadaFeature
// =============================================================================
void _$CanadaFeatureToEncoder(CanadaFeature instance, Encoder encoder) {
  final keyed = encoder.keyed();
  keyed.encodeStringKey(_$CanadaFeatureSchema.staticKeyType, instance.type);
  keyed.encodeValueKey(
    _$CanadaFeatureSchema.staticKeyProperties,
    instance.properties,
    _$CanadaPropertiesToEncoder,
  );
  keyed.encodeValueKey(
    _$CanadaFeatureSchema.staticKeyGeometry,
    instance.geometry,
    _$CanadaGeometryToEncoder,
  );
}

// =============================================================================
// 1. Unified Schema Descriptor for CanadaFeatureCollection
// =============================================================================
extension type const _$CanadaFeatureCollectionSchema(int _value) {
  // String Name Constants
  static const String nameType = 'type';
  static const String nameFeatures = 'features';

  // Pre-encoded UTF-8 Wire Name Bytes and StaticKeys
  static const List<int> wireNameBytesType = [34, 116, 121, 112, 101, 34];
  static const StaticKey staticKeyType = StaticKey(
    nameType,
    keyType,
    wireNameBytesType,
  );
  static const List<int> wireNameBytesFeatures = [
    34,
    102,
    101,
    97,
    116,
    117,
    114,
    101,
    115,
    34,
  ];
  static const StaticKey staticKeyFeatures = StaticKey(
    nameFeatures,
    keyFeatures,
    wireNameBytesFeatures,
  );

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
// 2. Universal Keyed Deserializer for CanadaFeatureCollection
// =============================================================================
CanadaFeatureCollection _$CanadaFeatureCollectionFromDecoder(Decoder decoder) {
  final keyed = decoder.keyed(
    options: _$CanadaFeatureCollectionSchema.keyOptions,
  );

  String? type;
  var features = const <CanadaFeature>[];
  var seen = _$CanadaFeatureCollectionSchema.none;

  while (keyed.hasNextKey()) {
    switch (keyed.selectKeyIndex(_$CanadaFeatureCollectionSchema.keyOptions)) {
      case _$CanadaFeatureCollectionSchema.keyType:
        if ((seen._value & _$CanadaFeatureCollectionSchema.type._value) != 0) {
          throw const CodableException('Duplicate field "type"');
        }
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          type = keyed.readString();
          seen |= _$CanadaFeatureCollectionSchema.type;
        }
        break;
      case _$CanadaFeatureCollectionSchema.keyFeatures:
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          features = keyed.decodeValue(_$CanadaFeatureListFromDecoder);
        }
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

// =============================================================================
// 2b. Universal List Deserializer for CanadaFeatureCollection
// =============================================================================
List<CanadaFeatureCollection> _$CanadaFeatureCollectionListFromDecoder(
  Decoder decoder,
) {
  final unkeyed = decoder.unkeyed();
  final list = <CanadaFeatureCollection>[];
  while (unkeyed.hasNext()) {
    list.add(unkeyed.decodeElement(_$CanadaFeatureCollectionFromDecoder));
  }
  return list;
}

// =============================================================================
// 3. Universal Serializer for CanadaFeatureCollection
// =============================================================================
void _$CanadaFeatureCollectionToEncoder(
  CanadaFeatureCollection instance,
  Encoder encoder,
) {
  final keyed = encoder.keyed();
  keyed.encodeStringKey(
    _$CanadaFeatureCollectionSchema.staticKeyType,
    instance.type,
  );
  keyed.encodeListKey(
    _$CanadaFeatureCollectionSchema.staticKeyFeatures,
    instance.features,
    _$CanadaFeatureToEncoder,
  );
}
