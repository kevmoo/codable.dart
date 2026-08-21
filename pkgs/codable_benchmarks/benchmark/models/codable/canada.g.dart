// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: lines_longer_than_80_chars

part of 'canada.dart';

// =============================================================================
// 1. Unified Schema Descriptor for CanadaProperties
// =============================================================================
extension type const _$CanadaPropertiesSchema(int _value) {
  // String Name Constants
  static const String nameName = 'name';

  // Pre-Encoded UTF-8 Wire Bytes
  static final Uint8List nameNameBytes = Uint8List.fromList(const [
    110,
    97,
    109,
    101,
  ]);

  // Key Indices for selectName()
  static const int keyName = 0;

  // Pre-Compiled JsonKeyOptions
  static final JsonKeyOptions options = JsonKeyOptions.of(const [
    _$CanadaPropertiesSchema.nameName,
  ]);
  static final KeyOptions keyOptions = KeyOptions(
    options.keys,
    compiled: options,
  );

  // Bitmask Flags strictly for Required Fields
  static const _$CanadaPropertiesSchema none = _$CanadaPropertiesSchema(0);

  @pragma('vm:prefer-inline')
  _$CanadaPropertiesSchema operator |(_$CanadaPropertiesSchema other) =>
      _$CanadaPropertiesSchema(_value | other._value);

  /// Validates required fields in 1 CPU test instruction on the fast path.
  @pragma('vm:prefer-inline')
  void validate() {}
}

// =============================================================================
// 2. Single-Pass Streaming Deserializer for CanadaProperties
// =============================================================================
CanadaProperties _$CanadaPropertiesFromReader(JsonTokenReader reader) {
  reader.beginObject();

  var name = '';
  var seen = _$CanadaPropertiesSchema.none;

  while (reader.hasNext()) {
    switch (reader.selectName(_$CanadaPropertiesSchema.options)) {
      case _$CanadaPropertiesSchema.keyName:
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          name = reader.readString();
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

  return CanadaProperties(name: name);
}

// =============================================================================
// 3. Universal Keyed Deserializer for CanadaProperties
// =============================================================================
CanadaProperties _$CanadaPropertiesFromDecoder(Decoder decoder) {
  final keyed = decoder.keyed();

  var name = '';
  var seen = _$CanadaPropertiesSchema.none;

  while (keyed.hasNextKey()) {
    switch (keyed.selectKeyIndex(_$CanadaPropertiesSchema.keyOptions)) {
      case _$CanadaPropertiesSchema.keyName:
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          name = keyed.readString();
        }
        break;
      default:
        keyed.skipValue();
        break;
    }
  }

  // Inlined fast-path check
  seen.validate();

  return CanadaProperties(name: name);
}

// =============================================================================
// 3. Single-Pass Streaming Serializer for CanadaProperties
// =============================================================================
void _$CanadaPropertiesToWriter(
  CanadaProperties instance,
  JsonTokenWriter writer,
) {
  writer.beginObject();
  writer.writeNameBytes(_$CanadaPropertiesSchema.nameNameBytes);
  writer.writeString(instance.name);
  writer.endObject();
}

// =============================================================================
// 1. Unified Schema Descriptor for CanadaGeometry
// =============================================================================
extension type const _$CanadaGeometrySchema(int _value) {
  // String Name Constants
  static const String nameType = 'type';
  static const String nameCoordinates = 'coordinates';

  // Pre-Encoded UTF-8 Wire Bytes
  static final Uint8List nameTypeBytes = Uint8List.fromList(const [
    116,
    121,
    112,
    101,
  ]);
  static final Uint8List nameCoordinatesBytes = Uint8List.fromList(const [
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
  ]);

  // Key Indices for selectName()
  static const int keyType = 0;
  static const int keyCoordinates = 1;

  // Pre-Compiled JsonKeyOptions
  static final JsonKeyOptions options = JsonKeyOptions.of(const [
    _$CanadaGeometrySchema.nameType,
    _$CanadaGeometrySchema.nameCoordinates,
  ]);
  static final KeyOptions keyOptions = KeyOptions(
    options.keys,
    compiled: options,
  );

  // Bitmask Flags strictly for Required Fields
  static const _$CanadaGeometrySchema none = _$CanadaGeometrySchema(0);
  static const int _typeBit = 1 << 0;
  static const _$CanadaGeometrySchema type = _$CanadaGeometrySchema(_typeBit);

  // Composite Golden Mask for Required Fields
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
// 2. Single-Pass Streaming Deserializer for CanadaGeometry
// =============================================================================
CanadaGeometry _$CanadaGeometryFromReader(JsonTokenReader reader) {
  reader.beginObject();

  String? type;
  var coordinates = const <List<List<double>>>[];
  var seen = _$CanadaGeometrySchema.none;

  while (reader.hasNext()) {
    switch (reader.selectName(_$CanadaGeometrySchema.options)) {
      case _$CanadaGeometrySchema.keyType:
        if ((seen._value & _$CanadaGeometrySchema.type._value) != 0) {
          throw const CodableException('Duplicate field "type"');
        }
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          type = reader.readString();
          seen |= _$CanadaGeometrySchema.type;
        }
        break;
      case _$CanadaGeometrySchema.keyCoordinates:
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          coordinates = const CanadaCoordinatesDecoder().decodeFromReader(
            reader,
          );
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

  return CanadaGeometry(type: type!, coordinates: coordinates);
}

// =============================================================================
// 3. Universal Keyed Deserializer for CanadaGeometry
// =============================================================================
CanadaGeometry _$CanadaGeometryFromDecoder(Decoder decoder) {
  final keyed = decoder.keyed();

  String? type;
  var coordinates = const <List<List<double>>>[];
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
// 3. Single-Pass Streaming Serializer for CanadaGeometry
// =============================================================================
void _$CanadaGeometryToWriter(CanadaGeometry instance, JsonTokenWriter writer) {
  writer.beginObject();
  writer.writeNameBytes(_$CanadaGeometrySchema.nameTypeBytes);
  writer.writeString(instance.type);
  writer.writeNameBytes(_$CanadaGeometrySchema.nameCoordinatesBytes);
  const CanadaCoordinatesDecoder().encodeToWriter(instance.coordinates, writer);
  writer.endObject();
}

// =============================================================================
// 1. Unified Schema Descriptor for CanadaFeature
// =============================================================================
extension type const _$CanadaFeatureSchema(int _value) {
  // String Name Constants
  static const String nameType = 'type';
  static const String nameProperties = 'properties';
  static const String nameGeometry = 'geometry';

  // Pre-Encoded UTF-8 Wire Bytes
  static final Uint8List nameTypeBytes = Uint8List.fromList(const [
    116,
    121,
    112,
    101,
  ]);
  static final Uint8List namePropertiesBytes = Uint8List.fromList(const [
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
  ]);
  static final Uint8List nameGeometryBytes = Uint8List.fromList(const [
    103,
    101,
    111,
    109,
    101,
    116,
    114,
    121,
  ]);

  // Key Indices for selectName()
  static const int keyType = 0;
  static const int keyProperties = 1;
  static const int keyGeometry = 2;

  // Pre-Compiled JsonKeyOptions
  static final JsonKeyOptions options = JsonKeyOptions.of(const [
    _$CanadaFeatureSchema.nameType,
    _$CanadaFeatureSchema.nameProperties,
    _$CanadaFeatureSchema.nameGeometry,
  ]);
  static final KeyOptions keyOptions = KeyOptions(
    options.keys,
    compiled: options,
  );

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

  // Composite Golden Mask for Required Fields
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
// 2. Single-Pass Streaming Deserializer for CanadaFeature
// =============================================================================
CanadaFeature _$CanadaFeatureFromReader(JsonTokenReader reader) {
  reader.beginObject();

  String? type;
  CanadaProperties? properties;
  CanadaGeometry? geometry;
  var seen = _$CanadaFeatureSchema.none;

  while (reader.hasNext()) {
    switch (reader.selectName(_$CanadaFeatureSchema.options)) {
      case _$CanadaFeatureSchema.keyType:
        if ((seen._value & _$CanadaFeatureSchema.type._value) != 0) {
          throw const CodableException('Duplicate field "type"');
        }
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          type = reader.readString();
          seen |= _$CanadaFeatureSchema.type;
        }
        break;
      case _$CanadaFeatureSchema.keyProperties:
        if ((seen._value & _$CanadaFeatureSchema.properties._value) != 0) {
          throw const CodableException('Duplicate field "properties"');
        }
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          properties = _$CanadaPropertiesFromReader(reader);
          seen |= _$CanadaFeatureSchema.properties;
        }
        break;
      case _$CanadaFeatureSchema.keyGeometry:
        if ((seen._value & _$CanadaFeatureSchema.geometry._value) != 0) {
          throw const CodableException('Duplicate field "geometry"');
        }
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          geometry = _$CanadaGeometryFromReader(reader);
          seen |= _$CanadaFeatureSchema.geometry;
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

  return CanadaFeature(
    type: type!,
    properties: properties!,
    geometry: geometry!,
  );
}

// =============================================================================
// 3. Universal Keyed Deserializer for CanadaFeature
// =============================================================================
CanadaFeature _$CanadaFeatureFromDecoder(Decoder decoder) {
  final keyed = decoder.keyed();

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
// 3. Single-Pass Streaming Serializer for CanadaFeature
// =============================================================================
void _$CanadaFeatureToWriter(CanadaFeature instance, JsonTokenWriter writer) {
  writer.beginObject();
  writer.writeNameBytes(_$CanadaFeatureSchema.nameTypeBytes);
  writer.writeString(instance.type);
  writer.writeNameBytes(_$CanadaFeatureSchema.namePropertiesBytes);
  _$CanadaPropertiesToWriter(instance.properties, writer);
  writer.writeNameBytes(_$CanadaFeatureSchema.nameGeometryBytes);
  _$CanadaGeometryToWriter(instance.geometry, writer);
  writer.endObject();
}

// =============================================================================
// 1. Unified Schema Descriptor for CanadaFeatureCollection
// =============================================================================
extension type const _$CanadaFeatureCollectionSchema(int _value) {
  // String Name Constants
  static const String nameType = 'type';
  static const String nameFeatures = 'features';

  // Pre-Encoded UTF-8 Wire Bytes
  static final Uint8List nameTypeBytes = Uint8List.fromList(const [
    116,
    121,
    112,
    101,
  ]);
  static final Uint8List nameFeaturesBytes = Uint8List.fromList(const [
    102,
    101,
    97,
    116,
    117,
    114,
    101,
    115,
  ]);

  // Key Indices for selectName()
  static const int keyType = 0;
  static const int keyFeatures = 1;

  // Pre-Compiled JsonKeyOptions
  static final JsonKeyOptions options = JsonKeyOptions.of(const [
    _$CanadaFeatureCollectionSchema.nameType,
    _$CanadaFeatureCollectionSchema.nameFeatures,
  ]);
  static final KeyOptions keyOptions = KeyOptions(
    options.keys,
    compiled: options,
  );

  // Bitmask Flags strictly for Required Fields
  static const _$CanadaFeatureCollectionSchema none =
      _$CanadaFeatureCollectionSchema(0);
  static const int _typeBit = 1 << 0;
  static const _$CanadaFeatureCollectionSchema type =
      _$CanadaFeatureCollectionSchema(_typeBit);

  // Composite Golden Mask for Required Fields
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
// 2. Single-Pass Streaming Deserializer for CanadaFeatureCollection
// =============================================================================
CanadaFeatureCollection _$CanadaFeatureCollectionFromReader(
  JsonTokenReader reader,
) {
  reader.beginObject();

  String? type;
  var features = const <CanadaFeature>[];
  var seen = _$CanadaFeatureCollectionSchema.none;

  while (reader.hasNext()) {
    switch (reader.selectName(_$CanadaFeatureCollectionSchema.options)) {
      case _$CanadaFeatureCollectionSchema.keyType:
        if ((seen._value & _$CanadaFeatureCollectionSchema.type._value) != 0) {
          throw const CodableException('Duplicate field "type"');
        }
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          type = reader.readString();
          seen |= _$CanadaFeatureCollectionSchema.type;
        }
        break;
      case _$CanadaFeatureCollectionSchema.keyFeatures:
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          reader.beginArray();
          final list = <CanadaFeature>[];
          while (reader.hasNext()) {
            list.add(_$CanadaFeatureFromReader(reader));
          }
          reader.endArray();
          features = list;
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

  return CanadaFeatureCollection(type: type!, features: features);
}

// =============================================================================
// 3. Universal Keyed Deserializer for CanadaFeatureCollection
// =============================================================================
CanadaFeatureCollection _$CanadaFeatureCollectionFromDecoder(Decoder decoder) {
  final keyed = decoder.keyed();

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
          features = keyed.decodeList(_$CanadaFeatureFromDecoder);
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
// 3. Single-Pass Streaming Serializer for CanadaFeatureCollection
// =============================================================================
void _$CanadaFeatureCollectionToWriter(
  CanadaFeatureCollection instance,
  JsonTokenWriter writer,
) {
  writer.beginObject();
  writer.writeNameBytes(_$CanadaFeatureCollectionSchema.nameTypeBytes);
  writer.writeString(instance.type);
  writer.writeNameBytes(_$CanadaFeatureCollectionSchema.nameFeaturesBytes);
  writer.beginArray();
  for (final item in instance.features) {
    _$CanadaFeatureToWriter(item, writer);
  }
  writer.endArray();
  writer.endObject();
}
