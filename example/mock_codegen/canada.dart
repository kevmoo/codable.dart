import 'dart:convert';
import 'dart:typed_data';

import 'package:codable/codable.dart';
import 'package:codable/src/driver/json_codable_driver.dart';

class CanadaFeatureCollection {
  final String type;
  final List<CanadaFeature> features;

  const CanadaFeatureCollection({required this.type, required this.features});

  static final _options = JsonKeyOptions.of(['type', 'features']);

  static CanadaFeatureCollection decodeFromReader(JsonTokenReader reader) {
    reader.beginObject();
    String? type;
    List<CanadaFeature>? features;

    while (reader.hasNext()) {
      switch (reader.selectName(_options)) {
        case 0:
          type = reader.readString();
          break;
        case 1:
          reader.beginArray();
          final list = <CanadaFeature>[];
          while (reader.hasNext()) {
            list.add(CanadaFeature.decodeFromReader(reader));
          }
          reader.endArray();
          features = list;
          break;
        default:
          reader.skipValue();
          break;
      }
    }
    reader.endObject();

    return CanadaFeatureCollection(
      type: type ?? '',
      features: features ?? const [],
    );
  }

  static CanadaFeatureCollection decode(Decoder decoder) {
    if (decoder is JsonCodableDecoder) {
      return decodeFromReader(decoder.reader);
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

class CanadaFeature {
  final String type;
  final CanadaProperties properties;
  final CanadaGeometry geometry;

  const CanadaFeature({
    required this.type,
    required this.properties,
    required this.geometry,
  });

  static final _options = JsonKeyOptions.of(['type', 'properties', 'geometry']);

  static CanadaFeature decodeFromReader(JsonTokenReader reader) {
    reader.beginObject();
    String? type;
    CanadaProperties? properties;
    CanadaGeometry? geometry;

    while (reader.hasNext()) {
      switch (reader.selectName(_options)) {
        case 0:
          type = reader.readString();
          break;
        case 1:
          properties = CanadaProperties.decodeFromReader(reader);
          break;
        case 2:
          geometry = CanadaGeometry.decodeFromReader(reader);
          break;
        default:
          reader.skipValue();
          break;
      }
    }
    reader.endObject();

    return CanadaFeature(
      type: type ?? '',
      properties: properties ?? const CanadaProperties(name: ''),
      geometry: geometry ?? const CanadaGeometry(type: '', coordinates: []),
    );
  }

  static CanadaFeature decode(Decoder decoder) {
    if (decoder is JsonCodableDecoder) {
      return decodeFromReader(decoder.reader);
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

class CanadaProperties {
  final String name;

  const CanadaProperties({required this.name});

  static final _options = JsonKeyOptions.of(['name']);

  static CanadaProperties decodeFromReader(JsonTokenReader reader) {
    reader.beginObject();
    String? name;

    while (reader.hasNext()) {
      switch (reader.selectName(_options)) {
        case 0:
          name = reader.readString();
          break;
        default:
          reader.skipValue();
          break;
      }
    }
    reader.endObject();

    return CanadaProperties(name: name ?? '');
  }

  static CanadaProperties decode(Decoder decoder) {
    if (decoder is JsonCodableDecoder) {
      return decodeFromReader(decoder.reader);
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

class CanadaGeometry {
  final String type;
  final List<List<Float64List>> coordinates;

  const CanadaGeometry({required this.type, required this.coordinates});

  static final _options = JsonKeyOptions.of(['type', 'coordinates']);

  static CanadaGeometry decodeFromReader(JsonTokenReader reader) {
    reader.beginObject();
    String? type;
    List<List<Float64List>>? coordinates;

    while (reader.hasNext()) {
      switch (reader.selectName(_options)) {
        case 0:
          type = reader.readString();
          break;
        case 1:
          final coords = <List<Float64List>>[];
          reader.beginArray();
          while (reader.hasNext()) {
            final poly = <Float64List>[];
            reader.beginArray();
            while (reader.hasNext()) {
              reader.beginArray();
              final ring = <double>[];
              while (reader.hasNext()) {
                ring.add(reader.readDouble());
              }
              reader.endArray();
              poly.add(Float64List.fromList(ring));
            }
            reader.endArray();
            coords.add(poly);
          }
          reader.endArray();
          coordinates = coords;
          break;
        default:
          reader.skipValue();
          break;
      }
    }
    reader.endObject();

    return CanadaGeometry(
      type: type ?? '',
      coordinates: coordinates ?? const [],
    );
  }

  static CanadaGeometry decode(Decoder decoder) {
    if (decoder is JsonCodableDecoder) {
      return decodeFromReader(decoder.reader);
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
          final coords = <List<Float64List>>[];
          final outerList = decoder.unkeyed();
          while (outerList.hasNext()) {
            final poly = <Float64List>[];
            final ringList = decoder.unkeyed();
            while (ringList.hasNext()) {
              poly.add(ringList.decodeFloat64List());
            }
            coords.add(poly);
          }
          coordinates = coords;
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
