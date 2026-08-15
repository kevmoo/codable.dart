import 'package:codable/codable.dart';
import 'package:codable/src/driver/json_codable_driver.dart';

/// Highly optimized generated Coordinate model using O(1) KeyOptions indexing.
class Coordinate {
  final double latitude;
  final double longitude;

  const Coordinate({required this.latitude, required this.longitude});

  static final _options = JsonKeyOptions.of([
    'latitude',
    'longitude',
    'lat',
    'lon',
  ]);

  static Coordinate decodeFromReader(JsonTokenReader reader) {
    reader.beginObject();
    double? lat;
    double? lon;

    while (reader.hasNext()) {
      switch (reader.selectName(_options)) {
        case 0: // latitude
        case 2: // lat
          lat = reader.readDouble();
          break;
        case 1: // longitude
        case 3: // lon
          lon = reader.readDouble();
          break;
        default:
          reader.skipValue();
          break;
      }
    }
    reader.endObject();

    if (lat == null || lon == null) {
      throw CodableException('Missing required fields for Coordinate');
    }
    return Coordinate(latitude: lat, longitude: lon);
  }

  static Coordinate decode(Decoder decoder) {
    if (decoder is JsonCodableDecoder) {
      return decodeFromReader(decoder.reader);
    }
    final keyed = decoder.keyed();
    double? lat;
    double? lon;

    while (keyed.hasNextKey()) {
      switch (keyed.selectKeyIndex(
        KeyOptions(['latitude', 'longitude', 'lat', 'lon']),
      )) {
        case 0: // latitude
        case 2: // lat
          lat = keyed.readDouble();
          break;
        case 1: // longitude
        case 3: // lon
          lon = keyed.readDouble();
          break;
        default:
          keyed.skipValue();
          break;
      }
    }

    if (lat == null || lon == null) {
      throw CodableException('Missing required fields for Coordinate');
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
