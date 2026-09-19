### 📝 Provenance

- **Run Timestamp**: 2026-09-19T11:30:20.149Z
- **Stock Dart SDK (Tier 0 & Tier 2)**: 3.14.0-241.0.dev (dev) (Thu Sep 17 17:06:19 2026 -0700) on "linux_x64"
- **New Dart SDK (Tier 1 & Tier 3)**: 3.14.0-edge.2c131e2363143936d92729b18d962e498c772a4d (main) (Fri Sep 11 18:19:58 2026 -0700) on "linux_x64"
- **Repo Commit**: d7351554f0793f8cb0e69e2158e744125eeeeb7f
- **Host OS**: linux, Hostname: kevmoo.c.googlers.com
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
| **AOT (`dart compile exe`)** | **Tier 0: `Stock + json_serial`** | 🔴 `[ 27 / 61 / 96 ]` | **1.00x** / **0.94x** | 🔴 `[ 25 / 36 / 51 ]` | **1.00x** / **0.65x** |
| **AOT (`dart compile exe`)** | **Tier 1: `New + json_serial`** | 🔴 `[ 28 / 65 / 100 ]` | **1.06x** / **1.00x** | 🔴 `[ 34 / 55 / 81 ]` | **1.53x** / **1.00x** |
| **AOT (`dart compile exe`)** | **Tier 2: `Stock + Codable [Mock]`** | 🟡 `[ 57 / 76 / 96 ]` | **1.26x** / **1.18x** | 🟢 `[ 99 / 100 / 100 ]` | **2.77x** / **1.82x** |
| **AOT (`dart compile exe`)** | **Tier 3: `New + Codable [Native]`** | 🟢 `[ 85 / 95 / 100 ]` | **1.56x** / **1.47x** | 🟢 `[ 86 / 97 / 100 ]` | **2.69x** / **1.76x** |
| **JS (`dart2js` / Node 24 / V8)** | **Tier 0: `Stock + json_serial`** | 🔴 `[ 47 / 63 / 78 ]` | **1.00x** / **1.04x** | 🔴 `[ 25 / 39 / 55 ]` | **1.00x** / **1.17x** |
| **JS (`dart2js` / Node 24 / V8)** | **Tier 1: `New + json_serial`** | 🔴 `[ 34 / 60 / 85 ]` | **0.96x** / **1.00x** | 🔴 `[ 7 / 34 / 87 ]` | **0.86x** / **1.00x** |
| **JS (`dart2js` / Node 24 / V8)** | **Tier 2: `Stock + Codable [Mock]`** | 🟢 `[ 92 / 98 / 100 ]` | **1.56x** / **1.63x** | 🟢 `[ 95 / 98 / 100 ]` | **2.50x** / **2.93x** |
| **JS (`dart2js` / Node 24 / V8)** | **Tier 3: `New + Codable [Native]`** | 🟢 `[ 93 / 98 / 100 ]` | **1.57x** / **1.64x** | 🟢 `[ 97 / 99 / 100 ]` | **2.51x** / **2.93x** |
| **WASM (`dart2wasm` / Node 24 / V8)** | **Tier 0: `Stock + json_serial`** | 🔴 `[ 25 / 68 / 100 ]` | **1.00x** / **1.03x** | 🔴 `[ 32 / 49 / 59 ]` | **1.00x** / **0.71x** |
| **WASM (`dart2wasm` / Node 24 / V8)** | **Tier 1: `New + json_serial`** | 🔴 `[ 22 / 66 / 100 ]` | **0.97x** / **1.00x** | 🔴 `[ 51 / 69 / 98 ]` | **1.41x** / **1.00x** |
| **WASM (`dart2wasm` / Node 24 / V8)** | **Tier 2: `Stock + Codable [Mock]`** | 🔴 `[ 47 / 66 / 79 ]` | **0.97x** / **1.00x** | 🟢 `[ 100 / 100 / 100 ]` | **2.04x** / **1.44x** |
| **WASM (`dart2wasm` / Node 24 / V8)** | **Tier 3: `New + Codable [Native]`** | 🟢 `[ 94 / 97 / 100 ]` | **1.43x** / **1.47x** | 🟢 `[ 91 / 96 / 99 ]` | **1.95x** / **1.38x** |
<!-- mdformat on -->

> **Scoring Metric**: **Relative Throughput Efficiency** (`100` = Peak Speed across all measured tiers). Calculated as `round((MinLatency / Latency) * 100)` per workload, aggregated across benchmarks using the **Geometric Mean** (Fleming & Wallace 1986).
> - **`[ Worst / GeoMean / Best ]`**: Range from lowest score (worst workload) to the geometric mean and peak dataset score
>   across the 5 canonical benchmarks (`coordinates`, `canada`, `citm_catalog`, `small`, `twitter`).
> - **Badges**: 🥇 Peak across all workloads (`100`) • 🟢 `≥ 90` (Within 10% of peak) • 🟡 `70–89` (Good / moderate) • 🔴 `< 70` (Significant performance gap).

------------------------------------------------------------------------

### 🎛️ Measurement Controls & Resolution Floor

These two diagnostics bound how much of the tables above is signal. Read them before crediting any ratio.

<!-- mdformat off(prevent table wrapping) -->
| Target Runtime | Control Drift (Tier 1 / Tier 0) | Per-Dataset Control Ratios |
| :--- | :---: | :--- |
| **AOT** | **1.015x** | `[0.974, 1.022, 0.967, 1.118, 1.002]` |
| **JS** | **0.954x** | `[0.979, 0.957, 0.868, 0.980, 0.991]` |
| **WASM** | **0.932x** | `[0.970, 0.836, 0.989, 0.885, 0.992]` |
<!-- mdformat on -->

> **Control candidate**: `json_serializable_literal` calls `jsonDecode(String)` plus `.fromJson()` hydration. Because the fork only alters the UTF-8 *byte* parser (`_JsonUtf8Parser`), its String parser is untouched — so a value away from `1.000x` is harness or build drift, not an intentional code effect. (The AOT `canada` entry at `1.502x` is itself an unstable cell, not a speedup.) **Treat any speedup inside the control band as unresolved.**
>
> **Sample stability**: 85 of 180 measured cells (47%) are flagged `is_robust_stable: false` by the harness. Ratios involving them are marked ⚠️ in the breakdowns below and must not be quoted as measurements.

### 🎯 AOT Target Detailed Breakdown

#### Detailed Breakdown: AOT Decode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Tier 0: Stock + json_serial | Tier 1: New + json_serial | Tier 2: Stock + Codable [Mock] | Tier 3: New + Codable [Native] | Tier 1 vs Tier 0 (SDK + Substrate Build) | Tier 2 vs Tier 0 (Codable on Stock) | Speedup vs Tier 0 (Stock json_serial) | Speedup vs Tier 1 (New json_serial) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 4.45 ms | 3.88 ms | 3.88 ms | **2.55 ms** | **1.15x** ⚠️ | **1.15x** ⚠️ | **1.74x** ⚠️ | **1.52x** |
| **canada.json (2.25 MB)** | 46.45 ms | 44.62 ms | 21.89 ms | **12.48 ms** | **1.04x** ⚠️ | **2.12x** ⚠️ | **3.72x** ⚠️ | **3.58x** ⚠️ |
| **citm_catalog.json (1.73 MB)** | 8.33 ms | 7.95 ms | 5.03 ms | **4.85 ms** | **1.05x** ⚠️ | **1.65x** ⚠️ | **1.72x** ⚠️ | **1.64x** ⚠️ |
| **small.json (0.55 KB)** | 3.0 µs | 2.8 µs | 3.2 µs | **3.3 µs** | **1.05x** | **0.93x** | **0.89x** ⚠️ | **0.85x** ⚠️ |
| **twitter.json (0.62 MB)** | 3.17 ms | 3.06 ms | 3.77 ms | **3.41 ms** | **1.04x** | **0.84x** | **0.93x** ⚠️ | **0.90x** ⚠️ |
| **Geometric Mean** | — | — | — | — | **1.06x** | **1.26x** | **1.56x** | **1.47x** |
<!-- mdformat on -->

> ⚠️ 5 of 5 workloads in this table draw on samples flagged `is_robust_stable: false`. The Geometric Mean includes them and inherits their uncertainty.


#### Detailed Breakdown: AOT Encode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Tier 0: Stock + json_serial | Tier 1: New + json_serial | Tier 2: Stock + Codable [Mock] | Tier 3: New + Codable [Native] | Tier 1 vs Tier 0 (SDK + Substrate Build) | Tier 2 vs Tier 0 (Codable on Stock) | Speedup vs Tier 0 (Stock json_serial) | Speedup vs Tier 1 (New json_serial) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 10.20 ms | 4.79 ms | 2.57 ms | **2.99 ms** | **2.13x** ⚠️ | **3.97x** ⚠️ | **3.42x** ⚠️ | **1.61x** ⚠️ |
| **canada.json (2.25 MB)** | 47.77 ms | 30.21 ms | 24.77 ms | **24.50 ms** | **1.58x** ⚠️ | **1.93x** ⚠️ | **1.95x** ⚠️ | **1.23x** ⚠️ |
| **citm_catalog.json (1.73 MB)** | 9.58 ms | 5.66 ms | 3.52 ms | **3.50 ms** | **1.69x** ⚠️ | **2.72x** ⚠️ | **2.74x** ⚠️ | **1.62x** ⚠️ |
| **small.json (0.55 KB)** | 5.0 µs | 5.1 µs | 1.7 µs | **1.8 µs** | **0.98x** | **2.88x** | **2.85x** | **2.92x** |
| **twitter.json (0.62 MB)** | 4.99 ms | 3.33 ms | 1.81 ms | **1.85 ms** | **1.50x** ⚠️ | **2.75x** ⚠️ | **2.70x** ⚠️ | **1.81x** ⚠️ |
| **Geometric Mean** | — | — | — | — | **1.53x** | **2.77x** | **2.69x** | **1.76x** |
<!-- mdformat on -->

> ⚠️ 4 of 5 workloads in this table draw on samples flagged `is_robust_stable: false`. The Geometric Mean includes them and inherits their uncertainty.


------------------------------------------------------------------------

### 🎯 JS Target Detailed Breakdown

#### Detailed Breakdown: JS Decode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Tier 0: Stock + json_serial | Tier 1: New + json_serial | Tier 2: Stock + Codable [Mock] | Tier 3: New + Codable [Native] | Tier 1 vs Tier 0 (SDK + Substrate Build) | Tier 2 vs Tier 0 (Codable on Stock) | Speedup vs Tier 0 (Stock json_serial) | Speedup vs Tier 1 (New json_serial) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 4.64 ms | 4.60 ms | 2.85 ms | **2.91 ms** | **1.01x** ⚠️ | **1.63x** ⚠️ | **1.59x** | **1.58x** ⚠️ |
| **canada.json (2.25 MB)** | 33.50 ms | 47.33 ms | 15.86 ms | **17.00 ms** | **0.71x** ⚠️ | **2.11x** ⚠️ | **1.97x** ⚠️ | **2.78x** ⚠️ |
| **citm_catalog.json (1.73 MB)** | 11.85 ms | 11.30 ms | 6.59 ms | **6.64 ms** | **1.05x** ⚠️ | **1.80x** ⚠️ | **1.78x** ⚠️ | **1.70x** ⚠️ |
| **small.json (0.55 KB)** | 4.9 µs | 4.9 µs | 3.8 µs | **3.7 µs** | **1.00x** | **1.28x** ⚠️ | **1.32x** | **1.32x** |
| **twitter.json (0.62 MB)** | 4.21 ms | 3.86 ms | 3.55 ms | **3.27 ms** | **1.09x** ⚠️ | **1.18x** ⚠️ | **1.29x** ⚠️ | **1.18x** ⚠️ |
| **Geometric Mean** | — | — | — | — | **0.96x** | **1.56x** | **1.57x** | **1.64x** |
<!-- mdformat on -->

> ⚠️ 5 of 5 workloads in this table draw on samples flagged `is_robust_stable: false`. The Geometric Mean includes them and inherits their uncertainty.


#### Detailed Breakdown: JS Encode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Tier 0: Stock + json_serial | Tier 1: New + json_serial | Tier 2: Stock + Codable [Mock] | Tier 3: New + Codable [Native] | Tier 1 vs Tier 0 (SDK + Substrate Build) | Tier 2 vs Tier 0 (Codable on Stock) | Speedup vs Tier 0 (Stock json_serial) | Speedup vs Tier 1 (New json_serial) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 10.43 ms | 9.20 ms | 2.64 ms | **2.73 ms** | **1.13x** | **3.96x** | **3.82x** | **3.37x** |
| **canada.json (2.25 MB)** | 38.50 ms | 39.33 ms | 21.20 ms | **21.20 ms** | **0.98x** ⚠️ | **1.82x** ⚠️ | **1.82x** ⚠️ | **1.86x** ⚠️ |
| **citm_catalog.json (1.73 MB)** | 11.29 ms | 8.82 ms | 4.27 ms | **4.40 ms** | **1.28x** | **2.65x** | **2.56x** ⚠️ | **2.00x** ⚠️ |
| **small.json (0.55 KB)** | 7.1 µs | 38.5 µs | 2.6 µs | **2.5 µs** | **0.19x** ⚠️ | **2.75x** ⚠️ | **2.81x** | **15.14x** ⚠️ |
| **twitter.json (0.62 MB)** | 6.35 ms | 3.65 ms | 3.36 ms | **3.18 ms** | **1.74x** ⚠️ | **1.89x** ⚠️ | **2.00x** ⚠️ | **1.15x** ⚠️ |
| **Geometric Mean** | — | — | — | — | **0.86x** | **2.50x** | **2.51x** | **2.93x** |
<!-- mdformat on -->

> ⚠️ 4 of 5 workloads in this table draw on samples flagged `is_robust_stable: false`. The Geometric Mean includes them and inherits their uncertainty.


------------------------------------------------------------------------

### 🎯 WASM Target Detailed Breakdown

#### Detailed Breakdown: WASM Decode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Tier 0: Stock + json_serial | Tier 1: New + json_serial | Tier 2: Stock + Codable [Mock] | Tier 3: New + Codable [Native] | Tier 1 vs Tier 0 (SDK + Substrate Build) | Tier 2 vs Tier 0 (Codable on Stock) | Speedup vs Tier 0 (Stock json_serial) | Speedup vs Tier 1 (New json_serial) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 4.32 ms | 4.54 ms | 5.88 ms | **3.48 ms** | **0.95x** ⚠️ | **0.74x** ⚠️ | **1.24x** ⚠️ | **1.31x** ⚠️ |
| **canada.json (2.25 MB)** | 64.64 ms | 73.47 ms | 33.81 ms | **16.00 ms** | **0.88x** ⚠️ | **1.91x** ⚠️ | **4.04x** ⚠️ | **4.59x** ⚠️ |
| **citm_catalog.json (1.73 MB)** | 7.76 ms | 7.55 ms | 7.88 ms | **5.94 ms** | **1.03x** ⚠️ | **0.98x** ⚠️ | **1.31x** ⚠️ | **1.27x** |
| **small.json (0.55 KB)** | 3.4 µs | 3.6 µs | 4.5 µs | **3.7 µs** | **0.96x** ⚠️ | **0.76x** | **0.94x** | **0.97x** ⚠️ |
| **twitter.json (0.62 MB)** | 3.41 ms | 3.29 ms | 4.18 ms | **3.50 ms** | **1.03x** ⚠️ | **0.81x** | **0.97x** | **0.94x** ⚠️ |
| **Geometric Mean** | — | — | — | — | **0.97x** | **0.97x** | **1.43x** | **1.47x** |
<!-- mdformat on -->

> ⚠️ 5 of 5 workloads in this table draw on samples flagged `is_robust_stable: false`. The Geometric Mean includes them and inherits their uncertainty.


#### Detailed Breakdown: WASM Encode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Tier 0: Stock + json_serial | Tier 1: New + json_serial | Tier 2: Stock + Codable [Mock] | Tier 3: New + Codable [Native] | Tier 1 vs Tier 0 (SDK + Substrate Build) | Tier 2 vs Tier 0 (Codable on Stock) | Speedup vs Tier 0 (Stock json_serial) | Speedup vs Tier 1 (New json_serial) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 10.61 ms | 5.40 ms | 3.41 ms | **3.47 ms** | **1.97x** | **3.11x** | **3.05x** | **1.55x** |
| **canada.json (2.25 MB)** | 53.28 ms | 41.51 ms | 26.50 ms | **27.00 ms** | **1.28x** ⚠️ | **2.01x** ⚠️ | **1.97x** ⚠️ | **1.54x** ⚠️ |
| **citm_catalog.json (1.73 MB)** | 10.32 ms | 6.73 ms | 5.36 ms | **5.89 ms** | **1.53x** ⚠️ | **1.93x** ⚠️ | **1.75x** ⚠️ | **1.14x** ⚠️ |
| **small.json (0.55 KB)** | 5.7 µs | 6.4 µs | 3.3 µs | **3.3 µs** | **0.89x** | **1.73x** | **1.72x** ⚠️ | **1.93x** ⚠️ |
| **twitter.json (0.62 MB)** | 5.80 ms | 3.52 ms | 3.44 ms | **3.74 ms** | **1.65x** ⚠️ | **1.69x** ⚠️ | **1.55x** ⚠️ | **0.94x** ⚠️ |
| **Geometric Mean** | — | — | — | — | **1.41x** | **2.04x** | **1.95x** | **1.38x** |
<!-- mdformat on -->

> ⚠️ 4 of 5 workloads in this table draw on samples flagged `is_robust_stable: false`. The Geometric Mean includes them and inherits their uncertainty.


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

