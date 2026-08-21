// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:codable/codable_json.dart';

part 'custom_decoder_example.g.dart';

/// Custom field decoder normalizing timestamp representations (integer epoch
/// milliseconds or ISO 8601 strings) into a standard [DateTime].
final class DateTimeEpochDecoder {
  const DateTimeEpochDecoder();

  DateTime decode(Decoder decoder) {
    if (decoder is JsonCodableDecoder) {
      final token = decoder.reader.peek();
      if (token == JsonTokenType.number) {
        return DateTime.fromMillisecondsSinceEpoch(decoder.reader.readInt());
      }
      return DateTime.parse(decoder.reader.readString());
    }
    final sv = decoder.singleValue();
    final str = sv.readString();
    final asInt = int.tryParse(str);
    if (asInt != null) {
      return DateTime.fromMillisecondsSinceEpoch(asInt);
    }
    return DateTime.parse(str);
  }

  void encodeToEncoder(DateTime value, Encoder encoder) {
    encoder.singleValue().encodeInt(value.millisecondsSinceEpoch);
  }
}

@Codable()
class DateTimeExample {
  @CodableKey(customDecoder: DateTimeEpochDecoder())
  final DateTime when;

  const DateTimeExample(this.when);

  static DateTimeExample decode(Decoder decoder) =>
      _$DateTimeExampleFromDecoder(decoder);
  void encode(Encoder encoder) => _$DateTimeExampleToEncoder(this, encoder);
}

void main() {
  // Parsing integer epoch timestamp
  final json1 = Uint8List.fromList(utf8.encode('{"when": 1700000000000}'));
  final ex1 = DateTimeExample.decode(JsonCodableDecoder.fromBytes(json1));
  print('Epoch timestamp: ${ex1.when}');

  // Parsing ISO 8601 string timestamp
  final json2 = Uint8List.fromList(
    utf8.encode('{"when": "2026-08-17T12:00:00.000Z"}'),
  );
  final ex2 = DateTimeExample.decode(JsonCodableDecoder.fromBytes(json2));
  print('ISO timestamp: ${ex2.when}');

  final outBytes = JsonCodableEncoder.toBytes(ex1.encode);
  print('Serialized: ${utf8.decode(outBytes)}');
}
