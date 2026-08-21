import 'dart:convert';
import 'dart:math' as math;
import 'dart:typed_data';

const List<double> _powersOfTen = [
  1.0,
  1e1,
  1e2,
  1e3,
  1e4,
  1e5,
  1e6,
  1e7,
  1e8,
  1e9,
  1e10,
  1e11,
  1e12,
  1e13,
  1e14,
  1e15,
  1e16,
  1e17,
  1e18,
  1e19,
  1e20,
  1e21,
  1e22,
];

/// Parses a 64-bit signed integer directly from the UTF-8 byte span
/// `[start, end)` in [source].
///
/// Throws [FormatException] if the byte span does not contain a valid integer,
/// or [RangeError] if [radix] is outside the range 2..36.
int parseIntUtf8(Uint8List source, int start, int end, {int? radix}) {
  final res = tryParseIntUtf8(source, start, end, radix: radix);
  if (res == null) {
    throw FormatException(
      'Invalid integer in byte span [$start, $end)',
      source,
      start,
    );
  }
  return res;
}

/// Zero-allocation fast-path integer parser operating directly on the UTF-8
/// byte span `[start, end)` in [source].
///
/// Supports radix 2 through 36 (default 10) and handles signed 64-bit integers
/// up to 19 digits (-9223372036854775808 to 9223372036854775807).
///
/// Returns `null` if the byte span is invalid, empty, or contains non-digit
/// characters.
int? tryParseIntUtf8(Uint8List source, int start, int end, {int? radix}) {
  final r = radix ?? 10;
  if (r < 2 || r > 36) throw RangeError.range(r, 2, 36, 'radix');
  if (start >= end || start < 0 || end > source.length) return null;

  var index = start;
  while (index < end && source[index] <= 32) {
    index++;
  }
  if (index >= end) return null;

  var negative = false;
  final first = source[index];
  if (first == 45) {
    // '-'
    negative = true;
    index++;
  } else if (first == 43) {
    // '+'
    index++;
  }
  if (index >= end) return null;

  var result = 0;
  var hasDigits = false;
  while (index < end) {
    final byte = source[index++];
    if (byte <= 32) {
      while (index < end) {
        if (source[index++] > 32) return null;
      }
      break;
    }
    final int digit;
    if (byte >= 48 && byte <= 57) {
      digit = byte - 48;
    } else if (byte >= 65 && byte <= 90) {
      digit = byte - 55;
    } else if (byte >= 97 && byte <= 122) {
      digit = byte - 87;
    } else {
      return null;
    }
    if (digit >= r) return null;
    hasDigits = true;
    result = result * r + digit;
  }

  if (!hasDigits) return null;
  return negative ? -result : result;
}

/// Parses a 64-bit IEEE 754 floating point number directly from the UTF-8
/// byte span `[start, end)` in [source].
///
/// Throws [FormatException] if the byte span does not contain a valid number.
double parseDoubleUtf8(Uint8List source, int start, int end) {
  final res = tryParseDoubleUtf8(source, start, end);
  if (res == null) {
    throw FormatException(
      'Invalid double in byte span [$start, $end)',
      source,
      start,
    );
  }
  return res;
}

/// Zero-allocation floating point parser operating directly on the UTF-8
/// byte span `[start, end)` in [source].
///
/// Uses mantissa accumulation and pre-computed powers of ten scaling.
/// Returns `null` if the span does not contain a valid number representation.
double? tryParseDoubleUtf8(Uint8List source, int start, int end) {
  if (start >= end || start < 0 || end > source.length) return null;

  var i = start;
  while (i < end && source[i] <= 32) {
    i++;
  }
  if (i >= end) return null;

  var negative = false;
  if (source[i] == 45) {
    // '-'
    negative = true;
    i++;
  } else if (source[i] == 43) {
    // '+'
    i++;
  }
  if (i >= end) return null;

  var integerPart = 0;
  var hasDigits = false;
  while (i < end && source[i] >= 48 && source[i] <= 57) {
    hasDigits = true;
    integerPart = integerPart * 10 + (source[i] - 48);
    i++;
  }

  var fractionalPart = 0;
  var fractionDigits = 0;
  if (i < end && source[i] == 46) {
    // '.'
    i++;
    while (i < end && source[i] >= 48 && source[i] <= 57) {
      hasDigits = true;
      fractionalPart = fractionalPart * 10 + (source[i] - 48);
      fractionDigits++;
      i++;
    }
  }

  if (!hasDigits) return null;

  var val = integerPart.toDouble();
  if (fractionDigits > 0) {
    if (fractionDigits < _powersOfTen.length) {
      val += fractionalPart / _powersOfTen[fractionDigits];
    } else {
      val += fractionalPart / math.pow(10, fractionDigits);
    }
  }

  if (i < end && (source[i] == 101 || source[i] == 69)) {
    // 'e' or 'E'
    i++;
    var expNegative = false;
    if (i < end && source[i] == 45) {
      expNegative = true;
      i++;
    } else if (i < end && source[i] == 43) {
      i++;
    }
    var exp = 0;
    var hasExpDigits = false;
    while (i < end && source[i] >= 48 && source[i] <= 57) {
      hasExpDigits = true;
      exp = exp * 10 + (source[i] - 48);
      i++;
    }
    if (!hasExpDigits) return null;
    final factor = exp < _powersOfTen.length
        ? _powersOfTen[exp]
        : math.pow(10, exp);
    val = expNegative ? val / factor : val * factor;
  }

  while (i < end && source[i] <= 32) {
    i++;
  }
  if (i < end) return null;

  return negative ? -val : val;
}

/// Parses a boolean literal (`true` or `false`) from the UTF-8 byte span
/// `[start, end)` in [source].
///
/// Throws [FormatException] if the byte span does not match `true` or `false`.
bool parseBoolUtf8(Uint8List source, int start, int end) {
  final res = tryParseBoolUtf8(source, start, end);
  if (res == null) {
    throw FormatException(
      'Invalid boolean in byte span [$start, $end)',
      source,
      start,
    );
  }
  return res;
}

/// Fast-path boolean matcher for the UTF-8 byte span `[start, end)` in
/// [source].
///
/// Returns `true` for `true`, `false` for `false`, or `null` if unmatched.
bool? tryParseBoolUtf8(Uint8List source, int start, int end) {
  final len = end - start;
  if (start < 0 || end > source.length || len < 4 || len > 5) return null;

  if (len == 4 &&
      source[start] == 116 &&
      source[start + 1] == 114 &&
      source[start + 2] == 117 &&
      source[start + 3] == 101) {
    return true;
  }
  if (len == 5 &&
      source[start] == 102 &&
      source[start + 1] == 97 &&
      source[start + 2] == 108 &&
      source[start + 3] == 115 &&
      source[start + 4] == 101) {
    return false;
  }
  return null;
}

/// Decodes the UTF-8 string slice `[start, end)` from [source] into a Dart
/// [String].
///
/// If the byte span contains no escape characters (`isVerbatimUtf8` returns
/// true), decodes the slice directly without intermediate buffers. Handles all
/// standard JSON escape sequences (`\"`, `\\`, `\/`, `\b`, `\f`, `\n`, `\r`,
/// `\t`, `\uXXXX`), including surrogate pairs.
String decodeStringUtf8(
  Uint8List source,
  int start,
  int end, {
  bool allowMalformed = false,
}) {
  if (start == end) return '';
  if (start < 0 || end > source.length || start > end) {
    throw RangeError('Invalid byte span [$start, $end)');
  }
  if (isVerbatimUtf8(source, start, end)) {
    return utf8.decode(
      Uint8List.sublistView(source, start, end),
      allowMalformed: allowMalformed,
    );
  }

  final buffer = StringBuffer();
  var i = start;
  while (i < end) {
    final byte = source[i];
    if (byte == 92) {
      // '\\'
      i++;
      if (i >= end) {
        throw FormatException('Unexpected EOF in escape sequence', source, i);
      }
      final esc = source[i++];
      switch (esc) {
        case 34:
          buffer.write('"');
        case 92:
          buffer.write('\\');
        case 47:
          buffer.write('/');
        case 98:
          buffer.write('\b');
        case 102:
          buffer.write('\f');
        case 110:
          buffer.write('\n');
        case 114:
          buffer.write('\r');
        case 116:
          buffer.write('\t');
        case 117: // \uXXXX
          if (i + 4 > end) {
            throw FormatException('Incomplete unicode escape', source, i);
          }
          final codeUnit = _parseHex4(source, i);
          i += 4;
          // Check for UTF-16 surrogate pairs
          if (codeUnit >= 0xD800 && codeUnit <= 0xDBFF) {
            if (i + 6 <= end && source[i] == 92 && source[i + 1] == 117) {
              final low = _parseHex4(source, i + 2);
              if (low >= 0xDC00 && low <= 0xDFFF) {
                i += 6;
                final codePoint =
                    0x10000 + ((codeUnit - 0xD800) << 10) + (low - 0xDC00);
                buffer.writeCharCode(codePoint);
                break;
              }
            }
          }
          buffer.writeCharCode(codeUnit);
        default:
          throw FormatException(
            'Invalid escape character: ${String.fromCharCode(esc)}',
            source,
            i - 1,
          );
      }
    } else {
      final charLen = _utf8SequenceLength(byte);
      if (i + charLen > end) {
        if (allowMalformed) {
          buffer.write('\uFFFD');
          i++;
          continue;
        }
        throw FormatException('Truncated UTF-8 multibyte sequence', source, i);
      }
      buffer.write(
        utf8.decode(
          Uint8List.sublistView(source, i, i + charLen),
          allowMalformed: allowMalformed,
        ),
      );
      i += charLen;
    }
  }
  return buffer.toString();
}

int _parseHex4(Uint8List source, int offset) {
  var v = 0;
  for (var i = 0; i < 4; i++) {
    final b = source[offset + i];
    final int digit;
    if (b >= 48 && b <= 57) {
      digit = b - 48;
    } else if (b >= 65 && b <= 70) {
      digit = b - 55;
    } else if (b >= 97 && b <= 102) {
      digit = b - 87;
    } else {
      throw FormatException(
        'Invalid hex digit: ${String.fromCharCode(b)}',
        source,
        offset + i,
      );
    }
    v = (v << 4) | digit;
  }
  return v;
}

int _utf8SequenceLength(int firstByte) {
  if (firstByte <= 0x7F) return 1;
  if ((firstByte & 0xE0) == 0xC0) return 2;
  if ((firstByte & 0xF0) == 0xE0) return 3;
  if ((firstByte & 0xF8) == 0xF0) return 4;
  return 1;
}

/// Direct byte-comparison of a UTF-8 byte span `[start, end)` against an
/// [asciiString].
///
/// Returns `true` if the slice exactly matches the ASCII string, `false`
/// otherwise.
bool equalsAsciiUtf8(Uint8List source, int start, int end, String asciiString) {
  if (start < 0 || end > source.length || end - start != asciiString.length) {
    return false;
  }
  for (var i = 0; i < asciiString.length; i++) {
    if (source[start + i] != asciiString.codeUnitAt(i)) return false;
  }
  return true;
}

/// Checks if the UTF-8 byte span `[start, end)` in [source] matches the literal
/// `null`.
bool isNullUtf8(Uint8List source, int start, int end) {
  return (end - start == 4) &&
      start >= 0 &&
      end <= source.length &&
      source[start] == 110 &&
      source[start + 1] == 117 &&
      source[start + 2] == 108 &&
      source[start + 3] == 108;
}

/// Checks whether the UTF-8 byte span `[start, end)` in [source] is verbatim
/// (contains no `\` escapes).
bool isVerbatimUtf8(Uint8List source, int start, int end) {
  if (start < 0 || end > source.length || start > end) return false;
  for (var i = start; i < end; i++) {
    if (source[i] == 92) return false; // '\\'
  }
  return true;
}
