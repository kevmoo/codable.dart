/// Core Encodable, Decodable, and Codable contracts and callback typedefs.
library;

import 'decoder.dart';
import 'encoder.dart';

/// Callback type for decoding a value of type [T] from a [Decoder].
typedef DecoderCallback<T> = T Function(Decoder decoder);

/// Callback type for encoding a value of type [T] to an [Encoder].
typedef EncoderCallback<T> = void Function(T value, Encoder encoder);

/// Base contract for domain objects that can serialize themselves to an
/// [Encoder].
abstract interface class Encodable {
  /// Encodes this instance into the given [encoder].
  void encode(Encoder encoder);
}

/// Base contract for domain objects that can deserialize themselves from a
/// [Decoder].
abstract interface class Decodable<T> {
  /// Decodes and returns an instance of [T] from the given [decoder].
  T decode(Decoder decoder);
}
