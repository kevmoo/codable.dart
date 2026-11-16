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
            if (location.length != 2) {
              throw CodableException(
                'Expected tuple of length 2 for "location", got ${location.length}',
                actualValue: location.length,
              );
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

  // Enum Options for UserRole
  static final KeyOptions enumUserRoleKeyOptions = KeyOptions.of(const [
    'admin',
    'member',
    'guest',
  ]);

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
            Decodable.fromFunction((d) {
              final raw = d.singleValue().readString();
              final idx = _$TeamSchema.enumUserRoleKeyOptions.indexOf(raw);
              if (idx < 0) {
                throw CodableException(
                  'Unknown UserRole value: "$raw"',
                  actualValue: raw,
                );
              }
              return UserRole.values[idx];
            }),
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
              final rawEnum1 = mDecoder.keyDecoder().singleValue().readString();
              final enumIdx1 = _$TypedKeyMapModelSchema.enumUserRoleKeyOptions
                  .indexOf(rawEnum1);
              if (enumIdx1 < 0) {
                throw CodableException(
                  'Unknown UserRole value: "$rawEnum1"',
                  actualValue: rawEnum1,
                );
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
              final rawEnum1 = k.readString();
              final enumIdx1 = _$StringKeyedNestedMapModelSchema
                  .enumUserRoleKeyOptions
                  .indexOf(rawEnum1);
              if (enumIdx1 < 0) {
                throw CodableException(
                  'Unknown UserRole value: "$rawEnum1"',
                  actualValue: rawEnum1,
                );
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

  // Enum Options for UserRole
  static final KeyOptions enumUserRoleKeyOptions = KeyOptions.of(const [
    'admin',
    'member',
    'guest',
  ]);

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
                  Decodable.fromFunction((d) {
                    final raw = d.singleValue().readString();
                    final idx = _$AllNullableModelSchema.enumUserRoleKeyOptions
                        .indexOf(raw);
                    if (idx < 0) {
                      throw CodableException(
                        'Unknown UserRole value: "$raw"',
                        actualValue: raw,
                      );
                    }
                    return UserRole.values[idx];
                  }),
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

// =============================================================================
// 1. Unified Schema Descriptor for NestedModelGrid
// =============================================================================
extension type const _$NestedModelGridSchema(int _value) {
  // String Name Constants
  static const String nameRows = 'rows';
  static const String nameNullableRows = 'nullableRows';
  static const String nameSparseRows = 'sparseRows';
  static const String nameCube = 'cube';

  // Key Indices for selectKeyIndex()
  static const int keyRows = 0;
  static const int keyNullableRows = 1;
  static const int keySparseRows = 2;
  static const int keyCube = 3;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
    _$NestedModelGridSchema.nameRows,
    _$NestedModelGridSchema.nameNullableRows,
    _$NestedModelGridSchema.nameSparseRows,
    _$NestedModelGridSchema.nameCube,
  ]);
  static final KeyOptions keyOptions = options;

  // Bitmask Flags strictly for Required Fields
  static const _$NestedModelGridSchema none = _$NestedModelGridSchema(0);

  @pragma('vm:prefer-inline')
  _$NestedModelGridSchema operator |(_$NestedModelGridSchema other) =>
      _$NestedModelGridSchema(_value | other._value);

  /// Validates required fields in 1 CPU test instruction on the fast path.
  @pragma('vm:prefer-inline')
  void validate() {}
}

// =============================================================================
// 2. Companion Codable for NestedModelGrid
// =============================================================================
final class NestedModelGridCodable implements Codable<NestedModelGrid> {
  const NestedModelGridCodable();

  @override
  NestedModelGrid decode(Decoder decoder) {
    final keyed = decoder.keyed(options: _$NestedModelGridSchema.keyOptions);

    var rows = const <List<Point>>[];
    var nullableRows = const <List<Point>?>[];
    var sparseRows = const <List<Point?>>[];
    var cube = const <List<List<Point>>>[];
    var seen = _$NestedModelGridSchema.none;

    while (keyed.moveNextKey()) {
      switch (keyed.selectKeyIndex(_$NestedModelGridSchema.keyOptions)) {
        case _$NestedModelGridSchema.keyRows:
          {
            final u = keyed.nestedDecoder().unkeyed();
            final l = <List<Point>>[];
            while (u.moveNext()) {
              l.add(u.decodeList(const PointCodable()));
            }
            rows = l;
          }
          break;
        case _$NestedModelGridSchema.keyNullableRows:
          {
            final u = keyed.nestedDecoder().unkeyed();
            final l = <List<Point>?>[];
            while (u.moveNext()) {
              l.add(u.decodeNullableList(const PointCodable()));
            }
            nullableRows = l;
          }
          break;
        case _$NestedModelGridSchema.keySparseRows:
          {
            final u = keyed.nestedDecoder().unkeyed();
            final l = <List<Point?>>[];
            while (u.moveNext()) {
              l.add(
                u.decodeList(
                  Decodable.fromFunction((d) {
                    final sv = d.singleValue();
                    if (sv.isNull()) {
                      sv.readNull();
                      return null;
                    }
                    return const PointCodable().decode(d);
                  }),
                ),
              );
            }
            sparseRows = l;
          }
          break;
        case _$NestedModelGridSchema.keyCube:
          {
            final u = keyed.nestedDecoder().unkeyed();
            final l = <List<List<Point>>>[];
            while (u.moveNext()) {
              l.add(u.decodeList((const PointCodable()).list));
            }
            cube = l;
          }
          break;
        default:
          keyed.skipValue();
          break;
      }
    }

    // Inlined fast-path check
    seen.validate();

    return NestedModelGrid(
      rows: rows,
      nullableRows: nullableRows,
      sparseRows: sparseRows,
      cube: cube,
    );
  }

  @override
  void encode(NestedModelGrid instance, Encoder encoder) {
    final keyed = encoder.keyed(length: 4);
    keyed.encodeList(
      _$NestedModelGridSchema.nameRows,
      instance.rows,
      Encodable.fromFunction((List<Point> item, e) {
        {
          final u = e.unkeyed(length: item.length);
          for (final elem in item) {
            const PointCodable().encode(elem, u.nestedEncoder());
          }
        }
      }),
    );
    keyed.encodeList(
      _$NestedModelGridSchema.nameNullableRows,
      instance.nullableRows,
      Encodable.fromFunction((List<Point>? item, e) {
        if (item case final val0?) {
          {
            final u1 = e.unkeyed(length: val0.length);
            for (final elem1 in val0) {
              const PointCodable().encode(elem1, u1.nestedEncoder());
            }
          }
        } else {
          e.singleValue().encodeNull();
        }
      }),
    );
    keyed.encodeList(
      _$NestedModelGridSchema.nameSparseRows,
      instance.sparseRows,
      Encodable.fromFunction((List<Point?> item, e) {
        {
          final u = e.unkeyed(length: item.length);
          for (final elem in item) {
            if (elem case final val1?) {
              const PointCodable().encode(val1, u.nestedEncoder());
            } else {
              u.nestedEncoder().singleValue().encodeNull();
            }
          }
        }
      }),
    );
    keyed.encodeList(
      _$NestedModelGridSchema.nameCube,
      instance.cube,
      Encodable.fromFunction((List<List<Point>> item, e) {
        {
          final u = e.unkeyed(length: item.length);
          for (final elem in item) {
            {
              final u1 = u.nestedEncoder().unkeyed(length: elem.length);
              for (final elem1 in elem) {
                const PointCodable().encode(elem1, u1.nestedEncoder());
              }
            }
          }
        }
      }),
    );
  }
}

// =============================================================================
// 1. Unified Schema Descriptor for NestedCollectionMatrix
// =============================================================================
extension type const _$NestedCollectionMatrixSchema(int _value) {
  // String Name Constants
  static const String nameTensor3d = 'tensor3d';
  static const String namePointSets = 'pointSets';
  static const String nameIntRowsSet = 'intRowsSet';
  static const String nameMapGrid = 'mapGrid';
  static const String nameRoleSets = 'roleSets';

  // Key Indices for selectKeyIndex()
  static const int keyTensor3d = 0;
  static const int keyPointSets = 1;
  static const int keyIntRowsSet = 2;
  static const int keyMapGrid = 3;
  static const int keyRoleSets = 4;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
    _$NestedCollectionMatrixSchema.nameTensor3d,
    _$NestedCollectionMatrixSchema.namePointSets,
    _$NestedCollectionMatrixSchema.nameIntRowsSet,
    _$NestedCollectionMatrixSchema.nameMapGrid,
    _$NestedCollectionMatrixSchema.nameRoleSets,
  ]);
  static final KeyOptions keyOptions = options;

  // Enum Options for UserRole
  static final KeyOptions enumUserRoleKeyOptions = KeyOptions.of(const [
    'admin',
    'member',
    'guest',
  ]);

  // Bitmask Flags strictly for Required Fields
  static const _$NestedCollectionMatrixSchema none =
      _$NestedCollectionMatrixSchema(0);

  @pragma('vm:prefer-inline')
  _$NestedCollectionMatrixSchema operator |(
    _$NestedCollectionMatrixSchema other,
  ) => _$NestedCollectionMatrixSchema(_value | other._value);

  /// Validates required fields in 1 CPU test instruction on the fast path.
  @pragma('vm:prefer-inline')
  void validate() {}
}

// =============================================================================
// 2. Companion Codable for NestedCollectionMatrix
// =============================================================================
final class NestedCollectionMatrixCodable
    implements Codable<NestedCollectionMatrix> {
  const NestedCollectionMatrixCodable();

  @override
  NestedCollectionMatrix decode(Decoder decoder) {
    final keyed = decoder.keyed(
      options: _$NestedCollectionMatrixSchema.keyOptions,
    );

    var tensor3d = const <List<Float64List>>[];
    var pointSets = const <Set<Point>>[];
    var intRowsSet = const <List<int>>{};
    var mapGrid = const <List<Map<String, int>>>[];
    var roleSets = const <Set<UserRole>>[];
    var seen = _$NestedCollectionMatrixSchema.none;

    while (keyed.moveNextKey()) {
      switch (keyed.selectKeyIndex(_$NestedCollectionMatrixSchema.keyOptions)) {
        case _$NestedCollectionMatrixSchema.keyTensor3d:
          {
            final u = keyed.nestedDecoder().unkeyed();
            final l = <List<Float64List>>[];
            while (u.moveNext()) {
              l.add(
                u.decodeList(
                  Decodable.fromFunction((d) {
                    Float64List res;
                    {
                      final u = d.unkeyed();
                      final l = <double>[];
                      while (u.moveNext()) {
                        l.add(u.readDouble());
                      }
                      res = Float64List.fromList(l);
                    }
                    return res;
                  }),
                ),
              );
            }
            tensor3d = l;
          }
          break;
        case _$NestedCollectionMatrixSchema.keyPointSets:
          {
            final u = keyed.nestedDecoder().unkeyed();
            final l = <Set<Point>>[];
            while (u.moveNext()) {
              final item = const PointCodable()
                  .decodeList(u.nestedDecoder())
                  .toSet();
              l.add(item);
            }
            pointSets = l;
          }
          break;
        case _$NestedCollectionMatrixSchema.keyIntRowsSet:
          {
            final u = keyed.nestedDecoder().unkeyed();
            final s = <List<int>>{};
            while (u.moveNext()) {
              List<int> item;
              {
                final u1 = u.nestedDecoder().unkeyed();
                final l1 = <int>[];
                while (u1.moveNext()) {
                  l1.add(u1.readInt());
                }
                item = l1;
              }
              s.add(item);
            }
            intRowsSet = s;
          }
          break;
        case _$NestedCollectionMatrixSchema.keyMapGrid:
          {
            final u = keyed.nestedDecoder().unkeyed();
            final l = <List<Map<String, int>>>[];
            while (u.moveNext()) {
              l.add(
                u.decodeList(
                  Decodable.fromFunction((d) {
                    Map<String, int> res;
                    {
                      final k = d.keyed();
                      final m = <String, int>{};
                      while (k.moveNextKey()) {
                        final key = k.nextKey();
                        m[key] = k.readInt();
                      }
                      res = m;
                    }
                    return res;
                  }),
                ),
              );
            }
            mapGrid = l;
          }
          break;
        case _$NestedCollectionMatrixSchema.keyRoleSets:
          {
            final u = keyed.nestedDecoder().unkeyed();
            final l = <Set<UserRole>>[];
            while (u.moveNext()) {
              Set<UserRole> item;
              {
                final u1 = u.nestedDecoder().unkeyed();
                final s1 = <UserRole>{};
                while (u1.moveNext()) {
                  final rawEnum2 = u1
                      .nestedDecoder()
                      .singleValue()
                      .readString();
                  final enumIdx2 = _$NestedCollectionMatrixSchema
                      .enumUserRoleKeyOptions
                      .indexOf(rawEnum2);
                  if (enumIdx2 < 0) {
                    throw CodableException(
                      'Unknown UserRole value: "$rawEnum2"',
                      actualValue: rawEnum2,
                    );
                  }
                  final item1 = UserRole.values[enumIdx2];
                  s1.add(item1);
                }
                item = s1;
              }
              l.add(item);
            }
            roleSets = l;
          }
          break;
        default:
          keyed.skipValue();
          break;
      }
    }

    // Inlined fast-path check
    seen.validate();

    return NestedCollectionMatrix(
      tensor3d: tensor3d,
      pointSets: pointSets,
      intRowsSet: intRowsSet,
      mapGrid: mapGrid,
      roleSets: roleSets,
    );
  }

  @override
  void encode(NestedCollectionMatrix instance, Encoder encoder) {
    final keyed = encoder.keyed(length: 5);
    keyed.encodeList(
      _$NestedCollectionMatrixSchema.nameTensor3d,
      instance.tensor3d,
      Encodable.fromFunction((List<Float64List> item, e) {
        {
          final u = e.unkeyed(length: item.length);
          for (final elem in item) {
            {
              final u1 = u.nestedEncoder().unkeyed(length: elem.length);
              for (final elem1 in elem) {
                u1.encodeDouble(elem1);
              }
            }
          }
        }
      }),
    );
    keyed.encodeList(
      _$NestedCollectionMatrixSchema.namePointSets,
      instance.pointSets,
      Encodable.fromFunction((Set<Point> item, e) {
        {
          final u = e.unkeyed(length: item.length);
          for (final elem in item) {
            const PointCodable().encode(elem, u.nestedEncoder());
          }
        }
      }),
    );
    keyed.encodeList(
      _$NestedCollectionMatrixSchema.nameIntRowsSet,
      instance.intRowsSet,
      Encodable.fromFunction((List<int> item, e) {
        {
          final u = e.unkeyed(length: item.length);
          for (final elem in item) {
            u.encodeInt(elem);
          }
        }
      }),
    );
    keyed.encodeList(
      _$NestedCollectionMatrixSchema.nameMapGrid,
      instance.mapGrid,
      Encodable.fromFunction((List<Map<String, int>> item, e) {
        {
          final u = e.unkeyed(length: item.length);
          for (final elem in item) {
            {
              final k1 = u.nestedEncoder().keyed(length: elem.length);
              for (final entry1 in elem.entries) {
                k1.encodeInt(entry1.key, entry1.value);
              }
            }
          }
        }
      }),
    );
    keyed.encodeList(
      _$NestedCollectionMatrixSchema.nameRoleSets,
      instance.roleSets,
      Encodable.fromFunction((Set<UserRole> item, e) {
        {
          final u = e.unkeyed(length: item.length);
          for (final elem in item) {
            u.nestedEncoder().singleValue().encodeString(elem.name);
          }
        }
      }),
    );
  }
}

// =============================================================================
// 1. Unified Schema Descriptor for DefaultValuesModel
// =============================================================================
extension type const _$DefaultValuesModelSchema(int _value) {
  // String Name Constants
  static const String nameLabel = 'label';
  static const String nameEscapedNote = 'escapedNote';
  static const String nameRetryCount = 'retryCount';
  static const String nameFactor = 'factor';
  static const String nameEnabled = 'enabled';
  static const String nameRole = 'role';
  static const String nameTags = 'tags';
  static const String nameMetadata = 'metadata';
  static const String nameOrigin = 'origin';
  static const String nameNullableOverride = 'nullableOverride';
  static const String nameOmittedDefaultKeepCtor = 'explicit_name';

  // Key Indices for selectKeyIndex()
  static const int keyLabel = 0;
  static const int keyEscapedNote = 1;
  static const int keyRetryCount = 2;
  static const int keyFactor = 3;
  static const int keyEnabled = 4;
  static const int keyRole = 5;
  static const int keyTags = 6;
  static const int keyMetadata = 7;
  static const int keyOrigin = 8;
  static const int keyNullableOverride = 9;
  static const int keyOmittedDefaultKeepCtor = 10;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
    _$DefaultValuesModelSchema.nameLabel,
    _$DefaultValuesModelSchema.nameEscapedNote,
    _$DefaultValuesModelSchema.nameRetryCount,
    _$DefaultValuesModelSchema.nameFactor,
    _$DefaultValuesModelSchema.nameEnabled,
    _$DefaultValuesModelSchema.nameRole,
    _$DefaultValuesModelSchema.nameTags,
    _$DefaultValuesModelSchema.nameMetadata,
    _$DefaultValuesModelSchema.nameOrigin,
    _$DefaultValuesModelSchema.nameNullableOverride,
    _$DefaultValuesModelSchema.nameOmittedDefaultKeepCtor,
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
  static const _$DefaultValuesModelSchema none = _$DefaultValuesModelSchema(0);

  @pragma('vm:prefer-inline')
  _$DefaultValuesModelSchema operator |(_$DefaultValuesModelSchema other) =>
      _$DefaultValuesModelSchema(_value | other._value);

  /// Validates required fields in 1 CPU test instruction on the fast path.
  @pragma('vm:prefer-inline')
  void validate() {}
}

// =============================================================================
// 2. Companion Codable for DefaultValuesModel
// =============================================================================
final class DefaultValuesModelCodable implements Codable<DefaultValuesModel> {
  const DefaultValuesModelCodable();

  @override
  DefaultValuesModel decode(Decoder decoder) {
    final keyed = decoder.keyed(options: _$DefaultValuesModelSchema.keyOptions);

    var label = 'guest';
    var escapedNote = 'it\'s \$5\n';
    var retryCount = 42;
    var factor = 2.5;
    var enabled = true;
    var role = UserRole.guest;
    var tags = const ['alpha', 'beta'];
    var metadata = const <String, int>{'env': 1};
    var origin = const Point(1.5, -2.5);
    String? nullableOverride;
    String? omittedDefaultKeepCtor = 'kept_ctor_default';
    var seen = _$DefaultValuesModelSchema.none;

    while (keyed.moveNextKey()) {
      switch (keyed.selectKeyIndex(_$DefaultValuesModelSchema.keyOptions)) {
        case _$DefaultValuesModelSchema.keyLabel:
          label = keyed.readString();
          break;
        case _$DefaultValuesModelSchema.keyEscapedNote:
          escapedNote = keyed.readString();
          break;
        case _$DefaultValuesModelSchema.keyRetryCount:
          retryCount = keyed.readInt();
          break;
        case _$DefaultValuesModelSchema.keyFactor:
          factor = keyed.readDouble();
          break;
        case _$DefaultValuesModelSchema.keyEnabled:
          enabled = keyed.readBool();
          break;
        case _$DefaultValuesModelSchema.keyRole:
          final enumIndex = keyed.selectStringIndex(
            _$DefaultValuesModelSchema.roleKeyOptions,
          );
          if (enumIndex >= 0 && enumIndex < UserRole.values.length) {
            role = UserRole.values[enumIndex];
          } else {
            throw const CodableException('Unknown UserRole value');
          }
          break;
        case _$DefaultValuesModelSchema.keyTags:
          tags = keyed.decodeStringList();
          break;
        case _$DefaultValuesModelSchema.keyMetadata:
          {
            final k = keyed.nestedDecoder().keyed();
            final m = <String, int>{};
            while (k.moveNextKey()) {
              final key = k.nextKey();
              m[key] = k.readInt();
            }
            metadata = m;
          }
          break;
        case _$DefaultValuesModelSchema.keyOrigin:
          origin = const PointCodable().decode(keyed.nestedDecoder());
          break;
        case _$DefaultValuesModelSchema.keyNullableOverride:
          if (keyed.isNextNull()) {
            keyed.readNull();
            nullableOverride = null;
          } else {
            nullableOverride = keyed.readString();
          }
          break;
        case _$DefaultValuesModelSchema.keyOmittedDefaultKeepCtor:
          if (keyed.isNextNull()) {
            keyed.readNull();
            omittedDefaultKeepCtor = null;
          } else {
            omittedDefaultKeepCtor = keyed.readString();
          }
          break;
        default:
          keyed.skipValue();
          break;
      }
    }

    // Inlined fast-path check
    seen.validate();

    return DefaultValuesModel(
      label: label,
      escapedNote: escapedNote,
      retryCount: retryCount,
      factor: factor,
      enabled: enabled,
      role: role,
      tags: tags,
      metadata: metadata,
      origin: origin,
      nullableOverride: nullableOverride,
      omittedDefaultKeepCtor: omittedDefaultKeepCtor,
    );
  }

  @override
  void encode(DefaultValuesModel instance, Encoder encoder) {
    var count$ = 9;
    final v$NullableOverride = instance.nullableOverride;
    if (v$NullableOverride != null) count$++;
    final v$OmittedDefaultKeepCtor = instance.omittedDefaultKeepCtor;
    if (v$OmittedDefaultKeepCtor != null) count$++;
    final keyed = encoder.keyed(length: count$);
    keyed.encodeString(_$DefaultValuesModelSchema.nameLabel, instance.label);
    keyed.encodeString(
      _$DefaultValuesModelSchema.nameEscapedNote,
      instance.escapedNote,
    );
    keyed.encodeInt(
      _$DefaultValuesModelSchema.nameRetryCount,
      instance.retryCount,
    );
    keyed.encodeDouble(_$DefaultValuesModelSchema.nameFactor, instance.factor);
    keyed.encodeBool(_$DefaultValuesModelSchema.nameEnabled, instance.enabled);
    keyed.encodeString(_$DefaultValuesModelSchema.nameRole, instance.role.name);
    keyed.encodeStringList(_$DefaultValuesModelSchema.nameTags, instance.tags);
    {
      final k = keyed
          .nestedEncoder(_$DefaultValuesModelSchema.nameMetadata)
          .keyed(length: instance.metadata.length);
      for (final entry in instance.metadata.entries) {
        k.encodeInt(entry.key, entry.value);
      }
    }
    keyed.encodeValue(
      _$DefaultValuesModelSchema.nameOrigin,
      instance.origin,
      const PointCodable(),
    );
    if (v$NullableOverride != null) {
      keyed.encodeString(
        _$DefaultValuesModelSchema.nameNullableOverride,
        v$NullableOverride,
      );
    }
    if (v$OmittedDefaultKeepCtor != null) {
      keyed.encodeString(
        _$DefaultValuesModelSchema.nameOmittedDefaultKeepCtor,
        v$OmittedDefaultKeepCtor,
      );
    }
  }
}

// =============================================================================
// 1. Unified Schema Descriptor for PortableTypedDataModel
// =============================================================================
extension type const _$PortableTypedDataModelSchema(int _value) {
  // String Name Constants
  static const String nameUint8 = 'uint8';
  static const String nameUint8Clamped = 'uint8Clamped';
  static const String nameUint16 = 'uint16';
  static const String nameUint32 = 'uint32';
  static const String nameInt8 = 'int8';
  static const String nameInt16 = 'int16';
  static const String nameInt32 = 'int32';
  static const String nameFloat32 = 'float32';
  static const String nameFloat64 = 'float64';
  static const String nameNullableInt16 = 'nullableInt16';
  static const String nameNullableFloat32 = 'nullableFloat32';
  static const String nameNestedInt16s = 'nestedInt16s';
  static const String nameSparseInt16s = 'sparseInt16s';
  static const String nameStringKeyedUint16s = 'stringKeyedUint16s';
  static const String nameIntKeyedInt8s = 'intKeyedInt8s';

  // Key Indices for selectKeyIndex()
  static const int keyUint8 = 0;
  static const int keyUint8Clamped = 1;
  static const int keyUint16 = 2;
  static const int keyUint32 = 3;
  static const int keyInt8 = 4;
  static const int keyInt16 = 5;
  static const int keyInt32 = 6;
  static const int keyFloat32 = 7;
  static const int keyFloat64 = 8;
  static const int keyNullableInt16 = 9;
  static const int keyNullableFloat32 = 10;
  static const int keyNestedInt16s = 11;
  static const int keySparseInt16s = 12;
  static const int keyStringKeyedUint16s = 13;
  static const int keyIntKeyedInt8s = 14;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
    _$PortableTypedDataModelSchema.nameUint8,
    _$PortableTypedDataModelSchema.nameUint8Clamped,
    _$PortableTypedDataModelSchema.nameUint16,
    _$PortableTypedDataModelSchema.nameUint32,
    _$PortableTypedDataModelSchema.nameInt8,
    _$PortableTypedDataModelSchema.nameInt16,
    _$PortableTypedDataModelSchema.nameInt32,
    _$PortableTypedDataModelSchema.nameFloat32,
    _$PortableTypedDataModelSchema.nameFloat64,
    _$PortableTypedDataModelSchema.nameNullableInt16,
    _$PortableTypedDataModelSchema.nameNullableFloat32,
    _$PortableTypedDataModelSchema.nameNestedInt16s,
    _$PortableTypedDataModelSchema.nameSparseInt16s,
    _$PortableTypedDataModelSchema.nameStringKeyedUint16s,
    _$PortableTypedDataModelSchema.nameIntKeyedInt8s,
  ]);
  static final KeyOptions keyOptions = options;

  // Bitmask Flags strictly for Required Fields
  static const _$PortableTypedDataModelSchema none =
      _$PortableTypedDataModelSchema(0);
  static const int _uint8Bit = 1 << 0;
  static const _$PortableTypedDataModelSchema uint8 =
      _$PortableTypedDataModelSchema(_uint8Bit);
  static const int _uint8ClampedBit = 1 << 1;
  static const _$PortableTypedDataModelSchema uint8Clamped =
      _$PortableTypedDataModelSchema(_uint8ClampedBit);
  static const int _uint16Bit = 1 << 2;
  static const _$PortableTypedDataModelSchema uint16 =
      _$PortableTypedDataModelSchema(_uint16Bit);
  static const int _uint32Bit = 1 << 3;
  static const _$PortableTypedDataModelSchema uint32 =
      _$PortableTypedDataModelSchema(_uint32Bit);
  static const int _int8Bit = 1 << 4;
  static const _$PortableTypedDataModelSchema int8 =
      _$PortableTypedDataModelSchema(_int8Bit);
  static const int _int16Bit = 1 << 5;
  static const _$PortableTypedDataModelSchema int16 =
      _$PortableTypedDataModelSchema(_int16Bit);
  static const int _int32Bit = 1 << 6;
  static const _$PortableTypedDataModelSchema int32 =
      _$PortableTypedDataModelSchema(_int32Bit);
  static const int _float32Bit = 1 << 7;
  static const _$PortableTypedDataModelSchema float32 =
      _$PortableTypedDataModelSchema(_float32Bit);
  static const int _float64Bit = 1 << 8;
  static const _$PortableTypedDataModelSchema float64 =
      _$PortableTypedDataModelSchema(_float64Bit);

  // Combined Golden Bitmask for fast single-instruction check
  static const _$PortableTypedDataModelSchema golden =
      _$PortableTypedDataModelSchema(
        _uint8Bit |
            _uint8ClampedBit |
            _uint16Bit |
            _uint32Bit |
            _int8Bit |
            _int16Bit |
            _int32Bit |
            _float32Bit |
            _float64Bit,
      );

  @pragma('vm:prefer-inline')
  _$PortableTypedDataModelSchema operator |(
    _$PortableTypedDataModelSchema other,
  ) => _$PortableTypedDataModelSchema(_value | other._value);

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
    if ((_value & _uint8Bit) == 0) {
      missing.add(nameUint8);
    }
    if ((_value & _uint8ClampedBit) == 0) {
      missing.add(nameUint8Clamped);
    }
    if ((_value & _uint16Bit) == 0) {
      missing.add(nameUint16);
    }
    if ((_value & _uint32Bit) == 0) {
      missing.add(nameUint32);
    }
    if ((_value & _int8Bit) == 0) {
      missing.add(nameInt8);
    }
    if ((_value & _int16Bit) == 0) {
      missing.add(nameInt16);
    }
    if ((_value & _int32Bit) == 0) {
      missing.add(nameInt32);
    }
    if ((_value & _float32Bit) == 0) {
      missing.add(nameFloat32);
    }
    if ((_value & _float64Bit) == 0) {
      missing.add(nameFloat64);
    }
    throw CodableException(
      'Missing required fields for PortableTypedDataModel: ${missing.join(", ")}',
    );
  }
}

// =============================================================================
// 2. Companion Codable for PortableTypedDataModel
// =============================================================================
final class PortableTypedDataModelCodable
    implements Codable<PortableTypedDataModel> {
  const PortableTypedDataModelCodable();

  @override
  PortableTypedDataModel decode(Decoder decoder) {
    final keyed = decoder.keyed(
      options: _$PortableTypedDataModelSchema.keyOptions,
    );

    Uint8List? uint8;
    Uint8ClampedList? uint8Clamped;
    Uint16List? uint16;
    Uint32List? uint32;
    Int8List? int8;
    Int16List? int16;
    Int32List? int32;
    Float32List? float32;
    Float64List? float64;
    Int16List? nullableInt16;
    Float32List? nullableFloat32;
    var nestedInt16s = const <Int16List>[];
    var sparseInt16s = const <Int16List?>[];
    var stringKeyedUint16s = const <String, Uint16List>{};
    var intKeyedInt8s = const <int, Int8List>{};
    var seen = _$PortableTypedDataModelSchema.none;

    while (keyed.moveNextKey()) {
      switch (keyed.selectKeyIndex(_$PortableTypedDataModelSchema.keyOptions)) {
        case _$PortableTypedDataModelSchema.keyUint8:
          if ((seen._value & _$PortableTypedDataModelSchema.uint8._value) !=
              0) {
            throw const CodableException('Duplicate field "uint8"');
          }
          uint8 = keyed.readBytes();
          seen |= _$PortableTypedDataModelSchema.uint8;
          break;
        case _$PortableTypedDataModelSchema.keyUint8Clamped:
          if ((seen._value &
                  _$PortableTypedDataModelSchema.uint8Clamped._value) !=
              0) {
            throw const CodableException('Duplicate field "uint8Clamped"');
          }
          uint8Clamped = Uint8ClampedList.fromList(keyed.decodeIntList());
          seen |= _$PortableTypedDataModelSchema.uint8Clamped;
          break;
        case _$PortableTypedDataModelSchema.keyUint16:
          if ((seen._value & _$PortableTypedDataModelSchema.uint16._value) !=
              0) {
            throw const CodableException('Duplicate field "uint16"');
          }
          uint16 = Uint16List.fromList(keyed.decodeIntList());
          seen |= _$PortableTypedDataModelSchema.uint16;
          break;
        case _$PortableTypedDataModelSchema.keyUint32:
          if ((seen._value & _$PortableTypedDataModelSchema.uint32._value) !=
              0) {
            throw const CodableException('Duplicate field "uint32"');
          }
          uint32 = Uint32List.fromList(keyed.decodeIntList());
          seen |= _$PortableTypedDataModelSchema.uint32;
          break;
        case _$PortableTypedDataModelSchema.keyInt8:
          if ((seen._value & _$PortableTypedDataModelSchema.int8._value) != 0) {
            throw const CodableException('Duplicate field "int8"');
          }
          int8 = Int8List.fromList(keyed.decodeIntList());
          seen |= _$PortableTypedDataModelSchema.int8;
          break;
        case _$PortableTypedDataModelSchema.keyInt16:
          if ((seen._value & _$PortableTypedDataModelSchema.int16._value) !=
              0) {
            throw const CodableException('Duplicate field "int16"');
          }
          int16 = Int16List.fromList(keyed.decodeIntList());
          seen |= _$PortableTypedDataModelSchema.int16;
          break;
        case _$PortableTypedDataModelSchema.keyInt32:
          if ((seen._value & _$PortableTypedDataModelSchema.int32._value) !=
              0) {
            throw const CodableException('Duplicate field "int32"');
          }
          int32 = Int32List.fromList(keyed.decodeIntList());
          seen |= _$PortableTypedDataModelSchema.int32;
          break;
        case _$PortableTypedDataModelSchema.keyFloat32:
          if ((seen._value & _$PortableTypedDataModelSchema.float32._value) !=
              0) {
            throw const CodableException('Duplicate field "float32"');
          }
          float32 = Float32List.fromList(keyed.decodeDoubleList());
          seen |= _$PortableTypedDataModelSchema.float32;
          break;
        case _$PortableTypedDataModelSchema.keyFloat64:
          if ((seen._value & _$PortableTypedDataModelSchema.float64._value) !=
              0) {
            throw const CodableException('Duplicate field "float64"');
          }
          float64 = keyed.decodeFloat64List();
          seen |= _$PortableTypedDataModelSchema.float64;
          break;
        case _$PortableTypedDataModelSchema.keyNullableInt16:
          if (keyed.isNextNull()) {
            keyed.readNull();
            nullableInt16 = null;
          } else {
            nullableInt16 = Int16List.fromList(keyed.decodeIntList());
          }
          break;
        case _$PortableTypedDataModelSchema.keyNullableFloat32:
          if (keyed.isNextNull()) {
            keyed.readNull();
            nullableFloat32 = null;
          } else {
            nullableFloat32 = Float32List.fromList(keyed.decodeDoubleList());
          }
          break;
        case _$PortableTypedDataModelSchema.keyNestedInt16s:
          {
            final u = keyed.nestedDecoder().unkeyed();
            final l = <Int16List>[];
            while (u.moveNext()) {
              l.add(Int16List.fromList(u.decodeIntList()));
            }
            nestedInt16s = l;
          }
          break;
        case _$PortableTypedDataModelSchema.keySparseInt16s:
          {
            final u = keyed.nestedDecoder().unkeyed();
            final l = <Int16List?>[];
            while (u.moveNext()) {
              Int16List? item;
              final dec1 = u.nestedDecoder();
              final sv1 = dec1.singleValue();
              if (sv1.isNull()) {
                sv1.readNull();
                item = null;
              } else {
                {
                  final u2 = dec1.unkeyed();
                  final l2 = <int>[];
                  while (u2.moveNext()) {
                    l2.add(u2.readInt());
                  }
                  item = Int16List.fromList(l2);
                }
              }
              l.add(item);
            }
            sparseInt16s = l;
          }
          break;
        case _$PortableTypedDataModelSchema.keyStringKeyedUint16s:
          {
            final k = keyed.nestedDecoder().keyed();
            final m = <String, Uint16List>{};
            while (k.moveNextKey()) {
              final key = k.nextKey();
              m[key] = Uint16List.fromList(k.decodeIntList());
            }
            stringKeyedUint16s = m;
          }
          break;
        case _$PortableTypedDataModelSchema.keyIntKeyedInt8s:
          {
            final mDecoder = keyed.nestedDecoder().map();
            final m = <int, Int8List>{};
            while (mDecoder.moveNextEntry()) {
              final key = mDecoder.keyDecoder().singleValue().readInt();
              {
                final u1 = mDecoder.valueDecoder().unkeyed();
                final l1 = <int>[];
                while (u1.moveNext()) {
                  l1.add(u1.readInt());
                }
                m[key] = Int8List.fromList(l1);
              }
            }
            intKeyedInt8s = m;
          }
          break;
        default:
          keyed.skipValue();
          break;
      }
    }

    // Inlined fast-path check
    seen.validate();

    return PortableTypedDataModel(
      uint8: uint8!,
      uint8Clamped: uint8Clamped!,
      uint16: uint16!,
      uint32: uint32!,
      int8: int8!,
      int16: int16!,
      int32: int32!,
      float32: float32!,
      float64: float64!,
      nullableInt16: nullableInt16,
      nullableFloat32: nullableFloat32,
      nestedInt16s: nestedInt16s,
      sparseInt16s: sparseInt16s,
      stringKeyedUint16s: stringKeyedUint16s,
      intKeyedInt8s: intKeyedInt8s,
    );
  }

  @override
  void encode(PortableTypedDataModel instance, Encoder encoder) {
    var count$ = 13;
    final v$NullableInt16 = instance.nullableInt16;
    if (v$NullableInt16 != null) count$++;
    final v$NullableFloat32 = instance.nullableFloat32;
    if (v$NullableFloat32 != null) count$++;
    final keyed = encoder.keyed(length: count$);
    keyed.encodeBytes(_$PortableTypedDataModelSchema.nameUint8, instance.uint8);
    keyed.encodeIntList(
      _$PortableTypedDataModelSchema.nameUint8Clamped,
      instance.uint8Clamped,
    );
    keyed.encodeIntList(
      _$PortableTypedDataModelSchema.nameUint16,
      instance.uint16,
    );
    keyed.encodeIntList(
      _$PortableTypedDataModelSchema.nameUint32,
      instance.uint32,
    );
    keyed.encodeIntList(_$PortableTypedDataModelSchema.nameInt8, instance.int8);
    keyed.encodeIntList(
      _$PortableTypedDataModelSchema.nameInt16,
      instance.int16,
    );
    keyed.encodeIntList(
      _$PortableTypedDataModelSchema.nameInt32,
      instance.int32,
    );
    keyed.encodeDoubleList(
      _$PortableTypedDataModelSchema.nameFloat32,
      instance.float32,
    );
    keyed.encodeDoubleList(
      _$PortableTypedDataModelSchema.nameFloat64,
      instance.float64,
    );
    if (v$NullableInt16 != null) {
      keyed.encodeIntList(
        _$PortableTypedDataModelSchema.nameNullableInt16,
        v$NullableInt16,
      );
    }
    if (v$NullableFloat32 != null) {
      keyed.encodeDoubleList(
        _$PortableTypedDataModelSchema.nameNullableFloat32,
        v$NullableFloat32,
      );
    }
    keyed.encodeList(
      _$PortableTypedDataModelSchema.nameNestedInt16s,
      instance.nestedInt16s,
      Encodable.fromFunction((Int16List item, e) {
        {
          final u = e.unkeyed(length: item.length);
          for (final elem in item) {
            u.encodeInt(elem);
          }
        }
      }),
    );
    keyed.encodeList(
      _$PortableTypedDataModelSchema.nameSparseInt16s,
      instance.sparseInt16s,
      Encodable.fromFunction((Int16List? item, e) {
        if (item case final val0?) {
          {
            final u1 = e.unkeyed(length: val0.length);
            for (final elem1 in val0) {
              u1.encodeInt(elem1);
            }
          }
        } else {
          e.singleValue().encodeNull();
        }
      }),
    );
    {
      final k = keyed
          .nestedEncoder(_$PortableTypedDataModelSchema.nameStringKeyedUint16s)
          .keyed(length: instance.stringKeyedUint16s.length);
      for (final entry in instance.stringKeyedUint16s.entries) {
        k.encodeIntList(entry.key, entry.value);
      }
    }
    {
      final m = keyed
          .nestedEncoder(_$PortableTypedDataModelSchema.nameIntKeyedInt8s)
          .map(length: instance.intKeyedInt8s.length);
      for (final entry in instance.intKeyedInt8s.entries) {
        m.keyEncoder().singleValue().encodeInt(entry.key);
        {
          final u1 = m.valueEncoder().unkeyed(length: entry.value.length);
          for (final elem1 in entry.value) {
            u1.encodeInt(elem1);
          }
        }
      }
    }
  }
}

// =============================================================================
// 1. Unified Schema Descriptor for Vm64BitTypedDataModel
// =============================================================================
extension type const _$Vm64BitTypedDataModelSchema(int _value) {
  // String Name Constants
  static const String nameInt64 = 'int64';
  static const String nameUint64 = 'uint64';
  static const String nameNullableInt64 = 'nullableInt64';
  static const String nameNullableUint64 = 'nullableUint64';
  static const String nameNestedUint64s = 'nestedUint64s';
  static const String nameNamedUint64s = 'namedUint64s';
  static const String nameTupleInt64 = 'tupleInt64';
  static const String nameTupleUint64 = 'tupleUint64';

  // Key Indices for selectKeyIndex()
  static const int keyInt64 = 0;
  static const int keyUint64 = 1;
  static const int keyNullableInt64 = 2;
  static const int keyNullableUint64 = 3;
  static const int keyNestedUint64s = 4;
  static const int keyNamedUint64s = 5;
  static const int keyTupleInt64 = 6;
  static const int keyTupleUint64 = 7;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
    _$Vm64BitTypedDataModelSchema.nameInt64,
    _$Vm64BitTypedDataModelSchema.nameUint64,
    _$Vm64BitTypedDataModelSchema.nameNullableInt64,
    _$Vm64BitTypedDataModelSchema.nameNullableUint64,
    _$Vm64BitTypedDataModelSchema.nameNestedUint64s,
    _$Vm64BitTypedDataModelSchema.nameNamedUint64s,
    _$Vm64BitTypedDataModelSchema.nameTupleInt64,
    _$Vm64BitTypedDataModelSchema.nameTupleUint64,
  ]);
  static final KeyOptions keyOptions = options;

  // Bitmask Flags strictly for Required Fields
  static const _$Vm64BitTypedDataModelSchema none =
      _$Vm64BitTypedDataModelSchema(0);
  static const int _int64Bit = 1 << 0;
  static const _$Vm64BitTypedDataModelSchema int64 =
      _$Vm64BitTypedDataModelSchema(_int64Bit);
  static const int _uint64Bit = 1 << 1;
  static const _$Vm64BitTypedDataModelSchema uint64 =
      _$Vm64BitTypedDataModelSchema(_uint64Bit);

  // Combined Golden Bitmask for fast single-instruction check
  static const _$Vm64BitTypedDataModelSchema golden =
      _$Vm64BitTypedDataModelSchema(_int64Bit | _uint64Bit);

  @pragma('vm:prefer-inline')
  _$Vm64BitTypedDataModelSchema operator |(
    _$Vm64BitTypedDataModelSchema other,
  ) => _$Vm64BitTypedDataModelSchema(_value | other._value);

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
    if ((_value & _int64Bit) == 0) {
      missing.add(nameInt64);
    }
    if ((_value & _uint64Bit) == 0) {
      missing.add(nameUint64);
    }
    throw CodableException(
      'Missing required fields for Vm64BitTypedDataModel: ${missing.join(", ")}',
    );
  }
}

// =============================================================================
// 2. Companion Codable for Vm64BitTypedDataModel
// =============================================================================
final class Vm64BitTypedDataModelCodable
    implements Codable<Vm64BitTypedDataModel> {
  const Vm64BitTypedDataModelCodable();

  @override
  Vm64BitTypedDataModel decode(Decoder decoder) {
    final keyed = decoder.keyed(
      options: _$Vm64BitTypedDataModelSchema.keyOptions,
    );

    Int64List? int64;
    Uint64List? uint64;
    Int64List? nullableInt64;
    Uint64List? nullableUint64;
    var nestedUint64s = const <Uint64List>[];
    var namedUint64s = const <String, Uint64List>{};
    Int64List? tupleInt64;
    Uint64List? tupleUint64;
    var seen = _$Vm64BitTypedDataModelSchema.none;

    while (keyed.moveNextKey()) {
      switch (keyed.selectKeyIndex(_$Vm64BitTypedDataModelSchema.keyOptions)) {
        case _$Vm64BitTypedDataModelSchema.keyInt64:
          if ((seen._value & _$Vm64BitTypedDataModelSchema.int64._value) != 0) {
            throw const CodableException('Duplicate field "int64"');
          }
          int64 = Int64List.fromList(keyed.decodeIntList());
          seen |= _$Vm64BitTypedDataModelSchema.int64;
          break;
        case _$Vm64BitTypedDataModelSchema.keyUint64:
          if ((seen._value & _$Vm64BitTypedDataModelSchema.uint64._value) !=
              0) {
            throw const CodableException('Duplicate field "uint64"');
          }
          uint64 = Uint64List.fromList(keyed.decodeIntList());
          seen |= _$Vm64BitTypedDataModelSchema.uint64;
          break;
        case _$Vm64BitTypedDataModelSchema.keyNullableInt64:
          if (keyed.isNextNull()) {
            keyed.readNull();
            nullableInt64 = null;
          } else {
            nullableInt64 = Int64List.fromList(keyed.decodeIntList());
          }
          break;
        case _$Vm64BitTypedDataModelSchema.keyNullableUint64:
          if (keyed.isNextNull()) {
            keyed.readNull();
            nullableUint64 = null;
          } else {
            nullableUint64 = Uint64List.fromList(keyed.decodeIntList());
          }
          break;
        case _$Vm64BitTypedDataModelSchema.keyNestedUint64s:
          {
            final u = keyed.nestedDecoder().unkeyed();
            final l = <Uint64List>[];
            while (u.moveNext()) {
              l.add(Uint64List.fromList(u.decodeIntList()));
            }
            nestedUint64s = l;
          }
          break;
        case _$Vm64BitTypedDataModelSchema.keyNamedUint64s:
          {
            final k = keyed.nestedDecoder().keyed();
            final m = <String, Uint64List>{};
            while (k.moveNextKey()) {
              final key = k.nextKey();
              m[key] = Uint64List.fromList(k.decodeIntList());
            }
            namedUint64s = m;
          }
          break;
        case _$Vm64BitTypedDataModelSchema.keyTupleInt64:
          if (keyed.isNextNull()) {
            keyed.readNull();
            tupleInt64 = null;
          } else {
            tupleInt64 = Int64List.fromList(keyed.decodeIntList());
            if (tupleInt64.length != 2) {
              throw CodableException(
                'Expected tuple of length 2 for "tupleInt64", got ${tupleInt64.length}',
                actualValue: tupleInt64.length,
              );
            }
          }
          break;
        case _$Vm64BitTypedDataModelSchema.keyTupleUint64:
          if (keyed.isNextNull()) {
            keyed.readNull();
            tupleUint64 = null;
          } else {
            tupleUint64 = Uint64List.fromList(keyed.decodeIntList());
            if (tupleUint64.length != 2) {
              throw CodableException(
                'Expected tuple of length 2 for "tupleUint64", got ${tupleUint64.length}',
                actualValue: tupleUint64.length,
              );
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

    return Vm64BitTypedDataModel(
      int64: int64!,
      uint64: uint64!,
      nullableInt64: nullableInt64,
      nullableUint64: nullableUint64,
      nestedUint64s: nestedUint64s,
      namedUint64s: namedUint64s,
      tupleInt64: tupleInt64,
      tupleUint64: tupleUint64,
    );
  }

  @override
  void encode(Vm64BitTypedDataModel instance, Encoder encoder) {
    var count$ = 4;
    final v$NullableInt64 = instance.nullableInt64;
    if (v$NullableInt64 != null) count$++;
    final v$NullableUint64 = instance.nullableUint64;
    if (v$NullableUint64 != null) count$++;
    final v$TupleInt64 = instance.tupleInt64;
    if (v$TupleInt64 != null) count$++;
    final v$TupleUint64 = instance.tupleUint64;
    if (v$TupleUint64 != null) count$++;
    final keyed = encoder.keyed(length: count$);
    keyed.encodeIntList(
      _$Vm64BitTypedDataModelSchema.nameInt64,
      instance.int64,
    );
    keyed.encodeIntList(
      _$Vm64BitTypedDataModelSchema.nameUint64,
      instance.uint64,
    );
    if (v$NullableInt64 != null) {
      keyed.encodeIntList(
        _$Vm64BitTypedDataModelSchema.nameNullableInt64,
        v$NullableInt64,
      );
    }
    if (v$NullableUint64 != null) {
      keyed.encodeIntList(
        _$Vm64BitTypedDataModelSchema.nameNullableUint64,
        v$NullableUint64,
      );
    }
    keyed.encodeList(
      _$Vm64BitTypedDataModelSchema.nameNestedUint64s,
      instance.nestedUint64s,
      Encodable.fromFunction((Uint64List item, e) {
        {
          final u = e.unkeyed(length: item.length);
          for (final elem in item) {
            u.encodeInt(elem);
          }
        }
      }),
    );
    {
      final k = keyed
          .nestedEncoder(_$Vm64BitTypedDataModelSchema.nameNamedUint64s)
          .keyed(length: instance.namedUint64s.length);
      for (final entry in instance.namedUint64s.entries) {
        k.encodeIntList(entry.key, entry.value);
      }
    }
    if (v$TupleInt64 != null) {
      keyed.encodeIntList(
        _$Vm64BitTypedDataModelSchema.nameTupleInt64,
        v$TupleInt64,
      );
    }
    if (v$TupleUint64 != null) {
      keyed.encodeIntList(
        _$Vm64BitTypedDataModelSchema.nameTupleUint64,
        v$TupleUint64,
      );
    }
  }
}

// =============================================================================
// 1. Unified Schema Descriptor for TupleVariantsModel
// =============================================================================
extension type const _$TupleVariantsModelSchema(int _value) {
  // String Name Constants
  static const String nameIntPair = 'intPair';
  static const String nameDoubleTriple = 'doubleTriple';
  static const String nameFloat64Pair = 'float64Pair';
  static const String nameFloat32Pair = 'float32Pair';
  static const String nameInt32Triple = 'int32Triple';
  static const String nameOptionalIntPair = 'optionalIntPair';
  static const String nameOptionalUint16Pair = 'optionalUint16Pair';

  // Key Indices for selectKeyIndex()
  static const int keyIntPair = 0;
  static const int keyDoubleTriple = 1;
  static const int keyFloat64Pair = 2;
  static const int keyFloat32Pair = 3;
  static const int keyInt32Triple = 4;
  static const int keyOptionalIntPair = 5;
  static const int keyOptionalUint16Pair = 6;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
    _$TupleVariantsModelSchema.nameIntPair,
    _$TupleVariantsModelSchema.nameDoubleTriple,
    _$TupleVariantsModelSchema.nameFloat64Pair,
    _$TupleVariantsModelSchema.nameFloat32Pair,
    _$TupleVariantsModelSchema.nameInt32Triple,
    _$TupleVariantsModelSchema.nameOptionalIntPair,
    _$TupleVariantsModelSchema.nameOptionalUint16Pair,
  ]);
  static final KeyOptions keyOptions = options;

  // Bitmask Flags strictly for Required Fields
  static const _$TupleVariantsModelSchema none = _$TupleVariantsModelSchema(0);
  static const int _intPairBit = 1 << 0;
  static const _$TupleVariantsModelSchema intPair = _$TupleVariantsModelSchema(
    _intPairBit,
  );
  static const int _doubleTripleBit = 1 << 1;
  static const _$TupleVariantsModelSchema doubleTriple =
      _$TupleVariantsModelSchema(_doubleTripleBit);
  static const int _float64PairBit = 1 << 2;
  static const _$TupleVariantsModelSchema float64Pair =
      _$TupleVariantsModelSchema(_float64PairBit);
  static const int _float32PairBit = 1 << 3;
  static const _$TupleVariantsModelSchema float32Pair =
      _$TupleVariantsModelSchema(_float32PairBit);
  static const int _int32TripleBit = 1 << 4;
  static const _$TupleVariantsModelSchema int32Triple =
      _$TupleVariantsModelSchema(_int32TripleBit);

  // Combined Golden Bitmask for fast single-instruction check
  static const _$TupleVariantsModelSchema golden = _$TupleVariantsModelSchema(
    _intPairBit |
        _doubleTripleBit |
        _float64PairBit |
        _float32PairBit |
        _int32TripleBit,
  );

  @pragma('vm:prefer-inline')
  _$TupleVariantsModelSchema operator |(_$TupleVariantsModelSchema other) =>
      _$TupleVariantsModelSchema(_value | other._value);

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
    if ((_value & _intPairBit) == 0) {
      missing.add(nameIntPair);
    }
    if ((_value & _doubleTripleBit) == 0) {
      missing.add(nameDoubleTriple);
    }
    if ((_value & _float64PairBit) == 0) {
      missing.add(nameFloat64Pair);
    }
    if ((_value & _float32PairBit) == 0) {
      missing.add(nameFloat32Pair);
    }
    if ((_value & _int32TripleBit) == 0) {
      missing.add(nameInt32Triple);
    }
    throw CodableException(
      'Missing required fields for TupleVariantsModel: ${missing.join(", ")}',
    );
  }
}

// =============================================================================
// 2. Companion Codable for TupleVariantsModel
// =============================================================================
final class TupleVariantsModelCodable implements Codable<TupleVariantsModel> {
  const TupleVariantsModelCodable();

  @override
  TupleVariantsModel decode(Decoder decoder) {
    final keyed = decoder.keyed(options: _$TupleVariantsModelSchema.keyOptions);

    List<int>? intPair;
    List<double>? doubleTriple;
    Float64List? float64Pair;
    Float32List? float32Pair;
    Int32List? int32Triple;
    List<int>? optionalIntPair;
    Uint16List? optionalUint16Pair;
    var seen = _$TupleVariantsModelSchema.none;

    while (keyed.moveNextKey()) {
      switch (keyed.selectKeyIndex(_$TupleVariantsModelSchema.keyOptions)) {
        case _$TupleVariantsModelSchema.keyIntPair:
          if ((seen._value & _$TupleVariantsModelSchema.intPair._value) != 0) {
            throw const CodableException('Duplicate field "intPair"');
          }
          intPair = keyed.decodeIntList();
          if (intPair.length != 2) {
            throw CodableException(
              'Expected tuple of length 2 for "intPair", got ${intPair.length}',
              actualValue: intPair.length,
            );
          }
          seen |= _$TupleVariantsModelSchema.intPair;
          break;
        case _$TupleVariantsModelSchema.keyDoubleTriple:
          if ((seen._value & _$TupleVariantsModelSchema.doubleTriple._value) !=
              0) {
            throw const CodableException('Duplicate field "doubleTriple"');
          }
          doubleTriple = keyed.decodeDoubleList();
          if (doubleTriple.length != 3) {
            throw CodableException(
              'Expected tuple of length 3 for "doubleTriple", got ${doubleTriple.length}',
              actualValue: doubleTriple.length,
            );
          }
          seen |= _$TupleVariantsModelSchema.doubleTriple;
          break;
        case _$TupleVariantsModelSchema.keyFloat64Pair:
          if ((seen._value & _$TupleVariantsModelSchema.float64Pair._value) !=
              0) {
            throw const CodableException('Duplicate field "float64Pair"');
          }
          float64Pair = keyed.decodeFloat64List();
          if (float64Pair.length != 2) {
            throw CodableException(
              'Expected tuple of length 2 for "float64Pair", got ${float64Pair.length}',
              actualValue: float64Pair.length,
            );
          }
          seen |= _$TupleVariantsModelSchema.float64Pair;
          break;
        case _$TupleVariantsModelSchema.keyFloat32Pair:
          if ((seen._value & _$TupleVariantsModelSchema.float32Pair._value) !=
              0) {
            throw const CodableException('Duplicate field "float32Pair"');
          }
          float32Pair = Float32List.fromList(keyed.decodeDoubleList());
          if (float32Pair.length != 2) {
            throw CodableException(
              'Expected tuple of length 2 for "float32Pair", got ${float32Pair.length}',
              actualValue: float32Pair.length,
            );
          }
          seen |= _$TupleVariantsModelSchema.float32Pair;
          break;
        case _$TupleVariantsModelSchema.keyInt32Triple:
          if ((seen._value & _$TupleVariantsModelSchema.int32Triple._value) !=
              0) {
            throw const CodableException('Duplicate field "int32Triple"');
          }
          int32Triple = Int32List.fromList(keyed.decodeIntList());
          if (int32Triple.length != 3) {
            throw CodableException(
              'Expected tuple of length 3 for "int32Triple", got ${int32Triple.length}',
              actualValue: int32Triple.length,
            );
          }
          seen |= _$TupleVariantsModelSchema.int32Triple;
          break;
        case _$TupleVariantsModelSchema.keyOptionalIntPair:
          if (keyed.isNextNull()) {
            keyed.readNull();
            optionalIntPair = null;
          } else {
            optionalIntPair = keyed.decodeIntList();
            if (optionalIntPair.length != 2) {
              throw CodableException(
                'Expected tuple of length 2 for "optionalIntPair", got ${optionalIntPair.length}',
                actualValue: optionalIntPair.length,
              );
            }
          }
          break;
        case _$TupleVariantsModelSchema.keyOptionalUint16Pair:
          if (keyed.isNextNull()) {
            keyed.readNull();
            optionalUint16Pair = null;
          } else {
            optionalUint16Pair = Uint16List.fromList(keyed.decodeIntList());
            if (optionalUint16Pair.length != 2) {
              throw CodableException(
                'Expected tuple of length 2 for "optionalUint16Pair", got ${optionalUint16Pair.length}',
                actualValue: optionalUint16Pair.length,
              );
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

    return TupleVariantsModel(
      intPair: intPair!,
      doubleTriple: doubleTriple!,
      float64Pair: float64Pair!,
      float32Pair: float32Pair!,
      int32Triple: int32Triple!,
      optionalIntPair: optionalIntPair,
      optionalUint16Pair: optionalUint16Pair,
    );
  }

  @override
  void encode(TupleVariantsModel instance, Encoder encoder) {
    var count$ = 5;
    final v$OptionalIntPair = instance.optionalIntPair;
    if (v$OptionalIntPair != null) count$++;
    final v$OptionalUint16Pair = instance.optionalUint16Pair;
    if (v$OptionalUint16Pair != null) count$++;
    final keyed = encoder.keyed(length: count$);
    keyed.encodeIntList(
      _$TupleVariantsModelSchema.nameIntPair,
      instance.intPair,
    );
    keyed.encodeDoubleList(
      _$TupleVariantsModelSchema.nameDoubleTriple,
      instance.doubleTriple,
    );
    keyed.encodeDoubleList(
      _$TupleVariantsModelSchema.nameFloat64Pair,
      instance.float64Pair,
    );
    keyed.encodeDoubleList(
      _$TupleVariantsModelSchema.nameFloat32Pair,
      instance.float32Pair,
    );
    keyed.encodeIntList(
      _$TupleVariantsModelSchema.nameInt32Triple,
      instance.int32Triple,
    );
    if (v$OptionalIntPair != null) {
      keyed.encodeIntList(
        _$TupleVariantsModelSchema.nameOptionalIntPair,
        v$OptionalIntPair,
      );
    }
    if (v$OptionalUint16Pair != null) {
      keyed.encodeIntList(
        _$TupleVariantsModelSchema.nameOptionalUint16Pair,
        v$OptionalUint16Pair,
      );
    }
  }
}

// =============================================================================
// 1. Unified Schema Descriptor for EnumCollectionsAndAliasesModel
// =============================================================================
extension type const _$EnumCollectionsAndAliasesModelSchema(int _value) {
  // String Name Constants
  static const String nameRoles = 'roles';
  static const String nameNullableRoles = 'nullableRoles';
  static const String nameRoleSet = 'roleSet';
  static const String nameRolesByKey = 'rolesByKey';
  static const String nameRolesById = 'rolesById';
  static const String nameCountsByRole = 'countsByRole';
  static const String nameSlug = 'slug';
  static const String aliasSlugFooBar = 'foo-bar';
  static const String aliasSlugFooBar$2 = 'foo_bar';

  // Key Indices for selectKeyIndex()
  static const int keyRoles = 0;
  static const int keyNullableRoles = 1;
  static const int keyRoleSet = 2;
  static const int keyRolesByKey = 3;
  static const int keyRolesById = 4;
  static const int keyCountsByRole = 5;
  static const int keySlug = 6;
  static const int aliasKeySlugFooBar = 7;
  static const int aliasKeySlugFooBar$2 = 8;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
    _$EnumCollectionsAndAliasesModelSchema.nameRoles,
    _$EnumCollectionsAndAliasesModelSchema.nameNullableRoles,
    _$EnumCollectionsAndAliasesModelSchema.nameRoleSet,
    _$EnumCollectionsAndAliasesModelSchema.nameRolesByKey,
    _$EnumCollectionsAndAliasesModelSchema.nameRolesById,
    _$EnumCollectionsAndAliasesModelSchema.nameCountsByRole,
    _$EnumCollectionsAndAliasesModelSchema.nameSlug,
    _$EnumCollectionsAndAliasesModelSchema.aliasSlugFooBar,
    _$EnumCollectionsAndAliasesModelSchema.aliasSlugFooBar$2,
  ]);
  static final KeyOptions keyOptions = options;

  // Enum Options for UserRole
  static final KeyOptions enumUserRoleKeyOptions = KeyOptions.of(const [
    'admin',
    'member',
    'guest',
  ]);

  // Bitmask Flags strictly for Required Fields
  static const _$EnumCollectionsAndAliasesModelSchema none =
      _$EnumCollectionsAndAliasesModelSchema(0);

  @pragma('vm:prefer-inline')
  _$EnumCollectionsAndAliasesModelSchema operator |(
    _$EnumCollectionsAndAliasesModelSchema other,
  ) => _$EnumCollectionsAndAliasesModelSchema(_value | other._value);

  /// Validates required fields in 1 CPU test instruction on the fast path.
  @pragma('vm:prefer-inline')
  void validate() {}
}

// =============================================================================
// 2. Companion Codable for EnumCollectionsAndAliasesModel
// =============================================================================
final class EnumCollectionsAndAliasesModelCodable
    implements Codable<EnumCollectionsAndAliasesModel> {
  const EnumCollectionsAndAliasesModelCodable();

  @override
  EnumCollectionsAndAliasesModel decode(Decoder decoder) {
    final keyed = decoder.keyed(
      options: _$EnumCollectionsAndAliasesModelSchema.keyOptions,
    );

    var roles = const <UserRole>[];
    var nullableRoles = const <UserRole?>[];
    var roleSet = const <UserRole>{};
    var rolesByKey = const <String, UserRole>{};
    var rolesById = const <int, UserRole>{};
    var countsByRole = const <UserRole, int>{};
    var slug = '';
    var seen = _$EnumCollectionsAndAliasesModelSchema.none;

    while (keyed.moveNextKey()) {
      switch (keyed.selectKeyIndex(
        _$EnumCollectionsAndAliasesModelSchema.keyOptions,
      )) {
        case _$EnumCollectionsAndAliasesModelSchema.keyRoles:
          roles = keyed.decodeList(
            Decodable.fromFunction((d) {
              final raw = d.singleValue().readString();
              final idx = _$EnumCollectionsAndAliasesModelSchema
                  .enumUserRoleKeyOptions
                  .indexOf(raw);
              if (idx < 0) {
                throw CodableException(
                  'Unknown UserRole value: "$raw"',
                  actualValue: raw,
                );
              }
              return UserRole.values[idx];
            }),
          );
          break;
        case _$EnumCollectionsAndAliasesModelSchema.keyNullableRoles:
          nullableRoles = keyed.decodeList(
            Decodable.fromFunction((d) {
              final raw = d.singleValue().readNullableString();
              if (raw == null) return null;
              final idx = _$EnumCollectionsAndAliasesModelSchema
                  .enumUserRoleKeyOptions
                  .indexOf(raw);
              if (idx < 0) {
                throw CodableException(
                  'Unknown UserRole value: "$raw"',
                  actualValue: raw,
                );
              }
              return UserRole.values[idx];
            }),
          );
          break;
        case _$EnumCollectionsAndAliasesModelSchema.keyRoleSet:
          roleSet = keyed
              .decodeList(
                Decodable.fromFunction((d) {
                  final raw = d.singleValue().readString();
                  final idx = _$EnumCollectionsAndAliasesModelSchema
                      .enumUserRoleKeyOptions
                      .indexOf(raw);
                  if (idx < 0) {
                    throw CodableException(
                      'Unknown UserRole value: "$raw"',
                      actualValue: raw,
                    );
                  }
                  return UserRole.values[idx];
                }),
              )
              .toSet();
          break;
        case _$EnumCollectionsAndAliasesModelSchema.keyRolesByKey:
          {
            final k = keyed.nestedDecoder().keyed();
            final m = <String, UserRole>{};
            while (k.moveNextKey()) {
              final key = k.nextKey();
              final rawEnum1 = k.readString();
              final enumIdx1 = _$EnumCollectionsAndAliasesModelSchema
                  .enumUserRoleKeyOptions
                  .indexOf(rawEnum1);
              if (enumIdx1 < 0) {
                throw CodableException(
                  'Unknown UserRole value: "$rawEnum1"',
                  actualValue: rawEnum1,
                );
              }
              m[key] = UserRole.values[enumIdx1];
            }
            rolesByKey = m;
          }
          break;
        case _$EnumCollectionsAndAliasesModelSchema.keyRolesById:
          {
            final mDecoder = keyed.nestedDecoder().map();
            final m = <int, UserRole>{};
            while (mDecoder.moveNextEntry()) {
              final key = mDecoder.keyDecoder().singleValue().readInt();
              final rawEnum1 = mDecoder
                  .valueDecoder()
                  .singleValue()
                  .readString();
              final enumIdx1 = _$EnumCollectionsAndAliasesModelSchema
                  .enumUserRoleKeyOptions
                  .indexOf(rawEnum1);
              if (enumIdx1 < 0) {
                throw CodableException(
                  'Unknown UserRole value: "$rawEnum1"',
                  actualValue: rawEnum1,
                );
              }
              m[key] = UserRole.values[enumIdx1];
            }
            rolesById = m;
          }
          break;
        case _$EnumCollectionsAndAliasesModelSchema.keyCountsByRole:
          {
            final mDecoder = keyed.nestedDecoder().map();
            final m = <UserRole, int>{};
            while (mDecoder.moveNextEntry()) {
              final rawEnum1 = mDecoder.keyDecoder().singleValue().readString();
              final enumIdx1 = _$EnumCollectionsAndAliasesModelSchema
                  .enumUserRoleKeyOptions
                  .indexOf(rawEnum1);
              if (enumIdx1 < 0) {
                throw CodableException(
                  'Unknown UserRole value: "$rawEnum1"',
                  actualValue: rawEnum1,
                );
              }
              final key = UserRole.values[enumIdx1];
              m[key] = mDecoder.valueDecoder().singleValue().readInt();
            }
            countsByRole = m;
          }
          break;
        case _$EnumCollectionsAndAliasesModelSchema.keySlug:
        case _$EnumCollectionsAndAliasesModelSchema.aliasKeySlugFooBar:
        case _$EnumCollectionsAndAliasesModelSchema.aliasKeySlugFooBar$2:
          slug = keyed.readString();
          break;
        default:
          keyed.skipValue();
          break;
      }
    }

    // Inlined fast-path check
    seen.validate();

    return EnumCollectionsAndAliasesModel(
      roles: roles,
      nullableRoles: nullableRoles,
      roleSet: roleSet,
      rolesByKey: rolesByKey,
      rolesById: rolesById,
      countsByRole: countsByRole,
      slug: slug,
    );
  }

  @override
  void encode(EnumCollectionsAndAliasesModel instance, Encoder encoder) {
    final keyed = encoder.keyed(length: 7);
    keyed.encodeList(
      _$EnumCollectionsAndAliasesModelSchema.nameRoles,
      instance.roles,
      Encodable.fromFunction((UserRole item, e) {
        e.singleValue().encodeString(item.name);
      }),
    );
    keyed.encodeList(
      _$EnumCollectionsAndAliasesModelSchema.nameNullableRoles,
      instance.nullableRoles,
      Encodable.fromFunction((UserRole? item, e) {
        e.singleValue().encodeNullableString(item?.name);
      }),
    );
    keyed.encodeList(
      _$EnumCollectionsAndAliasesModelSchema.nameRoleSet,
      instance.roleSet,
      Encodable.fromFunction((UserRole item, e) {
        e.singleValue().encodeString(item.name);
      }),
    );
    {
      final k = keyed
          .nestedEncoder(_$EnumCollectionsAndAliasesModelSchema.nameRolesByKey)
          .keyed(length: instance.rolesByKey.length);
      for (final entry in instance.rolesByKey.entries) {
        k.encodeString(entry.key, entry.value.name);
      }
    }
    {
      final m = keyed
          .nestedEncoder(_$EnumCollectionsAndAliasesModelSchema.nameRolesById)
          .map(length: instance.rolesById.length);
      for (final entry in instance.rolesById.entries) {
        m.keyEncoder().singleValue().encodeInt(entry.key);
        m.valueEncoder().singleValue().encodeString(entry.value.name);
      }
    }
    {
      final m = keyed
          .nestedEncoder(
            _$EnumCollectionsAndAliasesModelSchema.nameCountsByRole,
          )
          .map(length: instance.countsByRole.length);
      for (final entry in instance.countsByRole.entries) {
        m.keyEncoder().singleValue().encodeString(entry.key.name);
        m.valueEncoder().singleValue().encodeInt(entry.value);
      }
    }
    keyed.encodeString(
      _$EnumCollectionsAndAliasesModelSchema.nameSlug,
      instance.slug,
    );
  }
}
