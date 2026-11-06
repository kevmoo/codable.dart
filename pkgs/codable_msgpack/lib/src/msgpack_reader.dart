// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:typed_data';

import 'package:codable/codable.dart';

/// Maximum nested container depth allowed during MessagePack encoding,
/// decoding, and value skipping.
const int maxMsgPackDepth = 64;

/// Exact value of `2^32` (`4294967296`) for arithmetic 64-bit split/combine
/// without 32-bit JavaScript bitwise shift truncation.
const int msgPackTwoPow32 = 0x100000000;

/// High 32-bit word limit for JavaScript's `Number.MAX_SAFE_INTEGER` (`2^53-1`).
const int msgPackJsMaxSafeHi = 0x1fffff;

/// Exact `Number.MAX_SAFE_INTEGER` (`2^53 - 1`, `9007199254740991`).
const int msgPackJsMaxSafeInt = 0x1fffff * msgPackTwoPow32 + 0xffffffff;

/// Enforces the anti-DoS container nesting limit of [maxMsgPackDepth].
void checkMsgPackDepth(int depth) {
  if (depth >= maxMsgPackDepth) {
    throw const CodableException(
      'MessagePack nesting depth exceeds limit of 64',
    );
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
final class MsgPackCompiledKeys {
  final List<Uint8List> utf8Keys;
  final Int32List _slots;
  final int _mask;

  factory MsgPackCompiledKeys(List<String> keys) {
    final encoded = [for (final key in keys) utf8.encode(key)];
    if (encoded.isEmpty) {
      return MsgPackCompiledKeys._(encoded, Int32List(0), 0);
    }
    final mask = _tableCapacity(encoded.length) - 1;
    return MsgPackCompiledKeys._(encoded, _buildKeySlots(encoded, mask), mask);
  }

  MsgPackCompiledKeys._(this.utf8Keys, this._slots, this._mask);

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

ValueKind _peekTaggedKind(int b) => switch (b) {
  0xc0 => ValueKind.nullValue,
  0xc2 || 0xc3 => ValueKind.boolean,
  0xc4 || 0xc5 || 0xc6 => ValueKind.bytes,
  >= 0xca && <= 0xd3 => ValueKind.number,
  0xd9 || 0xda || 0xdb => ValueKind.string,
  0xdc || 0xdd => ValueKind.list,
  0xde || 0xdf => ValueKind.map,
  0xc1 => throw const CodableException(
    'Invalid MessagePack byte 0xc1 (never used)',
  ),
  _ => throw CodableException(
    'Unsupported MessagePack extension type: 0x${b.toRadixString(16)}',
  ),
};

/// Low-level single-pass cursor over MessagePack bytes.
final class MsgPackReader {
  final Uint8List bytes;
  late final ByteData _bd = ByteData.sublistView(bytes);
  late final Int32List _skipStack = Int32List(maxMsgPackDepth);
  int offset;

  MsgPackReader(this.bytes, [this.offset = 0]);

  void _require(int count) {
    if (count < 0 || count > bytes.length - offset) {
      throw const CodableException('Unexpected end of MessagePack payload');
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
    return _peekTaggedKind(b);
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
        throw const CodableException(
          'MessagePack uint64 exceeds 53-bit safe integer range on JavaScript',
        );
      }
    } else if (hi >= 0x80000000) {
      throw const CodableException(
        'MessagePack uint64 overflows signed 64-bit int',
      );
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
        throw const CodableException(
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
      throw const CodableException(
        'MessagePack int64 exceeds 53-bit safe integer range on JavaScript',
      );
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
      throw const CodableException('Unexpected end of MessagePack payload');
    }
  }

  void _checkArrayRemaining(int len) {
    if (len > bytes.length - offset) {
      throw const CodableException('Unexpected end of MessagePack payload');
    }
  }

  int readMapLength() {
    final b = readByte();
    final int pairs;
    if (b >= 0x80 && b <= 0x8f) {
      pairs = b & 0x0f;
    } else if (b == 0xde) {
      pairs = _readUint16();
    } else if (b == 0xdf) {
      pairs = _readUint32();
    } else {
      throw CodableException(
        'Expected MessagePack map, got 0x${b.toRadixString(16)}',
      );
    }
    _checkMapRemaining(pairs);
    return pairs;
  }

  int readArrayLength() {
    final b = readByte();
    final int len;
    if (b >= 0x90 && b <= 0x9f) {
      len = b & 0x0f;
    } else if (b == 0xdc) {
      len = _readUint16();
    } else if (b == 0xdd) {
      len = _readUint32();
    } else {
      throw CodableException(
        'Expected MessagePack array, got 0x${b.toRadixString(16)}',
      );
    }
    _checkArrayRemaining(len);
    return len;
  }

  void readNull() {
    final b = readByte();
    if (b != 0xc0) {
      throw CodableException(
        'Expected MessagePack nil (0xc0), got 0x${b.toRadixString(16)}',
      );
    }
  }

  bool readBool() {
    final b = readByte();
    if (b == 0xc2) return false;
    if (b == 0xc3) return true;
    throw CodableException(
      'Expected MessagePack bool, got 0x${b.toRadixString(16)}',
    );
  }

  int readInt() {
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
      _ => throw CodableException(
        'Expected MessagePack integer, got 0x${b.toRadixString(16)}',
      ),
    };
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
      throw CodableException(
        'Expected MessagePack string, got 0x${b.toRadixString(16)}',
      );
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
      throw CodableException(
        'Invalid UTF-8 in MessagePack string: ${e.message}',
        underlyingError: e,
      );
    }
  }

  int selectString(KeyOptions options) {
    final (start, end) = readTextStringSpan();
    return options
        .compiled<MsgPackCompiledKeys>(MsgPackCompiledKeys.new)
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
    throw CodableException(
      'Expected MessagePack bin or byte array, got 0x${b.toRadixString(16)}',
    );
  }

  Uint8List _readByteArrayFallback() {
    final len = readArrayLength();
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

  void skipItem([int baseDepth = 0]) {
    final firstChildren = _consumeItemOrChildCount(readByte());
    if (firstChildren < 0) return;
    checkMsgPackDepth(baseDepth);
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
        checkMsgPackDepth(baseDepth + sp + 1);
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
    _ => throw const CodableException(
      'Invalid MessagePack byte 0xc1 (never used)',
    ),
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
