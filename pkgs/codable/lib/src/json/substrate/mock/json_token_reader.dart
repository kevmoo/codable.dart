import 'dart:typed_data';

import 'json_key_options.dart';
import 'json_token_type.dart';
import 'span_parsers.dart';

/// Pull-based JSON token reader over contiguous UTF-8 bytes.
abstract interface class JsonTokenReader {
  /// Instantiates a pull-based token reader over [bytes].
  factory JsonTokenReader.fromBytes(Uint8List bytes) = _MockJsonTokenReader;

  /// Peeks at the next token type without advancing the cursor.
  JsonTokenType peek();

  /// Advances past the opening `{` of an object.
  void beginObject();

  /// Advances past the closing `}` of an object.
  void endObject();

  /// Advances past the opening `[` of an array.
  void beginArray();

  /// Advances past the closing `]` of an array.
  void endArray();

  /// Whether the current object or array has more elements.
  bool hasNext();

  /// Reads the next object property name as a [String].
  String nextName();

  /// Matches the next property name against pre-compiled [options] in O(1).
  int selectName(JsonKeyOptions options);

  /// Matches the next string VALUE against pre-compiled [options] in O(1)
  /// without allocating a heap [String] (e.g. for parsing string enums).
  int selectString(JsonKeyOptions options);

  /// Reads a string value.
  String readString();

  /// Reads an integer value.
  int readInt();

  /// Reads a double value (with automatic integer-to-double coercion).
  double readDouble();

  /// Reads a numeric token as a [num] (either [int] or [double]).
  num readNum();

  /// Reads a boolean value.
  bool readBool();

  /// Reads a null literal.
  void readNull();

  /// Skips the entire next value (including nested objects and arrays).
  void skipValue();

  /// Exposes the underlying byte payload buffer.
  Uint8List get bytes;

  /// Reads the next string token and returns its raw byte span `(start, end)`.
  (int start, int end) readStringSpan();

  /// The raw byte span `(start, end)` of the current token.
  (int start, int end) getTokenSpan();
}

final class _MockJsonTokenReader implements JsonTokenReader {
  static const int _stringCacheSize = 128;
  static const int _stringCacheMask = 127;
  static const int _maxCachedStringLength = 64;

  static const int _containerArray = 1;
  static const int _containerObject = 2;

  final Uint8List _bytes;
  int _offset = 0;
  final List<String?> _stringCache = List<String?>.filled(
    _stringCacheSize,
    null,
  );

  final List<int> _containerTypes = <int>[];
  final List<int> _elementCounts = <int>[];
  final List<int> _lastCheckedOffsets = <int>[];

  _MockJsonTokenReader(this._bytes);

  String _decodeCachedString(int start, int end) {
    final len = end - start;
    if (len == 0) return '';
    if (len > _maxCachedStringLength) {
      return decodeStringUtf8(_bytes, start, end);
    }

    var h = len;
    for (var i = start; i < end; i++) {
      h = (h * 31 + _bytes[i]) & 0x3fffffff;
    }
    final slot = h & _stringCacheMask;
    final cached = _stringCache[slot];
    if (cached != null && cached.length == len) {
      var match = true;
      for (var i = 0; i < len; i++) {
        final b = _bytes[start + i];
        if (b > 0x7F || b != cached.codeUnitAt(i)) {
          match = false;
          break;
        }
      }
      if (match) {
        return cached;
      }
    }

    final s = decodeStringUtf8(_bytes, start, end);
    _stringCache[slot] = s;
    return s;
  }

  @override
  Uint8List get bytes => _bytes;

  @pragma('vm:prefer-inline')
  @pragma('wasm:prefer-inline')
  static bool _isWs(int b) => b == 0x20 || b == 0x0A || b == 0x0D || b == 0x09;

  @pragma('vm:prefer-inline')
  @pragma('wasm:prefer-inline')
  void _skipWs() {
    while (_offset < _bytes.length && _isWs(_bytes[_offset])) {
      _offset++;
    }
  }

  @pragma('vm:prefer-inline')
  @pragma('wasm:prefer-inline')
  void _onValueRead() {
    if (_containerTypes.isNotEmpty) {
      _elementCounts[_containerTypes.length - 1]++;
    }
  }

  @override
  (int start, int end) readStringSpan() {
    final span = _scanStringSpan();
    _onValueRead();
    return span;
  }

  @override
  JsonTokenType peek() {
    _skipWs();
    if (_offset >= _bytes.length) return JsonTokenType.endOfDocument;
    final b = _bytes[_offset];
    switch (b) {
      case 123: // '{'
        return JsonTokenType.beginObject;
      case 125: // '}'
        return JsonTokenType.endObject;
      case 91: // '['
        return JsonTokenType.beginArray;
      case 93: // ']'
        return JsonTokenType.endArray;
      case 34: // '"'
        return JsonTokenType.string;
      case 116: // 't'
      case 102: // 'f'
        return JsonTokenType.boolean;
      case 110: // 'n'
        return JsonTokenType.nullValue;
      case 45: // '-'
      case 48:
      case 49:
      case 50:
      case 51:
      case 52:
      case 53:
      case 54:
      case 55:
      case 56:
      case 57:
        return JsonTokenType.number;
      default:
        return JsonTokenType.none;
    }
  }

  @override
  void beginObject() {
    _skipWs();
    if (_offset < _bytes.length && _bytes[_offset] == 123) {
      _offset++;
      _containerTypes.add(_containerObject);
      _elementCounts.add(0);
      _lastCheckedOffsets.add(-1);
    } else {
      throw FormatException('Expected "{" at offset $_offset');
    }
  }

  @override
  void endObject() {
    _skipWs();
    if (_containerTypes.isEmpty || _containerTypes.last != _containerObject) {
      throw FormatException('Mismatched endObject at offset $_offset');
    }
    if (_offset < _bytes.length && _bytes[_offset] == 125) {
      _offset++;
      _containerTypes.removeLast();
      _elementCounts.removeLast();
      _lastCheckedOffsets.removeLast();
      _onValueRead();
    } else {
      throw FormatException('Expected "}" at offset $_offset');
    }
  }

  @override
  void beginArray() {
    _skipWs();
    if (_offset < _bytes.length && _bytes[_offset] == 91) {
      _offset++;
      _containerTypes.add(_containerArray);
      _elementCounts.add(0);
      _lastCheckedOffsets.add(-1);
    } else {
      throw FormatException('Expected "[" at offset $_offset');
    }
  }

  @override
  void endArray() {
    _skipWs();
    if (_containerTypes.isEmpty || _containerTypes.last != _containerArray) {
      throw FormatException('Mismatched endArray at offset $_offset');
    }
    if (_offset < _bytes.length && _bytes[_offset] == 93) {
      _offset++;
      _containerTypes.removeLast();
      _elementCounts.removeLast();
      _lastCheckedOffsets.removeLast();
      _onValueRead();
    } else {
      throw FormatException('Expected "]" at offset $_offset');
    }
  }

  @override
  bool hasNext() {
    _skipWs();
    if (_offset >= _bytes.length) return false;
    if (_containerTypes.isEmpty) {
      return _offset < _bytes.length;
    }
    final depth = _containerTypes.length - 1;
    final type = _containerTypes[depth];
    final closeChar = type == _containerArray ? 93 : 125; // ']' or '}'
    final count = _elementCounts[depth];

    if (_bytes[_offset] == closeChar) {
      return false;
    }

    if (count == 0) {
      if (_bytes[_offset] == 44) {
        throw FormatException('Unexpected leading comma at offset $_offset');
      }
      return true;
    }

    if (_lastCheckedOffsets[depth] == _offset) {
      return true;
    }

    if (_bytes[_offset] != 44) {
      throw FormatException(
        'Expected "," or "${String.fromCharCode(closeChar)}" '
        'at offset $_offset',
      );
    }
    _offset++;
    _skipWs();
    if (_offset < _bytes.length && _bytes[_offset] == closeChar) {
      throw FormatException('Trailing comma not allowed at offset $_offset');
    }
    _lastCheckedOffsets[depth] = _offset;
    return true;
  }

  @pragma('vm:prefer-inline')
  @pragma('wasm:prefer-inline')
  (int, int, bool) _scanPropertyName() {
    var i = _offset;
    while (i < _bytes.length && _isWs(_bytes[i])) {
      i++;
    }
    if (i >= _bytes.length || _bytes[i] != 34) {
      throw FormatException('Expected string at offset $i');
    }
    final start = i + 1;
    i = start;
    var hasEscapes = false;
    while (i < _bytes.length) {
      final b = _bytes[i];
      if (b < 0x20) {
        throw FormatException(
          'Unescaped control character 0x${b.toRadixString(16)} at offset $i',
        );
      }
      if (b == 92) {
        hasEscapes = true;
        if (i + 1 >= _bytes.length) {
          throw FormatException('Unterminated escape sequence at offset $i');
        }
        i += 2;
      } else if (b == 34) {
        break;
      } else {
        i++;
      }
    }
    if (i >= _bytes.length) {
      throw FormatException('Unterminated string literal at offset $start');
    }
    final end = i;
    i++; // Advance past closing quote

    // Fused colon consumption & trailing whitespace
    if (i < _bytes.length && _bytes[i] == 58) {
      i++;
    } else {
      while (i < _bytes.length && _isWs(_bytes[i])) {
        i++;
      }
      if (i >= _bytes.length || _bytes[i] != 58) {
        throw FormatException('Expected ":" at offset $i');
      }
      i++;
    }
    while (i < _bytes.length && _isWs(_bytes[i])) {
      i++;
    }
    _offset = i;
    return (start, end, hasEscapes);
  }

  (int, int) _scanStringSpan() {
    _skipWs();
    if (_offset >= _bytes.length || _bytes[_offset] != 34) {
      throw FormatException('Expected string at offset $_offset');
    }
    final start = _offset + 1;
    var i = start;
    while (i < _bytes.length) {
      final b = _bytes[i];
      if (b < 0x20) {
        throw FormatException(
          'Unescaped control character 0x${b.toRadixString(16)} at offset $i',
        );
      }
      if (b == 92) {
        if (i + 1 >= _bytes.length) {
          throw FormatException('Unterminated escape sequence at offset $i');
        }
        i += 2;
      } else if (b == 34) {
        final end = i;
        _offset = i + 1;
        return (start, end);
      } else {
        i++;
      }
    }
    throw FormatException('Unterminated string literal at offset $start');
  }

  @override
  @pragma('vm:prefer-inline')
  @pragma('wasm:prefer-inline')
  String nextName() {
    final (start, end, _) = _scanPropertyName();
    return _decodeCachedString(start, end);
  }

  @override
  @pragma('vm:prefer-inline')
  @pragma('wasm:prefer-inline')
  int selectName(JsonKeyOptions options) {
    final (start, end, hasEscapes) = _scanPropertyName();
    if (!hasEscapes) {
      return options.selectKey(_bytes, start, end);
    }
    final unescaped = _decodeCachedString(start, end);
    return options.indexOf(unescaped);
  }

  @override
  @pragma('vm:prefer-inline')
  @pragma('wasm:prefer-inline')
  int selectString(JsonKeyOptions options) {
    final (start, end) = _scanStringSpan();
    _onValueRead();
    if (_isVerbatimUtf8(start, end)) {
      return options.selectKey(_bytes, start, end);
    }
    final unescaped = _decodeCachedString(start, end);
    return options.indexOf(unescaped);
  }

  @pragma('vm:prefer-inline')
  @pragma('wasm:prefer-inline')
  bool _isVerbatimUtf8(int start, int end) {
    for (var i = start; i < end; i++) {
      if (_bytes[i] == 92) return false;
    }
    return true;
  }

  @override
  String readString() {
    final (start, end) = _scanStringSpan();
    _onValueRead();
    return _decodeCachedString(start, end);
  }

  (int, int) _scanValueSpan() {
    _skipWs();
    final start = _offset;
    var i = start;
    while (i < _bytes.length) {
      final b = _bytes[i];
      if (b == 44 || b == 125 || b == 93 || _isWs(b)) {
        break;
      }
      i++;
    }
    _offset = i;
    return (start, i);
  }

  @override
  int readInt() {
    final (start, end) = _scanValueSpan();
    _onValueRead();
    return parseIntUtf8(_bytes, start, end);
  }

  @override
  double readDouble() {
    final (start, end) = _scanValueSpan();
    _onValueRead();
    return parseDoubleUtf8(_bytes, start, end);
  }

  @override
  num readNum() {
    final (start, end) = _scanValueSpan();
    _onValueRead();
    final asInt = tryParseIntUtf8(_bytes, start, end);
    if (asInt != null) return asInt;
    return parseDoubleUtf8(_bytes, start, end);
  }

  @override
  bool readBool() {
    final (start, end) = _scanValueSpan();
    _onValueRead();
    return parseBoolUtf8(_bytes, start, end);
  }

  @override
  void readNull() {
    final (start, end) = _scanValueSpan();
    _onValueRead();
    if (!isNullUtf8(_bytes, start, end)) {
      throw FormatException('Expected null at offset $start');
    }
  }

  @override
  void skipValue() {
    _skipWs();
    if (_offset >= _bytes.length) return;
    final b = _bytes[_offset];
    if (b == 123) {
      beginObject();
      while (hasNext()) {
        nextName();
        skipValue();
      }
      endObject();
    } else if (b == 91) {
      beginArray();
      while (hasNext()) {
        skipValue();
      }
      endArray();
    } else if (b == 34) {
      _scanStringSpan();
      _onValueRead();
    } else {
      _scanValueSpan();
      _onValueRead();
    }
  }

  @override
  (int start, int end) getTokenSpan() {
    _skipWs();
    final p = peek();
    if (p == JsonTokenType.string) {
      return _scanStringSpan();
    }
    return _scanValueSpan();
  }
}
