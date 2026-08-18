// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// ignore_for_file: deprecated_member_use

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:codable/codable.dart';
import 'package:source_gen/source_gen.dart';

import 'field_descriptor.dart';

/// TypeChecker for [@Codable].
const codableTypeChecker = TypeChecker.fromRuntime(Codable);

/// TypeChecker for [@CodableKey].
const codableKeyTypeChecker = TypeChecker.fromRuntime(CodableKey);

/// TypeChecker for [@CodableTuple].
const codableTupleTypeChecker = TypeChecker.fromRuntime(CodableTuple);

/// Classifies DartTypes into high-level [TypeCategory] for code generation.
final class TypeClassifier {
  const TypeClassifier();

  /// Classifies [type] and returns all nested metadata.
  ({
    TypeCategory category,
    DartType? elementType,
    DartType? mapKeyType,
    DartType? mapValueType,
    List<String>? enumConstants,
  })
  classify(DartType type, {int? tupleLength, String? customDecoderCode}) {
    if (customDecoderCode != null) {
      return (
        category: TypeCategory.custom,
        elementType: null,
        mapKeyType: null,
        mapValueType: null,
        enumConstants: null,
      );
    }

    if (tupleLength != null && tupleLength > 0) {
      return (
        category: TypeCategory.tuple,
        elementType: null,
        mapKeyType: null,
        mapValueType: null,
        enumConstants: null,
      );
    }

    if (type.isDartCoreInt) {
      return (
        category: TypeCategory.primitiveInt,
        elementType: null,
        mapKeyType: null,
        mapValueType: null,
        enumConstants: null,
      );
    }

    if (type.isDartCoreDouble) {
      return (
        category: TypeCategory.primitiveDouble,
        elementType: null,
        mapKeyType: null,
        mapValueType: null,
        enumConstants: null,
      );
    }

    if (type.isDartCoreNum) {
      return (
        category: TypeCategory.primitiveNum,
        elementType: null,
        mapKeyType: null,
        mapValueType: null,
        enumConstants: null,
      );
    }

    if (type.isDartCoreString) {
      return (
        category: TypeCategory.primitiveString,
        elementType: null,
        mapKeyType: null,
        mapValueType: null,
        enumConstants: null,
      );
    }

    if (type.isDartCoreBool) {
      return (
        category: TypeCategory.primitiveBool,
        elementType: null,
        mapKeyType: null,
        mapValueType: null,
        enumConstants: null,
      );
    }

    final element = type.element;
    if (element is EnumElement) {
      final constants = element.fields
          .where((f) => f.isEnumConstant)
          .map((f) => f.name)
          .whereType<String>()
          .toList();
      return (
        category: TypeCategory.enumType,
        elementType: null,
        mapKeyType: null,
        mapValueType: null,
        enumConstants: constants,
      );
    }

    if (type.isDartCoreList || (element != null && element.name == 'List')) {
      final elemType = type is InterfaceType && type.typeArguments.isNotEmpty
          ? type.typeArguments.first
          : null;
      return (
        category: TypeCategory.list,
        elementType: elemType,
        mapKeyType: null,
        mapValueType: null,
        enumConstants: null,
      );
    }

    if (type.isDartCoreSet || (element != null && element.name == 'Set')) {
      final elemType = type is InterfaceType && type.typeArguments.isNotEmpty
          ? type.typeArguments.first
          : null;
      return (
        category: TypeCategory.set,
        elementType: elemType,
        mapKeyType: null,
        mapValueType: null,
        enumConstants: null,
      );
    }

    if (type.isDartCoreMap || (element != null && element.name == 'Map')) {
      final keyType = type is InterfaceType && type.typeArguments.isNotEmpty
          ? type.typeArguments[0]
          : null;
      final valType = type is InterfaceType && type.typeArguments.length > 1
          ? type.typeArguments[1]
          : null;
      return (
        category: TypeCategory.map,
        elementType: null,
        mapKeyType: keyType,
        mapValueType: valType,
        enumConstants: null,
      );
    }

    // Typed data Float64List, Int32List, etc.
    if (element != null &&
        (element.name == 'Float64List' ||
            element.name == 'Float32List' ||
            element.name == 'Int32List' ||
            element.name == 'Uint8List')) {
      if (tupleLength != null) {
        return (
          category: TypeCategory.tuple,
          elementType: null,
          mapKeyType: null,
          mapValueType: null,
          enumConstants: null,
        );
      }
      return (
        category: TypeCategory.list,
        elementType: null,
        mapKeyType: null,
        mapValueType: null,
        enumConstants: null,
      );
    }

    if (element != null && isCodableElement(element)) {
      return (
        category: TypeCategory.nestedCodable,
        elementType: null,
        mapKeyType: null,
        mapValueType: null,
        enumConstants: null,
      );
    }

    return (
      category: TypeCategory.unknown,
      elementType: null,
      mapKeyType: null,
      mapValueType: null,
      enumConstants: null,
    );
  }

  /// Whether [element] has a `@Codable` annotation.
  bool isCodableElement(Element element) {
    return codableTypeChecker.hasAnnotationOf(element);
  }

  /// Whether [type] is nullable.
  bool isNullable(DartType type) {
    return type.nullabilitySuffix == NullabilitySuffix.question ||
        type is DynamicType;
  }
}
