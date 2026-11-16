// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:source_helper/source_helper.dart';

import 'field_descriptor.dart';
import 'type_helper.dart';

typedef _DecoderSlot = ({
  String target,
  String? declareType,
  String decoderExpr,
  String indent,
  int depth,
  String tag,
});

/// Emits the unified `_$ModelSchema` extension type and companion
/// `decode` / `decodeList` methods.
final class DecoderGeneratorHelper {
  final ModelDescriptor model;

  DecoderGeneratorHelper(this.model);

  /// Generates the schema extension type and decoder methods for [model].
  String generate() {
    final buffer = StringBuffer();
    buffer.write(generateSchema());
    if (model.createDecoder) {
      buffer.writeln();
      buffer.write(generateMethods());
    }
    return buffer.toString();
  }

  /// Generates the `extension type const _$ModelSchema` declaration.
  String generateSchema() {
    final buffer = StringBuffer();
    _writeSchema(buffer);
    return buffer.toString();
  }

  /// Generates the `decode` and (for uniform double models) `decodeList`
  /// methods for the companion `*Codable` class.
  String generateMethods() {
    if (!model.createDecoder) return '';
    final raw = StringBuffer();
    _writeDecoder(raw);
    if (model.isUniformDoubleModel) {
      raw.writeln();
      _writeListDecoder(raw);
    }
    return _indentLines(raw.toString(), '  ');
  }

  static String _indentLines(String text, String indent) {
    final lines = text.split('\n');
    final buffer = StringBuffer();
    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];
      if (i == lines.length - 1 && line.isEmpty) break;
      if (line.isEmpty) {
        buffer.writeln();
      } else {
        buffer.writeln('$indent$line');
      }
    }
    return buffer.toString();
  }

  void _writeSchema(StringBuffer buffer) {
    final schemaName = '_\$${model.className}Schema';
    buffer.writeln(
      '// =============================================================================',
    );
    buffer.writeln('// 1. Unified Schema Descriptor for ${model.className}');
    buffer.writeln(
      '// =============================================================================',
    );
    buffer.writeln('extension type const $schemaName(int _value) {');

    final nonIgnoredFields = model.fields.where((f) => !f.ignore).toList();

    _writeSchemaNameAndIndexConstants(buffer, nonIgnoredFields);
    _writeSchemaKeyOptionsTable(buffer, schemaName, nonIgnoredFields);
    _writeSchemaEnumOptions(buffer, nonIgnoredFields);
    _writeSchemaBitmaskValidation(buffer, schemaName);

    buffer.writeln('}');
  }

  static void _writeSchemaNameAndIndexConstants(
    StringBuffer buffer,
    List<FieldDescriptor> nonIgnoredFields,
  ) {
    buffer.writeln('  // String Name Constants');
    for (final field in nonIgnoredFields) {
      final suffix = field.schemaSuffix;
      buffer.writeln(
        '  static const String name$suffix = '
        '${escapeDartString(field.wireName)};',
      );
      for (var i = 0; i < field.aliases.length; i++) {
        final aliasCombo = field.aliasSchemaSuffixes[i];
        buffer.writeln(
          '  static const String alias$aliasCombo = '
          '${escapeDartString(field.aliases[i])};',
        );
      }
    }

    buffer.writeln();
    buffer.writeln('  // Key Indices for selectKeyIndex()');
    for (final field in nonIgnoredFields) {
      final suffix = field.schemaSuffix;
      buffer.writeln('  static const int key$suffix = ${field.keyIndex};');
      for (var i = 0; i < field.aliases.length; i++) {
        final aliasCombo = field.aliasSchemaSuffixes[i];
        buffer.writeln(
          '  static const int aliasKey$aliasCombo = ${field.aliasIndices[i]};',
        );
      }
    }
  }

  void _writeSchemaKeyOptionsTable(
    StringBuffer buffer,
    String schemaName,
    List<FieldDescriptor> nonIgnoredFields,
  ) {
    buffer.writeln();
    buffer.writeln('  // KeyOptions Table');
    if (model.allOptionsKeys.isEmpty) {
      buffer.writeln(
        '  static final KeyOptions options = KeyOptions.of(const []);',
      );
    } else {
      buffer.writeln(
        '  static final KeyOptions options = KeyOptions.of(const [',
      );
      for (final field in nonIgnoredFields) {
        final suffix = field.schemaSuffix;
        buffer.writeln('    $schemaName.name$suffix,');
        for (final aliasCombo in field.aliasSchemaSuffixes) {
          buffer.writeln('    $schemaName.alias$aliasCombo,');
        }
      }
      buffer.writeln('  ]);');
    }
    buffer.writeln('  static final KeyOptions keyOptions = options;');
  }

  void _writeSchemaEnumOptions(
    StringBuffer buffer,
    List<FieldDescriptor> nonIgnoredFields,
  ) {
    final emittedNames = <String>{};
    for (final field in nonIgnoredFields) {
      final needsEnumOptions =
          field.category == TypeCategory.enumType ||
          (field.category == TypeCategory.custom &&
              field.customDecoderCode == null &&
              field.nativeCategory == TypeCategory.enumType);
      final constants = field.enumConstants;
      if (!needsEnumOptions || constants == null || constants.isEmpty) {
        continue;
      }
      final enumOptName = '${field.name}EnumOptions';
      final keyOptName = '${field.name}KeyOptions';
      emittedNames
        ..add(enumOptName)
        ..add(keyOptName);
      buffer.write(_enumKeyOptionsBlock(field.name, enumOptName, constants));
      buffer.writeln('  static final KeyOptions $keyOptName = $enumOptName;');
    }

    for (final enumEl in _collectNestedEnums(nonIgnoredFields)) {
      final enumName = enumEl.name;
      final constants = _enumConstantNames(enumEl);
      final optName = 'enum${enumName}KeyOptions';
      if (enumName == null || constants.isEmpty || !emittedNames.add(optName)) {
        continue;
      }
      buffer.write(_enumKeyOptionsBlock(enumName, optName, constants));
    }
  }

  static String _enumKeyOptionsBlock(
    String label,
    String optionFieldName,
    List<String> constants,
  ) {
    final out = StringBuffer()
      ..writeln()
      ..writeln('  // Enum Options for $label')
      ..writeln(
        '  static final KeyOptions $optionFieldName = KeyOptions.of(const [',
      );
    for (final constant in constants) {
      out.writeln('    ${escapeDartString(constant)},');
    }
    out.writeln('  ]);');
    return out.toString();
  }

  static List<EnumElement> _collectNestedEnums(
    List<FieldDescriptor> nonIgnoredFields,
  ) {
    final found = <EnumElement>[];
    final seenNames = <String>{};
    for (final field in nonIgnoredFields) {
      if (field.category == TypeCategory.custom &&
          field.customDecoderCode != null) {
        continue;
      }
      _collectNestedEnumsFromType(field.type, found, seenNames, depth: 0);
    }
    return found;
  }

  static void _collectNestedEnumsFromType(
    DartType? type,
    List<EnumElement> found,
    Set<String> seenNames, {
    required int depth,
  }) {
    if (type == null) return;
    final el = type.element;
    if (depth >= 1 && el is EnumElement && el.name != null) {
      if (seenNames.add(el.name!)) found.add(el);
    }
    if (type is! InterfaceType) return;
    for (final arg in type.typeArguments) {
      _collectNestedEnumsFromType(arg, found, seenNames, depth: depth + 1);
    }
  }

  static List<String> _enumConstantNames(EnumElement element) => element.fields
      .where((f) => f.isEnumConstant)
      .map((f) => f.name)
      .whereType<String>()
      .toList();

  void _writeSchemaBitmaskValidation(StringBuffer buffer, String schemaName) {
    buffer.writeln();
    buffer.writeln('  // Bitmask Flags strictly for Required Fields');
    buffer.writeln('  static const $schemaName none = $schemaName(0);');
    for (final reqField in model.requiredFields) {
      buffer.writeln(
        '  static const int _${reqField.name}Bit = '
        '1 << ${reqField.reqBitIndex};',
      );
      buffer.writeln(
        '  static const $schemaName ${reqField.name} = '
        '$schemaName(_${reqField.name}Bit);',
      );
    }

    if (model.requiredFields.isNotEmpty) {
      buffer.writeln();
      buffer.writeln(
        '  // Combined Golden Bitmask for fast single-instruction check',
      );
      final goldenExpr = model.requiredFields
          .map((f) => '_${f.name}Bit')
          .join(' | ');
      buffer.writeln(
        '  static const $schemaName golden = $schemaName($goldenExpr);',
      );
    }

    buffer.writeln();
    buffer.writeln('  @pragma(\'vm:prefer-inline\')');
    buffer.writeln('  $schemaName operator |($schemaName other) =>');
    buffer.writeln('      $schemaName(_value | other._value);');

    buffer.writeln();
    buffer.writeln(
      '  /// Validates required fields in 1 CPU test instruction on the fast path.',
    );
    buffer.writeln('  @pragma(\'vm:prefer-inline\')');
    buffer.writeln('  void validate() {');
    if (model.requiredFields.isNotEmpty && model.useGoldenMask) {
      buffer.writeln('    if ((_value & golden._value) != golden._value) {');
      buffer.writeln('      _throwMissingFields();');
      buffer.writeln('    }');
    }
    buffer.writeln('  }');

    if (model.requiredFields.isNotEmpty && model.useGoldenMask) {
      buffer.writeln();
      buffer.writeln('  /// Out-of-line cold diagnostic reporting');
      buffer.writeln('  void _throwMissingFields() {');
      buffer.writeln('    final missing = <String>[];');
      for (final reqField in model.requiredFields) {
        final suffix = reqField.schemaSuffix;
        buffer.writeln('    if ((_value & _${reqField.name}Bit) == 0) {');
        buffer.writeln('      missing.add(name$suffix);');
        buffer.writeln('    }');
      }
      buffer.writeln(
        "    throw CodableException('Missing required fields for "
        "${model.className}: \${missing.join(\", \")}');",
      );
      buffer.writeln('  }');
    }
  }

  void _writeDecoder(StringBuffer buffer) {
    final schemaName = '_\$${model.className}Schema';

    buffer.writeln('@override');
    buffer.writeln('${model.className} decode(Decoder decoder) {');
    buffer.writeln(
      '  final keyed = decoder.keyed(options: $schemaName.keyOptions);',
    );
    buffer.writeln();
    _writeLocalVarDeclarations(buffer);
    _writeKeyedSelectLoop(buffer, schemaName);
    _writeDecoderReturn(buffer);
  }

  void _writeLocalVarDeclarations(StringBuffer buffer) {
    for (final field in model.fields) {
      final typeStr = field.type.getDisplayString();
      if (field.hasDefaultValue && field.defaultValueCode != null) {
        _writeDefaultVarDeclaration(buffer, field, typeStr);
      } else if (field.isNullable) {
        buffer.writeln('  $typeStr ${field.name};');
      } else {
        buffer.writeln('  $typeStr? ${field.name};');
      }
    }
  }

  void _writeDefaultVarDeclaration(
    StringBuffer buffer,
    FieldDescriptor field,
    String typeStr,
  ) {
    var defaultCode = field.defaultValueCode!;
    if (defaultCode.endsWith(';')) {
      defaultCode = defaultCode.substring(0, defaultCode.length - 1);
    }
    if (field.isNullable && defaultCode == 'null') {
      buffer.writeln('  $typeStr ${field.name};');
      return;
    }
    buffer.writeln('  $typeStr ${field.name} = $defaultCode;');
  }

  void _writeKeyedSelectLoop(StringBuffer buffer, String schemaName) {
    buffer.writeln('  var seen = $schemaName.none;');
    buffer.writeln();
    buffer.writeln('  while (keyed.moveNextKey()) {');
    buffer.writeln(
      '    switch (keyed.selectKeyIndex($schemaName.keyOptions)) {',
    );

    final nonIgnoredFields = model.fields.where((f) => !f.ignore).toList();
    for (final field in nonIgnoredFields) {
      _writeKeyedFieldCase(buffer, field, schemaName);
    }

    buffer.writeln('      default:');
    buffer.writeln('        keyed.skipValue();');
    buffer.writeln('        break;');
    buffer.writeln('    }');
    buffer.writeln('  }');
    buffer.writeln();
    buffer.writeln('  // Inlined fast-path check');
    buffer.writeln('  seen.validate();');
    buffer.writeln();
  }

  void _writeKeyedFieldCase(
    StringBuffer buffer,
    FieldDescriptor field,
    String schemaName,
  ) {
    final suffix = field.schemaSuffix;
    buffer.writeln('      case $schemaName.key$suffix:');
    for (final aliasCombo in field.aliasSchemaSuffixes) {
      buffer.writeln('      case $schemaName.aliasKey$aliasCombo:');
    }

    if (field.participatesInGoldenMask) {
      buffer.writeln(
        '        if ((seen._value & '
        '$schemaName.${field.name}._value) != 0) {',
      );
      final dupMsg = escapeDartString('Duplicate field "${field.wireName}"');
      buffer.writeln('          throw const CodableException($dupMsg);');
      buffer.writeln('        }');
    }

    if (field.isNullable) {
      buffer.writeln('        if (keyed.isNextNull()) {');
      buffer.writeln('          keyed.readNull();');
      buffer.writeln('          ${field.name} = null;');
      buffer.writeln('        } else {');
      _writeKeyedFieldRead(buffer, field, indent: '          ');
      if (field.participatesInGoldenMask) {
        buffer.writeln('          seen |= $schemaName.${field.name};');
      }
      buffer.writeln('        }');
    } else {
      _writeKeyedFieldRead(buffer, field, indent: '        ');
      if (field.participatesInGoldenMask) {
        buffer.writeln('        seen |= $schemaName.${field.name};');
      }
    }
    buffer.writeln('        break;');
  }

  void _writeKeyedFieldRead(
    StringBuffer buffer,
    FieldDescriptor field, {
    required String indent,
    TypeCategory? categoryOverride,
  }) {
    switch (categoryOverride ?? field.category) {
      case TypeCategory.primitiveInt:
        buffer.writeln('$indent${field.name} = keyed.readInt();');
      case TypeCategory.primitiveDouble:
        buffer.writeln('$indent${field.name} = keyed.readDouble();');
      case TypeCategory.primitiveNum:
        buffer.writeln('$indent${field.name} = keyed.readNum();');
      case TypeCategory.primitiveString:
        buffer.writeln('$indent${field.name} = keyed.readString();');
      case TypeCategory.primitiveBool:
        buffer.writeln('$indent${field.name} = keyed.readBool();');
      case TypeCategory.enumType:
        final schemaName = '_\$${model.className}Schema';
        _writeKeyedEnumFieldRead(buffer, field, schemaName, indent: indent);
      case TypeCategory.custom:
        if (field.customDecoderCode != null) {
          buffer.writeln(
            '$indent${field.name} = '
            'keyed.decodeValue(${field.customDecoderCode});',
          );
        } else {
          _writeKeyedFieldRead(
            buffer,
            field,
            indent: indent,
            categoryOverride: field.nativeCategory,
          );
        }
      case TypeCategory.tuple:
        _writeKeyedTupleRead(buffer, field, indent: indent);
      case TypeCategory.list:
        _writeKeyedListRead(buffer, field, indent: indent);
      case TypeCategory.set:
        _writeKeyedSetRead(buffer, field, indent: indent);
      case TypeCategory.map:
        _writeKeyedMapRead(buffer, field, indent: indent);
      case TypeCategory.nestedCodable:
        final nestedName = field.type.element!.name;
        buffer.writeln(
          '$indent${field.name} = '
          'const ${nestedName}Codable().decode(keyed.nestedDecoder());',
        );
      case TypeCategory.unknown:
        throw StateError(
          'Unsupported unknown field type '
          '"${field.type.getDisplayString()}" for "${field.name}".',
        );
    }
  }

  void _writeKeyedTupleRead(
    StringBuffer buffer,
    FieldDescriptor field, {
    required String indent,
  }) {
    final decodeExpr = _tupleDecodeExpr(field.type);
    final expectedLen = field.tupleLength!;
    final prefix = escapeDartString(
      'Expected tuple of length $expectedLen for "${field.wireName}", got ',
    );
    final prefixBody = prefix.substring(1, prefix.length - 1);
    buffer.writeln('$indent${field.name} = $decodeExpr;');
    buffer.writeln('${indent}if (${field.name}.length != $expectedLen) {');
    buffer.writeln(
      "$indent  throw CodableException('$prefixBody\${${field.name}.length}', "
      'actualValue: ${field.name}.length);',
    );
    buffer.writeln('$indent}');
  }

  static String _tupleDecodeExpr(DartType type) {
    final tdKind = classifyTypedDataKind(type);
    if (tdKind == TypedDataKind.float64) return 'keyed.decodeFloat64List()';
    if (tdKind == TypedDataKind.float32) {
      return 'Float32List.fromList(keyed.decodeDoubleList())';
    }
    if (tdKind != null) {
      return '${type.element!.name}.fromList(keyed.decodeIntList())';
    }
    if (isIntegerTupleTargetType(type)) return 'keyed.decodeIntList()';
    return 'keyed.decodeDoubleList()';
  }

  void _writeKeyedEnumFieldRead(
    StringBuffer buffer,
    FieldDescriptor field,
    String schemaName, {
    required String indent,
  }) {
    final typeStr =
        field.type.element?.name ??
        field.type.getDisplayString().replaceAll('?', '');
    buffer.writeln(
      '${indent}final enumIndex = '
      'keyed.selectStringIndex($schemaName.${field.name}KeyOptions);',
    );
    buffer.writeln(
      '${indent}if (enumIndex >= 0 && enumIndex < $typeStr.values.length) {',
    );
    buffer.writeln('$indent  ${field.name} = $typeStr.values[enumIndex];');
    buffer.writeln('$indent} else {');
    buffer.writeln(
      "$indent  throw const CodableException('Unknown $typeStr value');",
    );
    buffer.writeln('$indent}');
  }

  void _writeKeyedListRead(
    StringBuffer buffer,
    FieldDescriptor field, {
    required String indent,
  }) {
    if (_tryWriteTypedDataListRead(buffer, field, indent: indent)) {
      return;
    }

    final elemType = field.elementType;
    if (elemType == null) {
      throw StateError(
        'Missing element type for List field "${field.name}" '
        '(${field.type.getDisplayString()}).',
      );
    }

    final isNullable = elemType.isNullableType;
    if (!isNullable &&
        _tryWriteNonNullFastListRead(buffer, field, elemType, indent: indent)) {
      return;
    }
    if (elemType.isDartCoreList || elemType.element?.name == 'List') {
      _writeNestedListRead(buffer, field, elemType, indent: indent);
      return;
    }
    if (_isMapSetOrTypedList(elemType)) {
      buffer.write(
        _inlineCollectionDecodeCode(elemType, (
          target: field.name,
          declareType: null,
          decoderExpr: 'keyed.nestedDecoder()',
          indent: indent,
          depth: 0,
          tag: '',
        ), isSet: false),
      );
      return;
    }
    if (elemType.element is EnumElement) {
      _writeEnumListRead(buffer, field, elemType, indent: indent);
      return;
    }
    if (elemType.element != null &&
        const TypeClassifier().isCodableElement(elemType.element!)) {
      _writeCodableListRead(buffer, field, elemType, indent: indent);
      return;
    }
    if (isNullable &&
        _tryWriteNullablePrimitiveListRead(
          buffer,
          field,
          elemType,
          indent: indent,
        )) {
      return;
    }
    throw StateError(
      'Unsupported List element type "${elemType.getDisplayString()}" for '
      'field "${field.name}".',
    );
  }

  bool _tryWriteTypedDataListRead(
    StringBuffer buffer,
    FieldDescriptor field, {
    required String indent,
  }) {
    final kind = classifyTypedDataKind(field.type);
    if (kind == null) return false;
    final expr = switch (kind) {
      TypedDataKind.uint8Bytes => 'keyed.readBytes()',
      TypedDataKind.float64 => 'keyed.decodeFloat64List()',
      TypedDataKind.float32 => 'Float32List.fromList(keyed.decodeDoubleList())',
      TypedDataKind.intList =>
        '${field.type.element!.name}.fromList(keyed.decodeIntList())',
    };
    buffer.writeln('$indent${field.name} = $expr;');
    return true;
  }

  static String? _fastPrimitiveListCall(DartType type) {
    if (type.isNullableType) return null;
    if (type.isDartCoreInt) return 'decodeIntList()';
    if (type.isDartCoreDouble) return 'decodeDoubleList()';
    if (type.isDartCoreString) return 'decodeStringList()';
    if (type.isDartCoreBool) return 'decodeBoolList()';
    return null;
  }

  bool _tryWriteNonNullFastListRead(
    StringBuffer buffer,
    FieldDescriptor field,
    DartType elemType, {
    required String indent,
  }) {
    final fastCall = _fastPrimitiveListCall(elemType);
    if (fastCall != null) {
      buffer.writeln('$indent${field.name} = keyed.$fastCall;');
      return true;
    }
    if (elemType.isDartCoreNum) {
      buffer.writeln(
        '$indent${field.name} = keyed.decodeList<num>('
        'Decodable.fromFunction((d) => d.singleValue().readNum()));',
      );
      return true;
    }
    final loopSpec = _unkeyedTypedLoopSpec(elemType);
    if (loopSpec != null) {
      _writeUnkeyedLoopListRead(
        buffer,
        field.name,
        loopSpec.$1,
        loopSpec.$2,
        indent: indent,
      );
      return true;
    }
    return false;
  }

  static (String, String)? _unkeyedTypedLoopSpec(DartType elemType) {
    final kind = classifyTypedDataKind(elemType);
    if (kind == null) return null;
    final name = elemType.element!.name!;
    return switch (kind) {
      TypedDataKind.uint8Bytes => (name, 'u.readBytes()'),
      TypedDataKind.float64 => (name, 'u.decodeFloat64List()'),
      TypedDataKind.float32 => (
        name,
        'Float32List.fromList(u.decodeDoubleList())',
      ),
      TypedDataKind.intList => (name, '$name.fromList(u.decodeIntList())'),
    };
  }

  void _writeNestedListRead(
    StringBuffer buffer,
    FieldDescriptor field,
    DartType elemType, {
    required String indent,
  }) {
    final inner = elemType is InterfaceType && elemType.typeArguments.isNotEmpty
        ? elemType.typeArguments.first
        : null;
    if (inner == null) {
      throw StateError(
        'Missing element type for nested List "${elemType.getDisplayString()}" '
        'in "${field.name}".',
      );
    }
    if (!elemType.isNullableType) {
      final fastSpec = _nestedFastListSpec(inner);
      if (fastSpec != null) {
        _writeUnkeyedLoopListRead(
          buffer,
          field.name,
          fastSpec.$1,
          fastSpec.$2,
          indent: indent,
        );
        return;
      }
    }
    final innerExpr = _generateUnkeyedElementExpr(inner);
    final decodeExpr = elemType.isNullableType
        ? 'u.decodeNullableList($innerExpr)'
        : 'u.decodeList($innerExpr)';
    _writeUnkeyedLoopListRead(
      buffer,
      field.name,
      elemType.getDisplayString(),
      decodeExpr,
      indent: indent,
    );
  }

  static (String, String)? _nestedFastListSpec(DartType inner) {
    final fastCall = _fastPrimitiveListCall(inner);
    if (fastCall != null) {
      return ('List<${inner.getDisplayString()}>', 'u.$fastCall');
    }
    return null;
  }

  static bool _isMapOrSetType(DartType type) =>
      type.isDartCoreMap ||
      type.isDartCoreSet ||
      type.element?.name == 'Map' ||
      type.element?.name == 'Set';

  static bool _isMapSetOrTypedList(DartType type) {
    if (_isMapOrSetType(type)) return true;
    final tdKind = classifyTypedDataKind(type);
    return tdKind != null && tdKind != TypedDataKind.uint8Bytes;
  }

  static bool _isNestedSetElementCollection(DartType type) =>
      _isMapSetOrTypedList(type) ||
      type.isDartCoreList ||
      type.element?.name == 'List' ||
      classifyTypedDataKind(type) == TypedDataKind.uint8Bytes;

  void _writeUnkeyedLoopListRead(
    StringBuffer buffer,
    String fieldName,
    String listElementType,
    String decodeExpr, {
    required String indent,
  }) {
    buffer.writeln(
      '$indent{\n'
      '$indent  final u = keyed.nestedDecoder().unkeyed();\n'
      '$indent  final l = <$listElementType>[];\n'
      '$indent  while (u.moveNext()) {\n'
      '$indent    l.add($decodeExpr);\n'
      '$indent  }\n'
      '$indent  $fieldName = l;\n'
      '$indent}',
    );
  }

  void _writeEnumListRead(
    StringBuffer buffer,
    FieldDescriptor field,
    DartType elemType, {
    required String indent,
  }) {
    final enumName = elemType.element!.name;
    buffer.writeln(
      '$indent${field.name} = keyed.decodeList('
      '${_enumDecodableExpr(enumName!, isNullable: elemType.isNullableType)});',
    );
  }

  String _enumDecodableExpr(String enumName, {required bool isNullable}) {
    final optRef = '_\$${model.className}Schema.enum${enumName}KeyOptions';
    if (isNullable) {
      return 'Decodable.fromFunction((d) { '
          'final raw = d.singleValue().readNullableString(); '
          'if (raw == null) return null; '
          'final idx = $optRef.indexOf(raw); '
          'if (idx < 0) { '
          "throw CodableException('Unknown $enumName value: \"\$raw\"', "
          'actualValue: raw); '
          '} '
          'return $enumName.values[idx]; })';
    }
    return 'Decodable.fromFunction((d) { '
        'final raw = d.singleValue().readString(); '
        'final idx = $optRef.indexOf(raw); '
        'if (idx < 0) { '
        "throw CodableException('Unknown $enumName value: \"\$raw\"', "
        'actualValue: raw); '
        '} '
        'return $enumName.values[idx]; })';
  }

  void _writeCodableListRead(
    StringBuffer buffer,
    FieldDescriptor field,
    DartType elemType, {
    required String indent,
  }) {
    final nestedName = elemType.element!.name!;
    if (elemType.isNullableType) {
      buffer.writeln(
        _nullableCodableUnkeyedBlock(
          field.name,
          nestedName,
          indent: indent,
          isSet: false,
        ),
      );
    } else {
      buffer.writeln(
        '$indent${field.name} = '
        'const ${nestedName}Codable().decodeList(keyed.nestedDecoder());',
      );
    }
  }

  static String _nullableCodableUnkeyedBlock(
    String fieldName,
    String nestedName, {
    required String indent,
    required bool isSet,
  }) {
    final varName = isSet ? 's' : 'l';
    final literal = isSet ? '<$nestedName?>{}' : '<$nestedName?>[]';
    return '$indent{\n'
        '$indent  final u = keyed.nestedDecoder().unkeyed();\n'
        '$indent  final $varName = $literal;\n'
        '$indent  while (u.moveNext()) {\n'
        '$indent    if (u.isNextNull()) {\n'
        '$indent      u.readNull();\n'
        '$indent      $varName.add(null);\n'
        '$indent    } else {\n'
        '$indent      $varName.add(const ${nestedName}Codable().decode(u.nestedDecoder()));\n'
        '$indent    }\n'
        '$indent  }\n'
        '$indent  $fieldName = $varName;\n'
        '$indent}';
  }

  bool _tryWriteNullablePrimitiveListRead(
    StringBuffer buffer,
    FieldDescriptor field,
    DartType elemType, {
    required String indent,
  }) {
    final methods = _primitiveSingleValueMethods(elemType);
    if (methods == null) return false;
    final typeStr = elemType.getDisplayString();
    buffer.writeln(
      '$indent${field.name} = keyed.decodeList<$typeStr>('
      'Decodable.fromFunction((d) => d.singleValue().${methods.$2}()));',
    );
    return true;
  }

  String _generateUnkeyedElementExpr(DartType type) {
    if (type.isDartCoreList || type.element?.name == 'List') {
      return _generateUnkeyedListElementExpr(type);
    }
    if (_isMapSetOrTypedList(type)) {
      final body = _decoderValueCode(type, (
        target: 'res',
        declareType: type.getDisplayString(),
        decoderExpr: 'd',
        indent: '  ',
        depth: 0,
        tag: '',
      ));
      return 'Decodable.fromFunction((d) {\n$body  return res;\n})';
    }
    if (type.element != null &&
        const TypeClassifier().isCodableElement(type.element!)) {
      final nestedName = type.element!.name;
      return type.isNullableType
          ? 'Decodable.fromFunction((d) { final sv = d.singleValue(); if (sv.isNull()) { sv.readNull(); return null; } return const ${nestedName}Codable().decode(d); })'
          : 'const ${nestedName}Codable()';
    }
    if (type.element is EnumElement) {
      return _enumDecodableExpr(
        type.element!.name!,
        isNullable: type.isNullableType,
      );
    }
    return _generatePrimitiveUnkeyedElementExpr(type);
  }

  String _generateUnkeyedListElementExpr(DartType type) {
    final inner = type is InterfaceType && type.typeArguments.isNotEmpty
        ? type.typeArguments.first
        : null;
    if (inner == null) {
      throw StateError(
        'Missing element type for nested List "${type.getDisplayString()}".',
      );
    }
    final innerExpr = _generateUnkeyedElementExpr(inner);
    if (type.isNullableType) {
      return 'Decodable.fromFunction((d) { final sv = d.singleValue(); if (sv.isNull()) { sv.readNull(); return null; } return ($innerExpr).decodeList(d); })';
    }
    return '($innerExpr).list';
  }

  static String _generatePrimitiveUnkeyedElementExpr(DartType type) {
    final method = _primitiveSingleValueReadMethod(type);
    if (method != null) {
      return 'Decodable.fromFunction((d) => d.singleValue().$method())';
    }
    throw StateError(
      'Unsupported unkeyed element type "${type.getDisplayString()}".',
    );
  }

  static (String, String)? _primitiveSingleValueMethods(DartType type) {
    if (type.isDartCoreInt) return ('readInt', 'readNullableInt');
    if (type.isDartCoreDouble) return ('readDouble', 'readNullableDouble');
    if (type.isDartCoreNum) return ('readNum', 'readNullableNum');
    if (type.isDartCoreString) return ('readString', 'readNullableString');
    if (type.isDartCoreBool) return ('readBool', 'readNullableBool');
    if (classifyTypedDataKind(type) == TypedDataKind.uint8Bytes) {
      return ('readBytes', 'readNullableBytes');
    }
    return null;
  }

  static String? _primitiveSingleValueReadMethod(DartType type) {
    final methods = _primitiveSingleValueMethods(type);
    if (methods == null) return null;
    return type.isNullableType ? methods.$2 : methods.$1;
  }

  void _writeKeyedSetRead(
    StringBuffer buffer,
    FieldDescriptor field, {
    required String indent,
  }) {
    final elemType = field.elementType;
    if (elemType == null) {
      throw StateError(
        'Missing element type for Set field "${field.name}" '
        '(${field.type.getDisplayString()}).',
      );
    }
    final fastSet = _tryFastOrPrimitiveSetLine(field.name, elemType, indent);
    if (fastSet != null) {
      buffer.writeln(fastSet);
      return;
    }
    if (_isNestedSetElementCollection(elemType)) {
      buffer.write(
        _inlineCollectionDecodeCode(elemType, (
          target: field.name,
          declareType: null,
          decoderExpr: 'keyed.nestedDecoder()',
          indent: indent,
          depth: 0,
          tag: '',
        ), isSet: true),
      );
      return;
    }
    if (elemType.element is EnumElement) {
      final decExpr = _enumDecodableExpr(
        elemType.element!.name!,
        isNullable: elemType.isNullableType,
      );
      buffer.writeln(
        '$indent${field.name} = keyed.decodeList($decExpr).toSet();',
      );
      return;
    }
    if (elemType.element != null &&
        const TypeClassifier().isCodableElement(elemType.element!)) {
      final nestedName = elemType.element!.name!;
      final code = elemType.isNullableType
          ? _nullableCodableUnkeyedBlock(
              field.name,
              nestedName,
              indent: indent,
              isSet: true,
            )
          : '$indent${field.name} = '
                'const ${nestedName}Codable().decodeList(keyed.nestedDecoder()).toSet();';
      buffer.writeln(code);
      return;
    }
    throw StateError(
      'Unsupported Set element type "${elemType.getDisplayString()}" for '
      'field "${field.name}".',
    );
  }

  static String? _tryFastOrPrimitiveSetLine(
    String fieldName,
    DartType elemType,
    String indent,
  ) {
    final fastCall = _fastPrimitiveListCall(elemType);
    if (fastCall != null) {
      return '$indent$fieldName = keyed.$fastCall.toSet();';
    }
    final svMethod = _primitiveSingleValueReadMethod(elemType);
    if (svMethod != null) {
      final elemTypeStr = elemType.getDisplayString();
      return '$indent$fieldName = keyed.decodeList<$elemTypeStr>('
          'Decodable.fromFunction((d) => d.singleValue().$svMethod())).toSet();';
    }
    return null;
  }

  void _writeKeyedMapRead(
    StringBuffer buffer,
    FieldDescriptor field, {
    required String indent,
  }) {
    buffer.write(
      _inlineMapDecodeCode(field.mapKeyType, field.mapValueType, (
        target: field.name,
        declareType: null,
        decoderExpr: 'keyed.nestedDecoder()',
        indent: indent,
        depth: 0,
        tag: '',
      )),
    );
  }

  static String _slotSuffix(_DecoderSlot slot, {bool emptyAtZero = false}) =>
      emptyAtZero && slot.depth == 0 && slot.tag.isEmpty
      ? ''
      : '${slot.depth}${slot.tag}';

  static bool _isStringMapKey(DartType? keyType) =>
      keyType != null &&
      keyType.isDartCoreString &&
      keyType.nullabilitySuffix == NullabilitySuffix.none;

  String _inlineMapDecodeCode(
    DartType? keyType,
    DartType? valType,
    _DecoderSlot slot,
  ) {
    if (_isStringMapKey(keyType)) {
      return _inlineStringMapDecodeCode(valType, slot);
    }
    return _inlineGenericMapDecodeCode(keyType, valType, slot);
  }

  String _inlineStringMapDecodeCode(DartType? valType, _DecoderSlot slot) {
    if (valType == null) {
      throw StateError('Missing value type for String-keyed Map.');
    }
    final sfx = _slotSuffix(slot, emptyAtZero: true);
    final kVar = 'k$sfx';
    final mapVar = 'm$sfx';
    final keyVar = 'key$sfx';
    final valTypeStr = valType.getDisplayString();
    final indent = slot.indent;
    final out = StringBuffer();
    if (slot.declareType != null) {
      out.writeln('$indent${slot.declareType} ${slot.target};');
    }
    out
      ..writeln('$indent{')
      ..writeln('$indent  final $kVar = ${slot.decoderExpr}.keyed();')
      ..writeln('$indent  final $mapVar = <String, $valTypeStr>{};')
      ..writeln('$indent  while ($kVar.moveNextKey()) {')
      ..writeln('$indent    final $keyVar = $kVar.nextKey();')
      ..write(
        _keyedMapValueDecodeCode(valType, kVar, (
          target: '$mapVar[$keyVar]',
          declareType: null,
          decoderExpr: '$kVar.nestedDecoder()',
          indent: '$indent    ',
          depth: slot.depth + 1,
          tag: slot.tag,
        )),
      )
      ..writeln('$indent  }')
      ..writeln('$indent  ${slot.target} = $mapVar;')
      ..writeln('$indent}');
    return out.toString();
  }

  String _keyedMapValueDecodeCode(
    DartType? type,
    String kVar,
    _DecoderSlot slot,
  ) {
    if (type == null) {
      throw StateError('Missing Map value type.');
    }
    final scalarMethod = _primitiveSingleValueReadMethod(type);
    if (scalarMethod != null) {
      return '${slot.indent}${slot.target} = $kVar.$scalarMethod();\n';
    }
    if (!type.isNullableType) {
      return _nonNullKeyedMapValueDecodeCode(type, kVar, slot);
    }
    final indent = slot.indent;
    final out = StringBuffer()
      ..writeln('${indent}if ($kVar.isNextNull()) {')
      ..writeln('$indent  $kVar.readNull();')
      ..writeln('$indent  ${slot.target} = null;')
      ..writeln('$indent} else {')
      ..write(
        _nonNullKeyedMapValueDecodeCode(type, kVar, (
          target: slot.target,
          declareType: null,
          decoderExpr: '$kVar.nestedDecoder()',
          indent: '$indent  ',
          depth: slot.depth + 1,
          tag: slot.tag,
        )),
      )
      ..writeln('$indent}');
    return out.toString();
  }

  String _nonNullKeyedMapValueDecodeCode(
    DartType type,
    String kVar,
    _DecoderSlot slot,
  ) {
    if (type.element is EnumElement) {
      return _keyedEnumValueDecodeCode(type, kVar, slot);
    }
    final fastExpr = _keyedDirectCollectionDecodeExpr(type, kVar);
    if (fastExpr != null) {
      return '${slot.indent}${slot.target} = $fastExpr;\n';
    }
    return _nonNullComplexDecoderValueCode(type, slot);
  }

  String _keyedEnumValueDecodeCode(
    DartType type,
    String kVar,
    _DecoderSlot slot,
  ) {
    final enumName = type.element!.name!;
    final schemaName = '_\$${model.className}Schema';
    final optRef = '$schemaName.enum${enumName}KeyOptions';
    final indent = slot.indent;
    final sfx = _slotSuffix(slot);
    final rawVar = 'rawEnum$sfx';
    final idxVar = 'enumIdx$sfx';
    return '${indent}final $rawVar = $kVar.readString();\n'
        '${indent}final $idxVar = $optRef.indexOf($rawVar);\n'
        '${indent}if ($idxVar < 0) {\n'
        "$indent  throw CodableException('Unknown $enumName value: \"\$$rawVar\"', actualValue: $rawVar);\n"
        '$indent}\n'
        '$indent${slot.target} = $enumName.values[$idxVar];\n';
  }

  static String? _keyedDirectCollectionDecodeExpr(DartType type, String kVar) {
    final tdKind = classifyTypedDataKind(type);
    if (tdKind != null && tdKind != TypedDataKind.uint8Bytes) {
      final name = type.element!.name!;
      return switch (tdKind) {
        TypedDataKind.float64 => '$kVar.decodeFloat64List()',
        TypedDataKind.float32 =>
          'Float32List.fromList($kVar.decodeDoubleList())',
        TypedDataKind.intList => '$name.fromList($kVar.decodeIntList())',
        TypedDataKind.uint8Bytes => null,
      };
    }
    final isList = type.isDartCoreList || type.element?.name == 'List';
    final isSet = type.isDartCoreSet || type.element?.name == 'Set';
    if (!isList && !isSet) return null;
    final inner = _typeArgAt(type, 0);
    final fastCall = inner != null ? _fastPrimitiveListCall(inner) : null;
    if (fastCall == null) return null;
    return isSet ? '$kVar.$fastCall.toSet()' : '$kVar.$fastCall';
  }

  String _inlineGenericMapDecodeCode(
    DartType? keyType,
    DartType? valType,
    _DecoderSlot slot,
  ) {
    if (keyType == null || valType == null) {
      throw StateError('Missing key or value type for Map.');
    }
    final sfx = _slotSuffix(slot, emptyAtZero: true);
    final mDecVar = 'mDecoder$sfx';
    final mapVar = 'm$sfx';
    final keyVar = 'key$sfx';
    final keyTypeStr = keyType.getDisplayString();
    final valTypeStr = valType.getDisplayString();
    final indent = slot.indent;
    final bodyIndent = '$indent    ';
    final out = StringBuffer();
    if (slot.declareType != null) {
      out.writeln('$indent${slot.declareType} ${slot.target};');
    }
    out
      ..writeln('$indent{')
      ..writeln('$indent  final $mDecVar = ${slot.decoderExpr}.map();')
      ..writeln('$indent  final $mapVar = <$keyTypeStr, $valTypeStr>{};')
      ..writeln('$indent  while ($mDecVar.moveNextEntry()) {')
      ..write(
        _decoderValueCode(keyType, (
          target: keyVar,
          declareType: keyTypeStr,
          decoderExpr: '$mDecVar.keyDecoder()',
          indent: bodyIndent,
          depth: slot.depth + 1,
          tag: '${slot.tag}Key',
        )),
      )
      ..write(
        _decoderValueCode(valType, (
          target: '$mapVar[$keyVar]',
          declareType: null,
          decoderExpr: '$mDecVar.valueDecoder()',
          indent: bodyIndent,
          depth: slot.depth + 1,
          tag: '${slot.tag}Val',
        )),
      )
      ..writeln('$indent  }')
      ..writeln('$indent  ${slot.target} = $mapVar;')
      ..writeln('$indent}');
    return out.toString();
  }

  String _decoderValueCode(DartType? type, _DecoderSlot slot) {
    final assignLhs = slot.declareType != null
        ? 'final ${slot.target}'
        : slot.target;
    if (type == null) {
      throw StateError('Missing nested value type.');
    }
    final scalarMethod = _primitiveSingleValueReadMethod(type);
    if (scalarMethod != null) {
      return '${slot.indent}$assignLhs = '
          '${slot.decoderExpr}.singleValue().$scalarMethod();\n';
    }
    if (type.element is EnumElement) {
      return _enumDecoderValueCode(type, slot);
    }
    if (!type.isNullableType) {
      return _nonNullComplexDecoderValueCode(type, slot);
    }
    final sfx = _slotSuffix(slot);
    final decVar = 'dec$sfx';
    final svVar = 'sv$sfx';
    final indent = slot.indent;
    final out = StringBuffer();
    if (slot.declareType != null) {
      out.writeln('$indent${slot.declareType} ${slot.target};');
    }
    out
      ..writeln('${indent}final $decVar = ${slot.decoderExpr};')
      ..writeln('${indent}final $svVar = $decVar.singleValue();')
      ..writeln('${indent}if ($svVar.isNull()) {')
      ..writeln('$indent  $svVar.readNull();')
      ..writeln('$indent  ${slot.target} = null;')
      ..writeln('$indent} else {')
      ..write(
        _nonNullComplexDecoderValueCode(type, (
          target: slot.target,
          declareType: null,
          decoderExpr: decVar,
          indent: '$indent  ',
          depth: slot.depth + 1,
          tag: slot.tag,
        )),
      )
      ..writeln('$indent}');
    return out.toString();
  }

  String _enumDecoderValueCode(DartType type, _DecoderSlot slot) {
    final enumName = type.element!.name!;
    final schemaName = '_\$${model.className}Schema';
    final optRef = '$schemaName.enum${enumName}KeyOptions';
    final indent = slot.indent;
    final sfx = _slotSuffix(slot);
    final rawVar = 'rawEnum$sfx';
    final idxVar = 'enumIdx$sfx';
    if (!type.isNullableType) {
      final assignLhs = slot.declareType != null
          ? 'final ${slot.target}'
          : slot.target;
      return '${indent}final $rawVar = '
          '${slot.decoderExpr}.singleValue().readString();\n'
          '${indent}final $idxVar = $optRef.indexOf($rawVar);\n'
          '${indent}if ($idxVar < 0) {\n'
          "$indent  throw CodableException('Unknown $enumName value: \"\$$rawVar\"', actualValue: $rawVar);\n"
          '$indent}\n'
          '$indent$assignLhs = $enumName.values[$idxVar];\n';
    }
    final out = StringBuffer();
    if (slot.declareType != null) {
      out.writeln('$indent${slot.declareType} ${slot.target};');
    }
    out
      ..writeln(
        '${indent}final $rawVar = '
        '${slot.decoderExpr}.singleValue().readNullableString();',
      )
      ..writeln('${indent}if ($rawVar == null) {')
      ..writeln('$indent  ${slot.target} = null;')
      ..writeln('$indent} else {')
      ..writeln('$indent  final $idxVar = $optRef.indexOf($rawVar);')
      ..writeln('$indent  if ($idxVar < 0) {')
      ..writeln(
        "$indent    throw CodableException('Unknown $enumName value: \"\$$rawVar\"', actualValue: $rawVar);",
      )
      ..writeln('$indent  }')
      ..writeln('$indent  ${slot.target} = $enumName.values[$idxVar];')
      ..writeln('$indent}');
    return out.toString();
  }

  static DartType? _typeArgAt(DartType type, int index) =>
      type is InterfaceType && type.typeArguments.length > index
      ? type.typeArguments[index]
      : null;

  String _nonNullComplexDecoderValueCode(DartType type, _DecoderSlot slot) {
    final singleExpr = _nonNullComplexSingleExpr(type, slot.decoderExpr);
    final assignLhs = slot.declareType != null
        ? 'final ${slot.target}'
        : slot.target;
    if (singleExpr != null) {
      return '${slot.indent}$assignLhs = $singleExpr;\n';
    }
    final typedCode = _tryTypedDataDecodeCode(type, slot);
    if (typedCode != null) return typedCode;
    final name = type.element?.name;
    if (type.isDartCoreMap || name == 'Map') {
      return _inlineMapDecodeCode(
        _typeArgAt(type, 0),
        _typeArgAt(type, 1),
        slot,
      );
    }
    final isSet = type.isDartCoreSet || name == 'Set';
    if (isSet || type.isDartCoreList || name == 'List') {
      return _inlineCollectionDecodeCode(
        _typeArgAt(type, 0),
        slot,
        isSet: isSet,
      );
    }
    throw StateError(
      'Unsupported nested value type "${type.getDisplayString()}".',
    );
  }

  static String? _nonNullComplexSingleExpr(DartType type, String decExpr) {
    if (type.element != null &&
        const TypeClassifier().isCodableElement(type.element!)) {
      return 'const ${type.element!.name}Codable().decode($decExpr)';
    }
    final isSet = type.isDartCoreSet || type.element?.name == 'Set';
    final isList = type.isDartCoreList || type.element?.name == 'List';
    final inner = (isList || isSet) ? _typeArgAt(type, 0) : null;
    if (inner != null &&
        !inner.isNullableType &&
        inner.element != null &&
        const TypeClassifier().isCodableElement(inner.element!)) {
      final suffix = isSet ? '.toSet()' : '';
      return 'const ${inner.element!.name}Codable().decodeList($decExpr)$suffix';
    }
    return null;
  }

  static String? _tryTypedDataDecodeCode(DartType type, _DecoderSlot slot) {
    final tdKind = classifyTypedDataKind(type);
    if (tdKind == null || tdKind == TypedDataKind.uint8Bytes) return null;
    final name = type.element!.name!;
    final spec = switch (tdKind) {
      TypedDataKind.float64 ||
      TypedDataKind.float32 => ('double', 'readDouble()'),
      TypedDataKind.intList => ('int', 'readInt()'),
      TypedDataKind.uint8Bytes => throw StateError('Unreachable'),
    };
    final sfx = _slotSuffix(slot, emptyAtZero: true);
    final uVar = 'u$sfx';
    final lVar = 'l$sfx';
    final indent = slot.indent;
    final out = StringBuffer();
    if (slot.declareType != null) {
      out.writeln('$indent${slot.declareType} ${slot.target};');
    }
    out
      ..writeln('$indent{')
      ..writeln('$indent  final $uVar = ${slot.decoderExpr}.unkeyed();')
      ..writeln('$indent  final $lVar = <${spec.$1}>[];')
      ..writeln('$indent  while ($uVar.moveNext()) {')
      ..writeln('$indent    $lVar.add($uVar.${spec.$2});')
      ..writeln('$indent  }')
      ..writeln('$indent  ${slot.target} = $name.fromList($lVar);')
      ..writeln('$indent}');
    return out.toString();
  }

  static String? _unkeyedDirectReadExpr(DartType? inner, String uVar) {
    if (inner == null || inner.isNullableType) return null;
    if (inner.isDartCoreInt) return '$uVar.readInt()';
    if (inner.isDartCoreDouble) return '$uVar.readDouble()';
    if (inner.isDartCoreNum) return '$uVar.readNum()';
    if (inner.isDartCoreString) return '$uVar.readString()';
    if (inner.isDartCoreBool) return '$uVar.readBool()';
    if (classifyTypedDataKind(inner) == TypedDataKind.uint8Bytes) {
      return '$uVar.readBytes()';
    }
    return null;
  }

  String _inlineCollectionDecodeCode(
    DartType? inner,
    _DecoderSlot slot, {
    required bool isSet,
  }) {
    if (inner == null) {
      throw StateError('Missing element type for nested collection.');
    }
    final sfx = _slotSuffix(slot, emptyAtZero: true);
    final uVar = 'u$sfx';
    final colVar = isSet ? 's$sfx' : 'l$sfx';
    final innerStr = inner.getDisplayString();
    final literal = isSet ? '<$innerStr>{}' : '<$innerStr>[]';
    final indent = slot.indent;
    final directExpr = _unkeyedDirectReadExpr(inner, uVar);

    final out = StringBuffer();
    if (slot.declareType != null) {
      out.writeln('$indent${slot.declareType} ${slot.target};');
    }
    out
      ..writeln('$indent{')
      ..writeln('$indent  final $uVar = ${slot.decoderExpr}.unkeyed();')
      ..writeln('$indent  final $colVar = $literal;')
      ..writeln('$indent  while ($uVar.moveNext()) {');
    if (directExpr != null) {
      out.writeln('$indent    $colVar.add($directExpr);');
    } else {
      final itemVar = 'item$sfx';
      out
        ..write(
          _decoderValueCode(inner, (
            target: itemVar,
            declareType: innerStr,
            decoderExpr: '$uVar.nestedDecoder()',
            indent: '$indent    ',
            depth: slot.depth + 1,
            tag: slot.tag,
          )),
        )
        ..writeln('$indent    $colVar.add($itemVar);');
    }
    out
      ..writeln('$indent  }')
      ..writeln('$indent  ${slot.target} = $colVar;')
      ..writeln('$indent}');
    return out.toString();
  }

  void _writeDecoderReturn(StringBuffer buffer) {
    if (model.fields.isEmpty) {
      final constPrefix = model.isConstConstructor ? 'const ' : '';
      buffer.writeln('  return $constPrefix${model.className}();');
      buffer.writeln('}');
      return;
    }
    buffer.writeln('  return ${model.className}(');
    for (final field in model.fields) {
      final isNullableOrHasDefault = field.isNullable || field.hasDefaultValue;
      final argValue = isNullableOrHasDefault ? field.name : '${field.name}!';

      if (field.isPositional) {
        buffer.writeln('    $argValue,');
      } else {
        buffer.writeln('    ${field.name}: $argValue,');
      }
    }
    buffer.writeln('  );');
    buffer.writeln('}');
  }

  void _writeListDecoder(StringBuffer buffer) {
    final nonIgnoredFields = model.fields.where((f) => !f.ignore).toList();
    final isUniformDouble = model.isUniformDoubleModel;

    buffer.writeln('List<${model.className}> decodeList(Decoder decoder) {');

    if (isUniformDouble) {
      final kCount = nonIgnoredFields.length;
      buffer.writeln(
        '  final flatDoubles = decoder.decodeUniformDoubleList(const [',
      );
      for (final field in nonIgnoredFields) {
        final allAliases = [field.wireName, ...field.aliases];
        final formatted = allAliases.map(escapeDartString).join(', ');
        buffer.writeln('    [$formatted],');
      }
      buffer.writeln('  ]);');
      buffer.writeln('  if (flatDoubles != null) {');
      buffer.writeln('    final count = flatDoubles.length ~/ $kCount;');
      buffer.writeln('    return List<${model.className}>.generate(');
      buffer.writeln('      count,');
      buffer.writeln('      (i) => ${model.className}(');
      for (var k = 0; k < kCount; k++) {
        final field = nonIgnoredFields[k];
        final access = 'flatDoubles[i * $kCount + $k]';
        if (field.isPositional) {
          buffer.writeln('        $access,');
        } else {
          buffer.writeln('        ${field.name}: $access,');
        }
      }
      buffer.writeln('      ),');
      buffer.writeln('      growable: true,');
      buffer.writeln('    );');
      buffer.writeln('  }');
      buffer.writeln();
    }

    buffer.writeln('  final unkeyed = decoder.unkeyed();');
    buffer.writeln('  final list = <${model.className}>[];');
    buffer.writeln('  while (unkeyed.moveNext()) {');
    buffer.writeln('    list.add(decode(unkeyed.nestedDecoder()));');
    buffer.writeln('  }');
    buffer.writeln('  return list;');
    buffer.writeln('}');
  }
}
