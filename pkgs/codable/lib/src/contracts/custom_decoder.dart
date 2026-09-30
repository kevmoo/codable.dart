/// Polymorphic field serialization contracts.
library;

import 'codable.dart';

/// Tagged polymorphic subtype discriminator contract.
///
/// Maps discriminator property values (e.g. `{"type": "car"}`) to concrete
/// subtype [Decodable] companions.
abstract interface class SuperDecodable<T> {
  /// The property name used as the subtype discriminator (e.g. `'type'`).
  String get discriminatorKey;

  /// The map of discriminator string values to concrete subtype [Decodable]
  /// companions.
  Map<String, Decodable<T>> get subtypes;
}
