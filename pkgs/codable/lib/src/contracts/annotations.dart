/// Metadata annotations for code generation and schema customization.
library;

import 'package:meta/meta_meta.dart';

/// Annotation designating a class as Codable for streaming generation.
@Target({TargetKind.classType})
final class Codable {
  /// Whether to generate an encoder function `_$<Model>ToWriter`.
  final bool createEncoder;

  /// Whether to generate a decoder function `_$<Model>FromReader`.
  final bool createDecoder;

  /// Whether to use golden mask bitmask validation for required fields.
  final bool useGoldenMask;

  /// Field naming convention for JSON wire formats.
  final FieldRename fieldRename;

  /// Creates a [Codable] annotation instance.
  const Codable({
    this.createEncoder = true,
    this.createDecoder = true,
    this.useGoldenMask = true,
    this.fieldRename = FieldRename.none,
  });
}

/// Global const instance for `@Codable()`.
const codable = Codable();

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

/// Hints that a numeric list is a fixed-size coordinate tuple for pre-sized typed data allocation.
@Target({TargetKind.field, TargetKind.parameter})
final class CodableTuple {
  /// The expected fixed length of the tuple.
  final int length;

  /// Creates a [CodableTuple] annotation instance.
  const CodableTuple(this.length);
}

/// Field naming conventions for JSON wire formats.
enum FieldRename { none, snake, kebab, pascal, screamingSnake }
