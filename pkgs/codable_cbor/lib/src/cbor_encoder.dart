// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:typed_data';

import 'package:codable/codable.dart';

import 'cbor_reader.dart';

bool _isLowUtf16Surrogate(int cu) => cu >= 0xDC00 && cu <= 0xDFFF;

void _validateWellFormedCborUtf16(String value) {
  final len = value.length;
  for (var i = 0; i < len; i++) {
    final cu = value.codeUnitAt(i);
    if (cu < 0xD800 || cu > 0xDFFF) continue;
    if (cu <= 0xDBFF &&
        i + 1 < len &&
        _isLowUtf16Surrogate(value.codeUnitAt(i + 1))) {
      i++;
      continue;
    }
    throw CodableException(
      'Invalid unpaired UTF-16 surrogate '
      '(U+${cu.toRadixString(16).toUpperCase()}) in CBOR text string',
      actualValue: value,
    );
  }
}

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
      throw CodableException(
        'Invalid negative CBOR argument: $arg',
        actualValue: arg,
      );
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
      throw CodableException(
        'CBOR integer exceeds 53-bit safe integer range on JavaScript',
        actualValue: arg,
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
    if (count < 0) {
      throw CodableException(
        'Invalid negative CBOR argument: $count',
        actualValue: count,
      );
    }
    final mtBits = majorType << 5;
    if (count < 24) {
      _buf[headerOffset] = mtBits | count;
      return;
    }
    final extra = _headerExtraBytes(count);
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

  int _headerExtraBytes(int count) {
    if (count <= 255) return 1;
    if (count <= 0xffff) return 2;
    if (count <= 0xffffffff) return 4;
    if (identical(1.0, 1) && count ~/ cborTwoPow32 > cborJsMaxSafeHi) {
      throw CodableException(
        'CBOR integer exceeds 53-bit safe integer range on JavaScript',
        actualValue: count,
      );
    }
    return 8;
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
    } else if (extra == 4) {
      _buf[headerOffset] = mtBits | 26;
      _bd.setUint32(headerOffset + 1, count);
    } else {
      _buf[headerOffset] = mtBits | 27;
      _bd.setUint32(headerOffset + 1, count ~/ cborTwoPow32);
      _bd.setUint32(headerOffset + 5, count.remainder(cborTwoPow32));
    }
  }

  void writeInt(int value) {
    if (identical(1.0, 1) &&
        (value < -cborJsMaxSafeInt || value > cborJsMaxSafeInt)) {
      throw CodableException(
        'CBOR integer exceeds 53-bit safe integer range on JavaScript',
        actualValue: value,
      );
    }
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
    _validateWellFormedCborUtf16(value);
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
  final int _depth;
  _CborCloseable? _activeContainer;

  @override
  final Map<Object, Object?> userInfo;

  CborCodableEncoder._(this._writer, this._depth, {this.userInfo = const {}});

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
    final encoder = CborCodableEncoder._(writer, 0, userInfo: userInfo);
    encodable.encode(value, encoder);
    encoder._finish();
    return writer.toBytes();
  }

  void _finish() {
    _activeContainer?.close();
    _activeContainer = null;
  }

  CborCodableEncoder _spawnChild() =>
      CborCodableEncoder._(_writer, _depth + 1, userInfo: userInfo);

  @override
  bool get isHumanReadable => false;

  @override
  KeyedEncoder keyed({KeyOptions? options, int? length}) {
    _finish();
    checkCborDepth(_depth);
    final container = _CborKeyedEncoder(this, _writer, length: length);
    _activeContainer = container;
    return container;
  }

  @override
  UnkeyedEncoder unkeyed({int? length}) {
    _finish();
    checkCborDepth(_depth);
    final container = _CborUnkeyedEncoder(this, _writer, length: length);
    _activeContainer = container;
    return container;
  }

  @override
  MapEncoder map({int? length}) {
    _finish();
    checkCborDepth(_depth);
    final container = _CborMapEncoder(this, _writer, length: length);
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
  final CborCodableEncoder _owner;
  final _CborWriter _writer;
  final int? _fixedLength;
  late final int _headerOffset;
  int _count = 0;
  bool _closed = false;
  int _pendingStartPos = -1;
  CborCodableEncoder? _pendingNested;

  _CborKeyedEncoder(this._owner, this._writer, {int? length})
    : _fixedLength = length {
    if (length != null) {
      _writer.writeHeader(5, length);
      _headerOffset = -1;
    } else {
      _headerOffset = _writer.reserveByte(0xa0);
    }
  }

  void _finishPending() {
    final pending = _pendingNested;
    if (pending == null) return;
    final startPos = _pendingStartPos;
    _pendingNested = null;
    _pendingStartPos = -1;
    pending._finish();
    if (_writer._writePos == startPos) {
      throw const CodableException(
        'CBOR nested encoder completed without writing a value',
      );
    }
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
    _pendingStartPos = _writer._writePos;
    final child = _owner._spawnChild();
    _pendingNested = child;
    return child;
  }
}

final class _CborUnkeyedEncoder
    with BaseUnkeyedEncoderMixin
    implements UnkeyedEncoder, _CborCloseable {
  final CborCodableEncoder _owner;
  final _CborWriter _writer;
  final int? _fixedLength;
  late final int _headerOffset;
  int _count = 0;
  bool _closed = false;
  int _pendingStartPos = -1;
  CborCodableEncoder? _pendingNested;

  _CborUnkeyedEncoder(this._owner, this._writer, {int? length})
    : _fixedLength = length {
    if (length != null) {
      _writer.writeHeader(4, length);
      _headerOffset = -1;
    } else {
      _headerOffset = _writer.reserveByte(0x80);
    }
  }

  void _finishPending() {
    final pending = _pendingNested;
    if (pending == null) return;
    final startPos = _pendingStartPos;
    _pendingNested = null;
    _pendingStartPos = -1;
    pending._finish();
    if (_writer._writePos == startPos) {
      throw const CodableException(
        'CBOR nested encoder completed without writing a value',
      );
    }
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
    _pendingStartPos = _writer._writePos;
    final child = _owner._spawnChild();
    _pendingNested = child;
    return child;
  }
}

final class _CborMapEncoder implements MapEncoder, _CborCloseable {
  final CborCodableEncoder _owner;
  final _CborWriter _writer;
  final int? _fixedLength;
  late final int _headerOffset;
  int _count = 0;
  bool _expectingValue = false;
  bool _closed = false;
  int _pendingStartPos = -1;
  CborCodableEncoder? _pendingNested;

  _CborMapEncoder(this._owner, this._writer, {int? length})
    : _fixedLength = length {
    if (length != null) {
      _writer.writeHeader(5, length);
      _headerOffset = -1;
    } else {
      _headerOffset = _writer.reserveByte(0xa0);
    }
  }

  void _finishPending() {
    final pending = _pendingNested;
    if (pending == null) return;
    final startPos = _pendingStartPos;
    _pendingNested = null;
    _pendingStartPos = -1;
    pending._finish();
    if (_writer._writePos == startPos) {
      throw const CodableException(
        'CBOR MapEncoder entry encoder completed without writing a value',
      );
    }
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
    _pendingStartPos = _writer._writePos;
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
    _pendingStartPos = _writer._writePos;
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
