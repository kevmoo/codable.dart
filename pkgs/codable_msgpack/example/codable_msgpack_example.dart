// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// ignore_for_file: unreachable_from_main

import 'dart:typed_data';

import 'package:codable/codable.dart';
import 'package:codable_msgpack/codable_msgpack.dart';

part 'codable_msgpack_example.g.dart';

@Codable()
final class TelemetryCoordinate {
  final int rack;
  final int slot;

  const TelemetryCoordinate(this.rack, this.slot);

  @override
  bool operator ==(Object other) =>
      other is TelemetryCoordinate && other.rack == rack && other.slot == slot;

  @override
  int get hashCode => Object.hash(rack, slot);
}

@Codable()
final class TelemetryBatch {
  final int batchId;
  final Uint8List rawSample;
  final Float64List readings;
  final Map<TelemetryCoordinate, double> calibrationOffsets;

  const TelemetryBatch({
    required this.batchId,
    required this.rawSample,
    required this.readings,
    this.calibrationOffsets = const {},
  });
}

void main() {
  final batch = TelemetryBatch(
    batchId: 1001,
    rawSample: Uint8List.fromList([0xca, 0xfe, 0xba, 0xbe]),
    readings: Float64List.fromList([21.5, 22.0, 21.875]),
    calibrationOffsets: {
      const TelemetryCoordinate(1, 0): -0.125,
      const TelemetryCoordinate(1, 1): 0.25,
    },
  );

  final msgpackBytes = MsgPackCodableEncoder.encode(
    batch,
    const TelemetryBatchCodable(),
    requireKnownLength: true,
  );
  final decoded = MsgPackCodableDecoder.decode(
    msgpackBytes,
    const TelemetryBatchCodable(),
  );

  print(
    'Encoded MessagePack (${msgpackBytes.length} bytes) -> '
    'batchId=${decoded.batchId}, sample=${decoded.rawSample}',
  );
}
