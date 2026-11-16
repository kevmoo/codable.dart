// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:typed_data';

import 'package:codable/codable.dart';
import 'package:codable_toml/codable_toml.dart';

void main() {
  for (final sample in tomlFuzzSmokeCorpus()) {
    fuzzTarget(sample);
  }
}

/// Coverage-guided fuzz target for [TomlCodableDecoder] and the TOML v1.0
/// parser.
///
/// Catches only [CodableException]; any leaked [FormatException], [RangeError],
/// [StateError], or [TypeError] fails immediately.
void fuzzTarget(Uint8List bytes) {
  _fuzzGenericTreeAndKeyedParity(bytes);
  _fuzzKeyedSchemaDecode(bytes);
  _fuzzMappedAndMapKeyCoercion(bytes);
}

final KeyOptions _fuzzSchemaKeys = KeyOptions.of(const <String>[
  'id',
  'name',
  'active',
  'ratio',
  'data',
  'nums',
  'ts',
]);

void _fuzzGenericTreeAndKeyedParity(Uint8List bytes) {
  final Object? mapTree;
  try {
    final decoder = TomlCodableDecoder.fromBytes(bytes);
    mapTree = _readGenericNode(decoder);
  } on CodableException {
    return;
  }

  final text = utf8.decode(bytes);
  final keyedTree = TomlCodableDecoder.decode<Object?>(
    text,
    const Decodable.fromFunction(_readGenericNodeViaKeyed),
  );
  if (!_deepEquals(mapTree, keyedTree)) {
    throw StateError('TOML MapDecoder vs KeyedDecoder parity mismatch');
  }
}

Object? _readGenericNode(Decoder decoder) {
  final sv = decoder.singleValue();
  if (sv case final TomlNativeDateTimeSource source) {
    final dt = source.tryReadTomlDateTime();
    if (dt != null) return dt;
  }
  return switch (decoder.peekKind()) {
    ValueKind.nullValue => _consumeNull(sv),
    ValueKind.boolean => sv.readBool(),
    ValueKind.number => sv.readNum(),
    ValueKind.string => sv.readString(),
    ValueKind.bytes => sv.readBytes(),
    ValueKind.list => _readGenericArray(decoder),
    ValueKind.map => _readGenericMap(decoder),
  };
}

Object? _consumeNull(SingleValueDecoder sv) {
  sv.readNull();
  return null;
}

List<Object?> _readGenericArray(Decoder decoder) {
  final u = decoder.unkeyed();
  final items = <Object?>[];
  while (u.moveNext()) {
    items.add(_readGenericNode(u.nestedDecoder()));
  }
  return items;
}

Map<String, Object?> _readGenericMap(Decoder decoder) {
  final m = decoder.map();
  final out = <String, Object?>{};
  while (m.moveNextEntry()) {
    final k = m.keyDecoder().singleValue().readString();
    out[k] = _readGenericNode(m.valueDecoder());
  }
  return out;
}

Object? _readGenericNodeViaKeyed(Decoder decoder) =>
    switch (decoder.peekKind()) {
      ValueKind.map => _readKeyedTable(decoder),
      ValueKind.list => _readKeyedList(decoder),
      _ => _readGenericScalarViaSingleValue(decoder.singleValue()),
    };

Object? _readGenericScalarViaSingleValue(SingleValueDecoder sv) {
  if (sv case final TomlNativeDateTimeSource source) {
    final dt = source.tryReadTomlDateTime();
    if (dt != null) return dt;
  }
  return switch (sv.peekKind()) {
    ValueKind.boolean => sv.readBool(),
    ValueKind.number => sv.readNum(),
    ValueKind.string => sv.readString(),
    _ => null,
  };
}

Map<String, Object?> _readKeyedTable(Decoder decoder) {
  final k = decoder.keyed();
  final out = <String, Object?>{};
  while (k.moveNextKey()) {
    final key = k.nextKey();
    out[key] = _readGenericNodeViaKeyed(k.nestedDecoder());
  }
  return out;
}

List<Object?> _readKeyedList(Decoder decoder) {
  final u = decoder.unkeyed();
  final items = <Object?>[];
  while (u.moveNext()) {
    items.add(_readGenericNodeViaKeyed(u.nestedDecoder()));
  }
  return items;
}

bool _deepEquals(Object? a, Object? b) {
  if (a is double && b is double) {
    return (a.isNaN && b.isNaN) || a == b;
  }
  if (a is List<Object?> && b is List<Object?>) {
    return _listsEqual(a, b);
  }
  if (a is Map<String, Object?> && b is Map<String, Object?>) {
    return _mapsEqual(a, b);
  }
  return a == b;
}

bool _listsEqual(List<Object?> a, List<Object?> b) {
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (!_deepEquals(a[i], b[i])) return false;
  }
  return true;
}

bool _mapsEqual(Map<String, Object?> a, Map<String, Object?> b) {
  if (a.length != b.length) return false;
  for (final entry in a.entries) {
    if (!b.containsKey(entry.key)) return false;
    if (!_deepEquals(entry.value, b[entry.key])) return false;
  }
  return true;
}

void _fuzzKeyedSchemaDecode(Uint8List bytes) {
  try {
    TomlCodableDecoder.decodeBytes<void>(
      bytes,
      const Decodable.fromFunction(_consumeKeyedSchema),
    );
  } on CodableException {
    // Expected on malformed or schema-mismatched TOML inputs.
  }
}

void _consumeKeyedSchema(Decoder decoder) {
  final keyed = decoder.keyed(options: _fuzzSchemaKeys);
  while (keyed.moveNextKey()) {
    _consumeSchemaField(keyed, keyed.selectKeyIndex(_fuzzSchemaKeys));
  }
}

void _consumeSchemaField(KeyedDecoder keyed, int index) {
  switch (index) {
    case 0:
      keyed.readNullableInt();
    case 1:
      keyed.readNullableString();
    case 2:
      keyed.readNullableBool();
    case 3:
      keyed.readNullableDouble();
    case 4:
      keyed.readNullableBytes();
    case 5:
      keyed.decodeIntList();
    case 6:
      keyed.decodeValue(const TomlDateTimeCodec());
    default:
      keyed.skipValue();
  }
}

void _fuzzMappedAndMapKeyCoercion(Uint8List bytes) {
  try {
    final decoder = TomlCodableDecoder.fromBytes(bytes);
    final mapped = decoder.mapped();
    if (mapped.containsKey('id')) {
      mapped.peekKind('id');
      mapped.readNullableInt('id');
    }
    final keyed = decoder.keyed(options: _fuzzSchemaKeys);
    while (keyed.moveNextKey()) {
      keyed.peekKey();
      keyed.skipValue();
    }
    final map = decoder.map();
    while (map.moveNextEntry()) {
      _probeKeyCoercions(map.keyDecoder().singleValue());
    }
  } on CodableException {
    // Expected on malformed or non-coercible keys/values.
  }
}

void _probeKeyCoercions(SingleValueDecoder keySv) {
  final raw = keySv.readString();
  if (raw == 'true' || raw == 'false') {
    keySv.readBool();
  }
  if (int.tryParse(raw) != null) {
    try {
      keySv.readInt();
    } on CodableException {
      // Expected if outside safe integer bounds.
    }
  }
}

/// Deterministic smoke corpus covering valid TOML v1.0 constructs, malformed
/// syntax, invalid UTF-8 sequences, and PRNG byte slices.
List<Uint8List> tomlFuzzSmokeCorpus() {
  final textSamples = <String>[
    '',
    '# comment only\n',
    '\ufeffid = 42\nname = "hello\\nworld"\nactive = true\nratio = 3.14\n',
    'data = "AQIDBA=="\nnums = [1, 2, 3,]\nts = 1979-05-27T07:32:00Z\n',
    'ts = "not-a-date"\n',
    'hex = 0xdead_beef\noct = 0o755\nbin = 0b1010_0101\n',
    'pos_inf = +inf\nneg_inf = -inf\nnan_val = nan\n',
    'odt = 1979-05-27 07:32:00-07:00\nldt = 1979-05-27T00:32:00.999999\n',
    'ld = 1979-05-27\nlt = 07:32:00.123456789\n',
    'ml1 = """\nhello \\\n   world ""\\"!"""\nml2 = \'\'\'\nraw \'\'text\'\'\'\n',
    '[a.b]\nx = 1\n[a]\ny = 2\n[[items]]\nk = "v1"\n[[items]]\nk = "v2"\n',
    'inline = { a.b = 1, a.c = [true, false], "q.k" = \'lit\' }\n',
    '100 = "ok"\ntrue = false\n"-42" = 3.5\n',
    // Malformed / boundary inputs:
    'unterminated = "hello',
    'bad_esc = "\\x20"',
    'bad_surrogate = "\\uD800"',
    'bad_quotes = """"""""""foo"""',
    'bare_cr = "a\rb"',
    'comment_ctrl = 1 # \x07\n',
    'leading_zero = 01',
    'bad_underscore = 1__0',
    'overflow_int = 99999999999999999999999999999',
    'bad_date = 2023-02-29',
    'bad_time = 24:00:00',
    'dup = 1\ndup = 2\n',
    'inline_trail = { x = 1, }',
    'inline_nl = {\nx = 1\n}',
    'a = { b = 1 }\n[a.c]\nx = 2\n',
    'arr = [1]\n[[arr]]\nx = 2\n',
    'x = ${'[' * 64}1${']' * 64}\n',
    'x = ${'[' * 65}1${']' * 65}\n',
    '${List<String>.filled(66, 'a').join('.')} = 1\n',
  ];

  final corpus = <Uint8List>[
    Uint8List(0),
    Uint8List.fromList(const <int>[0xff, 0xfe, 0xfd]),
    Uint8List.fromList(const <int>[0x80]),
    Uint8List.fromList(const <int>[0xc0, 0xaf]),
    Uint8List.fromList(const <int>[0xf0, 0x9f, 0x98]),
    for (final s in textSamples) Uint8List.fromList(utf8.encode(s)),
  ];

  var state = 0x5eedcafe;
  for (var i = 0; i < 64; i++) {
    final len = i % 48;
    final buf = Uint8List(len);
    for (var j = 0; j < len; j++) {
      state = (state * 1103515245 + 12345) & 0x7fffffff;
      buf[j] = (state >> 16) & 0x7f;
    }
    corpus.add(buf);
  }
  return corpus;
}
