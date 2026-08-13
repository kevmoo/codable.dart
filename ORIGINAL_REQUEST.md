# Original User Request

## Initial Request — 2026-08-13T06:00:32Z

Implement `package:codable` contracts, a high-performance `JsonCodableDriver` wrapping our proposed `dart:convert` atoms, realistic domain models, and an automated API traceability audit in `~/github/kevmoo/codable`.

Working directory: /usr/local/google/home/kevmoo/github/kevmoo/codable
Integrity mode: development

## Primary Reference Specifications

The agent team should reference the exact API signatures in these two documents:
- **Layer 1 Proposed SDK Atoms**: `/google/src/cloud/kevmoo/resolve_siggi_serialization_questions/google3/experimental/users/kevmoo/projects/dart4_serialization/docs/specs/json_utf8_codec_spec.md`
- **Layer 2 Codable Contracts**: `/google/src/cloud/kevmoo/resolve_siggi_serialization_questions/google3/experimental/users/kevmoo/projects/dart4_serialization/docs/specs/codable_architecture_spec.md`

## Requirements

### R1. Ecosystem Contracts (`lib/codable.dart` & `lib/src/contracts/`)
Implement the core `package:codable` interfaces:
- `Encodable`, `Decodable<T>`, `KeyedDecoder`, `MappedDecoder`, `UnkeyedDecoder`, `SingleValueDecoder`, `KeyedEncoder`, `UnkeyedEncoder`, `SingleValueEncoder`
- Format-agnostic `StaticKey` descriptors
- Direct primitive readers (`readInt()`, `readNullableInt()`, `readDouble()`, `readNullableDouble()`, `readString()`, `readNullableString()`, `readBool()`, `readNullableBool()`, `readNull()`)
- Collection methods (`decodeList<T>()`, `decodeIntList()`, `decodeDoubleList()`, `decodeStringList()`, and `encodeList*`)

### R2. Mock Substrate & JsonCodableDriver (`lib/src/mock_sdk/` & `lib/src/driver/`)
- Implement standalone Dart prototypes of the proposed `dart:convert` atoms (`JsonUtf8Codec`, `JsonUtf8Decoder`, `JsonUtf8Encoder`, `JsonKeyOptions`, `JsonTokenReader`, `JsonTokenWriter`, span parsers, and direct buffer formatters).
- Implement `JsonCodableDriver` binding `package:codable` contracts directly to the mock atoms without intermediate `Map<String, dynamic>` allocations.

### R3. Realistic Domain Models & Verification Test Suites (`test/`)
- Implement representative domain models (`Coordinate`, `UserProfile` with string enums, and a polymorphic subtype hierarchy).
- Implement an end-to-end verification test suite and an automated **API Traceability Audit** that exercises each of the 41 proposed SDK atoms and outputs a Keep / Cut / Consolidate matrix.
- **Assertion Standard**: All unit tests MUST use `package:checks` (`check(...)`) for assertions.

## Acceptance Criteria

### Correctness & Test Suite
- [ ] `~/github/flutter/bin/dart test` passes 100% with zero failures or errors across all test suites.
- [ ] All test assertions strictly utilize `package:checks` API.
- [ ] Direct model serialization roundtrips produce valid, compliant UTF-8 JSON bytes identical to `jsonEncode`.

### Code Quality & Static Analysis
- [ ] `~/github/flutter/bin/dart analyze` reports zero lints, warnings, or errors under strict type settings.

### API Traceability Audit
- [ ] Outputs an empirical API traceability matrix covering all 41 proposed SDK APIs with Keep / Cut / Consolidate recommendations.
