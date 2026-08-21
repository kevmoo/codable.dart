// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: lines_longer_than_80_chars, unnecessary_lambdas, deprecated_member_use, unused_element

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
  keyed.encodeDouble(_$CoordinateSchema.nameLatitude, instance.latitude);
  keyed.encodeDouble(_$CoordinateSchema.nameLongitude, instance.longitude);
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

  // Key Indices for selectKeyIndex()
  static const int keyId = 0;
  static const int keyEmail = 1;
  static const int keyRole = 2;
  static const int keyZip = 3;
  static const int keyTags = 4;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
    _$UserProfileSchema.nameId,
    _$UserProfileSchema.nameEmail,
    _$UserProfileSchema.nameRole,
    _$UserProfileSchema.nameZip,
    _$UserProfileSchema.nameTags,
  ]);
  static final KeyOptions keyOptions = options;

  // Enum Options for role
  static final KeyOptions roleEnumOptions = KeyOptions.of(const [
    'admin',
    'member',
    'guest',
  ]);
  static final KeyOptions roleKeyOptions = roleEnumOptions;

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

  // Combined Golden Bitmask for fast single-instruction check
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
// 2. Universal Keyed Deserializer for UserProfile
// =============================================================================
UserProfile _$UserProfileFromDecoder(Decoder decoder) {
  final keyed = decoder.keyed(options: _$UserProfileSchema.keyOptions);

  String? id;
  String? email;
  UserRole? role;
  String? zip;
  var tags = const <String>[];
  var seen = _$UserProfileSchema.none;

  while (keyed.hasNextKey()) {
    switch (keyed.selectKeyIndex(_$UserProfileSchema.keyOptions)) {
      case _$UserProfileSchema.keyId:
        if ((seen._value & _$UserProfileSchema.id._value) != 0) {
          throw const CodableException('Duplicate field "id"');
        }
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          id = keyed.readString();
          seen |= _$UserProfileSchema.id;
        }
        break;
      case _$UserProfileSchema.keyEmail:
        if ((seen._value & _$UserProfileSchema.email._value) != 0) {
          throw const CodableException('Duplicate field "email"');
        }
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          email = keyed.readString();
          seen |= _$UserProfileSchema.email;
        }
        break;
      case _$UserProfileSchema.keyRole:
        if ((seen._value & _$UserProfileSchema.role._value) != 0) {
          throw const CodableException('Duplicate field "role"');
        }
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          final enumIndex = keyed.selectStringIndex(
            _$UserProfileSchema.roleKeyOptions,
          );
          if (enumIndex >= 0 && enumIndex < UserRole.values.length) {
            role = UserRole.values[enumIndex];
          } else {
            throw const CodableException('Unknown UserRole value');
          }
          seen |= _$UserProfileSchema.role;
        }
        break;
      case _$UserProfileSchema.keyZip:
        if ((seen._value & _$UserProfileSchema.zip._value) != 0) {
          throw const CodableException('Duplicate field "zip"');
        }
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          zip = keyed.decodeValue(const ZipCodeDecoder().decode);
          seen |= _$UserProfileSchema.zip;
        }
        break;
      case _$UserProfileSchema.keyTags:
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          tags = keyed.decodeStringList();
        }
        break;
      default:
        keyed.skipValue();
        break;
    }
  }

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
// 3. Universal Serializer for UserProfile
// =============================================================================
void _$UserProfileToEncoder(UserProfile instance, Encoder encoder) {
  final keyed = encoder.keyed();
  keyed.encodeString(_$UserProfileSchema.nameId, instance.id);
  keyed.encodeString(_$UserProfileSchema.nameEmail, instance.email);
  keyed.encodeString(_$UserProfileSchema.nameRole, instance.role.name);
  keyed.encodeValue(
    _$UserProfileSchema.nameZip,
    instance.zip,
    (v, e) => const ZipCodeDecoder().encodeToEncoder(v, e),
  );
  keyed.encodeStringList(_$UserProfileSchema.nameTags, instance.tags);
}

// =============================================================================
// 1. Unified Schema Descriptor for Car
// =============================================================================
extension type const _$CarSchema(int _value) {
  // String Name Constants
  static const String nameMaxSpeed = 'maxSpeed';
  static const String nameDoors = 'doors';

  // Key Indices for selectKeyIndex()
  static const int keyMaxSpeed = 0;
  static const int keyDoors = 1;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
    _$CarSchema.nameMaxSpeed,
    _$CarSchema.nameDoors,
  ]);
  static final KeyOptions keyOptions = options;

  // Bitmask Flags strictly for Required Fields
  static const _$CarSchema none = _$CarSchema(0);
  static const int _maxSpeedBit = 1 << 0;
  static const _$CarSchema maxSpeed = _$CarSchema(_maxSpeedBit);
  static const int _doorsBit = 1 << 1;
  static const _$CarSchema doors = _$CarSchema(_doorsBit);

  // Combined Golden Bitmask for fast single-instruction check
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
// 2. Universal Keyed Deserializer for Car
// =============================================================================
Car _$CarFromDecoder(Decoder decoder) {
  final keyed = decoder.keyed(options: _$CarSchema.keyOptions);

  int? maxSpeed;
  int? doors;
  var seen = _$CarSchema.none;

  while (keyed.hasNextKey()) {
    switch (keyed.selectKeyIndex(_$CarSchema.keyOptions)) {
      case _$CarSchema.keyMaxSpeed:
        if ((seen._value & _$CarSchema.maxSpeed._value) != 0) {
          throw const CodableException('Duplicate field "maxSpeed"');
        }
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          maxSpeed = keyed.readInt();
          seen |= _$CarSchema.maxSpeed;
        }
        break;
      case _$CarSchema.keyDoors:
        if ((seen._value & _$CarSchema.doors._value) != 0) {
          throw const CodableException('Duplicate field "doors"');
        }
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          doors = keyed.readInt();
          seen |= _$CarSchema.doors;
        }
        break;
      default:
        keyed.skipValue();
        break;
    }
  }

  // Inlined fast-path check
  seen.validate();

  return Car(maxSpeed: maxSpeed!, doors: doors!);
}

// =============================================================================
// 3. Universal Serializer for Car
// =============================================================================
void _$CarToEncoder(Car instance, Encoder encoder) {
  final keyed = encoder.keyed();
  keyed.encodeInt(_$CarSchema.nameMaxSpeed, instance.maxSpeed);
  keyed.encodeInt(_$CarSchema.nameDoors, instance.doors);
}

// =============================================================================
// 1. Unified Schema Descriptor for Bicycle
// =============================================================================
extension type const _$BicycleSchema(int _value) {
  // String Name Constants
  static const String nameMaxSpeed = 'maxSpeed';
  static const String nameHasBell = 'hasBell';

  // Key Indices for selectKeyIndex()
  static const int keyMaxSpeed = 0;
  static const int keyHasBell = 1;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
    _$BicycleSchema.nameMaxSpeed,
    _$BicycleSchema.nameHasBell,
  ]);
  static final KeyOptions keyOptions = options;

  // Bitmask Flags strictly for Required Fields
  static const _$BicycleSchema none = _$BicycleSchema(0);
  static const int _maxSpeedBit = 1 << 0;
  static const _$BicycleSchema maxSpeed = _$BicycleSchema(_maxSpeedBit);
  static const int _hasBellBit = 1 << 1;
  static const _$BicycleSchema hasBell = _$BicycleSchema(_hasBellBit);

  // Combined Golden Bitmask for fast single-instruction check
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
// 2. Universal Keyed Deserializer for Bicycle
// =============================================================================
Bicycle _$BicycleFromDecoder(Decoder decoder) {
  final keyed = decoder.keyed(options: _$BicycleSchema.keyOptions);

  int? maxSpeed;
  bool? hasBell;
  var seen = _$BicycleSchema.none;

  while (keyed.hasNextKey()) {
    switch (keyed.selectKeyIndex(_$BicycleSchema.keyOptions)) {
      case _$BicycleSchema.keyMaxSpeed:
        if ((seen._value & _$BicycleSchema.maxSpeed._value) != 0) {
          throw const CodableException('Duplicate field "maxSpeed"');
        }
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          maxSpeed = keyed.readInt();
          seen |= _$BicycleSchema.maxSpeed;
        }
        break;
      case _$BicycleSchema.keyHasBell:
        if ((seen._value & _$BicycleSchema.hasBell._value) != 0) {
          throw const CodableException('Duplicate field "hasBell"');
        }
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          hasBell = keyed.readBool();
          seen |= _$BicycleSchema.hasBell;
        }
        break;
      default:
        keyed.skipValue();
        break;
    }
  }

  // Inlined fast-path check
  seen.validate();

  return Bicycle(maxSpeed: maxSpeed!, hasBell: hasBell!);
}

// =============================================================================
// 3. Universal Serializer for Bicycle
// =============================================================================
void _$BicycleToEncoder(Bicycle instance, Encoder encoder) {
  final keyed = encoder.keyed();
  keyed.encodeInt(_$BicycleSchema.nameMaxSpeed, instance.maxSpeed);
  keyed.encodeBool(_$BicycleSchema.nameHasBell, instance.hasBell);
}

// =============================================================================
// 1. Unified Schema Descriptor for UserWithLocation
// =============================================================================
extension type const _$UserWithLocationSchema(int _value) {
  // String Name Constants
  static const String nameProfile = 'profile';
  static const String nameLocation = 'location';

  // Key Indices for selectKeyIndex()
  static const int keyProfile = 0;
  static const int keyLocation = 1;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
    _$UserWithLocationSchema.nameProfile,
    _$UserWithLocationSchema.nameLocation,
  ]);
  static final KeyOptions keyOptions = options;

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

  // Combined Golden Bitmask for fast single-instruction check
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
// 2. Universal Keyed Deserializer for UserWithLocation
// =============================================================================
UserWithLocation _$UserWithLocationFromDecoder(Decoder decoder) {
  final keyed = decoder.keyed(options: _$UserWithLocationSchema.keyOptions);

  UserProfile? profile;
  Coordinate? location;
  var seen = _$UserWithLocationSchema.none;

  while (keyed.hasNextKey()) {
    switch (keyed.selectKeyIndex(_$UserWithLocationSchema.keyOptions)) {
      case _$UserWithLocationSchema.keyProfile:
        if ((seen._value & _$UserWithLocationSchema.profile._value) != 0) {
          throw const CodableException('Duplicate field "profile"');
        }
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          profile = keyed.decodeValue(_$UserProfileFromDecoder);
          seen |= _$UserWithLocationSchema.profile;
        }
        break;
      case _$UserWithLocationSchema.keyLocation:
        if ((seen._value & _$UserWithLocationSchema.location._value) != 0) {
          throw const CodableException('Duplicate field "location"');
        }
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          location = keyed.decodeValue(_$CoordinateFromDecoder);
          seen |= _$UserWithLocationSchema.location;
        }
        break;
      default:
        keyed.skipValue();
        break;
    }
  }

  // Inlined fast-path check
  seen.validate();

  return UserWithLocation(profile: profile!, location: location!);
}

// =============================================================================
// 3. Universal Serializer for UserWithLocation
// =============================================================================
void _$UserWithLocationToEncoder(UserWithLocation instance, Encoder encoder) {
  final keyed = encoder.keyed();
  keyed.encodeValue(
    _$UserWithLocationSchema.nameProfile,
    instance.profile,
    _$UserProfileToEncoder,
  );
  keyed.encodeValue(
    _$UserWithLocationSchema.nameLocation,
    instance.location,
    _$CoordinateToEncoder,
  );
}
