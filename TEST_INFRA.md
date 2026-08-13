<!-- mdformat off(prevent table wrapping) -->
# E2E Test Infra: `package:codable`

## Test Philosophy
- Opaque-box, requirement-driven. Derives from `ORIGINAL_REQUEST.md`, `codable_architecture_spec.md`, and `json_utf8_codec_spec.md`.
- Strict Assertion Standard: All test assertions MUST strictly use `package:checks` (`check(...)`).
- Zero Intermediate Map Allocations: Verification tests validate direct token pull to constructors and direct buffer push from encodables.
- Golden Standard: Direct model serialization roundtrips produce valid, compliant UTF-8 JSON bytes identical to `jsonEncode`.

## Feature Inventory & Test Mapping
| # | Feature | Source | Tier 1 | Tier 2 | Tier 3 |
|---|---------|--------|:------:|:------:|:------:|
| 1 | Top-Level Contracts (`Encodable`, `Decodable`, `Decoder`, `Encoder`) | ORIGINAL_REQUEST § R1 | 5 | 5 | ✓ |
| 2 | Keyed Containers (`KeyedDecoder`, `MappedDecoder`, `KeyedEncoder`) | ORIGINAL_REQUEST § R1 | 5 | 5 | ✓ |
| 3 | Unkeyed Containers (`UnkeyedDecoder`, `UnkeyedEncoder`) | ORIGINAL_REQUEST § R1 | 5 | 5 | ✓ |
| 4 | Single Value Containers (`SingleValueDecoder`, `SingleValueEncoder`) | ORIGINAL_REQUEST § R1 | 5 | 5 | ✓ |
| 5 | StaticKey Descriptors & Aliases | ORIGINAL_REQUEST § R1 | 5 | 5 | ✓ |
| 6 | Direct Primitive Readers (`readInt`, `readDouble`, `readString`, `readBool`, `readNull`) | ORIGINAL_REQUEST § R1 | 5 | 5 | ✓ |
| 7 | Direct Primitive Writers (`encodeInt`, `encodeDouble`, `encodeString`, `encodeBool`, `encodeNull`) | ORIGINAL_REQUEST § R1 | 5 | 5 | ✓ |
| 8 | Typed Collections (`decodeList<T>`, `decodeIntList`, `decodeDoubleList`, `decodeStringList`, `encodeList*`) | ORIGINAL_REQUEST § R1 | 5 | 5 | ✓ |
| 9 | Polymorphic Contracts (`CustomFieldDecoder`, `UnionDecoder`, `SuperDecodable`) | ORIGINAL_REQUEST § R1 | 5 | 5 | ✓ |
| 10 | Error Handling (`CodableException`, Golden Mask bitmask validation) | ORIGINAL_REQUEST § R1 | 5 | 5 | ✓ |
| 11 | Mock Codec & Tokens (`JsonUtf8Codec`, `jsonUtf8`, `JsonTokenType`) | ORIGINAL_REQUEST § R2 | 5 | 5 | ✓ |
| 12 | Key Options Indexing (`JsonKeyOptions`) | ORIGINAL_REQUEST § R2 | 5 | 5 | ✓ |
| 13 | Span Parsers (`parseIntUtf8`, `parseDoubleUtf8`, `parseBoolUtf8`, etc.) | ORIGINAL_REQUEST § R2 | 5 | 5 | ✓ |
| 14 | Direct Buffer Formatters (`formatIntUtf8ToBuffer`, `formatDoubleUtf8ToBuffer`, etc.) | ORIGINAL_REQUEST § R2 | 5 | 5 | ✓ |
| 15 | Pull Token Reader (`JsonTokenReader`) | ORIGINAL_REQUEST § R2 | 5 | 5 | ✓ |
| 16 | Push Token Writer (`JsonTokenWriter`) | ORIGINAL_REQUEST § R2 | 5 | 5 | ✓ |
| 17 | Converters & Streaming (`JsonUtf8Decoder`, `JsonUtf8Encoder`, chunked conversion) | ORIGINAL_REQUEST § R2 | 5 | 5 | ✓ |
| 18 | `JsonCodableDriver` Streaming Decoder & Encoder Containers | ORIGINAL_REQUEST § R2 | 5 | 5 | ✓ |
| 19 | Trailing Discriminator Cursor Rewind / Buffer Support | ORIGINAL_REQUEST § R2 | 5 | 5 | ✓ |
| 20 | Domain Model `Coordinate` (float streaming, alias keys) | ORIGINAL_REQUEST § R3 | 5 | 5 | ✓ |
| 21 | Domain Model `UserProfile` (enums, `ZipCodeDecoder`, Golden Mask) | ORIGINAL_REQUEST § R3 | 5 | 5 | ✓ |
| 22 | Domain Model `Vehicle` Polymorphic Hierarchy (`SuperDecodable`) | ORIGINAL_REQUEST § R3 | 5 | 5 | ✓ |
| 23 | 41-Atom API Traceability Audit Suite | ORIGINAL_REQUEST § R3 | 5 | 5 | ✓ |

## Test Architecture
- **Runner**: `~/github/flutter/bin/dart test`
- **Assertion Framework**: `package:checks` (`check(...)`)
- **Directory Layout**:
  - `test/contracts_test.dart`: Pure contract behavior and mock drivers
  - `test/mock_sdk_test.dart`: Low-level 41 atom span parsers, formatters, token reader/writer, codec
  - `test/driver_test.dart`: `JsonCodableDriver` streaming zero-allocation decoding and encoding
  - `test/domain_models_test.dart`: Domain models (`Coordinate`, `UserProfile`, `Vehicle` hierarchy) and validation
  - `test/api_traceability_test.dart`: Full automated 41-atom audit exercising every atom
  - `test/e2e_test.dart`: End-to-end integration and complex composite scenarios

## Real-World Application Scenarios (Tier 4)
| # | Scenario | Features Exercised | Complexity |
|---|----------|--------------------|------------|
| 1 | High-throughput telemetry batch (10,000 Coordinates) | Primitive streaming, unkeyed arrays, buffer formatters | High |
| 2 | REST API User Profile payload with dirty zip codes & enums | Keyed decoder, CustomFieldDecoder, enum conversion, Golden Mask | High |
| 3 | Heterogeneous vehicle fleet registry with trailing discriminators | SuperDecodable, polymorphic dispatch, cursor rewind/buffering | High |
| 4 | Deeply nested complex document with mixed lists & maps | Recursive decoders, collection helpers, depth limit guard | High |
| 5 | Full 41-atom SDK Traceability Audit report generation | All 41 SDK atoms, Keep/Cut/Consolidate matrix verification | High |

## Coverage Thresholds
- Tier 1: ≥5 test cases per feature (happy-path isolations)
- Tier 2: ≥5 test cases per feature (boundary, nullability, overflows, malformed inputs, depth limits)
- Tier 3: Pairwise coverage of cross-feature interactions (e.g. custom decoder inside unkeyed array, aliased key in polymorphic subtype)
- Tier 4: ≥5 realistic application-level scenarios
- Total Target: ~260+ tests across the test suite
<!-- mdformat on -->
