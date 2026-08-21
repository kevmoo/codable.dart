// ignore_for_file: depend_on_referenced_packages, deprecated_member_use
// ignore_for_file: prefer_single_quotes

import 'dart:io';

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:codable_builder/codable_builder.dart';
import 'package:source_gen/source_gen.dart';

void main() async {
  final modelsDir = Directory('benchmark/models/codable');
  final modelFiles = modelsDir
      .listSync()
      .whereType<File>()
      .where((f) => f.path.endsWith('.dart') && !f.path.endsWith('.g.dart'))
      .toList();

  for (final file in modelFiles) {
    final filePath = file.absolute.path;
    final collection = AnalysisContextCollection(includedPaths: [filePath]);
    final context = collection.contextFor(filePath);
    final session = context.currentSession;
    final resolved =
        await session.getResolvedUnit(filePath) as ResolvedUnitResult;
    final unit = resolved.unit;

    final buffer = StringBuffer();
    buffer.writeln('// GENERATED CODE - DO NOT MODIFY BY HAND\n');
    buffer.writeln("// ignore_for_file: lines_longer_than_80_chars\n");
    final partName = file.uri.pathSegments.last;
    buffer.writeln("part of '$partName';\n");

    for (final decl in unit.declarations) {
      if (decl is ClassDeclaration) {
        final element = decl.declaredElement;
        if (element == null) continue;
        final annotation = codableTypeChecker.firstAnnotationOf(element);
        if (annotation == null) continue;
        final model = const ModelVisitor().visitClass(
          element,
          ConstantReader(annotation),
        );
        final decoderCode = DecoderGeneratorHelper(model).generate();
        final encoderCode = EncoderGeneratorHelper(model).generate();
        buffer.writeln(decoderCode);
        buffer.writeln();
        if (encoderCode.isNotEmpty) {
          buffer.writeln(encoderCode);
          buffer.writeln();
        }
      }
    }

    final outPath = '${filePath.substring(0, filePath.length - 5)}.g.dart';
    File(outPath).writeAsStringSync(buffer.toString());
    print('Generated $outPath');
  }
}
