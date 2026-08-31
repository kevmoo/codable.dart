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

  // Pre-encoded UTF-8 Wire Name Bytes and StaticKeys
  static const List<int> wireNameBytesMaxSpeed = [
    34,
    109,
    97,
    120,
    83,
    112,
    101,
    101,
    100,
    34,
  ];
  static const StaticKey staticKeyMaxSpeed = StaticKey(
    nameMaxSpeed,
    keyMaxSpeed,
    wireNameBytesMaxSpeed,
  );
  static const List<int> wireNameBytesDoors = [34, 100, 111, 111, 114, 115, 34];
  static const StaticKey staticKeyDoors = StaticKey(
    nameDoors,
    keyDoors,
    wireNameBytesDoors,
  );

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
// 2b. Universal List Deserializer for Car
// =============================================================================
List<Car> _$CarListFromDecoder(Decoder decoder) {
  final unkeyed = decoder.unkeyed();
  final list = <Car>[];
  while (unkeyed.hasNext()) {
    list.add(unkeyed.decodeElement(_$CarFromDecoder));
  }
  return list;
}

// =============================================================================
// 3. Universal Serializer for Car
// =============================================================================
void _$CarToEncoder(Car instance, Encoder encoder) {
  final keyed = encoder.keyed();
  keyed.encodeIntKey(_$CarSchema.staticKeyMaxSpeed, instance.maxSpeed);
  keyed.encodeIntKey(_$CarSchema.staticKeyDoors, instance.doors);
}

// =============================================================================
// 1. Unified Schema Descriptor for Bicycle
// =============================================================================
extension type const _$BicycleSchema(int _value) {
  // String Name Constants
  static const String nameMaxSpeed = 'maxSpeed';
  static const String nameHasBell = 'hasBell';

  // Pre-encoded UTF-8 Wire Name Bytes and StaticKeys
  static const List<int> wireNameBytesMaxSpeed = [
    34,
    109,
    97,
    120,
    83,
    112,
    101,
    101,
    100,
    34,
  ];
  static const StaticKey staticKeyMaxSpeed = StaticKey(
    nameMaxSpeed,
    keyMaxSpeed,
    wireNameBytesMaxSpeed,
  );
  static const List<int> wireNameBytesHasBell = [
    34,
    104,
    97,
    115,
    66,
    101,
    108,
    108,
    34,
  ];
  static const StaticKey staticKeyHasBell = StaticKey(
    nameHasBell,
    keyHasBell,
    wireNameBytesHasBell,
  );

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
// 2b. Universal List Deserializer for Bicycle
// =============================================================================
List<Bicycle> _$BicycleListFromDecoder(Decoder decoder) {
  final unkeyed = decoder.unkeyed();
  final list = <Bicycle>[];
  while (unkeyed.hasNext()) {
    list.add(unkeyed.decodeElement(_$BicycleFromDecoder));
  }
  return list;
}

// =============================================================================
// 3. Universal Serializer for Bicycle
// =============================================================================
void _$BicycleToEncoder(Bicycle instance, Encoder encoder) {
  final keyed = encoder.keyed();
  keyed.encodeIntKey(_$BicycleSchema.staticKeyMaxSpeed, instance.maxSpeed);
  keyed.encodeBoolKey(_$BicycleSchema.staticKeyHasBell, instance.hasBell);
}
