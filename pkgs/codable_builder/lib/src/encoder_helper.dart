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

/// Emits the format-agnostic `_$ModelToEncoder` serializer.
final class EncoderGeneratorHelper {
  final ModelDescriptor model;

  EncoderGeneratorHelper(this.model);

  /// Generates the serializer code for [model].
  String generate() {
    if (!model.createEncoder) return '';

    final buffer = StringBuffer();
    final schemaName = '_\$${model.className}Schema';
    final funcName = '_\$${model.className}ToEncoder';

    buffer.writeln(
      '// =============================================================================',
    );
    buffer.writeln('// 3. Universal Serializer for ${model.className}');
    buffer.writeln(
      '// =============================================================================',
    );
    buffer.writeln(
      'void $funcName(${model.className} instance, Encoder encoder) {',
    );
    buffer.writeln('  final keyed = encoder.keyed();');

    final nonIgnoredFields = model.fields.where((f) => !f.ignore).toList();

    for (final field in nonIgnoredFields) {
      final suffix = toSafeIdentifierSuffix(field.name);
      final fieldAccess = 'instance.${field.name}';
      final keyExpr = '$schemaName.staticKey$suffix';

      if (field.isNullable) {
        buffer.writeln('  if ($fieldAccess != null) {');
        _writeFieldEncode(
          buffer,
          field,
          keyExpr,
          '$fieldAccess!',
          indent: '    ',
        );
        buffer.writeln('  }');
      } else {
        _writeFieldEncode(buffer, field, keyExpr, fieldAccess, indent: '  ');
      }
    }

    buffer.writeln('}');
    return buffer.toString();
  }

  void _writeFieldEncode(
    StringBuffer buffer,
    FieldDescriptor field,
    String keyExpr,
    String access, {
    required String indent,
  }) {
    switch (field.category) {
      case TypeCategory.primitiveInt:
        buffer.writeln('${indent}keyed.encodeIntKey($keyExpr, $access);');
      case TypeCategory.primitiveDouble:
        buffer.writeln('${indent}keyed.encodeDoubleKey($keyExpr, $access);');
      case TypeCategory.primitiveNum:
        buffer.writeln('${indent}if ($access is int) {');
        buffer.writeln(
          '$indent  keyed.encodeIntKey($keyExpr, $access as int);',
        );
        buffer.writeln('$indent} else {');
        buffer.writeln(
          '$indent  keyed.encodeDoubleKey($keyExpr, $access.toDouble());',
        );
        buffer.writeln('$indent}');
      case TypeCategory.primitiveString:
        buffer.writeln('${indent}keyed.encodeStringKey($keyExpr, $access);');
      case TypeCategory.primitiveBool:
        buffer.writeln('${indent}keyed.encodeBoolKey($keyExpr, $access);');
      case TypeCategory.enumType:
        buffer.writeln(
          '${indent}keyed.encodeStringKey($keyExpr, $access.name);',
        );
      case TypeCategory.custom:
        final decoder = field.customDecoderCode;
        buffer.writeln(
          '${indent}keyed.encodeValueKey($keyExpr, $access, '
          '(v, e) => $decoder.encodeToEncoder(v, e));',
        );
      case TypeCategory.tuple:
        final tupleLen = field.tupleLength ?? 2;
        buffer.writeln(
          '${indent}keyed.encodeListKey<double>($keyExpr, '
          'List.generate($tupleLen, (i) => $access[i]), '
          '(v, e) => e.singleValue().encodeDouble(v));',
        );
      case TypeCategory.list:
        _writeListEncode(buffer, field, keyExpr, access, indent: indent);
      case TypeCategory.set:
        _writeSetEncode(buffer, field, keyExpr, access, indent: indent);
      case TypeCategory.map:
        _writeMapEncode(buffer, field, keyExpr, access, indent: indent);
      case TypeCategory.nestedCodable:
        final nestedName = field.type.element!.name;
        buffer.writeln(
          '${indent}keyed.encodeValueKey('
          '$keyExpr, $access, _\$${nestedName}ToEncoder);',
        );
      case TypeCategory.unknown:
        buffer.writeln(
          '${indent}keyed.encodeStringKey($keyExpr, $access.toString());',
        );
    }
  }

  void _writeListEncode(
    StringBuffer buffer,
    FieldDescriptor field,
    String keyExpr,
    String access, {
    required String indent,
  }) {
    final elemType = field.elementType;
    final isNullable = elemType?.isNullableType ?? false;
    if (elemType != null && elemType.isDartCoreInt && !isNullable) {
      buffer.writeln('${indent}keyed.encodeIntListKey($keyExpr, $access);');
    } else if (elemType != null &&
        (elemType.isDartCoreDouble || elemType.isDartCoreNum) &&
        !isNullable) {
      buffer.writeln(
        '${indent}keyed.encodeDoubleListKey($keyExpr, '
        '$access.map((e) => e.toDouble()).toList());',
      );
    } else if (elemType != null && elemType.isDartCoreString && !isNullable) {
      buffer.writeln('${indent}keyed.encodeStringListKey($keyExpr, $access);');
    } else if (elemType != null && elemType.isDartCoreBool && !isNullable) {
      buffer.writeln('${indent}keyed.encodeBoolListKey($keyExpr, $access);');
    } else if (elemType != null &&
        elemType.element != null &&
        const TypeClassifier().isCodableElement(elemType.element!)) {
      final nestedName = elemType.element!.name;
      buffer.writeln(
        '${indent}keyed.encodeListKey('
        '$keyExpr, $access, _\$${nestedName}ToEncoder);',
      );
    } else {
      buffer.writeln(
        '${indent}keyed.encodeListKey($keyExpr, $access, (item, e) {',
      );
      _writeElementEncode(buffer, elemType, 'item', indent: '$indent  ');
      buffer.writeln('$indent});');
    }
  }

  void _writeSetEncode(
    StringBuffer buffer,
    FieldDescriptor field,
    String keyExpr,
    String access, {
    required String indent,
  }) {
    final elemType = field.elementType;
    final isNullable = elemType?.isNullableType ?? false;
    if (elemType != null && elemType.isDartCoreInt && !isNullable) {
      buffer.writeln(
        '${indent}keyed.encodeIntListKey($keyExpr, $access.toList());',
      );
    } else if (elemType != null &&
        (elemType.isDartCoreDouble || elemType.isDartCoreNum) &&
        !isNullable) {
      buffer.writeln(
        '${indent}keyed.encodeDoubleListKey($keyExpr, '
        '$access.map((e) => e.toDouble()).toList());',
      );
    } else if (elemType != null && elemType.isDartCoreString && !isNullable) {
      buffer.writeln(
        '${indent}keyed.encodeStringListKey($keyExpr, $access.toList());',
      );
    } else if (elemType != null && elemType.isDartCoreBool && !isNullable) {
      buffer.writeln(
        '${indent}keyed.encodeBoolListKey($keyExpr, $access.toList());',
      );
    } else {
      buffer.writeln(
        '${indent}keyed.encodeListKey($keyExpr, $access, (item, e) {',
      );
      _writeElementEncode(buffer, elemType, 'item', indent: '$indent  ');
      buffer.writeln('$indent});');
    }
  }

  void _writeMapEncode(
    StringBuffer buffer,
    FieldDescriptor field,
    String keyExpr,
    String access, {
    required String indent,
  }) {
    buffer.writeln(
      '${indent}keyed.encodeValueKey($keyExpr, $access, (map, e) {',
    );
    buffer.writeln('$indent  final k = e.keyed();');
    buffer.writeln('$indent  for (final entry in map.entries) {');
    _writeMapValueEncode(
      buffer,
      field.mapValueType,
      'entry.key',
      'entry.value',
      indent: '$indent    ',
    );
    buffer.writeln('$indent  }');
    buffer.writeln('$indent});');
  }

  void _writeMapValueEncode(
    StringBuffer buffer,
    DartType? type,
    String keyAccess,
    String itemAccess, {
    required String indent,
  }) {
    if (type == null) {
      buffer.writeln(
        '${indent}k.encodeString($keyAccess, $itemAccess.toString());',
      );
      return;
    }
    final isNullable = type.isNullableType;
    if (type.isDartCoreString) {
      if (isNullable) {
        buffer.writeln(
          '${indent}k.encodeNullableString($keyAccess, $itemAccess);',
        );
      } else {
        buffer.writeln('${indent}k.encodeString($keyAccess, $itemAccess);');
      }
    } else if (type.isDartCoreInt) {
      if (isNullable) {
        buffer.writeln(
          '${indent}k.encodeNullableInt($keyAccess, $itemAccess);',
        );
      } else {
        buffer.writeln('${indent}k.encodeInt($keyAccess, $itemAccess);');
      }
    } else if (type.isDartCoreDouble || type.isDartCoreNum) {
      if (isNullable) {
        buffer.writeln(
          '${indent}k.encodeNullableDouble('
          '$keyAccess, $itemAccess?.toDouble());',
        );
      } else {
        buffer.writeln(
          '${indent}k.encodeDouble($keyAccess, $itemAccess.toDouble());',
        );
      }
    } else if (type.isDartCoreBool) {
      if (isNullable) {
        buffer.writeln(
          '${indent}k.encodeNullableBool($keyAccess, $itemAccess);',
        );
      } else {
        buffer.writeln('${indent}k.encodeBool($keyAccess, $itemAccess);');
      }
    } else if (type.element != null &&
        const TypeClassifier().isCodableElement(type.element!)) {
      final nestedName = type.element!.name;
      if (isNullable) {
        buffer.writeln(
          '${indent}k.encodeNullableValue('
          '$keyAccess, $itemAccess, _\$${nestedName}ToEncoder);',
        );
      } else {
        buffer.writeln(
          '${indent}k.encodeValue('
          '$keyAccess, $itemAccess, _\$${nestedName}ToEncoder);',
        );
      }
    } else {
      buffer.writeln(
        '${indent}k.encodeString($keyAccess, $itemAccess.toString());',
      );
    }
  }

  void _writeElementEncode(
    StringBuffer buffer,
    DartType? type,
    String itemAccess, {
    required String indent,
  }) {
    if (type == null) {
      buffer.writeln(
        '${indent}e.singleValue().encodeString($itemAccess.toString());',
      );
      return;
    }

    if (type.isNullableType) {
      buffer.writeln('${indent}if ($itemAccess == null) {');
      buffer.writeln('$indent  e.singleValue().encodeNull();');
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
      buffer.writeln('${indent}e.singleValue().encodeInt($itemAccess);');
    } else if (type.isDartCoreDouble) {
      buffer.writeln('${indent}e.singleValue().encodeDouble($itemAccess);');
    } else if (type.isDartCoreNum) {
      buffer.writeln('${indent}if ($itemAccess is int) {');
      buffer.writeln('$indent  e.singleValue().encodeInt($itemAccess as int);');
      buffer.writeln('$indent} else {');
      buffer.writeln(
        '$indent  e.singleValue().encodeDouble($itemAccess.toDouble());',
      );
      buffer.writeln('$indent}');
    } else if (type.isDartCoreString) {
      buffer.writeln('${indent}e.singleValue().encodeString($itemAccess);');
    } else if (type.isDartCoreBool) {
      buffer.writeln('${indent}e.singleValue().encodeBool($itemAccess);');
    } else if (type.element is EnumElement) {
      buffer.writeln(
        '${indent}e.singleValue().encodeString($itemAccess.name);',
      );
    } else if (type.element != null &&
        const TypeClassifier().isCodableElement(type.element!)) {
      buffer.writeln(
        '${indent}_\$${type.element!.name}ToEncoder($itemAccess, e);',
      );
    } else {
      buffer.writeln(
        '${indent}e.singleValue().encodeString($itemAccess.toString());',
      );
    }
  }
}

extension on DartType {
  bool get isNullableType =>
      nullabilitySuffix == NullabilitySuffix.question || this is DynamicType;
}
