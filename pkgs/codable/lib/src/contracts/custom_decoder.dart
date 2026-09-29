/// Polymorphic and custom field serialization contracts.
library;

import 'decoder.dart';
import 'encoder.dart';

/// Format-agnostic custom field serialization and normalization contract.
///
/// Normalizes multi-representation field tokens (e.g. integer epoch timestamps
/// vs ISO-8601 strings) into a consistent Dart type [T] and encodes [T] back to
/// an [Encoder].
abstract interface class CustomCodable<T> {
  /// Decodes and normalizes a custom field value from [decoder].
  T decode(Decoder decoder);

  /// Encodes a custom field [value] into [encoder].
  void encode(T value, Encoder encoder);
}

/// Tagged polymorphic subtype discriminator contract.
///
/// Maps discriminator property values (e.g. `{"type": "car"}`) to concrete
/// subtype decoders.
abstract interface class SuperDecodable<T> {
  /// The property name used as the subtype discriminator (e.g. `'type'`).
  String get discriminatorKey;

  /// The map of discriminator string values to concrete subtype decoder
  /// callbacks.
  Map<String, T Function(Decoder decoder)> get subtypes;
}
