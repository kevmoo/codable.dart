### 📝 Provenance

- **Run Timestamp**: 2026-10-01T23:49:25.721Z
- **Stock Dart SDK (Tier 0 & Tier 2)**: 3.14.0-271.0.dev (dev) (Fri Sep 25 05:03:10 2026 -0700) on "linux_x64"
- **New Dart SDK (Tier 1 & Tier 3)**: 3.14.0-json-next.c52b7fecede9a0324612382bdfe02bd0d793d6c0 (main) (Mon Sep 21 10:53:03 2026 -0700) on "linux_x64"
- **Repo Commit**: 4bde690b0e1ec50293248f580d4b27c8e74faa6e
- **Host OS**: linux, Hostname: bluefin
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
| **AOT (`dart compile exe`)** | **Tier 0: `Stock + json_serial`** | 🔴 `[ 20 / 57 / 100 ]` | **1.00x** / **0.93x** | 🔴 `[ 27 / 31 / 41 ]` | **1.00x** / **0.53x** |
| **AOT (`dart compile exe`)** | **Tier 1: `New + json_serial`** | 🔴 `[ 30 / 61 / 99 ]` | **1.07x** / **1.00x** | 🔴 `[ 46 / 58 / 100 ]` | **1.89x** / **1.00x** |
| **AOT (`dart compile exe`)** | **Tier 2: `Stock + Codable [Mock]`** | 🟡 `[ 63 / 78 / 100 ]` | **1.37x** / **1.28x** | 🟢 `[ 80 / 92 / 99 ]` | **3.00x** / **1.59x** |
| **AOT (`dart compile exe`)** | **Tier 3: `New + Codable [Native]`** | 🟢 `[ 94 / 98 / 100 ]` | **1.72x** / **1.60x** | 🟢 `[ 77 / 95 / 100 ]` | **3.09x** / **1.64x** |
| **JS (`dart2js` / Node 24 / V8)** | **Tier 0: `Stock + json_serial`** | 🔴 `[ 35 / 58 / 81 ]` | **1.00x** / **1.03x** | 🔴 `[ 34 / 45 / 64 ]` | **1.00x** / **0.76x** |
| **JS (`dart2js` / Node 24 / V8)** | **Tier 1: `New + json_serial`** | 🔴 `[ 33 / 57 / 81 ]` | **0.97x** / **1.00x** | 🔴 `[ 40 / 60 / 95 ]` | **1.31x** / **1.00x** |
| **JS (`dart2js` / Node 24 / V8)** | **Tier 2: `Stock + Codable [Mock]`** | 🟢 `[ 99 / 100 / 100 ]` | **1.71x** / **1.75x** | 🟢 `[ 100 / 100 / 100 ]` | **2.20x** / **1.67x** |
| **JS (`dart2js` / Node 24 / V8)** | **Tier 3: `New + Codable [Native]`** | 🟢 `[ 99 / 100 / 100 ]` | **1.71x** / **1.76x** | 🟢 `[ 99 / 99 / 100 ]` | **2.19x** / **1.67x** |
| **WASM (`dart2wasm` / Node 24 / V8)** | **Tier 0: `Stock + json_serial`** | 🔴 `[ 24 / 62 / 97 ]` | **1.00x** / **0.92x** | 🔴 `[ 36 / 53 / 65 ]` | **1.00x** / **0.58x** |
| **WASM (`dart2wasm` / Node 24 / V8)** | **Tier 1: `New + json_serial`** | 🔴 `[ 30 / 67 / 100 ]` | **1.09x** / **1.00x** | 🟢 `[ 68 / 91 / 100 ]` | **1.73x** / **1.00x** |
| **WASM (`dart2wasm` / Node 24 / V8)** | **Tier 2: `Stock + Codable [Mock]`** | 🟡 `[ 54 / 70 / 89 ]` | **1.14x** / **1.05x** | 🟢 `[ 69 / 92 / 100 ]` | **1.76x** / **1.02x** |
| **WASM (`dart2wasm` / Node 24 / V8)** | **Tier 3: `New + Codable [Native]`** | 🟢 `[ 94 / 98 / 100 ]` | **1.58x** / **1.45x** | 🟢 `[ 72 / 92 / 100 ]` | **1.75x** / **1.01x** |
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
| **AOT** | **0.972x** | `[0.973, 1.001, 0.943, 0.977, 0.966]` |
| **JS** | **0.955x** | `[0.938, 1.099, 0.801, 0.970, 0.990]` |
| **WASM** | **0.961x** | `[0.971, 0.997, 0.985, 0.863, 0.999]` |
<!-- mdformat on -->

<!-- mdformat off(prevent table wrapping) -->
| Target Runtime | Encode Control Drift (Tier 1 / Tier 0) | Per-Dataset Control Ratios |
| :--- | :---: | :--- |
| **AOT** | **0.992x** | `[1.005, 0.993, 1.024, 0.974, 0.965]` |
| **JS** | **1.024x** | `[0.816, 1.043, 0.998, 1.058, 1.256]` |
| **WASM** | **1.003x** | `[0.987, 1.005, 1.019, 0.997, 1.008]` |
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
> **Sample stability**: 36 of 210 measured cells (17%) are flagged `is_robust_stable: false` by the harness. Ratios involving them are marked ⚠️ in the breakdowns below and must not be quoted as measurements.

### 🎯 AOT Target Detailed Breakdown

#### Detailed Breakdown: AOT Decode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Tier 0: Stock + json_serial | Tier 1: New + json_serial | Tier 2: Stock + Codable [Mock] | Tier 3: New + Codable [Native] | Tier 1 vs Tier 0 (SDK + Substrate Build) | Tier 2 vs Tier 0 (Codable on Stock) | Speedup vs Tier 0 (Stock json_serial) | Speedup vs Tier 1 (New json_serial) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 2.16 ms | 2.15 ms | 1.69 ms | **1.18 ms** | **1.00x** | **1.28x** | **1.83x** | **1.82x** |
| **canada.json (2.25 MB)** | 31.68 ms | 21.53 ms | 10.32 ms | **6.47 ms** | **1.47x** ⚠️ | **3.07x** | **4.89x** | **3.33x** ⚠️ |
| **citm_catalog.json (1.73 MB)** | 4.43 ms | 4.39 ms | 2.39 ms | **2.43 ms** | **1.01x** | **1.86x** | **1.82x** | **1.81x** |
| **small.json (0.55 KB)** | 1.5 µs | 1.6 µs | 1.7 µs | **1.5 µs** | **0.97x** | **0.91x** | **0.99x** | **1.02x** |
| **twitter.json (0.62 MB)** | 1.53 ms | 1.54 ms | 2.06 ms | **1.63 ms** | **0.99x** | **0.74x** | **0.94x** | **0.94x** |
| **Geometric Mean** | — | — | — | — | **1.07x** | **1.37x** | **1.72x** | **1.60x** |
<!-- mdformat on -->

> ⚠️ 1 of 5 workloads in this table draw on samples flagged `is_robust_stable: false`. The Geometric Mean includes them and inherits their uncertainty.


#### Detailed Breakdown: AOT Encode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Tier 0: Stock + json_serial | Tier 1: New + json_serial | Tier 2: Stock + Codable [Mock] | Tier 3: New + Codable [Native] | Tier 1 vs Tier 0 (SDK + Substrate Build) | Tier 2 vs Tier 0 (Codable on Stock) | Speedup vs Tier 0 (Stock json_serial) | Speedup vs Tier 1 (New json_serial) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 5.39 ms | 2.62 ms | 1.62 ms | **1.46 ms** | **2.06x** | **3.34x** | **3.69x** | **1.79x** |
| **canada.json (2.25 MB)** | 26.37 ms | 10.76 ms | 13.51 ms | **13.96 ms** | **2.45x** ⚠️ | **1.95x** ⚠️ | **1.89x** ⚠️ | **0.77x** ⚠️ |
| **citm_catalog.json (1.73 MB)** | 4.46 ms | 3.27 ms | 1.53 ms | **1.52 ms** | **1.36x** | **2.91x** | **2.94x** | **2.16x** |
| **small.json (0.55 KB)** | 2.9 µs | 1.7 µs | 0.8 µs | **0.8 µs** | **1.69x** | **3.49x** ⚠️ | **3.66x** | **2.17x** |
| **twitter.json (0.62 MB)** | 3.28 ms | 1.59 ms | 890.2 µs | **874.7 µs** | **2.06x** ⚠️ | **3.68x** ⚠️ | **3.75x** ⚠️ | **1.82x** ⚠️ |
| **Geometric Mean** | — | — | — | — | **1.89x** | **3.00x** | **3.09x** | **1.64x** |
<!-- mdformat on -->

> ⚠️ 3 of 5 workloads in this table draw on samples flagged `is_robust_stable: false`. The Geometric Mean includes them and inherits their uncertainty.


------------------------------------------------------------------------

### 🎯 JS Target Detailed Breakdown

#### Detailed Breakdown: JS Decode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Tier 0: Stock + json_serial | Tier 1: New + json_serial | Tier 2: Stock + Codable [Mock] | Tier 3: New + Codable [Native] | Tier 1 vs Tier 0 (SDK + Substrate Build) | Tier 2 vs Tier 0 (Codable on Stock) | Speedup vs Tier 0 (Stock json_serial) | Speedup vs Tier 1 (New json_serial) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 2.54 ms | 2.59 ms | 1.49 ms | **1.48 ms** | **0.98x** | **1.71x** | **1.72x** | **1.75x** |
| **canada.json (2.25 MB)** | 24.33 ms | 25.50 ms | 8.55 ms | **8.50 ms** | **0.95x** ⚠️ | **2.85x** ⚠️ | **2.86x** ⚠️ | **3.00x** ⚠️ |
| **citm_catalog.json (1.73 MB)** | 6.81 ms | 7.21 ms | 3.66 ms | **3.63 ms** | **0.94x** ⚠️ | **1.86x** ⚠️ | **1.88x** ⚠️ | **1.99x** ⚠️ |
| **small.json (0.55 KB)** | 2.6 µs | 2.6 µs | 2.0 µs | **2.0 µs** | **0.99x** | **1.29x** | **1.29x** | **1.29x** |
| **twitter.json (0.62 MB)** | 2.08 ms | 2.08 ms | 1.68 ms | **1.69 ms** | **1.00x** | **1.24x** | **1.23x** | **1.23x** |
| **Geometric Mean** | — | — | — | — | **0.97x** | **1.71x** | **1.71x** | **1.76x** |
<!-- mdformat on -->

> ⚠️ 2 of 5 workloads in this table draw on samples flagged `is_robust_stable: false`. The Geometric Mean includes them and inherits their uncertainty.


#### Detailed Breakdown: JS Encode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Tier 0: Stock + json_serial | Tier 1: New + json_serial | Tier 2: Stock + Codable [Mock] | Tier 3: New + Codable [Native] | Tier 1 vs Tier 0 (SDK + Substrate Build) | Tier 2 vs Tier 0 (Codable on Stock) | Speedup vs Tier 0 (Stock json_serial) | Speedup vs Tier 1 (New json_serial) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 4.67 ms | 3.62 ms | 1.58 ms | **1.60 ms** | **1.29x** | **2.95x** | **2.91x** | **2.26x** |
| **canada.json (2.25 MB)** | 19.00 ms | 15.38 ms | 12.25 ms | **12.25 ms** | **1.24x** ⚠️ | **1.55x** | **1.55x** | **1.26x** ⚠️ |
| **citm_catalog.json (1.73 MB)** | 5.42 ms | 4.12 ms | 2.39 ms | **2.40 ms** | **1.32x** | **2.27x** | **2.26x** | **1.72x** |
| **small.json (0.55 KB)** | 3.8 µs | 3.3 µs | 1.3 µs | **1.3 µs** | **1.15x** | **2.89x** | **2.90x** | **2.53x** |
| **twitter.json (0.62 MB)** | 2.97 ms | 1.84 ms | 1.74 ms | **1.76 ms** | **1.62x** | **1.71x** | **1.69x** | **1.05x** |
| **Geometric Mean** | — | — | — | — | **1.31x** | **2.20x** | **2.19x** | **1.67x** |
<!-- mdformat on -->

> ⚠️ 1 of 5 workloads in this table draw on samples flagged `is_robust_stable: false`. The Geometric Mean includes them and inherits their uncertainty.


------------------------------------------------------------------------

### 🎯 WASM Target Detailed Breakdown

#### Detailed Breakdown: WASM Decode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Tier 0: Stock + json_serial | Tier 1: New + json_serial | Tier 2: Stock + Codable [Mock] | Tier 3: New + Codable [Native] | Tier 1 vs Tier 0 (SDK + Substrate Build) | Tier 2 vs Tier 0 (Codable on Stock) | Speedup vs Tier 0 (Stock json_serial) | Speedup vs Tier 1 (New json_serial) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 2.35 ms | 2.28 ms | 2.63 ms | **1.60 ms** | **1.03x** | **0.89x** | **1.46x** | **1.42x** |
| **canada.json (2.25 MB)** | 39.46 ms | 31.27 ms | 17.43 ms | **9.40 ms** | **1.26x** ⚠️ | **2.26x** ⚠️ | **4.20x** ⚠️ | **3.33x** ⚠️ |
| **citm_catalog.json (1.73 MB)** | 4.75 ms | 4.38 ms | 3.87 ms | **2.88 ms** | **1.08x** ⚠️ | **1.23x** | **1.65x** | **1.52x** ⚠️ |
| **small.json (0.55 KB)** | 1.8 µs | 1.8 µs | 2.0 µs | **1.9 µs** | **1.04x** | **0.92x** | **0.97x** | **0.94x** |
| **twitter.json (0.62 MB)** | 1.80 ms | 1.72 ms | 2.15 ms | **1.81 ms** | **1.04x** | **0.83x** | **0.99x** | **0.95x** |
| **Geometric Mean** | — | — | — | — | **1.09x** | **1.14x** | **1.58x** | **1.45x** |
<!-- mdformat on -->

> ⚠️ 2 of 5 workloads in this table draw on samples flagged `is_robust_stable: false`. The Geometric Mean includes them and inherits their uncertainty.


#### Detailed Breakdown: WASM Encode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Tier 0: Stock + json_serial | Tier 1: New + json_serial | Tier 2: Stock + Codable [Mock] | Tier 3: New + Codable [Native] | Tier 1 vs Tier 0 (SDK + Substrate Build) | Tier 2 vs Tier 0 (Codable on Stock) | Speedup vs Tier 0 (Stock json_serial) | Speedup vs Tier 1 (New json_serial) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 5.36 ms | 2.84 ms | 1.94 ms | **1.92 ms** | **1.89x** | **2.77x** | **2.79x** | **1.48x** |
| **canada.json (2.25 MB)** | 27.04 ms | 12.18 ms | 17.70 ms | **16.93 ms** | **2.22x** | **1.53x** | **1.60x** | **0.72x** |
| **citm_catalog.json (1.73 MB)** | 4.56 ms | 2.98 ms | 3.03 ms | **3.13 ms** | **1.53x** | **1.50x** | **1.46x** | **0.95x** |
| **small.json (0.55 KB)** | 2.8 µs | 1.8 µs | 1.7 µs | **1.8 µs** | **1.57x** | **1.63x** | **1.59x** | **1.01x** |
| **twitter.json (0.62 MB)** | 3.00 ms | 1.96 ms | 1.86 ms | **1.87 ms** | **1.53x** | **1.62x** | **1.61x** | **1.05x** |
| **Geometric Mean** | — | — | — | — | **1.73x** | **1.76x** | **1.75x** | **1.01x** |
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

