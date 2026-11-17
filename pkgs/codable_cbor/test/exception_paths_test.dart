// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:typed_data';

import 'package:checks/checks.dart';
import 'package:codable/codable.dart';
import 'package:codable_cbor/codable_cbor.dart';
import 'package:test/test.dart';

import 'cross_format_test.dart' as cf;

Uint8List _encodeDynamic(Object? value) => CborCodableEncoder.encode(
  value,
  const Encodable.fromFunction(_writeDynamic),
);

void _writeDynamic(Object? value, Encoder encoder) {
  switch (value) {
    case null:
      encoder.singleValue().encodeNull();
    case final bool v:
      encoder.singleValue().encodeBool(v);
    case final int v:
      encoder.singleValue().encodeInt(v);
    case final double v:
      encoder.singleValue().encodeDouble(v);
    case final Uint8List v:
      encoder.singleValue().encodeBytes(v);
    case final String v:
      encoder.singleValue().encodeString(v);
    case final List<Object?> items:
      final u = encoder.unkeyed(length: items.length);
      for (final item in items) {
        _writeDynamic(item, u.nestedEncoder());
      }
    case final Map<String, Object?> map:
      final k = encoder.keyed(length: map.length);
      for (final MapEntry(:key, value: val) in map.entries) {
        _writeDynamic(val, k.nestedEncoder(key));
      }
    case final Map<Object?, Object?> map:
      final m = encoder.map(length: map.length);
      for (final MapEntry(:key, value: val) in map.entries) {
        _writeDynamic(key, m.keyEncoder());
        _writeDynamic(val, m.valueEncoder());
      }
    default:
      throw ArgumentError('Unsupported test value: $value');
  }
}

sealed class _Shape {
  const _Shape();
}

final class _Circle extends _Shape {
  final double r;
  const _Circle(this.r);
}

final class _CircleDecodable implements Decodable<_Circle> {
  const _CircleDecodable();

  @override
  _Circle decode(Decoder decoder) {
    final k = decoder.keyed(options: KeyOptions.of(const ['r']));
    double? r;
    while (k.moveNextKey()) {
      if (k.selectKeyIndex(KeyOptions.of(const ['r'])) == 0) {
        r = k.readDouble();
      } else {
        k.skipValue();
      }
    }
    if (r == null) {
      throw const CodableException('Missing required fields for Circle: r');
    }
    return _Circle(r);
  }
}

final class _ShapeSuperDecodable extends SuperDecodable<_Shape> {
  const _ShapeSuperDecodable();

  @override
  String get discriminatorKey => 'kind';

  @override
  Map<String, Decodable<_Shape>> get subtypes => const {
    'circle': _CircleDecodable(),
  };
}

CodableException _expectCborPath<T>(
  Uint8List bytes,
  Decodable<T> decodable,
  List<Object> expectedPath,
  String expectedFormatted,
) {
  CodableException? caught;
  try {
    CborCodableDecoder.decode(bytes, decodable);
  } on CodableException catch (e) {
    caught = e;
  }
  check(caught).isNotNull();
  check(caught!.path).deepEquals(expectedPath);
  check(caught.formattedPath).equals(expectedFormatted);
  return caught;
}

void main() {
  group('CBOR CodableException.path diagnostics', () {
    test('attributes nested scalar, list, map, and byte-array errors', () {
      final badPerson = _encodeDynamic(<String, Object?>{
        'firstName': 'Ada',
        'lastName': 'Lovelace',
        'dob': '1815-12-10T00:00:00Z',
        'orders': <Object?>[
          <String, Object?>{'dateUs': 100},
          <String, Object?>{
            'dateUs': 200,
            'item': <String, Object?>{'count': 2, 'isRushed': 'yes'},
          },
        ],
      });
      _expectCborPath(badPerson, const cf.PersonCodable(), const [
        'orders',
        1,
        'item',
        'isRushed',
      ], 'orders[1].item.isRushed');

      final badLatency = _encodeDynamic(<String, Object?>{
        'path': '/v1',
        'method': 'get',
        'schemaHash': Uint8List.fromList([1, 2]),
        'latencyBuckets': <String, Object?>{
          'p99': <Object?>[10, 20, 'slow'],
        },
      });
      _expectCborPath(badLatency, const cf.OpenApiSpecModelCodable(), const [
        'latencyBuckets',
        'p99',
        2,
      ], 'latencyBuckets.p99[2]');

      final badMapKey = _encodeDynamic(<String, Object?>{
        'path': '/v1',
        'method': 'get',
        'schemaHash': Uint8List.fromList([1]),
        'responses': <Object?, Object?>{'not_int': 'ok'},
      });
      _expectCborPath(badMapKey, const cf.OpenApiSpecModelCodable(), const [
        'responses',
        'not_int',
      ], 'responses.not_int');

      final badEnumMapKey = _encodeDynamic(<String, Object?>{
        'path': '/v1',
        'method': 'get',
        'schemaHash': Uint8List.fromList([1]),
        'rateLimits': <Object?, Object?>{'patch': 10},
      });
      _expectCborPath(badEnumMapKey, const cf.OpenApiSpecModelCodable(), const [
        'rateLimits',
        'patch',
      ], 'rateLimits.patch');

      final badByteFallback = _encodeDynamic(<String, Object?>{
        'path': '/v1',
        'method': 'get',
        'schemaHash': <Object?>[1, 2, 299],
      });
      _expectCborPath(
        badByteFallback,
        const cf.OpenApiSpecModelCodable(),
        const ['schemaHash', 2],
        'schemaHash[2]',
      );
    });

    test('attributes composite map keys, missing fields, and duplicates', () {
      final badCompositeKey = _encodeDynamic(<String, Object?>{
        'cells': <Object?, Object?>{
          <String, Object?>{'x': 1, 'y': 'bad_y'}: 'origin',
        },
      });
      _expectCborPath(
        badCompositeKey,
        const cf.GridOverlayModelCodable(),
        const ['cells', 0, 'y'],
        'cells[0].y',
      );

      final missingNestedOrderField = _encodeDynamic(<String, Object?>{
        'firstName': 'Ada',
        'lastName': 'Lovelace',
        'dob': '1815-12-10T00:00:00Z',
        'orders': <Object?>[
          <String, Object?>{'dateUs': 100},
          <String, Object?>{'count': 3},
        ],
      });
      _expectCborPath(missingNestedOrderField, const cf.PersonCodable(), const [
        'orders',
        1,
      ], 'orders[1]');

      final aliasDuplicate = _encodeDynamic(<String, Object?>{
        'firstName': 'Ada',
        'lastName': 'Lovelace',
        'date-of-birth': '1815-12-10T00:00:00Z',
        'dob': '1815-12-10T00:00:00Z',
      });
      _expectCborPath(aliasDuplicate, const cf.PersonCodable(), const [
        'dob',
      ], 'dob');
    });

    test('attributes nested SuperDecodable and MappedDecoder errors', () {
      final shapesListDec = Decodable.fromFunction(
        (Decoder d) =>
            d.mapped().decodeListKey('shapes', const _ShapeSuperDecodable()),
      );

      _expectCborPath(
        _encodeDynamic(<String, Object?>{
          'shapes': <Object?>[
            <String, Object?>{'kind': 'circle', 'r': 2.5},
            <String, Object?>{'kind': 'hexagon', 'r': 1.0},
          ],
        }),
        shapesListDec,
        const ['shapes', 1, 'kind'],
        'shapes[1].kind',
      );

      _expectCborPath(
        _encodeDynamic(<String, Object?>{
          'shapes': <Object?>[
            <String, Object?>{'kind': 'circle', 'r': 2.5},
            <String, Object?>{'kind': 'circle', 'r': 'wide'},
          ],
        }),
        shapesListDec,
        const ['shapes', 1, 'r'],
        'shapes[1].r',
      );

      _expectCborPath(
        _encodeDynamic(<String, Object?>{
          'shapes': <Object?>[
            <String, Object?>{'kind': 'circle', 'r': 2.5},
            <String, Object?>{'kind': 'circle'},
          ],
        }),
        shapesListDec,
        const ['shapes', 1],
        'shapes[1]',
      );
    });

    test('supports non-destructive speculative primitive reads', () {
      final payload = _encodeDynamic(<String, Object?>{
        'items': <Object?>['alpha', 42],
      });
      final d = CborCodableDecoder.fromBytes(payload);
      final k = d.keyed();
      check(k.moveNextKey()).isTrue();
      check(k.nextKey()).equals('items');
      final u = k.nestedDecoder().unkeyed();
      final out = <String>[];
      while (u.moveNext()) {
        try {
          out.add(u.readInt().toString());
        } on CodableException catch (e) {
          check(e.path).deepEquals(const ['items', 0]);
          out.add(u.readString());
        }
      }
      check(out).deepEquals(const ['alpha', '42']);
    });
  });
}
