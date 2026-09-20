### 📝 Provenance

- **Run Timestamp**: 2026-09-20T02:50:19.821Z
- **Stock Dart SDK (Tier 0 & Tier 2)**: 3.14.0-248.0.dev (dev) (Sat Sep 19 01:09:06 2026 -0700) on "macos_arm64"
- **New Dart SDK (Tier 1 & Tier 3)**: 3.14.0-json-next.e676935b72bd801c2fdec5188d1e4d8e69dcbf61 (main) (Sat Sep 19 16:14:26 2026 -0700) on "macos_arm64"
- **Repo Commit**: 78ffc3c94f13923624a5fcb80b905aecbe9dc490
- **Host OS**: macos, Hostname: kevmoo-mac
- **Trials**: 15 (reporting `median` latency)

### 🏛️ The 4 Dart Serialization Tiers

- **Tier 0 (`Stock Dart + json_serializable`)**: Out-of-the-box status-quo baseline compiled & executed on unmodified Stock Dart (`dart:convert` DOM + `json_serializable`).
- **Tier 1 (`New Dart + json_serializable`)**: Unmodified `json_serializable` running on the upgraded `dart-sdk-json-next` SDK (15->16 digit double fast-path, 32 KB stringifier buffers, and Eisel-Lemire float parser). Measures the zero-public-API-change speedup for existing `json_serializable` users.
- **Tier 2 (`Stock Dart + Codable [Mock Substrate]`)**: `package:codable` running on unmodified Stock Dart using the pure-Dart mock substrate (`_MockJsonTokenReader` + 64-bit Eisel-Lemire + `AdaptiveJsonTokenWriter`). Measures what `package:codable` delivers if published on Stock Dart today with zero SDK changes.
- **Tier 3 (`New Dart + Codable [Native Substrate]`)**: Full end-to-end stack (`package:codable` + `dart:convert` Layer 1 native `JsonTokenReader` / `JsonUtf8TokenWriter` substrate).

### 📊 3-Runtime Summary (4-Tier Relative Efficiency & GeoMean Speedups)

<!-- mdformat off(prevent table wrapping) -->
| Target Runtime | Tier / Configuration | 📥 Decode Efficiency<br/>[ Worst / GeoMean / Best ] | 📥 Decode GeoMean<br/>(vs Tier 0 / vs Tier 1) | 📤 Encode Efficiency<br/>[ Worst / GeoMean / Best ] | 📤 Encode GeoMean<br/>(vs Tier 0 / vs Tier 1) |
| :--- | :--- | :---: | :---: | :---: | :---: |
| **AOT (`dart compile exe`)** | **Tier 0: `Stock + json_serial`** | 🔴 `[ 28 / 64 / 97 ]` | **1.00x** / **0.97x** | 🔴 `[ 22 / 29 / 40 ]` | **1.00x** / **0.53x** |
| **AOT (`dart compile exe`)** | **Tier 1: `New + json_serial`** | 🔴 `[ 33 / 66 / 98 ]` | **1.03x** / **1.00x** | 🔴 `[ 43 / 55 / 100 ]` | **1.90x** / **1.00x** |
| **AOT (`dart compile exe`)** | **Tier 2: `Stock + Codable [Mock]`** | 🟡 `[ 55 / 77 / 94 ]` | **1.21x** / **1.17x** | 🟢 `[ 81 / 96 / 100 ]` | **3.27x** / **1.73x** |
| **AOT (`dart compile exe`)** | **Tier 3: `New + Codable [Native]`** | 🟢 `[ 100 / 100 / 100 ]` | **1.57x** / **1.51x** | 🟢 `[ 79 / 93 / 99 ]` | **3.17x** / **1.67x** |
| **JS (`dart2js` / Node 24 / V8)** | **Tier 0: `Stock + json_serial`** | 🔴 `[ 40 / 62 / 83 ]` | **1.00x** / **1.01x** | 🔴 `[ 32 / 44 / 65 ]` | **1.00x** / **0.75x** |
| **JS (`dart2js` / Node 24 / V8)** | **Tier 1: `New + json_serial`** | 🔴 `[ 41 / 61 / 81 ]` | **0.99x** / **1.00x** | 🔴 `[ 41 / 59 / 90 ]` | **1.34x** / **1.00x** |
| **JS (`dart2js` / Node 24 / V8)** | **Tier 2: `Stock + Codable [Mock]`** | 🟢 `[ 98 / 100 / 100 ]` | **1.62x** / **1.63x** | 🟢 `[ 99 / 100 / 100 ]` | **2.28x** / **1.71x** |
| **JS (`dart2js` / Node 24 / V8)** | **Tier 3: `New + Codable [Native]`** | 🟢 `[ 98 / 99 / 100 ]` | **1.61x** / **1.63x** | 🟢 `[ 94 / 98 / 100 ]` | **2.25x** / **1.68x** |
| **WASM (`dart2wasm` / Node 24 / V8)** | **Tier 0: `Stock + json_serial`** | 🔴 `[ 39 / 68 / 90 ]` | **1.00x** / **0.93x** | 🔴 `[ 42 / 52 / 62 ]` | **1.00x** / **0.54x** |
| **WASM (`dart2wasm` / Node 24 / V8)** | **Tier 1: `New + json_serial`** | 🟡 `[ 50 / 74 / 100 ]` | **1.08x** / **1.00x** | 🟢 `[ 91 / 97 / 100 ]` | **1.85x** / **1.00x** |
| **WASM (`dart2wasm` / Node 24 / V8)** | **Tier 2: `Stock + Codable [Mock]`** | 🔴 `[ 21 / 47 / 83 ]` | **0.69x** / **0.64x** | 🟢 `[ 82 / 94 / 100 ]` | **1.79x** / **0.97x** |
| **WASM (`dart2wasm` / Node 24 / V8)** | **Tier 3: `New + Codable [Native]`** | 🟢 `[ 62 / 91 / 100 ]` | **1.33x** / **1.23x** | 🟢 `[ 83 / 94 / 100 ]` | **1.79x** / **0.97x** |
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
| **AOT** | **0.993x** | `[0.999, 1.003, 0.991, 0.996, 0.977]` |
| **JS** | **0.986x** | `[0.980, 1.000, 0.942, 1.000, 1.010]` |
| **WASM** | **1.057x** | `[1.050, 1.292, 0.998, 1.001, 0.975]` |
<!-- mdformat on -->

> **Control candidate**: `json_serializable_literal` calls `jsonDecode(String)` plus `.fromJson()` hydration. Because the fork only alters the UTF-8 *byte* parser (`_JsonUtf8Parser`), its String parser is untouched — so a value away from `1.000x` is harness or build drift, not an intentional code effect. **Treat any speedup inside the control band as unresolved.**
>
> **Sample stability**: 2 of 180 measured cells (1%) are flagged `is_robust_stable: false` by the harness. Ratios involving them are marked ⚠️ in the breakdowns below and must not be quoted as measurements.

### 🎯 AOT Target Detailed Breakdown

#### Detailed Breakdown: AOT Decode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Tier 0: Stock + json_serial | Tier 1: New + json_serial | Tier 2: Stock + Codable [Mock] | Tier 3: New + Codable [Native] | Tier 1 vs Tier 0 (SDK + Substrate Build) | Tier 2 vs Tier 0 (Codable on Stock) | Speedup vs Tier 0 (Stock json_serial) | Speedup vs Tier 1 (New json_serial) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 1.77 ms | 1.79 ms | 1.71 ms | **1.20 ms** | **0.99x** | **1.04x** | **1.48x** | **1.50x** |
| **canada.json (2.25 MB)** | 19.01 ms | 16.08 ms | 9.57 ms | **5.25 ms** | **1.18x** | **1.99x** | **3.62x** | **3.06x** |
| **citm_catalog.json (1.73 MB)** | 3.36 ms | 3.33 ms | 2.30 ms | **2.17 ms** | **1.01x** | **1.46x** | **1.55x** | **1.54x** |
| **small.json (0.55 KB)** | 1.5 µs | 1.5 µs | 1.4 µs | **1.4 µs** | **1.00x** | **1.05x** | **1.11x** | **1.11x** |
| **twitter.json (0.62 MB)** | 1.44 ms | 1.43 ms | 1.77 ms | **1.41 ms** | **1.01x** | **0.82x** | **1.03x** | **1.02x** |
| **Geometric Mean** | — | — | — | — | **1.03x** | **1.21x** | **1.57x** | **1.51x** |
<!-- mdformat on -->


#### Detailed Breakdown: AOT Encode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Tier 0: Stock + json_serial | Tier 1: New + json_serial | Tier 2: Stock + Codable [Mock] | Tier 3: New + Codable [Native] | Tier 1 vs Tier 0 (SDK + Substrate Build) | Tier 2 vs Tier 0 (Codable on Stock) | Speedup vs Tier 0 (Stock json_serial) | Speedup vs Tier 1 (New json_serial) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 4.77 ms | 1.93 ms | 1.03 ms | **1.06 ms** | **2.47x** | **4.63x** | **4.51x** | **1.83x** |
| **canada.json (2.25 MB)** | 19.45 ms | 7.77 ms | 9.64 ms | **9.78 ms** | **2.50x** | **2.02x** | **1.99x** | **0.79x** |
| **citm_catalog.json (1.73 MB)** | 3.72 ms | 2.69 ms | 1.15 ms | **1.16 ms** | **1.38x** | **3.23x** | **3.20x** | **2.31x** |
| **small.json (0.55 KB)** | 2.3 µs | 1.4 µs | 0.7 µs | **0.8 µs** | **1.61x** | **3.24x** | **2.99x** | **1.86x** |
| **twitter.json (0.62 MB)** | 2.46 ms | 1.38 ms | 642.4 µs | **656.1 µs** | **1.78x** | **3.83x** | **3.75x** | **2.11x** |
| **Geometric Mean** | — | — | — | — | **1.90x** | **3.27x** | **3.17x** | **1.67x** |
<!-- mdformat on -->


------------------------------------------------------------------------

### 🎯 JS Target Detailed Breakdown

#### Detailed Breakdown: JS Decode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Tier 0: Stock + json_serial | Tier 1: New + json_serial | Tier 2: Stock + Codable [Mock] | Tier 3: New + Codable [Native] | Tier 1 vs Tier 0 (SDK + Substrate Build) | Tier 2 vs Tier 0 (Codable on Stock) | Speedup vs Tier 0 (Stock json_serial) | Speedup vs Tier 1 (New json_serial) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 1.85 ms | 1.91 ms | 1.05 ms | **1.08 ms** | **0.97x** | **1.76x** | **1.72x** | **1.77x** |
| **canada.json (2.25 MB)** | 16.00 ms | 15.83 ms | 6.60 ms | **6.47 ms** | **1.01x** | **2.42x** | **2.47x** | **2.45x** |
| **citm_catalog.json (1.73 MB)** | 4.55 ms | 4.57 ms | 2.94 ms | **2.94 ms** | **1.00x** | **1.55x** | **1.55x** | **1.55x** |
| **small.json (0.55 KB)** | 2.0 µs | 2.0 µs | 1.4 µs | **1.4 µs** | **0.99x** | **1.38x** | **1.37x** | **1.39x** |
| **twitter.json (0.62 MB)** | 1.44 ms | 1.47 ms | 1.19 ms | **1.19 ms** | **0.98x** | **1.21x** | **1.21x** | **1.24x** |
| **Geometric Mean** | — | — | — | — | **0.99x** | **1.62x** | **1.61x** | **1.63x** |
<!-- mdformat on -->


#### Detailed Breakdown: JS Encode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Tier 0: Stock + json_serial | Tier 1: New + json_serial | Tier 2: Stock + Codable [Mock] | Tier 3: New + Codable [Native] | Tier 1 vs Tier 0 (SDK + Substrate Build) | Tier 2 vs Tier 0 (Codable on Stock) | Speedup vs Tier 0 (Stock json_serial) | Speedup vs Tier 1 (New json_serial) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 4.86 ms | 3.85 ms | 1.56 ms | **1.57 ms** | **1.26x** ⚠️ | **3.11x** ⚠️ | **3.10x** ⚠️ | **2.45x** |
| **canada.json (2.25 MB)** | 16.00 ms | 13.75 ms | 10.40 ms | **11.11 ms** | **1.16x** ⚠️ | **1.54x** | **1.44x** | **1.24x** ⚠️ |
| **citm_catalog.json (1.73 MB)** | 4.25 ms | 3.23 ms | 1.87 ms | **1.89 ms** | **1.32x** | **2.27x** | **2.25x** | **1.71x** |
| **small.json (0.55 KB)** | 2.9 µs | 2.4 µs | 1.0 µs | **1.0 µs** | **1.21x** | **2.82x** | **2.80x** | **2.31x** |
| **twitter.json (0.62 MB)** | 2.75 ms | 1.50 ms | 1.36 ms | **1.35 ms** | **1.83x** | **2.02x** | **2.04x** | **1.11x** |
| **Geometric Mean** | — | — | — | — | **1.34x** | **2.28x** | **2.25x** | **1.68x** |
<!-- mdformat on -->

> ⚠️ 2 of 5 workloads in this table draw on samples flagged `is_robust_stable: false`. The Geometric Mean includes them and inherits their uncertainty.


------------------------------------------------------------------------

### 🎯 WASM Target Detailed Breakdown

#### Detailed Breakdown: WASM Decode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Tier 0: Stock + json_serial | Tier 1: New + json_serial | Tier 2: Stock + Codable [Mock] | Tier 3: New + Codable [Native] | Tier 1 vs Tier 0 (SDK + Substrate Build) | Tier 2 vs Tier 0 (Codable on Stock) | Speedup vs Tier 0 (Stock json_serial) | Speedup vs Tier 1 (New json_serial) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 2.16 ms | 1.95 ms | 8.24 ms | **3.16 ms** | **1.11x** | **0.26x** | **0.68x** | **0.62x** |
| **canada.json (2.25 MB)** | 26.41 ms | 20.26 ms | 48.19 ms | **10.22 ms** | **1.30x** | **0.55x** | **2.58x** | **1.98x** |
| **citm_catalog.json (1.73 MB)** | 2.98 ms | 2.94 ms | 2.59 ms | **1.87 ms** | **1.01x** | **1.15x** | **1.59x** | **1.57x** |
| **small.json (0.55 KB)** | 1.6 µs | 1.6 µs | 1.5 µs | **1.2 µs** | **1.00x** | **1.09x** | **1.31x** | **1.31x** |
| **twitter.json (0.62 MB)** | 1.47 ms | 1.46 ms | 1.63 ms | **1.28 ms** | **1.00x** | **0.90x** | **1.14x** | **1.14x** |
| **Geometric Mean** | — | — | — | — | **1.08x** | **0.69x** | **1.33x** | **1.23x** |
<!-- mdformat on -->


#### Detailed Breakdown: WASM Encode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Tier 0: Stock + json_serial | Tier 1: New + json_serial | Tier 2: Stock + Codable [Mock] | Tier 3: New + Codable [Native] | Tier 1 vs Tier 0 (SDK + Substrate Build) | Tier 2 vs Tier 0 (Codable on Stock) | Speedup vs Tier 0 (Stock json_serial) | Speedup vs Tier 1 (New json_serial) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 4.37 ms | 2.03 ms | 1.85 ms | **1.84 ms** | **2.15x** | **2.36x** | **2.37x** | **1.10x** |
| **canada.json (2.25 MB)** | 21.63 ms | 10.56 ms | 12.88 ms | **12.79 ms** | **2.05x** | **1.68x** | **1.69x** | **0.83x** |
| **citm_catalog.json (1.73 MB)** | 3.91 ms | 2.43 ms | 2.41 ms | **2.42 ms** | **1.61x** | **1.62x** | **1.61x** | **1.00x** |
| **small.json (0.55 KB)** | 2.4 µs | 1.4 µs | 1.3 µs | **1.3 µs** | **1.69x** | **1.80x** | **1.80x** | **1.06x** |
| **twitter.json (0.62 MB)** | 2.35 ms | 1.30 ms | 1.48 ms | **1.48 ms** | **1.80x** | **1.59x** | **1.59x** | **0.88x** |
| **Geometric Mean** | — | — | — | — | **1.85x** | **1.79x** | **1.79x** | **0.97x** |
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

