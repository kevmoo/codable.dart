// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// ignore_for_file: unreachable_from_main

import 'dart:convert';

import 'package:codable/codable_json.dart';

part 'basic_example.g.dart';

final class DateTimeIsoDecoder {
  const DateTimeIsoDecoder();

  DateTime decode(Decoder decoder) =>
      DateTime.parse(decoder.singleValue().readString());

  void encodeToEncoder(DateTime value, Encoder encoder) =>
      encoder.singleValue().encodeString(value.toIso8601String());
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

  static Person decode(Decoder decoder) => _$PersonFromDecoder(decoder);
  void encode(Encoder encoder) => _$PersonToEncoder(this, encoder);
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

  static Order decode(Decoder decoder) => _$OrderFromDecoder(decoder);
  void encode(Encoder encoder) => _$OrderToEncoder(this, encoder);
}

@Codable()
class Item {
  final int? count;
  final int? itemNumber;
  final bool? isRushed;

  const Item({this.count, this.itemNumber, this.isRushed});

  static Item decode(Decoder decoder) => _$ItemFromDecoder(decoder);
  void encode(Encoder encoder) => _$ItemToEncoder(this, encoder);
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
  final decoder = JsonCodableDecoder.fromBytes(bytes);
  final person = Person.decode(decoder);

  print(
    'Decoded Person: ${person.firstName} ${person.lastName}, '
    'orders: ${person.orders.length}',
  );

  final outBytes = JsonCodableEncoder.toBytes(person.encode);
  print('Encoded JSON: ${utf8.decode(outBytes)}');
}
