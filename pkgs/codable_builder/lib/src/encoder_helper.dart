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

/// Emits the single-pass `_$ModelToWriter` streaming serializer.
final class EncoderGeneratorHelper {
  final ModelDescriptor model;

  EncoderGeneratorHelper(this.model);

  /// Generates the serializer code for [model].
  String generate() {
    if (!model.createEncoder) return '';

    final buffer = StringBuffer();
    final schemaName = '_\$${model.className}Schema';
    final funcName = '_\$${model.className}ToWriter';

    buffer.writeln(
      '// =============================================================================',
    );
    buffer.writeln(
      '// 3. Single-Pass Streaming Serializer for ${model.className}',
    );
    buffer.writeln(
      '// =============================================================================',
    );
    buffer.writeln(
      'void $funcName(${model.className} instance, JsonTokenWriter writer) {',
    );
    buffer.writeln('  writer.beginObject();');

    final nonIgnoredFields = model.fields.where((f) => !f.ignore).toList();

    for (final field in nonIgnoredFields) {
      final suffix = toSafeIdentifierSuffix(field.name);
      final fieldAccess = 'instance.${field.name}';

      if (field.isNullable) {
        buffer.writeln('  if ($fieldAccess != null) {');
        buffer.writeln(
          '    writer.writeNameBytes($schemaName.name${suffix}Bytes);',
        );
        _writeValue(buffer, field, '$fieldAccess!', indent: '    ');
        buffer.writeln('  }');
      } else {
        buffer.writeln(
          '  writer.writeNameBytes($schemaName.name${suffix}Bytes);',
        );
        _writeValue(buffer, field, fieldAccess, indent: '  ');
      }
    }

    buffer.writeln('  writer.endObject();');
    buffer.writeln('}');
    return buffer.toString();
  }

  void _writeValue(
    StringBuffer buffer,
    FieldDescriptor field,
    String access, {
    required String indent,
  }) {
    switch (field.category) {
      case TypeCategory.primitiveInt:
        buffer.writeln('${indent}writer.writeInt($access);');
      case TypeCategory.primitiveDouble:
        buffer.writeln('${indent}writer.writeDouble($access);');
      case TypeCategory.primitiveNum:
        buffer.writeln('${indent}if ($access is int) {');
        buffer.writeln('$indent  writer.writeInt($access as int);');
        buffer.writeln('$indent} else {');
        buffer.writeln('$indent  writer.writeDouble($access.toDouble());');
        buffer.writeln('$indent}');
      case TypeCategory.primitiveString:
        buffer.writeln('${indent}writer.writeString($access);');
      case TypeCategory.primitiveBool:
        buffer.writeln('${indent}writer.writeBool($access);');
      case TypeCategory.enumType:
        buffer.writeln('${indent}writer.writeString($access.name);');
      case TypeCategory.custom:
        final decoder = field.customDecoderCode;
        buffer.writeln('$indent$decoder.encodeToWriter($access, writer);');

      case TypeCategory.tuple:
        final tupleLen = field.tupleLength ?? 2;
        buffer.writeln('${indent}writer.beginArray();');
        for (var i = 0; i < tupleLen; i++) {
          buffer.writeln('${indent}writer.writeDouble($access[$i]);');
        }
        buffer.writeln('${indent}writer.endArray();');
      case TypeCategory.list:
        _writeListEncode(buffer, field, access, indent: indent);
      case TypeCategory.set:
        _writeSetEncode(buffer, field, access, indent: indent);
      case TypeCategory.map:
        _writeMapEncode(buffer, field, access, indent: indent);
      case TypeCategory.nestedCodable:
        final nestedName = field.type.element!.name;
        buffer.writeln('${indent}_\$${nestedName}ToWriter($access, writer);');
      case TypeCategory.unknown:
        buffer.writeln('${indent}writer.writeString($access.toString());');
    }
  }

  void _writeListEncode(
    StringBuffer buffer,
    FieldDescriptor field,
    String access, {
    required String indent,
  }) {
    buffer.writeln('${indent}writer.beginArray();');
    buffer.writeln('${indent}for (final item in $access) {');
    _writeElementEncode(buffer, field.elementType, 'item', indent: '$indent  ');
    buffer.writeln('$indent}');
    buffer.writeln('${indent}writer.endArray();');
  }

  void _writeSetEncode(
    StringBuffer buffer,
    FieldDescriptor field,
    String access, {
    required String indent,
  }) {
    buffer.writeln('${indent}writer.beginArray();');
    buffer.writeln('${indent}for (final item in $access) {');
    _writeElementEncode(buffer, field.elementType, 'item', indent: '$indent  ');
    buffer.writeln('$indent}');
    buffer.writeln('${indent}writer.endArray();');
  }

  void _writeMapEncode(
    StringBuffer buffer,
    FieldDescriptor field,
    String access, {
    required String indent,
  }) {
    buffer.writeln('${indent}writer.beginObject();');
    buffer.writeln('${indent}for (final entry in $access.entries) {');
    buffer.writeln('$indent  final value = entry.value;');
    buffer.writeln('$indent  writer.writeName(entry.key);');
    _writeElementEncode(
      buffer,
      field.mapValueType,
      'value',
      indent: '$indent  ',
    );
    buffer.writeln('$indent}');
    buffer.writeln('${indent}writer.endObject();');
  }

  void _writeElementEncode(
    StringBuffer buffer,
    DartType? type,
    String itemAccess, {
    required String indent,
  }) {
    if (type == null) {
      buffer.writeln('${indent}writer.writeString($itemAccess.toString());');
      return;
    }

    if (type.isNullableType) {
      buffer.writeln('${indent}if ($itemAccess == null) {');
      buffer.writeln('$indent  writer.writeNull();');
      buffer.writeln('$indent} else {');
      _writeNonNullElementEncode(buffer, type, itemAccess, indent: '$indent  ');
      buffer.writeln('$indent}');
    } else {
      _writeNonNullElementEncode(buffer, type, itemAccess, indent: indent);
    }
  }

  void _writeNonNullElementEncode(
    StringBuffer buffer,
    DartType type,
    String itemAccess, {
    required String indent,
  }) {
    if (type.isDartCoreInt) {
      buffer.writeln('${indent}writer.writeInt($itemAccess);');
    } else if (type.isDartCoreDouble) {
      buffer.writeln('${indent}writer.writeDouble($itemAccess);');
    } else if (type.isDartCoreNum) {
      buffer.writeln('${indent}if ($itemAccess is int) {');
      buffer.writeln('$indent  writer.writeInt($itemAccess as int);');
      buffer.writeln('$indent} else {');
      buffer.writeln('$indent  writer.writeDouble($itemAccess.toDouble());');
      buffer.writeln('$indent}');
    } else if (type.isDartCoreString) {
      buffer.writeln('${indent}writer.writeString($itemAccess);');
    } else if (type.isDartCoreBool) {
      buffer.writeln('${indent}writer.writeBool($itemAccess);');
    } else if (type.element is EnumElement) {
      buffer.writeln('${indent}writer.writeString($itemAccess.name);');
    } else if (type.element != null &&
        const TypeClassifier().isCodableElement(type.element!)) {
      buffer.writeln(
        '${indent}_\$${type.element!.name}ToWriter($itemAccess, writer);',
      );
    } else {
      buffer.writeln('${indent}writer.writeString($itemAccess.toString());');
    }
  }
}

extension on DartType {
  bool get isNullableType =>
      nullabilitySuffix == NullabilitySuffix.question || this is DynamicType;
}
