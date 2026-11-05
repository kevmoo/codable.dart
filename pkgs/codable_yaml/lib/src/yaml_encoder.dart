// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:codable/codable.dart';

final RegExp _bareYamlIdent = RegExp(r'^[a-zA-Z_][a-zA-Z0-9_-]*$');
const Set<String> _yamlReservedWords = {
  'true',
  'false',
  'null',
  'yes',
  'no',
  'on',
  'off',
  'nan',
  'inf',
};

String _formatYamlString(String value) {
  if (_bareYamlIdent.hasMatch(value) &&
      !_yamlReservedWords.contains(value.toLowerCase())) {
    return value;
  }
  return jsonEncode(value);
}

String _formatYamlDouble(double value) {
  if (value.isNaN) return '.nan';
  if (value.isInfinite) return value.isNegative ? '-.inf' : '.inf';
  return value.toString();
}

sealed class _YamlOut {
  const _YamlOut();
}

final class _YamlOutScalar extends _YamlOut {
  final String text;
  const _YamlOutScalar(this.text);
}

final class _YamlOutSeq extends _YamlOut {
  final List<YamlCodableEncoder> items = [];
}

final class _YamlOutMap extends _YamlOut {
  final List<(YamlCodableEncoder, YamlCodableEncoder)> entries = [];
}

void _emitYamlBlock(_YamlOut node, StringBuffer out, int indent) {
  switch (node) {
    case _YamlOutScalar(:final text):
      out.write(text);
    case _YamlOutSeq(:final items):
      _emitYamlBlockSeq(items, out, indent);
    case _YamlOutMap(:final entries):
      _emitYamlBlockMap(entries, out, indent);
  }
}

void _emitYamlBlockSeq(
  List<YamlCodableEncoder> items,
  StringBuffer out,
  int indent,
) {
  if (items.isEmpty) {
    out.write('[]');
    return;
  }
  final prefix = '  ' * indent;
  for (var i = 0; i < items.length; i++) {
    if (i > 0) out.write('\n$prefix');
    final child = items[i]._resolvedOut();
    if (child is _YamlOutScalar || _isEmptyCollection(child)) {
      out.write('- ');
      _emitYamlBlock(child, out, indent + 1);
    } else {
      out.write('-\n${'  ' * (indent + 1)}');
      _emitYamlBlock(child, out, indent + 1);
    }
  }
}

void _emitYamlBlockMap(
  List<(YamlCodableEncoder, YamlCodableEncoder)> entries,
  StringBuffer out,
  int indent,
) {
  if (entries.isEmpty) {
    out.write('{}');
    return;
  }
  final prefix = '  ' * indent;
  for (var i = 0; i < entries.length; i++) {
    if (i > 0) out.write('\n$prefix');
    final (kEnc, vEnc) = entries[i];
    final kNode = kEnc._resolvedOut();
    final vNode = vEnc._resolvedOut();
    if (kNode is _YamlOutScalar) {
      out.write(kNode.text);
    } else {
      _emitYamlComplexKey(kNode, out, indent, prefix);
    }
    _emitYamlBlockMapValue(vNode, out, indent);
  }
}

void _emitYamlComplexKey(
  _YamlOut kNode,
  StringBuffer out,
  int indent,
  String prefix,
) {
  if (_isEmptyCollection(kNode)) {
    out.write('? ');
    _emitYamlBlock(kNode, out, indent + 1);
  } else {
    out.write('?\n${'  ' * (indent + 1)}');
    _emitYamlBlock(kNode, out, indent + 1);
  }
  out.write('\n$prefix');
}

void _emitYamlBlockMapValue(_YamlOut vNode, StringBuffer out, int indent) {
  if (vNode is _YamlOutScalar || _isEmptyCollection(vNode)) {
    out.write(': ');
    _emitYamlBlock(vNode, out, indent + 1);
  } else {
    out.write(':\n${'  ' * (indent + 1)}');
    _emitYamlBlock(vNode, out, indent + 1);
  }
}

void _emitYamlFlow(_YamlOut node, StringBuffer out) {
  switch (node) {
    case _YamlOutScalar(:final text):
      out.write(text);
    case _YamlOutSeq(:final items):
      out.write('[');
      for (var i = 0; i < items.length; i++) {
        if (i > 0) out.write(', ');
        _emitYamlFlow(items[i]._resolvedOut(), out);
      }
      out.write(']');
    case _YamlOutMap(:final entries):
      _emitYamlFlowMap(entries, out);
  }
}

void _emitYamlFlowMap(
  List<(YamlCodableEncoder, YamlCodableEncoder)> entries,
  StringBuffer out,
) {
  out.write('{');
  for (var i = 0; i < entries.length; i++) {
    if (i > 0) out.write(', ');
    final (kEnc, vEnc) = entries[i];
    final kNode = kEnc._resolvedOut();
    if (kNode is _YamlOutScalar) {
      out.write('${kNode.text}: ');
    } else {
      out.write('? ');
      _emitYamlFlow(kNode, out);
      out.write(' : ');
    }
    _emitYamlFlow(vEnc._resolvedOut(), out);
  }
  out.write('}');
}

bool _isEmptyCollection(_YamlOut node) => switch (node) {
  _YamlOutSeq(:final items) => items.isEmpty,
  _YamlOutMap(:final entries) => entries.isEmpty,
  _YamlOutScalar() => false,
};

/// Human-readable YAML [Encoder] supporting block and flow emission, scalars,
/// Base64 bytes, lists, string-keyed objects, and arbitrary-keyed maps.
final class YamlCodableEncoder implements Encoder {
  @override
  final Map<Object, Object?> userInfo;

  /// Whether collections are emitted in compact single-line flow style
  /// (`{a: 1, b: [2, 3]}`) rather than indented block style.
  final bool flow;

  _YamlOut? _out;

  /// Creates a [YamlCodableEncoder] with optional [userInfo] and [flow] style.
  YamlCodableEncoder({this.userInfo = const {}, this.flow = false});

  YamlCodableEncoder._scalar(String text)
    : userInfo = const {},
      flow = false,
      _out = _YamlOutScalar(text);

  /// Encodes [value] into a YAML document string using [encodable].
  static String encode<T>(
    T value,
    Encodable<T> encodable, {
    Map<Object, Object?> userInfo = const {},
    bool flow = false,
  }) {
    final encoder = YamlCodableEncoder(userInfo: userInfo, flow: flow);
    encodable.encode(value, encoder);
    final buffer = StringBuffer();
    final root = encoder._resolvedOut();
    if (flow) {
      _emitYamlFlow(root, buffer);
    } else {
      _emitYamlBlock(root, buffer, 0);
    }
    buffer.writeln();
    return buffer.toString();
  }

  _YamlOut _resolvedOut() => _out ?? const _YamlOutScalar('null');

  @override
  bool get isHumanReadable => true;

  @override
  KeyedEncoder keyed({KeyOptions? options, int? length}) {
    final mapOut = _YamlOutMap();
    _out = mapOut;
    return _YamlKeyedEncoder(mapOut, userInfo, flow);
  }

  @override
  UnkeyedEncoder unkeyed({int? length}) {
    final seqOut = _YamlOutSeq();
    _out = seqOut;
    return _YamlUnkeyedEncoder(seqOut, userInfo, flow);
  }

  @override
  MapEncoder map({int? length}) {
    final mapOut = _YamlOutMap();
    _out = mapOut;
    return _YamlMapEncoder(mapOut, userInfo, flow);
  }

  @override
  SingleValueEncoder singleValue() => _YamlSingleValueEncoder(this);
}

final class _YamlKeyedEncoder
    with BaseKeyedEncoderMixin
    implements KeyedEncoder {
  final _YamlOutMap _mapOut;
  final Map<Object, Object?> _userInfo;
  final bool _flow;

  _YamlKeyedEncoder(this._mapOut, this._userInfo, this._flow);

  void _putScalar(String key, String text) {
    _mapOut.entries.add((
      YamlCodableEncoder._scalar(_formatYamlString(key)),
      YamlCodableEncoder._scalar(text),
    ));
  }

  @override
  void encodeInt(String key, int value) => _putScalar(key, value.toString());

  @override
  void encodeDouble(String key, double value) =>
      _putScalar(key, _formatYamlDouble(value));

  @override
  void encodeString(String key, String value) =>
      _putScalar(key, _formatYamlString(value));

  @override
  void encodeBool(String key, bool value) =>
      _putScalar(key, value ? 'true' : 'false');

  @override
  void encodeNull(String key) => _putScalar(key, 'null');

  @override
  Encoder nestedEncoder(String key) {
    final child = YamlCodableEncoder(userInfo: _userInfo, flow: _flow);
    _mapOut.entries.add((
      YamlCodableEncoder._scalar(_formatYamlString(key)),
      child,
    ));
    return child;
  }
}

final class _YamlUnkeyedEncoder
    with BaseUnkeyedEncoderMixin
    implements UnkeyedEncoder {
  final _YamlOutSeq _seqOut;
  final Map<Object, Object?> _userInfo;
  final bool _flow;

  _YamlUnkeyedEncoder(this._seqOut, this._userInfo, this._flow);

  void _addScalar(String text) {
    _seqOut.items.add(YamlCodableEncoder._scalar(text));
  }

  @override
  void encodeInt(int value) => _addScalar(value.toString());

  @override
  void encodeDouble(double value) => _addScalar(_formatYamlDouble(value));

  @override
  void encodeString(String value) => _addScalar(_formatYamlString(value));

  @override
  void encodeBool(bool value) => _addScalar(value ? 'true' : 'false');

  @override
  void encodeNull() => _addScalar('null');

  @override
  Encoder nestedEncoder() {
    final child = YamlCodableEncoder(userInfo: _userInfo, flow: _flow);
    _seqOut.items.add(child);
    return child;
  }
}

final class _YamlMapEncoder implements MapEncoder {
  final _YamlOutMap _mapOut;
  final Map<Object, Object?> _userInfo;
  final bool _flow;
  YamlCodableEncoder? _pendingKey;

  _YamlMapEncoder(this._mapOut, this._userInfo, this._flow);

  @override
  Encoder keyEncoder() {
    if (_pendingKey != null) {
      throw const CodableException(
        'MapEncoder.keyEncoder() called before valueEncoder()',
      );
    }
    final keyEnc = YamlCodableEncoder(userInfo: _userInfo, flow: _flow);
    _pendingKey = keyEnc;
    return keyEnc;
  }

  @override
  Encoder valueEncoder() {
    final keyEnc = _pendingKey;
    if (keyEnc == null) {
      throw const CodableException(
        'MapEncoder.valueEncoder() called before keyEncoder()',
      );
    }
    _pendingKey = null;
    final valEnc = YamlCodableEncoder(userInfo: _userInfo, flow: _flow);
    _mapOut.entries.add((keyEnc, valEnc));
    return valEnc;
  }
}

final class _YamlSingleValueEncoder
    with BaseSingleValueEncoderMixin
    implements SingleValueEncoder {
  final YamlCodableEncoder _parent;

  _YamlSingleValueEncoder(this._parent);

  void _set(String text) {
    _parent._out = _YamlOutScalar(text);
  }

  @override
  void encodeInt(int value) => _set(value.toString());

  @override
  void encodeDouble(double value) => _set(_formatYamlDouble(value));

  @override
  void encodeString(String value) => _set(_formatYamlString(value));

  @override
  void encodeBool(bool value) => _set(value ? 'true' : 'false');

  @override
  void encodeNull() => _set('null');

  @override
  void encode<T>(T value, Encodable<T> encodable) =>
      encodable.encode(value, _parent);
}
