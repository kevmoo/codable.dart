// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: lines_longer_than_80_chars, unnecessary_lambdas, deprecated_member_use, unused_element

part of 'polymorphic_example.dart';

// **************************************************************************
// CodableGenerator
// **************************************************************************

// ignore_for_file: omit_local_variable_types

// =============================================================================
// 1. Polymorphic Schema Descriptor for Vehicle
// =============================================================================
extension type const _$VehicleSchema(int _value) {
  static const String discriminatorKey = 'type';
  static const String subtypeCar = 'car';
  static const String subtypeBicycle = 'bicycle';
}

// =============================================================================
// 2. Companion Codable for Vehicle
// =============================================================================
final class VehicleCodable implements KeyedCodable<Vehicle> {
  const VehicleCodable();

  @override
  Vehicle decode(Decoder decoder) {
    final mapped = decoder.mapped();
    if (!mapped.containsKey(_$VehicleSchema.discriminatorKey) ||
        mapped.isNull(_$VehicleSchema.discriminatorKey)) {
      throw CodableException.missingKey(_$VehicleSchema.discriminatorKey);
    }
    final discriminator = mapped.readString(_$VehicleSchema.discriminatorKey);
    return switch (discriminator) {
      _$VehicleSchema.subtypeCar => const CarCodable().decode(decoder),
      _$VehicleSchema.subtypeBicycle => const BicycleCodable().decode(decoder),
      _ => throw CodableException.unknownSubtype(
        discriminatorKey: _$VehicleSchema.discriminatorKey,
        subtypeValue: discriminator,
      ),
    };
  }

  @override
  int encodedFieldCount(Vehicle instance) => switch (instance) {
    final Car sub => 1 + const CarCodable().encodedFieldCount(sub),
    final Bicycle sub => 1 + const BicycleCodable().encodedFieldCount(sub),
  };

  @override
  void encodeFields(Vehicle instance, KeyedEncoder keyed) {
    switch (instance) {
      case final Car sub:
        keyed.encodeString(
          _$VehicleSchema.discriminatorKey,
          _$VehicleSchema.subtypeCar,
        );
        const CarCodable().encodeFields(sub, keyed);
      case final Bicycle sub:
        keyed.encodeString(
          _$VehicleSchema.discriminatorKey,
          _$VehicleSchema.subtypeBicycle,
        );
        const BicycleCodable().encodeFields(sub, keyed);
    }
  }

  @override
  void encode(Vehicle instance, Encoder encoder) {
    switch (instance) {
      case final Car sub:
        final subCodec = const CarCodable();
        final keyed = encoder.keyed(
          length: 1 + subCodec.encodedFieldCount(sub),
        );
        keyed.encodeString(
          _$VehicleSchema.discriminatorKey,
          _$VehicleSchema.subtypeCar,
        );
        subCodec.encodeFields(sub, keyed);
      case final Bicycle sub:
        final subCodec = const BicycleCodable();
        final keyed = encoder.keyed(
          length: 1 + subCodec.encodedFieldCount(sub),
        );
        keyed.encodeString(
          _$VehicleSchema.discriminatorKey,
          _$VehicleSchema.subtypeBicycle,
        );
        subCodec.encodeFields(sub, keyed);
    }
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
final class CarCodable implements KeyedCodable<Car> {
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
  int encodedFieldCount(Car instance) => 2;

  @override
  void encodeFields(Car instance, KeyedEncoder keyed) {
    keyed.encodeInt(_$CarSchema.nameMaxSpeed, instance.maxSpeed);
    keyed.encodeInt(_$CarSchema.nameDoors, instance.doors);
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
final class BicycleCodable implements KeyedCodable<Bicycle> {
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
  int encodedFieldCount(Bicycle instance) => 2;

  @override
  void encodeFields(Bicycle instance, KeyedEncoder keyed) {
    keyed.encodeInt(_$BicycleSchema.nameMaxSpeed, instance.maxSpeed);
    keyed.encodeBool(_$BicycleSchema.nameHasBell, instance.hasBell);
  }

  @override
  void encode(Bicycle instance, Encoder encoder) {
    final keyed = encoder.keyed(length: 2);
    keyed.encodeInt(_$BicycleSchema.nameMaxSpeed, instance.maxSpeed);
    keyed.encodeBool(_$BicycleSchema.nameHasBell, instance.hasBell);
  }
}
