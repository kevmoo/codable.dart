// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:typed_data';

import 'package:checks/checks.dart';
import 'package:codable/codable.dart';
import 'package:codable_toml/codable_toml.dart';
import 'package:test/test.dart';

final class _TlsConfig {
  final bool enabled;
  final String minVersion;

  const _TlsConfig({required this.enabled, required this.minVersion});
}

final class _TlsConfigEncodable implements Encodable<_TlsConfig> {
  const _TlsConfigEncodable();

  @override
  void encode(_TlsConfig value, Encoder encoder) {
    encoder.keyed(length: 2)
      ..encodeBool('enabled', value.enabled)
      ..encodeString('min_version', value.minVersion);
  }
}

/// Intentionally encodes subtable `tls` BEFORE scalar `host` and `port`.
final class _ServerNode {
  final _TlsConfig tls;
  final String host;
  final int port;

  const _ServerNode({
    required this.tls,
    required this.host,
    required this.port,
  });
}

final class _ServerNodeEncodable implements Encodable<_ServerNode> {
  const _ServerNodeEncodable();

  @override
  void encode(_ServerNode value, Encoder encoder) {
    encoder.keyed(length: 3)
      ..encodeValue('tls', value.tls, const _TlsConfigEncodable())
      ..encodeString('host', value.host)
      ..encodeInt('port', value.port);
  }
}

final class _Point {
  final int x;
  final int y;

  const _Point(this.x, this.y);
}

final class _PointEncodable implements Encodable<_Point> {
  const _PointEncodable();

  @override
  void encode(_Point value, Encoder encoder) {
    encoder.keyed(length: 2)
      ..encodeInt('x', value.x)
      ..encodeInt('y', value.y);
  }
}

final class _EmptyStruct {
  const _EmptyStruct();
}

final class _EmptyStructEncodable implements Encodable<_EmptyStruct> {
  const _EmptyStructEncodable();

  @override
  void encode(_EmptyStruct value, Encoder encoder) {
    encoder.keyed(length: 0);
  }
}

void _encodeNestedDepth(int remaining, Encoder encoder) {
  final keyed = encoder.keyed(length: 1);
  if (remaining <= 1) {
    keyed.encodeInt('leaf', 42);
  } else {
    _encodeNestedDepth(remaining - 1, keyed.nestedEncoder('n'));
  }
}

void main() {
  _registerTableReorderingTests();
  _registerNestedAndEmptyTableTests();
  _registerArrayAndInlineTableTests();
  _registerKeyAndStringEscapingTests();
  _registerDateTimeAndBytesTests();
  _registerNumericAndJsFloatTests();
  _registerMapAndNullableFieldTests();
  _registerBoundaryExceptionTests();
}

void _registerTableReorderingTests() {
  group('Table declaration-order independence', () {
    test('emits scalars and inline arrays before subtables and [[items]]', () {
      final toml = TomlCodableEncoder.encode<void>(
        null,
        Encodable.fromFunction((_, encoder) {
          encoder.keyed()
            ..encodeValue(
              'tls',
              const _TlsConfig(enabled: true, minVersion: '1.3'),
              const _TlsConfigEncodable(),
            )
            ..encodeList('servers', const [
              _ServerNode(
                tls: _TlsConfig(enabled: true, minVersion: '1.3'),
                host: '10.0.0.1',
                port: 8443,
              ),
              _ServerNode(
                tls: _TlsConfig(enabled: false, minVersion: '1.2'),
                host: '10.0.0.2',
                port: 8080,
              ),
            ], const _ServerNodeEncodable())
            ..encodeString('service', 'edge-gateway')
            ..encodeIntList('ports', const [80, 443])
            ..encodeBool('active', true);
        }),
      );

      check(toml).equals(
        'service = "edge-gateway"\n'
        'ports = [80, 443]\n'
        'active = true\n'
        '\n'
        '[tls]\n'
        'enabled = true\n'
        'min_version = "1.3"\n'
        '\n'
        '[[servers]]\n'
        'host = "10.0.0.1"\n'
        'port = 8443\n'
        '\n'
        '[servers.tls]\n'
        'enabled = true\n'
        'min_version = "1.3"\n'
        '\n'
        '[[servers]]\n'
        'host = "10.0.0.2"\n'
        'port = 8080\n'
        '\n'
        '[servers.tls]\n'
        'enabled = false\n'
        'min_version = "1.2"\n',
      );
    });
  });
}

void _registerNestedAndEmptyTableTests() {
  group('3-level nested tables & empty vs intermediate parent tables', () {
    test('suppresses empty intermediate parent headers for [a.b.c]', () {
      final toml = TomlCodableEncoder.encode<void>(
        null,
        Encodable.fromFunction((_, encoder) {
          final a = encoder.keyed().nestedEncoder('a');
          final b = a.keyed().nestedEncoder('b');
          b.keyed().encodeInt('c_val', 99);
        }),
      );

      check(toml).equals(
        '[a.b]\n'
        'c_val = 99\n',
      );

      final threeDeep = TomlCodableEncoder.encode<void>(
        null,
        Encodable.fromFunction((_, encoder) {
          final a = encoder.keyed().nestedEncoder('a');
          final b = a.keyed().nestedEncoder('b');
          final c = b.keyed().nestedEncoder('c');
          c.keyed()
            ..encodeString('region', 'us-central1')
            ..encodeInt('replicas', 3);
        }),
      );

      check(threeDeep).equals(
        '[a.b.c]\n'
        'region = "us-central1"\n'
        'replicas = 3\n',
      );
    });

    test('retains parent header when parent has own scalar entries', () {
      final toml = TomlCodableEncoder.encode<void>(
        null,
        Encodable.fromFunction((_, encoder) {
          final aKeyed = encoder.keyed().nestedEncoder('a').keyed();
          final bKeyed = aKeyed.nestedEncoder('b').keyed();
          bKeyed.nestedEncoder('c').keyed().encodeInt('leaf', 7);
          aKeyed.encodeString('env', 'prod');
        }),
      );

      check(toml).equals(
        '[a]\n'
        'env = "prod"\n'
        '\n'
        '[a.b.c]\n'
        'leaf = 7\n',
      );
    });

    test('emits explicit header for genuinely empty structs and maps', () {
      final emptyRoot = TomlCodableEncoder.encode(
        const _EmptyStruct(),
        const _EmptyStructEncodable(),
      );
      check(emptyRoot).equals('');

      final nestedEmpty = TomlCodableEncoder.encode<void>(
        null,
        Encodable.fromFunction((_, encoder) {
          final root = encoder.keyed()
            ..encodeValue(
              'empty_struct',
              const _EmptyStruct(),
              const _EmptyStructEncodable(),
            );
          root.nestedEncoder('empty_map').map(length: 0);
          final a = root.nestedEncoder('a').keyed();
          a.nestedEncoder('deep_empty').keyed(length: 0);
        }),
      );

      check(nestedEmpty).equals(
        '[empty_struct]\n'
        '\n'
        '[empty_map]\n'
        '\n'
        '[a.deep_empty]\n',
      );
    });

    test('suppresses intermediate parent header above [[parent.items]]', () {
      final toml = TomlCodableEncoder.encode<void>(
        null,
        Encodable.fromFunction((_, encoder) {
          encoder.keyed().nestedEncoder('cluster').keyed().encodeList(
            'nodes',
            const [_Point(1, 2), _Point(3, 4)],
            const _PointEncodable(),
          );
        }),
      );

      check(toml).equals(
        '[[cluster.nodes]]\n'
        'x = 1\n'
        'y = 2\n'
        '\n'
        '[[cluster.nodes]]\n'
        'x = 3\n'
        'y = 4\n',
      );
    });
  });
}

void _registerArrayAndInlineTableTests() {
  group('[[array_of_tables]] vs empty [] vs 2D inline tables', () {
    test('emits key = [] inline for empty List<Model> and scalar lists', () {
      final toml = TomlCodableEncoder.encode<void>(
        null,
        Encodable.fromFunction((_, encoder) {
          encoder.keyed()
            ..encodeList('points', const <_Point>[], const _PointEncodable())
            ..encodeIntList('ids', const [])
            ..encodeDoubleList('weights', const [0.5, 1.5])
            ..encodeStringList('labels', const ['a', 'b'])
            ..encodeBoolList('flags', const [true, false]);
        }),
      );

      check(toml).equals(
        'points = []\n'
        'ids = []\n'
        'weights = [0.5, 1.5]\n'
        'labels = ["a", "b"]\n'
        'flags = [true, false]\n',
      );
    });

    test('preserves [[items]] headers even when item tables are empty', () {
      final toml = TomlCodableEncoder.encode<void>(
        null,
        Encodable.fromFunction((_, encoder) {
          encoder.keyed().encodeList('slots', const [
            _EmptyStruct(),
            _EmptyStruct(),
          ], const _EmptyStructEncodable());
        }),
      );

      check(toml).equals(
        '[[slots]]\n'
        '\n'
        '[[slots]]\n',
      );
    });

    test('renders 2D List<List<Model>> and mixed arrays as inline tables', () {
      final toml = TomlCodableEncoder.encode<void>(
        null,
        Encodable.fromFunction((_, encoder) {
          final root = encoder.keyed();
          final outer = root.nestedEncoder('grid').unkeyed(length: 2);
          outer.nestedEncoder().unkeyed(length: 2).encodeList(const [
            _Point(1, 2),
            _Point(3, 4),
          ], const _PointEncodable());
          outer.nestedEncoder().unkeyed(length: 0);

          final mixed1d = root.nestedEncoder('mixed_1d').unkeyed(length: 2)
            ..encodeInt(99);
          mixed1d.encodeElement(const _Point(5, 6), const _PointEncodable());

          final mixed = root.nestedEncoder('mixed_nested').unkeyed(length: 1);
          final innerRow = mixed.nestedEncoder().unkeyed(length: 2);
          innerRow.nestedEncoder().keyed(length: 0);
          final complexItem = innerRow.nestedEncoder().keyed();
          complexItem.encodeString('k.1', 'v');
          complexItem.nestedEncoder('meta').keyed().encodeBool('ok', true);
        }),
      );

      check(toml).equals(
        'grid = [[{ x = 1, y = 2 }, { x = 3, y = 4 }], []]\n'
        'mixed_1d = [99, { x = 5, y = 6 }]\n'
        'mixed_nested = [[{}, { "k.1" = "v", meta = { ok = true } }]]\n',
      );
    });
  });
}

void _registerKeyAndStringEscapingTests() {
  group('TOML v1.0 key quoting and basic string escaping', () {
    test('quotes empty, dotted, spaced, quoted, and Unicode keys', () {
      final toml = TomlCodableEncoder.encode<void>(
        null,
        Encodable.fromFunction((_, encoder) {
          final k = encoder.keyed()
            ..encodeInt('bare_key-01', 1)
            ..encodeInt('', 2)
            ..encodeInt('site.google.com', 3)
            ..encodeInt('first name', 4)
            ..encodeInt('quote"back\\slash', 5)
            ..encodeInt('🚀', 6);
          k.nestedEncoder('sub.v1').keyed().encodeString('line\nkey', 'ok');
        }),
      );

      check(toml).equals(
        'bare_key-01 = 1\n'
        '"" = 2\n'
        '"site.google.com" = 3\n'
        '"first name" = 4\n'
        r'"quote\"back\\slash" = 5'
        '\n'
        '"🚀" = 6\n'
        '\n'
        '["sub.v1"]\n'
        r'"line\nkey" = "ok"'
        '\n',
      );
    });

    test('escapes control chars and preserves UTF-8 astral runes', () {
      final toml = TomlCodableEncoder.encode<void>(
        null,
        Encodable.fromFunction((_, encoder) {
          encoder.keyed()
            ..encodeString('controls', 'a"b\\c\bd\te\nf\fg\rh\x00\x1f\x7f')
            ..encodeString('unicode', 'café 🚀 日本語');
        }),
      );

      check(toml).equals(
        r'controls = "a\"b\\c\bd\te\nf\fg\rh\u0000\u001F\u007F"'
        '\n'
        'unicode = "café 🚀 日本語"\n',
      );
    });

    test('rejects unpaired UTF-16 surrogates in strings and keys', () {
      final loneSurrogate = String.fromCharCode(0xd800);
      check(
            () => TomlCodableEncoder.encode<void>(
              null,
              Encodable.fromFunction((_, encoder) {
                encoder.keyed().encodeString('bad', loneSurrogate);
              }),
            ),
          )
          .throws<TomlCodableException>()
          .has((e) => e.path, 'path')
          .deepEquals(['bad']);

      check(
        () => TomlCodableEncoder.encode<void>(
          null,
          Encodable.fromFunction((_, encoder) {
            encoder.keyed().encodeInt(loneSurrogate, 1);
          }),
        ),
      ).throws<TomlCodableException>();
    });
  });
}

void _registerDateTimeAndBytesTests() {
  group('TomlDateTimeCodec, Base64 bytes, toBytes, and userInfo', () {
    test(
      'emits unquoted RFC 3339 literals while quoting date-like strings',
      () {
        final dt = DateTime.utc(1979, 5, 27, 7, 32);
        final toml = TomlCodableEncoder.encode<void>(
          null,
          Encodable.fromFunction((_, encoder) {
            final k = encoder.keyed()
              ..encodeValue('created_at', dt, const TomlDateTimeCodec())
              ..encodeString('raw_iso', '1979-05-27T07:32:00.000Z');
            final sv = k.nestedEncoder('local_date').singleValue();
            (sv as TomlNativeDateTimeSink).writeTomlDateTime(
              const TomlDateTime(
                kind: TomlDateTimeKind.localDate,
                raw: '1979-05-27',
              ),
            );
          }),
        );

        check(toml).equals(
          'created_at = 1979-05-27T07:32:00.000Z\n'
          'raw_iso = "1979-05-27T07:32:00.000Z"\n'
          'local_date = 1979-05-27\n',
        );
      },
    );

    test(
      'encodes Uint8List as Base64 across keyed, unkeyed, and singleValue',
      () {
        final sample = Uint8List.fromList([0xde, 0xad, 0xbe, 0xef]);
        final encodable = Encodable<Uint8List>.fromFunction((bytes, encoder) {
          check(encoder.isHumanReadable).isTrue();
          check(encoder.userInfo['tag']).equals('v1');
          final k = encoder.keyed()..encodeBytes('primary', bytes);
          k.nestedEncoder('chunks').unkeyed(length: 1).encodeBytes(bytes);
          k.nestedEncoder('single').singleValue().encodeBytes(bytes);
        });

        final text = TomlCodableEncoder.encode(
          sample,
          encodable,
          userInfo: const {'tag': 'v1'},
        );
        final utf8Bytes = TomlCodableEncoder.toBytes(
          sample,
          encodable,
          userInfo: const {'tag': 'v1'},
        );

        check(text).equals(
          'primary = "3q2+7w=="\n'
          'chunks = ["3q2+7w=="]\n'
          'single = "3q2+7w=="\n',
        );
        check(utf8Bytes).deepEquals(utf8.encode(text));
      },
    );
  });
}

void _registerNumericAndJsFloatTests() {
  group('Numeric bounds and JS float fidelity', () {
    test('preserves .0 on integral doubles, -0.0, inf, -inf, and nan', () {
      final toml = TomlCodableEncoder.encode<void>(
        null,
        Encodable.fromFunction((_, encoder) {
          final k = encoder.keyed()
            ..encodeDouble('one', 1.0)
            ..encodeDouble('neg_int_float', -42.0)
            ..encodeDouble('pos_zero', 0.0)
            ..encodeDouble('neg_zero', -0.0)
            ..encodeDouble('frac', 3.25)
            ..encodeDouble('sci', 1e25)
            ..encodeDouble('pos_inf', double.infinity)
            ..encodeDouble('neg_inf', double.negativeInfinity)
            ..encodeDouble('not_a_num', double.nan);
          k.nestedEncoder('arr').unkeyed(length: 4)
            ..encodeDouble(2.0)
            ..encodeDouble(-0.0)
            ..encodeDouble(double.infinity)
            ..encodeDouble(double.nan);
          k.nestedEncoder('sv').singleValue().encodeDouble(5.0);
        }),
      );

      check(toml).equals(
        'one = 1.0\n'
        'neg_int_float = -42.0\n'
        'pos_zero = 0.0\n'
        'neg_zero = -0.0\n'
        'frac = 3.25\n'
        'sci = 1e+25\n'
        'pos_inf = inf\n'
        'neg_inf = -inf\n'
        'not_a_num = nan\n'
        'arr = [2.0, -0.0, inf, nan]\n'
        'sv = 5.0\n',
      );
    });

    test('enforces JS 53-bit safe integer bounds and 64-bit VM/Wasm ints', () {
      const maxSafeJs = 0x1fffff * 0x100000000 + 0xffffffff;
      const minSafeJs = -maxSafeJs;

      final safeToml = TomlCodableEncoder.encode<void>(
        null,
        Encodable.fromFunction((_, encoder) {
          encoder.keyed()
            ..encodeInt('max_safe', maxSafeJs)
            ..encodeInt('min_safe', minSafeJs);
        }),
      );
      check(safeToml).equals(
        'max_safe = 9007199254740991\n'
        'min_safe = -9007199254740991\n',
      );

      if (identical(1, 1.0)) {
        const unsafeJs = 0x200000 * 0x100000000;
        check(
              () => TomlCodableEncoder.encode<void>(
                null,
                Encodable.fromFunction((_, encoder) {
                  encoder.keyed().encodeInt('unsafe', unsafeJs);
                }),
              ),
            )
            .throws<TomlCodableException>()
            .has((e) => e.path, 'path')
            .deepEquals(['unsafe']);
      } else {
        const maxInt64 = 0x7fffffff * 0x100000000 + 0xffffffff;
        const minInt64 = -maxInt64 - 1;
        final int64Toml = TomlCodableEncoder.encode<void>(
          null,
          Encodable.fromFunction((_, encoder) {
            encoder.keyed()
              ..encodeInt('max64', maxInt64)
              ..encodeInt('min64', minInt64);
          }),
        );
        check(int64Toml).equals(
          'max64 = 9223372036854775807\n'
          'min64 = -9223372036854775808\n',
        );
      }
    });
  });
}

void _registerMapAndNullableFieldTests() {
  group('MapEncoder scalar keys and nullable @Codable() field omission', () {
    test('encodes Map<int, V>, Map<bool, V>, and finite Map<double, V>', () {
      final toml = TomlCodableEncoder.encode<void>(
        null,
        Encodable.fromFunction((_, encoder) {
          final root = encoder.keyed();

          final intMap = root.nestedEncoder('status').map(length: 2);
          intMap.keyEncoder().singleValue().encodeInt(200);
          intMap.valueEncoder().singleValue().encodeString('ok');
          intMap.keyEncoder().singleValue().encodeInt(-1);
          intMap.valueEncoder().singleValue().encodeString('unknown');

          final boolMap = root.nestedEncoder('toggles').map(length: 2);
          boolMap.keyEncoder().singleValue().encodeBool(true);
          boolMap.valueEncoder().singleValue().encodeInt(1);
          boolMap.keyEncoder().singleValue().encodeBool(false);
          boolMap.valueEncoder().singleValue().encodeInt(0);

          final dblMap = root.nestedEncoder('thresholds').map(length: 2);
          dblMap.keyEncoder().singleValue().encodeDouble(1.0);
          dblMap.valueEncoder().singleValue().encodeString('unit');
          dblMap.keyEncoder().singleValue().encodeDouble(0.25);
          dblMap.valueEncoder().singleValue().encodeString('quarter');
        }),
      );

      check(toml).equals(
        '[status]\n'
        '200 = "ok"\n'
        '-1 = "unknown"\n'
        '\n'
        '[toggles]\n'
        'true = 1\n'
        'false = 0\n'
        '\n'
        '[thresholds]\n'
        '"1.0" = "unit"\n'
        '"0.25" = "quarter"\n',
      );
    });

    test(
      'omits null nullable struct fields cleanly via BaseKeyedEncoderMixin',
      () {
        final toml = TomlCodableEncoder.encode<void>(
          null,
          Encodable.fromFunction((_, encoder) {
            encoder.keyed()
              ..encodeString('present', 'yes')
              ..encodeNullableInt('opt_int', null)
              ..encodeNullableDouble('opt_dbl', null)
              ..encodeNullableString('opt_str', null)
              ..encodeNullableBool('opt_bool', null)
              ..encodeNullableBytes('opt_bytes', null)
              ..encodeNullableValue<_Point>(
                'opt_obj',
                null,
                const _PointEncodable(),
              )
              ..encodeNullableInt('set_int', 7);
          }),
        );

        check(toml).equals(
          'present = "yes"\n'
          'set_int = 7\n',
        );
      },
    );
  });
}

void _registerBoundaryExceptionTests() {
  group('TOML v1.0 structural boundary exceptions & depth guard', () {
    test('rejects scalar, null, array, and unwritten document roots', () {
      check(
        () => TomlCodableEncoder.encode<int>(
          42,
          Encodable.fromFunction((v, e) => e.singleValue().encodeInt(v)),
        ),
      ).throws<TomlCodableException>();

      check(
        () => TomlCodableEncoder.encode<void>(
          null,
          Encodable.fromFunction((_, e) => e.singleValue().encodeNull()),
        ),
      ).throws<TomlCodableException>();

      check(
        () => TomlCodableEncoder.encode<List<int>>(
          const [1, 2],
          Encodable.fromFunction((v, e) {
            final u = e.unkeyed(length: v.length);
            for (final item in v) {
              u.encodeInt(item);
            }
          }),
        ),
      ).throws<TomlCodableException>();

      check(() => TomlCodableEncoder().toTomlString())
          .throws<TomlCodableException>();
    });

    test('rejects explicit null in KeyedEncoder, UnkeyedEncoder, and Map', () {
      check(
            () => TomlCodableEncoder.encode<void>(
              null,
              Encodable.fromFunction((_, e) {
                e.keyed().nestedEncoder('props').keyed().encodeNull('missing');
              }),
            ),
          )
          .throws<TomlCodableException>()
          .has((e) => e.path, 'path')
          .deepEquals(['props', 'missing']);

      check(
            () => TomlCodableEncoder.encode<void>(
              null,
              Encodable.fromFunction((_, e) {
                e.keyed().nestedEncoder('nums').unkeyed()
                  ..encodeInt(10)
                  ..encodeNullableInt(null);
              }),
            ),
          )
          .throws<TomlCodableException>()
          .has((e) => e.path, 'path')
          .deepEquals(['nums', 1]);

      check(
            () => TomlCodableEncoder.encode<void>(
              null,
              Encodable.fromFunction((_, e) {
                final m = e.keyed().nestedEncoder('labels').map(length: 1);
                m.keyEncoder().singleValue().encodeInt(404);
                m.valueEncoder().singleValue().encodeNullableString(null);
              }),
            ),
          )
          .throws<TomlCodableException>()
          .has((e) => e.path, 'path')
          .deepEquals(['labels', '404']);
    });

    test('rejects null, bytes, non-finite double, and composite map keys', () {
      // Null map key
      check(
        () => TomlCodableEncoder.encode<void>(
          null,
          Encodable.fromFunction((_, e) {
            final m = e.map(length: 1);
            m.keyEncoder().singleValue().encodeNull();
          }),
        ),
      ).throws<TomlCodableException>();

      // Bytes map key
      check(
        () => TomlCodableEncoder.encode<void>(
          null,
          Encodable.fromFunction((_, e) {
            final m = e.map(length: 1);
            m.keyEncoder().singleValue().encodeBytes(Uint8List.fromList([1]));
          }),
        ),
      ).throws<TomlCodableException>();

      // Non-finite double map key
      check(
        () => TomlCodableEncoder.encode<void>(
          null,
          Encodable.fromFunction((_, e) {
            final m = e.map(length: 1);
            m.keyEncoder().singleValue().encodeDouble(double.nan);
          }),
        ),
      ).throws<TomlCodableException>();

      // Struct/table map key
      check(
        () => TomlCodableEncoder.encode<void>(
          null,
          Encodable.fromFunction((_, e) {
            final m = e.keyed().nestedEncoder('coords').map(length: 1);
            const _PointEncodable().encode(const _Point(1, 2), m.keyEncoder());
          }),
        ),
      ).throws<TomlCodableException>().has((e) => e.path, 'path').deepEquals([
        'coords',
        0,
      ]);

      // List map key
      check(
        () => TomlCodableEncoder.encode<void>(
          null,
          Encodable.fromFunction((_, e) {
            final m = e.map(length: 1);
            m.keyEncoder().unkeyed(length: 1).encodeInt(1);
          }),
        ),
      ).throws<TomlCodableException>();

      // Unwritten map key encoder fails fast when valueEncoder() is requested
      check(
        () => TomlCodableEncoder.encode<void>(
          null,
          Encodable.fromFunction((_, e) {
            final m = e.keyed().nestedEncoder('labels').map(length: 1);
            m.keyEncoder();
            m.valueEncoder();
          }),
        ),
      ).throws<TomlCodableException>().which(
        (it) => it
          ..has((e) => e.path, 'path').deepEquals(['labels', 0])
          ..has((e) => e.message, 'message').contains('did not write a key'),
      );

      // Duplicate stringified keys in MapEncoder (`1` and `'1'`)
      check(
        () => TomlCodableEncoder.encode<void>(
          null,
          Encodable.fromFunction((_, e) {
            final m = e.map(length: 2);
            m.keyEncoder().singleValue().encodeInt(1);
            m.valueEncoder().singleValue().encodeString('int');
            m.keyEncoder().singleValue().encodeString('1');
            m.valueEncoder().singleValue().encodeString('str');
          }),
        ),
      ).throws<TomlCodableException>();
    });

    test('enforces container recursion depth limit of 64', () {
      final depth64 = TomlCodableEncoder.encode<void>(
        null,
        Encodable.fromFunction((_, encoder) => _encodeNestedDepth(64, encoder)),
      );
      check(depth64).contains('leaf = 42');

      check(
            () => TomlCodableEncoder.encode<void>(
              null,
              Encodable.fromFunction(
                (_, encoder) => _encodeNestedDepth(65, encoder),
              ),
            ),
          )
          .throws<TomlCodableException>()
          .has((e) => e.path.length, 'path.length')
          .equals(64);
    });
  });
}
