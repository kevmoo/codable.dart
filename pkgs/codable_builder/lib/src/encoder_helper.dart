// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:source_gen/source_gen.dart';
import 'package:source_helper/source_helper.dart';

import 'field_descriptor.dart';
import 'type_helper.dart';
import 'utils.dart';

typedef _EncoderSlot = ({
  String itemAccess,
  String encoderExpr,
  String indent,
  int depth,
});

/// Emits the format-agnostic `encode` method on the companion `*Codable` class.
final class EncoderGeneratorHelper {
  final ModelDescriptor model;

  EncoderGeneratorHelper(this.model);

  /// Generates the serializer code for [model].
  String generate() => generateMethod();

  /// Generates the `encode` method for the companion `*Codable` class.
  String generateMethod() {
    if (!model.createEncoder) return '';

    final raw = StringBuffer();
    final schemaName = '_\$${model.className}Schema';
    final nonIgnoredFields = model.fields.where((f) => !f.ignore).toList();
    final allNonNullable = nonIgnoredFields.every((f) => !f.isNullable);

    raw.writeln('@override');
    raw.writeln('void encode(${model.className} instance, Encoder encoder) {');
    if (nonIgnoredFields.isEmpty) {
      raw.writeln('  encoder.keyed(length: 0);');
    } else if (allNonNullable) {
      raw.writeln(
        '  final keyed = encoder.keyed(length: ${nonIgnoredFields.length});',
      );
    } else {
      raw.writeln('  final keyed = encoder.keyed();');
    }

    for (final field in nonIgnoredFields) {
      final suffix = toSafeIdentifierSuffix(field.name);
      final fieldAccess = 'instance.${field.name}';
      final keyExpr = '$schemaName.name$suffix';

      if (field.isNullable) {
        raw.writeln('  if ($fieldAccess != null) {');
        _writeFieldEncode(raw, field, keyExpr, '$fieldAccess!', indent: '    ');
        raw.writeln('  }');
      } else {
        _writeFieldEncode(raw, field, keyExpr, fieldAccess, indent: '  ');
      }
    }

    raw.writeln('}');
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

  void _writeFieldEncode(
    StringBuffer buffer,
    FieldDescriptor field,
    String keyExpr,
    String access, {
    required String indent,
    TypeCategory? categoryOverride,
  }) {
    switch (categoryOverride ?? field.category) {
      case TypeCategory.primitiveInt:
        buffer.writeln('${indent}keyed.encodeInt($keyExpr, $access);');
      case TypeCategory.primitiveDouble:
        buffer.writeln('${indent}keyed.encodeDouble($keyExpr, $access);');
      case TypeCategory.primitiveNum:
        buffer.writeln('${indent}switch ($access) {');
        buffer.writeln('$indent  case final int v:');
        buffer.writeln('$indent    keyed.encodeInt($keyExpr, v);');
        buffer.writeln('$indent  case final v:');
        buffer.writeln(
          '$indent    keyed.encodeDouble($keyExpr, v.toDouble());',
        );
        buffer.writeln('$indent}');
      case TypeCategory.primitiveString:
        buffer.writeln('${indent}keyed.encodeString($keyExpr, $access);');
      case TypeCategory.primitiveBool:
        buffer.writeln('${indent}keyed.encodeBool($keyExpr, $access);');
      case TypeCategory.enumType:
        buffer.writeln('${indent}keyed.encodeString($keyExpr, $access.name);');
      case TypeCategory.custom:
        final customEncoder = field.customEncoderCode;
        if (customEncoder != null) {
          buffer.writeln(
            '${indent}keyed.encodeValue($keyExpr, $access, $customEncoder);',
          );
        } else {
          _writeFieldEncode(
            buffer,
            field,
            keyExpr,
            access,
            indent: indent,
            categoryOverride: field.nativeCategory,
          );
        }
      case TypeCategory.tuple:
        buffer.writeln('${indent}keyed.encodeDoubleList($keyExpr, $access);');
      case TypeCategory.list:
        _writeListEncode(buffer, field, keyExpr, access, indent: indent);
      case TypeCategory.set:
        _writeSetEncode(buffer, field, keyExpr, access, indent: indent);
      case TypeCategory.map:
        _writeMapEncode(buffer, field, keyExpr, access, indent: indent);
      case TypeCategory.nestedCodable:
        final nestedName = field.type.element!.name;
        buffer.writeln(
          '${indent}keyed.encodeValue('
          '$keyExpr, $access, const ${nestedName}Codable());',
        );
      case TypeCategory.unknown:
        buffer.writeln(
          '${indent}keyed.encodeString($keyExpr, $access.toString());',
        );
    }
  }

  static String? _typedDataKeyedMethod(String? typeName) => switch (typeName) {
    'Float64List' || 'Float32List' => 'encodeDoubleList',
    'Int64List' || 'Int32List' || 'Uint8List' => 'encodeIntList',
    _ => null,
  };

  static String? _primitiveKeyedListMethod(DartType? elemType) {
    if (elemType == null || elemType.isNullableType) return null;
    if (elemType.isDartCoreInt) return 'encodeIntList';
    if (elemType.isDartCoreDouble) return 'encodeDoubleList';
    if (elemType.isDartCoreString) return 'encodeStringList';
    if (elemType.isDartCoreBool) return 'encodeBoolList';
    return null;
  }

  void _writeListEncode(
    StringBuffer buffer,
    FieldDescriptor field,
    String keyExpr,
    String access, {
    required String indent,
  }) {
    final typedMethod = _typedDataKeyedMethod(field.type.element?.name);
    if (typedMethod != null) {
      buffer.writeln('${indent}keyed.$typedMethod($keyExpr, $access);');
      return;
    }

    final elemType = field.elementType;
    final primMethod = _primitiveKeyedListMethod(elemType);
    if (primMethod != null) {
      buffer.writeln('${indent}keyed.$primMethod($keyExpr, $access);');
      return;
    }

    if (elemType != null &&
        !elemType.isNullableType &&
        elemType.element != null &&
        const TypeClassifier().isCodableElement(elemType.element!)) {
      final nestedName = elemType.element!.name;
      buffer.writeln(
        '${indent}keyed.encodeList('
        '$keyExpr, $access, const ${nestedName}Codable());',
      );
      return;
    }

    final elemTypeStr = elemType?.getDisplayString() ?? 'dynamic';
    buffer.writeln(
      '${indent}keyed.encodeList($keyExpr, $access, Encodable.fromFunction(($elemTypeStr item, e) {',
    );
    buffer.write(
      _encoderValueCode(elemType, (
        itemAccess: 'item',
        encoderExpr: 'e',
        indent: '$indent  ',
        depth: 0,
      )),
    );
    buffer.writeln('$indent}));');
  }

  void _writeSetEncode(
    StringBuffer buffer,
    FieldDescriptor field,
    String keyExpr,
    String access, {
    required String indent,
  }) {
    final elemType = field.elementType;
    final primMethod = _primitiveKeyedListMethod(elemType);
    if (primMethod != null) {
      buffer.writeln('${indent}keyed.$primMethod($keyExpr, $access.toList());');
      return;
    }

    final elemTypeStr = elemType?.getDisplayString() ?? 'dynamic';
    buffer.writeln(
      '${indent}keyed.encodeList($keyExpr, $access, Encodable.fromFunction(($elemTypeStr item, e) {',
    );
    buffer.write(
      _encoderValueCode(elemType, (
        itemAccess: 'item',
        encoderExpr: 'e',
        indent: '$indent  ',
        depth: 0,
      )),
    );
    buffer.writeln('$indent}));');
  }

  void _writeMapEncode(
    StringBuffer buffer,
    FieldDescriptor field,
    String keyExpr,
    String access, {
    required String indent,
  }) {
    buffer.write(
      _inlineMapEncodeCode(field.mapKeyType, field.mapValueType, (
        itemAccess: access,
        encoderExpr: 'keyed.nestedEncoder($keyExpr)',
        indent: indent,
        depth: 0,
      )),
    );
  }

  static bool _isStringMapKey(DartType? keyType) =>
      keyType != null &&
      keyType.isDartCoreString &&
      keyType.nullabilitySuffix == NullabilitySuffix.none;

  static String _inlineMapEncodeCode(
    DartType? keyType,
    DartType? valType,
    _EncoderSlot slot,
  ) {
    if (!_isStringMapKey(keyType)) {
      throw InvalidGenerationSourceError(
        'Only non-nullable String Map keys are supported, found '
        'Map<${keyType?.getDisplayString() ?? 'dynamic'}, '
        '${valType?.getDisplayString() ?? 'dynamic'}>.',
      );
    }
    return _inlineStringMapEncodeCode(valType, slot);
  }

  static String _inlineStringMapEncodeCode(
    DartType? valType,
    _EncoderSlot slot,
  ) {
    final sfx = slot.depth == 0 ? '' : '${slot.depth}';
    final kVar = 'k$sfx';
    final entryVar = 'entry$sfx';
    final indent = slot.indent;
    final out = StringBuffer()
      ..writeln('$indent{')
      ..writeln(
        '$indent  final $kVar = '
        '${slot.encoderExpr}.keyed(length: ${slot.itemAccess}.length);',
      )
      ..writeln(
        '$indent  for (final $entryVar in ${slot.itemAccess}.entries) {',
      )
      ..write(
        _keyedMapValueEncodeCode(valType, kVar, '$entryVar.key', (
          itemAccess: '$entryVar.value',
          encoderExpr: '$kVar.nestedEncoder($entryVar.key)',
          indent: '$indent    ',
          depth: slot.depth + 1,
        )),
      )
      ..writeln('$indent  }')
      ..writeln('$indent}');
    return out.toString();
  }

  static String _keyedMapValueEncodeCode(
    DartType? type,
    String kVar,
    String keyExpr,
    _EncoderSlot slot,
  ) {
    if (type == null) {
      return '${slot.indent}$kVar.encodeString('
          '$keyExpr, ${slot.itemAccess}.toString());\n';
    }
    if (type.isDartCoreNum) {
      return _numKeyedMapValueEncodeCode(
        kVar,
        keyExpr,
        slot,
        isNullable: type.isNullableType,
      );
    }
    if (!type.isNullableType) {
      return _nonNullKeyedMapValueEncodeCode(type, kVar, keyExpr, slot);
    }
    final valVar = 'val${slot.depth}';
    final indent = slot.indent;
    final out = StringBuffer()
      ..writeln('${indent}if (${slot.itemAccess} case final $valVar?) {')
      ..write(
        _nonNullKeyedMapValueEncodeCode(type, kVar, keyExpr, (
          itemAccess: valVar,
          encoderExpr: slot.encoderExpr,
          indent: '$indent  ',
          depth: slot.depth + 1,
        )),
      )
      ..writeln('$indent} else {')
      ..writeln('$indent  $kVar.encodeNull($keyExpr);')
      ..writeln('$indent}');
    return out.toString();
  }

  static String _numKeyedMapValueEncodeCode(
    String kVar,
    String keyExpr,
    _EncoderSlot slot, {
    required bool isNullable,
  }) {
    final indent = slot.indent;
    final out = StringBuffer()
      ..writeln('${indent}switch (${slot.itemAccess}) {');
    if (isNullable) {
      out
        ..writeln('$indent  case null:')
        ..writeln('$indent    $kVar.encodeNull($keyExpr);');
    }
    out
      ..writeln('$indent  case final int v:')
      ..writeln('$indent    $kVar.encodeInt($keyExpr, v);')
      ..writeln('$indent  case final v:')
      ..writeln('$indent    $kVar.encodeDouble($keyExpr, v.toDouble());')
      ..writeln('$indent}');
    return out.toString();
  }

  static String _nonNullKeyedMapValueEncodeCode(
    DartType type,
    String kVar,
    String keyExpr,
    _EncoderSlot slot,
  ) {
    final scalarPair = _scalarEncodeMethods(type);
    if (scalarPair != null) {
      return '${slot.indent}$kVar.${scalarPair.$1}('
          '$keyExpr, ${slot.itemAccess});\n';
    }
    if (type.element is EnumElement) {
      return '${slot.indent}$kVar.encodeString('
          '$keyExpr, ${slot.itemAccess}.name);\n';
    }
    final listMethod = _keyedDirectListEncodeMethod(type);
    if (listMethod != null) {
      return '${slot.indent}$kVar.$listMethod($keyExpr, ${slot.itemAccess});\n';
    }
    return _nonNullComplexEncoderValueCode(type, slot);
  }

  static String? _keyedDirectListEncodeMethod(DartType type) {
    final typed = _typedDataKeyedMethod(type.element?.name);
    if (typed != null) return typed;
    if (type.isDartCoreList || type.element?.name == 'List') {
      return _primitiveKeyedListMethod(_typeArgAt(type, 0));
    }
    return null;
  }

  static (String, String)? _scalarEncodeMethods(DartType type) {
    if (type.isDartCoreInt) return ('encodeInt', 'encodeNullableInt');
    if (type.isDartCoreDouble) return ('encodeDouble', 'encodeNullableDouble');
    if (type.isDartCoreString) return ('encodeString', 'encodeNullableString');
    if (type.isDartCoreBool) return ('encodeBool', 'encodeNullableBool');
    return null;
  }

  static String? _scalarEncodeMethod(DartType type) {
    final pair = _scalarEncodeMethods(type);
    if (pair == null) return null;
    return type.isNullableType ? pair.$2 : pair.$1;
  }

  static String _encoderValueCode(DartType? type, _EncoderSlot slot) {
    if (type == null) {
      return '${slot.indent}${slot.encoderExpr}.singleValue().encodeString('
          '${slot.itemAccess}.toString());\n';
    }
    final scalarMethod = _scalarEncodeMethod(type);
    if (scalarMethod != null) {
      return '${slot.indent}${slot.encoderExpr}.singleValue().$scalarMethod('
          '${slot.itemAccess});\n';
    }
    if (type.isDartCoreNum) {
      return _numEncoderValueCode(slot, isNullable: type.isNullableType);
    }
    if (type.element is EnumElement) {
      return type.isNullableType
          ? '${slot.indent}${slot.encoderExpr}.singleValue()'
                '.encodeNullableString(${slot.itemAccess}?.name);\n'
          : '${slot.indent}${slot.encoderExpr}.singleValue()'
                '.encodeString(${slot.itemAccess}.name);\n';
    }
    if (!type.isNullableType) {
      return _nonNullComplexEncoderValueCode(type, slot);
    }
    final valVar = 'val${slot.depth}';
    final out = StringBuffer();
    out.writeln('${slot.indent}if (${slot.itemAccess} case final $valVar?) {');
    out.write(
      _nonNullComplexEncoderValueCode(type, (
        itemAccess: valVar,
        encoderExpr: slot.encoderExpr,
        indent: '${slot.indent}  ',
        depth: slot.depth + 1,
      )),
    );
    out.writeln('${slot.indent}} else {');
    out.writeln(
      '${slot.indent}  ${slot.encoderExpr}.singleValue().encodeNull();',
    );
    out.writeln('${slot.indent}}');
    return out.toString();
  }

  static String _numEncoderValueCode(
    _EncoderSlot slot, {
    required bool isNullable,
  }) {
    final indent = slot.indent;
    final enc = slot.encoderExpr;
    final out = StringBuffer();
    out.writeln('${indent}switch (${slot.itemAccess}) {');
    if (isNullable) {
      out.writeln('$indent  case null:');
      out.writeln('$indent    $enc.singleValue().encodeNull();');
    }
    out.writeln('$indent  case final int v:');
    out.writeln('$indent    $enc.singleValue().encodeInt(v);');
    out.writeln('$indent  case final v:');
    out.writeln('$indent    $enc.singleValue().encodeDouble(v.toDouble());');
    out.writeln('$indent}');
    return out.toString();
  }

  static DartType? _typeArgAt(DartType type, int index) =>
      type is InterfaceType && type.typeArguments.length > index
      ? type.typeArguments[index]
      : null;

  static String? _typedUnkeyedElementMethod(String? name) => switch (name) {
    'Float64List' || 'Float32List' => 'encodeDouble',
    'Int64List' || 'Int32List' || 'Uint8List' => 'encodeInt',
    _ => null,
  };

  static String _nonNullComplexEncoderValueCode(
    DartType type,
    _EncoderSlot slot,
  ) {
    final name = type.element?.name;
    if (type.isDartCoreMap || name == 'Map') {
      return _inlineMapEncodeCode(
        _typeArgAt(type, 0),
        _typeArgAt(type, 1),
        slot,
      );
    }
    if (type.isDartCoreList ||
        type.isDartCoreSet ||
        name == 'List' ||
        name == 'Set') {
      return _inlineUnkeyedEncodeCode(_typeArgAt(type, 0), slot);
    }
    final typedMethod = _typedUnkeyedElementMethod(name);
    if (typedMethod != null) {
      return _inlineTypedUnkeyedEncodeCode(typedMethod, slot);
    }
    if (type.element != null &&
        const TypeClassifier().isCodableElement(type.element!)) {
      return '${slot.indent}const ${type.element!.name}Codable().encode('
          '${slot.itemAccess}, ${slot.encoderExpr});\n';
    }
    return '${slot.indent}${slot.encoderExpr}.singleValue().encodeString('
        '${slot.itemAccess}.toString());\n';
  }

  static String _inlineUnkeyedEncodeCode(DartType? inner, _EncoderSlot slot) {
    final sfx = slot.depth == 0 ? '' : '${slot.depth}';
    final uVar = 'u$sfx';
    final elemVar = 'elem$sfx';
    final indent = slot.indent;
    final out = StringBuffer();
    out.writeln('$indent{');
    out.writeln(
      '$indent  final $uVar = '
      '${slot.encoderExpr}.unkeyed(length: ${slot.itemAccess}.length);',
    );
    out.writeln('$indent  for (final $elemVar in ${slot.itemAccess}) {');
    final directMethod = inner != null ? _scalarEncodeMethod(inner) : null;
    if (directMethod != null) {
      out.writeln('$indent    $uVar.$directMethod($elemVar);');
    } else {
      out.write(
        _encoderValueCode(inner, (
          itemAccess: elemVar,
          encoderExpr: '$uVar.nestedEncoder()',
          indent: '$indent    ',
          depth: slot.depth + 1,
        )),
      );
    }
    out.writeln('$indent  }');
    out.writeln('$indent}');
    return out.toString();
  }

  static String _inlineTypedUnkeyedEncodeCode(
    String method,
    _EncoderSlot slot,
  ) {
    final sfx = slot.depth == 0 ? '' : '${slot.depth}';
    final uVar = 'u$sfx';
    final elemVar = 'elem$sfx';
    final indent = slot.indent;
    return '$indent{\n'
        '$indent  final $uVar = '
        '${slot.encoderExpr}.unkeyed(length: ${slot.itemAccess}.length);\n'
        '$indent  for (final $elemVar in ${slot.itemAccess}) {\n'
        '$indent    $uVar.$method($elemVar);\n'
        '$indent  }\n'
        '$indent}\n';
  }
}
