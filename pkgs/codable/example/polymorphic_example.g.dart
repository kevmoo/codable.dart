// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: lines_longer_than_80_chars, unnecessary_lambdas, deprecated_member_use, unused_element

part of 'polymorphic_example.dart';

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
    final keyed = encoder.keyed();
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
    final keyed = encoder.keyed();
    keyed.encodeInt(_$BicycleSchema.nameMaxSpeed, instance.maxSpeed);
    keyed.encodeBool(_$BicycleSchema.nameHasBell, instance.hasBell);
  }
}
