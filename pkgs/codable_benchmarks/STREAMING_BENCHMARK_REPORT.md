## 🌊 Streaming Benchmark Report (`ChunkedConversionSink` / `ByteConversionSink`)

### 📝 Provenance

- **Run Timestamp**: 2026-09-19T20:37:01.130Z
- **Stock Dart SDK (Tier 0 & Tier 2)**: 3.14.0-241.0.dev (dev) (Thu Sep 17 17:06:19 2026 -0700) on "linux_x64"
- **New Dart SDK (Tier 1 & Tier 3)**: 3.14.0-json-next.04411fb24e8ed6395eb858265d1214c192d23419 (main) (Fri Sep 18 23:25:20 2026 -0700) on "linux_x64"
- **Repo Commit**: 7136bcffa52b42363bf45b551e22367a7ab2471c
- **Host OS**: linux, Hostname: kevmoo.c.googlers.com
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
| **AOT (`dart compile exe`)** | **Tier 0: `Stock + json_serial`** | 🔴 `[ 31 / 52 / 85 ]` | **1.00x** / **1.01x** | 🔴 `[ 26 / 35 / 48 ]` | **1.00x** / **0.46x** |
| **AOT (`dart compile exe`)** | **Tier 1: `New + json_serial`** | 🔴 `[ 29 / 51 / 92 ]` | **0.99x** / **1.00x** | 🟡 `[ 58 / 76 / 99 ]` | **2.16x** / **1.00x** |
| **AOT (`dart compile exe`)** | **Tier 2: `Stock + Codable [Mock]`** | 🔴 `[ 62 / 69 / 76 ]` | **1.33x** / **1.34x** | 🟢 `[ 96 / 96 / 97 ]` | **2.73x** / **1.27x** |
| **AOT (`dart compile exe`)** | **Tier 3: `New + Codable [Native]`** | 🟢 `[ 100 / 100 / 100 ]` | **1.93x** / **1.95x** | 🟢 `[ 100 / 100 / 100 ]` | **2.84x** / **1.32x** |
| **JS (`dart2js` / Node 24 / V8)** | **Tier 0: `Stock + json_serial`** | 🔴 `[ 29 / 34 / 38 ]` | **1.00x** / **1.04x** | 🟡 `[ 63 / 80 / 100 ]` | **1.00x** / **0.90x** |
| **JS (`dart2js` / Node 24 / V8)** | **Tier 1: `New + json_serial`** | 🔴 `[ 28 / 32 / 37 ]` | **0.96x** / **1.00x** | 🟡 `[ 79 / 89 / 99 ]` | **1.11x** / **1.00x** |
| **JS (`dart2js` / Node 24 / V8)** | **Tier 2: `Stock + Codable [Mock]`** | 🟢 `[ 100 / 100 / 100 ]` | **2.98x** / **3.10x** | 🟢 `[ 99 / 100 / 100 ]` | **1.25x** / **1.13x** |
| **JS (`dart2js` / Node 24 / V8)** | **Tier 3: `New + Codable [Native]`** | 🟢 `[ 90 / 94 / 98 ]` | **2.81x** / **2.92x** | 🟢 `[ 85 / 92 / 100 ]` | **1.16x** / **1.04x** |
| **WASM (`dart2wasm` / Node 24 / V8)** | **Tier 0: `Stock + json_serial`** | 🔴 `[ 38 / 61 / 97 ]` | **1.00x** / **0.81x** | 🔴 `[ 40 / 46 / 53 ]` | **1.00x** / **0.54x** |
| **WASM (`dart2wasm` / Node 24 / V8)** | **Tier 1: `New + json_serial`** | 🟡 `[ 57 / 76 / 100 ]` | **1.24x** / **1.00x** | 🟡 `[ 75 / 85 / 96 ]` | **1.86x** / **1.00x** |
| **WASM (`dart2wasm` / Node 24 / V8)** | **Tier 2: `Stock + Codable [Mock]`** | 🔴 `[ 19 / 21 / 22 ]` | **0.34x** / **0.28x** | 🟢 `[ 100 / 100 / 100 ]` | **2.19x** / **1.18x** |
| **WASM (`dart2wasm` / Node 24 / V8)** | **Tier 3: `New + Codable [Native]`** | 🔴 `[ 48 / 69 / 100 ]` | **1.13x** / **0.91x** | 🟢 `[ 89 / 92 / 95 ]` | **2.02x** / **1.09x** |
<!-- mdformat on -->

> **Scoring Metric**: **Relative Throughput Efficiency** (`100` = Peak Speed across all measured tiers). Calculated as `round((MinLatency / Latency) * 100)` per workload, aggregated across benchmarks using the **Geometric Mean** (Fleming & Wallace 1986).
> - **`[ Worst / GeoMean / Best ]`**: Range from lowest score (worst workload) to the geometric mean and peak dataset score
>   across the active canonical benchmarks.
> - **Badges**: 🥇 Peak across all workloads (`100`) • 🟢 `≥ 90` (Within 10% of peak) • 🟡 `70–89` (Good / moderate) • 🔴 `< 70` (Significant performance gap).

------------------------------------------------------------------------

### 🎛️ Measurement Controls & Resolution Floor

These two diagnostics bound how much of the tables above is signal. Read them before crediting any ratio.

<!-- mdformat off(prevent table wrapping) -->
| Target Runtime | Control Drift (Tier 1 / Tier 0) | Per-Dataset Control Ratios |
| :--- | :---: | :--- |
| **AOT** | **0.944x** | `[0.952, 0.936]` |
| **JS** | **0.902x** | `[0.922, 0.882]` |
| **WASM** | **1.277x** | `[1.196, 1.364]` |
<!-- mdformat on -->

> **Control candidate**: `json_serializable_literal` calls `jsonDecode(String)` plus `.fromJson()` hydration. Because the fork only alters the UTF-8 *byte* parser (`_JsonUtf8Parser`), its String parser is untouched — so a value away from `1.000x` is harness or build drift, not an intentional code effect. **Treat any speedup inside the control band as unresolved.**
>
> **Sample stability**: 42 of 72 measured cells (58%) are flagged `is_robust_stable: false` by the harness. Ratios involving them are marked ⚠️ in the breakdowns below and must not be quoted as measurements.

### 🎯 AOT Target Detailed Breakdown

#### Detailed Breakdown: AOT Decode Stream (32 KB Chunks)

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Tier 0: Stock + json_serial | Tier 1: New + json_serial | Tier 2: Stock + Codable [Mock] | Tier 3: New + Codable [Native] | Tier 1 vs Tier 0 (SDK + Substrate Build) | Tier 2 vs Tier 0 (Codable on Stock) | Speedup vs Tier 0 (Stock json_serial) | Speedup vs Tier 1 (New json_serial) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 4.41 ms | 4.11 ms | 4.94 ms | **3.76 ms** | **1.07x** ⚠️ | **0.89x** ⚠️ | **1.17x** ⚠️ | **1.09x** ⚠️ |
| **canada.json (2.25 MB)** | 49.35 ms | 53.84 ms | 24.95 ms | **15.54 ms** | **0.92x** ⚠️ | **1.98x** ⚠️ | **3.18x** ⚠️ | **3.47x** ⚠️ |
| **Geometric Mean** | — | — | — | — | **0.99x** | **1.33x** | **1.93x** | **1.95x** |
<!-- mdformat on -->

> ⚠️ 2 of 2 workloads in this table draw on samples flagged `is_robust_stable: false`. The Geometric Mean includes them and inherits their uncertainty.


#### Detailed Breakdown: AOT Encode Stream (BytesBuilder / ByteConversionSink)

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Tier 0: Stock + json_serial | Tier 1: New + json_serial | Tier 2: Stock + Codable [Mock] | Tier 3: New + Codable [Native] | Tier 1 vs Tier 0 (SDK + Substrate Build) | Tier 2 vs Tier 0 (Codable on Stock) | Speedup vs Tier 0 (Stock json_serial) | Speedup vs Tier 1 (New json_serial) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 8.95 ms | 3.98 ms | 2.43 ms | **2.33 ms** | **2.25x** ⚠️ | **3.69x** ⚠️ | **3.85x** ⚠️ | **1.71x** ⚠️ |
| **canada.json (2.25 MB)** | 40.28 ms | 19.46 ms | 19.86 ms | **19.18 ms** | **2.07x** | **2.03x** | **2.10x** | **1.01x** |
| **Geometric Mean** | — | — | — | — | **2.16x** | **2.73x** | **2.84x** | **1.32x** |
<!-- mdformat on -->

> ⚠️ 1 of 2 workloads in this table draw on samples flagged `is_robust_stable: false`. The Geometric Mean includes them and inherits their uncertainty.


------------------------------------------------------------------------

### 🎯 JS Target Detailed Breakdown

#### Detailed Breakdown: JS Decode Stream (32 KB Chunks)

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Tier 0: Stock + json_serial | Tier 1: New + json_serial | Tier 2: Stock + Codable [Mock] | Tier 3: New + Codable [Native] | Tier 1 vs Tier 0 (SDK + Substrate Build) | Tier 2 vs Tier 0 (Codable on Stock) | Speedup vs Tier 0 (Stock json_serial) | Speedup vs Tier 1 (New json_serial) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 7.06 ms | 7.21 ms | 2.70 ms | **2.75 ms** | **0.98x** | **2.61x** ⚠️ | **2.57x** | **2.62x** |
| **canada.json (2.25 MB)** | 53.00 ms | 56.00 ms | 15.57 ms | **17.29 ms** | **0.95x** ⚠️ | **3.40x** ⚠️ | **3.07x** ⚠️ | **3.24x** ⚠️ |
| **Geometric Mean** | — | — | — | — | **0.96x** | **2.98x** | **2.81x** | **2.92x** |
<!-- mdformat on -->

> ⚠️ 2 of 2 workloads in this table draw on samples flagged `is_robust_stable: false`. The Geometric Mean includes them and inherits their uncertainty.


#### Detailed Breakdown: JS Encode Stream (BytesBuilder / ByteConversionSink)

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Tier 0: Stock + json_serial | Tier 1: New + json_serial | Tier 2: Stock + Codable [Mock] | Tier 3: New + Codable [Native] | Tier 1 vs Tier 0 (SDK + Substrate Build) | Tier 2 vs Tier 0 (Codable on Stock) | Speedup vs Tier 0 (Stock json_serial) | Speedup vs Tier 1 (New json_serial) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 10.13 ms | 8.09 ms | 6.47 ms | **6.43 ms** | **1.25x** | **1.56x** | **1.57x** | **1.26x** |
| **canada.json (2.25 MB)** | 37.67 ms | 38.00 ms | 37.50 ms | **44.00 ms** | **0.99x** ⚠️ | **1.00x** ⚠️ | **0.86x** ⚠️ | **0.86x** ⚠️ |
| **Geometric Mean** | — | — | — | — | **1.11x** | **1.25x** | **1.16x** | **1.04x** |
<!-- mdformat on -->

> ⚠️ 1 of 2 workloads in this table draw on samples flagged `is_robust_stable: false`. The Geometric Mean includes them and inherits their uncertainty.


------------------------------------------------------------------------

### 🎯 WASM Target Detailed Breakdown

#### Detailed Breakdown: WASM Decode Stream (32 KB Chunks)

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Tier 0: Stock + json_serial | Tier 1: New + json_serial | Tier 2: Stock + Codable [Mock] | Tier 3: New + Codable [Native] | Tier 1 vs Tier 0 (SDK + Substrate Build) | Tier 2 vs Tier 0 (Codable on Stock) | Speedup vs Tier 0 (Stock json_serial) | Speedup vs Tier 1 (New json_serial) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 4.33 ms | 4.20 ms | 18.72 ms | **8.76 ms** | **1.03x** ⚠️ | **0.23x** ⚠️ | **0.49x** ⚠️ | **0.48x** ⚠️ |
| **canada.json (2.25 MB)** | 69.45 ms | 46.42 ms | 136.91 ms | **26.69 ms** | **1.50x** ⚠️ | **0.51x** ⚠️ | **2.60x** ⚠️ | **1.74x** ⚠️ |
| **Geometric Mean** | — | — | — | — | **1.24x** | **0.34x** | **1.13x** | **0.91x** |
<!-- mdformat on -->

> ⚠️ 2 of 2 workloads in this table draw on samples flagged `is_robust_stable: false`. The Geometric Mean includes them and inherits their uncertainty.


#### Detailed Breakdown: WASM Encode Stream (BytesBuilder / ByteConversionSink)

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Tier 0: Stock + json_serial | Tier 1: New + json_serial | Tier 2: Stock + Codable [Mock] | Tier 3: New + Codable [Native] | Tier 1 vs Tier 0 (SDK + Substrate Build) | Tier 2 vs Tier 0 (Codable on Stock) | Speedup vs Tier 0 (Stock json_serial) | Speedup vs Tier 1 (New json_serial) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 9.84 ms | 5.19 ms | 3.89 ms | **4.11 ms** | **1.90x** | **2.53x** | **2.40x** | **1.26x** |
| **canada.json (2.25 MB)** | 49.50 ms | 27.22 ms | 26.11 ms | **29.19 ms** | **1.82x** ⚠️ | **1.90x** ⚠️ | **1.70x** ⚠️ | **0.93x** |
| **Geometric Mean** | — | — | — | — | **1.86x** | **2.19x** | **2.02x** | **1.09x** |
<!-- mdformat on -->

> ⚠️ 1 of 2 workloads in this table draw on samples flagged `is_robust_stable: false`. The Geometric Mean includes them and inherits their uncertainty.


------------------------------------------------------------------------

### 🔄 Streaming vs. Monolithic Single-Buffer Overhead (`Stream / Sink` vs. `Single Buffer`)

Compares the chunked conversion sink latency (`32 KB` slices) against the in-memory single-buffer latency (`Stream Latency / Monolithic Latency`; `1.00x` = zero streaming overhead, `< 1.00x` = streaming is faster than monolithic allocation).

<!-- mdformat off(prevent table wrapping) -->
| Target | Mode & Dataset | Tier 0 Ratio (Stream / Mono) | Tier 1 Ratio (Stream / Mono) | Tier 2 Ratio (Stream / Mono) | Tier 3 Ratio (Stream / Mono) |
| :--- | :--- | :---: | :---: | :---: | :---: |
| **AOT** | 📥 Decode `10k Coordinates (0.39 MB)` | `0.99x` (4.41 ms vs 4.46 ms) | `0.87x` (4.11 ms vs 4.73 ms) | `1.13x` (4.94 ms vs 4.38 ms) | **`1.29x` (3.76 ms vs 2.90 ms)** |
| **AOT** | 📥 Decode `canada.json (2.25 MB)` | `0.96x` (49.35 ms vs 51.47 ms) | `1.01x` (53.84 ms vs 53.44 ms) | `1.18x` (24.95 ms vs 21.08 ms) | **`1.28x` (15.54 ms vs 12.12 ms)** |
| **AOT** | 📤 Encode `10k Coordinates (0.39 MB)` | `0.86x` (8.95 ms vs 10.39 ms) | `0.78x` (3.98 ms vs 5.12 ms) | `0.74x` (2.43 ms vs 3.30 ms) | **`0.66x` (2.33 ms vs 3.51 ms)** |
| **AOT** | 📤 Encode `canada.json (2.25 MB)` | `0.84x` (40.28 ms vs 48.16 ms) | `1.06x` (19.46 ms vs 18.35 ms) | `0.73x` (19.86 ms vs 27.09 ms) | **`0.68x` (19.18 ms vs 28.28 ms)** |
| **JS** | 📥 Decode `10k Coordinates (0.39 MB)` | `1.41x` (7.06 ms vs 5.00 ms) | `1.43x` (7.21 ms vs 5.05 ms) | `1.03x` (2.70 ms vs 2.63 ms) | **`1.03x` (2.75 ms vs 2.67 ms)** |
| **JS** | 📥 Decode `canada.json (2.25 MB)` | `1.49x` (53.00 ms vs 35.50 ms) | `1.40x` (56.00 ms vs 40.00 ms) | `1.02x` (15.57 ms vs 15.20 ms) | **`1.05x` (17.29 ms vs 16.40 ms)** |
| **JS** | 📤 Encode `10k Coordinates (0.39 MB)` | `0.56x` (10.13 ms vs 18.20 ms) | `0.55x` (8.09 ms vs 14.62 ms) | `1.79x` (6.47 ms vs 3.61 ms) | **`1.86x` (6.43 ms vs 3.45 ms)** |
| **JS** | 📤 Encode `canada.json (2.25 MB)` | `1.01x` (37.67 ms vs 37.33 ms) | `1.00x` (38.00 ms vs 38.00 ms) | `1.58x` (37.50 ms vs 23.75 ms) | **`1.85x` (44.00 ms vs 23.75 ms)** |
| **WASM** | 📥 Decode `10k Coordinates (0.39 MB)` | `1.00x` (4.33 ms vs 4.35 ms) | `1.04x` (4.20 ms vs 4.05 ms) | `0.96x` (18.72 ms vs 19.55 ms) | **`1.06x` (8.76 ms vs 8.24 ms)** |
| **WASM** | 📥 Decode `canada.json (2.25 MB)` | `0.91x` (69.45 ms vs 76.20 ms) | `0.75x` (46.42 ms vs 62.19 ms) | `0.95x` (136.91 ms vs 144.71 ms) | **`1.21x` (26.69 ms vs 22.07 ms)** |
| **WASM** | 📤 Encode `10k Coordinates (0.39 MB)` | `0.90x` (9.84 ms vs 10.96 ms) | `0.96x` (5.19 ms vs 5.38 ms) | `0.98x` (3.89 ms vs 3.99 ms) | **`1.04x` (4.11 ms vs 3.95 ms)** |
| **WASM** | 📤 Encode `canada.json (2.25 MB)` | `0.81x` (49.50 ms vs 61.00 ms) | `1.02x` (27.22 ms vs 26.79 ms) | `0.94x` (26.11 ms vs 27.72 ms) | **`1.02x` (29.19 ms vs 28.72 ms)** |
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

