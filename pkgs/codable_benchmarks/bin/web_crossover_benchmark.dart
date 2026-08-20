import 'dart:convert';
import 'dart:typed_data';

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:codable/src/driver/json_codable_driver.dart';

import '../benchmark/data/embedded_datasets.dart';
import '../benchmark/models/codable/small.dart';
import '../benchmark/models/codable/coordinate.dart';
import '../benchmark/models/codable/citm_catalog.dart';
import '../benchmark/models/codable/canada.dart';

int blackholeSink = 0;

@pragma('vm:never-inline')
void consumeBlackBox(Object? value) {
  blackholeSink ^= value.hashCode;
}

// -----------------------------------------------------------------------------
// Small Payload
// -----------------------------------------------------------------------------
class NativeSmallBenchmark extends BenchmarkBase {
  final String jsonStr;
  NativeSmallBenchmark(this.jsonStr)
    : super('Native Small (jsonDecode)       '.padRight(40));

  @override
  void run() {
    final map = jsonDecode(jsonStr) as Map<String, dynamic>;
    consumeBlackBox(map);
  }
}

class CodableSmallBenchmark extends BenchmarkBase {
  final Uint8List bytes;
  CodableSmallBenchmark(this.bytes)
    : super('Codable Small (JsonTokenReader) '.padRight(40));

  @override
  void run() {
    final decoder = JsonCodableDecoder.fromBytes(bytes);
    final doc = SmallDocument.decode(decoder);
    consumeBlackBox(doc);
  }
}

// -----------------------------------------------------------------------------
// Medium Payload
// -----------------------------------------------------------------------------
class NativeMediumBenchmark extends BenchmarkBase {
  final String jsonStr;
  NativeMediumBenchmark(this.jsonStr)
    : super('Native Medium (jsonDecode)      '.padRight(40));

  @override
  void run() {
    final list = jsonDecode(jsonStr) as List<dynamic>;
    consumeBlackBox(list);
  }
}

class CodableMediumBenchmark extends BenchmarkBase {
  final Uint8List bytes;
  CodableMediumBenchmark(this.bytes)
    : super('Codable Medium (JsonTokenReader)'.padRight(40));

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

// -----------------------------------------------------------------------------
// Large Payload (CitmCatalog)
// -----------------------------------------------------------------------------
class NativeLargeBenchmark extends BenchmarkBase {
  final String jsonStr;
  NativeLargeBenchmark(this.jsonStr)
    : super('Native Large (jsonDecode)       '.padRight(40));

  @override
  void run() {
    final map = jsonDecode(jsonStr) as Map<String, dynamic>;
    consumeBlackBox(map);
  }
}

class CodableLargeBenchmark extends BenchmarkBase {
  final Uint8List bytes;
  CodableLargeBenchmark(this.bytes)
    : super('Codable Large (JsonTokenReader) '.padRight(40));

  @override
  void run() {
    final decoder = JsonCodableDecoder.fromBytes(bytes);
    final catalog = CitmCatalog.decode(decoder);
    consumeBlackBox(catalog);
  }
}

// -----------------------------------------------------------------------------
// Large Payload Geo (Canada)
// -----------------------------------------------------------------------------
class NativeGeoBenchmark extends BenchmarkBase {
  final String jsonStr;
  NativeGeoBenchmark(this.jsonStr)
    : super('Native Geo (jsonDecode)         '.padRight(40));

  @override
  void run() {
    final map = jsonDecode(jsonStr) as Map<String, dynamic>;
    consumeBlackBox(map);
  }
}

class CodableGeoBenchmark extends BenchmarkBase {
  final Uint8List bytes;
  CodableGeoBenchmark(this.bytes)
    : super('Codable Geo (JsonTokenReader)   '.padRight(40));

  @override
  void run() {
    final decoder = JsonCodableDecoder.fromBytes(bytes);
    final catalog = CanadaFeatureCollection.decode(decoder);
    consumeBlackBox(catalog);
  }
}

void main() {
  print(
    '========================================================================',
  );
  print('Web Engine Crossover Benchmark: JSON.parse vs. pure-Dart scanning');
  print(
    '========================================================================',
  );

  final smallBytes = getDatasetBytes('small');
  final smallStr = utf8.decode(smallBytes);
  print('\n[1] Small Payload (${smallStr.length} bytes):');
  NativeSmallBenchmark(smallStr).report();
  CodableSmallBenchmark(smallBytes).report();

  final coordsBytes = getDatasetBytes('coordinates');
  final coordsStr = utf8.decode(coordsBytes);
  print('\n[2] Medium Payload (${coordsBytes.length} bytes):');
  NativeMediumBenchmark(coordsStr).report();
  CodableMediumBenchmark(coordsBytes).report();

  final citmBytes = getDatasetBytes('citm_catalog');
  final citmStr = utf8.decode(citmBytes);
  print('\n[3] Large Payload (${citmBytes.length} bytes):');
  NativeLargeBenchmark(citmStr).report();
  CodableLargeBenchmark(citmBytes).report();

  final canadaBytes = getDatasetBytes('canada');
  final canadaStr = utf8.decode(canadaBytes);
  print('\n[4] Large Payload Geo (${canadaBytes.length} bytes):');
  NativeGeoBenchmark(canadaStr).report();
  CodableGeoBenchmark(canadaBytes).report();
}
