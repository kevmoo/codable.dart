import 'dart:typed_data';

import 'package:codable/src/json/substrate/mock/json_token_reader.dart';
import 'package:codable/src/json/substrate/mock/json_token_type.dart';
import 'package:codable/src/json/substrate/mock/span_parsers.dart';

import 'package:test/test.dart';

void main() {
  group('Defect 1: int64 bounds', () {
    test('tryParseIntUtf8 parses valid boundaries', () {
      final pos = '9223372036854775807'.codeUnits;
      expect(
        tryParseIntUtf8(Uint8List.fromList(pos), 0, pos.length),
        9223372036854775807,
      );
      final neg = '-9223372036854775808'.codeUnits;
      expect(
        tryParseIntUtf8(Uint8List.fromList(neg), 0, neg.length),
        -9223372036854775808,
      );
    });
    test('tryParseIntUtf8 returns null on overflow', () {
      final neg1 = '-9223372036854775809'.codeUnits;
      expect(tryParseIntUtf8(Uint8List.fromList(neg1), 0, neg1.length), isNull);
      final neg2 = '-92233720368547758080'.codeUnits;
      expect(tryParseIntUtf8(Uint8List.fromList(neg2), 0, neg2.length), isNull);
      final neg3 = '-92233720368547758085'.codeUnits;
      expect(tryParseIntUtf8(Uint8List.fromList(neg3), 0, neg3.length), isNull);
      final neg4 = '-92233720368547758089999'.codeUnits;
      expect(tryParseIntUtf8(Uint8List.fromList(neg4), 0, neg4.length), isNull);
    });
    test('readNum handles overflows via fallback', () {
      final bytes = Uint8List.fromList('-92233720368547758080'.codeUnits);
      final reader = JsonTokenReader.fromBytes(bytes);
      expect(reader.peek(), JsonTokenType.number);
      expect(reader.readNum(), -92233720368547758080.0);
    });
  });
  group('Defect 4, 5, 6: State machine parity', () {
    test('Truncated stream hasNext returns false or throws at EOF', () {
      final bytes = Uint8List.fromList('[1,'.codeUnits);
      final reader = JsonTokenReader.fromBytes(bytes);
      reader.beginArray();
      expect(reader.hasNext(), isTrue);
      expect(reader.readInt(), 1);
      expect(reader.hasNext, throwsA(isA<FormatException>()));
    });
    test('Direct nextName reads fine without hasNext', () {
      final bytes = Uint8List.fromList('{"a": 1, "b": 2}'.codeUnits);
      final reader = JsonTokenReader.fromBytes(bytes);
      reader.beginObject();
      expect(reader.nextName(), 'a');
      expect(reader.readInt(), 1);
      expect(reader.nextName(), 'b');
      expect(reader.readInt(), 2);
      reader.endObject();
    });
    test('Direct array read without hasNext', () {
      final bytes = Uint8List.fromList('[1, 2]'.codeUnits);
      final reader = JsonTokenReader.fromBytes(bytes);
      reader.beginArray();
      expect(reader.readInt(), 1);
      expect(reader.readInt(), 2);
      reader.endArray();
    });
    test('beginObject/beginArray enforce parent state on entry', () {
      final bytes = Uint8List.fromList('{ {"a": 1} }'.codeUnits);
      final reader = JsonTokenReader.fromBytes(bytes);
      reader.beginObject();
      // Fails on entry because reading a value when it expects a property name
      expect(reader.beginObject, throwsA(isA<FormatException>()));
    });
    test('Multiple root values rejected', () {
      final bytes = Uint8List.fromList('123 456'.codeUnits);
      final reader = JsonTokenReader.fromBytes(bytes);
      expect(reader.readInt(), 123);
      expect(reader.readInt, throwsA(isA<FormatException>()));
    });
  });
  group('String control chars', () {
    test('peek() on key expects propertyName', () {
      final bytes = Uint8List.fromList('{"a": 1}'.codeUnits);
      final reader = JsonTokenReader.fromBytes(bytes);
      reader.beginObject();
      expect(reader.peek(), JsonTokenType.propertyName);
    });
  });
}
