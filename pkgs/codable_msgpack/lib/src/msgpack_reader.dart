// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:typed_data';

import 'package:codable/codable.dart';

/// Maximum nested container depth allowed during MessagePack encoding,
/// decoding, and value skipping.
const int _maxMsgPackDepth = 64;

/// Exact value of `2^32` (`4294967296`) for arithmetic 64-bit split/combine
/// without 32-bit JavaScript bitwise shift truncation.
const int msgPackTwoPow32 = 0x100000000;

/// High 32-bit word limit for JavaScript's `Number.MAX_SAFE_INTEGER` (`2^53-1`).
const int msgPackJsMaxSafeHi = 0x1fffff;

/// Exact `Number.MAX_SAFE_INTEGER` (`2^53 - 1`, `9007199254740991`).
const int msgPackJsMaxSafeInt = 0x1fffff * msgPackTwoPow32 + 0xffffffff;

/// Linked cursor frame for zero-allocation MessagePack diagnostic path
/// recovery.
abstract base class MsgPackPathNode {
  final MsgPackPathNode? parent;
  bool ended = false;
  bool inChild = false;

  MsgPackPathNode(this.parent);

  void appendSegment(List<Object> out);
}

/// Per-decode error-attribution and cursor stack state for MessagePack
/// decoding.
final class MsgPackPathState {
  MsgPackPathNode? activeNode;
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

  MsgPackPathNode? _liveNode() {
    var c = activeNode;
    while (c != null && c.ended) {
      c = c.parent;
    }
    return c;
  }

  List<Object> buildNodePath(MsgPackPathNode? leafNode) {
    if (leafNode == null) return const [];
    final chain = <MsgPackPathNode>[];
    MsgPackPathNode? curr = leafNode;
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

/// Enforces the anti-DoS container nesting limit of [_maxMsgPackDepth].
void checkMsgPackDepth(int depth, [MsgPackPathState? pathState]) {
  if (depth >= _maxMsgPackDepth) {
    const msg = 'MessagePack nesting depth exceeds limit of 64';
    if (pathState != null) pathState.fail(msg);
    throw const CodableException(msg);
  }
}

/// Whether [tag] is a MessagePack UTF-8 string prefix (`fixstr` or `str8..32`).
bool isMsgPackStringTag(int tag) =>
    (tag >= 0xa0 && tag <= 0xbf) || (tag >= 0xd9 && tag <= 0xdb);

/// Compares [length] bytes of [buf] starting at [start] against [target].
bool msgPackBytesMatch(Uint8List buf, int start, Uint8List target, int length) {
  for (var i = 0; i < length; i++) {
    if (buf[start + i] != target[i]) return false;
  }
  return true;
}

int _hashUtf8Slice(Uint8List buf, int start, int length) {
  var h = 0x1505;
  for (var i = 0; i < length; i++) {
    h = ((h * 33) + buf[start + i]) & 0x3fffffff;
  }
  return h;
}

int _tableCapacity(int keyCount) {
  var cap = 4;
  final minCap = keyCount * 2;
  while (cap < minCap) {
    cap *= 2;
  }
  return cap;
}

void _insertCompiledKey(
  Int32List slots,
  List<Uint8List> utf8Keys,
  int mask,
  int index,
) {
  final keyBytes = utf8Keys[index];
  var slot = _hashUtf8Slice(keyBytes, 0, keyBytes.length) & mask;
  while (true) {
    final existing = slots[slot];
    if (existing < 0) {
      slots[slot] = index;
      return;
    }
    final prev = utf8Keys[existing];
    if (prev.length == keyBytes.length &&
        msgPackBytesMatch(prev, 0, keyBytes, keyBytes.length)) {
      return;
    }
    slot = (slot + 1) & mask;
  }
}

Int32List _buildKeySlots(List<Uint8List> utf8Keys, int mask) {
  final slots = Int32List(mask + 1)..fillRange(0, mask + 1, -1);
  for (var i = 0; i < utf8Keys.length; i++) {
    _insertCompiledKey(slots, utf8Keys, mask, i);
  }
  return slots;
}

/// Pre-compiled UTF-8 byte hash/span key table cached on [KeyOptions] via
/// `compiled<T>`.
final class _MsgPackCompiledKeys {
  final List<Uint8List> utf8Keys;
  final Int32List _slots;
  final int _mask;

  factory _MsgPackCompiledKeys(List<String> keys) {
    final encoded = [for (final key in keys) utf8.encode(key)];
    if (encoded.isEmpty) {
      return _MsgPackCompiledKeys._(encoded, Int32List(0), 0);
    }
    final mask = _tableCapacity(encoded.length) - 1;
    return _MsgPackCompiledKeys._(encoded, _buildKeySlots(encoded, mask), mask);
  }

  _MsgPackCompiledKeys._(this.utf8Keys, this._slots, this._mask);

  int match(Uint8List buf, int start, int length) {
    if (utf8Keys.isEmpty) return -1;
    var slot = _hashUtf8Slice(buf, start, length) & _mask;
    while (true) {
      final idx = _slots[slot];
      if (idx < 0) return -1;
      final candidate = utf8Keys[idx];
      if (candidate.length == length &&
          msgPackBytesMatch(buf, start, candidate, length)) {
        return idx;
      }
      slot = (slot + 1) & _mask;
    }
  }
}

ValueKind _peekTaggedKind(int b, MsgPackReader reader) => switch (b) {
  0xc0 => ValueKind.nullValue,
  0xc2 || 0xc3 => ValueKind.boolean,
  0xc4 || 0xc5 || 0xc6 => ValueKind.bytes,
  >= 0xca && <= 0xd3 => ValueKind.number,
  0xd9 || 0xda || 0xdb => ValueKind.string,
  0xdc || 0xdd => ValueKind.list,
  0xde || 0xdf => ValueKind.map,
  0xc1 => reader.fail('Invalid MessagePack byte 0xc1 (never used)'),
  _ => reader.fail(
    'Unsupported MessagePack extension type: 0x${b.toRadixString(16)}',
  ),
};

/// Low-level single-pass cursor over MessagePack bytes.
final class MsgPackReader {
  final Uint8List bytes;
  final MsgPackPathState? pathState;
  late final ByteData _bd = ByteData.sublistView(bytes);
  late final Int32List _skipStack = Int32List(_maxMsgPackDepth);
  int offset;

  MsgPackReader(this.bytes, [this.offset = 0, this.pathState]);

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
      fail('Unexpected end of MessagePack payload');
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
    final b = peekByte();
    if (b <= 0x7f || b >= 0xe0) return ValueKind.number;
    if (b <= 0xbf) {
      if (b <= 0x8f) return ValueKind.map;
      if (b <= 0x9f) return ValueKind.list;
      return ValueKind.string;
    }
    return _peekTaggedKind(b, this);
  }

  int _readUint16() {
    _require(2);
    final v = _bd.getUint16(offset);
    offset += 2;
    return v;
  }

  int _readUint32() {
    _require(4);
    final v = _bd.getUint32(offset);
    offset += 4;
    return v;
  }

  int _readInt8() {
    _require(1);
    return _bd.getInt8(offset++);
  }

  int _readInt16() {
    _require(2);
    final v = _bd.getInt16(offset);
    offset += 2;
    return v;
  }

  int _readInt32() {
    _require(4);
    final v = _bd.getInt32(offset);
    offset += 4;
    return v;
  }

  int _readUint64() {
    _require(8);
    final hi = _bd.getUint32(offset);
    final lo = _bd.getUint32(offset + 4);
    offset += 8;
    if (identical(1.0, 1)) {
      if (hi > msgPackJsMaxSafeHi) {
        fail(
          'MessagePack uint64 exceeds 53-bit safe integer range on JavaScript',
        );
      }
    } else if (hi >= 0x80000000) {
      fail('MessagePack uint64 overflows signed 64-bit int');
    }
    return hi * msgPackTwoPow32 + lo;
  }

  int _readInt64() {
    _require(8);
    final hi = _bd.getUint32(offset);
    final lo = _bd.getUint32(offset + 4);
    offset += 8;
    if (hi < 0x80000000) {
      if (identical(1.0, 1) && hi > msgPackJsMaxSafeHi) {
        fail(
          'MessagePack int64 exceeds 53-bit safe integer range on JavaScript',
        );
      }
      return hi * msgPackTwoPow32 + lo;
    }
    final notHi = 0xffffffff - hi;
    final notLo = 0xffffffff - lo;
    if (identical(1.0, 1) &&
        (notHi > msgPackJsMaxSafeHi ||
            (notHi == msgPackJsMaxSafeHi && notLo == 0xffffffff))) {
      fail('MessagePack int64 exceeds 53-bit safe integer range on JavaScript');
    }
    return -1 - (notHi * msgPackTwoPow32 + notLo);
  }

  double _readFloat32() {
    _require(4);
    final v = _bd.getFloat32(offset);
    offset += 4;
    return v;
  }

  double _readFloat64() {
    _require(8);
    final v = _bd.getFloat64(offset);
    offset += 8;
    return v;
  }

  void _checkMapRemaining(int pairs) {
    if (pairs > (bytes.length - offset) ~/ 2) {
      fail('Unexpected end of MessagePack payload');
    }
  }

  void _checkArrayRemaining(int len) {
    if (len > bytes.length - offset) {
      fail('Unexpected end of MessagePack payload');
    }
  }

  int readMapLength() {
    final saved = offset;
    final b = readByte();
    final int pairs;
    if (b >= 0x80 && b <= 0x8f) {
      pairs = b & 0x0f;
    } else if (b == 0xde) {
      pairs = _readUint16();
    } else if (b == 0xdf) {
      pairs = _readUint32();
    } else {
      offset = saved;
      fail('Expected MessagePack map, got 0x${b.toRadixString(16)}');
    }
    _checkMapRemaining(pairs);
    return pairs;
  }

  int readArrayLength() {
    final saved = offset;
    final b = readByte();
    final int len;
    if (b >= 0x90 && b <= 0x9f) {
      len = b & 0x0f;
    } else if (b == 0xdc) {
      len = _readUint16();
    } else if (b == 0xdd) {
      len = _readUint32();
    } else {
      offset = saved;
      fail('Expected MessagePack array, got 0x${b.toRadixString(16)}');
    }
    _checkArrayRemaining(len);
    return len;
  }

  void readNull() {
    final b = peekByte();
    if (b != 0xc0) {
      fail('Expected MessagePack nil (0xc0), got 0x${b.toRadixString(16)}');
    }
    offset++;
  }

  bool readBool() {
    final b = peekByte();
    if (b == 0xc2) {
      offset++;
      return false;
    }
    if (b == 0xc3) {
      offset++;
      return true;
    }
    fail('Expected MessagePack bool, got 0x${b.toRadixString(16)}');
  }

  int readInt() {
    final saved = offset;
    final b = readByte();
    if (b <= 0x7f) return b;
    if (b >= 0xe0) return b - 0x100;
    return switch (b) {
      0xcc => readByte(),
      0xcd => _readUint16(),
      0xce => _readUint32(),
      0xcf => _readUint64(),
      0xd0 => _readInt8(),
      0xd1 => _readInt16(),
      0xd2 => _readInt32(),
      0xd3 => _readInt64(),
      _ => _restoreAndFailInt(saved, b),
    };
  }

  Never _restoreAndFailInt(int saved, int b) {
    offset = saved;
    fail('Expected MessagePack integer, got 0x${b.toRadixString(16)}');
  }

  double readDouble() {
    final b = peekByte();
    if (b == 0xca) {
      offset++;
      return _readFloat32();
    }
    if (b == 0xcb) {
      offset++;
      return _readFloat64();
    }
    return readInt().toDouble();
  }

  num readNum() {
    final b = peekByte();
    if (b == 0xca) {
      offset++;
      return _readFloat32();
    }
    if (b == 0xcb) {
      offset++;
      return _readFloat64();
    }
    return readInt();
  }

  (int start, int end) readTextStringSpan() {
    final saved = offset;
    final b = readByte();
    final int len;
    if (b >= 0xa0 && b <= 0xbf) {
      len = b & 0x1f;
    } else if (b == 0xd9) {
      len = readByte();
    } else if (b == 0xda) {
      len = _readUint16();
    } else if (b == 0xdb) {
      len = _readUint32();
    } else {
      offset = saved;
      fail('Expected MessagePack string, got 0x${b.toRadixString(16)}');
    }
    _require(len);
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
        'Invalid UTF-8 in MessagePack string: ${e.message}',
        underlyingError: e,
      );
    }
  }

  int selectString(KeyOptions options) {
    final (start, end) = readTextStringSpan();
    return options
        .compiled<_MsgPackCompiledKeys>(_MsgPackCompiledKeys.new)
        .match(bytes, start, end - start);
  }

  Uint8List readBytes() {
    final b = peekByte();
    if (b >= 0xc4 && b <= 0xc6) {
      offset++;
      final len = switch (b) {
        0xc4 => readByte(),
        0xc5 => _readUint16(),
        _ => _readUint32(),
      };
      _require(len);
      final start = offset;
      offset = start + len;
      return Uint8List.sublistView(bytes, start, offset);
    }
    if ((b >= 0x90 && b <= 0x9f) || b == 0xdc || b == 0xdd) {
      return _readByteArrayFallback();
    }
    fail(
      'Expected MessagePack bin or byte array, got 0x${b.toRadixString(16)}',
    );
  }

  Uint8List _readByteArrayFallback() {
    final len = readArrayLength();
    final out = Uint8List(len);
    for (var i = 0; i < len; i++) {
      final probe = MsgPackReader(bytes, offset);
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
    checkMsgPackDepth(baseDepth, pathState);
    if (firstChildren == 0) return;
    final stack = _skipStack;
    var sp = 0;
    stack[0] = firstChildren;
    while (sp >= 0) {
      final rem = stack[sp];
      if (rem == 0) {
        sp--;
        continue;
      }
      stack[sp] = rem - 1;
      final nested = _consumeItemOrChildCount(readByte());
      if (nested >= 0) {
        checkMsgPackDepth(baseDepth + sp + 1, pathState);
        if (nested > 0) stack[++sp] = nested;
      }
    }
  }

  int _consumeItemOrChildCount(int b) {
    if (b <= 0x7f || b >= 0xe0) return -1;
    if (b <= 0x8f) return _skipMapCount(b & 0x0f);
    if (b <= 0x9f) return _skipArrayCount(b & 0x0f);
    if (b <= 0xbf) return _skipScalarBytes(b & 0x1f);
    return _consumeTaggedItem(b);
  }

  int _consumeTaggedItem(int b) => switch (b) {
    0xc0 || 0xc2 || 0xc3 => -1,
    0xc4 || 0xd9 => _skipScalarBytes(readByte()),
    0xc5 || 0xda => _skipScalarBytes(_readUint16()),
    0xc6 || 0xdb => _skipScalarBytes(_readUint32()),
    0xc7 => _skipExtBytes(readByte()),
    0xc8 => _skipExtBytes(_readUint16()),
    0xc9 => _skipExtBytes(_readUint32()),
    0xcc || 0xd0 => _skipScalarBytes(1),
    0xcd || 0xd1 || 0xd4 => _skipScalarBytes(2),
    0xd5 => _skipScalarBytes(3),
    0xca || 0xce || 0xd2 => _skipScalarBytes(4),
    0xd6 => _skipScalarBytes(5),
    0xcb || 0xcf || 0xd3 => _skipScalarBytes(8),
    0xd7 => _skipScalarBytes(9),
    0xd8 => _skipScalarBytes(17),
    0xdc => _skipArrayCount(_readUint16()),
    0xdd => _skipArrayCount(_readUint32()),
    0xde => _skipMapCount(_readUint16()),
    0xdf => _skipMapCount(_readUint32()),
    _ => fail('Invalid MessagePack byte 0xc1 (never used)'),
  };

  int _skipScalarBytes(int len) {
    _require(len);
    offset += len;
    return -1;
  }

  int _skipExtBytes(int dataLen) {
    _require(1);
    offset++;
    return _skipScalarBytes(dataLen);
  }

  int _skipArrayCount(int len) {
    _checkArrayRemaining(len);
    return len;
  }

  int _skipMapCount(int pairs) {
    _checkMapRemaining(pairs);
    return pairs * 2;
  }
}
