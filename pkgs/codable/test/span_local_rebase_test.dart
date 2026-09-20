import 'dart:convert';
import 'dart:typed_data';

import 'package:codable/src/json/substrate/mock/json_token_reader.dart';
import 'package:codable/src/json/substrate/mock/json_token_type.dart';

void main() {
  final chunks = [
    Uint8List.fromList(utf8.encode('{"name": "Ali')),
    Uint8List.fromList(utf8.encode('ce", "a')),
    Uint8List.fromList(utf8.encode('ge" : 25 }')),
  ];

  final reader = JsonTokenReader.fromChunks(chunks);
  assert(reader.peek() == JsonTokenType.beginObject);
  reader.beginObject();

  assert(reader.hasNext() == true);
  var name = reader.nextName();
  print("Name 1: \$name");
  assert(name == "name");

  var val1 = reader.readString();
  print("Value 1: \$val1");
  assert(val1 == "Alice");

  assert(reader.hasNext() == true);
  var name2 = reader.nextName();
  print("Name 2: \$name2");
  assert(name2 == "age");

  var val2 = reader.readInt();
  print("Value 2: \$val2");
  assert(val2 == 25);

  assert(reader.hasNext() == false);
  reader.endObject();
  print("SUCCESS");
}
