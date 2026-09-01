// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:codable/codable.dart';

part 'canada.g.dart';

final class CanadaCoordinatesDecoder {
  const CanadaCoordinatesDecoder();

  List<List<List<double>>> decode(Decoder decoder) {
    final unkeyed = decoder.unkeyed();
    final coords = <List<List<double>>>[];
    while (unkeyed.hasNext()) {
      final poly = <List<double>>[];
      final u1 = unkeyed.decodeElement((d1) => d1.unkeyed());
      while (u1.hasNext()) {
        poly.add(u1.decodeDoubleList());
      }
      coords.add(poly);
    }
    return coords;
  }

  void encodeToEncoder(List<List<List<double>>> coordinates, Encoder encoder) {
    final unkeyed = encoder.unkeyed();
    for (final poly in coordinates) {
      unkeyed.encodeElement(poly, (polyList, e1) {
        final u1 = e1.unkeyed();
        for (final ring in polyList) {
          u1.encodeElement(ring, (ringList, e2) {
            final u2 = e2.unkeyed();
            for (final pt in ringList) {
              u2.encodeDouble(pt);
            }
          });
        }
      });
    }
  }
}

@Codable()
class CanadaProperties {
  final String name;

  const CanadaProperties({this.name = ''});

  static CanadaProperties decode(Decoder decoder) =>
      _$CanadaPropertiesFromDecoder(decoder);
  void encode(Encoder encoder) => _$CanadaPropertiesToEncoder(this, encoder);
}

@Codable()
class CanadaGeometry {
  final String type;
  @CodableKey(customDecoder: CanadaCoordinatesDecoder())
  final List<List<List<double>>> coordinates;

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
