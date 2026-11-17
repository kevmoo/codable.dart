// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:codable/codable.dart';
import 'package:source_gen/source_gen.dart';

import 'decoder_helper.dart';
import 'encoder_helper.dart';
import 'field_descriptor.dart';
import 'model_visitor.dart';
import 'polymorphic_helper.dart';

/// Generator for classes annotated with [@Codable].
class CodableGenerator extends GeneratorForAnnotation<Codable> {
  final ModelVisitor _visitor;

  const CodableGenerator() : _visitor = const ModelVisitor();

  @override
  FutureOr<String> generate(LibraryReader library, BuildStep buildStep) async {
    final generated = await super.generate(library, buildStep);
    if (generated.isEmpty) return generated;
    return '// ignore_for_file: omit_local_variable_types\n\n$generated';
  }

  @override
  String generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    if (element is! ClassElement) {
      throw InvalidGenerationSourceError(
        '@Codable can only be applied to classes.',
        element: element,
      );
    }

    final model = _visitor.visitClass(element, annotation);
    return generateForModel(model);
  }
}

/// Generates the schema extension type and companion `*Codable` class for
/// [model].
String generateForModel(ModelDescriptor model) {
  final targetType = model.instantiatedClassName;
  final interfaceName = switch ((model.createDecoder, model.createEncoder)) {
    (true, true) => 'KeyedCodable<$targetType>',
    (true, false) => 'Decodable<$targetType>',
    (false, true) => 'KeyedEncodable<$targetType>',
    (false, false) => null,
  };

  final String schemaCode;
  var decodeMethods = '';
  var encodeMethods = '';

  if (model.isPolymorphic) {
    final polyHelper = PolymorphicGeneratorHelper(model);
    decodeMethods = polyHelper.generateDecodeMethod();
    encodeMethods = polyHelper.generateEncodeMethods();
    schemaCode = polyHelper.generateSchema();
  } else {
    final decoderHelper = DecoderGeneratorHelper(model);
    if (model.createDecoder) decodeMethods = decoderHelper.generateMethods();
    if (model.createEncoder) {
      encodeMethods = EncoderGeneratorHelper(model).generateMethod();
    }
    schemaCode = decoderHelper.generateSchema();
  }

  final buffer = StringBuffer(schemaCode);
  if (interfaceName != null) {
    buffer
      ..writeln()
      ..writeln(
        '// =============================================================================',
      )
      ..writeln('// 2. Companion Codable for ${model.className}')
      ..writeln(
        '// =============================================================================',
      )
      ..writeln(
        'final class ${model.className}Codable${model.typeParamsDeclaration} '
        'implements $interfaceName {',
      );
    _writeCompanionFieldsAndConstructor(buffer, model);
    for (final section in [decodeMethods, encodeMethods]) {
      if (section.isNotEmpty) {
        buffer
          ..writeln()
          ..write(section);
      }
    }
    buffer.writeln('}');
  }

  return buffer.toString();
}

void _writeCompanionFieldsAndConstructor(
  StringBuffer buffer,
  ModelDescriptor model,
) {
  if (!model.isGeneric) {
    buffer.writeln('  const ${model.className}Codable();');
    return;
  }
  final paramContractPrefix = switch ((
    model.createDecoder,
    model.createEncoder,
  )) {
    (true, false) => 'Decodable',
    (false, true) => 'Encodable',
    _ => 'Codable',
  };
  for (final tp in model.typeParameters) {
    buffer.writeln(
      '  final $paramContractPrefix<${tp.name}> ${tp.codecFieldName};',
    );
  }
  buffer.writeln();
  final ctorParams = model.typeParameters
      .map((tp) => 'this.${tp.codecFieldName}')
      .join(', ');
  buffer.writeln('  const ${model.className}Codable($ctorParams);');
}
