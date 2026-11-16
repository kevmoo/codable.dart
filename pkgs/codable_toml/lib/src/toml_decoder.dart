// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:typed_data';

import 'package:codable/codable.dart';

import 'toml_parser.dart';
import 'toml_types.dart';

Map<String, int> _compileTomlKeyMap(List<String> keys) => <String, int>{
  for (var i = 0; i < keys.length; i++) keys[i]: i,
};

bool _startsWithPath(List<Object> full, List<Object> prefix) {
  if (full.length < prefix.length) return false;
  for (var i = 0; i < prefix.length; i++) {
    if (full[i] != prefix[i]) return false;
  }
  return true;
}

List<Object> _mergePaths(List<Object> prefix, List<Object> suffix) {
  if (suffix.isEmpty) return List<Object>.unmodifiable(prefix);
  if (prefix.isEmpty || _startsWithPath(suffix, prefix)) {
    return List<Object>.unmodifiable(suffix);
  }
  return List<Object>.unmodifiable(<Object>[...prefix, ...suffix]);
}

TomlCodableException _enrichTomlException(
  TomlCodableException e,
  _TomlTrace trace,
) {
  final mergedPath = _mergePaths(trace.path, e.path);
  if (e.line != null &&
      e.column != null &&
      mergedPath.length == e.path.length) {
    return e;
  }
  final (traceLine, traceCol) = computeTomlLineColumn(
    trace.source,
    trace.offset,
  );
  return TomlCodableException(
    e.message,
    line: e.line ?? traceLine,
    column: e.column ?? traceCol,
    path: mergedPath,
    actualValue: e.actualValue,
    underlyingError: e.underlyingError,
  );
}

ValueKind _tomlNodeKind(TomlNode node) => switch (node) {
  TomlBool() => ValueKind.boolean,
  TomlInt() || TomlFloat() => ValueKind.number,
  TomlString() || TomlDateTimeValue() => ValueKind.string,
  TomlArray() => ValueKind.list,
  TomlTable() => ValueKind.map,
};

Object? _tomlNodeActualValue(TomlNode node) => switch (node) {
  TomlBool(:final value) => value,
  TomlInt(:final value) => value,
  TomlFloat(:final value) => value,
  TomlString(:final value) => value,
  TomlDateTimeValue(:final value) => value,
  TomlArray() || TomlTable() => null,
};

String _describeTomlNode(TomlNode node) => switch (node) {
  TomlBool(:final value) => 'boolean ($value)',
  TomlInt(:final value) => 'integer ($value)',
  TomlFloat(:final value) => 'float ($value)',
  TomlString(:final value) => 'string ("$value")',
  TomlDateTimeValue(:final value) => '${value.kind.name} (${value.raw})',
  TomlArray() => 'array',
  TomlTable() => 'table',
};

final class _TomlTrace {
  final String source;
  int offset;
  List<Object> path = const <Object>[];

  _TomlTrace(this.source, {this.offset = 0});

  void set(int nextOffset, List<Object> nextPath) {
    offset = nextOffset;
    path = nextPath;
  }

  Never fail(
    String message, {
    int? atOffset,
    List<Object>? atPath,
    Object? actualValue,
    Object? underlyingError,
  }) {
    final (line, column) = computeTomlLineColumn(source, atOffset ?? offset);
    throw TomlCodableException(
      message,
      line: line,
      column: column,
      path: List<Object>.unmodifiable(atPath ?? path),
      actualValue: actualValue,
      underlyingError: underlyingError,
    );
  }
}

void _checkDecoderDepth(int depth, _TomlTrace trace) {
  if (depth >= maxTomlDepth) {
    trace.fail('TOML decoder nesting depth exceeds limit of $maxTomlDepth');
  }
}

int _readTomlInt(TomlNode node, _TomlTrace trace) {
  if (node is TomlInt) return node.value;
  trace.fail(
    'Expected int, got TOML ${_describeTomlNode(node)}',
    atOffset: node.offset,
    actualValue: _tomlNodeActualValue(node),
  );
}

double _readTomlDouble(TomlNode node, _TomlTrace trace) {
  if (node is TomlFloat) return node.value;
  if (node is TomlInt) return node.value.toDouble();
  trace.fail(
    'Expected double, got TOML ${_describeTomlNode(node)}',
    atOffset: node.offset,
    actualValue: _tomlNodeActualValue(node),
  );
}

num _readTomlNum(TomlNode node, _TomlTrace trace) {
  if (node is TomlInt) return node.value;
  if (node is TomlFloat) return node.value;
  trace.fail(
    'Expected num, got TOML ${_describeTomlNode(node)}',
    atOffset: node.offset,
    actualValue: _tomlNodeActualValue(node),
  );
}

String _readTomlString(TomlNode node, _TomlTrace trace) {
  if (node is TomlString) return node.value;
  if (node is TomlDateTimeValue) return node.value.raw;
  trace.fail(
    'Expected String, got TOML ${_describeTomlNode(node)}',
    atOffset: node.offset,
    actualValue: _tomlNodeActualValue(node),
  );
}

bool _readTomlBool(TomlNode node, _TomlTrace trace) {
  if (node is TomlBool) return node.value;
  trace.fail(
    'Expected bool, got TOML ${_describeTomlNode(node)}',
    atOffset: node.offset,
    actualValue: _tomlNodeActualValue(node),
  );
}

Uint8List _readTomlBytes(
  TomlNode node,
  List<Object> nodePath,
  _TomlTrace trace,
) {
  if (node is TomlString) {
    try {
      return base64Decode(node.value);
    } on FormatException catch (e) {
      trace.fail(
        'Invalid base64 string for bytes: ${e.message}',
        atOffset: node.offset,
        atPath: nodePath,
        actualValue: node.value,
        underlyingError: e,
      );
    }
  }
  if (node is TomlArray) {
    final items = node.items;
    final out = Uint8List(items.length);
    for (var i = 0; i < items.length; i++) {
      final elem = items[i];
      if (elem is! TomlInt || elem.value < 0 || elem.value > 255) {
        trace.fail(
          'Expected byte integer in range 0..255, got TOML ${_describeTomlNode(elem)}',
          atOffset: elem.offset,
          atPath: <Object>[...nodePath, i],
          actualValue: _tomlNodeActualValue(elem),
        );
      }
      out[i] = elem.value;
    }
    return out;
  }
  trace.fail(
    'Expected base64 string or byte list, got TOML ${_describeTomlNode(node)}',
    atOffset: node.offset,
    atPath: nodePath,
    actualValue: _tomlNodeActualValue(node),
  );
}

String _decodeUtf8Toml(Uint8List utf8Bytes) {
  try {
    return utf8.decode(utf8Bytes);
  } on FormatException catch (e) {
    throw TomlCodableException(
      'Invalid UTF-8 in TOML input: ${e.message}',
      underlyingError: e,
    );
  }
}

/// Zero-dependency TOML v1.0 [Decoder] (`isHumanReadable => true`).
final class TomlCodableDecoder implements Decoder, TomlNativeDateTimeSource {
  final TomlNode _node;
  final List<Object> _path;
  final _TomlTrace _trace;
  final int _depth;

  @override
  final Map<Object, Object?> userInfo;

  TomlCodableDecoder._(
    this._node,
    this._path,
    this._trace,
    this._depth, {
    required this.userInfo,
  });

  /// Parses [toml] as a TOML v1.0 document and returns a root
  /// [TomlCodableDecoder].
  factory TomlCodableDecoder.fromString(
    String toml, {
    Map<Object, Object?> userInfo = const <Object, Object?>{},
  }) {
    final root = parseTomlDocument(toml);
    final trace = _TomlTrace(toml, offset: root.offset);
    return TomlCodableDecoder._(
      root,
      const <Object>[],
      trace,
      0,
      userInfo: userInfo,
    );
  }

  /// Validates [utf8Bytes] as UTF-8, parses the TOML v1.0 document, and returns
  /// a root [TomlCodableDecoder].
  factory TomlCodableDecoder.fromBytes(
    Uint8List utf8Bytes, {
    Map<Object, Object?> userInfo = const <Object, Object?>{},
  }) => TomlCodableDecoder.fromString(
    _decodeUtf8Toml(utf8Bytes),
    userInfo: userInfo,
  );

  /// Parses [toml] and decodes [decodable], reporting 1-based `line`, `column`,
  /// and hierarchical `path` via [TomlCodableException] on syntax or schema
  /// mismatches.
  static T decode<T>(
    String toml,
    Decodable<T> decodable, {
    Map<Object, Object?> userInfo = const <Object, Object?>{},
  }) {
    final decoder = TomlCodableDecoder.fromString(toml, userInfo: userInfo);
    return _runDecode(decoder, decodable);
  }

  /// Validates [utf8Bytes] as UTF-8, parses the TOML v1.0 document, and decodes
  /// [decodable].
  static T decodeBytes<T>(
    Uint8List utf8Bytes,
    Decodable<T> decodable, {
    Map<Object, Object?> userInfo = const <Object, Object?>{},
  }) {
    final decoder = TomlCodableDecoder.fromBytes(utf8Bytes, userInfo: userInfo);
    return _runDecode(decoder, decodable);
  }

  static T _runDecode<T>(TomlCodableDecoder decoder, Decodable<T> decodable) {
    try {
      return decodable.decode(decoder);
    } on TomlCodableException catch (e) {
      final enriched = _enrichTomlException(e, decoder._trace);
      if (identical(enriched, e)) rethrow;
      throw enriched;
    } on CodableException catch (e) {
      decoder._trace.fail(
        e.message,
        atPath: _mergePaths(decoder._trace.path, e.path),
        actualValue: e.actualValue,
        underlyingError: e.underlyingError ?? e,
      );
    } on FormatException catch (e) {
      decoder._trace.fail(e.message, underlyingError: e);
    }
  }

  @override
  bool get isHumanReadable => true;

  @override
  Uint8List? get payload => null;

  @override
  Float64List? decodeUniformDoubleList(List<List<String>> propertyAliases) =>
      null;

  @override
  ValueKind peekKind() {
    _trace.set(_node.offset, _path);
    return _tomlNodeKind(_node);
  }

  @override
  TomlDateTime? tryReadTomlDateTime() {
    _trace.set(_node.offset, _path);
    final node = _node;
    return node is TomlDateTimeValue ? node.value : null;
  }

  TomlTable _requireTable(String containerName) {
    _trace.set(_node.offset, _path);
    final node = _node;
    if (node is TomlTable) return node;
    _trace.fail(
      'Expected TOML table for $containerName(), got ${_describeTomlNode(node)}',
      atOffset: node.offset,
    );
  }

  @override
  KeyedDecoder keyed({KeyOptions? options}) {
    final table = _requireTable('keyed');
    _checkDecoderDepth(_depth, _trace);
    return _TomlKeyedDecoder(table, _path, _trace, _depth + 1, userInfo);
  }

  @override
  MappedDecoder mapped() {
    final table = _requireTable('mapped');
    _checkDecoderDepth(_depth, _trace);
    return _TomlMappedDecoder(table, _path, _trace, _depth + 1, userInfo);
  }

  @override
  MapDecoder map() {
    final table = _requireTable('map');
    _checkDecoderDepth(_depth, _trace);
    return _TomlMapDecoder(table, _path, _trace, _depth + 1, userInfo);
  }

  @override
  UnkeyedDecoder unkeyed() {
    _trace.set(_node.offset, _path);
    final node = _node;
    if (node is! TomlArray) {
      _trace.fail(
        'Expected TOML array for unkeyed(), got ${_describeTomlNode(node)}',
        atOffset: node.offset,
      );
    }
    _checkDecoderDepth(_depth, _trace);
    return _TomlUnkeyedDecoder(node, _path, _trace, _depth + 1, userInfo);
  }

  @override
  SingleValueDecoder singleValue() {
    _trace.set(_node.offset, _path);
    return _TomlSingleValueDecoder(_node, _path, _trace, _depth, userInfo);
  }
}

mixin _TomlSequentialValueMixin {
  _TomlTrace get _trace;
  Map<Object, Object?> get _userInfo;
  int get _childDepth;

  TomlNode _peekNode();
  List<Object> _peekPath();
  void _consumeCurrent();

  TomlNode _takeNode() {
    final node = _peekNode();
    _consumeCurrent();
    return node;
  }

  ValueKind peekKind() => _tomlNodeKind(_peekNode());

  void readNull() {
    final node = _peekNode();
    _trace.fail(
      'TOML v1.0 has no null values; got ${_describeTomlNode(node)}',
      atOffset: node.offset,
      actualValue: _tomlNodeActualValue(node),
    );
  }

  int readInt() => _readTomlInt(_takeNode(), _trace);

  double readDouble() => _readTomlDouble(_takeNode(), _trace);

  num readNum() => _readTomlNum(_takeNode(), _trace);

  String readString() => _readTomlString(_takeNode(), _trace);

  bool readBool() => _readTomlBool(_takeNode(), _trace);

  Uint8List readBytes() {
    final path = _peekPath();
    final node = _takeNode();
    return _readTomlBytes(node, path, _trace);
  }

  int selectStringIndex(KeyOptions options) {
    final value = readString();
    return options.compiled<Map<String, int>>(_compileTomlKeyMap)[value] ?? -1;
  }

  Decoder nestedDecoder() {
    final path = _peekPath();
    final node = _takeNode();
    return TomlCodableDecoder._(
      node,
      path,
      _trace,
      _childDepth,
      userInfo: _userInfo,
    );
  }
}

final class _TomlKeyedDecoder
    with BaseKeyedDecoderMixin, _TomlSequentialValueMixin
    implements KeyedDecoder {
  final TomlTable _table;
  final List<Object> _parentPath;
  @override
  final _TomlTrace _trace;
  @override
  final int _childDepth;
  @override
  final Map<Object, Object?> _userInfo;
  late final List<TomlEntry> _entries = _table.entries.values.toList(
    growable: false,
  );

  int _index = 0;
  int _phase = 0; // 0 = idle, 1 = atKey, 2 = atValue
  TomlEntry? _activeEntry;
  List<Object> _activePath = const <Object>[];

  _TomlKeyedDecoder(
    this._table,
    this._parentPath,
    this._trace,
    this._childDepth,
    this._userInfo,
  );

  @override
  bool moveNextKey() {
    if (_phase == 1) return true;
    _phase = 0;
    if (_index >= _entries.length) {
      _trace.set(_table.offset, _parentPath);
      return false;
    }
    final entry = _entries[_index++];
    _activeEntry = entry;
    _activePath = <Object>[..._parentPath, entry.key];
    _phase = 1;
    _trace.set(entry.value.offset, _activePath);
    return true;
  }

  @override
  String nextKey() {
    if (!moveNextKey()) {
      _trace.fail('No more keys in TOML table', atOffset: _table.offset);
    }
    _phase = 2;
    return _activeEntry!.key;
  }

  @override
  String? peekKey() => moveNextKey() ? _activeEntry!.key : null;

  @override
  int selectKeyIndex(KeyOptions options) {
    if (!moveNextKey()) return -1;
    _phase = 2;
    final map = options.compiled<Map<String, int>>(_compileTomlKeyMap);
    return map[_activeEntry!.key] ?? -1;
  }

  @override
  TomlNode _peekNode() {
    if (_phase == 0 && !moveNextKey()) {
      _trace.fail('No more keys in TOML table', atOffset: _table.offset);
    }
    final node = _activeEntry!.value;
    _trace.set(node.offset, _activePath);
    return node;
  }

  @override
  List<Object> _peekPath() {
    if (_phase == 0 && !moveNextKey()) {
      _trace.fail('No more keys in TOML table', atOffset: _table.offset);
    }
    return _activePath;
  }

  @override
  void _consumeCurrent() {
    _phase = 0;
  }

  @override
  void skipValue() {
    if (_phase != 0 || moveNextKey()) _phase = 0;
  }
}

final class _TomlMappedDecoder
    with BaseMappedDecoderMixin
    implements MappedDecoder {
  final TomlTable _table;
  final List<Object> _parentPath;
  final _TomlTrace _trace;
  final int _childDepth;
  final Map<Object, Object?> _userInfo;

  _TomlMappedDecoder(
    this._table,
    this._parentPath,
    this._trace,
    this._childDepth,
    this._userInfo,
  );

  TomlEntry? _lookupEntry(String key) {
    final entry = _table.entries[key];
    if (entry != null) {
      _trace.set(entry.value.offset, <Object>[..._parentPath, key]);
    } else {
      _trace.set(_table.offset, _parentPath);
    }
    return entry;
  }

  TomlEntry _requireEntry(String key) {
    final entry = _lookupEntry(key);
    if (entry != null) return entry;
    _trace.fail(
      'Missing required key: "$key"',
      atOffset: _table.offset,
      atPath: <Object>[..._parentPath, key],
    );
  }

  @override
  bool containsKey(String key) => _lookupEntry(key) != null;

  @override
  ValueKind peekKind(String key) {
    final entry = _lookupEntry(key);
    return entry == null ? ValueKind.nullValue : _tomlNodeKind(entry.value);
  }

  @override
  int readInt(String key) => _readTomlInt(_requireEntry(key).value, _trace);

  @override
  double readDouble(String key) =>
      _readTomlDouble(_requireEntry(key).value, _trace);

  @override
  num readNum(String key) => _readTomlNum(_requireEntry(key).value, _trace);

  @override
  String readString(String key) =>
      _readTomlString(_requireEntry(key).value, _trace);

  @override
  bool readBool(String key) => _readTomlBool(_requireEntry(key).value, _trace);

  @override
  Uint8List readBytes(String key) {
    final entry = _requireEntry(key);
    return _readTomlBytes(entry.value, <Object>[..._parentPath, key], _trace);
  }

  @override
  Decoder nestedDecoder(String key) {
    final entry = _requireEntry(key);
    return TomlCodableDecoder._(
      entry.value,
      <Object>[..._parentPath, key],
      _trace,
      _childDepth,
      userInfo: _userInfo,
    );
  }
}

final class _TomlMapDecoder implements MapDecoder {
  final TomlTable _table;
  final List<Object> _parentPath;
  final _TomlTrace _trace;
  final int _childDepth;
  final Map<Object, Object?> _userInfo;
  late final List<TomlEntry> _entries = _table.entries.values.toList(
    growable: false,
  );
  late final StringMapKeyDecoder _keyDecoder = StringMapKeyDecoder(
    _userInfo,
    formatName: 'TOML',
  );

  int _index = -1;

  _TomlMapDecoder(
    this._table,
    this._parentPath,
    this._trace,
    this._childDepth,
    this._userInfo,
  );

  @override
  int get length => _entries.length;

  @override
  bool moveNextEntry() {
    final next = _index + 1;
    if (next >= _entries.length) {
      _trace.set(_table.offset, _parentPath);
      return false;
    }
    _index = next;
    return true;
  }

  TomlEntry _currentEntry() {
    if (_index < 0 || _index >= _entries.length) {
      _trace.fail(
        'MapDecoder cursor not positioned at an entry',
        atOffset: _table.offset,
        atPath: _parentPath,
      );
    }
    return _entries[_index];
  }

  @override
  Decoder keyDecoder() {
    final entry = _currentEntry();
    final path = <Object>[..._parentPath, entry.key];
    _trace.set(entry.keyOffset, path);
    _keyDecoder.key = entry.key;
    return _keyDecoder;
  }

  @override
  Decoder valueDecoder() {
    final entry = _currentEntry();
    final path = <Object>[..._parentPath, entry.key];
    _trace.set(entry.value.offset, path);
    return TomlCodableDecoder._(
      entry.value,
      path,
      _trace,
      _childDepth,
      userInfo: _userInfo,
    );
  }
}

final class _TomlUnkeyedDecoder
    with BaseUnkeyedDecoderMixin, _TomlSequentialValueMixin
    implements UnkeyedDecoder {
  final TomlArray _array;
  final List<Object> _parentPath;
  @override
  final _TomlTrace _trace;
  @override
  final int _childDepth;
  @override
  final Map<Object, Object?> _userInfo;

  int _index = -1;
  bool _hasActive = false;

  _TomlUnkeyedDecoder(
    this._array,
    this._parentPath,
    this._trace,
    this._childDepth,
    this._userInfo,
  );

  @override
  int get length => _array.items.length;

  @override
  bool moveNext() {
    if (_hasActive) return true;
    final next = _index + 1;
    if (next >= _array.items.length) {
      _trace.set(_array.offset, _parentPath);
      return false;
    }
    _index = next;
    _hasActive = true;
    _trace.set(_array.items[_index].offset, <Object>[..._parentPath, _index]);
    return true;
  }

  @override
  TomlNode _peekNode() {
    if (!_hasActive && !moveNext()) {
      _trace.fail('No more elements in TOML array', atOffset: _array.offset);
    }
    final node = _array.items[_index];
    _trace.set(node.offset, <Object>[..._parentPath, _index]);
    return node;
  }

  @override
  List<Object> _peekPath() {
    if (!_hasActive && !moveNext()) {
      _trace.fail('No more elements in TOML array', atOffset: _array.offset);
    }
    return <Object>[..._parentPath, _index];
  }

  @override
  void _consumeCurrent() {
    _hasActive = false;
  }

  @override
  void skipElement() {
    _takeNode();
  }
}

final class _TomlSingleValueDecoder
    with BaseSingleValueDecoderMixin, _TomlSequentialValueMixin
    implements SingleValueDecoder, TomlNativeDateTimeSource {
  final TomlNode _node;
  final List<Object> _path;
  @override
  final _TomlTrace _trace;
  @override
  final int _childDepth;
  @override
  final Map<Object, Object?> _userInfo;

  _TomlSingleValueDecoder(
    this._node,
    this._path,
    this._trace,
    this._childDepth,
    this._userInfo,
  );

  @override
  TomlDateTime? tryReadTomlDateTime() {
    _trace.set(_node.offset, _path);
    final node = _node;
    return node is TomlDateTimeValue ? node.value : null;
  }

  @override
  TomlNode _peekNode() {
    _trace.set(_node.offset, _path);
    return _node;
  }

  @override
  List<Object> _peekPath() => _path;

  @override
  void _consumeCurrent() {}
}

/// Lossless [Codable] companion for [TomlDateTime] across all four TOML v1.0
/// date/time wire kinds (`offsetDateTime`, `localDateTime`, `localDate`, and
/// `localTime`).
///
/// Emits unquoted native TOML literals on `TomlCodableEncoder` and canonical
/// TOML literal strings on non-TOML drivers.
final class TomlDateTimeCodable implements Codable<TomlDateTime> {
  /// Creates a `const` [TomlDateTimeCodable].
  const TomlDateTimeCodable();

  @override
  TomlDateTime decode(Decoder decoder) {
    final sv = decoder.singleValue();
    if (sv case final TomlNativeDateTimeSource source) {
      final dt = source.tryReadTomlDateTime();
      if (dt != null) return dt;
      final actual = sv is _TomlSingleValueDecoder
          ? _tomlNodeActualValue(sv._node)
          : null;
      throw TomlCodableException(
        'Expected native TOML date-time literal, got ${sv.peekKind()}',
        actualValue: actual,
      );
    }
    return parseTomlDateTimeLiteral(sv.readString());
  }

  @override
  void encode(TomlDateTime value, Encoder encoder) {
    final sv = encoder.singleValue();
    if (sv case final TomlNativeDateTimeSink sink) {
      sink.writeTomlDateTime(value);
      return;
    }
    sv.encodeString(value.raw);
  }
}
