// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// ignore_for_file: deprecated_member_use

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';

import 'field_descriptor.dart';
import 'type_helper.dart';
import 'utils.dart';

/// Emits the unified `_$ModelSchema` extension type and single-pass
/// `_$ModelFromReader` decoder.
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
    }

    buffer.writeln();
    buffer.writeln('  // Pre-Encoded UTF-8 Wire Bytes');
    for (final field in nonIgnoredFields) {
      final suffix = toSafeIdentifierSuffix(field.name);
      final constBytes = encodeAsConstBytes(field.wireName);
      buffer.writeln(
        '  static final Uint8List name${suffix}Bytes = '
        'Uint8List.fromList($constBytes);',
      );
    }

    buffer.writeln();
    buffer.writeln('  // Key Indices for selectName()');
    for (final field in nonIgnoredFields) {
      final suffix = toSafeIdentifierSuffix(field.name);
      buffer.writeln('  static const int key$suffix = ${field.keyIndex};');
      for (var i = 0; i < field.aliases.length; i++) {
        final aliasSuffix = toSafeIdentifierSuffix(field.aliases[i]);
        buffer.writeln(
          '  static const String alias$suffix$aliasSuffix = '
          "'${field.aliases[i]}';",
        );
        buffer.writeln(
          '  static const int aliasKey$suffix$aliasSuffix = '
          '${field.aliasIndices[i]};',
        );
      }
    }

    buffer.writeln();
    buffer.writeln('  // Pre-Compiled JsonKeyOptions');
    if (model.allOptionsKeys.isEmpty) {
      buffer.writeln(
        '  static final JsonKeyOptions options = JsonKeyOptions.of(const []);',
      );
    } else {
      buffer.writeln(
        '  static final JsonKeyOptions options = JsonKeyOptions.of(const [',
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
    buffer.writeln(
      '  static final KeyOptions keyOptions = '
      'KeyOptions(options.keys, compiled: options);',
    );

    // Enum Options
    for (final field in nonIgnoredFields) {
      if (field.category == TypeCategory.enumType &&
          field.enumConstants != null &&
          field.enumConstants!.isNotEmpty) {
        buffer.writeln();
        buffer.writeln('  // Enum Options for ${field.name}');
        buffer.writeln(
          '  static final JsonKeyOptions ${field.name}EnumOptions = '
          'JsonKeyOptions.of(const [',
        );
        for (final constant in field.enumConstants!) {
          buffer.writeln("    '$constant',");
        }
        buffer.writeln('  ]);');
        buffer.writeln(
          '  static final KeyOptions ${field.name}KeyOptions = '
          'KeyOptions(${field.name}EnumOptions.keys, '
          'compiled: ${field.name}EnumOptions);',
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

    if (model.requiredFields.isNotEmpty && model.useGoldenMask) {
      buffer.writeln();
      buffer.writeln('  // Composite Golden Mask for Required Fields');
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
    final readerFuncName = '_\$${model.className}FromReader';
    final decoderFuncName = '_\$${model.className}FromDecoder';

    _writeDecoderHeader(buffer, readerFuncName);
    _writeLocalVarDeclarations(buffer);
    _writeSelectLoop(buffer, schemaName);
    _writeDecoderReturn(buffer);

    buffer.writeln();
    _writeKeyedDecoder(buffer, decoderFuncName, schemaName);
  }

  void _writeKeyedDecoder(
    StringBuffer buffer,
    String funcName,
    String schemaName,
  ) {
    buffer.writeln(
      '// =============================================================================',
    );
    buffer.writeln('// 3. Universal Keyed Deserializer for ${model.className}');
    buffer.writeln(
      '// =============================================================================',
    );
    buffer.writeln('${model.className} $funcName(Decoder decoder) {');
    buffer.writeln('  final keyed = decoder.keyed();');
    buffer.writeln();
    _writeLocalVarDeclarations(buffer);
    _writeKeyedSelectLoop(buffer, schemaName);
    _writeDecoderReturn(buffer);
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
    } else if (field.category == TypeCategory.enumType) {
      _writeKeyedEnumFieldRead(buffer, field, schemaName, indent: '        ');
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

  void _writeKeyedEnumFieldRead(
    StringBuffer buffer,
    FieldDescriptor field,
    String schemaName, {
    required String indent,
  }) {
    final typeStr =
        field.type.element?.name ??
        field.type.getDisplayString().replaceAll('?', '');
    buffer.writeln('$indent// Zero-allocation enum matching');
    buffer.writeln(
      '${indent}final enumIndex = '
      'keyed.selectStringIndex($schemaName.${field.name}KeyOptions);',
    );
    buffer.writeln(
      '${indent}if (enumIndex >= 0 && enumIndex < $typeStr.values.length) {',
    );
    buffer.writeln('$indent  ${field.name} = $typeStr.values[enumIndex];');
    if (field.participatesInGoldenMask) {
      buffer.writeln('$indent  seen |= $schemaName.${field.name};');
    }
    buffer.writeln('$indent} else {');
    buffer.writeln(
      "$indent  throw const CodableException('Unknown $typeStr value');",
    );
    buffer.writeln('$indent}');
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
        buffer.writeln('$indent${field.name} = keyed.readDouble();');
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
        final tupleType =
            field.type.element?.name ??
            field.type.getDisplayString().replaceAll('?', '');
        if (tupleType == 'Float64List') {
          buffer.writeln('$indent${field.name} = keyed.decodeFloat64List();');
        } else {
          buffer.writeln('$indent${field.name} = keyed.decodeDoubleList();');
        }
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

  void _writeKeyedListRead(
    StringBuffer buffer,
    FieldDescriptor field, {
    required String indent,
  }) {
    final elemType = field.elementType;
    if (elemType == null) {
      buffer.writeln(
        '$indent${field.name} = '
        'keyed.decodeList((d) => d.singleValue().readString() as dynamic);',
      );
      return;
    }
    final isNullable = elemType.isNullableType;
    if (elemType.isDartCoreInt && !isNullable) {
      buffer.writeln('$indent${field.name} = keyed.decodeIntList();');
    } else if ((elemType.isDartCoreDouble || elemType.isDartCoreNum) &&
        !isNullable) {
      buffer.writeln('$indent${field.name} = keyed.decodeDoubleList();');
    } else if (elemType.isDartCoreString && !isNullable) {
      buffer.writeln('$indent${field.name} = keyed.decodeStringList();');
    } else if (elemType.isDartCoreBool && !isNullable) {
      buffer.writeln('$indent${field.name} = keyed.decodeBoolList();');
    } else if (elemType.element is EnumElement) {
      final enumName = elemType.element!.name;
      if (isNullable) {
        buffer.writeln(
          '$indent${field.name} = keyed.decodeList('
          '(d) => d.singleValue().isNull() ? null : '
          '$enumName.values.byName(d.singleValue().readString()));',
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
          '$indent${field.name} = keyed.decodeList('
          '(d) => d.singleValue().isNull() ? null : '
          '_\$${nestedName}FromDecoder(d));',
        );
      } else {
        buffer.writeln(
          '$indent${field.name} = '
          'keyed.decodeList(_\$${nestedName}FromDecoder);',
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
        '$indent${field.name} = keyed.decodeList('
        '(d) => d.singleValue().readNullableString() == null ? null : '
        '$enumName.values.byName(d.singleValue().readString())).toSet();',
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

  void _writeDecoderHeader(StringBuffer buffer, String funcName) {
    buffer.writeln(
      '// =============================================================================',
    );
    buffer.writeln(
      '// 2. Single-Pass Streaming Deserializer for ${model.className}',
    );
    buffer.writeln(
      '// =============================================================================',
    );
    buffer.writeln('${model.className} $funcName(JsonTokenReader reader) {');
    buffer.writeln('  reader.beginObject();');
    buffer.writeln();
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

  void _writeSelectLoop(StringBuffer buffer, String schemaName) {
    buffer.writeln('  var seen = $schemaName.none;');
    buffer.writeln();
    buffer.writeln('  while (reader.hasNext()) {');
    buffer.writeln('    switch (reader.selectName($schemaName.options)) {');

    final nonIgnoredFields = model.fields.where((f) => !f.ignore).toList();
    for (final field in nonIgnoredFields) {
      _writeFieldCase(buffer, field, schemaName);
    }

    buffer.writeln('      default:');
    buffer.writeln('        reader.skipValue();');
    buffer.writeln('        break;');
    buffer.writeln('    }');
    buffer.writeln('  }');
    buffer.writeln('  reader.endObject();');
    buffer.writeln();
    buffer.writeln('  // Inlined fast-path check');
    buffer.writeln('  seen.validate();');
    buffer.writeln();
  }

  void _writeFieldCase(
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
      buffer.writeln('        if (reader.isNextNull()) {');
      buffer.writeln('          reader.readNull();');
      buffer.writeln('          ${field.name} = null;');
      buffer.writeln('        } else {');
      _writeFieldRead(buffer, field, indent: '          ');
      if (field.participatesInGoldenMask) {
        buffer.writeln('          seen |= $schemaName.${field.name};');
      }
      buffer.writeln('        }');
    } else if (field.category == TypeCategory.enumType) {
      _writeEnumFieldRead(buffer, field, schemaName, indent: '        ');
    } else {
      buffer.writeln('        if (reader.isNextNull()) {');
      buffer.writeln('          reader.readNull();');
      buffer.writeln('        } else {');
      _writeFieldRead(buffer, field, indent: '          ');
      if (field.participatesInGoldenMask) {
        buffer.writeln('          seen |= $schemaName.${field.name};');
      }
      buffer.writeln('        }');
    }
    buffer.writeln('        break;');
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

  void _writeEnumFieldRead(
    StringBuffer buffer,
    FieldDescriptor field,
    String schemaName, {
    required String indent,
  }) {
    final typeStr =
        field.type.element?.name ??
        field.type.getDisplayString().replaceAll('?', '');
    buffer.writeln('$indent// Zero-allocation enum matching');
    buffer.writeln(
      '${indent}final enumIndex = '
      'reader.selectString($schemaName.${field.name}EnumOptions);',
    );
    buffer.writeln(
      '${indent}if (enumIndex >= 0 && enumIndex < $typeStr.values.length) {',
    );
    buffer.writeln('$indent  ${field.name} = $typeStr.values[enumIndex];');
    if (field.participatesInGoldenMask) {
      buffer.writeln('$indent  seen |= $schemaName.${field.name};');
    }
    buffer.writeln('$indent} else {');
    buffer.writeln(
      "$indent  throw const CodableException('Unknown $typeStr value');",
    );
    buffer.writeln('$indent}');
  }

  void _writeFieldRead(
    StringBuffer buffer,
    FieldDescriptor field, {
    required String indent,
  }) {
    switch (field.category) {
      case TypeCategory.primitiveInt:
        buffer.writeln('$indent${field.name} = reader.readInt();');
      case TypeCategory.primitiveDouble:
        buffer.writeln('$indent${field.name} = reader.readDouble();');
      case TypeCategory.primitiveNum:
        buffer.writeln('$indent${field.name} = reader.readNum();');
      case TypeCategory.primitiveString:
        buffer.writeln('$indent${field.name} = reader.readString();');
      case TypeCategory.primitiveBool:
        buffer.writeln('$indent${field.name} = reader.readBool();');
      case TypeCategory.enumType:
        final schemaName = '_\$${model.className}Schema';
        _writeEnumFieldRead(buffer, field, schemaName, indent: indent);
      case TypeCategory.custom:
        buffer.writeln(
          '$indent${field.name} = '
          '${field.customDecoderCode}.decodeFromReader(reader);',
        );
      case TypeCategory.tuple:
        final tupleLen = field.tupleLength ?? 2;
        final tupleType =
            field.type.element?.name ??
            field.type.getDisplayString().replaceAll('?', '');
        buffer.writeln('${indent}reader.beginArray();');
        buffer.writeln('${indent}final tuple = $tupleType($tupleLen);');
        buffer.writeln('${indent}var tupleIdx = 0;');
        buffer.writeln('${indent}while (reader.hasNext()) {');
        buffer.writeln('$indent  if (tupleIdx < $tupleLen) {');
        buffer.writeln('$indent    tuple[tupleIdx++] = reader.readDouble();');
        buffer.writeln('$indent  } else {');
        buffer.writeln('$indent    reader.skipValue();');
        buffer.writeln('$indent  }');
        buffer.writeln('$indent}');
        buffer.writeln('${indent}reader.endArray();');
        buffer.writeln('${indent}if (tupleIdx != $tupleLen) {');
        buffer.writeln(
          "$indent  throw CodableException('Expected $tupleLen elements for "
          "tuple \"${field.wireName}\", got \$tupleIdx');",
        );
        buffer.writeln('$indent}');
        buffer.writeln('$indent${field.name} = tuple;');

      case TypeCategory.list:
        _writeListRead(buffer, field, indent: indent);
      case TypeCategory.set:
        _writeSetRead(buffer, field, indent: indent);
      case TypeCategory.map:
        _writeMapRead(buffer, field, indent: indent);
      case TypeCategory.nestedCodable:
        final nestedName = field.type.element!.name;
        buffer.writeln(
          '$indent${field.name} = _\$${nestedName}FromReader(reader);',
        );
      case TypeCategory.unknown:
        buffer.writeln('$indent// Unknown type, reading string as fallback');
        buffer.writeln(
          '$indent${field.name} = reader.readString() as dynamic;',
        );
    }
  }

  void _writeListRead(
    StringBuffer buffer,
    FieldDescriptor field, {
    required String indent,
  }) {
    final elemType = field.elementType;
    final elemTypeStr = elemType?.getDisplayString() ?? 'dynamic';
    buffer.writeln('${indent}reader.beginArray();');
    buffer.writeln('${indent}final list = <$elemTypeStr>[];');
    buffer.writeln('${indent}while (reader.hasNext()) {');
    if (elemType != null && elemType.isNullableType) {
      buffer.writeln('$indent  if (reader.isNextNull()) {');
      buffer.writeln('$indent    reader.readNull();');
      buffer.writeln('$indent    list.add(null as $elemTypeStr);');
      buffer.writeln('$indent  } else {');
      _writeElementRead(buffer, elemType, 'list.add', indent: '$indent    ');
      buffer.writeln('$indent  }');
    } else {
      _writeElementRead(buffer, elemType, 'list.add', indent: '$indent  ');
    }
    buffer.writeln('$indent}');
    buffer.writeln('${indent}reader.endArray();');
    buffer.writeln('$indent${field.name} = list;');
  }

  void _writeSetRead(
    StringBuffer buffer,
    FieldDescriptor field, {
    required String indent,
  }) {
    final elemType = field.elementType;
    final elemTypeStr = elemType?.getDisplayString() ?? 'dynamic';
    buffer.writeln('${indent}reader.beginArray();');
    buffer.writeln('${indent}final set = <$elemTypeStr>{};');
    buffer.writeln('${indent}while (reader.hasNext()) {');
    if (elemType != null && elemType.isNullableType) {
      buffer.writeln('$indent  if (reader.isNextNull()) {');
      buffer.writeln('$indent    reader.readNull();');
      buffer.writeln('$indent    set.add(null as $elemTypeStr);');
      buffer.writeln('$indent  } else {');
      _writeElementRead(buffer, elemType, 'set.add', indent: '$indent    ');
      buffer.writeln('$indent  }');
    } else {
      _writeElementRead(buffer, elemType, 'set.add', indent: '$indent  ');
    }
    buffer.writeln('$indent}');
    buffer.writeln('${indent}reader.endArray();');
    buffer.writeln('$indent${field.name} = set;');
  }

  void _writeMapRead(
    StringBuffer buffer,
    FieldDescriptor field, {
    required String indent,
  }) {
    final valType = field.mapValueType;
    final valTypeStr = valType?.getDisplayString() ?? 'dynamic';
    buffer.writeln('${indent}reader.beginObject();');
    buffer.writeln('${indent}final map = <String, $valTypeStr>{};');
    buffer.writeln('${indent}while (reader.hasNext()) {');
    buffer.writeln('$indent  final k = reader.nextName();');
    if (valType != null && valType.isNullableType) {
      buffer.writeln('$indent  if (reader.isNextNull()) {');
      buffer.writeln('$indent    reader.readNull();');
      buffer.writeln('$indent    map[k] = null as $valTypeStr;');
      buffer.writeln('$indent  } else {');
      _writeElementRead(buffer, valType, 'map[k] =', indent: '$indent    ');
      buffer.writeln('$indent  }');
    } else {
      _writeElementRead(buffer, valType, 'map[k] =', indent: '$indent  ');
    }
    buffer.writeln('$indent}');
    buffer.writeln('${indent}reader.endObject();');
    buffer.writeln('$indent${field.name} = map;');
  }

  void _writeElementRead(
    StringBuffer buffer,
    DartType? type,
    String targetPrefix, {
    required String indent,
  }) {
    final String expr;
    if (type == null) {
      expr = 'reader.readString() as dynamic';
    } else if (type.isDartCoreInt) {
      expr = 'reader.readInt()';
    } else if (type.isDartCoreDouble) {
      expr = 'reader.readDouble()';
    } else if (type.isDartCoreNum) {
      expr = 'reader.readNum()';
    } else if (type.isDartCoreString) {
      expr = 'reader.readString()';
    } else if (type.isDartCoreBool) {
      expr = 'reader.readBool()';
    } else if (type.element is EnumElement) {
      final enumName = type.element!.name;
      expr = '$enumName.values.byName(reader.readString())';
    } else if (type.element != null &&
        const TypeClassifier().isCodableElement(type.element!)) {
      expr = '_\$${type.element!.name}FromReader(reader)';
    } else {
      expr = 'reader.readString() as dynamic';
    }

    if (targetPrefix.endsWith('=')) {
      buffer.writeln('$indent$targetPrefix $expr;');
    } else {
      buffer.writeln('$indent$targetPrefix($expr);');
    }
  }
}

extension on DartType {
  bool get isNullableType =>
      nullabilitySuffix == NullabilitySuffix.question || this is DynamicType;
}
