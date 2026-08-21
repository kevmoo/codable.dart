// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:codable/codable.dart';

part 'canada.g.dart';

final class CanadaCoordinatesDecoder {
  const CanadaCoordinatesDecoder();

  List<List<Float64List>> decode(Decoder decoder) {
    final unkeyed = decoder.unkeyed();
    final coords = <List<Float64List>>[];
    while (unkeyed.hasNext()) {
      final poly = <Float64List>[];
      final u1 = unkeyed.decodeElement((d1) => d1.unkeyed());
      while (u1.hasNext()) {
        poly.add(u1.decodeFloat64List());
      }
      coords.add(poly);
    }
    return coords;
  }

  void encodeToEncoder(List<List<Float64List>> coordinates, Encoder encoder) {
    final unkeyed = encoder.unkeyed();
    for (final poly in coordinates) {
      unkeyed.encodeElement(poly, (polyList, e1) {
        final u1 = e1.unkeyed();
        for (final ring in polyList) {
          u1.encodeElement(ring, (point, e2) {
            final u2 = e2.unkeyed();
            u2.encodeDouble(point[0]);
            u2.encodeDouble(point[1]);
          });
        }
      });
    }
  }
}

@Codable()
class CanadaProperties {
  final String name;

  const CanadaProperties({required this.name});

  static CanadaProperties decode(Decoder decoder) =>
      _$CanadaPropertiesFromDecoder(decoder);
  void encode(Encoder encoder) => _$CanadaPropertiesToEncoder(this, encoder);
}

@Codable()
class CanadaGeometry {
  final String type;
  @CodableKey(customDecoder: CanadaCoordinatesDecoder())
  final List<List<Float64List>> coordinates;

  const CanadaGeometry({required this.type, this.coordinates = const []});

  static CanadaGeometry decode(Decoder decoder) =>
      _$CanadaGeometryFromDecoder(decoder);
  void encode(Encoder encoder) => _$CanadaGeometryToEncoder(this, encoder);
}

@Codable()
class CanadaFeature {
  final String type;
  final CanadaProperties properties;
  final CanadaGeometry geometry;

  const CanadaFeature({
    required this.type,
    required this.properties,
    required this.geometry,
  });

  static CanadaFeature decode(Decoder decoder) =>
      _$CanadaFeatureFromDecoder(decoder);
  void encode(Encoder encoder) => _$CanadaFeatureToEncoder(this, encoder);
}

@Codable()
class CanadaFeatureCollection {
  final String type;
  final List<CanadaFeature> features;

  const CanadaFeatureCollection({required this.type, this.features = const []});

  static CanadaFeatureCollection decode(Decoder decoder) =>
      _$CanadaFeatureCollectionFromDecoder(decoder);
  void encode(Encoder encoder) =>
      _$CanadaFeatureCollectionToEncoder(this, encoder);
}
