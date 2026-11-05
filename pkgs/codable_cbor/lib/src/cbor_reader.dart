// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:typed_data';

import 'package:codable/codable.dart';

/// Exact value of `2^32` (`4294967296`) for arithmetic 64-bit split/combine
/// without 32-bit JavaScript bitwise shift truncation.
const int cborTwoPow32 = 0x100000000;

/// High 32-bit word limit for JavaScript's `Number.MAX_SAFE_INTEGER` (`2^53-1`).
const int cborJsMaxSafeHi = 0x1fffff;

/// Compares [length] bytes of [buf] starting at [start] against [target].
bool cborBytesMatch(Uint8List buf, int start, Uint8List target, int length) {
  for (var i = 0; i < length; i++) {
    if (buf[start + i] != target[i]) return false;
  }
  return true;
}

/// Pre-encoded UTF-8 key table cached on [KeyOptions] via `compiled<T>`.
final class CborCompiledKeys {
  final List<Uint8List> utf8Keys;

  CborCompiledKeys(List<String> keys)
    : utf8Keys = [for (final key in keys) utf8.encode(key)];

  int match(Uint8List buf, int start, int length) {
    for (var i = 0; i < utf8Keys.length; i++) {
      final candidate = utf8Keys[i];
      if (candidate.length == length &&
          cborBytesMatch(buf, start, candidate, length)) {
        return i;
      }
    }
    return -1;
  }
}

double _decodeFloat16Bits(int half, ByteData scratch) {
  final sign = (half & 0x8000) != 0 ? -1.0 : 1.0;
  final exp = (half >>> 10) & 0x1f;
  final mant = half & 0x03ff;
  if (exp == 0) {
    return sign * (mant * 5.960464477539063e-8);
  }
  if (exp == 0x1f) {
    return mant == 0 ? sign * double.infinity : double.nan;
  }
  final magBits = ((exp + 112) << 23) | (mant << 13);
  scratch.setUint32(0, magBits);
  return sign * scratch.getFloat32(0);
}

ValueKind _major7ValueKind(int ai) => switch (ai) {
  20 || 21 => ValueKind.boolean,
  22 => ValueKind.nullValue,
  25 || 26 || 27 => ValueKind.number,
  _ => throw CodableException('Unsupported CBOR simple/float value: $ai'),
};

/// Low-level single-pass cursor over definite-length RFC 8949 CBOR bytes.
final class CborReader {
  final Uint8List bytes;
  late final ByteData _bd = ByteData.sublistView(bytes);
  final ByteData _scratch = ByteData(4);
  int offset;

  CborReader(this.bytes, [this.offset = 0]);

  void _require(int count) {
    if (count < 0 || count > bytes.length - offset) {
      throw const CodableException('Unexpected end of CBOR payload');
    }
  }

  int peekByte() {
    _require(1);
    return bytes[offset];
  }

  int readByte() {
    _require(1);
    return bytes[offset++];
  }

  ValueKind peekKind() {
    final ib = peekByte();
    final mt = ib >>> 5;
    final ai = ib & 0x1f;
    if (ai == 31) {
      throw const CodableException(
        'Indefinite-length CBOR items are not supported',
      );
    }
    return switch (mt) {
      0 || 1 => ValueKind.number,
      2 => ValueKind.bytes,
      3 => ValueKind.string,
      4 => ValueKind.list,
      5 => ValueKind.map,
      7 => _major7ValueKind(ai),
      _ => throw CodableException('Unsupported CBOR major type: $mt'),
    };
  }

  int readArg(int ai) {
    if (ai < 24) return ai;
    if (ai == 24) return readByte();
    if (ai == 25) {
      _require(2);
      final v = _bd.getUint16(offset);
      offset += 2;
      return v;
    }
    if (ai == 26) {
      _require(4);
      final v = _bd.getUint32(offset);
      offset += 4;
      return v;
    }
    if (ai == 27) return _readUint64();
    throw CodableException('Invalid CBOR additional info: $ai');
  }

  int _readUint64() {
    _require(8);
    final hi = _bd.getUint32(offset);
    final lo = _bd.getUint32(offset + 4);
    offset += 8;
    if (identical(1.0, 1)) {
      if (hi > cborJsMaxSafeHi) {
        throw const CodableException(
          'CBOR integer exceeds 53-bit safe integer range on JavaScript',
        );
      }
    } else if (hi >= 0x80000000) {
      throw const CodableException('CBOR uint64 overflows signed 64-bit int');
    }
    return hi * cborTwoPow32 + lo;
  }

  int readContainerLength(int expectedMajorType) {
    final ib = readByte();
    final mt = ib >>> 5;
    final ai = ib & 0x1f;
    if (mt != expectedMajorType || ai == 31) {
      throw CodableException(
        'Expected CBOR major type $expectedMajorType, got $mt (ai=$ai)',
      );
    }
    final len = readArg(ai);
    final maxPossible = expectedMajorType == 5
        ? (bytes.length - offset) ~/ 2
        : bytes.length - offset;
    if (len > maxPossible) {
      throw const CodableException('Unexpected end of CBOR payload');
    }
    return len;
  }

  void readNull() {
    final ib = readByte();
    if (ib != 0xf6) {
      throw CodableException(
        'Expected CBOR null (0xf6), got 0x${ib.toRadixString(16)}',
      );
    }
  }

  bool readBool() {
    final ib = readByte();
    if (ib == 0xf4) return false;
    if (ib == 0xf5) return true;
    throw CodableException('Expected CBOR bool, got 0x${ib.toRadixString(16)}');
  }

  int readInt() {
    final ib = readByte();
    final mt = ib >>> 5;
    final ai = ib & 0x1f;
    if (mt == 0) return readArg(ai);
    if (mt == 1) return -1 - readArg(ai);
    throw CodableException('Expected CBOR integer, got major type $mt');
  }

  double readDouble() {
    final ib = peekByte();
    final mt = ib >>> 5;
    if (mt == 0 || mt == 1) return readInt().toDouble();
    if (mt == 7) return _readMajor7Float();
    throw CodableException('Expected CBOR number, got major type $mt');
  }

  num readNum() {
    final ib = peekByte();
    final mt = ib >>> 5;
    if (mt == 0 || mt == 1) return readInt();
    if (mt == 7) return _readMajor7Float();
    throw CodableException('Expected CBOR number, got major type $mt');
  }

  double _readMajor7Float() {
    final ai = readByte() & 0x1f;
    if (ai == 25) {
      _require(2);
      final half = _bd.getUint16(offset);
      offset += 2;
      return _decodeFloat16Bits(half, _scratch);
    }
    if (ai == 26) {
      _require(4);
      final v = _bd.getFloat32(offset);
      offset += 4;
      return v;
    }
    if (ai == 27) {
      _require(8);
      final v = _bd.getFloat64(offset);
      offset += 8;
      return v;
    }
    throw CodableException('Expected CBOR float, got simple value $ai');
  }

  (int start, int end) readTextStringSpan() {
    final len = readContainerLength(3);
    final start = offset;
    final end = start + len;
    offset = end;
    return (start, end);
  }

  String readString() {
    final (start, end) = readTextStringSpan();
    try {
      return utf8.decode(Uint8List.sublistView(bytes, start, end));
    } on FormatException catch (e) {
      throw CodableException(
        'Invalid UTF-8 in CBOR text string: ${e.message}',
        underlyingError: e,
      );
    }
  }

  int selectString(KeyOptions options) {
    final (start, end) = readTextStringSpan();
    return options
        .compiled<CborCompiledKeys>(CborCompiledKeys.new)
        .match(bytes, start, end - start);
  }

  Uint8List readBytes() {
    final ib = peekByte();
    final mt = ib >>> 5;
    if (mt == 2) {
      final len = readContainerLength(2);
      final start = offset;
      offset = start + len;
      return Uint8List.sublistView(bytes, start, offset);
    }
    if (mt == 4) return _readByteArrayFallback();
    throw CodableException('Expected CBOR bstr, got major type $mt');
  }

  Uint8List _readByteArrayFallback() {
    final len = readContainerLength(4);
    final out = Uint8List(len);
    for (var i = 0; i < len; i++) {
      final b = readInt();
      if (b < 0 || b > 255) {
        throw CodableException('Expected byte in range 0..255, got $b');
      }
      out[i] = b;
    }
    return out;
  }

  void skipItem() {
    var remaining = 1;
    while (remaining > 0) {
      remaining--;
      final ib = readByte();
      final delta = _skipItemBody(ib >>> 5, ib & 0x1f);
      if (delta > bytes.length - offset - remaining) {
        throw const CodableException('Unexpected end of CBOR payload');
      }
      remaining += delta;
    }
  }

  int _skipItemBody(int mt, int ai) {
    if (ai == 31) {
      throw const CodableException(
        'Indefinite-length CBOR items are not supported',
      );
    }
    return switch (mt) {
      0 || 1 => _ignoreArg(readArg(ai)),
      2 || 3 => _skipBytes(readArg(ai)),
      4 => readArg(ai),
      5 => _skipMapPairs(ai),
      7 => _skipMajor7(ai),
      _ => throw CodableException('Unsupported CBOR major type: $mt'),
    };
  }

  int _ignoreArg(int _) => 0;

  int _skipMapPairs(int ai) {
    final pairs = readArg(ai);
    if (pairs > (bytes.length - offset) ~/ 2) {
      throw const CodableException('Unexpected end of CBOR payload');
    }
    return pairs * 2;
  }

  int _skipBytes(int len) {
    _require(len);
    offset += len;
    return 0;
  }

  int _skipMajor7(int ai) {
    final width = switch (ai) {
      20 || 21 || 22 => 0,
      25 => 2,
      26 => 4,
      27 => 8,
      _ => throw CodableException('Unsupported CBOR simple value: $ai'),
    };
    return _skipBytes(width);
  }
}
