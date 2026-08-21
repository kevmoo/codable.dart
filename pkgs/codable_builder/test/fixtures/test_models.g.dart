// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'test_models.dart';

// =============================================================================
// 1. Unified Schema Descriptor for Point
// =============================================================================
extension type const _$PointSchema(int _value) {
  // String Name Constants
  static const String nameX = 'x';
  static const String nameY = 'y';

  // Pre-Encoded UTF-8 Wire Bytes
  static final Uint8List nameXBytes = Uint8List.fromList(const [120]);
  static final Uint8List nameYBytes = Uint8List.fromList(const [121]);

  // Key Indices for selectName()
  static const int keyX = 0;
  static const int keyY = 1;

  // Pre-Compiled JsonKeyOptions
  static final JsonKeyOptions options = JsonKeyOptions.of(const [
    _$PointSchema.nameX,
    _$PointSchema.nameY,
  ]);
  static final KeyOptions keyOptions = KeyOptions(
    options.keys,
    compiled: options,
  );

  // Bitmask Flags strictly for Required Fields
  static const _$PointSchema none = _$PointSchema(0);
  static const int _xBit = 1 << 0;
  static const _$PointSchema x = _$PointSchema(_xBit);
  static const int _yBit = 1 << 1;
  static const _$PointSchema y = _$PointSchema(_yBit);

  // Composite Golden Mask for Required Fields
  static const _$PointSchema golden = _$PointSchema(_xBit | _yBit);

  @pragma('vm:prefer-inline')
  _$PointSchema operator |(_$PointSchema other) =>
      _$PointSchema(_value | other._value);

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
    if ((_value & _xBit) == 0) {
      missing.add(nameX);
    }
    if ((_value & _yBit) == 0) {
      missing.add(nameY);
    }
    throw CodableException(
      'Missing required fields for Point: ${missing.join(", ")}',
    );
  }
}

// =============================================================================
// 2. Single-Pass Streaming Deserializer for Point
// =============================================================================
Point _$PointFromReader(JsonTokenReader reader) {
  reader.beginObject();

  double? x;
  double? y;
  var seen = _$PointSchema.none;

  while (reader.hasNext()) {
    switch (reader.selectName(_$PointSchema.options)) {
      case _$PointSchema.keyX:
        if ((seen._value & _$PointSchema.x._value) != 0) {
          throw const CodableException('Duplicate field "x"');
        }
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          x = reader.readDouble();
          seen |= _$PointSchema.x;
        }
        break;
      case _$PointSchema.keyY:
        if ((seen._value & _$PointSchema.y._value) != 0) {
          throw const CodableException('Duplicate field "y"');
        }
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          y = reader.readDouble();
          seen |= _$PointSchema.y;
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

  return Point(x!, y!);
}

// =============================================================================
// 3. Universal Keyed Deserializer for Point
// =============================================================================
Point _$PointFromDecoder(Decoder decoder) {
  final keyed = decoder.keyed();

  double? x;
  double? y;
  var seen = _$PointSchema.none;

  while (keyed.hasNextKey()) {
    switch (keyed.selectKeyIndex(_$PointSchema.keyOptions)) {
      case _$PointSchema.keyX:
        if ((seen._value & _$PointSchema.x._value) != 0) {
          throw const CodableException('Duplicate field "x"');
        }
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          x = keyed.readDouble();
          seen |= _$PointSchema.x;
        }
        break;
      case _$PointSchema.keyY:
        if ((seen._value & _$PointSchema.y._value) != 0) {
          throw const CodableException('Duplicate field "y"');
        }
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          y = keyed.readDouble();
          seen |= _$PointSchema.y;
        }
        break;
      default:
        keyed.skipValue();
        break;
    }
  }

  // Inlined fast-path check
  seen.validate();

  return Point(x!, y!);
}

// =============================================================================
// 3. Single-Pass Streaming Serializer for Point
// =============================================================================
void _$PointToWriter(Point instance, JsonTokenWriter writer) {
  writer.beginObject();
  writer.writeNameBytes(_$PointSchema.nameXBytes);
  writer.writeDouble(instance.x);
  writer.writeNameBytes(_$PointSchema.nameYBytes);
  writer.writeDouble(instance.y);
  writer.endObject();
}

// =============================================================================
// 1. Unified Schema Descriptor for UserAccount
// =============================================================================
extension type const _$UserAccountSchema(int _value) {
  // String Name Constants
  static const String nameId = 'id';
  static const String nameEmailAddress = 'email_address';
  static const String nameRole = 'role';
  static const String nameTags = 'tags';
  static const String nameLocation = 'location';

  // Pre-Encoded UTF-8 Wire Bytes
  static final Uint8List nameIdBytes = Uint8List.fromList(const [105, 100]);
  static final Uint8List nameEmailAddressBytes = Uint8List.fromList(const [
    101,
    109,
    97,
    105,
    108,
    95,
    97,
    100,
    100,
    114,
    101,
    115,
    115,
  ]);
  static final Uint8List nameRoleBytes = Uint8List.fromList(const [
    114,
    111,
    108,
    101,
  ]);
  static final Uint8List nameTagsBytes = Uint8List.fromList(const [
    116,
    97,
    103,
    115,
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
  static const int keyId = 0;
  static const int keyEmailAddress = 1;
  static const String aliasEmailAddressEmail = 'email';
  static const int aliasKeyEmailAddressEmail = 2;
  static const String aliasEmailAddressContactEmail = 'contact_email';
  static const int aliasKeyEmailAddressContactEmail = 3;
  static const int keyRole = 4;
  static const int keyTags = 5;
  static const int keyLocation = 6;

  // Pre-Compiled JsonKeyOptions
  static final JsonKeyOptions options = JsonKeyOptions.of(const [
    _$UserAccountSchema.nameId,
    _$UserAccountSchema.nameEmailAddress,
    _$UserAccountSchema.aliasEmailAddressEmail,
    _$UserAccountSchema.aliasEmailAddressContactEmail,
    _$UserAccountSchema.nameRole,
    _$UserAccountSchema.nameTags,
    _$UserAccountSchema.nameLocation,
  ]);
  static final KeyOptions keyOptions = KeyOptions(
    options.keys,
    compiled: options,
  );

  // Enum Options for role
  static final JsonKeyOptions roleEnumOptions = JsonKeyOptions.of(const [
    'admin',
    'member',
    'guest',
  ]);
  static final KeyOptions roleKeyOptions = KeyOptions(
    roleEnumOptions.keys,
    compiled: roleEnumOptions,
  );

  // Bitmask Flags strictly for Required Fields
  static const _$UserAccountSchema none = _$UserAccountSchema(0);
  static const int _idBit = 1 << 0;
  static const _$UserAccountSchema id = _$UserAccountSchema(_idBit);
  static const int _emailAddressBit = 1 << 1;
  static const _$UserAccountSchema emailAddress = _$UserAccountSchema(
    _emailAddressBit,
  );
  static const int _roleBit = 1 << 2;
  static const _$UserAccountSchema role = _$UserAccountSchema(_roleBit);

  // Composite Golden Mask for Required Fields
  static const _$UserAccountSchema golden = _$UserAccountSchema(
    _idBit | _emailAddressBit | _roleBit,
  );

  @pragma('vm:prefer-inline')
  _$UserAccountSchema operator |(_$UserAccountSchema other) =>
      _$UserAccountSchema(_value | other._value);

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
    if ((_value & _emailAddressBit) == 0) {
      missing.add(nameEmailAddress);
    }
    if ((_value & _roleBit) == 0) {
      missing.add(nameRole);
    }
    throw CodableException(
      'Missing required fields for UserAccount: ${missing.join(", ")}',
    );
  }
}

// =============================================================================
// 2. Single-Pass Streaming Deserializer for UserAccount
// =============================================================================
UserAccount _$UserAccountFromReader(JsonTokenReader reader) {
  reader.beginObject();

  String? id;
  String? emailAddress;
  UserRole? role;
  var tags = const <String>[];
  Float64List? location;
  var internalId = '';
  var seen = _$UserAccountSchema.none;

  while (reader.hasNext()) {
    switch (reader.selectName(_$UserAccountSchema.options)) {
      case _$UserAccountSchema.keyId:
        if ((seen._value & _$UserAccountSchema.id._value) != 0) {
          throw const CodableException('Duplicate field "id"');
        }
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          id = reader.readString();
          seen |= _$UserAccountSchema.id;
        }
        break;
      case _$UserAccountSchema.keyEmailAddress:
      case _$UserAccountSchema.aliasKeyEmailAddressEmail:
      case _$UserAccountSchema.aliasKeyEmailAddressContactEmail:
        if ((seen._value & _$UserAccountSchema.emailAddress._value) != 0) {
          throw const CodableException('Duplicate field "email_address"');
        }
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          emailAddress = reader.readString();
          seen |= _$UserAccountSchema.emailAddress;
        }
        break;
      case _$UserAccountSchema.keyRole:
        if ((seen._value & _$UserAccountSchema.role._value) != 0) {
          throw const CodableException('Duplicate field "role"');
        }
        // Zero-allocation enum matching
        final enumIndex = reader.selectString(
          _$UserAccountSchema.roleEnumOptions,
        );
        if (enumIndex >= 0 && enumIndex < UserRole.values.length) {
          role = UserRole.values[enumIndex];
          seen |= _$UserAccountSchema.role;
        } else {
          throw const CodableException('Unknown UserRole value');
        }
        break;
      case _$UserAccountSchema.keyTags:
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
      case _$UserAccountSchema.keyLocation:
        if (reader.isNextNull()) {
          reader.readNull();
          location = null;
        } else {
          reader.beginArray();
          final tuple = Float64List(2);
          var tupleIdx = 0;
          while (reader.hasNext()) {
            if (tupleIdx < 2) {
              tuple[tupleIdx++] = reader.readDouble();
            } else {
              reader.skipValue();
            }
          }
          reader.endArray();
          if (tupleIdx != 2) {
            throw CodableException(
              'Expected 2 elements for tuple "location", got $tupleIdx',
            );
          }
          location = tuple;
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

  return UserAccount(
    id: id!,
    emailAddress: emailAddress!,
    role: role!,
    tags: tags,
    location: location,
    internalId: internalId,
  );
}

// =============================================================================
// 3. Universal Keyed Deserializer for UserAccount
// =============================================================================
UserAccount _$UserAccountFromDecoder(Decoder decoder) {
  final keyed = decoder.keyed();

  String? id;
  String? emailAddress;
  UserRole? role;
  var tags = const <String>[];
  Float64List? location;
  var internalId = '';
  var seen = _$UserAccountSchema.none;

  while (keyed.hasNextKey()) {
    switch (keyed.selectKeyIndex(_$UserAccountSchema.keyOptions)) {
      case _$UserAccountSchema.keyId:
        if ((seen._value & _$UserAccountSchema.id._value) != 0) {
          throw const CodableException('Duplicate field "id"');
        }
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          id = keyed.readString();
          seen |= _$UserAccountSchema.id;
        }
        break;
      case _$UserAccountSchema.keyEmailAddress:
      case _$UserAccountSchema.aliasKeyEmailAddressEmail:
      case _$UserAccountSchema.aliasKeyEmailAddressContactEmail:
        if ((seen._value & _$UserAccountSchema.emailAddress._value) != 0) {
          throw const CodableException('Duplicate field "email_address"');
        }
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          emailAddress = keyed.readString();
          seen |= _$UserAccountSchema.emailAddress;
        }
        break;
      case _$UserAccountSchema.keyRole:
        if ((seen._value & _$UserAccountSchema.role._value) != 0) {
          throw const CodableException('Duplicate field "role"');
        }
        // Zero-allocation enum matching
        final enumIndex = keyed.selectStringIndex(
          _$UserAccountSchema.roleKeyOptions,
        );
        if (enumIndex >= 0 && enumIndex < UserRole.values.length) {
          role = UserRole.values[enumIndex];
          seen |= _$UserAccountSchema.role;
        } else {
          throw const CodableException('Unknown UserRole value');
        }
        break;
      case _$UserAccountSchema.keyTags:
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          tags = keyed.decodeStringList();
        }
        break;
      case _$UserAccountSchema.keyLocation:
        if (keyed.isNextNull()) {
          keyed.readNull();
          location = null;
        } else {
          location = keyed.decodeFloat64List();
        }
        break;
      default:
        keyed.skipValue();
        break;
    }
  }

  // Inlined fast-path check
  seen.validate();

  return UserAccount(
    id: id!,
    emailAddress: emailAddress!,
    role: role!,
    tags: tags,
    location: location,
    internalId: internalId,
  );
}

// =============================================================================
// 3. Single-Pass Streaming Serializer for UserAccount
// =============================================================================
void _$UserAccountToWriter(UserAccount instance, JsonTokenWriter writer) {
  writer.beginObject();
  writer.writeNameBytes(_$UserAccountSchema.nameIdBytes);
  writer.writeString(instance.id);
  writer.writeNameBytes(_$UserAccountSchema.nameEmailAddressBytes);
  writer.writeString(instance.emailAddress);
  writer.writeNameBytes(_$UserAccountSchema.nameRoleBytes);
  writer.writeString(instance.role.name);
  writer.writeNameBytes(_$UserAccountSchema.nameTagsBytes);
  writer.beginArray();
  for (final item in instance.tags) {
    writer.writeString(item);
  }
  writer.endArray();
  if (instance.location != null) {
    writer.writeNameBytes(_$UserAccountSchema.nameLocationBytes);
    writer.beginArray();
    writer.writeDouble(instance.location![0]);
    writer.writeDouble(instance.location![1]);
    writer.endArray();
  }
  writer.endObject();
}

// =============================================================================
// 1. Unified Schema Descriptor for Address
// =============================================================================
extension type const _$AddressSchema(int _value) {
  // String Name Constants
  static const String nameCity = 'city';
  static const String nameStreet = 'street';

  // Pre-Encoded UTF-8 Wire Bytes
  static final Uint8List nameCityBytes = Uint8List.fromList(const [
    99,
    105,
    116,
    121,
  ]);
  static final Uint8List nameStreetBytes = Uint8List.fromList(const [
    115,
    116,
    114,
    101,
    101,
    116,
  ]);

  // Key Indices for selectName()
  static const int keyCity = 0;
  static const int keyStreet = 1;

  // Pre-Compiled JsonKeyOptions
  static final JsonKeyOptions options = JsonKeyOptions.of(const [
    _$AddressSchema.nameCity,
    _$AddressSchema.nameStreet,
  ]);
  static final KeyOptions keyOptions = KeyOptions(
    options.keys,
    compiled: options,
  );

  // Bitmask Flags strictly for Required Fields
  static const _$AddressSchema none = _$AddressSchema(0);
  static const int _cityBit = 1 << 0;
  static const _$AddressSchema city = _$AddressSchema(_cityBit);
  static const int _streetBit = 1 << 1;
  static const _$AddressSchema street = _$AddressSchema(_streetBit);

  // Composite Golden Mask for Required Fields
  static const _$AddressSchema golden = _$AddressSchema(_cityBit | _streetBit);

  @pragma('vm:prefer-inline')
  _$AddressSchema operator |(_$AddressSchema other) =>
      _$AddressSchema(_value | other._value);

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
    if ((_value & _cityBit) == 0) {
      missing.add(nameCity);
    }
    if ((_value & _streetBit) == 0) {
      missing.add(nameStreet);
    }
    throw CodableException(
      'Missing required fields for Address: ${missing.join(", ")}',
    );
  }
}

// =============================================================================
// 2. Single-Pass Streaming Deserializer for Address
// =============================================================================
Address _$AddressFromReader(JsonTokenReader reader) {
  reader.beginObject();

  String? city;
  String? street;
  var seen = _$AddressSchema.none;

  while (reader.hasNext()) {
    switch (reader.selectName(_$AddressSchema.options)) {
      case _$AddressSchema.keyCity:
        if ((seen._value & _$AddressSchema.city._value) != 0) {
          throw const CodableException('Duplicate field "city"');
        }
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          city = reader.readString();
          seen |= _$AddressSchema.city;
        }
        break;
      case _$AddressSchema.keyStreet:
        if ((seen._value & _$AddressSchema.street._value) != 0) {
          throw const CodableException('Duplicate field "street"');
        }
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          street = reader.readString();
          seen |= _$AddressSchema.street;
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

  return Address(city: city!, street: street!);
}

// =============================================================================
// 3. Universal Keyed Deserializer for Address
// =============================================================================
Address _$AddressFromDecoder(Decoder decoder) {
  final keyed = decoder.keyed();

  String? city;
  String? street;
  var seen = _$AddressSchema.none;

  while (keyed.hasNextKey()) {
    switch (keyed.selectKeyIndex(_$AddressSchema.keyOptions)) {
      case _$AddressSchema.keyCity:
        if ((seen._value & _$AddressSchema.city._value) != 0) {
          throw const CodableException('Duplicate field "city"');
        }
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          city = keyed.readString();
          seen |= _$AddressSchema.city;
        }
        break;
      case _$AddressSchema.keyStreet:
        if ((seen._value & _$AddressSchema.street._value) != 0) {
          throw const CodableException('Duplicate field "street"');
        }
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          street = keyed.readString();
          seen |= _$AddressSchema.street;
        }
        break;
      default:
        keyed.skipValue();
        break;
    }
  }

  // Inlined fast-path check
  seen.validate();

  return Address(city: city!, street: street!);
}

// =============================================================================
// 3. Single-Pass Streaming Serializer for Address
// =============================================================================
void _$AddressToWriter(Address instance, JsonTokenWriter writer) {
  writer.beginObject();
  writer.writeNameBytes(_$AddressSchema.nameCityBytes);
  writer.writeString(instance.city);
  writer.writeNameBytes(_$AddressSchema.nameStreetBytes);
  writer.writeString(instance.street);
  writer.endObject();
}

// =============================================================================
// 1. Unified Schema Descriptor for Enterprise
// =============================================================================
extension type const _$EnterpriseSchema(int _value) {
  // String Name Constants
  static const String nameName = 'name';
  static const String nameHeadquarter = 'headquarter';
  static const String nameBranches = 'branches';
  static const String nameCategories = 'categories';
  static const String nameHeadcountByDept = 'headcountByDept';

  // Pre-Encoded UTF-8 Wire Bytes
  static final Uint8List nameNameBytes = Uint8List.fromList(const [
    110,
    97,
    109,
    101,
  ]);
  static final Uint8List nameHeadquarterBytes = Uint8List.fromList(const [
    104,
    101,
    97,
    100,
    113,
    117,
    97,
    114,
    116,
    101,
    114,
  ]);
  static final Uint8List nameBranchesBytes = Uint8List.fromList(const [
    98,
    114,
    97,
    110,
    99,
    104,
    101,
    115,
  ]);
  static final Uint8List nameCategoriesBytes = Uint8List.fromList(const [
    99,
    97,
    116,
    101,
    103,
    111,
    114,
    105,
    101,
    115,
  ]);
  static final Uint8List nameHeadcountByDeptBytes = Uint8List.fromList(const [
    104,
    101,
    97,
    100,
    99,
    111,
    117,
    110,
    116,
    66,
    121,
    68,
    101,
    112,
    116,
  ]);

  // Key Indices for selectName()
  static const int keyName = 0;
  static const int keyHeadquarter = 1;
  static const int keyBranches = 2;
  static const int keyCategories = 3;
  static const int keyHeadcountByDept = 4;

  // Pre-Compiled JsonKeyOptions
  static final JsonKeyOptions options = JsonKeyOptions.of(const [
    _$EnterpriseSchema.nameName,
    _$EnterpriseSchema.nameHeadquarter,
    _$EnterpriseSchema.nameBranches,
    _$EnterpriseSchema.nameCategories,
    _$EnterpriseSchema.nameHeadcountByDept,
  ]);
  static final KeyOptions keyOptions = KeyOptions(
    options.keys,
    compiled: options,
  );

  // Bitmask Flags strictly for Required Fields
  static const _$EnterpriseSchema none = _$EnterpriseSchema(0);
  static const int _nameBit = 1 << 0;
  static const _$EnterpriseSchema name = _$EnterpriseSchema(_nameBit);
  static const int _headquarterBit = 1 << 1;
  static const _$EnterpriseSchema headquarter = _$EnterpriseSchema(
    _headquarterBit,
  );

  // Composite Golden Mask for Required Fields
  static const _$EnterpriseSchema golden = _$EnterpriseSchema(
    _nameBit | _headquarterBit,
  );

  @pragma('vm:prefer-inline')
  _$EnterpriseSchema operator |(_$EnterpriseSchema other) =>
      _$EnterpriseSchema(_value | other._value);

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
    if ((_value & _headquarterBit) == 0) {
      missing.add(nameHeadquarter);
    }
    throw CodableException(
      'Missing required fields for Enterprise: ${missing.join(", ")}',
    );
  }
}

// =============================================================================
// 2. Single-Pass Streaming Deserializer for Enterprise
// =============================================================================
Enterprise _$EnterpriseFromReader(JsonTokenReader reader) {
  reader.beginObject();

  String? name;
  Address? headquarter;
  var branches = const <Address>[];
  var categories = const <String>{};
  var headcountByDept = const <String, int>{};
  var seen = _$EnterpriseSchema.none;

  while (reader.hasNext()) {
    switch (reader.selectName(_$EnterpriseSchema.options)) {
      case _$EnterpriseSchema.keyName:
        if ((seen._value & _$EnterpriseSchema.name._value) != 0) {
          throw const CodableException('Duplicate field "name"');
        }
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          name = reader.readString();
          seen |= _$EnterpriseSchema.name;
        }
        break;
      case _$EnterpriseSchema.keyHeadquarter:
        if ((seen._value & _$EnterpriseSchema.headquarter._value) != 0) {
          throw const CodableException('Duplicate field "headquarter"');
        }
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          headquarter = _$AddressFromReader(reader);
          seen |= _$EnterpriseSchema.headquarter;
        }
        break;
      case _$EnterpriseSchema.keyBranches:
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          reader.beginArray();
          final list = <Address>[];
          while (reader.hasNext()) {
            list.add(_$AddressFromReader(reader));
          }
          reader.endArray();
          branches = list;
        }
        break;
      case _$EnterpriseSchema.keyCategories:
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          reader.beginArray();
          final set = <String>{};
          while (reader.hasNext()) {
            set.add(reader.readString());
          }
          reader.endArray();
          categories = set;
        }
        break;
      case _$EnterpriseSchema.keyHeadcountByDept:
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          reader.beginObject();
          final map = <String, int>{};
          while (reader.hasNext()) {
            final k = reader.nextName();
            map[k] = reader.readInt();
          }
          reader.endObject();
          headcountByDept = map;
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

  return Enterprise(
    name: name!,
    headquarter: headquarter!,
    branches: branches,
    categories: categories,
    headcountByDept: headcountByDept,
  );
}

// =============================================================================
// 3. Universal Keyed Deserializer for Enterprise
// =============================================================================
Enterprise _$EnterpriseFromDecoder(Decoder decoder) {
  final keyed = decoder.keyed();

  String? name;
  Address? headquarter;
  var branches = const <Address>[];
  var categories = const <String>{};
  var headcountByDept = const <String, int>{};
  var seen = _$EnterpriseSchema.none;

  while (keyed.hasNextKey()) {
    switch (keyed.selectKeyIndex(_$EnterpriseSchema.keyOptions)) {
      case _$EnterpriseSchema.keyName:
        if ((seen._value & _$EnterpriseSchema.name._value) != 0) {
          throw const CodableException('Duplicate field "name"');
        }
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          name = keyed.readString();
          seen |= _$EnterpriseSchema.name;
        }
        break;
      case _$EnterpriseSchema.keyHeadquarter:
        if ((seen._value & _$EnterpriseSchema.headquarter._value) != 0) {
          throw const CodableException('Duplicate field "headquarter"');
        }
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          headquarter = keyed.decodeValue(_$AddressFromDecoder);
          seen |= _$EnterpriseSchema.headquarter;
        }
        break;
      case _$EnterpriseSchema.keyBranches:
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          branches = keyed.decodeList(_$AddressFromDecoder);
        }
        break;
      case _$EnterpriseSchema.keyCategories:
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          categories = keyed.decodeStringList().toSet();
        }
        break;
      case _$EnterpriseSchema.keyHeadcountByDept:
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          headcountByDept = keyed.decodeValue((d) {
            final m = <String, int>{};
            final k = d.keyed();
            while (k.hasNextKey()) {
              final key = k.nextKey();
              m[key] = k.readInt();
            }
            return m;
          });
        }
        break;
      default:
        keyed.skipValue();
        break;
    }
  }

  // Inlined fast-path check
  seen.validate();

  return Enterprise(
    name: name!,
    headquarter: headquarter!,
    branches: branches,
    categories: categories,
    headcountByDept: headcountByDept,
  );
}

// =============================================================================
// 3. Single-Pass Streaming Serializer for Enterprise
// =============================================================================
void _$EnterpriseToWriter(Enterprise instance, JsonTokenWriter writer) {
  writer.beginObject();
  writer.writeNameBytes(_$EnterpriseSchema.nameNameBytes);
  writer.writeString(instance.name);
  writer.writeNameBytes(_$EnterpriseSchema.nameHeadquarterBytes);
  _$AddressToWriter(instance.headquarter, writer);
  writer.writeNameBytes(_$EnterpriseSchema.nameBranchesBytes);
  writer.beginArray();
  for (final item in instance.branches) {
    _$AddressToWriter(item, writer);
  }
  writer.endArray();
  writer.writeNameBytes(_$EnterpriseSchema.nameCategoriesBytes);
  writer.beginArray();
  for (final item in instance.categories) {
    writer.writeString(item);
  }
  writer.endArray();
  writer.writeNameBytes(_$EnterpriseSchema.nameHeadcountByDeptBytes);
  writer.beginObject();
  for (final entry in instance.headcountByDept.entries) {
    final value = entry.value;
    writer.writeName(entry.key);
    writer.writeInt(value);
  }
  writer.endObject();
  writer.endObject();
}

// =============================================================================
// 1. Unified Schema Descriptor for UserProfileCustom
// =============================================================================
extension type const _$UserProfileCustomSchema(int _value) {
  // String Name Constants
  static const String nameId = 'id';
  static const String nameZip = 'zip';

  // Pre-Encoded UTF-8 Wire Bytes
  static final Uint8List nameIdBytes = Uint8List.fromList(const [105, 100]);
  static final Uint8List nameZipBytes = Uint8List.fromList(const [
    122,
    105,
    112,
  ]);

  // Key Indices for selectName()
  static const int keyId = 0;
  static const int keyZip = 1;

  // Pre-Compiled JsonKeyOptions
  static final JsonKeyOptions options = JsonKeyOptions.of(const [
    _$UserProfileCustomSchema.nameId,
    _$UserProfileCustomSchema.nameZip,
  ]);
  static final KeyOptions keyOptions = KeyOptions(
    options.keys,
    compiled: options,
  );

  // Bitmask Flags strictly for Required Fields
  static const _$UserProfileCustomSchema none = _$UserProfileCustomSchema(0);
  static const int _idBit = 1 << 0;
  static const _$UserProfileCustomSchema id = _$UserProfileCustomSchema(_idBit);
  static const int _zipBit = 1 << 1;
  static const _$UserProfileCustomSchema zip = _$UserProfileCustomSchema(
    _zipBit,
  );

  // Composite Golden Mask for Required Fields
  static const _$UserProfileCustomSchema golden = _$UserProfileCustomSchema(
    _idBit | _zipBit,
  );

  @pragma('vm:prefer-inline')
  _$UserProfileCustomSchema operator |(_$UserProfileCustomSchema other) =>
      _$UserProfileCustomSchema(_value | other._value);

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
    if ((_value & _zipBit) == 0) {
      missing.add(nameZip);
    }
    throw CodableException(
      'Missing required fields for UserProfileCustom: ${missing.join(", ")}',
    );
  }
}

// =============================================================================
// 2. Single-Pass Streaming Deserializer for UserProfileCustom
// =============================================================================
UserProfileCustom _$UserProfileCustomFromReader(JsonTokenReader reader) {
  reader.beginObject();

  String? id;
  String? zip;
  var seen = _$UserProfileCustomSchema.none;

  while (reader.hasNext()) {
    switch (reader.selectName(_$UserProfileCustomSchema.options)) {
      case _$UserProfileCustomSchema.keyId:
        if ((seen._value & _$UserProfileCustomSchema.id._value) != 0) {
          throw const CodableException('Duplicate field "id"');
        }
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          id = reader.readString();
          seen |= _$UserProfileCustomSchema.id;
        }
        break;
      case _$UserProfileCustomSchema.keyZip:
        if ((seen._value & _$UserProfileCustomSchema.zip._value) != 0) {
          throw const CodableException('Duplicate field "zip"');
        }
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          zip = const ZipCodeDecoder().decodeFromReader(reader);
          seen |= _$UserProfileCustomSchema.zip;
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

  return UserProfileCustom(id: id!, zip: zip!);
}

// =============================================================================
// 3. Universal Keyed Deserializer for UserProfileCustom
// =============================================================================
UserProfileCustom _$UserProfileCustomFromDecoder(Decoder decoder) {
  final keyed = decoder.keyed();

  String? id;
  String? zip;
  var seen = _$UserProfileCustomSchema.none;

  while (keyed.hasNextKey()) {
    switch (keyed.selectKeyIndex(_$UserProfileCustomSchema.keyOptions)) {
      case _$UserProfileCustomSchema.keyId:
        if ((seen._value & _$UserProfileCustomSchema.id._value) != 0) {
          throw const CodableException('Duplicate field "id"');
        }
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          id = keyed.readString();
          seen |= _$UserProfileCustomSchema.id;
        }
        break;
      case _$UserProfileCustomSchema.keyZip:
        if ((seen._value & _$UserProfileCustomSchema.zip._value) != 0) {
          throw const CodableException('Duplicate field "zip"');
        }
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          zip = keyed.decodeValue(const ZipCodeDecoder().decode);
          seen |= _$UserProfileCustomSchema.zip;
        }
        break;
      default:
        keyed.skipValue();
        break;
    }
  }

  // Inlined fast-path check
  seen.validate();

  return UserProfileCustom(id: id!, zip: zip!);
}

// =============================================================================
// 3. Single-Pass Streaming Serializer for UserProfileCustom
// =============================================================================
void _$UserProfileCustomToWriter(
  UserProfileCustom instance,
  JsonTokenWriter writer,
) {
  writer.beginObject();
  writer.writeNameBytes(_$UserProfileCustomSchema.nameIdBytes);
  writer.writeString(instance.id);
  writer.writeNameBytes(_$UserProfileCustomSchema.nameZipBytes);
  const ZipCodeDecoder().encodeToWriter(instance.zip, writer);
  writer.endObject();
}

// =============================================================================
// 1. Unified Schema Descriptor for Team
// =============================================================================
extension type const _$TeamSchema(int _value) {
  // String Name Constants
  static const String nameName = 'name';
  static const String nameRoles = 'roles';
  static const String nameNullableTags = 'nullableTags';
  static const String nameScores = 'scores';

  // Pre-Encoded UTF-8 Wire Bytes
  static final Uint8List nameNameBytes = Uint8List.fromList(const [
    110,
    97,
    109,
    101,
  ]);
  static final Uint8List nameRolesBytes = Uint8List.fromList(const [
    114,
    111,
    108,
    101,
    115,
  ]);
  static final Uint8List nameNullableTagsBytes = Uint8List.fromList(const [
    110,
    117,
    108,
    108,
    97,
    98,
    108,
    101,
    84,
    97,
    103,
    115,
  ]);
  static final Uint8List nameScoresBytes = Uint8List.fromList(const [
    115,
    99,
    111,
    114,
    101,
    115,
  ]);

  // Key Indices for selectName()
  static const int keyName = 0;
  static const int keyRoles = 1;
  static const int keyNullableTags = 2;
  static const int keyScores = 3;

  // Pre-Compiled JsonKeyOptions
  static final JsonKeyOptions options = JsonKeyOptions.of(const [
    _$TeamSchema.nameName,
    _$TeamSchema.nameRoles,
    _$TeamSchema.nameNullableTags,
    _$TeamSchema.nameScores,
  ]);
  static final KeyOptions keyOptions = KeyOptions(
    options.keys,
    compiled: options,
  );

  // Bitmask Flags strictly for Required Fields
  static const _$TeamSchema none = _$TeamSchema(0);
  static const int _nameBit = 1 << 0;
  static const _$TeamSchema name = _$TeamSchema(_nameBit);

  // Composite Golden Mask for Required Fields
  static const _$TeamSchema golden = _$TeamSchema(_nameBit);

  @pragma('vm:prefer-inline')
  _$TeamSchema operator |(_$TeamSchema other) =>
      _$TeamSchema(_value | other._value);

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
      'Missing required fields for Team: ${missing.join(", ")}',
    );
  }
}

// =============================================================================
// 2. Single-Pass Streaming Deserializer for Team
// =============================================================================
Team _$TeamFromReader(JsonTokenReader reader) {
  reader.beginObject();

  String? name;
  var roles = const <UserRole>[];
  var nullableTags = const <String?>{};
  var scores = const <String, int?>{};
  var seen = _$TeamSchema.none;

  while (reader.hasNext()) {
    switch (reader.selectName(_$TeamSchema.options)) {
      case _$TeamSchema.keyName:
        if ((seen._value & _$TeamSchema.name._value) != 0) {
          throw const CodableException('Duplicate field "name"');
        }
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          name = reader.readString();
          seen |= _$TeamSchema.name;
        }
        break;
      case _$TeamSchema.keyRoles:
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          reader.beginArray();
          final list = <UserRole>[];
          while (reader.hasNext()) {
            list.add(UserRole.values.byName(reader.readString()));
          }
          reader.endArray();
          roles = list;
        }
        break;
      case _$TeamSchema.keyNullableTags:
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          reader.beginArray();
          final set = <String?>{};
          while (reader.hasNext()) {
            if (reader.isNextNull()) {
              reader.readNull();
              set.add(null as String?);
            } else {
              set.add(reader.readString());
            }
          }
          reader.endArray();
          nullableTags = set;
        }
        break;
      case _$TeamSchema.keyScores:
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          reader.beginObject();
          final map = <String, int?>{};
          while (reader.hasNext()) {
            final k = reader.nextName();
            if (reader.isNextNull()) {
              reader.readNull();
              map[k] = null as int?;
            } else {
              map[k] = reader.readInt();
            }
          }
          reader.endObject();
          scores = map;
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

  return Team(
    name: name!,
    roles: roles,
    nullableTags: nullableTags,
    scores: scores,
  );
}

// =============================================================================
// 3. Universal Keyed Deserializer for Team
// =============================================================================
Team _$TeamFromDecoder(Decoder decoder) {
  final keyed = decoder.keyed();

  String? name;
  var roles = const <UserRole>[];
  var nullableTags = const <String?>{};
  var scores = const <String, int?>{};
  var seen = _$TeamSchema.none;

  while (keyed.hasNextKey()) {
    switch (keyed.selectKeyIndex(_$TeamSchema.keyOptions)) {
      case _$TeamSchema.keyName:
        if ((seen._value & _$TeamSchema.name._value) != 0) {
          throw const CodableException('Duplicate field "name"');
        }
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          name = keyed.readString();
          seen |= _$TeamSchema.name;
        }
        break;
      case _$TeamSchema.keyRoles:
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          roles = keyed.decodeList(
            (d) => UserRole.values.byName(d.singleValue().readString()),
          );
        }
        break;
      case _$TeamSchema.keyNullableTags:
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          nullableTags = keyed
              .decodeList<String?>((d) => d.singleValue().readNullableString())
              .toSet();
        }
        break;
      case _$TeamSchema.keyScores:
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          scores = keyed.decodeValue((d) {
            final m = <String, int?>{};
            final k = d.keyed();
            while (k.hasNextKey()) {
              final key = k.nextKey();
              if (k.isNextNull()) {
                k.readNull();
                m[key] = null as int?;
              } else {
                m[key] = k.readInt();
              }
            }
            return m;
          });
        }
        break;
      default:
        keyed.skipValue();
        break;
    }
  }

  // Inlined fast-path check
  seen.validate();

  return Team(
    name: name!,
    roles: roles,
    nullableTags: nullableTags,
    scores: scores,
  );
}

// =============================================================================
// 3. Single-Pass Streaming Serializer for Team
// =============================================================================
void _$TeamToWriter(Team instance, JsonTokenWriter writer) {
  writer.beginObject();
  writer.writeNameBytes(_$TeamSchema.nameNameBytes);
  writer.writeString(instance.name);
  writer.writeNameBytes(_$TeamSchema.nameRolesBytes);
  writer.beginArray();
  for (final item in instance.roles) {
    writer.writeString(item.name);
  }
  writer.endArray();
  writer.writeNameBytes(_$TeamSchema.nameNullableTagsBytes);
  writer.beginArray();
  for (final item in instance.nullableTags) {
    if (item == null) {
      writer.writeNull();
    } else {
      writer.writeString(item);
    }
  }
  writer.endArray();
  writer.writeNameBytes(_$TeamSchema.nameScoresBytes);
  writer.beginObject();
  for (final entry in instance.scores.entries) {
    final value = entry.value;
    writer.writeName(entry.key);
    if (value == null) {
      writer.writeNull();
    } else {
      writer.writeInt(value);
    }
  }
  writer.endObject();
  writer.endObject();
}
