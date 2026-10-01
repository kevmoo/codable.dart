## 🌊 Streaming Benchmark Report (`ChunkedConversionSink` / `ByteConversionSink`)

### 📝 Provenance

- **Run Timestamp**: 2026-10-01T23:49:25.721Z
- **Stock Dart SDK (Tier 0 & Tier 2)**: 3.14.0-271.0.dev (dev) (Fri Sep 25 05:03:10 2026 -0700) on "linux_x64"
- **New Dart SDK (Tier 1 & Tier 3)**: 3.14.0-json-next.c52b7fecede9a0324612382bdfe02bd0d793d6c0 (main) (Mon Sep 21 10:53:03 2026 -0700) on "linux_x64"
- **Repo Commit**: 4bde690b0e1ec50293248f580d4b27c8e74faa6e
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
| **AOT (`dart compile exe`)** | **Tier 0: `Stock + json_serial`** | 🔴 `[ 23 / 35 / 54 ]` | **1.00x** / **0.89x** | 🔴 `[ 21 / 28 / 36 ]` | **1.00x** / **0.39x** |
| **AOT (`dart compile exe`)** | **Tier 1: `New + json_serial`** | 🔴 `[ 29 / 40 / 55 ]` | **1.13x** / **1.00x** | 🟡 `[ 52 / 72 / 100 ]` | **2.59x** / **1.00x** |
| **AOT (`dart compile exe`)** | **Tier 2: `Stock + Codable [Mock]`** | 🔴 `[ 59 / 65 / 71 ]` | **1.82x** / **1.62x** | 🟡 `[ 78 / 88 / 100 ]` | **3.19x** / **1.23x** |
| **AOT (`dart compile exe`)** | **Tier 3: `New + Codable [Native]`** | 🟢 `[ 100 / 100 / 100 ]` | **2.82x** / **2.51x** | 🟡 `[ 73 / 85 / 100 ]` | **3.08x** / **1.19x** |
| **JS (`dart2js` / Node 24 / V8)** | **Tier 0: `Stock + json_serial`** | 🔴 `[ 26 / 32 / 38 ]` | **1.00x** / **0.98x** | 🔴 `[ 55 / 62 / 69 ]` | **1.00x** / **0.72x** |
| **JS (`dart2js` / Node 24 / V8)** | **Tier 1: `New + json_serial`** | 🔴 `[ 28 / 32 / 38 ]` | **1.02x** / **1.00x** | 🟡 `[ 73 / 86 / 100 ]` | **1.39x** / **1.00x** |
| **JS (`dart2js` / Node 24 / V8)** | **Tier 2: `Stock + Codable [Mock]`** | 🟢 `[ 99 / 100 / 100 ]` | **3.14x** / **3.07x** | 🟡 `[ 59 / 77 / 100 ]` | **1.25x** / **0.90x** |
| **JS (`dart2js` / Node 24 / V8)** | **Tier 3: `New + Codable [Native]`** | 🟢 `[ 99 / 100 / 100 ]` | **3.14x** / **3.07x** | 🟡 `[ 58 / 76 / 100 ]` | **1.24x** / **0.89x** |
| **WASM (`dart2wasm` / Node 24 / V8)** | **Tier 0: `Stock + json_serial`** | 🔴 `[ 24 / 42 / 74 ]` | **1.00x** / **0.84x** | 🔴 `[ 33 / 39 / 45 ]` | **1.00x** / **0.49x** |
| **WASM (`dart2wasm` / Node 24 / V8)** | **Tier 1: `New + json_serial`** | 🔴 `[ 41 / 50 / 61 ]` | **1.20x** / **1.00x** | 🟡 `[ 64 / 80 / 100 ]` | **2.05x** / **1.00x** |
| **WASM (`dart2wasm` / Node 24 / V8)** | **Tier 2: `Stock + Codable [Mock]`** | 🔴 `[ 55 / 61 / 68 ]` | **1.47x** / **1.23x** | 🟡 `[ 77 / 88 / 100 ]` | **2.25x** / **1.10x** |
| **WASM (`dart2wasm` / Node 24 / V8)** | **Tier 3: `New + Codable [Native]`** | 🟢 `[ 100 / 100 / 100 ]` | **2.39x** / **2.00x** | 🟡 `[ 78 / 88 / 99 ]` | **2.26x** / **1.10x** |
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
| **AOT** | **0.988x** | `[0.996, 0.981]` |
| **JS** | **0.945x** | `[0.970, 0.921]` |
| **WASM** | **0.794x** | `[0.581, 1.086]` |
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
> **Sample stability**: 10 of 72 measured cells (14%) are flagged `is_robust_stable: false` by the harness. Ratios involving them are marked ⚠️ in the breakdowns below and must not be quoted as measurements.

### 🎯 AOT Target Detailed Breakdown

#### Detailed Breakdown: AOT Decode Stream (32 KB Chunks)

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Tier 0: Stock + json_serial | Tier 1: New + json_serial | Tier 2: Stock + Codable [Mock] | Tier 3: New + Codable [Native] | Tier 1 vs Tier 0 (SDK + Substrate Build) | Tier 2 vs Tier 0 (Codable on Stock) | Speedup vs Tier 0 (Stock json_serial) | Speedup vs Tier 1 (New json_serial) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 2.21 ms | 2.16 ms | 1.70 ms | **1.20 ms** | **1.02x** | **1.30x** | **1.84x** | **1.80x** |
| **canada.json (2.25 MB)** | 27.22 ms | 21.89 ms | 10.67 ms | **6.29 ms** | **1.24x** ⚠️ | **2.55x** | **4.33x** | **3.48x** ⚠️ |
| **Geometric Mean** | — | — | — | — | **1.13x** | **1.82x** | **2.82x** | **2.51x** |
<!-- mdformat on -->

> ⚠️ 1 of 2 workloads in this table draw on samples flagged `is_robust_stable: false`. The Geometric Mean includes them and inherits their uncertainty.


#### Detailed Breakdown: AOT Encode Stream (BytesBuilder / ByteConversionSink)

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Tier 0: Stock + json_serial | Tier 1: New + json_serial | Tier 2: Stock + Codable [Mock] | Tier 3: New + Codable [Native] | Tier 1 vs Tier 0 (SDK + Substrate Build) | Tier 2 vs Tier 0 (Codable on Stock) | Speedup vs Tier 0 (Stock json_serial) | Speedup vs Tier 1 (New json_serial) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 4.88 ms | 2.02 ms | 1.04 ms | **1.05 ms** | **2.42x** | **4.68x** | **4.67x** | **1.93x** |
| **canada.json (2.25 MB)** | 23.70 ms | 8.51 ms | 10.94 ms | **11.70 ms** | **2.78x** | **2.17x** | **2.03x** | **0.73x** |
| **Geometric Mean** | — | — | — | — | **2.59x** | **3.19x** | **3.08x** | **1.19x** |
<!-- mdformat on -->


------------------------------------------------------------------------

### 🎯 JS Target Detailed Breakdown

#### Detailed Breakdown: JS Decode Stream (32 KB Chunks)

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Tier 0: Stock + json_serial | Tier 1: New + json_serial | Tier 2: Stock + Codable [Mock] | Tier 3: New + Codable [Native] | Tier 1 vs Tier 0 (SDK + Substrate Build) | Tier 2 vs Tier 0 (Codable on Stock) | Speedup vs Tier 0 (Stock json_serial) | Speedup vs Tier 1 (New json_serial) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 3.88 ms | 3.92 ms | 1.50 ms | **1.49 ms** | **0.99x** | **2.59x** | **2.60x** | **2.63x** |
| **canada.json (2.25 MB)** | 32.67 ms | 31.00 ms | 8.58 ms | **8.64 ms** | **1.05x** | **3.81x** | **3.78x** | **3.59x** |
| **Geometric Mean** | — | — | — | — | **1.02x** | **3.14x** | **3.14x** | **3.07x** |
<!-- mdformat on -->


#### Detailed Breakdown: JS Encode Stream (BytesBuilder / ByteConversionSink)

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Tier 0: Stock + json_serial | Tier 1: New + json_serial | Tier 2: Stock + Codable [Mock] | Tier 3: New + Codable [Native] | Tier 1 vs Tier 0 (SDK + Substrate Build) | Tier 2 vs Tier 0 (Codable on Stock) | Speedup vs Tier 0 (Stock json_serial) | Speedup vs Tier 1 (New json_serial) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 4.86 ms | 3.67 ms | 2.68 ms | **2.69 ms** | **1.32x** | **1.81x** | **1.80x** | **1.36x** |
| **canada.json (2.25 MB)** | 17.50 ms | 12.00 ms | 20.40 ms | **20.60 ms** | **1.46x** | **0.86x** | **0.85x** | **0.58x** |
| **Geometric Mean** | — | — | — | — | **1.39x** | **1.25x** | **1.24x** | **0.89x** |
<!-- mdformat on -->


------------------------------------------------------------------------

### 🎯 WASM Target Detailed Breakdown

#### Detailed Breakdown: WASM Decode Stream (32 KB Chunks)

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Tier 0: Stock + json_serial | Tier 1: New + json_serial | Tier 2: Stock + Codable [Mock] | Tier 3: New + Codable [Native] | Tier 1 vs Tier 0 (SDK + Substrate Build) | Tier 2 vs Tier 0 (Codable on Stock) | Speedup vs Tier 0 (Stock json_serial) | Speedup vs Tier 1 (New json_serial) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 2.39 ms | 2.91 ms | 2.58 ms | **1.76 ms** | **0.82x** | **0.93x** | **1.35x** | **1.65x** |
| **canada.json (2.25 MB)** | 41.00 ms | 23.53 ms | 17.62 ms | **9.72 ms** | **1.74x** ⚠️ | **2.33x** ⚠️ | **4.22x** ⚠️ | **2.42x** ⚠️ |
| **Geometric Mean** | — | — | — | — | **1.20x** | **1.47x** | **2.39x** | **2.00x** |
<!-- mdformat on -->

> ⚠️ 1 of 2 workloads in this table draw on samples flagged `is_robust_stable: false`. The Geometric Mean includes them and inherits their uncertainty.


#### Detailed Breakdown: WASM Encode Stream (BytesBuilder / ByteConversionSink)

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Tier 0: Stock + json_serial | Tier 1: New + json_serial | Tier 2: Stock + Codable [Mock] | Tier 3: New + Codable [Native] | Tier 1 vs Tier 0 (SDK + Substrate Build) | Tier 2 vs Tier 0 (Codable on Stock) | Speedup vs Tier 0 (Stock json_serial) | Speedup vs Tier 1 (New json_serial) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 4.95 ms | 2.58 ms | 1.65 ms | **1.67 ms** | **1.92x** | **3.00x** | **2.96x** | **1.55x** |
| **canada.json (2.25 MB)** | 23.62 ms | 10.74 ms | 13.93 ms | **13.75 ms** | **2.20x** | **1.70x** | **1.72x** | **0.78x** |
| **Geometric Mean** | — | — | — | — | **2.05x** | **2.25x** | **2.26x** | **1.10x** |
<!-- mdformat on -->


------------------------------------------------------------------------

### 🔄 Streaming vs. Monolithic Single-Buffer Overhead (`Stream / Sink` vs. `Single Buffer`)

Compares the chunked conversion sink latency (`32 KB` slices) against the in-memory single-buffer latency (`Stream Latency / Monolithic Latency`; `1.00x` = zero streaming overhead, `< 1.00x` = streaming is faster than monolithic allocation).

<!-- mdformat off(prevent table wrapping) -->
| Target | Mode & Dataset | Tier 0 Ratio (Stream / Mono) | Tier 1 Ratio (Stream / Mono) | Tier 2 Ratio (Stream / Mono) | Tier 3 Ratio (Stream / Mono) |
| :--- | :--- | :---: | :---: | :---: | :---: |
| **AOT** | 📥 Decode `10k Coordinates (0.39 MB)` | `1.02x` (2.21 ms vs 2.16 ms) | `1.00x` (2.16 ms vs 2.15 ms) | `1.00x` (1.70 ms vs 1.69 ms) | **`1.02x` (1.20 ms vs 1.18 ms)** |
| **AOT** | 📥 Decode `canada.json (2.25 MB)` | `0.86x` (27.22 ms vs 31.68 ms) | `1.02x` (21.89 ms vs 21.53 ms) | `1.03x` (10.67 ms vs 10.32 ms) | **`0.97x` (6.29 ms vs 6.47 ms)** |
| **AOT** | 📤 Encode `10k Coordinates (0.39 MB)` | `0.91x` (4.88 ms vs 5.39 ms) | `0.77x` (2.02 ms vs 2.62 ms) | `0.65x` (1.04 ms vs 1.62 ms) | **`0.71x` (1.05 ms vs 1.46 ms)** |
| **AOT** | 📤 Encode `canada.json (2.25 MB)` | `0.90x` (23.70 ms vs 26.37 ms) | `0.79x` (8.51 ms vs 10.76 ms) | `0.81x` (10.94 ms vs 13.51 ms) | **`0.84x` (11.70 ms vs 13.96 ms)** |
| **JS** | 📥 Decode `10k Coordinates (0.39 MB)` | `1.53x` (3.88 ms vs 2.54 ms) | `1.51x` (3.92 ms vs 2.59 ms) | `1.01x` (1.50 ms vs 1.49 ms) | **`1.01x` (1.49 ms vs 1.48 ms)** |
| **JS** | 📥 Decode `canada.json (2.25 MB)` | `1.34x` (32.67 ms vs 24.33 ms) | `1.22x` (31.00 ms vs 25.50 ms) | `1.00x` (8.58 ms vs 8.55 ms) | **`1.02x` (8.64 ms vs 8.50 ms)** |
| **JS** | 📤 Encode `10k Coordinates (0.39 MB)` | `1.04x` (4.86 ms vs 4.67 ms) | `1.01x` (3.67 ms vs 3.62 ms) | `1.70x` (2.68 ms vs 1.58 ms) | **`1.68x` (2.69 ms vs 1.60 ms)** |
| **JS** | 📤 Encode `canada.json (2.25 MB)` | `0.92x` (17.50 ms vs 19.00 ms) | `0.78x` (12.00 ms vs 15.38 ms) | `1.67x` (20.40 ms vs 12.25 ms) | **`1.68x` (20.60 ms vs 12.25 ms)** |
| **WASM** | 📥 Decode `10k Coordinates (0.39 MB)` | `1.02x` (2.39 ms vs 2.35 ms) | `1.28x` (2.91 ms vs 2.28 ms) | `0.98x` (2.58 ms vs 2.63 ms) | **`1.10x` (1.76 ms vs 1.60 ms)** |
| **WASM** | 📥 Decode `canada.json (2.25 MB)` | `1.04x` (41.00 ms vs 39.46 ms) | `0.75x` (23.53 ms vs 31.27 ms) | `1.01x` (17.62 ms vs 17.43 ms) | **`1.03x` (9.72 ms vs 9.40 ms)** |
| **WASM** | 📤 Encode `10k Coordinates (0.39 MB)` | `0.92x` (4.95 ms vs 5.36 ms) | `0.91x` (2.58 ms vs 2.84 ms) | `0.85x` (1.65 ms vs 1.94 ms) | **`0.87x` (1.67 ms vs 1.92 ms)** |
| **WASM** | 📤 Encode `canada.json (2.25 MB)` | `0.87x` (23.62 ms vs 27.04 ms) | `0.88x` (10.74 ms vs 12.18 ms) | `0.79x` (13.93 ms vs 17.70 ms) | **`0.81x` (13.75 ms vs 16.93 ms)** |
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

