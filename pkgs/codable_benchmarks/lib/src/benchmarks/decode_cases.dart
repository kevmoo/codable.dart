// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:typed_data';

import 'package:bench_press/bench_press.dart';
import 'package:codable/codable_json.dart';

import '../data/embedded_datasets.dart';
import '../models/codable/canada.dart' as codable_canada;
import '../models/codable/citm_catalog.dart' as codable_citm;
import '../models/codable/coordinate.dart' as codable_coord;
import '../models/codable/small.dart' as codable_small;
import '../models/codable/twitter.dart' as codable_twitter;
import '../models/json_serializable/canada.dart' as js_canada;
import '../models/json_serializable/citm_catalog.dart' as js_citm;
import '../models/json_serializable/coordinate.dart' as js_coord;
import '../models/json_serializable/small.dart' as js_small;
import '../models/json_serializable/twitter.dart' as js_twitter;

final utf8JsonDecoder = utf8.decoder.fuse(json.decoder);

class DecodeData {
  final String name;
  final Uint8List bytes;
  final String string;

  DecodeData(this.name)
    : bytes = getDatasetBytes(name),
      string = utf8.decode(getDatasetBytes(name));
}

BenchmarkGroup createDecodeBenchmarkGroup(String dataset) {
  final d = DecodeData(dataset);
  return BenchmarkGroup.compare(
    name: '${d.name}_decode',
    config: const BenchmarkConfig(forceRun: true),
    throughput: Throughput.bytes(d.bytes.length),
    baseline: (
      'json_serializable',
      () {
        final dynamic jsonAst = utf8JsonDecoder.convert(d.bytes);
        switch (d.name) {
          case 'coordinates':
            Blackhole.consume(
              (jsonAst as List<dynamic>)
                  .map(
                    (e) =>
                        js_coord.Coordinate.fromJson(e as Map<String, dynamic>),
                  )
                  .toList(),
            );
            break;
          case 'canada':
            Blackhole.consume(
              js_canada.CanadaFeatureCollection.fromJson(
                jsonAst as Map<String, dynamic>,
              ),
            );
            break;
          case 'citm_catalog':
            Blackhole.consume(
              js_citm.CitmCatalog.fromJson(jsonAst as Map<String, dynamic>),
            );
            break;
          case 'small':
            Blackhole.consume(
              js_small.SmallDocument.fromJson(jsonAst as Map<String, dynamic>),
            );
            break;
          case 'twitter':
            Blackhole.consume(
              js_twitter.TwitterResponse.fromJson(
                jsonAst as Map<String, dynamic>,
              ),
            );
            break;
        }
      },
    ),
    candidates: {
      'json_serializable_literal': () {
        final dynamic jsonAst = jsonDecode(d.string);
        switch (d.name) {
          case 'coordinates':
            Blackhole.consume(
              (jsonAst as List<dynamic>)
                  .map(
                    (e) =>
                        js_coord.Coordinate.fromJson(e as Map<String, dynamic>),
                  )
                  .toList(),
            );
            break;
          case 'canada':
            Blackhole.consume(
              js_canada.CanadaFeatureCollection.fromJson(
                jsonAst as Map<String, dynamic>,
              ),
            );
            break;
          case 'citm_catalog':
            Blackhole.consume(
              js_citm.CitmCatalog.fromJson(jsonAst as Map<String, dynamic>),
            );
            break;
          case 'small':
            Blackhole.consume(
              js_small.SmallDocument.fromJson(jsonAst as Map<String, dynamic>),
            );
            break;
          case 'twitter':
            Blackhole.consume(
              js_twitter.TwitterResponse.fromJson(
                jsonAst as Map<String, dynamic>,
              ),
            );
            break;
        }
      },
      'codable': () {
        final decoder = JsonCodableDecoder.fromBytes(d.bytes);
        switch (d.name) {
          case 'coordinates':
            Blackhole.consume(codable_coord.Coordinate.decodeList(decoder));
            break;
          case 'canada':
            Blackhole.consume(
              codable_canada.CanadaFeatureCollection.decode(decoder),
            );
            break;
          case 'citm_catalog':
            Blackhole.consume(codable_citm.CitmCatalog.decode(decoder));
            break;
          case 'small':
            Blackhole.consume(codable_small.SmallDocument.decode(decoder));
            break;
          case 'twitter':
            Blackhole.consume(codable_twitter.TwitterResponse.decode(decoder));
            break;
        }
      },
      'codable_js': () {
        final decoder = JsonCodableDecoder.fromBytes(
          d.bytes,
          userInfo: const {#forceJsDom: true},
        );
        switch (d.name) {
          case 'coordinates':
            Blackhole.consume(codable_coord.Coordinate.decodeList(decoder));
            break;
          case 'canada':
            Blackhole.consume(
              codable_canada.CanadaFeatureCollection.decode(decoder),
            );
            break;
          case 'citm_catalog':
            Blackhole.consume(codable_citm.CitmCatalog.decode(decoder));
            break;
          case 'small':
            Blackhole.consume(codable_small.SmallDocument.decode(decoder));
            break;
          case 'twitter':
            Blackhole.consume(codable_twitter.TwitterResponse.decode(decoder));
            break;
        }
      },
    },
  );
}

Future<void> mainDecodeCase(String dataset, List<String> args) async {
  print('\n============================================================');
  print('🎯 SUBSTRATE METADATA');
  print(
    'Mode: ${isMockSubstrate ? "MOCK (pure-Dart)" : "NATIVE (dart:convert)"}',
  );
  print('Workload: $dataset');
  print('============================================================\n');

  await mainBenchmarkGroup(createDecodeBenchmarkGroup(dataset), args);
}
