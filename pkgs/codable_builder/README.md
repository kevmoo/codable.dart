# package:codable_builder

Source generator (`build_runner`) for [`package:codable`](../codable/README.md).

Generates single-pass streaming decoders and encoders for classes annotated with
`@Codable()`.

## Setup

Add `codable` to your `dependencies` and `codable_builder` + `build_runner` to
your `dev_dependencies` in `pubspec.yaml`:

```yaml
dependencies:
  codable: ^2.0.0-wip

dev_dependencies:
  build_runner: ^2.4.0
  codable_builder: ^2.0.0-wip
```

## Usage

Annotate your model class with `@Codable()` and include a `part '<file>.g.dart';`
directive:

```dart
import 'package:codable/codable_json.dart';

part 'person.g.dart';

@Codable(fieldRename: FieldRename.snake)
class Person implements Decodable<Person>, Encodable {
  final String firstName;
  final String lastName;

  @CodableKey(name: 'dob', aliases: ['date_of_birth'])
  final String? dateOfBirth;

  @CodableKey(defaultValue: 0)
  final int orderCount;

  @CodableKey(ignore: true)
  final bool isTransient;

  const Person({
    required this.firstName,
    required this.lastName,
    this.dateOfBirth,
    this.orderCount = 0,
    this.isTransient = false,
  });

  static Person decode(Decoder decoder) => _$PersonFromDecoder(decoder);

  @override
  void encode(Encoder encoder) => _$PersonToEncoder(this, encoder);
}
```

Run `build_runner` to generate `person.g.dart`:

```bash
dart run build_runner build --delete-conflicting-outputs
```

## Generated Entrypoints

For each `@Codable()` class `Model`, `codable_builder` emits:

- `_$ModelFromDecoder(Decoder decoder)` — Universal `Decoder` entrypoint
  (automatically routes to streaming `JsonTokenReader` on VM/AOT/Wasm and
  `MappedDecoder` on Web JS).
- `_$ModelToEncoder(Model instance, Encoder encoder)` — Universal `Encoder`
  entrypoint.
- `_$ModelFromReader(JsonTokenReader reader)` — Direct streaming pull-reader
  fast path with pre-compiled `JsonKeyOptions` and 62-bit Golden Mask
  required-field validation.
- `_$ModelToWriter(Model instance, JsonTokenWriter writer)` — Direct streaming
  push-writer fast path with pre-encoded ASCII property keys.

## Annotations Reference

| Annotation              | Target                     | Options                                                                                                                                                        |
| :---------------------- | :------------------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `@Codable()`            | Class                      | `createDecoder` (`true`), `createEncoder` (`true`), `useGoldenMask` (`true`), `fieldRename` (`FieldRename.none`, `snake`, `kebab`, `pascal`, `screamingSnake`) |
| `@CodableKey()`         | Field / Parameter / Getter | `name`, `aliases`, `ignore` (`false`), `customDecoder` (`CustomCodable<T>` instance or type), `defaultValue`                                                   |
| `@CodableTuple(length)` | Field / Parameter          | Fixed-length numeric tuple hint for `Float64List` / `List<double>` / `List<int>`                                                                               |

See the [`package:codable` README](../codable/README.md) for full documentation
on `JsonCodableDecoder`, `JsonCodableEncoder`, and implementing custom
`Decodable` / `Encodable` / `CustomCodable<T>` types.
