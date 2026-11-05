// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:codable/codable.dart';
import 'package:source_gen/source_gen.dart';
import 'package:source_helper/source_helper.dart';

import 'field_descriptor.dart';
import 'type_helper.dart';
import 'utils.dart';

/// Visitor and metadata extractor for [@Codable] annotated classes.
final class ModelVisitor {
  final TypeClassifier _typeClassifier;

  const ModelVisitor({this._typeClassifier = const TypeClassifier()});

  /// Inspects [element] and [annotation], returning a validated
  /// [ModelDescriptor].
  ModelDescriptor visitClass(ClassElement element, ConstantReader annotation) {
    final createEncoder = annotation.peek('createEncoder')?.boolValue ?? true;
    final createDecoder = annotation.peek('createDecoder')?.boolValue ?? true;
    final useGoldenMask = annotation.peek('useGoldenMask')?.boolValue ?? true;
    final fieldRename = _extractFieldRename(annotation);

    final constructor = _selectConstructor(element);

    final rawFields = [
      for (final param in constructor.formalParameters)
        _visitParameter(
          element,
          param,
          createEncoder: createEncoder,
          createDecoder: createDecoder,
          fieldRename: fieldRename,
        ),
    ];

    // Required fields participating in golden mask (P0.1)
    final requiredFields = rawFields
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
    final reqBitMap = <String, int>{
      for (var i = 0; i < requiredFields.length; i++) requiredFields[i].name: i,
    };

    final allOptionsKeys = <String>[];
    final processedFields = _buildFieldDescriptors(
      rawFields,
      reqBitMap,
      allOptionsKeys,
    );

    final processedRequiredFields = processedFields
        .where((f) => f.participatesInGoldenMask)
        .toList();

    return ModelDescriptor(
      element: element,
      className: element.name ?? '',
      createEncoder: createEncoder,
      createDecoder: createDecoder,
      useGoldenMask: useGoldenMask,
      fieldRename: fieldRename,
      fields: processedFields,
      requiredFields: processedRequiredFields,
      allOptionsKeys: allOptionsKeys,
    );
  }

  _RawFieldData _visitParameter(
    ClassElement element,
    FormalParameterElement param, {
    required bool createEncoder,
    required bool createDecoder,
    required FieldRename fieldRename,
  }) {
    final paramName = param.name ?? '';
    final keyReader = _readParameterAnnotation(
      element,
      param,
      paramName,
      codableKeyTypeChecker,
    );
    final tupleReader = _readParameterAnnotation(
      element,
      param,
      paramName,
      codableTupleTypeChecker,
    );

    final customName = keyReader?.peek('name')?.stringValue;
    final aliases = _extractAliases(keyReader);
    final ignore = keyReader?.peek('ignore')?.boolValue ?? false;
    final codableSpec = _extractCodecSpec(keyReader, 'codable');
    final customDecoderSpec = _extractCodecSpec(keyReader, 'customDecoder');
    final customEncoderSpec = _extractCodecSpec(keyReader, 'customEncoder');
    final customDefaultValue = keyReader
        ?.peek('defaultValue')
        ?.literalValue
        ?.toString();
    final tupleLength = tupleReader?.peek('length')?.intValue;

    if (!ignore) {
      _validateCodecSpecs(
        param: param,
        createDecoder: createDecoder,
        createEncoder: createEncoder,
        codableSpec: codableSpec,
        customDecoderSpec: customDecoderSpec,
        customEncoderSpec: customEncoderSpec,
      );
    }

    final customDecoderCode = customDecoderSpec?.code ?? codableSpec?.code;
    final customEncoderCode = _resolveCustomEncoderCode(
      codableSpec: codableSpec,
      customDecoderSpec: customDecoderSpec,
      customEncoderSpec: customEncoderSpec,
    );

    final defaultValueCode = param.hasDefaultValue
        ? param.defaultValueCode
        : customDefaultValue;
    final hasDefaultValue = param.hasDefaultValue || customDefaultValue != null;
    final isRequired = param.isRequired;

    // P1.4 Ignored Required Field Validation
    if (ignore && isRequired && !hasDefaultValue) {
      throw InvalidGenerationSourceError(
        'The parameter "${param.name}" is required but marked with '
        '@CodableKey(ignore: true). Ignored parameters must have a default '
        'value or be optional.',
        element: param,
      );
    }

    final classified = _typeClassifier.classify(
      param.type,
      tupleLength: tupleLength,
      customDecoderCode: customDecoderCode,
      customEncoderCode: customEncoderCode,
    );

    if (!ignore && classified.category == TypeCategory.custom) {
      _validateCustomNativeFallback(
        param: param,
        classified: classified,
        createEncoder: createEncoder,
        createDecoder: createDecoder,
        customEncoderCode: customEncoderCode,
        customDecoderCode: customDecoderCode,
      );
    }

    return _RawFieldData(
      param: param,
      name: paramName,
      wireName: customName ?? applyFieldRename(paramName, fieldRename),
      aliases: aliases,
      type: param.type,
      category: classified.category,
      nativeCategory: classified.nativeCategory,
      isPositional: param.isPositional,
      isNamed: param.isNamed,
      isRequired: isRequired,
      isNullable: param.type.isNullableType,
      hasDefaultValue: hasDefaultValue,
      defaultValueCode: defaultValueCode,
      ignore: ignore,
      customDecoderCode: customDecoderCode,
      customEncoderCode: customEncoderCode,
      tupleLength: tupleLength,
      elementType: classified.elementType,
      mapKeyType: classified.mapKeyType,
      mapValueType: classified.mapValueType,
      enumConstants: classified.enumConstants,
    );
  }

  ConstantReader? _readParameterAnnotation(
    ClassElement element,
    FormalParameterElement param,
    String paramName,
    TypeChecker checker,
  ) {
    final annotation =
        checker.firstAnnotationOf(param) ??
        firstAnnotationOnProperty(element, paramName, checker);
    return annotation != null ? ConstantReader(annotation) : null;
  }

  List<String> _extractAliases(ConstantReader? keyReader) =>
      keyReader
          ?.peek('aliases')
          ?.listValue
          .map((o) => o.toStringValue())
          .whereType<String>()
          .toList() ??
      const <String>[];

  String? _resolveCustomEncoderCode({
    required ({String code, DartType? type})? codableSpec,
    required ({String code, DartType? type})? customDecoderSpec,
    required ({String code, DartType? type})? customEncoderSpec,
  }) {
    if (customEncoderSpec != null) return customEncoderSpec.code;
    if (codableSpec != null) return codableSpec.code;
    final decoderType = customDecoderSpec?.type;
    if (decoderType != null &&
        encodableTypeChecker.isAssignableFromType(decoderType)) {
      return customDecoderSpec!.code;
    }
    return null;
  }

  void _validateCustomNativeFallback({
    required FormalParameterElement param,
    required TypeClassification classified,
    required bool createEncoder,
    required bool createDecoder,
    required String? customEncoderCode,
    required String? customDecoderCode,
  }) {
    if (classified.nativeCategory != TypeCategory.unknown) return;
    if (createEncoder && customEncoderCode == null) {
      throw InvalidGenerationSourceError(
        'Parameter "${param.name}" of type '
        '"${param.type.getDisplayString()}" has a decode-only '
        '@CodableKey(customDecoder: ...) on a class with '
        'createEncoder: true, and "${param.type.getDisplayString()}" is '
        'not natively encodable. Implement Codable/Encodable, pass '
        'customEncoder:, or set @Codable(createEncoder: false).',
        element: param,
      );
    }
    if (createDecoder && customDecoderCode == null) {
      throw InvalidGenerationSourceError(
        'Parameter "${param.name}" of type '
        '"${param.type.getDisplayString()}" has an encode-only '
        '@CodableKey(customEncoder: ...) on a class with '
        'createDecoder: true, and "${param.type.getDisplayString()}" is '
        'not natively decodable. Implement Codable/Decodable, pass '
        'customDecoder:, or set @Codable(createDecoder: false).',
        element: param,
      );
    }
  }

  List<FieldDescriptor> _buildFieldDescriptors(
    List<_RawFieldData> rawFields,
    Map<String, int> reqBitMap,
    List<String> allOptionsKeys,
  ) {
    final processedFields = <FieldDescriptor>[];
    for (final raw in rawFields) {
      var keyIndex = -1;
      var aliasIndices = const <int>[];
      int? reqBitIndex;
      if (!raw.ignore) {
        keyIndex = allOptionsKeys.length;
        allOptionsKeys.add(raw.wireName);
        aliasIndices = [
          for (final alias in raw.aliases) _addOptionKey(allOptionsKeys, alias),
        ];
        reqBitIndex = reqBitMap[raw.name];
      }
      processedFields.add(
        FieldDescriptor(
          name: raw.name,
          wireName: raw.wireName,
          aliases: raw.aliases,
          type: raw.type,
          category: raw.category,
          nativeCategory: raw.nativeCategory,
          isPositional: raw.isPositional,
          isNamed: raw.isNamed,
          isRequired: raw.isRequired,
          isNullable: raw.isNullable,
          hasDefaultValue: raw.hasDefaultValue,
          defaultValueCode: raw.defaultValueCode,
          ignore: raw.ignore,
          customDecoderCode: raw.customDecoderCode,
          customEncoderCode: raw.customEncoderCode,
          tupleLength: raw.tupleLength,
          elementType: raw.elementType,
          mapKeyType: raw.mapKeyType,
          mapValueType: raw.mapValueType,
          enumConstants: raw.enumConstants,
          reqBitIndex: reqBitIndex,
          keyIndex: keyIndex,
          aliasIndices: aliasIndices,
        ),
      );
    }
    return processedFields;
  }

  int _addOptionKey(List<String> allOptionsKeys, String key) {
    final index = allOptionsKeys.length;
    allOptionsKeys.add(key);
    return index;
  }

  ConstructorElement _selectConstructor(ClassElement element) {
    try {
      return constructorByName(element, '');
    } on InvalidGenerationSourceError {
      final fallback = element.constructors.firstOrNull;
      if (fallback != null) {
        return fallback;
      }
      throw InvalidGenerationSourceError(
        'Class "${element.name}" does not have any constructors.',
        element: element,
      );
    }
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

  void _validateCodecSpecs({
    required FormalParameterElement param,
    required bool createDecoder,
    required bool createEncoder,
    required ({String code, DartType? type})? codableSpec,
    required ({String code, DartType? type})? customDecoderSpec,
    required ({String code, DartType? type})? customEncoderSpec,
  }) {
    if (codableSpec != null && codableSpec.type != null) {
      final type = codableSpec.type!;
      if (createDecoder && !decodableTypeChecker.isAssignableFromType(type)) {
        throw InvalidGenerationSourceError(
          'The @CodableKey(codable: ...) on "${param.name}" '
          '(${type.getDisplayString()}) must implement Decodable.',
          element: param,
        );
      }
      if (createEncoder && !encodableTypeChecker.isAssignableFromType(type)) {
        throw InvalidGenerationSourceError(
          'The @CodableKey(codable: ...) on "${param.name}" '
          '(${type.getDisplayString()}) must implement Encodable.',
          element: param,
        );
      }
    }
    if (customDecoderSpec != null &&
        customDecoderSpec.type != null &&
        createDecoder &&
        !decodableTypeChecker.isAssignableFromType(customDecoderSpec.type!)) {
      throw InvalidGenerationSourceError(
        'The @CodableKey(customDecoder: ...) on "${param.name}" '
        '(${customDecoderSpec.type!.getDisplayString()}) must implement '
        'Decodable.',
        element: param,
      );
    }
    if (customEncoderSpec != null &&
        customEncoderSpec.type != null &&
        createEncoder &&
        !encodableTypeChecker.isAssignableFromType(customEncoderSpec.type!)) {
      throw InvalidGenerationSourceError(
        'The @CodableKey(customEncoder: ...) on "${param.name}" '
        '(${customEncoderSpec.type!.getDisplayString()}) must implement '
        'Encodable.',
        element: param,
      );
    }
  }

  ({String code, DartType? type})? _extractCodecSpec(
    ConstantReader? reader,
    String fieldName,
  ) {
    if (reader == null) return null;
    final argReader = reader.peek(fieldName);
    if (argReader == null || argReader.isNull) return null;

    if (argReader.isType) {
      final type = argReader.typeValue;
      return (code: 'const ${type.getDisplayString()}()', type: type);
    }

    final objType = argReader.objectValue.type;
    final revivable = argReader.revive();
    if (revivable.source.fragment.isEmpty && revivable.accessor.isNotEmpty) {
      return (code: revivable.accessor, type: objType);
    }

    final typeName = objType?.getDisplayString();
    if (typeName != null) {
      final accessor = revivable.accessor.isEmpty
          ? ''
          : '.${revivable.accessor}';
      return (code: 'const $typeName$accessor()', type: objType);
    }

    if (revivable.accessor.isNotEmpty) {
      return (code: revivable.accessor, type: objType);
    }
    return null;
  }
}

final class _RawFieldData {
  final FormalParameterElement param;
  final String name;
  final String wireName;
  final List<String> aliases;
  final DartType type;
  final TypeCategory category;
  final TypeCategory nativeCategory;
  final bool isPositional;
  final bool isNamed;
  final bool isRequired;
  final bool isNullable;
  final bool hasDefaultValue;
  final String? defaultValueCode;
  final bool ignore;
  final String? customDecoderCode;
  final String? customEncoderCode;
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
    required this.nativeCategory,
    required this.isPositional,
    required this.isNamed,

    required this.isRequired,
    required this.isNullable,
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
  });
}
