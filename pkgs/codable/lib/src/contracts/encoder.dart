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

  /// Swift-ergonomic alias for [keyed].
  KeyedEncoder container({KeyOptions? options});

  /// Swift-ergonomic alias for [unkeyed].
  UnkeyedEncoder unkeyedContainer();

  /// Swift-ergonomic alias for [singleValue].
  SingleValueEncoder singleValueContainer();
}

/// Keyed encoder for writing object key-value pairs.
abstract interface class KeyedEncoder {
  /// Encodes a non-nullable integer value for string [key].
  void encodeInt(String key, int value);

  /// Encodes a non-nullable integer value for [key].
  void encodeIntKey(StaticKey key, int value);

  /// Encodes a nullable integer value for string [key].
  void encodeNullableInt(String key, int? value);

  /// Encodes a nullable integer value for [key].
  void encodeNullableIntKey(StaticKey key, int? value);

  /// Encodes a non-nullable double value for string [key].
  void encodeDouble(String key, double value);

  /// Encodes a non-nullable double value for [key].
  void encodeDoubleKey(StaticKey key, double value);

  /// Encodes a nullable double value for string [key].
  void encodeNullableDouble(String key, double? value);

  /// Encodes a nullable double value for [key].
  void encodeNullableDoubleKey(StaticKey key, double? value);

  /// Encodes a non-nullable String value for string [key].
  void encodeString(String key, String value);

  /// Encodes a non-nullable String value for [key].
  void encodeStringKey(StaticKey key, String value);

  /// Encodes a nullable String value for string [key].
  void encodeNullableString(String key, String? value);

  /// Encodes a nullable String value for [key].
  void encodeNullableStringKey(StaticKey key, String? value);

  /// Encodes a non-nullable boolean value for string [key].
  void encodeBool(String key, bool value);

  /// Encodes a non-nullable boolean value for [key].
  void encodeBoolKey(StaticKey key, bool value);

  /// Encodes a nullable boolean value for string [key].
  void encodeNullableBool(String key, bool? value);

  /// Encodes a nullable boolean value for [key].
  void encodeNullableBoolKey(StaticKey key, bool? value);

  /// Encodes an explicit null value for string [key].
  void encodeNull(String key);

  /// Encodes an explicit null value for [key].
  void encodeNullKey(StaticKey key);

  /// Encodes a custom value [value] for string [key] using [encode].
  void encodeValue<T>(String key, T value, EncoderCallback<T> encode);

  /// Encodes a custom value [value] for [key] using [encode].
  void encodeValueKey<T>(StaticKey key, T value, EncoderCallback<T> encode);

  /// Encodes a nullable custom value [value] for string [key] using [encode].
  void encodeNullableValue<T>(String key, T? value, EncoderCallback<T> encode);

  /// Encodes a nullable custom value [value] for [key] using [encode].
  void encodeNullableValueKey<T>(
    StaticKey key,
    T? value,
    EncoderCallback<T> encode,
  );

  /// Encodes an [Encodable] object for string [key].
  void encodeEncodable(String key, Encodable value);

  /// Encodes an [Encodable] object for [key].
  void encodeEncodableKey(StaticKey key, Encodable value);

  /// Encodes a nullable [Encodable] object for string [key].
  void encodeNullableEncodable(String key, Encodable? value);

  /// Encodes a nullable [Encodable] object for [key].
  void encodeNullableEncodableKey(StaticKey key, Encodable? value);

  /// Encodes an iterable of [elements] for string [key] using [encode].
  void encodeList<T>(
    String key,
    Iterable<T> elements,
    EncoderCallback<T> encode,
  );

  /// Encodes an iterable of [elements] for [key] using [encode].
  void encodeListKey<T>(
    StaticKey key,
    Iterable<T> elements,
    EncoderCallback<T> encode,
  );

  /// Encodes an integer list for string [key].
  void encodeIntList(String key, List<int> values);

  /// Encodes an integer list for [key].
  void encodeIntListKey(StaticKey key, List<int> values);

  /// Encodes a double list for string [key].
  void encodeDoubleList(String key, List<double> values);

  /// Encodes a double list for [key].
  void encodeDoubleListKey(StaticKey key, List<double> values);

  /// Encodes a String list for string [key].
  void encodeStringList(String key, List<String> values);

  /// Encodes a String list for [key].
  void encodeStringListKey(StaticKey key, List<String> values);

  /// Encodes a bool list for string [key].
  void encodeBoolList(String key, List<bool> values);

  /// Encodes a bool list for [key].
  void encodeBoolListKey(StaticKey key, List<bool> values);
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

  /// Encodes a custom element [value] using [encode].
  void encodeElement<T>(T value, EncoderCallback<T> encode);

  /// Encodes a nullable custom element [value] using [encode].
  void encodeNullableElement<T>(T? value, EncoderCallback<T> encode);

  /// Encodes an [Encodable] element.
  void encodeEncodable(Encodable value);

  /// Encodes a nullable [Encodable] element.
  void encodeNullableEncodable(Encodable? value);

  /// Encodes a nested list of [elements] using [encode].
  void encodeList<T>(Iterable<T> elements, EncoderCallback<T> encode);
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

  /// Encodes a custom scalar value [value] using [encode].
  void encode<T>(T value, EncoderCallback<T> encode);

  /// Encodes a nullable custom scalar value [value] using [encode].
  void encodeNullable<T>(T? value, EncoderCallback<T> encode);

  /// Encodes an [Encodable] scalar value.
  void encodeEncodable(Encodable value);

  /// Encodes a nullable [Encodable] scalar value.
  void encodeNullableEncodable(Encodable? value);
}
