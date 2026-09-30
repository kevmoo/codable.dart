// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:codable/codable.dart';

part 'canada.g.dart';

final class CanadaCoordinatesDecoder
    implements Codable<List<List<List<double>>>> {
  const CanadaCoordinatesDecoder();

  @override
  List<List<List<double>>> decode(Decoder decoder) {
    final unkeyed = decoder.unkeyed();
    final coords = <List<List<double>>>[];
    while (unkeyed.moveNext()) {
      final poly = <List<double>>[];
      final u1 = unkeyed.decodeElement(
        Decodable.fromFunction((d1) => d1.unkeyed()),
      );
      while (u1.moveNext()) {
        poly.add(u1.decodeDoubleList());
      }
      coords.add(poly);
    }
    return coords;
  }

  @override
  void encode(List<List<List<double>>> coordinates, Encoder encoder) {
    final unkeyed = encoder.unkeyed();
    for (final poly in coordinates) {
      unkeyed.encodeElement(
        poly,
        Encodable.fromFunction((List<List<double>> polyList, e1) {
          final u1 = e1.unkeyed();
          for (final ring in polyList) {
            u1.encodeElement(
              ring,
              Encodable.fromFunction((List<double> ringList, e2) {
                final u2 = e2.unkeyed();
                for (final pt in ringList) {
                  u2.encodeDouble(pt);
                }
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

  const CanadaProperties({this.name = ''});
}

@Codable()
class CanadaGeometry {
  final String type;
  @CodableKey(customDecoder: CanadaCoordinatesDecoder())
  final List<List<List<double>>> coordinates;

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
