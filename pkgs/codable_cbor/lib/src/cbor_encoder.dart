// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:typed_data';

import 'package:codable/codable.dart';

import 'cbor_reader.dart';

final class _CborWriter {
  Uint8List _buf;
  late ByteData _bd = ByteData.sublistView(_buf);
  int _writePos = 0;

  _CborWriter([int initialCapacity = 256]) : _buf = Uint8List(initialCapacity);

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

  void writeHeader(int majorType, int arg) {
    if (arg < 0) {
      throw CodableException('Invalid negative CBOR argument: $arg');
    }
    final mtBits = majorType << 5;
    if (arg < 24) {
      _ensureCapacity(1);
      _buf[_writePos++] = mtBits | arg;
      return;
    }
    if (arg <= 255) {
      _ensureCapacity(2);
      _buf[_writePos++] = mtBits | 24;
      _buf[_writePos++] = arg;
      return;
    }
    if (arg <= 0xffff) {
      _ensureCapacity(3);
      _buf[_writePos++] = mtBits | 25;
      _bd.setUint16(_writePos, arg);
      _writePos += 2;
      return;
    }
    if (arg <= 0xffffffff) {
      _ensureCapacity(5);
      _buf[_writePos++] = mtBits | 26;
      _bd.setUint32(_writePos, arg);
      _writePos += 4;
      return;
    }
    _writeUint64Header(mtBits, arg);
  }

  void _writeUint64Header(int mtBits, int arg) {
    final hi = arg ~/ cborTwoPow32;
    if (identical(1.0, 1) && hi > cborJsMaxSafeHi) {
      throw const CodableException(
        'CBOR integer exceeds 53-bit safe integer range on JavaScript',
      );
    }
    _ensureCapacity(9);
    _buf[_writePos++] = mtBits | 27;
    _bd.setUint32(_writePos, hi);
    _bd.setUint32(_writePos + 4, arg.remainder(cborTwoPow32));
    _writePos += 8;
  }

  int reserveByte(int placeholder) {
    _ensureCapacity(1);
    final offset = _writePos++;
    _buf[offset] = placeholder;
    return offset;
  }

  void patchHeader(int headerOffset, int majorType, int count) {
    final mtBits = majorType << 5;
    if (count < 24) {
      _buf[headerOffset] = mtBits | count;
      return;
    }
    final extra = count <= 255 ? 1 : (count <= 0xffff ? 2 : 4);
    _ensureCapacity(extra);
    _buf.setRange(
      headerOffset + 1 + extra,
      _writePos + extra,
      _buf,
      headerOffset + 1,
    );
    _writePos += extra;
    _writeMultiByteHeader(headerOffset, mtBits, count, extra);
  }

  void _writeMultiByteHeader(
    int headerOffset,
    int mtBits,
    int count,
    int extra,
  ) {
    if (extra == 1) {
      _buf[headerOffset] = mtBits | 24;
      _buf[headerOffset + 1] = count;
    } else if (extra == 2) {
      _buf[headerOffset] = mtBits | 25;
      _bd.setUint16(headerOffset + 1, count);
    } else {
      _buf[headerOffset] = mtBits | 26;
      _bd.setUint32(headerOffset + 1, count);
    }
  }

  void writeInt(int value) {
    if (value >= 0) {
      writeHeader(0, value);
    } else {
      writeHeader(1, -1 - value);
    }
  }

  void writeDouble(double value) {
    _ensureCapacity(9);
    _buf[_writePos++] = 0xfb;
    _bd.setFloat64(_writePos, value);
    _writePos += 8;
  }

  void writeBool(bool value) {
    _ensureCapacity(1);
    _buf[_writePos++] = value ? 0xf5 : 0xf4;
  }

  void writeNull() {
    _ensureCapacity(1);
    _buf[_writePos++] = 0xf6;
  }

  void writeBytes(Uint8List value) {
    writeHeader(2, value.length);
    _ensureCapacity(value.length);
    _buf.setRange(_writePos, _writePos + value.length, value);
    _writePos += value.length;
  }

  void writeTextString(String value) {
    final encoded = utf8.encode(value);
    writeHeader(3, encoded.length);
    _ensureCapacity(encoded.length);
    _buf.setRange(_writePos, _writePos + encoded.length, encoded);
    _writePos += encoded.length;
  }

  Uint8List toBytes() => _buf.sublist(0, _writePos);
}

abstract interface class _CborCloseable {
  void close();
}

/// Definite-length RFC 8949 CBOR [Encoder] (`isHumanReadable => false`).
final class CborCodableEncoder implements Encoder {
  final _CborWriter _writer;
  _CborCloseable? _activeContainer;

  @override
  final Map<Object, Object?> userInfo;

  CborCodableEncoder._(this._writer, {this.userInfo = const {}});

  /// Encodes [value] to definite-length RFC 8949 CBOR bytes using [encodable].
  static Uint8List encode<T>(
    T value,
    Encodable<T> encodable, {
    Map<Object, Object?> userInfo = const {},
    int initialCapacity = 256,
  }) {
    if (initialCapacity < 0) {
      throw RangeError.value(initialCapacity, 'initialCapacity');
    }
    final writer = _CborWriter(initialCapacity);
    final encoder = CborCodableEncoder._(writer, userInfo: userInfo);
    encodable.encode(value, encoder);
    encoder._finish();
    return writer.toBytes();
  }

  void _finish() {
    _activeContainer?.close();
    _activeContainer = null;
  }

  @override
  bool get isHumanReadable => false;

  @override
  KeyedEncoder keyed({KeyOptions? options, int? length}) {
    _finish();
    final container = _CborKeyedEncoder(_writer, userInfo, length: length);
    _activeContainer = container;
    return container;
  }

  @override
  UnkeyedEncoder unkeyed({int? length}) {
    _finish();
    final container = _CborUnkeyedEncoder(_writer, userInfo, length: length);
    _activeContainer = container;
    return container;
  }

  @override
  MapEncoder map({int? length}) {
    _finish();
    final container = _CborMapEncoder(_writer, userInfo, length: length);
    _activeContainer = container;
    return container;
  }

  @override
  SingleValueEncoder singleValue() {
    _finish();
    return _CborSingleValueEncoder(this, _writer);
  }
}

final class _CborKeyedEncoder
    with BaseKeyedEncoderMixin
    implements KeyedEncoder, _CborCloseable {
  final _CborWriter _writer;
  final Map<Object, Object?> _userInfo;
  final int? _fixedLength;
  late final int _headerOffset;
  int _count = 0;
  bool _closed = false;
  CborCodableEncoder? _pendingNested;

  _CborKeyedEncoder(this._writer, this._userInfo, {int? length})
    : _fixedLength = length {
    if (length != null) {
      _writer.writeHeader(5, length);
      _headerOffset = -1;
    } else {
      _headerOffset = _writer.reserveByte(0xa0);
    }
  }

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
    if (_fixedLength != null) {
      if (_count != _fixedLength) {
        throw CodableException(
          'CBOR keyed length mismatch: declared $_fixedLength, wrote $_count',
        );
      }
      return;
    }
    _writer.patchHeader(_headerOffset, 5, _count);
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
    final child = CborCodableEncoder._(_writer, userInfo: _userInfo);
    _pendingNested = child;
    return child;
  }
}

final class _CborUnkeyedEncoder
    with BaseUnkeyedEncoderMixin
    implements UnkeyedEncoder, _CborCloseable {
  final _CborWriter _writer;
  final Map<Object, Object?> _userInfo;
  final int? _fixedLength;
  late final int _headerOffset;
  int _count = 0;
  bool _closed = false;
  CborCodableEncoder? _pendingNested;

  _CborUnkeyedEncoder(this._writer, this._userInfo, {int? length})
    : _fixedLength = length {
    if (length != null) {
      _writer.writeHeader(4, length);
      _headerOffset = -1;
    } else {
      _headerOffset = _writer.reserveByte(0x80);
    }
  }

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
    if (_fixedLength != null) {
      if (_count != _fixedLength) {
        throw CodableException(
          'CBOR array length mismatch: declared $_fixedLength, wrote $_count',
        );
      }
      return;
    }
    _writer.patchHeader(_headerOffset, 4, _count);
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
    final child = CborCodableEncoder._(_writer, userInfo: _userInfo);
    _pendingNested = child;
    return child;
  }
}

final class _CborMapEncoder implements MapEncoder, _CborCloseable {
  final _CborWriter _writer;
  final Map<Object, Object?> _userInfo;
  final int? _fixedLength;
  late final int _headerOffset;
  int _count = 0;
  bool _expectingValue = false;
  bool _closed = false;
  CborCodableEncoder? _pendingNested;

  _CborMapEncoder(this._writer, this._userInfo, {int? length})
    : _fixedLength = length {
    if (length != null) {
      _writer.writeHeader(5, length);
      _headerOffset = -1;
    } else {
      _headerOffset = _writer.reserveByte(0xa0);
    }
  }

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
    final child = CborCodableEncoder._(_writer, userInfo: _userInfo);
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
    final child = CborCodableEncoder._(_writer, userInfo: _userInfo);
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
        'Dangling key without value in CBOR MapEncoder',
      );
    }
    if (_fixedLength != null) {
      if (_count != _fixedLength) {
        throw CodableException(
          'CBOR map length mismatch: declared $_fixedLength, wrote $_count',
        );
      }
      return;
    }
    _writer.patchHeader(_headerOffset, 5, _count);
  }
}

final class _CborSingleValueEncoder
    with BaseSingleValueEncoderMixin
    implements SingleValueEncoder {
  final CborCodableEncoder _parent;
  final _CborWriter _writer;

  _CborSingleValueEncoder(this._parent, this._writer);

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
