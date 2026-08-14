import 'package:codable/codable.dart';

/// Highly optimized generated Coordinate model using O(1) KeyOptions indexing.
class Coordinate {
  final double latitude;
  final double longitude;

  const Coordinate({required this.latitude, required this.longitude});

  static final _options = KeyOptions(['latitude', 'longitude', 'lat', 'lon']);

  static Coordinate decode(Decoder decoder) {
    final keyed = decoder.keyed();
    double? lat;
    double? lon;

    while (keyed.hasNextKey()) {
      switch (keyed.selectKeyIndex(_options)) {
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
