// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:source_gen/source_gen.dart';
import 'package:source_helper/source_helper.dart';

import 'field_descriptor.dart';

/// TypeChecker for [@Codable].
const codableTypeChecker = TypeChecker.fromUrl(
  'package:codable/src/contracts/codable.dart#Codable',
);

/// TypeChecker for `Decodable`.
const decodableTypeChecker = TypeChecker.fromUrl(
  'package:codable/src/contracts/codable.dart#Decodable',
);

/// TypeChecker for `Encodable`.
const encodableTypeChecker = TypeChecker.fromUrl(
  'package:codable/src/contracts/codable.dart#Encodable',
);

/// TypeChecker for [@CodableKey].
const codableKeyTypeChecker = TypeChecker.fromUrl(
  'package:codable/src/contracts/annotations.dart#CodableKey',
);

/// TypeChecker for [@CodableTuple].
const codableTupleTypeChecker = TypeChecker.fromUrl(
  'package:codable/src/contracts/annotations.dart#CodableTuple',
);

/// Categories of `dart:typed_data` list types supported by `codable_builder`.
enum TypedDataKind {
  /// `Uint8List` binary byte buffers (`readBytes` / `encodeBytes`).
  uint8Bytes,

  /// `Float64List` unboxed 64-bit float lists.
  float64,

  /// `Float32List` 32-bit float lists.
  float32,

  /// Fixed-width integer `TypedData` lists (`Int8List`, `Int16List`,
  /// `Int32List`, `Int64List`, `Uint8ClampedList`, `Uint16List`, `Uint32List`,
  /// `Uint64List`).
  intList,
}

/// Classifies [type] if it is one of the supported `dart:typed_data` list
/// types.
TypedDataKind? classifyTypedDataKind(DartType? type) {
  final element = type?.element;
  if (element == null) return null;
  final libUri = element.library?.uri.toString();
  if (libUri != null && libUri != 'dart:typed_data') return null;
  return switch (element.name) {
    'Uint8List' => TypedDataKind.uint8Bytes,
    'Float64List' => TypedDataKind.float64,
    'Float32List' => TypedDataKind.float32,
    'Int8List' ||
    'Int16List' ||
    'Int32List' ||
    'Int64List' ||
    'Uint8ClampedList' ||
    'Uint16List' ||
    'Uint32List' ||
    'Uint64List' => TypedDataKind.intList,
    _ => null,
  };
}

/// Whether [type] is a valid numeric list target for `@CodableTuple(N)`.
bool isNumericTupleTargetType(DartType type) {
  final tdKind = classifyTypedDataKind(type);
  if (tdKind != null) return tdKind != TypedDataKind.uint8Bytes;
  if (!type.isDartCoreList && type.element?.name != 'List') return false;
  final elem = type is InterfaceType && type.typeArguments.length == 1
      ? type.typeArguments.first
      : null;
  return elem != null &&
      !elem.isNullableType &&
      (elem.isDartCoreInt || elem.isDartCoreDouble);
}

/// Whether [type] is an integer list or integer `TypedData` target for
/// `@CodableTuple(N)`.
bool isIntegerTupleTargetType(DartType type) {
  final tdKind = classifyTypedDataKind(type);
  if (tdKind != null) {
    return tdKind == TypedDataKind.intList;
  }
  if (!type.isDartCoreList && type.element?.name != 'List') return false;
  final elem = type is InterfaceType && type.typeArguments.length == 1
      ? type.typeArguments.first
      : null;
  return elem != null && !elem.isNullableType && elem.isDartCoreInt;
}

/// Result record for [TypeClassifier.classify].
typedef TypeClassification = ({
  TypeCategory category,
  TypeCategory nativeCategory,
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
    String? customEncoderCode,
  }) {
    final native = _classifyNative(type, tupleLength: tupleLength);
    if (customDecoderCode != null || customEncoderCode != null) {
      return (
        category: TypeCategory.custom,
        nativeCategory: native.category,
        elementType: native.elementType,
        mapKeyType: native.mapKeyType,
        mapValueType: native.mapValueType,
        enumConstants: native.enumConstants,
      );
    }
    return native;
  }

  TypeClassification _classifyNative(DartType type, {int? tupleLength}) {
    final primitive = _classifyPrimitive(type);
    if (primitive != null) {
      return _emptyClassification(primitive);
    }

    final enumClassification = _classifyEnum(type);
    if (enumClassification != null) return enumClassification;

    final element = type.element;
    final collection = _classifyCollection(type, element);
    if (collection != null) {
      return _applyTupleToCollection(collection, type, tupleLength);
    }

    final typedData = _classifyTypedData(type, tupleLength);
    if (typedData != null) return typedData;

    if (element != null && isCodableElement(element)) {
      return _emptyClassification(TypeCategory.nestedCodable);
    }

    return _emptyClassification(TypeCategory.unknown);
  }

  static TypeClassification _applyTupleToCollection(
    TypeClassification collection,
    DartType type,
    int? tupleLength,
  ) {
    if (tupleLength == null ||
        tupleLength <= 0 ||
        !isNumericTupleTargetType(type)) {
      return collection;
    }
    return (
      category: TypeCategory.tuple,
      nativeCategory: TypeCategory.tuple,
      elementType: collection.elementType,
      mapKeyType: null,
      mapValueType: null,
      enumConstants: null,
    );
  }

  static TypeClassification _emptyClassification(TypeCategory category) => (
    category: category,
    nativeCategory: category,
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

  static TypeClassification? _classifyEnum(DartType type) {
    if (!type.isEnum) return null;
    final constants = type.enumConstants
        .map((f) => f.name)
        .whereType<String>()
        .toList();
    return (
      category: TypeCategory.enumType,
      nativeCategory: TypeCategory.enumType,
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
        nativeCategory: TypeCategory.list,
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
        nativeCategory: TypeCategory.set,
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
        nativeCategory: TypeCategory.map,
        elementType: null,
        mapKeyType: keyType,
        mapValueType: valType,
        enumConstants: null,
      );
    }
    return null;
  }

  static TypeClassification? _classifyTypedData(
    DartType type,
    int? tupleLength,
  ) {
    final tdKind = classifyTypedDataKind(type);
    if (tdKind == null) return null;
    final elemType = type is InterfaceType
        ? type.allSupertypes
              .where((s) => s.isDartCoreList && s.typeArguments.isNotEmpty)
              .map((s) => s.typeArguments.first)
              .firstOrNull
        : null;
    final category =
        (tupleLength != null &&
            tupleLength > 0 &&
            tdKind != TypedDataKind.uint8Bytes)
        ? TypeCategory.tuple
        : TypeCategory.list;
    return (
      category: category,
      nativeCategory: category,
      elementType: elemType,
      mapKeyType: null,
      mapValueType: null,
      enumConstants: null,
    );
  }

  /// Whether [element] has a `@Codable` annotation.
  bool isCodableElement(Element element) {
    return codableTypeChecker.hasAnnotationOf(element);
  }
}
