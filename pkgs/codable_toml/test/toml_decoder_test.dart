// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:typed_data';

import 'package:checks/checks.dart';
import 'package:codable/codable.dart';
import 'package:codable_toml/codable_toml.dart';
import 'package:codable_toml/src/toml_types.dart' show TomlNativeDateTimeSource;
import 'package:test/test.dart';

import 'fuzz/toml_fuzz.dart';

T _decodeField<T>(String toml, T Function(KeyedDecoder keyed) read) =>
    TomlCodableDecoder.decode<T>(
      toml,
      Decodable.fromFunction((decoder) {
        final keyed = decoder.keyed();
        if (!keyed.moveNextKey()) {
          throw const CodableException('Expected at least one key');
        }
        return read(keyed);
      }),
    );

TomlDateTime? _decodeNativeDateTimeField(String toml) =>
    _decodeField(toml, (keyed) {
      final sv = keyed.nestedDecoder().singleValue();
      return (sv as TomlNativeDateTimeSource).tryReadTomlDateTime();
    });

TomlCodableException _expectTomlError(void Function() action) {
  try {
    action();
  } on TomlCodableException catch (e) {
    return e;
  }
  throw StateError('Expected TomlCodableException to be thrown');
}

sealed class _Shape {
  const _Shape();
}

final class _Circle extends _Shape {
  final double radius;
  final String label;

  const _Circle({required this.radius, required this.label});
}

final class _Box extends _Shape {
  final int width;
  final int height;
  final Map<String, int> meta;

  const _Box({required this.width, required this.height, required this.meta});
}

final class _ShapeSuperDecodable extends SuperDecodable<_Shape> {
  const _ShapeSuperDecodable();

  @override
  String get discriminatorKey => 'kind';

  @override
  Map<String, Decodable<_Shape>> get subtypes =>
      const <String, Decodable<_Shape>>{
        'circle': Decodable.fromFunction(_decodeCircle),
        'box': Decodable.fromFunction(_decodeBox),
      };
}

final KeyOptions _circleKeys = KeyOptions.of(const <String>[
  'kind',
  'radius',
  'label',
]);

_Shape _decodeCircle(Decoder decoder) {
  final keyed = decoder.keyed(options: _circleKeys);
  double? radius;
  var label = '';
  while (keyed.moveNextKey()) {
    switch (keyed.selectKeyIndex(_circleKeys)) {
      case 1:
        radius = keyed.readDouble();
      case 2:
        label = keyed.readString();
      default:
        keyed.skipValue();
    }
  }
  return _Circle(radius: radius!, label: label);
}

final KeyOptions _boxKeys = KeyOptions.of(const <String>[
  'kind',
  'width',
  'height',
  'meta',
]);

_Shape _decodeBox(Decoder decoder) {
  final keyed = decoder.keyed(options: _boxKeys);
  int? width;
  int? height;
  var meta = const <String, int>{};
  while (keyed.moveNextKey()) {
    switch (keyed.selectKeyIndex(_boxKeys)) {
      case 1:
        width = keyed.readInt();
      case 2:
        height = keyed.readInt();
      case 3:
        meta = _decodeStringIntMap(keyed.nestedDecoder());
      default:
        keyed.skipValue();
    }
  }
  return _Box(width: width!, height: height!, meta: meta);
}

Map<String, int> _decodeStringIntMap(Decoder decoder) {
  final k = decoder.keyed();
  final out = <String, int>{};
  while (k.moveNextKey()) {
    final name = k.nextKey();
    out[name] = k.readInt();
  }
  return out;
}

Map<int, String> _decodeIntKeyMap(Decoder decoder) {
  final m = decoder.map();
  final out = <int, String>{};
  while (m.moveNextEntry()) {
    final k = m.keyDecoder().singleValue().readInt();
    final v = m.valueDecoder().singleValue().readString();
    out[k] = v;
  }
  return out;
}

void main() {
  _registerStringAndCommentTests();
  _registerNumberAndBoundsTests();
  _registerDateTimeTests();
  _registerTableAndArrayStructureTests();
  _registerDecoderContainerAndPolymorphicTests();
  _registerBytesAndDepthLimitTests();
  _registerDiagnosticsAndFuzzerTests();
}

void _registerStringAndCommentTests() {
  group('TOML v1.0 comments, keys, and string literals', () {
    test('handles empty documents, UTF-8 BOM, CRLF, and Unicode comments', () {
      final map = TomlCodableDecoder.decode<Map<String, int>>(
        '\ufeff# header comment 🚀\r\n\r\na = 1 # trailing comment\r\n',
        const Decodable.fromFunction(_decodeStringIntMap),
      );
      check(map).deepEquals(<String, int>{'a': 1});

      final empty = TomlCodableDecoder.decode<Map<String, int>>(
        '   # only comment\n\t\n',
        const Decodable.fromFunction(_decodeStringIntMap),
      );
      check(empty).isEmpty();
    });

    test(
      'parses basic, multiline basic, literal, and multiline literal strings',
      () {
        const toml =
            'basic = "line1\\nline2\\t\\"quoted\\"\\\\\\u0041\\U0001F680"\n'
            'ml_basic = """\r\n'
            'Roses are red\r\n'
            'Violets are \\\r\n'
            '    \n'
            '  blue ""\\"end""""\n'
            "lit = 'C:\\Users\\nodejs\\templates'\n"
            "ml_lit = '''\n"
            'The first newline is\n'
            "trimmed in ''raw'' strings.''''\n";

        final values = TomlCodableDecoder.decode<Map<String, String>>(
          toml,
          Decodable.fromFunction((d) {
            final k = d.keyed();
            final out = <String, String>{};
            while (k.moveNextKey()) {
              out[k.nextKey()] = k.readString();
            }
            return out;
          }),
        );

        check(values['basic']).equals('line1\nline2\t"quoted"\\A🚀');
        check(values['ml_basic'])
            .equals('Roses are red\nViolets are blue """end"');
        check(values['lit']).equals(r'C:\Users\nodejs\templates');
        check(values['ml_lit'])
            .equals("The first newline is\ntrimmed in ''raw'' strings.'");
      },
    );

    test('parses bare, numeric-looking, quoted, empty, and dotted keys', () {
      const validToml = '''
bare_key-1 = "v1"
1234 = "v2"
"" = "empty_basic"
site."google.com" = true
3.14159 = "pi"

[sub]
'' = 'empty_lit'
''';
      final root = TomlCodableDecoder.fromString(validToml).mapped();
      check(root.readString('bare_key-1')).equals('v1');
      check(root.readString('1234')).equals('v2');
      check(root.readString('')).equals('empty_basic');
      check(root.nestedDecoder('site').mapped().readBool('google.com'))
          .isTrue();
      check(root.nestedDecoder('3').mapped().readString('14159')).equals('pi');
      check(root.nestedDecoder('sub').mapped().readString(''))
          .equals('empty_lit');

      // Empty basic "" and empty literal '' collide as duplicate "" key:
      check(() => TomlCodableDecoder.fromString('"" = 1\n\'\' = 2\n'))
          .throws<TomlCodableException>();
    });

    test(
      'rejects invalid escapes, surrogates, control chars, and multiline keys',
      () {
        final badInputs = <String>[
          'x = "\\x20"',
          'x = "\\/"',
          'x = "\\uD800"',
          'x = "\\uDFFF"',
          'x = "\\U00110000"',
          'x = "raw\x00null"',
          'x = "del\x7fchar"',
          'x = "single \\\n line"',
          'x = """"""""""too_many"""',
          'a = 1 # bad \x08 comment',
          'a = 1\rb = 2',
          '"""ml_key""" = 1',
          "'''ml_key''' = 1",
        ];
        for (final input in badInputs) {
          check(() => TomlCodableDecoder.fromString(input))
              .throws<TomlCodableException>();
        }
      },
    );
  });
}

void _registerNumberAndBoundsTests() {
  group(
    'TOML v1.0 integers, floats, and VM 64-bit / JS 53-bit safe bounds',
    () {
      test('parses decimal, hex, octal, binary integers and signed zeros', () {
        const toml = '''
zero = 0
pos_zero = +0
neg_zero = -0
pos = +99
neg = -17
underscored = 1_000_000
hex = 0xdead_beef
hex_lead = 0x00_ff
oct = 0o0755
bin = 0b1101_0110
''';
        final m = TomlCodableDecoder.fromString(toml).mapped();
        check(m.readInt('zero')).equals(0);
        check(m.readInt('neg_zero')).equals(0);
        check(m.readInt('neg_zero').isNegative).isFalse();
        check(m.readInt('pos_zero')).equals(0);
        check(m.readInt('pos')).equals(99);
        check(m.readInt('neg')).equals(-17);
        check(m.readInt('underscored')).equals(1000000);
        check(m.readInt('hex')).equals(0xdeadbeef);
        check(m.readInt('hex_lead')).equals(255);
        check(m.readInt('oct')).equals(493);
        check(m.readInt('bin')).equals(214);
      });

      test(
        'enforces VM/Wasm signed 64-bit and JS safe 53-bit integer bounds',
        () {
          check(_decodeField('v = 9007199254740991', (k) => k.readInt()))
              .equals(9007199254740991);
          check(_decodeField('v = -9007199254740991', (k) => k.readInt()))
              .equals(-9007199254740991);

          if (identical(1, 1.0)) {
            check(() => TomlCodableDecoder.fromString('v = 9007199254740992'))
                .throws<TomlCodableException>();
            check(() => TomlCodableDecoder.fromString('v = -9007199254740992'))
                .throws<TomlCodableException>();
            check(() => TomlCodableDecoder.fromString('v = 0x20000000000000'))
                .throws<TomlCodableException>();
          } else {
            final max64 = BigInt.parse('9223372036854775807').toInt();
            final min64 = BigInt.parse('-9223372036854775808').toInt();
            check(_decodeField('v = 9223372036854775807', (k) => k.readInt()))
                .equals(max64);
            check(_decodeField('v = -9223372036854775808', (k) => k.readInt()))
                .equals(min64);
            check(_decodeField('v = 0x7fffffffffffffff', (k) => k.readInt()))
                .equals(max64);
            check(
              () => TomlCodableDecoder.fromString('v = 9223372036854775808'),
            ).throws<TomlCodableException>();
            check(
              () => TomlCodableDecoder.fromString('v = -9223372036854775809'),
            ).throws<TomlCodableException>();
            check(() => TomlCodableDecoder.fromString('v = 0x8000000000000000'))
                .throws<TomlCodableException>();
          }
        },
      );

      test('parses standard floats, negative zero, inf, and nan', () {
        const toml = '''
pi = 3.1415
neg_zero = -0.0
exp1 = 5e+22
exp2 = 1e06
exp3 = -2E-2
both = 6.626e-34
under = 224_617.445_991_228
pinf = +inf
inf_bare = inf
ninf = -inf
nan1 = nan
nan2 = +nan
nan3 = -nan
''';
        final m = TomlCodableDecoder.fromString(toml).mapped();
        check(m.readDouble('pi')).equals(3.1415);
        final nz = m.readDouble('neg_zero');
        check(nz).equals(0.0);
        check(nz.isNegative).isTrue();
        check(m.readDouble('exp1')).equals(5e22);
        check(m.readDouble('exp2')).equals(1e6);
        check(m.readDouble('exp3')).equals(-0.02);
        check(m.readDouble('both')).equals(6.626e-34);
        check(m.readDouble('under')).equals(224617.445991228);
        check(m.readDouble('pinf')).equals(double.infinity);
        check(m.readDouble('inf_bare')).equals(double.infinity);
        check(m.readDouble('ninf')).equals(double.negativeInfinity);
        check(m.readDouble('nan1').isNaN).isTrue();
        check(m.readDouble('nan2').isNaN).isTrue();
        check(m.readDouble('nan3').isNaN).isTrue();
      });

      test('rejects malformed numbers and int/float type confusion', () {
        final invalidNumbers = <String>[
          'v = 01',
          'v = -01',
          'v = 0_1',
          'v = _10',
          'v = 10_',
          'v = 1__0',
          'v = 0X10',
          'v = +0x10',
          'v = 0x_10',
          'v = .5',
          'v = 1.',
          'v = 1.e2',
          'v = 00.5',
          'v = 1._2',
          'v = 1e_2',
          'v = Inf',
          'v = NaN',
          'v = True',
        ];
        for (final bad in invalidNumbers) {
          check(() => TomlCodableDecoder.fromString(bad))
              .throws<TomlCodableException>();
        }

        // Even on JS where identical(1, 1.0), TOML float 1.0 must NOT pass readInt()!
        check(() => _decodeField('v = 1.0', (k) => k.readInt()))
            .throws<TomlCodableException>();
        check(_decodeField('v = 42', (k) => k.readDouble())).equals(42.0);
      });
    },
  );
}

void _registerDateTimeTests() {
  group('Native TOML v1.0 Date-Times and TomlDateTimeCodec', () {
    test('parses all 4 TomlDateTime kinds and exposes string fallback', () {
      final odtZ = _decodeNativeDateTimeField('dt = 1979-05-27T07:32:00Z')!;
      check(odtZ.kind).equals(TomlDateTimeKind.offsetDateTime);
      check(odtZ.raw).equals('1979-05-27T07:32:00Z');
      check(odtZ.dateTime).equals(DateTime.utc(1979, 5, 27, 7, 32));

      final odtSpace = _decodeNativeDateTimeField(
        'dt = 1979-05-27 00:32:00.999999999-07:00',
      )!;
      check(odtSpace.kind).equals(TomlDateTimeKind.offsetDateTime);
      check(odtSpace.raw).equals('1979-05-27 00:32:00.999999999-07:00');
      check(odtSpace.dateTime)
          .equals(DateTime.utc(1979, 5, 27, 7, 32, 0, 999, 999));

      final ldt = _decodeNativeDateTimeField('dt = 1979-05-27T07:32:00.25')!;
      check(ldt.kind).equals(TomlDateTimeKind.localDateTime);
      check(ldt.dateTime).equals(DateTime(1979, 5, 27, 7, 32, 0, 250));

      final ld = _decodeNativeDateTimeField('dt = 2000-02-29')!;
      check(ld.kind).equals(TomlDateTimeKind.localDate);
      check(ld.dateTime).equals(DateTime(2000, 2, 29));

      final lt = _decodeNativeDateTimeField('dt = 07:32:00.5')!;
      check(lt.kind).equals(TomlDateTimeKind.localTime);
      check(lt.raw).equals('07:32:00.5');
      check(lt.dateTime).isNull();

      // Generic callers see ValueKind.string and readString() == dt.raw
      final m = TomlCodableDecoder.fromString('dt = 1979-05-27T07:32:00Z')
          .mapped();
      check(m.peekKind('dt')).equals(ValueKind.string);
      check(m.readString('dt')).equals('1979-05-27T07:32:00Z');
    });

    test(
      'TomlDateTimeCodec decodes native Date-Times and quoted ISO strings',
      () {
        const codec = TomlDateTimeCodec();
        final nativeDt = _decodeField(
          'ts = 2026-11-14T02:30:00+02:00',
          (k) => k.decodeValue(codec),
        );
        check(nativeDt).equals(DateTime.utc(2026, 11, 14, 0, 30));

        final quotedIso = _decodeField(
          'ts = "2026-11-14T00:30:00Z"',
          (k) => k.decodeValue(codec),
        );
        check(quotedIso).equals(DateTime.utc(2026, 11, 14, 0, 30));

        // Quoted ISO string returns null from tryReadTomlDateTime()
        check(_decodeNativeDateTimeField('ts = "2026-11-14T00:30:00Z"'))
            .isNull();

        // Local Time has no calendar date and throws TomlCodableException with
        // enriched line, column, and hierarchical path from decoder._trace.
        final ltErr = _expectTomlError(
          () => TomlCodableDecoder.decode<DateTime>(
            '[event]\noffsetInstant = 07:32:00\n',
            Decodable.fromFunction(
              (d) => d
                  .mapped()
                  .nestedDecoder('event')
                  .mapped()
                  .decodeKey('offsetInstant', codec),
            ),
          ),
        );
        check(ltErr.line).equals(2);
        check(ltErr.column).equals(17);
        check(ltErr.path).deepEquals(<Object>['event', 'offsetInstant']);
      },
    );

    test('rejects invalid calendar dates, leap years, and time ranges', () {
      final invalidDates = <String>[
        'dt = 2023-02-29',
        'dt = 1900-02-29',
        'dt = 2023-04-31',
        'dt = 2023-00-10',
        'dt = 2023-13-01',
        'dt = 24:00:00',
        'dt = 12:60:00',
        'dt = 12:00:60',
        'dt = 07:32:00.',
        'dt = 1979-05-27T07:32:00+24:00',
        'dt = 1979-05-27T07:32:00-00:60',
      ];
      for (final bad in invalidDates) {
        check(() => TomlCodableDecoder.fromString(bad))
            .throws<TomlCodableException>();
      }
    });
  });
}

void _registerTableAndArrayStructureTests() {
  group(
    'Tables, out-of-order subtables, [[array_of_tables]], and inline tables',
    () {
      test(
        'resolves out-of-order [a.b] before [a] and dotted-key subtables',
        () {
          const toml = '''
[a.b]
x = 10

[a]
y = 20
nested.z = 30

[a.nested.sub]
w = 40
''';
          final root = TomlCodableDecoder.fromString(toml).mapped();
          final a = root.nestedDecoder('a').mapped();
          check(a.readInt('y')).equals(20);
          check(a.nestedDecoder('b').mapped().readInt('x')).equals(10);
          final nested = a.nestedDecoder('nested').mapped();
          check(nested.readInt('z')).equals(30);
          check(nested.nestedDecoder('sub').mapped().readInt('w')).equals(40);
        },
      );

      test(
        'scopes [[array_of_tables]] and nested subtables to latest element',
        () {
          const toml = '''
[[fruits]]
name = "apple"

[fruits.physical]
color = "red"

[[fruits.varieties]]
name = "red delicious"

[[fruits.varieties]]
name = "granny smith"

[[fruits]]
name = "banana"

[[fruits.varieties]]
name = "plantain"
''';
          final fruits = TomlCodableDecoder.fromString(toml)
              .mapped()
              .nestedDecoder('fruits')
              .unkeyed();
          check(fruits.length).equals(2);

          check(fruits.moveNext()).isTrue();
          final apple = fruits.nestedDecoder().mapped();
          check(apple.readString('name')).equals('apple');
          check(apple.nestedDecoder('physical').mapped().readString('color'))
              .equals('red');
          final appleVars = apple.nestedDecoder('varieties').unkeyed();
          check(appleVars.length).equals(2);
          check(appleVars.moveNext()).isTrue();
          check(appleVars.nestedDecoder().mapped().readString('name'))
              .equals('red delicious');
          check(appleVars.moveNext()).isTrue();
          check(appleVars.nestedDecoder().mapped().readString('name'))
              .equals('granny smith');
          check(appleVars.moveNext()).isFalse();

          check(fruits.moveNext()).isTrue();
          final banana = fruits.nestedDecoder().mapped();
          check(banana.readString('name')).equals('banana');
          check(banana.containsKey('physical')).isFalse();
          final bananaVars = banana.nestedDecoder('varieties').unkeyed();
          check(bananaVars.length).equals(1);
        },
      );

      test('parses inline tables and enforces sealing, conflicts, and TOML v1.0 rules', () {
        const validInline = '''
empty = {}
point = { x = 1, y = 2, meta.tag = "ok", meta.count = 3 }
mixed_arr = [
  # comment inside multiline array
  1,
  "two",
  { k = """
multiline
inside inline""" },
]
''';
        final root = TomlCodableDecoder.fromString(validInline).mapped();
        check(root.nestedDecoder('empty').map().length).equals(0);
        final pt = root.nestedDecoder('point').mapped();
        check(pt.readInt('x')).equals(1);
        check(pt.nestedDecoder('meta').mapped().readString('tag')).equals('ok');
        check(pt.nestedDecoder('meta').mapped().readInt('count')).equals(3);
        final arr = root.nestedDecoder('mixed_arr').unkeyed();
        check(arr.length).equals(3);

        final structuralViolations = <String>[
          '[a]\nx = 1\n[a]\ny = 2',
          '[a.b]\nx = 1\n[a]\nb.y = 2',
          '[a]\nb.c = 1\n[a.b]\nd = 2',
          'p = { x = 1 }\np.y = 2',
          'p = { x = 1 }\n[p.sub]\nz = 2',
          'p = { a = { b = 1 }, a.c = 2 }',
          'p = { x = 1, }',
          'p = {\nx = 1\n}',
          'arr = [1, 2]\n[[arr]]\nx = 1',
          '[[arr]]\nx = 1\n[arr]\ny = 2',
          'arr = [{ x = 1 }]\n[arr.sub]\ny = 2',
        ];
        for (final bad in structuralViolations) {
          check(() => TomlCodableDecoder.fromString(bad))
              .throws<TomlCodableException>();
        }
      });
    },
  );
}

void _registerDecoderContainerAndPolymorphicTests() {
  group('TomlCodableDecoder containers, KeyOptions, MapDecoder, and SuperDecodable', () {
    test(
      'exposes driver metadata, userInfo, and KeyOptions.compiled lookup',
      () {
        final dec = TomlCodableDecoder.fromString(
          'alpha = "one"\nbeta = [1, 2, 3]\ngamma = [1.5, 2.5]\nflags = [true, false]\nwords = ["a", "b"]\n',
          userInfo: const <Object, Object?>{'env': 'test'},
        );
        check(dec.isHumanReadable).isTrue();
        check(dec.payload).isNull();
        check(dec.decodeUniformDoubleList(const <List<String>>[])).isNull();
        check(dec.userInfo['env']).equals('test');
        check(dec.peekKind()).equals(ValueKind.map);

        final opts = KeyOptions.of(const <String>[
          'alpha',
          'beta',
          'gamma',
          'flags',
          'words',
        ]);
        final enumOpts = KeyOptions.of(const <String>['zero', 'one', 'two']);
        final keyed = dec.keyed(options: opts);
        check(keyed.peekKey()).equals('alpha');
        check(keyed.readStringSpan).throws<UnsupportedError>();
        check(keyed.selectKeyIndex(opts)).equals(0);
        check(keyed.selectStringIndex(enumOpts)).equals(1);
        check(keyed.selectKeyIndex(opts)).equals(1);
        check(keyed.decodeIntList()).deepEquals(<int>[1, 2, 3]);
        check(keyed.selectKeyIndex(opts)).equals(2);
        check(keyed.decodeFloat64List()).deepEquals(<double>[1.5, 2.5]);
        check(keyed.selectKeyIndex(opts)).equals(3);
        check(keyed.decodeBoolList()).deepEquals(<bool>[true, false]);
        check(keyed.selectKeyIndex(opts)).equals(4);
        check(keyed.decodeStringList()).deepEquals(<String>['a', 'b']);
        check(keyed.moveNextKey()).isFalse();
      },
    );

    test('supports SuperDecodable when discriminator is after fields or subtable', () {
      const circleToml = '''
radius = 4.5
label = "unit"
kind = "circle"
''';
      final shape1 = TomlCodableDecoder.decode<_Shape>(
        circleToml,
        const _ShapeSuperDecodable(),
      );
      check(shape1).isA<_Circle>()
        ..has((c) => c.radius, 'radius').equals(4.5)
        ..has((c) => c.label, 'label').equals('unit');

      // In TOML, scalar keys before [meta] and subtable [meta] coexist cleanly,
      // and discriminator can appear at the end of root scalars while [meta] follows.
      const boxToml = '''
width = 10
height = 20
kind = "box"

[meta]
layer = 3
''';
      final shape2 = TomlCodableDecoder.decode<_Shape>(
        boxToml,
        const _ShapeSuperDecodable(),
      );
      check(shape2).isA<_Box>()
        ..has((b) => b.width, 'width').equals(10)
        ..has((b) => b.height, 'height').equals(20)
        ..has((b) => b.meta, 'meta').deepEquals(<String, int>{'layer': 3});

      final unknownErr = _expectTomlError(
        () => TomlCodableDecoder.decode<_Shape>(
          'kind = "triangle"\n',
          const _ShapeSuperDecodable(),
        ),
      );
      check(unknownErr.path).deepEquals(<Object>['kind']);
    });

    test('MapDecoder coerces int, double, num, bool, and String keys and '
        'rejects binary byte keys', () {
      const toml = '''
[responses]
200 = "OK"
404 = "Not Found"
"-1" = "Fallback"

[booleans]
true = 1
false = 0

[floats]
"1.5" = "half"
"42" = "whole"
''';
      final root = TomlCodableDecoder.fromString(toml).mapped();
      final responses = _decodeIntKeyMap(root.nestedDecoder('responses'));
      check(
        responses,
      ).deepEquals(<int, String>{200: 'OK', 404: 'Not Found', -1: 'Fallback'});

      final boolMapDec = root.nestedDecoder('booleans').map();
      check(boolMapDec.length).equals(2);
      final boolMap = <bool, int>{};
      while (boolMapDec.moveNextEntry()) {
        final k = boolMapDec.keyDecoder().singleValue().readBool();
        final v = boolMapDec.valueDecoder().singleValue().readInt();
        boolMap[k] = v;
      }
      check(boolMap).deepEquals(<bool, int>{true: 1, false: 0});

      final floatMapDec = root.nestedDecoder('floats').map();
      final nums = <num, String>{};
      while (floatMapDec.moveNextEntry()) {
        final k = floatMapDec.keyDecoder().singleValue().readNum();
        final v = floatMapDec.valueDecoder().singleValue().readString();
        nums[k] = v;
      }
      check(nums[1.5]).equals('half');
      check(nums[42]).equals('whole');

      check(
            () => TomlCodableDecoder.decode<void>(
              '[bytes]\nAQID = 1\n',
              Decodable.fromFunction((d) {
                final m = d.mapped().nestedDecoder('bytes').map();
                m.moveNextEntry();
                m.keyDecoder().singleValue().readBytes();
              }),
            ),
          )
          .throws<TomlCodableException>()
          .has((e) => e.path, 'path')
          .deepEquals(<Object>['bytes', 'AQID']);
    });
  });
}

void _registerBytesAndDepthLimitTests() {
  group('Binary readBytes() and recursion depth-64 guard', () {
    test('decodes Base64 strings and 0..255 byte arrays via readBytes()', () {
      const toml = '''
b64 = "AQIDBA=="
raw = [0, 127, 255]
list_of_bytes = ["AAEC", [10, 20]]
''';
      final root = TomlCodableDecoder.fromString(toml).mapped();
      check(root.readBytes('b64')).deepEquals(<int>[1, 2, 3, 4]);
      check(root.readBytes('raw')).deepEquals(<int>[0, 127, 255]);

      final u = root.nestedDecoder('list_of_bytes').unkeyed();
      check(u.moveNext()).isTrue();
      check(u.readBytes()).deepEquals(<int>[0, 1, 2]);
      check(u.moveNext()).isTrue();
      check(u.readBytes()).deepEquals(<int>[10, 20]);
      check(u.moveNext()).isFalse();

      check(
        () => _decodeField('b = "not-valid-base64!!!"', (k) => k.readBytes()),
      ).throws<TomlCodableException>();
      check(() => _decodeField('b = [0, 256]', (k) => k.readBytes()))
          .throws<TomlCodableException>();
      check(() => _decodeField('b = [-1]', (k) => k.readBytes()))
          .throws<TomlCodableException>();
      check(() => _decodeField('b = [1.0]', (k) => k.readBytes()))
          .throws<TomlCodableException>();
    });

    test('allows container nesting up to depth 64 and rejects depth 65', () {
      final atLimit = 'v = ${'[' * 63}7${']' * 63}\n';
      final root64 = TomlCodableDecoder.fromString(atLimit);
      var cursor = root64.keyed().nestedDecoder();
      for (var i = 0; i < 63; i++) {
        cursor = cursor.unkeyed().nestedDecoder();
      }
      check(cursor.singleValue().readInt()).equals(7);

      final parserArray64 = 'v = ${'[' * 64}7${']' * 64}\n';
      final parsed64 = TomlCodableDecoder.fromString(parserArray64);
      // Root keyed() is depth 1, plus 63 nested unkeyed() = depth 64; 64th unkeyed() is depth 65 -> throws!
      check(() {
        var d = parsed64.keyed().nestedDecoder();
        for (var i = 0; i < 64; i++) {
          d = d.unkeyed().nestedDecoder();
        }
      }).throws<TomlCodableException>();

      final overLimitArrays = 'v = ${'[' * 65}7${']' * 65}\n';
      check(() => TomlCodableDecoder.fromString(overLimitArrays))
          .throws<TomlCodableException>();

      final overLimitInline =
          'v = ${List<String>.filled(65, '{ a = ').join()}1${'}' * 65}\n';
      check(() => TomlCodableDecoder.fromString(overLimitInline))
          .throws<TomlCodableException>();
    });
  });
}

void _registerDiagnosticsAndFuzzerTests() {
  group(
    'Line, column, hierarchical path diagnostics, UTF-8, and fuzz smoke',
    () {
      test(
        'reports exact 1-based line, column, and path on syntax & type errors',
        () {
          const syntaxBad = 'ok = 1\n[server]\nport = 01\n';
          final synErr = _expectTomlError(
            () => TomlCodableDecoder.fromString(syntaxBad),
          );
          check(synErr.line).equals(3);
          check(synErr.column).equals(8);
          check(synErr.toString()).contains('line 3, column 8');

          const typeBad = '''
[server]
ports = [80, "bad_port", 443]
''';
          final typeErr = _expectTomlError(
            () => TomlCodableDecoder.decode<List<int>>(
              typeBad,
              Decodable.fromFunction(
                (d) => d.mapped().decodeIntList('server_missing'),
              ),
            ),
          );
          check(typeErr.path).deepEquals(<Object>['server_missing']);

          final portErr = _expectTomlError(
            () => TomlCodableDecoder.decode<List<int>>(
              typeBad,
              Decodable.fromFunction(
                (d) => d
                    .mapped()
                    .nestedDecoder('server')
                    .mapped()
                    .decodeIntList('ports'),
              ),
            ),
          );
          check(portErr.line).equals(2);
          check(portErr.column).equals(14);
          check(portErr.path).deepEquals(<Object>['server', 'ports', 1]);
          check(portErr.formattedPath).equals('server.ports[1]');

          const badMapKey = '[scores]\n42 = "ok"\noops = "bad"\n';
          final keyErr = _expectTomlError(
            () => TomlCodableDecoder.decode<Map<int, String>>(
              badMapKey,
              Decodable.fromFunction(
                (d) => _decodeIntKeyMap(d.mapped().nestedDecoder('scores')),
              ),
            ),
          );
          check(keyErr.line).equals(3);
          check(keyErr.column).equals(1);
          check(keyErr.path).deepEquals(<Object>['scores', 'oops']);
        },
      );

      test('decodeBytes validates UTF-8 and converts FormatException', () {
        final validBytes = Uint8List.fromList(utf8.encode('count = 12\n'));
        final count = TomlCodableDecoder.decodeBytes<int>(
          validBytes,
          Decodable.fromFunction((d) => d.mapped().readInt('count')),
        );
        check(count).equals(12);

        final invalidUtf8 = Uint8List.fromList(const <int>[0x61, 0x3d, 0xff]);
        check(() => TomlCodableDecoder.fromBytes(invalidUtf8))
            .throws<TomlCodableException>();
      });

      test('passes fuzzTarget smoke corpus without unhandled exceptions', () {
        fuzzTarget(Uint8List(0));
        fuzzTarget(
          Uint8List.fromList(
            utf8.encode('[a]\nid = 1\nname = "x"\nts = 1979-05-27\n'),
          ),
        );
      });
    },
  );
}
