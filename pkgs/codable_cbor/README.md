Zero-dependency definite-length RFC 8949 CBOR serialization driver for
`package:codable`, streaming directly between `Uint8List` buffers and
`@Codable()` companions without intermediate `Map` or AST allocations.

`package:codable_cbor` depends exclusively on `package:codable` and the Dart SDK
(`dart:convert` and `dart:typed_data`), compiling cleanly across the Dart VM,
AOT, `dart2wasm`, and `dart2js`.

## Architecture & Wire Guarantees

- **Zero-copy `Uint8List` binary slices (`ValueKind.bytes`)**: Encodes
  `Uint8List` values as native CBOR Major Type 2 byte strings (`bstr`) rather
  than Base64 text or integer arrays, and decodes Major Type 2 slices via
  `Uint8List.sublistView` directly over the input buffer without copying bytes
  (with automatic fallback for Major Type 4 `[0..255]` integer arrays).
- **Definite-length Major Type 4 & 5 containers (`length`)**: Always emits
  canonical definite-length CBOR arrays and maps (never indefinite `0x9f`,
  `0xbf`, or `0xff` break markers). Known container sizes (`Encoder.keyed` and
  `Encoder.unkeyed` `length:` hints) write exact headers upfront; dynamic
  containers with omitted nullable fields reserve 1 byte (`count < 24` patched
  in `O(1)`) and shift-patch multi-byte headers only when `count >= 24`. On
  decode, `UnkeyedDecoder.length` and `MapDecoder.length` expose exact upfront
  counts so typed buffers (`Float64List(len)`) pre-allocate in one shot.
- **Typed & composite `Map<K, V>` keys (`MapDecoder` / `MapEncoder`)**:
  Preserves native integer, boolean, enum, tuple, and nested `@Codable()` struct
  keys in CBOR Major Type 5 maps without stringifying keys, while
  `Map<String, V>` stays on the zero-closure `KeyedDecoder` / `KeyedEncoder`
  fast path.
- **Binary format adaptation (`isHumanReadable == false`)**: Both
  `CborCodableDecoder` and `CborCodableEncoder` report
  `isHumanReadable == false`, allowing format-adaptive `Codable<T>` companions
  (such as 16-byte binary `Uuid` or integer epoch `DateTime` codecs) to switch
  automatically between compact binary CBOR and human-readable JSON/YAML.
- **Compiled `KeyOptions` UTF-8 key matching**: Pre-encodes expected field names
  into UTF-8 byte slices once per `KeyOptions` via `KeyOptions.compiled<T>` and
  matches incoming Major Type 3 text keys directly against raw payload bytes
  without allocating Dart `String` instances per field.

## Quickstart

```dart
import 'dart:typed_data';

import 'package:codable/codable.dart';
import 'package:codable_cbor/codable_cbor.dart';

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

  final bytes = CborCodableEncoder.encode(
    packet,
    const TelemetryPacketCodable(),
  );

  final decoded = CborCodableDecoder.decode(
    bytes,
    const TelemetryPacketCodable(),
  );
  print('Seq ${decoded.sequence}: ${decoded.payload.length} bytes');
}
```
