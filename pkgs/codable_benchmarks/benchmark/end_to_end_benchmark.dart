// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:codable/src/driver/json_codable_driver.dart';
import 'package:codable_benchmarks/codable_benchmarks.dart';

import 'models/canada.dart';
import 'models/citm_catalog.dart';
import 'models/coordinate.dart';

// =============================================================================
// 1. Coordinate List (10,000 Items)
// =============================================================================

final class NativeCoordinateBenchmark extends Benchmark {
  final String jsonStr;

  NativeCoordinateBenchmark(this.jsonStr, int payloadBytes)
    : super(
        'Native Coordinate (jsonDecode + Map)',
        category: 'Coordinates (10k items)',
        payloadBytes: payloadBytes,
      );

  @override
  dynamic run() {
    var hash = 0;
    final list = jsonDecode(jsonStr) as List<dynamic>;
    for (final item in list) {
      final map = item as Map<String, dynamic>;
      final c = Coordinate(
        latitude: (map['latitude'] ?? map['lat']) as double,
        longitude: (map['longitude'] ?? map['lon']) as double,
      );
      hash ^= c.hashCode;
    }
    return hash;
  }
}

final class CodableCoordinateBenchmark extends Benchmark {
  final Uint8List bytes;

  CodableCoordinateBenchmark(this.bytes, int payloadBytes)
    : super(
        'Codable Coordinate (Mock Codegen)',
        category: 'Coordinates (10k items)',
        payloadBytes: payloadBytes,
      );

  @override
  dynamic run() {
    var hash = 0;
    final decoder = JsonCodableDecoder.fromBytes(bytes);
    final unkeyed = decoder.unkeyed();
    while (unkeyed.hasNext()) {
      hash ^= Coordinate.decode(decoder).hashCode;
    }
    return hash;
  }
}

// =============================================================================
// 2. canada.json (2.25 MB GeoJSON - Coordinate Arrays & Float Operations)
// =============================================================================

final class NativeCanadaBenchmark extends Benchmark {
  final String jsonStr;

  NativeCanadaBenchmark(this.jsonStr, int payloadBytes)
    : super(
        'Native canada.json (jsonDecode -> Map)',
        category: 'canada.json (GeoJSON)',
        payloadBytes: payloadBytes,
      );

  @override
  dynamic run() => jsonDecode(jsonStr);
}

final class CodableCanadaBenchmark extends Benchmark {
  final Uint8List bytes;

  CodableCanadaBenchmark(this.bytes, int payloadBytes)
    : super(
        'Codable canada.json (Mock Codegen DOM)',
        category: 'canada.json (GeoJSON)',
        payloadBytes: payloadBytes,
      );

  @override
  dynamic run() {
    final decoder = JsonCodableDecoder.fromBytes(bytes);
    return CanadaFeatureCollection.decode(decoder);
  }
}

// =============================================================================
// 3. citm_catalog.json (1.73 MB - Deeply Nested Objects, Strings, Maps)
// =============================================================================

final class NativeCitmBenchmark extends Benchmark {
  final String jsonStr;

  NativeCitmBenchmark(this.jsonStr, int payloadBytes)
    : super(
        'Native citm_catalog (jsonDecode -> Map)',
        category: 'citm_catalog.json (Relational)',
        payloadBytes: payloadBytes,
      );

  @override
  dynamic run() => jsonDecode(jsonStr);
}

final class CodableCitmBenchmark extends Benchmark {
  final Uint8List bytes;

  CodableCitmBenchmark(this.bytes, int payloadBytes)
    : super(
        'Codable citm_catalog (Mock Codegen DOM)',
        category: 'citm_catalog.json (Relational)',
        payloadBytes: payloadBytes,
      );

  @override
  dynamic run() {
    final decoder = JsonCodableDecoder.fromBytes(bytes);
    return CitmCatalog.decode(decoder);
  }
}

File _findBenchmarkDataFile(String relativePath) {
  final candidate1 = File(relativePath);
  if (candidate1.existsSync()) return candidate1;
  final candidate2 = File('pkgs/codable_benchmarks/$relativePath');
  if (candidate2.existsSync()) return candidate2;
  final scriptDir = File.fromUri(Platform.script).parent;
  final candidate3 = File('${scriptDir.path}/../$relativePath');
  if (candidate3.existsSync()) return candidate3;
  throw StateError(
    'Benchmark data file not found: "$relativePath". Tried paths: '
    '"${candidate1.path}", "${candidate2.path}", "${candidate3.path}".',
  );
}

void main(List<String> args) {
  String? outputPath;
  for (final arg in args) {
    if (arg.startsWith('--output=')) {
      outputPath = arg.substring('--output='.length);
    }
  }

  // Default output path if not specified
  outputPath ??= 'benchmark/results/current_run.json';

  final runner = BenchmarkRunner(
    config: BenchmarkConfig(
      targetSampleMicros: 20000,
      warmupSamples: 3,
      sampleRuns: 10,
      outputPath: outputPath,
    ),
  );

  print('=' * 72);
  print('End-to-End Serialization Throughput Benchmark (In-Tree Harness)');
  print('${'=' * 72}\n');

  // 1. Coordinates (10,000 points)
  final coordsList = List.generate(
    10000,
    (i) => '{"lat": 34.012345, "lon": -118.098765}',
  ).join(',');
  final coordsJson = '[$coordsList]';
  final coordsBytes = utf8.encode(coordsJson);
  final coordsPayloadBytes = coordsBytes.length;

  print('[1] 10,000 Coordinates Deserialization (390 KB):');
  runner.add(NativeCoordinateBenchmark(coordsJson, coordsPayloadBytes));
  runner.add(CodableCoordinateBenchmark(coordsBytes, coordsPayloadBytes));

  // 2. canada.json
  final canadaFile = _findBenchmarkDataFile('benchmark/data/canada.json');
  final canadaStr = canadaFile.readAsStringSync();
  final canadaBytes = canadaFile.readAsBytesSync();
  final canadaPayloadBytes = canadaBytes.length;

  print('\n[2] canada.json (GeoJSON Polygons / 2.25 MB):');
  runner.add(NativeCanadaBenchmark(canadaStr, canadaPayloadBytes));
  runner.add(CodableCanadaBenchmark(canadaBytes, canadaPayloadBytes));

  // 3. citm_catalog.json
  final citmFile = _findBenchmarkDataFile('benchmark/data/citm_catalog.json');
  final citmStr = citmFile.readAsStringSync();
  final citmBytes = citmFile.readAsBytesSync();
  final citmPayloadBytes = citmBytes.length;

  print('\n[3] citm_catalog.json (Relational Catalog / 1.73 MB):');
  runner.add(NativeCitmBenchmark(citmStr, citmPayloadBytes));
  runner.add(CodableCitmBenchmark(citmBytes, citmPayloadBytes));

  print('\nRunning benchmarks with multi-sample auto-calibration...\n');
  runner.runSuite(suiteName: 'End-to-End Serialization Benchmarks');
}
