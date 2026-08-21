// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: lines_longer_than_80_chars

part of 'small.dart';

// **************************************************************************
// CodableGenerator
// **************************************************************************

// =============================================================================
// 1. Unified Schema Descriptor for SmallLocation
// =============================================================================
extension type const _$SmallLocationSchema(int _value) {
  // String Name Constants
  static const String nameLatitude = 'latitude';
  static const String nameLongitude = 'longitude';
  static const String nameCity = 'city';
  static const String nameCountry = 'country';

  // Key Indices for selectKeyIndex()
  static const int keyLatitude = 0;
  static const int keyLongitude = 1;
  static const int keyCity = 2;
  static const int keyCountry = 3;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
    _$SmallLocationSchema.nameLatitude,
    _$SmallLocationSchema.nameLongitude,
    _$SmallLocationSchema.nameCity,
    _$SmallLocationSchema.nameCountry,
  ]);
  static final KeyOptions keyOptions = options;

  // Bitmask Flags strictly for Required Fields
  static const _$SmallLocationSchema none = _$SmallLocationSchema(0);
  static const int _latitudeBit = 1 << 0;
  static const _$SmallLocationSchema latitude = _$SmallLocationSchema(
    _latitudeBit,
  );
  static const int _longitudeBit = 1 << 1;
  static const _$SmallLocationSchema longitude = _$SmallLocationSchema(
    _longitudeBit,
  );
  static const int _cityBit = 1 << 2;
  static const _$SmallLocationSchema city = _$SmallLocationSchema(_cityBit);
  static const int _countryBit = 1 << 3;
  static const _$SmallLocationSchema country = _$SmallLocationSchema(
    _countryBit,
  );

  // Combined Golden Bitmask for fast single-instruction check
  static const _$SmallLocationSchema golden = _$SmallLocationSchema(
    _latitudeBit | _longitudeBit | _cityBit | _countryBit,
  );

  @pragma('vm:prefer-inline')
  _$SmallLocationSchema operator |(_$SmallLocationSchema other) =>
      _$SmallLocationSchema(_value | other._value);

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
    if ((_value & _cityBit) == 0) {
      missing.add(nameCity);
    }
    if ((_value & _countryBit) == 0) {
      missing.add(nameCountry);
    }
    throw CodableException(
      'Missing required fields for SmallLocation: ${missing.join(", ")}',
    );
  }
}

// =============================================================================
// 2. Universal Keyed Deserializer for SmallLocation
// =============================================================================
SmallLocation _$SmallLocationFromDecoder(Decoder decoder) {
  final keyed = decoder.keyed(options: _$SmallLocationSchema.keyOptions);

  double? latitude;
  double? longitude;
  String? city;
  String? country;
  var seen = _$SmallLocationSchema.none;

  while (keyed.hasNextKey()) {
    switch (keyed.selectKeyIndex(_$SmallLocationSchema.keyOptions)) {
      case _$SmallLocationSchema.keyLatitude:
        if ((seen._value & _$SmallLocationSchema.latitude._value) != 0) {
          throw const CodableException('Duplicate field "latitude"');
        }
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          latitude = keyed.readDouble();
          seen |= _$SmallLocationSchema.latitude;
        }
        break;
      case _$SmallLocationSchema.keyLongitude:
        if ((seen._value & _$SmallLocationSchema.longitude._value) != 0) {
          throw const CodableException('Duplicate field "longitude"');
        }
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          longitude = keyed.readDouble();
          seen |= _$SmallLocationSchema.longitude;
        }
        break;
      case _$SmallLocationSchema.keyCity:
        if ((seen._value & _$SmallLocationSchema.city._value) != 0) {
          throw const CodableException('Duplicate field "city"');
        }
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          city = keyed.readString();
          seen |= _$SmallLocationSchema.city;
        }
        break;
      case _$SmallLocationSchema.keyCountry:
        if ((seen._value & _$SmallLocationSchema.country._value) != 0) {
          throw const CodableException('Duplicate field "country"');
        }
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          country = keyed.readString();
          seen |= _$SmallLocationSchema.country;
        }
        break;
      default:
        keyed.skipValue();
        break;
    }
  }

  // Inlined fast-path check
  seen.validate();

  return SmallLocation(
    latitude: latitude!,
    longitude: longitude!,
    city: city!,
    country: country!,
  );
}

// =============================================================================
// 3. Universal Serializer for SmallLocation
// =============================================================================
void _$SmallLocationToEncoder(SmallLocation instance, Encoder encoder) {
  final keyed = encoder.keyed();
  keyed.encodeDouble(_$SmallLocationSchema.nameLatitude, instance.latitude);
  keyed.encodeDouble(_$SmallLocationSchema.nameLongitude, instance.longitude);
  keyed.encodeString(_$SmallLocationSchema.nameCity, instance.city);
  keyed.encodeString(_$SmallLocationSchema.nameCountry, instance.country);
}

// =============================================================================
// 1. Unified Schema Descriptor for SmallMetadata
// =============================================================================
extension type const _$SmallMetadataSchema(int _value) {
  // String Name Constants
  static const String nameLoginCount = 'loginCount';
  static const String nameLastLogin = 'lastLogin';
  static const String nameLocation = 'location';

  // Key Indices for selectKeyIndex()
  static const int keyLoginCount = 0;
  static const int keyLastLogin = 1;
  static const int keyLocation = 2;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
    _$SmallMetadataSchema.nameLoginCount,
    _$SmallMetadataSchema.nameLastLogin,
    _$SmallMetadataSchema.nameLocation,
  ]);
  static final KeyOptions keyOptions = options;

  // Bitmask Flags strictly for Required Fields
  static const _$SmallMetadataSchema none = _$SmallMetadataSchema(0);
  static const int _loginCountBit = 1 << 0;
  static const _$SmallMetadataSchema loginCount = _$SmallMetadataSchema(
    _loginCountBit,
  );
  static const int _lastLoginBit = 1 << 1;
  static const _$SmallMetadataSchema lastLogin = _$SmallMetadataSchema(
    _lastLoginBit,
  );
  static const int _locationBit = 1 << 2;
  static const _$SmallMetadataSchema location = _$SmallMetadataSchema(
    _locationBit,
  );

  // Combined Golden Bitmask for fast single-instruction check
  static const _$SmallMetadataSchema golden = _$SmallMetadataSchema(
    _loginCountBit | _lastLoginBit | _locationBit,
  );

  @pragma('vm:prefer-inline')
  _$SmallMetadataSchema operator |(_$SmallMetadataSchema other) =>
      _$SmallMetadataSchema(_value | other._value);

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
    if ((_value & _loginCountBit) == 0) {
      missing.add(nameLoginCount);
    }
    if ((_value & _lastLoginBit) == 0) {
      missing.add(nameLastLogin);
    }
    if ((_value & _locationBit) == 0) {
      missing.add(nameLocation);
    }
    throw CodableException(
      'Missing required fields for SmallMetadata: ${missing.join(", ")}',
    );
  }
}

// =============================================================================
// 2. Universal Keyed Deserializer for SmallMetadata
// =============================================================================
SmallMetadata _$SmallMetadataFromDecoder(Decoder decoder) {
  final keyed = decoder.keyed(options: _$SmallMetadataSchema.keyOptions);

  int? loginCount;
  String? lastLogin;
  SmallLocation? location;
  var seen = _$SmallMetadataSchema.none;

  while (keyed.hasNextKey()) {
    switch (keyed.selectKeyIndex(_$SmallMetadataSchema.keyOptions)) {
      case _$SmallMetadataSchema.keyLoginCount:
        if ((seen._value & _$SmallMetadataSchema.loginCount._value) != 0) {
          throw const CodableException('Duplicate field "loginCount"');
        }
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          loginCount = keyed.readInt();
          seen |= _$SmallMetadataSchema.loginCount;
        }
        break;
      case _$SmallMetadataSchema.keyLastLogin:
        if ((seen._value & _$SmallMetadataSchema.lastLogin._value) != 0) {
          throw const CodableException('Duplicate field "lastLogin"');
        }
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          lastLogin = keyed.readString();
          seen |= _$SmallMetadataSchema.lastLogin;
        }
        break;
      case _$SmallMetadataSchema.keyLocation:
        if ((seen._value & _$SmallMetadataSchema.location._value) != 0) {
          throw const CodableException('Duplicate field "location"');
        }
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          location = keyed.decodeValue(_$SmallLocationFromDecoder);
          seen |= _$SmallMetadataSchema.location;
        }
        break;
      default:
        keyed.skipValue();
        break;
    }
  }

  // Inlined fast-path check
  seen.validate();

  return SmallMetadata(
    loginCount: loginCount!,
    lastLogin: lastLogin!,
    location: location!,
  );
}

// =============================================================================
// 3. Universal Serializer for SmallMetadata
// =============================================================================
void _$SmallMetadataToEncoder(SmallMetadata instance, Encoder encoder) {
  final keyed = encoder.keyed();
  keyed.encodeInt(_$SmallMetadataSchema.nameLoginCount, instance.loginCount);
  keyed.encodeString(_$SmallMetadataSchema.nameLastLogin, instance.lastLogin);
  keyed.encodeValue(
    _$SmallMetadataSchema.nameLocation,
    instance.location,
    _$SmallLocationToEncoder,
  );
}

// =============================================================================
// 1. Unified Schema Descriptor for SmallDocument
// =============================================================================
extension type const _$SmallDocumentSchema(int _value) {
  // String Name Constants
  static const String nameId = 'id';
  static const String nameUuid = 'uuid';
  static const String nameName = 'name';
  static const String nameEmail = 'email';
  static const String nameIsActive = 'isActive';
  static const String nameBalance = 'balance';
  static const String nameAge = 'age';
  static const String nameRoles = 'roles';
  static const String nameMetadata = 'metadata';
  static const String nameTags = 'tags';

  // Key Indices for selectKeyIndex()
  static const int keyId = 0;
  static const int keyUuid = 1;
  static const int keyName = 2;
  static const int keyEmail = 3;
  static const int keyIsActive = 4;
  static const int keyBalance = 5;
  static const int keyAge = 6;
  static const int keyRoles = 7;
  static const int keyMetadata = 8;
  static const int keyTags = 9;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
    _$SmallDocumentSchema.nameId,
    _$SmallDocumentSchema.nameUuid,
    _$SmallDocumentSchema.nameName,
    _$SmallDocumentSchema.nameEmail,
    _$SmallDocumentSchema.nameIsActive,
    _$SmallDocumentSchema.nameBalance,
    _$SmallDocumentSchema.nameAge,
    _$SmallDocumentSchema.nameRoles,
    _$SmallDocumentSchema.nameMetadata,
    _$SmallDocumentSchema.nameTags,
  ]);
  static final KeyOptions keyOptions = options;

  // Bitmask Flags strictly for Required Fields
  static const _$SmallDocumentSchema none = _$SmallDocumentSchema(0);
  static const int _idBit = 1 << 0;
  static const _$SmallDocumentSchema id = _$SmallDocumentSchema(_idBit);
  static const int _uuidBit = 1 << 1;
  static const _$SmallDocumentSchema uuid = _$SmallDocumentSchema(_uuidBit);
  static const int _nameBit = 1 << 2;
  static const _$SmallDocumentSchema name = _$SmallDocumentSchema(_nameBit);
  static const int _emailBit = 1 << 3;
  static const _$SmallDocumentSchema email = _$SmallDocumentSchema(_emailBit);
  static const int _isActiveBit = 1 << 4;
  static const _$SmallDocumentSchema isActive = _$SmallDocumentSchema(
    _isActiveBit,
  );
  static const int _balanceBit = 1 << 5;
  static const _$SmallDocumentSchema balance = _$SmallDocumentSchema(
    _balanceBit,
  );
  static const int _ageBit = 1 << 6;
  static const _$SmallDocumentSchema age = _$SmallDocumentSchema(_ageBit);
  static const int _rolesBit = 1 << 7;
  static const _$SmallDocumentSchema roles = _$SmallDocumentSchema(_rolesBit);
  static const int _metadataBit = 1 << 8;
  static const _$SmallDocumentSchema metadata = _$SmallDocumentSchema(
    _metadataBit,
  );
  static const int _tagsBit = 1 << 9;
  static const _$SmallDocumentSchema tags = _$SmallDocumentSchema(_tagsBit);

  // Combined Golden Bitmask for fast single-instruction check
  static const _$SmallDocumentSchema golden = _$SmallDocumentSchema(
    _idBit |
        _uuidBit |
        _nameBit |
        _emailBit |
        _isActiveBit |
        _balanceBit |
        _ageBit |
        _rolesBit |
        _metadataBit |
        _tagsBit,
  );

  @pragma('vm:prefer-inline')
  _$SmallDocumentSchema operator |(_$SmallDocumentSchema other) =>
      _$SmallDocumentSchema(_value | other._value);

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
    if ((_value & _uuidBit) == 0) {
      missing.add(nameUuid);
    }
    if ((_value & _nameBit) == 0) {
      missing.add(nameName);
    }
    if ((_value & _emailBit) == 0) {
      missing.add(nameEmail);
    }
    if ((_value & _isActiveBit) == 0) {
      missing.add(nameIsActive);
    }
    if ((_value & _balanceBit) == 0) {
      missing.add(nameBalance);
    }
    if ((_value & _ageBit) == 0) {
      missing.add(nameAge);
    }
    if ((_value & _rolesBit) == 0) {
      missing.add(nameRoles);
    }
    if ((_value & _metadataBit) == 0) {
      missing.add(nameMetadata);
    }
    if ((_value & _tagsBit) == 0) {
      missing.add(nameTags);
    }
    throw CodableException(
      'Missing required fields for SmallDocument: ${missing.join(", ")}',
    );
  }
}

// =============================================================================
// 2. Universal Keyed Deserializer for SmallDocument
// =============================================================================
SmallDocument _$SmallDocumentFromDecoder(Decoder decoder) {
  final keyed = decoder.keyed(options: _$SmallDocumentSchema.keyOptions);

  int? id;
  String? uuid;
  String? name;
  String? email;
  bool? isActive;
  double? balance;
  int? age;
  List<String>? roles;
  SmallMetadata? metadata;
  List<String>? tags;
  var seen = _$SmallDocumentSchema.none;

  while (keyed.hasNextKey()) {
    switch (keyed.selectKeyIndex(_$SmallDocumentSchema.keyOptions)) {
      case _$SmallDocumentSchema.keyId:
        if ((seen._value & _$SmallDocumentSchema.id._value) != 0) {
          throw const CodableException('Duplicate field "id"');
        }
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          id = keyed.readInt();
          seen |= _$SmallDocumentSchema.id;
        }
        break;
      case _$SmallDocumentSchema.keyUuid:
        if ((seen._value & _$SmallDocumentSchema.uuid._value) != 0) {
          throw const CodableException('Duplicate field "uuid"');
        }
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          uuid = keyed.readString();
          seen |= _$SmallDocumentSchema.uuid;
        }
        break;
      case _$SmallDocumentSchema.keyName:
        if ((seen._value & _$SmallDocumentSchema.name._value) != 0) {
          throw const CodableException('Duplicate field "name"');
        }
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          name = keyed.readString();
          seen |= _$SmallDocumentSchema.name;
        }
        break;
      case _$SmallDocumentSchema.keyEmail:
        if ((seen._value & _$SmallDocumentSchema.email._value) != 0) {
          throw const CodableException('Duplicate field "email"');
        }
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          email = keyed.readString();
          seen |= _$SmallDocumentSchema.email;
        }
        break;
      case _$SmallDocumentSchema.keyIsActive:
        if ((seen._value & _$SmallDocumentSchema.isActive._value) != 0) {
          throw const CodableException('Duplicate field "isActive"');
        }
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          isActive = keyed.readBool();
          seen |= _$SmallDocumentSchema.isActive;
        }
        break;
      case _$SmallDocumentSchema.keyBalance:
        if ((seen._value & _$SmallDocumentSchema.balance._value) != 0) {
          throw const CodableException('Duplicate field "balance"');
        }
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          balance = keyed.readDouble();
          seen |= _$SmallDocumentSchema.balance;
        }
        break;
      case _$SmallDocumentSchema.keyAge:
        if ((seen._value & _$SmallDocumentSchema.age._value) != 0) {
          throw const CodableException('Duplicate field "age"');
        }
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          age = keyed.readInt();
          seen |= _$SmallDocumentSchema.age;
        }
        break;
      case _$SmallDocumentSchema.keyRoles:
        if ((seen._value & _$SmallDocumentSchema.roles._value) != 0) {
          throw const CodableException('Duplicate field "roles"');
        }
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          roles = keyed.decodeStringList();
          seen |= _$SmallDocumentSchema.roles;
        }
        break;
      case _$SmallDocumentSchema.keyMetadata:
        if ((seen._value & _$SmallDocumentSchema.metadata._value) != 0) {
          throw const CodableException('Duplicate field "metadata"');
        }
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          metadata = keyed.decodeValue(_$SmallMetadataFromDecoder);
          seen |= _$SmallDocumentSchema.metadata;
        }
        break;
      case _$SmallDocumentSchema.keyTags:
        if ((seen._value & _$SmallDocumentSchema.tags._value) != 0) {
          throw const CodableException('Duplicate field "tags"');
        }
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          tags = keyed.decodeStringList();
          seen |= _$SmallDocumentSchema.tags;
        }
        break;
      default:
        keyed.skipValue();
        break;
    }
  }

  // Inlined fast-path check
  seen.validate();

  return SmallDocument(
    id: id!,
    uuid: uuid!,
    name: name!,
    email: email!,
    isActive: isActive!,
    balance: balance!,
    age: age!,
    roles: roles!,
    metadata: metadata!,
    tags: tags!,
  );
}

// =============================================================================
// 3. Universal Serializer for SmallDocument
// =============================================================================
void _$SmallDocumentToEncoder(SmallDocument instance, Encoder encoder) {
  final keyed = encoder.keyed();
  keyed.encodeInt(_$SmallDocumentSchema.nameId, instance.id);
  keyed.encodeString(_$SmallDocumentSchema.nameUuid, instance.uuid);
  keyed.encodeString(_$SmallDocumentSchema.nameName, instance.name);
  keyed.encodeString(_$SmallDocumentSchema.nameEmail, instance.email);
  keyed.encodeBool(_$SmallDocumentSchema.nameIsActive, instance.isActive);
  keyed.encodeDouble(_$SmallDocumentSchema.nameBalance, instance.balance);
  keyed.encodeInt(_$SmallDocumentSchema.nameAge, instance.age);
  keyed.encodeStringList(_$SmallDocumentSchema.nameRoles, instance.roles);
  keyed.encodeValue(
    _$SmallDocumentSchema.nameMetadata,
    instance.metadata,
    _$SmallMetadataToEncoder,
  );
  keyed.encodeStringList(_$SmallDocumentSchema.nameTags, instance.tags);
}
