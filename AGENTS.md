# Agent Instructions for `codable.dart`

## Two substrates, one API

`pkgs/codable/lib/src/json/substrate/substrate.dart` selects which
implementation of `JsonTokenReader`/`JsonTokenWriter`/`JsonUtf8Decoder` the
package compiles against:

- **mock** (default, what CI runs): the pure-Dart copy in `substrate/mock/`.
- **native**: `dart:convert` from the dedicated `dart-sdk-json-next` Dart SDK build
  (`kevmoo/dart-sdk-json-next` `main` branch).

The mock exists so the package builds on a stock SDK. It must stay
source-compatible with the SDK API: same names, same positional/named
parameters, same error contracts (e.g. `toBuffer([int initialCapacity])`
throws `RangeError` on non-positive values; `toBytes()` returns a copy).
When you add or change a member in `substrate/mock/`, check the corresponding
declaration in the SDK's `sdk/lib/convert/json_utf8.dart` first.

Switch with `dart run tool/switch_substrate.dart mock|native`. Never commit
`substrate.dart` in the `native` state.

## Native-substrate check

`native_sdk_parity_test.dart` automatically runs `tool/native_sdk_check.dart`
whenever `dart test` is invoked in an environment with a private SDK (e.g.
local development on Cloudtop). It dynamically skips on standard SDK / CI
environments.

You can also run the check standalone:

```bash
dart run tool/native_sdk_check.dart
```

It switches to the native substrate, runs `dart analyze` (errors and warnings fatal, infos not) with
the private SDK, and restores the mock substrate. SDK discovery order:
`$CODABLE_NATIVE_SDK`, `~/.local/share/dart-sdk-json-utf8-kernels/dart-sdk`,
`~/github/dart-sdk/core/agent-json-utf8-kernels/sdk/out/ReleaseX64/dart-sdk`.


- Exit 0: include "native substrate: analyzed clean" in the PR description.
- Exit 3 (no SDK found): say so explicitly in the PR description so a human
  can run it; do not silently skip.
- Exit 1: fix the drift before opening the PR.

## Standard checks

```bash
dart format --output=none --set-exit-if-changed .
dart analyze --fatal-infos
dart test pkgs/codable pkgs/codable_builder pkgs/codable_benchmarks
```

Benchmarks: `pkgs/codable_benchmarks/tool/run_comparative_benchmarks.dart`.
Numbers labelled "New Dart + Codable" reflect whichever substrate is active —
state which one in any report you update.
