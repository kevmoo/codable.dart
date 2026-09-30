# Project: `package:codable` & Streaming JSON Substrate

For user-facing documentation, see:

- [`pkgs/codable/README.md`](pkgs/codable/README.md) — General `Codable` model,
  `JsonCodableDecoder` / `JsonCodableEncoder` usage, and implementing custom
  `Codable<T>`, `Decodable<T>`, and `Encodable<T>` companions.
- [`pkgs/codable_builder/README.md`](pkgs/codable_builder/README.md) —
  `@Codable()` code generation setup and annotation options.

## Architecture

Three-Layer Architecture:

1. **Layer 1: Low-Level JSON Streaming Substrate (`pkgs/codable/lib/src/json/substrate/`)**:
   - Pure standalone Dart implementation of streaming JSON primitives (`mock/`)
     plus conditional native SDK re-exports (`substrate_native.dart`).
   - Imperative pull reader (`JsonTokenReader`), push writer (`JsonTokenWriter`,
     `JsonUtf8TokenWriter`), span parsers (`parseIntUtf8`, `parseDoubleUtf8`,
     `decodeStringUtf8`), key options hash tables (`JsonKeyOptions`), and UTF-8
     codecs (`JsonUtf8Codec`, `jsonUtf8`).
   - Enforces a 1,024-level nesting depth limit for Anti-DoS protection.
2. **Layer 2: Pure Abstract Ecosystem Contracts (`pkgs/codable/lib/codable.dart` & `pkgs/codable/lib/src/contracts/`)**:
   - Format-agnostic companion contracts decoupled from domain classes and
     in-memory payload representation: `Codable<T>`, `Decodable<T>`,
     `Encodable<T>`, `SuperDecodable<T>`, `Decoder`, `Encoder`, `KeyedDecoder`,
     `MappedDecoder`, `UnkeyedDecoder`, `SingleValueDecoder`, `KeyedEncoder`,
     `UnkeyedEncoder`, `SingleValueEncoder`, `KeyOptions`, and
     `CodableException`.
   - Direct primitive reader/writer methods and typed collection helpers
     (`decodeList<T>`, `decodeIntList`, `decodeDoubleList`, `decodeFloat64List`,
     `decodeStringList`, `decodeBoolList`).
3. **Layer 3: Target-Aware Format Drivers (`pkgs/codable/lib/src/json/driver/`)**:
   - `JsonCodableDecoder` and `JsonCodableEncoder` bind Layer 2 contracts to
     Layer 1 UTF-8 streaming tokens on VM/AOT/Wasm (`driver_streaming.dart`) and
     to browser `JSON.parse` / `JSON.stringify` `JSObject` traversal on Web JS
     (`driver_js.dart`).

## Code Layout

- `pkgs/codable/lib/codable.dart`: Format-agnostic contracts barrel.
- `pkgs/codable/lib/codable_json.dart`: JSON driver and streaming substrate
  barrel.
- `pkgs/codable/lib/src/contracts/`: Abstract contracts (`codable.dart`,
  `decoder.dart`, `encoder.dart`, `custom_decoder.dart`, `static_key.dart`,
  `exceptions.dart`, `annotations.dart`).
- `pkgs/codable/lib/src/json/substrate/`: `JsonTokenReader`, `JsonTokenWriter`,
  `JsonKeyOptions`, `JsonUtf8Codec`, and span parsers.
- `pkgs/codable/lib/src/json/driver/`: `JsonCodableDecoder` and
  `JsonCodableEncoder` implementations (`driver_streaming.dart`,
  `driver_js.dart`, `adaptive_writer.dart`, `mapped_decoder.dart`).
- `pkgs/codable_builder/`: `build_runner` code generator for `@Codable()`.
- `pkgs/codable_benchmarks/`: Multi-runtime (`AOT`, `JS`, `Wasm`) benchmark
  suite.

## Interface Contracts Summary

### 1. Top-Level Companion Contracts

```dart
abstract interface class Decodable<T> {
  const factory Decodable.fromFunction(T Function(Decoder decoder) decode) =
      _FunctionDecodable<T>;

  T decode(Decoder decoder);
}

abstract interface class Encodable<T> {
  const factory Encodable.fromFunction(
    void Function(T value, Encoder encoder) encode,
  ) = _FunctionEncodable<T>;

  void encode(T value, Encoder encoder);
}

@Target({TargetKind.classType})
@optionalTypeArgs
abstract interface class Codable<T> implements Decodable<T>, Encodable<T> {
  const factory Codable({
    bool createEncoder,
    bool createDecoder,
    bool useGoldenMask,
    FieldRename fieldRename,
  }) = CodableAnnotation;

  const factory Codable.fromFunctions({
    required T Function(Decoder decoder) decode,
    required void Function(T value, Encoder encoder) encode,
  }) = _FunctionCodable<T>;
}

abstract interface class Decoder {
  Map<Object, Object?> get userInfo;
  Uint8List? get payload;
  KeyedDecoder keyed({KeyOptions? options});
  MappedDecoder mapped();
  UnkeyedDecoder unkeyed();
  SingleValueDecoder singleValue();
  Float64List? decodeUniformDoubleList(List<List<String>> propertyAliases);
}

abstract interface class Encoder {
  Map<Object, Object?> get userInfo;
  KeyedEncoder keyed({KeyOptions? options});
  UnkeyedEncoder unkeyed();
  SingleValueEncoder singleValue();
}
```

### 2. `KeyedDecoder` Direct Primitive Readers & Collections

```dart
abstract interface class KeyedDecoder {
  bool moveNextKey();
  String nextKey();
  String? peekKey();
  int selectKeyIndex(KeyOptions options);
  int selectStringIndex(KeyOptions options);
  void skipValue();

  bool isNextNull();
  void readNull();
  int readInt();
  int? readNullableInt();
  double readDouble();
  double? readNullableDouble();
  String readString();
  String? readNullableString();
  bool readBool();
  bool? readNullableBool();

  Decoder nestedDecoder();
  T decodeValue<T>(Decodable<T> decodable);
  T? decodeNullableValue<T>(Decodable<T> decodable);

  List<T> decodeList<T>(Decodable<T> decodable);
  List<T>? decodeNullableList<T>(Decodable<T> decodable);
  List<int> decodeIntList();
  List<double> decodeDoubleList();
  List<String> decodeStringList();
  List<bool> decodeBoolList();
  Float64List decodeFloat64List();
}
```

### 3. `JsonCodableDecoder` & `JsonCodableEncoder` Entrypoints

```dart
final class JsonCodableDecoder implements Decoder {
  JsonCodableDecoder.fromReader(JsonTokenReader reader, {Map<Object, Object?> userInfo});
  factory JsonCodableDecoder.fromBytes(Uint8List bytes, {Map<Object, Object?> userInfo});
  factory JsonCodableDecoder.fromString(String source, {Map<Object, Object?> userInfo});
  static ByteConversionSink startChunkedConversion<T>(
    Sink<T> sink,
    Decodable<T> decodable, {
    Map<Object, Object?> userInfo,
  });
}

final class JsonCodableEncoder implements Encoder {
  static Uint8List toBytes<T>(
    T value,
    Encodable<T> encodable, {
    Map<Object, Object?> userInfo,
    int? capacityHint,
  });
  static String encode<T>(
    T value,
    Encodable<T> encodable, {
    Map<Object, Object?> userInfo,
  });
  static void toSink<T>(
    BytesBuilder sink,
    T value,
    Encodable<T> encodable, {
    Map<Object, Object?> userInfo,
  });
  static ChunkedConversionSink<T> startChunkedConversion<T>(
    Sink<List<int>> sink,
    Encodable<T> encodable, {
    Map<Object, Object?> userInfo,
  });
}
```
