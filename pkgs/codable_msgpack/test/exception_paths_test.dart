// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:typed_data';

import 'package:checks/checks.dart';
import 'package:codable/codable.dart';
import 'package:codable_msgpack/codable_msgpack.dart';
import 'package:test/test.dart';

import 'cross_format_test.dart' as cf;

Uint8List _encodeDynamic(Object? value) => MsgPackCodableEncoder.encode(
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

CodableException _expectMsgPackPath<T>(
  Uint8List bytes,
  Decodable<T> decodable,
  List<Object> expectedPath,
  String expectedFormatted,
) {
  CodableException? caught;
  try {
    MsgPackCodableDecoder.decode(bytes, decodable);
  } on CodableException catch (e) {
    caught = e;
  }
  check(caught).isNotNull();
  check(caught!.path).deepEquals(expectedPath);
  check(caught.formattedPath).equals(expectedFormatted);
  return caught;
}

Map<String, Object?> _validEnvelopeBase() => <String, Object?>{
  'id': 'env-1',
  'primaryMeta': <String, Object?>{'region': 'us-west', 'revision': 1},
  'payload': Uint8List.fromList([1, 2, 3]),
  'samples': <Object?>[1.0, 2.0],
  'primaryMetric': 10,
  'secondaryMetric': 2.5,
};

void main() {
  group('MessagePack CodableException.path diagnostics', () {
    test('attributes nested object, array, map, and byte-list mismatches', () {
      final badHistory = <String, Object?>{
        ..._validEnvelopeBase(),
        'history': <Object?>[
          <String, Object?>{'region': 'eu', 'revision': 2},
          <String, Object?>{'region': 'ap', 'revision': 'not_int'},
        ],
      };
      _expectMsgPackPath(
        _encodeDynamic(badHistory),
        const cf.CrossFormatEnvelopeCodable(),
        const ['history', 1, 'revision'],
        'history[1].revision',
      );

      final badSample = <String, Object?>{
        ..._validEnvelopeBase(),
        'samples': <Object?>[1.5, 'nan_str'],
      };
      _expectMsgPackPath(
        _encodeDynamic(badSample),
        const cf.CrossFormatEnvelopeCodable(),
        const ['samples', 1],
        'samples[1]',
      );

      final badMapKey = <String, Object?>{
        ..._validEnvelopeBase(),
        'statusLabels': <Object?, Object?>{'bad_code': 'ok'},
      };
      _expectMsgPackPath(
        _encodeDynamic(badMapKey),
        const cf.CrossFormatEnvelopeCodable(),
        const ['statusLabels', 'bad_code'],
        'statusLabels.bad_code',
      );

      final badEnumKey = <String, Object?>{
        ..._validEnvelopeBase(),
        'quotas': <Object?, Object?>{'trace': 5},
      };
      _expectMsgPackPath(
        _encodeDynamic(badEnumKey),
        const cf.CrossFormatEnvelopeCodable(),
        const ['quotas', 'trace'],
        'quotas.trace',
      );

      final badBytes = <String, Object?>{
        ..._validEnvelopeBase(),
        'payload': <Object?>[10, 512],
      };
      _expectMsgPackPath(
        _encodeDynamic(badBytes),
        const cf.CrossFormatEnvelopeCodable(),
        const ['payload', 1],
        'payload[1]',
      );
    });

    test(
      'attributes missing required fields at root and nested containers',
      () {
        final missingRoot = <String, Object?>{
          'primaryMeta': <String, Object?>{'region': 'us', 'revision': 1},
          'payload': Uint8List(0),
          'samples': const <Object?>[],
          'primaryMetric': 1,
          'secondaryMetric': 2,
        };
        _expectMsgPackPath(
          _encodeDynamic(missingRoot),
          const cf.CrossFormatEnvelopeCodable(),
          const [],
          '',
        );

        final missingHistoryItemField = <String, Object?>{
          ..._validEnvelopeBase(),
          'history': <Object?>[
            <String, Object?>{'region': 'us', 'revision': 1},
            <String, Object?>{'region': 'only_region'},
          ],
        };
        _expectMsgPackPath(
          _encodeDynamic(missingHistoryItemField),
          const cf.CrossFormatEnvelopeCodable(),
          const ['history', 1],
          'history[1]',
        );
      },
    );

    test('attributes root and nested SuperDecodable errors', () {
      _expectMsgPackPath(
        _encodeDynamic(<String, Object?>{'kind': 'triangle'}),
        const cf.ShapeNodeCodable(),
        const ['kind'],
        'kind',
      );

      final nestedShapes = Decodable.fromFunction(
        (Decoder d) =>
            d.mapped().decodeListKey('shapes', const cf.ShapeNodeCodable()),
      );

      _expectMsgPackPath(
        _encodeDynamic(<String, Object?>{
          'shapes': <Object?>[
            <String, Object?>{'kind': 'circle', 'radius': 1.0},
            <String, Object?>{'radius': 2.0},
          ],
        }),
        nestedShapes,
        const ['shapes', 1, 'kind'],
        'shapes[1].kind',
      );

      _expectMsgPackPath(
        _encodeDynamic(<String, Object?>{
          'shapes': <Object?>[
            <String, Object?>{'kind': 'circle', 'radius': 1.0},
            <String, Object?>{'kind': 'rhombus', 'radius': 2.0},
          ],
        }),
        nestedShapes,
        const ['shapes', 1, 'kind'],
        'shapes[1].kind',
      );

      _expectMsgPackPath(
        _encodeDynamic(<String, Object?>{
          'shapes': <Object?>[
            <String, Object?>{'kind': 'circle', 'radius': 1.0},
            <String, Object?>{
              'kind': 'polygon',
              'vertices': <Object?>[3, 'bad_vertex'],
            },
          ],
        }),
        nestedShapes,
        const ['shapes', 1, 'vertices', 1],
        'shapes[1].vertices[1]',
      );

      _expectMsgPackPath(
        _encodeDynamic(<String, Object?>{
          'shapes': <Object?>[
            <String, Object?>{'kind': 'circle', 'radius': 1.0},
            <String, Object?>{'kind': 'circle'},
          ],
        }),
        nestedShapes,
        const ['shapes', 1],
        'shapes[1]',
      );
    });

    test('supports non-destructive speculative primitive reads', () {
      final payload = _encodeDynamic(<String, Object?>{
        'tokens': <Object?>['hello', 99],
      });
      final d = MsgPackCodableDecoder.fromBytes(payload);
      final k = d.keyed();
      check(k.moveNextKey()).isTrue();
      check(k.nextKey()).equals('tokens');
      final u = k.nestedDecoder().unkeyed();
      final out = <String>[];
      while (u.moveNext()) {
        try {
          out.add(u.readInt().toString());
        } on CodableException catch (e) {
          check(e.path).deepEquals(const ['tokens', 0]);
          out.add(u.readString());
        }
      }
      check(out).deepEquals(const ['hello', '99']);
    });
  });
}
