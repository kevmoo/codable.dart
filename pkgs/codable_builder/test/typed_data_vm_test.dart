// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

@TestOn('vm')
library;

import 'dart:typed_data';

import 'package:checks/checks.dart';
import 'package:codable/codable_json.dart';
import 'package:test/test.dart';

import 'fixtures/test_models.dart';

void main() {
  group('VM 64-bit TypedData Roundtrip & Tuple Validation', () {
    test('roundtrips Int64List and Uint64List across KeyedDecoder and MappedDecoder', () {
      final model = Vm64BitTypedDataModel(
        int64: Int64List.fromList([-9000000000000, 0, 9000000000000]),
        uint64: Uint64List.fromList([0, 42, 9000000000000]),
        nullableInt64: Int64List.fromList([-1, 1]),
        nullableUint64: Uint64List.fromList([7, 8]),
        nestedUint64s: [
          Uint64List.fromList([100, 200]),
        ],
        namedUint64s: {
          'counters': Uint64List.fromList([10, 20, 30]),
        },
        tupleInt64: Int64List.fromList([-5, 5]),
        tupleUint64: Uint64List.fromList([11, 22]),
      );

      final encoded = JsonCodableEncoder.encode(
        model,
        const Vm64BitTypedDataModelCodable(),
      );
      final viaKeyed = const Vm64BitTypedDataModelCodable().decode(
        JsonCodableDecoder.fromString(encoded),
      );
      final viaMapped = JsonCodableDecoder.fromString('{"v": $encoded}')
          .mapped()
          .decodeKey('v', const Vm64BitTypedDataModelCodable());

      for (final decoded in [viaKeyed, viaMapped]) {
        check(decoded.int64).deepEquals([-9000000000000, 0, 9000000000000]);
        check(decoded.uint64).deepEquals([0, 42, 9000000000000]);
        check(decoded.nullableInt64).isNotNull().deepEquals([-1, 1]);
        check(decoded.nullableUint64).isNotNull().deepEquals([7, 8]);
        check(decoded.nestedUint64s.single).deepEquals([100, 200]);
        check(decoded.namedUint64s['counters'])
            .isNotNull()
            .deepEquals([10, 20, 30]);
        check(decoded.tupleInt64).isNotNull().deepEquals([-5, 5]);
        check(decoded.tupleUint64).isNotNull().deepEquals([11, 22]);
      }

      const badTupleJson =
          '{"int64": [1], "uint64": [2], "tupleInt64": [1, 2, 3]}';
      check(
            () => const Vm64BitTypedDataModelCodable().decode(
              JsonCodableDecoder.fromString(badTupleJson),
            ),
          )
          .throws<CodableException>()
          .has((e) => e.actualValue, 'actualValue')
          .equals(3);
    });
  });
}
