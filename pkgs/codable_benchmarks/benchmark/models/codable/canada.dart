// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:codable/codable.dart';

part 'canada.g.dart';

final class CanadaCoordinatesDecoder {
  const CanadaCoordinatesDecoder();

  List<List<List<double>>> decodeFromReader(JsonTokenReader reader) {
    final coords = <List<List<double>>>[];
    reader.beginArray();
    while (reader.hasNext()) {
      final poly = <List<double>>[];
      reader.beginArray();
      while (reader.hasNext()) {
        reader.beginArray();
        final ring = <double>[];
        while (reader.hasNext()) {
          ring.add(reader.readDouble());
        }
        reader.endArray();
        poly.add(ring);
      }
      reader.endArray();
      coords.add(poly);
    }
    reader.endArray();
    return coords;
  }

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

  void encodeToWriter(
    List<List<List<double>>> coordinates,
    JsonTokenWriter writer,
  ) {
    writer.beginArray();
    for (final poly in coordinates) {
      writer.beginArray();
      for (final ring in poly) {
        writer.beginArray();
        for (final pt in ring) {
          writer.writeDouble(pt);
        }
        writer.endArray();
      }
      writer.endArray();
    }
    writer.endArray();
  }
}

@Codable()
class CanadaProperties {
  final String name;

  const CanadaProperties({this.name = ''});

  static CanadaProperties fromReader(JsonTokenReader reader) =>
      _$CanadaPropertiesFromReader(reader);
  void toWriter(JsonTokenWriter writer) =>
      _$CanadaPropertiesToWriter(this, writer);

  static CanadaProperties decode(Decoder decoder) =>
      _$CanadaPropertiesFromDecoder(decoder);
}

@Codable()
class CanadaGeometry {
  final String type;
  @CodableKey(customDecoder: CanadaCoordinatesDecoder())
  final List<List<List<double>>> coordinates;

  const CanadaGeometry({required this.type, this.coordinates = const []});

  static CanadaGeometry fromReader(JsonTokenReader reader) =>
      _$CanadaGeometryFromReader(reader);
  void toWriter(JsonTokenWriter writer) =>
      _$CanadaGeometryToWriter(this, writer);

  static CanadaGeometry decode(Decoder decoder) =>
      _$CanadaGeometryFromDecoder(decoder);
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

  static CanadaFeature fromReader(JsonTokenReader reader) =>
      _$CanadaFeatureFromReader(reader);
  void toWriter(JsonTokenWriter writer) =>
      _$CanadaFeatureToWriter(this, writer);

  static CanadaFeature decode(Decoder decoder) =>
      _$CanadaFeatureFromDecoder(decoder);
}

@Codable()
class CanadaFeatureCollection {
  final String type;
  final List<CanadaFeature> features;

  const CanadaFeatureCollection({required this.type, this.features = const []});

  static CanadaFeatureCollection fromReader(JsonTokenReader reader) =>
      _$CanadaFeatureCollectionFromReader(reader);
  void toWriter(JsonTokenWriter writer) =>
      _$CanadaFeatureCollectionToWriter(this, writer);

  static CanadaFeatureCollection decode(Decoder decoder) =>
      _$CanadaFeatureCollectionFromDecoder(decoder);
}
