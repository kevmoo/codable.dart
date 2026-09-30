// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:codable/codable.dart';

part 'canada.g.dart';

final class CanadaCoordinatesDecoder
    implements Codable<List<List<Float64List>>> {
  const CanadaCoordinatesDecoder();

  @override
  List<List<Float64List>> decode(Decoder decoder) {
    final unkeyed = decoder.unkeyed();
    final coords = <List<Float64List>>[];
    while (unkeyed.moveNext()) {
      final poly = <Float64List>[];
      final u1 = unkeyed.decodeElement(
        Decodable.fromFunction((d1) => d1.unkeyed()),
      );
      while (u1.moveNext()) {
        poly.add(u1.decodeFloat64List());
      }
      coords.add(poly);
    }
    return coords;
  }

  @override
  void encode(List<List<Float64List>> coordinates, Encoder encoder) {
    final unkeyed = encoder.unkeyed();
    for (final poly in coordinates) {
      unkeyed.encodeElement(
        poly,
        Encodable.fromFunction((List<Float64List> polyList, e1) {
          final u1 = e1.unkeyed();
          for (final ring in polyList) {
            u1.encodeElement(
              ring,
              Encodable.fromFunction((Float64List point, e2) {
                final u2 = e2.unkeyed();
                u2.encodeDouble(point[0]);
                u2.encodeDouble(point[1]);
              }),
            );
          }
        }),
      );
    }
  }
}

@Codable()
class CanadaProperties {
  final String name;

  const CanadaProperties({required this.name});
}

@Codable()
class CanadaGeometry {
  final String type;
  @CodableKey(customDecoder: CanadaCoordinatesDecoder())
  final List<List<Float64List>> coordinates;

  const CanadaGeometry({required this.type, this.coordinates = const []});
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
}

@Codable()
class CanadaFeatureCollection {
  final String type;
  final List<CanadaFeature> features;

  const CanadaFeatureCollection({required this.type, this.features = const []});
}
