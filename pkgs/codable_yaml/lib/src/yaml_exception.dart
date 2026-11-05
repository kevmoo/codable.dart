// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:codable/codable.dart';
import 'package:source_span/source_span.dart';

/// Exception thrown by `YamlCodableDecoder` carrying `SourceSpan` line and
/// column diagnostics alongside hierarchical [path] context.
final class YamlCodableException extends SourceSpanFormatException
    implements CodableException {
  @override
  final List<Object> path;

  @override
  final Object? underlyingError;

  /// Creates a [YamlCodableException] with a [message], optional [span],
  /// structured [path], [underlyingError], and original [source].
  YamlCodableException(
    String message,
    SourceSpan? span, {
    this.path = const [],
    this.underlyingError,
    Object? source,
  }) : super(message, span, source);

  @override
  String get formattedPath => _formatYamlPath(path);

  @override
  String toString({Object? color}) {
    final s = span;
    if (s == null) return message;
    final buffer = StringBuffer(
      'Error on line ${s.start.line + 1}, column ${s.start.column + 1}',
    );
    if (s.sourceUrl != null) buffer.write(' of ${s.sourceUrl}');
    buffer.write(': $message');
    final highlight = s.highlight(color: color);
    if (highlight.isNotEmpty) {
      buffer
        ..writeln()
        ..write(highlight);
    }
    return buffer.toString();
  }
}

String _formatYamlPath(List<Object> path) {
  if (path.isEmpty) return '';
  final buffer = StringBuffer();
  for (final segment in path) {
    if (segment is int) {
      buffer.write('[$segment]');
    } else {
      if (buffer.isNotEmpty) buffer.write('.');
      buffer.write(segment);
    }
  }
  return buffer.toString();
}
