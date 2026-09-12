// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:typed_data';

const List<double> powersOfTen = [
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
];

const String digitPairs =
    '00010203040506070809'
    '10111213141516171819'
    '20212223242526272829'
    '30313233343536373839'
    '40414243444546474849'
    '50515253545556575859'
    '60616263646566676869'
    '70717273747576777879'
    '80818283848586878889'
    '90919293949596979899';

const String hexDigits = '0123456789abcdef';

const List<int> digitCountThresholds = [
  -10,
  -100,
  -1000,
  -10000,
  -100000,
  -1000000,
  -10000000,
  -100000000,
  -1000000000,
  -10000000000,
  -100000000000,
  -1000000000000,
  -10000000000000,
  -100000000000000,
  -1000000000000000,
  -10000000000000000,
  -100000000000000000,
  -1000000000000000000,
];

@pragma('vm:prefer-inline')
void emitDigitsBackwardNegative(Uint8List buffer, int writePos, int negVal) {
  var temp = negVal;
  while (temp <= -100) {
    final next = temp ~/ 100;
    final rem = -(temp - next * 100);
    final pairIdx = rem << 1;
    buffer[writePos] = digitPairs.codeUnitAt(pairIdx + 1);
    buffer[writePos - 1] = digitPairs.codeUnitAt(pairIdx);
    writePos -= 2;
    temp = next;
  }
  if (temp <= -10) {
    final rem = -temp;
    final pairIdx = rem << 1;
    buffer[writePos] = digitPairs.codeUnitAt(pairIdx + 1);
    buffer[writePos - 1] = digitPairs.codeUnitAt(pairIdx);
  } else {
    buffer[writePos] = 48 - temp;
  }
}

@pragma('vm:prefer-inline')
int digitCountNegative(int v) {
  for (var i = 0; i < 18; i++) {
    if (v > digitCountThresholds[i]) return i + 1;
  }
  return 19;
}

@pragma('vm:prefer-inline')
int writeIntToBuffer(int value, Uint8List buffer, int offset) {
  if (value == 0) {
    buffer[offset] = 48; // '0'
    return 1;
  }
  var v = value;
  final isNeg = v < 0;
  if (!isNeg) {
    v = -v;
  }
  final digitCount = digitCountNegative(v);
  final totalLen = (isNeg ? 1 : 0) + digitCount;
  var cursor = offset;
  if (isNeg) {
    buffer[cursor++] = 45; // '-'
  }
  final writePos = cursor + digitCount - 1;
  emitDigitsBackwardNegative(buffer, writePos, v);
  return totalLen;
}

@pragma('vm:prefer-inline')
bool isSimpleAsciiString(String value) {
  final len = value.length;
  for (var i = 0; i < len; i++) {
    final c = value.codeUnitAt(i);
    if (c < 0x20 || c == 0x22 || c == 0x5C || c >= 0x80) {
      return false;
    }
  }
  return true;
}

@pragma('vm:prefer-inline')
int writeEscapedChar(int c, Uint8List buffer, int cursor) {
  buffer[cursor] = 0x5C;
  switch (c) {
    case 0x22:
      buffer[cursor + 1] = 0x22;
      return 2;
    case 0x5C:
      buffer[cursor + 1] = 0x5C;
      return 2;
    case 0x08:
      buffer[cursor + 1] = 0x62;
      return 2;
    case 0x0C:
      buffer[cursor + 1] = 0x66;
      return 2;
    case 0x0A:
      buffer[cursor + 1] = 0x6E;
      return 2;
    case 0x0D:
      buffer[cursor + 1] = 0x72;
      return 2;
    case 0x09:
      buffer[cursor + 1] = 0x74;
      return 2;
    default:
      buffer[cursor + 1] = 0x75;
      buffer[cursor + 2] = 0x30;
      buffer[cursor + 3] = 0x30;
      buffer[cursor + 4] = hexDigits.codeUnitAt((c >> 4) & 0xF);
      buffer[cursor + 5] = hexDigits.codeUnitAt(c & 0xF);
      return 6;
  }
}

@pragma('vm:prefer-inline')
int writeUnicodeHexEscape(int c, Uint8List buffer, int cursor) {
  buffer[cursor] = 0x5C;
  buffer[cursor + 1] = 0x75;
  buffer[cursor + 2] = hexDigits.codeUnitAt((c >> 12) & 0xF);
  buffer[cursor + 3] = hexDigits.codeUnitAt((c >> 8) & 0xF);
  buffer[cursor + 4] = hexDigits.codeUnitAt((c >> 4) & 0xF);
  buffer[cursor + 5] = hexDigits.codeUnitAt(c & 0xF);
  return 6;
}

@pragma('vm:prefer-inline')
int writeSurrogatePair(int c, int next, Uint8List buffer, int cursor) {
  final codePoint = 0x10000 + ((c - 0xD800) << 10) + (next - 0xDC00);
  buffer[cursor] = 0xF0 | (codePoint >> 18);
  buffer[cursor + 1] = 0x80 | ((codePoint >> 12) & 0x3F);
  buffer[cursor + 2] = 0x80 | ((codePoint >> 6) & 0x3F);
  buffer[cursor + 3] = 0x80 | (codePoint & 0x3F);
  return 4;
}

@pragma('vm:prefer-inline')
int writeNonAsciiCodeUnit(int c, Uint8List buffer, int cursor) {
  if (c <= 0x7FF) {
    buffer[cursor] = 0xC0 | (c >> 6);
    buffer[cursor + 1] = 0x80 | (c & 0x3F);
    return 2;
  }
  buffer[cursor] = 0xE0 | (c >> 12);
  buffer[cursor + 1] = 0x80 | ((c >> 6) & 0x3F);
  buffer[cursor + 2] = 0x80 | (c & 0x3F);
  return 3;
}

int writeEscapedStringToBuffer(String value, Uint8List buffer, int offset) {
  var cursor = offset;
  buffer[cursor++] = 0x22; // '"'
  final len = value.length;
  for (var i = 0; i < len; i++) {
    final c = value.codeUnitAt(i);
    if (c < 0x20 || c == 0x22 || c == 0x5C) {
      cursor += writeEscapedChar(c, buffer, cursor);
    } else if (c <= 0x7F) {
      buffer[cursor++] = c;
    } else if (c >= 0xD800 && c <= 0xDBFF) {
      if (i + 1 < len &&
          value.codeUnitAt(i + 1) >= 0xDC00 &&
          value.codeUnitAt(i + 1) <= 0xDFFF) {
        cursor += writeSurrogatePair(
          c,
          value.codeUnitAt(i + 1),
          buffer,
          cursor,
        );
        i++;
      } else {
        cursor += writeUnicodeHexEscape(c, buffer, cursor);
      }
    } else if (c >= 0xDC00 && c <= 0xDFFF) {
      cursor += writeUnicodeHexEscape(c, buffer, cursor);
    } else {
      cursor += writeNonAsciiCodeUnit(c, buffer, cursor);
    }
  }
  buffer[cursor++] = 0x22; // '"'
  return cursor - offset;
}

@pragma('vm:prefer-inline')
int writeStringToBuffer(String value, Uint8List buffer, int offset) {
  final len = value.length;
  if (isSimpleAsciiString(value)) {
    buffer[offset] = 0x22; // '"'
    for (var i = 0; i < len; i++) {
      buffer[offset + 1 + i] = value.codeUnitAt(i);
    }
    buffer[offset + 1 + len] = 0x22; // '"'
    return len + 2;
  }
  return writeEscapedStringToBuffer(value, buffer, offset);
}

@pragma('vm:prefer-inline')
int writeZeroDouble(bool isNeg, Uint8List buffer, int offset) {
  var cursor = offset;
  if (isNeg) buffer[cursor++] = 0x2D;
  buffer[cursor++] = 0x30;
  buffer[cursor++] = 0x2E;
  buffer[cursor++] = 0x30;
  return cursor - offset;
}

@pragma('vm:prefer-inline')
int tryWriteExactIntDouble(
  double absVal,
  bool isNeg,
  Uint8List buffer,
  int offset,
) {
  final trunc = absVal.truncateToDouble();
  if (absVal != trunc || absVal > 9007199254740991.0) {
    return 0;
  }
  final intVal = absVal.toInt();
  final negVal = -intVal;
  final digitCount = digitCountNegative(negVal);
  final totalLen = (isNeg ? 1 : 0) + digitCount + 2;
  var cursor = offset;
  if (isNeg) buffer[cursor++] = 0x2D;
  final writePos = cursor + digitCount - 1;
  emitDigitsBackwardNegative(buffer, writePos, negVal);
  cursor += digitCount;
  buffer[cursor++] = 0x2E;
  buffer[cursor++] = 0x30;
  return totalLen;
}

@pragma('vm:prefer-inline')
int writeFractionWhole(Uint8List buffer, int offset, bool isNeg, int negVal) {
  final digitCount = digitCountNegative(negVal);
  final totalLen = (isNeg ? 1 : 0) + digitCount + 2;
  var cursor = offset;
  if (isNeg) buffer[cursor++] = 0x2D;
  final writePos = cursor + digitCount - 1;
  emitDigitsBackwardNegative(buffer, writePos, negVal);
  cursor += digitCount;
  buffer[cursor++] = 0x2E;
  buffer[cursor++] = 0x30;
  return totalLen;
}

@pragma('vm:prefer-inline')
int writeFractionSplitDigits(
  Uint8List buffer,
  int offset,
  bool isNeg,
  int negVal,
  int numDigits,
  int k,
) {
  final totalLen = (isNeg ? 1 : 0) + numDigits + 1;
  var cursor = offset;
  if (isNeg) buffer[cursor++] = 0x2D;
  final digitsStart = cursor;
  var writePos = digitsStart + numDigits;
  var temp = negVal;
  var digitsWritten = 0;
  while (digitsWritten < k) {
    final next = temp ~/ 10;
    final rem = -(temp - next * 10);
    buffer[writePos--] = 48 + rem;
    temp = next;
    digitsWritten++;
  }
  buffer[writePos--] = 0x2E;
  emitDigitsBackwardNegative(buffer, writePos, temp);
  return totalLen;
}

@pragma('vm:prefer-inline')
int writeFractionLeadingZeros(
  Uint8List buffer,
  int offset,
  bool isNeg,
  int negVal,
  int numDigits,
  int k,
) {
  final leadingZeros = k - numDigits;
  final totalLen = (isNeg ? 1 : 0) + 2 + leadingZeros + numDigits;
  var cursor = offset;
  if (isNeg) buffer[cursor++] = 0x2D;
  buffer[cursor++] = 0x30;
  buffer[cursor++] = 0x2E;
  for (var z = 0; z < leadingZeros; z++) {
    buffer[cursor++] = 0x30;
  }
  final writePos = cursor + numDigits - 1;
  emitDigitsBackwardNegative(buffer, writePos, negVal);
  return totalLen;
}

@pragma('vm:prefer-inline')
int writeDecimalFraction(
  Uint8List buffer,
  int offset,
  bool isNeg,
  int intVal,
  int k,
) {
  final negVal = -intVal;
  if (k == 0) {
    return writeFractionWhole(buffer, offset, isNeg, negVal);
  }
  final numDigits = digitCountNegative(negVal);
  if (numDigits > k) {
    return writeFractionSplitDigits(
      buffer,
      offset,
      isNeg,
      negVal,
      numDigits,
      k,
    );
  }
  return writeFractionLeadingZeros(buffer, offset, isNeg, negVal, numDigits, k);
}

@pragma('vm:prefer-inline')
int tryWriteScaledFractionDouble(
  double absVal,
  bool isNeg,
  Uint8List buffer,
  int offset,
) {
  if (absVal < 1e-15 || absVal > 1e15) {
    return 0;
  }
  final intPart = absVal.toInt();
  final intPartDigits = intPart == 0 ? 0 : digitCountNegative(-intPart);
  final maxFrac = 15 - intPartDigits;
  if (maxFrac <= 0 || maxFrac > 15) {
    return 0;
  }
  final p10 = powersOfTen[maxFrac];
  final scaled = absVal * p10;
  if (scaled > 9007199254740991.0) {
    return 0;
  }
  var intVal = scaled.round();
  if (intVal / p10 != absVal) {
    return 0;
  }
  var k = maxFrac;
  while (k >= 4 && intVal % 10000 == 0) {
    intVal ~/= 10000;
    k -= 4;
  }
  while (k >= 2 && intVal % 100 == 0) {
    intVal ~/= 100;
    k -= 2;
  }
  if (k > 0 && intVal % 10 == 0) {
    intVal ~/= 10;
    k--;
  }
  return writeDecimalFraction(buffer, offset, isNeg, intVal, k);
}

@pragma('vm:prefer-inline')
int writeDoubleToBuffer(double value, Uint8List buffer, int offset) {
  if (value.isNaN || value.isInfinite) {
    throw UnsupportedError('NaN and Infinity are not supported in JSON');
  }
  if (value == 0.0) {
    return writeZeroDouble(value.isNegative, buffer, offset);
  }

  final isNeg = value.isNegative;
  final absVal = isNeg ? -value : value;

  final intLen = tryWriteExactIntDouble(absVal, isNeg, buffer, offset);
  if (intLen > 0) return intLen;

  final fracLen = tryWriteScaledFractionDouble(absVal, isNeg, buffer, offset);
  if (fracLen > 0) return fracLen;

  final s = value.toString();
  for (var i = 0; i < s.length; i++) {
    buffer[offset + i] = s.codeUnitAt(i);
  }
  return s.length;
}
