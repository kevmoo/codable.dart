// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:typed_data';

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

const int streamChunkSize = 32 * 1024; // 32 KB

final utf8JsonDecoder = utf8.decoder.fuse(json.decoder);

List<Uint8List> sliceBytesIntoChunks(
  Uint8List bytes, [
  int chunkSize = streamChunkSize,
]) {
  if (bytes.isEmpty) return const <Uint8List>[];
  final chunks = <Uint8List>[];
  for (var offset = 0; offset < bytes.length; offset += chunkSize) {
    final end = (offset + chunkSize < bytes.length)
        ? offset + chunkSize
        : bytes.length;
    chunks.add(bytes.sublist(offset, end));
  }
  return List<Uint8List>.unmodifiable(chunks);
}

List<String> sliceStringIntoChunks(
  String text, [
  int chunkSize = streamChunkSize,
]) {
  if (text.isEmpty) return const <String>[];
  final chunks = <String>[];
  for (var offset = 0; offset < text.length; offset += chunkSize) {
    final end = (offset + chunkSize < text.length)
        ? offset + chunkSize
        : text.length;
    chunks.add(text.substring(offset, end));
  }
  return List<String>.unmodifiable(chunks);
}

Object _hydrateJsonSerializable(String name, Object? jsonAst) {
  switch (name) {
    case 'coordinates':
      return (jsonAst as List<dynamic>)
          .map((e) => js_coord.Coordinate.fromJson(e as Map<String, dynamic>))
          .toList();
    case 'canada':
      return js_canada.CanadaFeatureCollection.fromJson(
        jsonAst as Map<String, dynamic>,
      );
    case 'citm_catalog':
      return js_citm.CitmCatalog.fromJson(jsonAst as Map<String, dynamic>);
    case 'small':
      return js_small.SmallDocument.fromJson(jsonAst as Map<String, dynamic>);
    case 'twitter':
      return js_twitter.TwitterResponse.fromJson(
        jsonAst as Map<String, dynamic>,
      );
    default:
      throw ArgumentError.value(name, 'name', 'Unknown dataset');
  }
}

Object _decodeCodable(String name, Decoder decoder) {
  switch (name) {
    case 'coordinates':
      return codable_coord.Coordinate.decodeList(decoder);
    case 'canada':
      return codable_canada.CanadaFeatureCollection.decode(decoder);
    case 'citm_catalog':
      return codable_citm.CitmCatalog.decode(decoder);
    case 'small':
      return codable_small.SmallDocument.decode(decoder);
    case 'twitter':
      return codable_twitter.TwitterResponse.decode(decoder);
    default:
      throw ArgumentError.value(name, 'name', 'Unknown dataset');
  }
}

class StreamDecodeData {
  final String name;
  final Uint8List bytes;
  final String string;
  final List<Uint8List> chunks;
  final List<String> stringChunks;

  StreamDecodeData(this.name)
    : bytes = getDatasetBytes(name),
      string = utf8.decode(getDatasetBytes(name)),
      chunks = sliceBytesIntoChunks(getDatasetBytes(name)),
      stringChunks = sliceStringIntoChunks(utf8.decode(getDatasetBytes(name)));
}

void main(List<String> args) async {
  print('\n============================================================');
  print('🎯 SUBSTRATE METADATA (STREAM DECODE)');
  print(
    'Mode: ${isMockSubstrate ? "MOCK (pure-Dart)" : "NATIVE (dart:convert)"}',
  );
  print('Chunk Size: $streamChunkSize bytes (32 KB)');
  print('============================================================\n');

  final datasets = ['coordinates', 'canada'];
  final cases = datasets.map(StreamDecodeData.new).toList();

  final streamGroups = BenchmarkGroup.matrix<StreamDecodeData>(
    cases: cases,
    name: (d) => '${d.name}_decode_stream',
    config: const BenchmarkConfig(forceRun: true),
    throughput: (d) => Throughput.bytes(d.bytes.length),
    baseline: (
      'json_serializable',
      (d) {
        Object? jsonAst;
        final resultSink = ChunkedConversionSink<Object?>.withCallback((
          results,
        ) {
          jsonAst = results.first;
        });
        final sink = utf8JsonDecoder.startChunkedConversion(resultSink);
        for (final chunk in d.chunks) {
          sink.add(chunk);
        }
        sink.close();
        Blackhole.consume(_hydrateJsonSerializable(d.name, jsonAst));
      },
    ),
    candidates: {
      'json_serializable_literal': (d) {
        Object? jsonAst;
        final resultSink = ChunkedConversionSink<Object?>.withCallback((
          results,
        ) {
          jsonAst = results.first;
        });
        final sink = json.decoder.startChunkedConversion(resultSink);
        for (final chunk in d.stringChunks) {
          sink.add(chunk);
        }
        sink.close();
        Blackhole.consume(_hydrateJsonSerializable(d.name, jsonAst));
      },
      'codable': (d) {
        Object? hydrated;
        final resultSink = ChunkedConversionSink<Object?>.withCallback((
          results,
        ) {
          hydrated = results.first;
        });
        final sink = JsonCodableDecoder.startChunkedConversion<Object?>(
          resultSink,
          (decoder) => _decodeCodable(d.name, decoder),
        );
        for (final chunk in d.chunks) {
          sink.add(chunk);
        }
        sink.close();
        Blackhole.consume(hydrated);
      },
      'codable_js': (d) {
        Object? hydrated;
        final resultSink = ChunkedConversionSink<Object?>.withCallback((
          results,
        ) {
          hydrated = results.first;
        });
        final sink = JsonCodableDecoder.startChunkedConversion<Object?>(
          resultSink,
          (decoder) => _decodeCodable(d.name, decoder),
          userInfo: const {#forceJsDom: true},
        );
        for (final chunk in d.chunks) {
          sink.add(chunk);
        }
        sink.close();
        Blackhole.consume(hydrated);
      },
    },
  );

  final monoGroups = BenchmarkGroup.matrix<StreamDecodeData>(
    cases: cases,
    name: (d) => '${d.name}_decode',
    config: const BenchmarkConfig(forceRun: true),
    throughput: (d) => Throughput.bytes(d.bytes.length),
    baseline: (
      'json_serializable',
      (d) {
        final jsonAst = utf8JsonDecoder.convert(d.bytes);
        Blackhole.consume(_hydrateJsonSerializable(d.name, jsonAst));
      },
    ),
    candidates: {
      'json_serializable_literal': (d) {
        final jsonAst = jsonDecode(d.string);
        Blackhole.consume(_hydrateJsonSerializable(d.name, jsonAst));
      },
      'codable': (d) {
        final decoder = JsonCodableDecoder.fromBytes(d.bytes);
        Blackhole.consume(_decodeCodable(d.name, decoder));
      },
      'codable_js': (d) {
        final decoder = JsonCodableDecoder.fromBytes(
          d.bytes,
          userInfo: const {#forceJsDom: true},
        );
        Blackhole.consume(_decodeCodable(d.name, decoder));
      },
    },
  );

  await mainBenchmarkSuite([...streamGroups, ...monoGroups], args);
}
