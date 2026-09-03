// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:typed_data';

/// Pre-compiled key lookup options for fast-path UTF-8 property matching.
///
/// Enables matching raw UTF-8 byte spans against expected JSON field names
/// without intermediate Dart `String` allocations.
final class JsonKeyOptions {
  /// The list of original string keys.
  final List<String> keys;

  final Map<String, int> _indexMap;
  final int _minLen;
  final int _maxLen;

  // Single-key fast path
  final Uint8List? _singleKey;
  final int _singleKeyIndex;
  final int _singleFirstByte;
  final int _singleLastByte;

  // Unified O(1) hash table backed by parallel typed arrays.
  // All tables are indexed directly by `slot` to eliminate double indirection.
  final Uint8List _encodedKeys;
  final Int32List _tableOffsets;
  final Int32List _tableLengths;
  final Uint8List _tableFirstBytes;
  final Uint8List _tableLastBytes;
  final Int32List _tableKeyIndices;
  final int _hashMask;

  JsonKeyOptions._(
    this.keys,
    this._indexMap,
    this._minLen,
    this._maxLen,
    this._singleKey,
    this._singleKeyIndex,
    this._singleFirstByte,
    this._singleLastByte,
    this._encodedKeys,
    this._tableOffsets,
    this._tableLengths,
    this._tableFirstBytes,
    this._tableLastBytes,
    this._tableKeyIndices,
    this._hashMask,
  );

  /// Creates a [JsonKeyOptions] lookup table from the given [keys].
  ///
  /// Throws [ArgumentError] if [keys] is empty.
  factory JsonKeyOptions.of(List<String> keys) {
    if (keys.isEmpty) {
      throw ArgumentError.value(keys, 'keys', 'Must not be empty');
    }

    final utf8Keys = List<Uint8List>.generate(
      keys.length,
      (i) => Uint8List.fromList(utf8.encode(keys[i])),
      growable: false,
    );

    final indexMap = <String, int>{};
    for (var i = 0; i < keys.length; i++) {
      indexMap.putIfAbsent(keys[i], () => i);
    }

    var minLen = utf8Keys[0].length;
    var maxLen = utf8Keys[0].length;
    for (var i = 1; i < utf8Keys.length; i++) {
      final len = utf8Keys[i].length;
      if (len < minLen) minLen = len;
      if (len > maxLen) maxLen = len;
    }

    // Filter duplicates preserving the first occurrence index.
    final seen = <String>{};
    final uniqueIndices = <int>[];
    for (var i = 0; i < keys.length; i++) {
      if (seen.add(keys[i])) {
        uniqueIndices.add(i);
      }
    }

    if (uniqueIndices.length == 1) {
      final firstIdx = uniqueIndices[0];
      final keyBytes = utf8Keys[firstIdx];
      return JsonKeyOptions._(
        List.unmodifiable(keys),
        indexMap,
        minLen,
        maxLen,
        keyBytes,
        firstIdx,
        keyBytes.isEmpty ? 0 : keyBytes[0],
        keyBytes.isEmpty ? 0 : keyBytes[keyBytes.length - 1],
        Uint8List(0),
        Int32List(0),
        Int32List(0),
        Uint8List(0),
        Uint8List(0),
        Int32List(0),
        0,
      );
    }

    final count = uniqueIndices.length;
    var totalBytes = 0;
    for (var i = 0; i < count; i++) {
      totalBytes += utf8Keys[uniqueIndices[i]].length;
    }

    final encodedKeys = Uint8List(totalBytes);
    final offsets = Int32List(count);
    var currentOffset = 0;
    for (var i = 0; i < count; i++) {
      final bytes = utf8Keys[uniqueIndices[i]];
      offsets[i] = currentOffset;
      encodedKeys.setRange(currentOffset, currentOffset + bytes.length, bytes);
      currentOffset += bytes.length;
    }

    // Table capacity: power of two with load factor <= 0.25 to ensure ~1 probe.
    var cap = 16;
    while (cap < count * 4) {
      cap <<= 1;
    }
    final mask = cap - 1;
    final tableKeyIndices = Int32List(cap)..fillRange(0, cap, -1);
    final tableLengths = Int32List(cap);
    final tableOffsets = Int32List(cap);
    final tableFirstBytes = Uint8List(cap);
    final tableLastBytes = Uint8List(cap);

    for (var i = 0; i < count; i++) {
      final origIdx = uniqueIndices[i];
      final bytes = utf8Keys[origIdx];
      final len = bytes.length;
      final off = offsets[i];
      final h = _fastHash(encodedKeys, off, off + len, len);
      var slot = h & mask;
      while (tableKeyIndices[slot] != -1) {
        slot = (slot + 1) & mask;
      }
      tableKeyIndices[slot] = origIdx;
      tableLengths[slot] = len;
      tableOffsets[slot] = off;
      tableFirstBytes[slot] = len > 0 ? bytes[0] : 0;
      tableLastBytes[slot] = len > 0 ? bytes[len - 1] : 0;
    }

    return JsonKeyOptions._(
      List.unmodifiable(keys),
      indexMap,
      minLen,
      maxLen,
      null,
      0,
      0,
      0,
      encodedKeys,
      tableOffsets,
      tableLengths,
      tableFirstBytes,
      tableLastBytes,
      tableKeyIndices,
      mask,
    );
  }

  /// The index of [key], or `-1` if not recognized.
  int indexOf(String key) => _indexMap[key] ?? -1;

  /// The number of registered keys in this options table.
  int get length => keys.length;

  /// Matches the byte span `[start, end)` in [source] against the pre-compiled
  /// keys, returning the zero-based index of the matching key, or `-1` if
  /// unmatched.
  @pragma('vm:prefer-inline')
  @pragma('wasm:prefer-inline')
  int selectKey(Uint8List source, int start, int end) {
    if (start < 0 || end > source.length || start > end) {
      return -1;
    }
    final spanLen = end - start;
    if (spanLen < _minLen || spanLen > _maxLen) {
      return -1;
    }

    final singleKey = _singleKey;
    if (singleKey != null) {
      if (spanLen != singleKey.length) return -1;
      if (spanLen == 0) return _singleKeyIndex;
      if (source[start] != _singleFirstByte) return -1;
      if (spanLen > 1 && source[end - 1] != _singleLastByte) return -1;
      for (var j = 1; j < spanLen - 1; j++) {
        if (source[start + j] != singleKey[j]) return -1;
      }
      return _singleKeyIndex;
    }

    final h = _fastHash(source, start, end, spanLen);
    final mask = _hashMask;
    var slot = h & mask;
    final firstByte = spanLen > 0 ? source[start] : 0;
    final lastByte = spanLen > 0 ? source[end - 1] : 0;

    final keyIndices = _tableKeyIndices;
    final lengths = _tableLengths;
    final firstBytes = _tableFirstBytes;
    final lastBytes = _tableLastBytes;
    final offsets = _tableOffsets;
    final encodedKeys = _encodedKeys;

    while (true) {
      final keyIdx = keyIndices[slot];
      if (keyIdx == -1) return -1;
      if (lengths[slot] == spanLen &&
          firstBytes[slot] == firstByte &&
          lastBytes[slot] == lastByte) {
        final off = offsets[slot];
        var match = true;
        for (var j = 1; j < spanLen - 1; j++) {
          if (source[start + j] != encodedKeys[off + j]) {
            match = false;
            break;
          }
        }
        if (match) return keyIdx;
      }
      slot = (slot + 1) & mask;
    }
  }

  @pragma('vm:prefer-inline')
  @pragma('wasm:prefer-inline')
  static int _fastHash(Uint8List source, int start, int end, int len) {
    if (len <= 4) {
      var h = len;
      for (var i = start; i < end; i++) {
        h = (h * 31) ^ source[i];
      }
      return h;
    }
    return len ^
        (source[start] << 24) ^
        (source[start + 1] << 16) ^
        (source[start + (len >> 1)] << 8) ^
        source[end - 1];
  }
}
