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
  static const String aliasLatitudeLat = 'lat';
  static const String nameLongitude = 'longitude';
  static const String aliasLongitudeLon = 'lon';

  // Key Indices for selectKeyIndex()
  static const int keyLatitude = 0;
  static const int aliasKeyLatitudeLat = 1;
  static const int keyLongitude = 2;
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
// 2. Companion Codable for Coordinate
// =============================================================================
final class CoordinateCodable implements Codable<Coordinate> {
  const CoordinateCodable();

  @override
  Coordinate decode(Decoder decoder) {
    final keyed = decoder.keyed(options: _$CoordinateSchema.keyOptions);

    double? latitude;
    double? longitude;
    var seen = _$CoordinateSchema.none;

    while (keyed.moveNextKey()) {
      switch (keyed.selectKeyIndex(_$CoordinateSchema.keyOptions)) {
        case _$CoordinateSchema.keyLatitude:
        case _$CoordinateSchema.aliasKeyLatitudeLat:
          if ((seen._value & _$CoordinateSchema.latitude._value) != 0) {
            throw const CodableException('Duplicate field "latitude"');
          }
          latitude = keyed.readDouble();
          seen |= _$CoordinateSchema.latitude;
          break;
        case _$CoordinateSchema.keyLongitude:
        case _$CoordinateSchema.aliasKeyLongitudeLon:
          if ((seen._value & _$CoordinateSchema.longitude._value) != 0) {
            throw const CodableException('Duplicate field "longitude"');
          }
          longitude = keyed.readDouble();
          seen |= _$CoordinateSchema.longitude;
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

  List<Coordinate> decodeList(Decoder decoder) {
    final flatDoubles = decoder.decodeUniformDoubleList(const [
      ['latitude', 'lat'],
      ['longitude', 'lon'],
    ]);
    if (flatDoubles != null) {
      final count = flatDoubles.length ~/ 2;
      return List<Coordinate>.generate(
        count,
        (i) => Coordinate(
          latitude: flatDoubles[i * 2 + 0],
          longitude: flatDoubles[i * 2 + 1],
        ),
        growable: true,
      );
    }

    final unkeyed = decoder.unkeyed();
    final list = <Coordinate>[];
    while (unkeyed.moveNext()) {
      list.add(decode(unkeyed.nestedDecoder()));
    }
    return list;
  }

  @override
  void encode(Coordinate instance, Encoder encoder) {
    final keyed = encoder.keyed(length: 2);
    keyed.encodeDouble(_$CoordinateSchema.nameLatitude, instance.latitude);
    keyed.encodeDouble(_$CoordinateSchema.nameLongitude, instance.longitude);
  }
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
// 2. Companion Codable for UserProfile
// =============================================================================
final class UserProfileCodable implements Codable<UserProfile> {
  const UserProfileCodable();

  @override
  UserProfile decode(Decoder decoder) {
    final keyed = decoder.keyed(options: _$UserProfileSchema.keyOptions);

    String? id;
    String? email;
    UserRole? role;
    String? zip;
    var tags = const <String>[];
    var seen = _$UserProfileSchema.none;

    while (keyed.moveNextKey()) {
      switch (keyed.selectKeyIndex(_$UserProfileSchema.keyOptions)) {
        case _$UserProfileSchema.keyId:
          if ((seen._value & _$UserProfileSchema.id._value) != 0) {
            throw const CodableException('Duplicate field "id"');
          }
          id = keyed.readString();
          seen |= _$UserProfileSchema.id;
          break;
        case _$UserProfileSchema.keyEmail:
          if ((seen._value & _$UserProfileSchema.email._value) != 0) {
            throw const CodableException('Duplicate field "email"');
          }
          email = keyed.readString();
          seen |= _$UserProfileSchema.email;
          break;
        case _$UserProfileSchema.keyRole:
          if ((seen._value & _$UserProfileSchema.role._value) != 0) {
            throw const CodableException('Duplicate field "role"');
          }
          final enumIndex = keyed.selectStringIndex(
            _$UserProfileSchema.roleKeyOptions,
          );
          if (enumIndex >= 0 && enumIndex < UserRole.values.length) {
            role = UserRole.values[enumIndex];
          } else {
            throw const CodableException('Unknown UserRole value');
          }
          seen |= _$UserProfileSchema.role;
          break;
        case _$UserProfileSchema.keyZip:
          if ((seen._value & _$UserProfileSchema.zip._value) != 0) {
            throw const CodableException('Duplicate field "zip"');
          }
          zip = keyed.decodeValue(const ZipCodeDecoder());
          seen |= _$UserProfileSchema.zip;
          break;
        case _$UserProfileSchema.keyTags:
          tags = keyed.decodeStringList();
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

  @override
  void encode(UserProfile instance, Encoder encoder) {
    final keyed = encoder.keyed(length: 5);
    keyed.encodeString(_$UserProfileSchema.nameId, instance.id);
    keyed.encodeString(_$UserProfileSchema.nameEmail, instance.email);
    keyed.encodeString(_$UserProfileSchema.nameRole, instance.role.name);
    keyed.encodeValue(
      _$UserProfileSchema.nameZip,
      instance.zip,
      const ZipCodeDecoder(),
    );
    keyed.encodeStringList(_$UserProfileSchema.nameTags, instance.tags);
  }
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
// 2. Companion Codable for Car
// =============================================================================
final class CarCodable implements Codable<Car> {
  const CarCodable();

  @override
  Car decode(Decoder decoder) {
    final keyed = decoder.keyed(options: _$CarSchema.keyOptions);

    int? maxSpeed;
    int? doors;
    var seen = _$CarSchema.none;

    while (keyed.moveNextKey()) {
      switch (keyed.selectKeyIndex(_$CarSchema.keyOptions)) {
        case _$CarSchema.keyMaxSpeed:
          if ((seen._value & _$CarSchema.maxSpeed._value) != 0) {
            throw const CodableException('Duplicate field "maxSpeed"');
          }
          maxSpeed = keyed.readInt();
          seen |= _$CarSchema.maxSpeed;
          break;
        case _$CarSchema.keyDoors:
          if ((seen._value & _$CarSchema.doors._value) != 0) {
            throw const CodableException('Duplicate field "doors"');
          }
          doors = keyed.readInt();
          seen |= _$CarSchema.doors;
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

  @override
  void encode(Car instance, Encoder encoder) {
    final keyed = encoder.keyed(length: 2);
    keyed.encodeInt(_$CarSchema.nameMaxSpeed, instance.maxSpeed);
    keyed.encodeInt(_$CarSchema.nameDoors, instance.doors);
  }
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
// 2. Companion Codable for Bicycle
// =============================================================================
final class BicycleCodable implements Codable<Bicycle> {
  const BicycleCodable();

  @override
  Bicycle decode(Decoder decoder) {
    final keyed = decoder.keyed(options: _$BicycleSchema.keyOptions);

    int? maxSpeed;
    bool? hasBell;
    var seen = _$BicycleSchema.none;

    while (keyed.moveNextKey()) {
      switch (keyed.selectKeyIndex(_$BicycleSchema.keyOptions)) {
        case _$BicycleSchema.keyMaxSpeed:
          if ((seen._value & _$BicycleSchema.maxSpeed._value) != 0) {
            throw const CodableException('Duplicate field "maxSpeed"');
          }
          maxSpeed = keyed.readInt();
          seen |= _$BicycleSchema.maxSpeed;
          break;
        case _$BicycleSchema.keyHasBell:
          if ((seen._value & _$BicycleSchema.hasBell._value) != 0) {
            throw const CodableException('Duplicate field "hasBell"');
          }
          hasBell = keyed.readBool();
          seen |= _$BicycleSchema.hasBell;
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

  @override
  void encode(Bicycle instance, Encoder encoder) {
    final keyed = encoder.keyed(length: 2);
    keyed.encodeInt(_$BicycleSchema.nameMaxSpeed, instance.maxSpeed);
    keyed.encodeBool(_$BicycleSchema.nameHasBell, instance.hasBell);
  }
}

// =============================================================================
// 1. Unified Schema Descriptor for TelemetryPacket
// =============================================================================
extension type const _$TelemetryPacketSchema(int _value) {
  // String Name Constants
  static const String namePacketId = 'packetId';
  static const String nameRegionZip = 'regionZip';
  static const String nameStatusCode = 'statusCode';
  static const String nameReading = 'reading';
  static const String nameDelta = 'delta';
  static const String nameHistory = 'history';
  static const String nameCounters = 'counters';
  static const String nameVehicle = 'vehicle';
  static const String nameNotes = 'notes';

  // Key Indices for selectKeyIndex()
  static const int keyPacketId = 0;
  static const int keyRegionZip = 1;
  static const int keyStatusCode = 2;
  static const int keyReading = 3;
  static const int keyDelta = 4;
  static const int keyHistory = 5;
  static const int keyCounters = 6;
  static const int keyVehicle = 7;
  static const int keyNotes = 8;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
    _$TelemetryPacketSchema.namePacketId,
    _$TelemetryPacketSchema.nameRegionZip,
    _$TelemetryPacketSchema.nameStatusCode,
    _$TelemetryPacketSchema.nameReading,
    _$TelemetryPacketSchema.nameDelta,
    _$TelemetryPacketSchema.nameHistory,
    _$TelemetryPacketSchema.nameCounters,
    _$TelemetryPacketSchema.nameVehicle,
    _$TelemetryPacketSchema.nameNotes,
  ]);
  static final KeyOptions keyOptions = options;

  // Bitmask Flags strictly for Required Fields
  static const _$TelemetryPacketSchema none = _$TelemetryPacketSchema(0);
  static const int _packetIdBit = 1 << 0;
  static const _$TelemetryPacketSchema packetId = _$TelemetryPacketSchema(
    _packetIdBit,
  );
  static const int _regionZipBit = 1 << 1;
  static const _$TelemetryPacketSchema regionZip = _$TelemetryPacketSchema(
    _regionZipBit,
  );
  static const int _statusCodeBit = 1 << 2;
  static const _$TelemetryPacketSchema statusCode = _$TelemetryPacketSchema(
    _statusCodeBit,
  );
  static const int _readingBit = 1 << 3;
  static const _$TelemetryPacketSchema reading = _$TelemetryPacketSchema(
    _readingBit,
  );
  static const int _vehicleBit = 1 << 4;
  static const _$TelemetryPacketSchema vehicle = _$TelemetryPacketSchema(
    _vehicleBit,
  );

  // Combined Golden Bitmask for fast single-instruction check
  static const _$TelemetryPacketSchema golden = _$TelemetryPacketSchema(
    _packetIdBit | _regionZipBit | _statusCodeBit | _readingBit | _vehicleBit,
  );

  @pragma('vm:prefer-inline')
  _$TelemetryPacketSchema operator |(_$TelemetryPacketSchema other) =>
      _$TelemetryPacketSchema(_value | other._value);

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
    if ((_value & _packetIdBit) == 0) {
      missing.add(namePacketId);
    }
    if ((_value & _regionZipBit) == 0) {
      missing.add(nameRegionZip);
    }
    if ((_value & _statusCodeBit) == 0) {
      missing.add(nameStatusCode);
    }
    if ((_value & _readingBit) == 0) {
      missing.add(nameReading);
    }
    if ((_value & _vehicleBit) == 0) {
      missing.add(nameVehicle);
    }
    throw CodableException(
      'Missing required fields for TelemetryPacket: ${missing.join(", ")}',
    );
  }
}

// =============================================================================
// 2. Companion Codable for TelemetryPacket
// =============================================================================
final class TelemetryPacketCodable implements Codable<TelemetryPacket> {
  const TelemetryPacketCodable();

  @override
  TelemetryPacket decode(Decoder decoder) {
    final keyed = decoder.keyed(options: _$TelemetryPacketSchema.keyOptions);

    String? packetId;
    String? regionZip;
    String? statusCode;
    num? reading;
    num? delta;
    var history = const <num>[];
    var counters = const <String, num>{};
    Vehicle? vehicle;
    String? notes;
    var seen = _$TelemetryPacketSchema.none;

    while (keyed.moveNextKey()) {
      switch (keyed.selectKeyIndex(_$TelemetryPacketSchema.keyOptions)) {
        case _$TelemetryPacketSchema.keyPacketId:
          if ((seen._value & _$TelemetryPacketSchema.packetId._value) != 0) {
            throw const CodableException('Duplicate field "packetId"');
          }
          packetId = keyed.decodeValue(const FlexibleIdDecoder());
          seen |= _$TelemetryPacketSchema.packetId;
          break;
        case _$TelemetryPacketSchema.keyRegionZip:
          if ((seen._value & _$TelemetryPacketSchema.regionZip._value) != 0) {
            throw const CodableException('Duplicate field "regionZip"');
          }
          regionZip = keyed.decodeValue(const ZipCodeDecoder());
          seen |= _$TelemetryPacketSchema.regionZip;
          break;
        case _$TelemetryPacketSchema.keyStatusCode:
          if ((seen._value & _$TelemetryPacketSchema.statusCode._value) != 0) {
            throw const CodableException('Duplicate field "statusCode"');
          }
          statusCode = keyed.readString();
          seen |= _$TelemetryPacketSchema.statusCode;
          break;
        case _$TelemetryPacketSchema.keyReading:
          if ((seen._value & _$TelemetryPacketSchema.reading._value) != 0) {
            throw const CodableException('Duplicate field "reading"');
          }
          reading = keyed.readNum();
          seen |= _$TelemetryPacketSchema.reading;
          break;
        case _$TelemetryPacketSchema.keyDelta:
          if (keyed.isNextNull()) {
            keyed.readNull();
            delta = null;
          } else {
            delta = keyed.readNum();
          }
          break;
        case _$TelemetryPacketSchema.keyHistory:
          history = keyed.decodeList<num>(
            Decodable.fromFunction((d) => d.singleValue().readNum()),
          );
          break;
        case _$TelemetryPacketSchema.keyCounters:
          {
            final k = keyed.nestedDecoder().keyed();
            final m = <String, num>{};
            while (k.moveNextKey()) {
              final key = k.nextKey();
              m[key] = k.readNum();
            }
            counters = m;
          }
          break;
        case _$TelemetryPacketSchema.keyVehicle:
          if ((seen._value & _$TelemetryPacketSchema.vehicle._value) != 0) {
            throw const CodableException('Duplicate field "vehicle"');
          }
          vehicle = keyed.decodeValue(const VehicleSuperDecodable());
          seen |= _$TelemetryPacketSchema.vehicle;
          break;
        case _$TelemetryPacketSchema.keyNotes:
          if (keyed.isNextNull()) {
            keyed.readNull();
            notes = null;
          } else {
            notes = keyed.readString();
          }
          break;
        default:
          keyed.skipValue();
          break;
      }
    }

    // Inlined fast-path check
    seen.validate();

    return TelemetryPacket(
      packetId: packetId!,
      regionZip: regionZip!,
      statusCode: statusCode!,
      reading: reading!,
      delta: delta,
      history: history,
      counters: counters,
      vehicle: vehicle!,
      notes: notes,
    );
  }

  @override
  void encode(TelemetryPacket instance, Encoder encoder) {
    var count$ = 7;
    final v$Delta = instance.delta;
    if (v$Delta != null) count$++;
    final v$Notes = instance.notes;
    if (v$Notes != null) count$++;
    final keyed = encoder.keyed(length: count$);
    keyed.encodeString(_$TelemetryPacketSchema.namePacketId, instance.packetId);
    keyed.encodeValue(
      _$TelemetryPacketSchema.nameRegionZip,
      instance.regionZip,
      const ZipCodeDecoder(),
    );
    keyed.encodeValue(
      _$TelemetryPacketSchema.nameStatusCode,
      instance.statusCode,
      const UpperCodeEncoder(),
    );
    switch (instance.reading) {
      case final int v:
        keyed.encodeInt(_$TelemetryPacketSchema.nameReading, v);
      case final v:
        keyed.encodeDouble(_$TelemetryPacketSchema.nameReading, v.toDouble());
    }
    if (v$Delta != null) {
      switch (v$Delta) {
        case final int v:
          keyed.encodeInt(_$TelemetryPacketSchema.nameDelta, v);
        case final v:
          keyed.encodeDouble(_$TelemetryPacketSchema.nameDelta, v.toDouble());
      }
    }
    keyed.encodeList(
      _$TelemetryPacketSchema.nameHistory,
      instance.history,
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
          .nestedEncoder(_$TelemetryPacketSchema.nameCounters)
          .keyed(length: instance.counters.length);
      for (final entry in instance.counters.entries) {
        switch (entry.value) {
          case final int v:
            k.encodeInt(entry.key, v);
          case final v:
            k.encodeDouble(entry.key, v.toDouble());
        }
      }
    }
    keyed.encodeValue(
      _$TelemetryPacketSchema.nameVehicle,
      instance.vehicle,
      const VehicleCodable(),
    );
    if (v$Notes != null) {
      keyed.encodeString(_$TelemetryPacketSchema.nameNotes, v$Notes);
    }
  }
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
// 2. Companion Codable for UserWithLocation
// =============================================================================
final class UserWithLocationCodable implements Codable<UserWithLocation> {
  const UserWithLocationCodable();

  @override
  UserWithLocation decode(Decoder decoder) {
    final keyed = decoder.keyed(options: _$UserWithLocationSchema.keyOptions);

    UserProfile? profile;
    Coordinate? location;
    var seen = _$UserWithLocationSchema.none;

    while (keyed.moveNextKey()) {
      switch (keyed.selectKeyIndex(_$UserWithLocationSchema.keyOptions)) {
        case _$UserWithLocationSchema.keyProfile:
          if ((seen._value & _$UserWithLocationSchema.profile._value) != 0) {
            throw const CodableException('Duplicate field "profile"');
          }
          profile = const UserProfileCodable().decode(keyed.nestedDecoder());
          seen |= _$UserWithLocationSchema.profile;
          break;
        case _$UserWithLocationSchema.keyLocation:
          if ((seen._value & _$UserWithLocationSchema.location._value) != 0) {
            throw const CodableException('Duplicate field "location"');
          }
          location = const CoordinateCodable().decode(keyed.nestedDecoder());
          seen |= _$UserWithLocationSchema.location;
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

  @override
  void encode(UserWithLocation instance, Encoder encoder) {
    final keyed = encoder.keyed(length: 2);
    keyed.encodeValue(
      _$UserWithLocationSchema.nameProfile,
      instance.profile,
      const UserProfileCodable(),
    );
    keyed.encodeValue(
      _$UserWithLocationSchema.nameLocation,
      instance.location,
      const CoordinateCodable(),
    );
  }
}
