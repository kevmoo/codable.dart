/// Polymorphic subtype serialization contracts.
library;

import 'codable.dart';
import 'decoder.dart';
import 'encoder.dart';
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
    final subtypeValue = _readDiscriminatorValue(decoder, discriminatorKey);
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

/// Bidirectional subtype binding used by [SuperCodable].
abstract interface class PolymorphicSubtype<Base> {
  /// Wire value written for the enclosing `discriminatorKey`.
  String get discriminatorValue;

  /// Whether [value] is an instance handled by this subtype binding.
  bool matches(Base value);

  /// Decodes an instance of this subtype from [decoder].
  Base decode(Decoder decoder);

  /// Exact number of keyed entries [encodeFields] will write for [value], or
  /// `null` when unknown upfront.
  int? encodedFieldCount(Base value);

  /// Writes [value]'s fields into an already-open [keyed] container.
  void encodeFields(Base value, KeyedEncoder keyed);
}

/// Constant binding from a [discriminatorValue] to a concrete [KeyedCodable]
/// for [Sub] within [Base].
final class SubtypeCodable<Base, Sub extends Base>
    implements PolymorphicSubtype<Base> {
  @override
  final String discriminatorValue;

  /// Concrete [KeyedCodable] companion for [Sub].
  final KeyedCodable<Sub> codable;

  /// Creates a constant bidirectional polymorphic subtype binding.
  const SubtypeCodable(this.discriminatorValue, this.codable);

  @override
  bool matches(Base value) => value is Sub;

  @override
  Sub decode(Decoder decoder) => codable.decode(decoder);

  @override
  int? encodedFieldCount(Base value) => codable.encodedFieldCount(value as Sub);

  @override
  void encodeFields(Base value, KeyedEncoder keyed) =>
      codable.encodeFields(value as Sub, keyed);
}

/// Bidirectional polymorphic companion contract combining single-pass
/// `[discriminatorKey: discriminatorValue, ...subtypeFields]` encoding with
/// discriminator-based subtype decoding.
abstract class SuperCodable<T> implements KeyedCodable<T> {
  /// Creates a constant [SuperCodable] descriptor.
  const SuperCodable();

  /// The property name used as the subtype discriminator (e.g. `'type'`).
  String get discriminatorKey;

  /// Ordered subtype bindings checked via [PolymorphicSubtype.matches] on
  /// encode and [PolymorphicSubtype.discriminatorValue] on decode.
  List<PolymorphicSubtype<T>> get subtypes;

  @override
  T decode(Decoder decoder) {
    final subtypeValue = _readDiscriminatorValue(decoder, discriminatorKey);
    for (final subtype in subtypes) {
      if (subtype.discriminatorValue == subtypeValue) {
        return subtype.decode(decoder);
      }
    }
    throw CodableException.unknownSubtype(
      discriminatorKey: discriminatorKey,
      subtypeValue: subtypeValue,
    );
  }

  @override
  int? encodedFieldCount(T value) {
    final subCount = _matchSubtype(value).encodedFieldCount(value);
    return subCount == null ? null : 1 + subCount;
  }

  @override
  void encodeFields(T value, KeyedEncoder keyed) {
    final subtype = _matchSubtype(value);
    keyed.encodeString(discriminatorKey, subtype.discriminatorValue);
    subtype.encodeFields(value, keyed);
  }

  @override
  void encode(T value, Encoder encoder) {
    final subtype = _matchSubtype(value);
    final subCount = subtype.encodedFieldCount(value);
    final keyed = encoder.keyed(length: subCount == null ? null : 1 + subCount);
    keyed.encodeString(discriminatorKey, subtype.discriminatorValue);
    subtype.encodeFields(value, keyed);
  }

  PolymorphicSubtype<T> _matchSubtype(T value) {
    for (final subtype in subtypes) {
      if (subtype.matches(value)) return subtype;
    }
    throw CodableException(
      'No registered subtype for ${value.runtimeType} on discriminator '
      '"$discriminatorKey"',
      actualValue: value,
    );
  }
}

String _readDiscriminatorValue(Decoder decoder, String discriminatorKey) {
  final mapped = decoder.mapped();
  if (!mapped.containsKey(discriminatorKey) ||
      mapped.isNull(discriminatorKey)) {
    throw CodableException.missingKey(discriminatorKey);
  }
  return mapped.readString(discriminatorKey);
}
