// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:codable_builder/codable_builder.dart';
import 'package:source_gen/source_gen.dart';

void main() async {
  final candidate1 = File('test/fixtures/test_models.dart');
  final candidate2 = File(
    'pkgs/codable_builder/test/fixtures/test_models.dart',
  );
  final fixtureFile = candidate1.existsSync() ? candidate1 : candidate2;
  final fixturePath = fixtureFile.absolute.path;

  final collection = AnalysisContextCollection(includedPaths: [fixturePath]);
  final context = collection.contextFor(fixturePath);
  final session = context.currentSession;
  final resolved =
      await session.getResolvedUnit(fixturePath) as ResolvedUnitResult;
  final unit = resolved.unit;

  final classes = [
    'Point',
    'UserAccount',
    'Address',
    'Enterprise',
    'UserProfileCustom',
    'Team',
  ];

  final buffer = StringBuffer();
  buffer.writeln('// GENERATED CODE - DO NOT MODIFY BY HAND\n');
  buffer.writeln("part of 'test_models.dart';\n");

  for (final className in classes) {
    ClassElement? element;
    for (final decl in unit.declarations) {
      if (decl is ClassDeclaration && decl.name.lexeme == className) {
        element = decl.declaredElement;
        break;
      }
    }
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

  final outCandidate1 = File('test/fixtures/test_models.g.dart');
  final outCandidate2 = File(
    'pkgs/codable_builder/test/fixtures/test_models.g.dart',
  );
  final outFile = outCandidate1.parent.existsSync()
      ? outCandidate1
      : outCandidate2;
  outFile.writeAsStringSync(buffer.toString());
  print('Regenerated ${outFile.path} successfully!');
}
