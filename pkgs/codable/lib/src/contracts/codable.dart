/// Core [Encodable] and [Decodable] contracts.
library;

import 'decoder.dart';
import 'encoder.dart';

/// Base contract for domain objects that can serialize themselves to an
/// [Encoder].
abstract interface class Encodable {
  /// Encodes this instance into the given [encoder].
  void encode(Encoder encoder);
}

/// Marker contract for domain objects that deserialize themselves from a
/// [Decoder] via a `static T decode(Decoder decoder)` factory or static method.
// ignore: empty_container_bodies
abstract interface class Decodable<T> {}
