// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

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
      if (decl is ClassDeclaration &&
          decl.declaredFragment?.element.name == className) {
        return decl.declaredFragment?.element;
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
    return const CodableGenerator().generateForModel(model);
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

        // Verify companion class and universal decoder
        check(output)
            .contains('final class PointCodable implements Codable<Point>');
        check(output).contains('const PointCodable();');
        check(output).contains('Point decode(Decoder decoder)');
        check(output).contains(
          'final keyed = decoder.keyed(options: _\$PointSchema.keyOptions);',
        );
        check(output).contains('while (keyed.moveNextKey())');
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
        check(output).contains('return Point(\n      x!,\n      y!,\n    );');

        // Verify universal encoder with constant length hint
        check(output).contains('void encode(Point instance, Encoder encoder)');
        check(output).contains('final keyed = encoder.keyed(length: 2);');
        check(output)
            .contains('keyed.encodeDouble(_\$PointSchema.nameX, instance.x);');
        check(output)
            .contains('keyed.encodeDouble(_\$PointSchema.nameY, instance.y);');
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
      // Tuple decode & encode
      check(output).contains('location = keyed.decodeFloat64List();');
      check(output).contains('final v\$Location = instance.location;');
      check(output).contains(
        'keyed.encodeDoubleList(_\$UserAccountSchema.nameLocation, v\$Location);',
      );
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
      check(output).contains(
        'headquarter = const AddressCodable().decode(keyed.nestedDecoder());',
      );
      // List of nested codable
      check(output).contains(
        'branches = const AddressCodable().decodeList(keyed.nestedDecoder());',
      );
      // Set of string
      check(output).contains('categories = keyed.decodeStringList().toSet();');
      // Map<String, int> via 1-hop KeyedDecoder + zero-closure KeyedEncoder
      check(output).contains('final k = keyed.nestedDecoder().keyed();');
      check(output).contains('m[key] = k.readInt();');
      check(output).contains(
        'final k = keyed.nestedEncoder(_\$EnterpriseSchema.nameHeadcountByDept).keyed(length: instance.headcountByDept.length);',
      );
      check(output).contains('k.encodeInt(entry.key, entry.value);');
      check(output).not((s) => s.contains('.map('));
      // Nested encoder call
      check(output).contains(
        'keyed.encodeValue(_\$EnterpriseSchema.nameHeadquarter, instance.headquarter, const AddressCodable());',
      );
    });

    test('generates code for custom decoders via UserProfileCustom', () {
      final output = runGeneratorFor('UserProfileCustom');

      check(output)
          .contains('zip = keyed.decodeValue(const ZipCodeDecoder());');
      check(output).contains(
        'keyed.encodeValue(_\$UserProfileCustomSchema.nameZip, instance.zip, const ZipCodeDecoder());',
      );
    });

    test(
      'generates code for enum collections and nullable collections in Team',
      () {
        final output = runGeneratorFor('Team');

        check(output)
            .contains('UserRole.values.byName(d.singleValue().readString())');
        check(output).contains('nullableTags = keyed.decodeList<String?>');
        check(output).contains('final k = keyed.nestedDecoder().keyed();');
        check(output).contains('m[key] = k.readNullableInt();');
        check(output).contains(
          'final k = keyed.nestedEncoder(_\$TeamSchema.nameScores).keyed(length: instance.scores.length);',
        );
        check(output).contains('k.encodeNull(entry.key);');
        check(output).not((s) => s.contains('.map('));
        check(output).contains(
          'keyed.encodeList(_\$TeamSchema.nameRoles, instance.roles, Encodable.fromFunction((UserRole item, e) {',
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

    test('omits isNextNull() for non-nullable fields and retains it for nullable fields', () {
      final pointOutput = runGeneratorFor('Point');
      check(pointOutput).not((s) => s.contains('isNextNull()'));

      final userAccountOutput = runGeneratorFor('UserAccount');
      // UserAccount has 1 nullable field (`location`) and 4 non-nullable fields
      check('isNextNull()'.allMatches(userAccountOutput).length).equals(1);
    });

    test('generates readNum / readNullableNum and int-preserving num collection codecs for NumericMeasurement', () {
      final output = runGeneratorFor('NumericMeasurement');

      check(output).contains('score = keyed.readNum();');
      check(output).contains('optionalScore = keyed.readNum();');
      check(output).contains(
        'samples = keyed.decodeList<num>(Decodable.fromFunction((d) => d.singleValue().readNum()));',
      );
      check(output).contains(
        'nullableSamples = keyed.decodeList<num?>(Decodable.fromFunction((d) => d.singleValue().readNullableNum()));',
      );
      check(output).contains(
        'distinctValues = keyed.decodeList<num>(Decodable.fromFunction((d) => d.singleValue().readNum())).toSet();',
      );
      check(output).contains('m[key] = k.readNum();');
      check(output).contains('m[key] = k.readNullableNum();');
      check(output).not((s) => s.contains('.map('));
      check(output).not((s) => s.contains('decodeUniformDoubleList'));
    });

    test('generates asymmetric and symmetric codec calls for CodableKeyVariantsModel', () {
      final output = runGeneratorFor('CodableKeyVariantsModel');

      check(output)
          .contains('zip = keyed.decodeValue(const ZipCodeDecoder());');
      check(output).contains(
        'keyed.encodeValue(_\$CodableKeyVariantsModelSchema.nameZip, instance.zip, const ZipCodeDecoder());',
      );
      // decode-only falls back to native encodeString
      check(
        output,
      ).contains('decodeOnlyZip = keyed.decodeValue(const ZipDecodeOnly());');
      check(output).contains(
        'keyed.encodeString(_\$CodableKeyVariantsModelSchema.nameDecodeOnlyZip, instance.decodeOnlyZip);',
      );
      // encode-only falls back to native readString
      check(output).contains('upperCode = keyed.readString();');
      check(output).contains(
        'keyed.encodeValue(_\$CodableKeyVariantsModelSchema.nameUpperCode, instance.upperCode, const UpperCaseStringEncoder());',
      );
      // paired customDecoder + customEncoder
      check(output).contains(
        'createdAt = keyed.decodeValue(const EpochMsDateTimeDecoder());',
      );
      check(output).contains(
        'keyed.encodeValue(_\$CodableKeyVariantsModelSchema.nameCreatedAt, instance.createdAt, const EpochMsDateTimeEncoder());',
      );
    });

    test(
      'emits readBytes and encodeBytes for Uint8List fields and collections',
      () {
        final output = runGeneratorFor('BinaryPayloadModel');

        // Nullable field present (`signature`), so pre-count into `count$`
        check(output).contains('var count\$ = 4;');
        check(output).contains('final v\$Signature = instance.signature;');
        check(output).contains('if (v\$Signature != null) count\$++;');
        check(output).contains('final keyed = encoder.keyed(length: count\$);');
        // Top-level Uint8List decode & encode
        check(output).contains('payload = keyed.readBytes();');
        check(output).contains(
          'keyed.encodeBytes(_\$BinaryPayloadModelSchema.namePayload, instance.payload);',
        );
        check(output).contains(
          'keyed.encodeBytes(_\$BinaryPayloadModelSchema.nameSignature, v\$Signature);',
        );
        // List<Uint8List> & List<Uint8List?>
        check(output).contains('l.add(u.readBytes());');
        check(output).contains('e.singleValue().encodeBytes(item);');
        check(output).contains('d.singleValue().readNullableBytes()');
        check(output).contains('e.singleValue().encodeNullableBytes(item);');
        // Map<String, Uint8List> via 1-hop KeyedDecoder / KeyedEncoder
        check(output).contains('final k = keyed.nestedDecoder().keyed();');
        check(output).contains('m[key] = k.readBytes();');
        check(output).contains('k.encodeBytes(entry.key, entry.value);');
        check(output).not((s) => s.contains('.map('));
        check(output).not((s) => s.contains('decodeIntList'));
        check(output).not((s) => s.contains('encodeIntList'));
      },
    );

    test('emits Map<int/UserRole, V> via map() and Map<String, List<int>> via keyed()', () {
      final output = runGeneratorFor('TypedKeyMapModel');

      // Typed const {} defaults (not hardcoded to String)
      check(output).contains('var statusMessages = const <int, String>{};');
      check(output).contains('var roleCounts = const <UserRole, int>{};');
      check(output).contains('var flagWeights = const <bool, double>{};');

      // Constant length hint across 4 non-nullable fields
      check(output).contains('final keyed = encoder.keyed(length: 4);');

      // Zero closures across both decode and encode
      check(output).not((s) => s.contains('fromFunction'));

      // Map<int, String> uses MapDecoder / MapEncoder
      check(output).contains('final mDecoder = keyed.nestedDecoder().map();');
      check(output).contains(
        'final m = keyed.nestedEncoder(_\$TypedKeyMapModelSchema.nameStatusMessages).map(length: instance.statusMessages.length);',
      );
      check(
        output,
      ).contains('final key = mDecoder.keyDecoder().singleValue().readInt();');
      check(output)
          .contains('m.keyEncoder().singleValue().encodeInt(entry.key);');

      // Map<UserRole, int> uses MapDecoder / MapEncoder with schema KeyOptions
      check(output).contains(
        'static final KeyOptions enumUserRoleKeyOptions = KeyOptions.of(const [',
      );
      check(output).contains(
        'final m = keyed.nestedEncoder(_\$TypedKeyMapModelSchema.nameRoleCounts).map(length: instance.roleCounts.length);',
      );
      check(
        output,
      ).contains('_\$TypedKeyMapModelSchema.enumUserRoleKeyOptions.indexOf(');
      check(
        output,
      ).contains('m.keyEncoder().singleValue().encodeString(entry.key.name);');

      // Map<String, List<int>> buckets uses 1-hop KeyedDecoder / KeyedEncoder
      check(output).contains('final k = keyed.nestedDecoder().keyed();');
      check(output).contains('m[key] = k.decodeIntList();');
      check(output).contains(
        'final k = keyed.nestedEncoder(_\$TypedKeyMapModelSchema.nameBuckets).keyed(length: instance.buckets.length);',
      );
      check(output).contains('k.encodeIntList(entry.key, entry.value);');
    });

    test('emits 1-hop KeyedDecoder / KeyedEncoder for enum, nullable @Codable, and nested String maps', () {
      final output = runGeneratorFor('StringKeyedNestedMapModel');

      check(output).not((s) => s.contains('.map('));
      check(output).not((s) => s.contains('fromFunction'));

      // Map<String, UserRole> via selectStringIndex + encodeString
      check(output).contains(
        'final enumIdx1 = k.selectStringIndex(_\$StringKeyedNestedMapModelSchema.enumUserRoleKeyOptions);',
      );
      check(output).contains('k.encodeString(entry.key, entry.value.name);');

      // Map<String, Address?> via isNextNull + nestedDecoder / nestedEncoder
      check(output).contains('if (k.isNextNull()) {');
      check(
        output,
      ).contains('m[key] = const AddressCodable().decode(k.nestedDecoder());');
      check(output).contains(
        'const AddressCodable().encode(val1, k.nestedEncoder(entry.key));',
      );
      check(output).contains('k.encodeNull(entry.key);');

      // Map<String, Map<String, int>> via nested KeyedDecoder / KeyedEncoder
      check(output).contains('final k1 = k.nestedDecoder().keyed();');
      check(output).contains(
        'final k1 = k.nestedEncoder(entry.key).keyed(length: entry.value.length);',
      );
    });

    test(
      'supports @Codable composite map keys and length: 0 on empty models',
      () {
        final compositeOutput = runGeneratorFor('CompositeKeyMapModel');
        check(compositeOutput)
            .contains('var labelsByPoint = const <Point, String>{};');
        check(compositeOutput)
            .contains('final keyed = encoder.keyed(length: 1);');
        check(compositeOutput)
            .contains('final mDecoder = keyed.nestedDecoder().map();');
        check(compositeOutput).contains(
          'final m = keyed.nestedEncoder(_\$CompositeKeyMapModelSchema.nameLabelsByPoint).map(length: instance.labelsByPoint.length);',
        );
        check(compositeOutput).contains(
          'final key = const PointCodable().decode(mDecoder.keyDecoder());',
        );
        check(
          compositeOutput,
        ).contains('const PointCodable().encode(entry.key, m.keyEncoder());');

        final emptyOutput = runGeneratorFor('EmptyRecord');
        check(emptyOutput).contains('encoder.keyed(length: 0);');
        check(emptyOutput).contains('return const EmptyRecord();');

        // UserAccount has 4 fixed fields + nullable `location` (+ 1 ignored)
        final userOutput = runGeneratorFor('UserAccount');
        check(userOutput).contains('var count\$ = 4;');
        check(userOutput).contains('if (v\$Location != null) count\$++;');
        check(userOutput)
            .contains('final keyed = encoder.keyed(length: count\$);');
      },
    );

    test('pre-counts nullable fields with single-read promoted locals and zero ! in encode', () {
      final telemetryOutput = runGeneratorFor('NullableGetterTelemetry');
      final encodeSection = telemetryOutput.substring(
        telemetryOutput.indexOf('void encode('),
      );

      check(encodeSection).contains('var count\$ = 1;');
      check(encodeSection).contains('final v\$Tag = instance.tag;');
      check(encodeSection).contains('if (v\$Tag != null) count\$++;');
      check(encodeSection).contains('final v\$Score = instance.score;');
      check(encodeSection).contains('if (v\$Score != null) count\$++;');
      check(encodeSection).contains('final v\$Location = instance.location;');
      check(encodeSection).contains('if (v\$Location != null) count\$++;');
      check(encodeSection)
          .contains('final keyed = encoder.keyed(length: count\$);');
      check(encodeSection).not((s) => s.contains('encoder.keyed()'));

      // Each nullable getter is read from `instance.` exactly once in encode
      check('instance.tag'.allMatches(encodeSection).length).equals(1);
      check('instance.score'.allMatches(encodeSection).length).equals(1);
      check('instance.location'.allMatches(encodeSection).length).equals(1);
      // Promoted locals eliminate `!` null-assertions inside encode
      check(encodeSection).not((s) => s.contains('!;'));
      check(encodeSection).not((s) => s.contains('!,'));
      check(encodeSection).not((s) => s.contains('!)'));

      // All-nullable model starts fixedNonNullCount at 0
      final allNullOutput = runGeneratorFor('AllNullableModel');
      final allNullEncode = allNullOutput.substring(
        allNullOutput.indexOf('void encode('),
      );
      check(allNullEncode).contains('var count\$ = 0;');
      check(allNullEncode)
          .contains('final keyed = encoder.keyed(length: count\$);');
    });
  });
}
