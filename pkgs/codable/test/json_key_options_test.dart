// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:typed_data';

import 'package:codable/src/json/substrate/mock/json_key_options.dart';
import 'package:test/test.dart';

void main() {
  group('JsonKeyOptions', () {
    test('throws ArgumentError on empty keys list', () {
      expect(() => JsonKeyOptions.of([]), throwsArgumentError);
    });

    test('single key options table', () {
      final options = JsonKeyOptions.of(['id']);
      expect(options.length, 1);
      expect(options.keys, ['id']);
      expect(options.indexOf('id'), 0);
      expect(options.indexOf('other'), -1);

      final buffer = Uint8List.fromList(utf8.encode('{"id": 123}'));
      // span for "id" at index 2..4
      expect(options.selectKey(buffer, 2, 4), 0);
      // span for mismatch length
      expect(options.selectKey(buffer, 1, 4), -1);
      // span for mismatch content
      expect(options.selectKey(buffer, 7, 9), -1);
    });

    test('empty string key support', () {
      final options = JsonKeyOptions.of(['', 'name']);
      expect(options.length, 2);
      expect(options.indexOf(''), 0);
      expect(options.indexOf('name'), 1);

      final emptyBuffer = Uint8List(0);
      expect(options.selectKey(emptyBuffer, 0, 0), 0);

      final buffer = Uint8List.fromList(utf8.encode('""'));
      expect(options.selectKey(buffer, 1, 1), 0);
      expect(options.selectKey(buffer, 0, 2), -1);
    });

    test('boundary checks on selectKey', () {
      final options = JsonKeyOptions.of(['alpha', 'beta']);
      final buffer = Uint8List.fromList(utf8.encode('alpha'));

      expect(options.selectKey(buffer, -1, 5), -1);
      expect(options.selectKey(buffer, 0, 6), -1);
      expect(options.selectKey(buffer, 3, 2), -1);
      expect(options.selectKey(buffer, 0, 5), 0);
    });

    test('distinguishes keys with identical length', () {
      final options = JsonKeyOptions.of(['text', 'user', 'lang']);
      expect(options.length, 3);

      final source = Uint8List.fromList(utf8.encode('text user lang test'));
      expect(options.selectKey(source, 0, 4), 0); // text
      expect(options.selectKey(source, 5, 9), 1); // user
      expect(options.selectKey(source, 10, 14), 2); // lang
      expect(options.selectKey(source, 15, 19), -1); // test (unmatched)
    });

    test(
      'distinguishes keys with identical length, first byte, and last byte',
      () {
        // Both length 6, both start with 'c', both end with 'e'
        final options = JsonKeyOptions.of(['create', 'cookie']);
        expect(options.length, 2);

        final source = Uint8List.fromList(utf8.encode('create cookie candle'));
        expect(options.selectKey(source, 0, 6), 0); // create
        expect(options.selectKey(source, 7, 13), 1); // cookie
        expect(options.selectKey(source, 14, 20), -1); // candle
      },
    );

    test('handles multibyte UTF-8 keys', () {
      final options = JsonKeyOptions.of(['café', '🚀rocket', 'ümlaut']);
      expect(options.length, 3);

      final cafeBytes = Uint8List.fromList(utf8.encode('café'));
      final rocketBytes = Uint8List.fromList(utf8.encode('🚀rocket'));
      final umlautBytes = Uint8List.fromList(utf8.encode('ümlaut'));

      expect(options.selectKey(cafeBytes, 0, cafeBytes.length), 0);
      expect(options.selectKey(rocketBytes, 0, rocketBytes.length), 1);
      expect(options.selectKey(umlautBytes, 0, umlautBytes.length), 2);

      final badBytes = Uint8List.fromList(utf8.encode('cafe'));
      expect(options.selectKey(badBytes, 0, badBytes.length), -1);
    });

    test('handles duplicate keys returning first matching index', () {
      final options = JsonKeyOptions.of(['dup', 'other', 'dup']);
      expect(options.length, 3);
      expect(options.indexOf('dup'), 0);
      expect(options.indexOf('other'), 1);

      final buffer = Uint8List.fromList(utf8.encode('dup'));
      expect(options.selectKey(buffer, 0, 3), 0);
    });

    test(
      'handles unusually long keys exceeding 256 bytes (hash table fallback)',
      () {
        final longKey1 = 'prefix_${'a' * 300}_suffix1';
        final longKey2 = 'prefix_${'a' * 300}_suffix2';
        final shortKey = 'short';

        final options = JsonKeyOptions.of([longKey1, shortKey, longKey2]);
        expect(options.length, 3);
        expect(options.indexOf(longKey1), 0);
        expect(options.indexOf(shortKey), 1);
        expect(options.indexOf(longKey2), 2);

        final buf1 = Uint8List.fromList(utf8.encode(longKey1));
        final buf2 = Uint8List.fromList(utf8.encode(longKey2));
        final bufShort = Uint8List.fromList(utf8.encode(shortKey));
        final bufUnmatched = Uint8List.fromList(
          utf8.encode('prefix_${'a' * 300}_suffix3'),
        );

        expect(options.selectKey(buf1, 0, buf1.length), 0);
        expect(options.selectKey(bufShort, 0, bufShort.length), 1);
        expect(options.selectKey(buf2, 0, buf2.length), 2);
        expect(options.selectKey(bufUnmatched, 0, bufUnmatched.length), -1);
      },
    );

    test('handles 1-char and 2-char keys correctly', () {
      final options = JsonKeyOptions.of(['a', 'b', 'ab', 'ba', 'aa']);
      expect(options.length, 5);

      final buf = Uint8List.fromList(utf8.encode('a b ab ba aa bb'));
      expect(options.selectKey(buf, 0, 1), 0);
      expect(options.selectKey(buf, 2, 3), 1);
      expect(options.selectKey(buf, 4, 6), 2);
      expect(options.selectKey(buf, 7, 9), 3);
      expect(options.selectKey(buf, 10, 12), 4);
      expect(options.selectKey(buf, 13, 15), -1);
    });

    test('handles keys that share common prefixes and suffixes', () {
      final options = JsonKeyOptions.of(['user', 'users', 'username', 'use']);
      final buf = Uint8List.fromList(utf8.encode('user users username use us'));

      expect(options.selectKey(buf, 0, 4), 0); // user
      expect(options.selectKey(buf, 5, 10), 1); // users
      expect(options.selectKey(buf, 11, 19), 2); // username
      expect(options.selectKey(buf, 20, 23), 3); // use
      expect(options.selectKey(buf, 24, 26), -1); // us (unmatched)
    });

    test('handles keys with identical length, first byte, middle byte, and '
        'last byte', () {
      // len 7: index 0 is 'c', index 3 is 't', index 6 is 'e'
      // 'c' + 'an' + 't' + 'er' + 'e'
      // 'c' + 'os' + 't' + 'um' + 'e'
      // 'c' + 'us' + 't' + 'od' + 'e'
      final key1 = 'cantere';
      final key2 = 'costume';
      final key3 = 'custode';
      final options = JsonKeyOptions.of([key1, key2, key3]);

      final buf1 = Uint8List.fromList(utf8.encode(key1));
      final buf2 = Uint8List.fromList(utf8.encode(key2));
      final buf3 = Uint8List.fromList(utf8.encode(key3));
      final bufUnmatched = Uint8List.fromList(utf8.encode('centere'));

      expect(options.selectKey(buf1, 0, 7), 0);
      expect(options.selectKey(buf2, 0, 7), 1);
      expect(options.selectKey(buf3, 0, 7), 2);
      expect(options.selectKey(bufUnmatched, 0, 7), -1);
    });

    test('handles large key sets with 200 keys without collision bugs', () {
      final keys = List<String>.generate(200, (i) => 'field_property_name_$i');
      final options = JsonKeyOptions.of(keys);
      expect(options.length, 200);

      for (var i = 0; i < keys.length; i++) {
        final buf = Uint8List.fromList(utf8.encode(keys[i]));
        expect(options.selectKey(buf, 0, buf.length), i);
        expect(options.indexOf(keys[i]), i);
      }

      final unmatched = Uint8List.fromList(
        utf8.encode('field_property_name_201'),
      );
      expect(options.selectKey(unmatched, 0, unmatched.length), -1);
    });
  });
}
