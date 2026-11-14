Zero-dependency TOML v1.0 serialization driver for `package:codable`, pairing a
line-and-column diagnostic TOML v1.0 parser with a declaration-order-independent
TOML v1.0 table serializer.

`package:codable_toml` depends exclusively on `package:codable` and the Dart SDK
(`dart:convert` and `dart:typed_data`), compiling cleanly across the Dart VM,
AOT, `dart2wasm`, and `dart2js`.

## Architecture & Wire Guarantees

- **Declaration-order-independent table reordering**: Accumulates an in-memory
  structural node tree per container scope without requiring an explicit
  `Encoder.close()` lifecycle hook. Within every `[table]` and
  `[[array_of_tables]]` element, scalar and inline-array `key = value` pairs are
  emitted before `[subtable]` and `[[array_of_tables]]` sections—even when a
  Dart `@Codable()` class declares nested object or list fields before scalar
  fields.
- **Minimal intermediate headers & empty container fidelity**: Suppresses
  redundant `[parent]` headers when `parent` has zero scalar entries and one or
  more `[parent.child]` or `[[parent.items]]` sections, while emitting explicit
  `[empty]` headers for genuinely empty tables (`0` scalars and `0` child
  sections) and `key = []` for empty lists. Nested tables inside inner arrays
  (such as `List<List<Model>>`) automatically render as single-line TOML v1.0
  inline tables (`{ k1 = v1, k2 = v2 }`).
- **Format-adaptive `TomlDateTimeCodec` (`DateTime`)**: Emits native unquoted
  RFC 3339 Offset Date-Time literals (`createdAt = 1979-05-27T07:32:00Z`) on
  TOML via `TomlNativeDateTimeSink`, ISO-8601 strings on other human-readable
  drivers (JSON/YAML), and UTC epoch milliseconds on binary drivers
  (CBOR/MessagePack). Standard `String` fields are always quoted and escaped so
  date-looking strings (`"1979-05-27T07:32:00Z"`) never collide with native TOML
  timestamps.
- **Line, column & path diagnostics (`TomlCodableException`)**: Reports 1-based
  `line`, `column`, and hierarchical token `path` (`server.ports[0]`) across
  syntax errors, schema mismatches, duplicate keys, and structural boundary
  violations, with non-destructive `MappedDecoder` to `KeyedDecoder` handoff for
  `SuperDecodable` sealed hierarchies regardless of discriminator key position.
- **Web-safe integers & canonical TOML floats**: Enforces signed 64-bit integer
  bounds on VM/Wasm and 53-bit safe integer bounds on JavaScript, while
  preserving TOML float syntax (`1.0`, `-0.0`, `inf`, `-inf`, `nan`) even on
  `dart2js` where `(1.0).toString() == '1'`.

## TOML v1.0 Structural Boundaries

- **Table document root**: Every TOML v1.0 document is a root table
  (`KeyedEncoder` or `MapEncoder`). Encoding a top-level scalar, `null`, or
  top-level array throws a `TomlCodableException`.
- **No `null` wire values**: TOML v1.0 has no `null` literal. Nullable fields on
  `@Codable()` classes omit `null` keys cleanly, whereas explicit `null`
  elements in `List<T?>` or `null` values in `Map<K, V?>` throw a
  `TomlCodableException` carrying the offending `path` rather than silently
  dropping entries.
- **Scalar map keys (`MapEncoder`)**: Supports `String`, `int`, `bool`, enum,
  and finite `double` map keys stringified as bare or quoted TOML keys. `null`,
  binary `Uint8List`, non-finite `double`, and composite list/table/map keys
  throw a `TomlCodableException`.

## Quickstart

```dart
import 'package:codable/codable.dart';
import 'package:codable_toml/codable_toml.dart';

part 'service_manifest.g.dart';

@Codable()
final class DatabaseConfig {
  final String host;
  final int port;

  const DatabaseConfig({required this.host, this.port = 5432});
}

@Codable()
final class ServiceManifest {
  final DatabaseConfig database;
  final String name;

  @CodableKey(codable: TomlDateTimeCodec())
  final DateTime deployedAt;

  const ServiceManifest({
    required this.database,
    required this.name,
    required this.deployedAt,
  });
}

void main() {
  final manifest = ServiceManifest(
    database: const DatabaseConfig(host: 'db.internal'),
    name: 'billing-api',
    deployedAt: DateTime.utc(2026, 11, 14, 2, 30),
  );

  final toml = TomlCodableEncoder.encode(
    manifest,
    const ServiceManifestCodable(),
  );
  print(toml);

  final decoded = TomlCodableDecoder.decode(
    toml,
    const ServiceManifestCodable(),
  );
  print('Loaded ${decoded.name} (${decoded.database.host})');
}
```
