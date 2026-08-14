import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:codable/codable.dart';
import 'package:codable/src/driver/json_codable_driver.dart';

class Coordinate {
  final double latitude;
  final double longitude;

  const Coordinate({required this.latitude, required this.longitude});

  static Coordinate decode(Decoder decoder) {
    final keyed = decoder.keyed();
    double? lat;
    double? lon;

    while (keyed.hasNextKey()) {
      switch (keyed.nextKey()) {
        case 'latitude':
        case 'lat':
          lat = keyed.readDouble();
          break;
        case 'longitude':
        case 'lon':
          lon = keyed.readDouble();
          break;
        default:
          keyed.skipValue();
          break;
      }
    }

    if (lat == null || lon == null) {
      throw CodableException('Missing required fields for Coordinate');
    }
    return Coordinate(latitude: lat, longitude: lon);
  }

  @override
  void encode(Encoder encoder) {
    final keyed = encoder.keyed();
    keyed.encodeDouble('latitude', latitude);
    keyed.encodeDouble('longitude', longitude);
  }

  @override
  int get hashCode => Object.hash(latitude, longitude);
}

class NativeCoordinateBenchmark extends BenchmarkBase {
  final String jsonStr;
  late List<dynamic> _parsed;

  NativeCoordinateBenchmark(this.jsonStr)
    : super('Native Coordinate List          ');

  @override
  void run() {
    int hash = 0;
    final list = jsonDecode(jsonStr) as List<dynamic>;
    for (var item in list) {
      final c = Coordinate(
        latitude: item['latitude'] ?? item['lat'] as double,
        longitude: item['longitude'] ?? item['lon'] as double,
      );
      hash ^= c.hashCode;
    }
    if (hash == 0 && jsonStr.isEmpty) print('hash is 0');
  }
}

class CodableCoordinateBenchmark extends BenchmarkBase {
  final Uint8List bytes;

  CodableCoordinateBenchmark(this.bytes)
    : super('Codable Coordinate List         ');

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

class NativePayloadBenchmark extends BenchmarkBase {
  final String jsonStr;
  NativePayloadBenchmark(String name, this.jsonStr)
    : super('Native  $name'.padRight(32));

  @override
  void run() {
    final dynamic obj = jsonDecode(jsonStr);
    if (obj == null) print('null payload');
  }
}

class CodablePayloadBenchmark extends BenchmarkBase {
  final Uint8List bytes;
  CodablePayloadBenchmark(String name, this.bytes)
    : super('Codable $name'.padRight(32));

  @override
  void run() {
    final decoder = JsonCodableDecoder.fromBytes(bytes);
    final keyed = decoder.keyed();
    while (keyed.hasNextKey()) {
      keyed.nextKey();
      keyed.skipValue();
    }
  }
}

void main() {
  final coordsList = List.generate(
    10000,
    (i) => '{"lat": 34.0, "lon": -118.0}',
  ).join(',');
  final coordsJson = '[$coordsList]';
  final coordsBytes = utf8.encode(coordsJson) as Uint8List;

  print(
    '========================================================================',
  );
  print('JIT Benchmark (Run #1)');
  print(
    '========================================================================',
  );
  NativeCoordinateBenchmark(coordsJson).report();
  CodableCoordinateBenchmark(coordsBytes).report();

  final canadaFile = File('benchmark/data/canada.json');
  final citmFile = File('benchmark/data/citm_catalog.json');

  if (canadaFile.existsSync()) {
    final str = canadaFile.readAsStringSync();
    final bytes = canadaFile.readAsBytesSync();
    NativePayloadBenchmark('canada.json', str).report();
    CodablePayloadBenchmark('canada.json', bytes).report();
  }

  if (citmFile.existsSync()) {
    final str = citmFile.readAsStringSync();
    final bytes = citmFile.readAsBytesSync();
    NativePayloadBenchmark('citm_catalog.json', str).report();
    CodablePayloadBenchmark('citm_catalog.json', bytes).report();
  }
}
