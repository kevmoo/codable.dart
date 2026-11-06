// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:typed_data';

import 'package:checks/checks.dart';
import 'package:codable/codable.dart';
import 'package:codable_msgpack/codable_msgpack.dart';
import 'package:test/test.dart';

import 'fuzz/msgpack_fuzz.dart';

Uint8List _encodeIntScalar(int value) => MsgPackCodableEncoder.encode<int>(
  value,
  Encodable.fromFunction((v, e) => e.singleValue().encodeInt(v)),
  requireKnownLength: true,
);

int _decodeIntScalar(Uint8List bytes) => MsgPackCodableDecoder.decode<int>(
  bytes,
  Decodable.fromFunction((d) => d.singleValue().readInt()),
);

void main() {
  _registerCanonicalIntegerTests();
  _registerFloatAndNumSemanticsTests();
  _registerStringAndBinaryBoundaryTests();
  _registerExtensionSkipAndNeverUsedTests();
  _registerSinglePassAndBackpatchTests();
  _registerCursorMappedAndDepthLimitTests();
  _registerMalformedAndFuzzTests();
}

void _registerCanonicalIntegerTests() {
  group(
    'MessagePack canonical integer widths & JS 53-bit / VM 64-bit bounds',
    () {
      test(
        'emits smallest canonical integer header at every width boundary',
        () {
          const twoPow32 = 0x100000000;
          const maxSafeJs = 0x1fffff * twoPow32 + 0xffffffff;

          // (value, expectedFirstByte, expectedTotalLength)
          final cases = <(int, int, int)>[
            (0, 0x00, 1), // positive fixint min
            (127, 0x7f, 1), // positive fixint max
            (128, 0xcc, 2), // uint8 min
            (255, 0xcc, 2), // uint8 max
            (256, 0xcd, 3), // uint16 min
            (65535, 0xcd, 3), // uint16 max
            (65536, 0xce, 5), // uint32 min
            (0xffffffff, 0xce, 5), // uint32 max
            (twoPow32, 0xcf, 9), // uint64 min
            (maxSafeJs, 0xcf, 9), // JS max safe int (2^53 - 1)
            (-1, 0xff, 1), // negative fixint max
            (-32, 0xe0, 1), // negative fixint min
            (-33, 0xd0, 2), // int8 max
            (-128, 0xd0, 2), // int8 min
            (-129, 0xd1, 3), // int16 max
            (-32768, 0xd1, 3), // int16 min
            (-32769, 0xd2, 5), // int32 max
            (-0x80000000, 0xd2, 5), // int32 min
            (-0x80000001, 0xd3, 9), // int64 max
            (-twoPow32, 0xd3, 9), // -2^32
            (-twoPow32 - 1, 0xd3, 9), // -2^32 - 1
            (-maxSafeJs, 0xd3, 9), // JS min safe int (-(2^53 - 1))
          ];
          if (!identical(1.0, 1)) {
            final maxInt64 = 0x7fffffff * twoPow32 + 0xffffffff;
            final minInt64 = -maxInt64 - 1;
            cases.addAll([(maxInt64, 0xcf, 9), (minInt64, 0xd3, 9)]);
          }

          for (final (value, expectedTag, expectedLen) in cases) {
            final bytes = _encodeIntScalar(value);
            check(bytes.length).equals(expectedLen);
            check(bytes[0]).equals(expectedTag);
            check(_decodeIntScalar(bytes)).equals(value);
          }
        },
      );

      test('decodes non-canonical positive int8/16/32/64 wire encodings', () {
        // Positive 42 encoded via int8, int16, int32, and int64 wire tags
        final encodings = <List<int>>[
          const [0xd0, 42],
          const [0xd1, 0x00, 42],
          const [0xd2, 0x00, 0x00, 0x00, 42],
          const [0xd3, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 42],
        ];
        for (final raw in encodings) {
          check(_decodeIntScalar(Uint8List.fromList(raw))).equals(42);
        }
      });

      test(
        'rejects uint64/int64 values outside safe target integer bounds',
        () {
          // uint64 0xffffffffffffffff overflows signed 64-bit on VM/Wasm and 53-bit on JS
          final maxUint64 = Uint8List.fromList(const [
            0xcf,
            0xff,
            0xff,
            0xff,
            0xff,
            0xff,
            0xff,
            0xff,
            0xff,
          ]);
          check(() => _decodeIntScalar(maxUint64)).throws<CodableException>();

          if (identical(1.0, 1)) {
            // +2^53 (0x00200000_00000000) in uint64 and int64
            final uint64AboveJs = Uint8List.fromList(const [
              0xcf,
              0x00,
              0x20,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
            ]);
            final int64AboveJs = Uint8List.fromList(const [
              0xd3,
              0x00,
              0x20,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
            ]);
            // -2^53 (0xffe00000_00000000) in int64 -> outside [-0x1FFFFFFFFFFFFF, 0x1FFFFFFFFFFFFF]
            final int64BelowJs = Uint8List.fromList(const [
              0xd3,
              0xff,
              0xe0,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
            ]);
            for (final unsafe in [uint64AboveJs, int64AboveJs, int64BelowJs]) {
              check(() => _decodeIntScalar(unsafe)).throws<CodableException>();
            }
            // Also reject unsafe JS integers on encode!
            const unsafePos = 0x200000 * 0x100000000;
            check(() => _encodeIntScalar(unsafePos)).throws<CodableException>();
            check(() => _encodeIntScalar(-unsafePos))
                .throws<CodableException>();
          }
        },
      );
    },
  );
}

void _registerFloatAndNumSemanticsTests() {
  group('MessagePack float32/float64 and readInt/readDouble/readNum', () {
    test(
      'handles float32, float64, -0.0, Inf, NaN, and 1.0 cleanly on JS/VM',
      () {
        // Array of 6 elements:
        // [ float32(1.5), float32(1.0), float64(-0.0), float64(+Inf), float64(NaN), fixint(7) ]
        final bd = ByteData(1 + 5 + 5 + 9 + 9 + 9 + 1);
        var p = 0;
        bd.setUint8(p++, 0x96); // fixarray(6)
        bd.setUint8(p++, 0xca);
        bd.setFloat32(p, 1.5);
        p += 4;
        bd.setUint8(p++, 0xca);
        bd.setFloat32(p, 1.0);
        p += 4;
        bd.setUint8(p++, 0xcb);
        bd.setFloat64(p, -0.0);
        p += 8;
        bd.setUint8(p++, 0xcb);
        bd.setFloat64(p, double.infinity);
        p += 8;
        bd.setUint8(p++, 0xcb);
        bd.setFloat64(p, double.nan);
        p += 8;
        bd.setUint8(p++, 7);
        final payload = bd.buffer.asUint8List();

        // readDouble() accepts both floats and integers
        final asDoubles = MsgPackCodableDecoder.decode<List<double>>(
          payload,
          Decodable.fromFunction(
            (d) => [for (final u = d.unkeyed(); u.moveNext();) u.readDouble()],
          ),
        );
        check(asDoubles[0]).equals(1.5);
        check(asDoubles[1]).equals(1.0);
        check(asDoubles[2].isNegative).isTrue();
        check(asDoubles[3]).equals(double.infinity);
        check(asDoubles[4].isNaN).isTrue();
        check(asDoubles[5]).equals(7.0);

        // readNum() returns double for float32/float64 and int for integer tags
        final asNums = MsgPackCodableDecoder.decode<List<num>>(
          payload,
          Decodable.fromFunction(
            (d) => [for (final u = d.unkeyed(); u.moveNext();) u.readNum()],
          ),
        );
        check(asNums[0]).isA<double>().equals(1.5);
        check(asNums[1]).equals(1.0);
        if (!identical(1.0, 1)) {
          check(asNums[1]).isA<double>();
        }
        check(asNums[2].toDouble().isNegative).isTrue();
        check(asNums[5]).isA<int>().equals(7);

        // readInt() strictly rejects float32(1.0) and float64(1.0) even on JS!
        final float32One = Uint8List.fromList([0xca, 0x3f, 0x80, 0x00, 0x00]);
        final float64One = Uint8List.fromList([
          0xcb,
          0x3f,
          0xf0,
          0x00,
          0x00,
          0x00,
          0x00,
          0x00,
          0x00,
        ]);
        check(() => _decodeIntScalar(float32One)).throws<CodableException>();
        check(() => _decodeIntScalar(float64One)).throws<CodableException>();
      },
    );
  });
}

void _registerStringAndBinaryBoundaryTests() {
  group('MessagePack fixstr/str8/str16/str32 and zero-copy bin8/16/32', () {
    test(
      'roundtrips strings across fixstr, str8, str16, and str32 headers',
      () {
        final strCodec = Codable<String>.fromFunctions(
          decode: (d) => d.singleValue().readString(),
          encode: (v, e) => e.singleValue().encodeString(v),
        );

        for (final (len, expectedTag) in const [
          (0, 0xa0),
          (31, 0xbf),
          (32, 0xd9),
          (255, 0xd9),
          (256, 0xda),
          (65536, 0xdb),
        ]) {
          final text = 'a' * len;
          final encoded = MsgPackCodableEncoder.encode(
            text,
            strCodec,
            requireKnownLength: true,
          );
          check(encoded[0]).equals(expectedTag);
          check(MsgPackCodableDecoder.decode(encoded, strCodec)).equals(text);
        }
      },
    );

    test('returns zero-copy sublistView for bin8, bin16, and bin32', () {
      final bytesCodec = Codable<Uint8List>.fromFunctions(
        decode: (d) {
          check(d.isHumanReadable).isFalse();
          check(d.peekKind()).equals(ValueKind.bytes);
          return d.singleValue().readBytes();
        },
        encode: (v, e) {
          check(e.isHumanReadable).isFalse();
          e.singleValue().encodeBytes(v);
        },
      );

      for (final (len, expectedTag, expectedHeaderBytes) in const [
        (0, 0xc4, 2),
        (255, 0xc4, 2),
        (256, 0xc5, 3),
        (65536, 0xc6, 5),
      ]) {
        final input = Uint8List.fromList(
          List<int>.generate(len, (i) => i & 0xff),
        );
        final wire = MsgPackCodableEncoder.encode(
          input,
          bytesCodec,
          requireKnownLength: true,
        );
        check(wire[0]).equals(expectedTag);
        check(wire.length).equals(expectedHeaderBytes + len);

        final view = MsgPackCodableDecoder.decode(wire, bytesCodec);
        check(view.length).equals(len);
        check(view.offsetInBytes).equals(expectedHeaderBytes);
        if (len > 0) {
          wire[expectedHeaderBytes] = 0xee;
          check(view[0]).equals(0xee);
        }
      }
    });
  });
}

void _registerExtensionSkipAndNeverUsedTests() {
  group(
    'MessagePack fixext 1..16, ext 8/16/32 skipping, and 0xc1 rejection',
    () {
      test(
        'skips all fixext and ext frames cleanly in skipValue & skipElement',
        () {
          final extFrames = <List<int>>[
            [0xd4, 0x01, 0xaa], // fixext 1
            [0xd5, 0x02, 1, 2], // fixext 2
            [0xd6, 0x03, 1, 2, 3, 4], // fixext 4
            [0xd7, 0x04, ...List<int>.filled(8, 7)], // fixext 8
            [0xd8, 0x05, ...List<int>.filled(16, 8)], // fixext 16
            [0xc7, 3, 0x10, 9, 8, 7], // ext 8 (len=3)
            [0xc8, 0x00, 4, 0x11, 1, 2, 3, 4], // ext 16 (len=4)
            [0xc9, 0x00, 0x00, 0x00, 2, 0x12, 5, 6], // ext 32 (len=2)
          ];

          // Array containing all 8 ext frames followed by integer 42
          final arrPayload = Uint8List.fromList([
            0x99, // fixarray(9)
            for (final frame in extFrames) ...frame,
            42,
          ]);
          final trailingFromArray = MsgPackCodableDecoder.decode<int>(
            arrPayload,
            Decodable.fromFunction((d) {
              final u = d.unkeyed();
              for (var i = 0; i < extFrames.length; i++) {
                check(u.moveNext()).isTrue();
                u.skipElement();
              }
              check(u.moveNext()).isTrue();
              return u.readInt();
            }),
          );
          check(trailingFromArray).equals(42);

          // Map with unknown keys whose values are ext frames, plus "ok": 99
          final mapPayload = Uint8List.fromList([
            0x89, // fixmap(9)
            for (var i = 0; i < extFrames.length; i++) ...[
              0xa2,
              0x78,
              0x30 + i, // "x0".."x7"
              ...extFrames[i],
            ],
            0xa2,
            ...utf8.encode('ok'),
            99,
          ]);
          final opts = KeyOptions.of(const ['ok']);
          final okValue = MsgPackCodableDecoder.decode<int>(
            mapPayload,
            Decodable.fromFunction((d) {
              final k = d.keyed(options: opts);
              var result = -1;
              while (k.moveNextKey()) {
                if (k.selectKeyIndex(opts) == 0) {
                  result = k.readInt();
                } else {
                  k.skipValue();
                }
              }
              return result;
            }),
          );
          check(okValue).equals(99);
        },
      );

      test(
        'always throws CodableException on 0xc1 (never used) everywhere',
        () {
          // Direct value
          check(
            () => MsgPackCodableDecoder.decode<void>(
              Uint8List.fromList(const [0xc1]),
              Decodable.fromFunction((d) => d.peekKind()),
            ),
          ).throws<CodableException>();

          // Inside skipElement()
          check(
            () => MsgPackCodableDecoder.decode<void>(
              Uint8List.fromList(const [0x91, 0xc1]),
              Decodable.fromFunction((d) {
                final u = d.unkeyed();
                u.moveNext();
                u.skipElement();
              }),
            ),
          ).throws<CodableException>();

          // Inside skipValue()
          check(
            () => MsgPackCodableDecoder.decode<void>(
              Uint8List.fromList(const [0x81, 0xa1, 0x61, 0xc1]),
              Decodable.fromFunction((d) {
                final k = d.keyed();
                k.nextKey();
                k.skipValue();
              }),
            ),
          ).throws<CodableException>();
        },
      );
    },
  );
}

void _registerSinglePassAndBackpatchTests() {
  group('Single-pass requireKnownLength enforcement & fallback patching', () {
    test(
      'requireKnownLength: true rejects missing length on keyed/unkeyed/map',
      () {
        for (final openWithoutLen in <void Function(Encoder)>[
          (e) => e.keyed(),
          (e) => e.unkeyed(),
          (e) => e.map(),
        ]) {
          check(
                () => MsgPackCodableEncoder.encode<void>(
                  null,
                  Encodable.fromFunction((_, e) => openWithoutLen(e)),
                  requireKnownLength: true,
                ),
              )
              .throws<CodableException>()
              .has((e) => e.message, 'message')
              .contains(
                'Single-pass MessagePack encoding requires upfront container length',
              );
        }
      },
    );

    test(
      'validates declared vs written count on container close / toBytes',
      () {
        check(
          () => MsgPackCodableEncoder.encode<void>(
            null,
            Encodable.fromFunction((_, e) {
              e.keyed(length: 2).encodeInt('a', 1);
            }),
            requireKnownLength: true,
          ),
        ).throws<CodableException>();

        check(
          () => MsgPackCodableEncoder.encode<void>(
            null,
            Encodable.fromFunction((_, e) {
              e.unkeyed(length: 1)
                ..encodeInt(1)
                ..encodeInt(2);
            }),
            requireKnownLength: true,
          ),
        ).throws<CodableException>();

        check(
          () => MsgPackCodableEncoder.encode<void>(
            null,
            Encodable.fromFunction((_, e) {
              e.map(length: 2);
            }),
            requireKnownLength: true,
          ),
        ).throws<CodableException>();
      },
    );

    test('requireKnownLength: false patches fixmap (<16) and map16 (>=16)', () {
      final dynamicMapCodec = Codable<Map<String, int>>.fromFunctions(
        decode: (d) {
          final k = d.keyed();
          return {for (; k.moveNextKey();) k.nextKey(): k.readInt()};
        },
        encode: (v, e) {
          final k = e.keyed(); // intentionally omits length
          for (final MapEntry(:key, :value) in v.entries) {
            k.encodeInt(key, value);
          }
        },
      );

      final small = {for (var i = 0; i < 5; i++) 'k$i': i};
      final smallBytes = MsgPackCodableEncoder.encode(small, dynamicMapCodec);
      check(smallBytes[0]).equals(0x85); // fixmap(5)
      check(MsgPackCodableDecoder.decode(smallBytes, dynamicMapCodec))
          .deepEquals(small);

      final medium = {for (var i = 0; i < 20; i++) 'field_$i': i * 3};
      final mediumBytes = MsgPackCodableEncoder.encode(medium, dynamicMapCodec);
      check(mediumBytes[0]).equals(0xde); // map16
      check(mediumBytes[1]).equals(0x00);
      check(mediumBytes[2]).equals(20);
      check(MsgPackCodableDecoder.decode(mediumBytes, dynamicMapCodec))
          .deepEquals(medium);
    });
  });
}

void _registerCursorMappedAndDepthLimitTests() {
  group('Compiled KeyOptions, MappedDecoder handoff, LIFO drain, and depth 64', () {
    test('enforces max recursion depth 64 across decode, skip, and encode', () {
      // Build nested 1-element fixarrays of depth 64 (valid) and depth 65 (rejected)
      Uint8List nestedArrays(int depth) =>
          Uint8List.fromList([...List<int>.filled(depth, 0x91), 0x2a]);

      int readNested(Decoder d, int remaining) {
        if (remaining == 0) return d.singleValue().readInt();
        final u = d.unkeyed();
        u.moveNext();
        return readNested(u.nestedDecoder(), remaining - 1);
      }

      check(
        MsgPackCodableDecoder.decode<int>(
          nestedArrays(64),
          Decodable.fromFunction((d) => readNested(d, 64)),
        ),
      ).equals(42);

      check(
        () => MsgPackCodableDecoder.decode<int>(
          nestedArrays(65),
          Decodable.fromFunction((d) => readNested(d, 65)),
        ),
      ).throws<CodableException>();

      // Skipping a 63-deep array inside root array (total depth 64) succeeds;
      // skipping a 64-deep array inside root array (total depth 65) throws!
      final skipOk = Uint8List.fromList([0x92, ...nestedArrays(63), 7]);
      check(
        MsgPackCodableDecoder.decode<int>(
          skipOk,
          Decodable.fromFunction((d) {
            final u = d.unkeyed();
            u.moveNext();
            u.skipElement();
            u.moveNext();
            return u.readInt();
          }),
        ),
      ).equals(7);

      final skipTooDeep = Uint8List.fromList([0x92, ...nestedArrays(64), 7]);
      check(
        () => MsgPackCodableDecoder.decode<int>(
          skipTooDeep,
          Decodable.fromFunction((d) {
            final u = d.unkeyed();
            u.moveNext();
            u.skipElement();
            u.moveNext();
            return u.readInt();
          }),
        ),
      ).throws<CodableException>();

      // Encoder also rejects depth 65 while allowing depth 64
      void encodeNested(Encoder e, int remaining) {
        if (remaining == 0) {
          e.singleValue().encodeInt(1);
          return;
        }
        encodeNested(e.unkeyed(length: 1).nestedEncoder(), remaining - 1);
      }

      check(
        MsgPackCodableEncoder.encode<void>(
          null,
          Encodable.fromFunction((_, e) => encodeNested(e, 64)),
          requireKnownLength: true,
        ),
      ).deepEquals(Uint8List.fromList([...List<int>.filled(64, 0x91), 1]));

      check(
        () => MsgPackCodableEncoder.encode<void>(
          null,
          Encodable.fromFunction((_, e) => encodeNested(e, 65)),
          requireKnownLength: true,
        ),
      ).throws<CodableException>();
    });

    test(
      'supports MappedDecoder -> KeyedDecoder rewind and LIFO auto-drain',
      () {
        // Map of 3 entries: { 9: [10, 20], "kind": "rect", "w": 50 }
        final wire = Uint8List.fromList([
          0x83,
          0x09,
          0x92,
          10,
          20,
          0xa4,
          ...utf8.encode('kind'),
          0xa4,
          ...utf8.encode('rect'),
          0xa1,
          ...utf8.encode('w'),
          50,
        ]);
        final decoder = MsgPackCodableDecoder.fromBytes(wire);
        final mapped = decoder.mapped();
        check(mapped.containsKey('kind')).isTrue();
        check(mapped.readString('kind')).equals('rect');
        check(mapped.readInt('w')).equals(50);

        final opts = KeyOptions.of(const ['kind', 'w']);
        final keyed = decoder.keyed(options: opts);
        final seen = <int>[];
        while (keyed.moveNextKey()) {
          final idx = keyed.selectKeyIndex(opts);
          seen.add(idx);
          if (idx == 0) {
            check(
              keyed.selectStringIndex(KeyOptions.of(const ['circle', 'rect'])),
            ).equals(1);
          } else if (idx == 1) {
            check(keyed.readInt()).equals(50);
          } else {
            keyed.skipValue();
          }
        }
        check(seen).deepEquals([-1, 0, 1]);
      },
    );
  });
}

void _registerMalformedAndFuzzTests() {
  group('Malformed MessagePack bounds and fuzz smoke tests', () {
    test(
      'rejects truncated headers and invalid UTF-8 with CodableException',
      () {
        final malformed = <List<int>>[
          const [],
          const [0xc1], // never used
          const [0xdd, 0x7f, 0xff, 0xff, 0xff], // 2B-element array in 5 bytes
          const [0xdf, 0x7f, 0xff, 0xff, 0xff], // 2B-entry map in 5 bytes
          const [0xc6, 0x7f, 0xff, 0xff, 0xff], // 2GB bin32 in 5 bytes
          const [0xdb, 0x7f, 0xff, 0xff, 0xff], // 2GB str32 in 5 bytes
          const [0xc9, 0xff, 0xff, 0xff, 0xff], // 4GB ext32 in 5 bytes
          const [0xa2, 0xc3, 0x28], // invalid UTF-8 in fixstr
          const [0xce, 0x00, 0x01], // truncated uint32
          const [0xcb, 0x3f, 0xf0], // truncated float64
        ];
        for (final raw in malformed) {
          final bytes = Uint8List.fromList(raw);
          fuzzTarget(bytes);
          check(
            () => MsgPackCodableDecoder.decode<Object?>(
              bytes,
              const Decodable.fromFunction(_decodeAnyMalformedProbe),
            ),
          ).throws<CodableException>();
        }
      },
    );
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
