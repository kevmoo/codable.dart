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
import 'package:codable/codable.dart';
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

  ModelDescriptor visit(String className) {
    final element = findClass(className);
    if (element == null) throw StateError('Class $className not found');
    final annotation = codableTypeChecker.firstAnnotationOf(element);
    if (annotation == null) {
      throw StateError('No @Codable annotation on $className');
    }
    return const ModelVisitor().visitClass(element, ConstantReader(annotation));
  }

  group('ModelVisitor Unit Tests', () {
    test('extracts positional parameters correctly for Point', () {
      final model = visit('Point');
      check(model.className).equals('Point');
      check(model.createEncoder).isTrue();
      check(model.createDecoder).isTrue();
      check(model.useGoldenMask).isTrue();
      check(model.fieldRename).equals(FieldRename.none);

      check(model.fields.length).equals(2);
      final x = model.fields[0];
      final y = model.fields[1];

      check(x.name).equals('x');
      check(x.wireName).equals('x');
      check(x.isPositional).isTrue();
      check(x.isNamed).isFalse();
      check(x.isRequired).isTrue();
      check(x.participatesInGoldenMask).isTrue();
      check(x.reqBitIndex).equals(0);

      check(y.name).equals('y');
      check(y.wireName).equals('y');
      check(y.isPositional).isTrue();
      check(y.isRequired).isTrue();
      check(y.participatesInGoldenMask).isTrue();
      check(y.reqBitIndex).equals(1);

      check(model.requiredFields.length).equals(2);
      check(model.allOptionsKeys).deepEquals(['x', 'y']);
    });

    test(
      'extracts named parameters, aliases, enums, tuples, and defaults for UserAccount',
      () {
        final model = visit('UserAccount');
        check(model.className).equals('UserAccount');
        check(model.fieldRename).equals(FieldRename.snake);

        final fieldsByName = {for (final f in model.fields) f.name: f};
        check(fieldsByName.keys).contains('id');
        check(fieldsByName.keys).contains('emailAddress');
        check(fieldsByName.keys).contains('role');
        check(fieldsByName.keys).contains('tags');
        check(fieldsByName.keys).contains('location');
        check(fieldsByName.keys).contains('internalId');

        final email = fieldsByName['emailAddress']!;
        check(email.wireName).equals('email_address');
        check(email.aliases).deepEquals(['email', 'contact_email']);
        check(email.isRequired).isTrue();
        check(email.participatesInGoldenMask).isTrue();

        final role = fieldsByName['role']!;
        check(role.category).equals(TypeCategory.enumType);
        check(
          role.enumConstants,
        ).isNotNull().deepEquals(['admin', 'member', 'guest']);

        final tags = fieldsByName['tags']!;
        check(tags.hasDefaultValue).isTrue();
        check(tags.participatesInGoldenMask).isFalse();
        check(tags.reqBitIndex).isNull();

        final location = fieldsByName['location']!;
        check(location.category).equals(TypeCategory.tuple);
        check(location.tupleLength).equals(2);
        check(location.isNullable).isTrue();

        final internalId = fieldsByName['internalId']!;
        check(internalId.ignore).isTrue();
        check(internalId.keyIndex).equals(-1);
      },
    );

    test('validates nested models in Enterprise', () {
      final model = visit('Enterprise');
      check(model.className).equals('Enterprise');

      final headquarter = model.fields.firstWhere(
        (f) => f.name == 'headquarter',
      );
      check(headquarter.category).equals(TypeCategory.nestedCodable);
      check(headquarter.isRequired).isTrue();

      final branches = model.fields.firstWhere((f) => f.name == 'branches');
      check(branches.category).equals(TypeCategory.list);
      check(branches.hasDefaultValue).isTrue();

      final categories = model.fields.firstWhere((f) => f.name == 'categories');
      check(categories.category).equals(TypeCategory.set);

      final headcount = model.fields.firstWhere(
        (f) => f.name == 'headcountByDept',
      );
      check(headcount.category).equals(TypeCategory.map);
    });

    test('extracts custom decoder for UserProfileCustom', () {
      final model = visit('UserProfileCustom');
      check(model.className).equals('UserProfileCustom');

      final zip = model.fields.firstWhere((f) => f.name == 'zip');
      check(zip.category).equals(TypeCategory.custom);
      check(zip.customDecoderCode).equals('const ZipCodeDecoder()');
      check(zip.isRequired).isTrue();
      check(zip.participatesInGoldenMask).isTrue();
    });

    test('extracts collections and enum lists for Team', () {
      final model = visit('Team');
      check(model.className).equals('Team');

      final roles = model.fields.firstWhere((f) => f.name == 'roles');
      check(roles.category).equals(TypeCategory.list);
      check(roles.elementType?.element?.name).equals('UserRole');

      final nullableTags = model.fields.firstWhere(
        (f) => f.name == 'nullableTags',
      );
      check(nullableTags.category).equals(TypeCategory.set);

      final scores = model.fields.firstWhere((f) => f.name == 'scores');
      check(scores.category).equals(TypeCategory.map);
    });

    test(
      'throws InvalidGenerationSourceError when required fields without defaults exceed 62',
      () {
        check(() => visit('HugeModel63'))
            .throws<InvalidGenerationSourceError>()
            .has((e) => e.message, 'message')
            .contains('exceeds the maximum golden mask limit of 62');
      },
    );
  });
}
