/// Exception and diagnostic definitions for serialization errors.
library;

/// Canonical serialization and deserialization exception carrying structured
/// path context.
class CodableException implements Exception {
  /// Human-readable explanation of the serialization or deserialization
  /// failure.
  final String message;

  /// Hierarchical token path leading to the failure site (e.g.
  /// `['users', 0, 'email']`).
  final List<Object> path;

  /// Optional underlying cause (e.g. `FormatException`, `TypeError`).
  final Object? underlyingError;

  /// Creates a [CodableException] with a [message], optional token [path], and
  /// [underlyingError].
  const CodableException(
    this.message, {
    this.path = const [],
    this.underlyingError,
  });

  /// Creates an exception for a missing required property.
  factory CodableException.missingKey(
    String key, {
    List<Object> path = const [],
  }) => CodableException('Missing required key: "$key"', path: [...path, key]);

  /// Creates an exception for a field type mismatch.
  factory CodableException.typeMismatch({
    required Type expectedType,
    required Object? actualValue,
    List<Object> path = const [],
  }) => CodableException(
    'Expected value of type $expectedType but got ${actualValue.runtimeType} '
    '($actualValue)',
    path: path,
  );

  /// Creates an exception for an unknown polymorphic subtype tag.
  factory CodableException.unknownSubtype({
    required String discriminatorKey,
    required String subtypeValue,
    List<Object> path = const [],
  }) => CodableException(
    'Unknown polymorphic subtype "$subtypeValue" for discriminator '
    '"$discriminatorKey"',
    path: [...path, discriminatorKey],
  );

  /// Formats the hierarchical token path as a dot/bracket navigation string
  /// (e.g. `users[0].email`).
  String get formattedPath {
    if (path.isEmpty) return '';
    final buffer = StringBuffer();
    for (var i = 0; i < path.length; i++) {
      final segment = path[i];
      if (segment is int) {
        buffer.write('[$segment]');
      } else {
        if (buffer.isNotEmpty) buffer.write('.');
        buffer.write(segment);
      }
    }
    return buffer.toString();
  }

  @override
  String toString() {
    final buffer = StringBuffer('CodableException: ');
    buffer.write(message);
    final p = formattedPath;
    if (p.isNotEmpty) {
      buffer.write(' at path $p');
    }
    if (underlyingError != null) {
      buffer.write(' (caused by: $underlyingError)');
    }
    return buffer.toString();
  }
}
