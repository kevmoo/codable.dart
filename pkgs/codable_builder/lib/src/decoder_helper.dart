// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// ignore_for_file: deprecated_member_use, lines_longer_than_80_chars

import 'dart:convert';

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';

import 'field_descriptor.dart';
import 'type_helper.dart';
import 'utils.dart';

/// Emits the unified `_$ModelSchema` extension type and universal
/// `_$ModelFromDecoder` deserializer.
final class DecoderGeneratorHelper {
  final ModelDescriptor model;

  DecoderGeneratorHelper(this.model);

  /// Generates the complete decoder code for [model].
  String generate() {
    final buffer = StringBuffer();
    _writeSchema(buffer);
    buffer.writeln();
    if (model.createDecoder) {
      _writeDecoder(buffer);
      buffer.writeln();
      _writeListDecoder(buffer);
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
    buffer.writeln('  // Pre-encoded UTF-8 Wire Name Bytes and StaticKeys');
    for (final field in nonIgnoredFields) {
      final suffix = toSafeIdentifierSuffix(field.name);
      final encoded = utf8.encode(jsonEncode(field.wireName));
      buffer.writeln(
        '  static const List<int> wireNameBytes$suffix = $encoded;',
      );
      buffer.writeln(
        '  static const StaticKey staticKey$suffix = '
        'StaticKey(name$suffix, key$suffix, wireNameBytes$suffix);',
      );
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
    for (final field in nonIgnoredFields) {
      if (field.category == TypeCategory.enumType &&
          field.enumConstants != null &&
          field.enumConstants!.isNotEmpty) {
        buffer.writeln();
        buffer.writeln('  // Enum Options for ${field.name}');
        buffer.writeln(
          '  static final KeyOptions ${field.name}EnumOptions = '
          'KeyOptions.of(const [',
        );
        for (final constant in field.enumConstants!) {
          buffer.writeln("    '$constant',");
        }
        buffer.writeln('  ]);');
        buffer.writeln(
          '  static final KeyOptions ${field.name}KeyOptions = '
          '${field.name}EnumOptions;',
        );
      }
    }

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

    buffer.writeln('}');
  }

  void _writeDecoder(StringBuffer buffer) {
    final schemaName = '_\$${model.className}Schema';
    final decoderFuncName = '_\$${model.className}FromDecoder';

    buffer.writeln(
      '// =============================================================================',
    );
    buffer.writeln('// 2. Universal Keyed Deserializer for ${model.className}');
    buffer.writeln(
      '// =============================================================================',
    );
    buffer.writeln('${model.className} $decoderFuncName(Decoder decoder) {');
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
    buffer.writeln('  while (keyed.hasNextKey()) {');
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
      buffer.writeln('        if (keyed.isNextNull()) {');
      buffer.writeln('          keyed.readNull();');
      buffer.writeln('        } else {');
      _writeKeyedFieldRead(buffer, field, indent: '          ');
      if (field.participatesInGoldenMask) {
        buffer.writeln('          seen |= $schemaName.${field.name};');
      }
      buffer.writeln('        }');
    }
    buffer.writeln('        break;');
  }

  void _writeKeyedFieldRead(
    StringBuffer buffer,
    FieldDescriptor field, {
    required String indent,
  }) {
    switch (field.category) {
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
        buffer.writeln(
          '$indent${field.name} = '
          'keyed.decodeValue(${field.customDecoderCode}.decode);',
        );
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
          'keyed.decodeValue(_\$${nestedName}FromDecoder);',
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
    final typeName = field.type.element?.name;
    if (typeName == 'Float64List') {
      buffer.writeln('$indent${field.name} = keyed.decodeFloat64List();');
      return;
    } else if (typeName == 'Int64List') {
      buffer.writeln(
        '$indent${field.name} = Int64List.fromList(keyed.decodeIntList());',
      );
      return;
    } else if (typeName == 'Int32List') {
      buffer.writeln(
        '$indent${field.name} = Int32List.fromList(keyed.decodeIntList());',
      );
      return;
    } else if (typeName == 'Uint8List') {
      buffer.writeln(
        '$indent${field.name} = Uint8List.fromList(keyed.decodeIntList());',
      );
      return;
    } else if (typeName == 'Float32List') {
      buffer.writeln(
        '$indent${field.name} = Float32List.fromList(keyed.decodeDoubleList());',
      );
      return;
    }

    final elemType = field.elementType;
    final isNullable = elemType?.isNullableType ?? false;
    if (elemType == null) {
      buffer.writeln(
        '$indent${field.name} = keyed.decodeList('
        '(d) => d.singleValue().readString() as dynamic);',
      );
    } else if (elemType.isDartCoreInt && !isNullable) {
      buffer.writeln('$indent${field.name} = keyed.decodeIntList();');
    } else if ((elemType.isDartCoreDouble || elemType.isDartCoreNum) &&
        !isNullable) {
      buffer.writeln('$indent${field.name} = keyed.decodeDoubleList();');
    } else if (elemType.isDartCoreString && !isNullable) {
      buffer.writeln('$indent${field.name} = keyed.decodeStringList();');
    } else if (elemType.isDartCoreBool && !isNullable) {
      buffer.writeln('$indent${field.name} = keyed.decodeBoolList();');
    } else if (elemType.element?.name == 'Float64List' && !isNullable) {
      buffer.writeln(
        '$indent{\n'
        '$indent  final u = keyed.decodeValue((d) => d.unkeyed());\n'
        '$indent  final l = <Float64List>[];\n'
        '$indent  while (u.hasNext()) {\n'
        '$indent    l.add(u.decodeFloat64List());\n'
        '$indent  }\n'
        '$indent  ${field.name} = l;\n'
        '$indent}',
      );
    } else if (elemType.element?.name == 'Int64List' && !isNullable) {
      buffer.writeln(
        '$indent{\n'
        '$indent  final u = keyed.decodeValue((d) => d.unkeyed());\n'
        '$indent  final l = <Int64List>[];\n'
        '$indent  while (u.hasNext()) {\n'
        '$indent    l.add(Int64List.fromList(u.decodeIntList()));\n'
        '$indent  }\n'
        '$indent  ${field.name} = l;\n'
        '$indent}',
      );
    } else if (!isNullable &&
        (elemType.isDartCoreList || elemType.element?.name == 'List')) {
      final inner =
          elemType is InterfaceType && elemType.typeArguments.isNotEmpty
          ? elemType.typeArguments.first
          : null;
      if (inner != null && inner.isDartCoreDouble && !inner.isNullableType) {
        buffer.writeln(
          '$indent{\n'
          '$indent  final u = keyed.decodeValue((d) => d.unkeyed());\n'
          '$indent  final l = <List<double>>[];\n'
          '$indent  while (u.hasNext()) {\n'
          '$indent    l.add(u.decodeDoubleList());\n'
          '$indent  }\n'
          '$indent  ${field.name} = l;\n'
          '$indent}',
        );
      } else if (inner != null && inner.element?.name == 'Float64List') {
        buffer.writeln(
          '$indent{\n'
          '$indent  final u = keyed.decodeValue((d) => d.unkeyed());\n'
          '$indent  final l = <Float64List>[];\n'
          '$indent  while (u.hasNext()) {\n'
          '$indent    l.add(u.decodeFloat64List());\n'
          '$indent  }\n'
          '$indent  ${field.name} = l;\n'
          '$indent}',
        );
      } else if (inner != null &&
          inner.isDartCoreInt &&
          !inner.isNullableType) {
        buffer.writeln(
          '$indent{\n'
          '$indent  final u = keyed.decodeValue((d) => d.unkeyed());\n'
          '$indent  final l = <List<int>>[];\n'
          '$indent  while (u.hasNext()) {\n'
          '$indent    l.add(u.decodeIntList());\n'
          '$indent  }\n'
          '$indent  ${field.name} = l;\n'
          '$indent}',
        );
      } else if (inner != null &&
          inner.isDartCoreString &&
          !inner.isNullableType) {
        buffer.writeln(
          '$indent{\n'
          '$indent  final u = keyed.decodeValue((d) => d.unkeyed());\n'
          '$indent  final l = <List<String>>[];\n'
          '$indent  while (u.hasNext()) {\n'
          '$indent    l.add(u.decodeStringList());\n'
          '$indent  }\n'
          '$indent  ${field.name} = l;\n'
          '$indent}',
        );
      } else if (inner != null &&
          inner.isDartCoreBool &&
          !inner.isNullableType) {
        buffer.writeln(
          '$indent{\n'
          '$indent  final u = keyed.decodeValue((d) => d.unkeyed());\n'
          '$indent  final l = <List<bool>>[];\n'
          '$indent  while (u.hasNext()) {\n'
          '$indent    l.add(u.decodeBoolList());\n'
          '$indent  }\n'
          '$indent  ${field.name} = l;\n'
          '$indent}',
        );
      } else {
        buffer.writeln(
          '$indent${field.name} = keyed.decodeList(${_generateUnkeyedElementExpr(elemType)});',
        );
      }
    } else if (elemType.element is EnumElement) {
      final enumName = elemType.element!.name;
      if (isNullable) {
        buffer.writeln(
          '$indent${field.name} = keyed.decodeList((d) { '
          'final v = d.singleValue().readNullableString(); '
          'return v == null ? null : $enumName.values.byName(v); });',
        );
      } else {
        buffer.writeln(
          '$indent${field.name} = keyed.decodeList('
          '(d) => $enumName.values.byName(d.singleValue().readString()));',
        );
      }
    } else if (elemType.element != null &&
        const TypeClassifier().isCodableElement(elemType.element!)) {
      final nestedName = elemType.element!.name;
      if (isNullable) {
        buffer.writeln(
          '$indent${field.name} = keyed.decodeList((d) { '
          'if (d.singleValue().isNull()) { '
          'd.singleValue().readNull(); return null; } '
          'return _\$${nestedName}FromDecoder(d); });',
        );
      } else {
        buffer.writeln(
          '$indent${field.name} = '
          'keyed.decodeValue(_\$${nestedName}ListFromDecoder);',
        );
      }
    } else if (elemType.isDartCoreString && isNullable) {
      buffer.writeln(
        '$indent${field.name} = keyed.decodeList<String?>('
        '(d) => d.singleValue().readNullableString());',
      );
    } else if (elemType.isDartCoreInt && isNullable) {
      buffer.writeln(
        '$indent${field.name} = keyed.decodeList<int?>('
        '(d) => d.singleValue().readNullableInt());',
      );
    } else if ((elemType.isDartCoreDouble || elemType.isDartCoreNum) &&
        isNullable) {
      buffer.writeln(
        '$indent${field.name} = keyed.decodeList<double?>('
        '(d) => d.singleValue().readNullableDouble());',
      );
    } else if (elemType.isDartCoreBool && isNullable) {
      buffer.writeln(
        '$indent${field.name} = keyed.decodeList<bool?>('
        '(d) => d.singleValue().readNullableBool());',
      );
    } else {
      final elemTypeStr = elemType.getDisplayString();
      buffer.writeln(
        '$indent${field.name} = keyed.decodeList<$elemTypeStr>('
        '(d) => d.singleValue().readString() as dynamic);',
      );
    }
  }

  String _generateUnkeyedElementExpr(DartType type) {
    if (type.isDartCoreList || type.element?.name == 'List') {
      final inner = type is InterfaceType && type.typeArguments.isNotEmpty
          ? type.typeArguments.first
          : null;
      if (type.isNullableType) {
        if (inner == null) {
          return '(d) { if (d.singleValue().isNull()) { d.singleValue().readNull(); return null; } return d.unkeyed().decodeList((d) => d.singleValue().readString() as dynamic); }';
        }
        return '(d) { if (d.singleValue().isNull()) { d.singleValue().readNull(); return null; } return d.unkeyed().decodeList(${_generateUnkeyedElementExpr(inner)}); }';
      }
      if (inner == null) {
        return '(d) => d.unkeyed().decodeList((d) => d.singleValue().readString() as dynamic)';
      }
      if (inner.isDartCoreDouble && !inner.isNullableType) {
        return '(d) => d.unkeyed().decodeDoubleList()';
      }
      if (inner.element?.name == 'Float64List') {
        return '(d) => d.unkeyed().decodeFloat64List()';
      }
      if (inner.isDartCoreInt && !inner.isNullableType) {
        return '(d) => d.unkeyed().decodeIntList()';
      }
      if (inner.isDartCoreString && !inner.isNullableType) {
        return '(d) => d.unkeyed().decodeStringList()';
      }
      if (inner.isDartCoreBool && !inner.isNullableType) {
        return '(d) => d.unkeyed().decodeBoolList()';
      }
      return '(d) => d.unkeyed().decodeList(${_generateUnkeyedElementExpr(inner)})';
    }
    if (type.element?.name == 'Float64List') {
      return '(d) => d.unkeyed().decodeFloat64List()';
    }
    if (type.element?.name == 'Int64List') {
      return '(d) => Int64List.fromList(d.unkeyed().decodeIntList())';
    }
    if (type.element?.name == 'Int32List') {
      return '(d) => Int32List.fromList(d.unkeyed().decodeIntList())';
    }
    if (type.element?.name == 'Uint8List') {
      return '(d) => Uint8List.fromList(d.unkeyed().decodeIntList())';
    }
    if (type.element?.name == 'Float32List') {
      return '(d) => Float32List.fromList(d.unkeyed().decodeDoubleList())';
    }
    if (type.element != null &&
        const TypeClassifier().isCodableElement(type.element!)) {
      final nestedName = type.element!.name;
      if (type.isNullableType) {
        return '(d) { if (d.singleValue().isNull()) { d.singleValue().readNull(); return null; } return _\$${nestedName}FromDecoder(d); }';
      }
      return '_\$${nestedName}FromDecoder';
    }
    if (type.element is EnumElement) {
      final enumName = type.element!.name;
      if (type.isNullableType) {
        return '(d) { final v = d.singleValue().readNullableString(); return v == null ? null : $enumName.values.byName(v); }';
      }
      return '(d) => $enumName.values.byName(d.singleValue().readString())';
    }
    if (type.isDartCoreInt) {
      return type.isNullableType
          ? '(d) => d.singleValue().readNullableInt()'
          : '(d) => d.singleValue().readInt()';
    }
    if (type.isDartCoreDouble || type.isDartCoreNum) {
      return type.isNullableType
          ? '(d) => d.singleValue().readNullableDouble()'
          : '(d) => d.singleValue().readDouble()';
    }
    if (type.isDartCoreString) {
      return type.isNullableType
          ? '(d) => d.singleValue().readNullableString()'
          : '(d) => d.singleValue().readString()';
    }
    if (type.isDartCoreBool) {
      return type.isNullableType
          ? '(d) => d.singleValue().readNullableBool()'
          : '(d) => d.singleValue().readBool()';
    }
    return '(d) => d.singleValue().readString() as dynamic';
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
        '(d) => d.singleValue().readNullableString()).toSet();',
      );
    } else if (elemType != null && elemType.isDartCoreInt && isNullable) {
      buffer.writeln(
        '$indent${field.name} = keyed.decodeList<int?>('
        '(d) => d.singleValue().readNullableInt()).toSet();',
      );
    } else if (elemType != null &&
        (elemType.isDartCoreDouble || elemType.isDartCoreNum) &&
        !isNullable) {
      buffer.writeln(
        '$indent${field.name} = keyed.decodeDoubleList().toSet();',
      );
    } else if (elemType != null &&
        (elemType.isDartCoreDouble || elemType.isDartCoreNum) &&
        isNullable) {
      buffer.writeln(
        '$indent${field.name} = keyed.decodeList<double?>('
        '(d) => d.singleValue().readNullableDouble()).toSet();',
      );
    } else if (elemType != null && elemType.isDartCoreBool && !isNullable) {
      buffer.writeln('$indent${field.name} = keyed.decodeBoolList().toSet();');
    } else if (elemType != null && elemType.isDartCoreBool && isNullable) {
      buffer.writeln(
        '$indent${field.name} = keyed.decodeList<bool?>('
        '(d) => d.singleValue().readNullableBool()).toSet();',
      );
    } else if (elemType != null && elemType.element is EnumElement) {
      final enumName = elemType.element!.name;
      buffer.writeln(
        '$indent${field.name} = keyed.decodeList((d) { '
        'final v = d.singleValue().readNullableString(); '
        'return v == null ? null : $enumName.values.byName(v); }).toSet();',
      );
    } else {
      buffer.writeln(
        '$indent${field.name} = keyed.decodeList<$elemTypeStr>('
        '(d) => d.singleValue().readString() as dynamic).toSet();',
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
    } else if (valType != null &&
        (valType.isDartCoreDouble || valType.isDartCoreNum)) {
      readExpr = 'k.readDouble()';
    } else if (valType != null && valType.isDartCoreBool) {
      readExpr = 'k.readBool()';
    } else if (valType != null &&
        valType.element != null &&
        const TypeClassifier().isCodableElement(valType.element!)) {
      final nestedName = valType.element!.name;
      readExpr = 'k.decodeValue(_\$${nestedName}FromDecoder)';
    } else {
      readExpr = 'k.readString() as dynamic';
    }

    buffer.writeln('$indent${field.name} = keyed.decodeValue((d) {');
    buffer.writeln('$indent  final m = <String, $valTypeStr>{};');
    buffer.writeln('$indent  final k = d.keyed();');
    buffer.writeln('$indent  while (k.hasNextKey()) {');
    buffer.writeln('$indent    final key = k.nextKey();');
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
    buffer.writeln('$indent  }');
    buffer.writeln('$indent  return m;');
    buffer.writeln('$indent});');
  }

  void _writeDecoderReturn(StringBuffer buffer) {
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
    final listDecoderFuncName = '_\$${model.className}ListFromDecoder';
    final nonIgnoredFields = model.fields.where((f) => !f.ignore).toList();
    final isUniformDouble = model.isUniformDoubleModel;

    buffer.writeln(
      '// =============================================================================',
    );
    buffer.writeln('// 2b. Universal List Deserializer for ${model.className}');
    buffer.writeln(
      '// =============================================================================',
    );
    buffer.writeln(
      'List<${model.className}> $listDecoderFuncName(Decoder decoder) {',
    );

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
    buffer.writeln('  while (unkeyed.hasNext()) {');
    buffer.writeln(
      '    list.add(unkeyed.decodeElement(_\$${model.className}FromDecoder));',
    );
    buffer.writeln('  }');
    buffer.writeln('  return list;');
    buffer.writeln('}');
  }
}

extension on DartType {
  bool get isNullableType =>
      nullabilitySuffix == NullabilitySuffix.question || this is DynamicType;
}
