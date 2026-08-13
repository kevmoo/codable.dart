<!-- mdformat off(prevent table wrapping) -->
# Project: Dart 4 `package:codable` and Mock SDK Substrate

## Architecture
Three-Layer Architecture:
1. **Layer 1: Low-Level Mock SDK Substrate (`lib/src/mock_sdk/`)**:
   - Pure standalone Dart implementation of proposed `dart:convert` atoms.
   - Low-level zero-allocation imperative pull reader (`JsonTokenReader`), push writer (`JsonTokenWriter`), span parsers (`parseIntUtf8`, `parseDoubleUtf8`, etc.), direct buffer formatters (`formatIntUtf8ToBuffer`, etc.), key options indexing (`JsonKeyOptions`), and codecs (`JsonUtf8Codec`).
   - Anti-DoS recursion depth limit (64), UTF-8 bytes handling.
2. **Layer 2: Pure Abstract Ecosystem Contracts (`lib/codable.dart` & `lib/src/contracts/`)**:
   - Format-agnostic contracts completely decoupled from concrete wire formats: `Encodable`, `Decodable<T>`, `Decoder`, `Encoder`, `KeyedDecoder`, `MappedDecoder`, `UnkeyedDecoder`, `SingleValueDecoder`, `KeyedEncoder`, `UnkeyedEncoder`, `SingleValueEncoder`, `StaticKey`, `CodableException`.
   - Advanced polymorphic interfaces: `CustomFieldDecoder<T>`, `UnionDecoder<T>`, `SuperDecodable<T>`.
   - Direct primitive reader/writer methods and typed collection helpers (`decodeList<T>`, `decodeIntList`, etc.).
3. **Layer 3: Format Drivers & Binding (`lib/src/driver/`)**:
   - `JsonCodableDriver` and underlying decoder/encoder container implementations binding Layer 2 contracts to Layer 1 `dart:convert` mock atoms without intermediate `Map<String, dynamic>` DOM allocations.
   - Streaming pull decoding directly into domain model constructors; streaming push encoding directly into byte buffers.

## Feature Inventory
| # | Feature | Description | Milestone | Source |
|---|---------|-------------|-----------|--------|
| 1 | Core Contracts | `Encodable`, `Decodable<T>`, `Decoder`, `Encoder` | M1 | codable_architecture_spec |
| 2 | Keyed Container Contracts | `KeyedDecoder`, `MappedDecoder`, `KeyedEncoder` | M1 | codable_architecture_spec |
| 3 | Unkeyed Container Contracts | `UnkeyedDecoder`, `UnkeyedEncoder` | M1 | codable_architecture_spec |
| 4 | Single Value Container Contracts | `SingleValueDecoder`, `SingleValueEncoder` | M1 | codable_architecture_spec |
| 5 | StaticKey Descriptors | `StaticKey` with name, mask, and options | M1 | codable_architecture_spec |
| 6 | Direct Primitive Readers | `readInt`, `readNullableInt`, `readDouble`, `readNullableDouble`, `readString`, `readNullableString`, `readBool`, `readNullableBool`, `readNull` | M1 | codable_architecture_spec |
| 7 | Direct Primitive Writers | `encodeInt`, `encodeNullableInt`, `encodeDouble`, `encodeNullableDouble`, `encodeString`, `encodeNullableString`, `encodeBool`, `encodeNullableBool`, `encodeNull` | M1 | codable_architecture_spec |
| 8 | Typed Collection Methods | `decodeList<T>`, `decodeIntList`, `decodeDoubleList`, `decodeStringList`, and `encodeList*` | M1 | codable_architecture_spec |
| 9 | Polymorphic Contracts | `CustomFieldDecoder<T>`, `UnionDecoder<T>`, `SuperDecodable<T>` | M1 | codable_architecture_spec |
| 10 | Error Handling & Annotations | `CodableException`, `@Codable`, `@CodableField` | M1 | codable_architecture_spec |
| 11 | Mock Codec & Tokens | `JsonUtf8Codec`, `jsonUtf8`, `JsonTokenType` | M2 | json_utf8_codec_spec |
| 12 | Key Options Indexing | `JsonKeyOptions` with lookup / fast key matching | M2 | json_utf8_codec_spec |
| 13 | Span Parsers | `parseIntUtf8`, `parseDoubleUtf8`, `parseBoolUtf8`, `decodeStringUtf8`, `equalsAscii`, `isNullUtf8`, `isVerbatimUtf8` | M2 | json_utf8_codec_spec |
| 14 | Direct Buffer Formatters | `formatIntUtf8ToBuffer`, `formatDoubleUtf8ToBuffer`, `formatStringUtf8ToBuffer`, `formatAsciiLiteralToBuffer`, `formatBoolUtf8ToBuffer`, `formatNullUtf8ToBuffer` | M2 | json_utf8_codec_spec |
| 15 | Pull Token Reader | `JsonTokenReader` (fromBytes, fromString, navigation, value reading, depth checking) | M2 | json_utf8_codec_spec |
| 16 | Push Token Writer | `JsonTokenWriter` (toBuffer, toSink, emission, flush, depth checking) | M2 | json_utf8_codec_spec |
| 17 | Converters & Streaming | `JsonUtf8Decoder`, `JsonUtf8Encoder`, chunked conversion, `skipValueUtf8` | M2 | json_utf8_codec_spec |
| 18 | Driver Decoder Containers | `JsonCodableDriver.decode`, `_JsonDecoder`, `_JsonKeyedDecoder`, `_JsonMappedDecoder`, `_JsonUnkeyedDecoder`, `_JsonSingleValueDecoder` | M3 | TDD & codable_spec |
| 19 | Driver Encoder Containers | `JsonCodableDriver.encode`, `_JsonEncoder`, `_JsonKeyedEncoder`, `_JsonUnkeyedEncoder`, `_JsonSingleValueEncoder` | M3 | TDD & codable_spec |
| 20 | Zero-Allocation Pipeline | Direct byte span to constructor streaming; direct buffer formatting | M3 | TDD |
| 21 | Trailing Discriminator Tape | Cursor rewind / buffering support for trailing polymorphic keys | M3 | codable_spec |
| 22 | Domain Model: Coordinate | Primitive float streaming with `latitude`/`lat` & `longitude`/`lon` key aliasing | M4 | codable_spec & TDD |
| 23 | Domain Model: UserProfile | String enum `UserRole`, `ZipCodeDecoder` (`CustomFieldDecoder`), Golden Mask bitmask validation | M4 | codable_spec & TDD |
| 24 | Domain Model: Vehicle Hierarchy | Polymorphic `Vehicle` / `Car` / `Bicycle` hierarchy with `SuperDecodable` | M4 | codable_spec & TDD |
| 25 | Model Roundtrip Suite | Bit-exact roundtrip validation vs `jsonEncode` & `jsonDecode` | M4 | ORIGINAL_REQUEST |
| 26 | 41-Atom Traceability Audit | Automated test and script covering all 41 SDK atoms with Keep/Cut/Consolidate matrix | M5 | ORIGINAL_REQUEST |
| 27 | Full E2E Test Suite Pass | 100% test pass across Tiers 1-4 with `package:checks` | M-Final | ORIGINAL_REQUEST |
| 28 | Adversarial Hardening | Tier 5 white-box edge case, recursion depth, and malformed payload testing | M-Final | ORIGINAL_REQUEST |

## Milestones
| # | Name | Scope | Dependencies | Status |
|---|------|-------|-------------|--------|
| M1 | Ecosystem Contracts | `lib/codable.dart` & `lib/src/contracts/*` | none | PLANNED |
| M2 | Mock SDK Substrate | `lib/src/mock_sdk/*` (41 atoms, token reader/writer, span parsers, formatters) | none | PLANNED |
| M3 | JsonCodableDriver | `lib/src/driver/*` (Zero-allocation decoding/encoding driver & containers) | M1, M2 | PLANNED |
| M4 | Domain Models & Roundtrips | `lib/src/domain/*` and `test/domain/*` (Coordinate, UserProfile, Vehicle hierarchy, roundtrips) | M1, M3 | PLANNED |
| M5 | 41-Atom Traceability Audit | `test/api_traceability_test.dart` and audit matrix generator | M2, M3, M4 | PLANNED |
| M-Final | E2E Verification & Hardening | Pass 100% of E2E test suites (Tiers 1-4) and Tier 5 adversarial hardening | M1, M2, M3, M4, M5 | PLANNED |

## Code Layout
- `lib/codable.dart`: Top-level public exports for `package:codable`.
- `lib/src/contracts/`: Pure abstract contracts (`contracts.dart`, `decoders.dart`, `encoders.dart`, `static_key.dart`, `polymorphic.dart`, `exceptions.dart`, `annotations.dart`).
- `lib/src/mock_sdk/`: Mock `dart:convert` substrate (`mock_sdk.dart`, `json_utf8_codec.dart`, `json_token_reader.dart`, `json_token_writer.dart`, `json_key_options.dart`, `span_parsers.dart`, `buffer_formatters.dart`).
- `lib/src/driver/`: Format driver implementation (`json_codable_driver.dart`, `json_decoder.dart`, `json_encoder.dart`).
- `lib/src/domain/`: Canonical domain models (`coordinate.dart`, `user_profile.dart`, `vehicle.dart`).
- `test/`: Verification test suites using `package:checks` (`contracts_test.dart`, `mock_sdk_test.dart`, `driver_test.dart`, `domain_models_test.dart`, `api_traceability_test.dart`, `e2e_test.dart`).

## Interface Contracts

### 1. `package:codable` Top-Level Interfaces
```dart
abstract interface class Encodable {
  void encode(Encoder encoder);
}

abstract interface class Decodable<T> {
  T decode(Decoder decoder);
}

abstract interface class Decoder {
  KeyedDecoder keyed();
  MappedDecoder mapped();
  UnkeyedDecoder unkeyed();
  SingleValueDecoder singleValue();
  Map<Object, Object?> get userInfo;
}

abstract interface class Encoder {
  KeyedEncoder keyed();
  UnkeyedEncoder unkeyed();
  SingleValueEncoder singleValue();
  Map<Object, Object?> get userInfo;
}
```

### 2. `KeyedDecoder` Direct Primitive Readers & Collections
```dart
abstract interface class KeyedDecoder {
  int selectKeyIndex(JsonKeyOptions options);
  String? peekKey();
  void skipField();
  bool hasNext();

  int readInt();
  int? readNullableInt();
  double readDouble();
  double? readNullableDouble();
  String readString();
  String? readNullableString();
  bool readBool();
  bool? readNullableBool();
  void readNull();

  T decodeValue<T>(T Function(Decoder) decoder);
  T? decodeNullableValue<T>(T Function(Decoder) decoder);

  List<int> decodeIntList();
  List<double> decodeDoubleList();
  List<String> decodeStringList();
  List<T> decodeList<T>(T Function(Decoder) decoder);
}
```

### 3. `JsonCodableDriver` Public Interface
```dart
abstract final class JsonCodableDriver {
  static T decode<T>(Uint8List bytes, Decodable<T> decodable, {Map<Object, Object?>? userInfo});
  static T decodeString<T>(String jsonString, Decodable<T> decodable, {Map<Object, Object?>? userInfo});
  static Uint8List encode(Encodable encodable, {Map<Object, Object?>? userInfo});
  static String encodeToString(Encodable encodable, {Map<Object, Object?>? userInfo});
}
```
<!-- mdformat on -->
