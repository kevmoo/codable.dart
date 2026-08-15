import 'dart:convert';

import 'package:checks/checks.dart';
import 'package:codable/codable.dart';
import 'package:codable/src/driver/json_codable_driver.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('SDK Atom Inventory & Traceability Audit Test Suite', () {
    // -------------------------------------------------------------------------
    // 1. Top-Level Codec & Convenience Functions (Items 1-9)
    // -------------------------------------------------------------------------
    test('Items 1-9: Top-Level Codecs and Functions', () {
      final data = {'id': 123, 'name': 'Alice'};

      // 1. JsonUtf8Codec & 7. jsonUtf8
      check(jsonUtf8).isA<JsonUtf8Codec>();
      final encoded = jsonUtf8.encode(data);
      check(encoded).isNotEmpty();

      // 8. jsonUtf8Decode
      final decoded = jsonUtf8Decode(encoded) as Map<String, dynamic>;
      check(decoded['id']).equals(123);
      check(decoded['name']).equals('Alice');

      // 9. jsonUtf8Encode
      final encodedBytes = jsonUtf8Encode(data);
      check(encodedBytes).isA<Uint8List>();

      // 2. JsonUtf8Decoder
      final decoder = const JsonUtf8Decoder();
      check(decoder.convert(encoded)).isNotNull();

      // 4. JsonTokenType
      check(JsonTokenType.values.length).equals(11);
    });

    // -------------------------------------------------------------------------
    // 2. Static Members on JsonUtf8Decoder (Items 10-23)
    // -------------------------------------------------------------------------
    test('Items 10-23: JsonUtf8Decoder Static Span Atoms', () {
      final doubleBytes = Uint8List.fromList(utf8.encode('123.456'));
      final intBytes = Uint8List.fromList(utf8.encode('7890'));
      final boolBytes = Uint8List.fromList(utf8.encode('true'));
      final nullBytes = Uint8List.fromList(utf8.encode('null'));
      final strBytes = Uint8List.fromList(utf8.encode('"hello\\nworld"'));
      final jsonPayload = Uint8List.fromList(
        utf8.encode('  {"key": [1, 2, 3], "flag": false}'),
      );

      // 10 & 11: parseDouble & tryParseDouble
      check(
        JsonUtf8Decoder.parseDouble(doubleBytes, 0, doubleBytes.length),
      ).equals(123.456);
      check(
        JsonUtf8Decoder.tryParseDouble(doubleBytes, 0, doubleBytes.length),
      ).equals(123.456);

      // 12 & 13: parseInt & tryParseInt
      check(
        JsonUtf8Decoder.parseInt(intBytes, 0, intBytes.length),
      ).equals(7890);
      check(
        JsonUtf8Decoder.tryParseInt(intBytes, 0, intBytes.length),
      ).equals(7890);

      // 14 & 15: parseBool & tryParseBool
      check(
        JsonUtf8Decoder.parseBool(boolBytes, 0, boolBytes.length),
      ).equals(true);
      check(
        JsonUtf8Decoder.tryParseBool(boolBytes, 0, boolBytes.length),
      ).equals(true);

      // 16: isNull
      check(JsonUtf8Decoder.isNull(nullBytes, 0, nullBytes.length)).isTrue();

      // 17: equalsAscii
      check(
        JsonUtf8Decoder.equalsAscii(intBytes, 0, intBytes.length, '7890'),
      ).isTrue();

      // 18: matchKey & 39: JsonKeyOptions.of
      final keyOptions = JsonKeyOptions.of(['key', 'flag', 'other']);
      final keySlice = Uint8List.fromList(utf8.encode('flag'));
      check(
        JsonUtf8Decoder.matchKey(keySlice, 0, keySlice.length, keyOptions),
      ).equals(1);

      // 19: isVerbatim
      check(JsonUtf8Decoder.isVerbatim(intBytes, 0, intBytes.length)).isTrue();
      check(JsonUtf8Decoder.isVerbatim(strBytes, 0, strBytes.length)).isFalse();

      // 20: decodeString
      check(
        JsonUtf8Decoder.decodeString(strBytes, 1, strBytes.length - 1),
      ).equals('hello\nworld');

      // 21: skipValue
      final skippedEnd = JsonUtf8Decoder.skipValue(jsonPayload, 2);
      check(skippedEnd).equals(jsonPayload.length);

      // 22: skipWhitespace
      final nonWs = JsonUtf8Decoder.skipWhitespace(jsonPayload, 0);
      check(nonWs).equals(2);

      // 23: skipString
      final skippedStr = JsonUtf8Decoder.skipString(strBytes, 0);
      check(skippedStr).equals(strBytes.length);
    });

    // -------------------------------------------------------------------------
    // 3. Static Members on JsonUtf8Encoder (Items 24-38)
    // -------------------------------------------------------------------------
    test('Items 24-38: JsonUtf8Encoder Static Formatting Atoms', () {
      final sink = BytesBuilder();
      final buffer = Uint8List(128);

      // 24 & 25: writeString & writeStringToBuffer
      JsonUtf8Encoder.writeString('test"escaped"', sink);
      check(sink.length).isGreaterThan(0);
      final strLen = JsonUtf8Encoder.writeStringToBuffer('hello', buffer, 0);
      check(strLen).isGreaterThan(0);

      // 26 & 27: writeDouble & writeDoubleToBuffer
      sink.clear();
      JsonUtf8Encoder.writeDouble(3.14159, sink);
      check(utf8.decode(sink.toBytes())).equals('3.14159');
      final dblLen = JsonUtf8Encoder.writeDoubleToBuffer(2.718, buffer, 0);
      check(dblLen).isGreaterThan(0);

      // 28 & 29: writeInt & writeIntToBuffer
      sink.clear();
      JsonUtf8Encoder.writeInt(42, sink);
      check(utf8.decode(sink.toBytes())).equals('42');
      final intLen = JsonUtf8Encoder.writeIntToBuffer(100, buffer, 0);
      check(intLen).isGreaterThan(0);

      // 30 & 31: writeBool & writeBoolToBuffer
      sink.clear();
      JsonUtf8Encoder.writeBool(true, sink);
      check(utf8.decode(sink.toBytes())).equals('true');
      final boolLen = JsonUtf8Encoder.writeBoolToBuffer(false, buffer, 0);
      check(boolLen).isGreaterThan(0);

      // 32 & 33: writeNull & writeNullToBuffer
      sink.clear();
      JsonUtf8Encoder.writeNull(sink);
      check(utf8.decode(sink.toBytes())).equals('null');
      final nullLen = JsonUtf8Encoder.writeNullToBuffer(buffer, 0);
      check(nullLen).equals(4);

      // 34 & 35: writeAsciiLiteral & writeAsciiLiteralToBuffer
      final literal = Uint8List.fromList(utf8.encode('"status":'));
      sink.clear();
      JsonUtf8Encoder.writeAsciiLiteral(literal, sink);
      check(utf8.decode(sink.toBytes())).equals('"status":');
      final litLen = JsonUtf8Encoder.writeAsciiLiteralToBuffer(
        literal,
        buffer,
        0,
      );
      check(litLen).equals(literal.length);

      // 36 & 37: writeRawJson & writeRawJsonToBuffer
      final raw = Uint8List.fromList(utf8.encode('{"raw":true}'));
      sink.clear();
      JsonUtf8Encoder.writeRawJson(raw, sink);
      check(utf8.decode(sink.toBytes())).equals('{"raw":true}');
      final rawLen = JsonUtf8Encoder.writeRawJsonToBuffer(raw, buffer, 0);
      check(rawLen).equals(raw.length);

      // 38: writePropertyPrefixToBuffer
      final keyBytes = Uint8List.fromList(utf8.encode('"x"'));
      final prefixLenFirst = JsonUtf8Encoder.writePropertyPrefixToBuffer(
        buffer,
        0,
        keyBytes,
        isFirst: true,
      );
      check(utf8.decode(buffer.sublist(0, prefixLenFirst))).equals('"x":');

      final prefixLenNotFirst = JsonUtf8Encoder.writePropertyPrefixToBuffer(
        buffer,
        0,
        keyBytes,
        isFirst: false,
      );
      check(utf8.decode(buffer.sublist(0, prefixLenNotFirst))).equals(',"x":');
    });

    // -------------------------------------------------------------------------
    // 4. Streaming Token Reader & Writer (Items 39-41)
    // -------------------------------------------------------------------------
    test('Items 39-41: Streaming Token Reader & Writer', () {
      final sink = BytesBuilder();

      // 41: JsonTokenWriter.toSink
      final writer = JsonTokenWriter.toSink(sink);
      writer.beginObject();
      writer.writeName('id');
      writer.writeInt(101);
      writer.writeName('price');
      writer.writeDouble(19.99);
      writer.writeName('active');
      writer.writeBool(true);
      writer.writeName('comment');
      writer.writeNull();
      writer.endObject();

      final bytes = Uint8List.fromList(sink.takeBytes());

      // 40: JsonTokenReader.fromBytes
      final reader = JsonTokenReader.fromBytes(bytes);
      check(reader.peek()).equals(JsonTokenType.beginObject);
      reader.beginObject();

      final options = JsonKeyOptions.of(['id', 'price', 'active', 'comment']);

      check(reader.hasNext()).isTrue();
      check(reader.selectName(options)).equals(0);
      check(reader.readInt()).equals(101);

      check(reader.hasNext()).isTrue();
      check(reader.selectName(options)).equals(1);
      check(reader.readDouble()).equals(19.99);

      check(reader.hasNext()).isTrue();
      check(reader.selectName(options)).equals(2);
      check(reader.readBool()).equals(true);

      check(reader.hasNext()).isTrue();
      check(reader.selectName(options)).equals(3);
      reader.readNull();

      check(reader.hasNext()).isFalse();
      reader.endObject();
    });

    // -------------------------------------------------------------------------
    // 5. Full End-to-End JsonCodableDriver Integration
    // -------------------------------------------------------------------------
    test('JsonCodableDriver roundtrip with domain model', () {
      final jsonBytes = Uint8List.fromList(
        utf8.encode('{"x":10.5,"y":20.5,"z":30.5}'),
      );

      final decoder = JsonCodableDecoder.fromBytes(jsonBytes);
      final keyed = decoder.keyed();
      double? x, y, z;
      while (keyed.hasNextKey()) {
        final key = keyed.nextKey();
        if (key == 'x') {
          x = keyed.readDouble();
        } else if (key == 'y') {
          y = keyed.readDouble();
        } else if (key == 'z') {
          z = keyed.readDouble();
        }
      }

      check(x).equals(10.5);
      check(y).equals(20.5);
      check(z).equals(30.5);

      final sink = BytesBuilder();
      final encoder = JsonCodableEncoder.toSink(sink);
      final keyedEnc = encoder.keyed();
      keyedEnc.encodeDouble('x', x!);
      keyedEnc.encodeDouble('y', y!);
      keyedEnc.encodeDouble('z', z!);

      check(sink.length).isGreaterThan(0);
    });

    test('Encodable model integration with JsonCodableEncoder', () {
      final point = _TestPoint(12, 34);
      final sink = BytesBuilder();
      final encoder = JsonCodableEncoder.toSink(sink);
      final keyed = encoder.keyed();
      keyed.encodeEncodable('point', point);
      check(sink.length).isGreaterThan(0);
    });
  });
}

class _TestPoint implements Encodable {
  final int x;
  final int y;

  _TestPoint(this.x, this.y);

  @override
  void encode(Encoder encoder) {
    final keyed = encoder.keyed();
    keyed.encodeInt('x', x);
    keyed.encodeInt('y', y);
  }
}
