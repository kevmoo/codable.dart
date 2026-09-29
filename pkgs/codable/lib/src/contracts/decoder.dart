import 'dart:typed_data';

import 'static_key.dart';

/// Top-level decoding context providing access to specialized decoding
/// containers.
abstract interface class Decoder {
  /// Extensible context map for passing runtime dependency handles, options, or
  /// flags.
  Map<Object, Object?> get userInfo;

  /// Exposes the underlying payload byte buffer for zero-allocation span
  /// operations, or `null` if the decoder does not operate over a contiguous
  /// byte buffer.
  Uint8List? get payload;

  /// Opens a streaming sequential keyed container for reading object fields.
  KeyedDecoder keyed({KeyOptions? options});

  /// Opens a random-access mapped container for keyed lookups.
  MappedDecoder mapped();

  /// Opens a sequential unkeyed container for reading list/array elements.
  UnkeyedDecoder unkeyed();

  /// Opens a single-value container for reading standalone scalars.
  SingleValueDecoder singleValue();

  /// Decodes a flat [Float64List] from a uniform array of numeric objects
  /// using [propertyAliases] for each field, or `null` if the underlying
  /// driver does not support vectorized/interop extraction.
  Float64List? decodeUniformDoubleList(List<List<String>> propertyAliases);
}

/// Sequential streaming decoder matching keys in incoming stream order.
abstract interface class KeyedDecoder {
  /// Advances to the next key-value pair in the object, consuming any comma
  /// delimiter.
  bool moveNextKey();

  /// Reads the next field key as a [String].
  String nextKey();

  /// Peeks at the upcoming field key without consuming it, or `null` if at the
  /// end of the object or if the driver does not support lookahead.
  String? peekKey();

  /// Selects the index of the next key from pre-compiled [options], or `-1` if
  /// unknown.
  int selectKeyIndex(KeyOptions options);

  /// Selects the index of the next string value from pre-compiled [options].
  int selectStringIndex(KeyOptions options);

  /// Skips the upcoming value without allocating memory.
  void skipValue();

  /// Whether the next value token is null.
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

  /// Reads a non-nullable String value as a raw UTF-8 byte span `(start, end)`.
  (int start, int end) readStringSpan();

  /// Reads a nullable String value as a raw UTF-8 byte span `(start, end)`, or
  /// `null` if null.
  (int start, int end)? readNullableStringSpan();

  /// Reads a non-nullable boolean value.
  bool readBool();

  /// Reads a nullable boolean value.
  bool? readNullableBool();

  /// Creates a child [Decoder] positioned at the current field value for
  /// direct inlined decoding of nested models without closure allocation.
  Decoder nestedDecoder();

  /// Decodes a nested value using [decoder].
  T decodeValue<T>(T Function(Decoder decoder) decoder);

  /// Decodes a nullable nested value using [decoder].
  T? decodeNullableValue<T>(T Function(Decoder decoder) decoder);

  /// Decodes a generic list of items using the element [decoder].
  List<T> decodeList<T>(T Function(Decoder decoder) decoder);

  /// Decodes a nullable generic list of items using the element [decoder].
  List<T>? decodeNullableList<T>(T Function(Decoder decoder) decoder);

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
  /// Whether [key] is present in the container.
  bool containsKey(String key);

  /// Whether the value associated with [key] is null.
  bool isNull(String key);

  /// Reads a non-nullable integer value by [key].
  int readInt(String key);

  /// Reads a nullable integer value by [key].
  int? readNullableInt(String key);

  /// Reads a non-nullable double value by [key].
  double readDouble(String key);

  /// Reads a nullable double value by [key].
  double? readNullableDouble(String key);

  /// Reads a non-nullable String value by [key].
  String readString(String key);

  /// Reads a nullable String value by [key].
  String? readNullableString(String key);

  /// Reads a non-nullable boolean value by [key].
  bool readBool(String key);

  /// Reads a nullable boolean value by [key].
  bool? readNullableBool(String key);

  /// Creates a child [Decoder] positioned at [key] for direct inlined decoding
  /// of nested models without closure allocation.
  Decoder nestedDecoder(String key);

  /// Decodes a value associated with [key] using [decoder].
  T decodeKey<T>(String key, T Function(Decoder decoder) decoder);

  /// Decodes a nullable value associated with [key] using [decoder].
  T? decodeNullableKey<T>(String key, T Function(Decoder decoder) decoder);

  /// Decodes a list of values associated with [key] using [decoder].
  List<T> decodeListKey<T>(String key, T Function(Decoder decoder) decoder);

  /// Decodes an integer list associated with [key].
  List<int> decodeIntList(String key);

  /// Decodes a double list associated with [key].
  List<double> decodeDoubleList(String key);

  /// Decodes a double list associated with [key] directly as an unboxed
  /// [Float64List].
  Float64List decodeFloat64List(String key);

  /// Decodes a String list associated with [key].
  List<String> decodeStringList(String key);

  /// Decodes a bool list associated with [key].
  List<bool> decodeBoolList(String key);
}

/// Sequential decoder for homogeneous or heterogeneous arrays / lists.
abstract interface class UnkeyedDecoder {
  /// Advances to the next element in the array, consuming any comma delimiter.
  bool moveNext();

  /// Whether the next element in the sequence is null.
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

  /// Reads a non-nullable String element as a raw UTF-8 byte span
  /// `(start, end)`.
  (int start, int end) readStringSpan();

  /// Reads a nullable String element as a raw UTF-8 byte span `(start, end)`,
  /// or `null` if null.
  (int start, int end)? readNullableStringSpan();

  /// Reads a non-nullable boolean element.
  bool readBool();

  /// Reads a nullable boolean element.
  bool? readNullableBool();

  /// Creates a child [Decoder] positioned at the current array element for
  /// direct inlined decoding of nested models without closure allocation.
  Decoder nestedDecoder();

  /// Decodes an element using [decoder].
  T decodeElement<T>(T Function(Decoder decoder) decoder);

  /// Decodes a nullable element using [decoder].
  T? decodeNullableElement<T>(T Function(Decoder decoder) decoder);

  /// Decodes a nested contiguous list of integers.
  List<int> decodeIntList();

  /// Decodes a nested contiguous list of doubles.
  List<double> decodeDoubleList();

  /// Decodes a nested contiguous list of doubles directly as an unboxed
  /// [Float64List].
  Float64List decodeFloat64List();

  /// Decodes a nested contiguous list of Strings.
  List<String> decodeStringList();

  /// Decodes a nested contiguous list of booleans.
  List<bool> decodeBoolList();
}

/// Decoder for standalone scalar values or primitive wrappers.
abstract interface class SingleValueDecoder {
  /// Whether the scalar value is null.
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

  /// Reads a non-nullable String value as a raw UTF-8 byte span `(start, end)`.
  (int start, int end) readStringSpan();

  /// Reads a nullable String value as a raw UTF-8 byte span `(start, end)`, or
  /// `null` if null.
  (int start, int end)? readNullableStringSpan();

  /// Reads a non-nullable boolean value.
  bool readBool();

  /// Reads a nullable boolean value.
  bool? readNullableBool();

  /// Creates a child [Decoder] for direct inlined decoding of nested models
  /// without closure allocation.
  Decoder nestedDecoder();

  /// Decodes a single value using [decoder].
  T decode<T>(T Function(Decoder decoder) decoder);

  /// Decodes a single nullable value using [decoder].
  T? decodeNullable<T>(T Function(Decoder decoder) decoder);
}
