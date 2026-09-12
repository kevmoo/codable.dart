// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:typed_data';

import 'package:codable/src/json/driver/adaptive_writer.dart';
import 'package:test/test.dart';

void main() {
  group('AdaptiveJsonTokenWriter', () {
    test('encodes empty object and empty array', () {
      final wObj = AdaptiveJsonTokenWriter();
      wObj.beginObject();
      wObj.endObject();
      expect(utf8.decode(wObj.takeBytes()), '{}');

      final wArr = AdaptiveJsonTokenWriter();
      wArr.beginArray();
      wArr.endArray();
      expect(utf8.decode(wArr.takeBytes()), '[]');
    });

    test('encodes primitives and objects', () {
      final writer = AdaptiveJsonTokenWriter();
      writer.beginObject();
      writer.writeName('int');
      writer.writeInt(42);
      writer.writeName('negativeInt');
      writer.writeInt(-100);
      writer.writeName('zero');
      writer.writeInt(0);
      writer.writeName('string');
      writer.writeString('hello world');
      writer.writeName('boolTrue');
      writer.writeBool(true);
      writer.writeName('boolFalse');
      writer.writeBool(false);
      writer.writeName('nullVal');
      writer.writeNull();
      writer.writeName('doubleVal');
      writer.writeDouble(3.14159);
      writer.endObject();

      final json = utf8.decode(writer.takeBytes());
      final decoded = jsonDecode(json) as Map<String, Object?>;
      expect(decoded['int'], 42);
      expect(decoded['negativeInt'], -100);
      expect(decoded['zero'], 0);
      expect(decoded['string'], 'hello world');
      expect(decoded['boolTrue'], true);
      expect(decoded['boolFalse'], false);
      expect(decoded['nullVal'], isNull);
      expect(decoded['doubleVal'], 3.14159);
    });

    test('escapes strings properly', () {
      final writer = AdaptiveJsonTokenWriter();
      writer.beginArray();
      writer.writeString('quote: " and backslash: \\');
      writer.writeString('newline: \n, cr: \r, tab: \t');
      writer.writeString('control: \x00 and \x1f');
      writer.writeString('unicode: café, 你好, 🚀');
      writer.endArray();

      final json = utf8.decode(writer.takeBytes());
      final decoded = (jsonDecode(json) as List).cast<String>();
      expect(decoded[0], 'quote: " and backslash: \\');
      expect(decoded[1], 'newline: \n, cr: \r, tab: \t');
      expect(decoded[2], 'control: \x00 and \x1f');
      expect(decoded[3], 'unicode: café, 你好, 🚀');
    });

    test(
      'writeNameBytes handles unquoted, quoted, and colon-terminated keys',
      () {
        final writer = AdaptiveJsonTokenWriter();
        writer.beginObject();
        writer.writeNameBytes(Uint8List.fromList(utf8.encode('unquoted')));
        writer.writeInt(1);
        writer.writeNameBytes(Uint8List.fromList(utf8.encode('"quoted"')));
        writer.writeInt(2);
        writer.writeNameBytes(Uint8List.fromList(utf8.encode('"colon":')));
        writer.writeInt(3);
        writer.endObject();

        final json = utf8.decode(writer.takeBytes());
        final decoded = jsonDecode(json) as Map<String, Object?>;
        expect(decoded, {'unquoted': 1, 'quoted': 2, 'colon': 3});
      },
    );

    test('writeDouble rejects NaN and infinities', () {
      final writer = AdaptiveJsonTokenWriter();
      writer.beginArray();
      expect(
        () => writer.writeDouble(double.nan),
        throwsA(isA<UnsupportedError>()),
      );
      expect(
        () => writer.writeDouble(double.infinity),
        throwsA(isA<UnsupportedError>()),
      );
      expect(
        () => writer.writeDouble(double.negativeInfinity),
        throwsA(isA<UnsupportedError>()),
      );
    });

    test('writeDouble encodes doubles and array fast path', () {
      final writer = AdaptiveJsonTokenWriter();
      writer.beginArray();
      writer.writeDouble(0.0);
      writer.writeDouble(-0.0);
      writer.writeDouble(1.0);
      writer.writeDouble(-42.0);
      writer.writeDouble(-65.561935);
      writer.writeDouble(1.2345e20);
      writer.endArray();

      final json = utf8.decode(writer.takeBytes());
      final decoded = (jsonDecode(json) as List).cast<num>();
      expect(decoded[0], 0.0);
      expect(decoded[1], 0.0);
      expect(decoded[2], 1.0);
      expect(decoded[3], -42.0);
      expect(decoded[4], closeTo(-65.561935, 1e-9));
      expect(decoded[5], 1.2345e20);
    });

    test('transitions to chunked builder on capacity overflow', () {
      // Start with tiny initial capacity (16 bytes) to force reallocation.
      final writer = AdaptiveJsonTokenWriter(16);
      writer.beginArray();
      for (var i = 0; i < 500; i++) {
        writer.writeInt(i);
      }
      writer.endArray();

      final json = utf8.decode(writer.takeBytes());
      final decoded = (jsonDecode(json) as List).cast<int>();
      expect(decoded.length, 500);
      expect(decoded.first, 0);
      expect(decoded.last, 499);
    });

    test('flush preserves buffer content without corruption', () {
      final writer = AdaptiveJsonTokenWriter(32);
      writer.beginArray();
      writer.writeString('item-1');
      writer.flush();
      writer.writeString('item-2');
      writer.flush();
      writer.writeString('item-3');
      writer.endArray();

      final json = utf8.decode(writer.takeBytes());
      expect(jsonDecode(json), ['item-1', 'item-2', 'item-3']);
    });

    test('writeAsciiLiteral and writeRawJson', () {
      final writer = AdaptiveJsonTokenWriter();
      writer.beginObject();
      writer.writeName('raw');
      writer.writeRawJson(Uint8List.fromList(utf8.encode('{"nested": true}')));
      writer.writeName('literal');
      writer.writeAsciiLiteral(
        Uint8List.fromList(utf8.encode('"literalValue"')),
      );
      writer.endObject();

      final json = utf8.decode(writer.takeBytes());
      expect(jsonDecode(json), {
        'raw': {'nested': true},
        'literal': 'literalValue',
      });
    });

    group('state machine validation', () {
      test('throws on multiple root values', () {
        final writer = AdaptiveJsonTokenWriter();
        writer.writeInt(1);
        expect(() => writer.writeInt(2), throwsStateError);
      });

      test('throws on unbalanced endObject or endArray', () {
        final writer = AdaptiveJsonTokenWriter();
        expect(writer.endObject, throwsStateError);
        expect(writer.endArray, throwsStateError);

        writer.beginArray();
        expect(writer.endObject, throwsStateError);

        final objWriter = AdaptiveJsonTokenWriter();
        objWriter.beginObject();
        expect(objWriter.endArray, throwsStateError);
      });

      test('throws on value without property name in object', () {
        final writer = AdaptiveJsonTokenWriter();
        writer.beginObject();
        expect(() => writer.writeInt(123), throwsStateError);
      });

      test('throws on successive property names in object', () {
        final writer = AdaptiveJsonTokenWriter();
        writer.beginObject();
        writer.writeName('key1');
        expect(() => writer.writeName('key2'), throwsStateError);
        expect(
          () => writer.writeNameBytes(Uint8List.fromList([34, 120, 34])),
          throwsStateError,
        );
      });

      test('throws on endObject when expecting value for property', () {
        final writer = AdaptiveJsonTokenWriter();
        writer.beginObject();
        writer.writeName('key');
        expect(writer.endObject, throwsStateError);
      });
    });
  });
}
