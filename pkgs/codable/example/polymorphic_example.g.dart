// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: lines_longer_than_80_chars

part of 'polymorphic_example.dart';

// **************************************************************************
// CodableGenerator
// **************************************************************************

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
          throw const CodableException('Duplicate field "maxSpeed"');
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
          throw const CodableException('Duplicate field "doors"');
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
          throw const CodableException('Duplicate field "maxSpeed"');
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
          throw const CodableException('Duplicate field "hasBell"');
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
