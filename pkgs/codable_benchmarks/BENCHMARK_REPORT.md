### 📝 Provenance

- **Run Timestamp**: <span data-live="timestamp">2026-10-02T04:23:46.670Z</span>
- **Stock Dart SDK (Tier 0 & Tier 2)**: <span data-live="stock_dart_version">3.14.0-271.0.dev (dev) (Fri Sep 25 05:03:10 2026 -0700) on "linux_x64"</span>
- **New Dart SDK (Tier 1 & Tier 3)**: <span data-live="dart_version">3.14.0-271.0.dev.json-next.b1e2a8de06b07a0f94b642773c585784a8e8a911 (dev) (Thu Oct 1 20:53:39 2026 -0700) on "linux_x64"</span>
- **Repo Commit**: <span data-live="commit">1927fe6d60f802d44798756449b2a8a56fe3f484</span>
- **Host OS**: <span data-live="os">linux</span>, Hostname: <span data-live="host">bluefin</span>
- **Trials**: <span data-live="trial_count">15</span> (reporting `median` latency)

### 🏛️ The 4 Dart Serialization Tiers

- **Tier 0 (`Stock Dart + json_serializable`)**: Out-of-the-box status-quo baseline compiled & executed on unmodified Stock Dart (`dart:convert` DOM + `json_serializable`).
- **Tier 1 (`New Dart + json_serializable`)**: Unmodified `json_serializable` running on the upgraded `dart-sdk-json-next` SDK (15->16 digit double fast-path, 32 KB stringifier buffers, and Eisel-Lemire float parser). Measures the zero-public-API-change speedup for existing `json_serializable` users.
- **Tier 2 (`Stock Dart + Codable [Mock Substrate]`)**: `package:codable` running on unmodified Stock Dart using the pure-Dart mock substrate (`_MockJsonTokenReader` + 64-bit Eisel-Lemire + `AdaptiveJsonTokenWriter`). Measures what `package:codable` delivers if published on Stock Dart today with zero SDK changes.
- **Tier 3 (`New Dart + Codable [Native Substrate]`)**: Full end-to-end stack (`package:codable` + `dart:convert` Layer 1 native `JsonTokenReader` / `JsonUtf8TokenWriter` substrate).

### 📊 3-Runtime Summary (4-Tier Relative Efficiency & GeoMean Speedups)

<!-- bench:runtime-summary:start src="benchmark_results.json#benchmarks" -->

| Target Runtime | Tier / Configuration | 📥 Decode Efficiency<br/>[ Worst / GeoMean / Best ] | 📥 Decode GeoMean<br/>(vs Tier 0 / vs Tier 1) | 📤 Encode Efficiency<br/>[ Worst / GeoMean / Best ] | 📤 Encode GeoMean<br/>(vs Tier 0 / vs Tier 1) |
| :--- | :--- | :---: | :---: | :---: | :---: |
| **AOT (`dart compile exe`)** | **Tier 0: `Stock + json_serial`** | 🔴 `[ 21 / 57 / 100 ]` | **1.00x** / **0.94x** | 🔴 `[ 27 / 31 / 38 ]` | **1.00x** / **0.53x** |
| **AOT (`dart compile exe`)** | **Tier 1: `New + json_serial`** | 🔴 `[ 30 / 61 / 100 ]` | **1.07x** / **1.00x** | 🔴 `[ 45 / 58 / 100 ]` | **1.88x** / **1.00x** |
| **AOT (`dart compile exe`)** | **Tier 2: `Stock + Codable [Mock]`** | 🟡 `[ 61 / 78 / 100 ]` | **1.36x** / **1.28x** | 🟢 `[ 77 / 92 / 100 ]` | **2.99x** / **1.59x** |
| **AOT (`dart compile exe`)** | **Tier 3: `New + Codable [Native]`** | 🟢 `[ 96 / 99 / 100 ]` | **1.73x** / **1.62x** | 🟢 `[ 76 / 95 / 100 ]` | **3.07x** / **1.63x** |
| **JS (`dart2js` / Node 24 / V8)** | **Tier 0: `Stock + json_serial`** | 🔴 `[ 35 / 58 / 80 ]` | **1.00x** / **0.99x** | 🔴 `[ 34 / 45 / 67 ]` | **1.00x** / **0.71x** |
| **JS (`dart2js` / Node 24 / V8)** | **Tier 1: `New + json_serial`** | 🔴 `[ 35 / 58 / 82 ]` | **1.01x** / **1.00x** | 🔴 `[ 40 / 63 / 99 ]` | **1.41x** / **1.00x** |
| **JS (`dart2js` / Node 24 / V8)** | **Tier 2: `Stock + Codable [Mock]`** | 🟢 `[ 90 / 98 / 100 ]` | **1.70x** / **1.68x** | 🟢 `[ 99 / 100 / 100 ]` | **2.21x** / **1.57x** |
| **JS (`dart2js` / Node 24 / V8)** | **Tier 3: `New + Codable [Native]`** | 🟢 `[ 99 / 100 / 100 ]` | **1.73x** / **1.71x** | 🟢 `[ 96 / 99 / 100 ]` | **2.20x** / **1.56x** |
| **WASM (`dart2wasm` / Node 24 / V8)** | **Tier 0: `Stock + json_serial`** | 🔴 `[ 23 / 62 / 98 ]` | **1.00x** / **0.92x** | 🔴 `[ 37 / 54 / 65 ]` | **1.00x** / **0.59x** |
| **WASM (`dart2wasm` / Node 24 / V8)** | **Tier 1: `New + json_serial`** | 🔴 `[ 32 / 68 / 100 ]` | **1.08x** / **1.00x** | 🟢 `[ 68 / 92 / 100 ]` | **1.70x** / **1.00x** |
| **WASM (`dart2wasm` / Node 24 / V8)** | **Tier 2: `Stock + Codable [Mock]`** | 🟡 `[ 53 / 71 / 90 ]` | **1.13x** / **1.05x** | 🟢 `[ 74 / 93 / 100 ]` | **1.73x** / **1.02x** |
| **WASM (`dart2wasm` / Node 24 / V8)** | **Tier 3: `New + Codable [Native]`** | 🟢 `[ 94 / 98 / 100 ]` | **1.57x** / **1.45x** | 🟢 `[ 74 / 94 / 100 ]` | **1.73x** / **1.02x** |

<!-- bench:runtime-summary:end -->

> **Scoring Metric**: **Relative Throughput Efficiency** (`100` = Peak Speed across all measured tiers). Calculated as `round((MinLatency / Latency) * 100)` per workload, aggregated across benchmarks using the **Geometric Mean** (Fleming & Wallace 1986).
> - **`[ Worst / GeoMean / Best ]`**: Range from lowest score (worst workload) to the geometric mean and peak dataset score
>   across the active canonical benchmarks.
> - **Badges**: 🥇 Peak across all workloads (`100`) • 🟢 `≥ 90` (Within 10% of peak) • 🟡 `70–89` (Good / moderate) • 🔴 `< 70` (Significant performance gap).

------------------------------------------------------------------------

### 🎛️ Measurement Controls & Resolution Floor

These diagnostics bound how much of the tables above is signal. Read them before crediting any ratio.

<!-- bench:decode-control:start src="benchmark_results.json#benchmarks" -->

| Target Runtime | Decode Control Drift (Tier 1 / Tier 0) | Per-Dataset Control Ratios |
| :--- | :---: | :--- |
| **AOT** | **0.985x** | `[0.996, 0.976, 0.985, 0.960, 1.009]` |
| **JS** | **1.001x** | `[1.003, 1.009, 1.012, 0.989, 0.992]` |
| **WASM** | **1.020x** | `[1.014, 1.079, 0.985, 1.013, 1.013]` |

<!-- bench:decode-control:end -->

<!-- bench:encode-control:start src="benchmark_results.json#benchmarks" -->

| Target Runtime | Encode Control Drift (Tier 1 / Tier 0) | Per-Dataset Control Ratios |
| :--- | :---: | :--- |
| **AOT** | **0.982x** | `[0.976, 0.971, 0.960, 1.000, 1.001]` |
| **JS** | **1.031x** | `[1.363, 0.978, 1.029, 0.997, 0.853]` |
| **WASM** | **0.981x** | `[0.994, 0.982, 1.003, 0.948, 0.980]` |

<!-- bench:encode-control:end -->

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
> **Sample stability**: <span data-live="unstable_cells">32</span> of <span data-live="total_cells">210</span> measured cells (<span data-live="unstable_pct">15%</span>) are flagged `is_robust_stable: false` by the harness. Ratios involving them are marked ⚠️ in the breakdowns below and must not be quoted as measurements.

### 🎯 AOT Target Detailed Breakdown

#### Detailed Breakdown: AOT Decode

<!-- bench:aot-decode:start src="benchmark_results.json#benchmarks" -->

| Workload / Dataset | Tier 0: Stock + json_serial | Tier 1: New + json_serial | Tier 2: Stock + Codable [Mock] | Tier 3: New + Codable [Native] | Tier 1 vs Tier 0 (SDK + Substrate Build) | Tier 2 vs Tier 0 (Codable on Stock) | Speedup vs Tier 0 (Stock json_serial) | Speedup vs Tier 1 (New json_serial) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 2.17 ms | 2.15 ms | 1.70 ms | **1.20 ms** | **1.01x** | **1.28x** | **1.81x** | **1.79x** |
| **canada.json (2.25 MB)** | 30.51 ms | 21.39 ms | 10.37 ms | **6.36 ms** | **1.43x** ⚠️ | **2.94x** ⚠️ | **4.80x** ⚠️ | **3.36x** ⚠️ |
| **citm_catalog.json (1.73 MB)** | 4.40 ms | 4.54 ms | 2.39 ms | **2.41 ms** | **0.97x** | **1.84x** | **1.82x** | **1.88x** |
| **small.json (0.55 KB)** | 1.5 µs | 1.6 µs | 1.7 µs | **1.5 µs** | **0.99x** | **0.92x** ⚠️ | **1.01x** | **1.02x** |
| **twitter.json (0.62 MB)** | 1.54 ms | 1.54 ms | 2.05 ms | **1.59 ms** | **1.00x** | **0.75x** | **0.96x** | **0.96x** |
| **Geometric Mean** | — | — | — | — | **1.07x** | **1.36x** | **1.73x** | **1.62x** |

<!-- bench:aot-decode:end -->

> ⚠️ <span data-live="aot-decode-unstable">2</span> of <span data-live="aot-decode-datasets">5</span> workloads in this table draw on samples flagged `is_robust_stable: false`. The Geometric Mean includes them and inherits their uncertainty.


#### Detailed Breakdown: AOT Encode

<!-- bench:aot-encode:start src="benchmark_results.json#benchmarks" -->

| Workload / Dataset | Tier 0: Stock + json_serial | Tier 1: New + json_serial | Tier 2: Stock + Codable [Mock] | Tier 3: New + Codable [Native] | Tier 1 vs Tier 0 (SDK + Substrate Build) | Tier 2 vs Tier 0 (Codable on Stock) | Speedup vs Tier 0 (Stock json_serial) | Speedup vs Tier 1 (New json_serial) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 5.43 ms | 2.65 ms | 1.63 ms | **1.49 ms** | **2.05x** | **3.33x** | **3.64x** | **1.78x** |
| **canada.json (2.25 MB)** | 28.09 ms | 10.60 ms | 13.82 ms | **13.91 ms** | **2.65x** ⚠️ | **2.03x** ⚠️ | **2.02x** ⚠️ | **0.76x** ⚠️ |
| **citm_catalog.json (1.73 MB)** | 4.81 ms | 3.32 ms | 1.56 ms | **1.51 ms** | **1.45x** ⚠️ | **3.09x** ⚠️ | **3.18x** ⚠️ | **2.20x** |
| **small.json (0.55 KB)** | 2.8 µs | 1.7 µs | 0.8 µs | **0.8 µs** | **1.66x** | **3.37x** | **3.45x** | **2.08x** |
| **twitter.json (0.62 MB)** | 2.99 ms | 1.65 ms | 883.6 µs | **887.2 µs** | **1.82x** ⚠️ | **3.38x** | **3.37x** | **1.86x** ⚠️ |
| **Geometric Mean** | — | — | — | — | **1.88x** | **2.99x** | **3.07x** | **1.63x** |

<!-- bench:aot-encode:end -->

> ⚠️ <span data-live="aot-encode-unstable">3</span> of <span data-live="aot-encode-datasets">5</span> workloads in this table draw on samples flagged `is_robust_stable: false`. The Geometric Mean includes them and inherits their uncertainty.


------------------------------------------------------------------------

### 🎯 JS Target Detailed Breakdown

#### Detailed Breakdown: JS Decode

<!-- bench:js-decode:start src="benchmark_results.json#benchmarks" -->

| Workload / Dataset | Tier 0: Stock + json_serial | Tier 1: New + json_serial | Tier 2: Stock + Codable [Mock] | Tier 3: New + Codable [Native] | Tier 1 vs Tier 0 (SDK + Substrate Build) | Tier 2 vs Tier 0 (Codable on Stock) | Speedup vs Tier 0 (Stock json_serial) | Speedup vs Tier 1 (New json_serial) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 2.56 ms | 2.56 ms | 1.51 ms | **1.51 ms** | **1.00x** | **1.70x** | **1.70x** | **1.70x** |
| **canada.json (2.25 MB)** | 24.33 ms | 24.33 ms | 8.62 ms | **8.67 ms** | **1.00x** ⚠️ | **2.82x** ⚠️ | **2.81x** ⚠️ | **2.81x** ⚠️ |
| **citm_catalog.json (1.73 MB)** | 6.80 ms | 6.59 ms | 3.72 ms | **3.34 ms** | **1.03x** ⚠️ | **1.83x** ⚠️ | **2.03x** ⚠️ | **1.97x** ⚠️ |
| **small.json (0.55 KB)** | 2.6 µs | 2.6 µs | 2.0 µs | **2.0 µs** | **1.00x** | **1.30x** | **1.30x** | **1.29x** |
| **twitter.json (0.62 MB)** | 2.15 ms | 2.10 ms | 1.74 ms | **1.73 ms** | **1.02x** | **1.24x** | **1.24x** | **1.22x** |
| **Geometric Mean** | — | — | — | — | **1.01x** | **1.70x** | **1.73x** | **1.71x** |

<!-- bench:js-decode:end -->

> ⚠️ <span data-live="js-decode-unstable">2</span> of <span data-live="js-decode-datasets">5</span> workloads in this table draw on samples flagged `is_robust_stable: false`. The Geometric Mean includes them and inherits their uncertainty.


#### Detailed Breakdown: JS Encode

<!-- bench:js-encode:start src="benchmark_results.json#benchmarks" -->

| Workload / Dataset | Tier 0: Stock + json_serial | Tier 1: New + json_serial | Tier 2: Stock + Codable [Mock] | Tier 3: New + Codable [Native] | Tier 1 vs Tier 0 (SDK + Substrate Build) | Tier 2 vs Tier 0 (Codable on Stock) | Speedup vs Tier 0 (Stock json_serial) | Speedup vs Tier 1 (New json_serial) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 4.67 ms | 3.64 ms | 1.60 ms | **1.67 ms** | **1.28x** | **2.91x** | **2.80x** | **2.19x** |
| **canada.json (2.25 MB)** | 18.80 ms | 12.75 ms | 12.63 ms | **12.63 ms** | **1.47x** | **1.49x** | **1.49x** | **1.01x** |
| **citm_catalog.json (1.73 MB)** | 5.83 ms | 4.00 ms | 2.41 ms | **2.46 ms** | **1.46x** | **2.42x** | **2.37x** | **1.62x** |
| **small.json (0.55 KB)** | 3.9 µs | 3.3 µs | 1.3 µs | **1.3 µs** | **1.19x** | **2.92x** | **2.95x** | **2.48x** |
| **twitter.json (0.62 MB)** | 3.03 ms | 1.81 ms | 1.74 ms | **1.72 ms** | **1.68x** | **1.74x** | **1.76x** | **1.05x** |
| **Geometric Mean** | — | — | — | — | **1.41x** | **2.21x** | **2.20x** | **1.56x** |

<!-- bench:js-encode:end -->


------------------------------------------------------------------------

### 🎯 WASM Target Detailed Breakdown

#### Detailed Breakdown: WASM Decode

<!-- bench:wasm-decode:start src="benchmark_results.json#benchmarks" -->

| Workload / Dataset | Tier 0: Stock + json_serial | Tier 1: New + json_serial | Tier 2: Stock + Codable [Mock] | Tier 3: New + Codable [Native] | Tier 1 vs Tier 0 (SDK + Substrate Build) | Tier 2 vs Tier 0 (Codable on Stock) | Speedup vs Tier 0 (Stock json_serial) | Speedup vs Tier 1 (New json_serial) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 2.37 ms | 2.28 ms | 2.66 ms | **1.63 ms** | **1.04x** | **0.89x** | **1.46x** | **1.40x** |
| **canada.json (2.25 MB)** | 39.69 ms | 29.51 ms | 17.55 ms | **9.32 ms** | **1.34x** ⚠️ | **2.26x** ⚠️ | **4.26x** ⚠️ | **3.16x** ⚠️ |
| **citm_catalog.json (1.73 MB)** | 4.72 ms | 4.77 ms | 3.88 ms | **2.97 ms** | **0.99x** | **1.22x** | **1.59x** | **1.61x** |
| **small.json (0.55 KB)** | 1.9 µs | 1.8 µs | 2.0 µs | **1.9 µs** | **1.03x** | **0.93x** | **0.96x** | **0.94x** |
| **twitter.json (0.62 MB)** | 1.79 ms | 1.73 ms | 2.16 ms | **1.80 ms** | **1.04x** | **0.83x** | **1.00x** | **0.96x** |
| **Geometric Mean** | — | — | — | — | **1.08x** | **1.13x** | **1.57x** | **1.45x** |

<!-- bench:wasm-decode:end -->

> ⚠️ <span data-live="wasm-decode-unstable">1</span> of <span data-live="wasm-decode-datasets">5</span> workloads in this table draw on samples flagged `is_robust_stable: false`. The Geometric Mean includes them and inherits their uncertainty.


#### Detailed Breakdown: WASM Encode

<!-- bench:wasm-encode:start src="benchmark_results.json#benchmarks" -->

| Workload / Dataset | Tier 0: Stock + json_serial | Tier 1: New + json_serial | Tier 2: Stock + Codable [Mock] | Tier 3: New + Codable [Native] | Tier 1 vs Tier 0 (SDK + Substrate Build) | Tier 2 vs Tier 0 (Codable on Stock) | Speedup vs Tier 0 (Stock json_serial) | Speedup vs Tier 1 (New json_serial) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 5.37 ms | 2.87 ms | 2.02 ms | **1.96 ms** | **1.87x** | **2.66x** | **2.74x** | **1.46x** |
| **canada.json (2.25 MB)** | 25.72 ms | 12.62 ms | 17.15 ms | **16.96 ms** | **2.04x** | **1.50x** | **1.52x** | **0.74x** |
| **citm_catalog.json (1.73 MB)** | 4.58 ms | 2.98 ms | 3.04 ms | **3.09 ms** | **1.54x** | **1.51x** | **1.48x** | **0.96x** |
| **small.json (0.55 KB)** | 2.8 µs | 1.8 µs | 1.7 µs | **1.7 µs** | **1.55x** | **1.63x** | **1.63x** | **1.05x** |
| **twitter.json (0.62 MB)** | 2.98 ms | 1.92 ms | 1.90 ms | **1.90 ms** | **1.55x** | **1.57x** | **1.56x** | **1.01x** |
| **Geometric Mean** | — | — | — | — | **1.70x** | **1.73x** | **1.73x** | **1.02x** |

<!-- bench:wasm-encode:end -->


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

