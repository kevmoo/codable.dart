// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:codable_builder/codable_builder.dart';
import 'package:source_gen/source_gen.dart';

Future<void> generateForFile(String sourceRelPath, String targetRelPath) async {
  final file = File(sourceRelPath);
  if (!file.existsSync()) {
    print('Skipping $sourceRelPath (not found)');
    return;
  }
  final filePath = file.absolute.path;
  final collection = AnalysisContextCollection(includedPaths: [filePath]);
  final context = collection.contextFor(filePath);
  final session = context.currentSession;
  final resolved =
      await session.getResolvedUnit(filePath) as ResolvedUnitResult;
  final unit = resolved.unit;

  final partOfName = file.uri.pathSegments.last;
  final buffer = StringBuffer();
  buffer.writeln('// GENERATED CODE - DO NOT MODIFY BY HAND\n');
  buffer.writeln(
    '// ignore_for_file: lines_longer_than_80_chars, unnecessary_lambdas, deprecated_member_use, unused_element\n',
  );
  buffer.writeln("part of '$partOfName';\n");

  for (final decl in unit.declarations) {
    if (decl is! ClassDeclaration) continue;
    final element = decl.declaredElement;
    if (element == null) continue;
    final annotation = codableTypeChecker.firstAnnotationOf(element);
    if (annotation == null) continue;
    try {
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
    } catch (e, st) {
      print('Skipping ${element.name}: $e\n$st');
    }
  }

  final outFile = File(targetRelPath);
  outFile.writeAsStringSync(buffer.toString());
  print('Regenerated $targetRelPath successfully!');
}

void main() async {
  final targets = [
    (
      'pkgs/codable_builder/test/fixtures/test_models.dart',
      'pkgs/codable_builder/test/fixtures/test_models.g.dart',
    ),
    (
      'pkgs/codable/test/domain_models_test.dart',
      'pkgs/codable/test/domain_models_test.g.dart',
    ),
    (
      'pkgs/codable/example/mock_codegen/coordinate.dart',
      'pkgs/codable/example/mock_codegen/coordinate.g.dart',
    ),
    (
      'pkgs/codable/example/mock_codegen/canada.dart',
      'pkgs/codable/example/mock_codegen/canada.g.dart',
    ),
    (
      'pkgs/codable/example/mock_codegen/citm_catalog.dart',
      'pkgs/codable/example/mock_codegen/citm_catalog.g.dart',
    ),
    (
      'pkgs/codable/example/basic_example.dart',
      'pkgs/codable/example/basic_example.g.dart',
    ),
    (
      'pkgs/codable/example/custom_decoder_example.dart',
      'pkgs/codable/example/custom_decoder_example.g.dart',
    ),
    (
      'pkgs/codable/example/generic_response_example.dart',
      'pkgs/codable/example/generic_response_example.g.dart',
    ),
    (
      'pkgs/codable/example/polymorphic_example.dart',
      'pkgs/codable/example/polymorphic_example.g.dart',
    ),
    (
      'pkgs/codable/example/tuple_example.dart',
      'pkgs/codable/example/tuple_example.g.dart',
    ),
  ];

  for (final (source, target) in targets) {
    await generateForFile(source, target);
  }
}
