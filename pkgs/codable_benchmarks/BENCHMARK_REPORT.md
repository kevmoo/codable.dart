### 📝 Provenance

- **Run Timestamp**: 2026-09-18T23:51:32.138Z
- **Stock Dart SDK (Tier 0 & Tier 2)**: 3.14.0-edge.5237faee608e57dd1d8481289e6683bd83700d73 (main) (Wed Sep 9 15:51:44 2026 -0700) on "linux_x64"
- **New Dart SDK (Tier 1 & Tier 3)**: 3.14.0-edge.8045fcd2294b259f9a87e5abd1986c954a0ffbe0 (main) (Sat Sep 12 19:08:49 2026 -0700) on "linux_x64"
- **Repo Commit**: e1af15fa4fd2b0cb7606d05960a1b5c5d90de572
- **Host OS**: linux, Hostname: kevmoo.c.googlers.com
- **Trials**: 15 (reporting `min` latency)

### 🏛️ The 4 Dart Serialization Tiers

- **Tier 0 (`Stock Dart + json_serializable`)**: Out-of-the-box status-quo baseline compiled & executed on unmodified Stock Dart (`dart:convert` DOM + `json_serializable`).
- **Tier 1 (`New Dart + json_serializable`)**: Unmodified `json_serializable` running on the upgraded `dart-sdk-json-next` SDK (15->16 digit double fast-path, 32 KB stringifier buffers, and Eisel-Lemire float parser). Measures the zero-public-API-change speedup for existing `json_serializable` users.
- **Tier 2 (`Stock Dart + Codable [Mock Substrate]`)**: `package:codable` running on unmodified Stock Dart using the pure-Dart mock substrate (`_MockJsonTokenReader` + 64-bit Eisel-Lemire + `AdaptiveJsonTokenWriter`). Measures what `package:codable` delivers if published on Stock Dart today with zero SDK changes.
- **Tier 3 (`New Dart + Codable [Native Substrate]`)**: Full end-to-end stack (`package:codable` + `dart:convert` Layer 1 native `JsonTokenReader` / `JsonUtf8TokenWriter` substrate).

### 📊 3-Runtime Summary (4-Tier Relative Efficiency & GeoMean Speedups)

<!-- mdformat off(prevent table wrapping) -->
| Target Runtime | Tier / Configuration | 📥 Decode Efficiency<br/>[ Worst / GeoMean / Best ] | 📥 Decode GeoMean<br/>(vs Tier 0 / vs Tier 1) | 📤 Encode Efficiency<br/>[ Worst / GeoMean / Best ] | 📤 Encode GeoMean<br/>(vs Tier 0 / vs Tier 1) |
| :--- | :--- | :---: | :---: | :---: | :---: |
| **AOT (`dart compile exe`)** | **Tier 0: `Stock + json_serial`** | 🔴 `[ 32 / 68 / 100 ]` | **1.00x** / **0.93x** | 🔴 `[ 29 / 35 / 50 ]` | **1.00x** / **0.66x** |
| **AOT (`dart compile exe`)** | **Tier 1: `New + json_serial`** | 🟡 `[ 44 / 74 / 100 ]` | **1.08x** / **1.00x** | 🔴 `[ 32 / 53 / 100 ]` | **1.51x** / **1.00x** |
| **AOT (`dart compile exe`)** | **Tier 2: `Stock + Codable [Mock]`** | 🟡 `[ 54 / 75 / 92 ]` | **1.10x** / **1.02x** | 🟢 `[ 86 / 97 / 100 ]` | **2.76x** / **1.82x** |
| **AOT (`dart compile exe`)** | **Tier 3: `New + Codable [Native]`** | 🟢 `[ 90 / 96 / 100 ]` | **1.41x** / **1.31x** | 🟢 `[ 82 / 93 / 100 ]` | **2.65x** / **1.75x** |
| **JS (`dart2js` / Node 24 / V8)** | **Tier 0: `Stock + json_serial`** | 🔴 `[ 46 / 65 / 79 ]` | **1.00x** / **1.00x** | 🔴 `[ 27 / 40 / 56 ]` | **1.00x** / **1.05x** |
| **JS (`dart2js` / Node 24 / V8)** | **Tier 1: `New + json_serial`** | 🔴 `[ 47 / 64 / 75 ]` | **1.00x** / **1.00x** | 🔴 `[ 13 / 38 / 78 ]` | **0.95x** / **1.00x** |
| **JS (`dart2js` / Node 24 / V8)** | **Tier 2: `Stock + Codable [Mock]`** | 🟢 `[ 100 / 100 / 100 ]` | **1.55x** / **1.55x** | 🟢 `[ 95 / 98 / 100 ]` | **2.44x** / **2.57x** |
| **JS (`dart2js` / Node 24 / V8)** | **Tier 3: `New + Codable [Native]`** | 🟢 `[ 93 / 97 / 100 ]` | **1.50x** / **1.51x** | 🟢 `[ 100 / 100 / 100 ]` | **2.50x** / **2.62x** |
| **WASM (`dart2wasm` / Node 24 / V8)** | **Tier 0: `Stock + json_serial`** | 🟡 `[ 40 / 78 / 100 ]` | **1.00x** / **1.13x** | 🔴 `[ 30 / 48 / 61 ]` | **1.00x** / **0.63x** |
| **WASM (`dart2wasm` / Node 24 / V8)** | **Tier 1: `New + json_serial`** | 🔴 `[ 21 / 69 / 100 ]` | **0.88x** / **1.00x** | 🟡 `[ 52 / 77 / 98 ]` | **1.59x** / **1.00x** |
| **WASM (`dart2wasm` / Node 24 / V8)** | **Tier 2: `Stock + Codable [Mock]`** | 🔴 `[ 44 / 64 / 76 ]` | **0.82x** / **0.92x** | 🟢 `[ 98 / 100 / 100 ]` | **2.06x** / **1.29x** |
| **WASM (`dart2wasm` / Node 24 / V8)** | **Tier 3: `New + Codable [Native]`** | 🟢 `[ 88 / 96 / 100 ]` | **1.23x** / **1.39x** | 🟢 `[ 92 / 95 / 100 ]` | **1.97x** / **1.24x** |
<!-- mdformat on -->

> **Scoring Metric**: **Relative Throughput Efficiency** (`100` = Peak Speed across all measured tiers). Calculated as `round((MinLatency / Latency) * 100)` per workload, aggregated across benchmarks using the **Geometric Mean** (Fleming & Wallace 1986).
> - **`[ Worst / GeoMean / Best ]`**: Range from lowest score (worst workload) to the geometric mean and peak dataset score
>   across the 5 canonical benchmarks (`coordinates`, `canada`, `citm_catalog`, `small`, `twitter`).
> - **Badges**: 🥇 Peak across all workloads (`100`) • 🟢 `≥ 90` (Within 10% of peak) • 🟡 `70–89` (Good / moderate) • 🔴 `< 70` (Significant performance gap).

------------------------------------------------------------------------

### 🎯 AOT Target Detailed Breakdown

#### Detailed Breakdown: AOT Decode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Tier 0: Stock + json_serial | Tier 1: New + json_serial | Tier 2: Stock + Codable [Mock] | Tier 3: New + Codable [Native] | Tier 1 vs Tier 0 (SDK-Only) | Tier 2 vs Tier 0 (Codable on Stock) | Speedup vs Tier 0 (Stock json_serial) | Speedup vs Tier 1 (New json_serial) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 3.69 ms | 3.55 ms | 3.24 ms | **2.33 ms** | **1.04x** | **1.14x** | **1.58x** | **1.52x** |
| **canada.json (2.25 MB)** | 34.47 ms | 24.72 ms | 20.36 ms | **10.93 ms** | **1.39x** | **1.69x** | **3.15x** | **2.26x** |
| **citm_catalog.json (1.73 MB)** | 5.73 ms | 5.82 ms | 4.73 ms | **4.35 ms** | **0.99x** | **1.21x** | **1.32x** | **1.34x** |
| **small.json (0.55 KB)** | 2.7 µs | 2.7 µs | 3.1 µs | **3.0 µs** | **1.00x** | **0.90x** | **0.93x** | **0.93x** |
| **twitter.json (0.62 MB)** | 2.87 ms | 2.82 ms | 3.77 ms | **3.13 ms** | **1.02x** | **0.76x** | **0.92x** | **0.90x** |
| **Geometric Mean** | — | — | — | — | **1.08x** | **1.10x** | **1.41x** | **1.31x** |
<!-- mdformat on -->


#### Detailed Breakdown: AOT Encode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Tier 0: Stock + json_serial | Tier 1: New + json_serial | Tier 2: Stock + Codable [Mock] | Tier 3: New + Codable [Native] | Tier 1 vs Tier 0 (SDK-Only) | Tier 2 vs Tier 0 (Codable on Stock) | Speedup vs Tier 0 (Stock json_serial) | Speedup vs Tier 1 (New json_serial) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 8.91 ms | 4.15 ms | 2.71 ms | **2.79 ms** | **2.15x** | **3.28x** | **3.20x** | **1.49x** |
| **canada.json (2.25 MB)** | 42.20 ms | 20.99 ms | 24.37 ms | **24.06 ms** | **2.01x** | **1.73x** | **1.75x** | **0.87x** |
| **citm_catalog.json (1.73 MB)** | 8.72 ms | 6.49 ms | 2.93 ms | **2.89 ms** | **1.34x** | **2.98x** | **3.02x** | **2.25x** |
| **small.json (0.55 KB)** | 4.7 µs | 5.3 µs | 1.7 µs | **1.7 µs** | **0.89x** | **2.74x** | **2.74x** | **3.07x** |
| **twitter.json (0.62 MB)** | 4.85 ms | 3.15 ms | 1.42 ms | **1.72 ms** | **1.54x** | **3.42x** | **2.81x** | **1.83x** |
| **Geometric Mean** | — | — | — | — | **1.51x** | **2.76x** | **2.65x** | **1.75x** |
<!-- mdformat on -->


------------------------------------------------------------------------

### 🎯 JS Target Detailed Breakdown

#### Detailed Breakdown: JS Decode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Tier 0: Stock + json_serial | Tier 1: New + json_serial | Tier 2: Stock + Codable [Mock] | Tier 3: New + Codable [Native] | Tier 1 vs Tier 0 (SDK-Only) | Tier 2 vs Tier 0 (Codable on Stock) | Speedup vs Tier 0 (Stock json_serial) | Speedup vs Tier 1 (New json_serial) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 4.13 ms | 4.00 ms | 2.52 ms | **2.55 ms** | **1.03x** | **1.63x** | **1.62x** | **1.57x** |
| **canada.json (2.25 MB)** | 31.00 ms | 30.00 ms | 14.20 ms | **15.33 ms** | **1.03x** | **2.18x** | **2.02x** | **1.96x** |
| **citm_catalog.json (1.73 MB)** | 8.50 ms | 8.33 ms | 5.63 ms | **5.60 ms** | **1.02x** | **1.51x** | **1.52x** | **1.49x** |
| **small.json (0.55 KB)** | 4.8 µs | 5.0 µs | 3.7 µs | **3.7 µs** | **0.95x** | **1.31x** | **1.28x** | **1.35x** |
| **twitter.json (0.62 MB)** | 3.60 ms | 3.80 ms | 2.86 ms | **3.00 ms** | **0.95x** | **1.26x** | **1.20x** | **1.27x** |
| **Geometric Mean** | — | — | — | — | **1.00x** | **1.55x** | **1.50x** | **1.51x** |
<!-- mdformat on -->


#### Detailed Breakdown: JS Encode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Tier 0: Stock + json_serial | Tier 1: New + json_serial | Tier 2: Stock + Codable [Mock] | Tier 3: New + Codable [Native] | Tier 1 vs Tier 0 (SDK-Only) | Tier 2 vs Tier 0 (Codable on Stock) | Speedup vs Tier 0 (Stock json_serial) | Speedup vs Tier 1 (New json_serial) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 9.00 ms | 8.00 ms | 2.55 ms | **2.47 ms** | **1.13x** | **3.53x** | **3.64x** | **3.23x** |
| **canada.json (2.25 MB)** | 33.50 ms | 35.00 ms | 19.75 ms | **18.75 ms** | **0.96x** | **1.70x** | **1.79x** | **1.87x** |
| **citm_catalog.json (1.73 MB)** | 11.00 ms | 8.25 ms | 4.00 ms | **4.00 ms** | **1.33x** | **2.75x** | **2.75x** | **2.06x** |
| **small.json (0.55 KB)** | 6.9 µs | 18.7 µs | 2.5 µs | **2.4 µs** | **0.37x** | **2.80x** | **2.86x** | **7.80x** |
| **twitter.json (0.62 MB)** | 5.45 ms | 3.69 ms | 2.89 ms | **2.88 ms** | **1.48x** | **1.89x** | **1.89x** | **1.28x** |
| **Geometric Mean** | — | — | — | — | **0.95x** | **2.44x** | **2.50x** | **2.62x** |
<!-- mdformat on -->


------------------------------------------------------------------------

### 🎯 WASM Target Detailed Breakdown

#### Detailed Breakdown: WASM Decode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Tier 0: Stock + json_serial | Tier 1: New + json_serial | Tier 2: Stock + Codable [Mock] | Tier 3: New + Codable [Native] | Tier 1 vs Tier 0 (SDK-Only) | Tier 2 vs Tier 0 (Codable on Stock) | Speedup vs Tier 0 (Stock json_serial) | Speedup vs Tier 1 (New json_serial) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 3.49 ms | 3.79 ms | 4.92 ms | **3.10 ms** | **0.92x** | **0.71x** | **1.13x** | **1.22x** |
| **canada.json (2.25 MB)** | 34.68 ms | 65.92 ms | 31.19 ms | **13.87 ms** | **0.53x** | **1.11x** | **2.50x** | **4.75x** |
| **citm_catalog.json (1.73 MB)** | 6.26 ms | 5.78 ms | 7.79 ms | **5.40 ms** | **1.08x** | **0.80x** | **1.16x** | **1.07x** |
| **small.json (0.55 KB)** | 3.3 µs | 3.3 µs | 4.3 µs | **3.5 µs** | **0.99x** | **0.76x** | **0.93x** | **0.94x** |
| **twitter.json (0.62 MB)** | 3.07 ms | 2.96 ms | 4.09 ms | **3.36 ms** | **1.04x** | **0.75x** | **0.91x** | **0.88x** |
| **Geometric Mean** | — | — | — | — | **0.88x** | **0.82x** | **1.23x** | **1.39x** |
<!-- mdformat on -->


#### Detailed Breakdown: WASM Encode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Tier 0: Stock + json_serial | Tier 1: New + json_serial | Tier 2: Stock + Codable [Mock] | Tier 3: New + Codable [Native] | Tier 1 vs Tier 0 (SDK-Only) | Tier 2 vs Tier 0 (Codable on Stock) | Speedup vs Tier 0 (Stock json_serial) | Speedup vs Tier 1 (New json_serial) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 10.90 ms | 5.10 ms | 3.32 ms | **3.48 ms** | **2.14x** | **3.28x** | **3.13x** | **1.46x** |
| **canada.json (2.25 MB)** | 52.50 ms | 25.05 ms | 24.34 ms | **26.46 ms** | **2.10x** | **2.16x** | **1.98x** | **0.95x** |
| **citm_catalog.json (1.73 MB)** | 9.21 ms | 5.97 ms | 5.00 ms | **5.41 ms** | **1.54x** | **1.84x** | **1.70x** | **1.10x** |
| **small.json (0.55 KB)** | 5.4 µs | 5.9 µs | 3.2 µs | **3.1 µs** | **0.92x** | **1.71x** | **1.76x** | **1.92x** |
| **twitter.json (0.62 MB)** | 5.33 ms | 3.31 ms | 3.24 ms | **3.35 ms** | **1.61x** | **1.64x** | **1.59x** | **0.99x** |
| **Geometric Mean** | — | — | — | — | **1.59x** | **2.06x** | **1.97x** | **1.24x** |
<!-- mdformat on -->


------------------------------------------------------------------------

### 🧪 Unchanged-Code Controls & Repeat-Run Noise Floor

To verify that SDK baseline comparisons are free of tree/compiler skew or host contention, the table below tracks **unchanged-code controls** across the `Stock` (`mergebase-5237faee608`) and `New` (`head-8045fcd2294`) passes:
- **JS `json_serializable` (Decode)**: Executes V8 `JSON.parse` + identical generated Dart model constructors (`dart2js -O2` output is identical across both SDKs).
- **WASM `codable_js` (`#forceJsDom: true` Decode)**: Delegates to host V8 `TextDecoder` + `JSON.parse` via JS interop inside the same Wasm process that runs `native_kernels` and `stock`.

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | JS `json_serial` (Stock) | JS `json_serial` (New) | JS Control Ratio | WASM `codable_js` (Stock) | WASM `codable_js` (New) | WASM Control Ratio |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 4.13 ms | 4.00 ms | **1.03x** | 3.15 ms | 3.18 ms | **0.99x** |
| **canada.json (2.25 MB)** | 31.00 ms | 30.00 ms | **1.03x** | 29.67 ms | 28.54 ms | **1.04x** |
| **citm_catalog.json (1.73 MB)** | 8.50 ms | 8.33 ms | **1.02x** | 11.02 ms | 10.65 ms | **1.03x** |
| **small.json (0.55 KB)** | 4.8 µs | 5.0 µs | **0.95x** | 7.2 µs | 7.1 µs | **1.02x** |
| **twitter.json (0.62 MB)** | 3.60 ms | 3.80 ms | **0.95x** | 4.98 ms | 4.96 ms | **1.00x** |
| **Geometric Mean** | — | — | **1.00x** | — | — | **1.02x** |
<!-- mdformat on -->

- **Measured Repeat-Run Noise Floor (`taskset -c 2`, 15 trials, `min`)**:
  - **AOT (`dart compile exe`)**: `±1.5% – ±3.8%` across back-to-back runs (`citm_catalog`: `4.23 ms` vs `4.35 ms`; `coordinates`: `2.31 ms` vs `2.33 ms`; `twitter`: `3.13 ms` vs `3.19 ms`).
  - **JS (`dart2js -O2` on Node 24)**: `±2.0% – ±5.0%` (`1.00x` GeoMean across all 5 datasets on the unchanged `json_serializable` control).
  - **WASM (`dart2wasm -O4` on Node 24)**: `±1.0% – ±4.5%` (`0.99x` GeoMean on the `codable_js` host-DOM control; note `canada.json` Wasm `json_serializable` exhibits a `batch=2` (`34.68 ms`) vs `batch=1` (`65.92 ms`) V8 WasmGC major-collection quantization step when allocating `112,000` heap objects per iteration, whereas isolated single-dataset Wasm binaries measure `28.84 ms` vs `26.76 ms`).

------------------------------------------------------------------------

### 🔬 Methodology & Caveats

- Every cell is the **min** of the trial count listed in the provenance
  header.
  - **Tier 0 (`Stock Dart + json_serializable`)** and **Tier 2 (`Stock Dart + Codable [Mock]`)** are compiled and executed in a dedicated Stock Dart pass with `substrate.dart` switched to `mock`.
  - **Tier 1 (`New Dart + json_serializable`)** and **Tier 3 (`New Dart + Codable [Native]`)** are compiled and executed in the `native_kernels` pass with `substrate.dart` switched to `native`.
- **Dual Speedup Baselines**:
  - **Speedup vs Tier 0 (`Stock Dart + json_serializable`)**: Measures total end-to-end speedup over out-of-the-box Stock Dart.
  - **Speedup vs Tier 1 (`New Dart + json_serializable`)**: Measures the isolated streaming vs. DOM mapping speedup on the identical upgraded SDK.
- **Resolution limit**: at 10–15 trials this harness cannot reliably resolve
  latency deltas below roughly **10%**. Run-to-run drift is large enough to
  flip the sign of small effects. Treat any speedup between `0.90x` and
  `1.10x` as *no measured difference*.

