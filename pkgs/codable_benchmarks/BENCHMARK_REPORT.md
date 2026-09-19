### 📝 Provenance

- **Run Timestamp**: 2026-09-19T11:56:02.798Z
- **Stock Dart SDK (Tier 0 & Tier 2)**: 3.14.0-247.0.dev (dev) (Fri Sep 18 21:02:24 2026 -0700) on "macos_arm64"
- **New Dart SDK (Tier 1 & Tier 3)**: 3.14.0-json-next.04411fb24e8ed6395eb858265d1214c192d23419 (main) (Fri Sep 18 23:25:20 2026 -0700) on "macos_arm64"
- **Repo Commit**: 03ff7b6b1d99b0387a278fd6c3b61cfcd02e6f70
- **Host OS**: macos, Hostname: kevmoo-mac.roam.internal
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
| **AOT (`dart compile exe`)** | **Tier 0: `Stock + json_serial`** | 🔴 `[ 26 / 62 / 96 ]` | **1.00x** / **0.93x** | 🔴 `[ 21 / 29 / 39 ]` | **1.00x** / **0.56x** |
| **AOT (`dart compile exe`)** | **Tier 1: `New + json_serial`** | 🔴 `[ 33 / 67 / 98 ]` | **1.08x** / **1.00x** | 🔴 `[ 34 / 52 / 100 ]` | **1.79x** / **1.00x** |
| **AOT (`dart compile exe`)** | **Tier 2: `Stock + Codable [Mock]`** | 🟡 `[ 57 / 79 / 94 ]` | **1.27x** / **1.18x** | 🟢 `[ 81 / 95 / 100 ]` | **3.28x** / **1.83x** |
| **AOT (`dart compile exe`)** | **Tier 3: `New + Codable [Native]`** | 🟢 `[ 100 / 100 / 100 ]` | **1.61x** / **1.50x** | 🟢 `[ 81 / 95 / 100 ]` | **3.26x** / **1.82x** |
| **JS (`dart2js` / Node 24 / V8)** | **Tier 0: `Stock + json_serial`** | 🔴 `[ 41 / 63 / 81 ]` | **1.00x** / **0.98x** | 🔴 `[ 27 / 40 / 56 ]` | **1.00x** / **1.22x** |
| **JS (`dart2js` / Node 24 / V8)** | **Tier 1: `New + json_serial`** | 🔴 `[ 42 / 64 / 84 ]` | **1.02x** / **1.00x** | 🔴 `[ 13 / 33 / 84 ]` | **0.82x** / **1.00x** |
| **JS (`dart2js` / Node 24 / V8)** | **Tier 2: `Stock + Codable [Mock]`** | 🟢 `[ 99 / 99 / 100 ]` | **1.58x** / **1.55x** | 🟢 `[ 88 / 94 / 100 ]` | **2.36x** / **2.89x** |
| **JS (`dart2js` / Node 24 / V8)** | **Tier 3: `New + Codable [Native]`** | 🟢 `[ 99 / 100 / 100 ]` | **1.59x** / **1.56x** | 🟢 `[ 98 / 100 / 100 ]` | **2.50x** / **3.06x** |
| **WASM (`dart2wasm` / Node 24 / V8)** | **Tier 0: `Stock + json_serial`** | 🔴 `[ 26 / 58 / 88 ]` | **1.00x** / **1.05x** | 🔴 `[ 37 / 50 / 59 ]` | **1.00x** / **0.57x** |
| **WASM (`dart2wasm` / Node 24 / V8)** | **Tier 1: `New + json_serial`** | 🔴 `[ 20 / 55 / 89 ]` | **0.95x** / **1.00x** | 🟡 `[ 73 / 88 / 100 ]` | **1.77x** / **1.00x** |
| **WASM (`dart2wasm` / Node 24 / V8)** | **Tier 2: `Stock + Codable [Mock]`** | 🔴 `[ 41 / 60 / 74 ]` | **1.03x** / **1.09x** | 🟢 `[ 85 / 96 / 100 ]` | **1.93x** / **1.09x** |
| **WASM (`dart2wasm` / Node 24 / V8)** | **Tier 3: `New + Codable [Native]`** | 🟢 `[ 100 / 100 / 100 ]` | **1.73x** / **1.82x** | 🟢 `[ 85 / 93 / 100 ]` | **1.86x** / **1.05x** |
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
| **AOT** | **1.030x** | `[1.039, 1.018, 1.033, 1.012, 1.049]` |
| **JS** | **1.012x** | `[1.030, 0.993, 1.038, 0.989, 1.012]` |
| **WASM** | **0.940x** | `[0.981, 0.748, 1.018, 0.969, 1.017]` |
<!-- mdformat on -->

> **Control candidate**: `json_serializable_literal` calls `jsonDecode(String)` plus `.fromJson()` hydration. Because the fork only alters the UTF-8 *byte* parser (`_JsonUtf8Parser`), its String parser is untouched — so a value away from `1.000x` is harness or build drift, not an intentional code effect. **Treat any speedup inside the control band as unresolved.**
>
> **Sample stability**: 1 of 180 measured cells (1%) are flagged `is_robust_stable: false` by the harness. Ratios involving them are marked ⚠️ in the breakdowns below and must not be quoted as measurements.

### 🎯 AOT Target Detailed Breakdown

#### Detailed Breakdown: AOT Decode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Tier 0: Stock + json_serial | Tier 1: New + json_serial | Tier 2: Stock + Codable [Mock] | Tier 3: New + Codable [Native] | Tier 1 vs Tier 0 (SDK + Substrate Build) | Tier 2 vs Tier 0 (Codable on Stock) | Speedup vs Tier 0 (Stock json_serial) | Speedup vs Tier 1 (New json_serial) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 1.79 ms | 1.73 ms | 1.54 ms | **1.19 ms** | **1.03x** | **1.16x** | **1.50x** | **1.46x** |
| **canada.json (2.25 MB)** | 20.36 ms | 15.79 ms | 9.19 ms | **5.23 ms** | **1.29x** | **2.21x** | **3.89x** | **3.02x** |
| **citm_catalog.json (1.73 MB)** | 3.37 ms | 3.19 ms | 2.33 ms | **2.16 ms** | **1.06x** | **1.45x** | **1.56x** | **1.48x** |
| **small.json (0.55 KB)** | 1.5 µs | 1.5 µs | 1.4 µs | **1.3 µs** | **1.01x** | **1.07x** | **1.14x** | **1.13x** |
| **twitter.json (0.62 MB)** | 1.44 ms | 1.41 ms | 1.75 ms | **1.38 ms** | **1.02x** | **0.82x** | **1.04x** | **1.02x** |
| **Geometric Mean** | — | — | — | — | **1.08x** | **1.27x** | **1.61x** | **1.50x** |
<!-- mdformat on -->


#### Detailed Breakdown: AOT Encode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Tier 0: Stock + json_serial | Tier 1: New + json_serial | Tier 2: Stock + Codable [Mock] | Tier 3: New + Codable [Native] | Tier 1 vs Tier 0 (SDK + Substrate Build) | Tier 2 vs Tier 0 (Codable on Stock) | Speedup vs Tier 0 (Stock json_serial) | Speedup vs Tier 1 (New json_serial) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 4.85 ms | 1.88 ms | 1.03 ms | **1.05 ms** | **2.58x** | **4.73x** | **4.63x** | **1.79x** |
| **canada.json (2.25 MB)** | 19.71 ms | 7.68 ms | 9.53 ms | **9.44 ms** | **2.56x** | **2.07x** | **2.09x** | **0.81x** |
| **citm_catalog.json (1.73 MB)** | 3.82 ms | 2.71 ms | 1.18 ms | **1.15 ms** | **1.41x** | **3.25x** | **3.33x** | **2.36x** |
| **small.json (0.55 KB)** | 2.3 µs | 2.1 µs | 0.7 µs | **0.7 µs** | **1.08x** | **3.14x** | **3.07x** | **2.85x** |
| **twitter.json (0.62 MB)** | 2.49 ms | 1.36 ms | 657.3 µs | **665.8 µs** | **1.84x** | **3.78x** | **3.74x** | **2.04x** |
| **Geometric Mean** | — | — | — | — | **1.79x** | **3.28x** | **3.26x** | **1.82x** |
<!-- mdformat on -->


------------------------------------------------------------------------

### 🎯 JS Target Detailed Breakdown

#### Detailed Breakdown: JS Decode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Tier 0: Stock + json_serial | Tier 1: New + json_serial | Tier 2: Stock + Codable [Mock] | Tier 3: New + Codable [Native] | Tier 1 vs Tier 0 (SDK + Substrate Build) | Tier 2 vs Tier 0 (Codable on Stock) | Speedup vs Tier 0 (Stock json_serial) | Speedup vs Tier 1 (New json_serial) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 1.77 ms | 1.70 ms | 1.03 ms | **1.02 ms** | **1.04x** | **1.72x** | **1.73x** | **1.66x** |
| **canada.json (2.25 MB)** | 15.63 ms | 15.43 ms | 6.50 ms | **6.47 ms** | **1.01x** | **2.40x** | **2.41x** | **2.38x** |
| **citm_catalog.json (1.73 MB)** | 4.25 ms | 4.20 ms | 2.95 ms | **2.92 ms** | **1.01x** | **1.44x** | **1.45x** | **1.44x** |
| **small.json (0.55 KB)** | 2.0 µs | 1.9 µs | 1.4 µs | **1.4 µs** | **1.01x** | **1.37x** | **1.36x** | **1.35x** |
| **twitter.json (0.62 MB)** | 1.48 ms | 1.44 ms | 1.21 ms | **1.20 ms** | **1.03x** | **1.22x** | **1.23x** | **1.20x** |
| **Geometric Mean** | — | — | — | — | **1.02x** | **1.58x** | **1.59x** | **1.56x** |
<!-- mdformat on -->


#### Detailed Breakdown: JS Encode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Tier 0: Stock + json_serial | Tier 1: New + json_serial | Tier 2: Stock + Codable [Mock] | Tier 3: New + Codable [Native] | Tier 1 vs Tier 0 (SDK + Substrate Build) | Tier 2 vs Tier 0 (Codable on Stock) | Speedup vs Tier 0 (Stock json_serial) | Speedup vs Tier 1 (New json_serial) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 4.52 ms | 6.00 ms | 1.23 ms | **1.25 ms** | **0.75x** ⚠️ | **3.67x** | **3.61x** | **4.79x** ⚠️ |
| **canada.json (2.25 MB)** | 15.86 ms | 27.50 ms | 10.00 ms | **8.82 ms** | **0.58x** | **1.59x** | **1.80x** | **3.12x** |
| **citm_catalog.json (1.73 MB)** | 4.25 ms | 3.45 ms | 1.88 ms | **1.75 ms** | **1.23x** | **2.26x** | **2.43x** | **1.97x** |
| **small.json (0.55 KB)** | 2.9 µs | 7.4 µs | 1.0 µs | **1.0 µs** | **0.38x** | **2.82x** | **2.94x** | **7.67x** |
| **twitter.json (0.62 MB)** | 2.70 ms | 1.52 ms | 1.37 ms | **1.27 ms** | **1.78x** | **1.98x** | **2.13x** | **1.20x** |
| **Geometric Mean** | — | — | — | — | **0.82x** | **2.36x** | **2.50x** | **3.06x** |
<!-- mdformat on -->

> ⚠️ 1 of 5 workloads in this table draw on samples flagged `is_robust_stable: false`. The Geometric Mean includes them and inherits their uncertainty.


------------------------------------------------------------------------

### 🎯 WASM Target Detailed Breakdown

#### Detailed Breakdown: WASM Decode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Tier 0: Stock + json_serial | Tier 1: New + json_serial | Tier 2: Stock + Codable [Mock] | Tier 3: New + Codable [Native] | Tier 1 vs Tier 0 (SDK + Substrate Build) | Tier 2 vs Tier 0 (Codable on Stock) | Speedup vs Tier 0 (Stock json_serial) | Speedup vs Tier 1 (New json_serial) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 2.06 ms | 2.09 ms | 2.16 ms | **1.25 ms** | **0.98x** | **0.95x** | **1.65x** | **1.68x** |
| **canada.json (2.25 MB)** | 19.70 ms | 25.86 ms | 12.48 ms | **5.08 ms** | **0.76x** | **1.58x** | **3.88x** | **5.09x** |
| **citm_catalog.json (1.73 MB)** | 2.98 ms | 2.97 ms | 3.02 ms | **1.88 ms** | **1.01x** | **0.99x** | **1.59x** | **1.58x** |
| **small.json (0.55 KB)** | 1.6 µs | 1.6 µs | 1.7 µs | **1.2 µs** | **1.00x** | **0.94x** | **1.32x** | **1.32x** |
| **twitter.json (0.62 MB)** | 1.47 ms | 1.45 ms | 1.75 ms | **1.29 ms** | **1.01x** | **0.84x** | **1.14x** | **1.13x** |
| **Geometric Mean** | — | — | — | — | **0.95x** | **1.03x** | **1.73x** | **1.82x** |
<!-- mdformat on -->


#### Detailed Breakdown: WASM Encode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Tier 0: Stock + json_serial | Tier 1: New + json_serial | Tier 2: Stock + Codable [Mock] | Tier 3: New + Codable [Native] | Tier 1 vs Tier 0 (SDK + Substrate Build) | Tier 2 vs Tier 0 (Codable on Stock) | Speedup vs Tier 0 (Stock json_serial) | Speedup vs Tier 1 (New json_serial) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 4.48 ms | 2.08 ms | 1.68 ms | **1.65 ms** | **2.16x** | **2.67x** | **2.71x** | **1.26x** |
| **canada.json (2.25 MB)** | 22.48 ms | 10.33 ms | 12.13 ms | **12.11 ms** | **2.18x** | **1.85x** | **1.86x** | **0.85x** |
| **citm_catalog.json (1.73 MB)** | 3.97 ms | 2.45 ms | 2.23 ms | **2.38 ms** | **1.62x** | **1.78x** | **1.67x** | **1.03x** |
| **small.json (0.55 KB)** | 2.3 µs | 1.8 µs | 1.3 µs | **1.3 µs** | **1.32x** | **1.82x** | **1.75x** | **1.32x** |
| **twitter.json (0.62 MB)** | 2.25 ms | 1.32 ms | 1.35 ms | **1.47 ms** | **1.71x** | **1.66x** | **1.53x** | **0.90x** |
| **Geometric Mean** | — | — | — | — | **1.77x** | **1.93x** | **1.86x** | **1.05x** |
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

