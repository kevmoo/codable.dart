// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:typed_data';

import 'package:bench_press/bench_press.dart';
import 'package:codable/codable.dart';
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

class EncData {
  final String name;
  final Uint8List bytes;

  /// The dataset decoded to a Dart String.
  ///
  /// Only the encode control consumes this. It is materialised here, at setup
  /// time, so the control measures `utf8.encode` and nothing else.
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
        final m = codable_canada.CanadaFeatureCollection.decode(decoder);
        codableEncode = m.encode;
        break;
      case 'citm_catalog':
        jsModel = js_citm.CitmCatalog.fromJson(jsonAst as Map<String, dynamic>);
        final m = codable_citm.CitmCatalog.decode(decoder);
        codableEncode = m.encode;
        break;
      case 'small':
        jsModel = js_small.SmallDocument.fromJson(
          jsonAst as Map<String, dynamic>,
        );
        final m = codable_small.SmallDocument.decode(decoder);
        codableEncode = m.encode;
        break;
      case 'twitter':
        jsModel = js_twitter.TwitterResponse.fromJson(
          jsonAst as Map<String, dynamic>,
        );
        final m = codable_twitter.TwitterResponse.decode(decoder);
        codableEncode = m.encode;
        break;
      default:
        throw Exception();
    }
    return EncData._(name, bytes, utf8.decode(bytes), jsModel, codableEncode);
  }
}

void main(List<String> args) async {
  print('\n============================================================');
  print('🎯 SUBSTRATE METADATA');
  print(
    'Mode: ${isMockSubstrate ? "MOCK (pure-Dart)" : "NATIVE (dart:convert)"}',
  );
  print('============================================================\n');

  final datasets = [
    'coordinates',
    'canada',
    'citm_catalog',
    'small',
    'twitter',
  ];
  final cases = datasets.map(EncData.new).toList();

  final groups = BenchmarkGroup.matrix<EncData>(
    cases: cases,
    name: (d) => '${d.name}_encode',
    config: const BenchmarkConfig(forceRun: true),
    throughput: (d) => Throughput.bytes(d.bytes.length),
    baseline: (
      'json_serializable',
      (d) {
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
      'codable': (d) {
        final outBytes = JsonCodableEncoder.toBytes(d.codableEncode);
        Blackhole.consume(outBytes);
      },
      // Null-experiment control for the ENCODE tables.
      //
      // Its Tier 1 / Tier 0 ratio must be exactly 1.000x, because
      // `sdk/lib/convert/utf8.dart` is byte-identical between the stock SDK
      // and the fork, and no VM or Wasm `convert_patch.dart` references
      // `_Utf8Encoder` at all. Any deviation is harness, build, or
      // measurement drift.
      //
      // Note the asymmetry with the decode control: on the decode side we can
      // hide in the String parser, because the fork only altered the UTF-8
      // *byte* parser. There is no encode analogue — the fork relocates
      // `JsonEncoder`, `_JsonEncoderSink` and `_JsonStringStringifier` out of
      // `json.dart` into `json_utf8.dart`, so NO JSON encode path is
      // source-identical. The control therefore has to be a non-JSON codec.
      //
      // `latin1.encode` and `ascii.encode` are more stable but throw on
      // `twitter.json` and `citm_catalog.json`, which contain code units
      // above 0xFF. `base64.encode` is a viable alternative (marginally more
      // stable) but is bytes->String, the wrong direction to be sensitive to
      // the string-scanning drift that threatens the encode measurements.
      'utf8_encode_control': (d) {
        Blackhole.consume(utf8.encode(d.string));
      },
    },
  );

  await mainBenchmarkSuite(groups.toList(), args);
}
