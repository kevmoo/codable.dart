// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:typed_data';

import 'package:args/args.dart';

import '../data/embedded_datasets.dart';
import '../models/json_serializable/canada.dart';
import '../models/json_serializable/citm_catalog.dart';
import '../models/json_serializable/coordinate.dart';
import '../models/json_serializable/small.dart';
import '../models/json_serializable/twitter.dart';

int blackholeSink = 0;

final utf8JsonDecoder = utf8.decoder.fuse(json.decoder);
final utf8JsonEncoder = json.encoder.fuse(utf8.encoder);

@pragma('vm:never-inline')
void consumeBlackBox(Object? value) {
  if (value is List<Coordinate>) {
    for (var i = 0; i < value.length; i++) {
      blackholeSink ^= value[i].latitude.toInt() ^ value[i].longitude.toInt();
    }
  } else if (value is CanadaFeatureCollection) {
    blackholeSink ^= value.features.length;
    for (var i = 0; i < value.features.length; i++) {
      final f = value.features[i];
      blackholeSink ^= f.properties.name.length;
      final coords = f.geometry.coordinates;
      for (var j = 0; j < coords.length; j++) {
        final poly = coords[j];
        for (var k = 0; k < poly.length; k++) {
          final pt = poly[k];
          for (var l = 0; l < pt.length; l++) {
            blackholeSink ^= pt[l].toInt();
          }
        }
      }
    }
  } else if (value is CitmCatalog) {
    blackholeSink ^= value.events.length ^ value.performances.length;
    for (var i = 0; i < value.performances.length; i++) {
      final p = value.performances[i];
      blackholeSink ^= p.id ^ p.eventId ^ p.prices.length;
    }
  } else if (value is SmallDocument) {
    blackholeSink ^= value.id ^ value.name.length ^ value.metadata.loginCount;
  } else if (value is TwitterResponse) {
    blackholeSink ^= value.statuses.length ^ value.searchMetadata.count;
    for (var i = 0; i < value.statuses.length; i++) {
      final s = value.statuses[i];
      blackholeSink ^= s.id ^ s.text.length ^ (s.user?.followersCount ?? 0);
    }
  } else if (value is Uint8List) {
    blackholeSink ^=
        value.length ^
        (value.isNotEmpty ? value[0] ^ value[value.length - 1] : 0);
  } else {
    blackholeSink ^= value.hashCode;
  }
}

class BenchResult {
  final String dataset;
  final String mode;
  final String engine;
  final int iterations;
  final int fileBytes;
  final double latencyMs;
  final double throughputMbS;

  BenchResult({
    required this.dataset,
    required this.mode,
    required this.engine,
    required this.iterations,
    required this.fileBytes,
    required this.latencyMs,
    required this.throughputMbS,
  });

  Map<String, dynamic> toJson() => {
    'dataset': dataset,
    'mode': mode,
    'engine': engine,
    'iterations': iterations,
    'file_bytes': fileBytes,
    'latency_ms': double.parse(latencyMs.toStringAsFixed(3)),
    'throughput_mb_s': double.parse(throughputMbS.toStringAsFixed(2)),
  };
}

void main(List<String> rawArgs) {
  final parser = ArgParser()
    ..addOption(
      'dataset',
      abbr: 'd',
      defaultsTo: 'all',
      allowed: [
        'coordinates',
        'canada',
        'citm_catalog',
        'small',
        'twitter',
        'all',
      ],
    )
    ..addOption(
      'mode',
      abbr: 'm',
      defaultsTo: 'all',
      allowed: ['decode', 'decode_literal', 'encode', 'all'],
    )
    ..addOption('iterations', abbr: 'n', defaultsTo: '50')
    ..addOption('warmup', abbr: 'w', defaultsTo: '5')
    ..addOption('engine-label', defaultsTo: 'dart_json_serializable')
    ..addFlag('json', defaultsTo: false);

  final args = parser.parse(rawArgs);
  final targetDataset = args['dataset'] as String;
  final targetMode = args['mode'] as String;
  final defaultIters = int.parse(args['iterations'] as String);
  final defaultWarmup = int.parse(args['warmup'] as String);
  final engineLabel = args['engine-label'] as String;
  final outputJson = args['json'] as bool;

  final results = <BenchResult>[];

  final datasets = targetDataset == 'all'
      ? ['coordinates', 'canada', 'citm_catalog', 'small', 'twitter']
      : [targetDataset];

  final modes = targetMode == 'all'
      ? ['decode', 'decode_literal', 'encode']
      : [targetMode];

  for (final dataset in datasets) {
    for (final mode in modes) {
      final iters = dataset == 'coordinates' ? defaultIters * 5 : defaultIters;
      final warmup = dataset == 'coordinates'
          ? defaultWarmup * 5
          : defaultWarmup;
      final res = runBenchmark(dataset, mode, iters, warmup, engineLabel);
      results.add(res);
      if (!outputJson) {
        print(
          '[${res.engine}] ${res.dataset.padRight(14)} ${res.mode.padRight(15)}: '
          '${res.latencyMs.toStringAsFixed(3).padLeft(8)} ms | '
          '${res.throughputMbS.toStringAsFixed(2).padLeft(8)} MB/s',
        );
      }
    }
  }

  if (outputJson) {
    print(jsonEncode(results.map((r) => r.toJson()).toList()));
  }
}

BenchResult runBenchmark(
  String dataset,
  String mode,
  int iterations,
  int warmup,
  String engineLabel,
) {
  final bytes = getDatasetBytes(dataset);
  final fileBytes = bytes.length;

  // Pre-decode for literal hydration and encoding
  dynamic preDecodedDom;
  dynamic preDecodedModel;

  if (mode == 'decode_literal' || mode == 'encode') {
    preDecodedDom = utf8JsonDecoder.convert(bytes);
    switch (dataset) {
      case 'coordinates':
        final list = preDecodedDom as List<dynamic>;
        preDecodedModel = list
            .map((e) => Coordinate.fromJson(e as Map<String, dynamic>))
            .toList();
        break;
      case 'canada':
        preDecodedModel = CanadaFeatureCollection.fromJson(
          preDecodedDom as Map<String, dynamic>,
        );
        break;
      case 'citm_catalog':
        preDecodedModel = CitmCatalog.fromJson(
          preDecodedDom as Map<String, dynamic>,
        );
        break;
      case 'small':
        preDecodedModel = SmallDocument.fromJson(
          preDecodedDom as Map<String, dynamic>,
        );
        break;
      case 'twitter':
        preDecodedModel = TwitterResponse.fromJson(
          preDecodedDom as Map<String, dynamic>,
        );
        break;
    }
  }

  void Function() benchmarkWork;

  switch (mode) {
    case 'decode':
      switch (dataset) {
        case 'coordinates':
          benchmarkWork = () {
            final dom = utf8JsonDecoder.convert(bytes) as List<dynamic>;
            final list = <Coordinate>[];
            for (var i = 0; i < dom.length; i++) {
              list.add(Coordinate.fromJson(dom[i] as Map<String, dynamic>));
            }
            consumeBlackBox(list);
          };
          break;
        case 'canada':
          benchmarkWork = () {
            final dom = utf8JsonDecoder.convert(bytes) as Map<String, dynamic>;
            final model = CanadaFeatureCollection.fromJson(dom);
            consumeBlackBox(model);
          };
          break;
        case 'citm_catalog':
          benchmarkWork = () {
            final dom = utf8JsonDecoder.convert(bytes) as Map<String, dynamic>;
            final model = CitmCatalog.fromJson(dom);
            consumeBlackBox(model);
          };
          break;
        case 'small':
          benchmarkWork = () {
            final dom = utf8JsonDecoder.convert(bytes) as Map<String, dynamic>;
            final model = SmallDocument.fromJson(dom);
            consumeBlackBox(model);
          };
          break;
        case 'twitter':
          benchmarkWork = () {
            final dom = utf8JsonDecoder.convert(bytes) as Map<String, dynamic>;
            final model = TwitterResponse.fromJson(dom);
            consumeBlackBox(model);
          };
          break;
        default:
          throw ArgumentError('Unknown dataset: $dataset');
      }
      break;

    case 'decode_literal':
      switch (dataset) {
        case 'coordinates':
          final dom = preDecodedDom as List<dynamic>;
          benchmarkWork = () {
            final list = <Coordinate>[];
            for (var i = 0; i < dom.length; i++) {
              list.add(Coordinate.fromJson(dom[i] as Map<String, dynamic>));
            }
            consumeBlackBox(list);
          };
          break;
        case 'canada':
          final dom = preDecodedDom as Map<String, dynamic>;
          benchmarkWork = () {
            final model = CanadaFeatureCollection.fromJson(dom);
            consumeBlackBox(model);
          };
          break;
        case 'citm_catalog':
          final dom = preDecodedDom as Map<String, dynamic>;
          benchmarkWork = () {
            final model = CitmCatalog.fromJson(dom);
            consumeBlackBox(model);
          };
          break;
        case 'small':
          final dom = preDecodedDom as Map<String, dynamic>;
          benchmarkWork = () {
            final model = SmallDocument.fromJson(dom);
            consumeBlackBox(model);
          };
          break;
        case 'twitter':
          final dom = preDecodedDom as Map<String, dynamic>;
          benchmarkWork = () {
            final model = TwitterResponse.fromJson(dom);
            consumeBlackBox(model);
          };
          break;
        default:
          throw ArgumentError('Unknown dataset: $dataset');
      }
      break;

    case 'encode':
      switch (dataset) {
        case 'coordinates':
          final list = preDecodedModel as List<Coordinate>;
          benchmarkWork = () {
            final dom = list.map((c) => c.toJson()).toList();
            final outBytes = utf8JsonEncoder.convert(dom);
            consumeBlackBox(Uint8List.fromList(outBytes));
          };
          break;
        case 'canada':
          final model = preDecodedModel as CanadaFeatureCollection;
          benchmarkWork = () {
            final dom = model.toJson();
            final outBytes = utf8JsonEncoder.convert(dom);
            consumeBlackBox(Uint8List.fromList(outBytes));
          };
          break;
        case 'citm_catalog':
          final model = preDecodedModel as CitmCatalog;
          benchmarkWork = () {
            final dom = model.toJson();
            final outBytes = utf8JsonEncoder.convert(dom);
            consumeBlackBox(Uint8List.fromList(outBytes));
          };
          break;
        case 'small':
          final model = preDecodedModel as SmallDocument;
          benchmarkWork = () {
            final dom = model.toJson();
            final outBytes = utf8JsonEncoder.convert(dom);
            consumeBlackBox(Uint8List.fromList(outBytes));
          };
          break;
        case 'twitter':
          final model = preDecodedModel as TwitterResponse;
          benchmarkWork = () {
            final dom = model.toJson();
            final outBytes = utf8JsonEncoder.convert(dom);
            consumeBlackBox(Uint8List.fromList(outBytes));
          };
          break;
        default:
          throw ArgumentError('Unknown dataset: $dataset');
      }
      break;

    default:
      throw ArgumentError('Unknown mode: $mode');
  }

  // Warmup
  for (var i = 0; i < warmup; i++) {
    benchmarkWork();
  }

  // Measurement
  final sw = Stopwatch()..start();
  for (var i = 0; i < iterations; i++) {
    benchmarkWork();
  }
  sw.stop();

  final totalElapsedMicroseconds = sw.elapsedMicroseconds;
  final avgMicroseconds = totalElapsedMicroseconds / iterations;
  final latencyMs = avgMicroseconds / 1000.0;
  final latencySeconds = avgMicroseconds / 1000000.0;
  final throughputMbS = (fileBytes / (1024 * 1024)) / latencySeconds;

  return BenchResult(
    dataset: dataset,
    mode: mode,
    engine: engineLabel,
    iterations: iterations,
    fileBytes: fileBytes,
    latencyMs: latencyMs,
    throughputMbS: throughputMbS,
  );
}
