# Agent Instructions for `codable.dart`

## ⚡ Active Substrate Verification & Layer Targeting Invariant

When developing, optimizing, or benchmarking `package:codable`, **ALWAYS VERIFY** that the `native` substrate is active and that your modifications are targeting the underlying Dart SDK (`dart:convert` layer), not the `mock/` substrate.
The `mock/` substrate is ONLY a compilation stub for unmodified SDKs and CI; it is a false target for any performance optimizations or architectural improvements.

**Mandatory Verification Step:**
Before generating PRs, writing optimization code, or running benchmarks, check the substrate state:
1. Ensure `pkgs/codable/lib/src/json/substrate/substrate.dart` points to `substrate_native.dart`.
2. Ensure you are targeting the right codebase. Performance changes should be applied to `dart-sdk` (`sdk/lib/convert/...`) rather than `pkgs/codable/lib/src/json/substrate/mock/...`.
3. Do not run benchmarks on mock without explicitly providing `--allow-mock`.

## Two substrates, one API

`pkgs/codable/lib/src/json/substrate/substrate.dart` selects which
implementation of `JsonTokenReader`/`JsonTokenWriter`/`JsonUtf8Decoder` the
package compiles against:

- **native** (default): `dart:convert` from the dedicated `dart-sdk-json-next` Dart SDK build
  (`kevmoo/dart-sdk-json-next` `main` branch).
- **mock** (what CI runs): the pure-Dart copy in `substrate/mock/`.

The mock exists so the package builds on a stock SDK. It must stay
source-compatible with the SDK API: same names, same positional/named
parameters, same error contracts (e.g. `toBuffer([int initialCapacity])`
throws `RangeError` on non-positive values; `toBytes()` returns a copy).
When you add or change a member in `substrate/mock/`, check the corresponding
declaration in the SDK's `sdk/lib/convert/json_utf8.dart` first.

CI automatically switches `substrate.dart` to the mock substrate in `.github/workflows/dart.yml`.
For local testing on a stock SDK, switch with `dart run tool/switch_substrate.dart mock|native`.

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

## Benchmarking & Optimization Workflow

Benchmarks: `pkgs/codable_benchmarks/tool/run_comparative_benchmarks.dart`.
Numbers labelled "New Dart + Codable" reflect whichever substrate is active —
state which one in any report you update.

When evaluating performance optimizations, PRs, or commit deltas:
1. **Compare Against Baseline via Git (`--diff`)**:
   ```bash
   # Run benchmarks and automatically diff against main branch baseline in git:
   dart run pkgs/codable_benchmarks/tool/run_comparative_benchmarks.dart -t all --diff main
   ```
2. **Standalone Telemetry Diff (Zero-Token & Instant)**:
   ```bash
   # Diff existing local JSON against main without re-running 20-min compilations:
   dart run pkgs/codable_benchmarks/tool/run_comparative_benchmarks.dart --from-json benchmark_comparison.json --diff main
   ```
3. **Primary Report Invariant**:
   * ALWAYS lead with the isolated **Before vs. After Delta Table** on the `New Dart + Codable` target.
   * Multi-tier ecosystem matrices (vs Stock Dart) are strictly secondary.
   * Prominently highlight regressions (🔴) before calling out speedups (🏆).

