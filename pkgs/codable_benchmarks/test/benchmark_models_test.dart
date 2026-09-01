// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:checks/checks.dart';
import 'package:codable/codable_json.dart';
import 'package:codable_benchmarks/src/data/embedded_datasets.dart';
import 'package:codable_benchmarks/src/models/codable/canada.dart';
import 'package:codable_benchmarks/src/models/codable/citm_catalog.dart';
import 'package:codable_benchmarks/src/models/codable/coordinate.dart';
import 'package:test/test.dart';

void main() {
  group('Benchmark Models Verification Suite', () {
    group('Coordinate (benchmark/models)', () {
      test('decodes coordinates streaming array with 100 items', () {
        final list = List.generate(
          100,
          (i) => '{"lat": ${30.0 + i * 0.1}, "lon": ${-120.0 + i * 0.1}}',
        ).join(',');
        final jsonStr = '[$list]';
        final bytes = Uint8List.fromList(utf8.encode(jsonStr));

        final decoder = JsonCodableDecoder.fromBytes(bytes);
        final unkeyed = decoder.unkeyed();
        final coordinates = <Coordinate>[];
        while (unkeyed.hasNext()) {
          coordinates.add(Coordinate.decode(decoder));
        }

        check(coordinates.length).equals(100);
        check(coordinates.first.latitude).equals(30.0);
        check(coordinates.first.longitude).equals(-120.0);
        check(coordinates.last.latitude).equals(39.9);
      });

      test('decodes coordinates array using Coordinate.decodeList', () {
        final list = List.generate(
          100,
          (i) =>
              '{"latitude": ${40.0 + i * 0.1}, '
              '"longitude": ${-70.0 + i * 0.1}}',
        ).join(',');
        final jsonStr = '[$list]';
        final bytes = Uint8List.fromList(utf8.encode(jsonStr));

        final decoder = JsonCodableDecoder.fromBytes(bytes);
        final coordinates = Coordinate.decodeList(decoder);

        check(coordinates.length).equals(100);
        check(coordinates.first.latitude).equals(40.0);
        check(coordinates.first.longitude).equals(-70.0);
        check(coordinates.last.latitude).equals(49.9);
      });
    });

    group('canada.json real dataset parsing', () {
      test('deserializes entire canada.json and validates polygons', () {
        final bytes = getDatasetBytes('canada');
        final decoder = JsonCodableDecoder.fromBytes(bytes);
        final fc = CanadaFeatureCollection.decode(decoder);

        check(fc.type).equals('FeatureCollection');
        check(fc.features).isNotEmpty();
        final firstFeature = fc.features.first;
        check(firstFeature.type).equals('Feature');
        check(firstFeature.properties.name).equals('Canada');
        check(firstFeature.geometry.type).equals('Polygon');
        check(firstFeature.geometry.coordinates).isNotEmpty();
      });
    });

    group('citm_catalog.json real dataset parsing', () {
      test(
        'deserializes entire citm_catalog.json and validates relational maps',
        () {
          final bytes = getDatasetBytes('citm_catalog');
          final decoder = JsonCodableDecoder.fromBytes(bytes);
          final catalog = CitmCatalog.decode(decoder);

          check(catalog.events).isNotEmpty();
          check(catalog.performances).isNotEmpty();
          check(catalog.areaNames).isNotEmpty();
          check(catalog.seatCategoryNames).isNotEmpty();
        },
      );
    });
  });
}
