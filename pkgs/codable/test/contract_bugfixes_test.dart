// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:typed_data';

import 'package:checks/checks.dart';
import 'package:codable/codable.dart';
import 'package:codable/codable_json.dart';
import 'package:codable/codable_streaming.dart' as streaming;
import 'package:test/test.dart';

part 'contract_bugfixes_test.g.dart';

@Codable()
final class EmptyMarker {
  const EmptyMarker();

  @override
  bool operator ==(Object other) => other is EmptyMarker;

  @override
  int get hashCode => 0;
}

@Codable()
final class GridCell {
  final int row;
  final int col;
  final String label;

  const GridCell({required this.row, required this.col, this.label = ''});

  @override
  bool operator ==(Object other) =>
      other is GridCell &&
      other.row == row &&
      other.col == col &&
      other.label == label;

  @override
  int get hashCode => Object.hash(row, col, label);
}

@Codable()
final class GridBoard {
  final List<List<GridCell>> cells;
  final List<List<GridCell>?> nullableRows;

  const GridBoard({this.cells = const [], this.nullableRows = const []});
}

enum _KeyLevel { low, high }

void main() {
  _registerNestedListBugfixTests();
  _registerEmptyMarkerAndEmptyKeyOptionsTests();
  _registerByteListFloatRejectionTests();
  _registerStringMapKeyHelperTests();
  _registerExceptionActualValueTests();
}

void _registerNestedListBugfixTests() {
  group('UnkeyedDecoder.decodeList & decodeNullableList', () {
    test('roundtrips 2D List<List<@Codable>> and List<List<@Codable>?> in JSON', () {
      const board = GridBoard(
        cells: [
          [GridCell(row: 0, col: 0, label: 'origin'), GridCell(row: 0, col: 1)],
          [],
          [GridCell(row: 2, col: 0, label: 'end')],
        ],
        nullableRows: [
          [GridCell(row: 1, col: 1, label: 'mid')],
          null,
          [],
        ],
      );

      final encoded = JsonCodableEncoder.encode(
        board,
        const GridBoardCodable(),
      );
      final encodedBytes = Uint8List.fromList(utf8.encode(encoded));

      _checkBoard(
        const GridBoardCodable().decode(JsonCodableDecoder.fromString(encoded)),
      );
      _checkBoard(
        const GridBoardCodable().decode(
          JsonCodableDecoder.fromBytes(encodedBytes),
        ),
      );
      _checkBoard(
        const GridBoardCodable().decode(
          JsonCodableDecoder.fromBytes(
            encodedBytes,
            userInfo: const {#forceJsDom: true},
          ),
        ),
      );
      _checkBoard(
        const GridBoardCodable().decode(
          streaming.JsonCodableDecoder.fromBytes(encodedBytes),
        ),
      );

      // Buffered object-tree (DartObjectDecoder) via mapped() -> keyed() handoff
      final bufferedDec = streaming.JsonCodableDecoder.fromBytes(encodedBytes);
      check(bufferedDec.mapped().containsKey('cells')).isTrue();
      _checkBoard(const GridBoardCodable().decode(bufferedDec));

      // Non-nullable 2D list rejects null row and null cell element
      check(
        () => const GridBoardCodable().decode(
          JsonCodableDecoder.fromString('{"cells": [null]}'),
        ),
      ).throws<Exception>();
      check(
        () => const GridBoardCodable().decode(
          JsonCodableDecoder.fromString('{"cells": [[null]]}'),
        ),
      ).throws<Exception>();
      final bufferedNullRow = streaming.JsonCodableDecoder.fromBytes(
        Uint8List.fromList(utf8.encode('{"cells": [null]}')),
      )..mapped();
      check(() => const GridBoardCodable().decode(bufferedNullRow))
          .throws<CodableException>();

      // MappedDecoder.decodeNullableListKey handles present, null, and missing
      const mappedPayload =
          '{"present": [{"row": 3, "col": 4}], "nulled": null}';
      for (final mapped in [
        JsonCodableDecoder.fromString(mappedPayload).mapped(),
        JsonCodableDecoder.fromBytes(
          Uint8List.fromList(utf8.encode(mappedPayload)),
          userInfo: const {#forceJsDom: true},
        ).mapped(),
        streaming.JsonCodableDecoder.fromBytes(
          Uint8List.fromList(utf8.encode(mappedPayload)),
        ).mapped(),
      ]) {
        check(mapped.decodeNullableListKey('present', const GridCellCodable()))
            .isNotNull()
            .deepEquals(const [GridCell(row: 3, col: 4)]);
        check(mapped.decodeNullableListKey('nulled', const GridCellCodable()))
            .isNull();
        check(mapped.decodeNullableListKey('absent', const GridCellCodable()))
            .isNull();
      }
    });

    test(
      'exercises BaseUnkeyedDecoderMixin.decodeList & decodeNullableList',
      () {
        final dec = _StrictListDecoder([
          [10, 20],
          null,
          <Object?>[],
        ]);
        final u = dec.unkeyed();
        final intDec = Decodable<int>.fromFunction(
          (d) => d.singleValue().readInt(),
        );

        check(u.moveNext()).isTrue();
        check(u.decodeList(intDec)).deepEquals([10, 20]);
        check(u.moveNext()).isTrue();
        check(u.decodeNullableList(intDec)).isNull();
        check(u.moveNext()).isTrue();
        check(u.decodeNullableList(intDec)).isNotNull().isEmpty();
        check(u.moveNext()).isFalse();
      },
    );
  });
}

void _checkBoard(GridBoard decoded) {
  check(decoded.cells.length).equals(3);
  check(decoded.cells[0]).deepEquals(const [
    GridCell(row: 0, col: 0, label: 'origin'),
    GridCell(row: 0, col: 1),
  ]);
  check(decoded.cells[1]).isEmpty();
  check(decoded.cells[2])
      .deepEquals(const [GridCell(row: 2, col: 0, label: 'end')]);
  check(decoded.nullableRows.length).equals(3);
  check(decoded.nullableRows[0])
      .isNotNull()
      .deepEquals(const [GridCell(row: 1, col: 1, label: 'mid')]);
  check(decoded.nullableRows[1]).isNull();
  check(decoded.nullableRows[2]).isNotNull().isEmpty();
}

void _registerEmptyMarkerAndEmptyKeyOptionsTests() {
  group('Empty KeyOptions.of(const []) and zero-field @Codable()', () {
    test('roundtrips EmptyMarker on {} and {"ignored": [1, 2]} across all JSON modes', () {
      final encoded = JsonCodableEncoder.encode(
        const EmptyMarker(),
        const EmptyMarkerCodable(),
      );
      check(encoded).equals('{}');

      for (final payload in [
        '{}',
        '{"ignored": [1, 2], "extra": {"k": "v"}}',
      ]) {
        final bytes = Uint8List.fromList(utf8.encode(payload));
        check(
          const EmptyMarkerCodable().decode(
            JsonCodableDecoder.fromString(payload),
          ),
        ).equals(const EmptyMarker());
        check(
          const EmptyMarkerCodable().decode(
            JsonCodableDecoder.fromBytes(bytes),
          ),
        ).equals(const EmptyMarker());
        check(
          const EmptyMarkerCodable().decode(
            JsonCodableDecoder.fromBytes(
              bytes,
              userInfo: const {#forceJsDom: true},
            ),
          ),
        ).equals(const EmptyMarker());
        check(
          const EmptyMarkerCodable().decode(
            streaming.JsonCodableDecoder.fromBytes(bytes),
          ),
        ).equals(const EmptyMarker());

        // Object-tree DartObjectDecoder path via mapped() -> keyed()
        final buffered = streaming.JsonCodableDecoder.fromBytes(bytes);
        buffered.mapped();
        check(const EmptyMarkerCodable().decode(buffered))
            .equals(const EmptyMarker());
      }
    });

    test('supports direct KeyOptions.of(const []) in selectKeyIndex and selectStringIndex', () {
      final emptyOpts = KeyOptions.of(const []);
      final bytes = Uint8List.fromList(
        utf8.encode('{"status": "ok", "count": 42}'),
      );

      final streamingKeyed = streaming.JsonCodableDecoder.fromBytes(bytes)
          .keyed(options: emptyOpts);
      check(streamingKeyed.moveNextKey()).isTrue();
      check(streamingKeyed.selectKeyIndex(emptyOpts)).equals(-1);
      check(streamingKeyed.selectStringIndex(emptyOpts)).equals(-1);
      check(streamingKeyed.moveNextKey()).isTrue();
      check(streamingKeyed.selectKeyIndex(emptyOpts)).equals(-1);
      check(streamingKeyed.readInt()).equals(42);
      check(streamingKeyed.moveNextKey()).isFalse();

      // Also pass ad-hoc empty KeyOptions when keyed() was opened without options
      final unseededKeyed = JsonCodableDecoder.fromBytes(bytes).keyed();
      check(unseededKeyed.moveNextKey()).isTrue();
      check(unseededKeyed.selectKeyIndex(KeyOptions.of(const []))).equals(-1);
      check(unseededKeyed.selectStringIndex(KeyOptions.of(const [])))
          .equals(-1);
      check(unseededKeyed.moveNextKey()).isTrue();
      check(unseededKeyed.selectKeyIndex(KeyOptions.of(const []))).equals(-1);
      unseededKeyed.skipValue();
      check(unseededKeyed.moveNextKey()).isFalse();
    });
  });
}

void _registerByteListFloatRejectionTests() {
  group('Base*DecoderMixin.readBytes() float-array rejection', () {
    test('rejects [1.0, 2.0] float tokens in known-length and streaming UnkeyedDecoders', () {
      for (final reportLength in [true, false]) {
        // Valid integer bytes succeed on both paths
        final valid = _StrictListDecoder(const [
          _StrictInt(1),
          _StrictInt(255),
        ], reportLength: reportLength);
        check(valid.singleValue().readBytes()).deepEquals([1, 255]);

        // Float [1.0, 2.0] tokens are rejected on VM, dart2js, and dart2wasm
        final floatSingle = _StrictListDecoder(const [
          _StrictFloat(1.0),
          _StrictFloat(2.0),
        ], reportLength: reportLength);
        check(() => floatSingle.singleValue().readBytes())
            .throws<CodableException>();

        final floatKeyed = _StrictKeyedSingleEntryDecoder(
          'data',
          _StrictListDecoder(const [
            _StrictFloat(1.0),
            _StrictFloat(2.0),
          ], reportLength: reportLength),
        );
        check(floatKeyed.moveNextKey()).isTrue();
        check(floatKeyed.nextKey()).equals('data');
        check(floatKeyed.readBytes).throws<CodableException>();

        final floatUnkeyed = _StrictListDecoder([
          [const _StrictFloat(1.0), const _StrictFloat(2.0)],
        ], reportLength: reportLength).unkeyed();
        check(floatUnkeyed.moveNext()).isTrue();
        check(floatUnkeyed.readBytes).throws<CodableException>();

        // Out-of-range integer bytes (256, -1) rejected
        check(
          () => _StrictListDecoder(const [
            _StrictInt(256),
          ], reportLength: reportLength).singleValue().readBytes(),
        ).throws<CodableException>();
        check(
          () => _StrictListDecoder(const [
            _StrictInt(-1),
          ], reportLength: reportLength).singleValue().readBytes(),
        ).throws<CodableException>();
      }

      // Streaming JSON token reader rejects "[1.0, 2.0]" across VM/JS/Wasm
      final jsonFloatBytes = Uint8List.fromList(utf8.encode('[1.0, 2.0]'));
      check(
        () =>
            streaming.JsonCodableDecoder.fromBytes(jsonFloatBytes)
                .singleValue()
                .readBytes(),
      ).throws<CodableException>();
    });
  });
}

void _registerStringMapKeyHelperTests() {
  group('StringMapKeyDecoder & BaseStringMapKeyEncoderMixin', () {
    test('rejects Uint8List binary map keys on encode and decode', () {
      final keyEncoder = _CustomStringMapKeyEncoder(formatName: 'TOML');
      check(() => keyEncoder.encodeBytes(Uint8List.fromList([1, 2, 3])))
          .throws<CodableException>()
          .has((e) => e.message, 'message')
          .contains('TOML map keys cannot be binary bytes');
      check(() => keyEncoder.encodeNullableBytes(Uint8List.fromList([1])))
          .throws<CodableException>()
          .has((e) => e.message, 'message')
          .contains('TOML map keys cannot be binary bytes');

      final keyDecoder = StringMapKeyDecoder(
        const {},
        key: 'AQID',
        formatName: 'TOML',
      );
      check(keyDecoder.readBytes)
          .throws<CodableException>()
          .has((e) => e.message, 'message')
          .contains('TOML map keys cannot be binary bytes');

      // JSON MapDecoder also rejects binary map keys instead of decoding Base64
      final jsonMap = JsonCodableDecoder.fromString('{"AQID": 1}').map();
      check(jsonMap.moveNextEntry()).isTrue();
      check(() => jsonMap.keyDecoder().singleValue().readBytes())
          .throws<CodableException>()
          .has((e) => e.message, 'message')
          .contains('JSON map keys cannot be binary bytes');
    });

    test(
      'enforces 53-bit safe integer bounds on JS and allows 64-bit on VM/Wasm',
      () {
        const maxSafeStr = '9007199254740991';
        const minSafeStr = '-9007199254740991';
        const overMaxEvenStr = '9007199254740992';
        const overMaxOddStr = '9007199254740993';
        const underMinStr = '-9007199254740993';

        final keyDec = StringMapKeyDecoder(const {}, formatName: 'JSON');
        keyDec.key = maxSafeStr;
        check(keyDec.readInt()).equals(0x1FFFFFFFFFFFFF);
        keyDec.key = minSafeStr;
        check(keyDec.readInt()).equals(-0x1FFFFFFFFFFFFF);

        if (identical(1.0, 1)) {
          for (final unsafeKey in [
            overMaxEvenStr,
            overMaxOddStr,
            underMinStr,
          ]) {
            keyDec.key = unsafeKey;
            check(keyDec.readInt).throws<CodableException>();

            final jsonMap = JsonCodableDecoder.fromString('{"$unsafeKey": "x"}')
                .map();
            check(jsonMap.moveNextEntry()).isTrue();
            check(() => jsonMap.keyDecoder().singleValue().readInt())
                .throws<CodableException>();
          }

          // 2^53 = 0x200000 * 0x100000000 (9007199254740992) rejected by encodeInt on JS
          const twoPow53 = 0x200000 * 0x100000000;
          final keyEnc = _CustomStringMapKeyEncoder();
          check(() => keyEnc.encodeInt(twoPow53)).throws<CodableException>();
          check(() => keyEnc.encodeInt(-twoPow53)).throws<CodableException>();
        } else {
          keyDec.key = overMaxOddStr;
          final parsed = keyDec.readInt();
          check(parsed.toString()).equals(overMaxOddStr);
        }
      },
    );

    test('validates scalars, selectStringIndex, and rejects null/NaN/Infinity/containers', () {
      final enumOpts = KeyOptions.of(const ['low', 'high']);
      final keyDec = StringMapKeyDecoder(const {'ctx': 1}, formatName: 'TOML');
      check(keyDec.isHumanReadable).isTrue();
      check(keyDec.payload).isNull();
      check(keyDec.userInfo['ctx']).equals(1);
      check(keyDec.peekKind()).equals(ValueKind.string);
      check(keyDec.isNull()).isFalse();

      keyDec.key = 'low';
      check(keyDec.selectStringIndex(enumOpts)).equals(_KeyLevel.low.index);
      keyDec.key = 'high';
      check(keyDec.readString()).equals('high');
      check(keyDec.selectStringIndex(enumOpts)).equals(_KeyLevel.high.index);
      keyDec.key = 'true';
      check(keyDec.readBool()).isTrue();
      keyDec.key = '-3.25';
      check(keyDec.readDouble()).equals(-3.25);
      check(keyDec.readNum()).equals(-3.25);
      keyDec.key = '42';
      check(keyDec.readNum()).equals(42);

      for (final badInt in [
        '0x10',
        '-0xFF',
        '+42',
        ' 42 ',
        '\t7\n',
        '01',
        '-01',
        '1_000',
        'abc',
        '',
      ]) {
        keyDec.key = badInt;
        check(keyDec.readInt).throws<CodableException>();
      }

      for (final badDouble in [
        'NaN',
        'Infinity',
        '-Infinity',
        'abc',
        ' 42.5 ',
        '+1.5',
        '.5',
        '5.',
        '00.5',
      ]) {
        keyDec.key = badDouble;
        check(keyDec.readDouble).throws<CodableException>();
        check(keyDec.readNum).throws<CodableException>();
      }
      check(keyDec.readNull).throws<CodableException>();
      check(keyDec.keyed).throws<CodableException>();
      check(keyDec.mapped).throws<CodableException>();
      check(keyDec.map).throws<CodableException>();
      check(keyDec.unkeyed).throws<CodableException>();

      final keyEnc = _CustomStringMapKeyEncoder(formatName: 'TOML');
      keyEnc.encodeNullableInt(7);
      check(keyEnc.writtenKey).equals('7');
      keyEnc.reset();
      keyEnc.encodeNullableBool(false);
      check(keyEnc.writtenKey).equals('false');
      keyEnc.reset();
      keyEnc.encodeDouble(1.0);
      check(keyEnc.writtenKey).equals('1.0');
      keyEnc.reset();
      keyEnc.encodeDouble(-0.0);
      check(keyEnc.writtenKey).equals('-0.0');
      keyEnc.reset();
      check(() => keyEnc.encode<int>(0, Encodable.fromFunction((_, _) {})))
          .throws<CodableException>()
          .has((e) => e.message, 'message')
          .contains('TOML map key encoder did not write a key');

      // JSON Map<double, String> emits canonical "1.0" and "-0.0" on VM, Wasm, and JS
      final jsonDoubleMap = JsonCodableEncoder.encode<Map<double, String>>(
        {1.0: 'one', -0.0: 'neg_zero'},
        Encodable.fromFunction((m, e) {
          final me = e.map(length: m.length);
          for (final entry in m.entries) {
            me.keyEncoder().singleValue().encodeDouble(entry.key);
            me.valueEncoder().singleValue().encodeString(entry.value);
          }
        }),
      );
      check(jsonDoubleMap).equals('{"1.0":"one","-0.0":"neg_zero"}');

      check(keyEnc.encodeNull).throws<CodableException>();
      check(() => keyEnc.encodeNullableInt(null)).throws<CodableException>();
      check(() => keyEnc.encodeNullableDouble(null)).throws<CodableException>();
      check(() => keyEnc.encodeNullableString(null)).throws<CodableException>();
      check(() => keyEnc.encodeNullableBool(null)).throws<CodableException>();
      check(() => keyEnc.encodeDouble(double.nan)).throws<CodableException>();
      check(() => keyEnc.encodeDouble(double.infinity))
          .throws<CodableException>();
      check(() => keyEnc.encodeDouble(double.negativeInfinity))
          .throws<CodableException>();
      check(keyEnc.keyed).throws<CodableException>();
      check(keyEnc.unkeyed).throws<CodableException>();
      check(keyEnc.map).throws<CodableException>();
    });
  });
}

final class _CustomStringMapKeyEncoder
    with BaseStringMapKeyEncoderMixin
    implements Encoder, SingleValueEncoder {
  @override
  final String formatName;
  @override
  final Map<Object, Object?> userInfo = const {};
  String? writtenKey;

  _CustomStringMapKeyEncoder({this.formatName = 'JSON'});

  @override
  bool get hasWrittenKey => writtenKey != null;

  void reset() {
    writtenKey = null;
  }

  @override
  void writeKeyString(String key) {
    if (writtenKey != null) {
      throw const CodableException('Duplicate map key');
    }
    writtenKey = key;
  }
}

final class _StrictInt {
  final int value;
  const _StrictInt(this.value);
}

final class _StrictFloat {
  final double value;
  const _StrictFloat(this.value);
}

final class _StrictListDecoder implements Decoder {
  final Object? _value;
  final bool reportLength;

  _StrictListDecoder(this._value, {this.reportLength = true});

  @override
  bool get isHumanReadable => false;

  @override
  Map<Object, Object?> get userInfo => const {};

  @override
  Uint8List? get payload => null;

  @override
  ValueKind peekKind() => switch (_value) {
    null => ValueKind.nullValue,
    List() => ValueKind.list,
    int() || _StrictInt() || _StrictFloat() => ValueKind.number,
    String() => ValueKind.string,
    bool() => ValueKind.boolean,
    _ => ValueKind.map,
  };

  @override
  KeyedDecoder keyed({KeyOptions? options}) =>
      throw const CodableException('Not a map');

  @override
  MappedDecoder mapped() => throw const CodableException('Not a map');

  @override
  MapDecoder map() => throw const CodableException('Not a map');

  @override
  UnkeyedDecoder unkeyed() => _StrictUnkeyedDecoder(
    _value as List<Object?>,
    reportLength: reportLength,
  );

  @override
  SingleValueDecoder singleValue() =>
      _StrictSingleValueDecoder(_value, reportLength: reportLength);

  @override
  Float64List? decodeUniformDoubleList(List<List<String>> propertyAliases) =>
      null;
}

final class _StrictUnkeyedDecoder
    with BaseUnkeyedDecoderMixin
    implements UnkeyedDecoder {
  final List<Object?> _items;
  final bool reportLength;
  int _index = -1;

  _StrictUnkeyedDecoder(this._items, {required this.reportLength});

  @override
  int? get length => reportLength ? _items.length : null;

  @override
  bool moveNext() => ++_index < _items.length;

  Object? get _current => _items[_index];

  @override
  ValueKind peekKind() => _StrictListDecoder(_current).peekKind();

  @override
  void readNull() {
    if (_current != null) throw const CodableException('Expected null');
  }

  @override
  void skipElement() {}

  @override
  int readInt() => switch (_current) {
    final int v => v,
    _StrictInt(:final value) => value,
    _ => throw CodableException('Expected strict int, got $_current'),
  };

  @override
  double readDouble() => switch (_current) {
    final num v => v.toDouble(),
    _StrictInt(:final value) => value.toDouble(),
    _StrictFloat(:final value) => value,
    _ => throw CodableException('Expected double, got $_current'),
  };

  @override
  num readNum() => switch (_current) {
    final num v => v,
    _StrictInt(:final value) => value,
    _StrictFloat(:final value) => value,
    _ => throw CodableException('Expected num, got $_current'),
  };

  @override
  String readString() => _current as String;

  @override
  bool readBool() => _current as bool;

  @override
  Decoder nestedDecoder() =>
      _StrictListDecoder(_current, reportLength: reportLength);
}

final class _StrictSingleValueDecoder
    with BaseSingleValueDecoderMixin
    implements SingleValueDecoder {
  final Object? _value;
  final bool reportLength;

  _StrictSingleValueDecoder(this._value, {required this.reportLength});

  @override
  ValueKind peekKind() => _StrictListDecoder(_value).peekKind();

  @override
  void readNull() {
    if (_value != null) throw const CodableException('Expected null');
  }

  @override
  int readInt() => switch (_value) {
    final int v => v,
    _StrictInt(:final value) => value,
    _ => throw CodableException('Expected strict int, got $_value'),
  };

  @override
  double readDouble() => (_value as num).toDouble();

  @override
  num readNum() => _value as num;

  @override
  String readString() => _value as String;

  @override
  bool readBool() => _value as bool;

  @override
  Decoder nestedDecoder() =>
      _StrictListDecoder(_value, reportLength: reportLength);
}

final class _StrictKeyedSingleEntryDecoder
    with BaseKeyedDecoderMixin
    implements KeyedDecoder {
  final String _key;
  final Decoder _child;
  int _step = 0;

  _StrictKeyedSingleEntryDecoder(this._key, this._child);

  @override
  bool moveNextKey() => _step++ == 0;

  @override
  String nextKey() => _key;

  @override
  ValueKind peekKind() => _child.peekKind();

  @override
  void skipValue() {}

  @override
  void readNull() => _child.singleValue().readNull();

  @override
  int readInt() => _child.singleValue().readInt();

  @override
  double readDouble() => _child.singleValue().readDouble();

  @override
  num readNum() => _child.singleValue().readNum();

  @override
  String readString() => _child.singleValue().readString();

  @override
  bool readBool() => _child.singleValue().readBool();

  @override
  Decoder nestedDecoder() => _child;
}

void _registerExceptionActualValueTests() {
  group('CodableException.actualValue diagnostics', () {
    test(
      'preserves unescaped actualValue on factories and StringMapKeyDecoder',
      () {
        final mismatch = CodableException.typeMismatch(
          expectedType: int,
          actualValue: '42"quoted"',
          path: const ['count'],
        );
        check(mismatch.actualValue).equals('42"quoted"');
        check(mismatch.formattedPath).equals('count');

        final unknown = CodableException.unknownSubtype(
          discriminatorKey: 'kind',
          subtypeValue: 'unknown "quoted" kind',
        );
        check(unknown.actualValue).equals('unknown "quoted" kind');
        check(unknown.path).deepEquals(const <Object>['kind']);

        final keyDec = StringMapKeyDecoder(
          const {},
          key: 'bad "int" key',
          formatName: 'JSON',
        );
        check(keyDec.readInt)
            .throws<CodableException>()
            .has((e) => e.actualValue, 'actualValue')
            .equals('bad "int" key');
        check(keyDec.readDouble)
            .throws<CodableException>()
            .has((e) => e.actualValue, 'actualValue')
            .equals('bad "int" key');
        check(keyDec.readBool)
            .throws<CodableException>()
            .has((e) => e.actualValue, 'actualValue')
            .equals('bad "int" key');

        final keyEnc = _CustomStringMapKeyEncoder(formatName: 'JSON');
        check(() => keyEnc.encodeDouble(double.infinity))
            .throws<CodableException>()
            .has((e) => e.actualValue, 'actualValue')
            .equals(double.infinity);
      },
    );

    test(
      'captures actualValue on JSON base64, byte-range, and mapped mismatches',
      () {
        check(
              () =>
                  JsonCodableDecoder.fromString(r'{"b": "not==\"base64\""}')
                      .mapped()
                      .readBytes('b'),
            )
            .throws<CodableException>()
            .has((e) => e.actualValue, 'actualValue')
            .equals('not=="base64"');

        check(
              () => JsonCodableDecoder.fromString('{"b": [1, 256]}').keyed()
                ..moveNextKey()
                ..nextKey()
                ..readBytes(),
            )
            .throws<CodableException>()
            .has((e) => e.actualValue, 'actualValue')
            .equals(256);

        check(
              () =>
                  JsonCodableDecoder.fromString(r'{"port": "8080 \"oops\""}')
                      .mapped()
                      .readInt('port'),
            )
            .throws<CodableException>()
            .has((e) => e.actualValue, 'actualValue')
            .equals('8080 "oops"');
      },
    );
  });
}
