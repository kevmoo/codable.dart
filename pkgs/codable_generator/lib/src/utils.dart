// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:codable/codable.dart';

/// Applies [FieldRename] convention to [fieldName].
String applyFieldRename(String fieldName, FieldRename rename) {
  return switch (rename) {
    FieldRename.none => fieldName,
    FieldRename.snake => toSnakeCase(fieldName),
    FieldRename.kebab => toKebabCase(fieldName),
    FieldRename.pascal => toPascalCase(fieldName),
    FieldRename.screamingSnake => toScreamingSnakeCase(fieldName),
  };
}

/// Converts camelCase or PascalCase identifier to snake_case.
String toSnakeCase(String name) {
  if (name.isEmpty) return name;
  final buffer = StringBuffer();
  for (var i = 0; i < name.length; i++) {
    final char = name[i];
    final isUpper = char.toUpperCase() == char && char.toLowerCase() != char;
    if (isUpper) {
      if (i > 0 && name[i - 1] != '_') {
        final prevChar = name[i - 1];
        final prevIsUpper =
            prevChar.toUpperCase() == prevChar &&
            prevChar.toLowerCase() != prevChar;
        final nextIsLower =
            i + 1 < name.length &&
            name[i + 1].toLowerCase() == name[i + 1] &&
            name[i + 1].toUpperCase() != name[i + 1];
        if (!prevIsUpper || nextIsLower) {
          buffer.write('_');
        }
      }
      buffer.write(char.toLowerCase());
    } else {
      buffer.write(char);
    }
  }
  return buffer.toString();
}

/// Converts camelCase or PascalCase identifier to kebab-case.
String toKebabCase(String name) {
  return toSnakeCase(name).replaceAll('_', '-');
}

/// Converts identifier to PascalCase.
String toPascalCase(String name) {
  if (name.isEmpty) return name;
  // Handle snake_case or kebab-case inputs
  if (name.contains('_') || name.contains('-')) {
    final parts = name.split(RegExp(r'[_-]'));
    return parts.where((p) => p.isNotEmpty).map(toPascalCase).join();
  }
  return name[0].toUpperCase() + name.substring(1);
}

/// Converts identifier to SCREAMING_SNAKE_CASE.
String toScreamingSnakeCase(String name) {
  return toSnakeCase(name).toUpperCase();
}

/// Converts a field or wire name into a valid, safe PascalCase identifier
/// suffix.
String toSafeIdentifierSuffix(String name) {
  if (name.isEmpty) return 'Empty';
  final sanitized = name.replaceAll(RegExp(r'[^a-zA-Z0-9_]'), '_');
  return toPascalCase(sanitized);
}

/// Encodes a UTF-8 string into a Dart const list expression.
String encodeAsConstBytes(String text) {
  final bytes = Uint8List.fromList(utf8.encode(text));
  return 'const [${bytes.join(', ')}]';
}
