// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:codable/codable.dart';

import 'cbor_reader.dart';

abstract interface class _CborCursor {
  void drain();
}

/// Definite-length RFC 8949 CBOR [Decoder] (`isHumanReadable => false`).
final class CborCodableDecoder implements Decoder {
  final CborReader _reader;
  int? _bufferedMapOffset;
  _CborCursor? _activeCursor;

  @override
  final Map<Object, Object?> userInfo;

  /// Creates a [CborCodableDecoder] streaming over [bytes].
  CborCodableDecoder.fromBytes(Uint8List bytes, {this.userInfo = const {}})
    : _reader = CborReader(bytes);

  CborCodableDecoder._(this._reader, {required this.userInfo});

  /// Decodes [bytes] into [T] using [decodable].
  static T decode<T>(
    Uint8List bytes,
    Decodable<T> decodable, {
    Map<Object, Object?> userInfo = const {},
  }) {
    final decoder = CborCodableDecoder.fromBytes(bytes, userInfo: userInfo);
    final result = decodable.decode(decoder);
    decoder._drainActive();
    return result;
  }

  void _drainActive() {
    _activeCursor?.drain();
    _activeCursor = null;
  }

  void _rewindIfBufferedMap() {
    final saved = _bufferedMapOffset;
    if (saved != null) {
      _reader.offset = saved;
      _bufferedMapOffset = null;
    }
  }

  @override
  bool get isHumanReadable => false;

  @override
  Uint8List? get payload => _reader.bytes;

  @override
  ValueKind peekKind() =>
      _bufferedMapOffset != null ? ValueKind.map : _reader.peekKind();

  @override
  KeyedDecoder keyed({KeyOptions? options}) {
    _drainActive();
    _rewindIfBufferedMap();
    final cursor = _CborKeyedDecoder(_reader, userInfo);
    _activeCursor = cursor;
    return cursor;
  }

  @override
  MappedDecoder mapped() {
    _drainActive();
    final mapStart = _bufferedMapOffset ?? _reader.offset;
    _reader.offset = mapStart;
    final count = _reader.readContainerLength(5);
    final entriesStart = _reader.offset;
    _reader.offset = mapStart;
    _reader.skipItem();
    _bufferedMapOffset = mapStart;
    return _CborMappedDecoder(_reader.bytes, entriesStart, count, userInfo);
  }

  @override
  MapDecoder map() {
    _drainActive();
    _rewindIfBufferedMap();
    final cursor = _CborMapDecoder(_reader, userInfo);
    _activeCursor = cursor;
    return cursor;
  }

  @override
  UnkeyedDecoder unkeyed() {
    _drainActive();
    _rewindIfBufferedMap();
    final cursor = _CborUnkeyedDecoder(_reader, userInfo);
    _activeCursor = cursor;
    return cursor;
  }

  @override
  SingleValueDecoder singleValue() {
    _drainActive();
    _rewindIfBufferedMap();
    return _CborSingleValueDecoder(_reader, userInfo);
  }

  @override
  Float64List? decodeUniformDoubleList(List<List<String>> propertyAliases) =>
      null;
}

mixin _CborValueReaderMixin {
  CborReader get _reader;
  void _prepareValueRead();
  void _completeValueRead();

  ValueKind peekKind() {
    _prepareValueRead();
    return _reader.peekKind();
  }

  void readNull() {
    _prepareValueRead();
    _reader.readNull();
    _completeValueRead();
  }

  int readInt() {
    _prepareValueRead();
    final v = _reader.readInt();
    _completeValueRead();
    return v;
  }

  double readDouble() {
    _prepareValueRead();
    final v = _reader.readDouble();
    _completeValueRead();
    return v;
  }

  num readNum() {
    _prepareValueRead();
    final v = _reader.readNum();
    _completeValueRead();
    return v;
  }

  String readString() {
    _prepareValueRead();
    final v = _reader.readString();
    _completeValueRead();
    return v;
  }

  (int start, int end) readStringSpan() {
    _prepareValueRead();
    final span = _reader.readTextStringSpan();
    _completeValueRead();
    return span;
  }

  bool readBool() {
    _prepareValueRead();
    final v = _reader.readBool();
    _completeValueRead();
    return v;
  }

  Uint8List readBytes() {
    _prepareValueRead();
    final v = _reader.readBytes();
    _completeValueRead();
    return v;
  }
}

final class _CborKeyedDecoder
    with BaseKeyedDecoderMixin, _CborValueReaderMixin
    implements KeyedDecoder, _CborCursor {
  @override
  final CborReader _reader;
  final Map<Object, Object?> _userInfo;

  int _remainingPairs;
  int _phase = 0; // 0 = idle, 1 = atKey, 2 = atValue
  CborCodableDecoder? _pendingChild;

  _CborKeyedDecoder(this._reader, this._userInfo)
    : _remainingPairs = _reader.readContainerLength(5);

  void _finishPendingChild() {
    _pendingChild?._drainActive();
    _pendingChild = null;
  }

  @override
  void drain() {
    _finishPendingChild();
    if (_phase == 1) {
      _reader.skipItem();
      _reader.skipItem();
      _phase = 0;
    } else if (_phase == 2) {
      _reader.skipItem();
      _phase = 0;
    }
    while (_remainingPairs > 0) {
      _remainingPairs--;
      _reader.skipItem();
      _reader.skipItem();
    }
  }

  @override
  bool moveNextKey() {
    _finishPendingChild();
    if (_phase == 1) return true;
    if (_phase == 2) {
      _reader.skipItem();
      _phase = 0;
    }
    if (_remainingPairs <= 0) return false;
    _remainingPairs--;
    _phase = 1;
    return true;
  }

  @override
  String nextKey() {
    if (!moveNextKey()) {
      throw const CodableException('No more keys in CBOR map');
    }
    final key = _reader.readString();
    _phase = 2;
    return key;
  }

  @override
  String? peekKey() {
    if (!moveNextKey()) return null;
    final saved = _reader.offset;
    if ((_reader.peekByte() >>> 5) != 3) return null;
    try {
      return _reader.readString();
    } finally {
      _reader.offset = saved;
    }
  }

  @override
  int selectKeyIndex(KeyOptions options) {
    if (!moveNextKey()) return -1;
    if ((_reader.peekByte() >>> 5) != 3) {
      _reader.skipItem();
      _phase = 2;
      return -1;
    }
    final index = _reader.selectString(options);
    _phase = 2;
    return index;
  }

  @override
  int selectStringIndex(KeyOptions options) {
    _prepareValueRead();
    final idx = _reader.selectString(options);
    _completeValueRead();
    return idx;
  }

  @override
  void _prepareValueRead() {
    _finishPendingChild();
    if (_phase == 1) {
      _reader.skipItem();
      _phase = 2;
    }
    if (_phase != 2) {
      throw const CodableException('CBOR KeyedDecoder not positioned at value');
    }
  }

  @override
  void _completeValueRead() {
    _phase = 0;
  }

  @override
  void skipValue() {
    _prepareValueRead();
    _reader.skipItem();
    _completeValueRead();
  }

  @override
  Decoder nestedDecoder() {
    _prepareValueRead();
    _completeValueRead();
    final child = CborCodableDecoder._(_reader, userInfo: _userInfo);
    _pendingChild = child;
    return child;
  }
}

/// Zero-`Map` random-access [MappedDecoder] scanning definite-length CBOR map
/// slices directly in place.
final class _CborMappedDecoder
    with BaseMappedDecoderMixin
    implements MappedDecoder {
  final Uint8List _bytes;
  final int _entriesStart;
  final int _count;
  final Map<Object, Object?> _userInfo;

  _CborMappedDecoder(
    this._bytes,
    this._entriesStart,
    this._count,
    this._userInfo,
  );

  int _findValueOffset(String key) {
    final target = utf8.encode(key);
    final cursor = CborReader(_bytes, _entriesStart);
    for (var i = 0; i < _count; i++) {
      if ((cursor.peekByte() >>> 5) == 3) {
        final (start, end) = cursor.readTextStringSpan();
        if (end - start == target.length &&
            cborBytesMatch(_bytes, start, target, target.length)) {
          return cursor.offset;
        }
      } else {
        cursor.skipItem();
      }
      cursor.skipItem();
    }
    return -1;
  }

  CborReader _readerAtKey(String key) {
    final offset = _findValueOffset(key);
    if (offset < 0) throw CodableException.missingKey(key);
    return CborReader(_bytes, offset);
  }

  @override
  bool containsKey(String key) => _findValueOffset(key) >= 0;

  @override
  ValueKind peekKind(String key) {
    final offset = _findValueOffset(key);
    if (offset < 0) return ValueKind.nullValue;
    return CborReader(_bytes, offset).peekKind();
  }

  @override
  int readInt(String key) => _readerAtKey(key).readInt();

  @override
  double readDouble(String key) => _readerAtKey(key).readDouble();

  @override
  num readNum(String key) => _readerAtKey(key).readNum();

  @override
  String readString(String key) => _readerAtKey(key).readString();

  @override
  bool readBool(String key) => _readerAtKey(key).readBool();

  @override
  Decoder nestedDecoder(String key) =>
      CborCodableDecoder._(_readerAtKey(key), userInfo: _userInfo);
}

final class _CborMapDecoder implements MapDecoder, _CborCursor {
  final CborReader _reader;
  final Map<Object, Object?> _userInfo;
  @override
  final int length;

  int _remainingEntries;
  int _phase = 0; // 0 = idle, 1 = beforeKey, 2 = inKey, 3 = inValue
  int _itemStartOffset = -1;
  CborCodableDecoder? _pendingChild;

  _CborMapDecoder(this._reader, this._userInfo)
    : length = _reader.readContainerLength(5),
      _remainingEntries = 0 {
    _remainingEntries = length;
  }

  void _finishPendingChild() {
    _pendingChild?._drainActive();
    _pendingChild = null;
  }

  void _advanceUnreadInCurrentEntry() {
    _finishPendingChild();
    if (_phase == 1) {
      _reader.skipItem();
      _reader.skipItem();
    } else if (_phase == 2) {
      if (_reader.offset == _itemStartOffset) _reader.skipItem();
      _reader.skipItem();
    } else if (_phase == 3 && _reader.offset == _itemStartOffset) {
      _reader.skipItem();
    }
    _phase = 0;
  }

  @override
  void drain() {
    _advanceUnreadInCurrentEntry();
    while (_remainingEntries > 0) {
      _remainingEntries--;
      _reader.skipItem();
      _reader.skipItem();
    }
  }

  @override
  bool moveNextEntry() {
    _advanceUnreadInCurrentEntry();
    if (_remainingEntries <= 0) return false;
    _remainingEntries--;
    _phase = 1;
    return true;
  }

  @override
  Decoder keyDecoder() {
    _finishPendingChild();
    if (_phase != 1) {
      throw const CodableException(
        'MapDecoder.keyDecoder() called out of order',
      );
    }
    _phase = 2;
    _itemStartOffset = _reader.offset;
    final child = CborCodableDecoder._(_reader, userInfo: _userInfo);
    _pendingChild = child;
    return child;
  }

  @override
  Decoder valueDecoder() {
    _finishPendingChild();
    if (_phase == 1) {
      _reader.skipItem();
      _phase = 2;
      _itemStartOffset = -1;
    } else if (_phase == 2 && _reader.offset == _itemStartOffset) {
      _reader.skipItem();
    } else if (_phase != 2) {
      throw const CodableException(
        'MapDecoder.valueDecoder() called out of order',
      );
    }
    _phase = 3;
    _itemStartOffset = _reader.offset;
    final child = CborCodableDecoder._(_reader, userInfo: _userInfo);
    _pendingChild = child;
    return child;
  }
}

final class _CborUnkeyedDecoder
    with BaseUnkeyedDecoderMixin, _CborValueReaderMixin
    implements UnkeyedDecoder, _CborCursor {
  @override
  final CborReader _reader;
  final Map<Object, Object?> _userInfo;
  @override
  final int length;

  int _remaining;
  bool _hasActive = false;
  CborCodableDecoder? _pendingChild;

  _CborUnkeyedDecoder(this._reader, this._userInfo)
    : length = _reader.readContainerLength(4),
      _remaining = 0 {
    _remaining = length;
  }

  void _finishPendingChild() {
    _pendingChild?._drainActive();
    _pendingChild = null;
  }

  @override
  void drain() {
    _finishPendingChild();
    if (_hasActive) {
      _reader.skipItem();
      _hasActive = false;
    }
    while (_remaining > 0) {
      _remaining--;
      _reader.skipItem();
    }
  }

  @override
  bool moveNext() {
    _finishPendingChild();
    if (_hasActive) return true;
    if (_remaining <= 0) return false;
    _remaining--;
    _hasActive = true;
    return true;
  }

  @override
  void _prepareValueRead() {
    _finishPendingChild();
    if (!_hasActive && !moveNext()) {
      throw const CodableException('No more elements in CBOR array');
    }
  }

  @override
  void _completeValueRead() {
    _hasActive = false;
  }

  @override
  void skipElement() {
    _prepareValueRead();
    _reader.skipItem();
    _completeValueRead();
  }

  @override
  Decoder nestedDecoder() {
    _prepareValueRead();
    _completeValueRead();
    final child = CborCodableDecoder._(_reader, userInfo: _userInfo);
    _pendingChild = child;
    return child;
  }
}

final class _CborSingleValueDecoder
    with BaseSingleValueDecoderMixin, _CborValueReaderMixin
    implements SingleValueDecoder {
  @override
  final CborReader _reader;
  final Map<Object, Object?> _userInfo;

  _CborSingleValueDecoder(this._reader, this._userInfo);

  @override
  void _prepareValueRead() {}

  @override
  void _completeValueRead() {}

  @override
  Decoder nestedDecoder() => CborCodableDecoder._(_reader, userInfo: _userInfo);
}
