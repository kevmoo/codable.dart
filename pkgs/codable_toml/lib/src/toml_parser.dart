// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'toml_types.dart';

/// Maximum nesting depth allowed for TOML arrays, inline tables, key paths, and
/// decoder containers.
const int maxTomlDepth = 64;

final BigInt _maxInt64 = BigInt.parse('9223372036854775807');
final BigInt _minInt64 = BigInt.parse('-9223372036854775808');
final BigInt _maxSafeJs = BigInt.from(9007199254740991);
final BigInt _minSafeJs = BigInt.from(-9007199254740991);

/// Computes 1-based `(line, column)` coordinates for [offset] in [source].
(int line, int column) computeTomlLineColumn(String source, int offset) {
  final limit = offset.clamp(0, source.length);
  var line = 1;
  var lineStart = 0;
  for (var i = 0; i < limit; i++) {
    if (source.codeUnitAt(i) == 0x0a) {
      line++;
      lineStart = i + 1;
    }
  }
  var column = 1;
  var idx = lineStart;
  while (idx < limit) {
    final cu = source.codeUnitAt(idx);
    final isHigh = cu >= 0xd800 && cu <= 0xdbff && idx + 1 < limit;
    idx += isHigh ? 2 : 1;
    column++;
  }
  return (line, column);
}

/// How a [TomlTable] was introduced in the TOML document.
enum _TomlTableOrigin {
  /// Top-level document table.
  root,

  /// Intermediate super-table implicitly created by `[a.b]` or `[[a.b]]`.
  implicitHeader,

  /// Explicitly opened `[table]` or `[[array_of_tables]]` element.
  explicitHeader,

  /// Created via dotted key (`a.b = 1`) within a specific table scope.
  dottedKey,

  /// Created via `{ ... }` inline table literal.
  inline,
}

/// Parsed AST node in a TOML v1.0 document.
sealed class TomlNode {
  /// UTF-16 code-unit offset in the source document where this node begins.
  final int offset;

  const TomlNode({required this.offset});
}

/// Boolean scalar (`true` / `false`).
final class TomlBool extends TomlNode {
  final bool value;

  const TomlBool(this.value, {required super.offset});
}

/// 64-bit signed integer scalar (clamped to safe 53-bit integer range on JS).
final class TomlInt extends TomlNode {
  final int value;

  const TomlInt(this.value, {required super.offset});
}

/// IEEE 754 binary64 floating-point scalar.
final class TomlFloat extends TomlNode {
  final double value;

  const TomlFloat(this.value, {required super.offset});
}

/// Decoded UTF-8 string scalar.
final class TomlString extends TomlNode {
  final String value;

  const TomlString(this.value, {required super.offset});
}

/// Native unquoted TOML v1.0 date/time scalar.
final class TomlDateTimeValue extends TomlNode {
  final TomlDateTime value;

  const TomlDateTimeValue(this.value, {required super.offset});
}

/// TOML array literal (`[...]`) or `[[array_of_tables]]` sequence.
final class TomlArray extends TomlNode {
  final List<TomlNode> items = <TomlNode>[];
  final bool isArrayOfTables;
  bool isSealed;

  TomlArray({
    required super.offset,
    this.isArrayOfTables = false,
    this.isSealed = false,
  });
}

/// Key-value entry inside a [TomlTable], preserving the source [keyOffset].
final class TomlEntry {
  final String key;
  final int keyOffset;
  final TomlNode value;

  const TomlEntry({
    required this.key,
    required this.keyOffset,
    required this.value,
  });
}

/// Ordered TOML table mapping string keys to [TomlEntry] records.
final class TomlTable extends TomlNode {
  final Map<String, TomlEntry> entries = <String, TomlEntry>{};
  _TomlTableOrigin _origin;
  int scopeId;
  bool isSealed = false;

  TomlTable._(this._origin, {required super.offset, required this.scopeId});
}

final class _KeySegment {
  final String name;
  final int offset;

  const _KeySegment(this.name, this.offset);
}

final class _ParsedTime {
  final int hour;
  final int minute;
  final int second;
  final int millisecond;
  final int microsecond;

  const _ParsedTime({
    required this.hour,
    required this.minute,
    required this.second,
    required this.millisecond,
    required this.microsecond,
  });
}

/// Parses a complete TOML v1.0 [source] string into its root [TomlTable].
TomlTable parseTomlDocument(String source) => _TomlParser(source).parse();

/// Parses an unquoted TOML v1.0 date/time literal (`offsetDateTime`,
/// `localDateTime`, `localDate`, or `localTime`) or throws
/// [TomlCodableException].
TomlDateTime parseTomlDateTimeLiteral(String raw) {
  final parser = _TomlParser(raw);
  if (_looksLikeLocalTime(raw)) return parser._parseLocalTime(0, raw).value;
  if (_looksLikeDatePrefix(raw)) {
    return parser._parseDateOrDateTime(0, raw).value;
  }
  throw TomlCodableException('Invalid TOML date-time literal "$raw"');
}

final class _TomlParser {
  final String _source;
  final int _length;
  int _offset = 0;
  int _scopeCounter = 0;

  _TomlParser(this._source) : _length = _source.length;

  Never _fail(String message, [int? atOffset]) {
    final pos = atOffset ?? _offset;
    final (line, column) = computeTomlLineColumn(_source, pos);
    throw TomlCodableException(message, line: line, column: column);
  }

  bool get _isAtEnd => _offset >= _length;

  int _peek([int lookahead = 0]) {
    final idx = _offset + lookahead;
    return idx < _length ? _source.codeUnitAt(idx) : -1;
  }

  void _skipInlineWhitespace() {
    while (_offset < _length) {
      final c = _source.codeUnitAt(_offset);
      if (c != 0x20 && c != 0x09) break;
      _offset++;
    }
  }

  bool _consumeNewlineIfPresent() {
    final c = _peek();
    if (c == 0x0a) {
      _offset++;
      return true;
    }
    if (c == 0x0d) {
      if (_peek(1) != 0x0a) {
        _fail('Bare carriage return (CR without LF) is not allowed in TOML');
      }
      _offset += 2;
      return true;
    }
    return false;
  }

  void _skipComment() {
    _offset++; // '#'
    while (_offset < _length) {
      final c = _source.codeUnitAt(_offset);
      if (c == 0x0a) break;
      if (c == 0x0d) {
        if (_peek(1) != 0x0a) {
          _fail('Invalid control character U+000D in TOML comment');
        }
        break;
      }
      final cp = _readScalarAt(_offset);
      if (!_isAllowedCommentScalar(cp)) {
        _fail(
          'Disallowed control character U+${cp.toRadixString(16).padLeft(4, '0').toUpperCase()} in comment',
        );
      }
      _offset += cp > 0xffff ? 2 : 1;
    }
  }

  void _skipWhitespaceAndComments() {
    while (!_isAtEnd) {
      _skipInlineWhitespace();
      if (_peek() == 0x23) _skipComment();
      if (!_consumeNewlineIfPresent()) break;
    }
  }

  void _expectEndOfStatement() {
    _skipInlineWhitespace();
    if (_peek() == 0x23) _skipComment();
    if (_isAtEnd || _consumeNewlineIfPresent()) return;
    _fail('Expected newline or end of file after TOML statement');
  }

  TomlTable parse() {
    // Strip optional leading UTF-8 BOM (U+FEFF) if present in a raw string.
    if (_peek() == 0xfeff) _offset++;
    final root = TomlTable._(_TomlTableOrigin.root, offset: 0, scopeId: 0);
    var activeTable = root;
    var activeScope = 0;

    while (true) {
      _skipWhitespaceAndComments();
      if (_isAtEnd) break;
      if (_peek() == 0x5b) {
        final nextScope = ++_scopeCounter;
        activeTable = _parseTableHeader(root, nextScope);
        activeScope = nextScope;
      } else {
        _parseKeyValueInto(activeTable, activeScope, depth: 0);
        _expectEndOfStatement();
      }
    }
    return root;
  }

  TomlTable _parseTableHeader(TomlTable root, int nextScope) {
    final headerOffset = _offset;
    _offset++; // '['
    final isArrayHeader = _peek() == 0x5b;
    if (isArrayHeader) _offset++;

    final path = _readKeyPath();
    _skipInlineWhitespace();
    if (_peek() != 0x5d) {
      _fail('Expected closing "]" in table header');
    }
    _offset++;
    if (isArrayHeader) {
      if (_peek() != 0x5d) {
        _fail('Expected closing "]]" in array-of-tables header');
      }
      _offset++;
    }
    _expectEndOfStatement();

    return isArrayHeader
        ? _resolveArrayOfTablesHeader(root, path, nextScope, headerOffset)
        : _resolveStandardTableHeader(root, path, nextScope, headerOffset);
  }

  TomlTable _traverseHeaderPrefix(
    TomlTable root,
    List<_KeySegment> path,
    int nextScope,
  ) {
    var curr = root;
    for (var i = 0; i < path.length - 1; i++) {
      final seg = path[i];
      final existing = curr.entries[seg.name]?.value;
      curr = _stepHeaderPrefix(curr, seg, existing, nextScope);
    }
    return curr;
  }

  TomlTable _stepHeaderPrefix(
    TomlTable curr,
    _KeySegment seg,
    TomlNode? existing,
    int nextScope,
  ) {
    if (existing == null) {
      final created = TomlTable._(
        _TomlTableOrigin.implicitHeader,
        offset: seg.offset,
        scopeId: nextScope,
      );
      curr.entries[seg.name] = TomlEntry(
        key: seg.name,
        keyOffset: seg.offset,
        value: created,
      );
      return created;
    }
    if (existing is TomlTable && !existing.isSealed) return existing;
    if (existing is TomlArray &&
        existing.isArrayOfTables &&
        !existing.isSealed) {
      return existing.items.last as TomlTable;
    }
    _fail(
      'Cannot open table header through sealed or non-table key "${seg.name}"',
      seg.offset,
    );
  }

  TomlTable _resolveStandardTableHeader(
    TomlTable root,
    List<_KeySegment> path,
    int nextScope,
    int headerOffset,
  ) {
    final parent = _traverseHeaderPrefix(root, path, nextScope);
    final last = path.last;
    final existing = parent.entries[last.name]?.value;
    if (existing == null) {
      final table = TomlTable._(
        _TomlTableOrigin.explicitHeader,
        offset: headerOffset,
        scopeId: nextScope,
      );
      parent.entries[last.name] = TomlEntry(
        key: last.name,
        keyOffset: last.offset,
        value: table,
      );
      return table;
    }
    if (existing is TomlTable &&
        !existing.isSealed &&
        existing._origin == _TomlTableOrigin.implicitHeader) {
      existing
        .._origin = _TomlTableOrigin.explicitHeader
        ..scopeId = nextScope;
      return existing;
    }
    _fail('Duplicate or already-defined table "${last.name}"', last.offset);
  }

  TomlTable _resolveArrayOfTablesHeader(
    TomlTable root,
    List<_KeySegment> path,
    int nextScope,
    int headerOffset,
  ) {
    final parent = _traverseHeaderPrefix(root, path, nextScope);
    final last = path.last;
    final existing = parent.entries[last.name]?.value;
    final TomlArray array;
    if (existing == null) {
      array = TomlArray(offset: headerOffset, isArrayOfTables: true);
      parent.entries[last.name] = TomlEntry(
        key: last.name,
        keyOffset: last.offset,
        value: array,
      );
    } else if (existing is TomlArray &&
        existing.isArrayOfTables &&
        !existing.isSealed) {
      array = existing;
    } else {
      _fail(
        'Cannot define array of tables "${last.name}": key is already defined',
        last.offset,
      );
    }
    final element = TomlTable._(
      _TomlTableOrigin.explicitHeader,
      offset: headerOffset,
      scopeId: nextScope,
    );
    array.items.add(element);
    return element;
  }

  void _parseKeyValueInto(
    TomlTable targetTable,
    int scopeId, {
    required int depth,
  }) {
    final path = _readKeyPath(baseDepth: depth);
    _skipInlineWhitespace();
    if (_peek() != 0x3d) {
      _fail('Expected "=" after key "${path.last.name}"');
    }
    _offset++; // '='
    _skipInlineWhitespace();
    final valueDepth = depth + path.length - 1;
    final value = _parseValue(depth: valueDepth);
    _insertDottedValue(targetTable, path, value, scopeId);
  }

  void _insertDottedValue(
    TomlTable targetTable,
    List<_KeySegment> path,
    TomlNode value,
    int scopeId,
  ) {
    var curr = targetTable;
    for (var i = 0; i < path.length - 1; i++) {
      final seg = path[i];
      final existing = curr.entries[seg.name]?.value;
      if (existing == null) {
        final sub = TomlTable._(
          _TomlTableOrigin.dottedKey,
          offset: seg.offset,
          scopeId: scopeId,
        );
        curr.entries[seg.name] = TomlEntry(
          key: seg.name,
          keyOffset: seg.offset,
          value: sub,
        );
        curr = sub;
      } else if (existing is TomlTable &&
          !existing.isSealed &&
          existing._origin == _TomlTableOrigin.dottedKey &&
          existing.scopeId == scopeId) {
        curr = existing;
      } else {
        _fail(
          'Cannot extend already-defined or sealed key "${seg.name}" via dotted key',
          seg.offset,
        );
      }
    }
    final last = path.last;
    if (curr.entries.containsKey(last.name)) {
      _fail('Duplicate key "${last.name}"', last.offset);
    }
    curr.entries[last.name] = TomlEntry(
      key: last.name,
      keyOffset: last.offset,
      value: value,
    );
  }

  List<_KeySegment> _readKeyPath({int baseDepth = 0}) {
    final segments = <_KeySegment>[];
    while (true) {
      _skipInlineWhitespace();
      if (baseDepth + segments.length >= maxTomlDepth) {
        _fail('TOML key nesting depth exceeds limit of $maxTomlDepth');
      }
      segments.add(_readSingleKeySegment());
      _skipInlineWhitespace();
      if (_peek() != 0x2e) break;
      _offset++; // '.'
    }
    return segments;
  }

  _KeySegment _readSingleKeySegment() {
    final segOffset = _offset;
    final c = _peek();
    if (c == 0x22) {
      if (_peek(1) == 0x22 && _peek(2) == 0x22) {
        _fail('Multiline basic strings are not allowed as TOML keys');
      }
      return _KeySegment(_readBasicString(), segOffset);
    }
    if (c == 0x27) {
      if (_peek(1) == 0x27 && _peek(2) == 0x27) {
        _fail('Multiline literal strings are not allowed as TOML keys');
      }
      return _KeySegment(_readLiteralString(), segOffset);
    }
    while (_offset < _length && _isBareKeyChar(_source.codeUnitAt(_offset))) {
      _offset++;
    }
    if (_offset == segOffset) {
      _fail('Expected TOML bare or quoted key', segOffset);
    }
    return _KeySegment(_source.substring(segOffset, _offset), segOffset);
  }

  TomlNode _parseValue({required int depth}) {
    if (_isAtEnd) _fail('Unexpected end of input where TOML value expected');
    final start = _offset;
    final c = _source.codeUnitAt(start);
    if (c == 0x22) {
      final value = (_peek(1) == 0x22 && _peek(2) == 0x22)
          ? _readMultilineBasicString()
          : _readBasicString();
      return TomlString(value, offset: start);
    }
    if (c == 0x27) {
      final value = (_peek(1) == 0x27 && _peek(2) == 0x27)
          ? _readMultilineLiteralString()
          : _readLiteralString();
      return TomlString(value, offset: start);
    }
    if (c == 0x5b) return _parseArray(depth: depth);
    if (c == 0x7b) return _parseInlineTable(depth: depth);
    final raw = _readUnquotedScalarSlice();
    return _parseUnquotedScalar(start, raw);
  }

  TomlArray _parseArray({required int depth}) {
    if (depth >= maxTomlDepth) {
      _fail('TOML array nesting depth exceeds limit of $maxTomlDepth');
    }
    final start = _offset;
    _offset++; // '['
    final array = TomlArray(offset: start, isSealed: true);
    _skipWhitespaceAndComments();
    if (_peek() == 0x5d) {
      _offset++;
      return array;
    }
    while (true) {
      array.items.add(_parseValue(depth: depth + 1));
      _skipWhitespaceAndComments();
      if (_peek() == 0x2c) {
        _offset++; // ','
        _skipWhitespaceAndComments();
        if (_peek() == 0x5d) {
          _offset++;
          return array;
        }
        continue;
      }
      if (_peek() == 0x5d) {
        _offset++;
        return array;
      }
      _fail('Expected "," or "]" in TOML array');
    }
  }

  TomlTable _parseInlineTable({required int depth}) {
    if (depth >= maxTomlDepth) {
      _fail('TOML inline table nesting depth exceeds limit of $maxTomlDepth');
    }
    final start = _offset;
    final inlineScope = ++_scopeCounter;
    _offset++; // '{'
    final table = TomlTable._(
      _TomlTableOrigin.inline,
      offset: start,
      scopeId: inlineScope,
    );
    _skipInlineWhitespace();
    if (_peek() == 0x7d) {
      _offset++;
      table.isSealed = true;
      return table;
    }
    while (true) {
      _parseKeyValueInto(table, inlineScope, depth: depth + 1);
      _skipInlineWhitespace();
      if (_peek() == 0x2c) {
        _offset++; // ','
        _skipInlineWhitespace();
        if (_peek() == 0x7d) {
          _fail('Trailing comma is not allowed in TOML v1.0 inline tables');
        }
        continue;
      }
      if (_peek() == 0x7d) {
        _offset++;
        _sealInlineNode(table);
        return table;
      }
      _fail('Expected "," or "}" in TOML v1.0 single-line inline table');
    }
  }

  void _sealInlineNode(TomlNode node) {
    if (node is TomlTable) {
      node.isSealed = true;
      for (final entry in node.entries.values) {
        _sealInlineNode(entry.value);
      }
    } else if (node is TomlArray) {
      node.isSealed = true;
      for (final item in node.items) {
        _sealInlineNode(item);
      }
    }
  }

  String _readBasicString() {
    final openOffset = _offset;
    _offset++; // '"'
    final buf = StringBuffer();
    while (!_isAtEnd) {
      final c = _source.codeUnitAt(_offset);
      if (c == 0x22) {
        _offset++;
        return buf.toString();
      }
      if (c == 0x5c) {
        buf.write(_readEscapeSequence(allowLineContinuation: false));
      } else {
        buf.write(_readAllowedSingleLineChar());
      }
    }
    _fail('Unterminated basic string literal', openOffset);
  }

  String _readMultilineBasicString() {
    final openOffset = _offset;
    _offset += 3; // '"""'
    _consumeNewlineIfPresent();
    final buf = StringBuffer();
    while (!_isAtEnd) {
      final c = _source.codeUnitAt(_offset);
      if (c == 0x22) {
        if (_consumeMultilineClosingQuotes(0x22, buf)) {
          return buf.toString();
        }
        continue;
      }
      if (c == 0x5c) {
        buf.write(_readEscapeSequence(allowLineContinuation: true));
      } else {
        buf.write(_readAllowedMultilineChar());
      }
    }
    _fail('Unterminated multiline basic string literal', openOffset);
  }

  String _readLiteralString() {
    final openOffset = _offset;
    _offset++; // "'"
    final buf = StringBuffer();
    while (!_isAtEnd) {
      if (_source.codeUnitAt(_offset) == 0x27) {
        _offset++;
        return buf.toString();
      }
      buf.write(_readAllowedSingleLineChar());
    }
    _fail('Unterminated literal string', openOffset);
  }

  String _readMultilineLiteralString() {
    final openOffset = _offset;
    _offset += 3; // "'''"
    _consumeNewlineIfPresent();
    final buf = StringBuffer();
    while (!_isAtEnd) {
      if (_source.codeUnitAt(_offset) == 0x27) {
        if (_consumeMultilineClosingQuotes(0x27, buf)) {
          return buf.toString();
        }
        continue;
      }
      buf.write(_readAllowedMultilineChar());
    }
    _fail('Unterminated multiline literal string', openOffset);
  }

  bool _consumeMultilineClosingQuotes(int quoteChar, StringBuffer buf) {
    var run = 0;
    while (_peek(run) == quoteChar) {
      run++;
    }
    if (run < 3) {
      for (var i = 0; i < run; i++) {
        buf.writeCharCode(quoteChar);
      }
      _offset += run;
      return false;
    }
    if (run > 5) {
      _fail('Too many consecutive quotes in multiline string');
    }
    for (var i = 0; i < run - 3; i++) {
      buf.writeCharCode(quoteChar);
    }
    _offset += run;
    return true;
  }

  String _readAllowedSingleLineChar() {
    final cp = _readScalarAt(_offset);
    if (!_isAllowedCommentScalar(cp)) {
      _fail(
        'Disallowed control character U+${cp.toRadixString(16).padLeft(4, '0').toUpperCase()} in string',
      );
    }
    _offset += cp > 0xffff ? 2 : 1;
    return String.fromCharCode(cp);
  }

  String _readAllowedMultilineChar() {
    if (_consumeNewlineIfPresent()) return '\n';
    return _readAllowedSingleLineChar();
  }

  String _readEscapeSequence({required bool allowLineContinuation}) {
    final escOffset = _offset;
    _offset++; // '\'
    if (_isAtEnd) _fail('Unterminated escape sequence', escOffset);
    if (allowLineContinuation && _trySkipEscapedLineEnding()) return '';

    final c = _source.codeUnitAt(_offset++);
    return switch (c) {
      0x62 => '\b',
      0x74 => '\t',
      0x6e => '\n',
      0x66 => '\f',
      0x72 => '\r',
      0x22 => '"',
      0x5c => r'\',
      0x75 => _readUnicodeHexEscape(4, escOffset),
      0x55 => _readUnicodeHexEscape(8, escOffset),
      _ => _fail('Invalid escape sequence in TOML basic string', escOffset),
    };
  }

  bool _trySkipEscapedLineEnding() {
    final saved = _offset;
    _skipInlineWhitespace();
    if (!_consumeNewlineIfPresent()) {
      _offset = saved;
      return false;
    }
    while (!_isAtEnd) {
      _skipInlineWhitespace();
      if (!_consumeNewlineIfPresent()) break;
    }
    return true;
  }

  String _readUnicodeHexEscape(int digits, int escOffset) {
    if (_offset + digits > _length) {
      _fail('Truncated Unicode escape sequence', escOffset);
    }
    var cp = 0;
    for (var i = 0; i < digits; i++) {
      final d = _hexValue(_source.codeUnitAt(_offset + i));
      if (d < 0) _fail('Invalid hex digit in Unicode escape', _offset + i);
      cp = (cp << 4) | d;
    }
    _offset += digits;
    if (cp > 0x10ffff || (cp >= 0xd800 && cp <= 0xdfff)) {
      _fail('Invalid Unicode scalar value in escape sequence', escOffset);
    }
    return String.fromCharCode(cp);
  }

  int _readScalarAt(int index) {
    final cu = _source.codeUnitAt(index);
    if (cu >= 0xd800 && cu <= 0xdbff) {
      if (index + 1 < _length) {
        final low = _source.codeUnitAt(index + 1);
        if (low >= 0xdc00 && low <= 0xdfff) {
          return 0x10000 + ((cu - 0xd800) << 10) + (low - 0xdc00);
        }
      }
      _fail('Unpaired UTF-16 high surrogate in TOML source', index);
    }
    if (cu >= 0xdc00 && cu <= 0xdfff) {
      _fail('Unpaired UTF-16 low surrogate in TOML source', index);
    }
    return cu;
  }

  String _readUnquotedScalarSlice() {
    final start = _offset;
    while (_offset < _length) {
      final c = _source.codeUnitAt(_offset);
      if (c == 0x20 && _isSpaceSeparatedDateTimeAt(start, _offset)) {
        _offset++;
        continue;
      }
      if (_isValueDelimiter(c)) break;
      _offset++;
    }
    if (_offset == start) {
      _fail('Expected TOML scalar value', start);
    }
    return _source.substring(start, _offset);
  }

  bool _isSpaceSeparatedDateTimeAt(int start, int spacePos) =>
      spacePos - start == 10 &&
      _source.codeUnitAt(start + 4) == 0x2d &&
      _source.codeUnitAt(start + 7) == 0x2d &&
      spacePos + 3 < _length &&
      _isAsciiDigit(_source.codeUnitAt(spacePos + 1)) &&
      _isAsciiDigit(_source.codeUnitAt(spacePos + 2)) &&
      _source.codeUnitAt(spacePos + 3) == 0x3a;

  TomlNode _parseUnquotedScalar(int start, String raw) {
    if (raw == 'true') return TomlBool(true, offset: start);
    if (raw == 'false') return TomlBool(false, offset: start);
    if (raw == 'inf' || raw == '+inf') {
      return TomlFloat(double.infinity, offset: start);
    }
    if (raw == '-inf') return TomlFloat(double.negativeInfinity, offset: start);
    if (raw == 'nan' || raw == '+nan' || raw == '-nan') {
      return TomlFloat(double.nan, offset: start);
    }
    if (_looksLikeLocalTime(raw)) return _parseLocalTime(start, raw);
    if (_looksLikeDatePrefix(raw)) return _parseDateOrDateTime(start, raw);
    if (raw.startsWith('0x')) return _parseRadixInt(start, raw, 16);
    if (raw.startsWith('0o')) return _parseRadixInt(start, raw, 8);
    if (raw.startsWith('0b')) return _parseRadixInt(start, raw, 2);
    if (_containsFloatIndicator(raw)) return _parseFloat(start, raw);
    return _parseDecimalInt(start, raw);
  }

  TomlInt _parseRadixInt(int start, String raw, int radix) {
    final cleaned = _stripValidDigits(
      raw.substring(2),
      radix: radix,
      allowLeadingZero: true,
    );
    if (cleaned == null) {
      _fail('Invalid base-$radix integer literal "$raw"', start);
    }
    return TomlInt(
      _checkedBigIntToInt(BigInt.parse(cleaned, radix: radix), raw, start),
      offset: start,
    );
  }

  TomlInt _parseDecimalInt(int start, String raw) {
    final first = raw.codeUnitAt(0);
    final hasSign = first == 0x2b || first == 0x2d;
    final negative = first == 0x2d;
    final cleaned = _stripValidDigits(
      hasSign ? raw.substring(1) : raw,
      radix: 10,
      allowLeadingZero: false,
    );
    if (cleaned == null) {
      _fail('Invalid TOML literal "$raw"', start);
    }
    if (cleaned.length <= 15) {
      final mag = int.parse(cleaned);
      return TomlInt(mag == 0 ? 0 : (negative ? -mag : mag), offset: start);
    }
    final big = BigInt.parse(cleaned);
    final signed = negative ? -big : big;
    return TomlInt(_checkedBigIntToInt(signed, raw, start), offset: start);
  }

  int _checkedBigIntToInt(BigInt value, String raw, int start) {
    final (minB, maxB) = identical(1, 1.0)
        ? (_minSafeJs, _maxSafeJs)
        : (_minInt64, _maxInt64);
    if (value < minB || value > maxB) {
      _fail('TOML integer literal out of range: "$raw"', start);
    }
    return value == BigInt.zero ? 0 : value.toInt();
  }

  TomlFloat _parseFloat(int start, String raw) {
    final first = raw.codeUnitAt(0);
    final unsigned = (first == 0x2b || first == 0x2d) ? raw.substring(1) : raw;
    final expParts = unsigned.toLowerCase().split('e');
    if (expParts.length > 2 ||
        (expParts.length == 2 && !_isValidExponentTail(expParts[1]))) {
      _fail('Invalid TOML float literal "$raw"', start);
    }
    final dotParts = expParts[0].split('.');
    if (dotParts.length > 2 || !_isValidMantissaParts(dotParts)) {
      _fail('Invalid TOML float literal "$raw"', start);
    }
    return TomlFloat(double.parse(raw.replaceAll('_', '')), offset: start);
  }

  TomlDateTimeValue _parseLocalTime(int start, String raw) {
    final parsed = _parseTimePart(raw, 0);
    if (parsed == null || parsed.$2 != raw.length) {
      _fail('Invalid TOML Local Time "$raw"', start);
    }
    return TomlDateTimeValue(
      TomlDateTime(kind: TomlDateTimeKind.localTime, raw: raw),
      offset: start,
    );
  }

  TomlDateTimeValue _parseDateOrDateTime(int start, String raw) {
    final ymd = _parseCalendarDate(raw);
    if (ymd == null) _fail('Invalid TOML calendar date in "$raw"', start);
    final (year, month, day) = ymd;
    if (raw.length == 10) {
      return TomlDateTimeValue(
        TomlDateTime(
          kind: TomlDateTimeKind.localDate,
          raw: raw,
          dateTime: DateTime.utc(year, month, day),
        ),
        offset: start,
      );
    }
    final sep = raw.codeUnitAt(10);
    if (sep != 0x54 && sep != 0x74 && sep != 0x20) {
      _fail('Invalid TOML date-time separator in "$raw"', start);
    }
    final timeParsed = _parseTimePart(raw, 11);
    if (timeParsed == null) {
      _fail('Invalid time component in TOML date-time "$raw"', start);
    }
    final (time, afterTime) = timeParsed;
    if (afterTime == raw.length) {
      return TomlDateTimeValue(
        TomlDateTime(
          kind: TomlDateTimeKind.localDateTime,
          raw: raw,
          dateTime: DateTime(
            year,
            month,
            day,
            time.hour,
            time.minute,
            time.second,
            time.millisecond,
            time.microsecond,
          ),
        ),
        offset: start,
      );
    }
    final offsetMins = _parseTimeOffsetMinutes(raw, afterTime);
    if (offsetMins == null) {
      _fail('Invalid offset in TOML Offset Date-Time "$raw"', start);
    }
    final wallUtc = DateTime.utc(
      year,
      month,
      day,
      time.hour,
      time.minute,
      time.second,
      time.millisecond,
      time.microsecond,
    );
    final instant = offsetMins == 0
        ? wallUtc
        : wallUtc.subtract(Duration(minutes: offsetMins));
    return TomlDateTimeValue(
      TomlDateTime(
        kind: TomlDateTimeKind.offsetDateTime,
        raw: raw,
        dateTime: instant,
      ),
      offset: start,
    );
  }
}

bool _isBareKeyChar(int c) =>
    (c >= 0x41 && c <= 0x5a) ||
    (c >= 0x61 && c <= 0x7a) ||
    (c >= 0x30 && c <= 0x39) ||
    c == 0x5f ||
    c == 0x2d;

bool _isAsciiDigit(int c) => c >= 0x30 && c <= 0x39;

bool _isAllowedCommentScalar(int cp) =>
    cp == 0x09 || (cp >= 0x20 && cp <= 0x7e) || cp >= 0x80;

bool _isValueDelimiter(int c) =>
    c == 0x20 ||
    c == 0x09 ||
    c == 0x23 ||
    c == 0x2c ||
    c == 0x5d ||
    c == 0x7d ||
    c == 0x0a ||
    c == 0x0d;

int _hexValue(int c) {
  if (c >= 0x30 && c <= 0x39) return c - 0x30;
  if (c >= 0x41 && c <= 0x46) return c - 0x41 + 10;
  if (c >= 0x61 && c <= 0x66) return c - 0x61 + 10;
  return -1;
}

bool _isRadixDigit(int c, int radix) => switch (radix) {
  2 => c == 0x30 || c == 0x31,
  8 => c >= 0x30 && c <= 0x37,
  10 => c >= 0x30 && c <= 0x39,
  _ => _hexValue(c) >= 0,
};

String? _stripValidDigits(
  String part, {
  required int radix,
  required bool allowLeadingZero,
}) {
  if (part.isEmpty) return null;
  if (!allowLeadingZero && part.length > 1 && part.codeUnitAt(0) == 0x30) {
    return null;
  }
  final buf = StringBuffer();
  var prevUnderscore = true;
  for (var i = 0; i < part.length; i++) {
    final c = part.codeUnitAt(i);
    if (c == 0x5f) {
      if (prevUnderscore) return null;
      prevUnderscore = true;
    } else if (_isRadixDigit(c, radix)) {
      prevUnderscore = false;
      buf.writeCharCode(c);
    } else {
      return null;
    }
  }
  return prevUnderscore ? null : buf.toString();
}

bool _isValidMantissaParts(List<String> dotParts) {
  if (_stripValidDigits(dotParts[0], radix: 10, allowLeadingZero: false) ==
      null) {
    return false;
  }
  return dotParts.length == 1 ||
      _stripValidDigits(dotParts[1], radix: 10, allowLeadingZero: true) != null;
}

bool _isValidExponentTail(String tail) {
  if (tail.isEmpty) return false;
  final first = tail.codeUnitAt(0);
  final digits = (first == 0x2b || first == 0x2d) ? tail.substring(1) : tail;
  return _stripValidDigits(digits, radix: 10, allowLeadingZero: true) != null;
}

bool _containsFloatIndicator(String raw) {
  for (var i = 0; i < raw.length; i++) {
    final c = raw.codeUnitAt(i);
    if (c == 0x2e || c == 0x65 || c == 0x45) return true;
  }
  return false;
}

bool _looksLikeLocalTime(String raw) =>
    raw.length >= 8 &&
    _isAsciiDigit(raw.codeUnitAt(0)) &&
    _isAsciiDigit(raw.codeUnitAt(1)) &&
    raw.codeUnitAt(2) == 0x3a;

bool _looksLikeDatePrefix(String raw) =>
    raw.length >= 10 &&
    raw.codeUnitAt(4) == 0x2d &&
    _parseFixedDigits(raw, 0, 4) >= 0;

int _parseFixedDigits(String s, int start, int count) {
  if (start + count > s.length) return -1;
  var acc = 0;
  for (var i = 0; i < count; i++) {
    final c = s.codeUnitAt(start + i);
    if (!_isAsciiDigit(c)) return -1;
    acc = acc * 10 + (c - 0x30);
  }
  return acc;
}

(int year, int month, int day)? _parseCalendarDate(String s) {
  if (s.length < 10 || s.codeUnitAt(4) != 0x2d || s.codeUnitAt(7) != 0x2d) {
    return null;
  }
  final year = _parseFixedDigits(s, 0, 4);
  final month = _parseFixedDigits(s, 5, 2);
  final day = _parseFixedDigits(s, 8, 2);
  if (year < 0 || month < 1 || month > 12) return null;
  final maxDay = _daysInMonth(year, month);
  if (day < 1 || day > maxDay) return null;
  return (year, month, day);
}

int _daysInMonth(int year, int month) {
  const days = <int>[0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
  if (month != 2) return days[month];
  final isLeap = (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
  return isLeap ? 29 : 28;
}

(_ParsedTime, int)? _parseTimePart(String s, int start) {
  if (start + 8 > s.length ||
      s.codeUnitAt(start + 2) != 0x3a ||
      s.codeUnitAt(start + 5) != 0x3a) {
    return null;
  }
  final hour = _parseFixedDigits(s, start, 2);
  final minute = _parseFixedDigits(s, start + 3, 2);
  final second = _parseFixedDigits(s, start + 6, 2);
  if (hour < 0 || hour > 23 || minute < 0 || minute > 59) return null;
  if (second < 0 || second > 59) return null;

  final fracPos = start + 8;
  if (fracPos >= s.length || s.codeUnitAt(fracPos) != 0x2e) {
    return (
      _ParsedTime(
        hour: hour,
        minute: minute,
        second: second,
        millisecond: 0,
        microsecond: 0,
      ),
      fracPos,
    );
  }
  final subsecond = _parseSubsecondMicros(s, fracPos + 1);
  if (subsecond == null) return null;
  final (micros, nextIdx) = subsecond;
  return (
    _ParsedTime(
      hour: hour,
      minute: minute,
      second: second,
      millisecond: micros ~/ 1000,
      microsecond: micros % 1000,
    ),
    nextIdx,
  );
}

(int totalMicros, int nextIndex)? _parseSubsecondMicros(String s, int start) {
  var idx = start;
  var micros = 0;
  var scale = 100000;
  while (idx < s.length && _isAsciiDigit(s.codeUnitAt(idx))) {
    if (scale > 0) {
      micros += (s.codeUnitAt(idx) - 0x30) * scale;
      scale ~/= 10;
    }
    idx++;
  }
  return idx == start ? null : (micros, idx);
}

int? _parseTimeOffsetMinutes(String s, int start) {
  if (start >= s.length) return null;
  final ch = s.codeUnitAt(start);
  if (ch == 0x5a || ch == 0x7a) {
    return start + 1 == s.length ? 0 : null;
  }
  if ((ch != 0x2b && ch != 0x2d) ||
      start + 6 != s.length ||
      s.codeUnitAt(start + 3) != 0x3a) {
    return null;
  }
  final offH = _parseFixedDigits(s, start + 1, 2);
  final offM = _parseFixedDigits(s, start + 4, 2);
  if (offH < 0 || offH > 23 || offM < 0 || offM > 59) return null;
  final total = offH * 60 + offM;
  return ch == 0x2d ? -total : total;
}
