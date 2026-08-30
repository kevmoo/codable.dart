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

/// Result record for [TypeClassifier.classify].
typedef TypeClassification = ({
  TypeCategory category,
  DartType? elementType,
  DartType? mapKeyType,
  DartType? mapValueType,
  List<String>? enumConstants,
});

/// Classifies DartTypes into high-level [TypeCategory] for code generation.
final class TypeClassifier {
  const TypeClassifier();

  /// Classifies [type] and returns all nested metadata.
  TypeClassification classify(
    DartType type, {
    int? tupleLength,
    String? customDecoderCode,
  }) {
    if (customDecoderCode != null) {
      return _emptyClassification(TypeCategory.custom);
    }

    if (tupleLength != null && tupleLength > 0) {
      return _emptyClassification(TypeCategory.tuple);
    }

    final primitive = _classifyPrimitive(type);
    if (primitive != null) {
      return _emptyClassification(primitive);
    }

    final element = type.element;
    final enumClassification = _classifyEnum(element);
    if (enumClassification != null) return enumClassification;

    final collection = _classifyCollection(type, element);
    if (collection != null) return collection;

    final typedData = _classifyTypedData(element, tupleLength);
    if (typedData != null) return typedData;

    if (element != null && isCodableElement(element)) {
      return _emptyClassification(TypeCategory.nestedCodable);
    }

    return _emptyClassification(TypeCategory.unknown);
  }

  static TypeClassification _emptyClassification(TypeCategory category) => (
    category: category,
    elementType: null,
    mapKeyType: null,
    mapValueType: null,
    enumConstants: null,
  );

  static TypeCategory? _classifyPrimitive(DartType type) {
    if (type.isDartCoreInt) return TypeCategory.primitiveInt;
    if (type.isDartCoreDouble) return TypeCategory.primitiveDouble;
    if (type.isDartCoreNum) return TypeCategory.primitiveNum;
    if (type.isDartCoreString) return TypeCategory.primitiveString;
    if (type.isDartCoreBool) return TypeCategory.primitiveBool;
    return null;
  }

  static TypeClassification? _classifyEnum(Element? element) {
    if (element is! EnumElement) return null;
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

  static TypeClassification? _classifyCollection(
    DartType type,
    Element? element,
  ) =>
      _classifyList(type, element) ??
      _classifySet(type, element) ??
      _classifyMap(type, element);

  static TypeClassification? _classifyList(DartType type, Element? element) {
    if (type.isDartCoreList || element?.name == 'List') {
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
    return null;
  }

  static TypeClassification? _classifySet(DartType type, Element? element) {
    if (type.isDartCoreSet || element?.name == 'Set') {
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
    return null;
  }

  static TypeClassification? _classifyMap(DartType type, Element? element) {
    if (type.isDartCoreMap || element?.name == 'Map') {
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
    return null;
  }

  static TypeClassification? _classifyTypedData(
    Element? element,
    int? tupleLength,
  ) {
    const typedDataNames = {
      'Float64List',
      'Float32List',
      'Int64List',
      'Int32List',
      'Int16List',
      'Int8List',
      'Uint64List',
      'Uint32List',
      'Uint16List',
      'Uint8List',
      'Uint8ClampedList',
    };
    if (element == null || !typedDataNames.contains(element.name)) return null;
    return (
      category: tupleLength != null ? TypeCategory.tuple : TypeCategory.list,
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
