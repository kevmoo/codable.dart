// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:typed_data';

import 'package:checks/checks.dart';
import 'package:codable/codable.dart';
import 'package:codable/codable_json.dart';
import 'package:codable/codable_streaming.dart' as streaming;
import 'package:codable/src/json/driver/dart_object_decoder.dart';
import 'package:test/test.dart';

void main() {
  _registerWasmAndCrossPlatformEncoderTests();
  _registerObjectHasOwnTests();
  _registerNullableSpanAndUtf8FatalTests();
  _registerPayloadAndMappedHandoffTests();
}

void _registerWasmAndCrossPlatformEncoderTests() {
  group('JsonCodableEncoder numeric fidelity & non-finite rejection', () {
    test('preserves 64-bit int precision on VM and dart2wasm', () {
      if (identical(1.0, 1)) return;
      const twoPow32 = 0x100000000;
      final twoPow53Plus1 = 0x200000 * twoPow32 + 1;
      final maxInt64 = 0x7fffffff * twoPow32 + 0xffffffff;
      final minInt64 = -maxInt64 - 1;
      final values = <int>[twoPow53Plus1, -twoPow53Plus1, maxInt64, minInt64];

      final intListCodec = Codable<List<int>>.fromFunctions(
        decode: (d) {
          final k = d.keyed();
          check(k.moveNextKey()).isTrue();
          check(k.nextKey()).equals('nums');
          return k.decodeIntList();
        },
        encode: (list, e) => e.keyed(length: 1).encodeIntList('nums', list),
      );

      final text = JsonCodableEncoder.encode(values, intListCodec);
      check(text).contains('9007199254740993');
      check(text).contains('-9007199254740993');
      check(text).contains('9223372036854775807');
      check(text).contains('-9223372036854775808');

      final fromStr = intListCodec.decode(JsonCodableDecoder.fromString(text));
      check(fromStr).deepEquals(values);

      final bytes = JsonCodableEncoder.toBytes(values, intListCodec);
      final fromBytes = intListCodec.decode(
        JsonCodableDecoder.fromBytes(bytes),
      );
      check(fromBytes).deepEquals(values);
    });

    test('preserves -0.0 and integral doubles on streaming/Wasm/VM', () {
      final doubles = <double>[-0.0, 0.0, 1.0, -42.0, 3.25];
      final doubleListCodec = Codable<List<double>>.fromFunctions(
        decode: (d) => [
          for (final u = d.unkeyed(); u.moveNext();) u.readDouble(),
        ],
        encode: (list, e) {
          final u = e.unkeyed(length: list.length);
          for (final item in list) {
            u.encodeDouble(item);
          }
        },
      );

      final streamText = streaming.JsonCodableEncoder.encode(
        doubles,
        doubleListCodec,
      );
      check(streamText).equals('[-0.0,0.0,1.0,-42.0,3.25]');
      final streamBytes = streaming.JsonCodableEncoder.toBytes(
        doubles,
        doubleListCodec,
      );
      check(utf8.decode(streamBytes)).equals('[-0.0,0.0,1.0,-42.0,3.25]');

      final text = JsonCodableEncoder.encode(doubles, doubleListCodec);
      final bytes = JsonCodableEncoder.toBytes(doubles, doubleListCodec);
      if (!identical(1.0, 1)) {
        check(text).equals('[-0.0,0.0,1.0,-42.0,3.25]');
        check(utf8.decode(bytes)).equals('[-0.0,0.0,1.0,-42.0,3.25]');
        final parsed = doubleListCodec.decode(
          JsonCodableDecoder.fromBytes(bytes),
        );
        check(parsed[0].isNegative).isTrue();
        check(parsed[1].isNegative).isFalse();
        check(parsed[2]).equals(1.0);
        check(parsed[3]).equals(-42.0);
        check(parsed[4]).equals(3.25);
      } else {
        final parsed = doubleListCodec.decode(
          JsonCodableDecoder.fromBytes(bytes),
        );
        check(parsed[2]).equals(1.0);
        check(parsed[3]).equals(-42.0);
        check(parsed[4]).equals(3.25);
      }
    });

    test('rejects NaN and infinities across all encoder containers', () {
      for (final bad in <double>[
        double.nan,
        double.infinity,
        double.negativeInfinity,
      ]) {
        for (final userInfo in const <Map<Object, Object?>>[
          {},
          {#forceJsDom: true},
        ]) {
          check(
            () => JsonCodableEncoder.encode<double>(
              bad,
              Encodable.fromFunction((v, e) => e.singleValue().encodeDouble(v)),
              userInfo: userInfo,
            ),
          ).throws<UnsupportedError>();

          check(
            () => JsonCodableEncoder.toBytes<double>(
              bad,
              Encodable.fromFunction(
                (v, e) => e.singleValue().encodeNullableDouble(v),
              ),
              userInfo: userInfo,
            ),
          ).throws<UnsupportedError>();

          check(
            () => JsonCodableEncoder.encode<double>(
              bad,
              Encodable.fromFunction(
                (v, e) => e.keyed(length: 1).encodeDouble('x', v),
              ),
              userInfo: userInfo,
            ),
          ).throws<UnsupportedError>();

          check(
            () => JsonCodableEncoder.encode<double>(
              bad,
              Encodable.fromFunction(
                (v, e) => e.keyed(length: 1).encodeNullableDouble('x', v),
              ),
              userInfo: userInfo,
            ),
          ).throws<UnsupportedError>();

          check(
            () => JsonCodableEncoder.encode<double>(
              bad,
              Encodable.fromFunction(
                (v, e) => e.keyed(length: 1).encodeDoubleList('x', [1.0, v]),
              ),
              userInfo: userInfo,
            ),
          ).throws<UnsupportedError>();

          check(
            () => JsonCodableEncoder.encode<double>(
              bad,
              Encodable.fromFunction(
                (v, e) => e.unkeyed(length: 1).encodeDouble(v),
              ),
              userInfo: userInfo,
            ),
          ).throws<UnsupportedError>();

          check(
            () => JsonCodableEncoder.encode<double>(
              bad,
              Encodable.fromFunction(
                (v, e) => e.unkeyed(length: 1).encodeNullableDouble(v),
              ),
              userInfo: userInfo,
            ),
          ).throws<UnsupportedError>();

          check(
            () => JsonCodableEncoder.encode<double>(
              bad,
              Encodable.fromFunction((v, e) {
                final m = e.map(length: 1);
                m.keyEncoder().singleValue().encodeString('k');
                m.valueEncoder().singleValue().encodeDouble(v);
              }),
              userInfo: userInfo,
            ),
          ).throws<UnsupportedError>();

          check(
            () => JsonCodableEncoder.encode<double>(
              bad,
              Encodable.fromFunction((v, e) {
                final m = e.map(length: 1);
                m.keyEncoder().singleValue().encodeString('k');
                m.valueEncoder().singleValue().encodeNullableDouble(v);
              }),
              userInfo: userInfo,
            ),
          ).throws<UnsupportedError>();
        }
      }
    });
  });
}

void _registerObjectHasOwnTests() {
  group('Object.hasOwn isolation from Object.prototype keys', () {
    const protoKeys = <String>[
      'constructor',
      'toString',
      'valueOf',
      'hasOwnProperty',
    ];

    test('ignores inherited Object.prototype properties on empty {}', () {
      final emptyBytes = Uint8List.fromList(utf8.encode('{}'));
      for (final userInfo in const <Map<Object, Object?>>[
        {},
        {#forceJsDom: true},
      ]) {
        final mapped = JsonCodableDecoder.fromBytes(
          emptyBytes,
          userInfo: userInfo,
        ).mapped();
        for (final key in protoKeys) {
          check(mapped.containsKey(key)).isFalse();
          check(mapped.isNull(key)).isTrue();
          check(mapped.peekKind(key)).equals(ValueKind.nullValue);
          check(mapped.readNullableString(key)).isNull();
        }

        final opts = KeyOptions.of(protoKeys);
        final keyed = JsonCodableDecoder.fromBytes(
          emptyBytes,
          userInfo: userInfo,
        ).keyed(options: opts);
        check(keyed.moveNextKey()).isFalse();

        final uniformDec = JsonCodableDecoder.fromBytes(
          Uint8List.fromList(utf8.encode('[{"valueOf": 1.5, "alt": 2.5}]')),
          userInfo: userInfo,
        );
        check(
          uniformDec.decodeUniformDoubleList(const [
            ['constructor', 'valueOf'],
            ['toString', 'alt'],
          ]),
        ).isNotNull().deepEquals([1.5, 2.5]);
      }
    });

    test('reads explicit own properties named after Object.prototype keys', () {
      const explicitJson =
          '{"constructor":10,"toString":"s","valueOf":true,"hasOwnProperty":4}';
      final bytes = Uint8List.fromList(utf8.encode(explicitJson));
      final opts = KeyOptions.of(protoKeys);

      for (final userInfo in const <Map<Object, Object?>>[
        {},
        {#forceJsDom: true},
      ]) {
        final mapped = JsonCodableDecoder.fromBytes(
          bytes,
          userInfo: userInfo,
        ).mapped();
        check(mapped.containsKey('constructor')).isTrue();
        check(mapped.readInt('constructor')).equals(10);
        check(mapped.readString('toString')).equals('s');
        check(mapped.readBool('valueOf')).isTrue();
        check(mapped.readInt('hasOwnProperty')).equals(4);

        final keyed = JsonCodableDecoder.fromBytes(
          bytes,
          userInfo: userInfo,
        ).keyed(options: opts);
        final indices = <int>[];
        while (keyed.moveNextKey()) {
          indices.add(keyed.selectKeyIndex(opts));
          keyed.skipValue();
        }
        check(indices).deepEquals([0, 1, 2, 3]);
      }
    });
  });
}

void _registerNullableSpanAndUtf8FatalTests() {
  group('readNullableStringSpan on null, fatal UTF-8, and FormatException', () {
    test('readNullableStringSpan consumes null without UnsupportedError', () {
      final objBytes = Uint8List.fromList(
        utf8.encode('{"nullable": null, "after": 99}'),
      );
      final arrBytes = Uint8List.fromList(utf8.encode('[null, 42]'));
      final nullBytes = Uint8List.fromList(utf8.encode('null'));

      for (final userInfo in const <Map<Object, Object?>>[
        {},
        {#forceJsDom: true},
      ]) {
        final keyed = JsonCodableDecoder.fromBytes(
          objBytes,
          userInfo: userInfo,
        ).keyed();
        check(keyed.moveNextKey()).isTrue();
        check(keyed.nextKey()).equals('nullable');
        check(keyed.readNullableStringSpan()).isNull();
        check(keyed.moveNextKey()).isTrue();
        check(keyed.nextKey()).equals('after');
        check(keyed.readInt()).equals(99);
        check(keyed.moveNextKey()).isFalse();

        final unkeyed = JsonCodableDecoder.fromBytes(
          arrBytes,
          userInfo: userInfo,
        ).unkeyed();
        check(unkeyed.moveNext()).isTrue();
        check(unkeyed.readNullableStringSpan()).isNull();
        check(unkeyed.moveNext()).isTrue();
        check(unkeyed.readInt()).equals(42);
        check(unkeyed.moveNext()).isFalse();

        final single = JsonCodableDecoder.fromBytes(
          nullBytes,
          userInfo: userInfo,
        ).singleValue();
        check(single.readNullableStringSpan()).isNull();
      }
    });

    test('rejects invalid UTF-8 and malformed JSON with FormatException', () {
      final invalidUtf8Vectors = <Uint8List>[
        Uint8List.fromList(const [0xff]),
        Uint8List.fromList(const [0x22, 0xc3, 0x28, 0x22]),
        Uint8List.fromList(const [0x22, 0xed, 0xa0, 0x80, 0x22]),
      ];

      for (final badUtf8 in invalidUtf8Vectors) {
        for (final userInfo in const <Map<Object, Object?>>[
          {},
          {#forceJsDom: true},
        ]) {
          check(() {
            final d = JsonCodableDecoder.fromBytes(badUtf8, userInfo: userInfo);
            d.singleValue().readString();
          }).throws<FormatException>();
        }
      }

      for (final malformed in const <String>['{bad', '[1, 2', '', 'tru']) {
        final malformedBytes = Uint8List.fromList(utf8.encode(malformed));
        for (final userInfo in const <Map<Object, Object?>>[
          {},
          {#forceJsDom: true},
        ]) {
          check(() {
            final d = JsonCodableDecoder.fromString(
              malformed,
              userInfo: userInfo,
            );
            d.singleValue().readInt();
          }).throws<FormatException>();

          check(() {
            final d = JsonCodableDecoder.fromBytes(
              malformedBytes,
              userInfo: userInfo,
            );
            d.singleValue().readInt();
          }).throws<FormatException>();
        }
      }
    });
  });
}

void _registerPayloadAndMappedHandoffTests() {
  group('Decoder.payload & mapped() -> unkeyed()/singleValue() handoff', () {
    test(
      'mapped() followed by unkeyed() or singleValue() throws CodableException',
      () {
        final objBytes = Uint8List.fromList(utf8.encode('{"id": 7}'));

        for (final makeDecoder in <Decoder Function()>[
          () => JsonCodableDecoder.fromBytes(objBytes),
          () => JsonCodableDecoder.fromBytes(
            objBytes,
            userInfo: const {#forceJsDom: true},
          ),
          () => streaming.JsonCodableDecoder.fromBytes(objBytes),
        ]) {
          final decForUnkeyed = makeDecoder();
          check(decForUnkeyed.mapped().readInt('id')).equals(7);
          check(decForUnkeyed.payload).isNull();
          check(decForUnkeyed.unkeyed)
              .throws<CodableException>()
              .has((e) => e.actualValue, 'actualValue')
              .isNull();

          final decForScalar = makeDecoder();
          check(decForScalar.mapped().containsKey('id')).isTrue();
          check(() => decForScalar.singleValue().readInt())
              .throws<CodableException>()
              .has((e) => e.actualValue, 'actualValue')
              .isNull();

          final decForSingleDecode = makeDecoder();
          check(decForSingleDecode.mapped().containsKey('id')).isTrue();
          final extracted = decForSingleDecode.singleValue().decode<int>(
            Decodable.fromFunction((d) {
              final k = d.keyed();
              check(k.moveNextKey()).isTrue();
              check(k.nextKey()).equals('id');
              return k.readInt();
            }),
          );
          check(extracted).equals(7);
        }
      },
    );

    test(
      'DartObjectDecoder omits raw Map/List containers from actualValue',
      () {
        final mapObj = <String, Object?>{
          'nested': <String, Object?>{'k': 1},
        };
        final listObj = <Object?>[
          <Object?>[1, 2],
        ];

        check(() => DartObjectDecoder(mapObj).unkeyed())
            .throws<CodableException>()
            .has((e) => e.actualValue, 'actualValue')
            .isNull();

        check(() => DartObjectDecoder(listObj).keyed())
            .throws<CodableException>()
            .has((e) => e.actualValue, 'actualValue')
            .isNull();

        check(() => DartObjectDecoder(mapObj).mapped().readInt('nested'))
            .throws<CodableException>()
            .has((e) => e.actualValue, 'actualValue')
            .isNull();

        check(() => DartObjectDecoder(42).keyed())
            .throws<CodableException>()
            .has((e) => e.actualValue, 'actualValue')
            .equals(42);
      },
    );
  });
}
