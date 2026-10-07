// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert'
    show ByteConversionSink, ChunkedConversionSink, json, utf8;
import 'dart:typed_data';

import 'package:codable/src/json/substrate/mock/substrate_mock.dart';

void main() => fuzzTarget(Uint8List(0));

/// Coverage-guided fuzz target for `JsonUtf8Codec`, `JsonTokenReader`, and
/// UTF-8 span parsers.
void fuzzTarget(Uint8List bytes) {
  _fuzzDifferentialDecode(bytes);
  _fuzzTokenReader(bytes);
  _fuzzSpanParsers(bytes);
  _fuzzSkipHelpers(bytes);
  _fuzzChunkedDecode(bytes);
}

void _fuzzDifferentialDecode(Uint8List bytes) {
  Object? expected;
  var stdValid = false;
  try {
    expected = utf8.decoder.fuse(json.decoder).convert(bytes);
    stdValid = true;
  } on FormatException {
    stdValid = false;
  }

  Object? actual;
  var codableValid = false;
  try {
    actual = const JsonUtf8Codec().decode(bytes);
    codableValid = true;
  } on FormatException {
    codableValid = false;
  }

  if (stdValid != codableValid) {
    throw StateError(
      'Validity mismatch: std=$stdValid vs codable=$codableValid',
    );
  }
  if (stdValid && !_deepEquals(expected, actual)) {
    throw StateError('Value mismatch: std=$expected vs codable=$actual');
  }
}

void _fuzzTokenReader(Uint8List bytes) {
  try {
    final reader = JsonTokenReader.fromBytes(bytes);
    _consumeValue(reader, 0);
  } on FormatException {
    // Expected on malformed inputs.
  }

  try {
    final skipReader = JsonTokenReader.fromBytes(bytes);
    skipReader.skipValue();
  } on FormatException {
    // Expected on malformed inputs.
  }
}

void _consumeValue(JsonTokenReader reader, int depth) {
  if (depth > 32) {
    reader.skipValue();
    return;
  }
  switch (reader.peek()) {
    case JsonTokenType.beginObject:
      _consumeObject(reader, depth);
    case JsonTokenType.beginArray:
      _consumeArray(reader, depth);
    case JsonTokenType.string:
      reader.readString();
    case JsonTokenType.number:
      reader.readNum();
    case JsonTokenType.boolean:
      reader.readBool();
    case JsonTokenType.nullValue:
      reader.readNull();
    case JsonTokenType.none:
    case JsonTokenType.propertyName:
    case JsonTokenType.endObject:
    case JsonTokenType.endArray:
    case JsonTokenType.endOfDocument:
      reader.skipValue();
  }
}

void _consumeObject(JsonTokenReader reader, int depth) {
  reader.beginObject();
  while (reader.moveNext()) {
    reader.nextName();
    _consumeValue(reader, depth + 1);
  }
  reader.endObject();
}

void _consumeArray(JsonTokenReader reader, int depth) {
  reader.beginArray();
  while (reader.moveNext()) {
    _consumeValue(reader, depth + 1);
  }
  reader.endArray();
}

void _fuzzSpanParsers(Uint8List bytes) {
  final end = bytes.length;
  tryParseIntUtf8(bytes, 0, end);
  tryParseDoubleUtf8(bytes, 0, end);
  tryParseBoolUtf8(bytes, 0, end);
  isNullUtf8(bytes, 0, end);
  try {
    decodeStringUtf8(bytes, 0, end);
  } on FormatException {
    // Expected on invalid UTF-8 or escape sequences.
  }
}

void _fuzzSkipHelpers(Uint8List bytes) {
  final vEnd = JsonUtf8Decoder.skipValue(bytes, 0);
  if (vEnd < 0 || vEnd > bytes.length) {
    throw RangeError.range(vEnd, 0, bytes.length, 'skipValue');
  }
  final sEnd = JsonUtf8Decoder.skipString(bytes, 0);
  if (sEnd < 0 || sEnd > bytes.length) {
    throw RangeError.range(sEnd, 0, bytes.length, 'skipString');
  }
  final wEnd = JsonUtf8Decoder.skipWhitespace(bytes, 0);
  if (wEnd < 0 || wEnd > bytes.length) {
    throw RangeError.range(wEnd, 0, bytes.length, 'skipWhitespace');
  }
}

void _fuzzChunkedDecode(Uint8List bytes) {
  try {
    final results = <Object?>[];
    final ChunkedConversionSink<List<int>> byteSink = const JsonUtf8Codec()
        .decoder
        .startChunkedConversion(_CallbackSink(results.add));
    final split = bytes.length ~/ 2;
    if (byteSink is ByteConversionSink) {
      byteSink
        ..addSlice(bytes, 0, split, false)
        ..addSlice(bytes, split, bytes.length, true);
    } else {
      byteSink
        ..add(bytes.sublist(0, split))
        ..add(bytes.sublist(split))
        ..close();
    }
  } on FormatException {
    // Expected on malformed inputs.
  }
}

bool _deepEquals(Object? a, Object? b) {
  if (identical(a, b)) return true;
  if (a is num && b is num) return _numEquals(a, b);
  if (a is List && b is List) return _listEquals(a, b);
  if (a is Map && b is Map) return _mapEquals(a, b);
  return a == b;
}

bool _numEquals(num a, num b) {
  if (a.isNaN && b.isNaN) return true;
  return a == b;
}

bool _listEquals(List<Object?> a, List<Object?> b) {
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (!_deepEquals(a[i], b[i])) return false;
  }
  return true;
}

bool _mapEquals(Map<Object?, Object?> a, Map<Object?, Object?> b) {
  if (a.length != b.length) return false;
  for (final entry in a.entries) {
    final key = entry.key;
    if (!b.containsKey(key) || !_deepEquals(entry.value, b[key])) {
      return false;
    }
  }
  return true;
}

final class _CallbackSink implements Sink<Object?> {
  _CallbackSink(this._onData);

  final void Function(Object?) _onData;

  @override
  void add(Object? data) => _onData(data);

  @override
  void close() {}
}
