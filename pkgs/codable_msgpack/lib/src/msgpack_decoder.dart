// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:typed_data';

import 'package:codable/codable.dart';

import 'msgpack_reader.dart';

abstract interface class _MsgPackCursor {
  void drain();
}

/// Single-pass MessagePack [Decoder] (`isHumanReadable => false`).
final class MsgPackCodableDecoder implements Decoder {
  final MsgPackReader _reader;
  final int _depth;
  int? _bufferedMapOffset;
  _MsgPackCursor? _activeCursor;

  @override
  final Map<Object, Object?> userInfo;

  /// Creates a [MsgPackCodableDecoder] streaming over [bytes].
  MsgPackCodableDecoder.fromBytes(
    Uint8List bytes, {
    Map<Object, Object?>? userInfo,
  }) : _reader = MsgPackReader(bytes),
       _depth = 0,
       userInfo = userInfo ?? const {};

  MsgPackCodableDecoder._(this._reader, this._depth, {required this.userInfo});

  /// Decodes [bytes] into [T] using [decodable].
  static T decode<T>(
    Uint8List bytes,
    Decodable<T> decodable, {
    Map<Object, Object?>? userInfo,
  }) {
    final decoder = MsgPackCodableDecoder.fromBytes(bytes, userInfo: userInfo);
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
    checkMsgPackDepth(_depth);
    final cursor = _MsgPackKeyedDecoder(_reader, userInfo, _depth + 1);
    _activeCursor = cursor;
    return cursor;
  }

  @override
  MappedDecoder mapped() {
    _drainActive();
    checkMsgPackDepth(_depth);
    final mapStart = _bufferedMapOffset ?? _reader.offset;
    _reader.offset = mapStart;
    final count = _reader.readMapLength();
    final entriesStart = _reader.offset;
    _reader.offset = mapStart;
    _reader.skipItem(_depth);
    _bufferedMapOffset = mapStart;
    return _MsgPackMappedDecoder(
      _reader.bytes,
      entriesStart,
      count,
      userInfo,
      _depth + 1,
    );
  }

  @override
  MapDecoder map() {
    _drainActive();
    _rewindIfBufferedMap();
    checkMsgPackDepth(_depth);
    final cursor = _MsgPackMapDecoder(_reader, userInfo, _depth + 1);
    _activeCursor = cursor;
    return cursor;
  }

  @override
  UnkeyedDecoder unkeyed() {
    _drainActive();
    _rewindIfBufferedMap();
    checkMsgPackDepth(_depth);
    final cursor = _MsgPackUnkeyedDecoder(_reader, userInfo, _depth + 1);
    _activeCursor = cursor;
    return cursor;
  }

  @override
  SingleValueDecoder singleValue() {
    _drainActive();
    _rewindIfBufferedMap();
    return _MsgPackSingleValueDecoder(_reader, userInfo, _depth);
  }

  @override
  Float64List? decodeUniformDoubleList(List<List<String>> propertyAliases) =>
      null;
}

mixin _MsgPackValueReaderMixin {
  MsgPackReader get _reader;
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

final class _MsgPackKeyedDecoder
    with BaseKeyedDecoderMixin, _MsgPackValueReaderMixin
    implements KeyedDecoder, _MsgPackCursor {
  @override
  final MsgPackReader _reader;
  final Map<Object, Object?> _userInfo;
  final int _childDepth;

  int _remainingPairs;
  int _phase = 0; // 0 = idle, 1 = atKey, 2 = atValue
  MsgPackCodableDecoder? _pendingChild;

  _MsgPackKeyedDecoder(this._reader, this._userInfo, this._childDepth)
    : _remainingPairs = _reader.readMapLength();

  void _finishPendingChild() {
    _pendingChild?._drainActive();
    _pendingChild = null;
  }

  @override
  void drain() {
    _finishPendingChild();
    if (_phase == 1) {
      _reader.skipItem(_childDepth);
      _reader.skipItem(_childDepth);
      _phase = 0;
    } else if (_phase == 2) {
      _reader.skipItem(_childDepth);
      _phase = 0;
    }
    while (_remainingPairs > 0) {
      _remainingPairs--;
      _reader.skipItem(_childDepth);
      _reader.skipItem(_childDepth);
    }
  }

  @override
  bool moveNextKey() {
    _finishPendingChild();
    if (_phase == 1) return true;
    if (_phase == 2) {
      _reader.skipItem(_childDepth);
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
      throw const CodableException('No more keys in MessagePack map');
    }
    final key = _reader.readString();
    _phase = 2;
    return key;
  }

  @override
  String? peekKey() {
    if (!moveNextKey()) return null;
    final saved = _reader.offset;
    if (!isMsgPackStringTag(_reader.peekByte())) return null;
    try {
      return _reader.readString();
    } finally {
      _reader.offset = saved;
    }
  }

  @override
  int selectKeyIndex(KeyOptions options) {
    if (!moveNextKey()) return -1;
    if (!isMsgPackStringTag(_reader.peekByte())) {
      _reader.skipItem(_childDepth);
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
      _reader.skipItem(_childDepth);
      _phase = 2;
    }
    if (_phase != 2) {
      throw const CodableException(
        'MessagePack KeyedDecoder not positioned at value',
      );
    }
  }

  @override
  void _completeValueRead() {
    _phase = 0;
  }

  @override
  void skipValue() {
    _prepareValueRead();
    _reader.skipItem(_childDepth);
    _completeValueRead();
  }

  @override
  Decoder nestedDecoder() {
    _prepareValueRead();
    _completeValueRead();
    final child = MsgPackCodableDecoder._(
      _reader,
      _childDepth,
      userInfo: _userInfo,
    );
    _pendingChild = child;
    return child;
  }
}

/// Zero-`Map` random-access [MappedDecoder] scanning MessagePack map slices
/// directly in place.
final class _MsgPackMappedDecoder
    with BaseMappedDecoderMixin
    implements MappedDecoder {
  final Uint8List _bytes;
  final int _entriesStart;
  final int _count;
  final Map<Object, Object?> _userInfo;
  final int _childDepth;

  _MsgPackMappedDecoder(
    this._bytes,
    this._entriesStart,
    this._count,
    this._userInfo,
    this._childDepth,
  );

  int _findValueOffset(String key) {
    final target = utf8.encode(key);
    final cursor = MsgPackReader(_bytes, _entriesStart);
    for (var i = 0; i < _count; i++) {
      if (isMsgPackStringTag(cursor.peekByte())) {
        final (start, end) = cursor.readTextStringSpan();
        if (end - start == target.length &&
            msgPackBytesMatch(_bytes, start, target, target.length)) {
          return cursor.offset;
        }
      } else {
        cursor.skipItem(_childDepth);
      }
      cursor.skipItem(_childDepth);
    }
    return -1;
  }

  MsgPackReader _readerAtKey(String key) {
    final offset = _findValueOffset(key);
    if (offset < 0) throw CodableException.missingKey(key);
    return MsgPackReader(_bytes, offset);
  }

  @override
  bool containsKey(String key) => _findValueOffset(key) >= 0;

  @override
  ValueKind peekKind(String key) {
    final offset = _findValueOffset(key);
    if (offset < 0) return ValueKind.nullValue;
    return MsgPackReader(_bytes, offset).peekKind();
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
  Decoder nestedDecoder(String key) => MsgPackCodableDecoder._(
    _readerAtKey(key),
    _childDepth,
    userInfo: _userInfo,
  );
}

final class _MsgPackMapDecoder implements MapDecoder, _MsgPackCursor {
  final MsgPackReader _reader;
  final Map<Object, Object?> _userInfo;
  final int _childDepth;
  @override
  final int length;

  int _remainingEntries;
  int _phase = 0; // 0 = idle, 1 = beforeKey, 2 = inKey, 3 = inValue
  int _itemStartOffset = -1;
  MsgPackCodableDecoder? _pendingChild;

  _MsgPackMapDecoder(this._reader, this._userInfo, this._childDepth)
    : length = _reader.readMapLength(),
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
      _reader.skipItem(_childDepth);
      _reader.skipItem(_childDepth);
    } else if (_phase == 2) {
      if (_reader.offset == _itemStartOffset) _reader.skipItem(_childDepth);
      _reader.skipItem(_childDepth);
    } else if (_phase == 3 && _reader.offset == _itemStartOffset) {
      _reader.skipItem(_childDepth);
    }
    _phase = 0;
  }

  @override
  void drain() {
    _advanceUnreadInCurrentEntry();
    while (_remainingEntries > 0) {
      _remainingEntries--;
      _reader.skipItem(_childDepth);
      _reader.skipItem(_childDepth);
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
    final child = MsgPackCodableDecoder._(
      _reader,
      _childDepth,
      userInfo: _userInfo,
    );
    _pendingChild = child;
    return child;
  }

  @override
  Decoder valueDecoder() {
    _finishPendingChild();
    if (_phase == 1) {
      _reader.skipItem(_childDepth);
      _phase = 2;
      _itemStartOffset = -1;
    } else if (_phase == 2 && _reader.offset == _itemStartOffset) {
      _reader.skipItem(_childDepth);
    } else if (_phase != 2) {
      throw const CodableException(
        'MapDecoder.valueDecoder() called out of order',
      );
    }
    _phase = 3;
    _itemStartOffset = _reader.offset;
    final child = MsgPackCodableDecoder._(
      _reader,
      _childDepth,
      userInfo: _userInfo,
    );
    _pendingChild = child;
    return child;
  }
}

final class _MsgPackUnkeyedDecoder
    with BaseUnkeyedDecoderMixin, _MsgPackValueReaderMixin
    implements UnkeyedDecoder, _MsgPackCursor {
  @override
  final MsgPackReader _reader;
  final Map<Object, Object?> _userInfo;
  final int _childDepth;
  @override
  final int length;

  int _remaining;
  bool _hasActive = false;
  MsgPackCodableDecoder? _pendingChild;

  _MsgPackUnkeyedDecoder(this._reader, this._userInfo, this._childDepth)
    : length = _reader.readArrayLength(),
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
      _reader.skipItem(_childDepth);
      _hasActive = false;
    }
    while (_remaining > 0) {
      _remaining--;
      _reader.skipItem(_childDepth);
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
      throw const CodableException('No more elements in MessagePack array');
    }
  }

  @override
  void _completeValueRead() {
    _hasActive = false;
  }

  @override
  void skipElement() {
    _prepareValueRead();
    _reader.skipItem(_childDepth);
    _completeValueRead();
  }

  @override
  Decoder nestedDecoder() {
    _prepareValueRead();
    _completeValueRead();
    final child = MsgPackCodableDecoder._(
      _reader,
      _childDepth,
      userInfo: _userInfo,
    );
    _pendingChild = child;
    return child;
  }
}

final class _MsgPackSingleValueDecoder
    with BaseSingleValueDecoderMixin, _MsgPackValueReaderMixin
    implements SingleValueDecoder {
  @override
  final MsgPackReader _reader;
  final Map<Object, Object?> _userInfo;
  final int _depth;

  _MsgPackSingleValueDecoder(this._reader, this._userInfo, this._depth);

  @override
  void _prepareValueRead() {}

  @override
  void _completeValueRead() {}

  @override
  Decoder nestedDecoder() =>
      MsgPackCodableDecoder._(_reader, _depth, userInfo: _userInfo);
}
