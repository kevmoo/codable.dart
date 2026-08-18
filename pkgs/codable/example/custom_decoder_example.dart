// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:codable/codable.dart';

part 'custom_decoder_example.g.dart';

/// Custom field decoder normalizing timestamp representations (integer epoch
/// milliseconds or ISO 8601 strings) into a standard [DateTime].
final class DateTimeEpochDecoder {
  const DateTimeEpochDecoder();

  DateTime decodeFromReader(JsonTokenReader reader) {
    final token = reader.peek();
    if (token == JsonTokenType.number) {
      return DateTime.fromMillisecondsSinceEpoch(reader.readInt());
    }
    return DateTime.parse(reader.readString());
  }

  void encodeToWriter(DateTime value, JsonTokenWriter writer) {
    writer.writeInt(value.millisecondsSinceEpoch);
  }
}

@Codable()
class DateTimeExample {
  @CodableKey(customDecoder: DateTimeEpochDecoder())
  final DateTime when;

  const DateTimeExample(this.when);

  static DateTimeExample fromReader(JsonTokenReader reader) =>
      _$DateTimeExampleFromReader(reader);
  void toWriter(JsonTokenWriter writer) =>
      _$DateTimeExampleToWriter(this, writer);
}

void main() {
  // Parsing integer epoch timestamp
  final json1 = Uint8List.fromList(utf8.encode('{"when": 1700000000000}'));
  final ex1 = DateTimeExample.fromReader(JsonTokenReader.fromBytes(json1));
  print('Epoch timestamp: ${ex1.when}');

  // Parsing ISO 8601 string timestamp
  final json2 = Uint8List.fromList(
    utf8.encode('{"when": "2026-08-17T12:00:00.000Z"}'),
  );
  final ex2 = DateTimeExample.fromReader(JsonTokenReader.fromBytes(json2));
  print('ISO timestamp: ${ex2.when}');

  final builder = BytesBuilder();
  final writer = JsonTokenWriter.toSink(builder);
  ex1.toWriter(writer);
  print('Serialized: ${utf8.decode(builder.toBytes())}');
}
