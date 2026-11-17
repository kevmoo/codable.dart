// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:codable/codable.dart';
import 'package:source_gen/source_gen.dart';
import 'package:source_helper/source_helper.dart';

import 'field_descriptor.dart';
import 'polymorphic_helper.dart';
import 'type_helper.dart';
import 'utils.dart';

/// Visitor and metadata extractor for [@Codable] annotated classes.
final class ModelVisitor {
  final TypeClassifier _typeClassifier;
  final PolymorphicModelVisitor _polymorphicVisitor;

  const ModelVisitor({
    this._typeClassifier = const TypeClassifier(),
    this._polymorphicVisitor = const PolymorphicModelVisitor(),
  });

  /// Inspects [element] and [annotation], returning a validated
  /// [ModelDescriptor].
  ModelDescriptor visitClass(ClassElement element, ConstantReader annotation) {
    final createEncoder = annotation.peek('createEncoder')?.boolValue ?? true;
    final createDecoder = annotation.peek('createDecoder')?.boolValue ?? true;
    final useGoldenMask = annotation.peek('useGoldenMask')?.boolValue ?? true;
    final fieldRename = _extractFieldRename(annotation);
    final typeParameters = _extractTypeParameters(element);

    if (_polymorphicVisitor.isPolymorphicClass(element, annotation)) {
      return _polymorphicVisitor.visitPolymorphicClass(
        element: element,
        annotation: annotation,
        createEncoder: createEncoder,
        createDecoder: createDecoder,
        useGoldenMask: useGoldenMask,
        fieldRename: fieldRename,
        typeParameters: typeParameters,
        inspectSubtypeKeys: _inspectClassWireKeys,
      );
    }

    final constructor = _selectConstructor(element);
    if (element.isAbstract && !constructor.isFactory) {
      throw InvalidGenerationSourceError(
        'Abstract class "${element.name}" cannot be instantiated directly. '
        'Mark it "sealed" or specify @Codable(discriminatorKey: ...) for '
        'polymorphic serialization.',
        element: element,
      );
    }

    final enclosingTypeParams = {
      for (final tp in element.typeParameters) tp.baseElement,
    };
    final rawFields = [
      for (final param in constructor.formalParameters)
        _visitParameter(
          element,
          param,
          createEncoder: createEncoder,
          createDecoder: createDecoder,
          fieldRename: fieldRename,
          enclosingTypeParams: enclosingTypeParams,
        ),
    ];

    _validateWireKeysAndAliases(rawFields);

    // Required fields participating in golden mask (P0.1)
    final requiredFields = rawFields
        .where(
          (f) =>
              !f.ignore && f.isRequired && !f.isNullable && !f.hasDefaultValue,
        )
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
      isConstConstructor: constructor.isConst,
      typeParameters: typeParameters,
    );
  }

  List<TypeParameterDescriptor> _extractTypeParameters(ClassElement element) {
    final usedNames = <String>{};
    final result = <TypeParameterDescriptor>[];
    for (final tp in element.typeParameters) {
      final tpName = tp.name ?? 'T';
      final rawCamel = toLowerCamelCase(tpName);
      final fieldSuffix = allocateUniqueSuffix(
        rawCamel.isEmpty ? 't' : rawCamel,
        usedNames,
      );
      final bound = tp.bound;
      final boundCode =
          bound != null && !(bound.isDartCoreObject && bound.isNullableType)
          ? bound.getDisplayString()
          : null;
      result.add(
        TypeParameterDescriptor(
          element: tp,
          name: tpName,
          boundCode: boundCode,
          codecFieldName: '_\$$fieldSuffix',
        ),
      );
    }
    return result;
  }

  List<({String name, String wireName, List<String> aliases})>
  _inspectClassWireKeys(ClassElement subElement, FieldRename subRename) {
    if (subElement.isSealed) return const [];
    final constructor = _selectConstructor(subElement);
    final keys = <({String name, String wireName, List<String> aliases})>[];
    for (final param in constructor.formalParameters) {
      final paramName = param.name ?? '';
      final keyReader =
          _readerFromElementAnnotation(
            _findParameterElementAnnotation(
              subElement,
              param,
              paramName,
              codableKeyTypeChecker,
            ),
          ) ??
          _readParameterAnnotation(
            subElement,
            param,
            paramName,
            codableKeyTypeChecker,
          );
      if (keyReader?.peek('ignore')?.boolValue ?? false) continue;
      final customName = keyReader?.peek('name')?.stringValue;
      keys.add((
        name: paramName,
        wireName: customName ?? applyFieldRename(paramName, subRename),
        aliases: _extractAliases(keyReader),
      ));
    }
    return keys;
  }

  _RawFieldData _visitParameter(
    ClassElement element,
    FormalParameterElement param, {
    required bool createEncoder,
    required bool createDecoder,
    required FieldRename fieldRename,
    required Set<Element> enclosingTypeParams,
  }) {
    final paramName = param.name ?? '';
    final keyElementAnnotation = _findParameterElementAnnotation(
      element,
      param,
      paramName,
      codableKeyTypeChecker,
    );
    final keyReader =
        _readerFromElementAnnotation(keyElementAnnotation) ??
        _readParameterAnnotation(
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
    final customDefaultValue = _extractDefaultValue(
      keyElementAnnotation,
      keyReader,
      param,
    );
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
      if (tupleReader != null) {
        _validateTupleAnnotation(param, tupleLength);
      }
    }

    final customDecoderCode = customDecoderSpec?.code ?? codableSpec?.code;
    final customEncoderCode = _resolveCustomEncoderCode(
      codableSpec: codableSpec,
      customDecoderSpec: customDecoderSpec,
      customEncoderSpec: customEncoderSpec,
    );

    final defaultValueCode =
        customDefaultValue ??
        (param.hasDefaultValue ? param.defaultValueCode : null);
    final hasDefaultValue = customDefaultValue != null || param.hasDefaultValue;
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

    if (!ignore) {
      _validateFieldTypeSupport(
        element: element,
        param: param,
        classified: classified,
        createEncoder: createEncoder,
        createDecoder: createDecoder,
        customEncoderCode: customEncoderCode,
        customDecoderCode: customDecoderCode,
        enclosingTypeParams: enclosingTypeParams,
      );
    }

    final isNullable = param.type.isNullableType;
    final isPotentiallyNullable =
        isNullable ||
        element.library.typeSystem.isPotentiallyNullable(param.type);

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
      isNullable: isNullable,
      isPotentiallyNullable: isPotentiallyNullable,
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

  static ConstantReader? _readerFromElementAnnotation(
    ElementAnnotation? annotation,
  ) {
    final value = annotation?.computeConstantValue();
    return value != null ? ConstantReader(value) : null;
  }

  static ElementAnnotation? _matchingElementAnnotation(
    Element target,
    TypeChecker checker,
  ) {
    for (final meta in target.metadata.annotations) {
      final type = meta.computeConstantValue()?.type;
      if (type != null && checker.isAssignableFromType(type)) {
        return meta;
      }
    }
    return null;
  }

  static ElementAnnotation? _findParameterElementAnnotation(
    ClassElement element,
    FormalParameterElement param,
    String paramName,
    TypeChecker checker,
  ) {
    final direct = _matchingElementAnnotation(param, checker);
    if (direct != null) return direct;
    final fields = createSortedFieldSet(element, includeSetterOnly: true);
    final primary = fields.where((f) => f.name == paramName).firstOrNull;
    if (primary == null) return null;
    for (final candidate in fieldOverrideChain(element, primary)) {
      final match =
          _matchingElementAnnotation(candidate, checker) ??
          (candidate.getter != null
              ? _matchingElementAnnotation(candidate.getter!, checker)
              : null);
      if (match != null) return match;
    }
    return null;
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

  String? _extractDefaultValue(
    ElementAnnotation? keyAnnotation,
    ConstantReader? keyReader,
    FormalParameterElement param,
  ) {
    if (keyReader == null) return null;
    final valueReader = keyReader.peek('defaultValue');
    if (valueReader != null) {
      return _formatConstantReader(valueReader, nested: false, param: param);
    }
    if (!_hasAnnotationArgument(keyAnnotation, 'defaultValue')) {
      return null;
    }
    if (!param.type.isNullableType) {
      throw InvalidGenerationSourceError(
        'Parameter "${param.name}" of non-nullable type '
        '"${param.type.getDisplayString()}" cannot specify '
        '@CodableKey(defaultValue: null).',
        element: param,
      );
    }
    return 'null';
  }

  static bool _hasAnnotationArgument(
    ElementAnnotation? annotation,
    String argumentName,
  ) {
    if (annotation == null) return false;
    final source = annotation.toSource();
    final parsed = parseString(
      content: '$source var x;',
      throwIfDiagnostics: false,
    );
    final args =
        parsed.unit.declarations.firstOrNull?.metadata.firstOrNull?.arguments;
    if (args == null) return false;
    for (final arg in args.arguments) {
      if (arg.beginToken.lexeme == argumentName &&
          arg.beginToken.next?.lexeme == ':') {
        return true;
      }
    }
    return false;
  }

  static String _formatDartObject(
    DartObject object, {
    required bool nested,
    required FormalParameterElement param,
  }) => _formatConstantReader(
    ConstantReader(object),
    nested: nested,
    param: param,
  );

  static String _formatConstantReader(
    ConstantReader reader, {
    required bool nested,
    required FormalParameterElement param,
  }) {
    final scalar = _tryFormatScalarConstant(reader);
    if (scalar != null) return scalar;
    final collection = _tryFormatCollectionConstant(
      reader,
      nested: nested,
      param: param,
    );
    if (collection != null) return collection;
    final record = _tryFormatRecordConstant(
      reader.objectValue,
      nested: nested,
      param: param,
    );
    if (record != null) return record;
    return _formatRevivableConstant(reader, nested: nested, param: param);
  }

  static String? _tryFormatScalarConstant(ConstantReader reader) {
    if (reader.isNull) return 'null';
    if (reader.isBool) return '${reader.boolValue}';
    if (reader.isInt) return '${reader.intValue}';
    if (reader.isDouble) return _formatDoubleLiteral(reader.doubleValue);
    if (reader.isString) return escapeDartString(reader.stringValue);
    if (reader.isSymbol) return '#${reader.objectValue.toSymbolValue()}';
    if (reader.isType) return reader.typeValue.getDisplayString();
    return null;
  }

  static String _formatDoubleLiteral(double value) {
    if (value.isNaN) return 'double.nan';
    if (value.isInfinite) {
      return value.isNegative ? 'double.negativeInfinity' : 'double.infinity';
    }
    return '$value';
  }

  static String _typeArgDisplayAt(DartType? type, int index) =>
      type is InterfaceType && type.typeArguments.length > index
      ? type.typeArguments[index].getDisplayString()
      : 'dynamic';

  static String? _tryFormatCollectionConstant(
    ConstantReader reader, {
    required bool nested,
    required FormalParameterElement param,
  }) {
    if (reader.isList) {
      return _formatListConstant(reader, nested: nested, param: param);
    }
    if (reader.isSet) {
      return _formatSetConstant(reader, nested: nested, param: param);
    }
    if (reader.isMap) {
      return _formatMapConstant(reader, nested: nested, param: param);
    }
    return null;
  }

  static String _formatListConstant(
    ConstantReader reader, {
    required bool nested,
    required FormalParameterElement param,
  }) {
    final items = [
      for (final item in reader.listValue)
        _formatDartObject(item, nested: true, param: param),
    ];
    if (items.isEmpty && nested) {
      final elem = _typeArgDisplayAt(reader.objectValue.type, 0);
      return '<$elem>[]';
    }
    final prefix = nested ? '' : 'const ';
    return '$prefix[${items.join(', ')}]';
  }

  static String _formatSetConstant(
    ConstantReader reader, {
    required bool nested,
    required FormalParameterElement param,
  }) {
    final items = [
      for (final item in reader.setValue)
        _formatDartObject(item, nested: true, param: param),
    ];
    if (items.isEmpty && nested) {
      final elem = _typeArgDisplayAt(reader.objectValue.type, 0);
      return '<$elem>{}';
    }
    final prefix = nested ? '' : 'const ';
    return '$prefix{${items.join(', ')}}';
  }

  static String _formatMapConstant(
    ConstantReader reader, {
    required bool nested,
    required FormalParameterElement param,
  }) {
    final entries = <String>[
      for (final MapEntry(:key, :value) in reader.mapValue.entries)
        if (key != null && value != null)
          '${_formatDartObject(key, nested: true, param: param)}: '
              '${_formatDartObject(value, nested: true, param: param)}',
    ];
    if (entries.isEmpty && nested) {
      final objType = reader.objectValue.type;
      final key = _typeArgDisplayAt(objType, 0);
      final val = _typeArgDisplayAt(objType, 1);
      return '<$key, $val>{}';
    }
    final prefix = nested ? '' : 'const ';
    return '$prefix{${entries.join(', ')}}';
  }

  static String? _tryFormatRecordConstant(
    DartObject object, {
    required bool nested,
    required FormalParameterElement param,
  }) {
    final record = object.toRecordValue();
    if (record == null) return null;
    final pos = [
      for (final item in record.positional)
        _formatDartObject(item, nested: true, param: param),
    ];
    final named = [
      for (final entry in record.named.entries)
        '${entry.key}: ${_formatDartObject(entry.value, nested: true, param: param)}',
    ];
    final trailingComma = pos.length == 1 && named.isEmpty ? ',' : '';
    final prefix = nested ? '' : 'const ';
    return '$prefix(${[...pos, ...named].join(', ')}$trailingComma)';
  }

  static String _formatRevivableConstant(
    ConstantReader reader, {
    required bool nested,
    required FormalParameterElement param,
  }) {
    final revivable = reader.revive();
    if (revivable.isPrivate) {
      throw InvalidGenerationSourceError(
        'Cannot revive private constant "$revivable" for '
        '@CodableKey(defaultValue:) on parameter "${param.name}". '
        'Use a constructor default value (${param.name} = ...) or a constant '
        'with a public constructor.',
        element: param,
      );
    }
    if (revivable.source.fragment.isEmpty && revivable.accessor.isNotEmpty) {
      return revivable.accessor;
    }
    final rawType =
        reader.objectValue.type?.getDisplayString().replaceAll('?', '') ??
        revivable.source.fragment;
    final ctor = revivable.accessor.isEmpty ? '' : '.${revivable.accessor}';
    final pos = [
      for (final arg in revivable.positionalArguments)
        _formatDartObject(arg, nested: true, param: param),
    ];
    final named = [
      for (final entry in revivable.namedArguments.entries)
        '${entry.key}: ${_formatDartObject(entry.value, nested: true, param: param)}',
    ];
    final prefix = nested ? '' : 'const ';
    return '$prefix$rawType$ctor(${[...pos, ...named].join(', ')})';
  }

  static void _validateTupleAnnotation(
    FormalParameterElement param,
    int? tupleLength,
  ) {
    if (tupleLength == null || tupleLength <= 0) {
      throw InvalidGenerationSourceError(
        '@CodableTuple length on parameter "${param.name}" must be greater '
        'than 0, got $tupleLength.',
        element: param,
      );
    }
    if (!isNumericTupleTargetType(param.type)) {
      throw InvalidGenerationSourceError(
        '@CodableTuple($tupleLength) on parameter "${param.name}" requires a '
        'numeric list type (List<int>, List<double>, Float32List, Float64List, '
        'or integer TypedData list), got "${param.type.getDisplayString()}".',
        element: param,
      );
    }
  }

  List<String> _extractAliases(ConstantReader? keyReader) =>
      keyReader
          ?.peek('aliases')
          ?.listValue
          .map((o) => o.toStringValue())
          .whereType<String>()
          .toList() ??
      const <String>[];

  static void _validateWireKeysAndAliases(List<_RawFieldData> rawFields) {
    final ownerByWireKey = <String, String>{};
    for (final raw in rawFields) {
      if (raw.ignore) continue;
      final existingOwner = ownerByWireKey[raw.wireName];
      if (existingOwner != null) {
        throw InvalidGenerationSourceError(
          'Wire key "${raw.wireName}" on parameter "${raw.name}" collides '
          'with parameter "$existingOwner".',
          element: raw.param,
        );
      }
      ownerByWireKey[raw.wireName] = raw.name;
    }
    for (final raw in rawFields) {
      if (!raw.ignore) _validateFieldAliases(raw, ownerByWireKey);
    }
  }

  static void _validateFieldAliases(
    _RawFieldData raw,
    Map<String, String> ownerByWireKey,
  ) {
    final seenInField = <String>{};
    for (final alias in raw.aliases) {
      if (alias == raw.wireName) {
        throw InvalidGenerationSourceError(
          'Alias "$alias" on parameter "${raw.name}" duplicates its own wire '
          'key "${raw.wireName}".',
          element: raw.param,
        );
      }
      if (!seenInField.add(alias)) {
        throw InvalidGenerationSourceError(
          'Duplicate alias "$alias" on parameter "${raw.name}".',
          element: raw.param,
        );
      }
      final existingOwner = ownerByWireKey[alias];
      if (existingOwner != null) {
        throw InvalidGenerationSourceError(
          'Alias "$alias" on parameter "${raw.name}" collides with wire key '
          'or alias on parameter "$existingOwner".',
          element: raw.param,
        );
      }
      ownerByWireKey[alias] = raw.name;
    }
  }

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

  void _validateFieldTypeSupport({
    required ClassElement element,
    required FormalParameterElement param,
    required TypeClassification classified,
    required bool createEncoder,
    required bool createDecoder,
    required String? customEncoderCode,
    required String? customDecoderCode,
    required Set<Element> enclosingTypeParams,
  }) {
    if (classified.category == TypeCategory.custom) {
      _validateCustomNativeFallback(
        param: param,
        classified: classified,
        createEncoder: createEncoder,
        createDecoder: createDecoder,
        customEncoderCode: customEncoderCode,
        customDecoderCode: customDecoderCode,
      );
    }
    final needsNativeDecode = createDecoder && customDecoderCode == null;
    final needsNativeEncode = createEncoder && customEncoderCode == null;
    if (needsNativeDecode || needsNativeEncode) {
      _validateNativeTypeSupport(param.type, (
        enclosingClass: element,
        param: param,
        enclosingTypeParams: enclosingTypeParams,
        needsDecode: needsNativeDecode,
        needsEncode: needsNativeEncode,
      ));
    }
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
        'codable: or customEncoder:, or set @Codable(createEncoder: false).',
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
        'codable: or customDecoder:, or set @Codable(createDecoder: false).',
        element: param,
      );
    }
  }

  void _validateNativeTypeSupport(DartType type, _TypeValidationCtx ctx) {
    if (_isUnsupportedSpecialType(type)) {
      throw _unsupportedTypeError(ctx.param, type);
    }
    if (type is TypeParameterType) {
      if (!ctx.enclosingTypeParams.contains(type.element.baseElement)) {
        throw _unsupportedTypeError(ctx.param, type);
      }
      return;
    }
    if (_isScalarOrTypedData(type)) return;
    final typeElement = type.element;
    if (typeElement != null && _typeClassifier.isCodableElement(typeElement)) {
      _validateCodableInterfaceType(type, typeElement, ctx);
      return;
    }
    if (_isLinearCollectionType(type, typeElement)) {
      _validateLinearCollectionType(type, ctx);
      return;
    }
    if (type.isDartCoreMap || typeElement?.name == 'Map') {
      _validateMapType(type, ctx);
      return;
    }
    throw _unsupportedTypeError(ctx.param, type);
  }

  void _validateCodableInterfaceType(
    DartType type,
    Element typeElement,
    _TypeValidationCtx ctx,
  ) {
    if (type is! InterfaceType || typeElement is! ClassElement) return;
    if (type.typeArguments.length != typeElement.typeParameters.length) {
      throw _unsupportedTypeError(ctx.param, type);
    }
    final (subDec, subEnc) = readCodableFlags(typeElement);
    _validateNestedCodableDirection(typeElement, subDec, subEnc, ctx);
    final argCtx = (
      enclosingClass: ctx.enclosingClass,
      param: ctx.param,
      enclosingTypeParams: ctx.enclosingTypeParams,
      needsDecode: ctx.needsDecode && subDec,
      needsEncode: ctx.needsEncode && subEnc,
    );
    for (final arg in type.typeArguments) {
      _validateNativeTypeSupport(arg, argCtx);
    }
  }

  static void _validateNestedCodableDirection(
    ClassElement nested,
    bool subDec,
    bool subEnc,
    _TypeValidationCtx ctx,
  ) {
    if (!subDec && !subEnc) {
      throw InvalidGenerationSourceError(
        'Parameter "${ctx.param.name}" references "${nested.name}", which '
        'disables both createDecoder and createEncoder.',
        element: ctx.param,
      );
    }
    if (ctx.needsDecode && !subDec) {
      throw InvalidGenerationSourceError(
        'Parameter "${ctx.param.name}" references "${nested.name}", which '
        'sets createDecoder: false on a class requiring decoding.',
        element: ctx.param,
      );
    }
    if (ctx.needsEncode && !subEnc) {
      throw InvalidGenerationSourceError(
        'Parameter "${ctx.param.name}" references "${nested.name}", which '
        'sets createEncoder: false on a class requiring encoding.',
        element: ctx.param,
      );
    }
  }

  static bool _isLinearCollectionType(DartType type, Element? typeElement) =>
      type.isDartCoreList ||
      type.isDartCoreSet ||
      typeElement?.name == 'List' ||
      typeElement?.name == 'Set';

  static bool _isUnsupportedSpecialType(DartType type) =>
      type is DynamicType ||
      type is VoidType ||
      type is NeverType ||
      type is InvalidType ||
      type is RecordType ||
      type is FunctionType;

  static bool _isScalarOrTypedData(DartType type) {
    if (type.isDartCoreInt ||
        type.isDartCoreDouble ||
        type.isDartCoreNum ||
        type.isDartCoreString ||
        type.isDartCoreBool ||
        type.isEnum) {
      return true;
    }
    return classifyTypedDataKind(type) != null;
  }

  void _validateLinearCollectionType(DartType type, _TypeValidationCtx ctx) {
    final elemType = type is InterfaceType && type.typeArguments.length == 1
        ? type.typeArguments.first
        : null;
    if (elemType == null) throw _unsupportedTypeError(ctx.param, type);
    _validateNativeTypeSupport(elemType, ctx);
  }

  void _validateMapType(DartType type, _TypeValidationCtx ctx) {
    if (type is! InterfaceType || type.typeArguments.length != 2) {
      throw _unsupportedTypeError(ctx.param, type);
    }
    final keyType = type.typeArguments[0];
    final valType = type.typeArguments[1];
    if (!_isValidMapKeyType(
      ctx.enclosingClass,
      keyType,
      ctx.enclosingTypeParams,
    )) {
      throw _unsupportedMapKeyError(ctx.param, keyType);
    }
    _validateNativeTypeSupport(keyType, ctx);
    _validateNativeTypeSupport(valType, ctx);
  }

  bool _isValidMapKeyType(
    ClassElement enclosingClass,
    DartType keyType,
    Set<Element> enclosingTypeParams,
  ) {
    if (_isUnsupportedSpecialType(keyType) || keyType.isNullableType) {
      return false;
    }
    if (keyType is TypeParameterType) {
      return enclosingTypeParams.contains(keyType.element.baseElement) &&
          !enclosingClass.library.typeSystem.isPotentiallyNullable(keyType);
    }
    if (keyType.isDartCoreString ||
        keyType.isDartCoreInt ||
        keyType.isDartCoreDouble ||
        keyType.isDartCoreNum ||
        keyType.isDartCoreBool ||
        keyType.isEnum) {
      return true;
    }
    final element = keyType.element;
    return element != null && _typeClassifier.isCodableElement(element);
  }

  static InvalidGenerationSourceError _unsupportedTypeError(
    FormalParameterElement param,
    DartType unsupportedType,
  ) {
    final typeStr = unsupportedType.getDisplayString();
    return InvalidGenerationSourceError(
      'Unsupported type "$typeStr" on parameter "${param.name}" '
      '(${param.type.getDisplayString()}) is not natively codable. '
      'Annotate "$typeStr" with @Codable() or provide '
      '@CodableKey(codable: ...), customDecoder:, or customEncoder: on the '
      'field.',
      element: param,
    );
  }

  static InvalidGenerationSourceError _unsupportedMapKeyError(
    FormalParameterElement param,
    DartType keyType,
  ) {
    final keyStr = keyType.getDisplayString();
    return InvalidGenerationSourceError(
      'Unsupported Map key type "$keyStr" on parameter "${param.name}" '
      '(${param.type.getDisplayString()}). Map keys must be non-nullable '
      'String, int, double, num, bool, an enum, or a @Codable() class, or '
      'provide @CodableKey(codable: ...), customDecoder:, or customEncoder: '
      'on the field.',
      element: param,
    );
  }

  List<FieldDescriptor> _buildFieldDescriptors(
    List<_RawFieldData> rawFields,
    Map<String, int> reqBitMap,
    List<String> allOptionsKeys,
  ) {
    final usedFieldSuffixes = <String>{};
    final usedAliasSuffixes = <String>{};
    final processedFields = <FieldDescriptor>[];
    for (final raw in rawFields) {
      var keyIndex = -1;
      var aliasIndices = const <int>[];
      var fieldSuffix = toSafeIdentifierSuffix(raw.name);
      var aliasSuffixes = const <String>[];
      int? reqBitIndex;
      if (!raw.ignore) {
        fieldSuffix = allocateUniqueSuffix(fieldSuffix, usedFieldSuffixes);
        keyIndex = allOptionsKeys.length;
        allOptionsKeys.add(raw.wireName);
        aliasIndices = [
          for (final alias in raw.aliases) _addOptionKey(allOptionsKeys, alias),
        ];
        aliasSuffixes = [
          for (final alias in raw.aliases)
            allocateUniqueSuffix(
              '$fieldSuffix${toSafeIdentifierSuffix(alias)}',
              usedAliasSuffixes,
            ),
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
          isPotentiallyNullable: raw.isPotentiallyNullable,
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
          schemaSuffix: fieldSuffix,
          aliasSchemaSuffixes: aliasSuffixes,
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

typedef _TypeValidationCtx = ({
  ClassElement enclosingClass,
  FormalParameterElement param,
  Set<Element> enclosingTypeParams,
  bool needsDecode,
  bool needsEncode,
});

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
  final bool isPotentiallyNullable;
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
    required this.isPotentiallyNullable,
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
