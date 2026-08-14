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

  /// Returns `true` if the current object or array has more elements.
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

  /// Reads a contiguous JSON array of doubles as a [List<double>].
  List<double> readDoubleList();

  /// Reads a contiguous JSON array of doubles as an unboxed [Float64List].
  Float64List readFloat64List();

  /// Reads a contiguous JSON array of integers as a [List<int>].
  List<int> readIntList();

  /// Reads a boolean value.
  bool readBool();

  /// Reads a null literal.
  void readNull();

  /// Skips the entire next value (including nested objects and arrays).
  void skipValue();

  /// Returns the raw byte span `(start, end)` of the current token.
  (int start, int end) getTokenSpan();
}

final class _MockJsonTokenReader implements JsonTokenReader {
  final Uint8List _bytes;
  int _offset = 0;

  _MockJsonTokenReader(this._bytes);

  void _skipWs() {
    while (_offset < _bytes.length && _bytes[_offset] <= 32) {
      _offset++;
    }
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
    } else {
      throw FormatException('Expected "{" at offset $_offset');
    }
  }

  @override
  void endObject() {
    _skipWs();
    if (_offset < _bytes.length && _bytes[_offset] == 125) {
      _offset++;
      _consumeTrailingComma();
    } else {
      throw FormatException('Expected "}" at offset $_offset');
    }
  }

  @override
  void beginArray() {
    _skipWs();
    if (_offset < _bytes.length && _bytes[_offset] == 91) {
      _offset++;
    } else {
      throw FormatException('Expected "[" at offset $_offset');
    }
  }

  @override
  void endArray() {
    _skipWs();
    if (_offset < _bytes.length && _bytes[_offset] == 93) {
      _offset++;
      _consumeTrailingComma();
    } else {
      throw FormatException('Expected "]" at offset $_offset');
    }
  }

  @override
  bool hasNext() {
    _skipWs();
    if (_offset >= _bytes.length) return false;
    final b = _bytes[_offset];
    return b != 125 && b != 93; // not '}' and not ']'
  }

  void _consumeColon() {
    _skipWs();
    if (_offset < _bytes.length && _bytes[_offset] == 58) {
      _offset++;
    } else {
      throw FormatException('Expected ":" at offset $_offset');
    }
  }

  void _consumeTrailingComma() {
    _skipWs();
    if (_offset < _bytes.length && _bytes[_offset] == 44) {
      _offset++;
    }
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
      if (b == 92) {
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
  String nextName() {
    final (start, end) = _scanStringSpan();
    _consumeColon();
    return decodeStringUtf8(_bytes, start, end);
  }

  @override
  int selectName(JsonKeyOptions options) {
    final (start, end) = _scanStringSpan();
    _consumeColon();
    return options.selectKey(_bytes, start, end);
  }

  @override
  int selectString(JsonKeyOptions options) {
    final (start, end) = _scanStringSpan();
    _consumeTrailingComma();
    return options.selectKey(_bytes, start, end);
  }

  @override
  String readString() {
    final (start, end) = _scanStringSpan();
    _consumeTrailingComma();
    return decodeStringUtf8(_bytes, start, end);
  }

  (int, int) _scanValueSpan() {
    _skipWs();
    final start = _offset;
    var i = start;
    while (i < _bytes.length) {
      final b = _bytes[i];
      if (b == 44 || b == 125 || b == 93 || b <= 32) {
        break;
      }
      i++;
    }
    _offset = i;
    _consumeTrailingComma();
    return (start, i);
  }

  @override
  int readInt() {
    final (start, end) = _scanValueSpan();
    return parseIntUtf8(_bytes, start, end);
  }

  @override
  double readDouble() {
    final (start, end) = _scanValueSpan();
    return parseDoubleUtf8(_bytes, start, end);
  }

  @override
  List<double> readDoubleList() {
    beginArray();
    final list = <double>[];
    while (hasNext()) {
      list.add(readDouble());
    }
    endArray();
    return list;
  }

  @override
  Float64List readFloat64List() {
    beginArray();
    final list = <double>[];
    while (hasNext()) {
      list.add(readDouble());
    }
    endArray();
    return Float64List.fromList(list);
  }

  @override
  List<int> readIntList() {
    beginArray();
    final list = <int>[];
    while (hasNext()) {
      list.add(readInt());
    }
    endArray();
    return list;
  }

  @override
  num readNum() {
    final (start, end) = _scanValueSpan();
    final asInt = tryParseIntUtf8(_bytes, start, end);
    if (asInt != null) return asInt;
    return parseDoubleUtf8(_bytes, start, end);
  }

  @override
  bool readBool() {
    final (start, end) = _scanValueSpan();
    return parseBoolUtf8(_bytes, start, end);
  }

  @override
  void readNull() {
    final (start, end) = _scanValueSpan();
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
      // object
      var depth = 1;
      _offset++;
      while (_offset < _bytes.length && depth > 0) {
        final c = _bytes[_offset++];
        if (c == 34) {
          // skip string
          while (_offset < _bytes.length) {
            final sc = _bytes[_offset++];
            if (sc == 92) {
              _offset++;
            } else if (sc == 34) {
              break;
            }
          }
        } else if (c == 123) {
          depth++;
        } else if (c == 125) {
          depth--;
        }
      }
    } else if (b == 91) {
      // array
      var depth = 1;
      _offset++;
      while (_offset < _bytes.length && depth > 0) {
        final c = _bytes[_offset++];
        if (c == 34) {
          while (_offset < _bytes.length) {
            final sc = _bytes[_offset++];
            if (sc == 92) {
              _offset++;
            } else if (sc == 34) {
              break;
            }
          }
        } else if (c == 91) {
          depth++;
        } else if (c == 93) {
          depth--;
        }
      }
    } else if (b == 34) {
      _scanStringSpan();
    } else {
      _scanValueSpan();
    }
    _consumeTrailingComma();
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
