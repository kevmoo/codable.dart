// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:typed_data';

import 'package:codable/codable.dart';
import 'package:codable_cbor/codable_cbor.dart';
import 'package:codable_cbor/src/cbor_reader.dart';

void main() => fuzzTarget(Uint8List(0));

/// Coverage-guided fuzz target for [CborCodableDecoder], [CborCodableEncoder],
/// and [CborReader].
void fuzzTarget(Uint8List bytes) {
  _fuzzGenericDecodeAndReencode(bytes);
  _fuzzKeyedSchemaDecode(bytes);
  _fuzzMappedAndRewindDecode(bytes);
  _fuzzSkipItem(bytes);
}

sealed class _CborNode {
  const _CborNode();
}

final class _CborNull extends _CborNode {
  const _CborNull();
}

final class _CborBool extends _CborNode {
  final bool value;
  const _CborBool(this.value);
}

final class _CborInt extends _CborNode {
  final int value;
  const _CborInt(this.value);
}

final class _CborFloat extends _CborNode {
  final double value;
  const _CborFloat(this.value);
}

final class _CborText extends _CborNode {
  final String value;
  const _CborText(this.value);
}

final class _CborBytes extends _CborNode {
  final Uint8List value;
  const _CborBytes(this.value);
}

final class _CborArray extends _CborNode {
  final List<_CborNode> items;
  const _CborArray(this.items);
}

final class _CborMap extends _CborNode {
  final List<(_CborNode, _CborNode)> entries;
  const _CborMap(this.entries);
}

void _fuzzGenericDecodeAndReencode(Uint8List bytes) {
  final _CborNode root;
  final CborReader reader;
  try {
    reader = CborReader(bytes);
    final decoder = CborCodableDecoder.fromBytes(bytes);
    root = _decodeNode(decoder, 0);
    reader.skipItem();
  } on CodableException {
    return;
  }

  final reencoded = CborCodableEncoder.encode<_CborNode>(
    root,
    const Encodable.fromFunction(_encodeNode),
  );
  final roundtripped = CborCodableDecoder.decode<_CborNode>(
    reencoded,
    Decodable.fromFunction((d) => _decodeNode(d, 0)),
  );
  if (!_nodesEqual(root, roundtripped)) {
    throw StateError('CBOR roundtrip mismatch on valid input');
  }
}

_CborNode _decodeNode(Decoder decoder, int depth) {
  if (depth > 24) {
    throw const CodableException('Max fuzz nesting depth exceeded');
  }
  return switch (decoder.peekKind()) {
    ValueKind.nullValue => _readNullNode(decoder),
    ValueKind.boolean => _CborBool(decoder.singleValue().readBool()),
    ValueKind.number => _readNumberNode(decoder),
    ValueKind.string => _CborText(decoder.singleValue().readString()),
    ValueKind.bytes => _CborBytes(decoder.singleValue().readBytes()),
    ValueKind.list => _decodeArrayNode(decoder, depth + 1),
    ValueKind.map => _decodeMapNode(decoder, depth + 1),
  };
}

_CborNode _readNullNode(Decoder decoder) {
  decoder.singleValue().readNull();
  return const _CborNull();
}

_CborNode _readNumberNode(Decoder decoder) {
  final n = decoder.singleValue().readNum();
  return n is int ? _CborInt(n) : _CborFloat(n.toDouble());
}

_CborNode _decodeArrayNode(Decoder decoder, int nextDepth) {
  final u = decoder.unkeyed();
  final items = <_CborNode>[];
  while (u.moveNext()) {
    items.add(_decodeNode(u.nestedDecoder(), nextDepth));
  }
  return _CborArray(items);
}

_CborNode _decodeMapNode(Decoder decoder, int nextDepth) {
  final m = decoder.map();
  final entries = <(_CborNode, _CborNode)>[];
  while (m.moveNextEntry()) {
    final k = _decodeNode(m.keyDecoder(), nextDepth);
    final v = _decodeNode(m.valueDecoder(), nextDepth);
    entries.add((k, v));
  }
  return _CborMap(entries);
}

void _encodeNode(_CborNode node, Encoder encoder) {
  switch (node) {
    case _CborNull():
      encoder.singleValue().encodeNull();
    case _CborBool(:final value):
      encoder.singleValue().encodeBool(value);
    case _CborInt(:final value):
      encoder.singleValue().encodeInt(value);
    case _CborFloat(:final value):
      encoder.singleValue().encodeDouble(value);
    case _CborText(:final value):
      encoder.singleValue().encodeString(value);
    case _CborBytes(:final value):
      encoder.singleValue().encodeBytes(value);
    case _CborArray(:final items):
      _encodeArrayNode(items, encoder);
    case _CborMap(:final entries):
      _encodeMapNode(entries, encoder);
  }
}

void _encodeArrayNode(List<_CborNode> items, Encoder encoder) {
  final u = encoder.unkeyed(length: items.length);
  for (final item in items) {
    _encodeNode(item, u.nestedEncoder());
  }
}

void _encodeMapNode(List<(_CborNode, _CborNode)> entries, Encoder encoder) {
  final m = encoder.map(length: entries.length);
  for (final (k, v) in entries) {
    _encodeNode(k, m.keyEncoder());
    _encodeNode(v, m.valueEncoder());
  }
}

bool _nodesEqual(_CborNode a, _CborNode b) => switch ((a, b)) {
  (_CborNull(), _CborNull()) => true,
  (_CborBool(value: final va), _CborBool(value: final vb)) => va == vb,
  (_CborInt(value: final va), _CborInt(value: final vb)) => va == vb,
  (_CborFloat(value: final va), _CborFloat(value: final vb)) =>
    (va.isNaN && vb.isNaN) || va == vb,
  (_CborText(value: final va), _CborText(value: final vb)) => va == vb,
  (_CborBytes(value: final va), _CborBytes(value: final vb)) =>
    va.length == vb.length && cborBytesMatch(va, 0, vb, va.length),
  (_CborArray(items: final ia), _CborArray(items: final ib)) =>
    _arrayNodesEqual(ia, ib),
  (_CborMap(entries: final ea), _CborMap(entries: final eb)) => _mapNodesEqual(
    ea,
    eb,
  ),
  _ => false,
};

bool _arrayNodesEqual(List<_CborNode> a, List<_CborNode> b) {
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (!_nodesEqual(a[i], b[i])) return false;
  }
  return true;
}

bool _mapNodesEqual(
  List<(_CborNode, _CborNode)> a,
  List<(_CborNode, _CborNode)> b,
) {
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    final (ka, va) = a[i];
    final (kb, vb) = b[i];
    if (!_nodesEqual(ka, kb) || !_nodesEqual(va, vb)) return false;
  }
  return true;
}

final KeyOptions _fuzzSchemaKeys = KeyOptions.of(const [
  'id',
  'name',
  'data',
  'nums',
]);

void _fuzzKeyedSchemaDecode(Uint8List bytes) {
  try {
    CborCodableDecoder.decode<void>(
      bytes,
      const Decodable.fromFunction(_consumeKeyedSchema),
    );
  } on CodableException {
    // Expected on malformed or mismatched CBOR payloads.
  }
}

void _consumeKeyedSchema(Decoder decoder) {
  final keyed = decoder.keyed(options: _fuzzSchemaKeys);
  while (keyed.moveNextKey()) {
    switch (keyed.selectKeyIndex(_fuzzSchemaKeys)) {
      case 0:
        keyed.readNullableInt();
      case 1:
        keyed.readNullableString();
      case 2:
        keyed.readNullableBytes();
      case 3:
        keyed.decodeIntList();
      default:
        keyed.skipValue();
    }
  }
}

void _fuzzMappedAndRewindDecode(Uint8List bytes) {
  try {
    final decoder = CborCodableDecoder.fromBytes(bytes);
    final mapped = decoder.mapped();
    if (mapped.containsKey('id')) {
      mapped.peekKind('id');
      mapped.readNullableString('id');
    }
    final keyed = decoder.keyed(options: _fuzzSchemaKeys);
    while (keyed.moveNextKey()) {
      keyed.skipValue();
    }
  } on CodableException {
    // Expected on non-map or malformed CBOR payloads.
  }
}

void _fuzzSkipItem(Uint8List bytes) {
  try {
    final reader = CborReader(bytes);
    reader.skipItem();
    if (reader.offset <= 0 || reader.offset > bytes.length) {
      throw RangeError.range(reader.offset, 1, bytes.length, 'reader.offset');
    }
  } on CodableException {
    // Expected on truncated or unsupported CBOR payloads.
  }
}
