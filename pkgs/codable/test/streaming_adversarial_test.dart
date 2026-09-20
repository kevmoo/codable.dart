import 'dart:convert';
import 'dart:typed_data';

import 'package:codable/src/json/substrate/mock/json_token_reader.dart';
import 'package:codable/src/json/substrate/mock/json_token_type.dart';

void _expect(dynamic actual, dynamic expected) {
  if (actual != expected) {
    print('FAILED');
    print('ACTUAL: $actual');
    print('EXPECTED: $expected');
    throw StateError('Mismatch');
  }
}

void testSingleByteChunks() {
  final payload =
      '{"key": "value\\n\\uD83D\\uDE80", "num": -123.456, "b": true, "n": null}';
  final encoded = utf8.encode(payload);
  final chunks = <Uint8List>[
    for (int i = 0; i < encoded.length; i++) Uint8List.fromList([encoded[i]]),
  ];

  final reader = JsonTokenReader.fromChunks(chunks);

  _expect(reader.peek(), JsonTokenType.beginObject);
  reader.beginObject();

  _expect(reader.hasNext(), true);
  _expect(reader.nextName(), 'key');
  _expect(reader.readString(), 'value\n🚀');

  _expect(reader.hasNext(), true);
  _expect(reader.nextName(), 'num');
  _expect(reader.readDouble(), -123.456);

  _expect(reader.hasNext(), true);
  _expect(reader.nextName(), 'b');
  _expect(reader.readBool(), true);

  _expect(reader.hasNext(), true);
  _expect(reader.nextName(), 'n');
  reader.readNull();

  _expect(reader.hasNext(), false);
  reader.endObject();
}

void testSplitNumber() {
  final chunks = [
    Uint8List.fromList(utf8.encode('[ -1')),
    Uint8List.fromList(utf8.encode('23.4')),
    Uint8List.fromList(utf8.encode('56 ]')),
  ];
  final reader = JsonTokenReader.fromChunks(chunks);
  reader.beginArray();
  _expect(reader.readDouble(), -123.456);
  reader.endArray();
}

void testSplitEscape() {
  // The JSON string is: ["a\nb"]
  // We split it specifically on the escape sequence \n
  final chunks = [
    Uint8List.fromList(utf8.encode('["a\\')), // ends with a single backslash
    Uint8List.fromList(utf8.encode('nb"]')), // starts with n
  ];
  final reader = JsonTokenReader.fromChunks(chunks);
  reader.beginArray();
  _expect(reader.readString(), 'a\nb');
  reader.endArray();
}

void testSplitUTF8() {
  // The JSON string is: ["🚀"]
  // A rocket is 4 bytes in utf-8: F0 9F 9A 80
  final chunks = [
    Uint8List.fromList([
      91, // [
      34, // "
      0xF0, 0x9F, // first two bytes of rocket
    ]),
    Uint8List.fromList([
      0x9A, 0x80, // last two bytes of rocket
      34, // "
      93, // ]
    ]),
  ];
  final reader = JsonTokenReader.fromChunks(chunks);
  reader.beginArray();
  _expect(reader.readString(), '🚀');
  reader.endArray();
}

void main() {
  testSplitNumber();
  testSplitEscape();
  testSplitUTF8();
  testSingleByteChunks();
  print('Adversarial tests PASSED!');
}
