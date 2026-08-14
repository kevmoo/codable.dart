import 'dart:typed_data';

import 'package:codable/codable.dart';

class CanadaFeatureCollection {
  final String type;
  final List<CanadaFeature> features;

  const CanadaFeatureCollection({required this.type, required this.features});

  static final _options = KeyOptions(['type', 'features']);

  static CanadaFeatureCollection decode(Decoder decoder) {
    final keyed = decoder.keyed();
    String? type;
    List<CanadaFeature>? features;

    while (keyed.hasNextKey()) {
      switch (keyed.selectKeyIndex(_options)) {
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

  static final _options = KeyOptions(['type', 'properties', 'geometry']);

  static CanadaFeature decode(Decoder decoder) {
    final keyed = decoder.keyed();
    String? type;
    CanadaProperties? properties;
    CanadaGeometry? geometry;

    while (keyed.hasNextKey()) {
      switch (keyed.selectKeyIndex(_options)) {
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

  static final _options = KeyOptions(['name']);

  static CanadaProperties decode(Decoder decoder) {
    final keyed = decoder.keyed();
    String? name;

    while (keyed.hasNextKey()) {
      switch (keyed.selectKeyIndex(_options)) {
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

  static final _options = KeyOptions(['type', 'coordinates']);

  static CanadaGeometry decode(Decoder decoder) {
    final keyed = decoder.keyed();
    String? type;
    List<List<Float64List>>? coordinates;

    while (keyed.hasNextKey()) {
      switch (keyed.selectKeyIndex(_options)) {
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
