// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:typed_data';

import 'package:codable/codable.dart';

/// Maximum nested container depth allowed during CBOR encoding, decoding, and
/// value skipping.
const int maxCborDepth = 64;

/// Exact value of `2^32` (`4294967296`) for arithmetic 64-bit split/combine
/// without 32-bit JavaScript bitwise shift truncation.
const int cborTwoPow32 = 0x100000000;

/// High 32-bit word limit for JavaScript's `Number.MAX_SAFE_INTEGER` (`2^53-1`).
const int cborJsMaxSafeHi = 0x1fffff;

/// Exact `Number.MAX_SAFE_INTEGER` (`2^53 - 1`, `9007199254740991`).
const int cborJsMaxSafeInt = cborJsMaxSafeHi * cborTwoPow32 + 0xffffffff;

/// Linked cursor frame for zero-allocation CBOR diagnostic path recovery.
abstract base class CborPathNode {
  final CborPathNode? parent;
  bool ended = false;
  bool inChild = false;

  CborPathNode(this.parent);

  void appendSegment(List<Object> out);
}

/// Per-decode error-attribution and cursor stack state for CBOR decoding.
final class CborPathState {
  CborPathNode? activeNode;
  List<Object> mappedContainerPath = const [];
  bool hasMappedLeaf = false;
  Object? mappedLeaf;
  bool inMapped = false;
  CodableException? attributedError;

  void enterMappedContainer(List<Object> path) {
    inMapped = true;
    mappedContainerPath = path;
    hasMappedLeaf = false;
    mappedLeaf = null;
  }

  void enterMappedLeaf(List<Object> containerPath, Object key) {
    inMapped = true;
    mappedContainerPath = containerPath;
    hasMappedLeaf = true;
    mappedLeaf = key;
  }

  void clearMapped() {
    if (!inMapped) return;
    inMapped = false;
    hasMappedLeaf = false;
    mappedLeaf = null;
  }

  CborPathNode? _liveNode() {
    var c = activeNode;
    while (c != null && c.ended) {
      c = c.parent;
    }
    return c;
  }

  List<Object> buildNodePath(CborPathNode? leafNode) {
    if (leafNode == null) return const [];
    final chain = <CborPathNode>[];
    CborPathNode? curr = leafNode;
    while (curr != null) {
      chain.add(curr);
      curr = curr.parent;
    }
    final out = <Object>[];
    for (var i = chain.length - 1; i >= 0; i--) {
      if (!chain[i].ended) chain[i].appendSegment(out);
    }
    return out;
  }

  List<Object> buildContainerPath() {
    if (inMapped) return mappedContainerPath;
    final c = _liveNode();
    if (c == null) return const [];
    return buildNodePath(c.inChild ? c : c.parent);
  }

  List<Object> buildLeafPath([Object? extraSegment]) {
    final List<Object> base;
    if (inMapped) {
      base = hasMappedLeaf
          ? <Object>[...mappedContainerPath, mappedLeaf!]
          : mappedContainerPath;
    } else {
      base = buildNodePath(_liveNode());
    }
    return extraSegment != null ? <Object>[...base, extraSegment] : base;
  }

  Never fail(
    String message, {
    Object? extraSegment,
    Object? actualValue,
    Object? underlyingError,
  }) {
    final ex = CodableException(
      message,
      path: List<Object>.unmodifiable(buildLeafPath(extraSegment)),
      actualValue: actualValue,
      underlyingError: underlyingError,
    );
    attributedError = ex;
    throw ex;
  }
}

/// Enforces the anti-DoS container nesting limit of [maxCborDepth].
void checkCborDepth(int depth, [CborPathState? pathState]) {
  if (depth >= maxCborDepth) {
    const msg = 'CBOR nesting depth exceeds limit of 64';
    if (pathState != null) pathState.fail(msg);
    throw const CodableException(msg);
  }
}

/// Compares [length] bytes of [buf] starting at [start] against [target].
bool cborBytesMatch(Uint8List buf, int start, Uint8List target, int length) {
  for (var i = 0; i < length; i++) {
    if (buf[start + i] != target[i]) return false;
  }
  return true;
}

/// Pre-encoded UTF-8 key table cached on [KeyOptions] via `compiled<T>`.
final class _CborCompiledKeys {
  final List<Uint8List> utf8Keys;

  _CborCompiledKeys(List<String> keys)
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

ValueKind _major7ValueKind(int ai, CborReader reader) => switch (ai) {
  20 || 21 => ValueKind.boolean,
  22 => ValueKind.nullValue,
  25 || 26 || 27 => ValueKind.number,
  _ => reader.fail('Unsupported CBOR simple/float value: $ai'),
};

/// Low-level single-pass cursor over definite-length RFC 8949 CBOR bytes.
final class CborReader {
  final Uint8List bytes;
  final CborPathState? pathState;
  late final ByteData _bd = ByteData.sublistView(bytes);
  late final Int32List _skipStack = Int32List(maxCborDepth);
  final ByteData _scratch = ByteData(4);
  int offset;

  CborReader(this.bytes, [this.offset = 0, this.pathState]);

  @pragma('vm:never-inline')
  @pragma('wasm:never-inline')
  Never fail(
    String message, {
    Object? extraSegment,
    Object? actualValue,
    Object? underlyingError,
  }) {
    final state = pathState;
    if (state != null) {
      state.fail(
        message,
        extraSegment: extraSegment,
        actualValue: actualValue,
        underlyingError: underlyingError,
      );
    }
    throw CodableException(
      message,
      path: extraSegment != null
          ? List<Object>.unmodifiable(<Object>[extraSegment])
          : const [],
      actualValue: actualValue,
      underlyingError: underlyingError,
    );
  }

  void _require(int count) {
    if (count < 0 || count > bytes.length - offset) {
      fail('Unexpected end of CBOR payload');
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
      fail('Indefinite-length CBOR items are not supported');
    }
    return switch (mt) {
      0 || 1 => ValueKind.number,
      2 => ValueKind.bytes,
      3 => ValueKind.string,
      4 => ValueKind.list,
      5 => ValueKind.map,
      7 => _major7ValueKind(ai, this),
      _ => fail('Unsupported CBOR major type: $mt'),
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
    fail('Invalid CBOR additional info: $ai');
  }

  int _readUint64() {
    _require(8);
    final hi = _bd.getUint32(offset);
    final lo = _bd.getUint32(offset + 4);
    offset += 8;
    if (identical(1.0, 1)) {
      if (hi > cborJsMaxSafeHi) {
        fail('CBOR integer exceeds 53-bit safe integer range on JavaScript');
      }
    } else if (hi >= 0x80000000) {
      fail('CBOR uint64 overflows signed 64-bit int');
    }
    return hi * cborTwoPow32 + lo;
  }

  int readContainerLength(int expectedMajorType) {
    final saved = offset;
    final ib = readByte();
    final mt = ib >>> 5;
    final ai = ib & 0x1f;
    if (mt != expectedMajorType || ai == 31) {
      offset = saved;
      fail('Expected CBOR major type $expectedMajorType, got $mt (ai=$ai)');
    }
    final len = readArg(ai);
    final maxPossible = expectedMajorType == 5
        ? (bytes.length - offset) ~/ 2
        : bytes.length - offset;
    if (len > maxPossible) {
      offset = saved;
      fail('Unexpected end of CBOR payload');
    }
    return len;
  }

  void readNull() {
    final ib = peekByte();
    if (ib != 0xf6) {
      fail('Expected CBOR null (0xf6), got 0x${ib.toRadixString(16)}');
    }
    offset++;
  }

  bool readBool() {
    final ib = peekByte();
    if (ib == 0xf4) {
      offset++;
      return false;
    }
    if (ib == 0xf5) {
      offset++;
      return true;
    }
    fail('Expected CBOR bool, got 0x${ib.toRadixString(16)}');
  }

  int readInt() {
    final saved = offset;
    final ib = readByte();
    final mt = ib >>> 5;
    final ai = ib & 0x1f;
    if (mt == 0) return readArg(ai);
    if (mt == 1) {
      final arg = readArg(ai);
      if (identical(1.0, 1) && arg == cborJsMaxSafeInt) {
        offset = saved;
        fail('CBOR integer exceeds 53-bit safe integer range on JavaScript');
      }
      return -1 - arg;
    }
    offset = saved;
    fail('Expected CBOR integer, got major type $mt');
  }

  double readDouble() {
    final ib = peekByte();
    final mt = ib >>> 5;
    if (mt == 0 || mt == 1) return readInt().toDouble();
    if (mt == 7) return _readMajor7Float();
    fail('Expected CBOR number, got major type $mt');
  }

  num readNum() {
    final ib = peekByte();
    final mt = ib >>> 5;
    if (mt == 0 || mt == 1) return readInt();
    if (mt == 7) return _readMajor7Float();
    fail('Expected CBOR number, got major type $mt');
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
    fail('Expected CBOR float, got simple value $ai');
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
      fail(
        'Invalid UTF-8 in CBOR text string: ${e.message}',
        underlyingError: e,
      );
    }
  }

  int selectString(KeyOptions options) {
    final (start, end) = readTextStringSpan();
    return options
        .compiled<_CborCompiledKeys>(_CborCompiledKeys.new)
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
    fail('Expected CBOR bstr, got major type $mt');
  }

  Uint8List _readByteArrayFallback() {
    final len = readContainerLength(4);
    final out = Uint8List(len);
    for (var i = 0; i < len; i++) {
      final probe = CborReader(bytes, offset);
      final int b;
      try {
        b = probe.readInt();
      } on CodableException catch (e) {
        fail(
          e.message,
          extraSegment: i,
          actualValue: e.actualValue,
          underlyingError: e.underlyingError,
        );
      }
      offset = probe.offset;
      if (b < 0 || b > 255) {
        fail(
          'Expected byte in range 0..255, got $b',
          extraSegment: i,
          actualValue: b,
        );
      }
      out[i] = b;
    }
    return out;
  }

  void skipItem([int baseDepth = 0]) {
    final firstChildren = _consumeItemOrChildCount(readByte());
    if (firstChildren < 0) return;
    checkCborDepth(baseDepth, pathState);
    if (firstChildren == 0) return;
    final stack = _skipStack;
    var sp = 0;
    var pendingItems = firstChildren;
    stack[0] = firstChildren;
    while (sp >= 0) {
      final rem = stack[sp];
      if (rem == 0) {
        sp--;
        continue;
      }
      stack[sp] = rem - 1;
      pendingItems--;
      final nested = _consumeItemOrChildCount(readByte());
      if (nested >= 0) {
        checkCborDepth(baseDepth + sp + 1, pathState);
        if (nested > bytes.length - offset - pendingItems) {
          fail('Unexpected end of CBOR payload');
        }
        if (nested > 0) {
          pendingItems += nested;
          stack[++sp] = nested;
        }
      }
    }
  }

  int _consumeItemOrChildCount(int ib) {
    final mt = ib >>> 5;
    final ai = ib & 0x1f;
    if (ai == 31) {
      fail('Indefinite-length CBOR items are not supported');
    }
    return switch (mt) {
      0 || 1 => _ignoreArg(readArg(ai)),
      2 || 3 => _skipBytes(readArg(ai)),
      4 => _skipArrayElements(ai),
      5 => _skipMapPairs(ai),
      7 => _skipMajor7(ai),
      _ => fail('Unsupported CBOR major type: $mt'),
    };
  }

  int _ignoreArg(int _) => -1;

  int _skipArrayElements(int ai) {
    final len = readArg(ai);
    if (len > bytes.length - offset) {
      fail('Unexpected end of CBOR payload');
    }
    return len;
  }

  int _skipMapPairs(int ai) {
    final pairs = readArg(ai);
    if (pairs > (bytes.length - offset) ~/ 2) {
      fail('Unexpected end of CBOR payload');
    }
    return pairs * 2;
  }

  int _skipBytes(int len) {
    _require(len);
    offset += len;
    return -1;
  }

  int _skipMajor7(int ai) {
    final width = switch (ai) {
      20 || 21 || 22 => 0,
      25 => 2,
      26 => 4,
      27 => 8,
      _ => fail('Unsupported CBOR simple value: $ai'),
    };
    return _skipBytes(width);
  }
}
