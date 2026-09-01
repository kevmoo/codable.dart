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

BenchmarkGroup _createDecodeGroup(
  String dataset,
  Uint8List bytes,
  String jsonString,
) {
  return switch (dataset) {
    'coordinates' => BenchmarkGroup.compare(
      name: 'coordinates_decode',
      throughput: Throughput.bytes(bytes.length),
      baseline: (
        'json_serializable',
        () {
          final dynamic jsonAst = utf8JsonDecoder.convert(bytes);
          final list = (jsonAst as List<dynamic>)
              .map(
                (e) => js_coord.Coordinate.fromJson(e as Map<String, dynamic>),
              )
              .toList();
          Blackhole.consume(list);
        },
      ),
      candidates: {
        'json_serializable_literal': () {
          final dynamic jsonAst = jsonDecode(jsonString);
          final list = (jsonAst as List<dynamic>)
              .map(
                (e) => js_coord.Coordinate.fromJson(e as Map<String, dynamic>),
              )
              .toList();
          Blackhole.consume(list);
        },
        'codable': () {
          final list = codable_coord.Coordinate.decodeList(
            JsonCodableDecoder.fromBytes(bytes),
          );
          Blackhole.consume(list);
        },
      },
    ),
    'canada' => BenchmarkGroup.compare(
      name: 'canada_decode',
      throughput: Throughput.bytes(bytes.length),
      baseline: (
        'json_serializable',
        () {
          final dynamic jsonAst = utf8JsonDecoder.convert(bytes);
          final model = js_canada.CanadaFeatureCollection.fromJson(
            jsonAst as Map<String, dynamic>,
          );
          Blackhole.consume(model);
        },
      ),
      candidates: {
        'json_serializable_literal': () {
          final dynamic jsonAst = jsonDecode(jsonString);
          final model = js_canada.CanadaFeatureCollection.fromJson(
            jsonAst as Map<String, dynamic>,
          );
          Blackhole.consume(model);
        },
        'codable': () {
          final decoder = JsonCodableDecoder.fromBytes(bytes);
          final model = codable_canada.CanadaFeatureCollection.decode(decoder);
          Blackhole.consume(model);
        },
      },
    ),
    'citm_catalog' => BenchmarkGroup.compare(
      name: 'citm_catalog_decode',
      throughput: Throughput.bytes(bytes.length),
      baseline: (
        'json_serializable',
        () {
          final dynamic jsonAst = utf8JsonDecoder.convert(bytes);
          final model = js_citm.CitmCatalog.fromJson(
            jsonAst as Map<String, dynamic>,
          );
          Blackhole.consume(model);
        },
      ),
      candidates: {
        'json_serializable_literal': () {
          final dynamic jsonAst = jsonDecode(jsonString);
          final model = js_citm.CitmCatalog.fromJson(
            jsonAst as Map<String, dynamic>,
          );
          Blackhole.consume(model);
        },
        'codable': () {
          final decoder = JsonCodableDecoder.fromBytes(bytes);
          final model = codable_citm.CitmCatalog.decode(decoder);
          Blackhole.consume(model);
        },
      },
    ),
    'small' => BenchmarkGroup.compare(
      name: 'small_decode',
      throughput: Throughput.bytes(bytes.length),
      baseline: (
        'json_serializable',
        () {
          final dynamic jsonAst = utf8JsonDecoder.convert(bytes);
          final model = js_small.SmallDocument.fromJson(
            jsonAst as Map<String, dynamic>,
          );
          Blackhole.consume(model);
        },
      ),
      candidates: {
        'json_serializable_literal': () {
          final dynamic jsonAst = jsonDecode(jsonString);
          final model = js_small.SmallDocument.fromJson(
            jsonAst as Map<String, dynamic>,
          );
          Blackhole.consume(model);
        },
        'codable': () {
          final decoder = JsonCodableDecoder.fromBytes(bytes);
          final model = codable_small.SmallDocument.decode(decoder);
          Blackhole.consume(model);
        },
      },
    ),
    'twitter' => BenchmarkGroup.compare(
      name: 'twitter_decode',
      throughput: Throughput.bytes(bytes.length),
      baseline: (
        'json_serializable',
        () {
          final dynamic jsonAst = utf8JsonDecoder.convert(bytes);
          final model = js_twitter.TwitterResponse.fromJson(
            jsonAst as Map<String, dynamic>,
          );
          Blackhole.consume(model);
        },
      ),
      candidates: {
        'json_serializable_literal': () {
          final dynamic jsonAst = jsonDecode(jsonString);
          final model = js_twitter.TwitterResponse.fromJson(
            jsonAst as Map<String, dynamic>,
          );
          Blackhole.consume(model);
        },
        'codable': () {
          final decoder = JsonCodableDecoder.fromBytes(bytes);
          final model = codable_twitter.TwitterResponse.decode(decoder);
          Blackhole.consume(model);
        },
      },
    ),
    _ => throw ArgumentError('Unknown dataset: $dataset'),
  };
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
    groups.add(_createDecodeGroup(ds, bytes, jsonString));
  }

  await mainBenchmarkSuite(groups, args);
}
