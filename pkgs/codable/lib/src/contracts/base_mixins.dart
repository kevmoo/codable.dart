// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Reusable base mixins providing default implementations for [Decoder] and
/// [Encoder] container contracts.
library;

import 'dart:convert';
import 'dart:typed_data';

import 'codable.dart';
import 'decoder.dart';
import 'encoder.dart';
import 'exceptions.dart';
import 'static_key.dart';

Uint8List _decodeBase64String(String encoded) {
  try {
    return base64Decode(encoded);
  } on FormatException catch (e) {
    throw CodableException(
      'Invalid base64 string for bytes: ${e.message}',
      underlyingError: e,
    );
  }
}

Uint8List _decodeByteList(UnkeyedDecoder u) {
  final builder = BytesBuilder(copy: false);
  while (u.moveNext()) {
    final b = u.readNum();
    if (b is! int || b < 0 || b > 255) {
      throw CodableException('Expected byte in range 0..255, got $b');
    }
    builder.addByte(b);
  }
  return builder.takeBytes();
}

List<T> _decodeUnkeyedModelList<T>(UnkeyedDecoder u, Decodable<T> decodable) {
  final list = <T>[];
  while (u.moveNext()) {
    list.add(u.decodeElement(decodable));
  }
  return list;
}

List<int> _decodeUnkeyedIntList(UnkeyedDecoder u) {
  final list = <int>[];
  while (u.moveNext()) {
    list.add(u.readInt());
  }
  return list;
}

List<double> _decodeUnkeyedDoubleList(UnkeyedDecoder u) {
  final list = <double>[];
  while (u.moveNext()) {
    list.add(u.readDouble());
  }
  return list;
}

Float64List _decodeUnkeyedFloat64List(UnkeyedDecoder u) {
  final len = u.length;
  if (len != null) {
    final out = Float64List(len);
    var i = 0;
    while (u.moveNext()) {
      out[i++] = u.readDouble();
    }
    return out;
  }
  return Float64List.fromList(_decodeUnkeyedDoubleList(u));
}

List<String> _decodeUnkeyedStringList(UnkeyedDecoder u) {
  final list = <String>[];
  while (u.moveNext()) {
    list.add(u.readString());
  }
  return list;
}

List<bool> _decodeUnkeyedBoolList(UnkeyedDecoder u) {
  final list = <bool>[];
  while (u.moveNext()) {
    list.add(u.readBool());
  }
  return list;
}

/// Default implementations for [KeyedDecoder] container methods.
///
/// Drivers only need to implement core cursor navigation, `peekKind`, `readNull`,
/// non-nullable scalar readers (`readInt`, `readDouble`, `readNum`,
/// `readString`, `readBool`), `skipValue`, and `nestedDecoder`, overriding
/// specialized fast paths (such as `selectKeyIndex` or `readBytes`) as needed.
mixin BaseKeyedDecoderMixin implements KeyedDecoder {
  @override
  String? peekKey() => null;

  @override
  int selectKeyIndex(KeyOptions options) =>
      moveNextKey() ? options.indexOf(nextKey()) : -1;

  @override
  int selectStringIndex(KeyOptions options) => options.indexOf(readString());

  @override
  bool isNextNull() => peekKind() == ValueKind.nullValue;

  @override
  int? readNullableInt() {
    if (isNextNull()) {
      readNull();
      return null;
    }
    return readInt();
  }

  @override
  double? readNullableDouble() {
    if (isNextNull()) {
      readNull();
      return null;
    }
    return readDouble();
  }

  @override
  num? readNullableNum() {
    if (isNextNull()) {
      readNull();
      return null;
    }
    return readNum();
  }

  @override
  String? readNullableString() {
    if (isNextNull()) {
      readNull();
      return null;
    }
    return readString();
  }

  @override
  (int start, int end) readStringSpan() => throw UnsupportedError(
    'UTF-8 byte spans are not supported by this decoder.',
  );

  @override
  (int start, int end)? readNullableStringSpan() {
    if (isNextNull()) {
      readNull();
      return null;
    }
    return readStringSpan();
  }

  @override
  bool? readNullableBool() {
    if (isNextNull()) {
      readNull();
      return null;
    }
    return readBool();
  }

  @override
  Uint8List readBytes() => switch (peekKind()) {
    ValueKind.string => _decodeBase64String(readString()),
    ValueKind.list => _decodeByteList(nestedDecoder().unkeyed()),
    final kind => throw CodableException(
      'Expected base64 string or byte list, got $kind',
    ),
  };

  @override
  Uint8List? readNullableBytes() {
    if (isNextNull()) {
      readNull();
      return null;
    }
    return readBytes();
  }

  @override
  T decodeValue<T>(Decodable<T> decodable) => decodable.decode(nestedDecoder());

  @override
  T? decodeNullableValue<T>(Decodable<T> decodable) {
    if (isNextNull()) {
      readNull();
      return null;
    }
    return decodeValue(decodable);
  }

  @override
  List<T> decodeList<T>(Decodable<T> decodable) =>
      _decodeUnkeyedModelList(nestedDecoder().unkeyed(), decodable);

  @override
  List<T>? decodeNullableList<T>(Decodable<T> decodable) {
    if (isNextNull()) {
      readNull();
      return null;
    }
    return decodeList(decodable);
  }

  @override
  List<int> decodeIntList() => _decodeUnkeyedIntList(nestedDecoder().unkeyed());

  @override
  List<double> decodeDoubleList() =>
      _decodeUnkeyedDoubleList(nestedDecoder().unkeyed());

  @override
  List<String> decodeStringList() =>
      _decodeUnkeyedStringList(nestedDecoder().unkeyed());

  @override
  List<bool> decodeBoolList() =>
      _decodeUnkeyedBoolList(nestedDecoder().unkeyed());

  @override
  Float64List decodeFloat64List() =>
      _decodeUnkeyedFloat64List(nestedDecoder().unkeyed());
}

/// Default implementations for [MappedDecoder] container methods.
///
/// Drivers only need to implement `containsKey`, `peekKind`, non-nullable
/// scalar readers (`readInt`, `readDouble`, `readNum`, `readString`,
/// `readBool`), and `nestedDecoder`.
mixin BaseMappedDecoderMixin implements MappedDecoder {
  bool _isMissingOrNull(String key) => !containsKey(key) || isNull(key);

  @override
  bool isNull(String key) =>
      !containsKey(key) || peekKind(key) == ValueKind.nullValue;

  @override
  int? readNullableInt(String key) =>
      _isMissingOrNull(key) ? null : readInt(key);

  @override
  double? readNullableDouble(String key) =>
      _isMissingOrNull(key) ? null : readDouble(key);

  @override
  num? readNullableNum(String key) =>
      _isMissingOrNull(key) ? null : readNum(key);

  @override
  String? readNullableString(String key) =>
      _isMissingOrNull(key) ? null : readString(key);

  @override
  bool? readNullableBool(String key) =>
      _isMissingOrNull(key) ? null : readBool(key);

  @override
  Uint8List readBytes(String key) =>
      nestedDecoder(key).singleValue().readBytes();

  @override
  Uint8List? readNullableBytes(String key) =>
      _isMissingOrNull(key) ? null : readBytes(key);

  @override
  T decodeKey<T>(String key, Decodable<T> decodable) =>
      decodable.decode(nestedDecoder(key));

  @override
  T? decodeNullableKey<T>(String key, Decodable<T> decodable) =>
      _isMissingOrNull(key) ? null : decodeKey(key, decodable);

  @override
  List<T> decodeListKey<T>(String key, Decodable<T> decodable) =>
      _decodeUnkeyedModelList(nestedDecoder(key).unkeyed(), decodable);

  @override
  List<int> decodeIntList(String key) =>
      _decodeUnkeyedIntList(nestedDecoder(key).unkeyed());

  @override
  List<double> decodeDoubleList(String key) =>
      _decodeUnkeyedDoubleList(nestedDecoder(key).unkeyed());

  @override
  Float64List decodeFloat64List(String key) =>
      _decodeUnkeyedFloat64List(nestedDecoder(key).unkeyed());

  @override
  List<String> decodeStringList(String key) =>
      _decodeUnkeyedStringList(nestedDecoder(key).unkeyed());

  @override
  List<bool> decodeBoolList(String key) =>
      _decodeUnkeyedBoolList(nestedDecoder(key).unkeyed());
}

/// Default implementations for [UnkeyedDecoder] container methods.
///
/// Drivers only need to implement `moveNext`, `peekKind`, `readNull`,
/// `skipElement`, non-nullable scalar readers (`readInt`, `readDouble`,
/// `readNum`, `readString`, `readBool`), and `nestedDecoder`.
mixin BaseUnkeyedDecoderMixin implements UnkeyedDecoder {
  @override
  int? get length => null;

  @override
  bool isNextNull() => peekKind() == ValueKind.nullValue;

  @override
  int? readNullableInt() {
    if (isNextNull()) {
      readNull();
      return null;
    }
    return readInt();
  }

  @override
  double? readNullableDouble() {
    if (isNextNull()) {
      readNull();
      return null;
    }
    return readDouble();
  }

  @override
  num? readNullableNum() {
    if (isNextNull()) {
      readNull();
      return null;
    }
    return readNum();
  }

  @override
  String? readNullableString() {
    if (isNextNull()) {
      readNull();
      return null;
    }
    return readString();
  }

  @override
  (int start, int end) readStringSpan() => throw UnsupportedError(
    'UTF-8 byte spans are not supported by this decoder.',
  );

  @override
  (int start, int end)? readNullableStringSpan() {
    if (isNextNull()) {
      readNull();
      return null;
    }
    return readStringSpan();
  }

  @override
  bool? readNullableBool() {
    if (isNextNull()) {
      readNull();
      return null;
    }
    return readBool();
  }

  @override
  Uint8List readBytes() => switch (peekKind()) {
    ValueKind.string => _decodeBase64String(readString()),
    ValueKind.list => _decodeByteList(nestedDecoder().unkeyed()),
    final kind => throw CodableException(
      'Expected base64 string or byte list, got $kind',
    ),
  };

  @override
  Uint8List? readNullableBytes() {
    if (isNextNull()) {
      readNull();
      return null;
    }
    return readBytes();
  }

  @override
  T decodeElement<T>(Decodable<T> decodable) =>
      decodable.decode(nestedDecoder());

  @override
  T? decodeNullableElement<T>(Decodable<T> decodable) {
    if (isNextNull()) {
      readNull();
      return null;
    }
    return decodeElement(decodable);
  }

  @override
  List<int> decodeIntList() => _decodeUnkeyedIntList(nestedDecoder().unkeyed());

  @override
  List<double> decodeDoubleList() =>
      _decodeUnkeyedDoubleList(nestedDecoder().unkeyed());

  @override
  Float64List decodeFloat64List() =>
      _decodeUnkeyedFloat64List(nestedDecoder().unkeyed());

  @override
  List<String> decodeStringList() =>
      _decodeUnkeyedStringList(nestedDecoder().unkeyed());

  @override
  List<bool> decodeBoolList() =>
      _decodeUnkeyedBoolList(nestedDecoder().unkeyed());
}

/// Default implementations for [SingleValueDecoder] container methods.
///
/// Drivers only need to implement `peekKind`, `readNull`, non-nullable scalar
/// readers (`readInt`, `readDouble`, `readNum`, `readString`, `readBool`), and
/// `nestedDecoder`.
mixin BaseSingleValueDecoderMixin implements SingleValueDecoder {
  @override
  bool isNull() => peekKind() == ValueKind.nullValue;

  @override
  int? readNullableInt() {
    if (isNull()) {
      readNull();
      return null;
    }
    return readInt();
  }

  @override
  double? readNullableDouble() {
    if (isNull()) {
      readNull();
      return null;
    }
    return readDouble();
  }

  @override
  num? readNullableNum() {
    if (isNull()) {
      readNull();
      return null;
    }
    return readNum();
  }

  @override
  String? readNullableString() {
    if (isNull()) {
      readNull();
      return null;
    }
    return readString();
  }

  @override
  (int start, int end) readStringSpan() => throw UnsupportedError(
    'UTF-8 byte spans are not supported by this decoder.',
  );

  @override
  (int start, int end)? readNullableStringSpan() {
    if (isNull()) {
      readNull();
      return null;
    }
    return readStringSpan();
  }

  @override
  bool? readNullableBool() {
    if (isNull()) {
      readNull();
      return null;
    }
    return readBool();
  }

  @override
  Uint8List readBytes() => switch (peekKind()) {
    ValueKind.string => _decodeBase64String(readString()),
    ValueKind.list => _decodeByteList(nestedDecoder().unkeyed()),
    final kind => throw CodableException(
      'Expected base64 string or byte list, got $kind',
    ),
  };

  @override
  Uint8List? readNullableBytes() {
    if (isNull()) {
      readNull();
      return null;
    }
    return readBytes();
  }

  @override
  T decode<T>(Decodable<T> decodable) => decodable.decode(nestedDecoder());

  @override
  T? decodeNullable<T>(Decodable<T> decodable) {
    if (isNull()) {
      readNull();
      return null;
    }
    return decode(decodable);
  }
}

/// Default implementations for [KeyedEncoder] container methods.
///
/// Nullable fields omit the key when `value == null`. Drivers only need to
/// implement `encodeInt`, `encodeDouble`, `encodeString`, `encodeBool`,
/// `encodeNull`, and `nestedEncoder`.
mixin BaseKeyedEncoderMixin implements KeyedEncoder {
  @override
  void encodeNullableInt(String key, int? value) {
    if (value != null) encodeInt(key, value);
  }

  @override
  void encodeNullableDouble(String key, double? value) {
    if (value != null) encodeDouble(key, value);
  }

  @override
  void encodeNullableString(String key, String? value) {
    if (value != null) encodeString(key, value);
  }

  @override
  void encodeNullableBool(String key, bool? value) {
    if (value != null) encodeBool(key, value);
  }

  @override
  void encodeBytes(String key, Uint8List value) =>
      encodeString(key, base64Encode(value));

  @override
  void encodeNullableBytes(String key, Uint8List? value) {
    if (value != null) encodeBytes(key, value);
  }

  @override
  void encodeValue<T>(String key, T value, Encodable<T> encodable) =>
      encodable.encode(value, nestedEncoder(key));

  @override
  void encodeNullableValue<T>(String key, T? value, Encodable<T> encodable) {
    if (value != null) encodeValue(key, value, encodable);
  }

  @override
  void encodeList<T>(String key, Iterable<T> elements, Encodable<T> encodable) {
    final u = nestedEncoder(key).unkeyed(
      length: elements is List
          ? elements.length
          : (elements is Set ? elements.length : null),
    );
    u.encodeList(elements, encodable);
  }

  @override
  void encodeIntList(String key, List<int> values) {
    final u = nestedEncoder(key).unkeyed(length: values.length);
    for (var i = 0; i < values.length; i++) {
      u.encodeInt(values[i]);
    }
  }

  @override
  void encodeDoubleList(String key, List<double> values) {
    final u = nestedEncoder(key).unkeyed(length: values.length);
    for (var i = 0; i < values.length; i++) {
      u.encodeDouble(values[i]);
    }
  }

  @override
  void encodeStringList(String key, List<String> values) {
    final u = nestedEncoder(key).unkeyed(length: values.length);
    for (var i = 0; i < values.length; i++) {
      u.encodeString(values[i]);
    }
  }

  @override
  void encodeBoolList(String key, List<bool> values) {
    final u = nestedEncoder(key).unkeyed(length: values.length);
    for (var i = 0; i < values.length; i++) {
      u.encodeBool(values[i]);
    }
  }
}

/// Default implementations for [UnkeyedEncoder] container methods.
///
/// Nullable elements emit explicit `encodeNull()` tokens when `value == null`.
/// Drivers only need to implement `encodeInt`, `encodeDouble`, `encodeString`,
/// `encodeBool`, `encodeNull`, and `nestedEncoder`.
mixin BaseUnkeyedEncoderMixin implements UnkeyedEncoder {
  @override
  void encodeNullableInt(int? value) =>
      value == null ? encodeNull() : encodeInt(value);

  @override
  void encodeNullableDouble(double? value) =>
      value == null ? encodeNull() : encodeDouble(value);

  @override
  void encodeNullableString(String? value) =>
      value == null ? encodeNull() : encodeString(value);

  @override
  void encodeNullableBool(bool? value) =>
      value == null ? encodeNull() : encodeBool(value);

  @override
  void encodeBytes(Uint8List value) => encodeString(base64Encode(value));

  @override
  void encodeNullableBytes(Uint8List? value) =>
      value == null ? encodeNull() : encodeBytes(value);

  @override
  void encodeElement<T>(T value, Encodable<T> encodable) =>
      encodable.encode(value, nestedEncoder());

  @override
  void encodeNullableElement<T>(T? value, Encodable<T> encodable) =>
      value == null ? encodeNull() : encodeElement(value, encodable);

  @override
  void encodeList<T>(Iterable<T> elements, Encodable<T> encodable) {
    for (final element in elements) {
      encodeElement(element, encodable);
    }
  }
}

/// Default implementations for [SingleValueEncoder] container methods.
///
/// Nullable scalars emit `encodeNull()` when `value == null`. Drivers must
/// implement `encodeInt`, `encodeDouble`, `encodeString`, `encodeBool`,
/// `encodeNull`, and `encode<T>`.
mixin BaseSingleValueEncoderMixin implements SingleValueEncoder {
  @override
  void encodeNullableInt(int? value) =>
      value == null ? encodeNull() : encodeInt(value);

  @override
  void encodeNullableDouble(double? value) =>
      value == null ? encodeNull() : encodeDouble(value);

  @override
  void encodeNullableString(String? value) =>
      value == null ? encodeNull() : encodeString(value);

  @override
  void encodeNullableBool(bool? value) =>
      value == null ? encodeNull() : encodeBool(value);

  @override
  void encodeBytes(Uint8List value) => encodeString(base64Encode(value));

  @override
  void encodeNullableBytes(Uint8List? value) =>
      value == null ? encodeNull() : encodeBytes(value);

  @override
  void encodeNullable<T>(T? value, Encodable<T> encodable) =>
      value == null ? encodeNull() : encode(value, encodable);
}
