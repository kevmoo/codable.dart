// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:typed_data';

import 'package:checks/checks.dart';
import 'package:codable/codable.dart';
import 'package:codable/codable_json.dart';
import 'package:codable/codable_streaming.dart' as streaming;
import 'package:codable/src/json/driver/scratch_byte_accumulator.dart';
import 'package:test/test.dart';

Uint8List? _asNullable(Uint8List? b) => b;

void main() {
  group('ScratchByteAccumulator TDD', () {
    test('1. Cross-Stream Pool Reuse & Truncation Safety', () {
      final largeBytes = Uint8List(100 * 1024);
      largeBytes.fillRange(0, largeBytes.length, 32); // ' '
      largeBytes[0] = 91; // '['
      largeBytes[1] = 49; // '1'
      largeBytes[largeBytes.length - 1] = 93; // ']'

      int? decodedElement;
      final sink1 = JsonCodableDecoder.startChunkedConversion<void>(
        ChunkedConversionSink.withCallback((_) {}),
        Decodable.fromFunction((decoder) {
          final unkeyed = decoder.unkeyed();
          check(unkeyed.moveNext()).isTrue();
          decodedElement = unkeyed.readInt();
          check(unkeyed.moveNext()).isFalse();
        }),
      );
      sink1.add(largeBytes);
      sink1.close();
      check(decodedElement).equals(1);

      final smallPayload = utf8.encode('{"a":1,"b":2}${' ' * 187}');
      check(smallPayload.length).equals(200);

      int? secondLength;
      Uint8List? secondPayload;
      int? secondBufferLength;

      final sink2 = JsonCodableDecoder.startChunkedConversion<void>(
        ChunkedConversionSink.withCallback((_) {}),
        Decodable.fromFunction((decoder) {
          final keyed = decoder.keyed();
          check(keyed.nextKey()).equals('a');
          keyed.skipValue();
          check(keyed.nextKey()).equals('b');
          keyed.skipValue();
          check(keyed.moveNextKey()).isFalse();

          final bytes = _asNullable(
            (decoder as JsonCodableDecoder).reader.bytes,
          );
          secondLength = bytes?.length;
          secondBufferLength = bytes?.buffer.lengthInBytes;
          if (bytes != null) {
            check(bytes.offsetInBytes % 8).equals(0);
            secondPayload = Uint8List.fromList(bytes);
          }
        }),
      );
      sink2.add(smallPayload);
      sink2.close();

      check(secondLength).equals(smallPayload.length);
      check(secondPayload).isNotNull().deepEquals(smallPayload);

      if (secondBufferLength != null) {
        check(secondBufferLength!).isGreaterOrEqual(100 * 1024);
      }
    });

    test('2a. decoder.payload Escape Guard (Use-After-Free Protection)', () {
      final payload1 = utf8.encode('[1, 2, 3]');

      Uint8List? escapedPayload;
      final sink1 = streaming.JsonCodableDecoder.startChunkedConversion<void>(
        ChunkedConversionSink.withCallback((_) {}),
        Decodable.fromFunction((decoder) {
          escapedPayload = Uint8List.sublistView(
            decoder.payload!,
            0,
            decoder.payload!.length,
          );
        }),
      );
      sink1.add(payload1);
      sink1.close();

      check(escapedPayload).isNotNull();
      final capturedBytes = Uint8List.fromList(escapedPayload!);

      final payload2 = utf8.encode(
        '{"overridden": true, "padding": "some extra data"}',
      );
      final sink2 = streaming.JsonCodableDecoder.startChunkedConversion<void>(
        ChunkedConversionSink.withCallback((_) {}),
        Decodable.fromFunction((decoder) {}),
      );
      sink2.add(payload2);
      sink2.close();

      check(escapedPayload!).deepEquals(capturedBytes);
    });

    test(
      '2b. decoder.reader.bytes Escape Guard (Use-After-Free Protection)',
      () {
        final first = utf8.encode('[11111111,22222222,33333333]');
        Uint8List? retained;
        final sink1 = JsonCodableDecoder.startChunkedConversion<void>(
          ChunkedConversionSink.withCallback((_) {}),
          Decodable.fromFunction((decoder) {
            retained = _asNullable(
              (decoder as JsonCodableDecoder).reader.bytes,
            );
          }),
        );
        sink1
          ..add(first)
          ..close();

        check(retained).isNotNull();
        final snapshot = Uint8List.fromList(retained!);

        final sink2 = JsonCodableDecoder.startChunkedConversion<void>(
          ChunkedConversionSink.withCallback((_) {}),
          Decodable.fromFunction((decoder) {}),
        );
        sink2
          ..add(utf8.encode('[99999999,88888888,77777777]'))
          ..close();

        check(retained!).deepEquals(snapshot);
      },
    );

    test('3. Re-Entrant / Nested startChunkedConversion Safety', () {
      final outerPayload = utf8.encode('{"outer": true}');
      final innerPayload = utf8.encode('["inner", "nested"]');

      Uint8List? outerDecodedBytes;
      Uint8List? innerDecodedBytes;

      final outerSink =
          streaming.JsonCodableDecoder.startChunkedConversion<void>(
            ChunkedConversionSink.withCallback((_) {}),
            Decodable.fromFunction((outerDecoder) {
              outerDecodedBytes = Uint8List.fromList(outerDecoder.payload!);

              final innerSink =
                  streaming.JsonCodableDecoder.startChunkedConversion<void>(
                    ChunkedConversionSink.withCallback((_) {}),
                    Decodable.fromFunction((innerDecoder) {
                      innerDecodedBytes = Uint8List.fromList(
                        innerDecoder.payload!,
                      );
                    }),
                  );
              innerSink.add(innerPayload);
              innerSink.close();

              check(outerDecoder.payload).isNotNull().deepEquals(outerPayload);
            }),
          );

      outerSink.add(outerPayload);
      outerSink.close();

      check(outerDecodedBytes).isNotNull().deepEquals(outerPayload);
      check(innerDecodedBytes).isNotNull().deepEquals(innerPayload);
    });

    test('4. addSlice with non-zero start and partial end offsets', () {
      final rawData = utf8.encode('IGNORED[1, 2, 3]IGNORED');

      List<int>? decoded;
      final sink = JsonCodableDecoder.startChunkedConversion<List<int>>(
        ChunkedConversionSink.withCallback((items) {
          decoded = items.single;
        }),
        Decodable.fromFunction((decoder) {
          if (identical(1.0, 1)) {
            check(decoder.payload).isNull();
          } else {
            check(decoder.payload)
                .isNotNull()
                .deepEquals(utf8.encode('[1, 2, 3]'));
          }
          final u = decoder.unkeyed();
          return [for (; u.moveNext();) u.readInt()];
        }),
      );

      sink.addSlice(rawData, 7, 9, false);
      sink.addSlice(rawData, 9, 16, true);

      check(decoded).isNotNull().deepEquals([1, 2, 3]);
    });

    test('5. > 4 MB Pool Cap Release', () {
      final largeBytes = Uint8List(4 * 1024 * 1024 + 1024);
      largeBytes.fillRange(0, largeBytes.length, 32);
      largeBytes[0] = 91; // '['
      largeBytes[1] = 49; // '1'
      largeBytes[largeBytes.length - 1] = 93; // ']'

      int? decodedValue;
      final sink = JsonCodableDecoder.startChunkedConversion<void>(
        ChunkedConversionSink.withCallback((_) {}),
        Decodable.fromFunction((decoder) {
          final unkeyed = decoder.unkeyed();
          check(unkeyed.moveNext()).isTrue();
          decodedValue = unkeyed.readInt();
          check(unkeyed.moveNext()).isFalse();
        }),
      );

      sink.add(largeBytes);
      sink.close();
      check(decodedValue).equals(1);

      final small = utf8.encode('{}');
      Uint8List? smallReaderBytes;
      int? smallBufferLength;
      final sink2 = JsonCodableDecoder.startChunkedConversion<void>(
        ChunkedConversionSink.withCallback((_) {}),
        Decodable.fromFunction((decoder) {
          final bytes = _asNullable(
            (decoder as JsonCodableDecoder).reader.bytes,
          );
          smallReaderBytes = bytes;
          smallBufferLength = bytes?.buffer.lengthInBytes;
        }),
      );
      sink2.add(small);
      sink2.close();

      check(smallReaderBytes).isNotNull().deepEquals(small);
      if (smallBufferLength != null) {
        check(smallBufferLength!).isLessOrEqual(4 * 1024 * 1024);
      }
    });

    test('6. ScratchByteAccumulator reuse after release(canPool: false)', () {
      final acc = ScratchByteAccumulator();
      acc.add([1, 2, 3]);
      acc.release(canPool: false);

      acc.add([4, 5, 6, 7]);
      final bytes = acc.takeBytes();
      check(bytes).deepEquals([4, 5, 6, 7]);
      acc.release(canPool: true);
    });

    test(
      '7. Small uniform double list in large payload shrinks backing buffer',
      () {
        final jsonText = '[{"x":1.5,"y":2.5},{"x":3.5,"y":4.5}]${' ' * 100000}';
        final payload = Uint8List.fromList(utf8.encode(jsonText));

        Float64List? result;
        final sink = JsonCodableDecoder.startChunkedConversion<void>(
          ChunkedConversionSink.withCallback((_) {}),
          Decodable.fromFunction((decoder) {
            result = decoder.decodeUniformDoubleList(const [
              ['x'],
              ['y'],
            ]);
          }),
        );
        sink.add(payload);
        sink.close();

        check(result).isNotNull().deepEquals([1.5, 2.5, 3.5, 4.5]);
        check(result!.buffer.lengthInBytes).equals(4 * 8);
      },
    );
  });
}
