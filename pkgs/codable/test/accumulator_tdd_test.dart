import 'dart:convert';
import 'dart:typed_data';

import 'package:codable/codable_json.dart';
import 'package:codable/src/json/driver/scratch_byte_accumulator.dart';
import 'package:test/test.dart';

Uint8List? _asNullable(Uint8List? b) => b;

void main() {
  group('ScratchByteAccumulator TDD', () {
    test('1. Cross-Stream Pool Reuse & Truncation Safety', () {
      // 100 KB JSON payload decoded via normal Decoder API (unkeyed) so
      // neither decoder.payload nor decoder.reader is touched and the 128 KB
      // buffer returns to the static pool.
      final largeBytes = Uint8List(100 * 1024);
      largeBytes.fillRange(0, largeBytes.length, 32); // ' '
      largeBytes[0] = 91; // '['
      largeBytes[1] = 49; // '1'
      largeBytes[largeBytes.length - 1] = 93; // ']'

      int? decodedElement;
      final sink1 = JsonCodableDecoder.startChunkedConversion<void>(
        ChunkedConversionSink.withCallback((_) {}),
        (decoder) {
          final unkeyed = decoder.unkeyed();
          expect(unkeyed.hasNext(), isTrue);
          decodedElement = unkeyed.readInt();
          expect(unkeyed.hasNext(), isFalse);
        },
      );
      sink1.add(largeBytes);
      sink1.close();
      expect(decodedElement, equals(1));

      // 200-byte JSON payload in Stream 2 should reuse the 128 KB pooled
      // buffer from Stream 1 while strictly truncating its view to [0, 200).
      final smallPayload = utf8.encode('{"a":1,"b":2}${' ' * 187}');
      expect(smallPayload.length, 200);

      int? secondLength;
      Uint8List? secondPayload;
      int? secondBufferLength;

      final sink2 = JsonCodableDecoder.startChunkedConversion<void>(
        ChunkedConversionSink.withCallback((_) {}),
        (decoder) {
          final keyed = decoder.keyed();
          expect(keyed.nextKey(), equals('a'));
          keyed.skipValue();
          expect(keyed.nextKey(), equals('b'));
          keyed.skipValue();
          expect(keyed.hasNextKey(), isFalse);

          // Now inspect the backing buffer at the end of Stream 2:
          final bytes = _asNullable(
            (decoder as JsonCodableDecoder).reader.bytes,
          );
          secondLength = bytes?.length;
          secondBufferLength = bytes?.buffer.lengthInBytes;
          if (bytes != null) {
            expect(
              bytes.offsetInBytes % 8,
              0,
              reason: 'payload must be 8-byte aligned',
            );
            secondPayload = Uint8List.fromList(bytes);
          }
        },
      );
      sink2.add(smallPayload);
      sink2.close();

      expect(secondLength, equals(smallPayload.length));
      expect(secondPayload, equals(smallPayload));

      // Verify pool reuse: Stream 2's backing buffer is the 128 KB buffer
      // pooled by Stream 1 (>= 100 KB), not a newly allocated 64 KB buffer.
      if (secondBufferLength != null) {
        expect(
          secondBufferLength,
          greaterThanOrEqualTo(100 * 1024),
          reason: 'Stream 2 should reuse pooled 128 KB buffer from Stream 1',
        );
      }
    });

    test('2a. decoder.payload Escape Guard (Use-After-Free Protection)', () {
      final payload1 = utf8.encode('[1, 2, 3]');

      Uint8List? escapedPayload;
      final sink1 = JsonCodableDecoder.startChunkedConversion<void>(
        ChunkedConversionSink.withCallback((_) {}),
        (decoder) {
          escapedPayload = Uint8List.sublistView(
            decoder.payload!,
            0,
            decoder.payload!.length,
          );
        },
      );
      sink1.add(payload1);
      sink1.close();

      expect(escapedPayload, isNotNull);
      final capturedBytes = Uint8List.fromList(escapedPayload!);

      // Stream 2 runs startChunkedConversion with completely different bytes
      final payload2 = utf8.encode(
        '{"overridden": true, "padding": "some extra data"}',
      );
      final sink2 = JsonCodableDecoder.startChunkedConversion<void>(
        ChunkedConversionSink.withCallback((_) {}),
        (decoder) {},
      );
      sink2.add(payload2);
      sink2.close();

      expect(escapedPayload, equals(capturedBytes));
    });

    test(
      '2b. decoder.reader.bytes Escape Guard (Use-After-Free Protection)',
      () {
        // Stream 1 retains reader.bytes without ever touching decoder.payload.
        final first = utf8.encode('[11111111,22222222,33333333]');
        Uint8List? retained;
        final sink1 = JsonCodableDecoder.startChunkedConversion<void>(
          ChunkedConversionSink.withCallback((_) {}),
          (decoder) {
            retained = _asNullable(
              (decoder as JsonCodableDecoder).reader.bytes,
            );
          },
        );
        sink1
          ..add(first)
          ..close();

        expect(retained, isNotNull);
        final snapshot = Uint8List.fromList(retained!);

        // Stream 2 decodes a different payload and must not overwrite retained.
        final sink2 = JsonCodableDecoder.startChunkedConversion<void>(
          ChunkedConversionSink.withCallback((_) {}),
          (decoder) {},
        );
        sink2
          ..add(utf8.encode('[99999999,88888888,77777777]'))
          ..close();

        expect(retained, equals(snapshot));
      },
    );

    test('3. Re-Entrant / Nested startChunkedConversion Safety', () {
      final outerPayload = utf8.encode('{"outer": true}');
      final innerPayload = utf8.encode('["inner", "nested"]');

      Uint8List? outerDecodedBytes;
      Uint8List? innerDecodedBytes;

      final outerSink = JsonCodableDecoder.startChunkedConversion<void>(
        ChunkedConversionSink.withCallback((_) {}),
        (outerDecoder) {
          outerDecodedBytes = Uint8List.fromList(outerDecoder.payload!);

          // Re-entrant decoding inside the decode callback
          final innerSink = JsonCodableDecoder.startChunkedConversion<void>(
            ChunkedConversionSink.withCallback((_) {}),
            (innerDecoder) {
              innerDecodedBytes = Uint8List.fromList(innerDecoder.payload!);
            },
          );
          innerSink.add(innerPayload);
          innerSink.close();

          // Outer payload should still be unharmed after innerSink finishes
          expect(outerDecoder.payload, equals(outerPayload));
        },
      );

      outerSink.add(outerPayload);
      outerSink.close();

      expect(outerDecodedBytes, equals(outerPayload));
      expect(innerDecodedBytes, equals(innerPayload));
    });

    test('4. addSlice with non-zero start and partial end offsets', () {
      final rawData = utf8.encode('IGNORED[1, 2, 3]IGNORED');

      Uint8List? finalPayload;
      final sink = JsonCodableDecoder.startChunkedConversion<void>(
        ChunkedConversionSink.withCallback((_) {}),
        (decoder) {
          finalPayload = Uint8List.fromList(decoder.payload!);
        },
      );

      sink.addSlice(rawData, 7, 9, false);
      sink.addSlice(rawData, 9, 16, true);

      expect(finalPayload, equals(utf8.encode('[1, 2, 3]')));
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
        (decoder) {
          final unkeyed = decoder.unkeyed();
          expect(unkeyed.hasNext(), isTrue);
          decodedValue = unkeyed.readInt();
          expect(unkeyed.hasNext(), isFalse);
        },
      );

      sink.add(largeBytes);
      sink.close();
      expect(decodedValue, equals(1));

      // Subsequent small decode must NOT inherit a >4MB buffer from the pool
      final small = utf8.encode('{}');
      Uint8List? smallPayload;
      int? smallBufferLength;
      final sink2 = JsonCodableDecoder.startChunkedConversion<void>(
        ChunkedConversionSink.withCallback((_) {}),
        (decoder) {
          smallPayload = decoder.payload;
          smallBufferLength = decoder.payload?.buffer.lengthInBytes;
        },
      );
      sink2.add(small);
      sink2.close();

      expect(smallPayload, equals(small));
      if (smallBufferLength != null) {
        expect(
          smallBufferLength,
          lessThanOrEqualTo(4 * 1024 * 1024),
          reason: 'Buffers > 4MB must not be retained in the static pool',
        );
      }
    });

    test('6. ScratchByteAccumulator reuse after release(canPool: false)', () {
      final acc = ScratchByteAccumulator();
      acc.add([1, 2, 3]);
      acc.release(canPool: false);

      // Re-adding after release(canPool: false) must recover from 0-length
      // buffer without hanging and start at index 0.
      acc.add([4, 5, 6, 7]);
      final bytes = acc.takeBytes();
      expect(bytes, equals([4, 5, 6, 7]));
      acc.release(canPool: true);
    });

    test(
      '7. Small uniform double list in large payload shrinks backing buffer',
      () {
        // 2-row uniform coordinate array followed by 100 KB of whitespace
        final jsonText = '[{"x":1.5,"y":2.5},{"x":3.5,"y":4.5}]${' ' * 100000}';
        final payload = Uint8List.fromList(utf8.encode(jsonText));

        Float64List? result;
        final sink = JsonCodableDecoder.startChunkedConversion<void>(
          ChunkedConversionSink.withCallback((_) {}),
          (decoder) {
            result = decoder.decodeUniformDoubleList(const [
              ['x'],
              ['y'],
            ]);
          },
        );
        sink.add(payload);
        sink.close();

        expect(result, equals([1.5, 2.5, 3.5, 4.5]));
        expect(
          result!.buffer.lengthInBytes,
          equals(4 * 8),
          reason:
              'Tiny array in 100KB payload must not pin the oversized buffer',
        );
      },
    );
  });
}
