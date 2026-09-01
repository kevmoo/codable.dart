// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:checks/checks.dart';
import 'package:codable/codable_json.dart';
import 'package:codable_benchmarks/src/data/embedded_datasets.dart';
import 'package:codable_benchmarks/src/models/codable/canada.dart' as c_can;
import 'package:codable_benchmarks/src/models/codable/citm_catalog.dart'
    as c_citm;
import 'package:codable_benchmarks/src/models/codable/coordinate.dart'
    as c_coord;
import 'package:codable_benchmarks/src/models/codable/small.dart' as c_small;
import 'package:codable_benchmarks/src/models/codable/twitter.dart' as c_twit;
import 'package:codable_benchmarks/src/models/json_serializable/canada.dart'
    as js_can;
import 'package:codable_benchmarks/src/models/json_serializable/citm_catalog.dart'
    as js_citm;
import 'package:codable_benchmarks/src/models/json_serializable/coordinate.dart'
    as js_coord;
import 'package:codable_benchmarks/src/models/json_serializable/small.dart'
    as js_small;
import 'package:codable_benchmarks/src/models/json_serializable/twitter.dart'
    as js_twit;
import 'package:test/test.dart';

void main() {
  group('Model Parity Suite (Codable vs json_serializable)', () {
    test('Coordinate parity on synthetic point', () {
      final jsonMap = {'lat': 34.05, 'lon': -118.25};
      final jsonBytes = utf8.encode(
        '{"latitude": 34.05, "longitude": -118.25}',
      );

      final jsObj = js_coord.Coordinate.fromJson(jsonMap);
      final cDecoder = JsonCodableDecoder.fromBytes(
        Uint8List.fromList(jsonBytes),
      );
      final cObj = c_coord.Coordinate.decode(cDecoder);

      check(cObj.latitude).equals(jsObj.latitude);
      check(cObj.longitude).equals(jsObj.longitude);
    });

    test('canada.json parity', () {
      final bytes = getDatasetBytes('canada');
      final stringSource = utf8.decode(bytes);

      final jsMap = jsonDecode(stringSource) as Map<String, dynamic>;
      final jsObj = js_can.CanadaFeatureCollection.fromJson(jsMap);

      final cDecoder = JsonCodableDecoder.fromBytes(bytes);
      final cObj = c_can.CanadaFeatureCollection.decode(cDecoder);

      check(cObj.type).equals(jsObj.type);
      check(cObj.features.length).equals(jsObj.features.length);
      check(cObj.features.first.geometry.coordinates.length)
          .equals(jsObj.features.first.geometry.coordinates.length);
    });

    test('citm_catalog.json parity', () {
      final bytes = getDatasetBytes('citm_catalog');
      final stringSource = utf8.decode(bytes);

      final jsMap = jsonDecode(stringSource) as Map<String, dynamic>;
      final jsObj = js_citm.CitmCatalog.fromJson(jsMap);

      final cDecoder = JsonCodableDecoder.fromBytes(bytes);
      final cObj = c_citm.CitmCatalog.decode(cDecoder);

      check(cObj.areaNames.length).equals(jsObj.areaNames.length);
      check(cObj.events.length).equals(jsObj.events.length);
      check(cObj.performances.length).equals(jsObj.performances.length);
      check(cObj.venueNames.length).equals(jsObj.venueNames.length);
    });

    test('small.json parity', () {
      final bytes = getDatasetBytes('small');
      final stringSource = utf8.decode(bytes);

      final jsMap = jsonDecode(stringSource) as Map<String, dynamic>;
      final jsObj = js_small.SmallDocument.fromJson(jsMap);

      final cDecoder = JsonCodableDecoder.fromBytes(bytes);
      final cObj = c_small.SmallDocument.decode(cDecoder);

      check(cObj.name).equals(jsObj.name);
      check(cObj.email).equals(jsObj.email);
      check(cObj.roles.length).equals(jsObj.roles.length);
      check(cObj.metadata.location.city).equals(jsObj.metadata.location.city);
    });

    test('twitter.json parity', () {
      final bytes = getDatasetBytes('twitter');
      final stringSource = utf8.decode(bytes);

      final jsMap = jsonDecode(stringSource) as Map<String, dynamic>;
      final jsObj = js_twit.TwitterResponse.fromJson(jsMap);

      final cDecoder = JsonCodableDecoder.fromBytes(bytes);
      final cObj = c_twit.TwitterResponse.decode(cDecoder);

      check(cObj.statuses.length).equals(jsObj.statuses.length);
      check(cObj.searchMetadata.count).equals(jsObj.searchMetadata.count);
      check(cObj.statuses.first.id).equals(jsObj.statuses.first.id);
      check(cObj.statuses.first.user?.screenName)
          .equals(jsObj.statuses.first.user?.screenName);
    });
  });
}
