/// Metadata annotations for code generation and schema customization.
library;

import 'package:meta/meta_meta.dart';

/// Annotation designating a class as Codable for build-time code generation.
@Target({TargetKind.classType})
final class Codable {
  /// Creates a [Codable] annotation instance.
  const Codable();
}

/// Global const instance for `@Codable()`.
const codable = Codable();

/// Annotation for configuring field-level decoding, custom conversion, and naming overrides.
@Target({TargetKind.field, TargetKind.getter})
final class CodableField {
  /// Custom field decoder class reference or static function tear-off.
  final Object? decoder;

  /// Custom field encoder class reference or static function tear-off.
  final Object? encoder;

  /// Custom wire name override for this field.
  final String? name;

  /// Whether to include this field during encoding if its value is null.
  final bool includeIfNull;

  /// Creates a [CodableField] annotation instance.
  const CodableField({
    this.decoder,
    this.encoder,
    this.name,
    this.includeIfNull = true,
  });
}
