/// Encoder and container contracts for serialization.
library;

import 'codable.dart';
import 'static_key.dart';

/// Top-level encoding context providing access to specialized encoding
/// containers.
abstract interface class Encoder {
  /// Extensible context map for passing runtime dependency handles, options, or
  /// flags.
  Map<Object, Object?> get userInfo;

  /// Opens a keyed container for writing object key-value pairs.
  KeyedEncoder keyed({KeyOptions? options});

  /// Opens an unkeyed container for writing sequential elements into an array.
  UnkeyedEncoder unkeyed();

  /// Opens a single-value container for writing a standalone scalar value.
  SingleValueEncoder singleValue();
}

/// Keyed encoder for writing object key-value pairs.
abstract interface class KeyedEncoder {
  /// Encodes a non-nullable integer value for [key].
  void encodeInt(String key, int value);

  /// Encodes a nullable integer value for [key].
  void encodeNullableInt(String key, int? value);

  /// Encodes a non-nullable double value for [key].
  void encodeDouble(String key, double value);

  /// Encodes a nullable double value for [key].
  void encodeNullableDouble(String key, double? value);

  /// Encodes a non-nullable String value for [key].
  void encodeString(String key, String value);

  /// Encodes a nullable String value for [key].
  void encodeNullableString(String key, String? value);

  /// Encodes a non-nullable boolean value for [key].
  void encodeBool(String key, bool value);

  /// Encodes a nullable boolean value for [key].
  void encodeNullableBool(String key, bool? value);

  /// Encodes an explicit null value for [key].
  void encodeNull(String key);

  /// Encodes a nested value [value] for [key] using [encodable].
  void encodeValue<T>(String key, T value, Encodable<T> encodable);

  /// Encodes a nullable nested value [value] for [key] using [encodable].
  void encodeNullableValue<T>(String key, T? value, Encodable<T> encodable);

  /// Encodes an iterable of [elements] for [key] using [encodable].
  void encodeList<T>(String key, Iterable<T> elements, Encodable<T> encodable);

  /// Encodes an integer list for [key].
  void encodeIntList(String key, List<int> values);

  /// Encodes a double list for [key].
  void encodeDoubleList(String key, List<double> values);

  /// Encodes a String list for [key].
  void encodeStringList(String key, List<String> values);

  /// Encodes a bool list for [key].
  void encodeBoolList(String key, List<bool> values);
}

/// Unkeyed encoder for writing sequential elements into an array.
abstract interface class UnkeyedEncoder {
  /// Encodes a non-nullable integer element.
  void encodeInt(int value);

  /// Encodes a nullable integer element.
  void encodeNullableInt(int? value);

  /// Encodes a non-nullable double element.
  void encodeDouble(double value);

  /// Encodes a nullable double element.
  void encodeNullableDouble(double? value);

  /// Encodes a non-nullable String element.
  void encodeString(String value);

  /// Encodes a nullable String element.
  void encodeNullableString(String? value);

  /// Encodes a non-nullable boolean element.
  void encodeBool(bool value);

  /// Encodes a nullable boolean element.
  void encodeNullableBool(bool? value);

  /// Encodes an explicit null element.
  void encodeNull();

  /// Encodes a custom element [value] using [encodable].
  void encodeElement<T>(T value, Encodable<T> encodable);

  /// Encodes a nullable custom element [value] using [encodable].
  void encodeNullableElement<T>(T? value, Encodable<T> encodable);

  /// Encodes a nested list of [elements] using [encodable].
  void encodeList<T>(Iterable<T> elements, Encodable<T> encodable);
}

/// Single-value encoder for writing a standalone scalar value.
abstract interface class SingleValueEncoder {
  /// Encodes a non-nullable integer scalar value.
  void encodeInt(int value);

  /// Encodes a nullable integer scalar value.
  void encodeNullableInt(int? value);

  /// Encodes a non-nullable double scalar value.
  void encodeDouble(double value);

  /// Encodes a nullable double scalar value.
  void encodeNullableDouble(double? value);

  /// Encodes a non-nullable String scalar value.
  void encodeString(String value);

  /// Encodes a nullable String scalar value.
  void encodeNullableString(String? value);

  /// Encodes a non-nullable boolean scalar value.
  void encodeBool(bool value);

  /// Encodes a nullable boolean scalar value.
  void encodeNullableBool(bool? value);

  /// Encodes an explicit null scalar value.
  void encodeNull();

  /// Encodes a custom scalar value [value] using [encodable].
  void encode<T>(T value, Encodable<T> encodable);

  /// Encodes a nullable custom scalar value [value] using [encodable].
  void encodeNullable<T>(T? value, Encodable<T> encodable);
}
