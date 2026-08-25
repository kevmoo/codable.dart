// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:args/args.dart';
import 'package:codable/codable_json.dart';
import 'package:codable_benchmarks/harness.dart';

import '../data/embedded_datasets.dart';
import '../models/codable/canada.dart';
import '../models/codable/citm_catalog.dart';
import '../models/codable/coordinate.dart';
import '../models/codable/small.dart';
import '../models/codable/twitter.dart';

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
    ..addOption('engine-label', defaultsTo: 'dart_codable_streaming')
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
          '[${res.engine}] ${res.dataset.padRight(14)} '
          '${res.mode.padRight(15)}: '
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

Object? _preDecodeModel(String dataset, Uint8List bytes) {
  return switch (dataset) {
    'coordinates' => () {
      final list = <Coordinate>[];
      final decoder = JsonCodableDecoder.fromBytes(bytes);
      final unkeyed = decoder.unkeyed();
      while (unkeyed.hasNext()) {
        list.add(unkeyed.decodeElement(Coordinate.decode));
      }
      return list;
    }(),
    'canada' => CanadaFeatureCollection.decode(
      JsonCodableDecoder.fromBytes(bytes),
    ),
    'citm_catalog' => CitmCatalog.decode(JsonCodableDecoder.fromBytes(bytes)),
    'small' => SmallDocument.decode(JsonCodableDecoder.fromBytes(bytes)),
    'twitter' => TwitterResponse.decode(JsonCodableDecoder.fromBytes(bytes)),
    _ => null,
  };
}

void Function() _createDecodeBenchmark(String dataset, Uint8List bytes) {
  return switch (dataset) {
    'coordinates' => () {
      final decoder = JsonCodableDecoder.fromBytes(bytes);
      final unkeyed = decoder.unkeyed();
      final list = <Coordinate>[];
      while (unkeyed.hasNext()) {
        list.add(unkeyed.decodeElement(Coordinate.decode));
      }
      blackhole(list);
    },
    'canada' => () {
      final decoder = JsonCodableDecoder.fromBytes(bytes);
      final model = CanadaFeatureCollection.decode(decoder);
      blackhole(model);
    },
    'citm_catalog' => () {
      final decoder = JsonCodableDecoder.fromBytes(bytes);
      final model = CitmCatalog.decode(decoder);
      blackhole(model);
    },
    'small' => () {
      final decoder = JsonCodableDecoder.fromBytes(bytes);
      final model = SmallDocument.decode(decoder);
      blackhole(model);
    },
    'twitter' => () {
      final decoder = JsonCodableDecoder.fromBytes(bytes);
      final model = TwitterResponse.decode(decoder);
      blackhole(model);
    },
    _ => throw ArgumentError('Unknown dataset: $dataset'),
  };
}

void Function() _createEncodeBenchmark(
  String dataset,
  Object? preDecodedModel,
) {
  return switch (dataset) {
    'coordinates' => () {
      final list = preDecodedModel as List<Coordinate>;
      final outBytes = JsonCodableEncoder.toBytes((e) {
        final unkeyed = e.unkeyed();
        for (var i = 0; i < list.length; i++) {
          unkeyed.encodeEncodable(list[i]);
        }
      });
      blackhole(outBytes);
    },
    'canada' => () {
      final model = preDecodedModel as CanadaFeatureCollection;
      final outBytes = JsonCodableEncoder.toBytes(model.encode);
      blackhole(outBytes);
    },
    'citm_catalog' => () {
      final model = preDecodedModel as CitmCatalog;
      final outBytes = JsonCodableEncoder.toBytes(model.encode);
      blackhole(outBytes);
    },
    'small' => () {
      final model = preDecodedModel as SmallDocument;
      final outBytes = JsonCodableEncoder.toBytes(model.encode);
      blackhole(outBytes);
    },
    'twitter' => () {
      final model = preDecodedModel as TwitterResponse;
      final outBytes = JsonCodableEncoder.toBytes(model.encode);
      blackhole(outBytes);
    },
    _ => throw ArgumentError('Unknown dataset: $dataset'),
  };
}

BenchmarkResult runBenchmark(String dataset, String mode, String engineLabel) {
  final bytes = getDatasetBytes(dataset);
  final fileBytes = bytes.length;

  final preDecodedModel = mode == 'encode'
      ? _preDecodeModel(dataset, bytes)
      : null;

  final benchmarkWork = switch (mode) {
    'decode' || 'decode_literal' => _createDecodeBenchmark(dataset, bytes),
    'encode' => _createEncodeBenchmark(dataset, preDecodedModel),
    _ => throw ArgumentError('Unknown mode: $mode'),
  };

  final runner = BenchmarkRunner(
    dataset: dataset,
    mode: mode,
    engine: engineLabel,
    fileBytes: fileBytes,
  );

  return runner.run(benchmarkWork);
}
