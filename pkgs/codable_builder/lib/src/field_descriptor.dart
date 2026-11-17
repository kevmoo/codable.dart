// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:codable/codable.dart';

import 'utils.dart';

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
  typeParameter,
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

  /// The underlying native type category (ignoring custom codecs).
  final TypeCategory nativeCategory;

  /// Whether this parameter is positional in the primary constructor.
  final bool isPositional;

  /// Whether this parameter is named in the primary constructor.
  final bool isNamed;

  /// Whether this parameter is required (non-optional positional or required
  /// named).
  final bool isRequired;

  /// Whether the field is nullable (`T?` or `dynamic`).
  final bool isNullable;

  /// Whether the field type may evaluate to `null` at runtime (either
  /// explicitly nullable `T?` or an unbounded/nullable-bounded type parameter
  /// `T`).
  final bool isPotentiallyNullable;

  /// Whether a default value is defined.
  final bool hasDefaultValue;

  /// The source code representation of the default value.
  final String? defaultValueCode;

  /// Whether this field is ignored during serialization/deserialization.
  final bool ignore;

  /// Revived custom decoder expression (e.g. `const ZipCodeDecoder()`).
  final String? customDecoderCode;

  /// Revived custom encoder expression (e.g. `const ZipCodeDecoder()`).
  final String? customEncoderCode;

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

  /// Disambiguated PascalCase identifier suffix for `_$Schema` field constants.
  final String schemaSuffix;

  /// Disambiguated PascalCase identifier suffixes for `_$Schema` alias
  /// constants.
  final List<String> aliasSchemaSuffixes;

  FieldDescriptor({
    required this.name,
    required this.wireName,
    required this.aliases,
    required this.type,
    required this.category,
    TypeCategory? nativeCategory,
    required this.isPositional,
    required this.isNamed,
    required this.isRequired,
    required this.isNullable,
    bool? isPotentiallyNullable,
    required this.hasDefaultValue,
    this.defaultValueCode,
    required this.ignore,
    this.customDecoderCode,
    this.customEncoderCode,
    this.tupleLength,
    this.elementType,
    this.mapKeyType,
    this.mapValueType,
    this.enumConstants,
    this.reqBitIndex,
    required this.keyIndex,
    required this.aliasIndices,
    String? schemaSuffix,
    List<String>? aliasSchemaSuffixes,
  }) : nativeCategory = nativeCategory ?? category,
       isPotentiallyNullable = isPotentiallyNullable ?? isNullable,
       schemaSuffix = schemaSuffix ?? toSafeIdentifierSuffix(name),
       aliasSchemaSuffixes =
           aliasSchemaSuffixes ??
           [
             for (final alias in aliases)
               '${schemaSuffix ?? toSafeIdentifierSuffix(name)}'
                   '${toSafeIdentifierSuffix(alias)}',
           ];

  /// Whether this field is a type parameter without an explicit `?` suffix
  /// whose bound still permits `null` (e.g. `final T data` on `Envelope<T>`).
  bool get isUnboundedTypeParameter =>
      !isNullable &&
      isPotentiallyNullable &&
      (category == TypeCategory.typeParameter ||
          (category == TypeCategory.custom &&
              nativeCategory == TypeCategory.typeParameter));

  /// Whether this field participates in golden mask validation.
  bool get participatesInGoldenMask =>
      !ignore &&
      isRequired &&
      !isNullable &&
      !hasDefaultValue &&
      reqBitIndex != null;
}

/// Metadata descriptor for a class type parameter on a generic `@Codable()`
/// model.
final class TypeParameterDescriptor {
  /// The analyzer [TypeParameterElement].
  final TypeParameterElement element;

  /// The type parameter identifier (e.g. `T`).
  final String name;

  /// Explicit non-`Object?` bound display string (e.g. `num`), or `null` if
  /// unbounded.
  final String? boundCode;

  /// Private codec field identifier on the generated companion class (e.g.
  /// `_$t`).
  final String codecFieldName;

  const TypeParameterDescriptor({
    required this.element,
    required this.name,
    this.boundCode,
    required this.codecFieldName,
  });

  /// Formal type parameter declaration fragment (e.g. `T` or `T extends num`).
  String get declarationCode =>
      boundCode == null ? name : '$name extends $boundCode';
}

/// Metadata descriptor for a concrete subtype of a polymorphic `@Codable()`
/// base class.
final class PolymorphicSubtypeDescriptor {
  /// The concrete subtype's [ClassElement].
  final ClassElement element;

  /// The concrete subtype's simple class name (e.g. `Car`).
  final String className;

  /// Wire string value written/matched under `discriminatorKey` (e.g. `'car'`).
  final String discriminatorValue;

  /// Disambiguated PascalCase identifier suffix for `_$Schema` constants.
  final String schemaSuffix;

  /// Type arguments passed to [className] in terms of the polymorphic base
  /// class's type parameters (e.g. `[T]` for `Ok<T> extends Result<T>`, or
  /// empty for `Err extends Result<Never>`).
  final List<DartType> typeArguments;

  /// Whether the subtype's `@Codable` generates a decoder.
  final bool subtypeCreatesDecoder;

  /// Whether the subtype's `@Codable` generates an encoder.
  final bool subtypeCreatesEncoder;

  const PolymorphicSubtypeDescriptor({
    required this.element,
    required this.className,
    required this.discriminatorValue,
    required this.schemaSuffix,
    this.typeArguments = const [],
    this.subtypeCreatesDecoder = true,
    this.subtypeCreatesEncoder = true,
  });

  /// Type application suffix (`''` or `'<T>'`).
  String get typeArgsCode => typeArguments.isEmpty
      ? ''
      : '<${typeArguments.map((t) => t.getDisplayString()).join(', ')}>';

  /// Instantiated Dart type name (e.g. `Car` or `Ok<T>`).
  String get instantiatedTypeCode => '$className$typeArgsCode';
}

/// Metadata descriptor for a `@Codable()` annotated class.
final class ModelDescriptor {
  /// The analyzer [ClassElement].
  final ClassElement element;

  /// The Dart class name (without type parameters).
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

  /// Whether the selected primary constructor is `const`.
  final bool isConstConstructor;

  /// Declared type parameters on a generic `@Codable()` model.
  final List<TypeParameterDescriptor> typeParameters;

  /// Wire property name used as subtype discriminator when this model is a
  /// polymorphic base class, or `null` for concrete models.
  final String? discriminatorKey;

  /// Registered concrete subtypes when [isPolymorphic] is `true`.
  final List<PolymorphicSubtypeDescriptor> polymorphicSubtypes;

  /// Whether [element] is a Dart `sealed class` (enabling exhaustive switches
  /// without a wildcard branch).
  final bool isSealed;

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
    this.isConstConstructor = false,
    this.typeParameters = const [],
    this.discriminatorKey,
    this.polymorphicSubtypes = const [],
    this.isSealed = false,
  });

  /// Whether this class declares generic type parameters.
  bool get isGeneric => typeParameters.isNotEmpty;

  /// Whether this class is a polymorphic discriminator base class.
  bool get isPolymorphic => discriminatorKey != null;

  /// Type parameter declaration clause (`''` or `'<T, U extends num>'`).
  String get typeParamsDeclaration => typeParameters.isEmpty
      ? ''
      : '<${typeParameters.map((p) => p.declarationCode).join(', ')}>';

  /// Type argument application clause (`''` or `'<T, U>'`).
  String get typeArgsApplication => typeParameters.isEmpty
      ? ''
      : '<${typeParameters.map((p) => p.name).join(', ')}>';

  /// Instantiated class name (`Point` or `Envelope<T>`).
  String get instantiatedClassName => '$className$typeArgsApplication';

  /// Looks up the companion codec field name (e.g. `_$t`) for [paramElement].
  String? codecFieldFor(Element? paramElement) {
    if (paramElement == null) return null;
    final target = paramElement.baseElement;
    for (final tp in typeParameters) {
      if (tp.element.baseElement == target || tp.name == paramElement.name) {
        return tp.codecFieldName;
      }
    }
    return null;
  }

  /// Whether all non-ignored fields in this model are homogeneous, non-nullable
  /// double primitives.
  bool get isUniformDoubleModel {
    if (isPolymorphic) return false;
    final activeFields = fields.where((f) => !f.ignore).toList();
    if (activeFields.isEmpty) return false;
    return activeFields.every(
      (f) =>
          (f.category == TypeCategory.primitiveDouble ||
              f.type.isDartCoreDouble) &&
          !f.isNullable &&
          f.customDecoderCode == null &&
          f.customEncoderCode == null &&
          f.tupleLength == null,
    );
  }
}
