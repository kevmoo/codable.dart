// Copyright 2024 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License.
// You may obtain a copy of the License at
//
//     https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'dart:convert';
import 'dart:math' as math;
import 'dart:typed_data';

const _powersOfTen = <double>[
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

bool _isWs(int charCode) =>
    charCode == 32 || charCode == 10 || charCode == 13 || charCode == 9;

int _skipWs(Uint8List source, int i, int end) {
  while (i < end && _isWs(source[i])) {
    i++;
  }
  return i;
}

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

int? tryParseIntUtf8(Uint8List source, int start, int end, {int? radix}) {
  final r = radix ?? 10;
  if (r < 2 || r > 36) throw RangeError.range(r, 2, 36, 'radix');
  if (start >= end || start < 0 || end > source.length) return null;

  var index = _skipWs(source, start, end);
  if (index >= end) return null;

  final signRes = _parseSign(source, index, end, r);
  if (signRes == null) return null;
  final negative = signRes.$1;
  index = signRes.$2;

  if (index >= end) return null;

  if (r == 10 && source[index] == 48 && index + 1 < end) {
    final next = source[index + 1];
    if (next >= 48 && next <= 57) return null;
  }

  return _accumulateInt(source, index, end, r, negative);
}

(bool, int)? _parseSign(Uint8List source, int i, int end, int r) {
  if (source[i] == 45) return (true, i + 1);
  if (source[i] == 43) {
    if (r == 10) return null;
    return (false, i + 1);
  }
  return (false, i);
}

int? _accumulateInt(
  Uint8List source,
  int index,
  int end,
  int r,
  bool negative,
) {
  var result = 0;
  var hasDigits = false;
  while (index < end) {
    final byte = source[index++];
    if (_isWs(byte)) {
      index = _skipWs(source, index, end);
      if (index < end) return null;
      break;
    }
    final digit = _parseIntDigit(byte, r);
    if (digit == null) return null;
    hasDigits = true;
    result = result * r + digit;
  }

  if (!hasDigits) return null;
  return negative ? -result : result;
}

int? _parseIntDigit(int byte, int r) {
  final int digit;
  if (byte >= 48 && byte <= 57)
    digit = byte - 48;
  else if (byte >= 65 && byte <= 90)
    digit = byte - 55;
  else if (byte >= 97 && byte <= 122)
    digit = byte - 87;
  else
    return null;
  return digit >= r ? null : digit;
}

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

double? tryParseDoubleUtf8(Uint8List source, int start, int end) {
  if (start >= end || start < 0 || end > source.length) return null;

  final prep = _prepareDoubleParsing(source, start, end);
  if (prep == null) return null;
  final negative = prep.$1;
  var i = prep.$2;

  final intResult = _parseIntegerPart(source, i, end);
  if (intResult == null) return null;
  final integerPart = intResult.$1;
  final intDigits = intResult.$2;
  i = intResult.$3;

  final fracResult = _parseFractionPart(source, i, end);
  if (fracResult == null) return null;
  final fractionalPart = fracResult.$1;
  final fractionDigits = fracResult.$2;
  i = fracResult.$3;

  final val = _computeDouble(integerPart, fractionalPart, fractionDigits);
  final fallback = _tryFallbackParseDouble(
    source,
    start,
    end,
    i,
    intDigits,
    fractionDigits,
  );
  if (fallback != null) {
    return fallback.isNaN ? null : fallback;
  }

  i = _skipWs(source, i, end);
  return (i < end) ? null : (negative ? -val : val);
}

(bool, int)? _prepareDoubleParsing(Uint8List source, int start, int end) {
  var i = _skipWs(source, start, end);
  if (i >= end) return null;

  final signRes = _parseSignDouble(source, i, end);
  if (signRes == null) return null;
  final negative = signRes.$1;
  i = signRes.$2;

  if (i >= end || _hasInvalidLeadingZero(source, i, end)) return null;
  return (negative, i);
}

(bool, int)? _parseSignDouble(Uint8List source, int i, int end) {
  if (source[i] == 45) return (true, i + 1);
  if (source[i] == 43) return null;
  return (false, i);
}

bool _hasInvalidLeadingZero(Uint8List source, int i, int end) {
  if (source[i] == 48 && i + 1 < end) {
    final next = source[i + 1];
    return next >= 48 && next <= 57;
  }
  return false;
}

double _computeDouble(int integerPart, int fractionalPart, int fractionDigits) {
  var val = integerPart.toDouble();
  if (fractionDigits > 0) {
    val +=
        fractionalPart /
        (fractionDigits < _powersOfTen.length
            ? _powersOfTen[fractionDigits]
            : math.pow(10, fractionDigits));
  }
  return val;
}

(int, int, int)? _parseIntegerPart(Uint8List source, int i, int end) {
  var integerPart = 0;
  var intDigits = 0;
  while (i < end && source[i] >= 48 && source[i] <= 57) {
    intDigits++;
    integerPart = integerPart * 10 + (source[i] - 48);
    i++;
  }
  if (intDigits == 0) return null;
  return (integerPart, intDigits, i);
}

(int, int, int)? _parseFractionPart(Uint8List source, int i, int end) {
  var fractionalPart = 0;
  var fractionDigits = 0;
  if (i < end && source[i] == 46) {
    i++;
    while (i < end && source[i] >= 48 && source[i] <= 57) {
      fractionalPart = fractionalPart * 10 + (source[i] - 48);
      fractionDigits++;
      i++;
    }
    if (fractionDigits == 0) return null;
  }
  return (fractionalPart, fractionDigits, i);
}

double? _tryFallbackParseDouble(
  Uint8List source,
  int start,
  int end,
  int i,
  int intDigits,
  int fractionDigits,
) {
  if (i < end && (source[i] == 101 || source[i] == 69)) {
    return _parseExponentPart(source, start, end, i);
  }

  if (intDigits + fractionDigits > 15) {
    var wsIndex = _skipWs(source, i, end);
    if (wsIndex < end) return double.nan;
    final str = String.fromCharCodes(source, start, i);
    return double.tryParse(str) ?? double.nan;
  }

  return null;
}

double? _parseExponentPart(Uint8List source, int start, int end, int i) {
  var endIndex = i + 1;
  if (endIndex < end && (source[endIndex] == 45 || source[endIndex] == 43)) {
    endIndex++;
  }
  var hasExpDigits = false;
  while (endIndex < end && source[endIndex] >= 48 && source[endIndex] <= 57) {
    hasExpDigits = true;
    endIndex++;
  }
  if (!hasExpDigits) return double.nan;

  var wsIndex = _skipWs(source, endIndex, end);
  if (wsIndex < end) return double.nan;

  final str = String.fromCharCodes(source, start, endIndex);
  return double.tryParse(str) ?? double.nan;
}

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

bool? tryParseBoolUtf8(Uint8List source, int start, int end) {
  final len = end - start;
  if (start < 0 || end > source.length || len < 4 || len > 5) return null;

  if (len == 4 &&
      source[start] == 116 &&
      source[start + 1] == 114 &&
      source[start + 2] == 117 &&
      source[start + 3] == 101)
    return true;
  if (len == 5 &&
      source[start] == 102 &&
      source[start + 1] == 97 &&
      source[start + 2] == 108 &&
      source[start + 3] == 115 &&
      source[start + 4] == 101)
    return false;
  return null;
}

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

  var isAscii = true;
  var isVerbatim = true;
  for (var i = start; i < end; i++) {
    final b = source[i];
    if (b == 92) {
      isVerbatim = false;
      break;
    }
    if (b >= 128) isAscii = false;
  }

  if (isVerbatim) {
    if (isAscii) return String.fromCharCodes(source, start, end);
    return utf8.decode(
      Uint8List.sublistView(source, start, end),
      allowMalformed: allowMalformed,
    );
  }

  return _decodeStringBody(source, start, end, allowMalformed);
}

String _decodeStringBody(
  Uint8List source,
  int start,
  int end,
  bool allowMalformed,
) {
  final buffer = StringBuffer();
  var i = start;
  while (i < end) {
    final byte = source[i];
    if (byte == 92) {
      i = _processEscape(source, i, end, buffer);
    } else if (byte <= 0x7F) {
      i = _processAscii(source, i, byte, buffer);
    } else {
      i = _processMultibyte(source, i, end, byte, buffer, allowMalformed);
    }
  }
  return buffer.toString();
}

int _processEscape(Uint8List source, int i, int end, StringBuffer buffer) {
  i++;
  if (i >= end)
    throw FormatException('Unexpected EOF in escape sequence', source, i);
  final esc = source[i++];
  return _decodeEscape(source, esc, i, end, buffer);
}

int _processAscii(Uint8List source, int i, int byte, StringBuffer buffer) {
  if (byte < 0x20)
    throw FormatException('Unescaped control character', source, i);
  buffer.writeCharCode(byte);
  return i + 1;
}

int _processMultibyte(
  Uint8List source,
  int i,
  int end,
  int byte,
  StringBuffer buffer,
  bool allowMalformed,
) {
  final charLen = _utf8SequenceLength(byte);
  if (i + charLen > end) {
    if (allowMalformed) {
      buffer.writeCharCode(0xFFFD);
      return i + 1;
    }
    throw FormatException('Truncated UTF-8 multibyte sequence', source, i);
  }
  buffer.write(
    utf8.decode(
      Uint8List.sublistView(source, i, i + charLen),
      allowMalformed: allowMalformed,
    ),
  );
  return i + charLen;
}

int _decodeEscape(
  Uint8List source,
  int esc,
  int i,
  int end,
  StringBuffer buffer,
) {
  final charId = switch (esc) {
    34 => 34,
    92 => 92,
    47 => 47,
    98 => 8,
    102 => 12,
    110 => 10,
    114 => 13,
    116 => 9,
    _ => -1,
  };

  if (charId >= 0) {
    buffer.writeCharCode(charId);
    return i;
  }

  if (esc == 117) {
    return _decodeUnicodeEscape(source, i, end, buffer);
  }
  throw FormatException(
    'Invalid escape character: ${String.fromCharCode(esc)}',
    source,
    i - 1,
  );
}

int _decodeUnicodeEscape(
  Uint8List source,
  int i,
  int end,
  StringBuffer buffer,
) {
  if (i + 4 > end)
    throw FormatException('Incomplete unicode escape', source, i);
  final codeUnit = _parseHex4(source, i);
  i += 4;
  if (codeUnit >= 0xD800 && codeUnit <= 0xDBFF) {
    if (i + 6 <= end && source[i] == 92 && source[i + 1] == 117) {
      final low = _parseHex4(source, i + 2);
      if (low >= 0xDC00 && low <= 0xDFFF) {
        i += 6;
        buffer.writeCharCode(
          0x10000 + ((codeUnit - 0xD800) << 10) + (low - 0xDC00),
        );
        return i;
      }
    }
  }
  buffer.writeCharCode(codeUnit);
  return i;
}

int _parseHex4(Uint8List source, int offset) {
  var v = 0;
  for (var i = 0; i < 4; i++) {
    final b = source[offset + i];
    final int digit;
    if (b >= 48 && b <= 57)
      digit = b - 48;
    else if (b >= 65 && b <= 70)
      digit = b - 55;
    else if (b >= 97 && b <= 102)
      digit = b - 87;
    else
      throw FormatException('Invalid hex digit', source, offset + i);
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

bool equalsAsciiUtf8(Uint8List source, int start, int end, String asciiString) {
  if (start < 0 || end > source.length || end - start != asciiString.length) {
    return false;
  }
  for (var i = 0; i < asciiString.length; i++) {
    if (source[start + i] != asciiString.codeUnitAt(i)) return false;
  }
  return true;
}

bool isNullUtf8(Uint8List source, int start, int end) {
  return (end - start == 4) &&
      start >= 0 &&
      end <= source.length &&
      source[start] == 110 &&
      source[start + 1] == 117 &&
      source[start + 2] == 108 &&
      source[start + 3] == 108;
}

bool isVerbatimUtf8(Uint8List source, int start, int end) {
  if (start < 0 || end > source.length || start > end) return false;
  for (var i = start; i < end; i++) {
    if (source[i] == 92) return false;
  }
  return true;
}
