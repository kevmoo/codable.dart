// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';

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
///
/// The tests run over both decoder construction paths because they select
/// different implementations per platform (verified by inspecting
/// `runtimeType` on each):
///
/// - `fromString`: `_JsonCodableKeyedDecoder` on the VM,
///   `_JsonCodableMappedKeyedDecoder` on JS.
/// - `fromBytes` with a payload <= 2048 bytes: `_JsonCodableKeyedDecoder` on
///   the VM, `_JsonCodableStreamingKeyedDecoder` on JS.
/// - `fromBytes` with a payload > 2048 bytes: same as `fromString`.
///
/// Running only `fromString` on the VM leaves both JS classes uncovered, and
/// `_JsonCodableStreamingKeyedDecoder` is reachable on JS *only* through the
/// small-payload `fromBytes` branch.
void main() {
  /// Builds a keyed decoder over [source] using each construction path.
  ///
  /// Returns fresh decoders; call the factory again for each assertion so no
  /// test shares cursor state.
  final constructions = <String, KeyedDecoder Function(String, KeyOptions?)>{
    'fromString': (source, options) =>
        JsonCodableDecoder.fromString(source).keyed(options: options),
    'fromBytes': (source, options) =>
        JsonCodableDecoder.fromBytes(utf8.encode(source))
            .keyed(options: options),
  };

  constructions.forEach((label, keyedOver) {
    group('KeyedDecoder cold-call contract ($label)', () {
      test('selectKeyIndex as the first call opens the object', () {
        final options = KeyOptions(['a', 'b']);
        final keyed = keyedOver('{"a":1,"b":2}', options);

        check(keyed.selectKeyIndex(options)).equals(0);
        check(keyed.readInt()).equals(1);
      });

      test('selectKey as the first call opens the object', () {
        final keyed = keyedOver('{"a":1,"b":2}', null);

        check(keyed.selectKey(['a', 'b'])).equals(0);
        check(keyed.readInt()).equals(1);
      });

      test('skipValue as the first call does not throw', () {
        final keyed = keyedOver('{"a":1,"b":2}', null);

        keyed.skipValue();
      });

      test('skipField as the first call does not throw', () {
        final keyed = keyedOver('{"a":1,"b":2}', null);

        keyed.skipField();
      });

      test('peekKey as the first call leaves the cursor usable', () {
        // peekKey's return value is deliberately not asserted: the streaming
        // drivers return null (peek unsupported) while the JS mapped decoder
        // returns the real key. The contract under test is that calling it
        // cold opens the object without consuming anything.
        final keyed = keyedOver('{"a":1}', null);

        keyed.peekKey();

        check(keyed.nextKey()).equals('a');
        check(keyed.readInt()).equals(1);
      });

      test('warm path is unaffected (control)', () {
        final options = KeyOptions(['a', 'b']);
        final keyed = keyedOver('{"a":1,"b":2}', options);

        final seen = <int>[];
        while (keyed.hasNextKey()) {
          seen.add(keyed.selectKeyIndex(options));
          keyed.skipValue();
        }
        check(seen).deepEquals([0, 1]);
      });
    });

    group('KeyOptions instance reuse ($label)', () {
      test('a KeyOptions instance other than the constructor one works', () {
        // The decoder caches the compiled form of the KeyOptions it was
        // constructed with. Passing a *different* instance must fall back to
        // compiling that instance rather than reusing the cached one.
        final constructed = KeyOptions(['a', 'b']);
        final other = KeyOptions(['b', 'a']);
        final keyed = keyedOver('{"a":1,"b":2}', constructed);

        check(keyed.hasNextKey()).isTrue();
        check(keyed.selectKeyIndex(other)).equals(1);
        check(keyed.readInt()).equals(1);
      });

      test('no options passed to the constructor still resolves keys', () {
        final options = KeyOptions(['a', 'b']);
        final keyed = keyedOver('{"a":1,"b":2}', null);

        check(keyed.hasNextKey()).isTrue();
        check(keyed.selectKeyIndex(options)).equals(0);
        check(keyed.readInt()).equals(1);
      });
    });
  });
}
