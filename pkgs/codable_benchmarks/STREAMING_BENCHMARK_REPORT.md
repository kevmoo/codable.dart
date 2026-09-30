## 🌊 Streaming Benchmark Report (`ChunkedConversionSink` / `ByteConversionSink`)

### 📝 Provenance

- **Run Timestamp**: 2026-09-30T18:49:16.201Z
- **Stock Dart SDK (Tier 0 & Tier 2)**: 3.14.0-271.0.dev (dev) (Fri Sep 25 05:03:10 2026 -0700) on "linux_x64"
- **New Dart SDK (Tier 1 & Tier 3)**: 3.14.0-json-next.c52b7fecede9a0324612382bdfe02bd0d793d6c0 (main) (Mon Sep 21 10:53:03 2026 -0700) on "linux_x64"
- **Repo Commit**: 12cffb870aeadf003ec5d4983f3ac47913bac863
- **Host OS**: linux, Hostname: bluefin
- **Trials**: 15 (reporting `median` latency)

### 🏛️ The 4 Dart Serialization Tiers

- **Tier 0 (`Stock Dart + json_serializable [Chunked Sink]`)**: Out-of-the-box status-quo baseline compiled & executed on unmodified Stock Dart (`utf8.decoder.fuse(json.decoder).startChunkedConversion` on 32 KB input chunks, and `json.encoder.fuse(utf8.encoder).startChunkedConversion` for output).
- **Tier 1 (`New Dart + json_serializable [Chunked Sink]`)**: Unmodified `json_serializable` chunked converter pipeline running on the upgraded `dart-sdk-json-next` SDK.
- **Tier 2 (`Stock Dart + Codable [Mock Substrate]`)**: `package:codable` running on unmodified Stock Dart (`JsonCodableDecoder.startChunkedConversion` accumulating 32 KB chunks into `BytesBuilder(copy: false)` for `_MockJsonTokenReader`, and `JsonCodableEncoder.startChunkedConversion` streaming 32 KB chunks via `JsonTokenWriter.toSink`).
- **Tier 3 (`New Dart + Codable [Native Substrate]`)**: Full end-to-end streaming stack (`package:codable` + `dart:convert` Layer 1 native `JsonTokenReader` / `JsonUtf8TokenWriter` chunked sink substrate).

### 📊 3-Runtime Summary (4-Tier Relative Efficiency & GeoMean Speedups)

<!-- mdformat off(prevent table wrapping) -->
| Target Runtime | Tier / Configuration | 📥 Decode Efficiency<br/>[ Worst / GeoMean / Best ] | 📥 Decode GeoMean<br/>(vs Tier 0 / vs Tier 1) | 📤 Encode Efficiency<br/>[ Worst / GeoMean / Best ] | 📤 Encode GeoMean<br/>(vs Tier 0 / vs Tier 1) |
| :--- | :--- | :---: | :---: | :---: | :---: |
| **AOT (`dart compile exe`)** | **Tier 0: `Stock + json_serial`** | 🔴 `[ 23 / 35 / 54 ]` | **1.00x** / **0.93x** | 🔴 `[ 21 / 27 / 36 ]` | **1.00x** / **0.38x** |
| **AOT (`dart compile exe`)** | **Tier 1: `New + json_serial`** | 🔴 `[ 25 / 38 / 56 ]` | **1.07x** / **1.00x** | 🟡 `[ 51 / 71 / 100 ]` | **2.62x** / **1.00x** |
| **AOT (`dart compile exe`)** | **Tier 2: `Stock + Codable [Mock]`** | 🔴 `[ 60 / 65 / 71 ]` | **1.86x** / **1.74x** | 🟡 `[ 77 / 88 / 100 ]` | **3.22x** / **1.23x** |
| **AOT (`dart compile exe`)** | **Tier 3: `New + Codable [Native]`** | 🟢 `[ 100 / 100 / 100 ]` | **2.85x** / **2.66x** | 🟡 `[ 76 / 87 / 100 ]` | **3.20x** / **1.22x** |
| **JS (`dart2js` / Node 24 / V8)** | **Tier 0: `Stock + json_serial`** | 🔴 `[ 26 / 32 / 39 ]` | **1.00x** / **0.95x** | 🔴 `[ 49 / 58 / 68 ]` | **1.00x** / **0.68x** |
| **JS (`dart2js` / Node 24 / V8)** | **Tier 1: `New + json_serial`** | 🔴 `[ 28 / 33 / 39 ]` | **1.05x** / **1.00x** | 🟡 `[ 73 / 85 / 100 ]` | **1.48x** / **1.00x** |
| **JS (`dart2js` / Node 24 / V8)** | **Tier 2: `Stock + Codable [Mock]`** | 🟢 `[ 99 / 100 / 100 ]` | **3.15x** / **3.00x** | 🟡 `[ 55 / 74 / 100 ]` | **1.28x** / **0.86x** |
| **JS (`dart2js` / Node 24 / V8)** | **Tier 3: `New + Codable [Native]`** | 🟢 `[ 95 / 98 / 100 ]` | **3.08x** / **2.94x** | 🟡 `[ 58 / 76 / 100 ]` | **1.32x** / **0.89x** |
| **WASM (`dart2wasm` / Node 24 / V8)** | **Tier 0: `Stock + json_serial`** | 🔴 `[ 22 / 40 / 70 ]` | **1.00x** / **0.86x** | 🔴 `[ 34 / 40 / 47 ]` | **1.00x** / **0.50x** |
| **WASM (`dart2wasm` / Node 24 / V8)** | **Tier 1: `New + json_serial`** | 🔴 `[ 29 / 46 / 73 ]` | **1.16x** / **1.00x** | 🟡 `[ 64 / 80 / 100 ]` | **2.01x** / **1.00x** |
| **WASM (`dart2wasm` / Node 24 / V8)** | **Tier 2: `Stock + Codable [Mock]`** | 🔴 `[ 52 / 57 / 61 ]` | **1.42x** / **1.23x** | 🟡 `[ 79 / 89 / 100 ]` | **2.25x** / **1.12x** |
| **WASM (`dart2wasm` / Node 24 / V8)** | **Tier 3: `New + Codable [Native]`** | 🟢 `[ 100 / 100 / 100 ]` | **2.52x** / **2.17x** | 🟡 `[ 80 / 89 / 98 ]` | **2.24x** / **1.11x** |
<!-- mdformat on -->

> **Scoring Metric**: **Relative Throughput Efficiency** (`100` = Peak Speed across all measured tiers). Calculated as `round((MinLatency / Latency) * 100)` per workload, aggregated across benchmarks using the **Geometric Mean** (Fleming & Wallace 1986).
> - **`[ Worst / GeoMean / Best ]`**: Range from lowest score (worst workload) to the geometric mean and peak dataset score
>   across the active canonical benchmarks.
> - **Badges**: 🥇 Peak across all workloads (`100`) • 🟢 `≥ 90` (Within 10% of peak) • 🟡 `70–89` (Good / moderate) • 🔴 `< 70` (Significant performance gap).

------------------------------------------------------------------------

### 🎛️ Measurement Controls & Resolution Floor

These diagnostics bound how much of the tables above is signal. Read them before crediting any ratio.

<!-- mdformat off(prevent table wrapping) -->
| Target Runtime | Decode Control Drift (Tier 1 / Tier 0) | Per-Dataset Control Ratios |
| :--- | :---: | :--- |
| **AOT** | **0.983x** | `[1.006, 0.960]` |
| **JS** | **1.071x** | `[1.020, 1.124]` |
| **WASM** | **1.007x** | `[0.989, 1.025]` |
<!-- mdformat on -->

<!-- mdformat off(prevent table wrapping) -->
| Target Runtime | Encode Control Drift (Tier 1 / Tier 0) | Per-Dataset Control Ratios |
| :--- | :---: | :--- |
| **AOT** | N/A | N/A |
| **JS** | N/A | N/A |
| **WASM** | N/A | N/A |
<!-- mdformat on -->

> **Decode control**: `json_serializable_literal` calls `jsonDecode(String)` plus `.fromJson()` hydration. On AOT and JS the fork alters only the UTF-8 *byte* parser (`_JsonUtf8Parser`), leaving this String path source-identical.
>
> **Encode control**: `utf8_encode_control` calls `utf8.encode(String)`. There is no JSON encode path that is source-identical across the two SDKs — the fork relocates `JsonEncoder`, `_JsonEncoderSink` and `_JsonStringStringifier` out of `json.dart` — so the encode control must be a non-JSON codec. `sdk/lib/convert/utf8.dart` is untouched and no `convert_patch.dart` references `_Utf8Encoder`.
>
> **Codebase Layout Collateral**: The source on those paths is identical in both SDKs. However, because SDK forks often relocate hundreds of lines across libraries (e.g., into `dart:_internal`), measurements may drift due to snapshot alignment and cross-library code layout shifts underneath the control. A moving control is NOT by itself proof of a contaminated run — rather, its ratio bounds **layout collateral + environmental noise**.
>
> ⚠️ **Actionable Rule: Compare each cell against its own runtime's control band, never a pooled band.** Control spread is not a fixed property of a backend, and it does not necessarily track how much of that backend the fork edited — a run in which the least-edited backend shows the widest spread and the most-edited the narrowest is evidence of apparatus noise rather than of the patch. Re-derive the band per runtime from the current run instead of carrying numbers forward from a previous one, and treat per-tier maxima from small samples as weak statistics.
>
> **Which comparisons the control actually bounds.** Tier 0 and Tier 2 run on the stock `dart` binary; Tier 1 and Tier 3 run on the fork binary. Two binaries cannot share a process, so per-build and per-process bias falls entirely on the **cross-pass** ratios — *Tier 1 vs Tier 0*, *Tier 3 vs Tier 0*, and any Tier 2 vs Tier 1/3 comparison. It **cancels** in the **same-pass** ratios: *Tier 3 vs Tier 1* (both fork) and *Tier 2 vs Tier 0* (both stock). Do not discount same-pass figures on control-drift grounds.
>
> **Sample stability**: 16 of 72 measured cells (22%) are flagged `is_robust_stable: false` by the harness. Ratios involving them are marked ⚠️ in the breakdowns below and must not be quoted as measurements.

### 🎯 AOT Target Detailed Breakdown

#### Detailed Breakdown: AOT Decode Stream (32 KB Chunks)

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Tier 0: Stock + json_serial | Tier 1: New + json_serial | Tier 2: Stock + Codable [Mock] | Tier 3: New + Codable [Native] | Tier 1 vs Tier 0 (SDK + Substrate Build) | Tier 2 vs Tier 0 (Codable on Stock) | Speedup vs Tier 0 (Stock json_serial) | Speedup vs Tier 1 (New json_serial) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 2.21 ms | 2.16 ms | 1.70 ms | **1.20 ms** | **1.03x** | **1.30x** | **1.84x** | **1.80x** |
| **canada.json (2.25 MB)** | 28.08 ms | 25.13 ms | 10.53 ms | **6.36 ms** | **1.12x** ⚠️ | **2.67x** ⚠️ | **4.41x** ⚠️ | **3.95x** ⚠️ |
| **Geometric Mean** | — | — | — | — | **1.07x** | **1.86x** | **2.85x** | **2.66x** |
<!-- mdformat on -->

> ⚠️ 1 of 2 workloads in this table draw on samples flagged `is_robust_stable: false`. The Geometric Mean includes them and inherits their uncertainty.


#### Detailed Breakdown: AOT Encode Stream (BytesBuilder / ByteConversionSink)

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Tier 0: Stock + json_serial | Tier 1: New + json_serial | Tier 2: Stock + Codable [Mock] | Tier 3: New + Codable [Native] | Tier 1 vs Tier 0 (SDK + Substrate Build) | Tier 2 vs Tier 0 (Codable on Stock) | Speedup vs Tier 0 (Stock json_serial) | Speedup vs Tier 1 (New json_serial) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 5.04 ms | 2.05 ms | 1.05 ms | **1.05 ms** | **2.46x** | **4.82x** | **4.82x** | **1.96x** |
| **canada.json (2.25 MB)** | 23.56 ms | 8.43 ms | 10.94 ms | **11.08 ms** | **2.80x** | **2.15x** | **2.13x** | **0.76x** |
| **Geometric Mean** | — | — | — | — | **2.62x** | **3.22x** | **3.20x** | **1.22x** |
<!-- mdformat on -->


------------------------------------------------------------------------

### 🎯 JS Target Detailed Breakdown

#### Detailed Breakdown: JS Decode Stream (32 KB Chunks)

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Tier 0: Stock + json_serial | Tier 1: New + json_serial | Tier 2: Stock + Codable [Mock] | Tier 3: New + Codable [Native] | Tier 1 vs Tier 0 (SDK + Substrate Build) | Tier 2 vs Tier 0 (Codable on Stock) | Speedup vs Tier 0 (Stock json_serial) | Speedup vs Tier 1 (New json_serial) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 3.88 ms | 3.85 ms | 1.52 ms | **1.52 ms** | **1.01x** | **2.55x** | **2.56x** | **2.54x** |
| **canada.json (2.25 MB)** | 33.33 ms | 30.67 ms | 8.58 ms | **9.00 ms** | **1.09x** | **3.88x** ⚠️ | **3.70x** | **3.41x** |
| **Geometric Mean** | — | — | — | — | **1.05x** | **3.15x** | **3.08x** | **2.94x** |
<!-- mdformat on -->

> ⚠️ 1 of 2 workloads in this table draw on samples flagged `is_robust_stable: false`. The Geometric Mean includes them and inherits their uncertainty.


#### Detailed Breakdown: JS Encode Stream (BytesBuilder / ByteConversionSink)

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Tier 0: Stock + json_serial | Tier 1: New + json_serial | Tier 2: Stock + Codable [Mock] | Tier 3: New + Codable [Native] | Tier 1 vs Tier 0 (SDK + Substrate Build) | Tier 2 vs Tier 0 (Codable on Stock) | Speedup vs Tier 0 (Stock json_serial) | Speedup vs Tier 1 (New json_serial) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 5.41 ms | 3.63 ms | 2.66 ms | **2.65 ms** | **1.49x** ⚠️ | **2.04x** ⚠️ | **2.04x** ⚠️ | **1.37x** |
| **canada.json (2.25 MB)** | 17.50 ms | 11.89 ms | 21.80 ms | **20.40 ms** | **1.47x** | **0.80x** | **0.86x** | **0.58x** |
| **Geometric Mean** | — | — | — | — | **1.48x** | **1.28x** | **1.32x** | **0.89x** |
<!-- mdformat on -->

> ⚠️ 1 of 2 workloads in this table draw on samples flagged `is_robust_stable: false`. The Geometric Mean includes them and inherits their uncertainty.


------------------------------------------------------------------------

### 🎯 WASM Target Detailed Breakdown

#### Detailed Breakdown: WASM Decode Stream (32 KB Chunks)

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Tier 0: Stock + json_serial | Tier 1: New + json_serial | Tier 2: Stock + Codable [Mock] | Tier 3: New + Codable [Native] | Tier 1 vs Tier 0 (SDK + Substrate Build) | Tier 2 vs Tier 0 (Codable on Stock) | Speedup vs Tier 0 (Stock json_serial) | Speedup vs Tier 1 (New json_serial) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 2.33 ms | 2.25 ms | 2.67 ms | **1.64 ms** | **1.03x** | **0.87x** | **1.42x** | **1.38x** |
| **canada.json (2.25 MB)** | 40.73 ms | 31.18 ms | 17.55 ms | **9.14 ms** | **1.31x** ⚠️ | **2.32x** ⚠️ | **4.46x** ⚠️ | **3.41x** ⚠️ |
| **Geometric Mean** | — | — | — | — | **1.16x** | **1.42x** | **2.52x** | **2.17x** |
<!-- mdformat on -->

> ⚠️ 1 of 2 workloads in this table draw on samples flagged `is_robust_stable: false`. The Geometric Mean includes them and inherits their uncertainty.


#### Detailed Breakdown: WASM Encode Stream (BytesBuilder / ByteConversionSink)

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Tier 0: Stock + json_serial | Tier 1: New + json_serial | Tier 2: Stock + Codable [Mock] | Tier 3: New + Codable [Native] | Tier 1 vs Tier 0 (SDK + Substrate Build) | Tier 2 vs Tier 0 (Codable on Stock) | Speedup vs Tier 0 (Stock json_serial) | Speedup vs Tier 1 (New json_serial) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 4.93 ms | 2.61 ms | 1.66 ms | **1.69 ms** | **1.89x** | **2.97x** | **2.91x** | **1.54x** |
| **canada.json (2.25 MB)** | 23.59 ms | 10.99 ms | 13.83 ms | **13.70 ms** | **2.15x** | **1.71x** | **1.72x** | **0.80x** |
| **Geometric Mean** | — | — | — | — | **2.01x** | **2.25x** | **2.24x** | **1.11x** |
<!-- mdformat on -->


------------------------------------------------------------------------

### 🔄 Streaming vs. Monolithic Single-Buffer Overhead (`Stream / Sink` vs. `Single Buffer`)

Compares the chunked conversion sink latency (`32 KB` slices) against the in-memory single-buffer latency (`Stream Latency / Monolithic Latency`; `1.00x` = zero streaming overhead, `< 1.00x` = streaming is faster than monolithic allocation).

<!-- mdformat off(prevent table wrapping) -->
| Target | Mode & Dataset | Tier 0 Ratio (Stream / Mono) | Tier 1 Ratio (Stream / Mono) | Tier 2 Ratio (Stream / Mono) | Tier 3 Ratio (Stream / Mono) |
| :--- | :--- | :---: | :---: | :---: | :---: |
| **AOT** | 📥 Decode `10k Coordinates (0.39 MB)` | `1.00x` (2.21 ms vs 2.21 ms) | `0.99x` (2.16 ms vs 2.18 ms) | `0.99x` (1.70 ms vs 1.71 ms) | **`1.02x` (1.20 ms vs 1.18 ms)** |
| **AOT** | 📥 Decode `canada.json (2.25 MB)` | `1.08x` (28.08 ms vs 25.88 ms) | `1.06x` (25.13 ms vs 23.81 ms) | `1.00x` (10.53 ms vs 10.52 ms) | **`0.98x` (6.36 ms vs 6.48 ms)** |
| **AOT** | 📤 Encode `10k Coordinates (0.39 MB)` | `0.91x` (5.04 ms vs 5.51 ms) | `0.80x` (2.05 ms vs 2.56 ms) | `0.69x` (1.05 ms vs 1.51 ms) | **`0.71x` (1.05 ms vs 1.46 ms)** |
| **AOT** | 📤 Encode `canada.json (2.25 MB)` | `0.95x` (23.56 ms vs 24.72 ms) | `0.78x` (8.43 ms vs 10.74 ms) | `0.80x` (10.94 ms vs 13.62 ms) | **`0.81x` (11.08 ms vs 13.70 ms)** |
| **JS** | 📥 Decode `10k Coordinates (0.39 MB)` | `1.52x` (3.88 ms vs 2.55 ms) | `1.52x` (3.85 ms vs 2.52 ms) | `1.02x` (1.52 ms vs 1.49 ms) | **`1.02x` (1.52 ms vs 1.49 ms)** |
| **JS** | 📥 Decode `canada.json (2.25 MB)` | `1.16x` (33.33 ms vs 28.75 ms) | `1.17x` (30.67 ms vs 26.25 ms) | `0.99x` (8.58 ms vs 8.64 ms) | **`1.00x` (9.00 ms vs 9.00 ms)** |
| **JS** | 📤 Encode `10k Coordinates (0.39 MB)` | `1.14x` (5.41 ms vs 4.75 ms) | `1.01x` (3.63 ms vs 3.61 ms) | `1.64x` (2.66 ms vs 1.62 ms) | **`1.57x` (2.65 ms vs 1.68 ms)** |
| **JS** | 📤 Encode `canada.json (2.25 MB)` | `0.96x` (17.50 ms vs 18.20 ms) | `0.91x` (11.89 ms vs 13.13 ms) | `1.71x` (21.80 ms vs 12.75 ms) | **`1.60x` (20.40 ms vs 12.75 ms)** |
| **WASM** | 📥 Decode `10k Coordinates (0.39 MB)` | `0.92x` (2.33 ms vs 2.53 ms) | `1.01x` (2.25 ms vs 2.24 ms) | `1.00x` (2.67 ms vs 2.65 ms) | **`1.02x` (1.64 ms vs 1.60 ms)** |
| **WASM** | 📥 Decode `canada.json (2.25 MB)` | `1.03x` (40.73 ms vs 39.59 ms) | `1.16x` (31.18 ms vs 26.79 ms) | `0.97x` (17.55 ms vs 18.09 ms) | **`1.08x` (9.14 ms vs 8.50 ms)** |
| **WASM** | 📤 Encode `10k Coordinates (0.39 MB)` | `0.92x` (4.93 ms vs 5.38 ms) | `0.91x` (2.61 ms vs 2.86 ms) | `0.85x` (1.66 ms vs 1.96 ms) | **`0.84x` (1.69 ms vs 2.03 ms)** |
| **WASM** | 📤 Encode `canada.json (2.25 MB)` | `0.91x` (23.59 ms vs 25.83 ms) | `0.88x` (10.99 ms vs 12.44 ms) | `0.78x` (13.83 ms vs 17.84 ms) | **`0.80x` (13.70 ms vs 17.17 ms)** |
<!-- mdformat on -->

------------------------------------------------------------------------

### 🔬 Methodology & Caveats

- Every cell is the **median** of the trial count listed in the provenance
  header.
  - **Tier 0 (`Stock Dart + json_serializable`)** and **Tier 2 (`Stock Dart + Codable [Mock]`)** are compiled and executed in a dedicated Stock Dart pass with `substrate.dart` switched to `mock`.
  - **Tier 1 (`New Dart + json_serializable`)** and **Tier 3 (`New Dart + Codable [Native]`)** are compiled and executed in the `native_kernels` pass with `substrate.dart` switched to `native`.
- **Use `median`, not `min`.** `min` reports whichever configuration drew the
  single luckiest trial. On multimodal workloads that is enough to flip the
  sign of a comparison, so `--metric median` is the default. Regenerating this
  report with `--metric min` is a diagnostic, not a publication.
- **`Tier 1 vs Tier 0` is not an SDK-only comparison.** The two passes differ by
  SDK *and* by substrate build (`mock` vs `native`), because the native
  substrate re-exports symbols that only exist in the forked SDK and cannot be
  compiled by stock Dart. The binaries therefore differ in retained code and
  layout even for candidates that never call the substrate. Read that column as
  *SDK + build configuration*, never as an isolated SDK delta.
- **Stability gate**: cells the harness flagged `is_robust_stable: false` have
  their derived ratios marked ⚠️. A marked ratio is not a measurement. See the
  *Measurement Controls & Resolution Floor* section for the run-wide count and
  the unchanged-code control drift.
- **Dual Speedup Baselines**:
  - **Speedup vs Tier 0 (`Stock Dart + json_serializable`)**: Measures total end-to-end speedup over out-of-the-box Stock Dart.
  - **Speedup vs Tier 1 (`New Dart + json_serializable`)**: Measures the isolated streaming vs. DOM mapping speedup on the identical upgraded SDK.
- **Resolution limit**: at 10–15 trials this harness cannot reliably resolve
  latency deltas below roughly **10%**. Run-to-run drift is large enough to
  flip the sign of small effects. Treat any speedup between `0.90x` and
  `1.10x` as *no measured difference*.
- **Single invocation**: every cell comes from one process launch. Workloads
  whose launch-to-launch distribution is multimodal cannot be resolved at any
  estimator from a single invocation; they need repeated launches with a
  median-of-medians aggregate.

