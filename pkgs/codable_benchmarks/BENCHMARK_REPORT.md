### 📝 Provenance

- **Run Timestamp**: 2026-09-21T23:12:46.756Z
- **Stock Dart SDK (Tier 0 & Tier 2)**: 3.14.0-248.0.dev (dev) (Sat Sep 19 01:09:06 2026 -0700) on "linux_x64"
- **New Dart SDK (Tier 1 & Tier 3)**: 3.14.0-json-next.c52b7fecede9a0324612382bdfe02bd0d793d6c0 (main) (Mon Sep 21 10:53:03 2026 -0700) on "linux_x64"
- **Repo Commit**: 5582224fe5589c940ffdf3957a4b1e1206ad1bb1
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
| **AOT (`dart compile exe`)** | **Tier 0: `Stock + json_serial`** | 🔴 `[ 24 / 61 / 100 ]` | **1.00x** / **0.94x** | 🔴 `[ 26 / 31 / 39 ]` | **1.00x** / **0.51x** |
| **AOT (`dart compile exe`)** | **Tier 1: `New + json_serial`** | 🔴 `[ 34 / 65 / 99 ]` | **1.06x** / **1.00x** | 🔴 `[ 50 / 61 / 100 ]` | **1.96x** / **1.00x** |
| **AOT (`dart compile exe`)** | **Tier 2: `Stock + Codable [Mock]`** | 🟡 `[ 63 / 79 / 98 ]` | **1.29x** / **1.21x** | 🟢 `[ 83 / 96 / 100 ]` | **3.11x** / **1.58x** |
| **AOT (`dart compile exe`)** | **Tier 3: `New + Codable [Native]`** | 🟢 `[ 92 / 98 / 100 ]` | **1.62x** / **1.52x** | 🟢 `[ 85 / 96 / 100 ]` | **3.12x** / **1.59x** |
| **JS (`dart2js` / Node 24 / V8)** | **Tier 0: `Stock + json_serial`** | 🔴 `[ 35 / 57 / 78 ]` | **1.00x** / **1.02x** | 🔴 `[ 30 / 42 / 60 ]` | **1.00x** / **0.74x** |
| **JS (`dart2js` / Node 24 / V8)** | **Tier 1: `New + json_serial`** | 🔴 `[ 31 / 56 / 80 ]` | **0.98x** / **1.00x** | 🔴 `[ 33 / 58 / 95 ]` | **1.36x** / **1.00x** |
| **JS (`dart2js` / Node 24 / V8)** | **Tier 2: `Stock + Codable [Mock]`** | 🟢 `[ 99 / 100 / 100 ]` | **1.74x** / **1.78x** | 🟢 `[ 99 / 99 / 100 ]` | **2.34x** / **1.72x** |
| **JS (`dart2js` / Node 24 / V8)** | **Tier 3: `New + Codable [Native]`** | 🟢 `[ 93 / 98 / 100 ]` | **1.71x** / **1.75x** | 🟢 `[ 99 / 100 / 100 ]` | **2.35x** / **1.73x** |
| **WASM (`dart2wasm` / Node 24 / V8)** | **Tier 0: `Stock + json_serial`** | 🔴 `[ 26 / 65 / 98 ]` | **1.00x** / **0.91x** | 🔴 `[ 35 / 52 / 63 ]` | **1.00x** / **0.58x** |
| **WASM (`dart2wasm` / Node 24 / V8)** | **Tier 1: `New + json_serial`** | 🟡 `[ 35 / 71 / 100 ]` | **1.10x** / **1.00x** | 🟢 `[ 66 / 91 / 100 ]` | **1.73x** / **1.00x** |
| **WASM (`dart2wasm` / Node 24 / V8)** | **Tier 2: `Stock + Codable [Mock]`** | 🔴 `[ 54 / 69 / 82 ]` | **1.07x** / **0.97x** | 🟢 `[ 85 / 96 / 100 ]` | **1.84x** / **1.06x** |
| **WASM (`dart2wasm` / Node 24 / V8)** | **Tier 3: `New + Codable [Native]`** | 🟢 `[ 88 / 96 / 100 ]` | **1.49x** / **1.35x** | 🟢 `[ 85 / 97 / 100 ]` | **1.85x** / **1.07x** |
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
| **AOT** | **1.003x** | `[1.020, 1.011, 0.988, 1.008, 0.986]` |
| **JS** | **0.972x** | `[0.971, 0.912, 0.982, 1.000, 1.000]` |
| **WASM** | **1.016x** | `[0.988, 1.050, 1.040, 0.995, 1.010]` |
<!-- mdformat on -->

<!-- mdformat off(prevent table wrapping) -->
| Target Runtime | Encode Control Drift (Tier 1 / Tier 0) | Per-Dataset Control Ratios |
| :--- | :---: | :--- |
| **AOT** | **1.021x** | `[1.005, 1.026, 1.066, 0.965, 1.044]` |
| **JS** | **0.947x** | `[0.767, 1.022, 1.020, 0.950, 1.003]` |
| **WASM** | **1.000x** | `[0.970, 1.005, 1.022, 1.009, 0.994]` |
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
> **Sample stability**: 21 of 210 measured cells (10%) are flagged `is_robust_stable: false` by the harness. Ratios involving them are marked ⚠️ in the breakdowns below and must not be quoted as measurements.

### 🎯 AOT Target Detailed Breakdown

#### Detailed Breakdown: AOT Decode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Tier 0: Stock + json_serial | Tier 1: New + json_serial | Tier 2: Stock + Codable [Mock] | Tier 3: New + Codable [Native] | Tier 1 vs Tier 0 (SDK + Substrate Build) | Tier 2 vs Tier 0 (Codable on Stock) | Speedup vs Tier 0 (Stock json_serial) | Speedup vs Tier 1 (New json_serial) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 2.21 ms | 2.14 ms | 1.98 ms | **1.45 ms** | **1.03x** | **1.12x** | **1.53x** | **1.48x** |
| **canada.json (2.25 MB)** | 27.59 ms | 19.25 ms | 10.43 ms | **6.52 ms** | **1.43x** ⚠️ | **2.65x** | **4.23x** | **2.95x** ⚠️ |
| **citm_catalog.json (1.73 MB)** | 4.25 ms | 4.49 ms | 2.39 ms | **2.34 ms** | **0.95x** ⚠️ | **1.78x** | **1.82x** | **1.92x** ⚠️ |
| **small.json (0.55 KB)** | 1.5 µs | 1.5 µs | 1.7 µs | **1.5 µs** | **0.99x** | **0.91x** | **1.02x** | **1.04x** |
| **twitter.json (0.62 MB)** | 1.53 ms | 1.55 ms | 2.05 ms | **1.66 ms** | **0.99x** | **0.75x** | **0.92x** | **0.93x** |
| **Geometric Mean** | — | — | — | — | **1.06x** | **1.29x** | **1.62x** | **1.52x** |
<!-- mdformat on -->

> ⚠️ 2 of 5 workloads in this table draw on samples flagged `is_robust_stable: false`. The Geometric Mean includes them and inherits their uncertainty.


#### Detailed Breakdown: AOT Encode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Tier 0: Stock + json_serial | Tier 1: New + json_serial | Tier 2: Stock + Codable [Mock] | Tier 3: New + Codable [Native] | Tier 1 vs Tier 0 (SDK + Substrate Build) | Tier 2 vs Tier 0 (Codable on Stock) | Speedup vs Tier 0 (Stock json_serial) | Speedup vs Tier 1 (New json_serial) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 5.51 ms | 2.57 ms | 1.44 ms | **1.46 ms** | **2.15x** | **3.82x** | **3.78x** | **1.76x** |
| **canada.json (2.25 MB)** | 27.25 ms | 10.68 ms | 12.81 ms | **12.53 ms** | **2.55x** | **2.13x** | **2.17x** | **0.85x** |
| **citm_catalog.json (1.73 MB)** | 4.83 ms | 3.31 ms | 1.66 ms | **1.66 ms** | **1.46x** ⚠️ | **2.91x** | **2.90x** | **1.99x** ⚠️ |
| **small.json (0.55 KB)** | 3.1 µs | 1.7 µs | 0.9 µs | **0.9 µs** | **1.82x** | **3.45x** | **3.43x** | **1.89x** |
| **twitter.json (0.62 MB)** | 3.21 ms | 1.59 ms | 907.0 µs | **881.9 µs** | **2.02x** | **3.54x** | **3.64x** | **1.80x** |
| **Geometric Mean** | — | — | — | — | **1.96x** | **3.11x** | **3.12x** | **1.59x** |
<!-- mdformat on -->

> ⚠️ 1 of 5 workloads in this table draw on samples flagged `is_robust_stable: false`. The Geometric Mean includes them and inherits their uncertainty.


------------------------------------------------------------------------

### 🎯 JS Target Detailed Breakdown

#### Detailed Breakdown: JS Decode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Tier 0: Stock + json_serial | Tier 1: New + json_serial | Tier 2: Stock + Codable [Mock] | Tier 3: New + Codable [Native] | Tier 1 vs Tier 0 (SDK + Substrate Build) | Tier 2 vs Tier 0 (Codable on Stock) | Speedup vs Tier 0 (Stock json_serial) | Speedup vs Tier 1 (New json_serial) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 2.50 ms | 2.62 ms | 1.48 ms | **1.48 ms** | **0.96x** | **1.69x** | **1.69x** | **1.77x** |
| **canada.json (2.25 MB)** | 23.25 ms | 26.00 ms | 8.15 ms | **8.23 ms** | **0.89x** ⚠️ | **2.85x** ⚠️ | **2.82x** ⚠️ | **3.16x** ⚠️ |
| **citm_catalog.json (1.73 MB)** | 6.69 ms | 6.47 ms | 3.34 ms | **3.61 ms** | **1.03x** ⚠️ | **2.00x** ⚠️ | **1.85x** ⚠️ | **1.79x** ⚠️ |
| **small.json (0.55 KB)** | 2.6 µs | 2.6 µs | 2.0 µs | **2.0 µs** | **1.00x** | **1.29x** | **1.31x** | **1.31x** |
| **twitter.json (0.62 MB)** | 2.10 ms | 2.06 ms | 1.65 ms | **1.65 ms** | **1.02x** | **1.28x** | **1.28x** | **1.25x** |
| **Geometric Mean** | — | — | — | — | **0.98x** | **1.74x** | **1.71x** | **1.75x** |
<!-- mdformat on -->

> ⚠️ 2 of 5 workloads in this table draw on samples flagged `is_robust_stable: false`. The Geometric Mean includes them and inherits their uncertainty.


#### Detailed Breakdown: JS Encode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Tier 0: Stock + json_serial | Tier 1: New + json_serial | Tier 2: Stock + Codable [Mock] | Tier 3: New + Codable [Native] | Tier 1 vs Tier 0 (SDK + Substrate Build) | Tier 2 vs Tier 0 (Codable on Stock) | Speedup vs Tier 0 (Stock json_serial) | Speedup vs Tier 1 (New json_serial) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 4.73 ms | 3.45 ms | 1.43 ms | **1.42 ms** | **1.37x** | **3.31x** | **3.32x** | **2.42x** |
| **canada.json (2.25 MB)** | 18.17 ms | 13.63 ms | 11.00 ms | **10.89 ms** | **1.33x** ⚠️ | **1.65x** | **1.67x** | **1.25x** ⚠️ |
| **citm_catalog.json (1.73 MB)** | 5.61 ms | 3.92 ms | 2.44 ms | **2.46 ms** | **1.43x** | **2.30x** | **2.28x** | **1.59x** |
| **small.json (0.55 KB)** | 4.4 µs | 4.1 µs | 1.4 µs | **1.4 µs** | **1.05x** | **3.20x** | **3.21x** | **3.04x** |
| **twitter.json (0.62 MB)** | 3.09 ms | 1.83 ms | 1.75 ms | **1.74 ms** | **1.69x** | **1.76x** | **1.77x** | **1.05x** |
| **Geometric Mean** | — | — | — | — | **1.36x** | **2.34x** | **2.35x** | **1.73x** |
<!-- mdformat on -->

> ⚠️ 1 of 5 workloads in this table draw on samples flagged `is_robust_stable: false`. The Geometric Mean includes them and inherits their uncertainty.


------------------------------------------------------------------------

### 🎯 WASM Target Detailed Breakdown

#### Detailed Breakdown: WASM Decode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Tier 0: Stock + json_serial | Tier 1: New + json_serial | Tier 2: Stock + Codable [Mock] | Tier 3: New + Codable [Native] | Tier 1 vs Tier 0 (SDK + Substrate Build) | Tier 2 vs Tier 0 (Codable on Stock) | Speedup vs Tier 0 (Stock json_serial) | Speedup vs Tier 1 (New json_serial) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 2.31 ms | 2.24 ms | 2.71 ms | **1.69 ms** | **1.03x** | **0.85x** | **1.36x** | **1.32x** |
| **canada.json (2.25 MB)** | 34.53 ms | 25.33 ms | 16.29 ms | **8.81 ms** | **1.36x** ⚠️ | **2.12x** ⚠️ | **3.92x** ⚠️ | **2.88x** ⚠️ |
| **citm_catalog.json (1.73 MB)** | 4.40 ms | 4.08 ms | 4.05 ms | **2.85 ms** | **1.08x** | **1.08x** | **1.54x** | **1.43x** |
| **small.json (0.55 KB)** | 1.8 µs | 1.7 µs | 2.1 µs | **1.9 µs** | **1.05x** | **0.86x** | **0.93x** | **0.88x** |
| **twitter.json (0.62 MB)** | 1.74 ms | 1.71 ms | 2.13 ms | **1.83 ms** | **1.02x** | **0.82x** | **0.95x** | **0.94x** |
| **Geometric Mean** | — | — | — | — | **1.10x** | **1.07x** | **1.49x** | **1.35x** |
<!-- mdformat on -->

> ⚠️ 1 of 5 workloads in this table draw on samples flagged `is_robust_stable: false`. The Geometric Mean includes them and inherits their uncertainty.


#### Detailed Breakdown: WASM Encode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Tier 0: Stock + json_serial | Tier 1: New + json_serial | Tier 2: Stock + Codable [Mock] | Tier 3: New + Codable [Native] | Tier 1 vs Tier 0 (SDK + Substrate Build) | Tier 2 vs Tier 0 (Codable on Stock) | Speedup vs Tier 0 (Stock json_serial) | Speedup vs Tier 1 (New json_serial) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 5.33 ms | 2.83 ms | 1.93 ms | **1.87 ms** | **1.88x** | **2.76x** | **2.84x** | **1.51x** |
| **canada.json (2.25 MB)** | 26.84 ms | 12.51 ms | 14.72 ms | **14.71 ms** | **2.14x** | **1.82x** | **1.82x** | **0.85x** |
| **citm_catalog.json (1.73 MB)** | 4.73 ms | 3.03 ms | 3.00 ms | **3.02 ms** | **1.56x** | **1.58x** | **1.56x** | **1.00x** |
| **small.json (0.55 KB)** | 2.9 µs | 1.8 µs | 1.8 µs | **1.7 µs** | **1.58x** | **1.67x** | **1.67x** | **1.05x** |
| **twitter.json (0.62 MB)** | 2.98 ms | 1.90 ms | 1.89 ms | **1.87 ms** | **1.57x** | **1.58x** | **1.59x** | **1.02x** |
| **Geometric Mean** | — | — | — | — | **1.73x** | **1.84x** | **1.85x** | **1.07x** |
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

