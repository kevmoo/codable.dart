/// Metadata annotations for code generation and schema customization.
library;

import 'package:meta/meta_meta.dart';

import 'codable.dart';
import 'decoder.dart';
import 'encoder.dart';

/// Backing metadata class for the [@Codable] annotation.
@Target({TargetKind.classType})
final class CodableAnnotation implements Codable<Never> {
  /// Whether to generate an `encode` implementation on `<Model>Codable`.
  final bool createEncoder;

  /// Whether to generate a `decode` implementation on `<Model>Codable`.
  final bool createDecoder;

  /// Whether to use golden mask bitmask validation for required fields.
  final bool useGoldenMask;

  /// Field naming convention for JSON wire formats.
  final FieldRename fieldRename;

  /// Creates a [CodableAnnotation] instance.
  const CodableAnnotation({
    this.createEncoder = true,
    this.createDecoder = true,
    this.useGoldenMask = true,
    this.fieldRename = FieldRename.none,
  });

  @override
  Never decode(Decoder decoder) => throw UnsupportedError(
    '@Codable() annotation instance cannot be used as a runtime Decodable.',
  );

  @override
  void encode(Never value, Encoder encoder) => throw UnsupportedError(
    '@Codable() annotation instance cannot be used as a runtime Encodable.',
  );
}

/// Global const instance for `@Codable()`.
const codable = Codable<Never>();

/// Custom configuration for an individual class field or constructor parameter.
@Target({TargetKind.field, TargetKind.parameter, TargetKind.getter})
final class CodableKey {
  /// Explicit wire name override for this key.
  final String? name;

  /// Alternative wire names accepted during deserialization.
  final List<String>? aliases;

  /// Whether to ignore this field during serialization and deserialization.
  final bool ignore;

  /// Custom decoder class instance or type for custom value conversion.
  final Object? customDecoder;

  /// Default value expression / constant if missing from payload.
  final Object? defaultValue;

  /// Creates a [CodableKey] annotation instance.
  const CodableKey({
    this.name,
    this.aliases,
    this.ignore = false,
    this.customDecoder,
    this.defaultValue,
  });
}

/// Hints that a numeric list is a fixed-size coordinate tuple for pre-sized
/// typed data allocation.
@Target({TargetKind.field, TargetKind.parameter})
final class CodableTuple {
  /// The expected fixed length of the tuple.
  final int length;

  /// Creates a [CodableTuple] annotation instance.
  const CodableTuple(this.length);
}

/// Field naming conventions for JSON wire formats.
enum FieldRename { none, snake, kebab, pascal, screamingSnake }
