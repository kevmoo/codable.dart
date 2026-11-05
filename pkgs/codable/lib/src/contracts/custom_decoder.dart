/// Polymorphic field serialization contracts.
library;

import 'codable.dart';
import 'decoder.dart';
import 'exceptions.dart';

/// Tagged polymorphic subtype discriminator contract.
///
/// Maps discriminator property values (e.g. `{"type": "car"}`) to concrete
/// subtype [Decodable] companions, and implements [Decodable] by inspecting
/// [discriminatorKey] via [Decoder.mapped] and dispatching to the matching
/// subtype decoder.
abstract class SuperDecodable<T> implements Decodable<T> {
  /// Creates a constant [SuperDecodable] descriptor.
  const SuperDecodable();

  /// The property name used as the subtype discriminator (e.g. `'type'`).
  String get discriminatorKey;

  /// The map of discriminator string values to concrete subtype [Decodable]
  /// companions.
  Map<String, Decodable<T>> get subtypes;

  @override
  T decode(Decoder decoder) => decodeSuper(decoder);
}

/// Extension providing polymorphic decoding for classes that implement or
/// extend [SuperDecodable].
extension SuperDecodableExtension<T> on SuperDecodable<T> {
  /// Decodes a polymorphic value of type [T] from [decoder] using
  /// [discriminatorKey] and [subtypes].
  T decodeSuper(Decoder decoder) {
    final mapped = decoder.mapped();
    if (!mapped.containsKey(discriminatorKey) ||
        mapped.isNull(discriminatorKey)) {
      throw CodableException.missingKey(discriminatorKey);
    }
    final subtypeValue = mapped.readString(discriminatorKey);
    final subtype = subtypes[subtypeValue];
    if (subtype == null) {
      throw CodableException.unknownSubtype(
        discriminatorKey: discriminatorKey,
        subtypeValue: subtypeValue,
      );
    }
    return subtype.decode(decoder);
  }
}
