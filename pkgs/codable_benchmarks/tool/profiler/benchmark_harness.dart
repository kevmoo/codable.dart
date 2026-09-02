// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:bench_press/bench_press.dart';
import 'package:codable/codable_json.dart';

import 'package:codable_benchmarks/src/data/embedded_datasets.dart';
import 'package:codable_benchmarks/src/models/codable/canada.dart'
    as codable_canada;
import 'package:codable_benchmarks/src/models/codable/citm_catalog.dart'
    as codable_citm;
import 'package:codable_benchmarks/src/models/codable/coordinate.dart'
    as codable_coord;
import 'package:codable_benchmarks/src/models/codable/small.dart'
    as codable_small;
import 'package:codable_benchmarks/src/models/codable/twitter.dart'
    as codable_twitter;
import 'package:codable_benchmarks/src/models/json_serializable/canada.dart'
    as js_canada;
import 'package:codable_benchmarks/src/models/json_serializable/citm_catalog.dart'
    as js_citm;
import 'package:codable_benchmarks/src/models/json_serializable/coordinate.dart'
    as js_coord;
import 'package:codable_benchmarks/src/models/json_serializable/small.dart'
    as js_small;
import 'package:codable_benchmarks/src/models/json_serializable/twitter.dart'
    as js_twitter;

final utf8JsonDecoder = utf8.decoder.fuse(json.decoder);
final utf8JsonEncoder = json.encoder.fuse(utf8.encoder);

// Pre-decoded models for encode benchmarks (evaluated lazily on first access)
final _coordinatesCodable = codable_coord.Coordinate.decodeList(
  JsonCodableDecoder.fromBytes(coordinatesBytes),
);
final _coordinatesJs =
    (jsonDecode(utf8.decode(coordinatesBytes)) as List<dynamic>)
        .map((e) => js_coord.Coordinate.fromJson(e as Map<String, dynamic>))
        .toList();

final _canadaCodable = codable_canada.CanadaFeatureCollection.decode(
  JsonCodableDecoder.fromBytes(canadaBytes),
);
final _canadaJs = js_canada.CanadaFeatureCollection.fromJson(
  jsonDecode(utf8.decode(canadaBytes)) as Map<String, dynamic>,
);

final _citmCodable = codable_citm.CitmCatalog.decode(
  JsonCodableDecoder.fromBytes(citmBytes),
);
final _citmJs = js_citm.CitmCatalog.fromJson(
  jsonDecode(utf8.decode(citmBytes)) as Map<String, dynamic>,
);

final _smallCodable = codable_small.SmallDocument.decode(
  JsonCodableDecoder.fromBytes(smallBytes),
);
final _smallJs = js_small.SmallDocument.fromJson(
  jsonDecode(utf8.decode(smallBytes)) as Map<String, dynamic>,
);

final _twitterCodable = codable_twitter.TwitterResponse.decode(
  JsonCodableDecoder.fromBytes(twitterBytes),
);
final _twitterJs = js_twitter.TwitterResponse.fromJson(
  jsonDecode(utf8.decode(twitterBytes)) as Map<String, dynamic>,
);

const supportedBenchmarks = [
  'twitter_decode',
  'citm_catalog_decode',
  'canada_decode',
  'coordinates_decode',
  'small_decode',
  'twitter_encode',
  'citm_catalog_encode',
  'canada_encode',
  'coordinates_encode',
  'small_encode',
];

int defaultIterationsFor(String benchmark) {
  final normalized = benchmark.toLowerCase().replaceAll('-', '_');
  if (normalized.startsWith('small')) return 20000;
  if (normalized.startsWith('twitter')) return 500;
  if (normalized.startsWith('citm')) return 200;
  if (normalized.startsWith('canada')) return 100;
  if (normalized.startsWith('coord')) return 300;
  return 500;
}

JsonCodableDecoder _createDecoder(Uint8List bytes, String impl) {
  if (impl == 'codable_reader' || impl == 'reader') {
    return JsonCodableDecoder.fromReader(JsonTokenReader.fromBytes(bytes));
  }
  return JsonCodableDecoder.fromBytes(bytes);
}

void Function() resolveBenchmarkAction(
  String benchmark, {
  String impl = 'codable',
}) {
  final isJsonSerializable = impl.toLowerCase() == 'json_serializable';
  final isCodable = !isJsonSerializable;
  final normalized = benchmark.toLowerCase().replaceAll('-', '_');

  return switch (normalized) {
    'twitter_decode' || 'twitter' =>
      isJsonSerializable
          ? () {
              final dynamic jsonAst = utf8JsonDecoder.convert(twitterBytes);
              final model = js_twitter.TwitterResponse.fromJson(
                jsonAst as Map<String, dynamic>,
              );
              Blackhole.consume(model);
            }
          : () {
              final decoder = _createDecoder(twitterBytes, impl);
              final model = codable_twitter.TwitterResponse.decode(decoder);
              Blackhole.consume(model);
            },

    'citm_catalog_decode' || 'citm_catalog' || 'citm_decode' || 'citm' =>
      isJsonSerializable
          ? () {
              final dynamic jsonAst = utf8JsonDecoder.convert(citmBytes);
              final model = js_citm.CitmCatalog.fromJson(
                jsonAst as Map<String, dynamic>,
              );
              Blackhole.consume(model);
            }
          : () {
              final decoder = _createDecoder(citmBytes, impl);
              final model = codable_citm.CitmCatalog.decode(decoder);
              Blackhole.consume(model);
            },

    'canada_decode' || 'canada' =>
      isJsonSerializable
          ? () {
              final dynamic jsonAst = utf8JsonDecoder.convert(canadaBytes);
              final model = js_canada.CanadaFeatureCollection.fromJson(
                jsonAst as Map<String, dynamic>,
              );
              Blackhole.consume(model);
            }
          : () {
              final decoder = _createDecoder(canadaBytes, impl);
              final model = codable_canada.CanadaFeatureCollection.decode(
                decoder,
              );
              Blackhole.consume(model);
            },

    'coordinates_decode' || 'coordinates' || 'coord_decode' || 'coord' =>
      isJsonSerializable
          ? () {
              final dynamic jsonAst = utf8JsonDecoder.convert(coordinatesBytes);
              final list = (jsonAst as List<dynamic>)
                  .map(
                    (e) =>
                        js_coord.Coordinate.fromJson(e as Map<String, dynamic>),
                  )
                  .toList();
              Blackhole.consume(list);
            }
          : () {
              final list = codable_coord.Coordinate.decodeList(
                _createDecoder(coordinatesBytes, impl),
              );
              Blackhole.consume(list);
            },

    'small_decode' || 'small' =>
      isJsonSerializable
          ? () {
              final dynamic jsonAst = utf8JsonDecoder.convert(smallBytes);
              final model = js_small.SmallDocument.fromJson(
                jsonAst as Map<String, dynamic>,
              );
              Blackhole.consume(model);
            }
          : () {
              final decoder = _createDecoder(smallBytes, impl);
              final model = codable_small.SmallDocument.decode(decoder);
              Blackhole.consume(model);
            },

    'twitter_encode' =>
      isCodable
          ? () {
              final outBytes = JsonCodableEncoder.toBytes(
                _twitterCodable.encode,
              );
              Blackhole.consume(outBytes);
            }
          : () {
              final outBytes = utf8JsonEncoder.convert(_twitterJs.toJson());
              Blackhole.consume(outBytes);
            },

    'citm_catalog_encode' || 'citm_encode' =>
      isCodable
          ? () {
              final outBytes = JsonCodableEncoder.toBytes(_citmCodable.encode);
              Blackhole.consume(outBytes);
            }
          : () {
              final outBytes = utf8JsonEncoder.convert(_citmJs.toJson());
              Blackhole.consume(outBytes);
            },

    'canada_encode' =>
      isCodable
          ? () {
              final outBytes = JsonCodableEncoder.toBytes(
                _canadaCodable.encode,
              );
              Blackhole.consume(outBytes);
            }
          : () {
              final outBytes = utf8JsonEncoder.convert(_canadaJs.toJson());
              Blackhole.consume(outBytes);
            },

    'coordinates_encode' || 'coord_encode' =>
      isCodable
          ? () {
              final outBytes = JsonCodableEncoder.toBytes((e) {
                final unkeyed = e.unkeyed();
                for (var i = 0; i < _coordinatesCodable.length; i++) {
                  unkeyed.encodeEncodable(_coordinatesCodable[i]);
                }
              });
              Blackhole.consume(outBytes);
            }
          : () {
              final mapList = _coordinatesJs.map((e) => e.toJson()).toList();
              final outBytes = utf8JsonEncoder.convert(mapList);
              Blackhole.consume(outBytes);
            },

    'small_encode' =>
      isCodable
          ? () {
              final outBytes = JsonCodableEncoder.toBytes(_smallCodable.encode);
              Blackhole.consume(outBytes);
            }
          : () {
              final outBytes = utf8JsonEncoder.convert(_smallJs.toJson());
              Blackhole.consume(outBytes);
            },

    _ => throw ArgumentError(
      'Unknown benchmark "$benchmark". Supported: '
      '${supportedBenchmarks.join(', ')}.',
    ),
  };
}

void runBenchmark(
  String benchmark, {
  int? iterations,
  String impl = 'codable',
  int warmupIterations = 5,
}) {
  final count = iterations ?? defaultIterationsFor(benchmark);
  final action = resolveBenchmarkAction(benchmark, impl: impl);

  // Warmup
  for (var i = 0; i < warmupIterations; i++) {
    action();
  }

  // Measurement Loop
  for (var i = 0; i < count; i++) {
    action();
  }
}

void main(List<String> args) {
  final benchmark = args.isNotEmpty ? args[0] : 'twitter_decode';
  final count = args.length > 1
      ? int.tryParse(args[1]) ?? defaultIterationsFor(benchmark)
      : defaultIterationsFor(benchmark);
  final impl = args.length > 2 ? args[2] : 'codable';

  print('Executing $benchmark ($impl) x $count iterations...');
  final sw = Stopwatch()..start();
  runBenchmark(benchmark, iterations: count, impl: impl);
  sw.stop();
  final avgUs = (sw.elapsedMicroseconds / count).toStringAsFixed(1);
  print('Finished in ${sw.elapsedMilliseconds} ms ($avgUs us/iter).');
}
