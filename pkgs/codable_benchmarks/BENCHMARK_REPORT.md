### 📝 Provenance

- **Run Timestamp**: 2026-09-30T18:49:16.201Z
- **Stock Dart SDK (Tier 0 & Tier 2)**: 3.14.0-271.0.dev (dev) (Fri Sep 25 05:03:10 2026 -0700) on "linux_x64"
- **New Dart SDK (Tier 1 & Tier 3)**: 3.14.0-json-next.c52b7fecede9a0324612382bdfe02bd0d793d6c0 (main) (Mon Sep 21 10:53:03 2026 -0700) on "linux_x64"
- **Repo Commit**: 12cffb870aeadf003ec5d4983f3ac47913bac863
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
| **AOT (`dart compile exe`)** | **Tier 0: `Stock + json_serial`** | 🔴 `[ 25 / 59 / 100 ]` | **1.00x** / **0.98x** | 🔴 `[ 27 / 31 / 43 ]` | **1.00x** / **0.52x** |
| **AOT (`dart compile exe`)** | **Tier 1: `New + json_serial`** | 🔴 `[ 27 / 60 / 100 ]` | **1.02x** / **1.00x** | 🔴 `[ 46 / 59 / 100 ]` | **1.92x** / **1.00x** |
| **AOT (`dart compile exe`)** | **Tier 2: `Stock + Codable [Mock]`** | 🟡 `[ 62 / 78 / 100 ]` | **1.32x** / **1.30x** | 🟢 `[ 79 / 94 / 100 ]` | **3.07x** / **1.60x** |
| **AOT (`dart compile exe`)** | **Tier 3: `New + Codable [Native]`** | 🟢 `[ 95 / 98 / 100 ]` | **1.66x** / **1.63x** | 🟢 `[ 78 / 95 / 100 ]` | **3.09x** / **1.61x** |
| **JS (`dart2js` / Node 24 / V8)** | **Tier 0: `Stock + json_serial`** | 🔴 `[ 30 / 56 / 82 ]` | **1.00x** / **0.98x** | 🔴 `[ 34 / 45 / 70 ]` | **1.00x** / **0.73x** |
| **JS (`dart2js` / Node 24 / V8)** | **Tier 1: `New + json_serial`** | 🔴 `[ 33 / 57 / 83 ]` | **1.02x** / **1.00x** | 🔴 `[ 38 / 62 / 97 ]` | **1.38x** / **1.00x** |
| **JS (`dart2js` / Node 24 / V8)** | **Tier 2: `Stock + Codable [Mock]`** | 🟢 `[ 98 / 99 / 100 ]` | **1.78x** / **1.74x** | 🟢 `[ 100 / 100 / 100 ]` | **2.21x** / **1.61x** |
| **JS (`dart2js` / Node 24 / V8)** | **Tier 3: `New + Codable [Native]`** | 🟢 `[ 96 / 99 / 100 ]` | **1.76x** / **1.72x** | 🟢 `[ 96 / 98 / 100 ]` | **2.17x** / **1.57x** |
| **WASM (`dart2wasm` / Node 24 / V8)** | **Tier 0: `Stock + json_serial`** | 🔴 `[ 21 / 60 / 97 ]` | **1.00x** / **0.88x** | 🔴 `[ 36 / 54 / 65 ]` | **1.00x** / **0.59x** |
| **WASM (`dart2wasm` / Node 24 / V8)** | **Tier 1: `New + json_serial`** | 🔴 `[ 32 / 69 / 100 ]` | **1.13x** / **1.00x** | 🟢 `[ 69 / 91 / 100 ]` | **1.70x** / **1.00x** |
| **WASM (`dart2wasm` / Node 24 / V8)** | **Tier 2: `Stock + Codable [Mock]`** | 🔴 `[ 47 / 68 / 85 ]` | **1.13x** / **0.99x** | 🟢 `[ 70 / 91 / 100 ]` | **1.70x** / **1.00x** |
| **WASM (`dart2wasm` / Node 24 / V8)** | **Tier 3: `New + Codable [Native]`** | 🟢 `[ 91 / 97 / 100 ]` | **1.60x** / **1.41x** | 🟢 `[ 72 / 91 / 100 ]` | **1.71x** / **1.01x** |
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
| **AOT** | **0.988x** | `[1.033, 0.929, 1.019, 0.983, 0.982]` |
| **JS** | **1.041x** | `[1.014, 1.211, 0.985, 1.010, 1.000]` |
| **WASM** | **0.969x** | `[1.047, 0.872, 0.950, 0.984, 0.999]` |
<!-- mdformat on -->

<!-- mdformat off(prevent table wrapping) -->
| Target Runtime | Encode Control Drift (Tier 1 / Tier 0) | Per-Dataset Control Ratios |
| :--- | :---: | :--- |
| **AOT** | **1.023x** | `[1.063, 1.031, 1.024, 1.000, 0.998]` |
| **JS** | **0.975x** | `[0.779, 1.000, 1.031, 1.158, 0.946]` |
| **WASM** | **1.001x** | `[0.996, 1.003, 1.004, 1.006, 0.996]` |
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
> **Sample stability**: 41 of 210 measured cells (20%) are flagged `is_robust_stable: false` by the harness. Ratios involving them are marked ⚠️ in the breakdowns below and must not be quoted as measurements.

### 🎯 AOT Target Detailed Breakdown

#### Detailed Breakdown: AOT Decode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Tier 0: Stock + json_serial | Tier 1: New + json_serial | Tier 2: Stock + Codable [Mock] | Tier 3: New + Codable [Native] | Tier 1 vs Tier 0 (SDK + Substrate Build) | Tier 2 vs Tier 0 (Codable on Stock) | Speedup vs Tier 0 (Stock json_serial) | Speedup vs Tier 1 (New json_serial) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 2.21 ms | 2.18 ms | 1.71 ms | **1.18 ms** | **1.02x** | **1.30x** | **1.88x** | **1.85x** |
| **canada.json (2.25 MB)** | 25.88 ms | 23.81 ms | 10.52 ms | **6.48 ms** | **1.09x** ⚠️ | **2.46x** ⚠️ | **3.99x** ⚠️ | **3.68x** ⚠️ |
| **citm_catalog.json (1.73 MB)** | 4.40 ms | 4.34 ms | 2.40 ms | **2.41 ms** | **1.01x** | **1.84x** | **1.82x** | **1.80x** |
| **small.json (0.55 KB)** | 1.5 µs | 1.6 µs | 1.7 µs | **1.6 µs** | **0.96x** | **0.91x** | **0.97x** | **1.01x** |
| **twitter.json (0.62 MB)** | 1.54 ms | 1.52 ms | 2.03 ms | **1.60 ms** | **1.01x** | **0.76x** | **0.96x** | **0.95x** |
| **Geometric Mean** | — | — | — | — | **1.02x** | **1.32x** | **1.66x** | **1.63x** |
<!-- mdformat on -->

> ⚠️ 1 of 5 workloads in this table draw on samples flagged `is_robust_stable: false`. The Geometric Mean includes them and inherits their uncertainty.


#### Detailed Breakdown: AOT Encode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Tier 0: Stock + json_serial | Tier 1: New + json_serial | Tier 2: Stock + Codable [Mock] | Tier 3: New + Codable [Native] | Tier 1 vs Tier 0 (SDK + Substrate Build) | Tier 2 vs Tier 0 (Codable on Stock) | Speedup vs Tier 0 (Stock json_serial) | Speedup vs Tier 1 (New json_serial) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 5.51 ms | 2.56 ms | 1.51 ms | **1.46 ms** | **2.16x** | **3.65x** | **3.77x** | **1.75x** |
| **canada.json (2.25 MB)** | 24.72 ms | 10.74 ms | 13.62 ms | **13.70 ms** | **2.30x** ⚠️ | **1.81x** ⚠️ | **1.80x** ⚠️ | **0.78x** |
| **citm_catalog.json (1.73 MB)** | 4.89 ms | 3.08 ms | 1.54 ms | **1.54 ms** | **1.59x** ⚠️ | **3.17x** ⚠️ | **3.17x** ⚠️ | **2.00x** ⚠️ |
| **small.json (0.55 KB)** | 2.8 µs | 1.7 µs | 0.8 µs | **0.8 µs** | **1.65x** | **3.57x** | **3.54x** | **2.15x** |
| **twitter.json (0.62 MB)** | 3.24 ms | 1.61 ms | 896.4 µs | **871.8 µs** | **2.01x** | **3.61x** | **3.71x** | **1.85x** |
| **Geometric Mean** | — | — | — | — | **1.92x** | **3.07x** | **3.09x** | **1.61x** |
<!-- mdformat on -->

> ⚠️ 2 of 5 workloads in this table draw on samples flagged `is_robust_stable: false`. The Geometric Mean includes them and inherits their uncertainty.


------------------------------------------------------------------------

### 🎯 JS Target Detailed Breakdown

#### Detailed Breakdown: JS Decode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Tier 0: Stock + json_serial | Tier 1: New + json_serial | Tier 2: Stock + Codable [Mock] | Tier 3: New + Codable [Native] | Tier 1 vs Tier 0 (SDK + Substrate Build) | Tier 2 vs Tier 0 (Codable on Stock) | Speedup vs Tier 0 (Stock json_serial) | Speedup vs Tier 1 (New json_serial) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 2.55 ms | 2.52 ms | 1.49 ms | **1.49 ms** | **1.01x** | **1.71x** | **1.72x** | **1.70x** |
| **canada.json (2.25 MB)** | 28.75 ms | 26.25 ms | 8.64 ms | **9.00 ms** | **1.10x** ⚠️ | **3.33x** ⚠️ | **3.19x** ⚠️ | **2.92x** ⚠️ |
| **citm_catalog.json (1.73 MB)** | 7.08 ms | 7.15 ms | 3.55 ms | **3.67 ms** | **0.99x** ⚠️ | **1.99x** ⚠️ | **1.93x** ⚠️ | **1.95x** ⚠️ |
| **small.json (0.55 KB)** | 2.6 µs | 2.6 µs | 2.0 µs | **2.0 µs** | **1.01x** | **1.28x** | **1.31x** | **1.30x** |
| **twitter.json (0.62 MB)** | 2.11 ms | 2.08 ms | 1.73 ms | **1.72 ms** | **1.01x** | **1.22x** | **1.22x** | **1.21x** |
| **Geometric Mean** | — | — | — | — | **1.02x** | **1.78x** | **1.76x** | **1.72x** |
<!-- mdformat on -->

> ⚠️ 2 of 5 workloads in this table draw on samples flagged `is_robust_stable: false`. The Geometric Mean includes them and inherits their uncertainty.


#### Detailed Breakdown: JS Encode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Tier 0: Stock + json_serial | Tier 1: New + json_serial | Tier 2: Stock + Codable [Mock] | Tier 3: New + Codable [Native] | Tier 1 vs Tier 0 (SDK + Substrate Build) | Tier 2 vs Tier 0 (Codable on Stock) | Speedup vs Tier 0 (Stock json_serial) | Speedup vs Tier 1 (New json_serial) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 4.75 ms | 3.61 ms | 1.62 ms | **1.68 ms** | **1.32x** | **2.93x** | **2.82x** ⚠️ | **2.14x** ⚠️ |
| **canada.json (2.25 MB)** | 18.20 ms | 13.13 ms | 12.75 ms | **12.75 ms** | **1.39x** | **1.43x** | **1.43x** ⚠️ | **1.03x** ⚠️ |
| **citm_catalog.json (1.73 MB)** | 5.82 ms | 4.12 ms | 2.51 ms | **2.50 ms** | **1.42x** ⚠️ | **2.32x** ⚠️ | **2.33x** ⚠️ | **1.65x** ⚠️ |
| **small.json (0.55 KB)** | 3.9 µs | 3.5 µs | 1.3 µs | **1.4 µs** | **1.11x** ⚠️ | **2.96x** | **2.84x** ⚠️ | **2.56x** ⚠️ |
| **twitter.json (0.62 MB)** | 3.22 ms | 1.86 ms | 1.74 ms | **1.79 ms** | **1.73x** | **1.85x** | **1.80x** | **1.04x** |
| **Geometric Mean** | — | — | — | — | **1.38x** | **2.21x** | **2.17x** | **1.57x** |
<!-- mdformat on -->

> ⚠️ 4 of 5 workloads in this table draw on samples flagged `is_robust_stable: false`. The Geometric Mean includes them and inherits their uncertainty.


------------------------------------------------------------------------

### 🎯 WASM Target Detailed Breakdown

#### Detailed Breakdown: WASM Decode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Tier 0: Stock + json_serial | Tier 1: New + json_serial | Tier 2: Stock + Codable [Mock] | Tier 3: New + Codable [Native] | Tier 1 vs Tier 0 (SDK + Substrate Build) | Tier 2 vs Tier 0 (Codable on Stock) | Speedup vs Tier 0 (Stock json_serial) | Speedup vs Tier 1 (New json_serial) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 2.53 ms | 2.24 ms | 2.65 ms | **1.60 ms** | **1.13x** | **0.95x** | **1.58x** | **1.40x** |
| **canada.json (2.25 MB)** | 39.59 ms | 26.79 ms | 18.09 ms | **8.50 ms** | **1.48x** ⚠️ | **2.19x** ⚠️ | **4.66x** ⚠️ | **3.15x** ⚠️ |
| **citm_catalog.json (1.73 MB)** | 4.57 ms | 4.40 ms | 3.86 ms | **2.96 ms** | **1.04x** | **1.18x** | **1.54x** | **1.49x** |
| **small.json (0.55 KB)** | 1.8 µs | 1.7 µs | 2.0 µs | **1.9 µs** | **1.05x** | **0.90x** | **0.96x** | **0.91x** |
| **twitter.json (0.62 MB)** | 1.78 ms | 1.73 ms | 2.18 ms | **1.83 ms** | **1.03x** | **0.82x** | **0.97x** | **0.95x** |
| **Geometric Mean** | — | — | — | — | **1.13x** | **1.13x** | **1.60x** | **1.41x** |
<!-- mdformat on -->

> ⚠️ 1 of 5 workloads in this table draw on samples flagged `is_robust_stable: false`. The Geometric Mean includes them and inherits their uncertainty.


#### Detailed Breakdown: WASM Encode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Tier 0: Stock + json_serial | Tier 1: New + json_serial | Tier 2: Stock + Codable [Mock] | Tier 3: New + Codable [Native] | Tier 1 vs Tier 0 (SDK + Substrate Build) | Tier 2 vs Tier 0 (Codable on Stock) | Speedup vs Tier 0 (Stock json_serial) | Speedup vs Tier 1 (New json_serial) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 5.38 ms | 2.86 ms | 1.96 ms | **2.03 ms** | **1.88x** | **2.75x** | **2.66x** | **1.41x** |
| **canada.json (2.25 MB)** | 25.83 ms | 12.44 ms | 17.84 ms | **17.17 ms** | **2.08x** | **1.45x** | **1.50x** | **0.72x** |
| **citm_catalog.json (1.73 MB)** | 4.64 ms | 3.01 ms | 3.28 ms | **3.30 ms** | **1.54x** | **1.42x** | **1.41x** | **0.91x** |
| **small.json (0.55 KB)** | 2.8 µs | 1.8 µs | 1.7 µs | **1.7 µs** | **1.54x** | **1.60x** | **1.62x** | **1.05x** |
| **twitter.json (0.62 MB)** | 3.02 ms | 1.97 ms | 1.93 ms | **1.89 ms** | **1.53x** | **1.56x** | **1.60x** | **1.04x** |
| **Geometric Mean** | — | — | — | — | **1.70x** | **1.70x** | **1.71x** | **1.01x** |
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

