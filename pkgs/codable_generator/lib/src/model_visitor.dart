// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// ignore_for_file: deprecated_member_use

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:codable/codable.dart';
import 'package:source_gen/source_gen.dart';

import 'field_descriptor.dart';
import 'type_helper.dart';
import 'utils.dart';

/// Visitor and metadata extractor for [@Codable] annotated classes.
final class ModelVisitor {
  final TypeClassifier _typeClassifier;

  const ModelVisitor({TypeClassifier typeClassifier = const TypeClassifier()})
    : _typeClassifier = typeClassifier;

  /// Inspects [element] and [annotation], returning a validated [ModelDescriptor].
  ModelDescriptor visitClass(ClassElement element, ConstantReader annotation) {
    final createEncoder = annotation.peek('createEncoder')?.boolValue ?? true;
    final createDecoder = annotation.peek('createDecoder')?.boolValue ?? true;
    final useGoldenMask = annotation.peek('useGoldenMask')?.boolValue ?? true;
    final fieldRename = _extractFieldRename(annotation);

    final constructor =
        element.unnamedConstructor ?? element.constructors.firstOrNull;
    if (constructor == null) {
      throw InvalidGenerationSourceError(
        'Class "${element.name}" does not have any constructors.',
        element: element,
      );
    }

    final rawFields = <_RawFieldData>[];

    for (final param in constructor.parameters) {
      final field =
          element.getField(param.name) ?? element.getGetter(param.name);

      // Check annotations on parameter first, then on field
      final paramKeyAnnotation = codableKeyTypeChecker.firstAnnotationOf(param);
      final fieldKeyAnnotation =
          field != null ? codableKeyTypeChecker.firstAnnotationOf(field) : null;
      final keyAnnotation = paramKeyAnnotation ?? fieldKeyAnnotation;
      final keyReader =
          keyAnnotation != null ? ConstantReader(keyAnnotation) : null;

      final paramTupleAnnotation = codableTupleTypeChecker.firstAnnotationOf(
        param,
      );
      final fieldTupleAnnotation =
          field != null
              ? codableTupleTypeChecker.firstAnnotationOf(field)
              : null;
      final tupleAnnotation = paramTupleAnnotation ?? fieldTupleAnnotation;
      final tupleReader =
          tupleAnnotation != null ? ConstantReader(tupleAnnotation) : null;

      final customName = keyReader?.peek('name')?.stringValue;
      final aliases =
          keyReader
              ?.peek('aliases')
              ?.listValue
              .map((o) => o.toStringValue())
              .whereType<String>()
              .toList() ??
          const <String>[];
      final ignore = keyReader?.peek('ignore')?.boolValue ?? false;
      final customDecoderCode = _extractCustomDecoder(keyReader);
      final customDefaultValue =
          keyReader?.peek('defaultValue')?.literalValue?.toString();
      final tupleLength = tupleReader?.peek('length')?.intValue;

      final defaultValueCode =
          param.hasDefaultValue ? param.defaultValueCode : customDefaultValue;
      final hasDefaultValue =
          param.hasDefaultValue || customDefaultValue != null;
      final isRequired = param.isRequired;

      // P1.4 Ignored Required Field Validation
      if (ignore && isRequired && !hasDefaultValue) {
        throw InvalidGenerationSourceError(
          'The parameter "${param.name}" is required but marked with '
          '@CodableKey(ignore: true). Ignored parameters must have a default value or be optional.',
          element: param,
        );
      }

      final wireName = customName ?? applyFieldRename(param.name, fieldRename);
      final isNullable = _typeClassifier.isNullable(param.type);

      final classified = _typeClassifier.classify(
        param.type,
        tupleLength: tupleLength,
        customDecoderCode: customDecoderCode,
      );

      rawFields.add(
        _RawFieldData(
          param: param,
          name: param.name,
          wireName: wireName,
          aliases: aliases,
          type: param.type,
          category: classified.category,
          isPositional: param.isPositional,
          isNamed: param.isNamed,
          isRequired: isRequired,
          isNullable: isNullable,
          hasDefaultValue: hasDefaultValue,
          defaultValueCode: defaultValueCode,
          ignore: ignore,
          customDecoderCode: customDecoderCode,
          tupleLength: tupleLength,
          elementType: classified.elementType,
          mapKeyType: classified.mapKeyType,
          mapValueType: classified.mapValueType,
          enumConstants: classified.enumConstants,
        ),
      );
    }

    // Required fields participating in golden mask (P0.1)
    final requiredFields =
        rawFields
            .where((f) => !f.ignore && f.isRequired && !f.hasDefaultValue)
            .toList();

    // P0.1 Fail-Fast 62-Bit Limit
    if (requiredFields.length > 62) {
      throw InvalidGenerationSourceError(
        'Class "${element.name}" has ${requiredFields.length} required fields '
        'without defaults, which exceeds the maximum golden mask limit of 62.',
        element: element,
      );
    }

    // Assign reqBitIndex strictly to required fields without defaults
    final reqBitMap = <String, int>{};
    for (var i = 0; i < requiredFields.length; i++) {
      reqBitMap[requiredFields[i].name] = i;
    }

    // Build options keys list and assign indices
    final allOptionsKeys = <String>[];
    final processedFields = <FieldDescriptor>[];

    for (final raw in rawFields) {
      if (raw.ignore) {
        processedFields.add(
          FieldDescriptor(
            name: raw.name,
            wireName: raw.wireName,
            aliases: raw.aliases,
            type: raw.type,
            category: raw.category,
            isPositional: raw.isPositional,
            isNamed: raw.isNamed,
            isRequired: raw.isRequired,
            isNullable: raw.isNullable,
            hasDefaultValue: raw.hasDefaultValue,
            defaultValueCode: raw.defaultValueCode,
            ignore: true,
            customDecoderCode: raw.customDecoderCode,
            tupleLength: raw.tupleLength,
            elementType: raw.elementType,
            mapKeyType: raw.mapKeyType,
            mapValueType: raw.mapValueType,
            enumConstants: raw.enumConstants,
            reqBitIndex: null,
            keyIndex: -1,
            aliasIndices: const [],
          ),
        );
        continue;
      }

      final keyIndex = allOptionsKeys.length;
      allOptionsKeys.add(raw.wireName);

      final aliasIndices = <int>[];
      for (final alias in raw.aliases) {
        aliasIndices.add(allOptionsKeys.length);
        allOptionsKeys.add(alias);
      }

      processedFields.add(
        FieldDescriptor(
          name: raw.name,
          wireName: raw.wireName,
          aliases: raw.aliases,
          type: raw.type,
          category: raw.category,
          isPositional: raw.isPositional,
          isNamed: raw.isNamed,
          isRequired: raw.isRequired,
          isNullable: raw.isNullable,
          hasDefaultValue: raw.hasDefaultValue,
          defaultValueCode: raw.defaultValueCode,
          ignore: false,
          customDecoderCode: raw.customDecoderCode,
          tupleLength: raw.tupleLength,
          elementType: raw.elementType,
          mapKeyType: raw.mapKeyType,
          mapValueType: raw.mapValueType,
          enumConstants: raw.enumConstants,
          reqBitIndex: reqBitMap[raw.name],
          keyIndex: keyIndex,
          aliasIndices: aliasIndices,
        ),
      );
    }

    final processedRequiredFields =
        processedFields.where((f) => f.participatesInGoldenMask).toList();

    return ModelDescriptor(
      element: element,
      className: element.name,
      createEncoder: createEncoder,
      createDecoder: createDecoder,
      useGoldenMask: useGoldenMask,
      fieldRename: fieldRename,
      fields: processedFields,
      requiredFields: processedRequiredFields,
      allOptionsKeys: allOptionsKeys,
    );
  }

  FieldRename _extractFieldRename(ConstantReader annotation) {
    final reader = annotation.peek('fieldRename');
    if (reader == null || reader.isNull) return FieldRename.none;
    final index = reader.peek('index')?.intValue;
    if (index != null && index >= 0 && index < FieldRename.values.length) {
      return FieldRename.values[index];
    }
    return FieldRename.none;
  }

  String? _extractCustomDecoder(ConstantReader? reader) {
    if (reader == null) return null;
    final customDecoderReader = reader.peek('customDecoder');
    if (customDecoderReader == null || customDecoderReader.isNull) return null;

    if (customDecoderReader.isType) {
      return 'const ${customDecoderReader.typeValue.getDisplayString()}()';
    }

    final revivable = customDecoderReader.revive();
    final typeName = customDecoderReader.objectValue.type?.getDisplayString();
    if (typeName != null) {
      final accessor =
          revivable.accessor.isEmpty ? '' : '.${revivable.accessor}';
      return 'const $typeName$accessor()';
    }

    if (revivable.accessor.isNotEmpty) {
      return revivable.accessor;
    }
    return null;
  }
}

final class _RawFieldData {
  final ParameterElement param;
  final String name;
  final String wireName;
  final List<String> aliases;
  final DartType type;
  final TypeCategory category;
  final bool isPositional;
  final bool isNamed;
  final bool isRequired;
  final bool isNullable;
  final bool hasDefaultValue;
  final String? defaultValueCode;
  final bool ignore;
  final String? customDecoderCode;
  final int? tupleLength;
  final DartType? elementType;
  final DartType? mapKeyType;
  final DartType? mapValueType;
  final List<String>? enumConstants;

  _RawFieldData({
    required this.param,
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
  });
}
