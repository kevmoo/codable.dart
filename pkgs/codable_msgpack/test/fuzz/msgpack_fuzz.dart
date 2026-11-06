// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:typed_data';

import 'package:codable/codable.dart';
import 'package:codable_msgpack/codable_msgpack.dart';
import 'package:codable_msgpack/src/msgpack_reader.dart';

void main() => fuzzTarget(Uint8List(0));

/// Coverage-guided fuzz target for [MsgPackCodableDecoder],
/// [MsgPackCodableEncoder], and [MsgPackReader].
void fuzzTarget(Uint8List bytes) {
  _fuzzGenericDecodeAndReencode(bytes);
  _fuzzKeyedSchemaDecode(bytes);
  _fuzzMappedAndRewindDecode(bytes);
  _fuzzSkipItem(bytes);
}

sealed class _MsgPackNode {
  const _MsgPackNode();
}

final class _MsgPackNull extends _MsgPackNode {
  const _MsgPackNull();
}

final class _MsgPackBool extends _MsgPackNode {
  final bool value;
  const _MsgPackBool(this.value);
}

final class _MsgPackInt extends _MsgPackNode {
  final int value;
  const _MsgPackInt(this.value);
}

final class _MsgPackFloat extends _MsgPackNode {
  final double value;
  const _MsgPackFloat(this.value);
}

final class _MsgPackText extends _MsgPackNode {
  final String value;
  const _MsgPackText(this.value);
}

final class _MsgPackBytes extends _MsgPackNode {
  final Uint8List value;
  const _MsgPackBytes(this.value);
}

final class _MsgPackArray extends _MsgPackNode {
  final List<_MsgPackNode> items;
  const _MsgPackArray(this.items);
}

final class _MsgPackMap extends _MsgPackNode {
  final List<(_MsgPackNode, _MsgPackNode)> entries;
  const _MsgPackMap(this.entries);
}

void _fuzzGenericDecodeAndReencode(Uint8List bytes) {
  final _MsgPackNode root;
  final MsgPackReader reader;
  try {
    reader = MsgPackReader(bytes);
    final decoder = MsgPackCodableDecoder.fromBytes(bytes);
    root = _decodeNode(decoder, 0);
    reader.skipItem();
  } on CodableException {
    return;
  }

  final reencoded = MsgPackCodableEncoder.encode<_MsgPackNode>(
    root,
    const Encodable.fromFunction(_encodeNode),
    requireKnownLength: true,
  );
  final roundtripped = MsgPackCodableDecoder.decode<_MsgPackNode>(
    reencoded,
    Decodable.fromFunction((d) => _decodeNode(d, 0)),
  );
  if (!_nodesEqual(root, roundtripped)) {
    throw StateError('MessagePack roundtrip mismatch on valid input');
  }
}

_MsgPackNode _decodeNode(Decoder decoder, int depth) {
  if (depth > 24) {
    throw const CodableException('Max fuzz nesting depth exceeded');
  }
  return switch (decoder.peekKind()) {
    ValueKind.nullValue => _readNullNode(decoder),
    ValueKind.boolean => _MsgPackBool(decoder.singleValue().readBool()),
    ValueKind.number => _readNumberNode(decoder),
    ValueKind.string => _MsgPackText(decoder.singleValue().readString()),
    ValueKind.bytes => _MsgPackBytes(decoder.singleValue().readBytes()),
    ValueKind.list => _decodeArrayNode(decoder, depth + 1),
    ValueKind.map => _decodeMapNode(decoder, depth + 1),
  };
}

_MsgPackNode _readNullNode(Decoder decoder) {
  decoder.singleValue().readNull();
  return const _MsgPackNull();
}

bool _isEncodableInt(num n) {
  if (n is! int || identical(n, -0.0)) return false;
  if (!identical(1.0, 1)) return true;
  return n >= -msgPackJsMaxSafeInt && n <= msgPackJsMaxSafeInt;
}

_MsgPackNode _readNumberNode(Decoder decoder) {
  final n = decoder.singleValue().readNum();
  return _isEncodableInt(n)
      ? _MsgPackInt(n as int)
      : _MsgPackFloat(n.toDouble());
}

_MsgPackNode _decodeArrayNode(Decoder decoder, int nextDepth) {
  final u = decoder.unkeyed();
  final items = <_MsgPackNode>[];
  while (u.moveNext()) {
    items.add(_decodeNode(u.nestedDecoder(), nextDepth));
  }
  return _MsgPackArray(items);
}

_MsgPackNode _decodeMapNode(Decoder decoder, int nextDepth) {
  final m = decoder.map();
  final entries = <(_MsgPackNode, _MsgPackNode)>[];
  while (m.moveNextEntry()) {
    final k = _decodeNode(m.keyDecoder(), nextDepth);
    final v = _decodeNode(m.valueDecoder(), nextDepth);
    entries.add((k, v));
  }
  return _MsgPackMap(entries);
}

void _encodeNode(_MsgPackNode node, Encoder encoder) {
  switch (node) {
    case _MsgPackNull():
      encoder.singleValue().encodeNull();
    case _MsgPackBool(:final value):
      encoder.singleValue().encodeBool(value);
    case _MsgPackInt(:final value):
      encoder.singleValue().encodeInt(value);
    case _MsgPackFloat(:final value):
      encoder.singleValue().encodeDouble(value);
    case _MsgPackText(:final value):
      encoder.singleValue().encodeString(value);
    case _MsgPackBytes(:final value):
      encoder.singleValue().encodeBytes(value);
    case _MsgPackArray(:final items):
      _encodeArrayNode(items, encoder);
    case _MsgPackMap(:final entries):
      _encodeMapNode(entries, encoder);
  }
}

void _encodeArrayNode(List<_MsgPackNode> items, Encoder encoder) {
  final u = encoder.unkeyed(length: items.length);
  for (final item in items) {
    _encodeNode(item, u.nestedEncoder());
  }
}

void _encodeMapNode(
  List<(_MsgPackNode, _MsgPackNode)> entries,
  Encoder encoder,
) {
  final m = encoder.map(length: entries.length);
  for (final (k, v) in entries) {
    _encodeNode(k, m.keyEncoder());
    _encodeNode(v, m.valueEncoder());
  }
}

bool _nodesEqual(_MsgPackNode a, _MsgPackNode b) => switch ((a, b)) {
  (_MsgPackNull(), _MsgPackNull()) => true,
  (_MsgPackBool(value: final va), _MsgPackBool(value: final vb)) => va == vb,
  (_MsgPackInt(value: final va), _MsgPackInt(value: final vb)) => va == vb,
  (_MsgPackFloat(value: final va), _MsgPackFloat(value: final vb)) =>
    (va.isNaN && vb.isNaN) || va == vb,
  (_MsgPackText(value: final va), _MsgPackText(value: final vb)) => va == vb,
  (_MsgPackBytes(value: final va), _MsgPackBytes(value: final vb)) =>
    va.length == vb.length && msgPackBytesMatch(va, 0, vb, va.length),
  (_MsgPackArray(items: final ia), _MsgPackArray(items: final ib)) =>
    _arrayNodesEqual(ia, ib),
  (_MsgPackMap(entries: final ea), _MsgPackMap(entries: final eb)) =>
    _mapNodesEqual(ea, eb),
  _ => false,
};

bool _arrayNodesEqual(List<_MsgPackNode> a, List<_MsgPackNode> b) {
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (!_nodesEqual(a[i], b[i])) return false;
  }
  return true;
}

bool _mapNodesEqual(
  List<(_MsgPackNode, _MsgPackNode)> a,
  List<(_MsgPackNode, _MsgPackNode)> b,
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
    MsgPackCodableDecoder.decode<void>(
      bytes,
      const Decodable.fromFunction(_consumeKeyedSchema),
    );
  } on CodableException {
    // Expected on malformed or mismatched MessagePack payloads.
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
    final decoder = MsgPackCodableDecoder.fromBytes(bytes);
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
    // Expected on non-map or malformed MessagePack payloads.
  }
}

void _fuzzSkipItem(Uint8List bytes) {
  try {
    final reader = MsgPackReader(bytes);
    reader.skipItem();
    if (reader.offset <= 0 || reader.offset > bytes.length) {
      throw RangeError.range(reader.offset, 1, bytes.length, 'reader.offset');
    }
  } on CodableException {
    // Expected on truncated or unsupported MessagePack payloads.
  }
}
