// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:codable/codable.dart';
import 'package:codable/src/driver/json_codable_driver.dart';

part 'basic_example.g.dart';

final class DateTimeIsoDecoder {
  const DateTimeIsoDecoder();

  DateTime decodeFromReader(JsonTokenReader reader) =>
      DateTime.parse(reader.readString());

  void encodeToWriter(DateTime value, JsonTokenWriter writer) =>
      writer.writeString(value.toIso8601String());
}

/// Standard model demonstrating primary constructors, custom wire keys,
/// key aliasing, and nested object collections.
@Codable()
class Person {
  final String firstName;
  final String? middleName;
  final String lastName;

  @CodableKey(
    name: 'date-of-birth',
    aliases: ['dob'],
    customDecoder: DateTimeIsoDecoder(),
  )
  final DateTime dateOfBirth;

  @CodableKey(name: 'last-order', customDecoder: DateTimeIsoDecoder())
  final DateTime? lastOrder;

  final List<Order> orders;

  const Person({
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    this.middleName,
    this.lastOrder,
    this.orders = const [],
  });

  static Person fromReader(JsonTokenReader reader) =>
      _$PersonFromReader(reader);
  void toWriter(JsonTokenWriter writer) => _$PersonToWriter(this, writer);

  static Person decode(Decoder decoder) {
    if (decoder is JsonCodableDecoder) return fromReader(decoder.reader);
    throw UnimplementedError();
  }

  void encode(Encoder encoder) {
    if (encoder is JsonCodableEncoder) {
      toWriter(encoder.writer);
      return;
    }
    throw UnimplementedError();
  }
}

@Codable()
class Order {
  final int? count;
  final int? itemNumber;
  final bool? isRushed;
  final Item? item;
  final int? prepTimeMs;
  final int dateUs;

  const Order({
    required this.dateUs,
    this.count,
    this.itemNumber,
    this.isRushed,
    this.item,
    this.prepTimeMs,
  });

  static Order fromReader(JsonTokenReader reader) => _$OrderFromReader(reader);
  void toWriter(JsonTokenWriter writer) => _$OrderToWriter(this, writer);
}

@Codable()
class Item {
  final int? count;
  final int? itemNumber;
  final bool? isRushed;

  const Item({this.count, this.itemNumber, this.isRushed});

  static Item fromReader(JsonTokenReader reader) => _$ItemFromReader(reader);
  void toWriter(JsonTokenWriter writer) => _$ItemToWriter(this, writer);
}

void main() {
  const json = '''
  {
    "firstName": "Bob",
    "lastName": "Smith",
    "dob": "1990-05-15T00:00:00.000Z",
    "orders": [
      {
        "dateUs": 1700000000000,
        "count": 2,
        "item": {
          "count": 2,
          "itemNumber": 42
        }
      }
    ]
  }
  ''';

  final bytes = Uint8List.fromList(utf8.encode(json));
  final reader = JsonTokenReader.fromBytes(bytes);
  final person = Person.fromReader(reader);

  print(
    'Decoded Person: \${person.firstName} \${person.lastName}, orders: \${person.orders.length}',
  );

  final builder = BytesBuilder();
  final writer = JsonTokenWriter.toSink(builder);
  person.toWriter(writer);
  print('Encoded JSON: \${utf8.decode(builder.toBytes())}');
}
