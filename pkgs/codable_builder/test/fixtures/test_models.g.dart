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
// 2. Companion Codable for Point
// =============================================================================
final class PointCodable implements Codable<Point> {
  const PointCodable();

  @override
  Point decode(Decoder decoder) {
    final keyed = decoder.keyed(options: _$PointSchema.keyOptions);

    double? x;
    double? y;
    var seen = _$PointSchema.none;

    while (keyed.moveNextKey()) {
      switch (keyed.selectKeyIndex(_$PointSchema.keyOptions)) {
        case _$PointSchema.keyX:
          if ((seen._value & _$PointSchema.x._value) != 0) {
            throw const CodableException('Duplicate field "x"');
          }
          x = keyed.readDouble();
          seen |= _$PointSchema.x;
          break;
        case _$PointSchema.keyY:
          if ((seen._value & _$PointSchema.y._value) != 0) {
            throw const CodableException('Duplicate field "y"');
          }
          y = keyed.readDouble();
          seen |= _$PointSchema.y;
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

  List<Point> decodeList(Decoder decoder) {
    final flatDoubles = decoder.decodeUniformDoubleList(const [
      ['x'],
      ['y'],
    ]);
    if (flatDoubles != null) {
      final count = flatDoubles.length ~/ 2;
      return List<Point>.generate(
        count,
        (i) => Point(flatDoubles[i * 2 + 0], flatDoubles[i * 2 + 1]),
        growable: true,
      );
    }

    final unkeyed = decoder.unkeyed();
    final list = <Point>[];
    while (unkeyed.moveNext()) {
      list.add(decode(unkeyed.nestedDecoder()));
    }
    return list;
  }

  @override
  void encode(Point instance, Encoder encoder) {
    final keyed = encoder.keyed(length: 2);
    keyed.encodeDouble(_$PointSchema.nameX, instance.x);
    keyed.encodeDouble(_$PointSchema.nameY, instance.y);
  }
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
// 2. Companion Codable for UserAccount
// =============================================================================
final class UserAccountCodable implements Codable<UserAccount> {
  const UserAccountCodable();

  @override
  UserAccount decode(Decoder decoder) {
    final keyed = decoder.keyed(options: _$UserAccountSchema.keyOptions);

    String? id;
    String? emailAddress;
    UserRole? role;
    var tags = const <String>[];
    Float64List? location;
    var internalId = '';
    var seen = _$UserAccountSchema.none;

    while (keyed.moveNextKey()) {
      switch (keyed.selectKeyIndex(_$UserAccountSchema.keyOptions)) {
        case _$UserAccountSchema.keyId:
          if ((seen._value & _$UserAccountSchema.id._value) != 0) {
            throw const CodableException('Duplicate field "id"');
          }
          id = keyed.readString();
          seen |= _$UserAccountSchema.id;
          break;
        case _$UserAccountSchema.keyEmailAddress:
        case _$UserAccountSchema.aliasKeyEmailAddressEmail:
        case _$UserAccountSchema.aliasKeyEmailAddressContactEmail:
          if ((seen._value & _$UserAccountSchema.emailAddress._value) != 0) {
            throw const CodableException('Duplicate field "email_address"');
          }
          emailAddress = keyed.readString();
          seen |= _$UserAccountSchema.emailAddress;
          break;
        case _$UserAccountSchema.keyRole:
          if ((seen._value & _$UserAccountSchema.role._value) != 0) {
            throw const CodableException('Duplicate field "role"');
          }
          final enumIndex = keyed.selectStringIndex(
            _$UserAccountSchema.roleKeyOptions,
          );
          if (enumIndex >= 0 && enumIndex < UserRole.values.length) {
            role = UserRole.values[enumIndex];
          } else {
            throw const CodableException('Unknown UserRole value');
          }
          seen |= _$UserAccountSchema.role;
          break;
        case _$UserAccountSchema.keyTags:
          tags = keyed.decodeStringList();
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

  @override
  void encode(UserAccount instance, Encoder encoder) {
    var count$ = 4;
    final v$Location = instance.location;
    if (v$Location != null) count$++;
    final keyed = encoder.keyed(length: count$);
    keyed.encodeString(_$UserAccountSchema.nameId, instance.id);
    keyed.encodeString(
      _$UserAccountSchema.nameEmailAddress,
      instance.emailAddress,
    );
    keyed.encodeString(_$UserAccountSchema.nameRole, instance.role.name);
    keyed.encodeStringList(_$UserAccountSchema.nameTags, instance.tags);
    if (v$Location != null) {
      keyed.encodeDoubleList(_$UserAccountSchema.nameLocation, v$Location);
    }
  }
}

// =============================================================================
// 1. Unified Schema Descriptor for Address
// =============================================================================
extension type const _$AddressSchema(int _value) {
  // String Name Constants
  static const String nameCity = 'city';
  static const String nameStreet = 'street';

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
// 2. Companion Codable for Address
// =============================================================================
final class AddressCodable implements Codable<Address> {
  const AddressCodable();

  @override
  Address decode(Decoder decoder) {
    final keyed = decoder.keyed(options: _$AddressSchema.keyOptions);

    String? city;
    String? street;
    var seen = _$AddressSchema.none;

    while (keyed.moveNextKey()) {
      switch (keyed.selectKeyIndex(_$AddressSchema.keyOptions)) {
        case _$AddressSchema.keyCity:
          if ((seen._value & _$AddressSchema.city._value) != 0) {
            throw const CodableException('Duplicate field "city"');
          }
          city = keyed.readString();
          seen |= _$AddressSchema.city;
          break;
        case _$AddressSchema.keyStreet:
          if ((seen._value & _$AddressSchema.street._value) != 0) {
            throw const CodableException('Duplicate field "street"');
          }
          street = keyed.readString();
          seen |= _$AddressSchema.street;
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

  @override
  void encode(Address instance, Encoder encoder) {
    final keyed = encoder.keyed(length: 2);
    keyed.encodeString(_$AddressSchema.nameCity, instance.city);
    keyed.encodeString(_$AddressSchema.nameStreet, instance.street);
  }
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
// 2. Companion Codable for Enterprise
// =============================================================================
final class EnterpriseCodable implements Codable<Enterprise> {
  const EnterpriseCodable();

  @override
  Enterprise decode(Decoder decoder) {
    final keyed = decoder.keyed(options: _$EnterpriseSchema.keyOptions);

    String? name;
    Address? headquarter;
    var branches = const <Address>[];
    var categories = const <String>{};
    var headcountByDept = const <String, int>{};
    var seen = _$EnterpriseSchema.none;

    while (keyed.moveNextKey()) {
      switch (keyed.selectKeyIndex(_$EnterpriseSchema.keyOptions)) {
        case _$EnterpriseSchema.keyName:
          if ((seen._value & _$EnterpriseSchema.name._value) != 0) {
            throw const CodableException('Duplicate field "name"');
          }
          name = keyed.readString();
          seen |= _$EnterpriseSchema.name;
          break;
        case _$EnterpriseSchema.keyHeadquarter:
          if ((seen._value & _$EnterpriseSchema.headquarter._value) != 0) {
            throw const CodableException('Duplicate field "headquarter"');
          }
          headquarter = const AddressCodable().decode(keyed.nestedDecoder());
          seen |= _$EnterpriseSchema.headquarter;
          break;
        case _$EnterpriseSchema.keyBranches:
          branches = const AddressCodable().decodeList(keyed.nestedDecoder());
          break;
        case _$EnterpriseSchema.keyCategories:
          categories = keyed.decodeStringList().toSet();
          break;
        case _$EnterpriseSchema.keyHeadcountByDept:
          {
            final k = keyed.nestedDecoder().keyed();
            final m = <String, int>{};
            while (k.moveNextKey()) {
              final key = k.nextKey();
              m[key] = k.readInt();
            }
            headcountByDept = m;
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

  @override
  void encode(Enterprise instance, Encoder encoder) {
    final keyed = encoder.keyed(length: 5);
    keyed.encodeString(_$EnterpriseSchema.nameName, instance.name);
    keyed.encodeValue(
      _$EnterpriseSchema.nameHeadquarter,
      instance.headquarter,
      const AddressCodable(),
    );
    keyed.encodeList(
      _$EnterpriseSchema.nameBranches,
      instance.branches,
      const AddressCodable(),
    );
    keyed.encodeStringList(
      _$EnterpriseSchema.nameCategories,
      instance.categories.toList(),
    );
    {
      final k = keyed
          .nestedEncoder(_$EnterpriseSchema.nameHeadcountByDept)
          .keyed(length: instance.headcountByDept.length);
      for (final entry in instance.headcountByDept.entries) {
        k.encodeInt(entry.key, entry.value);
      }
    }
  }
}

// =============================================================================
// 1. Unified Schema Descriptor for UserProfileCustom
// =============================================================================
extension type const _$UserProfileCustomSchema(int _value) {
  // String Name Constants
  static const String nameId = 'id';
  static const String nameZip = 'zip';

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
// 2. Companion Codable for UserProfileCustom
// =============================================================================
final class UserProfileCustomCodable implements Codable<UserProfileCustom> {
  const UserProfileCustomCodable();

  @override
  UserProfileCustom decode(Decoder decoder) {
    final keyed = decoder.keyed(options: _$UserProfileCustomSchema.keyOptions);

    String? id;
    String? zip;
    var seen = _$UserProfileCustomSchema.none;

    while (keyed.moveNextKey()) {
      switch (keyed.selectKeyIndex(_$UserProfileCustomSchema.keyOptions)) {
        case _$UserProfileCustomSchema.keyId:
          if ((seen._value & _$UserProfileCustomSchema.id._value) != 0) {
            throw const CodableException('Duplicate field "id"');
          }
          id = keyed.readString();
          seen |= _$UserProfileCustomSchema.id;
          break;
        case _$UserProfileCustomSchema.keyZip:
          if ((seen._value & _$UserProfileCustomSchema.zip._value) != 0) {
            throw const CodableException('Duplicate field "zip"');
          }
          zip = keyed.decodeValue(const ZipCodeDecoder());
          seen |= _$UserProfileCustomSchema.zip;
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

  @override
  void encode(UserProfileCustom instance, Encoder encoder) {
    final keyed = encoder.keyed(length: 2);
    keyed.encodeString(_$UserProfileCustomSchema.nameId, instance.id);
    keyed.encodeValue(
      _$UserProfileCustomSchema.nameZip,
      instance.zip,
      const ZipCodeDecoder(),
    );
  }
}

// =============================================================================
// 1. Unified Schema Descriptor for CodableKeyVariantsModel
// =============================================================================
extension type const _$CodableKeyVariantsModelSchema(int _value) {
  // String Name Constants
  static const String nameZip = 'zip';
  static const String nameDecodeOnlyZip = 'decodeOnlyZip';
  static const String nameUpperCode = 'upperCode';
  static const String nameCreatedAt = 'createdAt';

  // Key Indices for selectKeyIndex()
  static const int keyZip = 0;
  static const int keyDecodeOnlyZip = 1;
  static const int keyUpperCode = 2;
  static const int keyCreatedAt = 3;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
    _$CodableKeyVariantsModelSchema.nameZip,
    _$CodableKeyVariantsModelSchema.nameDecodeOnlyZip,
    _$CodableKeyVariantsModelSchema.nameUpperCode,
    _$CodableKeyVariantsModelSchema.nameCreatedAt,
  ]);
  static final KeyOptions keyOptions = options;

  // Bitmask Flags strictly for Required Fields
  static const _$CodableKeyVariantsModelSchema none =
      _$CodableKeyVariantsModelSchema(0);
  static const int _zipBit = 1 << 0;
  static const _$CodableKeyVariantsModelSchema zip =
      _$CodableKeyVariantsModelSchema(_zipBit);
  static const int _decodeOnlyZipBit = 1 << 1;
  static const _$CodableKeyVariantsModelSchema decodeOnlyZip =
      _$CodableKeyVariantsModelSchema(_decodeOnlyZipBit);
  static const int _upperCodeBit = 1 << 2;
  static const _$CodableKeyVariantsModelSchema upperCode =
      _$CodableKeyVariantsModelSchema(_upperCodeBit);
  static const int _createdAtBit = 1 << 3;
  static const _$CodableKeyVariantsModelSchema createdAt =
      _$CodableKeyVariantsModelSchema(_createdAtBit);

  // Combined Golden Bitmask for fast single-instruction check
  static const _$CodableKeyVariantsModelSchema golden =
      _$CodableKeyVariantsModelSchema(
        _zipBit | _decodeOnlyZipBit | _upperCodeBit | _createdAtBit,
      );

  @pragma('vm:prefer-inline')
  _$CodableKeyVariantsModelSchema operator |(
    _$CodableKeyVariantsModelSchema other,
  ) => _$CodableKeyVariantsModelSchema(_value | other._value);

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
    if ((_value & _zipBit) == 0) {
      missing.add(nameZip);
    }
    if ((_value & _decodeOnlyZipBit) == 0) {
      missing.add(nameDecodeOnlyZip);
    }
    if ((_value & _upperCodeBit) == 0) {
      missing.add(nameUpperCode);
    }
    if ((_value & _createdAtBit) == 0) {
      missing.add(nameCreatedAt);
    }
    throw CodableException(
      'Missing required fields for CodableKeyVariantsModel: ${missing.join(", ")}',
    );
  }
}

// =============================================================================
// 2. Companion Codable for CodableKeyVariantsModel
// =============================================================================
final class CodableKeyVariantsModelCodable
    implements Codable<CodableKeyVariantsModel> {
  const CodableKeyVariantsModelCodable();

  @override
  CodableKeyVariantsModel decode(Decoder decoder) {
    final keyed = decoder.keyed(
      options: _$CodableKeyVariantsModelSchema.keyOptions,
    );

    String? zip;
    String? decodeOnlyZip;
    String? upperCode;
    DateTime? createdAt;
    var seen = _$CodableKeyVariantsModelSchema.none;

    while (keyed.moveNextKey()) {
      switch (keyed.selectKeyIndex(
        _$CodableKeyVariantsModelSchema.keyOptions,
      )) {
        case _$CodableKeyVariantsModelSchema.keyZip:
          if ((seen._value & _$CodableKeyVariantsModelSchema.zip._value) != 0) {
            throw const CodableException('Duplicate field "zip"');
          }
          zip = keyed.decodeValue(const ZipCodeDecoder());
          seen |= _$CodableKeyVariantsModelSchema.zip;
          break;
        case _$CodableKeyVariantsModelSchema.keyDecodeOnlyZip:
          if ((seen._value &
                  _$CodableKeyVariantsModelSchema.decodeOnlyZip._value) !=
              0) {
            throw const CodableException('Duplicate field "decodeOnlyZip"');
          }
          decodeOnlyZip = keyed.decodeValue(const ZipDecodeOnly());
          seen |= _$CodableKeyVariantsModelSchema.decodeOnlyZip;
          break;
        case _$CodableKeyVariantsModelSchema.keyUpperCode:
          if ((seen._value &
                  _$CodableKeyVariantsModelSchema.upperCode._value) !=
              0) {
            throw const CodableException('Duplicate field "upperCode"');
          }
          upperCode = keyed.readString();
          seen |= _$CodableKeyVariantsModelSchema.upperCode;
          break;
        case _$CodableKeyVariantsModelSchema.keyCreatedAt:
          if ((seen._value &
                  _$CodableKeyVariantsModelSchema.createdAt._value) !=
              0) {
            throw const CodableException('Duplicate field "createdAt"');
          }
          createdAt = keyed.decodeValue(const EpochMsDateTimeDecoder());
          seen |= _$CodableKeyVariantsModelSchema.createdAt;
          break;
        default:
          keyed.skipValue();
          break;
      }
    }

    // Inlined fast-path check
    seen.validate();

    return CodableKeyVariantsModel(
      zip: zip!,
      decodeOnlyZip: decodeOnlyZip!,
      upperCode: upperCode!,
      createdAt: createdAt!,
    );
  }

  @override
  void encode(CodableKeyVariantsModel instance, Encoder encoder) {
    final keyed = encoder.keyed(length: 4);
    keyed.encodeValue(
      _$CodableKeyVariantsModelSchema.nameZip,
      instance.zip,
      const ZipCodeDecoder(),
    );
    keyed.encodeString(
      _$CodableKeyVariantsModelSchema.nameDecodeOnlyZip,
      instance.decodeOnlyZip,
    );
    keyed.encodeValue(
      _$CodableKeyVariantsModelSchema.nameUpperCode,
      instance.upperCode,
      const UpperCaseStringEncoder(),
    );
    keyed.encodeValue(
      _$CodableKeyVariantsModelSchema.nameCreatedAt,
      instance.createdAt,
      const EpochMsDateTimeEncoder(),
    );
  }
}

// =============================================================================
// 1. Unified Schema Descriptor for NumericMeasurement
// =============================================================================
extension type const _$NumericMeasurementSchema(int _value) {
  // String Name Constants
  static const String nameScore = 'score';
  static const String nameOptionalScore = 'optionalScore';
  static const String nameSamples = 'samples';
  static const String nameNullableSamples = 'nullableSamples';
  static const String nameDistinctValues = 'distinctValues';
  static const String nameMetrics = 'metrics';
  static const String nameNullableMetrics = 'nullableMetrics';

  // Key Indices for selectKeyIndex()
  static const int keyScore = 0;
  static const int keyOptionalScore = 1;
  static const int keySamples = 2;
  static const int keyNullableSamples = 3;
  static const int keyDistinctValues = 4;
  static const int keyMetrics = 5;
  static const int keyNullableMetrics = 6;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
    _$NumericMeasurementSchema.nameScore,
    _$NumericMeasurementSchema.nameOptionalScore,
    _$NumericMeasurementSchema.nameSamples,
    _$NumericMeasurementSchema.nameNullableSamples,
    _$NumericMeasurementSchema.nameDistinctValues,
    _$NumericMeasurementSchema.nameMetrics,
    _$NumericMeasurementSchema.nameNullableMetrics,
  ]);
  static final KeyOptions keyOptions = options;

  // Bitmask Flags strictly for Required Fields
  static const _$NumericMeasurementSchema none = _$NumericMeasurementSchema(0);
  static const int _scoreBit = 1 << 0;
  static const _$NumericMeasurementSchema score = _$NumericMeasurementSchema(
    _scoreBit,
  );

  // Combined Golden Bitmask for fast single-instruction check
  static const _$NumericMeasurementSchema golden = _$NumericMeasurementSchema(
    _scoreBit,
  );

  @pragma('vm:prefer-inline')
  _$NumericMeasurementSchema operator |(_$NumericMeasurementSchema other) =>
      _$NumericMeasurementSchema(_value | other._value);

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
    if ((_value & _scoreBit) == 0) {
      missing.add(nameScore);
    }
    throw CodableException(
      'Missing required fields for NumericMeasurement: ${missing.join(", ")}',
    );
  }
}

// =============================================================================
// 2. Companion Codable for NumericMeasurement
// =============================================================================
final class NumericMeasurementCodable implements Codable<NumericMeasurement> {
  const NumericMeasurementCodable();

  @override
  NumericMeasurement decode(Decoder decoder) {
    final keyed = decoder.keyed(options: _$NumericMeasurementSchema.keyOptions);

    num? score;
    num? optionalScore;
    var samples = const <num>[];
    var nullableSamples = const <num?>[];
    var distinctValues = const <num>{};
    var metrics = const <String, num>{};
    var nullableMetrics = const <String, num?>{};
    var seen = _$NumericMeasurementSchema.none;

    while (keyed.moveNextKey()) {
      switch (keyed.selectKeyIndex(_$NumericMeasurementSchema.keyOptions)) {
        case _$NumericMeasurementSchema.keyScore:
          if ((seen._value & _$NumericMeasurementSchema.score._value) != 0) {
            throw const CodableException('Duplicate field "score"');
          }
          score = keyed.readNum();
          seen |= _$NumericMeasurementSchema.score;
          break;
        case _$NumericMeasurementSchema.keyOptionalScore:
          if (keyed.isNextNull()) {
            keyed.readNull();
            optionalScore = null;
          } else {
            optionalScore = keyed.readNum();
          }
          break;
        case _$NumericMeasurementSchema.keySamples:
          samples = keyed.decodeList<num>(
            Decodable.fromFunction((d) => d.singleValue().readNum()),
          );
          break;
        case _$NumericMeasurementSchema.keyNullableSamples:
          nullableSamples = keyed.decodeList<num?>(
            Decodable.fromFunction((d) => d.singleValue().readNullableNum()),
          );
          break;
        case _$NumericMeasurementSchema.keyDistinctValues:
          distinctValues = keyed
              .decodeList<num>(
                Decodable.fromFunction((d) => d.singleValue().readNum()),
              )
              .toSet();
          break;
        case _$NumericMeasurementSchema.keyMetrics:
          {
            final k = keyed.nestedDecoder().keyed();
            final m = <String, num>{};
            while (k.moveNextKey()) {
              final key = k.nextKey();
              m[key] = k.readNum();
            }
            metrics = m;
          }
          break;
        case _$NumericMeasurementSchema.keyNullableMetrics:
          {
            final k = keyed.nestedDecoder().keyed();
            final m = <String, num?>{};
            while (k.moveNextKey()) {
              final key = k.nextKey();
              m[key] = k.readNullableNum();
            }
            nullableMetrics = m;
          }
          break;
        default:
          keyed.skipValue();
          break;
      }
    }

    // Inlined fast-path check
    seen.validate();

    return NumericMeasurement(
      score: score!,
      optionalScore: optionalScore,
      samples: samples,
      nullableSamples: nullableSamples,
      distinctValues: distinctValues,
      metrics: metrics,
      nullableMetrics: nullableMetrics,
    );
  }

  @override
  void encode(NumericMeasurement instance, Encoder encoder) {
    var count$ = 6;
    final v$OptionalScore = instance.optionalScore;
    if (v$OptionalScore != null) count$++;
    final keyed = encoder.keyed(length: count$);
    switch (instance.score) {
      case final int v:
        keyed.encodeInt(_$NumericMeasurementSchema.nameScore, v);
      case final v:
        keyed.encodeDouble(_$NumericMeasurementSchema.nameScore, v.toDouble());
    }
    if (v$OptionalScore != null) {
      switch (v$OptionalScore) {
        case final int v:
          keyed.encodeInt(_$NumericMeasurementSchema.nameOptionalScore, v);
        case final v:
          keyed.encodeDouble(
            _$NumericMeasurementSchema.nameOptionalScore,
            v.toDouble(),
          );
      }
    }
    keyed.encodeList(
      _$NumericMeasurementSchema.nameSamples,
      instance.samples,
      Encodable.fromFunction((num item, e) {
        switch (item) {
          case final int v:
            e.singleValue().encodeInt(v);
          case final v:
            e.singleValue().encodeDouble(v.toDouble());
        }
      }),
    );
    keyed.encodeList(
      _$NumericMeasurementSchema.nameNullableSamples,
      instance.nullableSamples,
      Encodable.fromFunction((num? item, e) {
        switch (item) {
          case null:
            e.singleValue().encodeNull();
          case final int v:
            e.singleValue().encodeInt(v);
          case final v:
            e.singleValue().encodeDouble(v.toDouble());
        }
      }),
    );
    keyed.encodeList(
      _$NumericMeasurementSchema.nameDistinctValues,
      instance.distinctValues,
      Encodable.fromFunction((num item, e) {
        switch (item) {
          case final int v:
            e.singleValue().encodeInt(v);
          case final v:
            e.singleValue().encodeDouble(v.toDouble());
        }
      }),
    );
    {
      final k = keyed
          .nestedEncoder(_$NumericMeasurementSchema.nameMetrics)
          .keyed(length: instance.metrics.length);
      for (final entry in instance.metrics.entries) {
        switch (entry.value) {
          case final int v:
            k.encodeInt(entry.key, v);
          case final v:
            k.encodeDouble(entry.key, v.toDouble());
        }
      }
    }
    {
      final k = keyed
          .nestedEncoder(_$NumericMeasurementSchema.nameNullableMetrics)
          .keyed(length: instance.nullableMetrics.length);
      for (final entry in instance.nullableMetrics.entries) {
        switch (entry.value) {
          case null:
            k.encodeNull(entry.key);
          case final int v:
            k.encodeInt(entry.key, v);
          case final v:
            k.encodeDouble(entry.key, v.toDouble());
        }
      }
    }
  }
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
// 2. Companion Codable for Team
// =============================================================================
final class TeamCodable implements Codable<Team> {
  const TeamCodable();

  @override
  Team decode(Decoder decoder) {
    final keyed = decoder.keyed(options: _$TeamSchema.keyOptions);

    String? name;
    var roles = const <UserRole>[];
    var nullableTags = const <String?>{};
    var scores = const <String, int?>{};
    var seen = _$TeamSchema.none;

    while (keyed.moveNextKey()) {
      switch (keyed.selectKeyIndex(_$TeamSchema.keyOptions)) {
        case _$TeamSchema.keyName:
          if ((seen._value & _$TeamSchema.name._value) != 0) {
            throw const CodableException('Duplicate field "name"');
          }
          name = keyed.readString();
          seen |= _$TeamSchema.name;
          break;
        case _$TeamSchema.keyRoles:
          roles = keyed.decodeList(
            Decodable.fromFunction(
              (d) => UserRole.values.byName(d.singleValue().readString()),
            ),
          );
          break;
        case _$TeamSchema.keyNullableTags:
          nullableTags = keyed
              .decodeList<String?>(
                Decodable.fromFunction(
                  (d) => d.singleValue().readNullableString(),
                ),
              )
              .toSet();
          break;
        case _$TeamSchema.keyScores:
          {
            final k = keyed.nestedDecoder().keyed();
            final m = <String, int?>{};
            while (k.moveNextKey()) {
              final key = k.nextKey();
              m[key] = k.readNullableInt();
            }
            scores = m;
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

  @override
  void encode(Team instance, Encoder encoder) {
    final keyed = encoder.keyed(length: 4);
    keyed.encodeString(_$TeamSchema.nameName, instance.name);
    keyed.encodeList(
      _$TeamSchema.nameRoles,
      instance.roles,
      Encodable.fromFunction((UserRole item, e) {
        e.singleValue().encodeString(item.name);
      }),
    );
    keyed.encodeList(
      _$TeamSchema.nameNullableTags,
      instance.nullableTags,
      Encodable.fromFunction((String? item, e) {
        e.singleValue().encodeNullableString(item);
      }),
    );
    {
      final k = keyed
          .nestedEncoder(_$TeamSchema.nameScores)
          .keyed(length: instance.scores.length);
      for (final entry in instance.scores.entries) {
        if (entry.value case final val1?) {
          k.encodeInt(entry.key, val1);
        } else {
          k.encodeNull(entry.key);
        }
      }
    }
  }
}

// =============================================================================
// 1. Unified Schema Descriptor for PrimitiveCollectionsModel
// =============================================================================
extension type const _$PrimitiveCollectionsModelSchema(int _value) {
  // String Name Constants
  static const String nameInts = 'ints';
  static const String nameDoubles = 'doubles';
  static const String nameStrings = 'strings';
  static const String nameBools = 'bools';
  static const String nameFloat64s = 'float64s';
  static const String nameMatrix = 'matrix';
  static const String nameNestedFloats = 'nestedFloats';

  // Key Indices for selectKeyIndex()
  static const int keyInts = 0;
  static const int keyDoubles = 1;
  static const int keyStrings = 2;
  static const int keyBools = 3;
  static const int keyFloat64s = 4;
  static const int keyMatrix = 5;
  static const int keyNestedFloats = 6;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
    _$PrimitiveCollectionsModelSchema.nameInts,
    _$PrimitiveCollectionsModelSchema.nameDoubles,
    _$PrimitiveCollectionsModelSchema.nameStrings,
    _$PrimitiveCollectionsModelSchema.nameBools,
    _$PrimitiveCollectionsModelSchema.nameFloat64s,
    _$PrimitiveCollectionsModelSchema.nameMatrix,
    _$PrimitiveCollectionsModelSchema.nameNestedFloats,
  ]);
  static final KeyOptions keyOptions = options;

  // Bitmask Flags strictly for Required Fields
  static const _$PrimitiveCollectionsModelSchema none =
      _$PrimitiveCollectionsModelSchema(0);
  static const int _float64sBit = 1 << 0;
  static const _$PrimitiveCollectionsModelSchema float64s =
      _$PrimitiveCollectionsModelSchema(_float64sBit);

  // Combined Golden Bitmask for fast single-instruction check
  static const _$PrimitiveCollectionsModelSchema golden =
      _$PrimitiveCollectionsModelSchema(_float64sBit);

  @pragma('vm:prefer-inline')
  _$PrimitiveCollectionsModelSchema operator |(
    _$PrimitiveCollectionsModelSchema other,
  ) => _$PrimitiveCollectionsModelSchema(_value | other._value);

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
    if ((_value & _float64sBit) == 0) {
      missing.add(nameFloat64s);
    }
    throw CodableException(
      'Missing required fields for PrimitiveCollectionsModel: ${missing.join(", ")}',
    );
  }
}

// =============================================================================
// 2. Companion Codable for PrimitiveCollectionsModel
// =============================================================================
final class PrimitiveCollectionsModelCodable
    implements Codable<PrimitiveCollectionsModel> {
  const PrimitiveCollectionsModelCodable();

  @override
  PrimitiveCollectionsModel decode(Decoder decoder) {
    final keyed = decoder.keyed(
      options: _$PrimitiveCollectionsModelSchema.keyOptions,
    );

    var ints = const <int>[];
    var doubles = const <double>[];
    var strings = const <String>[];
    var bools = const <bool>[];
    Float64List? float64s;
    var matrix = const <List<double>>[];
    var nestedFloats = const <Float64List>[];
    var seen = _$PrimitiveCollectionsModelSchema.none;

    while (keyed.moveNextKey()) {
      switch (keyed.selectKeyIndex(
        _$PrimitiveCollectionsModelSchema.keyOptions,
      )) {
        case _$PrimitiveCollectionsModelSchema.keyInts:
          ints = keyed.decodeIntList();
          break;
        case _$PrimitiveCollectionsModelSchema.keyDoubles:
          doubles = keyed.decodeDoubleList();
          break;
        case _$PrimitiveCollectionsModelSchema.keyStrings:
          strings = keyed.decodeStringList();
          break;
        case _$PrimitiveCollectionsModelSchema.keyBools:
          bools = keyed.decodeBoolList();
          break;
        case _$PrimitiveCollectionsModelSchema.keyFloat64s:
          if ((seen._value &
                  _$PrimitiveCollectionsModelSchema.float64s._value) !=
              0) {
            throw const CodableException('Duplicate field "float64s"');
          }
          float64s = keyed.decodeFloat64List();
          seen |= _$PrimitiveCollectionsModelSchema.float64s;
          break;
        case _$PrimitiveCollectionsModelSchema.keyMatrix:
          {
            final u = keyed.nestedDecoder().unkeyed();
            final l = <List<double>>[];
            while (u.moveNext()) {
              l.add(u.decodeDoubleList());
            }
            matrix = l;
          }
          break;
        case _$PrimitiveCollectionsModelSchema.keyNestedFloats:
          {
            final u = keyed.nestedDecoder().unkeyed();
            final l = <Float64List>[];
            while (u.moveNext()) {
              l.add(u.decodeFloat64List());
            }
            nestedFloats = l;
          }
          break;
        default:
          keyed.skipValue();
          break;
      }
    }

    // Inlined fast-path check
    seen.validate();

    return PrimitiveCollectionsModel(
      ints: ints,
      doubles: doubles,
      strings: strings,
      bools: bools,
      float64s: float64s!,
      matrix: matrix,
      nestedFloats: nestedFloats,
    );
  }

  @override
  void encode(PrimitiveCollectionsModel instance, Encoder encoder) {
    final keyed = encoder.keyed(length: 7);
    keyed.encodeIntList(
      _$PrimitiveCollectionsModelSchema.nameInts,
      instance.ints,
    );
    keyed.encodeDoubleList(
      _$PrimitiveCollectionsModelSchema.nameDoubles,
      instance.doubles,
    );
    keyed.encodeStringList(
      _$PrimitiveCollectionsModelSchema.nameStrings,
      instance.strings,
    );
    keyed.encodeBoolList(
      _$PrimitiveCollectionsModelSchema.nameBools,
      instance.bools,
    );
    keyed.encodeDoubleList(
      _$PrimitiveCollectionsModelSchema.nameFloat64s,
      instance.float64s,
    );
    keyed.encodeList(
      _$PrimitiveCollectionsModelSchema.nameMatrix,
      instance.matrix,
      Encodable.fromFunction((List<double> item, e) {
        {
          final u = e.unkeyed(length: item.length);
          for (final elem in item) {
            u.encodeDouble(elem);
          }
        }
      }),
    );
    keyed.encodeList(
      _$PrimitiveCollectionsModelSchema.nameNestedFloats,
      instance.nestedFloats,
      Encodable.fromFunction((Float64List item, e) {
        {
          final u = e.unkeyed(length: item.length);
          for (final elem in item) {
            u.encodeDouble(elem);
          }
        }
      }),
    );
  }
}

// =============================================================================
// 1. Unified Schema Descriptor for BinaryPayloadModel
// =============================================================================
extension type const _$BinaryPayloadModelSchema(int _value) {
  // String Name Constants
  static const String namePayload = 'payload';
  static const String nameSignature = 'signature';
  static const String nameChunks = 'chunks';
  static const String nameNullableChunks = 'nullableChunks';
  static const String nameNamedBlobs = 'namedBlobs';

  // Key Indices for selectKeyIndex()
  static const int keyPayload = 0;
  static const int keySignature = 1;
  static const int keyChunks = 2;
  static const int keyNullableChunks = 3;
  static const int keyNamedBlobs = 4;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
    _$BinaryPayloadModelSchema.namePayload,
    _$BinaryPayloadModelSchema.nameSignature,
    _$BinaryPayloadModelSchema.nameChunks,
    _$BinaryPayloadModelSchema.nameNullableChunks,
    _$BinaryPayloadModelSchema.nameNamedBlobs,
  ]);
  static final KeyOptions keyOptions = options;

  // Bitmask Flags strictly for Required Fields
  static const _$BinaryPayloadModelSchema none = _$BinaryPayloadModelSchema(0);
  static const int _payloadBit = 1 << 0;
  static const _$BinaryPayloadModelSchema payload = _$BinaryPayloadModelSchema(
    _payloadBit,
  );

  // Combined Golden Bitmask for fast single-instruction check
  static const _$BinaryPayloadModelSchema golden = _$BinaryPayloadModelSchema(
    _payloadBit,
  );

  @pragma('vm:prefer-inline')
  _$BinaryPayloadModelSchema operator |(_$BinaryPayloadModelSchema other) =>
      _$BinaryPayloadModelSchema(_value | other._value);

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
    if ((_value & _payloadBit) == 0) {
      missing.add(namePayload);
    }
    throw CodableException(
      'Missing required fields for BinaryPayloadModel: ${missing.join(", ")}',
    );
  }
}

// =============================================================================
// 2. Companion Codable for BinaryPayloadModel
// =============================================================================
final class BinaryPayloadModelCodable implements Codable<BinaryPayloadModel> {
  const BinaryPayloadModelCodable();

  @override
  BinaryPayloadModel decode(Decoder decoder) {
    final keyed = decoder.keyed(options: _$BinaryPayloadModelSchema.keyOptions);

    Uint8List? payload;
    Uint8List? signature;
    var chunks = const <Uint8List>[];
    var nullableChunks = const <Uint8List?>[];
    var namedBlobs = const <String, Uint8List>{};
    var seen = _$BinaryPayloadModelSchema.none;

    while (keyed.moveNextKey()) {
      switch (keyed.selectKeyIndex(_$BinaryPayloadModelSchema.keyOptions)) {
        case _$BinaryPayloadModelSchema.keyPayload:
          if ((seen._value & _$BinaryPayloadModelSchema.payload._value) != 0) {
            throw const CodableException('Duplicate field "payload"');
          }
          payload = keyed.readBytes();
          seen |= _$BinaryPayloadModelSchema.payload;
          break;
        case _$BinaryPayloadModelSchema.keySignature:
          if (keyed.isNextNull()) {
            keyed.readNull();
            signature = null;
          } else {
            signature = keyed.readBytes();
          }
          break;
        case _$BinaryPayloadModelSchema.keyChunks:
          {
            final u = keyed.nestedDecoder().unkeyed();
            final l = <Uint8List>[];
            while (u.moveNext()) {
              l.add(u.readBytes());
            }
            chunks = l;
          }
          break;
        case _$BinaryPayloadModelSchema.keyNullableChunks:
          nullableChunks = keyed.decodeList<Uint8List?>(
            Decodable.fromFunction((d) => d.singleValue().readNullableBytes()),
          );
          break;
        case _$BinaryPayloadModelSchema.keyNamedBlobs:
          {
            final k = keyed.nestedDecoder().keyed();
            final m = <String, Uint8List>{};
            while (k.moveNextKey()) {
              final key = k.nextKey();
              m[key] = k.readBytes();
            }
            namedBlobs = m;
          }
          break;
        default:
          keyed.skipValue();
          break;
      }
    }

    // Inlined fast-path check
    seen.validate();

    return BinaryPayloadModel(
      payload: payload!,
      signature: signature,
      chunks: chunks,
      nullableChunks: nullableChunks,
      namedBlobs: namedBlobs,
    );
  }

  @override
  void encode(BinaryPayloadModel instance, Encoder encoder) {
    var count$ = 4;
    final v$Signature = instance.signature;
    if (v$Signature != null) count$++;
    final keyed = encoder.keyed(length: count$);
    keyed.encodeBytes(_$BinaryPayloadModelSchema.namePayload, instance.payload);
    if (v$Signature != null) {
      keyed.encodeBytes(_$BinaryPayloadModelSchema.nameSignature, v$Signature);
    }
    keyed.encodeList(
      _$BinaryPayloadModelSchema.nameChunks,
      instance.chunks,
      Encodable.fromFunction((Uint8List item, e) {
        e.singleValue().encodeBytes(item);
      }),
    );
    keyed.encodeList(
      _$BinaryPayloadModelSchema.nameNullableChunks,
      instance.nullableChunks,
      Encodable.fromFunction((Uint8List? item, e) {
        e.singleValue().encodeNullableBytes(item);
      }),
    );
    {
      final k = keyed
          .nestedEncoder(_$BinaryPayloadModelSchema.nameNamedBlobs)
          .keyed(length: instance.namedBlobs.length);
      for (final entry in instance.namedBlobs.entries) {
        k.encodeBytes(entry.key, entry.value);
      }
    }
  }
}

// =============================================================================
// 1. Unified Schema Descriptor for TypedKeyMapModel
// =============================================================================
extension type const _$TypedKeyMapModelSchema(int _value) {
  // String Name Constants
  static const String nameStatusMessages = 'statusMessages';
  static const String nameRoleCounts = 'roleCounts';
  static const String nameFlagWeights = 'flagWeights';
  static const String nameBuckets = 'buckets';

  // Key Indices for selectKeyIndex()
  static const int keyStatusMessages = 0;
  static const int keyRoleCounts = 1;
  static const int keyFlagWeights = 2;
  static const int keyBuckets = 3;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
    _$TypedKeyMapModelSchema.nameStatusMessages,
    _$TypedKeyMapModelSchema.nameRoleCounts,
    _$TypedKeyMapModelSchema.nameFlagWeights,
    _$TypedKeyMapModelSchema.nameBuckets,
  ]);
  static final KeyOptions keyOptions = options;

  // Enum Options for UserRole
  static final KeyOptions enumUserRoleKeyOptions = KeyOptions.of(const [
    'admin',
    'member',
    'guest',
  ]);

  // Bitmask Flags strictly for Required Fields
  static const _$TypedKeyMapModelSchema none = _$TypedKeyMapModelSchema(0);

  @pragma('vm:prefer-inline')
  _$TypedKeyMapModelSchema operator |(_$TypedKeyMapModelSchema other) =>
      _$TypedKeyMapModelSchema(_value | other._value);

  /// Validates required fields in 1 CPU test instruction on the fast path.
  @pragma('vm:prefer-inline')
  void validate() {}
}

// =============================================================================
// 2. Companion Codable for TypedKeyMapModel
// =============================================================================
final class TypedKeyMapModelCodable implements Codable<TypedKeyMapModel> {
  const TypedKeyMapModelCodable();

  @override
  TypedKeyMapModel decode(Decoder decoder) {
    final keyed = decoder.keyed(options: _$TypedKeyMapModelSchema.keyOptions);

    var statusMessages = const <int, String>{};
    var roleCounts = const <UserRole, int>{};
    var flagWeights = const <bool, double>{};
    var buckets = const <String, List<int>>{};
    var seen = _$TypedKeyMapModelSchema.none;

    while (keyed.moveNextKey()) {
      switch (keyed.selectKeyIndex(_$TypedKeyMapModelSchema.keyOptions)) {
        case _$TypedKeyMapModelSchema.keyStatusMessages:
          {
            final mDecoder = keyed.nestedDecoder().map();
            final m = <int, String>{};
            while (mDecoder.moveNextEntry()) {
              final key = mDecoder.keyDecoder().singleValue().readInt();
              m[key] = mDecoder.valueDecoder().singleValue().readString();
            }
            statusMessages = m;
          }
          break;
        case _$TypedKeyMapModelSchema.keyRoleCounts:
          {
            final mDecoder = keyed.nestedDecoder().map();
            final m = <UserRole, int>{};
            while (mDecoder.moveNextEntry()) {
              final enumIdx1 = _$TypedKeyMapModelSchema.enumUserRoleKeyOptions
                  .indexOf(mDecoder.keyDecoder().singleValue().readString());
              if (enumIdx1 < 0) {
                throw const CodableException('Unknown UserRole value');
              }
              final key = UserRole.values[enumIdx1];
              m[key] = mDecoder.valueDecoder().singleValue().readInt();
            }
            roleCounts = m;
          }
          break;
        case _$TypedKeyMapModelSchema.keyFlagWeights:
          {
            final mDecoder = keyed.nestedDecoder().map();
            final m = <bool, double>{};
            while (mDecoder.moveNextEntry()) {
              final key = mDecoder.keyDecoder().singleValue().readBool();
              m[key] = mDecoder.valueDecoder().singleValue().readDouble();
            }
            flagWeights = m;
          }
          break;
        case _$TypedKeyMapModelSchema.keyBuckets:
          {
            final k = keyed.nestedDecoder().keyed();
            final m = <String, List<int>>{};
            while (k.moveNextKey()) {
              final key = k.nextKey();
              m[key] = k.decodeIntList();
            }
            buckets = m;
          }
          break;
        default:
          keyed.skipValue();
          break;
      }
    }

    // Inlined fast-path check
    seen.validate();

    return TypedKeyMapModel(
      statusMessages: statusMessages,
      roleCounts: roleCounts,
      flagWeights: flagWeights,
      buckets: buckets,
    );
  }

  @override
  void encode(TypedKeyMapModel instance, Encoder encoder) {
    final keyed = encoder.keyed(length: 4);
    {
      final m = keyed
          .nestedEncoder(_$TypedKeyMapModelSchema.nameStatusMessages)
          .map(length: instance.statusMessages.length);
      for (final entry in instance.statusMessages.entries) {
        m.keyEncoder().singleValue().encodeInt(entry.key);
        m.valueEncoder().singleValue().encodeString(entry.value);
      }
    }
    {
      final m = keyed
          .nestedEncoder(_$TypedKeyMapModelSchema.nameRoleCounts)
          .map(length: instance.roleCounts.length);
      for (final entry in instance.roleCounts.entries) {
        m.keyEncoder().singleValue().encodeString(entry.key.name);
        m.valueEncoder().singleValue().encodeInt(entry.value);
      }
    }
    {
      final m = keyed
          .nestedEncoder(_$TypedKeyMapModelSchema.nameFlagWeights)
          .map(length: instance.flagWeights.length);
      for (final entry in instance.flagWeights.entries) {
        m.keyEncoder().singleValue().encodeBool(entry.key);
        m.valueEncoder().singleValue().encodeDouble(entry.value);
      }
    }
    {
      final k = keyed
          .nestedEncoder(_$TypedKeyMapModelSchema.nameBuckets)
          .keyed(length: instance.buckets.length);
      for (final entry in instance.buckets.entries) {
        k.encodeIntList(entry.key, entry.value);
      }
    }
  }
}

// =============================================================================
// 1. Unified Schema Descriptor for CompositeKeyMapModel
// =============================================================================
extension type const _$CompositeKeyMapModelSchema(int _value) {
  // String Name Constants
  static const String nameLabelsByPoint = 'labelsByPoint';

  // Key Indices for selectKeyIndex()
  static const int keyLabelsByPoint = 0;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
    _$CompositeKeyMapModelSchema.nameLabelsByPoint,
  ]);
  static final KeyOptions keyOptions = options;

  // Bitmask Flags strictly for Required Fields
  static const _$CompositeKeyMapModelSchema none = _$CompositeKeyMapModelSchema(
    0,
  );

  @pragma('vm:prefer-inline')
  _$CompositeKeyMapModelSchema operator |(_$CompositeKeyMapModelSchema other) =>
      _$CompositeKeyMapModelSchema(_value | other._value);

  /// Validates required fields in 1 CPU test instruction on the fast path.
  @pragma('vm:prefer-inline')
  void validate() {}
}

// =============================================================================
// 2. Companion Codable for CompositeKeyMapModel
// =============================================================================
final class CompositeKeyMapModelCodable
    implements Codable<CompositeKeyMapModel> {
  const CompositeKeyMapModelCodable();

  @override
  CompositeKeyMapModel decode(Decoder decoder) {
    final keyed = decoder.keyed(
      options: _$CompositeKeyMapModelSchema.keyOptions,
    );

    var labelsByPoint = const <Point, String>{};
    var seen = _$CompositeKeyMapModelSchema.none;

    while (keyed.moveNextKey()) {
      switch (keyed.selectKeyIndex(_$CompositeKeyMapModelSchema.keyOptions)) {
        case _$CompositeKeyMapModelSchema.keyLabelsByPoint:
          {
            final mDecoder = keyed.nestedDecoder().map();
            final m = <Point, String>{};
            while (mDecoder.moveNextEntry()) {
              final key = const PointCodable().decode(mDecoder.keyDecoder());
              m[key] = mDecoder.valueDecoder().singleValue().readString();
            }
            labelsByPoint = m;
          }
          break;
        default:
          keyed.skipValue();
          break;
      }
    }

    // Inlined fast-path check
    seen.validate();

    return CompositeKeyMapModel(labelsByPoint: labelsByPoint);
  }

  @override
  void encode(CompositeKeyMapModel instance, Encoder encoder) {
    final keyed = encoder.keyed(length: 1);
    {
      final m = keyed
          .nestedEncoder(_$CompositeKeyMapModelSchema.nameLabelsByPoint)
          .map(length: instance.labelsByPoint.length);
      for (final entry in instance.labelsByPoint.entries) {
        const PointCodable().encode(entry.key, m.keyEncoder());
        m.valueEncoder().singleValue().encodeString(entry.value);
      }
    }
  }
}

// =============================================================================
// 1. Unified Schema Descriptor for StringKeyedNestedMapModel
// =============================================================================
extension type const _$StringKeyedNestedMapModelSchema(int _value) {
  // String Name Constants
  static const String nameRolesByUser = 'rolesByUser';
  static const String nameOfficesByCode = 'officesByCode';
  static const String nameNestedCounts = 'nestedCounts';

  // Key Indices for selectKeyIndex()
  static const int keyRolesByUser = 0;
  static const int keyOfficesByCode = 1;
  static const int keyNestedCounts = 2;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
    _$StringKeyedNestedMapModelSchema.nameRolesByUser,
    _$StringKeyedNestedMapModelSchema.nameOfficesByCode,
    _$StringKeyedNestedMapModelSchema.nameNestedCounts,
  ]);
  static final KeyOptions keyOptions = options;

  // Enum Options for UserRole
  static final KeyOptions enumUserRoleKeyOptions = KeyOptions.of(const [
    'admin',
    'member',
    'guest',
  ]);

  // Bitmask Flags strictly for Required Fields
  static const _$StringKeyedNestedMapModelSchema none =
      _$StringKeyedNestedMapModelSchema(0);

  @pragma('vm:prefer-inline')
  _$StringKeyedNestedMapModelSchema operator |(
    _$StringKeyedNestedMapModelSchema other,
  ) => _$StringKeyedNestedMapModelSchema(_value | other._value);

  /// Validates required fields in 1 CPU test instruction on the fast path.
  @pragma('vm:prefer-inline')
  void validate() {}
}

// =============================================================================
// 2. Companion Codable for StringKeyedNestedMapModel
// =============================================================================
final class StringKeyedNestedMapModelCodable
    implements Codable<StringKeyedNestedMapModel> {
  const StringKeyedNestedMapModelCodable();

  @override
  StringKeyedNestedMapModel decode(Decoder decoder) {
    final keyed = decoder.keyed(
      options: _$StringKeyedNestedMapModelSchema.keyOptions,
    );

    var rolesByUser = const <String, UserRole>{};
    var officesByCode = const <String, Address?>{};
    var nestedCounts = const <String, Map<String, int>>{};
    var seen = _$StringKeyedNestedMapModelSchema.none;

    while (keyed.moveNextKey()) {
      switch (keyed.selectKeyIndex(
        _$StringKeyedNestedMapModelSchema.keyOptions,
      )) {
        case _$StringKeyedNestedMapModelSchema.keyRolesByUser:
          {
            final k = keyed.nestedDecoder().keyed();
            final m = <String, UserRole>{};
            while (k.moveNextKey()) {
              final key = k.nextKey();
              final enumIdx1 = k.selectStringIndex(
                _$StringKeyedNestedMapModelSchema.enumUserRoleKeyOptions,
              );
              if (enumIdx1 < 0 || enumIdx1 >= UserRole.values.length) {
                throw const CodableException('Unknown UserRole value');
              }
              m[key] = UserRole.values[enumIdx1];
            }
            rolesByUser = m;
          }
          break;
        case _$StringKeyedNestedMapModelSchema.keyOfficesByCode:
          {
            final k = keyed.nestedDecoder().keyed();
            final m = <String, Address?>{};
            while (k.moveNextKey()) {
              final key = k.nextKey();
              if (k.isNextNull()) {
                k.readNull();
                m[key] = null;
              } else {
                m[key] = const AddressCodable().decode(k.nestedDecoder());
              }
            }
            officesByCode = m;
          }
          break;
        case _$StringKeyedNestedMapModelSchema.keyNestedCounts:
          {
            final k = keyed.nestedDecoder().keyed();
            final m = <String, Map<String, int>>{};
            while (k.moveNextKey()) {
              final key = k.nextKey();
              {
                final k1 = k.nestedDecoder().keyed();
                final m1 = <String, int>{};
                while (k1.moveNextKey()) {
                  final key1 = k1.nextKey();
                  m1[key1] = k1.readInt();
                }
                m[key] = m1;
              }
            }
            nestedCounts = m;
          }
          break;
        default:
          keyed.skipValue();
          break;
      }
    }

    // Inlined fast-path check
    seen.validate();

    return StringKeyedNestedMapModel(
      rolesByUser: rolesByUser,
      officesByCode: officesByCode,
      nestedCounts: nestedCounts,
    );
  }

  @override
  void encode(StringKeyedNestedMapModel instance, Encoder encoder) {
    final keyed = encoder.keyed(length: 3);
    {
      final k = keyed
          .nestedEncoder(_$StringKeyedNestedMapModelSchema.nameRolesByUser)
          .keyed(length: instance.rolesByUser.length);
      for (final entry in instance.rolesByUser.entries) {
        k.encodeString(entry.key, entry.value.name);
      }
    }
    {
      final k = keyed
          .nestedEncoder(_$StringKeyedNestedMapModelSchema.nameOfficesByCode)
          .keyed(length: instance.officesByCode.length);
      for (final entry in instance.officesByCode.entries) {
        if (entry.value case final val1?) {
          const AddressCodable().encode(val1, k.nestedEncoder(entry.key));
        } else {
          k.encodeNull(entry.key);
        }
      }
    }
    {
      final k = keyed
          .nestedEncoder(_$StringKeyedNestedMapModelSchema.nameNestedCounts)
          .keyed(length: instance.nestedCounts.length);
      for (final entry in instance.nestedCounts.entries) {
        {
          final k1 = k
              .nestedEncoder(entry.key)
              .keyed(length: entry.value.length);
          for (final entry1 in entry.value.entries) {
            k1.encodeInt(entry1.key, entry1.value);
          }
        }
      }
    }
  }
}

// =============================================================================
// 1. Unified Schema Descriptor for NullableGetterTelemetry
// =============================================================================
extension type const _$NullableGetterTelemetrySchema(int _value) {
  // String Name Constants
  static const String nameId = 'id';
  static const String nameTag = 'tag';
  static const String nameScore = 'score';
  static const String nameLocation = 'location';

  // Key Indices for selectKeyIndex()
  static const int keyId = 0;
  static const int keyTag = 1;
  static const int keyScore = 2;
  static const int keyLocation = 3;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
    _$NullableGetterTelemetrySchema.nameId,
    _$NullableGetterTelemetrySchema.nameTag,
    _$NullableGetterTelemetrySchema.nameScore,
    _$NullableGetterTelemetrySchema.nameLocation,
  ]);
  static final KeyOptions keyOptions = options;

  // Bitmask Flags strictly for Required Fields
  static const _$NullableGetterTelemetrySchema none =
      _$NullableGetterTelemetrySchema(0);
  static const int _idBit = 1 << 0;
  static const _$NullableGetterTelemetrySchema id =
      _$NullableGetterTelemetrySchema(_idBit);

  // Combined Golden Bitmask for fast single-instruction check
  static const _$NullableGetterTelemetrySchema golden =
      _$NullableGetterTelemetrySchema(_idBit);

  @pragma('vm:prefer-inline')
  _$NullableGetterTelemetrySchema operator |(
    _$NullableGetterTelemetrySchema other,
  ) => _$NullableGetterTelemetrySchema(_value | other._value);

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
    throw CodableException(
      'Missing required fields for NullableGetterTelemetry: ${missing.join(", ")}',
    );
  }
}

// =============================================================================
// 2. Companion Codable for NullableGetterTelemetry
// =============================================================================
final class NullableGetterTelemetryCodable
    implements Codable<NullableGetterTelemetry> {
  const NullableGetterTelemetryCodable();

  @override
  NullableGetterTelemetry decode(Decoder decoder) {
    final keyed = decoder.keyed(
      options: _$NullableGetterTelemetrySchema.keyOptions,
    );

    String? id;
    String? tag;
    int? score;
    Address? location;
    void Function(String)? onRead;
    var seen = _$NullableGetterTelemetrySchema.none;

    while (keyed.moveNextKey()) {
      switch (keyed.selectKeyIndex(
        _$NullableGetterTelemetrySchema.keyOptions,
      )) {
        case _$NullableGetterTelemetrySchema.keyId:
          if ((seen._value & _$NullableGetterTelemetrySchema.id._value) != 0) {
            throw const CodableException('Duplicate field "id"');
          }
          id = keyed.readString();
          seen |= _$NullableGetterTelemetrySchema.id;
          break;
        case _$NullableGetterTelemetrySchema.keyTag:
          if (keyed.isNextNull()) {
            keyed.readNull();
            tag = null;
          } else {
            tag = keyed.readString();
          }
          break;
        case _$NullableGetterTelemetrySchema.keyScore:
          if (keyed.isNextNull()) {
            keyed.readNull();
            score = null;
          } else {
            score = keyed.readInt();
          }
          break;
        case _$NullableGetterTelemetrySchema.keyLocation:
          if (keyed.isNextNull()) {
            keyed.readNull();
            location = null;
          } else {
            location = const AddressCodable().decode(keyed.nestedDecoder());
          }
          break;
        default:
          keyed.skipValue();
          break;
      }
    }

    // Inlined fast-path check
    seen.validate();

    return NullableGetterTelemetry(
      id: id!,
      tag: tag,
      score: score,
      location: location,
      onRead: onRead,
    );
  }

  @override
  void encode(NullableGetterTelemetry instance, Encoder encoder) {
    var count$ = 1;
    final v$Tag = instance.tag;
    if (v$Tag != null) count$++;
    final v$Score = instance.score;
    if (v$Score != null) count$++;
    final v$Location = instance.location;
    if (v$Location != null) count$++;
    final keyed = encoder.keyed(length: count$);
    keyed.encodeString(_$NullableGetterTelemetrySchema.nameId, instance.id);
    if (v$Tag != null) {
      keyed.encodeString(_$NullableGetterTelemetrySchema.nameTag, v$Tag);
    }
    if (v$Score != null) {
      keyed.encodeInt(_$NullableGetterTelemetrySchema.nameScore, v$Score);
    }
    if (v$Location != null) {
      keyed.encodeValue(
        _$NullableGetterTelemetrySchema.nameLocation,
        v$Location,
        const AddressCodable(),
      );
    }
  }
}

// =============================================================================
// 1. Unified Schema Descriptor for AllNullableModel
// =============================================================================
extension type const _$AllNullableModelSchema(int _value) {
  // String Name Constants
  static const String nameA = 'a';
  static const String nameB = 'b';
  static const String nameItems = 'items';
  static const String nameRoles = 'roles';
  static const String nameLabels = 'labels';
  static const String nameCodes = 'codes';

  // Key Indices for selectKeyIndex()
  static const int keyA = 0;
  static const int keyB = 1;
  static const int keyItems = 2;
  static const int keyRoles = 3;
  static const int keyLabels = 4;
  static const int keyCodes = 5;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
    _$AllNullableModelSchema.nameA,
    _$AllNullableModelSchema.nameB,
    _$AllNullableModelSchema.nameItems,
    _$AllNullableModelSchema.nameRoles,
    _$AllNullableModelSchema.nameLabels,
    _$AllNullableModelSchema.nameCodes,
  ]);
  static final KeyOptions keyOptions = options;

  // Bitmask Flags strictly for Required Fields
  static const _$AllNullableModelSchema none = _$AllNullableModelSchema(0);

  @pragma('vm:prefer-inline')
  _$AllNullableModelSchema operator |(_$AllNullableModelSchema other) =>
      _$AllNullableModelSchema(_value | other._value);

  /// Validates required fields in 1 CPU test instruction on the fast path.
  @pragma('vm:prefer-inline')
  void validate() {}
}

// =============================================================================
// 2. Companion Codable for AllNullableModel
// =============================================================================
final class AllNullableModelCodable implements Codable<AllNullableModel> {
  const AllNullableModelCodable();

  @override
  AllNullableModel decode(Decoder decoder) {
    final keyed = decoder.keyed(options: _$AllNullableModelSchema.keyOptions);

    int? a;
    String? b;
    List<int>? items;
    Set<UserRole>? roles;
    Map<String, int>? labels;
    Map<int, String>? codes;
    var seen = _$AllNullableModelSchema.none;

    while (keyed.moveNextKey()) {
      switch (keyed.selectKeyIndex(_$AllNullableModelSchema.keyOptions)) {
        case _$AllNullableModelSchema.keyA:
          if (keyed.isNextNull()) {
            keyed.readNull();
            a = null;
          } else {
            a = keyed.readInt();
          }
          break;
        case _$AllNullableModelSchema.keyB:
          if (keyed.isNextNull()) {
            keyed.readNull();
            b = null;
          } else {
            b = keyed.readString();
          }
          break;
        case _$AllNullableModelSchema.keyItems:
          if (keyed.isNextNull()) {
            keyed.readNull();
            items = null;
          } else {
            items = keyed.decodeIntList();
          }
          break;
        case _$AllNullableModelSchema.keyRoles:
          if (keyed.isNextNull()) {
            keyed.readNull();
            roles = null;
          } else {
            roles = keyed
                .decodeList(
                  Decodable.fromFunction(
                    (d) => UserRole.values.byName(d.singleValue().readString()),
                  ),
                )
                .toSet();
          }
          break;
        case _$AllNullableModelSchema.keyLabels:
          if (keyed.isNextNull()) {
            keyed.readNull();
            labels = null;
          } else {
            {
              final k = keyed.nestedDecoder().keyed();
              final m = <String, int>{};
              while (k.moveNextKey()) {
                final key = k.nextKey();
                m[key] = k.readInt();
              }
              labels = m;
            }
          }
          break;
        case _$AllNullableModelSchema.keyCodes:
          if (keyed.isNextNull()) {
            keyed.readNull();
            codes = null;
          } else {
            {
              final mDecoder = keyed.nestedDecoder().map();
              final m = <int, String>{};
              while (mDecoder.moveNextEntry()) {
                final key = mDecoder.keyDecoder().singleValue().readInt();
                m[key] = mDecoder.valueDecoder().singleValue().readString();
              }
              codes = m;
            }
          }
          break;
        default:
          keyed.skipValue();
          break;
      }
    }

    // Inlined fast-path check
    seen.validate();

    return AllNullableModel(
      a: a,
      b: b,
      items: items,
      roles: roles,
      labels: labels,
      codes: codes,
    );
  }

  @override
  void encode(AllNullableModel instance, Encoder encoder) {
    var count$ = 0;
    final v$A = instance.a;
    if (v$A != null) count$++;
    final v$B = instance.b;
    if (v$B != null) count$++;
    final v$Items = instance.items;
    if (v$Items != null) count$++;
    final v$Roles = instance.roles;
    if (v$Roles != null) count$++;
    final v$Labels = instance.labels;
    if (v$Labels != null) count$++;
    final v$Codes = instance.codes;
    if (v$Codes != null) count$++;
    final keyed = encoder.keyed(length: count$);
    if (v$A != null) {
      keyed.encodeInt(_$AllNullableModelSchema.nameA, v$A);
    }
    if (v$B != null) {
      keyed.encodeString(_$AllNullableModelSchema.nameB, v$B);
    }
    if (v$Items != null) {
      keyed.encodeIntList(_$AllNullableModelSchema.nameItems, v$Items);
    }
    if (v$Roles != null) {
      keyed.encodeList(
        _$AllNullableModelSchema.nameRoles,
        v$Roles,
        Encodable.fromFunction((UserRole item, e) {
          e.singleValue().encodeString(item.name);
        }),
      );
    }
    if (v$Labels != null) {
      {
        final k = keyed
            .nestedEncoder(_$AllNullableModelSchema.nameLabels)
            .keyed(length: v$Labels.length);
        for (final entry in v$Labels.entries) {
          k.encodeInt(entry.key, entry.value);
        }
      }
    }
    if (v$Codes != null) {
      {
        final m = keyed
            .nestedEncoder(_$AllNullableModelSchema.nameCodes)
            .map(length: v$Codes.length);
        for (final entry in v$Codes.entries) {
          m.keyEncoder().singleValue().encodeInt(entry.key);
          m.valueEncoder().singleValue().encodeString(entry.value);
        }
      }
    }
  }
}

// =============================================================================
// 1. Unified Schema Descriptor for EmptyRecord
// =============================================================================
extension type const _$EmptyRecordSchema(int _value) {
  // String Name Constants

  // Key Indices for selectKeyIndex()

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const []);
  static final KeyOptions keyOptions = options;

  // Bitmask Flags strictly for Required Fields
  static const _$EmptyRecordSchema none = _$EmptyRecordSchema(0);

  @pragma('vm:prefer-inline')
  _$EmptyRecordSchema operator |(_$EmptyRecordSchema other) =>
      _$EmptyRecordSchema(_value | other._value);

  /// Validates required fields in 1 CPU test instruction on the fast path.
  @pragma('vm:prefer-inline')
  void validate() {}
}

// =============================================================================
// 2. Companion Codable for EmptyRecord
// =============================================================================
final class EmptyRecordCodable implements Codable<EmptyRecord> {
  const EmptyRecordCodable();

  @override
  EmptyRecord decode(Decoder decoder) {
    final keyed = decoder.keyed(options: _$EmptyRecordSchema.keyOptions);

    var seen = _$EmptyRecordSchema.none;

    while (keyed.moveNextKey()) {
      switch (keyed.selectKeyIndex(_$EmptyRecordSchema.keyOptions)) {
        default:
          keyed.skipValue();
          break;
      }
    }

    // Inlined fast-path check
    seen.validate();

    return const EmptyRecord();
  }

  @override
  void encode(EmptyRecord instance, Encoder encoder) {
    encoder.keyed(length: 0);
  }
}
