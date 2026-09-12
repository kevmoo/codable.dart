// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:checks/checks.dart';
import 'package:codable/codable.dart';
import 'package:codable/codable_json.dart';
import 'package:test/scaffolding.dart';

/// Pins the "cold call" contract on [KeyedDecoder].
///
/// Every method that reads from the underlying object must open the object
/// itself if the caller has not already driven the decoder with
/// `hasNextKey()` / `nextKey()`. Generated code always iterates via
/// `hasNextKey()` first, so these paths are not exercised by the rest of the
/// suite -- which is precisely why they need pinning: an optimization that
/// drops the internal `_ensureStarted()` guards passes all other tests while
/// silently breaking direct callers.
void main() {
  group('KeyedDecoder cold-call contract', () {
    test('selectKeyIndex as the first call opens the object', () {
      final options = KeyOptions(['a', 'b']);
      final keyed = JsonCodableDecoder.fromString('{"a":1,"b":2}')
          .keyed(options: options);

      check(keyed.selectKeyIndex(options)).equals(0);
      check(keyed.readInt()).equals(1);
    });

    test('selectKey as the first call opens the object', () {
      final keyed = JsonCodableDecoder.fromString('{"a":1,"b":2}').keyed();

      check(keyed.selectKey(['a', 'b'])).equals(0);
      check(keyed.readInt()).equals(1);
    });

    test('skipValue as the first call does not throw', () {
      final keyed = JsonCodableDecoder.fromString('{"a":1,"b":2}').keyed();

      keyed.skipValue();
    });

    test('skipField as the first call does not throw', () {
      final keyed = JsonCodableDecoder.fromString('{"a":1,"b":2}').keyed();

      keyed.skipField();
    });

    test('peekKey as the first call opens the object', () {
      final keyed = JsonCodableDecoder.fromString('{"a":1}').keyed();

      check(keyed.peekKey()).isNull();
      check(keyed.nextKey()).equals('a');
      check(keyed.readInt()).equals(1);
    });

    test('warm path is unaffected (control)', () {
      final options = KeyOptions(['a', 'b']);
      final keyed = JsonCodableDecoder.fromString('{"a":1,"b":2}')
          .keyed(options: options);

      final seen = <int>[];
      while (keyed.hasNextKey()) {
        seen.add(keyed.selectKeyIndex(options));
        keyed.skipValue();
      }
      check(seen).deepEquals([0, 1]);
    });
  });

  group('KeyOptions instance reuse', () {
    test('a KeyOptions instance other than the constructor one still '
        'works', () {
      // The decoder caches the compiled form of the KeyOptions it was
      // constructed with. Passing a *different* instance must fall back to
      // compiling that instance rather than reusing the cached one.
      final constructed = KeyOptions(['a', 'b']);
      final other = KeyOptions(['b', 'a']);
      final keyed = JsonCodableDecoder.fromString('{"a":1,"b":2}')
          .keyed(options: constructed);

      check(keyed.hasNextKey()).isTrue();
      check(keyed.selectKeyIndex(other)).equals(1);
      check(keyed.readInt()).equals(1);
    });

    test('no options passed to the constructor still resolves keys', () {
      final options = KeyOptions(['a', 'b']);
      final keyed = JsonCodableDecoder.fromString('{"a":1,"b":2}').keyed();

      check(keyed.hasNextKey()).isTrue();
      check(keyed.selectKeyIndex(options)).equals(0);
      check(keyed.readInt()).equals(1);
    });
  });
}
