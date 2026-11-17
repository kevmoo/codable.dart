// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:codable/codable.dart';
import 'package:source_gen/source_gen.dart';
import 'package:source_helper/source_helper.dart';

import 'codec_expression_helper.dart';
import 'field_descriptor.dart';
import 'type_helper.dart';
import 'utils.dart';

/// Discovers and validates polymorphic `@Codable` hierarchies (such as `sealed`
/// or `abstract` base classes with `@Codable(discriminatorKey: ...)`).
final class PolymorphicModelVisitor {
  const PolymorphicModelVisitor();

  /// Whether [element] with [annotation] should be synthesized as a polymorphic
  /// discriminator base model.
  bool isPolymorphicClass(ClassElement element, ConstantReader annotation) {
    if (element.isSealed) return true;
    final hasKey = annotation.peek('discriminatorKey')?.isNull == false;
    final hasSubtypes = annotation.peek('subtypes')?.isNull == false;
    return hasKey || hasSubtypes;
  }

  /// Builds a validated polymorphic [ModelDescriptor] for [element].
  ModelDescriptor visitPolymorphicClass({
    required ClassElement element,
    required ConstantReader annotation,
    required bool createEncoder,
    required bool createDecoder,
    required bool useGoldenMask,
    required FieldRename fieldRename,
    required List<TypeParameterDescriptor> typeParameters,
    required List<({String name, String wireName, List<String> aliases})>
    Function(ClassElement subElement, FieldRename subRename)
    inspectSubtypeKeys,
  }) {
    final discriminatorKey =
        annotation.peek('discriminatorKey')?.stringValue ?? 'type';
    final explicitSubtypes = _extractExplicitSubtypes(element, annotation);
    final rawSubtypes =
        explicitSubtypes ?? _discoverLibrarySubtypes(element, discriminatorKey);

    if (rawSubtypes.isEmpty) {
      throw InvalidGenerationSourceError(
        'Polymorphic @Codable class "${element.name}" has no concrete '
        '@Codable() subtypes.',
        element: element,
      );
    }

    final isExhaustivelySealed =
        explicitSubtypes == null && _isExhaustivelySealedHierarchy(element);
    final subtypes = _buildSubtypeDescriptors(
      baseElement: element,
      rawSubtypes: rawSubtypes,
      discriminatorKey: discriminatorKey,
      fieldRename: fieldRename,
      createDecoder: createDecoder,
      createEncoder: createEncoder,
      inspectSubtypeKeys: inspectSubtypeKeys,
    );

    return ModelDescriptor(
      element: element,
      className: element.name ?? '',
      createEncoder: createEncoder,
      createDecoder: createDecoder,
      useGoldenMask: useGoldenMask,
      fieldRename: fieldRename,
      fields: const [],
      requiredFields: const [],
      allOptionsKeys: [discriminatorKey],
      typeParameters: typeParameters,
      discriminatorKey: discriminatorKey,
      polymorphicSubtypes: subtypes,
      isSealed: isExhaustivelySealed,
    );
  }

  static List<ClassElement>? _extractExplicitSubtypes(
    ClassElement baseElement,
    ConstantReader annotation,
  ) {
    final reader = annotation.peek('subtypes');
    if (reader == null || reader.isNull) return null;
    final result = <ClassElement>[];
    final seen = <ClassElement>{};
    for (final obj in reader.listValue) {
      final type = obj.toTypeValue();
      final subEl = type?.element;
      if (subEl is! ClassElement || subEl.isAbstract || subEl.isSealed) {
        throw InvalidGenerationSourceError(
          'Entry "$type" in @Codable(subtypes: ...) on "${baseElement.name}" '
          'must be a concrete class.',
          element: baseElement,
        );
      }
      if (seen.add(subEl)) result.add(subEl);
    }
    return result;
  }

  static List<ClassElement> _discoverLibrarySubtypes(
    ClassElement baseElement,
    String discriminatorKey,
  ) {
    if (!baseElement.isSealed && !baseElement.isAbstract) {
      throw InvalidGenerationSourceError(
        'Concrete class "${baseElement.name}" specifies '
        'discriminatorKey "$discriminatorKey" without @Codable(subtypes: ...). '
        'Mark "${baseElement.name}" sealed/abstract or remove discriminatorKey.',
        element: baseElement,
      );
    }
    final candidates = <ClassElement>[];
    for (final cls in baseElement.library.classes) {
      if (cls == baseElement || cls.isAbstract || cls.isSealed) continue;
      if (cls.thisType.asInstanceOf(baseElement) == null) continue;
      if (baseElement.isSealed || codableTypeChecker.hasAnnotationOf(cls)) {
        candidates.add(cls);
      }
    }
    candidates.sort(_compareClassOrder);
    return candidates;
  }

  static int _compareClassOrder(ClassElement a, ClassElement b) {
    final offsetA = a.firstFragment.nameOffset ?? 0;
    final offsetB = b.firstFragment.nameOffset ?? 0;
    if (offsetA != offsetB) return offsetA.compareTo(offsetB);
    return (a.name ?? '').compareTo(b.name ?? '');
  }

  static bool _isExhaustivelySealedHierarchy(ClassElement baseElement) {
    if (!baseElement.isSealed) return false;
    for (final cls in baseElement.library.classes) {
      if (cls == baseElement) continue;
      if (cls.thisType.asInstanceOf(baseElement) == null) continue;
      if (cls.isAbstract && !cls.isSealed) return false;
    }
    return true;
  }

  static List<PolymorphicSubtypeDescriptor> _buildSubtypeDescriptors({
    required ClassElement baseElement,
    required List<ClassElement> rawSubtypes,
    required String discriminatorKey,
    required FieldRename fieldRename,
    required bool createDecoder,
    required bool createEncoder,
    required List<({String name, String wireName, List<String> aliases})>
    Function(ClassElement subElement, FieldRename subRename)
    inspectSubtypeKeys,
  }) {
    final ownerByDiscVal = <String, String>{};
    final usedSuffixes = <String>{};
    final descriptors = <PolymorphicSubtypeDescriptor>[];

    for (final sub in rawSubtypes) {
      final subMeta = _validateAndReadSubtypeAnnotation(
        baseElement: baseElement,
        sub: sub,
        createDecoder: createDecoder,
        createEncoder: createEncoder,
      );
      final subName = sub.name ?? '';
      final discVal =
          subMeta.discriminatorValue ??
          defaultDiscriminatorValue(subName, fieldRename);
      final existing = ownerByDiscVal[discVal];
      if (existing != null) {
        throw InvalidGenerationSourceError(
          'Duplicate discriminator value "$discVal" on subtype "$subName" '
          '(already used by "$existing") for "${baseElement.name}".',
          element: sub,
        );
      }
      ownerByDiscVal[discVal] = subName;

      _validateNoDiscriminatorFieldCollision(
        baseElement: baseElement,
        sub: sub,
        discriminatorKey: discriminatorKey,
        keys: inspectSubtypeKeys(sub, subMeta.fieldRename),
      );

      final mappedTypeArgs = _resolveSubtypeTypeArguments(baseElement, sub);
      final suffix = _allocateUniqueSuffix(
        toSafeIdentifierSuffix(subName),
        usedSuffixes,
      );
      descriptors.add(
        PolymorphicSubtypeDescriptor(
          element: sub,
          className: subName,
          discriminatorValue: discVal,
          schemaSuffix: suffix,
          typeArguments: mappedTypeArgs,
          subtypeCreatesDecoder: subMeta.createsDecoder,
          subtypeCreatesEncoder: subMeta.createsEncoder,
        ),
      );
    }
    return descriptors;
  }

  static ({
    String? discriminatorValue,
    FieldRename fieldRename,
    bool createsDecoder,
    bool createsEncoder,
  })
  _validateAndReadSubtypeAnnotation({
    required ClassElement baseElement,
    required ClassElement sub,
    required bool createDecoder,
    required bool createEncoder,
  }) {
    if (sub.thisType.asInstanceOf(baseElement) == null) {
      throw InvalidGenerationSourceError(
        'Class "${sub.name}" in @Codable(subtypes: ...) does not extend or '
        'implement "${baseElement.name}".',
        element: baseElement,
      );
    }
    final annotation = codableTypeChecker.firstAnnotationOf(sub);
    if (annotation == null) {
      throw InvalidGenerationSourceError(
        'Concrete subtype "${sub.name}" of polymorphic @Codable class '
        '"${baseElement.name}" must also be annotated with @Codable().',
        element: sub,
      );
    }
    final reader = ConstantReader(annotation);
    final subDec = reader.peek('createDecoder')?.boolValue ?? true;
    final subEnc = reader.peek('createEncoder')?.boolValue ?? true;
    if (createDecoder && !subDec) {
      throw InvalidGenerationSourceError(
        'Subtype "${sub.name}" sets createDecoder: false, but polymorphic '
        'base "${baseElement.name}" requires decoding.',
        element: sub,
      );
    }
    if (createEncoder && !subEnc) {
      throw InvalidGenerationSourceError(
        'Subtype "${sub.name}" sets createEncoder: false, but polymorphic '
        'base "${baseElement.name}" requires encoding.',
        element: sub,
      );
    }
    final renameIdx = reader.peek('fieldRename')?.peek('index')?.intValue;
    final subRename =
        renameIdx != null &&
            renameIdx >= 0 &&
            renameIdx < FieldRename.values.length
        ? FieldRename.values[renameIdx]
        : FieldRename.none;
    return (
      discriminatorValue: reader.peek('discriminatorValue')?.stringValue,
      fieldRename: subRename,
      createsDecoder: subDec,
      createsEncoder: subEnc,
    );
  }

  static void _validateNoDiscriminatorFieldCollision({
    required ClassElement baseElement,
    required ClassElement sub,
    required String discriminatorKey,
    required List<({String name, String wireName, List<String> aliases})> keys,
  }) {
    for (final field in keys) {
      if (field.wireName == discriminatorKey ||
          field.aliases.contains(discriminatorKey)) {
        throw InvalidGenerationSourceError(
          'Parameter "${field.name}" on subtype "${sub.name}" uses wire key '
          '"$discriminatorKey", which collides with discriminatorKey '
          '"$discriminatorKey" on polymorphic base "${baseElement.name}". '
          'Remove the redundant discriminator parameter or mark it '
          '@CodableKey(ignore: true).',
          element: sub,
        );
      }
    }
  }

  static List<DartType> _resolveSubtypeTypeArguments(
    ClassElement baseElement,
    ClassElement sub,
  ) {
    if (baseElement.typeParameters.isEmpty) {
      if (sub.typeParameters.isNotEmpty) {
        throw InvalidGenerationSourceError(
          'Generic subtype "${sub.name}" cannot participate in non-generic '
          'polymorphic @Codable base "${baseElement.name}".',
          element: sub,
        );
      }
      return const [];
    }

    final asBase = sub.thisType.asInstanceOf(baseElement)!;
    final subToBase = <Element, DartType>{};
    for (var i = 0; i < baseElement.typeParameters.length; i++) {
      final arg = asBase.typeArguments[i];
      if (arg is NeverType) continue;
      if (arg is! TypeParameterType ||
          arg.nullabilitySuffix != NullabilitySuffix.none) {
        throw InvalidGenerationSourceError(
          'Subtype "${sub.name}" must forward type parameters directly or '
          'pass Never when extending generic @Codable base '
          '"${baseElement.name}" (got "${asBase.getDisplayString()}").',
          element: sub,
        );
      }
      final baseParamType = baseElement.typeParameters[i].instantiate(
        nullabilitySuffix: NullabilitySuffix.none,
      );
      final key = arg.element.baseElement;
      final existing = subToBase[key];
      if (existing != null && existing != baseParamType) {
        throw InvalidGenerationSourceError(
          'Subtype "${sub.name}" binds type parameter "${arg.element.name}" '
          'to multiple distinct type parameters on "${baseElement.name}".',
          element: sub,
        );
      }
      subToBase[key] = baseParamType;
    }

    final resolved = <DartType>[];
    for (final sp in sub.typeParameters) {
      final mapped = subToBase[sp.baseElement];
      if (mapped == null) {
        throw InvalidGenerationSourceError(
          'Type parameter "${sp.name}" on subtype "${sub.name}" is not bound '
          'by polymorphic @Codable base "${baseElement.name}".',
          element: sub,
        );
      }
      resolved.add(mapped);
    }
    return resolved;
  }

  static String _allocateUniqueSuffix(String base, Set<String> used) {
    if (used.add(base)) return base;
    var index = 2;
    while (!used.add('$base\$$index')) {
      index++;
    }
    return '$base\$$index';
  }
}

/// Emits the schema descriptor and polymorphic `decode` / `encodedFieldCount` /
/// `encodeFields` / `encode` methods for a polymorphic [ModelDescriptor].
final class PolymorphicGeneratorHelper {
  final ModelDescriptor model;
  final CodecExpressionHelper _codecHelper;

  PolymorphicGeneratorHelper(
    this.model, {
    required InlineValueDecodeBuilder decodeBuilder,
    required InlineValueEncodeBuilder encodeBuilder,
  }) : _codecHelper = CodecExpressionHelper(
         model,
         decodeBuilder: decodeBuilder,
         encodeBuilder: encodeBuilder,
       );

  /// Generates `extension type const _$<Base>Schema(int _value)`.
  String generateSchema() {
    final schemaName = '_\$${model.className}Schema';
    final buffer = StringBuffer()
      ..writeln(
        '// =============================================================================',
      )
      ..writeln('// 1. Polymorphic Schema Descriptor for ${model.className}')
      ..writeln(
        '// =============================================================================',
      )
      ..writeln('extension type const $schemaName(int _value) {')
      ..writeln(
        '  static const String discriminatorKey = '
        '${escapeDartString(model.discriminatorKey!)};',
      );
    for (final sub in model.polymorphicSubtypes) {
      buffer.writeln(
        '  static const String subtype${sub.schemaSuffix} = '
        '${escapeDartString(sub.discriminatorValue)};',
      );
    }
    buffer.writeln('}');
    return buffer.toString();
  }

  /// Generates the `decode` method for the polymorphic companion class.
  String generateDecodeMethod() {
    if (!model.createDecoder) return '';
    final schemaName = '_\$${model.className}Schema';
    final targetType = model.instantiatedClassName;
    final out = StringBuffer()
      ..writeln('  @override')
      ..writeln('  $targetType decode(Decoder decoder) {')
      ..writeln('    final mapped = decoder.mapped();')
      ..writeln('    if (!mapped.containsKey($schemaName.discriminatorKey) ||')
      ..writeln('        mapped.isNull($schemaName.discriminatorKey)) {')
      ..writeln(
        '      throw CodableException.missingKey($schemaName.discriminatorKey);',
      )
      ..writeln('    }')
      ..writeln(
        '    final discriminator = '
        'mapped.readString($schemaName.discriminatorKey);',
      )
      ..writeln('    return switch (discriminator) {');
    for (final sub in model.polymorphicSubtypes) {
      final codec = _codecHelper
          .buildClassCodecExpr(
            sub.element,
            sub.typeArguments,
            CodecMode.decodable,
          )
          .code;
      out.writeln(
        '      $schemaName.subtype${sub.schemaSuffix} => '
        '$codec.decode(decoder),',
      );
    }
    out
      ..writeln('      _ => throw CodableException.unknownSubtype(')
      ..writeln('        discriminatorKey: $schemaName.discriminatorKey,')
      ..writeln('        subtypeValue: discriminator,')
      ..writeln('      ),')
      ..writeln('    };')
      ..writeln('  }');
    return out.toString();
  }

  /// Generates `encodedFieldCount`, `encodeFields`, and `encode` for the
  /// polymorphic companion class.
  String generateEncodeMethods() {
    if (!model.createEncoder) return '';
    final out = StringBuffer()
      ..write(_generateEncodedFieldCount())
      ..writeln()
      ..write(_generateEncodeFields())
      ..writeln()
      ..write(_generateEncode());
    return out.toString();
  }

  String _generateEncodedFieldCount() {
    final targetType = model.instantiatedClassName;
    final out = StringBuffer()
      ..writeln('  @override')
      ..writeln('  int encodedFieldCount($targetType instance) =>')
      ..writeln('      switch (instance) {');
    for (final sub in model.polymorphicSubtypes) {
      final codec = _subtypeEncodableCode(sub);
      out.writeln(
        '        final ${sub.instantiatedTypeCode} sub => '
        '1 + $codec.encodedFieldCount(sub),',
      );
    }
    if (!model.isSealed) {
      out.writeln('        _ => ${_unregisteredSubtypeThrowExpr()},');
    }
    out.writeln('      };');
    return out.toString();
  }

  String _generateEncodeFields() {
    final schemaName = '_\$${model.className}Schema';
    final targetType = model.instantiatedClassName;
    final out = StringBuffer()
      ..writeln('  @override')
      ..writeln(
        '  void encodeFields($targetType instance, KeyedEncoder keyed) {',
      )
      ..writeln('    switch (instance) {');
    for (final sub in model.polymorphicSubtypes) {
      final codec = _subtypeEncodableCode(sub);
      out
        ..writeln('      case final ${sub.instantiatedTypeCode} sub:')
        ..writeln(
          '        keyed.encodeString('
          '$schemaName.discriminatorKey, '
          '$schemaName.subtype${sub.schemaSuffix});',
        )
        ..writeln('        $codec.encodeFields(sub, keyed);');
    }
    if (!model.isSealed) {
      out
        ..writeln('      default:')
        ..writeln('        ${_unregisteredSubtypeThrowExpr()};');
    }
    out
      ..writeln('    }')
      ..writeln('  }');
    return out.toString();
  }

  String _generateEncode() {
    final schemaName = '_\$${model.className}Schema';
    final targetType = model.instantiatedClassName;
    final out = StringBuffer()
      ..writeln('  @override')
      ..writeln('  void encode($targetType instance, Encoder encoder) {')
      ..writeln('    switch (instance) {');
    for (final sub in model.polymorphicSubtypes) {
      final codec = _subtypeEncodableCode(sub);
      out
        ..writeln('      case final ${sub.instantiatedTypeCode} sub:')
        ..writeln('        final subCodec = $codec;')
        ..writeln(
          '        final keyed = encoder.keyed('
          'length: 1 + subCodec.encodedFieldCount(sub));',
        )
        ..writeln(
          '        keyed.encodeString('
          '$schemaName.discriminatorKey, '
          '$schemaName.subtype${sub.schemaSuffix});',
        )
        ..writeln('        subCodec.encodeFields(sub, keyed);');
    }
    if (!model.isSealed) {
      out
        ..writeln('      default:')
        ..writeln('        ${_unregisteredSubtypeThrowExpr()};');
    }
    out
      ..writeln('    }')
      ..writeln('  }');
    return out.toString();
  }

  String _subtypeEncodableCode(PolymorphicSubtypeDescriptor sub) => _codecHelper
      .buildClassCodecExpr(sub.element, sub.typeArguments, CodecMode.encodable)
      .code;

  String _unregisteredSubtypeThrowExpr() {
    final discEscaped = escapeDartString(model.discriminatorKey!);
    final discBody = discEscaped.substring(1, discEscaped.length - 1);
    return "throw CodableException('No registered subtype for "
        '\${instance.runtimeType} on discriminator "$discBody"\', '
        'actualValue: instance)';
  }
}
