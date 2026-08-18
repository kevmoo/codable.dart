// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// ignore_for_file: deprecated_member_use, lines_longer_than_80_chars

import 'dart:io';

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:checks/checks.dart';
import 'package:codable_generator/codable_generator.dart';
import 'package:source_gen/source_gen.dart';
import 'package:test/test.dart';

void main() {
  late AnalysisContextCollection collection;
  late String fixturePath;
  late CompilationUnit unit;

  setUpAll(() async {
    final candidate1 = File(
      'pkgs/codable_generator/test/fixtures/test_models.dart',
    );
    final candidate2 = File('test/fixtures/test_models.dart');
    final fixtureFile = candidate1.existsSync() ? candidate1 : candidate2;
    fixturePath = fixtureFile.absolute.path;
    collection = AnalysisContextCollection(includedPaths: [fixturePath]);
    final context = collection.contextFor(fixturePath);
    final session = context.currentSession;
    final resolved =
        await session.getResolvedUnit(fixturePath) as ResolvedUnitResult;
    unit = resolved.unit;
  });

  ClassElement? findClass(String className) {
    for (final decl in unit.declarations) {
      if (decl is ClassDeclaration && decl.name.lexeme == className) {
        return decl.declaredElement;
      }
    }
    return null;
  }

  String runGeneratorFor(String className) {
    final element = findClass(className);
    if (element == null) throw StateError('Class $className not found');
    final annotation = codableTypeChecker.firstAnnotationOf(element);
    if (annotation == null) {
      throw StateError('No @Codable annotation on $className');
    }
    final model = const ModelVisitor().visitClass(
      element,
      ConstantReader(annotation),
    );
    final decoderCode = DecoderGeneratorHelper(model).generate();
    final encoderCode = EncoderGeneratorHelper(model).generate();
    return '$decoderCode\n$encoderCode';
  }

  group('CodableGenerator Code Synthesis & Validation Tests', () {
    test(
      'generates schema, decoder, and encoder for positional Point model',
      () {
        final output = runGeneratorFor('Point');

        // Verify schema extension type
        check(output)
            .contains('extension type const _\$PointSchema(int _value)');
        check(output).contains("static const String nameX = 'x';");
        check(output).contains("static const String nameY = 'y';");
        check(output).contains('static const int keyX = 0;');
        check(output).contains('static const int keyY = 1;');
        check(
          output,
        ).contains('static final JsonKeyOptions options = JsonKeyOptions.of');
        check(output).contains('nameX,');
        check(output).contains('nameY,');
        check(output).contains('static const int _xBit = 1 << 0;');
        check(output)
            .contains('static const _\$PointSchema x = _\$PointSchema(_xBit);');
        check(output).contains('static const int _yBit = 1 << 1;');
        check(output)
            .contains('static const _\$PointSchema y = _\$PointSchema(_yBit);');
        check(output).contains(
          'static const _\$PointSchema golden = _\$PointSchema(_xBit | _yBit);',
        );

        check(output).contains('void validate()');
        check(output).contains('_throwMissingFields()');

        // Verify decoder
        check(output)
            .contains('Point _\$PointFromReader(JsonTokenReader reader)');
        check(output).contains('reader.beginObject();');
        check(output).contains('while (reader.hasNext())');
        check(output)
            .contains('switch (reader.selectName(_\$PointSchema.options))');
        check(output).contains('case _\$PointSchema.keyX:');
        check(output).contains('x = reader.readDouble();');
        check(output).contains('seen |= _\$PointSchema.x;');
        check(output).contains('case _\$PointSchema.keyY:');
        check(output).contains('y = reader.readDouble();');
        check(output).contains('seen |= _\$PointSchema.y;');
        check(output).contains('seen.validate();');
        // Positional constructor call
        check(output).contains('return Point(\n    x!,\n    y!,\n  );');

        // Verify encoder
        check(output).contains(
          'void _\$PointToWriter(Point instance, JsonTokenWriter writer)',
        );
        check(output)
            .contains('writer.writeNameBytes(_\$PointSchema.nameXBytes);');
        check(output).contains('writer.writeDouble(instance.x);');
        check(output)
            .contains('writer.writeNameBytes(_\$PointSchema.nameYBytes);');
        check(output).contains('writer.writeDouble(instance.y);');
      },
    );

    test('generates schema and handlers for enums, aliases, tuples, and field renaming', () {
      final output = runGeneratorFor('UserAccount');

      // FieldRename.snake
      check(output)
          .contains("static const String nameEmailAddress = 'email_address';");
      // Aliases in lowerCamelCase
      check(output)
          .contains("static const String aliasEmailAddressEmail = 'email';");
      check(output).contains(
        "static const String aliasEmailAddressContactEmail = 'contact_email';",
      );
      // Options referencing constants
      check(output).contains('nameEmailAddress,');
      check(output).contains('aliasEmailAddressEmail,');
      check(output).contains('aliasEmailAddressContactEmail,');
      // Zero-allocation enum options
      check(output).contains(
        'static final JsonKeyOptions roleEnumOptions = JsonKeyOptions.of(const [',
      );
      check(output).contains("'admin',");
      check(output).contains("'member',");
      check(output).contains("'guest',");
      // Zero-allocation selectString for enums
      check(output).contains(
        'final enumIndex = reader.selectString(_\$UserAccountSchema.roleEnumOptions);',
      );
      // Tuple pre-sizing
      check(output).contains('final tuple = Float64List(2);');
      // Ignored field internalId not in schema options
      check(output).not((s) => s.contains('nameInternalId'));
      // Named constructor invocation with defaults
      check(output).contains('id: id!,');
      check(output).contains('emailAddress: emailAddress!,');
      check(output).contains('role: role!,');
      check(output).contains('tags: tags,');
      check(output).contains('location: location,');
      check(output).contains('internalId: internalId,');
    });

    test('throws InvalidGenerationSourceError when ignored parameter is required without default', () {
      check(() => runGeneratorFor('InvalidIgnoredField'))
          .throws<InvalidGenerationSourceError>();
    });

    test('supports nested @Codable domain classes and collection generics', () {
      final output = runGeneratorFor('Enterprise');

      // Nested decoder call
      check(output).contains('headquarter = _\$AddressFromReader(reader);');
      // List of nested codable
      check(output).contains('_\$AddressFromReader(reader)');
      // Set of string
      check(output).contains('final set = <String>{};');
      // Map of string to int
      check(output).contains('final map = <String, int>{};');
      // Nested encoder call
      check(output)
          .contains('_\$AddressToWriter(instance.headquarter, writer);');
    });

    test('generates code for custom decoders via UserProfileCustom', () {
      final output = runGeneratorFor('UserProfileCustom');

      check(output).contains('const ZipCodeDecoder().decodeFromReader(reader)');
      check(
        output,
      ).contains('const ZipCodeDecoder().encodeToWriter(instance.zip, writer)');
    });

    test(
      'generates code for enum collections and nullable collections in Team',
      () {
        final output = runGeneratorFor('Team');

        check(output).contains('UserRole.values.byName(reader.readString())');
        check(output).contains('final set = <String?>{};');
        check(output).contains('final map = <String, int?>{};');
        check(output).contains('writer.writeString(item.name);');
      },
    );

    test('throws InvalidGenerationSourceError when required fields exceed 62 limit', () {
      check(() => runGeneratorFor('HugeModel63'))
          .throws<InvalidGenerationSourceError>()
          .has((e) => e.message, 'message')
          .contains('exceeds the maximum golden mask limit of 62');
    });
  });
}
