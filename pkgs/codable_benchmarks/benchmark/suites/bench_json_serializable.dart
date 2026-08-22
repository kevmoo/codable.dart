// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:typed_data';

import 'package:args/args.dart';
import 'package:codable_benchmarks/harness.dart';

import '../data/embedded_datasets.dart';
import '../models/json_serializable/canada.dart';
import '../models/json_serializable/citm_catalog.dart';
import '../models/json_serializable/coordinate.dart';
import '../models/json_serializable/small.dart';
import '../models/json_serializable/twitter.dart';

final utf8JsonDecoder = utf8.decoder.fuse(json.decoder);
final utf8JsonEncoder = json.encoder.fuse(utf8.encoder);

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
  final engineLabel = args['engine-label'] as String;
  final outputJson = args['json'] as bool;

  final results = <BenchmarkResult>[];

  final datasets = targetDataset == 'all'
      ? ['coordinates', 'canada', 'citm_catalog', 'small', 'twitter']
      : [targetDataset];

  final modes = targetMode == 'all'
      ? ['decode', 'decode_literal', 'encode']
      : [targetMode];

  for (final dataset in datasets) {
    for (final mode in modes) {
      final res = runBenchmark(dataset, mode, engineLabel);
      results.add(res);
      if (!outputJson) {
        final stdDevStr = '±${res.stdDevMs.toStringAsFixed(3)}';
        print(
          '[${res.engine}] ${res.dataset.padRight(14)} ${res.mode.padRight(15)}: '
          '${res.latencyMs.toStringAsFixed(3).padLeft(8)} ms ($stdDevStr ms) | '
          '${res.throughputMbS.toStringAsFixed(2).padLeft(8)} MB/s',
        );
      }
    }
  }

  if (outputJson) {
    print(jsonEncode(results.map((r) => r.toJson()).toList()));
  }
}

BenchmarkResult runBenchmark(String dataset, String mode, String engineLabel) {
  final bytes = getDatasetBytes(dataset);
  final fileBytes = bytes.length;
  final jsonString = utf8.decode(bytes);

  // Pre-decode model for encode benchmarks
  dynamic preDecodedModel;
  if (mode == 'encode') {
    switch (dataset) {
      case 'coordinates':
        final list = jsonDecode(jsonString) as List<dynamic>;
        preDecodedModel = list
            .map((e) => Coordinate.fromJson(e as Map<String, dynamic>))
            .toList();
        break;
      case 'canada':
        preDecodedModel = CanadaFeatureCollection.fromJson(
          jsonDecode(jsonString) as Map<String, dynamic>,
        );
        break;
      case 'citm_catalog':
        preDecodedModel = CitmCatalog.fromJson(
          jsonDecode(jsonString) as Map<String, dynamic>,
        );
        break;
      case 'small':
        preDecodedModel = SmallDocument.fromJson(
          jsonDecode(jsonString) as Map<String, dynamic>,
        );
        break;
      case 'twitter':
        preDecodedModel = TwitterResponse.fromJson(
          jsonDecode(jsonString) as Map<String, dynamic>,
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
            final dynamic jsonAst = utf8JsonDecoder.convert(bytes);
            final list = (jsonAst as List<dynamic>)
                .map((e) => Coordinate.fromJson(e as Map<String, dynamic>))
                .toList();
            blackhole(list);
          };
          break;
        case 'canada':
          benchmarkWork = () {
            final dynamic jsonAst = utf8JsonDecoder.convert(bytes);
            final model = CanadaFeatureCollection.fromJson(
              jsonAst as Map<String, dynamic>,
            );
            blackhole(model);
          };
          break;
        case 'citm_catalog':
          benchmarkWork = () {
            final dynamic jsonAst = utf8JsonDecoder.convert(bytes);
            final model = CitmCatalog.fromJson(jsonAst as Map<String, dynamic>);
            blackhole(model);
          };
          break;
        case 'small':
          benchmarkWork = () {
            final dynamic jsonAst = utf8JsonDecoder.convert(bytes);
            final model = SmallDocument.fromJson(
              jsonAst as Map<String, dynamic>,
            );
            blackhole(model);
          };
          break;
        case 'twitter':
          benchmarkWork = () {
            final dynamic jsonAst = utf8JsonDecoder.convert(bytes);
            final model = TwitterResponse.fromJson(
              jsonAst as Map<String, dynamic>,
            );
            blackhole(model);
          };
          break;
        default:
          throw ArgumentError('Unknown dataset: $dataset');
      }
      break;

    case 'decode_literal':
      switch (dataset) {
        case 'coordinates':
          benchmarkWork = () {
            final dynamic jsonAst = jsonDecode(jsonString);
            final list = (jsonAst as List<dynamic>)
                .map((e) => Coordinate.fromJson(e as Map<String, dynamic>))
                .toList();
            blackhole(list);
          };
          break;
        case 'canada':
          benchmarkWork = () {
            final dynamic jsonAst = jsonDecode(jsonString);
            final model = CanadaFeatureCollection.fromJson(
              jsonAst as Map<String, dynamic>,
            );
            blackhole(model);
          };
          break;
        case 'citm_catalog':
          benchmarkWork = () {
            final dynamic jsonAst = jsonDecode(jsonString);
            final model = CitmCatalog.fromJson(jsonAst as Map<String, dynamic>);
            blackhole(model);
          };
          break;
        case 'small':
          benchmarkWork = () {
            final dynamic jsonAst = jsonDecode(jsonString);
            final model = SmallDocument.fromJson(
              jsonAst as Map<String, dynamic>,
            );
            blackhole(model);
          };
          break;
        case 'twitter':
          benchmarkWork = () {
            final dynamic jsonAst = jsonDecode(jsonString);
            final model = TwitterResponse.fromJson(
              jsonAst as Map<String, dynamic>,
            );
            blackhole(model);
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
            final mapList = list.map((e) => e.toJson()).toList();
            final outBytes = utf8JsonEncoder.convert(mapList);
            blackhole(outBytes);
          };
          break;
        case 'canada':
          final model = preDecodedModel as CanadaFeatureCollection;
          benchmarkWork = () {
            final outBytes = utf8JsonEncoder.convert(model.toJson());
            blackhole(outBytes);
          };
          break;
        case 'citm_catalog':
          final model = preDecodedModel as CitmCatalog;
          benchmarkWork = () {
            final outBytes = utf8JsonEncoder.convert(model.toJson());
            blackhole(outBytes);
          };
          break;
        case 'small':
          final model = preDecodedModel as SmallDocument;
          benchmarkWork = () {
            final outBytes = utf8JsonEncoder.convert(model.toJson());
            blackhole(outBytes);
          };
          break;
        case 'twitter':
          final model = preDecodedModel as TwitterResponse;
          benchmarkWork = () {
            final outBytes = utf8JsonEncoder.convert(model.toJson());
            blackhole(outBytes);
          };
          break;
        default:
          throw ArgumentError('Unknown dataset: $dataset');
      }
      break;

    default:
      throw ArgumentError('Unknown mode: $mode');
  }

  final runner = BenchmarkRunner(
    dataset: dataset,
    mode: mode,
    engine: engineLabel,
    fileBytes: fileBytes,
  );

  return runner.run(benchmarkWork);
}
