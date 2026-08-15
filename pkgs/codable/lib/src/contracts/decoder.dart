import 'dart:typed_data';

import 'codable.dart';
import 'static_key.dart';

/// Top-level decoding context providing access to specialized decoding containers.
abstract interface class Decoder {
  /// Extensible context map for passing runtime dependency handles, options, or flags.
  Map<Object, Object?> get userInfo;

  /// Opens a streaming sequential keyed container for reading object fields.
  KeyedDecoder keyed({KeyOptions? options});

  /// Opens a random-access mapped container for keyed lookups.
  MappedDecoder mapped();

  /// Opens a sequential unkeyed container for reading list/array elements.
  UnkeyedDecoder unkeyed();

  /// Opens a single-value container for reading standalone scalars.
  SingleValueDecoder singleValue();

  /// Swift-ergonomic alias for [keyed].
  KeyedDecoder container({KeyOptions? options});

  /// Swift-ergonomic alias for [unkeyed].
  UnkeyedDecoder unkeyedContainer();

  /// Swift-ergonomic alias for [singleValue].
  SingleValueDecoder singleValueContainer();
}

/// Sequential streaming decoder matching keys in incoming stream order.
abstract interface class KeyedDecoder {
  /// Returns `true` if more key-value pairs remain in the current object.
  bool hasNextKey();

  /// Returns `true` if more key-value pairs remain in the current object (alias for [hasNextKey]).
  bool hasNext();

  /// Reads and returns the next field key as a String.
  String nextKey();

  /// Peeks at the upcoming field key without consuming it, or `null` if at the end of the object.
  String? peekKey();

  /// Selects the index of the next key from pre-compiled [options], or -1 if unknown.
  int selectKeyIndex(KeyOptions options);

  /// Selects the index of the next key from a list of [keys], or -1 if unknown.
  int selectKey(List<String> keys);

  /// Selects the index of the next string value from pre-compiled [options].
  int selectStringIndex(KeyOptions options);

  /// Skips the upcoming field and its value without allocating memory.
  void skipField();

  /// Skips the upcoming value (alias for [skipField]).
  void skipValue();

  /// Returns `true` if the next value token is null.
  bool isNextNull();

  /// Consumes a null value token from the stream.
  void readNull();

  /// Reads a non-nullable integer value.
  int readInt();

  /// Reads a nullable integer value.
  int? readNullableInt();

  /// Reads a non-nullable double value.
  double readDouble();

  /// Reads a nullable double value.
  double? readNullableDouble();

  /// Reads a non-nullable String value.
  String readString();

  /// Reads a nullable String value.
  String? readNullableString();

  /// Reads a non-nullable boolean value.
  bool readBool();

  /// Reads a nullable boolean value.
  bool? readNullableBool();

  /// Decodes a nested value using [decoder].
  T decodeValue<T>(DecoderCallback<T> decoder);

  /// Decodes a nullable nested value using [decoder].
  T? decodeNullableValue<T>(DecoderCallback<T> decoder);

  /// Decodes a generic list of items using the element [decoder].
  List<T> decodeList<T>(DecoderCallback<T> decoder);

  /// Decodes a nullable generic list of items using the element [decoder].
  List<T>? decodeNullableList<T>(DecoderCallback<T> decoder);

  /// Specialized zero-allocation fast primitive integer list decoder.
  List<int> decodeIntList();

  /// Specialized zero-allocation fast primitive double list decoder.
  List<double> decodeDoubleList();

  /// Specialized zero-allocation fast primitive String list decoder.
  List<String> decodeStringList();

  /// Specialized zero-allocation fast primitive bool list decoder.
  List<bool> decodeBoolList();

  /// Specialized zero-allocation fast unboxed Float64List decoder.
  Float64List decodeFloat64List();
}


/// In-memory or buffered random-access decoder supporting out-of-order lookups.
abstract interface class MappedDecoder {
  /// Returns `true` if [key] is present in the container.
  bool containsKey(String key);

  /// Returns `true` if [key] is present in the container.
  bool containsStaticKey(StaticKey key);

  /// Returns `true` if the value associated with [key] is null.
  bool isNull(String key);

  /// Returns `true` if the value associated with [key] is null.
  bool isNullKey(StaticKey key);

  /// Reads a non-nullable integer value by string [key].
  int readInt(String key);

  /// Reads a non-nullable integer value by [key].
  int readIntKey(StaticKey key);

  /// Reads a nullable integer value by string [key].
  int? readNullableInt(String key);

  /// Reads a nullable integer value by [key].
  int? readNullableIntKey(StaticKey key);

  /// Reads a non-nullable double value by string [key].
  double readDouble(String key);

  /// Reads a non-nullable double value by [key].
  double readDoubleKey(StaticKey key);

  /// Reads a nullable double value by string [key].
  double? readNullableDouble(String key);

  /// Reads a nullable double value by [key].
  double? readNullableDoubleKey(StaticKey key);

  /// Reads a non-nullable String value by string [key].
  String readString(String key);

  /// Reads a non-nullable String value by [key].
  String readStringKey(StaticKey key);

  /// Reads a nullable String value by string [key].
  String? readNullableString(String key);

  /// Reads a nullable String value by [key].
  String? readNullableStringKey(StaticKey key);

  /// Reads a non-nullable boolean value by string [key].
  bool readBool(String key);

  /// Reads a non-nullable boolean value by [key].
  bool readBoolKey(StaticKey key);

  /// Reads a nullable boolean value by string [key].
  bool? readNullableBool(String key);

  /// Reads a nullable boolean value by [key].
  bool? readNullableBoolKey(StaticKey key);

  /// Decodes a value associated with [key] using [decoder].
  T decodeKey<T>(String key, DecoderCallback<T> decoder);

  /// Decodes a value associated with [key] using [decoder].
  T decodeStaticKey<T>(StaticKey key, DecoderCallback<T> decoder);

  /// Decodes a nullable value associated with [key] using [decoder].
  T? decodeNullableKey<T>(String key, DecoderCallback<T> decoder);

  /// Decodes a nullable value associated with [key] using [decoder].
  T? decodeNullableStaticKey<T>(StaticKey key, DecoderCallback<T> decoder);

  /// Decodes a list of values associated with [key] using [decoder].
  List<T> decodeListKey<T>(String key, DecoderCallback<T> decoder);

  /// Decodes a list of values associated with [key] using [decoder].
  List<T> decodeListStaticKey<T>(StaticKey key, DecoderCallback<T> decoder);

  /// Decodes an integer list associated with string [key].
  List<int> decodeIntList(String key);

  /// Decodes an integer list associated with [key].
  List<int> decodeIntListKey(StaticKey key);

  /// Decodes a double list associated with string [key].
  List<double> decodeDoubleList(String key);

  /// Decodes a double list associated with [key].
  List<double> decodeDoubleListKey(StaticKey key);

  /// Decodes a double list associated with string [key] directly as an unboxed [Float64List].
  Float64List decodeFloat64List(String key);

  /// Decodes a double list associated with [key] directly as an unboxed [Float64List].
  Float64List decodeFloat64ListKey(StaticKey key);

  /// Decodes a String list associated with string [key].
  List<String> decodeStringList(String key);

  /// Decodes a String list associated with [key].
  List<String> decodeStringListKey(StaticKey key);

  /// Decodes a bool list associated with string [key].
  List<bool> decodeBoolList(String key);

  /// Decodes a bool list associated with [key].
  List<bool> decodeBoolListKey(StaticKey key);
}

/// Sequential decoder for homogeneous or heterogeneous arrays / lists.
abstract interface class UnkeyedDecoder {
  /// Returns `true` if more elements remain in the sequence.
  bool hasNext();

  /// Returns `true` if the next element in the sequence is null.
  bool isNextNull();

  /// Consumes a null element from the sequence.
  void readNull();

  /// Skips the upcoming element in the sequence.
  void skipElement();

  /// Reads a non-nullable integer element.
  int readInt();

  /// Reads a nullable integer element.
  int? readNullableInt();

  /// Reads a non-nullable double element.
  double readDouble();

  /// Reads a nullable double element.
  double? readNullableDouble();

  /// Reads a non-nullable String element.
  String readString();

  /// Reads a nullable String element.
  String? readNullableString();

  /// Reads a non-nullable boolean element.
  bool readBool();

  /// Reads a nullable boolean element.
  bool? readNullableBool();

  /// Decodes an element using [decoder].
  T decodeElement<T>(DecoderCallback<T> decoder);

  /// Decodes a nullable element using [decoder].
  T? decodeNullableElement<T>(DecoderCallback<T> decoder);

  /// Decodes a nested contiguous list of integers.
  List<int> decodeIntList();

  /// Decodes a nested contiguous list of doubles.
  List<double> decodeDoubleList();

  /// Decodes a nested contiguous list of doubles directly as an unboxed [Float64List].
  Float64List decodeFloat64List();
}

/// Decoder for standalone scalar values or primitive wrappers.
abstract interface class SingleValueDecoder {
  /// Returns `true` if the scalar value is null.
  bool isNull();

  /// Consumes a null scalar value.
  void readNull();

  /// Reads a non-nullable integer value.
  int readInt();

  /// Reads a nullable integer value.
  int? readNullableInt();

  /// Reads a non-nullable double value.
  double readDouble();

  /// Reads a nullable double value.
  double? readNullableDouble();

  /// Reads a non-nullable String value.
  String readString();

  /// Reads a nullable String value.
  String? readNullableString();

  /// Reads a non-nullable boolean value.
  bool readBool();

  /// Reads a nullable boolean value.
  bool? readNullableBool();

  /// Decodes a single value using [decoder].
  T decode<T>(DecoderCallback<T> decoder);

  /// Decodes a single nullable value using [decoder].
  T? decodeNullable<T>(DecoderCallback<T> decoder);
}
