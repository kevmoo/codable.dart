import 'dart:convert';
import 'dart:io';

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:codable/codable_json.dart';

import 'models/codable/canada.dart';
import 'models/codable/citm_catalog.dart';
import 'models/codable/coordinate.dart';

int blackholeSink = 0;

@pragma('vm:never-inline')
void consumeBlackBox(Object? value) {
  blackholeSink ^= value.hashCode;
}

// =============================================================================
// 1. Coordinate List (10,000 Items)
// =============================================================================

class NativeCoordinateBenchmark extends BenchmarkBase {
  final String jsonStr;

  NativeCoordinateBenchmark(this.jsonStr)
    : super('Native Coordinate (jsonDecode + Map)'.padRight(42));

  @override
  void run() {
    var hash = 0;
    final list = jsonDecode(jsonStr) as List<dynamic>;
    for (var item in list) {
      final map = item as Map<String, dynamic>;
      final c = Coordinate(
        latitude: (map['latitude'] ?? map['lat']) as double,
        longitude: (map['longitude'] ?? map['lon']) as double,
      );
      hash ^= c.hashCode;
    }
    consumeBlackBox(hash);
  }
}

class CodableCoordinateBenchmark extends BenchmarkBase {
  final Uint8List bytes;

  CodableCoordinateBenchmark(this.bytes)
    : super('Codable Coordinate (Mock Codegen)     '.padRight(42));

  @override
  void run() {
    var hash = 0;
    final decoder = JsonCodableDecoder.fromBytes(bytes);
    final unkeyed = decoder.unkeyed();
    while (unkeyed.hasNext()) {
      hash ^= Coordinate.decode(decoder).hashCode;
    }
    consumeBlackBox(hash);
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
    consumeBlackBox(obj);
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
    consumeBlackBox(fc);
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
    consumeBlackBox(obj);
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
    consumeBlackBox(catalog);
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
