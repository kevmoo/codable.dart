Zero-dependency single-pass MessagePack serialization driver for
`package:codable`, streaming directly between `Uint8List` buffers and
`@Codable()` companions without intermediate `Map` or AST allocations.

`package:codable_msgpack` depends exclusively on `package:codable` and the Dart
SDK (`dart:convert` and `dart:typed_data`), compiling cleanly across the Dart
VM, AOT, `dart2wasm`, and `dart2js`.

## Architecture & Wire Guarantees

- **Single-pass container headers (`requireKnownLength`)**: Writes exact
  `fixmap`/`map16`/`map32` and `fixarray`/`array16`/`array32` headers upfront in
  one pass whenever container `length` is provided, with optional
  `requireKnownLength: true` enforcement and automatic 1-byte reservation
  backpatching (`count >= 16` shift) for dynamic hand-written `Encodable`s.
- **Zero-copy `Uint8List` binary slices (`ValueKind.bytes`)**: Encodes
  `Uint8List` values as native MessagePack `bin 8`/`bin 16`/`bin 32` frames and
  decodes binary slices via `Uint8List.sublistView` directly over the input
  buffer without copying bytes (with automatic fallback for `[0..255]` integer
  arrays).
- **Canonical smallest-width integers & web-safe 64-bit arithmetic**: Emits the
  smallest fitting MessagePack integer representation (`fixint`, `uint 8..64`,
  `int 8..64`) using 32-bit arithmetic halves without `ByteData.getInt64` or
  64-bit bitwise shifts, enforcing JavaScript's 53-bit safe integer bounds on
  `dart2js`.
- **Typed & composite `Map<K, V>` keys (`MapDecoder` / `MapEncoder`)**:
  Preserves native integer, boolean, enum, tuple, and nested `@Codable()` struct
  keys in MessagePack maps without stringifying keys, while `Map<String, V>`
  stays on the zero-closure `KeyedDecoder` / `KeyedEncoder` fast path.
- **Binary format adaptation (`isHumanReadable == false`)**: Both
  `MsgPackCodableDecoder` and `MsgPackCodableEncoder` report
  `isHumanReadable == false`, allowing format-adaptive `Codable<T>` companions
  (such as 16-byte binary `Uuid` or integer epoch `DateTime` codecs) to switch
  automatically between compact binary MessagePack and human-readable JSON/YAML.
- **Compiled `KeyOptions` UTF-8 key matching**: Pre-compiles expected field
  names into UTF-8 byte hash/span tables once per `KeyOptions` via
  `KeyOptions.compiled<T>` and matches incoming MessagePack string keys directly
  against raw payload bytes without allocating Dart `String` instances per
  field.

## Quickstart

```dart
import 'dart:typed_data';

import 'package:codable/codable.dart';
import 'package:codable_msgpack/codable_msgpack.dart';

part 'packet.g.dart';

@Codable()
final class TelemetryPacket {
  final int sequence;
  final Uint8List payload;
  final Map<int, String> channelNames;

  const TelemetryPacket({
    required this.sequence,
    required this.payload,
    this.channelNames = const {},
  });
}

void main() {
  final packet = TelemetryPacket(
    sequence: 42,
    payload: Uint8List.fromList([0xde, 0xad, 0xbe, 0xef]),
    channelNames: const {1: 'imu', 2: 'lidar'},
  );

  final bytes = MsgPackCodableEncoder.encode(
    packet,
    const TelemetryPacketCodable(),
    requireKnownLength: true,
  );

  final decoded = MsgPackCodableDecoder.decode(
    bytes,
    const TelemetryPacketCodable(),
  );
  print('Seq ${decoded.sequence}: ${decoded.payload.length} bytes');
}
```
