// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:codable/codable.dart';
import 'package:yaml/yaml.dart';

import 'yaml_exception.dart';

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
  return List<Object>.unmodifiable([...prefix, ...suffix]);
}

final class _YamlTrace {
  YamlNode node;
  List<Object> path = const [];

  _YamlTrace(this.node);

  void set(YamlNode nextNode, List<Object> nextPath) {
    node = nextNode;
    path = nextPath;
  }
}

ValueKind _yamlNodeKind(YamlNode node) => switch (node) {
  final YamlMap _ => ValueKind.map,
  final YamlList _ => ValueKind.list,
  YamlScalar(:final value) => switch (value) {
    null => ValueKind.nullValue,
    final bool _ => ValueKind.boolean,
    final num _ => ValueKind.number,
    final String _ => ValueKind.string,
    _ => throw CodableException('Unsupported YAML scalar value: $value'),
  },
  _ => throw CodableException('Unsupported YAML node: ${node.runtimeType}'),
};

Object? _scalarValue(YamlNode node) => node is YamlScalar ? node.value : node;

const int _yamlTwoPow32 = 0x100000000;
const int _yamlJsMaxSafeInt = 0x1fffff * _yamlTwoPow32 + 0xffffffff;
const int _yamlJsMinSafeInt = -_yamlJsMaxSafeInt;
final BigInt _bigJsMaxSafeInt = BigInt.from(_yamlJsMaxSafeInt);
final BigInt _bigJsMinSafeInt = BigInt.from(_yamlJsMinSafeInt);

final RegExp _yamlPlainHexPrefix = RegExp(r'^[+-]?0[xX]');

bool _isPlainYamlFloatOnJs(YamlNode node) {
  if (!identical(1.0, 1) || node is! YamlScalar) return false;
  if (node.style != ScalarStyle.PLAIN) return false;
  final text = node.span.text;
  if (_yamlPlainHexPrefix.hasMatch(text)) return false;
  return text.contains('.') || text.contains('e') || text.contains('E');
}

String _extractYamlScalarToken(String raw) {
  var s = raw.trim();
  while (s.startsWith('!') || s.startsWith('&')) {
    final space = s.indexOf(RegExp(r'\s'));
    if (space < 0) break;
    s = s.substring(space + 1).trimLeft();
  }
  if (s.length >= 2 &&
      ((s.startsWith('"') && s.endsWith('"')) ||
          (s.startsWith("'") && s.endsWith("'")))) {
    s = s.substring(1, s.length - 1);
  }
  return s.contains('_') ? s.replaceAll('_', '') : s;
}

BigInt? _tryParseYamlBigInt(String raw) {
  final s = _extractYamlScalarToken(raw);
  if (s.isEmpty) return null;
  final isNeg = s.startsWith('-');
  final body = (isNeg || s.startsWith('+')) ? s.substring(1) : s;
  if (body.isEmpty) return null;
  final (radix, digits) = _radixAndDigits(body);
  if (digits.isEmpty || digits.startsWith('-') || digits.startsWith('+')) {
    return null;
  }
  final magnitude = BigInt.tryParse(digits, radix: radix);
  if (magnitude == null) return null;
  return isNeg ? -magnitude : magnitude;
}

(int, String) _radixAndDigits(String body) {
  if (body.startsWith('0x') || body.startsWith('0X')) {
    return (16, body.substring(2));
  }
  if (body.startsWith('0o') || body.startsWith('0O')) {
    return (8, body.substring(2));
  }
  if (body.startsWith('0b') || body.startsWith('0B')) {
    return (2, body.substring(2));
  }
  return (10, body);
}

void _checkJsYamlSafeInt(YamlNode node, int v) {
  if (node is YamlScalar) {
    final raw = node.span.text;
    final big = _tryParseYamlBigInt(raw);
    if (big != null && (big < _bigJsMinSafeInt || big > _bigJsMaxSafeInt)) {
      throw CodableException(
        'YAML integer $raw exceeds JavaScript 53-bit safe integer range '
        '[$_yamlJsMinSafeInt, $_yamlJsMaxSafeInt]',
        actualValue: raw,
      );
    }
  }
  if (v < _yamlJsMinSafeInt || v > _yamlJsMaxSafeInt) {
    throw CodableException(
      'YAML integer $v exceeds JavaScript 53-bit safe integer range '
      '[$_yamlJsMinSafeInt, $_yamlJsMaxSafeInt]',
      actualValue: v,
    );
  }
}

int _coerceYamlStringToInt(String v) {
  if (identical(1.0, 1)) {
    final big = _tryParseYamlBigInt(v);
    if (big == null) {
      throw CodableException.typeMismatch(expectedType: int, actualValue: v);
    }
    if (big < _bigJsMinSafeInt || big > _bigJsMaxSafeInt) {
      throw CodableException(
        'YAML integer $v exceeds JavaScript 53-bit safe integer range '
        '[$_yamlJsMinSafeInt, $_yamlJsMaxSafeInt]',
        actualValue: v,
      );
    }
    return big.toInt();
  }
  final parsed = int.tryParse(v);
  if (parsed != null) return parsed;
  throw CodableException.typeMismatch(expectedType: int, actualValue: v);
}

int _readYamlInt(YamlNode node, {bool coerceString = false}) {
  final v = _scalarValue(node);
  if (v is int && !_isPlainYamlFloatOnJs(node)) {
    if (identical(1.0, 1)) _checkJsYamlSafeInt(node, v);
    return v;
  }
  if (coerceString && v is String) return _coerceYamlStringToInt(v);
  throw CodableException.typeMismatch(expectedType: int, actualValue: v);
}

double _readYamlDouble(YamlNode node, {bool coerceString = false}) {
  final v = _scalarValue(node);
  if (v is num) return v.toDouble();
  if (coerceString && v is String) {
    final parsed = double.tryParse(v);
    if (parsed != null) return parsed;
  }
  throw CodableException.typeMismatch(expectedType: double, actualValue: v);
}

num _readYamlNum(YamlNode node, {bool coerceString = false}) {
  final v = _scalarValue(node);
  if (v is num) return v;
  if (coerceString && v is String) {
    final parsed = num.tryParse(v);
    if (parsed != null) return parsed;
  }
  throw CodableException.typeMismatch(expectedType: num, actualValue: v);
}

String _readYamlString(YamlNode node) {
  final v = _scalarValue(node);
  if (v is String) return v;
  throw CodableException.typeMismatch(expectedType: String, actualValue: v);
}

bool _readYamlBool(YamlNode node, {bool coerceString = false}) {
  final v = _scalarValue(node);
  if (v is bool) return v;
  if (coerceString && v is String) {
    if (v == 'true') return true;
    if (v == 'false') return false;
  }
  throw CodableException.typeMismatch(expectedType: bool, actualValue: v);
}

/// YAML format [Decoder] wrapping `package:yaml`'s [YamlNode] tree with
/// exact `SourceSpan` diagnostics.
final class YamlCodableDecoder implements Decoder {
  final YamlNode _node;
  final List<Object> _path;
  final _YamlTrace _trace;
  final bool _isMapKey;

  @override
  final Map<Object, Object?> userInfo;

  /// Creates a [YamlCodableDecoder] positioned at an already-parsed [_node].
  YamlCodableDecoder.fromNode(this._node, {this.userInfo = const {}})
    : _path = const [],
      _trace = _YamlTrace(_node),
      _isMapKey = false;

  YamlCodableDecoder._(
    this._node,
    this._path,
    this._trace, {
    required this.userInfo,
    this._isMapKey = false,
  });

  /// Parses [yaml] and decodes [decodable], rethrowing any [CodableException]
  /// or [YamlException] as a [YamlCodableException] with exact `SourceSpan`
  /// location details.
  static T decode<T>(
    String yaml,
    Decodable<T> decodable, {
    Uri? sourceUrl,
    Map<Object, Object?> userInfo = const {},
  }) {
    final YamlNode rootNode;
    try {
      rootNode = loadYamlNode(yaml, sourceUrl: sourceUrl);
    } on YamlException catch (e) {
      throw YamlCodableException(
        e.message,
        e.span,
        underlyingError: e,
        source: yaml,
      );
    }
    final decoder = YamlCodableDecoder.fromNode(rootNode, userInfo: userInfo);
    try {
      return decodable.decode(decoder);
    } on YamlCodableException {
      rethrow;
    } on CodableException catch (e) {
      throw YamlCodableException(
        e.message,
        decoder._trace.node.span,
        path: _mergePaths(decoder._trace.path, e.path),
        actualValue: e.actualValue,
        underlyingError: e.underlyingError ?? e,
        source: yaml,
      );
    }
  }

  @override
  bool get isHumanReadable => true;

  @override
  Uint8List? get payload => null;

  @override
  ValueKind peekKind() {
    _trace.set(_node, _path);
    return _yamlNodeKind(_node);
  }

  YamlMap _requireMap() {
    _trace.set(_node, _path);
    return switch (_node) {
      final YamlMap map => map,
      final node => throw CodableException.typeMismatch(
        expectedType: YamlMap,
        actualValue: _scalarValue(node),
      ),
    };
  }

  @override
  KeyedDecoder keyed({KeyOptions? options}) =>
      _YamlKeyedDecoder(_requireMap(), _path, _trace, userInfo);

  @override
  MappedDecoder mapped() =>
      _YamlMappedDecoder(_requireMap(), _path, _trace, userInfo);

  @override
  MapDecoder map() => _YamlMapDecoder(_requireMap(), _path, _trace, userInfo);

  @override
  UnkeyedDecoder unkeyed() {
    _trace.set(_node, _path);
    return switch (_node) {
      final YamlList list => _YamlUnkeyedDecoder(list, _path, _trace, userInfo),
      final node => throw CodableException.typeMismatch(
        expectedType: YamlList,
        actualValue: _scalarValue(node),
      ),
    };
  }

  @override
  SingleValueDecoder singleValue() {
    _trace.set(_node, _path);
    return _YamlSingleValueDecoder(
      _node,
      _path,
      _trace,
      userInfo,
      isMapKey: _isMapKey,
    );
  }

  @override
  Float64List? decodeUniformDoubleList(List<List<String>> propertyAliases) =>
      null;
}

mixin _YamlSequentialCursorMixin {
  _YamlTrace get _trace;
  Map<Object, Object?> get _userInfo;
  bool get _coerceStringScalars => false;

  YamlNode _peekNode();
  List<Object> _peekPath();
  void _consumeCurrent();

  YamlNode _takeNode() {
    final node = _peekNode();
    _consumeCurrent();
    return node;
  }

  ValueKind peekKind() => _yamlNodeKind(_peekNode());

  void readNull() {
    final node = _peekNode();
    if (_scalarValue(node) != null) {
      throw CodableException.typeMismatch(
        expectedType: Null,
        actualValue: _scalarValue(node),
      );
    }
    _consumeCurrent();
  }

  int readInt() =>
      _readYamlInt(_takeNode(), coerceString: _coerceStringScalars);

  double readDouble() =>
      _readYamlDouble(_takeNode(), coerceString: _coerceStringScalars);

  num readNum() =>
      _readYamlNum(_takeNode(), coerceString: _coerceStringScalars);

  String readString() => _readYamlString(_takeNode());

  bool readBool() =>
      _readYamlBool(_takeNode(), coerceString: _coerceStringScalars);

  Decoder nestedDecoder() {
    final path = _peekPath();
    final node = _takeNode();
    return YamlCodableDecoder._(
      node,
      path,
      _trace,
      userInfo: _userInfo,
      isMapKey: _coerceStringScalars,
    );
  }
}

final class _YamlKeyedDecoder
    with BaseKeyedDecoderMixin, _YamlSequentialCursorMixin
    implements KeyedDecoder {
  final YamlMap _map;
  final List<Object> _parentPath;
  @override
  final _YamlTrace _trace;
  @override
  final Map<Object, Object?> _userInfo;
  late final List<MapEntry<dynamic, YamlNode>> _entries = _map.nodes.entries
      .toList(growable: false);

  int _index = 0;
  int _phase = 0; // 0 = idle, 1 = atKey, 2 = atValue
  String? _activeKey;
  YamlNode? _activeKeyNode;
  YamlNode? _activeValueNode;
  List<Object> _activePath = const [];

  _YamlKeyedDecoder(this._map, this._parentPath, this._trace, this._userInfo);

  @override
  bool moveNextKey() {
    if (_phase == 1) return true;
    _phase = 0;
    if (_index >= _entries.length) {
      _trace.set(_map, _parentPath);
      return false;
    }
    final entry = _entries[_index++];
    final keyNode = entry.key as YamlNode;
    final rawKey = _scalarValue(keyNode);
    _activeKeyNode = keyNode;
    _activeKey = rawKey is String ? rawKey : null;
    _activeValueNode = entry.value;
    _activePath = [..._parentPath, _activeKey ?? (rawKey ?? '?')];
    _phase = 1;
    _trace.set(entry.value, _activePath);
    return true;
  }

  @override
  YamlNode _peekNode() {
    if (_phase == 0 && !moveNextKey()) {
      throw const CodableException('No more keys in YAML map');
    }
    _trace.set(_activeValueNode!, _activePath);
    return _activeValueNode!;
  }

  @override
  List<Object> _peekPath() {
    if (_phase == 0 && !moveNextKey()) {
      throw const CodableException('No more keys in YAML map');
    }
    return _activePath;
  }

  @override
  void _consumeCurrent() {
    _phase = 0;
  }

  @override
  String nextKey() {
    if (!moveNextKey()) {
      throw const CodableException('No more keys in YAML map');
    }
    final key = _activeKey;
    if (key != null) {
      _phase = 2;
      return key;
    }
    _trace.set(_activeKeyNode!, _parentPath);
    throw CodableException.typeMismatch(
      expectedType: String,
      actualValue: _scalarValue(_activeKeyNode!),
    );
  }

  @override
  String? peekKey() => moveNextKey() ? _activeKey : null;

  @override
  int selectKeyIndex(KeyOptions options) {
    if (!moveNextKey()) return -1;
    _phase = 2;
    final key = _activeKey;
    return key == null ? -1 : options.indexOf(key);
  }

  @override
  void skipValue() {
    if (_phase != 0 || moveNextKey()) _phase = 0;
  }

  @override
  Uint8List readBytes() => nestedDecoder().singleValue().readBytes();
}

final class _YamlMappedDecoder
    with BaseMappedDecoderMixin
    implements MappedDecoder {
  final YamlMap _map;
  final List<Object> _parentPath;
  final _YamlTrace _trace;
  final Map<Object, Object?> _userInfo;

  _YamlMappedDecoder(this._map, this._parentPath, this._trace, this._userInfo);

  YamlNode? _lookupNode(String key) {
    final node = _map.nodes[key];
    if (node != null) {
      _trace.set(node, [..._parentPath, key]);
    } else {
      _trace.set(_map, _parentPath);
    }
    return node;
  }

  YamlNode _requireNode(String key) {
    final node = _lookupNode(key);
    if (node != null) return node;
    throw CodableException.missingKey(key);
  }

  @override
  bool containsKey(String key) => _lookupNode(key) != null;

  @override
  ValueKind peekKind(String key) {
    final node = _lookupNode(key);
    return node == null ? ValueKind.nullValue : _yamlNodeKind(node);
  }

  @override
  int readInt(String key) => _readYamlInt(_requireNode(key));

  @override
  double readDouble(String key) => _readYamlDouble(_requireNode(key));

  @override
  num readNum(String key) => _readYamlNum(_requireNode(key));

  @override
  String readString(String key) => _readYamlString(_requireNode(key));

  @override
  bool readBool(String key) => _readYamlBool(_requireNode(key));

  @override
  Decoder nestedDecoder(String key) {
    final node = _requireNode(key);
    return YamlCodableDecoder._(
      node,
      [..._parentPath, key],
      _trace,
      userInfo: _userInfo,
    );
  }
}

final class _YamlMapDecoder implements MapDecoder {
  final YamlMap _map;
  final List<Object> _parentPath;
  final _YamlTrace _trace;
  final Map<Object, Object?> _userInfo;
  late final List<MapEntry<dynamic, YamlNode>> _entries = _map.nodes.entries
      .toList(growable: false);

  int _index = -1;

  _YamlMapDecoder(this._map, this._parentPath, this._trace, this._userInfo);

  @override
  int get length => _entries.length;

  @override
  bool moveNextEntry() {
    final next = _index + 1;
    if (next >= _entries.length) {
      _trace.set(_map, _parentPath);
      return false;
    }
    _index = next;
    return true;
  }

  MapEntry<dynamic, YamlNode> _currentEntry() {
    if (_index < 0 || _index >= _entries.length) {
      throw const CodableException(
        'MapDecoder cursor not positioned at an entry',
      );
    }
    return _entries[_index];
  }

  @override
  Decoder keyDecoder() {
    final entry = _currentEntry();
    final keyNode = entry.key as YamlNode;
    final keyPath = [..._parentPath, _scalarValue(keyNode) ?? '?'];
    _trace.set(keyNode, keyPath);
    return YamlCodableDecoder._(
      keyNode,
      keyPath,
      _trace,
      userInfo: _userInfo,
      isMapKey: true,
    );
  }

  @override
  Decoder valueDecoder() {
    final entry = _currentEntry();
    final keyNode = entry.key as YamlNode;
    final valNode = entry.value;
    final valPath = [..._parentPath, _scalarValue(keyNode) ?? '?'];
    _trace.set(valNode, valPath);
    return YamlCodableDecoder._(valNode, valPath, _trace, userInfo: _userInfo);
  }
}

final class _YamlUnkeyedDecoder
    with BaseUnkeyedDecoderMixin, _YamlSequentialCursorMixin
    implements UnkeyedDecoder {
  final YamlList _list;
  final List<Object> _parentPath;
  @override
  final _YamlTrace _trace;
  @override
  final Map<Object, Object?> _userInfo;

  int _index = -1;
  bool _consumed = true;

  _YamlUnkeyedDecoder(
    this._list,
    this._parentPath,
    this._trace,
    this._userInfo,
  );

  @override
  int get length => _list.nodes.length;

  @override
  bool moveNext() {
    if (!_consumed) return true;
    final next = _index + 1;
    if (next >= _list.nodes.length) {
      _trace.set(_list, _parentPath);
      return false;
    }
    _index = next;
    _consumed = false;
    _trace.set(_list.nodes[_index], [..._parentPath, _index]);
    return true;
  }

  @override
  YamlNode _peekNode() {
    if (_index < 0 || _index >= _list.nodes.length || _consumed) {
      throw const CodableException('No active element in YAML list');
    }
    final node = _list.nodes[_index];
    _trace.set(node, [..._parentPath, _index]);
    return node;
  }

  @override
  List<Object> _peekPath() => [..._parentPath, _index];

  @override
  void _consumeCurrent() {
    _consumed = true;
  }

  @override
  void skipElement() {
    _takeNode();
  }

  @override
  Uint8List readBytes() => nestedDecoder().singleValue().readBytes();
}

final class _YamlSingleValueDecoder
    with BaseSingleValueDecoderMixin, _YamlSequentialCursorMixin
    implements SingleValueDecoder {
  final YamlNode _node;
  final List<Object> _path;
  @override
  final _YamlTrace _trace;
  @override
  final Map<Object, Object?> _userInfo;
  @override
  final bool _coerceStringScalars;

  _YamlSingleValueDecoder(
    this._node,
    this._path,
    this._trace,
    this._userInfo, {
    bool isMapKey = false,
  }) : _coerceStringScalars = isMapKey;

  @override
  YamlNode _peekNode() {
    _trace.set(_node, _path);
    return _node;
  }

  @override
  List<Object> _peekPath() => _path;

  @override
  void _consumeCurrent() {}

  @override
  Uint8List readBytes() {
    final node = _peekNode();
    final kind = _yamlNodeKind(node);
    if (kind != ValueKind.string && kind != ValueKind.list) {
      throw CodableException(
        'Expected base64 string or byte list, got $kind',
        actualValue: node is YamlScalar ? node.value : null,
      );
    }
    return super.readBytes();
  }
}
