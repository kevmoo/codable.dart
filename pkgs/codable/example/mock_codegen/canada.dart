// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:codable/codable.dart';

part 'canada.g.dart';

final class CanadaCoordinatesDecoder {
  const CanadaCoordinatesDecoder();

  List<List<Float64List>> decodeFromReader(JsonTokenReader reader) {
    final coords = <List<Float64List>>[];
    reader.beginArray();
    while (reader.hasNext()) {
      final poly = <Float64List>[];
      reader.beginArray();
      while (reader.hasNext()) {
        reader.beginArray();
        final point = Float64List(2);
        point[0] = reader.readDouble();
        point[1] = reader.readDouble();
        reader.endArray();
        poly.add(point);
      }
      reader.endArray();
      coords.add(poly);
    }
    reader.endArray();
    return coords;
  }

  void encodeToWriter(
    List<List<Float64List>> coordinates,
    JsonTokenWriter writer,
  ) {
    writer.beginArray();
    for (final poly in coordinates) {
      writer.beginArray();
      for (final ring in poly) {
        writer.beginArray();
        writer.writeDouble(ring[0]);
        writer.writeDouble(ring[1]);
        writer.endArray();
      }
      writer.endArray();
    }
    writer.endArray();
  }
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

  static CanadaFeatureCollection decodeFromReader(JsonTokenReader reader) =>
      _$CanadaFeatureCollectionFromReader(reader);
  void encodeToWriter(JsonTokenWriter writer) =>
      _$CanadaFeatureCollectionToWriter(this, writer);

  static CanadaFeatureCollection decode(Decoder decoder) {
    if (decoder is JsonCodableDecoder) {
      return _$CanadaFeatureCollectionFromReader(decoder.reader);
    }
    final keyed = decoder.keyed();
    String? type;
    List<CanadaFeature>? features;

    while (keyed.hasNextKey()) {
      switch (keyed.selectKeyIndex(KeyOptions(['type', 'features']))) {
        case 0:
          type = keyed.readString();
          break;
        case 1:
          features = keyed.decodeList(CanadaFeature.decode);
          break;
        default:
          keyed.skipValue();
          break;
      }
    }

    return CanadaFeatureCollection(
      type: type ?? '',
      features: features ?? const [],
    );
  }
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

  static CanadaFeature decodeFromReader(JsonTokenReader reader) =>
      _$CanadaFeatureFromReader(reader);
  void encodeToWriter(JsonTokenWriter writer) =>
      _$CanadaFeatureToWriter(this, writer);

  static CanadaFeature decode(Decoder decoder) {
    if (decoder is JsonCodableDecoder) {
      return _$CanadaFeatureFromReader(decoder.reader);
    }
    final keyed = decoder.keyed();
    String? type;
    CanadaProperties? properties;
    CanadaGeometry? geometry;

    while (keyed.hasNextKey()) {
      switch (keyed.selectKeyIndex(
        KeyOptions(['type', 'properties', 'geometry']),
      )) {
        case 0:
          type = keyed.readString();
          break;
        case 1:
          properties = keyed.decodeValue(CanadaProperties.decode);
          break;
        case 2:
          geometry = keyed.decodeValue(CanadaGeometry.decode);
          break;
        default:
          keyed.skipValue();
          break;
      }
    }

    return CanadaFeature(
      type: type ?? '',
      properties: properties ?? const CanadaProperties(name: ''),
      geometry: geometry ?? const CanadaGeometry(type: '', coordinates: []),
    );
  }
}

@Codable()
class CanadaProperties {
  final String name;

  const CanadaProperties({required this.name});

  static CanadaProperties fromReader(JsonTokenReader reader) =>
      _$CanadaPropertiesFromReader(reader);
  void toWriter(JsonTokenWriter writer) =>
      _$CanadaPropertiesToWriter(this, writer);

  static CanadaProperties decodeFromReader(JsonTokenReader reader) =>
      _$CanadaPropertiesFromReader(reader);
  void encodeToWriter(JsonTokenWriter writer) =>
      _$CanadaPropertiesToWriter(this, writer);

  static CanadaProperties decode(Decoder decoder) {
    if (decoder is JsonCodableDecoder) {
      return _$CanadaPropertiesFromReader(decoder.reader);
    }
    final keyed = decoder.keyed();
    String? name;

    while (keyed.hasNextKey()) {
      switch (keyed.selectKeyIndex(KeyOptions(['name']))) {
        case 0:
          name = keyed.readString();
          break;
        default:
          keyed.skipValue();
          break;
      }
    }

    return CanadaProperties(name: name ?? '');
  }
}

@Codable()
class CanadaGeometry {
  final String type;
  @CodableKey(customDecoder: CanadaCoordinatesDecoder())
  final List<List<Float64List>> coordinates;

  const CanadaGeometry({required this.type, this.coordinates = const []});

  static CanadaGeometry fromReader(JsonTokenReader reader) =>
      _$CanadaGeometryFromReader(reader);
  void toWriter(JsonTokenWriter writer) =>
      _$CanadaGeometryToWriter(this, writer);

  static CanadaGeometry decodeFromReader(JsonTokenReader reader) =>
      _$CanadaGeometryFromReader(reader);
  void encodeToWriter(JsonTokenWriter writer) =>
      _$CanadaGeometryToWriter(this, writer);

  static CanadaGeometry decode(Decoder decoder) {
    if (decoder is JsonCodableDecoder) {
      return _$CanadaGeometryFromReader(decoder.reader);
    }
    final keyed = decoder.keyed();
    String? type;
    List<List<Float64List>>? coordinates;

    while (keyed.hasNextKey()) {
      switch (keyed.selectKeyIndex(KeyOptions(['type', 'coordinates']))) {
        case 0:
          type = keyed.readString();
          break;
        case 1:
          coordinates = keyed.decodeList((polyDecoder) {
            final polyUnkeyed = polyDecoder.unkeyed();
            final poly = <Float64List>[];
            while (polyUnkeyed.hasNext()) {
              poly.add(polyUnkeyed.decodeFloat64List());
            }
            return poly;
          });
          break;
        default:
          keyed.skipValue();
          break;
      }
    }

    return CanadaGeometry(
      type: type ?? '',
      coordinates: coordinates ?? const [],
    );
  }
}
