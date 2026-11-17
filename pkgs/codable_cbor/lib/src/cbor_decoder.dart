// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:typed_data';

import 'package:codable/codable_driver.dart';

import 'cbor_reader.dart';

abstract interface class _CborCursor {
  void drain();
}

final class _CborFixedPathNode extends CborPathNode {
  final Object _segment;

  _CborFixedPathNode(super.parent, this._segment);

  @override
  void appendSegment(List<Object> out) {
    out.add(_segment);
  }
}

Object _decodeLazyCborScalarOrFallback(
  Uint8List bytes,
  int offset,
  Object fallback,
) {
  if (offset < 0 || offset >= bytes.length) return fallback;
  try {
    final probe = CborReader(bytes, offset);
    final ib = probe.peekByte();
    final mt = ib >>> 5;
    if (mt == 3) return probe.readString();
    if (mt == 0 || mt == 1) return probe.readInt();
    if (mt == 7) {
      final ai = ib & 0x1f;
      if (ai == 20 || ai == 21) return probe.readBool();
      if (ai == 25 || ai == 26 || ai == 27) return probe.readDouble();
    }
  } on Object {
    return fallback;
  }
  return fallback;
}

/// Definite-length RFC 8949 CBOR [Decoder] (`isHumanReadable => false`).
final class CborCodableDecoder implements Decoder {
  final CborReader _reader;
  final int _depth;
  final CborPathState _pathState;
  final CborPathNode? _parentNode;
  int? _bufferedMapOffset;
  _CborCursor? _activeCursor;

  @override
  final Map<Object, Object?> userInfo;

  /// Creates a [CborCodableDecoder] streaming over [bytes].
  factory CborCodableDecoder.fromBytes(
    Uint8List bytes, {
    Map<Object, Object?> userInfo = const {},
  }) {
    final state = CborPathState();
    return CborCodableDecoder._(
      CborReader(bytes, 0, state),
      0,
      state,
      null,
      userInfo: userInfo,
    );
  }

  CborCodableDecoder._(
    this._reader,
    this._depth,
    this._pathState,
    this._parentNode, {
    required this.userInfo,
  });

  /// Decodes [bytes] into [T] using [decodable].
  static T decode<T>(
    Uint8List bytes,
    Decodable<T> decodable, {
    Map<Object, Object?> userInfo = const {},
  }) {
    final decoder = CborCodableDecoder.fromBytes(bytes, userInfo: userInfo);
    final state = decoder._pathState;
    try {
      final result = decodable.decode(decoder);
      decoder._drainActive();
      return result;
    } on CodableException catch (e) {
      final enriched = enrichCodableException(
        e,
        alreadyAttributed: state.attributedError,
        containerPath: state.buildContainerPath,
        leafPath: state.buildLeafPath,
      );
      if (identical(enriched, e)) rethrow;
      throw enriched;
    }
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

  void _activateThisDecoderContext() {
    _pathState.clearMapped();
    final p = _parentNode;
    if (p != null) p.inChild = true;
    _pathState.activeNode = p;
  }

  @override
  bool get isHumanReadable => false;

  @override
  Uint8List? get payload => _reader.bytes;

  @override
  ValueKind peekKind() {
    if (_bufferedMapOffset != null) return ValueKind.map;
    _activateThisDecoderContext();
    return _reader.peekKind();
  }

  @override
  KeyedDecoder keyed({KeyOptions? options}) {
    _drainActive();
    _rewindIfBufferedMap();
    _activateThisDecoderContext();
    checkCborDepth(_depth, _pathState);
    final cursor = _CborKeyedDecoder(
      _reader,
      userInfo,
      _depth + 1,
      _pathState,
      _parentNode,
    );
    _activeCursor = cursor;
    return cursor;
  }

  @override
  MappedDecoder mapped() {
    _drainActive();
    _activateThisDecoderContext();
    checkCborDepth(_depth, _pathState);
    final mapStart = _bufferedMapOffset ?? _reader.offset;
    _reader.offset = mapStart;
    final count = _reader.readContainerLength(5);
    final entriesStart = _reader.offset;
    _reader.offset = mapStart;
    _reader.skipItem(_depth);
    _bufferedMapOffset = mapStart;
    final basePath = _pathState.buildNodePath(_parentNode);
    _pathState.enterMappedContainer(basePath);
    return _CborMappedDecoder(
      _reader.bytes,
      entriesStart,
      count,
      userInfo,
      _depth + 1,
      _pathState,
      _parentNode,
      basePath,
    );
  }

  @override
  MapDecoder map() {
    _drainActive();
    _rewindIfBufferedMap();
    _activateThisDecoderContext();
    checkCborDepth(_depth, _pathState);
    final cursor = _CborMapDecoder(
      _reader,
      userInfo,
      _depth + 1,
      _pathState,
      _parentNode,
    );
    _activeCursor = cursor;
    return cursor;
  }

  @override
  UnkeyedDecoder unkeyed() {
    _drainActive();
    _rewindIfBufferedMap();
    _activateThisDecoderContext();
    checkCborDepth(_depth, _pathState);
    final cursor = _CborUnkeyedDecoder(
      _reader,
      userInfo,
      _depth + 1,
      _pathState,
      _parentNode,
    );
    _activeCursor = cursor;
    return cursor;
  }

  @override
  SingleValueDecoder singleValue() {
    _drainActive();
    _rewindIfBufferedMap();
    _activateThisDecoderContext();
    return _CborSingleValueDecoder(this);
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

final class _CborKeyedDecoder extends CborPathNode
    with BaseKeyedDecoderMixin, _CborValueReaderMixin
    implements KeyedDecoder, _CborCursor {
  @override
  final CborReader _reader;
  final Map<Object, Object?> _userInfo;
  final int _childDepth;
  final CborPathState _pathState;

  int _remainingPairs;
  int _phase = 0; // 0 = idle, 1 = atKey, 2 = atValue
  int _keyOffset = -1;
  String? _decodedKey;
  bool _hasKey = false;
  int _itemStartOffset = -1;
  CborCodableDecoder? _pendingChild;

  _CborKeyedDecoder(
    this._reader,
    this._userInfo,
    this._childDepth,
    this._pathState,
    super.parent,
  ) : _remainingPairs = _reader.readContainerLength(5) {
    _pathState.activeNode = this;
  }

  @override
  void appendSegment(List<Object> out) {
    if (!_hasKey) return;
    out.add(
      _decodedKey ??
          _decodeLazyCborScalarOrFallback(_reader.bytes, _keyOffset, '?'),
    );
  }

  void _finishPendingChild() {
    final child = _pendingChild;
    if (child == null) return;
    _pendingChild = null;
    child._drainActive();
    if (_reader.offset == _itemStartOffset) {
      _reader.skipItem(_childDepth);
    }
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
    ended = true;
    _hasKey = false;
    _decodedKey = null;
    inChild = false;
    _pathState.activeNode = parent;
  }

  @override
  bool moveNextKey() {
    _finishPendingChild();
    _pathState.clearMapped();
    if (_phase == 1) return true;
    if (_phase == 2) {
      _reader.skipItem(_childDepth);
      _phase = 0;
    }
    if (_remainingPairs <= 0) {
      ended = true;
      _hasKey = false;
      _decodedKey = null;
      inChild = false;
      _pathState.activeNode = parent;
      return false;
    }
    _remainingPairs--;
    _keyOffset = _reader.offset;
    _decodedKey = null;
    _hasKey = true;
    inChild = false;
    _phase = 1;
    _pathState.activeNode = this;
    return true;
  }

  @override
  String nextKey() {
    if (!moveNextKey()) {
      _hasKey = false;
      _pathState.activeNode = this;
      _reader.fail('No more keys in CBOR map');
    }
    _hasKey = false;
    final key = _reader.readString();
    _decodedKey = key;
    _hasKey = true;
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
      _hasKey = false;
      _reader.skipItem(_childDepth);
      _hasKey = true;
      _phase = 2;
      return -1;
    }
    _hasKey = false;
    final index = _reader.selectString(options);
    if (index >= 0) _decodedKey = options[index];
    _hasKey = true;
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
    _pathState.clearMapped();
    inChild = false;
    _pathState.activeNode = this;
    if (_phase == 1) {
      _reader.skipItem(_childDepth);
      _phase = 2;
    }
    if (_phase != 2) {
      _hasKey = false;
      _reader.fail('CBOR KeyedDecoder not positioned at value');
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
    inChild = true;
    _pathState.activeNode = this;
    _itemStartOffset = _reader.offset;
    final child = CborCodableDecoder._(
      _reader,
      _childDepth,
      _pathState,
      this,
      userInfo: _userInfo,
    );
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
  final int _childDepth;
  final CborPathState _pathState;
  final CborPathNode? _ownerNode;
  final List<Object> _parentPath;

  _CborMappedDecoder(
    this._bytes,
    this._entriesStart,
    this._count,
    this._userInfo,
    this._childDepth,
    this._pathState,
    this._ownerNode,
    this._parentPath,
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
        cursor.skipItem(_childDepth);
      }
      cursor.skipItem(_childDepth);
    }
    return -1;
  }

  CborReader _readerAtKey(String key) {
    final offset = _findValueOffset(key);
    if (offset < 0) {
      _pathState.enterMappedContainer(_parentPath);
      final ex = CodableException.missingKey(key, path: _parentPath);
      _pathState.attributedError = ex;
      throw ex;
    }
    _pathState.enterMappedLeaf(_parentPath, key);
    return CborReader(_bytes, offset, _pathState);
  }

  @override
  bool containsKey(String key) {
    final present = _findValueOffset(key) >= 0;
    if (present) {
      _pathState.enterMappedLeaf(_parentPath, key);
    } else {
      _pathState.enterMappedContainer(_parentPath);
    }
    return present;
  }

  @override
  ValueKind peekKind(String key) {
    final offset = _findValueOffset(key);
    if (offset < 0) {
      _pathState.enterMappedContainer(_parentPath);
      return ValueKind.nullValue;
    }
    _pathState.enterMappedLeaf(_parentPath, key);
    return CborReader(_bytes, offset, _pathState).peekKind();
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
  Decoder nestedDecoder(String key) {
    final r = _readerAtKey(key);
    final keyNode = _CborFixedPathNode(_ownerNode, key)..inChild = true;
    _pathState.clearMapped();
    _pathState.activeNode = keyNode;
    return CborCodableDecoder._(
      r,
      _childDepth,
      _pathState,
      keyNode,
      userInfo: _userInfo,
    );
  }
}

final class _CborMapDecoder extends CborPathNode
    implements MapDecoder, _CborCursor {
  final CborReader _reader;
  final Map<Object, Object?> _userInfo;
  final int _childDepth;
  final CborPathState _pathState;
  @override
  final int length;

  int _remainingEntries;
  int _phase = 0; // 0 = idle, 1 = beforeKey, 2 = inKey, 3 = inValue
  int _keyOffset = -1;
  int _entryIndex = -1;
  bool _hasEntry = false;
  int _itemStartOffset = -1;
  CborCodableDecoder? _pendingChild;

  _CborMapDecoder(
    this._reader,
    this._userInfo,
    this._childDepth,
    this._pathState,
    super.parent,
  ) : length = _reader.readContainerLength(5),
      _remainingEntries = 0 {
    _remainingEntries = length;
    _pathState.activeNode = this;
  }

  @override
  void appendSegment(List<Object> out) {
    if (!_hasEntry) return;
    out.add(
      _decodeLazyCborScalarOrFallback(_reader.bytes, _keyOffset, _entryIndex),
    );
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
    ended = true;
    _hasEntry = false;
    inChild = false;
    _pathState.activeNode = parent;
  }

  @override
  bool moveNextEntry() {
    _advanceUnreadInCurrentEntry();
    _pathState.clearMapped();
    if (_remainingEntries <= 0) {
      ended = true;
      _hasEntry = false;
      inChild = false;
      _pathState.activeNode = parent;
      return false;
    }
    _entryIndex = length - _remainingEntries;
    _remainingEntries--;
    _keyOffset = _reader.offset;
    _hasEntry = true;
    inChild = false;
    _phase = 1;
    _pathState.activeNode = this;
    return true;
  }

  @override
  Decoder keyDecoder() {
    _finishPendingChild();
    _pathState.clearMapped();
    if (_phase != 1) {
      _hasEntry = false;
      _pathState.activeNode = this;
      _reader.fail('MapDecoder.keyDecoder() called out of order');
    }
    _phase = 2;
    inChild = false;
    _pathState.activeNode = this;
    _itemStartOffset = _reader.offset;
    final child = CborCodableDecoder._(
      _reader,
      _childDepth,
      _pathState,
      this,
      userInfo: _userInfo,
    );
    _pendingChild = child;
    return child;
  }

  @override
  Decoder valueDecoder() {
    _finishPendingChild();
    _pathState.clearMapped();
    if (_phase == 1) {
      _reader.skipItem(_childDepth);
      _phase = 2;
      _itemStartOffset = -1;
    } else if (_phase == 2 && _reader.offset == _itemStartOffset) {
      _reader.skipItem(_childDepth);
    } else if (_phase != 2) {
      _hasEntry = false;
      _pathState.activeNode = this;
      _reader.fail('MapDecoder.valueDecoder() called out of order');
    }
    _phase = 3;
    inChild = true;
    _pathState.activeNode = this;
    _itemStartOffset = _reader.offset;
    final child = CborCodableDecoder._(
      _reader,
      _childDepth,
      _pathState,
      this,
      userInfo: _userInfo,
    );
    _pendingChild = child;
    return child;
  }
}

final class _CborUnkeyedDecoder extends CborPathNode
    with BaseUnkeyedDecoderMixin, _CborValueReaderMixin
    implements UnkeyedDecoder, _CborCursor {
  @override
  final CborReader _reader;
  final Map<Object, Object?> _userInfo;
  final int _childDepth;
  final CborPathState _pathState;
  @override
  final int length;

  int _remaining;
  int _activeIndex = -1;
  bool _hasActive = false;
  int _itemStartOffset = -1;
  CborCodableDecoder? _pendingChild;

  _CborUnkeyedDecoder(
    this._reader,
    this._userInfo,
    this._childDepth,
    this._pathState,
    super.parent,
  ) : length = _reader.readContainerLength(4),
      _remaining = 0 {
    _remaining = length;
    _pathState.activeNode = this;
  }

  @override
  void appendSegment(List<Object> out) {
    if (_activeIndex >= 0) out.add(_activeIndex);
  }

  void _finishPendingChild() {
    final child = _pendingChild;
    if (child == null) return;
    _pendingChild = null;
    child._drainActive();
    if (_reader.offset == _itemStartOffset) {
      _reader.skipItem(_childDepth);
    }
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
    ended = true;
    _activeIndex = -1;
    inChild = false;
    _pathState.activeNode = parent;
  }

  @override
  bool moveNext() {
    _finishPendingChild();
    _pathState.clearMapped();
    if (_hasActive) return true;
    if (_remaining <= 0) {
      ended = true;
      _activeIndex = -1;
      inChild = false;
      _pathState.activeNode = parent;
      return false;
    }
    _activeIndex = length - _remaining;
    _remaining--;
    _hasActive = true;
    inChild = false;
    _pathState.activeNode = this;
    return true;
  }

  @override
  void _prepareValueRead() {
    _finishPendingChild();
    _pathState.clearMapped();
    if (!_hasActive && !moveNext()) {
      _activeIndex = -1;
      _pathState.activeNode = this;
      _reader.fail('No more elements in CBOR array');
    }
    inChild = false;
    _pathState.activeNode = this;
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
    inChild = true;
    _pathState.activeNode = this;
    _itemStartOffset = _reader.offset;
    final child = CborCodableDecoder._(
      _reader,
      _childDepth,
      _pathState,
      this,
      userInfo: _userInfo,
    );
    _pendingChild = child;
    return child;
  }
}

final class _CborSingleValueDecoder
    with BaseSingleValueDecoderMixin, _CborValueReaderMixin
    implements SingleValueDecoder {
  final CborCodableDecoder _parent;

  _CborSingleValueDecoder(this._parent);

  @override
  CborReader get _reader => _parent._reader;

  @override
  void _prepareValueRead() {
    _parent._activateThisDecoderContext();
  }

  @override
  void _completeValueRead() {}

  @override
  Decoder nestedDecoder() => _parent;
}
