// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:codable/codable.dart';
import 'package:codable/src/driver/json_codable_driver.dart';

part 'coordinate.g.dart';

/// Generated Coordinate model with @Codable and key aliasing.
@Codable()
class Coordinate {
  @CodableKey(aliases: ['lat'])
  final double latitude;

  @CodableKey(aliases: ['lon'])
  final double longitude;

  const Coordinate({required this.latitude, required this.longitude});

  static Coordinate fromReader(JsonTokenReader reader) =>
      _$CoordinateFromReader(reader);
  void toWriter(JsonTokenWriter writer) => _$CoordinateToWriter(this, writer);

  static Coordinate decodeFromReader(JsonTokenReader reader) =>
      _$CoordinateFromReader(reader);
  void encodeToWriter(JsonTokenWriter writer) =>
      _$CoordinateToWriter(this, writer);

  static Coordinate decode(Decoder decoder) {
    if (decoder is JsonCodableDecoder) {
      return _$CoordinateFromReader(decoder.reader);
    }
    final keyed = decoder.keyed();
    double? lat;
    double? lon;

    while (keyed.hasNextKey()) {
      switch (keyed.selectKeyIndex(
        KeyOptions(['latitude', 'longitude', 'lat', 'lon']),
      )) {
        case 0:
        case 2:
          lat = keyed.readDouble();
          break;
        case 1:
        case 3:
          lon = keyed.readDouble();
          break;
        default:
          keyed.skipValue();
          break;
      }
    }

    if (lat == null || lon == null) {
      throw const CodableException('Missing required fields for Coordinate');
    }
    return Coordinate(latitude: lat, longitude: lon);
  }

  void encode(Encoder encoder) {
    final keyed = encoder.keyed();
    keyed.encodeDouble('latitude', latitude);
    keyed.encodeDouble('longitude', longitude);
  }

  @override
  int get hashCode => Object.hash(latitude, longitude);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Coordinate &&
          latitude == other.latitude &&
          longitude == other.longitude;
}
