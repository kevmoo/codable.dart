Source generator (`build_runner`) for
[`package:codable`](https://pub.dev/packages/codable).

Generates single-pass streaming `*Codable` companion classes and pre-compiled
`KeyOptions` schemas for classes annotated with `@Codable()`.

## Setup

Add `codable` to your `dependencies` and `codable_builder` + `build_runner` to
your `dev_dependencies` in `pubspec.yaml`:

```yaml
dependencies:
  codable: ^2.0.0-wip

dev_dependencies:
  build_runner: ^2.4.0
  codable_builder: ^0.1.0-wip
```

## Usage

Annotate your domain class with `@Codable()` and include a
`part '<file>.g.dart';` directive. Your domain class stays completely free of
serialization boilerplate:

```dart
import 'package:codable/codable_json.dart';

part 'person.g.dart';

@Codable(fieldRename: FieldRename.snake)
class Person {
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
}
```

Run `build_runner` to generate `person.g.dart`:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Then decode and encode using the generated `const PersonCodable()` companion:

```dart
final person = const PersonCodable().decode(
  JsonCodableDecoder.fromBytes(utf8Bytes),
);
final outBytes = JsonCodableEncoder.toBytes(person, const PersonCodable());
```

## Generated Output

For each `@Codable()` class `Model`, `codable_builder` emits:

- `_$ModelSchema` (`extension type const _$ModelSchema(int _value)`) — Unified
  schema descriptor containing wire name constants, key index constants, a
  pre-compiled `KeyOptions` lookup table, enum option tables, and a 62-bit
  Golden Mask (`validate()`) for single-instruction required-field verification.
- `final class ModelCodable` (`const ModelCodable()`, or
  `const ModelCodable(this._$t)` for generic `Model<T>`) — Stateless companion
  class implementing `KeyedCodable<Model>` (or `Decodable<Model>` /
  `KeyedEncodable<Model>` when `createEncoder: false` or
  `createDecoder: false`):
  - `Model decode(Decoder decoder)` — Universal streaming `Decoder` method (or
    `MappedDecoder` discriminator dispatch for `sealed` / polymorphic bases).
  - `List<Model> decodeList(Decoder decoder)` — Specialized SIMD/flat-buffer
    array decoder for uniform `double` models (all other models inherit
    `decodeList` via `DecodableListExtension`).
  - `int encodedFieldCount(Model instance)` &
    `void encodeFields(Model instance, KeyedEncoder keyed)` — Field-splicing
    hooks used by polymorphic envelopes (`SuperCodable` and generated `sealed`
    companions).
  - `void encode(Model instance, Encoder encoder)` — Universal single-pass
    streaming `Encoder` method.

## Generic & Polymorphic Models

- **Generic `@Codable()` classes**: `class BaseResponse<T>` generates
  `BaseResponseCodable<T>(this._$t)` accepting an inner `Codable<T>` (or
  `Decodable<T>` / `Encodable<T>` when `createEncoder: false` /
  `createDecoder: false`), supporting `.list` and `.nullable` composition.
- **Polymorphic `sealed` & `abstract` hierarchies**: Annotating a `sealed` base
  class with `@Codable(discriminatorKey: 'type')` (or listing explicit concrete
  classes in `@Codable(subtypes: [...])`) generates exhaustive single-pass
  discriminator decoding and `1 + subCount` container encoding.

## Annotations Reference

| Annotation              | Target                     | Options                                                                                                                                                                                                              |
| :---------------------- | :------------------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `@Codable()`            | Class                      | `createDecoder` (`true`), `createEncoder` (`true`), `useGoldenMask` (`true`), `fieldRename` (`FieldRename.none`, `snake`, `kebab`, `pascal`, `screamingSnake`), `discriminatorKey`, `discriminatorValue`, `subtypes` |
| `@CodableKey()`         | Field / Parameter / Getter | `name`, `aliases`, `ignore` (`false`), `codable` / `customDecoder` / `customEncoder` (`Codable<T>` / `Decodable<T>` / `Encodable<T>` instance or type), `defaultValue`                                               |
| `@CodableTuple(length)` | Field / Parameter          | Fixed-length numeric tuple hint for `Float64List` / `List<double>` / `List<int>`                                                                                                                                     |

See the [`package:codable` documentation](https://pub.dev/packages/codable) for
full details on `JsonCodableDecoder`, `JsonCodableEncoder`, and implementing
custom `Codable<T>` / `Decodable<T>` / `Encodable<T>` companions.
