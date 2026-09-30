// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// ignore_for_file: deprecated_member_use, lines_longer_than_80_chars

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';

import 'field_descriptor.dart';
import 'type_helper.dart';
import 'utils.dart';

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

    raw.writeln('@override');
    raw.writeln('void encode(${model.className} instance, Encoder encoder) {');
    raw.writeln('  final keyed = encoder.keyed();');

    final nonIgnoredFields = model.fields.where((f) => !f.ignore).toList();

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
  }) {
    switch (field.category) {
      case TypeCategory.primitiveInt:
        buffer.writeln('${indent}keyed.encodeInt($keyExpr, $access);');
      case TypeCategory.primitiveDouble:
        buffer.writeln('${indent}keyed.encodeDouble($keyExpr, $access);');
      case TypeCategory.primitiveNum:
        buffer.writeln('${indent}if ($access is int) {');
        buffer.writeln('$indent  keyed.encodeInt($keyExpr, $access as int);');
        buffer.writeln('$indent} else {');
        buffer.writeln(
          '$indent  keyed.encodeDouble($keyExpr, $access.toDouble());',
        );
        buffer.writeln('$indent}');
      case TypeCategory.primitiveString:
        buffer.writeln('${indent}keyed.encodeString($keyExpr, $access);');
      case TypeCategory.primitiveBool:
        buffer.writeln('${indent}keyed.encodeBool($keyExpr, $access);');
      case TypeCategory.enumType:
        buffer.writeln('${indent}keyed.encodeString($keyExpr, $access.name);');
      case TypeCategory.custom:
        final decoder = field.customDecoderCode;
        buffer.writeln(
          '${indent}keyed.encodeValue($keyExpr, $access, $decoder);',
        );
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

  void _writeListEncode(
    StringBuffer buffer,
    FieldDescriptor field,
    String keyExpr,
    String access, {
    required String indent,
  }) {
    final typeName = field.type.element?.name;
    if (typeName == 'Float64List' || typeName == 'Float32List') {
      buffer.writeln('${indent}keyed.encodeDoubleList($keyExpr, $access);');
      return;
    } else if (typeName == 'Int64List' ||
        typeName == 'Int32List' ||
        typeName == 'Uint8List') {
      buffer.writeln('${indent}keyed.encodeIntList($keyExpr, $access);');
      return;
    }

    final elemType = field.elementType;
    final isNullable = elemType?.isNullableType ?? false;
    if (elemType != null && elemType.isDartCoreInt && !isNullable) {
      buffer.writeln('${indent}keyed.encodeIntList($keyExpr, $access);');
    } else if (elemType != null && elemType.isDartCoreDouble && !isNullable) {
      buffer.writeln('${indent}keyed.encodeDoubleList($keyExpr, $access);');
    } else if (elemType != null && elemType.isDartCoreNum && !isNullable) {
      buffer.writeln(
        '${indent}keyed.encodeDoubleList($keyExpr, '
        '$access.map((e) => e.toDouble()).toList());',
      );
    } else if (elemType != null && elemType.isDartCoreString && !isNullable) {
      buffer.writeln('${indent}keyed.encodeStringList($keyExpr, $access);');
    } else if (elemType != null && elemType.isDartCoreBool && !isNullable) {
      buffer.writeln('${indent}keyed.encodeBoolList($keyExpr, $access);');
    } else if (elemType != null &&
        !isNullable &&
        elemType.element != null &&
        const TypeClassifier().isCodableElement(elemType.element!)) {
      final nestedName = elemType.element!.name;
      buffer.writeln(
        '${indent}keyed.encodeList('
        '$keyExpr, $access, const ${nestedName}Codable());',
      );
    } else {
      final elemTypeStr = elemType?.getDisplayString() ?? 'dynamic';
      buffer.writeln(
        '${indent}keyed.encodeList($keyExpr, $access, Encodable.fromFunction(($elemTypeStr item, e) {',
      );
      _writeElementEncode(buffer, elemType, 'item', indent: '$indent  ');
      buffer.writeln('$indent}));');
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
        '${indent}keyed.encodeIntList($keyExpr, $access.toList());',
      );
    } else if (elemType != null &&
        (elemType.isDartCoreDouble || elemType.isDartCoreNum) &&
        !isNullable) {
      buffer.writeln(
        '${indent}keyed.encodeDoubleList($keyExpr, '
        '$access.map((e) => e.toDouble()).toList());',
      );
    } else if (elemType != null && elemType.isDartCoreString && !isNullable) {
      buffer.writeln(
        '${indent}keyed.encodeStringList($keyExpr, $access.toList());',
      );
    } else if (elemType != null && elemType.isDartCoreBool && !isNullable) {
      buffer.writeln(
        '${indent}keyed.encodeBoolList($keyExpr, $access.toList());',
      );
    } else {
      final elemTypeStr = elemType?.getDisplayString() ?? 'dynamic';
      buffer.writeln(
        '${indent}keyed.encodeList($keyExpr, $access, Encodable.fromFunction(($elemTypeStr item, e) {',
      );
      _writeElementEncode(buffer, elemType, 'item', indent: '$indent  ');
      buffer.writeln('$indent}));');
    }
  }

  void _writeMapEncode(
    StringBuffer buffer,
    FieldDescriptor field,
    String keyExpr,
    String access, {
    required String indent,
  }) {
    final valTypeStr = field.mapValueType?.getDisplayString() ?? 'dynamic';
    buffer.writeln(
      '${indent}keyed.encodeValue($keyExpr, $access, Encodable.fromFunction((Map<String, $valTypeStr> map, e) {',
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
    buffer.writeln('$indent}));');
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
          '$keyAccess, $itemAccess, const ${nestedName}Codable());',
        );
      } else {
        buffer.writeln(
          '${indent}k.encodeValue('
          '$keyAccess, $itemAccess, const ${nestedName}Codable());',
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
    } else if (type.isDartCoreList || type.element?.name == 'List') {
      final inner = type is InterfaceType && type.typeArguments.isNotEmpty
          ? type.typeArguments.first
          : null;
      final innerTypeStr = inner?.getDisplayString() ?? 'dynamic';
      buffer.writeln(
        '${indent}e.unkeyed().encodeList($itemAccess, Encodable.fromFunction(($innerTypeStr item, e) {',
      );
      _writeElementEncode(buffer, inner, 'item', indent: '$indent  ');
      buffer.writeln('$indent}));');
    } else if (type.element?.name == 'Float64List' ||
        type.element?.name == 'Float32List') {
      buffer.writeln(
        '${indent}e.unkeyed().encodeList($itemAccess, Encodable.fromFunction((double item, e) => e.singleValue().encodeDouble(item)));',
      );
    } else if (type.element?.name == 'Int64List' ||
        type.element?.name == 'Int32List' ||
        type.element?.name == 'Uint8List') {
      buffer.writeln(
        '${indent}e.unkeyed().encodeList($itemAccess, Encodable.fromFunction((int item, e) => e.singleValue().encodeInt(item)));',
      );
    } else if (type.element != null &&
        const TypeClassifier().isCodableElement(type.element!)) {
      buffer.writeln(
        '${indent}const ${type.element!.name}Codable().encode($itemAccess, e);',
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
