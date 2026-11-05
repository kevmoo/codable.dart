// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:source_helper/source_helper.dart';

import 'field_descriptor.dart';
import 'type_helper.dart';
import 'utils.dart';

typedef _DecoderSlot = ({
  String target,
  String? declareType,
  String decoderExpr,
  String indent,
  int depth,
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
      final suffix = toSafeIdentifierSuffix(field.name);
      buffer.writeln(
        "  static const String name$suffix = '${field.wireName}';",
      );
      for (final alias in field.aliases) {
        final aliasSuffix = toSafeIdentifierSuffix(alias);
        buffer.writeln(
          "  static const String alias$suffix$aliasSuffix = '$alias';",
        );
      }
    }

    buffer.writeln();
    buffer.writeln('  // Key Indices for selectKeyIndex()');
    for (final field in nonIgnoredFields) {
      final suffix = toSafeIdentifierSuffix(field.name);
      buffer.writeln('  static const int key$suffix = ${field.keyIndex};');
      for (var i = 0; i < field.aliases.length; i++) {
        final aliasSuffix = toSafeIdentifierSuffix(field.aliases[i]);
        buffer.writeln(
          '  static const int aliasKey$suffix$aliasSuffix = '
          '${field.aliasIndices[i]};',
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
        final suffix = toSafeIdentifierSuffix(field.name);
        buffer.writeln('    $schemaName.name$suffix,');
        for (final alias in field.aliases) {
          final aliasSuffix = toSafeIdentifierSuffix(alias);
          buffer.writeln('    $schemaName.alias$suffix$aliasSuffix,');
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
      out.writeln("    '$constant',");
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
      _collectMapEnumsFromType(field.type, found, seenNames, inMap: false);
    }
    return found;
  }

  static void _collectMapEnumsFromType(
    DartType? type,
    List<EnumElement> found,
    Set<String> seenNames, {
    required bool inMap,
  }) {
    if (type == null) return;
    final el = type.element;
    if (inMap && el is EnumElement && el.name != null) {
      if (seenNames.add(el.name!)) found.add(el);
    }
    if (type is! InterfaceType) return;
    final nextInMap = inMap || type.isDartCoreMap || el?.name == 'Map';
    for (final arg in type.typeArguments) {
      _collectMapEnumsFromType(arg, found, seenNames, inMap: nextInMap);
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
        final suffix = toSafeIdentifierSuffix(reqField.name);
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
        final defaultCode = _formatDefaultValue(field);
        buffer.writeln('  var ${field.name} = $defaultCode;');
      } else if (field.isNullable) {
        buffer.writeln('  $typeStr ${field.name};');
      } else {
        buffer.writeln('  $typeStr? ${field.name};');
      }
    }
  }

  static String _firstTypeArgDisplay(DartType? elemType, DartType container) {
    if (elemType != null) return elemType.getDisplayString();
    if (container is InterfaceType && container.typeArguments.isNotEmpty) {
      return container.typeArguments.first.getDisplayString();
    }
    return 'dynamic';
  }

  String _formatDefaultValue(FieldDescriptor field) {
    var defaultCode = field.defaultValueCode!;
    final isSet =
        field.category == TypeCategory.set ||
        field.nativeCategory == TypeCategory.set;
    if (isSet && defaultCode == 'const {}') {
      final elemType = _firstTypeArgDisplay(field.elementType, field.type);
      defaultCode = 'const <$elemType>{}';
    } else if (defaultCode == 'const {}') {
      final keyType = field.mapKeyType?.getDisplayString() ?? 'dynamic';
      final valType = field.mapValueType?.getDisplayString() ?? 'dynamic';
      defaultCode = 'const <$keyType, $valType>{}';
    } else if (defaultCode == 'const []') {
      final elemType = _firstTypeArgDisplay(field.elementType, field.type);
      defaultCode = 'const <$elemType>[]';
    }
    if (defaultCode.endsWith(';')) {
      defaultCode = defaultCode.substring(0, defaultCode.length - 1);
    }
    return defaultCode;
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
    final suffix = toSafeIdentifierSuffix(field.name);
    buffer.writeln('      case $schemaName.key$suffix:');
    for (final alias in field.aliases) {
      final aliasSuffix = toSafeIdentifierSuffix(alias);
      buffer.writeln('      case $schemaName.aliasKey$suffix$aliasSuffix:');
    }

    if (field.participatesInGoldenMask) {
      buffer.writeln(
        '        if ((seen._value & '
        '$schemaName.${field.name}._value) != 0) {',
      );
      buffer.writeln(
        '          throw const CodableException('
        "'Duplicate field \"${field.wireName}\"');",
      );
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
        buffer.writeln('$indent${field.name} = keyed.decodeFloat64List();');
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
        buffer.writeln('$indent// Unknown type, reading string as fallback');
        buffer.writeln('$indent${field.name} = keyed.readString() as dynamic;');
    }
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
      buffer.writeln(
        '$indent${field.name} = keyed.decodeList('
        'Decodable.fromFunction((d) => d.singleValue().readString() as dynamic));',
      );
      return;
    }

    final isNullable = elemType.isNullableType;
    if (!isNullable &&
        _tryWriteNonNullFastListRead(buffer, field, elemType, indent: indent)) {
      return;
    }
    if (!isNullable &&
        (elemType.isDartCoreList || elemType.element?.name == 'List')) {
      _writeNestedListRead(buffer, field, elemType, indent: indent);
      return;
    }
    if (elemType.isDartCoreMap || elemType.element?.name == 'Map') {
      buffer.write(
        _inlineCollectionDecodeCode(elemType, (
          target: field.name,
          declareType: null,
          decoderExpr: 'keyed.nestedDecoder()',
          indent: indent,
          depth: 0,
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
    final elemTypeStr = elemType.getDisplayString();
    buffer.writeln(
      '$indent${field.name} = keyed.decodeList<$elemTypeStr>('
      'Decodable.fromFunction((d) => d.singleValue().readString() as dynamic));',
    );
  }

  bool _tryWriteTypedDataListRead(
    StringBuffer buffer,
    FieldDescriptor field, {
    required String indent,
  }) {
    switch (field.type.element?.name) {
      case 'Float64List':
        buffer.writeln('$indent${field.name} = keyed.decodeFloat64List();');
        return true;
      case 'Int64List':
        buffer.writeln(
          '$indent${field.name} = Int64List.fromList(keyed.decodeIntList());',
        );
        return true;
      case 'Int32List':
        buffer.writeln(
          '$indent${field.name} = Int32List.fromList(keyed.decodeIntList());',
        );
        return true;
      case 'Uint8List':
        buffer.writeln('$indent${field.name} = keyed.readBytes();');
        return true;
      case 'Float32List':
        buffer.writeln(
          '$indent${field.name} = Float32List.fromList(keyed.decodeDoubleList());',
        );
        return true;
      default:
        return false;
    }
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
    final loopSpec = _unkeyedTypedLoopSpec(elemType.element?.name);
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

  static (String, String)? _unkeyedTypedLoopSpec(String? elemName) =>
      switch (elemName) {
        'Uint8List' => ('Uint8List', 'u.readBytes()'),
        'Float64List' => ('Float64List', 'u.decodeFloat64List()'),
        'Int64List' => ('Int64List', 'Int64List.fromList(u.decodeIntList())'),
        _ => null,
      };

  void _writeNestedListRead(
    StringBuffer buffer,
    FieldDescriptor field,
    DartType elemType, {
    required String indent,
  }) {
    final inner = elemType is InterfaceType && elemType.typeArguments.isNotEmpty
        ? elemType.typeArguments.first
        : null;
    final fastSpec = inner != null ? _nestedFastListSpec(inner) : null;
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
    buffer.writeln(
      '$indent${field.name} = keyed.decodeList(${_generateUnkeyedElementExpr(elemType)});',
    );
  }

  static (String, String)? _nestedFastListSpec(DartType inner) {
    if (inner.element?.name == 'Float64List') {
      return ('Float64List', 'u.decodeFloat64List()');
    }
    final fastCall = _fastPrimitiveListCall(inner);
    if (fastCall != null) {
      return ('List<${inner.getDisplayString()}>', 'u.$fastCall');
    }
    return null;
  }

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

  static String _enumDecodableExpr(
    String enumName, {
    required bool isNullable,
  }) => isNullable
      ? 'Decodable.fromFunction((d) { '
            'final v = d.singleValue().readNullableString(); '
            'return v == null ? null : $enumName.values.byName(v); })'
      : 'Decodable.fromFunction('
            '(d) => $enumName.values.byName(d.singleValue().readString()))';

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
    final typedData = _tryGenerateTypedDataElementExpr(type);
    if (typedData != null) return typedData;
    if (type.element != null &&
        const TypeClassifier().isCodableElement(type.element!)) {
      final nestedName = type.element!.name;
      return type.isNullableType
          ? 'Decodable.fromFunction((d) { if (d.singleValue().isNull()) { d.singleValue().readNull(); return null; } return const ${nestedName}Codable().decode(d); })'
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
    if (type.isNullableType) {
      final innerExpr = inner == null
          ? 'Decodable.fromFunction((d) => d.singleValue().readString() as dynamic)'
          : _generateUnkeyedElementExpr(inner);
      return 'Decodable.fromFunction((d) { if (d.singleValue().isNull()) { d.singleValue().readNull(); return null; } return d.unkeyed().decodeList($innerExpr); })';
    }
    if (inner == null) {
      return 'Decodable.fromFunction((d) => d.unkeyed().decodeList(Decodable.fromFunction((d) => d.singleValue().readString() as dynamic)))';
    }
    final fastCall = _unkeyedFastInnerListCall(inner);
    if (fastCall != null) {
      return 'Decodable.fromFunction((d) => d.unkeyed().$fastCall)';
    }
    return 'Decodable.fromFunction((d) => d.unkeyed().decodeList(${_generateUnkeyedElementExpr(inner)}))';
  }

  static String? _unkeyedFastInnerListCall(DartType inner) {
    if (inner.element?.name == 'Float64List') return 'decodeFloat64List()';
    return _fastPrimitiveListCall(inner);
  }

  static String? _tryGenerateTypedDataElementExpr(DartType type) {
    switch (type.element?.name) {
      case 'Float64List':
        return 'Decodable.fromFunction((d) => d.unkeyed().decodeFloat64List())';
      case 'Int64List':
        return 'Decodable.fromFunction((d) => Int64List.fromList(d.unkeyed().decodeIntList()))';
      case 'Int32List':
        return 'Decodable.fromFunction((d) => Int32List.fromList(d.unkeyed().decodeIntList()))';
      case 'Uint8List':
        final method = type.isNullableType ? 'readNullableBytes' : 'readBytes';
        return 'Decodable.fromFunction((d) => d.singleValue().$method())';
      case 'Float32List':
        return 'Decodable.fromFunction((d) => Float32List.fromList(d.unkeyed().decodeDoubleList()))';
      default:
        return null;
    }
  }

  static String _generatePrimitiveUnkeyedElementExpr(DartType type) {
    final method = _primitiveSingleValueReadMethod(type);
    if (method != null) {
      return 'Decodable.fromFunction((d) => d.singleValue().$method())';
    }
    return 'Decodable.fromFunction((d) => d.singleValue().readString() as dynamic)';
  }

  static (String, String)? _primitiveSingleValueMethods(DartType type) {
    if (type.isDartCoreInt) return ('readInt', 'readNullableInt');
    if (type.isDartCoreDouble) return ('readDouble', 'readNullableDouble');
    if (type.isDartCoreNum) return ('readNum', 'readNullableNum');
    if (type.isDartCoreString) return ('readString', 'readNullableString');
    if (type.isDartCoreBool) return ('readBool', 'readNullableBool');
    if (type.element?.name == 'Uint8List') {
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
    if (elemType != null) {
      final fastSet = _tryFastOrPrimitiveSetLine(field.name, elemType, indent);
      if (fastSet != null) {
        buffer.writeln(fastSet);
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
    }
    final elemTypeStr = elemType?.getDisplayString() ?? 'dynamic';
    buffer.writeln(
      '$indent${field.name} = keyed.decodeList<$elemTypeStr>('
      'Decodable.fromFunction((d) => d.singleValue().readString() as dynamic)).toSet();',
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
      )),
    );
  }

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
    final sfx = slot.depth == 0 ? '' : '${slot.depth}';
    final kVar = 'k$sfx';
    final mapVar = 'm$sfx';
    final keyVar = 'key$sfx';
    final valTypeStr = valType?.getDisplayString() ?? 'dynamic';
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
      return '${slot.indent}${slot.target} = $kVar.readString() as dynamic;\n';
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
    final idxVar = 'enumIdx${slot.depth}';
    return '${indent}final $idxVar = $kVar.selectStringIndex($optRef);\n'
        '${indent}if ($idxVar < 0 || $idxVar >= $enumName.values.length) {\n'
        "$indent  throw const CodableException('Unknown $enumName value');\n"
        '$indent}\n'
        '$indent${slot.target} = $enumName.values[$idxVar];\n';
  }

  static String? _keyedDirectCollectionDecodeExpr(DartType type, String kVar) {
    final typedExpr = switch (type.element?.name) {
      'Float64List' => '$kVar.decodeFloat64List()',
      'Float32List' => 'Float32List.fromList($kVar.decodeDoubleList())',
      'Int64List' => 'Int64List.fromList($kVar.decodeIntList())',
      'Int32List' => 'Int32List.fromList($kVar.decodeIntList())',
      _ => null,
    };
    if (typedExpr != null) return typedExpr;
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
    final sfx = slot.depth == 0 ? '' : '${slot.depth}';
    final mDecVar = 'mDecoder$sfx';
    final mapVar = 'm$sfx';
    final keyVar = 'key$sfx';
    final keyTypeStr = keyType?.getDisplayString() ?? 'dynamic';
    final valTypeStr = valType?.getDisplayString() ?? 'dynamic';
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
        )),
      )
      ..write(
        _decoderValueCode(valType, (
          target: '$mapVar[$keyVar]',
          declareType: null,
          decoderExpr: '$mDecVar.valueDecoder()',
          indent: bodyIndent,
          depth: slot.depth + 1,
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
      return '${slot.indent}$assignLhs = '
          '${slot.decoderExpr}.singleValue().readString() as dynamic;\n';
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
    final decVar = 'dec${slot.depth}';
    final svVar = 'sv${slot.depth}';
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
    final idxVar = 'enumIdx${slot.depth}';
    if (!type.isNullableType) {
      final assignLhs = slot.declareType != null
          ? 'final ${slot.target}'
          : slot.target;
      return '${indent}final $idxVar = '
          '$optRef.indexOf(${slot.decoderExpr}.singleValue().readString());\n'
          '${indent}if ($idxVar < 0) {\n'
          "$indent  throw const CodableException('Unknown $enumName value');\n"
          '$indent}\n'
          '$indent$assignLhs = $enumName.values[$idxVar];\n';
    }
    final rawVar = 'rawEnum${slot.depth}';
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
        "$indent    throw const CodableException('Unknown $enumName value');",
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
    final name = type.element?.name;
    final typedCode = _tryTypedDataDecodeCode(name, slot);
    if (typedCode != null) return typedCode;
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
    return '${slot.indent}$assignLhs = '
        '${slot.decoderExpr}.singleValue().readString() as dynamic;\n';
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

  static String? _tryTypedDataDecodeCode(String? name, _DecoderSlot slot) {
    final spec = switch (name) {
      'Float64List' => ('double', 'readDouble()'),
      'Float32List' => ('double', 'readDouble()'),
      'Int64List' => ('int', 'readInt()'),
      'Int32List' => ('int', 'readInt()'),
      _ => null,
    };
    if (spec == null) return null;
    final sfx = slot.depth == 0 ? '' : '${slot.depth}';
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
    if (inner.element?.name == 'Uint8List') return '$uVar.readBytes()';
    return null;
  }

  String _inlineCollectionDecodeCode(
    DartType? inner,
    _DecoderSlot slot, {
    required bool isSet,
  }) {
    final sfx = slot.depth == 0 ? '' : '${slot.depth}';
    final uVar = 'u$sfx';
    final colVar = isSet ? 's$sfx' : 'l$sfx';
    final innerStr = inner?.getDisplayString() ?? 'dynamic';
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
        final formatted = allAliases.map((a) => "'$a'").join(', ');
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
