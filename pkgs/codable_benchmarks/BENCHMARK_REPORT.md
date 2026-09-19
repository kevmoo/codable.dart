### 📝 Provenance

- **Run Timestamp**: 2026-09-19T12:08:11.346Z
- **Stock Dart SDK (Tier 0 & Tier 2)**: 3.14.0-241.0.dev (dev) (Thu Sep 17 17:06:19 2026 -0700) on "linux_x64"
- **New Dart SDK (Tier 1 & Tier 3)**: 3.14.0-json-next.04411fb24e8ed6395eb858265d1214c192d23419 (main) (Fri Sep 18 23:25:20 2026 -0700) on "linux_x64"
- **Repo Commit**: 03ff7b6b1d99b0387a278fd6c3b61cfcd02e6f70
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
| **AOT (`dart compile exe`)** | **Tier 0: `Stock + json_serial`** | 🔴 `[ 26 / 61 / 100 ]` | **1.00x** / **0.97x** | 🔴 `[ 25 / 34 / 43 ]` | **1.00x** / **0.64x** |
| **AOT (`dart compile exe`)** | **Tier 1: `New + json_serial`** | 🔴 `[ 25 / 63 / 100 ]` | **1.03x** / **1.00x** | 🔴 `[ 31 / 53 / 100 ]` | **1.55x** / **1.00x** |
| **AOT (`dart compile exe`)** | **Tier 2: `Stock + Codable [Mock]`** | 🟡 `[ 56 / 77 / 97 ]` | **1.26x** / **1.22x** | 🟢 `[ 84 / 95 / 100 ]` | **2.77x** / **1.79x** |
| **AOT (`dart compile exe`)** | **Tier 3: `New + Codable [Native]`** | 🟢 `[ 93 / 98 / 100 ]` | **1.60x** / **1.56x** | 🟢 `[ 83 / 94 / 100 ]` | **2.75x** / **1.77x** |
| **JS (`dart2js` / Node 24 / V8)** | **Tier 0: `Stock + json_serial`** | 🔴 `[ 47 / 61 / 75 ]` | **1.00x** / **1.00x** | 🔴 `[ 25 / 39 / 51 ]` | **1.00x** / **1.09x** |
| **JS (`dart2js` / Node 24 / V8)** | **Tier 1: `New + json_serial`** | 🔴 `[ 38 / 61 / 84 ]` | **1.00x** / **1.00x** | 🔴 `[ 9 / 36 / 88 ]` | **0.92x** / **1.00x** |
| **JS (`dart2js` / Node 24 / V8)** | **Tier 2: `Stock + Codable [Mock]`** | 🟢 `[ 89 / 95 / 100 ]` | **1.56x** / **1.56x** | 🟢 `[ 93 / 97 / 100 ]` | **2.50x** / **2.73x** |
| **JS (`dart2js` / Node 24 / V8)** | **Tier 3: `New + Codable [Native]`** | 🟢 `[ 100 / 100 / 100 ]` | **1.65x** / **1.65x** | 🟢 `[ 99 / 100 / 100 ]` | **2.58x** / **2.81x** |
| **WASM (`dart2wasm` / Node 24 / V8)** | **Tier 0: `Stock + json_serial`** | 🔴 `[ 25 / 67 / 99 ]` | **1.00x** / **0.99x** | 🔴 `[ 32 / 49 / 59 ]` | **1.00x** / **0.63x** |
| **WASM (`dart2wasm` / Node 24 / V8)** | **Tier 1: `New + json_serial`** | 🔴 `[ 24 / 67 / 100 ]` | **1.01x** / **1.00x** | 🟡 `[ 54 / 78 / 100 ]` | **1.59x** / **1.00x** |
| **WASM (`dart2wasm` / Node 24 / V8)** | **Tier 2: `Stock + Codable [Mock]`** | 🔴 `[ 47 / 65 / 77 ]` | **0.97x** / **0.96x** | 🟢 `[ 99 / 100 / 100 ]` | **2.04x** / **1.28x** |
| **WASM (`dart2wasm` / Node 24 / V8)** | **Tier 3: `New + Codable [Native]`** | 🟢 `[ 92 / 97 / 100 ]` | **1.46x** / **1.44x** | 🟢 `[ 97 / 98 / 100 ]` | **2.00x** / **1.26x** |
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
| **AOT** | **1.006x** | `[0.970, 0.983, 0.978, 1.127, 0.981]` |
| **JS** | **1.010x** | `[1.050, 0.985, 1.008, 1.000, 1.009]` |
| **WASM** | **0.913x** | `[0.984, 0.710, 0.979, 0.948, 0.978]` |
<!-- mdformat on -->

> **Control candidate**: `json_serializable_literal` calls `jsonDecode(String)` plus `.fromJson()` hydration. Because the fork only alters the UTF-8 *byte* parser (`_JsonUtf8Parser`), its String parser is untouched — so a value away from `1.000x` is harness or build drift, not an intentional code effect. **Treat any speedup inside the control band as unresolved.**
>
> **Sample stability**: 80 of 180 measured cells (44%) are flagged `is_robust_stable: false` by the harness. Ratios involving them are marked ⚠️ in the breakdowns below and must not be quoted as measurements.

### 🎯 AOT Target Detailed Breakdown

#### Detailed Breakdown: AOT Decode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Tier 0: Stock + json_serial | Tier 1: New + json_serial | Tier 2: Stock + Codable [Mock] | Tier 3: New + Codable [Native] | Tier 1 vs Tier 0 (SDK + Substrate Build) | Tier 2 vs Tier 0 (Codable on Stock) | Speedup vs Tier 0 (Stock json_serial) | Speedup vs Tier 1 (New json_serial) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 4.45 ms | 4.10 ms | 3.88 ms | **2.62 ms** | **1.09x** ⚠️ | **1.15x** ⚠️ | **1.70x** ⚠️ | **1.56x** ⚠️ |
| **canada.json (2.25 MB)** | 46.45 ms | 48.60 ms | 21.89 ms | **12.21 ms** | **0.96x** ⚠️ | **2.12x** ⚠️ | **3.80x** ⚠️ | **3.98x** ⚠️ |
| **citm_catalog.json (1.73 MB)** | 8.33 ms | 7.62 ms | 5.03 ms | **4.86 ms** | **1.09x** ⚠️ | **1.65x** ⚠️ | **1.71x** ⚠️ | **1.57x** ⚠️ |
| **small.json (0.55 KB)** | 3.0 µs | 2.8 µs | 3.2 µs | **3.0 µs** | **1.05x** | **0.93x** | **0.97x** | **0.93x** |
| **twitter.json (0.62 MB)** | 3.17 ms | 3.26 ms | 3.77 ms | **3.20 ms** | **0.97x** ⚠️ | **0.84x** | **0.99x** | **1.02x** ⚠️ |
| **Geometric Mean** | — | — | — | — | **1.03x** | **1.26x** | **1.60x** | **1.56x** |
<!-- mdformat on -->

> ⚠️ 4 of 5 workloads in this table draw on samples flagged `is_robust_stable: false`. The Geometric Mean includes them and inherits their uncertainty.


#### Detailed Breakdown: AOT Encode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Tier 0: Stock + json_serial | Tier 1: New + json_serial | Tier 2: Stock + Codable [Mock] | Tier 3: New + Codable [Native] | Tier 1 vs Tier 0 (SDK + Substrate Build) | Tier 2 vs Tier 0 (Codable on Stock) | Speedup vs Tier 0 (Stock json_serial) | Speedup vs Tier 1 (New json_serial) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 10.20 ms | 4.89 ms | 2.57 ms | **2.84 ms** | **2.09x** ⚠️ | **3.97x** ⚠️ | **3.60x** ⚠️ | **1.72x** ⚠️ |
| **canada.json (2.25 MB)** | 47.77 ms | 20.71 ms | 24.77 ms | **24.80 ms** | **2.31x** ⚠️ | **1.93x** ⚠️ | **1.93x** ⚠️ | **0.83x** ⚠️ |
| **citm_catalog.json (1.73 MB)** | 9.58 ms | 6.60 ms | 3.52 ms | **3.38 ms** | **1.45x** ⚠️ | **2.72x** ⚠️ | **2.84x** ⚠️ | **1.95x** ⚠️ |
| **small.json (0.55 KB)** | 5.0 µs | 5.7 µs | 1.7 µs | **1.8 µs** | **0.88x** ⚠️ | **2.88x** | **2.85x** | **3.23x** ⚠️ |
| **twitter.json (0.62 MB)** | 4.99 ms | 3.44 ms | 1.81 ms | **1.79 ms** | **1.45x** ⚠️ | **2.75x** ⚠️ | **2.78x** | **1.92x** ⚠️ |
| **Geometric Mean** | — | — | — | — | **1.55x** | **2.77x** | **2.75x** | **1.77x** |
<!-- mdformat on -->

> ⚠️ 5 of 5 workloads in this table draw on samples flagged `is_robust_stable: false`. The Geometric Mean includes them and inherits their uncertainty.


------------------------------------------------------------------------

### 🎯 JS Target Detailed Breakdown

#### Detailed Breakdown: JS Decode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Tier 0: Stock + json_serial | Tier 1: New + json_serial | Tier 2: Stock + Codable [Mock] | Tier 3: New + Codable [Native] | Tier 1 vs Tier 0 (SDK + Substrate Build) | Tier 2 vs Tier 0 (Codable on Stock) | Speedup vs Tier 0 (Stock json_serial) | Speedup vs Tier 1 (New json_serial) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 4.64 ms | 4.45 ms | 2.85 ms | **2.60 ms** | **1.04x** | **1.63x** ⚠️ | **1.78x** | **1.71x** |
| **canada.json (2.25 MB)** | 33.50 ms | 41.33 ms | 15.86 ms | **15.80 ms** | **0.81x** ⚠️ | **2.11x** ⚠️ | **2.12x** ⚠️ | **2.62x** ⚠️ |
| **citm_catalog.json (1.73 MB)** | 11.85 ms | 11.27 ms | 6.59 ms | **6.50 ms** | **1.05x** ⚠️ | **1.80x** ⚠️ | **1.82x** ⚠️ | **1.73x** ⚠️ |
| **small.json (0.55 KB)** | 4.9 µs | 4.9 µs | 3.8 µs | **3.7 µs** | **1.01x** | **1.28x** ⚠️ | **1.33x** | **1.32x** |
| **twitter.json (0.62 MB)** | 4.21 ms | 3.75 ms | 3.55 ms | **3.15 ms** | **1.12x** ⚠️ | **1.18x** ⚠️ | **1.34x** ⚠️ | **1.19x** |
| **Geometric Mean** | — | — | — | — | **1.00x** | **1.56x** | **1.65x** | **1.65x** |
<!-- mdformat on -->

> ⚠️ 5 of 5 workloads in this table draw on samples flagged `is_robust_stable: false`. The Geometric Mean includes them and inherits their uncertainty.


#### Detailed Breakdown: JS Encode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Tier 0: Stock + json_serial | Tier 1: New + json_serial | Tier 2: Stock + Codable [Mock] | Tier 3: New + Codable [Native] | Tier 1 vs Tier 0 (SDK + Substrate Build) | Tier 2 vs Tier 0 (Codable on Stock) | Speedup vs Tier 0 (Stock json_serial) | Speedup vs Tier 1 (New json_serial) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 10.43 ms | 9.77 ms | 2.64 ms | **2.63 ms** | **1.07x** ⚠️ | **3.96x** | **3.96x** | **3.71x** ⚠️ |
| **canada.json (2.25 MB)** | 38.50 ms | 36.00 ms | 21.20 ms | **19.67 ms** | **1.07x** ⚠️ | **1.82x** ⚠️ | **1.96x** ⚠️ | **1.83x** |
| **citm_catalog.json (1.73 MB)** | 11.29 ms | 9.09 ms | 4.27 ms | **4.31 ms** | **1.24x** | **2.65x** | **2.62x** ⚠️ | **2.11x** ⚠️ |
| **small.json (0.55 KB)** | 7.1 µs | 27.8 µs | 2.6 µs | **2.6 µs** | **0.26x** ⚠️ | **2.75x** ⚠️ | **2.75x** ⚠️ | **10.73x** ⚠️ |
| **twitter.json (0.62 MB)** | 6.35 ms | 3.55 ms | 3.36 ms | **3.14 ms** | **1.79x** ⚠️ | **1.89x** ⚠️ | **2.02x** ⚠️ | **1.13x** ⚠️ |
| **Geometric Mean** | — | — | — | — | **0.92x** | **2.50x** | **2.58x** | **2.81x** |
<!-- mdformat on -->

> ⚠️ 5 of 5 workloads in this table draw on samples flagged `is_robust_stable: false`. The Geometric Mean includes them and inherits their uncertainty.


------------------------------------------------------------------------

### 🎯 WASM Target Detailed Breakdown

#### Detailed Breakdown: WASM Decode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Tier 0: Stock + json_serial | Tier 1: New + json_serial | Tier 2: Stock + Codable [Mock] | Tier 3: New + Codable [Native] | Tier 1 vs Tier 0 (SDK + Substrate Build) | Tier 2 vs Tier 0 (Codable on Stock) | Speedup vs Tier 0 (Stock json_serial) | Speedup vs Tier 1 (New json_serial) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 4.32 ms | 4.16 ms | 5.88 ms | **3.37 ms** | **1.04x** ⚠️ | **0.74x** ⚠️ | **1.28x** ⚠️ | **1.24x** ⚠️ |
| **canada.json (2.25 MB)** | 64.64 ms | 67.56 ms | 33.81 ms | **16.03 ms** | **0.96x** ⚠️ | **1.91x** ⚠️ | **4.03x** ⚠️ | **4.22x** ⚠️ |
| **citm_catalog.json (1.73 MB)** | 7.76 ms | 7.85 ms | 7.88 ms | **5.70 ms** | **0.99x** ⚠️ | **0.98x** ⚠️ | **1.36x** ⚠️ | **1.38x** ⚠️ |
| **small.json (0.55 KB)** | 3.4 µs | 3.4 µs | 4.5 µs | **3.7 µs** | **1.01x** | **0.76x** | **0.94x** | **0.92x** |
| **twitter.json (0.62 MB)** | 3.41 ms | 3.21 ms | 4.18 ms | **3.43 ms** | **1.06x** | **0.81x** | **0.99x** | **0.94x** |
| **Geometric Mean** | — | — | — | — | **1.01x** | **0.97x** | **1.46x** | **1.44x** |
<!-- mdformat on -->

> ⚠️ 3 of 5 workloads in this table draw on samples flagged `is_robust_stable: false`. The Geometric Mean includes them and inherits their uncertainty.


#### Detailed Breakdown: WASM Encode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Tier 0: Stock + json_serial | Tier 1: New + json_serial | Tier 2: Stock + Codable [Mock] | Tier 3: New + Codable [Native] | Tier 1 vs Tier 0 (SDK + Substrate Build) | Tier 2 vs Tier 0 (Codable on Stock) | Speedup vs Tier 0 (Stock json_serial) | Speedup vs Tier 1 (New json_serial) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 10.61 ms | 5.54 ms | 3.41 ms | **3.50 ms** | **1.91x** | **3.11x** | **3.03x** | **1.59x** |
| **canada.json (2.25 MB)** | 53.28 ms | 26.59 ms | 26.50 ms | **26.98 ms** | **2.00x** ⚠️ | **2.01x** ⚠️ | **1.98x** ⚠️ | **0.99x** |
| **citm_catalog.json (1.73 MB)** | 10.32 ms | 6.08 ms | 5.36 ms | **5.48 ms** | **1.70x** ⚠️ | **1.93x** ⚠️ | **1.88x** ⚠️ | **1.11x** ⚠️ |
| **small.json (0.55 KB)** | 5.7 µs | 6.1 µs | 3.3 µs | **3.4 µs** | **0.93x** | **1.73x** | **1.68x** ⚠️ | **1.80x** ⚠️ |
| **twitter.json (0.62 MB)** | 5.80 ms | 3.50 ms | 3.44 ms | **3.40 ms** | **1.66x** ⚠️ | **1.69x** ⚠️ | **1.71x** ⚠️ | **1.03x** ⚠️ |
| **Geometric Mean** | — | — | — | — | **1.59x** | **2.04x** | **2.00x** | **1.26x** |
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

