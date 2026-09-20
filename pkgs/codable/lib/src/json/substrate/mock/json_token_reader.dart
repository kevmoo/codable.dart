import 'dart:typed_data';

import 'json_key_options.dart';
import 'json_token_type.dart';
import 'span_parsers.dart';

/// Pull-based JSON token reader over contiguous UTF-8 bytes.
abstract interface class JsonTokenReader {
  /// Instantiates a pull-based token reader over [bytes].
  factory JsonTokenReader.fromBytes(Uint8List bytes) = _MockJsonTokenReader;

  /// Instantiates a streaming token reader over a list of chunks.
  factory JsonTokenReader.fromChunks(List<Uint8List> chunks) =
      _MockJsonTokenReader.fromChunks;

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

  Uint8List _bytes;
  int _offset = 0;
  final List<Uint8List>? _chunks;
  int _chunkIndex = 0;
  bool _isStitched = false;

  _MockJsonTokenReader(this._bytes) : _chunks = null;

  @pragma('vm:prefer-inline')
  @pragma('wasm:prefer-inline')
  void _normalizeStitched() {
    if (_isStitched) {
      final lastChunk = _chunks![_chunkIndex];
      final prefixLen = _bytes.length - lastChunk.length;
      if (_offset >= prefixLen) {
        _offset -= prefixLen;
        _bytes = lastChunk;
        _isStitched = false;
      }
    }
  }

  _MockJsonTokenReader.fromChunks(List<Uint8List> chunks)
    : _chunks = chunks,
      _bytes = chunks.isEmpty ? Uint8List(0) : chunks[0];

  @pragma('vm:prefer-inline')
  @pragma('wasm:prefer-inline')
  bool _advanceChunk() {
    if (_chunks == null) return false;
    _chunkIndex++;
    if (_chunkIndex < _chunks.length) {
      _bytes = _chunks[_chunkIndex];
      _offset = 0;
      return true;
    }
    return false;
  }

  @pragma('vm:prefer-inline')
  @pragma('wasm:prefer-inline')
  bool _stitchNextChunk() {
    if (_chunks == null || _chunkIndex + 1 >= _chunks.length) {
      return false;
    }
    final next = _chunks[_chunkIndex + 1];
    final stitched = Uint8List(_bytes.length + next.length);
    stitched.setAll(0, _bytes);
    stitched.setAll(_bytes.length, next);
    _bytes = stitched;
    _chunkIndex++;
    _isStitched = true;
    return true;
  }

  final List<String?> _stringCache = List<String?>.filled(
    _stringCacheSize,
    null,
  );

  final List<int> _types = <int>[];
  final List<int> _states = <int>[];
  int _stackLength = 0;
  int _topType = 0;
  int _topState = 0;
  bool _hasReadRoot = false;

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
    _normalizeStitched();
    while (true) {
      while (_offset < _bytes.length && _isWs(_bytes[_offset])) {
        _offset++;
      }
      if (_offset < _bytes.length) return;
      if (!_advanceChunk()) return;
    }
  }

  @pragma('vm:prefer-inline')
  @pragma('wasm:prefer-inline')
  void _beforeReadingName() {
    _skipWs();
    if (_stackLength > 0 && _topType == 0) {
      if (_topState == 0 || _topState == 3) {
        _topState = 1;
      } else if (_topState == 2) {
        if (_offset < _bytes.length && _bytes[_offset] == 44) {
          _offset++;
          _topState = 1;
          _skipWs();
        } else {
          throw FormatException(
            'Expected "," before property name at offset $_offset',
          );
        }
      } else {
        throw FormatException('Expected property name at offset $_offset');
      }
    } else {
      throw FormatException('Unexpected property name at offset $_offset');
    }
  }

  @pragma('vm:prefer-inline')
  @pragma('wasm:prefer-inline')
  void _beforeReadingValue() {
    _skipWs();
    if (_stackLength > 0) {
      if (_topType == 0) {
        if (_topState != 1) {
          throw FormatException(
            'Expected property name before value at offset $_offset',
          );
        }
      } else {
        if (_topState == 2) {
          if (_offset < _bytes.length && _bytes[_offset] == 44) {
            _offset++;
            _topState = 3;
            _skipWs();
          } else {
            throw FormatException(
              'Expected "," before array element at offset $_offset',
            );
          }
        }
      }
    } else {
      if (_hasReadRoot) {
        throw FormatException(
          'Cannot read multiple root values',
          _bytes,
          _offset,
        );
      }
    }
  }

  @pragma('vm:prefer-inline')
  @pragma('wasm:prefer-inline')
  void _afterReadingValue() {
    if (_stackLength > 0) {
      _topState = 2;
    } else {
      _hasReadRoot = true;
    }
  }

  @pragma('vm:prefer-inline')
  @pragma('wasm:prefer-inline')
  static JsonTokenType _valueTokenType(int b) {
    switch (b) {
      case 123:
        return JsonTokenType.beginObject;
      case 91:
        return JsonTokenType.beginArray;
      case 34:
        return JsonTokenType.string;
      case 116:
      case 102:
        return JsonTokenType.boolean;
      case 110:
        return JsonTokenType.nullValue;
      case 45:
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
  @pragma('vm:prefer-inline')
  @pragma('wasm:prefer-inline')
  JsonTokenType peek() {
    _skipWs();
    if (_offset >= _bytes.length) {
      if (_stackLength > 0 && _topState == 3) {
        throw FormatException(
          'Unexpected end of document after comma',
          _bytes,
          _offset,
        );
      }
      return JsonTokenType.endOfDocument;
    }

    if (_stackLength > 0) {
      if (_topType == 0) {
        switch (_topState) {
          case 0:
            if (_bytes[_offset] == 125) return JsonTokenType.endObject;
            if (_bytes[_offset] == 34) return JsonTokenType.propertyName;
            return JsonTokenType.none;
          case 1:
            return _valueTokenType(_bytes[_offset]);
          case 3:
            if (_bytes[_offset] == 34) return JsonTokenType.propertyName;
            if (_bytes[_offset] == 125 || _bytes[_offset] == 93) {
              throw FormatException(
                'Trailing comma before closing delimiter',
                _bytes,
                _offset,
              );
            }
            return JsonTokenType.none;
          case 2:
            if (_bytes[_offset] == 125) return JsonTokenType.endObject;
            if (_bytes[_offset] == 44) {
              var i = _offset + 1;
              while (true) {
                while (i < _bytes.length && _isWs(_bytes[i])) {
                  i++;
                }
                if (i < _bytes.length) break;
                if (!_stitchNextChunk()) break; // EOF
              }
              if (i >= _bytes.length) {
                throw FormatException(
                  'Unexpected end of document after comma',
                  _bytes,
                  _offset,
                );
              }
              if (_bytes[i] == 125 || _bytes[i] == 93) {
                throw FormatException(
                  'Trailing comma before closing delimiter',
                  _bytes,
                  _offset,
                );
              }
              if (_bytes[i] == 34) return JsonTokenType.propertyName;
              return JsonTokenType.none;
            }
            throw FormatException(
              'Expected comma or closing delimiter',
              _bytes,
              _offset,
            );
        }
      } else {
        switch (_topState) {
          case 0:
            if (_bytes[_offset] == 93) return JsonTokenType.endArray;
            return _valueTokenType(_bytes[_offset]);
          case 3:
            if (_bytes[_offset] == 125 || _bytes[_offset] == 93) {
              throw FormatException(
                'Trailing comma before closing delimiter',
                _bytes,
                _offset,
              );
            }
            return _valueTokenType(_bytes[_offset]);
          case 2:
            if (_bytes[_offset] == 93) return JsonTokenType.endArray;
            if (_bytes[_offset] == 44) {
              var i = _offset + 1;
              while (true) {
                while (i < _bytes.length && _isWs(_bytes[i])) {
                  i++;
                }
                if (i < _bytes.length) break;
                if (!_stitchNextChunk()) break; // EOF
              }
              if (i >= _bytes.length) {
                throw FormatException(
                  'Unexpected end of document after comma',
                  _bytes,
                  _offset,
                );
              }
              if (_bytes[i] == 125 || _bytes[i] == 93) {
                throw FormatException(
                  'Trailing comma before closing delimiter',
                  _bytes,
                  _offset,
                );
              }
              return _valueTokenType(_bytes[i]);
            }
            throw FormatException(
              'Expected comma or closing delimiter',
              _bytes,
              _offset,
            );
        }
      }
    } else {
      if (_hasReadRoot) {
        throw FormatException(
          'Unexpected trailing characters after root value',
          _bytes,
          _offset,
        );
      }
      return _valueTokenType(_bytes[_offset]);
    }
    return JsonTokenType.none;
  }

  @override
  void beginObject() {
    _beforeReadingValue();
    if (_offset < _bytes.length && _bytes[_offset] == 123) {
      if (_stackLength >= 1000) {
        throw FormatException(
          'Nesting depth exceeds limit of 1000 at offset $_offset',
        );
      }
      _offset++;
      if (_stackLength > 0) {
        _types.add(_topType);
        _states.add(_topState);
      }
      _stackLength++;
      _topType = 0;
      _topState = 0;
    } else {
      throw FormatException('Expected "{" at offset $_offset');
    }
  }

  @override
  void endObject() {
    _skipWs();
    if (_stackLength > 0 && _topType == 0) {
      if (_topState == 1 || _topState == 3) {
        throw FormatException('Mismatched endObject at offset $_offset');
      }
      if (_offset < _bytes.length && _bytes[_offset] == 125) {
        _offset++;
        _stackLength--;
        if (_stackLength > 0) {
          _topState = _states.removeLast();
          _topType = _types.removeLast();
          _topState = 2;
        } else {
          _topType = 0;
          _topState = 0;
          _hasReadRoot = true;
        }
      } else {
        throw FormatException('Expected "}" at offset $_offset');
      }
    } else {
      throw FormatException('Mismatched endObject at offset $_offset');
    }
  }

  @override
  void beginArray() {
    _beforeReadingValue();
    if (_offset < _bytes.length && _bytes[_offset] == 91) {
      if (_stackLength >= 1000) {
        throw FormatException(
          'Nesting depth exceeds limit of 1000 at offset $_offset',
        );
      }
      _offset++;
      if (_stackLength > 0) {
        _types.add(_topType);
        _states.add(_topState);
      }
      _stackLength++;
      _topType = 1;
      _topState = 0;
    } else {
      throw FormatException('Expected "[" at offset $_offset');
    }
  }

  @override
  void endArray() {
    _skipWs();
    if (_stackLength > 0 && _topType == 1) {
      if (_topState == 3) {
        throw FormatException('Trailing comma not allowed at offset $_offset');
      }
      if (_offset < _bytes.length && _bytes[_offset] == 93) {
        _offset++;
        _stackLength--;
        if (_stackLength > 0) {
          _topState = _states.removeLast();
          _topType = _types.removeLast();
          _topState = 2;
        } else {
          _topType = 0;
          _topState = 0;
          _hasReadRoot = true;
        }
      } else {
        throw FormatException('Expected "]" at offset $_offset');
      }
    } else {
      throw FormatException('Mismatched endArray at offset $_offset');
    }
  }

  @override
  bool hasNext() {
    _skipWs();
    if (_offset >= _bytes.length) {
      if (_stackLength > 0 && _topState == 3) {
        throw const FormatException('Unexpected end of document after comma');
      }
      return false;
    }
    if (_stackLength == 0) {
      if (_hasReadRoot) {
        throw FormatException(
          'Unexpected trailing characters after root value',
          _bytes,
          _offset,
        );
      }
      return true;
    }

    final closeChar = _topType == 0 ? 125 : 93;
    final b = _bytes[_offset];

    if (b == closeChar) {
      if (_topState == 3) {
        throw FormatException('Trailing comma not allowed at offset $_offset');
      }
      return false;
    }

    if (_topState == 0) {
      if (b == 44) {
        throw FormatException('Unexpected leading comma at offset $_offset');
      }
      return true;
    }

    if (_topState == 2) {
      if (b != 44) {
        throw FormatException(
          'Expected "," or "${String.fromCharCode(closeChar)}" '
          'at offset $_offset',
        );
      }
      _offset++;
      _topState = 3;
      _skipWs();
      if (_offset < _bytes.length && _bytes[_offset] == closeChar) {
        throw FormatException('Trailing comma not allowed at offset $_offset');
      }
      if (_offset >= _bytes.length) {
        throw const FormatException('Unexpected end of document after comma');
      }
      return true;
    }

    return true;
  }

  @pragma('vm:prefer-inline')
  @pragma('wasm:prefer-inline')
  (int, int, bool) _scanPropertyName() {
    _beforeReadingName();

    var i = _offset;
    if (i >= _bytes.length || _bytes[i] != 34) {
      throw FormatException('Expected string at offset $i');
    }
    final start = i + 1;
    i = start;
    var hasEscapes = false;
    while (true) {
      while (i < _bytes.length) {
        final b = _bytes[i];
        if (b < 0x20) {
          throw FormatException(
            'Unescaped control character 0x${b.toRadixString(16)} at offset $i',
          );
        }
        if (b == 92) {
          hasEscapes = true;
          while (i + 1 >= _bytes.length) {
            if (!_stitchNextChunk()) {
              throw FormatException(
                'Unterminated escape sequence at offset $i',
              );
            }
          }
          i += 2;
        } else if (b == 34) {
          break;
        } else {
          i++;
        }
      }
      if (i < _bytes.length && _bytes[i] == 34) {
        break;
      }
      if (!_stitchNextChunk()) {
        throw FormatException('Unterminated string literal at offset $start');
      }
    }
    final end = i;
    i++; // Advance past closing quote

    // Fused colon consumption & trailing whitespace
    while (true) {
      if (i < _bytes.length && _bytes[i] == 58) {
        i++;
        break;
      }
      while (i < _bytes.length && _isWs(_bytes[i])) {
        i++;
      }
      if (i < _bytes.length) {
        if (_bytes[i] != 58) throw FormatException('Expected ":" at offset $i');
        i++;
        break;
      }
      if (!_stitchNextChunk()) {
        throw FormatException('Expected ":" at offset $i');
      }
    }

    while (true) {
      while (i < _bytes.length && _isWs(_bytes[i])) {
        i++;
      }
      if (i < _bytes.length) break;
      if (!_stitchNextChunk()) break;
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
    while (true) {
      while (i < _bytes.length) {
        final b = _bytes[i];
        if (b < 0x20) {
          throw FormatException(
            'Unescaped control character 0x${b.toRadixString(16)} at offset $i',
          );
        }
        if (b == 92) {
          while (i + 1 >= _bytes.length) {
            if (!_stitchNextChunk()) {
              throw FormatException(
                'Unterminated escape sequence at offset $i',
              );
            }
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
      if (!_stitchNextChunk()) {
        throw FormatException('Unterminated string literal at offset $start');
      }
    }
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
  (int start, int end) readStringSpan() {
    _beforeReadingValue();
    final span = _scanStringSpan();
    _afterReadingValue();
    return span;
  }

  @override
  @pragma('vm:prefer-inline')
  @pragma('wasm:prefer-inline')
  int selectString(JsonKeyOptions options) {
    _beforeReadingValue();
    final (start, end) = _scanStringSpan();
    _afterReadingValue();
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
    _beforeReadingValue();
    final (start, end) = _scanStringSpan();
    _afterReadingValue();
    return _decodeCachedString(start, end);
  }

  (int, int) _scanValueSpan() {
    _skipWs();
    final start = _offset;
    var i = start;
    while (true) {
      while (i < _bytes.length) {
        final b = _bytes[i];
        if (b == 44 || b == 125 || b == 93 || _isWs(b)) {
          break;
        }
        i++;
      }
      if (i < _bytes.length) break;
      if (!_stitchNextChunk()) break;
    }
    _offset = i;
    return (start, i);
  }

  @override
  int readInt() {
    _beforeReadingValue();
    final (start, end) = _scanValueSpan();
    _afterReadingValue();
    return parseIntUtf8(_bytes, start, end);
  }

  @override
  double readDouble() {
    _beforeReadingValue();
    final (start, end) = _scanValueSpan();
    _afterReadingValue();
    return parseDoubleUtf8(_bytes, start, end);
  }

  @override
  num readNum() {
    _beforeReadingValue();
    final (start, end) = _scanValueSpan();
    _afterReadingValue();
    final asInt = tryParseIntUtf8(_bytes, start, end);
    if (asInt != null) return asInt;
    return parseDoubleUtf8(_bytes, start, end);
  }

  @override
  bool readBool() {
    _beforeReadingValue();
    final (start, end) = _scanValueSpan();
    _afterReadingValue();
    return parseBoolUtf8(_bytes, start, end);
  }

  @override
  void readNull() {
    _beforeReadingValue();
    final (start, end) = _scanValueSpan();
    _afterReadingValue();
    if (!isNullUtf8(_bytes, start, end)) {
      throw FormatException('Expected null at offset $start');
    }
  }

  @override
  void skipValue() {
    _skipWs();
    if (_offset >= _bytes.length) {
      throw FormatException(
        'Unexpected end of document at offset $_offset',
        _bytes,
        _offset,
      );
    }

    if (_stackLength > 0 &&
        _topType == 0 &&
        (_topState == 0 || _topState == 2 || _topState == 3)) {
      nextName();
      skipValue();
      return;
    }

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
      _beforeReadingValue();
      final (start, end) = _scanStringSpan();
      decodeStringUtf8(_bytes, start, end); // validates
      _afterReadingValue();
    } else {
      _beforeReadingValue();
      final (start, end) = _scanValueSpan();
      if (start == end) {
        throw FormatException(
          'Unexpected token at offset $start',
          _bytes,
          start,
        );
      }
      if (!isNullUtf8(_bytes, start, end) &&
          tryParseBoolUtf8(_bytes, start, end) == null &&
          tryParseIntUtf8(_bytes, start, end) == null &&
          tryParseDoubleUtf8(_bytes, start, end) == null) {
        throw FormatException(
          'Invalid JSON value in byte span [$start, $end)',
          _bytes,
          start,
        );
      }
      _afterReadingValue();
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
