// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:source_gen/source_gen.dart';

import 'field_descriptor.dart';
import 'type_helper.dart';

/// Target interface required for a synthesized codec expression.
enum CodecMode {
  codable,
  decodable,
  encodable;

  /// Returns the parameterized contract type name for [valueTypeCode].
  String typeFor(String valueTypeCode) => switch (this) {
    CodecMode.codable => 'Codable<$valueTypeCode>',
    CodecMode.decodable => 'Decodable<$valueTypeCode>',
    CodecMode.encodable => 'Encodable<$valueTypeCode>',
  };
}

/// Synthesized Dart expression for a runtime codec (`Codable`, `Decodable`, or
/// `Encodable`), tracking `const` eligibility and enclosing type-parameter use.
final class CodecExpr {
  /// Constructor or expression body without a leading `const ` keyword when
  /// [isConst] is `true` (e.g. `'AddressCodable()'`), or a complete runtime
  /// expression when [isConst] is `false` (e.g. `'_\$t'`).
  final String body;

  /// Declared Dart type for hoisting closed non-`const` expressions to static
  /// schema fields.
  final String staticTypeCode;

  /// Whether `const $body` is a valid compile-time constant expression.
  final bool isConst;

  /// Whether [body] references enclosing companion codec fields (`_\$t`).
  final bool usesTypeParams;

  /// Whether this codec implements bidirectional `Codable<...>`.
  final bool isBidirectional;

  const CodecExpr({
    required this.body,
    required this.staticTypeCode,
    required this.isConst,
    this.usesTypeParams = false,
    this.isBidirectional = false,
  });

  /// Complete standalone Dart expression (prefixed with `const ` if [isConst]).
  String get code => isConst ? 'const $body' : body;
}

/// Callback that renders inline statements decoding from `decoderExpr` into
/// a declared variable `targetVar` of `type`.
typedef InlineValueDecodeBuilder = String Function(
  DartType type, {
  required String targetVar,
  required String decoderExpr,
  required String indent,
});

/// Callback that renders inline statements encoding `valueExpr` of `type` into
/// `encoderExpr`.
typedef InlineValueEncodeBuilder = String Function(
  DartType type, {
  required String valueExpr,
  required String encoderExpr,
  required String indent,
});

/// Synthesizes `Codable`, `Decodable`, and `Encodable` expressions for nested
/// `@Codable` classes, generic type parameters, and composite type arguments.
final class CodecExpressionHelper {
  final ModelDescriptor model;
  final InlineValueDecodeBuilder? decodeBuilder;
  final InlineValueEncodeBuilder? encodeBuilder;

  const CodecExpressionHelper(
    this.model, {
    this.decodeBuilder,
    this.encodeBuilder,
  });

  /// Returns a Dart expression implementing [mode] for [type], hoisting closed
  /// non-`const` codecs onto `_$<Model>Schema`.
  String forType(DartType type, CodecMode mode) {
    final expr = buildExpr(type, mode);
    if (expr.isConst || expr.usesTypeParams || model.isPolymorphic) {
      return expr.code;
    }
    return model.registerClosedCodec(
      typeCode: expr.staticTypeCode,
      exprCode: expr.code,
    );
  }

  /// Returns a [CodecExpr] implementing [mode] for [type].
  CodecExpr buildExpr(DartType type, CodecMode mode) {
    if (type.nullabilitySuffix == NullabilitySuffix.question) {
      return _buildNullableExpr(type, mode);
    }
    if (type is TypeParameterType) {
      return _buildTypeParamExpr(type, mode);
    }
    final element = type.element;
    if (element is ClassElement &&
        const TypeClassifier().isCodableElement(element)) {
      final typeArgs = type is InterfaceType
          ? type.typeArguments
          : const <DartType>[];
      return buildClassCodecExpr(element, typeArgs, mode);
    }
    if (type.isDartCoreList &&
        mode != CodecMode.encodable &&
        type is InterfaceType &&
        type.typeArguments.length == 1) {
      final directElem = _tryDirectCodecExpr(type.typeArguments.first, mode);
      if (directElem != null) {
        final listTypeStr = type.getDisplayString();
        final effectiveMode = directElem.isBidirectional
            ? CodecMode.codable
            : mode;
        return CodecExpr(
          body: '${directElem.code}.list',
          staticTypeCode: effectiveMode.typeFor(listTypeStr),
          isConst: false,
          usesTypeParams: directElem.usesTypeParams,
          isBidirectional: directElem.isBidirectional,
        );
      }
    }
    return _buildClosureCodecExpr(type, mode);
  }

  /// Builds a codec expression for [targetClass] applied to [typeArguments].
  CodecExpr buildClassCodecExpr(
    ClassElement targetClass,
    List<DartType> typeArguments,
    CodecMode requiredMode,
  ) {
    final (createsDec, createsEnc) = readCodableFlags(targetClass);
    final companionName = '${targetClass.name}Codable';
    final isBidir = createsDec && createsEnc;
    if (typeArguments.isEmpty) {
      return _adaptIfNeeded(
        CodecExpr(
          body: '$companionName()',
          staticTypeCode: companionName,
          isConst: true,
          isBidirectional: isBidir,
        ),
        targetClass.thisType,
        availableDec: createsDec,
        availableEnc: createsEnc,
        requiredMode: requiredMode,
        errorElement: targetClass,
      );
    }

    final argMode = _modeForFlags(createsDec, createsEnc);
    final argExprs = [for (final arg in typeArguments) buildExpr(arg, argMode)];
    final allConst = argExprs.every((e) => e.isConst);
    final anyTypeParams = argExprs.any((e) => e.usesTypeParams);
    final typeArgsCode =
        '<${typeArguments.map((t) => t.getDisplayString()).join(', ')}>';
    final renderedArgs = argExprs
        .map((e) => allConst ? e.body : e.code)
        .join(', ');
    final instantiatedType = targetClass.instantiate(
      typeArguments: typeArguments,
      nullabilitySuffix: NullabilitySuffix.none,
    );
    final companionType = '$companionName$typeArgsCode';
    return _adaptIfNeeded(
      CodecExpr(
        body: '$companionType($renderedArgs)',
        staticTypeCode: companionType,
        isConst: allConst,
        usesTypeParams: anyTypeParams,
        isBidirectional: isBidir,
      ),
      instantiatedType,
      availableDec: createsDec,
      availableEnc: createsEnc,
      requiredMode: requiredMode,
      errorElement: targetClass,
    );
  }

  CodecExpr? _tryDirectCodecExpr(DartType type, CodecMode mode) {
    if (type.nullabilitySuffix == NullabilitySuffix.question) {
      final nonNull = model.element.library.typeSystem.promoteToNonNull(type);
      final inner = _tryDirectCodecExpr(nonNull, mode);
      if (inner == null) return null;
      final effectiveMode = inner.isBidirectional ? CodecMode.codable : mode;
      return CodecExpr(
        body: '${inner.code}.nullable',
        staticTypeCode: effectiveMode.typeFor(type.getDisplayString()),
        isConst: false,
        usesTypeParams: inner.usesTypeParams,
        isBidirectional: inner.isBidirectional,
      );
    }
    if (type is TypeParameterType) {
      return _buildTypeParamExpr(type, mode);
    }
    final element = type.element;
    if (element is ClassElement &&
        const TypeClassifier().isCodableElement(element)) {
      return buildExpr(type, mode);
    }
    return null;
  }

  CodecExpr _buildNullableExpr(DartType type, CodecMode mode) {
    final direct = _tryDirectCodecExpr(type, mode);
    if (direct != null) return direct;
    return _buildClosureCodecExpr(type, mode);
  }

  CodecExpr _buildTypeParamExpr(TypeParameterType type, CodecMode mode) {
    final field = model.codecFieldFor(type.element);
    if (field == null) {
      throw StateError(
        'Unbound type parameter "${type.getDisplayString()}" on '
        '"${model.className}".',
      );
    }
    final isBidir = model.createDecoder && model.createEncoder;
    final companionMode = _modeForFlags(
      model.createDecoder,
      model.createEncoder,
    );
    return _adaptIfNeeded(
      CodecExpr(
        body: field,
        staticTypeCode: companionMode.typeFor(type.getDisplayString()),
        isConst: false,
        usesTypeParams: true,
        isBidirectional: isBidir,
      ),
      type,
      availableDec: model.createDecoder,
      availableEnc: model.createEncoder,
      requiredMode: mode,
      errorElement: model.element,
    );
  }

  static CodecExpr _adaptIfNeeded(
    CodecExpr expr,
    DartType type, {
    required bool availableDec,
    required bool availableEnc,
    required CodecMode requiredMode,
    required Element errorElement,
  }) {
    final typeStr = type.getDisplayString();
    if (!availableDec && !availableEnc) {
      throw InvalidGenerationSourceError(
        'Class "$typeStr" disables both createDecoder and createEncoder and '
        'has no generated *Codable companion.',
        element: errorElement,
      );
    }
    if (requiredMode == CodecMode.decodable && !availableDec) {
      throw InvalidGenerationSourceError(
        'Type "$typeStr" sets createDecoder: false, which cannot satisfy a '
        'required Decodable codec.',
        element: errorElement,
      );
    }
    if (requiredMode == CodecMode.encodable && !availableEnc) {
      throw InvalidGenerationSourceError(
        'Type "$typeStr" sets createEncoder: false, which cannot satisfy a '
        'required Encodable codec.',
        element: errorElement,
      );
    }
    if (requiredMode != CodecMode.codable || (availableDec && availableEnc)) {
      return expr;
    }
    final ref = expr.code;
    final codableType = 'Codable<$typeStr>';
    if (availableDec) {
      return CodecExpr(
        body:
            '$codableType.fromFunctions('
            'decode: $ref.decode, '
            "encode: (_, _) => throw UnsupportedError('Decode-only codec'))",
        staticTypeCode: codableType,
        isConst: false,
        usesTypeParams: expr.usesTypeParams,
        isBidirectional: true,
      );
    }
    return CodecExpr(
      body:
          '$codableType.fromFunctions('
          "decode: (_) => throw UnsupportedError('Encode-only codec'), "
          'encode: $ref.encode)',
      staticTypeCode: codableType,
      isConst: false,
      usesTypeParams: expr.usesTypeParams,
      isBidirectional: true,
    );
  }

  CodecExpr _buildClosureCodecExpr(DartType type, CodecMode mode) {
    final typeStr = type.getDisplayString();
    final staticType = mode.typeFor(typeStr);
    final usesTp = _containsEnclosingTypeParam(type);
    return switch (mode) {
      CodecMode.decodable => CodecExpr(
        body: '$staticType.fromFunction(${_decodeClosure(type)})',
        staticTypeCode: staticType,
        isConst: false,
        usesTypeParams: usesTp,
      ),
      CodecMode.encodable => CodecExpr(
        body: '$staticType.fromFunction(${_encodeClosure(type)})',
        staticTypeCode: staticType,
        isConst: false,
        usesTypeParams: usesTp,
      ),
      CodecMode.codable => CodecExpr(
        body:
            '$staticType.fromFunctions('
            'decode: ${_decodeClosure(type)}, '
            'encode: ${_encodeClosure(type)})',
        staticTypeCode: staticType,
        isConst: false,
        usesTypeParams: usesTp,
        isBidirectional: true,
      ),
    };
  }

  bool _containsEnclosingTypeParam(DartType type) {
    if (type is TypeParameterType) {
      return model.codecFieldFor(type.element) != null;
    }
    if (type is InterfaceType) {
      return type.typeArguments.any(_containsEnclosingTypeParam);
    }
    return false;
  }

  String _decodeClosure(DartType type) {
    final builder = decodeBuilder;
    if (builder == null) {
      throw StateError(
        'Missing decodeBuilder for nested type "${type.getDisplayString()}".',
      );
    }
    final body = builder(
      type,
      targetVar: 'res',
      decoderExpr: 'd',
      indent: '  ',
    );
    return '(d) {\n$body  return res;\n}';
  }

  String _encodeClosure(DartType type) {
    final builder = encodeBuilder;
    if (builder == null) {
      throw StateError(
        'Missing encodeBuilder for nested type "${type.getDisplayString()}".',
      );
    }
    final typeStr = type.getDisplayString();
    final body = builder(type, valueExpr: 'v', encoderExpr: 'e', indent: '  ');
    return '($typeStr v, e) {\n$body}';
  }

  static CodecMode _modeForFlags(bool createDecoder, bool createEncoder) =>
      switch ((createDecoder, createEncoder)) {
        (true, false) => CodecMode.decodable,
        (false, true) => CodecMode.encodable,
        _ => CodecMode.codable,
      };
}
