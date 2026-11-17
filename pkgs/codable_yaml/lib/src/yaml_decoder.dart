// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:typed_data';

import 'package:codable/codable_driver.dart';
import 'package:yaml/yaml.dart';

import 'yaml_exception.dart';

List<Object> _resolveYamlErrorPath(_YamlTrace trace, CodableException e) {
  if (identical(e, trace.attributedError)) {
    return List<Object>.unmodifiable(e.path);
  }
  if (e.path.isEmpty) {
    return List<Object>.unmodifiable(trace.path);
  }
  return List<Object>.unmodifiable(<Object>[...trace.containerPath, ...e.path]);
}

final class _YamlTrace {
  YamlNode node;
  List<Object> containerPath = const [];
  List<Object> path = const [];
  CodableException? attributedError;

  _YamlTrace(this.node);

  void setContainer(YamlNode nextNode, List<Object> nextContainerPath) {
    node = nextNode;
    containerPath = nextContainerPath;
    path = nextContainerPath;
  }

  void setLeaf(
    YamlNode nextNode,
    List<Object> nextContainerPath,
    List<Object> nextLeafPath,
  ) {
    node = nextNode;
    containerPath = nextContainerPath;
    path = nextLeafPath;
  }

  Never fail(CodableException error) {
    final withPath = error.path.isNotEmpty || path.isEmpty
        ? error
        : CodableException(
            error.message,
            path: List<Object>.unmodifiable(path),
            actualValue: error.actualValue,
            underlyingError: error.underlyingError,
          );
    attributedError = withPath;
    throw withPath;
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
final RegExp _yamlWhitespace = RegExp(r'\s');

int _yamlTagEndIndex(String s) {
  if (s.startsWith('!<')) {
    final gt = s.indexOf('>');
    return gt < 0 ? -1 : gt + 1;
  }
  return s.indexOf(_yamlWhitespace);
}

bool _isYamlFloatTagToken(String tag) =>
    tag.endsWith('!float') || tag.endsWith(':float') || tag.endsWith(':float>');

(bool isFloatTag, String? remaining) _consumeYamlPropertyPrefix(String s) {
  if (s.startsWith('#')) {
    final nl = s.indexOf('\n');
    return (false, nl < 0 ? '' : s.substring(nl + 1).trimLeft());
  }
  if (s.startsWith('&')) {
    final ws = s.indexOf(_yamlWhitespace);
    return (false, ws < 0 ? '' : s.substring(ws + 1).trimLeft());
  }
  if (s.startsWith('!')) {
    final end = _yamlTagEndIndex(s);
    if (end < 0) return (false, '');
    final isFloat = _isYamlFloatTagToken(s.substring(0, end));
    return (isFloat, s.substring(end).trimLeft());
  }
  return (false, null);
}

(bool hasFloatTag, String body) _stripYamlScalarProperties(String raw) {
  var s = raw.trimLeft();
  var hasFloatTag = false;
  while (s.isNotEmpty) {
    final (isFloat, next) = _consumeYamlPropertyPrefix(s);
    if (isFloat) hasFloatTag = true;
    if (next == null) break;
    s = next;
  }
  return (hasFloatTag, s.trimRight());
}

bool _isPlainYamlFloatOnJs(YamlNode node) {
  if (!identical(1.0, 1) || node is! YamlScalar) return false;
  final (hasFloatTag, text) = _stripYamlScalarProperties(node.span.text);
  if (hasFloatTag) return true;
  if (node.style != ScalarStyle.PLAIN || text.isEmpty) {
    final val = node.value;
    return val is num && val == 0 && val.isNegative;
  }
  if (_yamlPlainHexPrefix.hasMatch(text)) return false;
  return text.contains('.') || text.contains('e') || text.contains('E');
}

String _extractYamlScalarToken(String raw) {
  var (_, s) = _stripYamlScalarProperties(raw);
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
    final big = BigInt.tryParse(v);
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
        path: _resolveYamlErrorPath(decoder._trace, e),
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
    _trace.setContainer(_node, _path);
    return _yamlNodeKind(_node);
  }

  YamlMap _requireMap() {
    _trace.setContainer(_node, _path);
    return switch (_node) {
      final YamlMap map => map,
      final node => _trace.fail(
        CodableException.typeMismatch(
          expectedType: YamlMap,
          actualValue: _scalarValue(node),
          path: _path,
        ),
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
    _trace.setContainer(_node, _path);
    return switch (_node) {
      final YamlList list => _YamlUnkeyedDecoder(list, _path, _trace, userInfo),
      final node => _trace.fail(
        CodableException.typeMismatch(
          expectedType: YamlList,
          actualValue: _scalarValue(node),
          path: _path,
        ),
      ),
    };
  }

  @override
  SingleValueDecoder singleValue() {
    if (_isMapKey) {
      _trace.node = _node;
      _trace.path = _path;
    } else {
      _trace.setContainer(_node, _path);
    }
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

  T _runScalarRead<T>(T Function() fn) {
    try {
      return fn();
    } on CodableException catch (e) {
      _trace.fail(e);
    }
  }

  ValueKind peekKind() => _runScalarRead(() => _yamlNodeKind(_peekNode()));

  void readNull() {
    final node = _peekNode();
    if (_scalarValue(node) != null) {
      _trace.fail(
        CodableException.typeMismatch(
          expectedType: Null,
          actualValue: _scalarValue(node),
        ),
      );
    }
    _consumeCurrent();
  }

  int readInt() {
    final v = _runScalarRead(
      () => _readYamlInt(_peekNode(), coerceString: _coerceStringScalars),
    );
    _consumeCurrent();
    return v;
  }

  double readDouble() {
    final v = _runScalarRead(
      () => _readYamlDouble(_peekNode(), coerceString: _coerceStringScalars),
    );
    _consumeCurrent();
    return v;
  }

  num readNum() {
    final v = _runScalarRead(
      () => _readYamlNum(_peekNode(), coerceString: _coerceStringScalars),
    );
    _consumeCurrent();
    return v;
  }

  String readString() {
    final v = _runScalarRead(() => _readYamlString(_peekNode()));
    _consumeCurrent();
    return v;
  }

  bool readBool() {
    final v = _runScalarRead(
      () => _readYamlBool(_peekNode(), coerceString: _coerceStringScalars),
    );
    _consumeCurrent();
    return v;
  }

  Decoder nestedDecoder() {
    final path = _peekPath();
    final node = _takeNode();
    if (!_coerceStringScalars) {
      _trace.setContainer(node, path);
    }
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
      _trace.setContainer(_map, _parentPath);
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
    _trace.setLeaf(entry.value, _parentPath, _activePath);
    return true;
  }

  @override
  YamlNode _peekNode() {
    if (_phase == 0 && !moveNextKey()) {
      _trace.setContainer(_map, _parentPath);
      _trace.fail(const CodableException('No more keys in YAML map'));
    }
    _trace.setLeaf(_activeValueNode!, _parentPath, _activePath);
    return _activeValueNode!;
  }

  @override
  List<Object> _peekPath() {
    if (_phase == 0 && !moveNextKey()) {
      _trace.setContainer(_map, _parentPath);
      _trace.fail(const CodableException('No more keys in YAML map'));
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
      _trace.setContainer(_map, _parentPath);
      _trace.fail(const CodableException('No more keys in YAML map'));
    }
    final key = _activeKey;
    if (key != null) {
      _phase = 2;
      return key;
    }
    _trace.setContainer(_activeKeyNode!, _parentPath);
    _trace.fail(
      CodableException.typeMismatch(
        expectedType: String,
        actualValue: _scalarValue(_activeKeyNode!),
      ),
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
      _trace.setLeaf(node, _parentPath, [..._parentPath, key]);
    } else {
      _trace.setContainer(_map, _parentPath);
    }
    return node;
  }

  YamlNode _requireNode(String key) {
    final node = _lookupNode(key);
    if (node != null) return node;
    _trace.fail(CodableException.missingKey(key, path: _parentPath));
  }

  T _runMappedRead<T>(T Function() fn) {
    try {
      return fn();
    } on CodableException catch (e) {
      _trace.fail(e);
    }
  }

  @override
  bool containsKey(String key) => _lookupNode(key) != null;

  @override
  ValueKind peekKind(String key) {
    final node = _lookupNode(key);
    return node == null
        ? ValueKind.nullValue
        : _runMappedRead(() => _yamlNodeKind(node));
  }

  @override
  int readInt(String key) =>
      _runMappedRead(() => _readYamlInt(_requireNode(key)));

  @override
  double readDouble(String key) =>
      _runMappedRead(() => _readYamlDouble(_requireNode(key)));

  @override
  num readNum(String key) =>
      _runMappedRead(() => _readYamlNum(_requireNode(key)));

  @override
  String readString(String key) =>
      _runMappedRead(() => _readYamlString(_requireNode(key)));

  @override
  bool readBool(String key) =>
      _runMappedRead(() => _readYamlBool(_requireNode(key)));

  @override
  Decoder nestedDecoder(String key) {
    final node = _requireNode(key);
    final nextPath = [..._parentPath, key];
    _trace.setContainer(node, nextPath);
    return YamlCodableDecoder._(node, nextPath, _trace, userInfo: _userInfo);
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
      _trace.setContainer(_map, _parentPath);
      return false;
    }
    _index = next;
    return true;
  }

  MapEntry<dynamic, YamlNode> _currentEntry() {
    if (_index < 0 || _index >= _entries.length) {
      _trace.setContainer(_map, _parentPath);
      _trace.fail(
        const CodableException('MapDecoder cursor not positioned at an entry'),
      );
    }
    return _entries[_index];
  }

  @override
  Decoder keyDecoder() {
    final entry = _currentEntry();
    final keyNode = entry.key as YamlNode;
    final keyPath = [..._parentPath, _scalarValue(keyNode) ?? '?'];
    _trace.setLeaf(keyNode, _parentPath, keyPath);
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
    _trace.setContainer(valNode, valPath);
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
      _trace.setContainer(_list, _parentPath);
      return false;
    }
    _index = next;
    _consumed = false;
    _trace.setLeaf(_list.nodes[_index], _parentPath, [..._parentPath, _index]);
    return true;
  }

  @override
  YamlNode _peekNode() {
    if (_index < 0 || _index >= _list.nodes.length || _consumed) {
      _trace.setContainer(_list, _parentPath);
      _trace.fail(const CodableException('No active element in YAML list'));
    }
    final node = _list.nodes[_index];
    _trace.setLeaf(node, _parentPath, [..._parentPath, _index]);
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
    if (_coerceStringScalars) {
      _trace.node = _node;
      _trace.path = _path;
    } else {
      _trace.setContainer(_node, _path);
    }
    return _node;
  }

  @override
  List<Object> _peekPath() => _path;

  @override
  void _consumeCurrent() {}

  @override
  Uint8List readBytes() {
    final node = _peekNode();
    final kind = _runScalarRead(() => _yamlNodeKind(node));
    if (kind != ValueKind.string && kind != ValueKind.list) {
      _trace.fail(
        CodableException(
          'Expected base64 string or byte list, got $kind',
          actualValue: node is YamlScalar ? node.value : null,
        ),
      );
    }
    try {
      return super.readBytes();
    } on CodableException catch (e) {
      _trace.fail(e);
    }
  }
}
