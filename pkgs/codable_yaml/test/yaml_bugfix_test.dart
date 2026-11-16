// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:checks/checks.dart';
import 'package:codable/codable.dart';
import 'package:codable_yaml/codable_yaml.dart';
import 'package:test/test.dart';

void main() {
  _registerJsIntFidelityTests();
  _registerFloatFormattingTests();
  _registerMapEncoderAndSurrogateTests();
}

void _registerJsIntFidelityTests() {
  group('YAML JS 53-bit & VM/Wasm 64-bit integer fidelity', () {
    test(
      'enforces safe 53-bit int range on JS encode and 64-bit on VM/Wasm',
      () {
        const twoPow32 = 0x100000000;
        final maxSafeJs = 0x1fffff * twoPow32 + 0xffffffff;
        final minSafeJs = -maxSafeJs;

        final safeYaml = YamlCodableEncoder.encode<(int, int)>(
          (maxSafeJs, minSafeJs),
          Encodable.fromFunction((pair, e) {
            e.keyed(length: 2)
              ..encodeInt('max', pair.$1)
              ..encodeInt('min', pair.$2);
          }),
        );
        check(safeYaml).contains('max: 9007199254740991');
        check(safeYaml).contains('min: -9007199254740991');

        if (identical(1.0, 1)) {
          const twoPow53 = 0x200000 * twoPow32;
          for (final unsafe in <int>[twoPow53, -twoPow53]) {
            check(
                  () => YamlCodableEncoder.encode<int>(
                    unsafe,
                    Encodable.fromFunction(
                      (v, e) => e.singleValue().encodeInt(v),
                    ),
                  ),
                )
                .throws<CodableException>()
                .has((e) => e.actualValue, 'actualValue')
                .equals(unsafe);

            check(
                  () => YamlCodableEncoder.encode<int>(
                    unsafe,
                    Encodable.fromFunction(
                      (v, e) => e.keyed(length: 1).encodeNullableInt('n', v),
                    ),
                  ),
                )
                .throws<CodableException>()
                .has((e) => e.actualValue, 'actualValue')
                .equals(unsafe);

            check(
                  () => YamlCodableEncoder.encode<int>(
                    unsafe,
                    Encodable.fromFunction(
                      (v, e) => e.keyed(length: 1).encodeIntList('ns', [v]),
                    ),
                  ),
                )
                .throws<CodableException>()
                .has((e) => e.actualValue, 'actualValue')
                .equals(unsafe);
          }
        } else {
          final overSafe = 0x200000 * twoPow32 + 1;
          final maxInt64 = 0x7fffffff * twoPow32 + 0xffffffff;
          final minInt64 = -maxInt64 - 1;
          final yaml64 = YamlCodableEncoder.encode<List<int>>(
            [overSafe, maxInt64, minInt64],
            Encodable.fromFunction(
              (list, e) => e.keyed(length: 1).encodeIntList('vals', list),
            ),
          );
          final decoded64 = YamlCodableDecoder.decode<List<int>>(
            yaml64,
            Decodable.fromFunction((d) => d.mapped().decodeIntList('vals')),
          );
          check(decoded64).deepEquals([overSafe, maxInt64, minInt64]);
        }
      },
    );

    test(
      'rejects >53-bit YAML integer literals on JS decode across formats',
      () {
        const twoPow32 = 0x100000000;
        final maxSafeJs = 0x1fffff * twoPow32 + 0xffffffff;

        for (final (literal, expected) in <(String, int)>[
          ('9007199254740991', maxSafeJs),
          ('-9007199254740991', -maxSafeJs),
          ('0x1fffffffffffff', maxSafeJs),
          ('0o377777777777777777', maxSafeJs),
        ]) {
          final parsed = YamlCodableDecoder.decode<int>(
            'v: $literal\n',
            Decodable.fromFunction((d) => d.mapped().readInt('v')),
          );
          check(parsed).equals(expected);
        }

        if (identical(1.0, 1)) {
          for (final unsafeLiteral in const <String>[
            '9007199254740992',
            '9007199254740993',
            '-9007199254740992',
            '-9007199254740993',
            '+9007199254740993',
            '9223372036854775807',
            '-9223372036854775808',
            '0x20000000000000',
            '-0x20000000000000',
            '0o400000000000000000',
            '-0o400000000000000000',
          ]) {
            check(
              () => YamlCodableDecoder.decode<int>(
                'v: $unsafeLiteral\n',
                Decodable.fromFunction((d) => d.mapped().readInt('v')),
              ),
            ).throws<YamlCodableException>();

            check(
              () => YamlCodableDecoder.decode<int>(
                '- $unsafeLiteral\n',
                Decodable.fromFunction((d) {
                  final u = d.unkeyed();
                  u.moveNext();
                  return u.readInt();
                }),
              ),
            ).throws<YamlCodableException>();

            check(
              () => YamlCodableDecoder.decode<int>(
                '"$unsafeLiteral": 1\n',
                Decodable.fromFunction((d) {
                  final m = d.map();
                  m.moveNextEntry();
                  return m.keyDecoder().singleValue().readInt();
                }),
              ),
            ).throws<YamlCodableException>();
          }
        }
      },
    );
  });
}

void _registerFloatFormattingTests() {
  group('YAML float formatting (-0.0 and integral doubles on JS/VM/Wasm)', () {
    test('emits -0.0 and .0 suffix so floats roundtrip as floats on JS', () {
      final values = <double>[-0.0, 0.0, 1.0, -42.0, 1e25];
      final doubleListCodec = Codable<List<double>>.fromFunctions(
        decode: (d) => [
          for (final u = d.unkeyed(); u.moveNext();) u.readDouble(),
        ],
        encode: (list, e) {
          final u = e.unkeyed(length: list.length);
          for (final v in list) {
            u.encodeDouble(v);
          }
        },
      );

      for (final flow in const [false, true]) {
        final yaml = YamlCodableEncoder.encode(
          values,
          doubleListCodec,
          flow: flow,
        );
        check(yaml).contains('-0.0');
        check(yaml).contains('0.0');
        check(yaml).contains('1.0');
        check(yaml).contains('-42.0');

        final decoded = YamlCodableDecoder.decode(yaml, doubleListCodec);
        check(decoded[0]).equals(0.0);
        check(decoded[0].isNegative).isTrue();
        check(decoded[1]).equals(0.0);
        check(decoded[1].isNegative).isFalse();
        check(decoded[2]).equals(1.0);
        check(decoded[3]).equals(-42.0);
        check(decoded[4]).equals(1e25);

        // Verify YAML parses 1.0 as float (so readInt rejects it even on JS!)
        check(
          () => YamlCodableDecoder.decode<int>(
            YamlCodableEncoder.encode<double>(
              1.0,
              Encodable.fromFunction((v, e) => e.singleValue().encodeDouble(v)),
              flow: flow,
            ),
            Decodable.fromFunction((d) => d.singleValue().readInt()),
          ),
        ).throws<YamlCodableException>();
      }
    });
  });
}

void _registerMapEncoderAndSurrogateTests() {
  group('YAML MapEncoder invariants & lone UTF-16 surrogate rejection', () {
    test('rejects unwritten key, duplicate keyEncoder, missing key, and dangling key', () {
      // 1. valueEncoder() without keyEncoder()
      check(
        () => YamlCodableEncoder.encode<void>(
          null,
          Encodable.fromFunction((_, e) {
            e.map().valueEncoder();
          }),
        ),
      ).throws<CodableException>();

      // 2. keyEncoder() called without writing a key before valueEncoder()
      check(
        () => YamlCodableEncoder.encode<void>(
          null,
          Encodable.fromFunction((_, e) {
            final m = e.map();
            m.keyEncoder();
            m.valueEncoder();
          }),
        ),
      ).throws<CodableException>();

      // 3. keyEncoder() called twice without valueEncoder()
      check(
        () => YamlCodableEncoder.encode<void>(
          null,
          Encodable.fromFunction((_, e) {
            final m = e.map();
            m.keyEncoder().singleValue().encodeString('a');
            m.keyEncoder();
          }),
        ),
      ).throws<CodableException>();

      // 4. Finishes/emits YAML while a pending key has no encoded value (block & flow)
      for (final flow in const [false, true]) {
        check(
          () => YamlCodableEncoder.encode<void>(
            null,
            Encodable.fromFunction((_, e) {
              final m = e.map();
              m.keyEncoder().singleValue().encodeString('dangling');
            }),
            flow: flow,
          ),
        ).throws<CodableException>();

        check(
          () => YamlCodableEncoder.encode<void>(
            null,
            Encodable.fromFunction((_, e) {
              final m = e.map();
              m.keyEncoder().singleValue().encodeString('dangling');
              m.valueEncoder(); // opened but no value written
            }),
            flow: flow,
          ),
        ).throws<CodableException>();

        check(
          () => YamlCodableEncoder.encode<void>(
            null,
            Encodable.fromFunction((_, e) {
              final nested = e.keyed().nestedEncoder('inner').map();
              nested.keyEncoder().singleValue().encodeString('dangling');
            }),
            flow: flow,
          ),
        ).throws<CodableException>();
      }
    });

    test(
      'rejects unpaired UTF-16 surrogates while preserving valid emoji pairs',
      () {
        final validEmoji = YamlCodableEncoder.encode<String>(
          'hello 🚀 𝄞',
          Encodable.fromFunction((v, e) => e.singleValue().encodeString(v)),
        );
        check(
          YamlCodableDecoder.decode<String>(
            validEmoji,
            Decodable.fromFunction((d) => d.singleValue().readString()),
          ),
        ).equals('hello 🚀 𝄞');

        for (final bad in const <String>[
          '\uD800',
          'prefix\uDBFFsuffix',
          '\uDC00',
          'end\uDFFF',
          '\uDC00\uD800',
        ]) {
          check(
                () => YamlCodableEncoder.encode<String>(
                  bad,
                  Encodable.fromFunction(
                    (v, e) => e.singleValue().encodeString(v),
                  ),
                ),
              )
              .throws<CodableException>()
              .has((e) => e.actualValue, 'actualValue')
              .equals(bad);

          check(
                () => YamlCodableEncoder.encode<String>(
                  bad,
                  Encodable.fromFunction(
                    (v, e) => e.keyed(length: 1).encodeString('k', v),
                  ),
                ),
              )
              .throws<CodableException>()
              .has((e) => e.actualValue, 'actualValue')
              .equals(bad);

          check(
                () => YamlCodableEncoder.encode<String>(
                  bad,
                  Encodable.fromFunction(
                    (v, e) => e.keyed(length: 1).encodeInt(v, 1),
                  ),
                ),
              )
              .throws<CodableException>()
              .has((e) => e.actualValue, 'actualValue')
              .equals(bad);
        }
      },
    );
  });
}
