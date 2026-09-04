// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:typed_data';

import 'package:checks/checks.dart';
import 'package:codable/codable.dart';
import 'package:codable/codable_json.dart';
import 'package:codable/src/json/substrate/mock/substrate_mock.dart' as mock;
import 'package:test/scaffolding.dart';

void main() {
  group('JsonTokenReader property name and colon fusion (mock substrate)', () {
    test('scans keys and values with no whitespace', () {
      final bytes = Uint8List.fromList(
        utf8.encode('{"a":1,"b":"val","c":true}'),
      );
      final reader = mock.JsonTokenReader.fromBytes(bytes);
      final options = mock.JsonKeyOptions.of(['a', 'b', 'c']);

      reader.beginObject();
      check(reader.hasNext()).isTrue();
      check(reader.selectName(options)).equals(0);
      check(reader.readInt()).equals(1);

      check(reader.hasNext()).isTrue();
      check(reader.selectName(options)).equals(1);
      check(reader.readString()).equals('val');

      check(reader.hasNext()).isTrue();
      check(reader.selectName(options)).equals(2);
      check(reader.readBool()).isTrue();

      check(reader.hasNext()).isFalse();
      reader.endObject();
    });

    test('scans keys with nextName and varied whitespace around colon', () {
      final bytes = Uint8List.fromList(
        utf8.encode(
          '{\n  "first" :  10 ,\n  "second"\t:\t20 ,\n  "third"\r\n:\r\n30\n}',
        ),
      );
      final reader = mock.JsonTokenReader.fromBytes(bytes);

      reader.beginObject();
      check(reader.hasNext()).isTrue();
      check(reader.nextName()).equals('first');
      check(reader.readInt()).equals(10);

      check(reader.hasNext()).isTrue();
      check(reader.nextName()).equals('second');
      check(reader.readInt()).equals(20);

      check(reader.hasNext()).isTrue();
      check(reader.nextName()).equals('third');
      check(reader.readInt()).equals(30);

      check(reader.hasNext()).isFalse();
      reader.endObject();
    });

    test('handles empty string key and escaped quotes/backslashes in key', () {
      final bytes = Uint8List.fromList(
        utf8.encode('{"": 0, "k\\"ey": 1, "k\\\\ey": 2}'),
      );
      final reader = mock.JsonTokenReader.fromBytes(bytes);

      reader.beginObject();
      check(reader.hasNext()).isTrue();
      check(reader.nextName()).equals('');
      check(reader.readInt()).equals(0);

      check(reader.hasNext()).isTrue();
      check(reader.nextName()).equals('k"ey');
      check(reader.readInt()).equals(1);

      check(reader.hasNext()).isTrue();
      check(reader.nextName()).equals('k\\ey');
      check(reader.readInt()).equals(2);

      check(reader.hasNext()).isFalse();
      reader.endObject();
    });

    test('selectName correctly matches escaped property keys', () {
      final bytes = Uint8List.fromList(
        utf8.encode(
          r'{"\u0061": 1, "k\"ey": 2, "k\\ey": 3, "\uD83D\uDE00": 4}',
        ),
      );
      final options = mock.JsonKeyOptions.of(['a', 'k"ey', 'k\\ey', '😀']);
      final reader = mock.JsonTokenReader.fromBytes(bytes);

      reader.beginObject();
      check(reader.hasNext()).isTrue();
      check(reader.selectName(options)).equals(0);
      check(reader.readInt()).equals(1);

      check(reader.hasNext()).isTrue();
      check(reader.selectName(options)).equals(1);
      check(reader.readInt()).equals(2);

      check(reader.hasNext()).isTrue();
      check(reader.selectName(options)).equals(2);
      check(reader.readInt()).equals(3);

      check(reader.hasNext()).isTrue();
      check(reader.selectName(options)).equals(3);
      check(reader.readInt()).equals(4);

      check(reader.hasNext()).isFalse();
      reader.endObject();
    });

    test('selectName returns -1 for unknown escaped keys', () {
      final bytes = Uint8List.fromList(utf8.encode(r'{"\u007a": 99}'));
      final reader = mock.JsonTokenReader.fromBytes(bytes);
      final options = mock.JsonKeyOptions.of(['a', 'b', 'c']);

      reader.beginObject();
      check(reader.hasNext()).isTrue();
      check(reader.selectName(options)).equals(-1);
      check(reader.readInt()).equals(99);
      check(reader.hasNext()).isFalse();
      reader.endObject();
    });

    test('selectName correctly matches empty string key', () {
      final bytes = Uint8List.fromList(utf8.encode('{"": 42}'));
      final reader = mock.JsonTokenReader.fromBytes(bytes);
      final options = mock.JsonKeyOptions.of(['', 'a']);

      reader.beginObject();
      check(reader.hasNext()).isTrue();
      check(reader.selectName(options)).equals(0);
      check(reader.readInt()).equals(42);
      check(reader.hasNext()).isFalse();
      reader.endObject();
    });

    test('selectString matches escaped string values', () {
      final bytes = Uint8List.fromList(
        utf8.encode(r'{"v1": "hel\u006co", "v2": "w\"orld", "v3": "plain"}'),
      );
      final reader = mock.JsonTokenReader.fromBytes(bytes);
      final stringOptions = mock.JsonKeyOptions.of([
        'hello',
        'w"orld',
        'plain',
      ]);

      reader.beginObject();
      check(reader.hasNext()).isTrue();
      check(reader.nextName()).equals('v1');
      check(reader.selectString(stringOptions)).equals(0);

      check(reader.hasNext()).isTrue();
      check(reader.nextName()).equals('v2');
      check(reader.selectString(stringOptions)).equals(1);

      check(reader.hasNext()).isTrue();
      check(reader.nextName()).equals('v3');
      check(reader.selectString(stringOptions)).equals(2);

      check(reader.hasNext()).isFalse();
      reader.endObject();
    });

    test('fused colon handles nested objects and arrays', () {
      final bytes = Uint8List.fromList(
        utf8.encode('{"nested" : { "inner" : 42 }, "arr" : [ 1, 2 ] }'),
      );
      final reader = mock.JsonTokenReader.fromBytes(bytes);

      reader.beginObject();
      check(reader.hasNext()).isTrue();
      check(reader.nextName()).equals('nested');
      reader.beginObject();
      check(reader.hasNext()).isTrue();
      check(reader.nextName()).equals('inner');
      check(reader.readInt()).equals(42);
      check(reader.hasNext()).isFalse();
      reader.endObject();

      check(reader.hasNext()).isTrue();
      check(reader.nextName()).equals('arr');
      reader.beginArray();
      check(reader.hasNext()).isTrue();
      check(reader.readInt()).equals(1);
      check(reader.hasNext()).isTrue();
      check(reader.readInt()).equals(2);
      check(reader.hasNext()).isFalse();
      reader.endArray();

      check(reader.hasNext()).isFalse();
      reader.endObject();
    });

    test('throws FormatException when colon is missing', () {
      final bytes = Uint8List.fromList(utf8.encode('{"key" 123}'));
      final reader = mock.JsonTokenReader.fromBytes(bytes);
      reader.beginObject();
      check(reader.hasNext()).isTrue();
      check(reader.nextName).throws<FormatException>();
    });

    test(
      'throws FormatException when colon is missing with extra whitespace',
      () {
        final bytes = Uint8List.fromList(utf8.encode('{"key"   \t\n  123}'));
        final reader = mock.JsonTokenReader.fromBytes(bytes);
        reader.beginObject();
        check(reader.hasNext()).isTrue();
        check(reader.nextName).throws<FormatException>();
      },
    );

    test('throws FormatException when key is not a string', () {
      final bytes = Uint8List.fromList(utf8.encode('{123: 456}'));
      final reader = mock.JsonTokenReader.fromBytes(bytes);
      reader.beginObject();
      check(reader.hasNext()).isTrue();
      check(reader.nextName).throws<FormatException>();
    });

    test('throws FormatException on unterminated key string', () {
      final bytes = Uint8List.fromList(utf8.encode('{"unterminated: 123}'));
      final reader = mock.JsonTokenReader.fromBytes(bytes);
      reader.beginObject();
      check(reader.hasNext()).isTrue();
      check(reader.nextName).throws<FormatException>();
    });

    test(
      'throws FormatException on unterminated key string ending with backslash',
      () {
        final bytes = Uint8List.fromList(utf8.encode(r'{"unterminated\'));
        final reader = mock.JsonTokenReader.fromBytes(bytes);
        reader.beginObject();
        check(reader.hasNext()).isTrue();
        check(reader.nextName).throws<FormatException>();
      },
    );

    test('throws FormatException on unexpected EOF after key', () {
      final bytes = Uint8List.fromList(utf8.encode('{"key"'));
      final reader = mock.JsonTokenReader.fromBytes(bytes);
      reader.beginObject();
      check(reader.hasNext()).isTrue();
      check(reader.nextName).throws<FormatException>();
    });
  });

  group('KeyedDecoder integration with fused property scanning', () {
    test('KeyedDecoder decodes with various whitespace styles', () {
      final json = '''
      {
        "id" : 101 ,
        "name" : "Widget" ,
        "price"   :\t99.5 ,
        "inStock"
        :
        true
      }
      ''';
      final decoder = JsonCodableDecoder.fromBytes(
        Uint8List.fromList(utf8.encode(json)),
      );
      final keyed = decoder.keyed();
      final options = KeyOptions(['id', 'name', 'price', 'inStock']);

      var id = 0;
      var name = '';
      var price = 0.0;
      var inStock = false;

      while (keyed.hasNextKey()) {
        final idx = keyed.selectKeyIndex(options);
        switch (idx) {
          case 0:
            id = keyed.readInt();
          case 1:
            name = keyed.readString();
          case 2:
            price = keyed.readDouble();
          case 3:
            inStock = keyed.readBool();
          default:
            keyed.skipField();
        }
      }

      check(id).equals(101);
      check(name).equals('Widget');
      check(price).equals(99.5);
      check(inStock).isTrue();
    });

    test(
      'KeyedDecoder selectKeyIndex decodes escaped keys and unicode escapes',
      () {
        final json = r'''
      {
        "\u0069d": 202,
        "na\"me": "SpecialWidget",
        "\uD83D\uDE00": true
      }
      ''';
        final decoder = JsonCodableDecoder.fromBytes(
          Uint8List.fromList(utf8.encode(json)),
        );
        final keyed = decoder.keyed();
        final options = KeyOptions(['id', 'na"me', '😀']);

        var id = 0;
        var name = '';
        var happy = false;

        while (keyed.hasNextKey()) {
          final idx = keyed.selectKeyIndex(options);
          switch (idx) {
            case 0:
              id = keyed.readInt();
            case 1:
              name = keyed.readString();
            case 2:
              happy = keyed.readBool();
            default:
              keyed.skipField();
          }
        }

        check(id).equals(202);
        check(name).equals('SpecialWidget');
        check(happy).isTrue();
      },
    );
  });
}
