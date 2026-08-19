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
    final decoderCode = DecoderGeneratorHelper(model).generate();
    final encoderCode = EncoderGeneratorHelper(model).generate();

    final buffer = StringBuffer();
    buffer.write(decoderCode);
    if (encoderCode.isNotEmpty) {
      buffer.writeln();
      buffer.write(encoderCode);
    }
    return buffer.toString();
  }
}
