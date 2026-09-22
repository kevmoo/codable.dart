## 🌊 Streaming Benchmark Report (`ChunkedConversionSink` / `ByteConversionSink`)

### 📝 Provenance

- **Run Timestamp**: 2026-09-21T23:12:46.756Z
- **Stock Dart SDK (Tier 0 & Tier 2)**: 3.14.0-248.0.dev (dev) (Sat Sep 19 01:09:06 2026 -0700) on "linux_x64"
- **New Dart SDK (Tier 1 & Tier 3)**: 3.14.0-json-next.c52b7fecede9a0324612382bdfe02bd0d793d6c0 (main) (Mon Sep 21 10:53:03 2026 -0700) on "linux_x64"
- **Repo Commit**: 5582224fe5589c940ffdf3957a4b1e1206ad1bb1
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
| **AOT (`dart compile exe`)** | **Tier 0: `Stock + json_serial`** | 🔴 `[ 33 / 54 / 89 ]` | **1.00x** / **0.81x** | 🔴 `[ 23 / 29 / 36 ]` | **1.00x** / **0.39x** |
| **AOT (`dart compile exe`)** | **Tier 1: `New + json_serial`** | 🔴 `[ 48 / 66 / 92 ]` | **1.23x** / **1.00x** | 🟡 `[ 56 / 75 / 100 ]` | **2.59x** / **1.00x** |
| **AOT (`dart compile exe`)** | **Tier 2: `Stock + Codable [Mock]`** | 🟡 `[ 71 / 72 / 74 ]` | **1.33x** / **1.09x** | 🟢 `[ 84 / 91 / 100 ]` | **3.16x** / **1.22x** |
| **AOT (`dart compile exe`)** | **Tier 3: `New + Codable [Native]`** | 🟢 `[ 100 / 100 / 100 ]` | **1.85x** / **1.51x** | 🟢 `[ 83 / 90 / 98 ]` | **3.11x** / **1.20x** |
| **JS (`dart2js` / Node 24 / V8)** | **Tier 0: `Stock + json_serial`** | 🔴 `[ 27 / 33 / 40 ]` | **1.00x** / **1.01x** | 🔴 `[ 60 / 60 / 60 ]` | **1.00x** / **0.66x** |
| **JS (`dart2js` / Node 24 / V8)** | **Tier 1: `New + json_serial`** | 🔴 `[ 27 / 33 / 40 ]` | **0.99x** / **1.00x** | 🟢 `[ 82 / 90 / 100 ]` | **1.51x** / **1.00x** |
| **JS (`dart2js` / Node 24 / V8)** | **Tier 2: `Stock + Codable [Mock]`** | 🟢 `[ 99 / 100 / 100 ]` | **3.02x** / **3.04x** | 🟡 `[ 64 / 77 / 93 ]` | **1.30x** / **0.86x** |
| **JS (`dart2js` / Node 24 / V8)** | **Tier 3: `New + Codable [Native]`** | 🟢 `[ 100 / 100 / 100 ]` | **3.03x** / **3.05x** | 🟡 `[ 64 / 80 / 100 ]` | **1.34x** / **0.88x** |
| **WASM (`dart2wasm` / Node 24 / V8)** | **Tier 0: `Stock + json_serial`** | 🔴 `[ 43 / 66 / 100 ]` | **1.00x** / **0.85x** | 🔴 `[ 42 / 43 / 45 ]` | **1.00x** / **0.49x** |
| **WASM (`dart2wasm` / Node 24 / V8)** | **Tier 1: `New + json_serial`** | 🟡 `[ 59 / 77 / 100 ]` | **1.17x** / **1.00x** | 🟡 `[ 80 / 89 / 100 ]` | **2.05x** / **1.00x** |
| **WASM (`dart2wasm` / Node 24 / V8)** | **Tier 2: `Stock + Codable [Mock]`** | 🔴 `[ 21 / 22 / 23 ]` | **0.33x** / **0.28x** | 🟡 `[ 80 / 89 / 99 ]` | **2.05x** / **1.00x** |
| **WASM (`dart2wasm` / Node 24 / V8)** | **Tier 3: `New + Codable [Native]`** | 🟡 `[ 52 / 72 / 100 ]` | **1.09x** / **0.93x** | 🟢 `[ 89 / 94 / 100 ]` | **2.17x** / **1.06x** |
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
| **AOT** | **0.995x** | `[0.980, 1.010]` |
| **JS** | **1.023x** | `[1.035, 1.011]` |
| **WASM** | **0.968x** | `[0.992, 0.944]` |
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
> **Sample stability**: 7 of 72 measured cells (10%) are flagged `is_robust_stable: false` by the harness. Ratios involving them are marked ⚠️ in the breakdowns below and must not be quoted as measurements.

### 🎯 AOT Target Detailed Breakdown

#### Detailed Breakdown: AOT Decode Stream (32 KB Chunks)

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Tier 0: Stock + json_serial | Tier 1: New + json_serial | Tier 2: Stock + Codable [Mock] | Tier 3: New + Codable [Native] | Tier 1 vs Tier 0 (SDK + Substrate Build) | Tier 2 vs Tier 0 (Codable on Stock) | Speedup vs Tier 0 (Stock json_serial) | Speedup vs Tier 1 (New json_serial) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 2.21 ms | 2.14 ms | 2.68 ms | **1.97 ms** | **1.03x** | **0.83x** | **1.12x** | **1.09x** |
| **canada.json (2.25 MB)** | 27.98 ms | 19.14 ms | 12.97 ms | **9.16 ms** | **1.46x** ⚠️ | **2.16x** | **3.05x** | **2.09x** ⚠️ |
| **Geometric Mean** | — | — | — | — | **1.23x** | **1.33x** | **1.85x** | **1.51x** |
<!-- mdformat on -->

> ⚠️ 1 of 2 workloads in this table draw on samples flagged `is_robust_stable: false`. The Geometric Mean includes them and inherits their uncertainty.


#### Detailed Breakdown: AOT Encode Stream (BytesBuilder / ByteConversionSink)

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Tier 0: Stock + json_serial | Tier 1: New + json_serial | Tier 2: Stock + Codable [Mock] | Tier 3: New + Codable [Native] | Tier 1 vs Tier 0 (SDK + Substrate Build) | Tier 2 vs Tier 0 (Codable on Stock) | Speedup vs Tier 0 (Stock json_serial) | Speedup vs Tier 1 (New json_serial) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 4.96 ms | 2.04 ms | 1.15 ms | **1.17 ms** | **2.43x** | **4.32x** | **4.25x** | **1.75x** |
| **canada.json (2.25 MB)** | 23.48 ms | 8.52 ms | 10.20 ms | **10.32 ms** | **2.76x** | **2.30x** | **2.27x** | **0.83x** |
| **Geometric Mean** | — | — | — | — | **2.59x** | **3.16x** | **3.11x** | **1.20x** |
<!-- mdformat on -->


------------------------------------------------------------------------

### 🎯 JS Target Detailed Breakdown

#### Detailed Breakdown: JS Decode Stream (32 KB Chunks)

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Tier 0: Stock + json_serial | Tier 1: New + json_serial | Tier 2: Stock + Codable [Mock] | Tier 3: New + Codable [Native] | Tier 1 vs Tier 0 (SDK + Substrate Build) | Tier 2 vs Tier 0 (Codable on Stock) | Speedup vs Tier 0 (Stock json_serial) | Speedup vs Tier 1 (New json_serial) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 3.85 ms | 3.81 ms | 1.54 ms | **1.54 ms** | **1.01x** | **2.50x** | **2.50x** | **2.47x** |
| **canada.json (2.25 MB)** | 30.67 ms | 31.33 ms | 8.42 ms | **8.33 ms** | **0.98x** ⚠️ | **3.64x** | **3.68x** | **3.76x** ⚠️ |
| **Geometric Mean** | — | — | — | — | **0.99x** | **3.02x** | **3.03x** | **3.05x** |
<!-- mdformat on -->

> ⚠️ 1 of 2 workloads in this table draw on samples flagged `is_robust_stable: false`. The Geometric Mean includes them and inherits their uncertainty.


#### Detailed Breakdown: JS Encode Stream (BytesBuilder / ByteConversionSink)

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Tier 0: Stock + json_serial | Tier 1: New + json_serial | Tier 2: Stock + Codable [Mock] | Tier 3: New + Codable [Native] | Tier 1 vs Tier 0 (SDK + Substrate Build) | Tier 2 vs Tier 0 (Codable on Stock) | Speedup vs Tier 0 (Stock json_serial) | Speedup vs Tier 1 (New json_serial) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 5.00 ms | 3.67 ms | 3.23 ms | **3.00 ms** | **1.36x** | **1.55x** | **1.67x** | **1.22x** |
| **canada.json (2.25 MB)** | 21.00 ms | 12.50 ms | 19.40 ms | **19.60 ms** | **1.68x** | **1.08x** | **1.07x** | **0.64x** |
| **Geometric Mean** | — | — | — | — | **1.51x** | **1.30x** | **1.34x** | **0.88x** |
<!-- mdformat on -->


------------------------------------------------------------------------

### 🎯 WASM Target Detailed Breakdown

#### Detailed Breakdown: WASM Decode Stream (32 KB Chunks)

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Tier 0: Stock + json_serial | Tier 1: New + json_serial | Tier 2: Stock + Codable [Mock] | Tier 3: New + Codable [Native] | Tier 1 vs Tier 0 (SDK + Substrate Build) | Tier 2 vs Tier 0 (Codable on Stock) | Speedup vs Tier 0 (Stock json_serial) | Speedup vs Tier 1 (New json_serial) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 2.27 ms | 2.27 ms | 9.88 ms | **4.40 ms** | **1.00x** | **0.23x** | **0.52x** | **0.52x** |
| **canada.json (2.25 MB)** | 33.96 ms | 24.75 ms | 70.14 ms | **14.66 ms** | **1.37x** ⚠️ | **0.48x** ⚠️ | **2.32x** ⚠️ | **1.69x** |
| **Geometric Mean** | — | — | — | — | **1.17x** | **0.33x** | **1.09x** | **0.93x** |
<!-- mdformat on -->

> ⚠️ 1 of 2 workloads in this table draw on samples flagged `is_robust_stable: false`. The Geometric Mean includes them and inherits their uncertainty.


#### Detailed Breakdown: WASM Encode Stream (BytesBuilder / ByteConversionSink)

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Tier 0: Stock + json_serial | Tier 1: New + json_serial | Tier 2: Stock + Codable [Mock] | Tier 3: New + Codable [Native] | Tier 1 vs Tier 0 (SDK + Substrate Build) | Tier 2 vs Tier 0 (Codable on Stock) | Speedup vs Tier 0 (Stock json_serial) | Speedup vs Tier 1 (New json_serial) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 4.92 ms | 2.60 ms | 2.09 ms | **2.07 ms** | **1.89x** | **2.36x** | **2.38x** | **1.26x** |
| **canada.json (2.25 MB)** | 24.70 ms | 11.11 ms | 13.82 ms | **12.44 ms** | **2.22x** | **1.79x** | **1.99x** | **0.89x** |
| **Geometric Mean** | — | — | — | — | **2.05x** | **2.05x** | **2.17x** | **1.06x** |
<!-- mdformat on -->


------------------------------------------------------------------------

### 🔄 Streaming vs. Monolithic Single-Buffer Overhead (`Stream / Sink` vs. `Single Buffer`)

Compares the chunked conversion sink latency (`32 KB` slices) against the in-memory single-buffer latency (`Stream Latency / Monolithic Latency`; `1.00x` = zero streaming overhead, `< 1.00x` = streaming is faster than monolithic allocation).

<!-- mdformat off(prevent table wrapping) -->
| Target | Mode & Dataset | Tier 0 Ratio (Stream / Mono) | Tier 1 Ratio (Stream / Mono) | Tier 2 Ratio (Stream / Mono) | Tier 3 Ratio (Stream / Mono) |
| :--- | :--- | :---: | :---: | :---: | :---: |
| **AOT** | 📥 Decode `10k Coordinates (0.39 MB)` | `1.00x` (2.21 ms vs 2.21 ms) | `1.00x` (2.14 ms vs 2.14 ms) | `1.36x` (2.68 ms vs 1.98 ms) | **`1.36x` (1.97 ms vs 1.45 ms)** |
| **AOT** | 📥 Decode `canada.json (2.25 MB)` | `1.01x` (27.98 ms vs 27.59 ms) | `0.99x` (19.14 ms vs 19.25 ms) | `1.24x` (12.97 ms vs 10.43 ms) | **`1.40x` (9.16 ms vs 6.52 ms)** |
| **AOT** | 📤 Encode `10k Coordinates (0.39 MB)` | `0.90x` (4.96 ms vs 5.51 ms) | `0.79x` (2.04 ms vs 2.57 ms) | `0.79x` (1.15 ms vs 1.44 ms) | **`0.80x` (1.17 ms vs 1.46 ms)** |
| **AOT** | 📤 Encode `canada.json (2.25 MB)` | `0.86x` (23.48 ms vs 27.25 ms) | `0.80x` (8.52 ms vs 10.68 ms) | `0.80x` (10.20 ms vs 12.81 ms) | **`0.82x` (10.32 ms vs 12.53 ms)** |
| **JS** | 📥 Decode `10k Coordinates (0.39 MB)` | `1.54x` (3.85 ms vs 2.50 ms) | `1.46x` (3.81 ms vs 2.62 ms) | `1.04x` (1.54 ms vs 1.48 ms) | **`1.04x` (1.54 ms vs 1.48 ms)** |
| **JS** | 📥 Decode `canada.json (2.25 MB)` | `1.32x` (30.67 ms vs 23.25 ms) | `1.21x` (31.33 ms vs 26.00 ms) | `1.03x` (8.42 ms vs 8.15 ms) | **`1.01x` (8.33 ms vs 8.23 ms)** |
| **JS** | 📤 Encode `10k Coordinates (0.39 MB)` | `1.06x` (5.00 ms vs 4.73 ms) | `1.06x` (3.67 ms vs 3.45 ms) | `2.26x` (3.23 ms vs 1.43 ms) | **`2.11x` (3.00 ms vs 1.42 ms)** |
| **JS** | 📤 Encode `canada.json (2.25 MB)` | `1.16x` (21.00 ms vs 18.17 ms) | `0.92x` (12.50 ms vs 13.63 ms) | `1.76x` (19.40 ms vs 11.00 ms) | **`1.80x` (19.60 ms vs 10.89 ms)** |
| **WASM** | 📥 Decode `10k Coordinates (0.39 MB)` | `0.98x` (2.27 ms vs 2.31 ms) | `1.01x` (2.27 ms vs 2.24 ms) | `3.65x` (9.88 ms vs 2.71 ms) | **`2.59x` (4.40 ms vs 1.69 ms)** |
| **WASM** | 📥 Decode `canada.json (2.25 MB)` | `0.98x` (33.96 ms vs 34.53 ms) | `0.98x` (24.75 ms vs 25.33 ms) | `4.31x` (70.14 ms vs 16.29 ms) | **`1.67x` (14.66 ms vs 8.81 ms)** |
| **WASM** | 📤 Encode `10k Coordinates (0.39 MB)` | `0.92x` (4.92 ms vs 5.33 ms) | `0.92x` (2.60 ms vs 2.83 ms) | `1.08x` (2.09 ms vs 1.93 ms) | **`1.10x` (2.07 ms vs 1.87 ms)** |
| **WASM** | 📤 Encode `canada.json (2.25 MB)` | `0.92x` (24.70 ms vs 26.84 ms) | `0.89x` (11.11 ms vs 12.51 ms) | `0.94x` (13.82 ms vs 14.72 ms) | **`0.85x` (12.44 ms vs 14.71 ms)** |
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

