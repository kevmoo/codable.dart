// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

@TestOn('vm')
library;

import 'dart:io';

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:checks/checks.dart';
import 'package:codable/codable.dart';
import 'package:codable_builder/src/field_descriptor.dart';
import 'package:codable_builder/src/model_visitor.dart';
import 'package:codable_builder/src/type_helper.dart';
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
      if (decl is ClassDeclaration &&
          decl.declaredFragment?.element.name == className) {
        return decl.declaredFragment?.element;
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
      check(model.createEncoder).isTrue;
      check(model.createDecoder).isTrue;
      check(model.useGoldenMask).isTrue;
      check(model.fieldRename).equals(FieldRename.none);

      check(model.fields.length).equals(2);
      final x = model.fields[0];
      final y = model.fields[1];

      check(x.name).equals('x');
      check(x.wireName).equals('x');
      check(x.isPositional).isTrue;
      check(x.isNamed).isFalse;
      check(x.isRequired).isTrue;
      check(x.participatesInGoldenMask).isTrue;
      check(x.reqBitIndex).equals(0);

      check(y.name).equals('y');
      check(y.wireName).equals('y');
      check(y.isPositional).isTrue;
      check(y.isRequired).isTrue;
      check(y.participatesInGoldenMask).isTrue;
      check(y.reqBitIndex).equals(1);

      check(model.requiredFields.length).equals(2);
      check(model.allOptionsKeys).deepEquals(['x', 'y']);
    });

    test('extracts named parameters, aliases, enums, tuples, and defaults for UserAccount', () {
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
      check(email.isRequired).isTrue;
      check(email.participatesInGoldenMask).isTrue;

      final role = fieldsByName['role']!;
      check(role.category).equals(TypeCategory.enumType);
      check(role.enumConstants)
          .isNotNull()
          .deepEquals(['admin', 'member', 'guest']);

      final tags = fieldsByName['tags']!;
      check(tags.hasDefaultValue).isTrue;
      check(tags.participatesInGoldenMask).isFalse;
      check(tags.reqBitIndex).isNull;

      final location = fieldsByName['location']!;
      check(location.category).equals(TypeCategory.tuple);
      check(location.tupleLength).equals(2);
      check(location.isNullable).isTrue;

      final internalId = fieldsByName['internalId']!;
      check(internalId.ignore).isTrue;
      check(internalId.keyIndex).equals(-1);
    });

    test('validates nested models in Enterprise', () {
      final model = visit('Enterprise');
      check(model.className).equals('Enterprise');

      final headquarter = model.fields.firstWhere(
        (f) => f.name == 'headquarter',
      );
      check(headquarter.category).equals(TypeCategory.nestedCodable);
      check(headquarter.isRequired).isTrue;

      final branches = model.fields.firstWhere((f) => f.name == 'branches');
      check(branches.category).equals(TypeCategory.list);
      check(branches.hasDefaultValue).isTrue;

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
      check(zip.isRequired).isTrue;
      check(zip.participatesInGoldenMask).isTrue;
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

    test('throws InvalidGenerationSourceError when required fields without defaults exceed 62', () {
      check(() => visit('HugeModel63'))
          .throws<InvalidGenerationSourceError>()
          .has('message', (e) => e.message)
          .contains('exceeds the maximum golden mask limit of 62');
    });

    test('extracts codable, customDecoder, and customEncoder on CodableKeyVariantsModel', () {
      final model = visit('CodableKeyVariantsModel');
      final fields = {for (final f in model.fields) f.name: f};

      final zip = fields['zip']!;
      check(zip.category).equals(TypeCategory.custom);
      check(zip.customDecoderCode).equals('const ZipCodeDecoder()');
      check(zip.customEncoderCode).equals('const ZipCodeDecoder()');

      final decodeOnlyZip = fields['decodeOnlyZip']!;
      check(decodeOnlyZip.category).equals(TypeCategory.custom);
      check(decodeOnlyZip.nativeCategory).equals(TypeCategory.primitiveString);
      check(decodeOnlyZip.customDecoderCode).equals('const ZipDecodeOnly()');
      check(decodeOnlyZip.customEncoderCode).isNull;

      final upperCode = fields['upperCode']!;
      check(upperCode.category).equals(TypeCategory.custom);
      check(upperCode.nativeCategory).equals(TypeCategory.primitiveString);
      check(upperCode.customDecoderCode).isNull;
      check(upperCode.customEncoderCode)
          .equals('const UpperCaseStringEncoder()');

      final createdAt = fields['createdAt']!;
      check(createdAt.category).equals(TypeCategory.custom);
      check(createdAt.customDecoderCode)
          .equals('const EpochMsDateTimeDecoder()');
      check(createdAt.customEncoderCode)
          .equals('const EpochMsDateTimeEncoder()');
    });

    test('extracts primitiveNum and num collections on NumericMeasurement without uniform double list', () {
      final model = visit('NumericMeasurement');
      check(model.isUniformDoubleModel).isFalse;
      final score = model.fields.firstWhere((f) => f.name == 'score');
      check(score.category).equals(TypeCategory.primitiveNum);
    });

    test('validates @CodableKey codec assignability at build time', () {
      check(() => visit('InvalidCodableMissingEncoder'))
          .throws<InvalidGenerationSourceError>()
          .has('message', (e) => e.message)
          .contains('must implement Encodable');

      check(() => visit('InvalidCustomDecoderNotDecodable'))
          .throws<InvalidGenerationSourceError>()
          .has('message', (e) => e.message)
          .contains('must implement Decodable');

      check(() => visit('InvalidCustomEncoderNotEncodable'))
          .throws<InvalidGenerationSourceError>()
          .has('message', (e) => e.message)
          .contains('must implement Encodable');

      check(() => visit('InvalidDecodeOnlyNonNativeType'))
          .throws<InvalidGenerationSourceError>()
          .has('message', (e) => e.message)
          .contains('not natively encodable');
    });

    test(
      'rejects unsupported top-level, nested collection, and Map key types',
      () {
        for (final (className, expectedTypeSnippet) in [
          ('InvalidUnknownDateTimeField', 'DateTime'),
          ('InvalidUnknownUriField', 'Uri'),
          ('InvalidUnknownDynamicField', 'dynamic'),
          ('InvalidUnknownObjectField', 'Object?'),
          ('InvalidUnknownRecordField', '(int, String)'),
          ('InvalidNestedListDateTime', 'DateTime'),
          ('InvalidNestedSetUri', 'Uri'),
          ('InvalidNestedMapValueBigInt', 'BigInt'),
          ('InvalidMapKeyDateTime', 'DateTime'),
          ('InvalidMapKeyList', 'List<int>'),
          ('InvalidMapKeyNullable', 'String?'),
        ]) {
          check(() => visit(className))
              .throws<InvalidGenerationSourceError>()
              .has('message', (e) => e.message)
              .contains(expectedTypeSnippet);
        }
      },
    );

    test('extracts @CodableKey(defaultValue:) literals, enums, consts, and precedence', () {
      final model = visit('DefaultValuesModel');
      final fields = {for (final f in model.fields) f.name: f};

      check(fields['label']!.defaultValueCode).equals("'guest'");
      check(fields['escapedNote']!.defaultValueCode)
          .isNotNull()
          .contains(r'\n');
      check(fields['retryCount']!.defaultValueCode).equals('42');
      check(fields['factor']!.defaultValueCode).equals('2.5');
      check(fields['enabled']!.defaultValueCode).equals('true');
      check(fields['role']!.defaultValueCode).equals('UserRole.guest');
      check(fields['role']!.participatesInGoldenMask).isFalse;
      check(fields['tags']!.defaultValueCode).equals("const ['alpha', 'beta']");
      check(fields['metadata']!.defaultValueCode).equals("const {'env': 1}");
      check(fields['origin']!.defaultValueCode)
          .equals('const Point(1.5, -2.5)');
      check(fields['nullableOverride']!.defaultValueCode).equals('null');
      check(fields['omittedDefaultKeepCtor']!.defaultValueCode)
          .equals("'kept_ctor_default'");
      check(fields['weights']!.defaultValueCode).equals('const [1, 2]');
      check(fields['hexDouble']!.defaultValueCode).equals('0x10');
      check(fields['nestedIntRows']!.defaultValueCode)
          .equals('const [<int>[], [1]]');
      check(fields['nestedStringIntMaps']!.defaultValueCode)
          .equals('const [<String, int>{}]');

      check(() => visit('InvalidNullDefaultOnNonNullable'))
          .throws<InvalidGenerationSourceError>()
          .has('message', (e) => e.message)
          .contains('defaultValue: null');

      check(() => visit('InvalidPrivateRevivableDefault'))
          .throws<InvalidGenerationSourceError>()
          .has('message', (e) => e.message)
          .contains('private constant');

      check(() => visit('InvalidNestedPrivateRevivableDefault'))
          .throws<InvalidGenerationSourceError>()
          .has('message', (e) => e.message)
          .contains('private constant');
    });

    test('validates @CodableTuple(N) positive length and numeric list target types', () {
      for (final className in [
        'InvalidZeroLengthTuple',
        'InvalidNegativeLengthTuple',
        'InvalidNonNumericTuple',
        'InvalidScalarTuple',
        'InvalidUint8ListTuple',
      ]) {
        check(() => visit(className)).throws<InvalidGenerationSourceError>();
      }

      check(() => visit('InvalidUint8ListTuple'))
          .throws<InvalidGenerationSourceError>()
          .has('message', (e) => e.message)
          .contains('Uint8List');

      final binaryModel = visit('BinaryPayloadModel');
      final uint8Type = binaryModel.fields
          .firstWhere((f) => f.name == 'payload')
          .type;
      check(const TypeClassifier().classify(uint8Type, tupleLength: 4).category)
          .equals(TypeCategory.list);

      final valid = visit('TupleVariantsModel');
      for (final field in valid.fields) {
        check(field.category).equals(TypeCategory.tuple);
      }
    });

    test('validates alias uniqueness and disambiguates colliding PascalCase suffixes', () {
      for (final className in [
        'InvalidDuplicateAliasInField',
        'InvalidAliasEqualsWireName',
        'InvalidCrossFieldAliasCollision',
        'InvalidCrossFieldAliasToAliasCollision',
      ]) {
        check(() => visit(className)).throws<InvalidGenerationSourceError>();
      }

      final disambiguated = visit('EnumCollectionsAndAliasesModel');
      final slug = disambiguated.fields.firstWhere((f) => f.name == 'slug');
      check(slug.aliasSchemaSuffixes)
          .deepEquals(['SlugFooBar', 'SlugFooBar\$2']);
    });

    test(
      'extracts generic type parameters, bounds, and unbounded nullability',
      () {
        final envelope = visit('Envelope');
        check(envelope.isGeneric).isTrue;
        check(envelope.isPolymorphic).isFalse;
        check(envelope.instantiatedClassName).equals('Envelope<T>');
        check(envelope.typeParamsDeclaration).equals('<T>');
        check(envelope.typeParameters.single.codecFieldName).equals('_\$t');
        check(envelope.typeParameters.single.boundCode).isNull;
        final dataField = envelope.fields.firstWhere((f) => f.name == 'data');
        check(dataField.category).equals(TypeCategory.typeParameter);
        check(dataField.isUnboundedTypeParameter).isTrue;
        check(dataField.participatesInGoldenMask).isTrue;

        final pair = visit('Pair');
        check(pair.typeParamsDeclaration).equals('<A, B extends num>');
        check(pair.instantiatedClassName).equals('Pair<A, B>');
        check(pair.typeParameters.map((p) => p.codecFieldName))
            .deepEquals(['_\$a', '_\$b']);
        final secondField = pair.fields.firstWhere((f) => f.name == 'second');
        check(secondField.isUnboundedTypeParameter).isFalse;

        final bucket = visit('KeyedBucket');
        check(bucket.typeParamsDeclaration).equals('<K extends Object, V>');
      },
    );

    test('extracts sealed, multi-level sealed, generic sealed, and abstract polymorphic descriptors', () {
      final shape = visit('ShapeEvent');
      check(shape.isPolymorphic).isTrue;
      check(shape.isSealed).isTrue;
      check(shape.discriminatorKey).equals('type');
      check(
        shape.polymorphicSubtypes.map(
          (s) => (s.className, s.discriminatorValue),
        ),
      ).deepEquals([('CircleEvent', 'circleEvent'), ('RectEvent', 'rect_box')]);

      final payment = visit('PaymentMethod');
      check(payment.isPolymorphic).isTrue;
      check(payment.isSealed).isTrue;
      check(payment.discriminatorKey).equals('kind');
      check(
        payment.polymorphicSubtypes.map(
          (s) => (s.className, s.discriminatorValue),
        ),
      ).deepEquals([
        ('CreditCardPayment', 'credit_card_payment'),
        ('DebitCardPayment', 'debit_card_payment'),
        ('WireTransferPayment', 'wire_transfer_payment'),
      ]);

      final outcome = visit('ApiOutcome');
      check(outcome.isGeneric).isTrue;
      check(outcome.isPolymorphic).isTrue;
      check(outcome.discriminatorKey).equals('status');
      check(
        outcome.polymorphicSubtypes.map(
          (s) => (s.instantiatedTypeCode, s.discriminatorValue),
        ),
      ).deepEquals([('ApiSuccess<T>', 'ok'), ('ApiFailure', 'error')]);

      final plugin = visit('PluginAction');
      check(plugin.isPolymorphic).isTrue;
      check(plugin.isSealed).isFalse;
      check(plugin.polymorphicSubtypes.map((s) => s.className))
          .deepEquals(['PingAction', 'EchoAction']);

      final tiered = visit('TieredVehicle');
      check(tiered.polymorphicSubtypes.map((s) => s.className))
          .deepEquals(['LuxurySedanVehicle', 'SedanVehicle']);

      final withEnum = visit('SealedWithEnumBranch');
      check(withEnum.isSealed).isFalse;
    });

    test('rejects invalid generic type arguments and invalid polymorphic hierarchies', () {
      for (final (className, expectedSnippet) in [
        ('InvalidGenericNestedUnsupportedType', 'DateTime'),
        ('InvalidUnboundedGenericMapKey', 'Map keys must be non-nullable'),
        ('InvalidSealedMissingSubtypeAnnotation', 'UnannotatedSealedLeaf'),
        (
          'InvalidSealedDuplicateDiscriminator',
          'Duplicate discriminator value',
        ),
        (
          'InvalidSealedDiscriminatorFieldCollision',
          'collides with discriminatorKey',
        ),
        ('InvalidConcreteWithDiscriminator', 'without @Codable(subtypes: ...)'),
        (
          'InvalidUnsealedAbstractWithoutDiscriminator',
          'cannot be instantiated directly',
        ),
        ('InvalidGenericSealedConcreteArg', 'must forward type parameters'),
        ('InvalidGenericSealedExtraParam', 'not bound by polymorphic'),
        ('InvalidTightenedSubtypeBound', 'tightens bound'),
        ('InvalidNestedEncodeOnlyInBidirectional', 'createDecoder: false'),
      ]) {
        check(() => visit(className))
            .throws<InvalidGenerationSourceError>()
            .has('message', (e) => e.message)
            .contains(expectedSnippet);
      }
    });
  });
}
