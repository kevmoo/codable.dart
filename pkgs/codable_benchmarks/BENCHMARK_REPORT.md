### 📝 Provenance

- **Run Timestamp**: 2026-09-18T21:19:13.841Z
- **Stock Dart SDK (Tier 0 & Tier 2)**: 3.14.0-241.0.dev (dev) (Thu Sep 17 17:06:19 2026 -0700) on "linux_x64"
- **New Dart SDK (Tier 1 & Tier 3)**: 3.14.0-edge.8045fcd2294b259f9a87e5abd1986c954a0ffbe0 (main) (Sat Sep 12 19:08:49 2026 -0700) on "linux_x64"
- **Repo Commit**: c1c55073793289db7c37c28c762ad8ae2d4e0dfa
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
| **AOT (`dart compile exe`)** | **Tier 0: `Stock + json_serial`** | 🔴 `[ 33 / 64 / 97 ]` | **1.00x** / **1.01x** | 🔴 `[ 28 / 34 / 48 ]` | **1.00x** / **0.64x** |
| **AOT (`dart compile exe`)** | **Tier 1: `New + json_serial`** | 🔴 `[ 25 / 63 / 100 ]` | **0.99x** / **1.00x** | 🔴 `[ 30 / 53 / 100 ]` | **1.56x** / **1.00x** |
| **AOT (`dart compile exe`)** | **Tier 2: `Stock + Codable [Mock]`** | 🟡 `[ 66 / 81 / 95 ]` | **1.26x** / **1.28x** | 🟢 `[ 93 / 97 / 100 ]` | **2.83x** / **1.82x** |
| **AOT (`dart compile exe`)** | **Tier 3: `New + Codable [Native]`** | 🟢 `[ 87 / 96 / 100 ]` | **1.49x** / **1.51x** | 🟢 `[ 93 / 97 / 100 ]` | **2.83x** / **1.82x** |
| **JS (`dart2js` / Node 24 / V8)** | **Tier 0: `Stock + json_serial`** | 🔴 `[ 40 / 61 / 75 ]` | **1.00x** / **0.98x** | 🔴 `[ 27 / 39 / 53 ]` | **1.00x** / **1.11x** |
| **JS (`dart2js` / Node 24 / V8)** | **Tier 1: `New + json_serial`** | 🔴 `[ 50 / 62 / 78 ]` | **1.02x** / **1.00x** | 🔴 `[ 8 / 36 / 87 ]` | **0.90x** / **1.00x** |
| **JS (`dart2js` / Node 24 / V8)** | **Tier 2: `Stock + Codable [Mock]`** | 🟢 `[ 92 / 98 / 100 ]` | **1.60x** / **1.57x** | 🟢 `[ 88 / 95 / 100 ]` | **2.41x** / **2.67x** |
| **JS (`dart2js` / Node 24 / V8)** | **Tier 3: `New + Codable [Native]`** | 🟢 `[ 93 / 99 / 100 ]` | **1.61x** / **1.58x** | 🟢 `[ 99 / 100 / 100 ]` | **2.52x** / **2.79x** |
| **WASM (`dart2wasm` / Node 24 / V8)** | **Tier 0: `Stock + json_serial`** | 🔴 `[ 34 / 60 / 95 ]` | **1.00x** / **0.91x** | 🔴 `[ 33 / 48 / 61 ]` | **1.00x** / **0.63x** |
| **WASM (`dart2wasm` / Node 24 / V8)** | **Tier 1: `New + json_serial`** | 🔴 `[ 24 / 66 / 100 ]` | **1.09x** / **1.00x** | 🟡 `[ 51 / 77 / 100 ]` | **1.59x** / **1.00x** |
| **WASM (`dart2wasm` / Node 24 / V8)** | **Tier 2: `Stock + Codable [Mock]`** | 🔴 `[ 47 / 65 / 77 ]` | **1.07x** / **0.98x** | 🟢 `[ 90 / 95 / 100 ]` | **1.97x** / **1.24x** |
| **WASM (`dart2wasm` / Node 24 / V8)** | **Tier 3: `New + Codable [Native]`** | 🟢 `[ 89 / 97 / 100 ]` | **1.60x** / **1.46x** | 🟢 `[ 98 / 99 / 100 ]` | **2.06x** / **1.30x** |
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
| **AOT** | **1.101x** | `[1.052, 1.502, 1.030, 1.015, 0.978]` |
| **JS** | **0.996x** | `[0.864, 1.033, 0.992, 1.044, 1.062]` |
| **WASM** | **0.966x** | `[0.932, 1.002, 0.861, 0.986, 1.060]` |
<!-- mdformat on -->

> **Control candidate**: `json_serializable_literal` calls `jsonDecode(String)` plus `.fromJson()` hydration. Because the fork only alters the UTF-8 *byte* parser (`_JsonUtf8Parser`), its String parser is untouched — so a value away from `1.000x` is harness or build drift, not an intentional code effect. (The AOT `canada` entry at `1.502x` is itself an unstable cell, not a speedup.) **Treat any speedup inside the control band as unresolved.**
>
> **Sample stability**: 110 of 180 measured cells (61%) are flagged `is_robust_stable: false` by the harness. Ratios involving them are marked ⚠️ in the breakdowns below and must not be quoted as measurements.

### 🎯 AOT Target Detailed Breakdown

#### Detailed Breakdown: AOT Decode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Tier 0: Stock + json_serial | Tier 1: New + json_serial | Tier 2: Stock + Codable [Mock] | Tier 3: New + Codable [Native] | Tier 1 vs Tier 0 (SDK + Substrate Build) | Tier 2 vs Tier 0 (Codable on Stock) | Speedup vs Tier 0 (Stock json_serial) | Speedup vs Tier 1 (New json_serial) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 4.35 ms | 3.90 ms | 3.39 ms | **2.64 ms** | **1.12x** ⚠️ | **1.28x** ⚠️ | **1.65x** ⚠️ | **1.48x** ⚠️ |
| **canada.json (2.25 MB)** | 41.57 ms | 54.57 ms | 21.07 ms | **13.85 ms** | **0.76x** ⚠️ | **1.97x** ⚠️ | **3.00x** ⚠️ | **3.94x** ⚠️ |
| **citm_catalog.json (1.73 MB)** | 8.34 ms | 8.07 ms | 5.10 ms | **4.84 ms** | **1.03x** ⚠️ | **1.64x** ⚠️ | **1.72x** ⚠️ | **1.67x** ⚠️ |
| **small.json (0.55 KB)** | 2.9 µs | 2.8 µs | 3.3 µs | **3.2 µs** | **1.03x** | **0.88x** | **0.90x** | **0.87x** |
| **twitter.json (0.62 MB)** | 3.24 ms | 3.13 ms | 3.72 ms | **3.34 ms** | **1.03x** ⚠️ | **0.87x** ⚠️ | **0.97x** ⚠️ | **0.94x** ⚠️ |
| **Geometric Mean** | — | — | — | — | **0.99x** | **1.26x** | **1.49x** | **1.51x** |
<!-- mdformat on -->

> ⚠️ 4 of 5 workloads in this table draw on samples flagged `is_robust_stable: false`. The Geometric Mean includes them and inherits their uncertainty.


#### Detailed Breakdown: AOT Encode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Tier 0: Stock + json_serial | Tier 1: New + json_serial | Tier 2: Stock + Codable [Mock] | Tier 3: New + Codable [Native] | Tier 1 vs Tier 0 (SDK + Substrate Build) | Tier 2 vs Tier 0 (Codable on Stock) | Speedup vs Tier 0 (Stock json_serial) | Speedup vs Tier 1 (New json_serial) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 10.74 ms | 5.26 ms | 3.08 ms | **3.05 ms** | **2.04x** ⚠️ | **3.49x** ⚠️ | **3.52x** ⚠️ | **1.72x** ⚠️ |
| **canada.json (2.25 MB)** | 49.29 ms | 23.45 ms | 25.32 ms | **25.33 ms** | **2.10x** ⚠️ | **1.95x** ⚠️ | **1.95x** ⚠️ | **0.93x** ⚠️ |
| **citm_catalog.json (1.73 MB)** | 9.48 ms | 6.46 ms | 3.47 ms | **3.39 ms** | **1.47x** ⚠️ | **2.73x** ⚠️ | **2.79x** ⚠️ | **1.90x** ⚠️ |
| **small.json (0.55 KB)** | 5.0 µs | 5.5 µs | 1.7 µs | **1.8 µs** | **0.90x** ⚠️ | **2.98x** ⚠️ | **2.79x** ⚠️ | **3.10x** |
| **twitter.json (0.62 MB)** | 6.17 ms | 3.82 ms | 1.89 ms | **1.80 ms** | **1.61x** ⚠️ | **3.27x** ⚠️ | **3.42x** ⚠️ | **2.12x** ⚠️ |
| **Geometric Mean** | — | — | — | — | **1.56x** | **2.83x** | **2.83x** | **1.82x** |
<!-- mdformat on -->

> ⚠️ 5 of 5 workloads in this table draw on samples flagged `is_robust_stable: false`. The Geometric Mean includes them and inherits their uncertainty.


------------------------------------------------------------------------

### 🎯 JS Target Detailed Breakdown

#### Detailed Breakdown: JS Decode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Tier 0: Stock + json_serial | Tier 1: New + json_serial | Tier 2: Stock + Codable [Mock] | Tier 3: New + Codable [Native] | Tier 1 vs Tier 0 (SDK + Substrate Build) | Tier 2 vs Tier 0 (Codable on Stock) | Speedup vs Tier 0 (Stock json_serial) | Speedup vs Tier 1 (New json_serial) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 4.57 ms | 4.43 ms | 2.63 ms | **2.59 ms** | **1.03x** ⚠️ | **1.74x** ⚠️ | **1.77x** ⚠️ | **1.71x** ⚠️ |
| **canada.json (2.25 MB)** | 40.67 ms | 32.50 ms | 16.60 ms | **16.40 ms** | **1.25x** ⚠️ | **2.45x** ⚠️ | **2.48x** ⚠️ | **1.98x** ⚠️ |
| **citm_catalog.json (1.73 MB)** | 9.33 ms | 11.75 ms | 6.25 ms | **6.17 ms** | **0.79x** ⚠️ | **1.49x** ⚠️ | **1.51x** ⚠️ | **1.91x** ⚠️ |
| **small.json (0.55 KB)** | 4.9 µs | 4.8 µs | 4.0 µs | **3.7 µs** | **1.02x** | **1.23x** | **1.33x** | **1.30x** |
| **twitter.json (0.62 MB)** | 4.00 ms | 3.82 ms | 3.00 ms | **3.24 ms** | **1.05x** ⚠️ | **1.33x** ⚠️ | **1.24x** ⚠️ | **1.18x** ⚠️ |
| **Geometric Mean** | — | — | — | — | **1.02x** | **1.60x** | **1.61x** | **1.58x** |
<!-- mdformat on -->

> ⚠️ 4 of 5 workloads in this table draw on samples flagged `is_robust_stable: false`. The Geometric Mean includes them and inherits their uncertainty.


#### Detailed Breakdown: JS Encode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Tier 0: Stock + json_serial | Tier 1: New + json_serial | Tier 2: Stock + Codable [Mock] | Tier 3: New + Codable [Native] | Tier 1 vs Tier 0 (SDK + Substrate Build) | Tier 2 vs Tier 0 (Codable on Stock) | Speedup vs Tier 0 (Stock json_serial) | Speedup vs Tier 1 (New json_serial) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 10.00 ms | 8.00 ms | 2.65 ms | **2.68 ms** | **1.25x** ⚠️ | **3.77x** ⚠️ | **3.73x** ⚠️ | **2.98x** |
| **canada.json (2.25 MB)** | 39.00 ms | 38.67 ms | 23.50 ms | **20.60 ms** | **1.01x** ⚠️ | **1.66x** ⚠️ | **1.89x** ⚠️ | **1.88x** |
| **citm_catalog.json (1.73 MB)** | 11.25 ms | 9.00 ms | 4.73 ms | **4.36 ms** | **1.25x** ⚠️ | **2.38x** ⚠️ | **2.58x** ⚠️ | **2.06x** ⚠️ |
| **small.json (0.55 KB)** | 7.2 µs | 32.7 µs | 2.5 µs | **2.6 µs** | **0.22x** ⚠️ | **2.86x** ⚠️ | **2.83x** ⚠️ | **12.82x** ⚠️ |
| **twitter.json (0.62 MB)** | 6.25 ms | 3.62 ms | 3.30 ms | **3.15 ms** | **1.73x** ⚠️ | **1.89x** ⚠️ | **1.98x** ⚠️ | **1.15x** ⚠️ |
| **Geometric Mean** | — | — | — | — | **0.90x** | **2.41x** | **2.52x** | **2.79x** |
<!-- mdformat on -->

> ⚠️ 5 of 5 workloads in this table draw on samples flagged `is_robust_stable: false`. The Geometric Mean includes them and inherits their uncertainty.


------------------------------------------------------------------------

### 🎯 WASM Target Detailed Breakdown

#### Detailed Breakdown: WASM Decode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Tier 0: Stock + json_serial | Tier 1: New + json_serial | Tier 2: Stock + Codable [Mock] | Tier 3: New + Codable [Native] | Tier 1 vs Tier 0 (SDK + Substrate Build) | Tier 2 vs Tier 0 (Codable on Stock) | Speedup vs Tier 0 (Stock json_serial) | Speedup vs Tier 1 (New json_serial) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 4.19 ms | 4.31 ms | 5.31 ms | **3.26 ms** | **0.97x** ⚠️ | **0.79x** ⚠️ | **1.29x** ⚠️ | **1.32x** ⚠️ |
| **canada.json (2.25 MB)** | 48.17 ms | 68.09 ms | 34.71 ms | **16.37 ms** | **0.71x** ⚠️ | **1.39x** ⚠️ | **2.94x** ⚠️ | **4.16x** |
| **citm_catalog.json (1.73 MB)** | 8.11 ms | 7.89 ms | 7.83 ms | **5.49 ms** | **1.03x** ⚠️ | **1.04x** ⚠️ | **1.48x** ⚠️ | **1.44x** ⚠️ |
| **small.json (0.55 KB)** | 7.0 µs | 3.3 µs | 4.3 µs | **3.5 µs** | **2.11x** ⚠️ | **1.63x** ⚠️ | **2.01x** ⚠️ | **0.95x** |
| **twitter.json (0.62 MB)** | 3.27 ms | 3.12 ms | 4.34 ms | **3.49 ms** | **1.05x** ⚠️ | **0.75x** ⚠️ | **0.94x** ⚠️ | **0.89x** |
| **Geometric Mean** | — | — | — | — | **1.09x** | **1.07x** | **1.60x** | **1.46x** |
<!-- mdformat on -->

> ⚠️ 5 of 5 workloads in this table draw on samples flagged `is_robust_stable: false`. The Geometric Mean includes them and inherits their uncertainty.


#### Detailed Breakdown: WASM Encode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Tier 0: Stock + json_serial | Tier 1: New + json_serial | Tier 2: Stock + Codable [Mock] | Tier 3: New + Codable [Native] | Tier 1 vs Tier 0 (SDK + Substrate Build) | Tier 2 vs Tier 0 (Codable on Stock) | Speedup vs Tier 0 (Stock json_serial) | Speedup vs Tier 1 (New json_serial) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 10.55 ms | 5.62 ms | 3.58 ms | **3.49 ms** | **1.88x** ⚠️ | **2.95x** ⚠️ | **3.02x** ⚠️ | **1.61x** ⚠️ |
| **canada.json (2.25 MB)** | 64.44 ms | 26.63 ms | 29.57 ms | **26.75 ms** | **2.42x** ⚠️ | **2.18x** ⚠️ | **2.41x** ⚠️ | **1.00x** ⚠️ |
| **citm_catalog.json (1.73 MB)** | 10.42 ms | 6.78 ms | 5.66 ms | **5.80 ms** | **1.54x** ⚠️ | **1.84x** ⚠️ | **1.80x** ⚠️ | **1.17x** ⚠️ |
| **small.json (0.55 KB)** | 5.8 µs | 6.6 µs | 3.5 µs | **3.4 µs** | **0.88x** ⚠️ | **1.67x** ⚠️ | **1.73x** ⚠️ | **1.95x** ⚠️ |
| **twitter.json (0.62 MB)** | 5.90 ms | 3.59 ms | 3.95 ms | **3.58 ms** | **1.64x** ⚠️ | **1.49x** ⚠️ | **1.65x** ⚠️ | **1.00x** ⚠️ |
| **Geometric Mean** | — | — | — | — | **1.59x** | **1.97x** | **2.06x** | **1.30x** |
<!-- mdformat on -->

> ⚠️ 5 of 5 workloads in this table draw on samples flagged `is_robust_stable: false`. The Geometric Mean includes them and inherits their uncertainty.


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

