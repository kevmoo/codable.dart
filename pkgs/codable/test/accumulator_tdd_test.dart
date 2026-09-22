import 'dart:convert';
import 'dart:typed_data';

import 'package:codable/codable_json.dart';
import 'package:test/test.dart';

Uint8List? _asNullable(Uint8List? b) => b;

void main() {
  group('ScratchByteAccumulator TDD', () {
    test('1. Cross-Stream Pool Reuse & Truncation Safety', () {
      // 100 KB JSON payload
      final largeBytes = Uint8List(100 * 1024);
      largeBytes.fillRange(0, largeBytes.length, 32); // ' '
      largeBytes[0] = 91; // '['
      largeBytes[largeBytes.length - 1] = 93; // ']'

      int? firstLength;
      int? firstBufferLength;
      final sink1 = JsonCodableDecoder.startChunkedConversion<void>(
        ChunkedConversionSink.withCallback((_) {}),
        (decoder) {
          final bytes = _asNullable(
            (decoder as JsonCodableDecoder).reader.bytes,
          );
          firstLength = bytes?.length;
          firstBufferLength = bytes?.buffer.lengthInBytes;
          if (bytes != null) {
            expect(
              bytes.offsetInBytes % 8,
              0,
              reason: 'payload must be 8-byte aligned',
            );
            Float64List.sublistView(bytes, 0, 0); // Smoke test
          }
        },
      );
      sink1.add(largeBytes);
      sink1.close();
      expect(firstLength, equals(largeBytes.length));

      // 200-byte JSON payload
      final smallPayload = utf8.encode('{"a":1,"b":2}${' ' * 187}');
      expect(smallPayload.length, 200);

      int? secondLength;
      Uint8List? secondPayload;
      int? secondBufferLength;

      final sink2 = JsonCodableDecoder.startChunkedConversion<void>(
        ChunkedConversionSink.withCallback((_) {}),
        (decoder) {
          final bytes = _asNullable(
            (decoder as JsonCodableDecoder).reader.bytes,
          );
          secondLength = bytes?.length;
          secondBufferLength = bytes?.buffer.lengthInBytes;
          // Capture list elements to ensure trailing garbage from Stream 1
          // didn't leak into the 200-byte logical slice.
          if (bytes != null) {
            secondPayload = Uint8List.fromList(bytes);
          }
        },
      );
      sink2.add(smallPayload);
      sink2.close();

      expect(secondLength, equals(smallPayload.length));
      expect(secondPayload, equals(smallPayload));

      // Verify pool reuse: capacity from Stream 1 (100+ KB) is reused for
      // Stream 2.
      if (secondBufferLength != null && firstBufferLength != null) {
        expect(
          secondBufferLength,
          equals(firstBufferLength),
          reason: 'Stream 2 should reuse strictly pooled buffer from Stream 1',
        );
      }
    });

    test('2. decoder.payload Escape Guard (Use-After-Free Protection)', () {
      final payload1 = utf8.encode('[1, 2, 3]');

      Uint8List? escapedPayload;
      final sink1 = JsonCodableDecoder.startChunkedConversion<void>(
        ChunkedConversionSink.withCallback((_) {}),
        (decoder) {
          // Take a sublistView to strictly hold a reference to the buffer
          // slice. The underlying buffer must not be mutated by reuse.
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

      // escapedPayload from Stream 1 should not be corrupted by Stream 2
      expect(escapedPayload, equals(capturedBytes));
    });

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

      // addSlice(chunk, start, end, isLast)
      // "[1": index 7..9
      sink.addSlice(rawData, 7, 9, false);
      // ", 2, 3]": index 9..16
      sink.addSlice(rawData, 9, 16, true);

      expect(finalPayload, equals(utf8.encode('[1, 2, 3]')));
    });

    test('5. > 4 MB Pool Cap Release', () {
      // Create a payload > 4MB
      final largeBytes = Uint8List(4 * 1024 * 1024 + 1024);
      largeBytes.fillRange(0, largeBytes.length, 32);
      largeBytes[0] = 91; // '['
      largeBytes[largeBytes.length - 1] = 93; // ']'

      int? finalizedLength;
      int? largeBufferLength;
      final sink = JsonCodableDecoder.startChunkedConversion<void>(
        ChunkedConversionSink.withCallback((_) {}),
        (decoder) {
          final bytes = _asNullable(
            (decoder as JsonCodableDecoder).reader.bytes,
          );
          finalizedLength = bytes?.length;
          largeBufferLength = bytes?.buffer.lengthInBytes;
        },
      );

      sink.add(largeBytes);
      sink.close();

      expect(finalizedLength, equals(largeBytes.length));

      // Subsequent small decode
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

      // Ensure the >4MB buffer was NOT retained in the pool
      if (smallBufferLength != null && largeBufferLength != null) {
        expect(
          smallBufferLength,
          lessThan(largeBufferLength!),
          reason: 'Buffers > 4MB must not be retained in the static pool',
        );
      }
    });
  });
}
