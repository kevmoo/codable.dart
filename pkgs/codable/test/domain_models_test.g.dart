// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'domain_models_test.dart';

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
          throw CodableException('Duplicate field "latitude"');
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
          throw CodableException('Duplicate field "longitude"');
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

// =============================================================================
// 1. Unified Schema Descriptor for UserProfile
// =============================================================================
extension type const _$UserProfileSchema(int _value) {
  // String Name Constants
  static const String nameId = 'id';
  static const String nameEmail = 'email';
  static const String nameRole = 'role';
  static const String nameZip = 'zip';
  static const String nameTags = 'tags';

  // Pre-Encoded UTF-8 Wire Bytes
  static final Uint8List nameIdBytes = Uint8List.fromList(const [105, 100]);
  static final Uint8List nameEmailBytes = Uint8List.fromList(const [
    101,
    109,
    97,
    105,
    108,
  ]);
  static final Uint8List nameRoleBytes = Uint8List.fromList(const [
    114,
    111,
    108,
    101,
  ]);
  static final Uint8List nameZipBytes = Uint8List.fromList(const [
    122,
    105,
    112,
  ]);
  static final Uint8List nameTagsBytes = Uint8List.fromList(const [
    116,
    97,
    103,
    115,
  ]);

  // Key Indices for selectName()
  static const int keyId = 0;
  static const int keyEmail = 1;
  static const int keyRole = 2;
  static const int keyZip = 3;
  static const int keyTags = 4;

  // Pre-Compiled JsonKeyOptions
  static final JsonKeyOptions options = JsonKeyOptions.of(const [
    _$UserProfileSchema.nameId,
    _$UserProfileSchema.nameEmail,
    _$UserProfileSchema.nameRole,
    _$UserProfileSchema.nameZip,
    _$UserProfileSchema.nameTags,
  ]);

  // Enum Options for role
  static final JsonKeyOptions roleEnumOptions = JsonKeyOptions.of(const [
    'admin',
    'member',
    'guest',
  ]);

  // Bitmask Flags strictly for Required Fields
  static const _$UserProfileSchema none = _$UserProfileSchema(0);
  static const int _idBit = 1 << 0;
  static const _$UserProfileSchema id = _$UserProfileSchema(_idBit);
  static const int _emailBit = 1 << 1;
  static const _$UserProfileSchema email = _$UserProfileSchema(_emailBit);
  static const int _roleBit = 1 << 2;
  static const _$UserProfileSchema role = _$UserProfileSchema(_roleBit);
  static const int _zipBit = 1 << 3;
  static const _$UserProfileSchema zip = _$UserProfileSchema(_zipBit);

  // Composite Golden Mask for Required Fields
  static const _$UserProfileSchema golden = _$UserProfileSchema(
    _idBit | _emailBit | _roleBit | _zipBit,
  );

  @pragma('vm:prefer-inline')
  _$UserProfileSchema operator |(_$UserProfileSchema other) =>
      _$UserProfileSchema(_value | other._value);

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
    if ((_value & _idBit) == 0) {
      missing.add(nameId);
    }
    if ((_value & _emailBit) == 0) {
      missing.add(nameEmail);
    }
    if ((_value & _roleBit) == 0) {
      missing.add(nameRole);
    }
    if ((_value & _zipBit) == 0) {
      missing.add(nameZip);
    }
    throw CodableException(
      'Missing required fields for UserProfile: ${missing.join(", ")}',
    );
  }
}

// =============================================================================
// 2. Single-Pass Streaming Deserializer for UserProfile
// =============================================================================
UserProfile _$UserProfileFromReader(JsonTokenReader reader) {
  reader.beginObject();

  String? id;
  String? email;
  UserRole? role;
  String? zip;
  List<String> tags = const [];
  var seen = _$UserProfileSchema.none;

  while (reader.hasNext()) {
    switch (reader.selectName(_$UserProfileSchema.options)) {
      case _$UserProfileSchema.keyId:
        if ((seen._value & _$UserProfileSchema.id._value) != 0) {
          throw CodableException('Duplicate field "id"');
        }
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          id = reader.readString();
          seen |= _$UserProfileSchema.id;
        }
        break;
      case _$UserProfileSchema.keyEmail:
        if ((seen._value & _$UserProfileSchema.email._value) != 0) {
          throw CodableException('Duplicate field "email"');
        }
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          email = reader.readString();
          seen |= _$UserProfileSchema.email;
        }
        break;
      case _$UserProfileSchema.keyRole:
        if ((seen._value & _$UserProfileSchema.role._value) != 0) {
          throw CodableException('Duplicate field "role"');
        }
        // Zero-allocation enum matching
        final enumIndex = reader.selectString(
          _$UserProfileSchema.roleEnumOptions,
        );
        if (enumIndex >= 0 && enumIndex < UserRole.values.length) {
          role = UserRole.values[enumIndex];
          seen |= _$UserProfileSchema.role;
        } else {
          throw CodableException('Unknown UserRole value');
        }
        break;
      case _$UserProfileSchema.keyZip:
        if ((seen._value & _$UserProfileSchema.zip._value) != 0) {
          throw CodableException('Duplicate field "zip"');
        }
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          zip = const ZipCodeDecoder().decodeFromReader(reader);
          seen |= _$UserProfileSchema.zip;
        }
        break;
      case _$UserProfileSchema.keyTags:
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          reader.beginArray();
          final list = <String>[];
          while (reader.hasNext()) {
            list.add(reader.readString());
          }
          reader.endArray();
          tags = list;
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

  return UserProfile(
    id: id!,
    email: email!,
    role: role!,
    zip: zip!,
    tags: tags,
  );
}

// =============================================================================
// 3. Single-Pass Streaming Serializer for UserProfile
// =============================================================================
void _$UserProfileToWriter(UserProfile instance, JsonTokenWriter writer) {
  writer.beginObject();
  writer.writeNameBytes(_$UserProfileSchema.nameIdBytes);
  writer.writeString(instance.id);
  writer.writeNameBytes(_$UserProfileSchema.nameEmailBytes);
  writer.writeString(instance.email);
  writer.writeNameBytes(_$UserProfileSchema.nameRoleBytes);
  writer.writeString(instance.role.name);
  writer.writeNameBytes(_$UserProfileSchema.nameZipBytes);
  const ZipCodeDecoder().encodeToWriter(instance.zip, writer);
  writer.writeNameBytes(_$UserProfileSchema.nameTagsBytes);
  writer.beginArray();
  for (final item in instance.tags) {
    writer.writeString(item);
  }
  writer.endArray();
  writer.endObject();
}

// =============================================================================
// 1. Unified Schema Descriptor for Car
// =============================================================================
extension type const _$CarSchema(int _value) {
  // String Name Constants
  static const String nameMaxSpeed = 'maxSpeed';
  static const String nameDoors = 'doors';

  // Pre-Encoded UTF-8 Wire Bytes
  static final Uint8List nameMaxSpeedBytes = Uint8List.fromList(const [
    109,
    97,
    120,
    83,
    112,
    101,
    101,
    100,
  ]);
  static final Uint8List nameDoorsBytes = Uint8List.fromList(const [
    100,
    111,
    111,
    114,
    115,
  ]);

  // Key Indices for selectName()
  static const int keyMaxSpeed = 0;
  static const int keyDoors = 1;

  // Pre-Compiled JsonKeyOptions
  static final JsonKeyOptions options = JsonKeyOptions.of(const [
    _$CarSchema.nameMaxSpeed,
    _$CarSchema.nameDoors,
  ]);

  // Bitmask Flags strictly for Required Fields
  static const _$CarSchema none = _$CarSchema(0);
  static const int _maxSpeedBit = 1 << 0;
  static const _$CarSchema maxSpeed = _$CarSchema(_maxSpeedBit);
  static const int _doorsBit = 1 << 1;
  static const _$CarSchema doors = _$CarSchema(_doorsBit);

  // Composite Golden Mask for Required Fields
  static const _$CarSchema golden = _$CarSchema(_maxSpeedBit | _doorsBit);

  @pragma('vm:prefer-inline')
  _$CarSchema operator |(_$CarSchema other) =>
      _$CarSchema(_value | other._value);

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
    if ((_value & _maxSpeedBit) == 0) {
      missing.add(nameMaxSpeed);
    }
    if ((_value & _doorsBit) == 0) {
      missing.add(nameDoors);
    }
    throw CodableException(
      'Missing required fields for Car: ${missing.join(", ")}',
    );
  }
}

// =============================================================================
// 2. Single-Pass Streaming Deserializer for Car
// =============================================================================
Car _$CarFromReader(JsonTokenReader reader) {
  reader.beginObject();

  int? maxSpeed;
  int? doors;
  var seen = _$CarSchema.none;

  while (reader.hasNext()) {
    switch (reader.selectName(_$CarSchema.options)) {
      case _$CarSchema.keyMaxSpeed:
        if ((seen._value & _$CarSchema.maxSpeed._value) != 0) {
          throw CodableException('Duplicate field "maxSpeed"');
        }
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          maxSpeed = reader.readInt();
          seen |= _$CarSchema.maxSpeed;
        }
        break;
      case _$CarSchema.keyDoors:
        if ((seen._value & _$CarSchema.doors._value) != 0) {
          throw CodableException('Duplicate field "doors"');
        }
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          doors = reader.readInt();
          seen |= _$CarSchema.doors;
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

  return Car(maxSpeed: maxSpeed!, doors: doors!);
}

// =============================================================================
// 3. Single-Pass Streaming Serializer for Car
// =============================================================================
void _$CarToWriter(Car instance, JsonTokenWriter writer) {
  writer.beginObject();
  writer.writeNameBytes(_$CarSchema.nameMaxSpeedBytes);
  writer.writeInt(instance.maxSpeed);
  writer.writeNameBytes(_$CarSchema.nameDoorsBytes);
  writer.writeInt(instance.doors);
  writer.endObject();
}

// =============================================================================
// 1. Unified Schema Descriptor for Bicycle
// =============================================================================
extension type const _$BicycleSchema(int _value) {
  // String Name Constants
  static const String nameMaxSpeed = 'maxSpeed';
  static const String nameHasBell = 'hasBell';

  // Pre-Encoded UTF-8 Wire Bytes
  static final Uint8List nameMaxSpeedBytes = Uint8List.fromList(const [
    109,
    97,
    120,
    83,
    112,
    101,
    101,
    100,
  ]);
  static final Uint8List nameHasBellBytes = Uint8List.fromList(const [
    104,
    97,
    115,
    66,
    101,
    108,
    108,
  ]);

  // Key Indices for selectName()
  static const int keyMaxSpeed = 0;
  static const int keyHasBell = 1;

  // Pre-Compiled JsonKeyOptions
  static final JsonKeyOptions options = JsonKeyOptions.of(const [
    _$BicycleSchema.nameMaxSpeed,
    _$BicycleSchema.nameHasBell,
  ]);

  // Bitmask Flags strictly for Required Fields
  static const _$BicycleSchema none = _$BicycleSchema(0);
  static const int _maxSpeedBit = 1 << 0;
  static const _$BicycleSchema maxSpeed = _$BicycleSchema(_maxSpeedBit);
  static const int _hasBellBit = 1 << 1;
  static const _$BicycleSchema hasBell = _$BicycleSchema(_hasBellBit);

  // Composite Golden Mask for Required Fields
  static const _$BicycleSchema golden = _$BicycleSchema(
    _maxSpeedBit | _hasBellBit,
  );

  @pragma('vm:prefer-inline')
  _$BicycleSchema operator |(_$BicycleSchema other) =>
      _$BicycleSchema(_value | other._value);

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
    if ((_value & _maxSpeedBit) == 0) {
      missing.add(nameMaxSpeed);
    }
    if ((_value & _hasBellBit) == 0) {
      missing.add(nameHasBell);
    }
    throw CodableException(
      'Missing required fields for Bicycle: ${missing.join(", ")}',
    );
  }
}

// =============================================================================
// 2. Single-Pass Streaming Deserializer for Bicycle
// =============================================================================
Bicycle _$BicycleFromReader(JsonTokenReader reader) {
  reader.beginObject();

  int? maxSpeed;
  bool? hasBell;
  var seen = _$BicycleSchema.none;

  while (reader.hasNext()) {
    switch (reader.selectName(_$BicycleSchema.options)) {
      case _$BicycleSchema.keyMaxSpeed:
        if ((seen._value & _$BicycleSchema.maxSpeed._value) != 0) {
          throw CodableException('Duplicate field "maxSpeed"');
        }
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          maxSpeed = reader.readInt();
          seen |= _$BicycleSchema.maxSpeed;
        }
        break;
      case _$BicycleSchema.keyHasBell:
        if ((seen._value & _$BicycleSchema.hasBell._value) != 0) {
          throw CodableException('Duplicate field "hasBell"');
        }
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          hasBell = reader.readBool();
          seen |= _$BicycleSchema.hasBell;
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

  return Bicycle(maxSpeed: maxSpeed!, hasBell: hasBell!);
}

// =============================================================================
// 3. Single-Pass Streaming Serializer for Bicycle
// =============================================================================
void _$BicycleToWriter(Bicycle instance, JsonTokenWriter writer) {
  writer.beginObject();
  writer.writeNameBytes(_$BicycleSchema.nameMaxSpeedBytes);
  writer.writeInt(instance.maxSpeed);
  writer.writeNameBytes(_$BicycleSchema.nameHasBellBytes);
  writer.writeBool(instance.hasBell);
  writer.endObject();
}

// =============================================================================
// 1. Unified Schema Descriptor for UserWithLocation
// =============================================================================
extension type const _$UserWithLocationSchema(int _value) {
  // String Name Constants
  static const String nameProfile = 'profile';
  static const String nameLocation = 'location';

  // Pre-Encoded UTF-8 Wire Bytes
  static final Uint8List nameProfileBytes = Uint8List.fromList(const [
    112,
    114,
    111,
    102,
    105,
    108,
    101,
  ]);
  static final Uint8List nameLocationBytes = Uint8List.fromList(const [
    108,
    111,
    99,
    97,
    116,
    105,
    111,
    110,
  ]);

  // Key Indices for selectName()
  static const int keyProfile = 0;
  static const int keyLocation = 1;

  // Pre-Compiled JsonKeyOptions
  static final JsonKeyOptions options = JsonKeyOptions.of(const [
    _$UserWithLocationSchema.nameProfile,
    _$UserWithLocationSchema.nameLocation,
  ]);

  // Bitmask Flags strictly for Required Fields
  static const _$UserWithLocationSchema none = _$UserWithLocationSchema(0);
  static const int _profileBit = 1 << 0;
  static const _$UserWithLocationSchema profile = _$UserWithLocationSchema(
    _profileBit,
  );
  static const int _locationBit = 1 << 1;
  static const _$UserWithLocationSchema location = _$UserWithLocationSchema(
    _locationBit,
  );

  // Composite Golden Mask for Required Fields
  static const _$UserWithLocationSchema golden = _$UserWithLocationSchema(
    _profileBit | _locationBit,
  );

  @pragma('vm:prefer-inline')
  _$UserWithLocationSchema operator |(_$UserWithLocationSchema other) =>
      _$UserWithLocationSchema(_value | other._value);

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
    if ((_value & _profileBit) == 0) {
      missing.add(nameProfile);
    }
    if ((_value & _locationBit) == 0) {
      missing.add(nameLocation);
    }
    throw CodableException(
      'Missing required fields for UserWithLocation: ${missing.join(", ")}',
    );
  }
}

// =============================================================================
// 2. Single-Pass Streaming Deserializer for UserWithLocation
// =============================================================================
UserWithLocation _$UserWithLocationFromReader(JsonTokenReader reader) {
  reader.beginObject();

  UserProfile? profile;
  Coordinate? location;
  var seen = _$UserWithLocationSchema.none;

  while (reader.hasNext()) {
    switch (reader.selectName(_$UserWithLocationSchema.options)) {
      case _$UserWithLocationSchema.keyProfile:
        if ((seen._value & _$UserWithLocationSchema.profile._value) != 0) {
          throw CodableException('Duplicate field "profile"');
        }
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          profile = _$UserProfileFromReader(reader);
          seen |= _$UserWithLocationSchema.profile;
        }
        break;
      case _$UserWithLocationSchema.keyLocation:
        if ((seen._value & _$UserWithLocationSchema.location._value) != 0) {
          throw CodableException('Duplicate field "location"');
        }
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          location = _$CoordinateFromReader(reader);
          seen |= _$UserWithLocationSchema.location;
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

  return UserWithLocation(profile: profile!, location: location!);
}

// =============================================================================
// 3. Single-Pass Streaming Serializer for UserWithLocation
// =============================================================================
void _$UserWithLocationToWriter(
  UserWithLocation instance,
  JsonTokenWriter writer,
) {
  writer.beginObject();
  writer.writeNameBytes(_$UserWithLocationSchema.nameProfileBytes);
  _$UserProfileToWriter(instance.profile, writer);
  writer.writeNameBytes(_$UserWithLocationSchema.nameLocationBytes);
  _$CoordinateToWriter(instance.location, writer);
  writer.endObject();
}
