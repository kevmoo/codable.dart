## 🌊 Streaming Benchmark Report (`ChunkedConversionSink` / `ByteConversionSink`)

### 📝 Provenance

- **Run Timestamp**: 2026-09-20T02:50:19.821Z
- **Stock Dart SDK (Tier 0 & Tier 2)**: 3.14.0-248.0.dev (dev) (Sat Sep 19 01:09:06 2026 -0700) on "macos_arm64"
- **New Dart SDK (Tier 1 & Tier 3)**: 3.14.0-json-next.e676935b72bd801c2fdec5188d1e4d8e69dcbf61 (main) (Sat Sep 19 16:14:26 2026 -0700) on "macos_arm64"
- **Repo Commit**: 78ffc3c94f13923624a5fcb80b905aecbe9dc490
- **Host OS**: macos, Hostname: kevmoo-mac
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
| **AOT (`dart compile exe`)** | **Tier 0: `Stock + json_serial`** | 🔴 `[ 31 / 46 / 71 ]` | **1.00x** / **0.92x** | 🔴 `[ 19 / 27 / 39 ]` | **1.00x** / **0.39x** |
| **AOT (`dart compile exe`)** | **Tier 1: `New + json_serial`** | 🔴 `[ 36 / 50 / 71 ]` | **1.08x** / **1.00x** | 🔴 `[ 48 / 70 / 100 ]` | **2.54x** / **1.00x** |
| **AOT (`dart compile exe`)** | **Tier 2: `Stock + Codable [Mock]`** | 🔴 `[ 57 / 64 / 71 ]` | **1.38x** / **1.27x** | 🟢 `[ 84 / 92 / 100 ]` | **3.36x** / **1.32x** |
| **AOT (`dart compile exe`)** | **Tier 3: `New + Codable [Native]`** | 🟢 `[ 100 / 100 / 100 ]` | **2.15x** / **1.98x** | 🟢 `[ 84 / 91 / 98 ]` | **3.32x** / **1.30x** |
| **JS (`dart2js` / Node 24 / V8)** | **Tier 0: `Stock + json_serial`** | 🔴 `[ 31 / 34 / 37 ]` | **1.00x** / **1.03x** | 🟡 `[ 79 / 81 / 83 ]` | **1.00x** / **0.81x** |
| **JS (`dart2js` / Node 24 / V8)** | **Tier 1: `New + json_serial`** | 🔴 `[ 30 / 33 / 36 ]` | **0.97x** / **1.00x** | 🟢 `[ 100 / 100 / 100 ]` | **1.23x** / **1.00x** |
| **JS (`dart2js` / Node 24 / V8)** | **Tier 2: `Stock + Codable [Mock]`** | 🟢 `[ 100 / 100 / 100 ]` | **2.96x** / **3.06x** | 🔴 `[ 47 / 64 / 87 ]` | **0.78x** / **0.64x** |
| **JS (`dart2js` / Node 24 / V8)** | **Tier 3: `New + Codable [Native]`** | 🟢 `[ 97 / 98 / 99 ]` | **2.90x** / **3.00x** | 🔴 `[ 45 / 63 / 87 ]` | **0.77x** / **0.63x** |
| **WASM (`dart2wasm` / Node 24 / V8)** | **Tier 0: `Stock + json_serial`** | 🔴 `[ 40 / 60 / 91 ]` | **1.00x** / **0.83x** | 🔴 `[ 39 / 44 / 49 ]` | **1.00x** / **0.51x** |
| **WASM (`dart2wasm` / Node 24 / V8)** | **Tier 1: `New + json_serial`** | 🟡 `[ 52 / 72 / 100 ]` | **1.20x** / **1.00x** | 🟡 `[ 76 / 86 / 97 ]` | **1.97x** / **1.00x** |
| **WASM (`dart2wasm` / Node 24 / V8)** | **Tier 2: `Stock + Codable [Mock]`** | 🔴 `[ 22 / 22 / 23 ]` | **0.37x** / **0.31x** | 🟢 `[ 96 / 98 / 100 ]` | **2.23x** / **1.13x** |
| **WASM (`dart2wasm` / Node 24 / V8)** | **Tier 3: `New + Codable [Native]`** | 🟡 `[ 59 / 77 / 100 ]` | **1.28x** / **1.07x** | 🟢 `[ 93 / 96 / 100 ]` | **2.20x** / **1.12x** |
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
| **AOT** | **0.994x** | `[0.994, 0.995]` |
| **JS** | **0.990x** | `[0.971, 1.010]` |
| **WASM** | **1.155x** | `[1.024, 1.303]` |
<!-- mdformat on -->

> **Control candidate**: `json_serializable_literal` calls `jsonDecode(String)` plus `.fromJson()` hydration. Because the fork only alters the UTF-8 *byte* parser (`_JsonUtf8Parser`), its String parser is untouched — so a value away from `1.000x` is harness or build drift, not an intentional code effect. **Treat any speedup inside the control band as unresolved.**
>
> **Sample stability**: 2 of 72 measured cells (3%) are flagged `is_robust_stable: false` by the harness. Ratios involving them are marked ⚠️ in the breakdowns below and must not be quoted as measurements.

### 🎯 AOT Target Detailed Breakdown

#### Detailed Breakdown: AOT Decode Stream (32 KB Chunks)

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Tier 0: Stock + json_serial | Tier 1: New + json_serial | Tier 2: Stock + Codable [Mock] | Tier 3: New + Codable [Native] | Tier 1 vs Tier 0 (SDK + Substrate Build) | Tier 2 vs Tier 0 (Codable on Stock) | Speedup vs Tier 0 (Stock json_serial) | Speedup vs Tier 1 (New json_serial) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 1.77 ms | 1.77 ms | 1.76 ms | **1.25 ms** | **1.00x** | **1.01x** | **1.42x** | **1.42x** |
| **canada.json (2.25 MB)** | 18.99 ms | 16.15 ms | 10.11 ms | **5.81 ms** | **1.18x** | **1.88x** | **3.27x** | **2.78x** |
| **Geometric Mean** | — | — | — | — | **1.08x** | **1.38x** | **2.15x** | **1.98x** |
<!-- mdformat on -->


#### Detailed Breakdown: AOT Encode Stream (BytesBuilder / ByteConversionSink)

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Tier 0: Stock + json_serial | Tier 1: New + json_serial | Tier 2: Stock + Codable [Mock] | Tier 3: New + Codable [Native] | Tier 1 vs Tier 0 (SDK + Substrate Build) | Tier 2 vs Tier 0 (Codable on Stock) | Speedup vs Tier 0 (Stock json_serial) | Speedup vs Tier 1 (New json_serial) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 4.45 ms | 1.74 ms | 841.1 µs | **859.8 µs** | **2.55x** | **5.29x** | **5.17x** | **2.03x** |
| **canada.json (2.25 MB)** | 18.48 ms | 7.29 ms | 8.65 ms | **8.67 ms** | **2.54x** | **2.14x** | **2.13x** | **0.84x** |
| **Geometric Mean** | — | — | — | — | **2.54x** | **3.36x** | **3.32x** | **1.30x** |
<!-- mdformat on -->


------------------------------------------------------------------------

### 🎯 JS Target Detailed Breakdown

#### Detailed Breakdown: JS Decode Stream (32 KB Chunks)

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Tier 0: Stock + json_serial | Tier 1: New + json_serial | Tier 2: Stock + Codable [Mock] | Tier 3: New + Codable [Native] | Tier 1 vs Tier 0 (SDK + Substrate Build) | Tier 2 vs Tier 0 (Codable on Stock) | Speedup vs Tier 0 (Stock json_serial) | Speedup vs Tier 1 (New json_serial) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 2.89 ms | 2.94 ms | 1.06 ms | **1.10 ms** | **0.98x** | **2.71x** | **2.63x** | **2.68x** |
| **canada.json (2.25 MB)** | 21.75 ms | 22.75 ms | 6.73 ms | **6.80 ms** | **0.96x** | **3.23x** | **3.20x** | **3.35x** |
| **Geometric Mean** | — | — | — | — | **0.97x** | **2.96x** | **2.90x** | **3.00x** |
<!-- mdformat on -->


#### Detailed Breakdown: JS Encode Stream (BytesBuilder / ByteConversionSink)

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Tier 0: Stock + json_serial | Tier 1: New + json_serial | Tier 2: Stock + Codable [Mock] | Tier 3: New + Codable [Native] | Tier 1 vs Tier 0 (SDK + Substrate Build) | Tier 2 vs Tier 0 (Codable on Stock) | Speedup vs Tier 0 (Stock json_serial) | Speedup vs Tier 1 (New json_serial) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 4.59 ms | 3.64 ms | 4.21 ms | **4.21 ms** | **1.26x** ⚠️ | **1.09x** ⚠️ | **1.09x** ⚠️ | **0.87x** |
| **canada.json (2.25 MB)** | 15.33 ms | 12.75 ms | 27.25 ms | **28.25 ms** | **1.20x** | **0.56x** | **0.54x** | **0.45x** |
| **Geometric Mean** | — | — | — | — | **1.23x** | **0.78x** | **0.77x** | **0.63x** |
<!-- mdformat on -->

> ⚠️ 1 of 2 workloads in this table draw on samples flagged `is_robust_stable: false`. The Geometric Mean includes them and inherits their uncertainty.


------------------------------------------------------------------------

### 🎯 WASM Target Detailed Breakdown

#### Detailed Breakdown: WASM Decode Stream (32 KB Chunks)

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Tier 0: Stock + json_serial | Tier 1: New + json_serial | Tier 2: Stock + Codable [Mock] | Tier 3: New + Codable [Native] | Tier 1 vs Tier 0 (SDK + Substrate Build) | Tier 2 vs Tier 0 (Codable on Stock) | Speedup vs Tier 0 (Stock json_serial) | Speedup vs Tier 1 (New json_serial) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 2.14 ms | 1.95 ms | 8.45 ms | **3.29 ms** | **1.10x** | **0.25x** | **0.65x** | **0.59x** |
| **canada.json (2.25 MB)** | 26.27 ms | 20.02 ms | 48.55 ms | **10.46 ms** | **1.31x** | **0.54x** | **2.51x** | **1.91x** |
| **Geometric Mean** | — | — | — | — | **1.20x** | **0.37x** | **1.28x** | **1.07x** |
<!-- mdformat on -->


#### Detailed Breakdown: WASM Encode Stream (BytesBuilder / ByteConversionSink)

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Tier 0: Stock + json_serial | Tier 1: New + json_serial | Tier 2: Stock + Codable [Mock] | Tier 3: New + Codable [Native] | Tier 1 vs Tier 0 (SDK + Substrate Build) | Tier 2 vs Tier 0 (Codable on Stock) | Speedup vs Tier 0 (Stock json_serial) | Speedup vs Tier 1 (New json_serial) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 4.20 ms | 2.17 ms | 1.73 ms | **1.65 ms** | **1.94x** | **2.42x** | **2.54x** | **1.31x** |
| **canada.json (2.25 MB)** | 20.69 ms | 10.34 ms | 10.08 ms | **10.86 ms** | **2.00x** | **2.05x** | **1.91x** | **0.95x** |
| **Geometric Mean** | — | — | — | — | **1.97x** | **2.23x** | **2.20x** | **1.12x** |
<!-- mdformat on -->


------------------------------------------------------------------------

### 🔄 Streaming vs. Monolithic Single-Buffer Overhead (`Stream / Sink` vs. `Single Buffer`)

Compares the chunked conversion sink latency (`32 KB` slices) against the in-memory single-buffer latency (`Stream Latency / Monolithic Latency`; `1.00x` = zero streaming overhead, `< 1.00x` = streaming is faster than monolithic allocation).

<!-- mdformat off(prevent table wrapping) -->
| Target | Mode & Dataset | Tier 0 Ratio (Stream / Mono) | Tier 1 Ratio (Stream / Mono) | Tier 2 Ratio (Stream / Mono) | Tier 3 Ratio (Stream / Mono) |
| :--- | :--- | :---: | :---: | :---: | :---: |
| **AOT** | 📥 Decode `10k Coordinates (0.39 MB)` | `1.00x` (1.77 ms vs 1.77 ms) | `0.99x` (1.77 ms vs 1.79 ms) | `1.03x` (1.76 ms vs 1.71 ms) | **`1.05x` (1.25 ms vs 1.20 ms)** |
| **AOT** | 📥 Decode `canada.json (2.25 MB)` | `1.00x` (18.99 ms vs 19.01 ms) | `1.00x` (16.15 ms vs 16.08 ms) | `1.06x` (10.11 ms vs 9.57 ms) | **`1.11x` (5.81 ms vs 5.25 ms)** |
| **AOT** | 📤 Encode `10k Coordinates (0.39 MB)` | `0.93x` (4.45 ms vs 4.77 ms) | `0.90x` (1.74 ms vs 1.93 ms) | `0.82x` (841.1 µs vs 1.03 ms) | **`0.81x` (859.8 µs vs 1.06 ms)** |
| **AOT** | 📤 Encode `canada.json (2.25 MB)` | `0.95x` (18.48 ms vs 19.45 ms) | `0.94x` (7.29 ms vs 7.77 ms) | `0.90x` (8.65 ms vs 9.64 ms) | **`0.89x` (8.67 ms vs 9.78 ms)** |
| **JS** | 📥 Decode `10k Coordinates (0.39 MB)` | `1.56x` (2.89 ms vs 1.85 ms) | `1.54x` (2.94 ms vs 1.91 ms) | `1.01x` (1.06 ms vs 1.05 ms) | **`1.02x` (1.10 ms vs 1.08 ms)** |
| **JS** | 📥 Decode `canada.json (2.25 MB)` | `1.36x` (21.75 ms vs 16.00 ms) | `1.44x` (22.75 ms vs 15.83 ms) | `1.02x` (6.73 ms vs 6.60 ms) | **`1.05x` (6.80 ms vs 6.47 ms)** |
| **JS** | 📤 Encode `10k Coordinates (0.39 MB)` | `0.95x` (4.59 ms vs 4.86 ms) | `0.95x` (3.64 ms vs 3.85 ms) | `2.69x` (4.21 ms vs 1.56 ms) | **`2.68x` (4.21 ms vs 1.57 ms)** |
| **JS** | 📤 Encode `canada.json (2.25 MB)` | `0.96x` (15.33 ms vs 16.00 ms) | `0.93x` (12.75 ms vs 13.75 ms) | `2.62x` (27.25 ms vs 10.40 ms) | **`2.54x` (28.25 ms vs 11.11 ms)** |
| **WASM** | 📥 Decode `10k Coordinates (0.39 MB)` | `0.99x` (2.14 ms vs 2.16 ms) | `1.00x` (1.95 ms vs 1.95 ms) | `1.03x` (8.45 ms vs 8.24 ms) | **`1.04x` (3.29 ms vs 3.16 ms)** |
| **WASM** | 📥 Decode `canada.json (2.25 MB)` | `0.99x` (26.27 ms vs 26.41 ms) | `0.99x` (20.02 ms vs 20.26 ms) | `1.01x` (48.55 ms vs 48.19 ms) | **`1.02x` (10.46 ms vs 10.22 ms)** |
| **WASM** | 📤 Encode `10k Coordinates (0.39 MB)` | `0.96x` (4.20 ms vs 4.37 ms) | `1.07x` (2.17 ms vs 2.03 ms) | `0.94x` (1.73 ms vs 1.85 ms) | **`0.90x` (1.65 ms vs 1.84 ms)** |
| **WASM** | 📤 Encode `canada.json (2.25 MB)` | `0.96x` (20.69 ms vs 21.63 ms) | `0.98x` (10.34 ms vs 10.56 ms) | `0.78x` (10.08 ms vs 12.88 ms) | **`0.85x` (10.86 ms vs 12.79 ms)** |
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

