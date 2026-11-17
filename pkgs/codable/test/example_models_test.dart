// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:typed_data';

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
      final person = const PersonCodable().decode(decoder);

      check(person.firstName).equals('Alice');
      check(person.lastName).equals('Smith');
      check(person.orders.length).equals(1);
      check(person.orders.first.count).equals(5);
      check(person.orders.first.isRushed).equals(true);
      check(person.orders.first.item?.itemNumber).equals(101);

      final outputBytes = JsonCodableEncoder.toBytes(
        person,
        const PersonCodable(),
      );

      final roundtripped = const PersonCodable().decode(
        JsonCodableDecoder.fromBytes(outputBytes),
      );
      check(roundtripped.firstName).equals('Alice');
      check(roundtripped.lastName).equals('Smith');
      check(roundtripped.dateOfBirth)
          .equals(DateTime.parse('1995-03-20T00:00:00.000Z'));
      check(roundtripped.orders.length).equals(1);
      check(roundtripped.orders.first.count).equals(5);
      check(roundtripped.orders.first.isRushed).equals(true);
      check(roundtripped.orders.first.item?.itemNumber).equals(101);
    });

    test('GenericResponseExample: BaseResponse<T> concrete, list, and nullable roundtrips', () {
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

      const codec = BaseResponseCodable<Article>(ArticleCodable());
      final response = JsonCodableDecoder.decode(json, codec);

      check(response.status).equals(200);
      check(response.message).equals('OK');
      check(response.data.id).equals(42);
      check(response.data.title).equals('Dart 4 Zero-Allocation');
      check(response.data.author?.email).equals('alice@dart.dev');

      final encoded = JsonCodableEncoder.encode(response, codec);
      final roundtripped = JsonCodableDecoder.decode(encoded, codec);
      check(roundtripped.status).equals(200);
      check(roundtripped.message).equals('OK');
      check(roundtripped.data.id).equals(42);
      check(roundtripped.data.title).equals('Dart 4 Zero-Allocation');
      check(roundtripped.data.author?.email).equals('alice@dart.dev');

      final listCodec = BaseResponseCodable<List<User>>(
        const UserCodable().list,
      );
      const usersEnv = BaseResponse<List<User>>(
        status: 200,
        message: 'OK',
        data: [
          User(id: 1, email: 'a@b.dev'),
          User(id: 2, email: 'c@d.dev'),
        ],
      );
      final usersRoundtrip = JsonCodableDecoder.decode(
        JsonCodableEncoder.encode(usersEnv, listCodec),
        listCodec,
      );
      check(usersRoundtrip.data.map((u) => u.email))
          .deepEquals(['a@b.dev', 'c@d.dev']);

      final nullableCodec = BaseResponseCodable<Article?>(
        const ArticleCodable().nullable,
      );
      const emptyEnv = BaseResponse<Article?>(
        status: 204,
        message: 'No Content',
        data: null,
      );
      final emptyJson = JsonCodableEncoder.encode(emptyEnv, nullableCodec);
      check(emptyJson).equals('{"status":204,"message":"No Content"}');
      final emptyDecoded = JsonCodableDecoder.decode(emptyJson, nullableCodec);
      check(emptyDecoded.status).equals(204);
      check(emptyDecoded.data).isNull();
    });

    test('CustomDecoderExample: DateTimeEpochDecoder', () {
      final json1 = Uint8List.fromList(utf8.encode('{"when": 1700000000000}'));
      final ex1 = const DateTimeExampleCodable().decode(
        JsonCodableDecoder.fromBytes(json1),
      );
      check(ex1.when)
          .equals(DateTime.fromMillisecondsSinceEpoch(1700000000000));

      final json2 = Uint8List.fromList(
        utf8.encode('{"when": "2026-08-17T12:00:00.000Z"}'),
      );
      final ex2 = const DateTimeExampleCodable().decode(
        JsonCodableDecoder.fromBytes(json2),
      );
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

    test('TupleExample: CoordinatePair decoding and encoding', () {
      final json = Uint8List.fromList(
        utf8.encode('{"location":[37.7749,-122.4194]}'),
      );
      final decoder = JsonCodableDecoder.fromBytes(json);
      final pair = const CoordinatePairCodable().decode(decoder);

      check(pair.location).isNotNull();
      check(pair.location![0]).equals(37.7749);
      check(pair.location![1]).equals(-122.4194);

      final encoded = utf8.decode(
        JsonCodableEncoder.toBytes(pair, const CoordinatePairCodable()),
      );
      check(encoded).equals('{"location":[37.7749,-122.4194]}');
    });

    test('PolymorphicExample: Vehicle hierarchy resolution and roundtrip', () {
      const jsonArray = '''
      [
        {"type": "car", "maxSpeed": 120, "doors": 4},
        {"maxSpeed": 25, "hasBell": true, "type": "bicycle"},
        {"type": "cargo_van", "maxSpeed": 95, "payloadTons": 3.5}
      ]
      ''';

      final vehicles = JsonCodableDecoder.decode(
        jsonArray,
        const VehicleCodable().list,
      );

      check(vehicles.length).equals(3);
      check(vehicles[0])
          .isA<Car>()
          .has((c) => (c.maxSpeed, c.doors), 'car')
          .equals((120, 4));
      check(vehicles[1])
          .isA<Bicycle>()
          .has((b) => (b.maxSpeed, b.hasBell), 'bicycle')
          .equals((25, true));
      check(vehicles[2])
          .isA<CargoVan>()
          .has((v) => (v.maxSpeed, v.payloadTons), 'van')
          .equals((95, 3.5));

      final roundtrippedJson = JsonCodableEncoder.encode(
        vehicles,
        const VehicleCodable().list,
      );
      check(roundtrippedJson).contains('"type":"cargo_van"');
      final roundtripped = JsonCodableDecoder.decode(
        roundtrippedJson,
        const VehicleCodable().list,
      );
      check(roundtripped.length).equals(3);
      check(roundtripped[2])
          .isA<CargoVan>()
          .has((v) => v.payloadTons, 'payloadTons')
          .equals(3.5);
    });
  });
}
