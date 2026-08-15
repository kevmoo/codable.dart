// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:checks/checks.dart';
import 'package:codable/codable.dart';
import 'package:codable/src/driver/json_codable_driver.dart';
import 'package:test/test.dart';

import '../example/mock_codegen/canada.dart';
import '../example/mock_codegen/citm_catalog.dart';
import '../example/mock_codegen/coordinate.dart';

void main() {
  group('Example Models Serialization & Deserialization Suite', () {
    group('Coordinate (example/mock_codegen)', () {
      test('decodes and encodes with JsonCodableDriver', () {
        final jsonBytes = Uint8List.fromList(
          utf8.encode('{"latitude": 37.7749, "longitude": -122.4194}'),
        );
        final decoder = JsonCodableDecoder.fromBytes(jsonBytes);
        final coord = Coordinate.decode(decoder);

        check(coord.latitude).equals(37.7749);
        check(coord.longitude).equals(-122.4194);

        final sink = BytesBuilder();
        final writer = JsonTokenWriter.toSink(sink);
        coord.toWriter(writer);
        final reDecoded = Coordinate.fromReader(
          JsonTokenReader.fromBytes(sink.toBytes()),
        );

        check(reDecoded.latitude).equals(37.7749);
        check(reDecoded.longitude).equals(-122.4194);
      });

      test('supports key aliases "lat" and "lon"', () {
        final jsonBytes = Uint8List.fromList(
          utf8.encode('{"lat": 51.5074, "lon": -0.1278}'),
        );
        final coord = Coordinate.fromReader(
          JsonTokenReader.fromBytes(jsonBytes),
        );
        check(coord.latitude).equals(51.5074);
        check(coord.longitude).equals(-0.1278);
      });
    });

    group('Canada GeoJSON Models (example/mock_codegen)', () {
      test(
        'roundtrips CanadaFeatureCollection via streaming token reader/writer',
        () {
          const jsonStr = '''
{
  "type": "FeatureCollection",
  "features": [
    {
      "type": "Feature",
      "properties": {
        "name": "Canada"
      },
      "geometry": {
        "type": "Polygon",
        "coordinates": [
          [
            [-65.613617, 43.420273],
            [-65.61972, 43.428055]
          ]
        ]
      }
    }
  ]
}''';
          final bytes = Uint8List.fromList(utf8.encode(jsonStr));
          final collection = CanadaFeatureCollection.fromReader(
            JsonTokenReader.fromBytes(bytes),
          );

          check(collection.type).equals('FeatureCollection');
          check(collection.features.length).equals(1);

          final feature = collection.features.first;
          check(feature.type).equals('Feature');
          check(feature.properties.name).equals('Canada');
          check(feature.geometry.type).equals('Polygon');
          check(feature.geometry.coordinates.length).equals(1);
          check(feature.geometry.coordinates[0].length).equals(2);
          check(feature.geometry.coordinates[0][0][0]).equals(-65.613617);
          check(feature.geometry.coordinates[0][0][1]).equals(43.420273);

          final sink = BytesBuilder();
          final writer = JsonTokenWriter.toSink(sink);
          collection.toWriter(writer);
          final reDecoded = CanadaFeatureCollection.fromReader(
            JsonTokenReader.fromBytes(sink.toBytes()),
          );

          check(reDecoded.type).equals('FeatureCollection');
          check(reDecoded.features.length).equals(1);
          check(reDecoded.features[0].properties.name).equals('Canada');
        },
      );

      test(
        'decodes CanadaGeometry with custom Float64List coordinate matrix',
        () {
          const jsonStr = '''
{
  "type": "Polygon",
  "coordinates": [
    [
      [10.0, 20.0],
      [30.0, 40.0]
    ]
  ]
}''';
          final bytes = Uint8List.fromList(utf8.encode(jsonStr));
          final geom = CanadaGeometry.fromReader(
            JsonTokenReader.fromBytes(bytes),
          );

          check(geom.type).equals('Polygon');
          check(geom.coordinates.length).equals(1);
          check(geom.coordinates[0][0][0]).equals(10.0);
          check(geom.coordinates[0][0][1]).equals(20.0);
          check(geom.coordinates[0][1][0]).equals(30.0);
          check(geom.coordinates[0][1][1]).equals(40.0);
        },
      );
    });

    group('CitmCatalog Models (example/mock_codegen)', () {
      test(
        'decodes and encodes CitmCatalog with all nested relational maps and lists',
        () {
          const jsonStr = '''
{
  "areaNames": {"1": "Orchestra", "2": "Balcony"},
  "audienceSubCategoryNames": {"10": "Adult", "20": "Child"},
  "blockNames": {"100": "Section A"},
  "events": {
    "evt_1": {
      "id": 1,
      "name": "Opera Night",
      "subTopicIds": [1, 2],
      "topicIds": [10, 20]
    }
  },
  "performances": [
    {
      "eventId": 1,
      "id": 501,
      "start": 1600000000,
      "venueCode": "HALL_1",
      "prices": [
        {"amount": 7500, "audienceSubCategoryId": 10, "seatCategoryId": 1}
      ],
      "seatCategories": [
        {
          "seatCategoryId": 1,
          "areas": [
            {"areaId": 1, "blockIds": [100, 101]}
          ]
        }
      ]
    }
  ],
  "seatCategoryNames": {"1": "VIP"},
  "subTopicNames": {"1": "Classical"},
  "subjectNames": {"1": "Music"},
  "topicNames": {"10": "Concert"},
  "topicSynced": {"10": true},
  "venueNames": {"HALL_1": "Royal Albert Hall"}
}''';
          final bytes = Uint8List.fromList(utf8.encode(jsonStr));
          final catalog = CitmCatalog.fromReader(
            JsonTokenReader.fromBytes(bytes),
          );

          check(catalog.areaNames['1']).equals('Orchestra');
          check(catalog.audienceSubCategoryNames['10']).equals('Adult');
          check(catalog.blockNames['100']).equals('Section A');
          check(catalog.events['evt_1']?.name).equals('Opera Night');
          check(catalog.events['evt_1']!.subTopicIds).deepEquals([1, 2]);
          check(catalog.performances.length).equals(1);
          check(catalog.performances[0].venueCode).equals('HALL_1');
          check(catalog.performances[0].prices.length).equals(1);
          check(catalog.performances[0].prices[0].amount).equals(7500);
          check(catalog.performances[0].seatCategories.length).equals(1);
          check(
            catalog.performances[0].seatCategories[0].areas.length,
          ).equals(1);
          check(
            catalog.performances[0].seatCategories[0].areas[0].blockIds,
          ).deepEquals([100, 101]);
          check(catalog.topicSynced['10']).equals(true);

          final sink = BytesBuilder();
          final writer = JsonTokenWriter.toSink(sink);
          catalog.toWriter(writer);
          final reDecoded = CitmCatalog.fromReader(
            JsonTokenReader.fromBytes(sink.toBytes()),
          );

          check(reDecoded.events['evt_1']?.name).equals('Opera Night');
          check(reDecoded.performances[0].venueCode).equals('HALL_1');
        },
      );

      test(
        'CitmArea, CitmPrice, CitmSeatCategory, CitmPerformance, CitmEvent decode',
        () {
          final areaBytes = Uint8List.fromList(
            utf8.encode('{"areaId": 42, "blockIds": [1, 2, 3]}'),
          );
          final area = CitmArea.decode(JsonCodableDecoder.fromBytes(areaBytes));
          check(area.areaId).equals(42);
          check(area.blockIds).deepEquals([1, 2, 3]);

          final priceBytes = Uint8List.fromList(
            utf8.encode(
              '{"amount": 5000, "audienceSubCategoryId": 2, "seatCategoryId": 1}',
            ),
          );
          final price = CitmPrice.decode(
            JsonCodableDecoder.fromBytes(priceBytes),
          );
          check(price.amount).equals(5000);
          check(price.audienceSubCategoryId).equals(2);
          check(price.seatCategoryId).equals(1);
        },
      );
    });
  });
}
