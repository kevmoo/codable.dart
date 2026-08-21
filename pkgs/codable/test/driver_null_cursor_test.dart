// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:checks/checks.dart';
import 'package:codable/codable.dart';
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

        check(keyed.hasNextKey()).isTrue();
        check(keyed.nextKey()).equals('first');
        check(keyed.isNextNull()).isTrue();
        keyed.readNull();

        check(keyed.hasNextKey()).isTrue();
        check(keyed.nextKey()).equals('second');
        check(keyed.readInt()).equals(123);
        check(keyed.hasNextKey()).isFalse();
      },
    );

    test('manual nextKey() iteration on multiple null and present values', () {
      final jsonBytes = Uint8List.fromList(
        utf8.encode('{"a": null, "b": "hello", "c": null, "d": 42}'),
      );
      final decoder = JsonCodableDecoder.fromBytes(jsonBytes);
      final keyed = decoder.keyed();

      check(keyed.hasNextKey()).isTrue();
      check(keyed.nextKey()).equals('a');
      check(keyed.isNextNull()).isTrue();
      keyed.readNull();

      check(keyed.hasNextKey()).isTrue();
      check(keyed.nextKey()).equals('b');
      check(keyed.isNextNull()).isFalse();
      check(keyed.readString()).equals('hello');

      check(keyed.hasNextKey()).isTrue();
      check(keyed.nextKey()).equals('c');
      check(keyed.isNextNull()).isTrue();
      keyed.readNull();

      check(keyed.hasNextKey()).isTrue();
      check(keyed.nextKey()).equals('d');
      check(keyed.isNextNull()).isFalse();
      check(keyed.readInt()).equals(42);

      check(keyed.hasNextKey()).isFalse();
    });
  });
}
