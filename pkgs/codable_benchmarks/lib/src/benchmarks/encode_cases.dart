// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:typed_data';

import 'package:bench_press/bench_press.dart';
import 'package:codable/codable.dart';
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

final utf8JsonEncoder = json.encoder.fuse(utf8.encoder);

class EncData {
  final String name;
  final Uint8List bytes;
  final String string;
  final Object jsModel;
  final void Function(Encoder) codableEncode;

  EncData._(
    this.name,
    this.bytes,
    this.string,
    this.jsModel,
    this.codableEncode,
  );

  factory EncData(String name) {
    final bytes = getDatasetBytes(name);
    final jsonAst = utf8.decoder.fuse(json.decoder).convert(bytes);
    Object jsModel;
    void Function(Encoder) codableEncode;
    final decoder = JsonCodableDecoder.fromBytes(bytes);

    switch (name) {
      case 'coordinates':
        jsModel = (jsonAst as List)
            .map((e) => js_coord.Coordinate.fromJson(e as Map<String, dynamic>))
            .toList();
        final list = codable_coord.Coordinate.decodeList(
          JsonCodableDecoder.fromBytes(bytes),
        );
        codableEncode = (encoder) {
          var eList = encoder.unkeyed();
          for (final model in list) {
            eList.encodeEncodable(model);
          }
        };
        break;
      case 'canada':
        jsModel = js_canada.CanadaFeatureCollection.fromJson(
          jsonAst as Map<String, dynamic>,
        );
        final model = codable_canada.CanadaFeatureCollection.decode(decoder);
        codableEncode = model.encode;
        break;
      case 'citm_catalog':
        jsModel = js_citm.CitmCatalog.fromJson(jsonAst as Map<String, dynamic>);
        final model = codable_citm.CitmCatalog.decode(decoder);
        codableEncode = model.encode;
        break;
      case 'small':
        jsModel = js_small.SmallDocument.fromJson(
          jsonAst as Map<String, dynamic>,
        );
        final model = codable_small.SmallDocument.decode(decoder);
        codableEncode = model.encode;
        break;
      case 'twitter':
        jsModel = js_twitter.TwitterResponse.fromJson(
          jsonAst as Map<String, dynamic>,
        );
        final model = codable_twitter.TwitterResponse.decode(decoder);
        codableEncode = model.encode;
        break;

      default:
        throw ArgumentError.value(name, 'name', 'Unknown dataset');
    }

    final str = utf8.decode(bytes);
    return EncData._(name, bytes, str, jsModel, codableEncode);
  }
}

BenchmarkGroup createEncodeBenchmarkGroup(String dataset) {
  final d = EncData(dataset);
  return BenchmarkGroup.compare(
    name: '${d.name}_encode',
    config: const BenchmarkConfig(forceRun: true),
    throughput: Throughput.bytes(d.bytes.length),
    baseline: (
      'json_serializable',
      () {
        dynamic res;
        switch (d.name) {
          case 'coordinates':
            res = (d.jsModel as List<js_coord.Coordinate>)
                .map((e) => e.toJson())
                .toList();
            break;
          case 'canada':
            res = (d.jsModel as js_canada.CanadaFeatureCollection).toJson();
            break;
          case 'citm_catalog':
            res = (d.jsModel as js_citm.CitmCatalog).toJson();
            break;
          case 'small':
            res = (d.jsModel as js_small.SmallDocument).toJson();
            break;
          case 'twitter':
            res = (d.jsModel as js_twitter.TwitterResponse).toJson();
            break;
        }
        Blackhole.consume(utf8JsonEncoder.convert(res));
      },
    ),
    candidates: {
      'codable': () {
        final outBytes = JsonCodableEncoder.toBytes(d.codableEncode);
        Blackhole.consume(outBytes);
      },
      'utf8_encode_control': () {
        Blackhole.consume(utf8.encode(d.string));
      },
    },
  );
}

Future<void> mainEncodeCase(String dataset, List<String> args) async {
  print('\n============================================================');
  print('🎯 SUBSTRATE METADATA');
  print(
    'Mode: ${isMockSubstrate ? "MOCK (pure-Dart)" : "NATIVE (dart:convert)"}',
  );
  print('Workload: $dataset');
  print('============================================================\n');

  await mainBenchmarkGroup(createEncodeBenchmarkGroup(dataset), args);
}
