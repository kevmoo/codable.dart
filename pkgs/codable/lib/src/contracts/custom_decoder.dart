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

/// Covariant subtype encoder binding used by [SuperEncodable].
abstract interface class PolymorphicEncodableSubtype<Base> {
  /// Wire value written for the enclosing `discriminatorKey`.
  String get discriminatorValue;

  /// Whether [value] is an instance handled by this subtype binding.
  bool matches(Base value);

  /// Exact number of keyed entries [encodeFields] will write for [value], or
  /// `null` when unknown upfront.
  int? encodedFieldCount(Base value);

  /// Writes [value]'s fields into an already-open [keyed] container.
  void encodeFields(Base value, KeyedEncoder keyed);
}

/// Bidirectional subtype binding used by [SuperCodable].
abstract interface class PolymorphicSubtype<Base>
    implements PolymorphicEncodableSubtype<Base> {
  /// Decodes an instance of this subtype from [decoder].
  Base decode(Decoder decoder);
}

/// Constant binding from a [discriminatorValue] to a concrete [KeyedEncodable]
/// for [Sub] within [Base].
final class SubtypeEncodable<Base, Sub extends Base>
    implements PolymorphicEncodableSubtype<Base> {
  @override
  final String discriminatorValue;

  /// Concrete [KeyedEncodable] companion for [Sub].
  final KeyedEncodable<Sub> encodable;

  /// Creates a constant polymorphic subtype encoder binding.
  const SubtypeEncodable(this.discriminatorValue, this.encodable);

  @override
  bool matches(Base value) => value is Sub;

  @override
  int? encodedFieldCount(Base value) =>
      encodable.encodedFieldCount(value as Sub);

  @override
  void encodeFields(Base value, KeyedEncoder keyed) =>
      encodable.encodeFields(value as Sub, keyed);
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

/// Tagged polymorphic subtype encoder contract complementing [SuperDecodable].
///
/// Splices `[discriminatorKey: subtype.discriminatorValue]` ahead of the
/// matched subtype's [KeyedEncodable.encodeFields] inside a single
/// [KeyedEncoder] container with exact `1 + subCount` framing.
abstract class SuperEncodable<T> implements KeyedEncodable<T> {
  /// Creates a constant [SuperEncodable] descriptor.
  const SuperEncodable();

  /// The property name used as the subtype discriminator (e.g. `'type'`).
  String get discriminatorKey;

  /// Ordered subtype encoder bindings checked via
  /// [PolymorphicEncodableSubtype.matches].
  List<PolymorphicEncodableSubtype<T>> get subtypes;

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
  void encode(T value, Encoder encoder) => encodeSuper(value, encoder);

  PolymorphicEncodableSubtype<T> _matchSubtype(T value) {
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

/// Extension providing polymorphic encoding for classes that implement or
/// extend [SuperEncodable].
extension SuperEncodableExtension<T> on SuperEncodable<T> {
  /// Encodes [value] into [encoder] as a single keyed container carrying
  /// [discriminatorKey] and the matched subtype's fields.
  void encodeSuper(T value, Encoder encoder) {
    final subtype = _matchSubtype(value);
    final subCount = subtype.encodedFieldCount(value);
    final keyed = encoder.keyed(length: subCount == null ? null : 1 + subCount);
    keyed.encodeString(discriminatorKey, subtype.discriminatorValue);
    subtype.encodeFields(value, keyed);
  }
}

/// Unified bidirectional polymorphic companion contract combining
/// [SuperEncodable] and discriminator-based subtype decoding.
abstract class SuperCodable<T> extends SuperEncodable<T>
    implements KeyedCodable<T> {
  /// Creates a constant [SuperCodable] descriptor.
  const SuperCodable();

  @override
  List<PolymorphicSubtype<T>> get subtypes;

  @override
  T decode(Decoder decoder) => decodeSuper(decoder);
}

/// Extension providing polymorphic decoding for classes that implement or
/// extend [SuperCodable].
extension SuperCodableExtension<T> on SuperCodable<T> {
  /// Decodes a polymorphic value of type [T] from [decoder] using
  /// [discriminatorKey] and [subtypes].
  T decodeSuper(Decoder decoder) {
    final mapped = decoder.mapped();
    if (!mapped.containsKey(discriminatorKey) ||
        mapped.isNull(discriminatorKey)) {
      throw CodableException.missingKey(discriminatorKey);
    }
    final subtypeValue = mapped.readString(discriminatorKey);
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
}
