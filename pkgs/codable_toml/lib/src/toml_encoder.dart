// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:typed_data';

import 'package:codable/codable.dart';

import 'toml_types.dart';

/// Maximum nested container depth allowed during TOML encoding.
const int _maxTomlDepth = 64;

/// Exact `2^32` (`4294967296`) for web-safe 53-bit integer range arithmetic.
const int _twoPow32 = 0x100000000;

/// Exact `Number.MAX_SAFE_INTEGER` (`2^53 - 1`, `9007199254740991`).
const int _jsMaxSafeInt = 0x1fffff * _twoPow32 + 0xffffffff;

/// Exact `Number.MIN_SAFE_INTEGER` (`-(2^53 - 1)`, `-9007199254740991`).
const int _jsMinSafeInt = -_jsMaxSafeInt;

enum _TableHeaderKind { root, standardTable, arrayOfTablesItem }

final class _TomlEncoderTrace {
  List<Object> path = const [];
}

sealed class _TomlNode {
  const _TomlNode();
}

final class _TomlScalar extends _TomlNode {
  final String literal;

  const _TomlScalar(this.literal);
}

final class _TomlArray extends _TomlNode {
  final List<TomlCodableEncoder> elements = [];
}

final class _TomlTable extends _TomlNode {
  final List<(String, TomlCodableEncoder)> entries = [];
}

final class _TomlMap extends _TomlNode {
  final List<(String, TomlCodableEncoder)> entries = [];
  _TomlMapKeyEncoder? pendingKey;
}

sealed class _ResolvedNode {
  const _ResolvedNode();
}

final class _ResolvedScalar extends _ResolvedNode {
  final String literal;
  const _ResolvedScalar(this.literal);
}

final class _ResolvedArray extends _ResolvedNode {
  final List<_ResolvedNode> elements;
  const _ResolvedArray(this.elements);
}

final class _ResolvedTable extends _ResolvedNode {
  final List<(String, _ResolvedNode)> entries;
  const _ResolvedTable(this.entries);
}

bool _isBareTomlKey(String key) {
  if (key.isEmpty) return false;
  for (var i = 0; i < key.length; i++) {
    final c = key.codeUnitAt(i);
    final isBareChar =
        (c >= 0x41 && c <= 0x5a) ||
        (c >= 0x61 && c <= 0x7a) ||
        (c >= 0x30 && c <= 0x39) ||
        c == 0x5f ||
        c == 0x2d;
    if (!isBareChar) return false;
  }
  return true;
}

bool _needsBasicStringEscape(String value) {
  for (var i = 0; i < value.length; i++) {
    final c = value.codeUnitAt(i);
    if (c < 0x20 || c >= 0x7f || c == 0x22 || c == 0x5c) return true;
  }
  return false;
}

void _writeEscapedRune(int rune, StringBuffer out, List<Object> path) {
  if (rune >= 0xd800 && rune <= 0xdfff) {
    throw TomlCodableException(
      'Invalid unpaired UTF-16 surrogate '
      '(U+${rune.toRadixString(16).toUpperCase()}) in TOML string',
      path: path,
    );
  }
  switch (rune) {
    case 0x08:
      out.write(r'\b');
    case 0x09:
      out.write(r'\t');
    case 0x0a:
      out.write(r'\n');
    case 0x0c:
      out.write(r'\f');
    case 0x0d:
      out.write(r'\r');
    case 0x22:
      out.write(r'\"');
    case 0x5c:
      out.write(r'\\');
    default:
      if (rune < 0x20 || rune == 0x7f) {
        final hex = rune.toRadixString(16).toUpperCase().padLeft(4, '0');
        out.write('\\u$hex');
      } else {
        out.writeCharCode(rune);
      }
  }
}

String _escapeTomlBasicString(String value, [List<Object> path = const []]) {
  if (!_needsBasicStringEscape(value)) return '"$value"';
  final out = StringBuffer('"');
  for (final rune in value.runes) {
    _writeEscapedRune(rune, out, path);
  }
  out.write('"');
  return out.toString();
}

String _formatTomlKey(String key) =>
    _isBareTomlKey(key) ? key : _escapeTomlBasicString(key);

String _formatTomlPath(List<String> pathSegments) =>
    pathSegments.map(_formatTomlKey).join('.');

String _formatTomlInt(int value, List<Object> path) {
  if (identical(1, 1.0) && (value < _jsMinSafeInt || value > _jsMaxSafeInt)) {
    throw TomlCodableException(
      'Integer $value exceeds JavaScript 53-bit safe integer range '
      '[$_jsMinSafeInt, $_jsMaxSafeInt]',
      path: path,
    );
  }
  return value.toString();
}

String _formatTomlDouble(double value) {
  if (value.isNaN) return 'nan';
  if (value.isInfinite) return value.isNegative ? '-inf' : 'inf';
  if (value == 0.0) return value.isNegative ? '-0.0' : '0.0';
  final s = value.toString();
  if (!s.contains('.') && !s.contains('e') && !s.contains('E')) {
    return '$s.0';
  }
  return s;
}

void _validateRawDateTime(String raw, List<Object> path) {
  if (raw.isEmpty) {
    throw TomlCodableException(
      'Invalid empty TOML date-time literal',
      path: path,
    );
  }
  for (var i = 0; i < raw.length; i++) {
    final c = raw.codeUnitAt(i);
    if (c < 0x20 || c >= 0x7f || c == 0x23) {
      throw TomlCodableException(
        'Invalid character in TOML date-time literal "$raw"',
        path: path,
      );
    }
  }
}

_ResolvedNode _resolveNode(TomlCodableEncoder encoder) {
  final node = encoder._node;
  if (node == null) {
    throw TomlCodableException(
      encoder._depth == 0
          ? 'TOML v1.0 document root must be a table, got unwritten encoder'
          : 'Encoder slot opened without writing a value',
      path: encoder._path,
    );
  }
  return switch (node) {
    _TomlScalar(:final literal) => _ResolvedScalar(literal),
    _TomlArray(:final elements) => _ResolvedArray([
      for (final elem in elements) _resolveNode(elem),
    ]),
    _TomlTable(:final entries) => _resolveTableEntries(entries, encoder._path),
    _TomlMap() => _resolveMapEntries(node, encoder._path),
  };
}

_ResolvedTable _resolveTableEntries(
  List<(String, TomlCodableEncoder)> entries,
  List<Object> tablePath,
) {
  final seenKeys = <String>{};
  final resolved = <(String, _ResolvedNode)>[];
  for (final (key, valEnc) in entries) {
    _validateTableKey(key, tablePath, seenKeys);
    resolved.add((key, _resolveNode(valEnc)));
  }
  return _ResolvedTable(resolved);
}

_ResolvedTable _resolveMapEntries(_TomlMap mapNode, List<Object> tablePath) {
  if (mapNode.pendingKey != null) {
    throw TomlCodableException(
      'Dangling key without value in TOML MapEncoder',
      path: tablePath,
    );
  }
  return _resolveTableEntries(mapNode.entries, tablePath);
}

void _validateTableKey(
  String key,
  List<Object> tablePath,
  Set<String> seenKeys,
) {
  for (final rune in key.runes) {
    if (rune >= 0xd800 && rune <= 0xdfff) {
      throw TomlCodableException(
        'Invalid unpaired UTF-16 surrogate in TOML key',
        path: [...tablePath, key],
      );
    }
  }
  if (!seenKeys.add(key)) {
    throw TomlCodableException(
      'Duplicate TOML key "$key"',
      path: [...tablePath, key],
    );
  }
}

bool _isArrayOfTables(_ResolvedArray array) =>
    array.elements.isNotEmpty &&
    array.elements.every((element) => element is _ResolvedTable);

typedef _PartitionedTable = ({
  List<(String, _ResolvedNode)> inlineEntries,
  List<(String, _ResolvedTable)> subtables,
  List<(String, List<_ResolvedTable>)> tableArrays,
});

_PartitionedTable _partitionTableEntries(
  List<(String, _ResolvedNode)> entries,
) {
  final inlineEntries = <(String, _ResolvedNode)>[];
  final subtables = <(String, _ResolvedTable)>[];
  final tableArrays = <(String, List<_ResolvedTable>)>[];
  for (final (key, value) in entries) {
    switch (value) {
      case _ResolvedTable():
        subtables.add((key, value));
      case _ResolvedArray() when _isArrayOfTables(value):
        tableArrays.add((
          key,
          [for (final elem in value.elements) elem as _ResolvedTable],
        ));
      case _ResolvedScalar() || _ResolvedArray():
        inlineEntries.add((key, value));
    }
  }
  return (
    inlineEntries: inlineEntries,
    subtables: subtables,
    tableArrays: tableArrays,
  );
}

void _emitTableSection(
  _ResolvedTable table,
  List<String> path,
  _TableHeaderKind kind,
  StringBuffer out,
) {
  final (:inlineEntries, :subtables, :tableArrays) = _partitionTableEntries(
    table.entries,
  );
  final hasChildren = subtables.isNotEmpty || tableArrays.isNotEmpty;

  if (kind == _TableHeaderKind.arrayOfTablesItem) {
    if (out.isNotEmpty) out.writeln();
    out.writeln('[[${_formatTomlPath(path)}]]');
  } else if (kind == _TableHeaderKind.standardTable &&
      (inlineEntries.isNotEmpty || !hasChildren)) {
    if (out.isNotEmpty) out.writeln();
    out.writeln('[${_formatTomlPath(path)}]');
  }

  for (final (key, value) in inlineEntries) {
    out.write('${_formatTomlKey(key)} = ');
    _emitInlineValue(value, out);
    out.writeln();
  }

  for (final (key, subtable) in subtables) {
    _emitTableSection(
      subtable,
      [...path, key],
      _TableHeaderKind.standardTable,
      out,
    );
  }

  for (final (key, items) in tableArrays) {
    final itemPath = [...path, key];
    for (final item in items) {
      _emitTableSection(
        item,
        itemPath,
        _TableHeaderKind.arrayOfTablesItem,
        out,
      );
    }
  }
}

void _emitInlineValue(_ResolvedNode node, StringBuffer out) {
  switch (node) {
    case _ResolvedScalar(:final literal):
      out.write(literal);
    case _ResolvedArray(:final elements):
      _emitInlineArray(elements, out);
    case _ResolvedTable(:final entries):
      _emitInlineTable(entries, out);
  }
}

void _emitInlineArray(List<_ResolvedNode> elements, StringBuffer out) {
  out.write('[');
  for (var i = 0; i < elements.length; i++) {
    if (i > 0) out.write(', ');
    _emitInlineValue(elements[i], out);
  }
  out.write(']');
}

void _emitInlineTable(List<(String, _ResolvedNode)> entries, StringBuffer out) {
  if (entries.isEmpty) {
    out.write('{}');
    return;
  }
  out.write('{ ');
  for (var i = 0; i < entries.length; i++) {
    if (i > 0) out.write(', ');
    final (key, value) = entries[i];
    out.write('${_formatTomlKey(key)} = ');
    _emitInlineValue(value, out);
  }
  out.write(' }');
}

/// Zero-dependency TOML v1.0 [Encoder] (`isHumanReadable => true`).
///
/// Accumulates an in-memory structural node tree while encoding so that
/// scalar and inline-array entries are always emitted before `[subtable]` and
/// `[[array_of_tables]]` sections regardless of Dart field declaration order,
/// without requiring an explicit `Encoder.close()` lifecycle method.
final class TomlCodableEncoder implements Encoder {
  @override
  final Map<Object, Object?> userInfo;

  final int _depth;
  final List<Object> _path;
  final _TomlEncoderTrace _trace;
  _TomlNode? _node;

  /// Creates a root [TomlCodableEncoder] with optional [userInfo].
  TomlCodableEncoder({this.userInfo = const {}})
    : _depth = 0,
      _path = const [],
      _trace = _TomlEncoderTrace();

  TomlCodableEncoder._(this.userInfo, this._depth, this._path, this._trace);

  /// Encodes [value] to a TOML v1.0 document string using [encodable].
  static String encode<T>(
    T value,
    Encodable<T> encodable, {
    Map<Object, Object?> userInfo = const {},
  }) {
    final encoder = TomlCodableEncoder(userInfo: userInfo);
    try {
      encodable.encode(value, encoder);
      return encoder.toTomlString();
    } on TomlCodableException {
      rethrow;
    } on CodableException catch (e) {
      throw TomlCodableException(
        e.message,
        path: e.path.isNotEmpty ? e.path : encoder._trace.path,
        underlyingError: e.underlyingError ?? e,
      );
    }
  }

  /// Encodes [value] to UTF-8 TOML v1.0 bytes using [encodable].
  static Uint8List toBytes<T>(
    T value,
    Encodable<T> encodable, {
    Map<Object, Object?> userInfo = const {},
  }) => utf8.encode(encode(value, encodable, userInfo: userInfo));

  /// Serializes the accumulated root table into canonical TOML v1.0 text.
  String toTomlString() {
    final root = _resolveNode(this);
    if (root is! _ResolvedTable) {
      throw TomlCodableException(
        'TOML v1.0 document root must be a table',
        path: _path,
      );
    }
    final out = StringBuffer();
    _emitTableSection(root, const [], _TableHeaderKind.root, out);
    return out.toString();
  }

  @override
  bool get isHumanReadable => true;

  TomlCodableEncoder _spawnChild(Object segment) {
    final nextPath = <Object>[..._path, segment];
    _trace.path = nextPath;
    return TomlCodableEncoder._(userInfo, _depth + 1, nextPath, _trace);
  }

  void _ensureWritableContainer() {
    if (_node != null) {
      throw TomlCodableException(
        'Encoder value already written at scope',
        path: _path,
      );
    }
    if (_depth >= _maxTomlDepth) {
      throw TomlCodableException(
        'TOML nesting depth exceeds limit of $_maxTomlDepth',
        path: _path,
      );
    }
  }

  void _setScalar(_TomlScalar scalar) {
    if (_node != null) {
      throw TomlCodableException(
        'Encoder value already written at scope',
        path: _path,
      );
    }
    if (_depth == 0) {
      throw TomlCodableException(
        'TOML v1.0 document root must be a table, not a scalar value',
        path: _path,
      );
    }
    _node = scalar;
  }

  @override
  KeyedEncoder keyed({KeyOptions? options, int? length}) {
    _ensureWritableContainer();
    final table = _TomlTable();
    _node = table;
    return _TomlKeyedEncoder(this, table);
  }

  @override
  UnkeyedEncoder unkeyed({int? length}) {
    if (_depth == 0) {
      throw TomlCodableException(
        'TOML v1.0 document root must be a table, not an array',
        path: _path,
      );
    }
    _ensureWritableContainer();
    final array = _TomlArray();
    _node = array;
    return _TomlUnkeyedEncoder(this, array);
  }

  @override
  MapEncoder map({int? length}) {
    _ensureWritableContainer();
    final mapNode = _TomlMap();
    _node = mapNode;
    return _TomlMapEncoder(this, mapNode);
  }

  @override
  SingleValueEncoder singleValue() => _TomlSingleValueEncoder(this);
}

final class _TomlKeyedEncoder
    with BaseKeyedEncoderMixin
    implements KeyedEncoder {
  final TomlCodableEncoder _owner;
  final _TomlTable _table;

  _TomlKeyedEncoder(this._owner, this._table);

  void _putScalar(String key, _TomlScalar scalar) {
    final child = _owner._spawnChild(key).._node = scalar;
    _table.entries.add((key, child));
  }

  @override
  void encodeInt(String key, int value) {
    final path = [..._owner._path, key];
    _putScalar(key, _TomlScalar(_formatTomlInt(value, path)));
  }

  @override
  void encodeDouble(String key, double value) =>
      _putScalar(key, _TomlScalar(_formatTomlDouble(value)));

  @override
  void encodeString(String key, String value) {
    final path = [..._owner._path, key];
    _putScalar(key, _TomlScalar(_escapeTomlBasicString(value, path)));
  }

  @override
  void encodeBool(String key, bool value) =>
      _putScalar(key, _TomlScalar(value ? 'true' : 'false'));

  @override
  void encodeNull(String key) {
    throw TomlCodableException(
      'TOML v1.0 does not support null values (for key "$key")',
      path: [..._owner._path, key],
    );
  }

  @override
  Encoder nestedEncoder(String key) {
    final child = _owner._spawnChild(key);
    _table.entries.add((key, child));
    return child;
  }
}

final class _TomlUnkeyedEncoder
    with BaseUnkeyedEncoderMixin
    implements UnkeyedEncoder {
  final TomlCodableEncoder _owner;
  final _TomlArray _array;

  _TomlUnkeyedEncoder(this._owner, this._array);

  void _addScalar(int index, _TomlScalar scalar) {
    final child = _owner._spawnChild(index).._node = scalar;
    _array.elements.add(child);
  }

  @override
  void encodeInt(int value) {
    final index = _array.elements.length;
    final path = [..._owner._path, index];
    _addScalar(index, _TomlScalar(_formatTomlInt(value, path)));
  }

  @override
  void encodeDouble(double value) {
    final index = _array.elements.length;
    _addScalar(index, _TomlScalar(_formatTomlDouble(value)));
  }

  @override
  void encodeString(String value) {
    final index = _array.elements.length;
    final path = [..._owner._path, index];
    _addScalar(index, _TomlScalar(_escapeTomlBasicString(value, path)));
  }

  @override
  void encodeBool(bool value) {
    final index = _array.elements.length;
    _addScalar(index, _TomlScalar(value ? 'true' : 'false'));
  }

  @override
  void encodeNull() {
    final index = _array.elements.length;
    throw TomlCodableException(
      'TOML v1.0 arrays cannot contain null elements',
      path: [..._owner._path, index],
    );
  }

  @override
  Encoder nestedEncoder() {
    final index = _array.elements.length;
    final child = _owner._spawnChild(index);
    _array.elements.add(child);
    return child;
  }
}

final class _TomlMapEncoder implements MapEncoder {
  final TomlCodableEncoder _owner;
  final _TomlMap _map;

  _TomlMapEncoder(this._owner, this._map);

  @override
  Encoder keyEncoder() {
    if (_map.pendingKey != null) {
      throw TomlCodableException(
        'MapEncoder.keyEncoder() called before valueEncoder()',
        path: _owner._path,
      );
    }
    final index = _map.entries.length;
    final keyPath = <Object>[..._owner._path, index];
    _owner._trace.path = keyPath;
    final keyEnc = _TomlMapKeyEncoder(_owner.userInfo, keyPath);
    _map.pendingKey = keyEnc;
    return keyEnc;
  }

  @override
  Encoder valueEncoder() {
    final keyEnc = _map.pendingKey;
    if (keyEnc == null) {
      throw TomlCodableException(
        'MapEncoder.valueEncoder() called before keyEncoder()',
        path: _owner._path,
      );
    }
    _map.pendingKey = null;
    final keyText = keyEnc._key;
    if (keyText == null) {
      throw TomlCodableException(
        'TOML map key encoder did not write a key',
        path: keyEnc._path,
      );
    }
    final valEnc = _owner._spawnChild(keyText);
    _map.entries.add((keyText, valEnc));
    return valEnc;
  }
}

final class _TomlMapKeyEncoder
    with BaseStringMapKeyEncoderMixin
    implements Encoder, SingleValueEncoder {
  @override
  final Map<Object, Object?> userInfo;
  final List<Object> _path;
  String? _key;

  _TomlMapKeyEncoder(this.userInfo, this._path);

  @override
  String get formatName => 'TOML';

  @override
  bool get hasWrittenKey => _key != null;

  @override
  void writeKeyString(String key) {
    if (_key != null) {
      throw TomlCodableException(
        'Encoder value already written at scope',
        path: _path,
      );
    }
    _key = key;
  }

  @override
  void encodeInt(int value) => writeKeyString(_formatTomlInt(value, _path));

  @override
  void encodeDouble(double value) {
    if (!value.isFinite) {
      throw TomlCodableException(
        'TOML map keys must be finite numbers, got $value',
        path: _path,
      );
    }
    writeKeyString(_formatTomlDouble(value));
  }
}

final class _TomlSingleValueEncoder
    with BaseSingleValueEncoderMixin
    implements SingleValueEncoder, TomlNativeDateTimeSink {
  final TomlCodableEncoder _parent;

  _TomlSingleValueEncoder(this._parent);

  @override
  void encodeInt(int value) {
    final text = _formatTomlInt(value, _parent._path);
    _parent._setScalar(_TomlScalar(text));
  }

  @override
  void encodeDouble(double value) =>
      _parent._setScalar(_TomlScalar(_formatTomlDouble(value)));

  @override
  void encodeString(String value) {
    _parent._setScalar(
      _TomlScalar(_escapeTomlBasicString(value, _parent._path)),
    );
  }

  @override
  void encodeBool(bool value) =>
      _parent._setScalar(_TomlScalar(value ? 'true' : 'false'));

  @override
  void encodeBytes(Uint8List value) {
    _parent._setScalar(
      _TomlScalar(_escapeTomlBasicString(base64Encode(value))),
    );
  }

  @override
  void encodeNull() {
    throw TomlCodableException(
      'TOML v1.0 does not support null values',
      path: _parent._path,
    );
  }

  @override
  void writeTomlDateTime(TomlDateTime value) {
    _validateRawDateTime(value.raw, _parent._path);
    _parent._setScalar(_TomlScalar(value.raw));
  }

  @override
  void encode<T>(T value, Encodable<T> encodable) =>
      encodable.encode(value, _parent);
}
