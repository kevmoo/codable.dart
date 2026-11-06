// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: lines_longer_than_80_chars, unnecessary_lambdas, deprecated_member_use, unused_element

part of 'codable_msgpack_example.dart';

// **************************************************************************
// CodableGenerator
// **************************************************************************

// =============================================================================
// 1. Unified Schema Descriptor for TelemetryCoordinate
// =============================================================================
extension type const _$TelemetryCoordinateSchema(int _value) {
  // String Name Constants
  static const String nameRack = 'rack';
  static const String nameSlot = 'slot';

  // Key Indices for selectKeyIndex()
  static const int keyRack = 0;
  static const int keySlot = 1;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
    _$TelemetryCoordinateSchema.nameRack,
    _$TelemetryCoordinateSchema.nameSlot,
  ]);
  static final KeyOptions keyOptions = options;

  // Bitmask Flags strictly for Required Fields
  static const _$TelemetryCoordinateSchema none = _$TelemetryCoordinateSchema(
    0,
  );
  static const int _rackBit = 1 << 0;
  static const _$TelemetryCoordinateSchema rack = _$TelemetryCoordinateSchema(
    _rackBit,
  );
  static const int _slotBit = 1 << 1;
  static const _$TelemetryCoordinateSchema slot = _$TelemetryCoordinateSchema(
    _slotBit,
  );

  // Combined Golden Bitmask for fast single-instruction check
  static const _$TelemetryCoordinateSchema golden = _$TelemetryCoordinateSchema(
    _rackBit | _slotBit,
  );

  @pragma('vm:prefer-inline')
  _$TelemetryCoordinateSchema operator |(_$TelemetryCoordinateSchema other) =>
      _$TelemetryCoordinateSchema(_value | other._value);

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
      'Missing required fields for TelemetryCoordinate: ${missing.join(", ")}',
    );
  }
}

// =============================================================================
// 2. Companion Codable for TelemetryCoordinate
// =============================================================================
final class TelemetryCoordinateCodable implements Codable<TelemetryCoordinate> {
  const TelemetryCoordinateCodable();

  @override
  TelemetryCoordinate decode(Decoder decoder) {
    final keyed = decoder.keyed(
      options: _$TelemetryCoordinateSchema.keyOptions,
    );

    int? rack;
    int? slot;
    var seen = _$TelemetryCoordinateSchema.none;

    while (keyed.moveNextKey()) {
      switch (keyed.selectKeyIndex(_$TelemetryCoordinateSchema.keyOptions)) {
        case _$TelemetryCoordinateSchema.keyRack:
          if ((seen._value & _$TelemetryCoordinateSchema.rack._value) != 0) {
            throw const CodableException('Duplicate field "rack"');
          }
          rack = keyed.readInt();
          seen |= _$TelemetryCoordinateSchema.rack;
          break;
        case _$TelemetryCoordinateSchema.keySlot:
          if ((seen._value & _$TelemetryCoordinateSchema.slot._value) != 0) {
            throw const CodableException('Duplicate field "slot"');
          }
          slot = keyed.readInt();
          seen |= _$TelemetryCoordinateSchema.slot;
          break;
        default:
          keyed.skipValue();
          break;
      }
    }

    // Inlined fast-path check
    seen.validate();

    return TelemetryCoordinate(rack!, slot!);
  }

  @override
  void encode(TelemetryCoordinate instance, Encoder encoder) {
    final keyed = encoder.keyed(length: 2);
    keyed.encodeInt(_$TelemetryCoordinateSchema.nameRack, instance.rack);
    keyed.encodeInt(_$TelemetryCoordinateSchema.nameSlot, instance.slot);
  }
}

// =============================================================================
// 1. Unified Schema Descriptor for TelemetryBatch
// =============================================================================
extension type const _$TelemetryBatchSchema(int _value) {
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
    _$TelemetryBatchSchema.nameBatchId,
    _$TelemetryBatchSchema.nameRawSample,
    _$TelemetryBatchSchema.nameReadings,
    _$TelemetryBatchSchema.nameCalibrationOffsets,
  ]);
  static final KeyOptions keyOptions = options;

  // Bitmask Flags strictly for Required Fields
  static const _$TelemetryBatchSchema none = _$TelemetryBatchSchema(0);
  static const int _batchIdBit = 1 << 0;
  static const _$TelemetryBatchSchema batchId = _$TelemetryBatchSchema(
    _batchIdBit,
  );
  static const int _rawSampleBit = 1 << 1;
  static const _$TelemetryBatchSchema rawSample = _$TelemetryBatchSchema(
    _rawSampleBit,
  );
  static const int _readingsBit = 1 << 2;
  static const _$TelemetryBatchSchema readings = _$TelemetryBatchSchema(
    _readingsBit,
  );

  // Combined Golden Bitmask for fast single-instruction check
  static const _$TelemetryBatchSchema golden = _$TelemetryBatchSchema(
    _batchIdBit | _rawSampleBit | _readingsBit,
  );

  @pragma('vm:prefer-inline')
  _$TelemetryBatchSchema operator |(_$TelemetryBatchSchema other) =>
      _$TelemetryBatchSchema(_value | other._value);

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
      'Missing required fields for TelemetryBatch: ${missing.join(", ")}',
    );
  }
}

// =============================================================================
// 2. Companion Codable for TelemetryBatch
// =============================================================================
final class TelemetryBatchCodable implements Codable<TelemetryBatch> {
  const TelemetryBatchCodable();

  @override
  TelemetryBatch decode(Decoder decoder) {
    final keyed = decoder.keyed(options: _$TelemetryBatchSchema.keyOptions);

    int? batchId;
    Uint8List? rawSample;
    Float64List? readings;
    var calibrationOffsets = const <TelemetryCoordinate, double>{};
    var seen = _$TelemetryBatchSchema.none;

    while (keyed.moveNextKey()) {
      switch (keyed.selectKeyIndex(_$TelemetryBatchSchema.keyOptions)) {
        case _$TelemetryBatchSchema.keyBatchId:
          if ((seen._value & _$TelemetryBatchSchema.batchId._value) != 0) {
            throw const CodableException('Duplicate field "batchId"');
          }
          batchId = keyed.readInt();
          seen |= _$TelemetryBatchSchema.batchId;
          break;
        case _$TelemetryBatchSchema.keyRawSample:
          if ((seen._value & _$TelemetryBatchSchema.rawSample._value) != 0) {
            throw const CodableException('Duplicate field "rawSample"');
          }
          rawSample = keyed.readBytes();
          seen |= _$TelemetryBatchSchema.rawSample;
          break;
        case _$TelemetryBatchSchema.keyReadings:
          if ((seen._value & _$TelemetryBatchSchema.readings._value) != 0) {
            throw const CodableException('Duplicate field "readings"');
          }
          readings = keyed.decodeFloat64List();
          seen |= _$TelemetryBatchSchema.readings;
          break;
        case _$TelemetryBatchSchema.keyCalibrationOffsets:
          {
            final mDecoder = keyed.nestedDecoder().map();
            final m = <TelemetryCoordinate, double>{};
            while (mDecoder.moveNextEntry()) {
              final key = const TelemetryCoordinateCodable().decode(
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

    return TelemetryBatch(
      batchId: batchId!,
      rawSample: rawSample!,
      readings: readings!,
      calibrationOffsets: calibrationOffsets,
    );
  }

  @override
  void encode(TelemetryBatch instance, Encoder encoder) {
    final keyed = encoder.keyed(length: 4);
    keyed.encodeInt(_$TelemetryBatchSchema.nameBatchId, instance.batchId);
    keyed.encodeBytes(_$TelemetryBatchSchema.nameRawSample, instance.rawSample);
    keyed.encodeDoubleList(
      _$TelemetryBatchSchema.nameReadings,
      instance.readings,
    );
    {
      final m = keyed
          .nestedEncoder(_$TelemetryBatchSchema.nameCalibrationOffsets)
          .map(length: instance.calibrationOffsets.length);
      for (final entry in instance.calibrationOffsets.entries) {
        const TelemetryCoordinateCodable().encode(entry.key, m.keyEncoder());
        m.valueEncoder().singleValue().encodeDouble(entry.value);
      }
    }
  }
}
