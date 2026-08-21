// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:checks/checks.dart';
import 'package:codable/codable_json.dart';
import 'package:test/test.dart';

import '../example/basic_example.dart';
import '../example/custom_decoder_example.dart';
import '../example/generic_response_example.dart';
import '../example/nested_values_example.dart';
import '../example/polymorphic_example.dart';
import '../example/tuple_example.dart';

void main() {
  group('Example Models Validation Suite', () {
    test('BasicExample: Person and Order roundtrip', () {
      const json = '''
      {
        "firstName": "Alice",
        "lastName": "Smith",
        "date-of-birth": "1995-03-20T00:00:00.000Z",
        "orders": [
          {
            "dateUs": 1700000000000,
            "count": 5,
            "isRushed": true,
            "item": {
              "count": 5,
              "itemNumber": 101,
              "isRushed": true
            }
          }
        ]
      }
      ''';

      final bytes = Uint8List.fromList(utf8.encode(json));
      final decoder = JsonCodableDecoder.fromBytes(bytes);
      final person = Person.decode(decoder);

      check(person.firstName).equals('Alice');
      check(person.lastName).equals('Smith');
      check(person.orders.length).equals(1);
      check(person.orders.first.count).equals(5);
      check(person.orders.first.isRushed).equals(true);
      check(person.orders.first.item?.itemNumber).equals(101);

      final outputBytes = JsonCodableEncoder.toBytes(person.encode);

      final roundtripped = Person.decode(
        JsonCodableDecoder.fromBytes(outputBytes),
      );
      check(roundtripped.firstName).equals('Alice');
      check(roundtripped.lastName).equals('Smith');
      check(roundtripped.orders.length).equals(1);
    });

    test('GenericResponseExample: BaseResponse<Article> decoding', () {
      const json = '''
      {
        "status": 200,
        "message": "OK",
        "data": {
          "id": 42,
          "title": "Dart 4 Zero-Allocation",
          "author": {
            "id": 7,
            "email": "alice@dart.dev"
          }
        }
      }
      ''';

      final bytes = Uint8List.fromList(utf8.encode(json));
      final decoder = JsonCodableDecoder.fromBytes(bytes);
      final response = BaseResponse.decode(decoder, Article.decode);

      check(response.status).equals(200);
      check(response.message).equals('OK');
      check(response.data.id).equals(42);
      check(response.data.title).equals('Dart 4 Zero-Allocation');
      check(response.data.author?.email).equals('alice@dart.dev');
    });

    test('CustomDecoderExample: DateTimeEpochDecoder', () {
      final json1 = Uint8List.fromList(utf8.encode('{"when": 1700000000000}'));
      final ex1 = DateTimeExample.decode(JsonCodableDecoder.fromBytes(json1));
      check(ex1.when)
          .equals(DateTime.fromMillisecondsSinceEpoch(1700000000000));

      final json2 = Uint8List.fromList(
        utf8.encode('{"when": "2026-08-17T12:00:00.000Z"}'),
      );
      final ex2 = DateTimeExample.decode(JsonCodableDecoder.fromBytes(json2));
      check(ex2.when).equals(DateTime.parse('2026-08-17T12:00:00.000Z'));
    });

    test('NestedValuesExample: Direct stream extraction', () {
      const json = '''
      {
        "root_items": {
          "items": [
            {"name": "apple"},
            {"name": "banana"},
            {"name": "cherry"}
          ]
        }
      }
      ''';

      final bytes = Uint8List.fromList(utf8.encode(json));
      final reader = JsonTokenReader.fromBytes(bytes);
      final example = NestedValueExample.fromReader(reader);

      check(example.nestedValues.length).equals(3);
      check(example.nestedValues[0]).equals('apple');
      check(example.nestedValues[1]).equals('banana');
      check(example.nestedValues[2]).equals('cherry');
    });

    test('TupleExample: CoordinatePair decoding', () {
      final json = Uint8List.fromList(
        utf8.encode('{"location": [37.7749, -122.4194]}'),
      );
      final decoder = JsonCodableDecoder.fromBytes(json);
      final pair = CoordinatePair.decode(decoder);

      check(pair.location).isNotNull();
      check(pair.location![0]).equals(37.7749);
      check(pair.location![1]).equals(-122.4194);
    });

    test('PolymorphicExample: Vehicle hierarchy resolution', () {
      const jsonArray = '''
      [
        {"type": "car", "maxSpeed": 120, "doors": 4},
        {"type": "bicycle", "maxSpeed": 25, "hasBell": true}
      ]
      ''';

      final bytes = Uint8List.fromList(utf8.encode(jsonArray));
      final decoder = JsonCodableDecoder.fromBytes(bytes);
      final unkeyed = decoder.unkeyed();

      final vehicles = <Vehicle>[];
      while (unkeyed.hasNext()) {
        vehicles.add(unkeyed.decodeElement(Vehicle.decode));
      }

      check(vehicles.length).equals(2);
      check(vehicles[0]).isA<Car>();
      check((vehicles[0] as Car).doors).equals(4);
      check(vehicles[1]).isA<Bicycle>();
      check((vehicles[1] as Bicycle).hasBell).isTrue();
    });
  });
}
