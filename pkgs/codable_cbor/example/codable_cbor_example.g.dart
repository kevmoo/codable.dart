// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: lines_longer_than_80_chars, unnecessary_lambdas, deprecated_member_use, unused_element

part of 'codable_cbor_example.dart';

// **************************************************************************
// CodableGenerator
// **************************************************************************

// =============================================================================
// 1. Unified Schema Descriptor for SensorCoordinate
// =============================================================================
extension type const _$SensorCoordinateSchema(int _value) {
  // String Name Constants
  static const String nameRack = 'rack';
  static const String nameSlot = 'slot';

  // Key Indices for selectKeyIndex()
  static const int keyRack = 0;
  static const int keySlot = 1;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
    _$SensorCoordinateSchema.nameRack,
    _$SensorCoordinateSchema.nameSlot,
  ]);
  static final KeyOptions keyOptions = options;

  // Bitmask Flags strictly for Required Fields
  static const _$SensorCoordinateSchema none = _$SensorCoordinateSchema(0);
  static const int _rackBit = 1 << 0;
  static const _$SensorCoordinateSchema rack = _$SensorCoordinateSchema(
    _rackBit,
  );
  static const int _slotBit = 1 << 1;
  static const _$SensorCoordinateSchema slot = _$SensorCoordinateSchema(
    _slotBit,
  );

  // Combined Golden Bitmask for fast single-instruction check
  static const _$SensorCoordinateSchema golden = _$SensorCoordinateSchema(
    _rackBit | _slotBit,
  );

  @pragma('vm:prefer-inline')
  _$SensorCoordinateSchema operator |(_$SensorCoordinateSchema other) =>
      _$SensorCoordinateSchema(_value | other._value);

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
    if ((_value & _rackBit) == 0) {
      missing.add(nameRack);
    }
    if ((_value & _slotBit) == 0) {
      missing.add(nameSlot);
    }
    throw CodableException(
      'Missing required fields for SensorCoordinate: ${missing.join(", ")}',
    );
  }
}

// =============================================================================
// 2. Companion Codable for SensorCoordinate
// =============================================================================
final class SensorCoordinateCodable implements Codable<SensorCoordinate> {
  const SensorCoordinateCodable();

  @override
  SensorCoordinate decode(Decoder decoder) {
    final keyed = decoder.keyed(options: _$SensorCoordinateSchema.keyOptions);

    int? rack;
    int? slot;
    var seen = _$SensorCoordinateSchema.none;

    while (keyed.moveNextKey()) {
      switch (keyed.selectKeyIndex(_$SensorCoordinateSchema.keyOptions)) {
        case _$SensorCoordinateSchema.keyRack:
          if ((seen._value & _$SensorCoordinateSchema.rack._value) != 0) {
            throw const CodableException('Duplicate field "rack"');
          }
          rack = keyed.readInt();
          seen |= _$SensorCoordinateSchema.rack;
          break;
        case _$SensorCoordinateSchema.keySlot:
          if ((seen._value & _$SensorCoordinateSchema.slot._value) != 0) {
            throw const CodableException('Duplicate field "slot"');
          }
          slot = keyed.readInt();
          seen |= _$SensorCoordinateSchema.slot;
          break;
        default:
          keyed.skipValue();
          break;
      }
    }

    // Inlined fast-path check
    seen.validate();

    return SensorCoordinate(rack!, slot!);
  }

  @override
  void encode(SensorCoordinate instance, Encoder encoder) {
    final keyed = encoder.keyed(length: 2);
    keyed.encodeInt(_$SensorCoordinateSchema.nameRack, instance.rack);
    keyed.encodeInt(_$SensorCoordinateSchema.nameSlot, instance.slot);
  }
}

// =============================================================================
// 1. Unified Schema Descriptor for SensorBatch
// =============================================================================
extension type const _$SensorBatchSchema(int _value) {
  // String Name Constants
  static const String nameBatchId = 'batchId';
  static const String nameRawSample = 'rawSample';
  static const String nameReadings = 'readings';
  static const String nameCalibrationOffsets = 'calibrationOffsets';

  // Key Indices for selectKeyIndex()
  static const int keyBatchId = 0;
  static const int keyRawSample = 1;
  static const int keyReadings = 2;
  static const int keyCalibrationOffsets = 3;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
    _$SensorBatchSchema.nameBatchId,
    _$SensorBatchSchema.nameRawSample,
    _$SensorBatchSchema.nameReadings,
    _$SensorBatchSchema.nameCalibrationOffsets,
  ]);
  static final KeyOptions keyOptions = options;

  // Bitmask Flags strictly for Required Fields
  static const _$SensorBatchSchema none = _$SensorBatchSchema(0);
  static const int _batchIdBit = 1 << 0;
  static const _$SensorBatchSchema batchId = _$SensorBatchSchema(_batchIdBit);
  static const int _rawSampleBit = 1 << 1;
  static const _$SensorBatchSchema rawSample = _$SensorBatchSchema(
    _rawSampleBit,
  );
  static const int _readingsBit = 1 << 2;
  static const _$SensorBatchSchema readings = _$SensorBatchSchema(_readingsBit);

  // Combined Golden Bitmask for fast single-instruction check
  static const _$SensorBatchSchema golden = _$SensorBatchSchema(
    _batchIdBit | _rawSampleBit | _readingsBit,
  );

  @pragma('vm:prefer-inline')
  _$SensorBatchSchema operator |(_$SensorBatchSchema other) =>
      _$SensorBatchSchema(_value | other._value);

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
    if ((_value & _batchIdBit) == 0) {
      missing.add(nameBatchId);
    }
    if ((_value & _rawSampleBit) == 0) {
      missing.add(nameRawSample);
    }
    if ((_value & _readingsBit) == 0) {
      missing.add(nameReadings);
    }
    throw CodableException(
      'Missing required fields for SensorBatch: ${missing.join(", ")}',
    );
  }
}

// =============================================================================
// 2. Companion Codable for SensorBatch
// =============================================================================
final class SensorBatchCodable implements Codable<SensorBatch> {
  const SensorBatchCodable();

  @override
  SensorBatch decode(Decoder decoder) {
    final keyed = decoder.keyed(options: _$SensorBatchSchema.keyOptions);

    int? batchId;
    Uint8List? rawSample;
    Float64List? readings;
    var calibrationOffsets = const <SensorCoordinate, double>{};
    var seen = _$SensorBatchSchema.none;

    while (keyed.moveNextKey()) {
      switch (keyed.selectKeyIndex(_$SensorBatchSchema.keyOptions)) {
        case _$SensorBatchSchema.keyBatchId:
          if ((seen._value & _$SensorBatchSchema.batchId._value) != 0) {
            throw const CodableException('Duplicate field "batchId"');
          }
          batchId = keyed.readInt();
          seen |= _$SensorBatchSchema.batchId;
          break;
        case _$SensorBatchSchema.keyRawSample:
          if ((seen._value & _$SensorBatchSchema.rawSample._value) != 0) {
            throw const CodableException('Duplicate field "rawSample"');
          }
          rawSample = keyed.readBytes();
          seen |= _$SensorBatchSchema.rawSample;
          break;
        case _$SensorBatchSchema.keyReadings:
          if ((seen._value & _$SensorBatchSchema.readings._value) != 0) {
            throw const CodableException('Duplicate field "readings"');
          }
          readings = keyed.decodeFloat64List();
          seen |= _$SensorBatchSchema.readings;
          break;
        case _$SensorBatchSchema.keyCalibrationOffsets:
          {
            final mDecoder = keyed.nestedDecoder().map();
            final m = <SensorCoordinate, double>{};
            while (mDecoder.moveNextEntry()) {
              final key = const SensorCoordinateCodable().decode(
                mDecoder.keyDecoder(),
              );
              m[key] = mDecoder.valueDecoder().singleValue().readDouble();
            }
            calibrationOffsets = m;
          }
          break;
        default:
          keyed.skipValue();
          break;
      }
    }

    // Inlined fast-path check
    seen.validate();

    return SensorBatch(
      batchId: batchId!,
      rawSample: rawSample!,
      readings: readings!,
      calibrationOffsets: calibrationOffsets,
    );
  }

  @override
  void encode(SensorBatch instance, Encoder encoder) {
    final keyed = encoder.keyed(length: 4);
    keyed.encodeInt(_$SensorBatchSchema.nameBatchId, instance.batchId);
    keyed.encodeBytes(_$SensorBatchSchema.nameRawSample, instance.rawSample);
    keyed.encodeDoubleList(_$SensorBatchSchema.nameReadings, instance.readings);
    {
      final m = keyed
          .nestedEncoder(_$SensorBatchSchema.nameCalibrationOffsets)
          .map(length: instance.calibrationOffsets.length);
      for (final entry in instance.calibrationOffsets.entries) {
        const SensorCoordinateCodable().encode(entry.key, m.keyEncoder());
        m.valueEncoder().singleValue().encodeDouble(entry.value);
      }
    }
  }
}
