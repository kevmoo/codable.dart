// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// ignore_for_file: deprecated_member_use

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:codable/codable.dart';

/// Categories of types supported by `package:codable_builder`.
enum TypeCategory {
  primitiveInt,
  primitiveDouble,
  primitiveNum,
  primitiveString,
  primitiveBool,
  enumType,
  tuple,
  list,
  set,
  map,
  nestedCodable,
  custom,
  unknown,
}

/// Metadata descriptor for a constructor parameter and class field.
final class FieldDescriptor {
  /// The parameter identifier in Dart.
  final String name;

  /// The JSON wire name.
  final String wireName;

  /// Alternative JSON wire names accepted during decoding.
  final List<String> aliases;

  /// The analyzer DartType of this field.
  final DartType type;

  /// The classified high-level type category.
  final TypeCategory category;

  /// Whether this parameter is positional in the primary constructor.
  final bool isPositional;

  /// Whether this parameter is named in the primary constructor.
  final bool isNamed;

  /// Whether this parameter is required (non-optional positional or required
  /// named).
  final bool isRequired;

  /// Whether the field is nullable (`T?` or `dynamic`).
  final bool isNullable;

  /// Whether a default value is defined.
  final bool hasDefaultValue;

  /// The source code representation of the default value.
  final String? defaultValueCode;

  /// Whether this field is ignored during serialization/deserialization.
  final bool ignore;

  /// Revived custom decoder expression (e.g. `const ZipCodeDecoder()`).
  final String? customDecoderCode;

  /// Fixed length if annotated with `@CodableTuple(length)`.
  final int? tupleLength;

  /// Element type for collections (`List<T>`, `Set<T>`).
  final DartType? elementType;

  /// Key type for maps (`Map<K, V>`).
  final DartType? mapKeyType;

  /// Value type for maps (`Map<K, V>`).
  final DartType? mapValueType;

  /// Known enum constant names if this field is an enum.
  final List<String>? enumConstants;

  /// Bitmask bit index ($0 \le reqBitIndex < 62$) for golden mask validation.
  final int? reqBitIndex;

  /// Index in the static `JsonKeyOptions.options` table.
  final int keyIndex;

  /// Indices of aliases in the static `JsonKeyOptions.options` table.
  final List<int> aliasIndices;

  FieldDescriptor({
    required this.name,
    required this.wireName,
    required this.aliases,
    required this.type,
    required this.category,
    required this.isPositional,
    required this.isNamed,
    required this.isRequired,
    required this.isNullable,
    required this.hasDefaultValue,
    this.defaultValueCode,
    required this.ignore,
    this.customDecoderCode,
    this.tupleLength,
    this.elementType,
    this.mapKeyType,
    this.mapValueType,
    this.enumConstants,
    this.reqBitIndex,
    required this.keyIndex,
    required this.aliasIndices,
  });

  /// Whether this field participates in golden mask validation.
  bool get participatesInGoldenMask =>
      !ignore && isRequired && !hasDefaultValue && reqBitIndex != null;
}

/// Metadata descriptor for a `@Codable()` annotated class.
final class ModelDescriptor {
  /// The analyzer [ClassElement].
  final ClassElement element;

  /// The Dart class name.
  final String className;

  /// Whether to generate encoder method.
  final bool createEncoder;

  /// Whether to generate decoder method.
  final bool createDecoder;

  /// Whether to generate golden mask validation.
  final bool useGoldenMask;

  /// Field renaming convention.
  final FieldRename fieldRename;

  /// Descriptors for all constructor parameters.
  final List<FieldDescriptor> fields;

  /// Descriptors for required fields participating in golden mask.
  final List<FieldDescriptor> requiredFields;

  /// All registered keys in the pre-compiled `JsonKeyOptions` table.
  final List<String> allOptionsKeys;

  ModelDescriptor({
    required this.element,
    required this.className,
    required this.createEncoder,
    required this.createDecoder,
    required this.useGoldenMask,
    required this.fieldRename,
    required this.fields,
    required this.requiredFields,
    required this.allOptionsKeys,
  });

  /// Whether all non-ignored fields in this model are homogeneous, non-nullable
  /// double primitives.
  bool get isUniformDoubleModel {
    final activeFields = fields.where((f) => !f.ignore).toList();
    if (activeFields.isEmpty) return false;
    return activeFields.every(
      (f) =>
          (f.category == TypeCategory.primitiveDouble ||
              f.category == TypeCategory.primitiveNum ||
              f.type.isDartCoreDouble ||
              f.type.isDartCoreNum) &&
          !f.isNullable &&
          f.customDecoderCode == null &&
          f.tupleLength == null,
    );
  }
}
