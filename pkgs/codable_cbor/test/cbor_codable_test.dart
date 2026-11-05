// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:typed_data';

import 'package:checks/checks.dart';
import 'package:codable/codable.dart';
import 'package:codable_cbor/codable_cbor.dart';
import 'package:test/test.dart';

import '../example/codable_cbor_example.dart';
import 'fuzz/cbor_fuzz.dart';

part 'cbor_codable_test.g.dart';

enum FramePriority { low, normal, urgent }

@Codable()
final class CborEnvelope {
  final int id;
  final FramePriority priority;
  final Uint8List body;
  final Uint8List? digest;
  final Map<int, String> headers;
  final List<double> metrics;

  const CborEnvelope({
    required this.id,
    this.priority = FramePriority.normal,
    required this.body,
    this.digest,
    this.headers = const {},
    this.metrics = const [],
  });
}

void main() {
  _registerGeneratedModelTests();
  _registerIntegerWidthAndJsSafeTests();
  _registerFloatAndZeroCopyTests();
  _registerCursorDrainAndEncoderErrorTests();
  _registerMalformedAndFuzzSmokeTests();
}

void _registerGeneratedModelTests() {
  group('@Codable CBOR roundtrip & example verification', () {
    test('roundtrips CborEnvelope and SensorBatch with definite headers', () {
      final envelope = CborEnvelope(
        id: 9001,
        priority: FramePriority.urgent,
        body: Uint8List.fromList([0x00, 0x7f, 0x80, 0xff]),
        headers: const {1: 'trace-id', 256: 'span-id'},
        metrics: const [1.25, -0.5, 0.0],
      );
      final encoded = CborCodableEncoder.encode(
        envelope,
        const CborEnvelopeCodable(),
      );
      final decoded = CborCodableDecoder.decode(
        encoded,
        const CborEnvelopeCodable(),
      );
      check(decoded.id).equals(9001);
      check(decoded.priority).equals(FramePriority.urgent);
      check(decoded.body).deepEquals([0x00, 0x7f, 0x80, 0xff]);
      check(decoded.digest).isNull();
      check(decoded.headers).deepEquals({1: 'trace-id', 256: 'span-id'});
      check(decoded.metrics).deepEquals([1.25, -0.5, 0.0]);

      final batch = SensorBatch(
        batchId: 42,
        rawSample: Uint8List.fromList([10, 20, 30]),
        readings: Float64List.fromList([98.6, 99.1]),
        calibrationOffsets: {const SensorCoordinate(2, 5): -0.75},
      );
      final batchBytes = CborCodableEncoder.encode(
        batch,
        const SensorBatchCodable(),
      );
      final decodedBatch = CborCodableDecoder.decode(
        batchBytes,
        const SensorBatchCodable(),
      );
      check(decodedBatch.batchId).equals(42);
      check(decodedBatch.rawSample).deepEquals([10, 20, 30]);
      check(decodedBatch.readings).deepEquals([98.6, 99.1]);
      check(decodedBatch.calibrationOffsets)
          .deepEquals({const SensorCoordinate(2, 5): -0.75});
    });
  });
}

void _registerIntegerWidthAndJsSafeTests() {
  group('RFC 8949 integer widths and JS 53-bit / VM 64-bit bounds', () {
    test('roundtrips unsigned and negative ints across all header widths', () {
      const twoPow32 = 0x100000000;
      final maxSafeJs = 0x1fffff * twoPow32 + 0xffffffff;
      final values = <int>[
        0,
        23,
        24,
        255,
        256,
        65535,
        65536,
        0xffffffff,
        twoPow32,
        1700000000123,
        maxSafeJs,
        -1,
        -24,
        -25,
        -256,
        -257,
        -65536,
        -65537,
        -twoPow32,
        -maxSafeJs,
      ];
      if (!identical(1.0, 1)) {
        final maxInt64 = 0x7fffffff * twoPow32 + 0xffffffff;
        final minInt64 = -maxInt64 - 1;
        values.addAll([maxInt64, minInt64]);
      }

      final intListCodec = Codable<List<int>>.fromFunctions(
        decode: (d) => [for (final u = d.unkeyed(); u.moveNext();) u.readInt()],
        encode: (list, e) {
          final u = e.unkeyed(length: list.length);
          for (final v in list) {
            u.encodeInt(v);
          }
        },
      );

      final bytes = CborCodableEncoder.encode(values, intListCodec);
      final decoded = CborCodableDecoder.decode(bytes, intListCodec);
      check(decoded).deepEquals(values);
    });

    test('rejects uint64 values exceeding signed 64-bit or JS 53-bit range', () {
      // 0x1b followed by 0xffffffffffffffff (2^64 - 1) overflows on all targets
      final maxUint64 = Uint8List.fromList([
        0x1b,
        0xff,
        0xff,
        0xff,
        0xff,
        0xff,
        0xff,
        0xff,
        0xff,
      ]);
      check(
        () => CborCodableDecoder.decode<int>(
          maxUint64,
          Decodable.fromFunction((d) => d.singleValue().readInt()),
        ),
      ).throws<CodableException>();

      if (identical(1.0, 1)) {
        // 2^53 (hi = 0x00200000, lo = 0) exceeds JS safe integer precision
        final aboveJsSafe = Uint8List.fromList([
          0x1b,
          0x00,
          0x20,
          0x00,
          0x00,
          0x00,
          0x00,
          0x00,
          0x00,
        ]);
        check(
          () => CborCodableDecoder.decode<int>(
            aboveJsSafe,
            Decodable.fromFunction((d) => d.singleValue().readInt()),
          ),
        ).throws<CodableException>();
      }
    });
  });
}

void _registerFloatAndZeroCopyTests() {
  group('RFC 8949 float16/float32/float64 and zero-copy Uint8List views', () {
    test('decodes positive, negative, subnormal, inf, and NaN float16s', () {
      // [0.0, -0.0, smallest subnormal 0x0001, -1.0 (0xbc00), 65504.0 (0x7bff),
      //  +inf (0x7c00), -inf (0xfc00), NaN (0x7e00)]
      final payload = Uint8List.fromList([
        0x88,
        0xf9,
        0x00,
        0x00,
        0xf9,
        0x80,
        0x00,
        0xf9,
        0x00,
        0x01,
        0xf9,
        0xbc,
        0x00,
        0xf9,
        0x7b,
        0xff,
        0xf9,
        0x7c,
        0x00,
        0xf9,
        0xfc,
        0x00,
        0xf9,
        0x7e,
        0x00,
      ]);
      final decoded = CborCodableDecoder.decode<List<double>>(
        payload,
        Decodable.fromFunction(
          (d) => [for (final u = d.unkeyed(); u.moveNext();) u.readDouble()],
        ),
      );
      check(decoded[0]).equals(0.0);
      check(decoded[1].isNegative).isTrue();
      check(decoded[2]).isGreaterThan(0.0);
      check(decoded[3]).equals(-1.0);
      check(decoded[4]).equals(65504.0);
      check(decoded[5]).equals(double.infinity);
      check(decoded[6]).equals(double.negativeInfinity);
      check(decoded[7].isNaN).isTrue();
    });

    test(
      'returns zero-copy sublistView over input buffer for Major Type 2',
      () {
        final raw = Uint8List.fromList([11, 22, 33, 44, 55]);
        final cbor = CborCodableEncoder.encode<Uint8List>(
          raw,
          Encodable.fromFunction((v, e) => e.singleValue().encodeBytes(v)),
        );
        final view = CborCodableDecoder.decode<Uint8List>(
          cbor,
          Decodable.fromFunction((d) {
            check(d.isHumanReadable).isFalse();
            check(d.peekKind()).equals(ValueKind.bytes);
            return d.singleValue().readBytes();
          }),
        );
        check(view).deepEquals(raw);
        check(view.offsetInBytes).equals(1);
        cbor[1] = 99;
        check(view[0]).equals(99);
      },
    );
  });
}

void _registerCursorDrainAndEncoderErrorTests() {
  group(
    'Streaming cursor auto-draining, MappedDecoder, and encoder guards',
    () {
      test('drains partially consumed nested arrays and maps cleanly', () {
        // Outer array: [ [10, 20, 30], {1: "a", 2: "b"}, 99 ]
        final encoded = CborCodableEncoder.encode<void>(
          null,
          Encodable.fromFunction((_, e) {
            final outer = e.unkeyed(length: 3);
            final innerArr = outer.nestedEncoder().unkeyed(length: 3);
            innerArr
              ..encodeInt(10)
              ..encodeInt(20)
              ..encodeInt(30);
            final innerMap = outer.nestedEncoder().map(length: 2);
            innerMap.keyEncoder().singleValue().encodeInt(1);
            innerMap.valueEncoder().singleValue().encodeString('a');
            innerMap.keyEncoder().singleValue().encodeInt(2);
            innerMap.valueEncoder().singleValue().encodeString('b');
            outer.encodeInt(99);
          }),
        );

        final result = CborCodableDecoder.decode<(int, int, int)>(
          encoded,
          Decodable.fromFunction((d) {
            final outer = d.unkeyed();
            check(outer.moveNext()).isTrue();
            final innerArr = outer.nestedDecoder().unkeyed();
            check(innerArr.moveNext()).isTrue();
            final firstElem = innerArr.readInt(); // leave 20, 30 unread!

            check(outer.moveNext()).isTrue();
            final innerMap = outer.nestedDecoder().map();
            check(innerMap.moveNextEntry()).isTrue();
            final firstMapKey = innerMap
                .keyDecoder()
                .singleValue()
                .readInt(); // leave value & entry 2 unread!

            check(outer.moveNext()).isTrue();
            final trailing = outer.readInt();
            return (firstElem, firstMapKey, trailing);
          }),
        );
        check(result).equals((10, 1, 99));
      });

      test('supports MappedDecoder random access and skips non-text keys', () {
        // Map of 3 entries: { 7: [1, 2], "target": 42, "flag": true }
        final cbor = Uint8List.fromList([
          0xa3,
          0x07,
          0x82,
          0x01,
          0x02,
          0x66,
          ...utf8.encode('target'),
          0x18,
          42,
          0x64,
          ...utf8.encode('flag'),
          0xf5,
        ]);
        final decoder = CborCodableDecoder.fromBytes(cbor);
        final mapped = decoder.mapped();
        check(mapped.containsKey('target')).isTrue();
        check(mapped.containsKey('absent')).isFalse();
        check(mapped.readInt('target')).equals(42);
        check(mapped.readBool('flag')).isTrue();

        // Rewind handoff to KeyedDecoder skips integer key 7 cleanly
        final opts = KeyOptions.of(const ['target']);
        final keyed = decoder.keyed(options: opts);
        final indices = <int>[];
        while (keyed.moveNextKey()) {
          final idx = keyed.selectKeyIndex(opts);
          indices.add(idx);
          if (idx == 0) {
            check(keyed.readInt()).equals(42);
          } else {
            keyed.skipValue();
          }
        }
        check(indices).deepEquals([-1, 0, -1]);
      });

      test(
        'validates fixed container lengths and dangling MapEncoder keys',
        () {
          check(
            () => CborCodableEncoder.encode<void>(
              null,
              Encodable.fromFunction((_, e) {
                e.keyed(length: 2).encodeInt('onlyOne', 1);
              }),
            ),
          ).throws<CodableException>();

          check(
            () => CborCodableEncoder.encode<void>(
              null,
              Encodable.fromFunction((_, e) {
                e.unkeyed(length: 2).encodeInt(1);
              }),
            ),
          ).throws<CodableException>();

          check(
            () => CborCodableEncoder.encode<void>(
              null,
              Encodable.fromFunction((_, e) {
                final m = e.map();
                m.keyEncoder().singleValue().encodeInt(1);
              }),
            ),
          ).throws<CodableException>();
        },
      );
    },
  );
}

void _registerMalformedAndFuzzSmokeTests() {
  group('Malformed CBOR bounds, invalid UTF-8, and fuzz target smoke run', () {
    test('throws CodableException without OOM on truncated huge headers', () {
      final malformedVectors = <List<int>>[
        const [], // empty
        const [0x9f, 0x01, 0xff], // indefinite array
        const [0xbf, 0x61, 0x61, 0x01, 0xff], // indefinite map
        const [0x5f, 0xff], // indefinite bstr
        const [0x9a, 0x7f, 0xff, 0xff, 0xff], // 2B-element array in 5 bytes
        const [0xba, 0x7f, 0xff, 0xff, 0xff], // 2B-entry map in 5 bytes
        const [0x5a, 0x7f, 0xff, 0xff, 0xff], // 2GB bstr in 5 bytes
        const [0x7a, 0x7f, 0xff, 0xff, 0xff], // 2GB tstr in 5 bytes
        const [0x62, 0xc3, 0x28], // invalid UTF-8 in text string
        const [0xc0, 0x00], // unsupported Major Type 6 tag
        const [0xf8, 0x20], // unsupported Major Type 7 simple value
        const [0x1a, 0x00, 0x01], // truncated uint32
        const [0xfb, 0x3f, 0xf0], // truncated float64
      ];

      for (final vec in malformedVectors) {
        final bytes = Uint8List.fromList(vec);
        // fuzzTarget verifies only CodableException is thrown (never RangeError/OOM)
        fuzzTarget(bytes);
        check(
          () => CborCodableDecoder.decode<Object?>(
            bytes,
            const Decodable.fromFunction(_decodeAnyMalformedProbe),
          ),
        ).throws<CodableException>();
      }
    });

    test('executes cbor_fuzz target cleanly on valid composite corpus', () {
      final validBytes = CborCodableEncoder.encode(
        CborEnvelope(
          id: 77,
          body: Uint8List.fromList([1, 2, 3]),
          headers: const {200: 'ok'},
          metrics: const [3.14],
        ),
        const CborEnvelopeCodable(),
      );
      fuzzTarget(Uint8List(0));
      fuzzTarget(validBytes);
    });
  });
}

Object? _decodeAnyMalformedProbe(Decoder d) => switch (d.peekKind()) {
  ValueKind.list => d.unkeyed().decodeFloat64List(),
  ValueKind.map => [
    for (final m = d.map(); m.moveNextEntry();)
      (
        m.keyDecoder().singleValue().readInt(),
        m.valueDecoder().singleValue().readInt(),
      ),
  ],
  ValueKind.string => d.singleValue().readString(),
  ValueKind.bytes => d.singleValue().readBytes(),
  ValueKind.number => d.singleValue().readDouble(),
  ValueKind.boolean => d.singleValue().readBool(),
  ValueKind.nullValue => () {
    d.singleValue().readNull();
    return null;
  }(),
};
