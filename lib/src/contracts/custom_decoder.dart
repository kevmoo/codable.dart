/// Polymorphic and custom field decoding contracts.
library;

import 'codable.dart';
import 'decoder.dart';

/// Format-agnostic custom field normalization contract.
///
/// Normalizes multi-representation field tokens (e.g. integer `90210` vs string `"90210"`)
/// into a consistent Dart type.
abstract interface class CustomFieldDecoder<T> {
  /// Decodes and normalizes a custom field value from [decoder].
  T decodeField(Decoder decoder);
}

/// Untagged structural / shape-based polymorphism contract.
///
/// Resolves union types via token peeking (e.g. `String` user ID vs nested `User` object).
abstract interface class UnionDecoder<T> {
  /// Decodes an untagged union branch from [decoder].
  T decodeUnion(Decoder decoder);
}

/// Tagged polymorphic subtype discriminator contract.
///
/// Maps discriminator property values (e.g. `{"type": "car"}`) to concrete subtype decoders.
abstract interface class SuperDecodable<T> {
  /// The property name used as the subtype discriminator (e.g. `'type'`).
  String get discriminatorKey;

  /// The map of discriminator string values to concrete subtype decoder callbacks.
  Map<String, DecoderCallback<T>> get subtypes;
}
