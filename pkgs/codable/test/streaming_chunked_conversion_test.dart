// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:typed_data';

import 'package:checks/checks.dart';
import 'package:codable/codable_json.dart';
import 'package:codable/src/json/substrate/mock/substrate_mock.dart'
    as mock_sub;
import 'package:test/scaffolding.dart';

final class _Point implements Encodable {
  final double x;
  final double y;
  final String label;

  const _Point(this.x, this.y, this.label);

  static _Point decode(Decoder decoder) {
    final c = decoder.keyed();
    double? x;
    double? y;
    String? label;
    while (c.hasNextKey()) {
      switch (c.nextKey()) {
        case 'x':
          x = c.readDouble();
          break;
        case 'y':
          y = c.readDouble();
          break;
        case 'label':
          label = c.readString();
          break;
        default:
          c.skipValue();
      }
    }
    return _Point(x!, y!, label!);
  }

  static List<_Point> decodeList(Decoder decoder) {
    final u = decoder.unkeyed();
    final out = <_Point>[];
    while (u.hasNext()) {
      out.add(u.decodeElement(_Point.decode));
    }
    return out;
  }

  @override
  void encode(Encoder encoder) {
    final c = encoder.keyed();
    c.encodeDouble('x', x);
    c.encodeDouble('y', y);
    c.encodeString('label', label);
  }
}

void main() {
  group('Mock JsonUtf8Decoder & JsonUtf8Encoder startChunkedConversion', () {
    test('decodes single and multi-chunk JSON payloads', () {
      final payload = utf8.encode(
        '{"items":[1,2,3,4,5],"message":"hello world"}',
      );
      Object? result;
      final outSink = ChunkedConversionSink<Object?>.withCallback((results) {
        result = results.first;
      });
      final inSink = const mock_sub.JsonUtf8Decoder().startChunkedConversion(
        outSink,
      );
      for (var i = 0; i < payload.length; i += 7) {
        final end = (i + 7 < payload.length) ? i + 7 : payload.length;
        inSink.add(payload.sublist(i, end));
      }
      inSink.close();

      check(result).isA<Map<String, dynamic>>();
      final map = result as Map<String, dynamic>;
      check(map['message']).equals('hello world');
      check(map['items']).isA<List<dynamic>>().deepEquals([1, 2, 3, 4, 5]);
    });

    test('decodes multi-byte UTF-8 characters split across 1-byte chunks', () {
      final payload = utf8.encode('{"emoji":"🚀✨こんにちは","n":42}');
      Object? result;
      final outSink = ChunkedConversionSink<Object?>.withCallback((results) {
        result = results.first;
      });
      final inSink = const mock_sub.JsonUtf8Decoder().startChunkedConversion(
        outSink,
      );
      for (var i = 0; i < payload.length; i++) {
        inSink.add(Uint8List.fromList([payload[i]]));
      }
      inSink.close();

      final map = result as Map<String, dynamic>;
      check(map['emoji']).equals('🚀✨こんにちは');
      check(map['n']).equals(42);
    });

    test('supports addSlice, reviver, and idempotent close', () {
      final raw = Uint8List.fromList(utf8.encode('____{"a":10,"b":20}____'));
      Object? result;
      final outSink = ChunkedConversionSink<Object?>.withCallback((results) {
        result = results.first;
      });
      final decoder = mock_sub.JsonUtf8Decoder((key, value) {
        if (value is int) return value * 2;
        return value;
      });
      final inSink = decoder.startChunkedConversion(outSink);
      inSink.addSlice(raw, 4, 11, false);
      inSink.addSlice(raw, 11, 19, true);
      // Calling close() after addSlice(..., true) must be a safe no-op.
      inSink.close();

      final map = result as Map<String, dynamic>;
      check(map['a']).equals(20);
      check(map['b']).equals(40);

      check(() => inSink.add([123])).throws<StateError>();
      check(() => inSink.addSlice(raw, 0, 1, false)).throws<StateError>();
    });

    test('JsonUtf8Encoder.startChunkedConversion emits valid UTF-8 bytes', () {
      final builder = BytesBuilder(copy: false);
      final byteSink = ByteConversionSink.withCallback(builder.add);
      final inSink = const mock_sub.JsonUtf8Encoder().startChunkedConversion(
        byteSink,
      );
      inSink.add({
        'hello': 'world',
        'nums': [1, 2, 3],
      });
      inSink.close();

      final decoded = jsonDecode(utf8.decode(builder.takeBytes()));
      check(decoded).isA<Map<String, dynamic>>();
      check((decoded as Map<String, dynamic>)['hello']).equals('world');
    });
  });

  group('JsonCodableDecoder & JsonCodableEncoder streaming sinks', () {
    test('roundtrips large multi-chunk payload across 32 KB boundaries', () {
      final points = List<_Point>.generate(
        1500,
        (i) => _Point(i * 1.25, -i * 0.5, 'point_label_$i'),
      );

      final byteBuilder = BytesBuilder(copy: false);
      final byteSink = ByteConversionSink.withCallback(byteBuilder.add);
      final encSink = JsonCodableEncoder.startChunkedConversion(byteSink);
      encSink.add((encoder) {
        final listEnc = encoder.unkeyed();
        for (final p in points) {
          listEnc.encodeEncodable(p);
        }
      });
      encSink.close();

      final encodedBytes = byteBuilder.takeBytes();
      check(encodedBytes.length).isGreaterThan(32768);

      // Verify JsonCodableEncoder.toSink produces identical bytes
      final directSinkBuilder = BytesBuilder(copy: false);
      JsonCodableEncoder.toSink(directSinkBuilder, (encoder) {
        final listEnc = encoder.unkeyed();
        for (final p in points) {
          listEnc.encodeEncodable(p);
        }
      });
      check(directSinkBuilder.takeBytes()).deepEquals(encodedBytes);

      // Slice into 4 KB chunks and decode via
      // JsonCodableDecoder.startChunkedConversion.
      List<_Point>? decodedPoints;
      final resultSink = ChunkedConversionSink<List<_Point>>.withCallback((
        results,
      ) {
        decodedPoints = results.first;
      });
      final decSink = JsonCodableDecoder.startChunkedConversion<List<_Point>>(
        resultSink,
        _Point.decodeList,
      );
      for (var offset = 0; offset < encodedBytes.length; offset += 4096) {
        final end = (offset + 4096 < encodedBytes.length)
            ? offset + 4096
            : encodedBytes.length;
        decSink.add(Uint8List.sublistView(encodedBytes, offset, end));
      }
      decSink.close();

      check(decodedPoints).isNotNull();
      check(decodedPoints!.length).equals(points.length);
      check(decodedPoints!.first.label).equals('point_label_0');
      check(decodedPoints!.last.label).equals('point_label_1499');
      check(decodedPoints!.last.x).equals(1499 * 1.25);
    });

    test('addSlice copies slice bytes so caller can reuse scratch buffer', () {
      final rawBytes = utf8.encode('[{"x":1.5,"y":-2.5,"label":"reused"}]');
      final scratch = Uint8List(32);

      // 1. JsonUtf8Decoder.startChunkedConversion
      Object? utf8Decoded;
      final utf8Out = ChunkedConversionSink<Object?>.withCallback((res) {
        utf8Decoded = res.first;
      });
      final utf8Sink = const mock_sub.JsonUtf8Decoder().startChunkedConversion(
        utf8Out,
      );
      for (var i = 0; i < rawBytes.length; i += 8) {
        final end = (i + 8 < rawBytes.length) ? i + 8 : rawBytes.length;
        final sliceLen = end - i;
        scratch.setRange(4, 4 + sliceLen, rawBytes, i);
        utf8Sink.addSlice(scratch, 4, 4 + sliceLen, false);
        // Immediately overwrite scratch buffer to verify addSlice copied it.
        scratch.fillRange(0, scratch.length, 0xFF);
      }
      utf8Sink.close();
      check(utf8Decoded).isA<List<Object?>>().length.equals(1);

      // 2. JsonCodableDecoder.startChunkedConversion
      List<_Point>? codableDecoded;
      final codableOut = ChunkedConversionSink<List<_Point>>.withCallback((
        res,
      ) {
        codableDecoded = res.first;
      });
      final codableSink =
          JsonCodableDecoder.startChunkedConversion<List<_Point>>(
            codableOut,
            _Point.decodeList,
          );
      for (var i = 0; i < rawBytes.length; i += 8) {
        final end = (i + 8 < rawBytes.length) ? i + 8 : rawBytes.length;
        final sliceLen = end - i;
        scratch.setRange(4, 4 + sliceLen, rawBytes, i);
        codableSink.addSlice(scratch, 4, 4 + sliceLen, false);
        scratch.fillRange(0, scratch.length, 0xFF);
      }
      codableSink.close();
      check(codableDecoded).isNotNull();
      check(codableDecoded!.single.label).equals('reused');
      check(codableDecoded!.single.x).equals(1.5);
      check(codableDecoded!.single.y).equals(-2.5);
    });
  });
}
