// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:typed_data';

import 'package:codable/codable.dart';

import 'msgpack_reader.dart';

final class _MsgPackWriter {
  Uint8List _buf;
  late ByteData _bd = ByteData.sublistView(_buf);
  int _writePos = 0;

  _MsgPackWriter([int initialCapacity = 256])
    : _buf = Uint8List(initialCapacity);

  void _ensureCapacity(int extra) {
    final needed = _writePos + extra;
    if (needed <= _buf.length) return;
    var nextCap = _buf.isEmpty ? 64 : _buf.length * 2;
    while (nextCap < needed) {
      nextCap *= 2;
    }
    final grown = Uint8List(nextCap)..setRange(0, _writePos, _buf);
    _buf = grown;
    _bd = ByteData.sublistView(_buf);
  }

  void writeContainerHeader({required bool isMap, required int count}) {
    if (count < 0 || count > 0xffffffff) {
      throw CodableException('Invalid MessagePack container length: $count');
    }
    if (count < 16) {
      _ensureCapacity(1);
      _buf[_writePos++] = (isMap ? 0x80 : 0x90) | count;
      return;
    }
    if (count <= 0xffff) {
      _ensureCapacity(3);
      _buf[_writePos++] = isMap ? 0xde : 0xdc;
      _bd.setUint16(_writePos, count);
      _writePos += 2;
      return;
    }
    _ensureCapacity(5);
    _buf[_writePos++] = isMap ? 0xdf : 0xdd;
    _bd.setUint32(_writePos, count);
    _writePos += 4;
  }

  int reserveByte(int placeholder) {
    _ensureCapacity(1);
    final offset = _writePos++;
    _buf[offset] = placeholder;
    return offset;
  }

  void patchContainerHeader(
    int headerOffset, {
    required bool isMap,
    required int count,
  }) {
    if (count < 16) {
      _buf[headerOffset] = (isMap ? 0x80 : 0x90) | count;
      return;
    }
    if (count > 0xffffffff) {
      throw CodableException('Invalid MessagePack container length: $count');
    }
    final extra = count <= 0xffff ? 2 : 4;
    _ensureCapacity(extra);
    _buf.setRange(
      headerOffset + 1 + extra,
      _writePos + extra,
      _buf,
      headerOffset + 1,
    );
    _writePos += extra;
    if (extra == 2) {
      _buf[headerOffset] = isMap ? 0xde : 0xdc;
      _bd.setUint16(headerOffset + 1, count);
    } else {
      _buf[headerOffset] = isMap ? 0xdf : 0xdd;
      _bd.setUint32(headerOffset + 1, count);
    }
  }

  void writeInt(int value) {
    if (value >= 0) {
      _writeNonNegativeInt(value);
    } else {
      _writeNegativeInt(value);
    }
  }

  void _writeNonNegativeInt(int value) {
    if (value <= 0x7f) {
      _ensureCapacity(1);
      _buf[_writePos++] = value;
      return;
    }
    if (value <= 0xff) {
      _ensureCapacity(2);
      _buf[_writePos++] = 0xcc;
      _buf[_writePos++] = value;
      return;
    }
    if (value <= 0xffff) {
      _ensureCapacity(3);
      _buf[_writePos++] = 0xcd;
      _bd.setUint16(_writePos, value);
      _writePos += 2;
      return;
    }
    if (value <= 0xffffffff) {
      _ensureCapacity(5);
      _buf[_writePos++] = 0xce;
      _bd.setUint32(_writePos, value);
      _writePos += 4;
      return;
    }
    _writeUint64(value);
  }

  void _writeUint64(int value) {
    final hi = value ~/ msgPackTwoPow32;
    if (identical(1.0, 1) && hi > msgPackJsMaxSafeHi) {
      throw const CodableException(
        'MessagePack integer exceeds 53-bit safe integer range on JavaScript',
      );
    }
    _ensureCapacity(9);
    _buf[_writePos++] = 0xcf;
    _bd.setUint32(_writePos, hi);
    _bd.setUint32(_writePos + 4, value.remainder(msgPackTwoPow32));
    _writePos += 8;
  }

  void _writeNegativeInt(int value) {
    if (value >= -32) {
      _ensureCapacity(1);
      _buf[_writePos++] = 0x100 + value;
      return;
    }
    if (value >= -128) {
      _ensureCapacity(2);
      _buf[_writePos++] = 0xd0;
      _bd.setInt8(_writePos++, value);
      return;
    }
    if (value >= -32768) {
      _ensureCapacity(3);
      _buf[_writePos++] = 0xd1;
      _bd.setInt16(_writePos, value);
      _writePos += 2;
      return;
    }
    if (value >= -0x80000000) {
      _ensureCapacity(5);
      _buf[_writePos++] = 0xd2;
      _bd.setInt32(_writePos, value);
      _writePos += 4;
      return;
    }
    _writeInt64(value);
  }

  void _writeInt64(int value) {
    if (identical(1.0, 1) && value < -msgPackJsMaxSafeInt) {
      throw const CodableException(
        'MessagePack integer exceeds 53-bit safe integer range on JavaScript',
      );
    }
    final magMinus1 = -1 - value;
    final notHi = magMinus1 ~/ msgPackTwoPow32;
    final notLo = magMinus1.remainder(msgPackTwoPow32);
    _ensureCapacity(9);
    _buf[_writePos++] = 0xd3;
    _bd.setUint32(_writePos, 0xffffffff - notHi);
    _bd.setUint32(_writePos + 4, 0xffffffff - notLo);
    _writePos += 8;
  }

  void writeDouble(double value) {
    _ensureCapacity(9);
    _buf[_writePos++] = 0xcb;
    _bd.setFloat64(_writePos, value);
    _writePos += 8;
  }

  void writeBool(bool value) {
    _ensureCapacity(1);
    _buf[_writePos++] = value ? 0xc3 : 0xc2;
  }

  void writeNull() {
    _ensureCapacity(1);
    _buf[_writePos++] = 0xc0;
  }

  void writeBytes(Uint8List value) {
    final len = value.length;
    if (len <= 0xff) {
      _ensureCapacity(2 + len);
      _buf[_writePos++] = 0xc4;
      _buf[_writePos++] = len;
    } else if (len <= 0xffff) {
      _ensureCapacity(3 + len);
      _buf[_writePos++] = 0xc5;
      _bd.setUint16(_writePos, len);
      _writePos += 2;
    } else if (len <= 0xffffffff) {
      _ensureCapacity(5 + len);
      _buf[_writePos++] = 0xc6;
      _bd.setUint32(_writePos, len);
      _writePos += 4;
    } else {
      throw CodableException('MessagePack bin exceeds uint32 maximum: $len');
    }
    _buf.setRange(_writePos, _writePos + len, value);
    _writePos += len;
  }

  void writeTextString(String value) {
    final encoded = utf8.encode(value);
    final len = encoded.length;
    if (len < 32) {
      _ensureCapacity(1 + len);
      _buf[_writePos++] = 0xa0 | len;
    } else if (len <= 0xff) {
      _ensureCapacity(2 + len);
      _buf[_writePos++] = 0xd9;
      _buf[_writePos++] = len;
    } else if (len <= 0xffff) {
      _ensureCapacity(3 + len);
      _buf[_writePos++] = 0xda;
      _bd.setUint16(_writePos, len);
      _writePos += 2;
    } else if (len <= 0xffffffff) {
      _ensureCapacity(5 + len);
      _buf[_writePos++] = 0xdb;
      _bd.setUint32(_writePos, len);
      _writePos += 4;
    } else {
      throw CodableException('MessagePack str exceeds uint32 maximum: $len');
    }
    _buf.setRange(_writePos, _writePos + len, encoded);
    _writePos += len;
  }

  Uint8List toBytes() => _buf.sublist(0, _writePos);
}

abstract interface class _MsgPackCloseable {
  void close();
}

int _initContainerHeader(
  _MsgPackWriter writer, {
  required bool isMap,
  required int? length,
  required bool requireKnownLength,
}) {
  if (length != null) {
    writer.writeContainerHeader(isMap: isMap, count: length);
    return -1;
  }
  if (requireKnownLength) {
    throw const CodableException(
      'Single-pass MessagePack encoding requires upfront container length',
    );
  }
  return writer.reserveByte(isMap ? 0x80 : 0x90);
}

void _finalizeContainerHeader(
  _MsgPackWriter writer, {
  required bool isMap,
  required int? fixedLength,
  required int headerOffset,
  required int count,
}) {
  if (fixedLength != null) {
    if (count != fixedLength) {
      final kind = isMap ? 'map' : 'array';
      throw CodableException(
        'MessagePack $kind length mismatch: declared $fixedLength, wrote $count',
      );
    }
    return;
  }
  writer.patchContainerHeader(headerOffset, isMap: isMap, count: count);
}

/// Single-pass MessagePack [Encoder] (`isHumanReadable => false`).
final class MsgPackCodableEncoder implements Encoder {
  final _MsgPackWriter _writer;
  final int _depth;

  /// Whether every opened container must supply a non-null upfront `length`.
  final bool requireKnownLength;

  _MsgPackCloseable? _activeContainer;

  @override
  final Map<Object, Object?> userInfo;

  /// Creates a [MsgPackCodableEncoder] writing into a fresh byte buffer.
  MsgPackCodableEncoder({
    this.requireKnownLength = false,
    Map<Object, Object?>? userInfo,
  }) : _writer = _MsgPackWriter(),
       _depth = 0,
       userInfo = userInfo ?? const {};

  MsgPackCodableEncoder._(
    this._writer,
    this._depth, {
    required this.requireKnownLength,
    required this.userInfo,
  });

  /// Encodes [value] to MessagePack bytes using [encodable].
  static Uint8List encode<T>(
    T value,
    Encodable<T> encodable, {
    bool requireKnownLength = false,
    Map<Object, Object?>? userInfo,
  }) {
    final encoder = MsgPackCodableEncoder(
      requireKnownLength: requireKnownLength,
      userInfo: userInfo,
    );
    encodable.encode(value, encoder);
    return encoder.toBytes();
  }

  /// Finalizes any open container and returns the encoded MessagePack bytes.
  Uint8List toBytes() {
    _finish();
    return _writer.toBytes();
  }

  void _finish() {
    _activeContainer?.close();
    _activeContainer = null;
  }

  MsgPackCodableEncoder _spawnChild() => MsgPackCodableEncoder._(
    _writer,
    _depth + 1,
    requireKnownLength: requireKnownLength,
    userInfo: userInfo,
  );

  @override
  bool get isHumanReadable => false;

  @override
  KeyedEncoder keyed({KeyOptions? options, int? length}) {
    _finish();
    checkMsgPackDepth(_depth);
    final container = _MsgPackKeyedEncoder(this, _writer, length: length);
    _activeContainer = container;
    return container;
  }

  @override
  UnkeyedEncoder unkeyed({int? length}) {
    _finish();
    checkMsgPackDepth(_depth);
    final container = _MsgPackUnkeyedEncoder(this, _writer, length: length);
    _activeContainer = container;
    return container;
  }

  @override
  MapEncoder map({int? length}) {
    _finish();
    checkMsgPackDepth(_depth);
    final container = _MsgPackMapEncoder(this, _writer, length: length);
    _activeContainer = container;
    return container;
  }

  @override
  SingleValueEncoder singleValue() {
    _finish();
    return _MsgPackSingleValueEncoder(this, _writer);
  }
}

final class _MsgPackKeyedEncoder
    with BaseKeyedEncoderMixin
    implements KeyedEncoder, _MsgPackCloseable {
  final MsgPackCodableEncoder _owner;
  final _MsgPackWriter _writer;
  final int? _fixedLength;
  final int _headerOffset;
  int _count = 0;
  bool _closed = false;
  MsgPackCodableEncoder? _pendingNested;

  _MsgPackKeyedEncoder(this._owner, this._writer, {int? length})
    : _fixedLength = length,
      _headerOffset = _initContainerHeader(
        _writer,
        isMap: true,
        length: length,
        requireKnownLength: _owner.requireKnownLength,
      );

  void _finishPending() {
    _pendingNested?._finish();
    _pendingNested = null;
  }

  void _beginField(String key) {
    _finishPending();
    _count++;
    _writer.writeTextString(key);
  }

  @override
  void close() {
    if (_closed) return;
    _closed = true;
    _finishPending();
    _finalizeContainerHeader(
      _writer,
      isMap: true,
      fixedLength: _fixedLength,
      headerOffset: _headerOffset,
      count: _count,
    );
  }

  @override
  void encodeInt(String key, int value) {
    _beginField(key);
    _writer.writeInt(value);
  }

  @override
  void encodeDouble(String key, double value) {
    _beginField(key);
    _writer.writeDouble(value);
  }

  @override
  void encodeString(String key, String value) {
    _beginField(key);
    _writer.writeTextString(value);
  }

  @override
  void encodeBool(String key, bool value) {
    _beginField(key);
    _writer.writeBool(value);
  }

  @override
  void encodeBytes(String key, Uint8List value) {
    _beginField(key);
    _writer.writeBytes(value);
  }

  @override
  void encodeNull(String key) {
    _beginField(key);
    _writer.writeNull();
  }

  @override
  Encoder nestedEncoder(String key) {
    _beginField(key);
    final child = _owner._spawnChild();
    _pendingNested = child;
    return child;
  }
}

final class _MsgPackUnkeyedEncoder
    with BaseUnkeyedEncoderMixin
    implements UnkeyedEncoder, _MsgPackCloseable {
  final MsgPackCodableEncoder _owner;
  final _MsgPackWriter _writer;
  final int? _fixedLength;
  final int _headerOffset;
  int _count = 0;
  bool _closed = false;
  MsgPackCodableEncoder? _pendingNested;

  _MsgPackUnkeyedEncoder(this._owner, this._writer, {int? length})
    : _fixedLength = length,
      _headerOffset = _initContainerHeader(
        _writer,
        isMap: false,
        length: length,
        requireKnownLength: _owner.requireKnownLength,
      );

  void _finishPending() {
    _pendingNested?._finish();
    _pendingNested = null;
  }

  void _beginElement() {
    _finishPending();
    _count++;
  }

  @override
  void close() {
    if (_closed) return;
    _closed = true;
    _finishPending();
    _finalizeContainerHeader(
      _writer,
      isMap: false,
      fixedLength: _fixedLength,
      headerOffset: _headerOffset,
      count: _count,
    );
  }

  @override
  void encodeInt(int value) {
    _beginElement();
    _writer.writeInt(value);
  }

  @override
  void encodeDouble(double value) {
    _beginElement();
    _writer.writeDouble(value);
  }

  @override
  void encodeString(String value) {
    _beginElement();
    _writer.writeTextString(value);
  }

  @override
  void encodeBool(bool value) {
    _beginElement();
    _writer.writeBool(value);
  }

  @override
  void encodeBytes(Uint8List value) {
    _beginElement();
    _writer.writeBytes(value);
  }

  @override
  void encodeNull() {
    _beginElement();
    _writer.writeNull();
  }

  @override
  Encoder nestedEncoder() {
    _beginElement();
    final child = _owner._spawnChild();
    _pendingNested = child;
    return child;
  }
}

final class _MsgPackMapEncoder implements MapEncoder, _MsgPackCloseable {
  final MsgPackCodableEncoder _owner;
  final _MsgPackWriter _writer;
  final int? _fixedLength;
  final int _headerOffset;
  int _count = 0;
  bool _expectingValue = false;
  bool _closed = false;
  MsgPackCodableEncoder? _pendingNested;

  _MsgPackMapEncoder(this._owner, this._writer, {int? length})
    : _fixedLength = length,
      _headerOffset = _initContainerHeader(
        _writer,
        isMap: true,
        length: length,
        requireKnownLength: _owner.requireKnownLength,
      );

  void _finishPending() {
    _pendingNested?._finish();
    _pendingNested = null;
  }

  @override
  Encoder keyEncoder() {
    _finishPending();
    if (_expectingValue) {
      throw const CodableException(
        'MapEncoder.keyEncoder() called before valueEncoder()',
      );
    }
    _expectingValue = true;
    _count++;
    final child = _owner._spawnChild();
    _pendingNested = child;
    return child;
  }

  @override
  Encoder valueEncoder() {
    _finishPending();
    if (!_expectingValue) {
      throw const CodableException(
        'MapEncoder.valueEncoder() called before keyEncoder()',
      );
    }
    _expectingValue = false;
    final child = _owner._spawnChild();
    _pendingNested = child;
    return child;
  }

  @override
  void close() {
    if (_closed) return;
    _closed = true;
    _finishPending();
    if (_expectingValue) {
      throw const CodableException(
        'Dangling key without value in MessagePack MapEncoder',
      );
    }
    _finalizeContainerHeader(
      _writer,
      isMap: true,
      fixedLength: _fixedLength,
      headerOffset: _headerOffset,
      count: _count,
    );
  }
}

final class _MsgPackSingleValueEncoder
    with BaseSingleValueEncoderMixin
    implements SingleValueEncoder {
  final MsgPackCodableEncoder _parent;
  final _MsgPackWriter _writer;

  _MsgPackSingleValueEncoder(this._parent, this._writer);

  @override
  void encodeInt(int value) => _writer.writeInt(value);

  @override
  void encodeDouble(double value) => _writer.writeDouble(value);

  @override
  void encodeString(String value) => _writer.writeTextString(value);

  @override
  void encodeBool(bool value) => _writer.writeBool(value);

  @override
  void encodeBytes(Uint8List value) => _writer.writeBytes(value);

  @override
  void encodeNull() => _writer.writeNull();

  @override
  void encode<T>(T value, Encodable<T> encodable) =>
      encodable.encode(value, _parent);
}
