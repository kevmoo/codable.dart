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

class StreamEncData {
  final String name;
  final Uint8List bytes;
  final Object jsModel;
  final void Function(Encoder) codableEncode;

  StreamEncData._(this.name, this.bytes, this.jsModel, this.codableEncode);

  factory StreamEncData(String name) {
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
          final eList = encoder.unkeyed();
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
        throw ArgumentError.value(name, 'name', 'Unknown dataset');
    }
    return StreamEncData._(name, bytes, jsModel, codableEncode);
  }
}

final class _BytesBuilderSink extends ByteConversionSinkBase {
  final BytesBuilder _builder;

  _BytesBuilderSink(this._builder);

  @override
  void add(List<int> chunk) {
    _builder.add(chunk);
  }

  @override
  void addSlice(List<int> chunk, int start, int end, bool isLast) {
    if (start == 0 && end == chunk.length) {
      _builder.add(chunk);
    } else if (chunk is Uint8List) {
      _builder.add(chunk.sublist(start, end));
    } else {
      _builder.add(chunk.sublist(start, end));
    }
    if (isLast) {
      close();
    }
  }

  @override
  void close() {}
}

Object _serializeJsonSerializable(StreamEncData d) {
  switch (d.name) {
    case 'coordinates':
      return (d.jsModel as List<js_coord.Coordinate>)
          .map((e) => e.toJson())
          .toList();
    case 'canada':
      return (d.jsModel as js_canada.CanadaFeatureCollection).toJson();
    case 'citm_catalog':
      return (d.jsModel as js_citm.CitmCatalog).toJson();
    case 'small':
      return (d.jsModel as js_small.SmallDocument).toJson();
    case 'twitter':
      return (d.jsModel as js_twitter.TwitterResponse).toJson();
    default:
      throw ArgumentError.value(d.name, 'name', 'Unknown dataset');
  }
}

void main(List<String> args) async {
  print('\n============================================================');
  print('🎯 SUBSTRATE METADATA (STREAM ENCODE)');
  print(
    'Mode: ${isMockSubstrate ? "MOCK (pure-Dart)" : "NATIVE (dart:convert)"}',
  );
  print('============================================================\n');

  final datasets = ['coordinates', 'canada'];
  final cases = datasets.map(StreamEncData.new).toList();

  final streamGroups = BenchmarkGroup.matrix<StreamEncData>(
    cases: cases,
    name: (d) => '${d.name}_encode_stream',
    config: const BenchmarkConfig(forceRun: true),
    throughput: (d) => Throughput.bytes(d.bytes.length),
    baseline: (
      'json_serializable',
      (d) {
        final byteBuilder = BytesBuilder(copy: false);
        final byteSink = _BytesBuilderSink(byteBuilder);
        final sink = utf8JsonEncoder.startChunkedConversion(byteSink);
        sink.add(_serializeJsonSerializable(d));
        sink.close();
        Blackhole.consume(byteBuilder.length);
      },
    ),
    candidates: {
      'codable': (d) {
        final byteBuilder = BytesBuilder(copy: false);
        final byteSink = _BytesBuilderSink(byteBuilder);
        final sink = JsonCodableEncoder.startChunkedConversion(byteSink);
        sink.add(d.codableEncode);
        sink.close();
        Blackhole.consume(byteBuilder.length);
      },
    },
  );

  final monoGroups = BenchmarkGroup.matrix<StreamEncData>(
    cases: cases,
    name: (d) => '${d.name}_encode',
    config: const BenchmarkConfig(forceRun: true),
    throughput: (d) => Throughput.bytes(d.bytes.length),
    baseline: (
      'json_serializable',
      (d) {
        Blackhole.consume(
          utf8JsonEncoder.convert(_serializeJsonSerializable(d)),
        );
      },
    ),
    candidates: {
      'codable': (d) {
        Blackhole.consume(JsonCodableEncoder.toBytes(d.codableEncode));
      },
    },
  );

  await mainBenchmarkSuite([...streamGroups, ...monoGroups], args);
}
