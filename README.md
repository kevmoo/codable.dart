# codable.dart

High-performance, zero-intermediate-tree serialization framework and JSON
streaming drivers for Dart.

## Packages

| Package                                                                     | Description                                                                                                                                                                                                        |
| :-------------------------------------------------------------------------- | :----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [`package:codable`](pkgs/codable/README.md)                                 | Core serialization contracts (`Encodable`, `Decodable<T>`, `CustomCodable<T>`, `Decoder`, `Encoder`), target-aware JSON drivers (`JsonCodableDecoder`, `JsonCodableEncoder`), and UTF-8 token streaming substrate. |
| [`package:codable_builder`](pkgs/codable_builder/README.md)                 | `build_runner` code generator synthesizing single-pass streaming serializers and pre-compiled `KeyOptions` schemas for `@Codable()` classes.                                                                       |
| [`package:codable_benchmarks`](pkgs/codable_benchmarks/BENCHMARK_REPORT.md) | Multi-runtime benchmark suite (`AOT`, `JS`, `Wasm`) comparing `package:codable` and `json_serializable` across canonical JSON datasets.                                                                            |

## Quick Links

- **[User Guide & Architecture (`pkgs/codable/README.md`)](pkgs/codable/README.md)**:
  1. [The General `Codable` Model](pkgs/codable/README.md#1-the-general-codable-model) (`Decoder` / `Encoder` containers: `keyed`, `mapped`, `unkeyed`, `singleValue`, and VM/Wasm vs. Web JS routing)
  2. [Using `JsonCodableDecoder` and `JsonCodableEncoder`](pkgs/codable/README.md#2-using-jsoncodabledecoder-and-jsoncodableencoder) (bytes, strings, chunked streams, and `@Codable()` annotations)
  3. [Implementing Your Own `Codable`](pkgs/codable/README.md#3-implementing-your-own-codable) (manual `Decodable<T>` / `Encodable` loops, `CustomCodable<T>` field converters, and polymorphic hierarchies)
- **[Code Generation Guide (`pkgs/codable_builder/README.md`)](pkgs/codable_builder/README.md)**
- **[Runnable Examples (`pkgs/codable/example/`)](pkgs/codable/example/)**
- **[Benchmark Reports (`pkgs/codable_benchmarks/BENCHMARK_REPORT.md`)](pkgs/codable_benchmarks/BENCHMARK_REPORT.md)**

## Quickstart

```dart
import 'dart:convert';
import 'dart:typed_data';
import 'package:codable/codable_json.dart';

part 'user.g.dart';

@Codable()
class User implements Decodable<User>, Encodable {
  final int id;
  final String name;

  const User({required this.id, required this.name});

  static User decode(Decoder decoder) => _$UserFromDecoder(decoder);

  @override
  void encode(Encoder encoder) => _$UserToEncoder(this, encoder);
}

void main() {
  final inputBytes = Uint8List.fromList(utf8.encode('{"id": 42, "name": "Ada"}'));

  // Decode directly from UTF-8 bytes without intermediate Map allocation:
  final user = User.decode(JsonCodableDecoder.fromBytes(inputBytes));

  // Encode directly back to UTF-8 bytes:
  final outputBytes = JsonCodableEncoder.toBytes(user.encode);
  print(utf8.decode(outputBytes)); // {"id":42,"name":"Ada"}
}
```
