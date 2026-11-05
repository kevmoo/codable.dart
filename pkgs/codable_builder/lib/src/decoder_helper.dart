// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:source_helper/source_helper.dart';

import 'field_descriptor.dart';
import 'type_helper.dart';
import 'utils.dart';

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

    // String Name Constants
    buffer.writeln('  // String Name Constants');
    for (final field in nonIgnoredFields) {
      final suffix = toSafeIdentifierSuffix(field.name);
      buffer.writeln(
        "  static const String name$suffix = '${field.wireName}';",
      );
      for (var i = 0; i < field.aliases.length; i++) {
        final aliasSuffix = toSafeIdentifierSuffix(field.aliases[i]);
        buffer.writeln(
          '  static const String alias$suffix$aliasSuffix = '
          "'${field.aliases[i]}';",
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
        for (var i = 0; i < field.aliases.length; i++) {
          final aliasSuffix = toSafeIdentifierSuffix(field.aliases[i]);
          buffer.writeln('    $schemaName.alias$suffix$aliasSuffix,');
        }
      }
      buffer.writeln('  ]);');
    }
    buffer.writeln('  static final KeyOptions keyOptions = options;');

    // Enum Options
    _writeSchemaEnumOptions(buffer, nonIgnoredFields);

    _writeSchemaBitmaskValidation(buffer, schemaName);

    buffer.writeln('}');
  }

  void _writeSchemaEnumOptions(
    StringBuffer buffer,
    List<FieldDescriptor> nonIgnoredFields,
  ) {
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
      buffer.writeln();
      buffer.writeln('  // Enum Options for ${field.name}');
      buffer.writeln(
        '  static final KeyOptions ${field.name}EnumOptions = '
        'KeyOptions.of(const [',
      );
      for (final constant in constants) {
        buffer.writeln("    '$constant',");
      }
      buffer.writeln('  ]);');
      buffer.writeln(
        '  static final KeyOptions ${field.name}KeyOptions = '
        '${field.name}EnumOptions;',
      );
    }
  }

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

  String _formatDefaultValue(FieldDescriptor field) {
    var defaultCode = field.defaultValueCode!;
    if (field.category == TypeCategory.set && defaultCode == 'const {}') {
      final elemType =
          field.elementType?.getDisplayString() ??
          (field.type is InterfaceType &&
                  (field.type as InterfaceType).typeArguments.isNotEmpty
              ? (field.type as InterfaceType).typeArguments.first
                    .getDisplayString()
              : 'dynamic');
      defaultCode = 'const <$elemType>{};';
    } else if (defaultCode == 'const {}') {
      final valType = field.mapValueType?.getDisplayString() ?? 'dynamic';
      defaultCode = 'const <String, $valType>{};';
    } else if (defaultCode == 'const []') {
      final elemType =
          field.elementType?.getDisplayString() ??
          (field.type is InterfaceType &&
                  (field.type as InterfaceType).typeArguments.isNotEmpty
              ? (field.type as InterfaceType).typeArguments.first
                    .getDisplayString()
              : 'dynamic');
      defaultCode = 'const <$elemType>[];';
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
    for (var i = 0; i < field.aliases.length; i++) {
      final aliasSuffix = toSafeIdentifierSuffix(field.aliases[i]);
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
        buffer.writeln(
          '$indent${field.name} = Uint8List.fromList(keyed.decodeIntList());',
        );
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

  bool _tryWriteNonNullFastListRead(
    StringBuffer buffer,
    FieldDescriptor field,
    DartType elemType, {
    required String indent,
  }) {
    if (elemType.isDartCoreInt) {
      buffer.writeln('$indent${field.name} = keyed.decodeIntList();');
      return true;
    }
    if (elemType.isDartCoreDouble) {
      buffer.writeln('$indent${field.name} = keyed.decodeDoubleList();');
      return true;
    }
    if (elemType.isDartCoreNum) {
      buffer.writeln(
        '$indent${field.name} = keyed.decodeList<num>('
        'Decodable.fromFunction((d) => d.singleValue().readNum()));',
      );
      return true;
    }
    if (elemType.isDartCoreString) {
      buffer.writeln('$indent${field.name} = keyed.decodeStringList();');
      return true;
    }
    if (elemType.isDartCoreBool) {
      buffer.writeln('$indent${field.name} = keyed.decodeBoolList();');
      return true;
    }
    if (elemType.element?.name == 'Float64List') {
      _writeUnkeyedLoopListRead(
        buffer,
        field.name,
        'Float64List',
        'u.decodeFloat64List()',
        indent: indent,
      );
      return true;
    }
    if (elemType.element?.name == 'Int64List') {
      _writeUnkeyedLoopListRead(
        buffer,
        field.name,
        'Int64List',
        'Int64List.fromList(u.decodeIntList())',
        indent: indent,
      );
      return true;
    }
    return false;
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

  (String, String)? _nestedFastListSpec(DartType inner) {
    if (inner.element?.name == 'Float64List') {
      return ('Float64List', 'u.decodeFloat64List()');
    }
    if (inner.isNullableType) return null;
    if (inner.isDartCoreDouble) return ('List<double>', 'u.decodeDoubleList()');
    if (inner.isDartCoreInt) return ('List<int>', 'u.decodeIntList()');
    if (inner.isDartCoreString) return ('List<String>', 'u.decodeStringList()');
    if (inner.isDartCoreBool) return ('List<bool>', 'u.decodeBoolList()');
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
    if (elemType.isNullableType) {
      buffer.writeln(
        '$indent${field.name} = keyed.decodeList(Decodable.fromFunction((d) { '
        'final v = d.singleValue().readNullableString(); '
        'return v == null ? null : $enumName.values.byName(v); }));',
      );
    } else {
      buffer.writeln(
        '$indent${field.name} = keyed.decodeList('
        'Decodable.fromFunction((d) => $enumName.values.byName(d.singleValue().readString())));',
      );
    }
  }

  void _writeCodableListRead(
    StringBuffer buffer,
    FieldDescriptor field,
    DartType elemType, {
    required String indent,
  }) {
    final nestedName = elemType.element!.name;
    if (elemType.isNullableType) {
      buffer.writeln(
        '$indent{\n'
        '$indent  final u = keyed.nestedDecoder().unkeyed();\n'
        '$indent  final l = <$nestedName?>[];\n'
        '$indent  while (u.moveNext()) {\n'
        '$indent    if (u.isNextNull()) {\n'
        '$indent      u.readNull();\n'
        '$indent      l.add(null);\n'
        '$indent    } else {\n'
        '$indent      l.add(const ${nestedName}Codable().decode(u.nestedDecoder()));\n'
        '$indent    }\n'
        '$indent  }\n'
        '$indent  ${field.name} = l;\n'
        '$indent}',
      );
    } else {
      buffer.writeln(
        '$indent${field.name} = '
        'const ${nestedName}Codable().decodeList(keyed.nestedDecoder());',
      );
    }
  }

  bool _tryWriteNullablePrimitiveListRead(
    StringBuffer buffer,
    FieldDescriptor field,
    DartType elemType, {
    required String indent,
  }) {
    final spec = _nullablePrimitiveListSpec(elemType);
    if (spec == null) return false;
    buffer.writeln(
      '$indent${field.name} = keyed.decodeList<${spec.$1}>('
      'Decodable.fromFunction((d) => d.singleValue().${spec.$2}()));',
    );
    return true;
  }

  (String, String)? _nullablePrimitiveListSpec(DartType elemType) {
    if (elemType.isDartCoreString) return ('String?', 'readNullableString');
    if (elemType.isDartCoreInt) return ('int?', 'readNullableInt');
    if (elemType.isDartCoreDouble) return ('double?', 'readNullableDouble');
    if (elemType.isDartCoreNum) return ('num?', 'readNullableNum');
    if (elemType.isDartCoreBool) return ('bool?', 'readNullableBool');
    return null;
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
      final enumName = type.element!.name;
      return type.isNullableType
          ? 'Decodable.fromFunction((d) { final v = d.singleValue().readNullableString(); return v == null ? null : $enumName.values.byName(v); })'
          : 'Decodable.fromFunction((d) => $enumName.values.byName(d.singleValue().readString()))';
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

  String? _unkeyedFastInnerListCall(DartType inner) {
    if (inner.element?.name == 'Float64List') return 'decodeFloat64List()';
    if (inner.isNullableType) return null;
    if (inner.isDartCoreDouble) return 'decodeDoubleList()';
    if (inner.isDartCoreInt) return 'decodeIntList()';
    if (inner.isDartCoreString) return 'decodeStringList()';
    if (inner.isDartCoreBool) return 'decodeBoolList()';
    return null;
  }

  String? _tryGenerateTypedDataElementExpr(DartType type) {
    switch (type.element?.name) {
      case 'Float64List':
        return 'Decodable.fromFunction((d) => d.unkeyed().decodeFloat64List())';
      case 'Int64List':
        return 'Decodable.fromFunction((d) => Int64List.fromList(d.unkeyed().decodeIntList()))';
      case 'Int32List':
        return 'Decodable.fromFunction((d) => Int32List.fromList(d.unkeyed().decodeIntList()))';
      case 'Uint8List':
        return 'Decodable.fromFunction((d) => Uint8List.fromList(d.unkeyed().decodeIntList()))';
      case 'Float32List':
        return 'Decodable.fromFunction((d) => Float32List.fromList(d.unkeyed().decodeDoubleList()))';
      default:
        return null;
    }
  }

  String _generatePrimitiveUnkeyedElementExpr(DartType type) {
    final method = _primitiveSingleValueReadMethod(type);
    if (method != null) {
      return 'Decodable.fromFunction((d) => d.singleValue().$method())';
    }
    return 'Decodable.fromFunction((d) => d.singleValue().readString() as dynamic)';
  }

  String? _primitiveSingleValueReadMethod(DartType type) {
    final nullable = type.isNullableType;
    if (type.isDartCoreInt) return nullable ? 'readNullableInt' : 'readInt';
    if (type.isDartCoreDouble) {
      return nullable ? 'readNullableDouble' : 'readDouble';
    }
    if (type.isDartCoreNum) return nullable ? 'readNullableNum' : 'readNum';
    if (type.isDartCoreString) {
      return nullable ? 'readNullableString' : 'readString';
    }
    if (type.isDartCoreBool) return nullable ? 'readNullableBool' : 'readBool';
    return null;
  }

  void _writeKeyedSetRead(
    StringBuffer buffer,
    FieldDescriptor field, {
    required String indent,
  }) {
    final elemType = field.elementType;
    final elemTypeStr = elemType?.getDisplayString() ?? 'dynamic';
    final isNullable = elemType?.isNullableType ?? false;
    if (elemType != null && elemType.isDartCoreString && !isNullable) {
      buffer.writeln(
        '$indent${field.name} = keyed.decodeStringList().toSet();',
      );
    } else if (elemType != null && elemType.isDartCoreInt && !isNullable) {
      buffer.writeln('$indent${field.name} = keyed.decodeIntList().toSet();');
    } else if (elemType != null && elemType.isDartCoreString && isNullable) {
      buffer.writeln(
        '$indent${field.name} = keyed.decodeList<String?>('
        'Decodable.fromFunction((d) => d.singleValue().readNullableString())).toSet();',
      );
    } else if (elemType != null && elemType.isDartCoreInt && isNullable) {
      buffer.writeln(
        '$indent${field.name} = keyed.decodeList<int?>('
        'Decodable.fromFunction((d) => d.singleValue().readNullableInt())).toSet();',
      );
    } else if (elemType != null && elemType.isDartCoreDouble && !isNullable) {
      buffer.writeln(
        '$indent${field.name} = keyed.decodeDoubleList().toSet();',
      );
    } else if (elemType != null && elemType.isDartCoreNum && !isNullable) {
      buffer.writeln(
        '$indent${field.name} = keyed.decodeList<num>('
        'Decodable.fromFunction((d) => d.singleValue().readNum())).toSet();',
      );
    } else if (elemType != null && elemType.isDartCoreDouble && isNullable) {
      buffer.writeln(
        '$indent${field.name} = keyed.decodeList<double?>('
        'Decodable.fromFunction((d) => d.singleValue().readNullableDouble())).toSet();',
      );
    } else if (elemType != null && elemType.isDartCoreNum && isNullable) {
      buffer.writeln(
        '$indent${field.name} = keyed.decodeList<num?>('
        'Decodable.fromFunction((d) => d.singleValue().readNullableNum())).toSet();',
      );
    } else if (elemType != null && elemType.isDartCoreBool && !isNullable) {
      buffer.writeln('$indent${field.name} = keyed.decodeBoolList().toSet();');
    } else if (elemType != null && elemType.isDartCoreBool && isNullable) {
      buffer.writeln(
        '$indent${field.name} = keyed.decodeList<bool?>('
        'Decodable.fromFunction((d) => d.singleValue().readNullableBool())).toSet();',
      );
    } else if (elemType != null && elemType.element is EnumElement) {
      final enumName = elemType.element!.name;
      if (isNullable) {
        buffer.writeln(
          '$indent${field.name} = keyed.decodeList(Decodable.fromFunction((d) { '
          'final v = d.singleValue().readNullableString(); '
          'return v == null ? null : $enumName.values.byName(v); })).toSet();',
        );
      } else {
        buffer.writeln(
          '$indent${field.name} = keyed.decodeList('
          'Decodable.fromFunction((d) => $enumName.values.byName(d.singleValue().readString()))).toSet();',
        );
      }
    } else if (elemType != null &&
        elemType.element != null &&
        const TypeClassifier().isCodableElement(elemType.element!)) {
      final nestedName = elemType.element!.name;
      if (isNullable) {
        buffer.writeln(
          '$indent{\n'
          '$indent  final u = keyed.nestedDecoder().unkeyed();\n'
          '$indent  final s = <$nestedName?>{};\n'
          '$indent  while (u.moveNext()) {\n'
          '$indent    if (u.isNextNull()) {\n'
          '$indent      u.readNull();\n'
          '$indent      s.add(null);\n'
          '$indent    } else {\n'
          '$indent      s.add(const ${nestedName}Codable().decode(u.nestedDecoder()));\n'
          '$indent    }\n'
          '$indent  }\n'
          '$indent  ${field.name} = s;\n'
          '$indent}',
        );
      } else {
        buffer.writeln(
          '$indent${field.name} = '
          'const ${nestedName}Codable().decodeList(keyed.nestedDecoder()).toSet();',
        );
      }
    } else {
      buffer.writeln(
        '$indent${field.name} = keyed.decodeList<$elemTypeStr>('
        'Decodable.fromFunction((d) => d.singleValue().readString() as dynamic)).toSet();',
      );
    }
  }

  void _writeKeyedMapRead(
    StringBuffer buffer,
    FieldDescriptor field, {
    required String indent,
  }) {
    final valType = field.mapValueType;
    final valTypeStr = valType?.getDisplayString() ?? 'dynamic';
    final isValNullable = valType?.isNullableType ?? false;
    final String readExpr;
    if (valType != null && valType.isDartCoreString) {
      readExpr = 'k.readString()';
    } else if (valType != null && valType.isDartCoreInt) {
      readExpr = 'k.readInt()';
    } else if (valType != null && valType.isDartCoreDouble) {
      readExpr = 'k.readDouble()';
    } else if (valType != null && valType.isDartCoreNum) {
      readExpr = 'k.readNum()';
    } else if (valType != null && valType.isDartCoreBool) {
      readExpr = 'k.readBool()';
    } else if (valType != null &&
        valType.element != null &&
        const TypeClassifier().isCodableElement(valType.element!)) {
      final nestedName = valType.element!.name;
      readExpr = 'const ${nestedName}Codable().decode(k.nestedDecoder())';
    } else {
      readExpr = 'k.readString() as dynamic';
    }

    buffer.writeln(
      '$indent{\n'
      '$indent  final k = keyed.nestedDecoder().keyed();\n'
      '$indent  final m = <String, $valTypeStr>{};\n'
      '$indent  while (k.moveNextKey()) {\n'
      '$indent    final key = k.nextKey();',
    );
    if (isValNullable) {
      buffer.writeln('$indent    if (k.isNextNull()) {');
      buffer.writeln('$indent      k.readNull();');
      buffer.writeln('$indent      m[key] = null as $valTypeStr;');
      buffer.writeln('$indent    } else {');
      buffer.writeln('$indent      m[key] = $readExpr;');
      buffer.writeln('$indent    }');
    } else {
      buffer.writeln('$indent    m[key] = $readExpr;');
    }
    buffer.writeln(
      '$indent  }\n'
      '$indent  ${field.name} = m;\n'
      '$indent}',
    );
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
