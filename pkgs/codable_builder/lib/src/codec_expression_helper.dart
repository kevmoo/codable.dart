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
enum CodecMode { codable, decodable, encodable }

/// Synthesized Dart expression for a runtime codec (`Codable`, `Decodable`, or
/// `Encodable`), tracking whether it can participate in a `const` context.
final class CodecExpr {
  /// Constructor or expression body without a leading `const ` keyword when
  /// [isConst] is `true` (e.g. `'AddressCodable()'`), or a complete runtime
  /// expression when [isConst] is `false` (e.g. `'_\$t'`).
  final String body;

  /// Whether `const $body` is a valid compile-time constant expression.
  final bool isConst;

  const CodecExpr({required this.body, required this.isConst});

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

  /// Returns the standalone Dart expression implementing [mode] for [type].
  String forType(DartType type, CodecMode mode) => buildExpr(type, mode).code;

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
    if ((type.isDartCoreList || element?.name == 'List') &&
        mode != CodecMode.encodable &&
        type is InterfaceType &&
        type.typeArguments.length == 1) {
      final directElem = _tryDirectCodecExpr(type.typeArguments.first, mode);
      if (directElem != null) {
        return CodecExpr(body: '${directElem.code}.list', isConst: false);
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
    final (createsDec, createsEnc) = _readCodableFlags(targetClass);
    final companionName = '${targetClass.name}Codable';
    if (typeArguments.isEmpty) {
      return _adaptIfNeeded(
        CodecExpr(body: '$companionName()', isConst: true),
        targetClass.thisType,
        availableDec: createsDec,
        availableEnc: createsEnc,
        requiredMode: requiredMode,
      );
    }

    final argMode = _modeForFlags(createsDec, createsEnc);
    final argExprs = [for (final arg in typeArguments) buildExpr(arg, argMode)];
    final allConst = argExprs.every((e) => e.isConst);
    final typeArgsCode =
        '<${typeArguments.map((t) => t.getDisplayString()).join(', ')}>';
    final renderedArgs = argExprs
        .map((e) => allConst ? e.body : e.code)
        .join(', ');
    final instantiatedType = targetClass.instantiate(
      typeArguments: typeArguments,
      nullabilitySuffix: NullabilitySuffix.none,
    );
    return _adaptIfNeeded(
      CodecExpr(
        body: '$companionName$typeArgsCode($renderedArgs)',
        isConst: allConst,
      ),
      instantiatedType,
      availableDec: createsDec,
      availableEnc: createsEnc,
      requiredMode: requiredMode,
    );
  }

  CodecExpr? _tryDirectCodecExpr(DartType type, CodecMode mode) {
    if (type.nullabilitySuffix == NullabilitySuffix.question) {
      final nonNull = model.element.library.typeSystem.promoteToNonNull(type);
      final inner = _tryDirectCodecExpr(nonNull, mode);
      return inner == null
          ? null
          : CodecExpr(body: '${inner.code}.nullable', isConst: false);
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
    final nonNull = model.element.library.typeSystem.promoteToNonNull(type);
    final direct = _tryDirectCodecExpr(nonNull, mode);
    if (direct != null) {
      return CodecExpr(body: '${direct.code}.nullable', isConst: false);
    }
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
    return _adaptIfNeeded(
      CodecExpr(body: field, isConst: false),
      type,
      availableDec: model.createDecoder,
      availableEnc: model.createEncoder,
      requiredMode: mode,
    );
  }

  static CodecExpr _adaptIfNeeded(
    CodecExpr expr,
    DartType type, {
    required bool availableDec,
    required bool availableEnc,
    required CodecMode requiredMode,
  }) {
    if (requiredMode != CodecMode.codable || (availableDec && availableEnc)) {
      return expr;
    }
    final typeStr = type.getDisplayString();
    final ref = expr.code;
    if (availableDec) {
      return CodecExpr(
        body:
            'Codable<$typeStr>.fromFunctions('
            'decode: $ref.decode, '
            "encode: (_, _) => throw UnsupportedError('Decode-only codec'))",
        isConst: false,
      );
    }
    return CodecExpr(
      body:
          'Codable<$typeStr>.fromFunctions('
          "decode: (_) => throw UnsupportedError('Encode-only codec'), "
          'encode: $ref.encode)',
      isConst: false,
    );
  }

  CodecExpr _buildClosureCodecExpr(DartType type, CodecMode mode) {
    final typeStr = type.getDisplayString();
    return switch (mode) {
      CodecMode.decodable => CodecExpr(
        body: 'Decodable<$typeStr>.fromFunction(${_decodeClosure(type)})',
        isConst: false,
      ),
      CodecMode.encodable => CodecExpr(
        body: 'Encodable<$typeStr>.fromFunction(${_encodeClosure(type)})',
        isConst: false,
      ),
      CodecMode.codable => CodecExpr(
        body:
            'Codable<$typeStr>.fromFunctions('
            'decode: ${_decodeClosure(type)}, '
            'encode: ${_encodeClosure(type)})',
        isConst: false,
      ),
    };
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

  static (bool, bool) _readCodableFlags(ClassElement element) {
    final annotation = codableTypeChecker.firstAnnotationOf(element);
    if (annotation == null) return (true, true);
    final reader = ConstantReader(annotation);
    final dec = reader.peek('createDecoder')?.boolValue ?? true;
    final enc = reader.peek('createEncoder')?.boolValue ?? true;
    return (dec, enc);
  }

  static CodecMode _modeForFlags(bool createDecoder, bool createEncoder) =>
      switch ((createDecoder, createEncoder)) {
        (true, false) => CodecMode.decodable,
        (false, true) => CodecMode.encodable,
        _ => CodecMode.codable,
      };
}
