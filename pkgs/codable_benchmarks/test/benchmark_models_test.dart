// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:checks/checks.dart';
import 'package:codable/codable.dart';
import 'package:codable/src/driver/json_codable_driver.dart';
import 'package:test/test.dart';

import '../benchmark/models/canada.dart';
import '../benchmark/models/citm_catalog.dart';
import '../benchmark/models/coordinate.dart';

File _findDataFile(String relativePath) {
  final candidate1 = File(relativePath);
  if (candidate1.existsSync()) return candidate1;
  final candidate2 = File('pkgs/codable_benchmarks/$relativePath');
  if (candidate2.existsSync()) return candidate2;
  final scriptDir = File.fromUri(Platform.script).parent;
  final candidate3 = File('${scriptDir.path}/../$relativePath');
  if (candidate3.existsSync()) return candidate3;
  throw StateError('Data file not found: "$relativePath"');
}

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
    });

    group('canada.json real dataset parsing', () {
      test('deserializes entire canada.json and validates polygons', () {
        final file = _findDataFile('benchmark/data/canada.json');
        final bytes = file.readAsBytesSync();
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
          final file = _findDataFile('benchmark/data/citm_catalog.json');
          final bytes = file.readAsBytesSync();
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
