// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: lines_longer_than_80_chars, unnecessary_lambdas, deprecated_member_use, unused_element

part of 'test_models.dart';

// =============================================================================
// 1. Unified Schema Descriptor for Point
// =============================================================================
extension type const _$PointSchema(int _value) {
  // String Name Constants
  static const String nameX = 'x';
  static const String nameY = 'y';

  // Pre-encoded UTF-8 Wire Name Bytes and StaticKeys
  static const List<int> wireNameBytesX = [34, 120, 34];
  static const StaticKey staticKeyX = StaticKey(nameX, keyX, wireNameBytesX);
  static const List<int> wireNameBytesY = [34, 121, 34];
  static const StaticKey staticKeyY = StaticKey(nameY, keyY, wireNameBytesY);

  // Key Indices for selectKeyIndex()
  static const int keyX = 0;
  static const int keyY = 1;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
    _$PointSchema.nameX,
    _$PointSchema.nameY,
  ]);
  static final KeyOptions keyOptions = options;

  // Bitmask Flags strictly for Required Fields
  static const _$PointSchema none = _$PointSchema(0);
  static const int _xBit = 1 << 0;
  static const _$PointSchema x = _$PointSchema(_xBit);
  static const int _yBit = 1 << 1;
  static const _$PointSchema y = _$PointSchema(_yBit);

  // Combined Golden Bitmask for fast single-instruction check
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
// 2. Universal Keyed Deserializer for Point
// =============================================================================
Point _$PointFromDecoder(Decoder decoder) {
  final keyed = decoder.keyed(options: _$PointSchema.keyOptions);

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
// 3. Universal Serializer for Point
// =============================================================================
void _$PointToEncoder(Point instance, Encoder encoder) {
  final keyed = encoder.keyed();
  keyed.encodeDoubleKey(_$PointSchema.staticKeyX, instance.x);
  keyed.encodeDoubleKey(_$PointSchema.staticKeyY, instance.y);
}

// =============================================================================
// 1. Unified Schema Descriptor for UserAccount
// =============================================================================
extension type const _$UserAccountSchema(int _value) {
  // String Name Constants
  static const String nameId = 'id';
  static const String nameEmailAddress = 'email_address';
  static const String aliasEmailAddressEmail = 'email';
  static const String aliasEmailAddressContactEmail = 'contact_email';
  static const String nameRole = 'role';
  static const String nameTags = 'tags';
  static const String nameLocation = 'location';

  // Pre-encoded UTF-8 Wire Name Bytes and StaticKeys
  static const List<int> wireNameBytesId = [34, 105, 100, 34];
  static const StaticKey staticKeyId = StaticKey(
    nameId,
    keyId,
    wireNameBytesId,
  );
  static const List<int> wireNameBytesEmailAddress = [
    34,
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
    34,
  ];
  static const StaticKey staticKeyEmailAddress = StaticKey(
    nameEmailAddress,
    keyEmailAddress,
    wireNameBytesEmailAddress,
  );
  static const List<int> wireNameBytesRole = [34, 114, 111, 108, 101, 34];
  static const StaticKey staticKeyRole = StaticKey(
    nameRole,
    keyRole,
    wireNameBytesRole,
  );
  static const List<int> wireNameBytesTags = [34, 116, 97, 103, 115, 34];
  static const StaticKey staticKeyTags = StaticKey(
    nameTags,
    keyTags,
    wireNameBytesTags,
  );
  static const List<int> wireNameBytesLocation = [
    34,
    108,
    111,
    99,
    97,
    116,
    105,
    111,
    110,
    34,
  ];
  static const StaticKey staticKeyLocation = StaticKey(
    nameLocation,
    keyLocation,
    wireNameBytesLocation,
  );

  // Key Indices for selectKeyIndex()
  static const int keyId = 0;
  static const int keyEmailAddress = 1;
  static const int aliasKeyEmailAddressEmail = 2;
  static const int aliasKeyEmailAddressContactEmail = 3;
  static const int keyRole = 4;
  static const int keyTags = 5;
  static const int keyLocation = 6;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
    _$UserAccountSchema.nameId,
    _$UserAccountSchema.nameEmailAddress,
    _$UserAccountSchema.aliasEmailAddressEmail,
    _$UserAccountSchema.aliasEmailAddressContactEmail,
    _$UserAccountSchema.nameRole,
    _$UserAccountSchema.nameTags,
    _$UserAccountSchema.nameLocation,
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
  static const _$UserAccountSchema none = _$UserAccountSchema(0);
  static const int _idBit = 1 << 0;
  static const _$UserAccountSchema id = _$UserAccountSchema(_idBit);
  static const int _emailAddressBit = 1 << 1;
  static const _$UserAccountSchema emailAddress = _$UserAccountSchema(
    _emailAddressBit,
  );
  static const int _roleBit = 1 << 2;
  static const _$UserAccountSchema role = _$UserAccountSchema(_roleBit);

  // Combined Golden Bitmask for fast single-instruction check
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
// 2. Universal Keyed Deserializer for UserAccount
// =============================================================================
UserAccount _$UserAccountFromDecoder(Decoder decoder) {
  final keyed = decoder.keyed(options: _$UserAccountSchema.keyOptions);

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
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          final enumIndex = keyed.selectStringIndex(
            _$UserAccountSchema.roleKeyOptions,
          );
          if (enumIndex >= 0 && enumIndex < UserRole.values.length) {
            role = UserRole.values[enumIndex];
          } else {
            throw const CodableException('Unknown UserRole value');
          }
          seen |= _$UserAccountSchema.role;
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
// 3. Universal Serializer for UserAccount
// =============================================================================
void _$UserAccountToEncoder(UserAccount instance, Encoder encoder) {
  final keyed = encoder.keyed();
  keyed.encodeStringKey(_$UserAccountSchema.staticKeyId, instance.id);
  keyed.encodeStringKey(
    _$UserAccountSchema.staticKeyEmailAddress,
    instance.emailAddress,
  );
  keyed.encodeStringKey(_$UserAccountSchema.staticKeyRole, instance.role.name);
  keyed.encodeStringListKey(_$UserAccountSchema.staticKeyTags, instance.tags);
  if (instance.location != null) {
    keyed.encodeListKey<double>(
      _$UserAccountSchema.staticKeyLocation,
      List.generate(2, (i) => instance.location![i]),
      (v, e) => e.singleValue().encodeDouble(v),
    );
  }
}

// =============================================================================
// 1. Unified Schema Descriptor for Address
// =============================================================================
extension type const _$AddressSchema(int _value) {
  // String Name Constants
  static const String nameCity = 'city';
  static const String nameStreet = 'street';

  // Pre-encoded UTF-8 Wire Name Bytes and StaticKeys
  static const List<int> wireNameBytesCity = [34, 99, 105, 116, 121, 34];
  static const StaticKey staticKeyCity = StaticKey(
    nameCity,
    keyCity,
    wireNameBytesCity,
  );
  static const List<int> wireNameBytesStreet = [
    34,
    115,
    116,
    114,
    101,
    101,
    116,
    34,
  ];
  static const StaticKey staticKeyStreet = StaticKey(
    nameStreet,
    keyStreet,
    wireNameBytesStreet,
  );

  // Key Indices for selectKeyIndex()
  static const int keyCity = 0;
  static const int keyStreet = 1;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
    _$AddressSchema.nameCity,
    _$AddressSchema.nameStreet,
  ]);
  static final KeyOptions keyOptions = options;

  // Bitmask Flags strictly for Required Fields
  static const _$AddressSchema none = _$AddressSchema(0);
  static const int _cityBit = 1 << 0;
  static const _$AddressSchema city = _$AddressSchema(_cityBit);
  static const int _streetBit = 1 << 1;
  static const _$AddressSchema street = _$AddressSchema(_streetBit);

  // Combined Golden Bitmask for fast single-instruction check
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
// 2. Universal Keyed Deserializer for Address
// =============================================================================
Address _$AddressFromDecoder(Decoder decoder) {
  final keyed = decoder.keyed(options: _$AddressSchema.keyOptions);

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
// 3. Universal Serializer for Address
// =============================================================================
void _$AddressToEncoder(Address instance, Encoder encoder) {
  final keyed = encoder.keyed();
  keyed.encodeStringKey(_$AddressSchema.staticKeyCity, instance.city);
  keyed.encodeStringKey(_$AddressSchema.staticKeyStreet, instance.street);
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

  // Pre-encoded UTF-8 Wire Name Bytes and StaticKeys
  static const List<int> wireNameBytesName = [34, 110, 97, 109, 101, 34];
  static const StaticKey staticKeyName = StaticKey(
    nameName,
    keyName,
    wireNameBytesName,
  );
  static const List<int> wireNameBytesHeadquarter = [
    34,
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
    34,
  ];
  static const StaticKey staticKeyHeadquarter = StaticKey(
    nameHeadquarter,
    keyHeadquarter,
    wireNameBytesHeadquarter,
  );
  static const List<int> wireNameBytesBranches = [
    34,
    98,
    114,
    97,
    110,
    99,
    104,
    101,
    115,
    34,
  ];
  static const StaticKey staticKeyBranches = StaticKey(
    nameBranches,
    keyBranches,
    wireNameBytesBranches,
  );
  static const List<int> wireNameBytesCategories = [
    34,
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
    34,
  ];
  static const StaticKey staticKeyCategories = StaticKey(
    nameCategories,
    keyCategories,
    wireNameBytesCategories,
  );
  static const List<int> wireNameBytesHeadcountByDept = [
    34,
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
    34,
  ];
  static const StaticKey staticKeyHeadcountByDept = StaticKey(
    nameHeadcountByDept,
    keyHeadcountByDept,
    wireNameBytesHeadcountByDept,
  );

  // Key Indices for selectKeyIndex()
  static const int keyName = 0;
  static const int keyHeadquarter = 1;
  static const int keyBranches = 2;
  static const int keyCategories = 3;
  static const int keyHeadcountByDept = 4;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
    _$EnterpriseSchema.nameName,
    _$EnterpriseSchema.nameHeadquarter,
    _$EnterpriseSchema.nameBranches,
    _$EnterpriseSchema.nameCategories,
    _$EnterpriseSchema.nameHeadcountByDept,
  ]);
  static final KeyOptions keyOptions = options;

  // Bitmask Flags strictly for Required Fields
  static const _$EnterpriseSchema none = _$EnterpriseSchema(0);
  static const int _nameBit = 1 << 0;
  static const _$EnterpriseSchema name = _$EnterpriseSchema(_nameBit);
  static const int _headquarterBit = 1 << 1;
  static const _$EnterpriseSchema headquarter = _$EnterpriseSchema(
    _headquarterBit,
  );

  // Combined Golden Bitmask for fast single-instruction check
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
// 2. Universal Keyed Deserializer for Enterprise
// =============================================================================
Enterprise _$EnterpriseFromDecoder(Decoder decoder) {
  final keyed = decoder.keyed(options: _$EnterpriseSchema.keyOptions);

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
// 3. Universal Serializer for Enterprise
// =============================================================================
void _$EnterpriseToEncoder(Enterprise instance, Encoder encoder) {
  final keyed = encoder.keyed();
  keyed.encodeStringKey(_$EnterpriseSchema.staticKeyName, instance.name);
  keyed.encodeValueKey(
    _$EnterpriseSchema.staticKeyHeadquarter,
    instance.headquarter,
    _$AddressToEncoder,
  );
  keyed.encodeListKey(
    _$EnterpriseSchema.staticKeyBranches,
    instance.branches,
    _$AddressToEncoder,
  );
  keyed.encodeStringListKey(
    _$EnterpriseSchema.staticKeyCategories,
    instance.categories.toList(),
  );
  keyed.encodeValueKey(
    _$EnterpriseSchema.staticKeyHeadcountByDept,
    instance.headcountByDept,
    (map, e) {
      final k = e.keyed();
      for (final entry in map.entries) {
        k.encodeInt(entry.key, entry.value);
      }
    },
  );
}

// =============================================================================
// 1. Unified Schema Descriptor for UserProfileCustom
// =============================================================================
extension type const _$UserProfileCustomSchema(int _value) {
  // String Name Constants
  static const String nameId = 'id';
  static const String nameZip = 'zip';

  // Pre-encoded UTF-8 Wire Name Bytes and StaticKeys
  static const List<int> wireNameBytesId = [34, 105, 100, 34];
  static const StaticKey staticKeyId = StaticKey(
    nameId,
    keyId,
    wireNameBytesId,
  );
  static const List<int> wireNameBytesZip = [34, 122, 105, 112, 34];
  static const StaticKey staticKeyZip = StaticKey(
    nameZip,
    keyZip,
    wireNameBytesZip,
  );

  // Key Indices for selectKeyIndex()
  static const int keyId = 0;
  static const int keyZip = 1;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
    _$UserProfileCustomSchema.nameId,
    _$UserProfileCustomSchema.nameZip,
  ]);
  static final KeyOptions keyOptions = options;

  // Bitmask Flags strictly for Required Fields
  static const _$UserProfileCustomSchema none = _$UserProfileCustomSchema(0);
  static const int _idBit = 1 << 0;
  static const _$UserProfileCustomSchema id = _$UserProfileCustomSchema(_idBit);
  static const int _zipBit = 1 << 1;
  static const _$UserProfileCustomSchema zip = _$UserProfileCustomSchema(
    _zipBit,
  );

  // Combined Golden Bitmask for fast single-instruction check
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
// 2. Universal Keyed Deserializer for UserProfileCustom
// =============================================================================
UserProfileCustom _$UserProfileCustomFromDecoder(Decoder decoder) {
  final keyed = decoder.keyed(options: _$UserProfileCustomSchema.keyOptions);

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
// 3. Universal Serializer for UserProfileCustom
// =============================================================================
void _$UserProfileCustomToEncoder(UserProfileCustom instance, Encoder encoder) {
  final keyed = encoder.keyed();
  keyed.encodeStringKey(_$UserProfileCustomSchema.staticKeyId, instance.id);
  keyed.encodeValueKey(
    _$UserProfileCustomSchema.staticKeyZip,
    instance.zip,
    (v, e) => const ZipCodeDecoder().encodeToEncoder(v, e),
  );
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

  // Pre-encoded UTF-8 Wire Name Bytes and StaticKeys
  static const List<int> wireNameBytesName = [34, 110, 97, 109, 101, 34];
  static const StaticKey staticKeyName = StaticKey(
    nameName,
    keyName,
    wireNameBytesName,
  );
  static const List<int> wireNameBytesRoles = [34, 114, 111, 108, 101, 115, 34];
  static const StaticKey staticKeyRoles = StaticKey(
    nameRoles,
    keyRoles,
    wireNameBytesRoles,
  );
  static const List<int> wireNameBytesNullableTags = [
    34,
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
    34,
  ];
  static const StaticKey staticKeyNullableTags = StaticKey(
    nameNullableTags,
    keyNullableTags,
    wireNameBytesNullableTags,
  );
  static const List<int> wireNameBytesScores = [
    34,
    115,
    99,
    111,
    114,
    101,
    115,
    34,
  ];
  static const StaticKey staticKeyScores = StaticKey(
    nameScores,
    keyScores,
    wireNameBytesScores,
  );

  // Key Indices for selectKeyIndex()
  static const int keyName = 0;
  static const int keyRoles = 1;
  static const int keyNullableTags = 2;
  static const int keyScores = 3;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
    _$TeamSchema.nameName,
    _$TeamSchema.nameRoles,
    _$TeamSchema.nameNullableTags,
    _$TeamSchema.nameScores,
  ]);
  static final KeyOptions keyOptions = options;

  // Bitmask Flags strictly for Required Fields
  static const _$TeamSchema none = _$TeamSchema(0);
  static const int _nameBit = 1 << 0;
  static const _$TeamSchema name = _$TeamSchema(_nameBit);

  // Combined Golden Bitmask for fast single-instruction check
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
// 2. Universal Keyed Deserializer for Team
// =============================================================================
Team _$TeamFromDecoder(Decoder decoder) {
  final keyed = decoder.keyed(options: _$TeamSchema.keyOptions);

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
// 3. Universal Serializer for Team
// =============================================================================
void _$TeamToEncoder(Team instance, Encoder encoder) {
  final keyed = encoder.keyed();
  keyed.encodeStringKey(_$TeamSchema.staticKeyName, instance.name);
  keyed.encodeListKey(_$TeamSchema.staticKeyRoles, instance.roles, (item, e) {
    e.singleValue().encodeString(item.name);
  });
  keyed.encodeListKey(
    _$TeamSchema.staticKeyNullableTags,
    instance.nullableTags,
    (item, e) {
      if (item == null) {
        e.singleValue().encodeNull();
      } else {
        e.singleValue().encodeString(item);
      }
    },
  );
  keyed.encodeValueKey(_$TeamSchema.staticKeyScores, instance.scores, (map, e) {
    final k = e.keyed();
    for (final entry in map.entries) {
      k.encodeNullableInt(entry.key, entry.value);
    }
  });
}
