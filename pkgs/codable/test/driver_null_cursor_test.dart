// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:checks/checks.dart';
import 'package:codable/codable_json.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('JsonCodableDecoder null property cursor regression tests', () {
    test(
      'manual nextKey() iteration on null value advances cursor correctly',
      () {
        final jsonBytes = Uint8List.fromList(
          utf8.encode('{"first": null, "second": 123}'),
        );
        final decoder = JsonCodableDecoder.fromBytes(jsonBytes);
        final keyed = decoder.keyed();

        check(keyed.moveNextKey()).isTrue();
        check(keyed.nextKey()).equals('first');
        check(keyed.isNextNull()).isTrue();
        keyed.readNull();

        check(keyed.moveNextKey()).isTrue();
        check(keyed.nextKey()).equals('second');
        check(keyed.readInt()).equals(123);
        check(keyed.moveNextKey()).isFalse();
      },
    );

    test('manual nextKey() iteration on multiple null and present values', () {
      final jsonBytes = Uint8List.fromList(
        utf8.encode('{"a": null, "b": "hello", "c": null, "d": 42}'),
      );
      final decoder = JsonCodableDecoder.fromBytes(jsonBytes);
      final keyed = decoder.keyed();

      check(keyed.moveNextKey()).isTrue();
      check(keyed.nextKey()).equals('a');
      check(keyed.isNextNull()).isTrue();
      keyed.readNull();

      check(keyed.moveNextKey()).isTrue();
      check(keyed.nextKey()).equals('b');
      check(keyed.isNextNull()).isFalse();
      check(keyed.readString()).equals('hello');

      check(keyed.moveNextKey()).isTrue();
      check(keyed.nextKey()).equals('c');
      check(keyed.isNextNull()).isTrue();
      keyed.readNull();

      check(keyed.moveNextKey()).isTrue();
      check(keyed.nextKey()).equals('d');
      check(keyed.isNextNull()).isFalse();
      check(keyed.readInt()).equals(42);

      check(keyed.moveNextKey()).isFalse();
    });

    test('SingleValueDecoder.decode properly scopes nested single value', () {
      final jsonBytes = Uint8List.fromList(utf8.encode('{"inner": "hello"}'));
      final decoder = JsonCodableDecoder.fromBytes(jsonBytes);
      final single = decoder.singleValue();

      final result = single.decode(
        Decodable.fromFunction((d) {
          final keyed = d.keyed();
          check(keyed.moveNextKey()).isTrue();
          check(keyed.nextKey()).equals('inner');
          return keyed.readString();
        }),
      );

      check(result).equals('hello');
    });

    test('MappedDecoder preserves int values and traverses nested objects and '
        'lists in-memory', () {
      final jsonBytes = Uint8List.fromList(
        utf8.encode(
          '{"name": "test", "count": 42, "ratio": 3.5, '
          '"items": ["a", "b"], "ints": [10, 20, 30], '
          '"nested": {"id": 99, "flag": true, "tags": ["x", "y"]}}',
        ),
      );
      final decoder = JsonCodableDecoder.fromBytes(jsonBytes);
      final mapped = decoder.mapped();

      check(mapped.containsKey('name')).isTrue();
      check(mapped.containsKey('missing')).isFalse();
      check(mapped.readString('name')).equals('test');
      check(mapped.readInt('count')).equals(42);
      check(mapped.readDouble('ratio')).equals(3.5);
      check(mapped.decodeStringList('items')).deepEquals(['a', 'b']);
      check(mapped.decodeIntList('ints')).deepEquals([10, 20, 30]);

      final nestedSummary = mapped.decodeKey(
        'nested',
        Decodable.fromFunction((d) {
          final k = d.keyed();
          var id = 0;
          var flag = false;
          var tags = <String>[];
          while (k.moveNextKey()) {
            switch (k.nextKey()) {
              case 'id':
                id = k.readInt();
              case 'flag':
                flag = k.readBool();
              case 'tags':
                tags = k.decodeStringList();
              default:
                k.skipValue();
            }
          }
          return '$id:$flag:${tags.join(",")}';
        }),
      );
      check(nestedSummary).equals('99:true:x,y');
    });
  });
}
