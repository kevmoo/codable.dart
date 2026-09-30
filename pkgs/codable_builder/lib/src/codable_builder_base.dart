// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// ignore_for_file: deprecated_member_use

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:codable/codable.dart';
import 'package:source_gen/source_gen.dart';

import 'decoder_helper.dart';
import 'encoder_helper.dart';
import 'field_descriptor.dart';
import 'model_visitor.dart';

/// Generator for classes annotated with [@Codable].
class CodableGenerator extends GeneratorForAnnotation<Codable> {
  final ModelVisitor _visitor;

  const CodableGenerator({this._visitor = const ModelVisitor()});

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

  /// Generates the schema extension type and companion `*Codable` class for
  /// [model].
  String generateForModel(ModelDescriptor model) {
    final decoderHelper = DecoderGeneratorHelper(model);
    final encoderHelper = EncoderGeneratorHelper(model);

    final buffer = StringBuffer();
    buffer.write(decoderHelper.generateSchema());

    final interfaceName = switch ((model.createDecoder, model.createEncoder)) {
      (true, true) => 'Codable<${model.className}>',
      (true, false) => 'Decodable<${model.className}>',
      (false, true) => 'Encodable<${model.className}>',
      (false, false) => null,
    };

    if (interfaceName != null) {
      buffer.writeln();
      buffer.writeln(
        '// =============================================================================',
      );
      buffer.writeln('// 2. Companion Codable for ${model.className}');
      buffer.writeln(
        '// =============================================================================',
      );
      buffer.writeln(
        'final class ${model.className}Codable implements $interfaceName {',
      );
      buffer.writeln('  const ${model.className}Codable();');

      if (model.createDecoder) {
        buffer.writeln();
        buffer.write(decoderHelper.generateMethods());
      }
      if (model.createEncoder) {
        buffer.writeln();
        buffer.write(encoderHelper.generateMethod());
      }

      buffer.writeln('}');
    }

    return buffer.toString();
  }
}
