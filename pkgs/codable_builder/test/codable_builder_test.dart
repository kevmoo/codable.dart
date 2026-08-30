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
import 'package:codable_builder/codable_builder.dart';
import 'package:source_gen/source_gen.dart';
import 'package:test/test.dart';

void main() {
  late AnalysisContextCollection collection;
  late String fixturePath;
  late CompilationUnit unit;

  setUpAll(() async {
    final candidate1 = File(
      'pkgs/codable_builder/test/fixtures/test_models.dart',
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
        ).contains('static final KeyOptions options = KeyOptions.of(const [');
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

        // Verify universal decoder
        check(output).contains('Point _\$PointFromDecoder(Decoder decoder)');
        check(output).contains(
          'final keyed = decoder.keyed(options: _\$PointSchema.keyOptions);',
        );
        check(output).contains('while (keyed.hasNextKey())');
        check(
          output,
        ).contains('switch (keyed.selectKeyIndex(_\$PointSchema.keyOptions))');
        check(output).contains('case _\$PointSchema.keyX:');
        check(output).contains('x = keyed.readDouble();');
        check(output).contains('seen |= _\$PointSchema.x;');
        check(output).contains('case _\$PointSchema.keyY:');
        check(output).contains('y = keyed.readDouble();');
        check(output).contains('seen |= _\$PointSchema.y;');
        check(output).contains('seen.validate();');
        // Positional constructor call
        check(output).contains('return Point(\n    x!,\n    y!,\n  );');

        // Verify universal encoder
        check(
          output,
        ).contains('void _\$PointToEncoder(Point instance, Encoder encoder)');
        check(output).contains('final keyed = encoder.keyed();');
        check(output).contains(
          'keyed.encodeDoubleKey(_\$PointSchema.staticKeyX, instance.x);',
        );
        check(output).contains(
          'keyed.encodeDoubleKey(_\$PointSchema.staticKeyY, instance.y);',
        );
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
        'static final KeyOptions roleEnumOptions = KeyOptions.of(const [',
      );
      check(output).contains("'admin',");
      check(output).contains("'member',");
      check(output).contains("'guest',");
      // Keyed selectStringIndex for enums
      check(output).contains(
        'final enumIndex = keyed.selectStringIndex(_\$UserAccountSchema.roleKeyOptions);',
      );
      // Tuple decode
      check(output).contains('location = keyed.decodeFloat64List();');
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
      check(output)
          .contains('headquarter = keyed.decodeValue(_\$AddressFromDecoder);');
      // List of nested codable
      check(output)
          .contains('branches = keyed.decodeList(_\$AddressFromDecoder);');
      // Set of string
      check(output).contains('categories = keyed.decodeStringList().toSet();');
      // Map of string to int
      check(output).contains('headcountByDept = keyed.decodeValue((d) {');
      // Nested encoder call
      check(output).contains(
        'keyed.encodeValueKey(_\$EnterpriseSchema.staticKeyHeadquarter, instance.headquarter, _\$AddressToEncoder);',
      );
    });

    test('generates code for custom decoders via UserProfileCustom', () {
      final output = runGeneratorFor('UserProfileCustom');

      check(output)
          .contains('zip = keyed.decodeValue(const ZipCodeDecoder().decode);');
      check(output).contains(
        'keyed.encodeValueKey(_\$UserProfileCustomSchema.staticKeyZip, instance.zip, (v, e) => const ZipCodeDecoder().encodeToEncoder(v, e));',
      );
    });

    test(
      'generates code for enum collections and nullable collections in Team',
      () {
        final output = runGeneratorFor('Team');

        check(output)
            .contains('UserRole.values.byName(d.singleValue().readString())');
        check(output).contains('nullableTags = keyed.decodeList<String?>');
        check(output).contains('scores = keyed.decodeValue((d) {');
        check(output).contains(
          'keyed.encodeListKey(_\$TeamSchema.staticKeyRoles, instance.roles, (item, e) {',
        );
      },
    );

    test(
      'generates specialized list decoders for PrimitiveCollectionsModel',
      () {
        final output = runGeneratorFor('PrimitiveCollectionsModel');

        check(output).contains('ints = keyed.decodeIntList();');
        check(output).contains('doubles = keyed.decodeDoubleList();');
        check(output).contains('strings = keyed.decodeStringList();');
        check(output).contains('bools = keyed.decodeBoolList();');
        check(output).contains('float64s = keyed.decodeFloat64List();');
        check(output).contains('l.add(u.decodeDoubleList());');
        check(output).contains('matrix = l;');
        check(output).contains('l.add(u.decodeFloat64List());');
        check(output).contains('nestedFloats = l;');
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
