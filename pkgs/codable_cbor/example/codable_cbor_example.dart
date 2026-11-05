// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// ignore_for_file: unreachable_from_main

import 'dart:typed_data';

import 'package:codable/codable.dart';
import 'package:codable_cbor/codable_cbor.dart';

part 'codable_cbor_example.g.dart';

@Codable()
final class SensorCoordinate {
  final int rack;
  final int slot;

  const SensorCoordinate(this.rack, this.slot);

  @override
  bool operator ==(Object other) =>
      other is SensorCoordinate && other.rack == rack && other.slot == slot;

  @override
  int get hashCode => Object.hash(rack, slot);
}

@Codable()
final class SensorBatch {
  final int batchId;
  final Uint8List rawSample;
  final Float64List readings;
  final Map<SensorCoordinate, double> calibrationOffsets;

  const SensorBatch({
    required this.batchId,
    required this.rawSample,
    required this.readings,
    this.calibrationOffsets = const {},
  });
}

void main() {
  final batch = SensorBatch(
    batchId: 1001,
    rawSample: Uint8List.fromList([0xca, 0xfe, 0xba, 0xbe]),
    readings: Float64List.fromList([21.5, 22.0, 21.875]),
    calibrationOffsets: {
      const SensorCoordinate(1, 0): -0.125,
      const SensorCoordinate(1, 1): 0.25,
    },
  );

  final cborBytes = CborCodableEncoder.encode(
    batch,
    const SensorBatchCodable(),
  );
  final decoded = CborCodableDecoder.decode(
    cborBytes,
    const SensorBatchCodable(),
  );

  print(
    'Encoded CBOR (${cborBytes.length} bytes) -> '
    'batchId=${decoded.batchId}, sample=${decoded.rawSample}',
  );
}
