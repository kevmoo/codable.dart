import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:codable/src/driver/json_codable_driver.dart';

import 'models/canada.dart';
import 'models/citm_catalog.dart';
import 'models/coordinate.dart';

// =============================================================================
// 1. Coordinate List (10,000 Items)
// =============================================================================

class NativeCoordinateBenchmark extends BenchmarkBase {
  final String jsonStr;

  NativeCoordinateBenchmark(this.jsonStr)
    : super('Native Coordinate (jsonDecode + Map)'.padRight(42));

  @override
  void run() {
    int hash = 0;
    final list = jsonDecode(jsonStr) as List<dynamic>;
    for (var item in list) {
      final map = item as Map<String, dynamic>;
      final c = Coordinate(
        latitude: (map['latitude'] ?? map['lat']) as double,
        longitude: (map['longitude'] ?? map['lon']) as double,
      );
      hash ^= c.hashCode;
    }
    if (hash == 0 && jsonStr.isEmpty) print('hash is 0');
  }
}

class CodableCoordinateBenchmark extends BenchmarkBase {
  final Uint8List bytes;

  CodableCoordinateBenchmark(this.bytes)
    : super('Codable Coordinate (Mock Codegen)     '.padRight(42));

  @override
  void run() {
    int hash = 0;
    final decoder = JsonCodableDecoder.fromBytes(bytes);
    final unkeyed = decoder.unkeyed();
    while (unkeyed.hasNext()) {
      hash ^= Coordinate.decode(decoder).hashCode;
    }
    if (hash == 0 && bytes.isEmpty) print('hash is 0');
  }
}

// =============================================================================
// 2. canada.json (536 KB GeoJSON - Coordinate Arrays & Float Operations)
// =============================================================================

class NativeCanadaBenchmark extends BenchmarkBase {
  final String jsonStr;

  NativeCanadaBenchmark(this.jsonStr)
    : super('Native canada.json (jsonDecode -> Map)'.padRight(42));

  @override
  void run() {
    final dynamic obj = jsonDecode(jsonStr);
    if (obj == null) print('null');
  }
}

class CodableCanadaBenchmark extends BenchmarkBase {
  final Uint8List bytes;

  CodableCanadaBenchmark(this.bytes)
    : super('Codable canada.json (Mock Codegen DOM) '.padRight(42));

  @override
  void run() {
    final decoder = JsonCodableDecoder.fromBytes(bytes);
    final fc = CanadaFeatureCollection.decode(decoder);
    if (fc.features.isEmpty && bytes.isEmpty) print('empty');
  }
}

// =============================================================================
// 3. citm_catalog.json (1.7 MB - Deeply Nested Objects, Strings, Maps)
// =============================================================================

class NativeCitmBenchmark extends BenchmarkBase {
  final String jsonStr;

  NativeCitmBenchmark(this.jsonStr)
    : super('Native citm_catalog (jsonDecode -> Map)'.padRight(42));

  @override
  void run() {
    final dynamic obj = jsonDecode(jsonStr);
    if (obj == null) print('null');
  }
}

class CodableCitmBenchmark extends BenchmarkBase {
  final Uint8List bytes;

  CodableCitmBenchmark(this.bytes)
    : super('Codable citm_catalog (Mock Codegen DOM)'.padRight(42));

  @override
  void run() {
    final decoder = JsonCodableDecoder.fromBytes(bytes);
    final catalog = CitmCatalog.decode(decoder);
    if (catalog.events.isEmpty && bytes.isEmpty) print('empty');
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
    'Benchmark data file not found: "$relativePath". Tried paths: "${candidate1.path}", "${candidate2.path}", "${candidate3.path}".',
  );
}

void main() {
  print(
    '========================================================================',
  );
  print('End-to-End Serialization Throughput Benchmark');
  print(
    '========================================================================',
  );

  // 1. Coordinates (10,000 points)
  final coordsList = List.generate(
    10000,
    (i) => '{"lat": 34.012345, "lon": -118.098765}',
  ).join(',');
  final coordsJson = '[$coordsList]';
  final coordsBytes = utf8.encode(coordsJson);

  print('\n[1] 10,000 Coordinates Deserialization:');
  NativeCoordinateBenchmark(coordsJson).report();
  CodableCoordinateBenchmark(coordsBytes).report();

  // 2. canada.json
  final canadaFile = _findBenchmarkDataFile('benchmark/data/canada.json');
  print('\n[2] canada.json (GeoJSON Polygons / Double Arrays):');
  final canadaStr = canadaFile.readAsStringSync();
  final canadaBytes = canadaFile.readAsBytesSync();
  NativeCanadaBenchmark(canadaStr).report();
  CodableCanadaBenchmark(canadaBytes).report();

  // 3. citm_catalog.json
  final citmFile = _findBenchmarkDataFile('benchmark/data/citm_catalog.json');
  print('\n[3] citm_catalog.json (Relational Catalog / Nested Objects):');
  final citmStr = citmFile.readAsStringSync();
  final citmBytes = citmFile.readAsBytesSync();
  NativeCitmBenchmark(citmStr).report();
  CodableCitmBenchmark(citmBytes).report();
}
