// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:source_helper/source_helper.dart';

import 'codec_expression_helper.dart';
import 'decoder_helper.dart';
import 'field_descriptor.dart';
import 'type_helper.dart';
import 'utils.dart';

typedef _EncoderSlot = ({
  String itemAccess,
  String encoderExpr,
  String indent,
  int depth,
});

/// Emits the format-agnostic `encodedFieldCount`, `encodeFields`, and `encode`
/// methods on the companion `*Codable` class.
final class EncoderGeneratorHelper {
  final ModelDescriptor model;
  late final CodecExpressionHelper _codecHelper = CodecExpressionHelper(
    model,
    decodeBuilder:
        (type, {required targetVar, required decoderExpr, required indent}) =>
            DecoderGeneratorHelper(model).inlineValueDecodeCode(
              type,
              targetVar: targetVar,
              decoderExpr: decoderExpr,
              indent: indent,
            ),
    encodeBuilder: inlineValueEncodeCode,
  );

  EncoderGeneratorHelper(this.model);

  /// Generates the serializer methods for [model].
  String generate() => generateMethod();

  /// Renders inline statements encoding [valueExpr] of [type] into
  /// [encoderExpr].
  String inlineValueEncodeCode(
    DartType type, {
    required String valueExpr,
    required String encoderExpr,
    required String indent,
  }) => _encoderValueCode(type, (
    itemAccess: valueExpr,
    encoderExpr: encoderExpr,
    indent: indent,
    depth: 0,
  ));

  /// Generates `encodedFieldCount`, `encodeFields`, and `encode` for the
  /// companion `*Codable` class.
  String generateMethod() {
    if (!model.createEncoder) return '';

    final raw = StringBuffer();
    final nonIgnoredFields = model.fields.where((f) => !f.ignore).toList();
    final dynamicCountFields = nonIgnoredFields
        .where(_isDynamicallyOmittedField)
        .toList();

    _writeEncodedFieldCountMethod(raw, nonIgnoredFields, dynamicCountFields);
    raw.writeln();
    _writeEncodeFieldsMethod(raw, nonIgnoredFields);
    raw.writeln();
    _writeEncodeMethod(raw, nonIgnoredFields, dynamicCountFields);

    return indentLines(raw.toString(), '  ');
  }

  static bool _isDynamicallyOmittedField(FieldDescriptor f) =>
      f.isNullable || f.isUnboundedTypeParameter;

  void _writeEncodedFieldCountMethod(
    StringBuffer raw,
    List<FieldDescriptor> nonIgnoredFields,
    List<FieldDescriptor> dynamicCountFields,
  ) {
    final targetType = model.instantiatedClassName;
    raw.writeln('@override');
    if (dynamicCountFields.isEmpty) {
      raw.writeln(
        'int encodedFieldCount($targetType instance) => '
        '${nonIgnoredFields.length};',
      );
      return;
    }
    final fixedCount = nonIgnoredFields.length - dynamicCountFields.length;
    raw.writeln('int encodedFieldCount($targetType instance) {');
    raw.writeln('  var count\$ = $fixedCount;');
    for (final field in dynamicCountFields) {
      raw.writeln('  if (instance.${field.name} != null) count\$++;');
    }
    raw.writeln('  return count\$;');
    raw.writeln('}');
  }

  void _writeEncodeFieldsMethod(
    StringBuffer raw,
    List<FieldDescriptor> nonIgnoredFields,
  ) {
    final targetType = model.instantiatedClassName;
    final schemaName = '_\$${model.className}Schema';
    raw.writeln('@override');
    raw.writeln(
      'void encodeFields($targetType instance, KeyedEncoder keyed) {',
    );
    for (final field in nonIgnoredFields) {
      final suffix = field.schemaSuffix;
      final keyExpr = '$schemaName.name$suffix';
      if (_isDynamicallyOmittedField(field)) {
        raw.writeln('  final v\$$suffix = instance.${field.name};');
        raw.writeln('  if (v\$$suffix != null) {');
        _writeFieldEncode(raw, field, keyExpr, 'v\$$suffix', indent: '    ');
        raw.writeln('  }');
      } else {
        _writeFieldEncode(
          raw,
          field,
          keyExpr,
          'instance.${field.name}',
          indent: '  ',
        );
      }
    }
    raw.writeln('}');
  }

  void _writeEncodeMethod(
    StringBuffer raw,
    List<FieldDescriptor> nonIgnoredFields,
    List<FieldDescriptor> dynamicCountFields,
  ) {
    final targetType = model.instantiatedClassName;
    raw.writeln('@override');
    raw.writeln('void encode($targetType instance, Encoder encoder) {');
    if (nonIgnoredFields.isEmpty) {
      raw.writeln('  encoder.keyed(length: 0);');
      raw.writeln('}');
      return;
    }
    if (dynamicCountFields.isEmpty) {
      raw.writeln(
        '  encodeFields(instance, '
        'encoder.keyed(length: ${nonIgnoredFields.length}));',
      );
      raw.writeln('}');
      return;
    }

    final schemaName = '_\$${model.className}Schema';
    final fixedNonNullCount =
        nonIgnoredFields.length - dynamicCountFields.length;
    raw.writeln('  var count\$ = $fixedNonNullCount;');
    for (final field in dynamicCountFields) {
      final suffix = field.schemaSuffix;
      raw.writeln('  final v\$$suffix = instance.${field.name};');
      raw.writeln('  if (v\$$suffix != null) count\$++;');
    }
    raw.writeln('  final keyed = encoder.keyed(length: count\$);');

    for (final field in nonIgnoredFields) {
      final suffix = field.schemaSuffix;
      final keyExpr = '$schemaName.name$suffix';

      if (_isDynamicallyOmittedField(field)) {
        raw.writeln('  if (v\$$suffix != null) {');
        _writeFieldEncode(raw, field, keyExpr, 'v\$$suffix', indent: '    ');
        raw.writeln('  }');
      } else {
        _writeFieldEncode(
          raw,
          field,
          keyExpr,
          'instance.${field.name}',
          indent: '  ',
        );
      }
    }

    raw.writeln('}');
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
        final tupleMethod = isIntegerTupleTargetType(field.type)
            ? 'encodeIntList'
            : 'encodeDoubleList';
        buffer.writeln('${indent}keyed.$tupleMethod($keyExpr, $access);');
      case TypeCategory.list:
        _writeListEncode(buffer, field, keyExpr, access, indent: indent);
      case TypeCategory.set:
        _writeSetEncode(buffer, field, keyExpr, access, indent: indent);
      case TypeCategory.map:
        _writeMapEncode(buffer, field, keyExpr, access, indent: indent);
      case TypeCategory.nestedCodable || TypeCategory.typeParameter:
        final nonNullType = field.isNullable
            ? model.element.library.typeSystem.promoteToNonNull(field.type)
            : field.type;
        final codecExpr = _codecHelper.forType(
          nonNullType,
          CodecMode.encodable,
        );
        buffer.writeln(
          '${indent}keyed.encodeValue($keyExpr, $access, $codecExpr);',
        );
      case TypeCategory.unknown:
        throw StateError(
          'Unsupported unknown field type '
          '"${field.type.getDisplayString()}" for "${field.name}".',
        );
    }
  }

  static String? _typedDataKeyedMethod(DartType type) =>
      switch (classifyTypedDataKind(type)) {
        TypedDataKind.float64 || TypedDataKind.float32 => 'encodeDoubleList',
        TypedDataKind.uint8Bytes => 'encodeBytes',
        TypedDataKind.intList => 'encodeIntList',
        null => null,
      };

  static String? _primitiveKeyedListMethod(DartType? elemType) {
    if (elemType == null || elemType.isNullableType) return null;
    if (elemType.isDartCoreInt) return 'encodeIntList';
    if (elemType.isDartCoreDouble) return 'encodeDoubleList';
    if (elemType.isDartCoreString) return 'encodeStringList';
    if (elemType.isDartCoreBool) return 'encodeBoolList';
    return null;
  }

  String? _directNonNullElementCodecExpr(DartType? elemType) {
    if (elemType == null || elemType.isNullableType) return null;
    if (elemType is TypeParameterType) {
      if (model.element.library.typeSystem.isPotentiallyNullable(elemType)) {
        return null;
      }
      return _codecHelper.forType(elemType, CodecMode.encodable);
    }
    final element = elemType.element;
    if (element != null && const TypeClassifier().isCodableElement(element)) {
      return _codecHelper.forType(elemType, CodecMode.encodable);
    }
    return null;
  }

  void _writeListEncode(
    StringBuffer buffer,
    FieldDescriptor field,
    String keyExpr,
    String access, {
    required String indent,
  }) {
    final typedMethod = _typedDataKeyedMethod(field.type);
    if (typedMethod != null) {
      buffer.writeln('${indent}keyed.$typedMethod($keyExpr, $access);');
      return;
    }

    final elemType = field.elementType;
    if (elemType == null) {
      throw StateError(
        'Missing element type for List field "${field.name}" '
        '(${field.type.getDisplayString()}).',
      );
    }
    _writeLinearIterableEncode(
      buffer,
      elemType,
      keyExpr,
      access,
      indent: indent,
      isSet: false,
    );
  }

  void _writeSetEncode(
    StringBuffer buffer,
    FieldDescriptor field,
    String keyExpr,
    String access, {
    required String indent,
  }) {
    final elemType = field.elementType;
    if (elemType == null) {
      throw StateError(
        'Missing element type for Set field "${field.name}" '
        '(${field.type.getDisplayString()}).',
      );
    }
    _writeLinearIterableEncode(
      buffer,
      elemType,
      keyExpr,
      access,
      indent: indent,
      isSet: true,
    );
  }

  void _writeLinearIterableEncode(
    StringBuffer buffer,
    DartType elemType,
    String keyExpr,
    String access, {
    required String indent,
    required bool isSet,
  }) {
    final primMethod = _primitiveKeyedListMethod(elemType);
    if (primMethod != null) {
      final listExpr = isSet ? '$access.toList()' : access;
      buffer.writeln('${indent}keyed.$primMethod($keyExpr, $listExpr);');
      return;
    }

    final directCodec = _directNonNullElementCodecExpr(elemType);
    if (directCodec != null) {
      buffer.writeln(
        '${indent}keyed.encodeList($keyExpr, $access, $directCodec);',
      );
      return;
    }

    final elemTypeStr = elemType.getDisplayString();
    buffer.writeln(
      '${indent}keyed.encodeList($keyExpr, $access, '
      'Encodable.fromFunction(($elemTypeStr item, e) {',
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

  String _inlineMapEncodeCode(
    DartType? keyType,
    DartType? valType,
    _EncoderSlot slot,
  ) {
    if (isStringMapKey(keyType)) {
      return _inlineStringMapEncodeCode(valType, slot);
    }
    return _inlineGenericMapEncodeCode(keyType, valType, slot);
  }

  String _inlineStringMapEncodeCode(DartType? valType, _EncoderSlot slot) {
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

  String _keyedMapValueEncodeCode(
    DartType? type,
    String kVar,
    String keyExpr,
    _EncoderSlot slot,
  ) {
    if (type == null) {
      throw StateError('Missing Map value type.');
    }
    if (type.isDartCoreNum) {
      return _numKeyedMapValueEncodeCode(
        kVar,
        keyExpr,
        slot,
        isNullable: type.isNullableType,
      );
    }
    final isDynamicallyNull =
        type.isNullableType ||
        (type is TypeParameterType &&
            model.element.library.typeSystem.isPotentiallyNullable(type));
    if (!isDynamicallyNull) {
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

  String _nonNullKeyedMapValueEncodeCode(
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
    final typed = _typedDataKeyedMethod(type);
    if (typed != null) return typed;
    if (type.isDartCoreList || type.element?.name == 'List') {
      return _primitiveKeyedListMethod(typeArgAt(type, 0));
    }
    return null;
  }

  String _inlineGenericMapEncodeCode(
    DartType? keyType,
    DartType? valType,
    _EncoderSlot slot,
  ) {
    final sfx = slot.depth == 0 ? '' : '${slot.depth}';
    final mapVar = 'm$sfx';
    final entryVar = 'entry$sfx';
    final indent = slot.indent;
    final innerIndent = '$indent    ';
    final out = StringBuffer();
    out.writeln('$indent{');
    out.writeln(
      '$indent  final $mapVar = '
      '${slot.encoderExpr}.map(length: ${slot.itemAccess}.length);',
    );
    out.writeln(
      '$indent  for (final $entryVar in ${slot.itemAccess}.entries) {',
    );
    out.write(
      _encoderValueCode(keyType, (
        itemAccess: '$entryVar.key',
        encoderExpr: '$mapVar.keyEncoder()',
        indent: innerIndent,
        depth: slot.depth + 1,
      )),
    );
    out.write(
      _encoderValueCode(valType, (
        itemAccess: '$entryVar.value',
        encoderExpr: '$mapVar.valueEncoder()',
        indent: innerIndent,
        depth: slot.depth + 1,
      )),
    );
    out.writeln('$indent  }');
    out.writeln('$indent}');
    return out.toString();
  }

  static (String, String)? _scalarEncodeMethods(DartType type) {
    if (type.isDartCoreInt) return ('encodeInt', 'encodeNullableInt');
    if (type.isDartCoreDouble) return ('encodeDouble', 'encodeNullableDouble');
    if (type.isDartCoreString) return ('encodeString', 'encodeNullableString');
    if (type.isDartCoreBool) return ('encodeBool', 'encodeNullableBool');
    if (classifyTypedDataKind(type) == TypedDataKind.uint8Bytes) {
      return ('encodeBytes', 'encodeNullableBytes');
    }
    return null;
  }

  static String? _scalarEncodeMethod(DartType type) {
    final pair = _scalarEncodeMethods(type);
    if (pair == null) return null;
    return type.isNullableType ? pair.$2 : pair.$1;
  }

  String _encoderValueCode(DartType? type, _EncoderSlot slot) {
    if (type == null) {
      throw StateError('Missing nested value type.');
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
    final isDynamicallyNull =
        type.isNullableType ||
        (type is TypeParameterType &&
            model.element.library.typeSystem.isPotentiallyNullable(type));
    if (!isDynamicallyNull) {
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

  static String? _typedUnkeyedElementMethod(DartType type) =>
      switch (classifyTypedDataKind(type)) {
        TypedDataKind.float64 || TypedDataKind.float32 => 'encodeDouble',
        TypedDataKind.intList => 'encodeInt',
        TypedDataKind.uint8Bytes || null => null,
      };

  String _nonNullComplexEncoderValueCode(DartType type, _EncoderSlot slot) {
    final nonNull = model.element.library.typeSystem.promoteToNonNull(type);
    final name = nonNull.element?.name;
    if (nonNull.isDartCoreMap || name == 'Map') {
      return _inlineMapEncodeCode(
        typeArgAt(nonNull, 0),
        typeArgAt(nonNull, 1),
        slot,
      );
    }
    if (nonNull.isDartCoreList ||
        nonNull.isDartCoreSet ||
        name == 'List' ||
        name == 'Set') {
      return _inlineUnkeyedEncodeCode(typeArgAt(nonNull, 0), slot);
    }
    final typedMethod = _typedUnkeyedElementMethod(nonNull);
    if (typedMethod != null) {
      return _inlineTypedUnkeyedEncodeCode(typedMethod, slot);
    }
    if (nonNull is TypeParameterType ||
        (nonNull.element != null &&
            const TypeClassifier().isCodableElement(nonNull.element!))) {
      final codecExpr = _codecHelper.forType(nonNull, CodecMode.encodable);
      return '${slot.indent}$codecExpr.encode('
          '${slot.itemAccess}, ${slot.encoderExpr});\n';
    }
    throw StateError(
      'Unsupported nested value type "${type.getDisplayString()}".',
    );
  }

  String _inlineUnkeyedEncodeCode(DartType? inner, _EncoderSlot slot) {
    if (inner == null) {
      throw StateError('Missing element type for nested collection.');
    }
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
    final directMethod = _scalarEncodeMethod(inner);
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
