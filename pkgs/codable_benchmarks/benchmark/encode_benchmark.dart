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

final utf8JsonEncoder = json.encoder.fuse(utf8.encoder);

BenchmarkGroup _createEncodeGroup(
  String dataset,
  Uint8List bytes,
  String jsonString,
) {
  switch (dataset) {
    case 'coordinates':
      final jsList = (jsonDecode(jsonString) as List<dynamic>)
          .map((e) => js_coord.Coordinate.fromJson(e as Map<String, dynamic>))
          .toList();
      final codableList = codable_coord.Coordinate.decodeList(
        JsonCodableDecoder.fromBytes(bytes),
      );
      return BenchmarkGroup.compare(
        name: 'coordinates_encode',
        config: const BenchmarkConfig(forceRun: true),
        throughput: Throughput.bytes(bytes.length),
        baseline: (
          'json_serializable',
          () {
            final mapList = jsList.map((e) => e.toJson()).toList();
            final outBytes = utf8JsonEncoder.convert(mapList);
            Blackhole.consume(outBytes);
          },
        ),
        candidates: {
          'codable': () {
            final outBytes = JsonCodableEncoder.toBytes((e) {
              final unkeyed = e.unkeyed();
              for (var i = 0; i < codableList.length; i++) {
                unkeyed.encodeEncodable(codableList[i]);
              }
            });
            Blackhole.consume(outBytes);
          },
        },
      );

    case 'canada':
      final jsModel = js_canada.CanadaFeatureCollection.fromJson(
        jsonDecode(jsonString) as Map<String, dynamic>,
      );
      final codableModel = codable_canada.CanadaFeatureCollection.decode(
        JsonCodableDecoder.fromBytes(bytes),
      );
      return BenchmarkGroup.compare(
        name: 'canada_encode',
        config: const BenchmarkConfig(forceRun: true),
        throughput: Throughput.bytes(bytes.length),
        baseline: (
          'json_serializable',
          () {
            final outBytes = utf8JsonEncoder.convert(jsModel.toJson());
            Blackhole.consume(outBytes);
          },
        ),
        candidates: {
          'codable': () {
            final outBytes = JsonCodableEncoder.toBytes(codableModel.encode);
            Blackhole.consume(outBytes);
          },
        },
      );

    case 'citm_catalog':
      final jsModel = js_citm.CitmCatalog.fromJson(
        jsonDecode(jsonString) as Map<String, dynamic>,
      );
      final codableModel = codable_citm.CitmCatalog.decode(
        JsonCodableDecoder.fromBytes(bytes),
      );
      return BenchmarkGroup.compare(
        name: 'citm_catalog_encode',
        config: const BenchmarkConfig(forceRun: true),
        throughput: Throughput.bytes(bytes.length),
        baseline: (
          'json_serializable',
          () {
            final outBytes = utf8JsonEncoder.convert(jsModel.toJson());
            Blackhole.consume(outBytes);
          },
        ),
        candidates: {
          'codable': () {
            final outBytes = JsonCodableEncoder.toBytes(codableModel.encode);
            Blackhole.consume(outBytes);
          },
        },
      );

    case 'small':
      final jsModel = js_small.SmallDocument.fromJson(
        jsonDecode(jsonString) as Map<String, dynamic>,
      );
      final codableModel = codable_small.SmallDocument.decode(
        JsonCodableDecoder.fromBytes(bytes),
      );
      return BenchmarkGroup.compare(
        name: 'small_encode',
        config: const BenchmarkConfig(forceRun: true),
        throughput: Throughput.bytes(bytes.length),
        baseline: (
          'json_serializable',
          () {
            final outBytes = utf8JsonEncoder.convert(jsModel.toJson());
            Blackhole.consume(outBytes);
          },
        ),
        candidates: {
          'codable': () {
            final outBytes = JsonCodableEncoder.toBytes(codableModel.encode);
            Blackhole.consume(outBytes);
          },
        },
      );

    case 'twitter':
      final jsModel = js_twitter.TwitterResponse.fromJson(
        jsonDecode(jsonString) as Map<String, dynamic>,
      );
      final codableModel = codable_twitter.TwitterResponse.decode(
        JsonCodableDecoder.fromBytes(bytes),
      );
      return BenchmarkGroup.compare(
        name: 'twitter_encode',
        config: const BenchmarkConfig(forceRun: true),
        throughput: Throughput.bytes(bytes.length),
        baseline: (
          'json_serializable',
          () {
            final outBytes = utf8JsonEncoder.convert(jsModel.toJson());
            Blackhole.consume(outBytes);
          },
        ),
        candidates: {
          'codable': () {
            final outBytes = JsonCodableEncoder.toBytes(codableModel.encode);
            Blackhole.consume(outBytes);
          },
        },
      );

    default:
      throw ArgumentError('Unknown dataset: $dataset');
  }
}

void main(List<String> args) async {
  final datasets = [
    'coordinates',
    'canada',
    'citm_catalog',
    'small',
    'twitter',
  ];

  final groups = <BenchmarkGroup>[];
  for (final ds in datasets) {
    final bytes = getDatasetBytes(ds);
    final jsonString = utf8.decode(bytes);
    groups.add(_createEncodeGroup(ds, bytes, jsonString));
  }

  await mainBenchmarkSuite(groups, args);
}
