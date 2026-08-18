// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:codable/codable.dart';
import 'package:codable/src/driver/json_codable_driver.dart';

/// Demonstrates high-throughput, zero-allocation streaming deserialization
/// directly over UTF-8 bytes without intermediate Map DOM allocations.
class CoordinateTelemetry {
  final double lat;
  final double lon;

  const CoordinateTelemetry(this.lat, this.lon);

  static CoordinateTelemetry decode(Decoder decoder) {
    final keyed = decoder.keyed();
    double? lat;
    double? lon;

    while (keyed.hasNextKey()) {
      final key = keyed.nextKey();
      if (key == 'lat') {
        lat = keyed.readDouble();
      } else if (key == 'lon') {
        lon = keyed.readDouble();
      } else {
        keyed.skipValue();
      }
    }

    if (lat == null || lon == null) {
      throw const CodableException('Missing required coordinates');
    }
    return CoordinateTelemetry(lat, lon);
  }
}

void main() {
  // Simulating an incoming binary network payload of 2 coordinates
  final payload = Uint8List.fromList(
    utf8.encode(
      '[{"lat": 37.77, "lon": -122.41}, {"lat": 40.71, "lon": -74.00}]',
    ),
  );

  final decoder = JsonCodableDecoder.fromBytes(payload);
  final unkeyed = decoder.unkeyed();

  final points = <CoordinateTelemetry>[];
  while (unkeyed.hasNext()) {
    points.add(unkeyed.decodeElement(CoordinateTelemetry.decode));
  }

  for (final p in points) {
    print('Coordinate: ${p.lat}, ${p.lon}');
  }
}
