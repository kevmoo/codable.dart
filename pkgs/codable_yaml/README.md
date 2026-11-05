`SourceSpan`-preserving YAML serialization driver for `package:codable`,
combining `checked_yaml`-grade line and column diagnostics with format-agnostic
`@Codable()` models and YAML emission.

`package:codable_yaml` bridges `package:yaml`'s AST directly into
`package:codable` `Decoder` and `Encoder` cursors without converting nodes into
intermediate untyped `Map<String, dynamic>` copies. The same `@Codable()`
companions used for JSON or CBOR work unchanged over YAML documents.

## Decoding with `YamlCodableDecoder`

`YamlCodableDecoder.decode` parses a YAML document via `loadYamlNode`, runs any
`Decodable<T>` companion, and enriches syntax or schema failures into a
`YamlCodableException`
(`implements SourceSpanFormatException, CodableException`) carrying the exact
offending `SourceSpan` and hierarchical field `path`:

- **Line & column diagnostics (`checked_yaml` replacement)**: Type mismatches,
  unknown enum values, missing required fields, and custom validation errors
  point directly at the offending scalar or mapping span—including `sourceUrl`
  and ASCII source highlights via `toString()`.
- **Duplicate-key rejection**: Duplicate YAML mapping keys and duplicate logical
  `@CodableKey(aliases: [...])` bindings fail immediately with a
  `YamlCodableException` anchored at the duplicate node.
- **Anchors & aliases**: Standard YAML anchors (`&default`) and aliases
  (`*default`) on scalars, sequences, and nested mappings resolve transparently
  through `package:yaml` while preserving per-node source spans.
- **Typed & composite map keys (`MapDecoder`)**: Supports native unquoted YAML
  integer/boolean keys (`200: ok`, `true: 1.0`), string-coerced quoted keys
  (`"200": ok`), and structured block keys (`? {x: 0, y: 0}`) via
  `Decoder.map()`.
- **AST interop (`YamlCodableDecoder.fromNode`)**: Decode directly from an
  existing `YamlNode` subtree when embedding `Codable` models inside larger YAML
  workflows.

## Encoding with `YamlCodableEncoder`

`YamlCodableEncoder` reports `isHumanReadable == true` so format-adaptive codecs
(such as ISO-8601 `DateTime` or canonical `Uuid` strings) emit human-friendly
scalars automatically, while `Uint8List` binary fields default to Base64 via
`Base*EncoderMixin`:

- **Block style (default)**: Emits clean 2-space indented block mappings and
  sequences (`flow: false`), using inline `[]` and `{}` for empty containers and
  explicit `?` block keys for composite map keys.
- **Flow style (`flow: true`)**: Emits compact single-line flow mappings and
  sequences (`{host: localhost, ports: [8080, 8443]}`).

## Quickstart

```dart
import 'package:codable/codable.dart';
import 'package:codable_yaml/codable_yaml.dart';

part 'service_config.g.dart';

@Codable()
final class ServiceConfig {
  final String name;
  final int port;
  final Map<int, String> statusLabels;
  final List<String> tags;

  const ServiceConfig({
    required this.name,
    required this.port,
    this.statusLabels = const {},
    this.tags = const [],
  });
}

void main() {
  const rawYaml = '''
name: api-gateway
port: 8080
statusLabels:
  200: ok
  503: unavailable
tags:
  - edge
  - grpc
''';

  final config = YamlCodableDecoder.decode(
    rawYaml,
    const ServiceConfigCodable(),
    sourceUrl: Uri.parse('config.yaml'),
  );

  final blockYaml = YamlCodableEncoder.encode(
    config,
    const ServiceConfigCodable(),
  );
  print(blockYaml);
}
```
