import 'dart:convert'
    hide
        JsonKeyOptions,
        JsonTokenReader,
        JsonTokenType,
        JsonTokenWriter,
        JsonUtf8TokenWriter,
        jsonUtf8,
        jsonUtf8Decode,
        jsonUtf8Encode;
import 'dart:typed_data';

import 'eisel_lemire.dart';

@pragma('vm:prefer-inline')
@pragma('wasm:prefer-inline')
bool _isWs(int b) => b == 0x20 || b == 0x0A || b == 0x0D || b == 0x09;

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
/// `null` if the byte span is invalid, empty, or contains non-digit
/// characters.
int? tryParseIntUtf8(Uint8List source, int start, int end, {int? radix}) {
  final r = radix ?? 10;
  if (r < 2 || r > 36) throw RangeError.range(r, 2, 36, 'radix');
  if (start >= end || start < 0 || end > source.length) return null;

  var index = start;
  while (index < end && _isWs(source[index])) {
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
    if (r == 10) return null;
    index++;
  }
  if (index >= end) return null;

  if (r == 10 && source[index] == 48) {
    if (index + 1 < end && source[index + 1] >= 48 && source[index + 1] <= 57) {
      return null;
    }
  }

  final maxInt = identical(1.0, 1)
      ? 0x1FFFFFFFFFFFFF
      : (0x7FFFFFFF * 0x100000000) + 0xFFFFFFFF;
  final limitBeforeMul = maxInt ~/ r;
  final limitLastDigit =
      (maxInt % r) + (negative && !identical(1.0, 1) ? 1 : 0);

  var result = 0;
  var hasDigits = false;
  while (index < end) {
    final byte = source[index++];
    if (_isWs(byte)) {
      while (index < end) {
        if (!_isWs(source[index++])) return null;
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

    if (result < 0 || result > limitBeforeMul) return null;
    if (result == limitBeforeMul && digit > limitLastDigit) return null;

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

const int _invalidExponentSentinel = 0x7FFFFFFF;

@pragma('vm:prefer-inline')
@pragma('wasm:prefer-inline')
bool _isAsciiDigit(int b) => b >= 48 && b <= 57;

@pragma('vm:prefer-inline')
@pragma('wasm:prefer-inline')
int _skipLeadingWs(Uint8List source, int start, int end) {
  var i = start;
  while (i < end && _isWs(source[i])) {
    i++;
  }
  return i;
}

@pragma('vm:prefer-inline')
@pragma('wasm:prefer-inline')
int _trimTrailingWs(Uint8List source, int start, int end) {
  var actualEnd = end;
  while (actualEnd > start && _isWs(source[actualEnd - 1])) {
    actualEnd--;
  }
  return actualEnd;
}

@pragma('vm:prefer-inline')
@pragma('wasm:prefer-inline')
bool _hasValidLeadingIntDigit(Uint8List source, int i, int actualEnd) {
  final first = source[i];
  if (!_isAsciiDigit(first)) {
    return false;
  }
  return first != 48 || i + 1 >= actualEnd || !_isAsciiDigit(source[i + 1]);
}

@pragma('vm:prefer-inline')
@pragma('wasm:prefer-inline')
int _applyExpSign(int explicitExp, bool expNegative, bool expSaturated) {
  if (expSaturated) {
    return expNegative ? -100000 : 100000;
  }
  return expNegative ? -explicitExp : explicitExp;
}

@pragma('vm:prefer-inline')
@pragma('wasm:prefer-inline')
int _parseExplicitExponent(Uint8List source, int i, int actualEnd) {
  if (i >= actualEnd) {
    return _invalidExponentSentinel;
  }
  final first = source[i];
  final expNegative = first == 45;
  if (expNegative || first == 43) {
    i++;
  }
  if (i >= actualEnd || !_isAsciiDigit(source[i])) {
    return _invalidExponentSentinel;
  }
  var explicitExp = 0;
  var expSaturated = false;
  while (i < actualEnd) {
    final b = source[i++];
    if (!_isAsciiDigit(b)) {
      return _invalidExponentSentinel;
    }
    if (explicitExp < 10000) {
      explicitExp = explicitExp * 10 + (b - 48);
    } else {
      expSaturated = true;
    }
  }
  return _applyExpSign(explicitExp, expNegative, expSaturated);
}

@pragma('vm:prefer-inline')
@pragma('wasm:prefer-inline')
double? _finishDoubleFastPath(
  int mantissa,
  int decimalExp,
  bool isNegative,
  bool truncatedDigits,
) {
  if (mantissa == 0) {
    return isNegative ? -0.0 : 0.0;
  }
  if (decimalExp == 0 &&
      !truncatedDigits &&
      unsignedLe(mantissa, 0x001FFFFFFFFFFFFF)) {
    return isNegative ? -mantissa.toDouble() : mantissa.toDouble();
  }
  final result = tryParseDoubleFastEiselLemire(
    mantissa,
    decimalExp,
    isNegative,
  );
  if (result == null) {
    return null;
  }
  if (!truncatedDigits) {
    return result;
  }
  final resultPlus1 = tryParseDoubleFastEiselLemire(
    mantissa + 1,
    decimalExp,
    isNegative,
  );
  return resultPlus1 == result ? result : null;
}

@pragma('vm:prefer-inline')
@pragma('wasm:prefer-inline')
bool _isValidBounds(Uint8List source, int start, int end) =>
    start < end && start >= 0 && end <= source.length;

@pragma('vm:prefer-inline')
@pragma('wasm:prefer-inline')
bool _isExponentMarker(int b) => b == 101 || b == 69;

@pragma('vm:prefer-inline')
@pragma('wasm:prefer-inline')
int _scanDigitsEnd(Uint8List source, int start, int end) {
  var i = start;
  while (i < end && _isAsciiDigit(source[i])) {
    i++;
  }
  return i;
}

@pragma('vm:prefer-inline')
@pragma('wasm:prefer-inline')
int _scanOptionalFractionEnd(Uint8List source, int intEnd, int actualEnd) {
  if (intEnd >= actualEnd || source[intEnd] != 46) {
    return intEnd;
  }
  final fracStart = intEnd + 1;
  if (fracStart >= actualEnd || !_isAsciiDigit(source[fracStart])) {
    return -1;
  }
  return _scanDigitsEnd(source, fracStart + 1, actualEnd);
}

@pragma('vm:prefer-inline')
@pragma('wasm:prefer-inline')
double? _accumulateMantissaAndParse(
  Uint8List source,
  int start,
  int intEnd,
  int fracEnd,
  int explicitExp,
  bool isNegative,
) {
  var mantissa = 0;
  var leadingZeros = 0;
  var digitCount = 0;
  var truncatedDigits = false;

  for (var k = start; k < fracEnd; k++) {
    final d = source[k] - 48;
    if (d < 0) {
      continue;
    }
    if (mantissa == 0 && d == 0) {
      leadingZeros++;
    } else if (digitCount < 19) {
      mantissa = mantissa * 10 + d;
      digitCount++;
    } else {
      truncatedDigits = true;
    }
  }

  final sigExp = (intEnd - start) - leadingZeros - digitCount;
  final decimalExp = explicitExp.abs() == 100000
      ? explicitExp
      : sigExp + explicitExp;

  return _finishDoubleFastPath(
    mantissa,
    decimalExp,
    isNegative,
    truncatedDigits,
  );
}

/// Zero-allocation floating point parser operating directly on the UTF-8
/// byte span `[start, end)` in [source].
///
/// Uses integer fast-path and 64-bit Eisel-Lemire 128-bit power-of-10 scaling
/// before falling back to [double.tryParse] for ambiguous halfway or extreme
/// subnormal cases to guarantee exact IEEE 754 precision matching RFC 8259.
/// `null` if the span does not contain a valid number representation.
@pragma('vm:prefer-inline')
@pragma('wasm:prefer-inline')
double? tryParseDoubleUtf8(Uint8List source, int start, int end) {
  if (!_isValidBounds(source, start, end)) {
    return null;
  }

  var i = _skipLeadingWs(source, start, end);
  final actualEnd = _trimTrailingWs(source, i, end);
  if (i >= actualEnd) {
    return null;
  }

  final sliceStart = i;
  final isNegative = source[i] == 45;
  if (isNegative) {
    i++;
  }
  if (i >= actualEnd || !_hasValidLeadingIntDigit(source, i, actualEnd)) {
    return null;
  }

  final intEnd = source[i] == 48 ? i + 1 : _scanDigitsEnd(source, i, actualEnd);
  final fracEnd = _scanOptionalFractionEnd(source, intEnd, actualEnd);
  if (fracEnd < 0) {
    return null;
  }

  var explicitExp = 0;
  var afterNumber = fracEnd;
  if (fracEnd < actualEnd && _isExponentMarker(source[fracEnd])) {
    explicitExp = _parseExplicitExponent(source, fracEnd + 1, actualEnd);
    if (explicitExp == _invalidExponentSentinel) {
      return null;
    }
    afterNumber = actualEnd;
  }

  if (afterNumber != actualEnd) {
    return null;
  }

  return _accumulateMantissaAndParse(
        source,
        i,
        intEnd,
        fracEnd,
        explicitExp,
        isNegative,
      ) ??
      double.tryParse(String.fromCharCodes(source, sliceStart, actualEnd));
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
/// `true` for `true`, `false` for `false`, or `null` if unmatched.
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
  if (start < 0 || end > source.length || start > end) {
    throw RangeError('Invalid byte span [$start, $end)');
  }
  if (start == end) return '';

  // Single-pass scan for escapes and non-ASCII characters.
  var isAscii = true;
  var isVerbatim = true;
  for (var i = start; i < end; i++) {
    final b = source[i];
    if (b < 0x20 || b == 34) {
      throw FormatException(
        'Unescaped control character or quote at offset $i',
        source,
        i,
      );
    }
    if (b == 92) {
      // '\\' escape present
      isVerbatim = false;
      break;
    }
    if (b >= 128) {
      isAscii = false;
    }
  }

  if (isVerbatim) {
    if (isAscii) {
      // Pure ASCII fast-path: zero heap view allocation, zero multi-byte
      // state machine.
      return String.fromCharCodes(source, start, end);
    }
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
    } else if (byte <= 0x7F) {
      if (byte < 0x20 || byte == 34) {
        throw FormatException(
          'Unescaped control character or quote 0x${byte.toRadixString(16)} '
          'at offset $i',
          source,
          i,
        );
      }
      buffer.writeCharCode(byte);
      i++;
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
/// Whether the slice exactly matches the ASCII string, `false`
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
    final b = source[i];
    if (b < 0x20 || b == 92 || b == 34) return false;
  }
  return true;
}
