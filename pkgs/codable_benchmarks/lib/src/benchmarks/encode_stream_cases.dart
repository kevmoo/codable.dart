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
import '../models/codable/coordinate.dart' as codable_coord;
import '../models/json_serializable/canada.dart' as js_canada;
import '../models/json_serializable/coordinate.dart' as js_coord;

final utf8JsonEncoder = json.encoder.fuse(utf8.encoder);

class _BytesBuilderSink implements ByteConversionSink {
  final BytesBuilder _builder;
  _BytesBuilderSink(this._builder);

  @override
  void add(List<int> chunk) {
    _builder.add(chunk);
  }

  @override
  void addSlice(List<int> chunk, int start, int end, bool isLast) {
    if (chunk is Uint8List) {
      _builder.add(
        Uint8List.sublistView(chunk as TypedData, start, end) as List<int>,
      );
    } else {
      _builder.add(chunk.sublist(start, end));
    }
  }

  @override
  void close() {}
}

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

      default:
        throw ArgumentError.value(name, 'name', 'Unknown dataset');
    }

    return StreamEncData._(name, bytes, jsModel, codableEncode);
  }
}

Object _serializeJsonSerializable(StreamEncData d) {
  switch (d.name) {
    case 'coordinates':
      return (d.jsModel as List<js_coord.Coordinate>)
          .map((e) => e.toJson())
          .toList();
    case 'canada':
      return (d.jsModel as js_canada.CanadaFeatureCollection).toJson();
    default:
      throw ArgumentError.value(d.name, 'name', 'Unknown dataset');
  }
}

BenchmarkGroup createEncodeStreamBenchmarkGroup(String dataset) {
  final d = StreamEncData(dataset);
  final throughput = Throughput.bytes(d.bytes.length);
  final groupName = '${d.name}_encode_stream';

  void runJsonSerializable() {
    final byteBuilder = BytesBuilder(copy: false);
    final byteSink = _BytesBuilderSink(byteBuilder);
    final sink = utf8JsonEncoder.startChunkedConversion(byteSink);
    sink.add(_serializeJsonSerializable(d));
    sink.close();
    Blackhole.consume(byteBuilder.length);
  }

  void runCodable() {
    final byteBuilder = BytesBuilder(copy: false);
    final byteSink = _BytesBuilderSink(byteBuilder);
    final sink = JsonCodableEncoder.startChunkedConversion(byteSink);
    sink.add(d.codableEncode);
    sink.close();
    Blackhole.consume(byteBuilder.length);
  }

  return BenchmarkGroup(groupName, [
    BenchmarkVariant(
      'codable',
      runCodable,
      group: groupName,
      isBaseline: false,
      throughput: throughput,
    ),
    BenchmarkVariant(
      'json_serializable',
      runJsonSerializable,
      group: groupName,
      isBaseline: true,
      throughput: throughput,
    ),
  ], config: const BenchmarkConfig(forceRun: true));
}

Future<void> mainEncodeStreamCase(String dataset, List<String> args) async {
  print('\n============================================================');
  print('🎯 SUBSTRATE METADATA (STREAM ENCODE)');
  print(
    'Mode: ${isMockSubstrate ? "MOCK (pure-Dart)" : "NATIVE (dart:convert)"}',
  );
  print('Workload: $dataset');
  print('============================================================\n');

  await mainBenchmarkGroup(createEncodeStreamBenchmarkGroup(dataset), args);
}
