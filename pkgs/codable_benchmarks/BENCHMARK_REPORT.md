### 📝 Provenance

- **Run Timestamp**: 2026-09-18T21:19:13.841Z
- **Stock Dart SDK (Tier 0 & Tier 2)**: 3.14.0-241.0.dev (dev) (Thu Sep 17 17:06:19 2026 -0700) on "linux_x64"
- **New Dart SDK (Tier 1 & Tier 3)**: 3.14.0-edge.8045fcd2294b259f9a87e5abd1986c954a0ffbe0 (main) (Sat Sep 12 19:08:49 2026 -0700) on "linux_x64"
- **Repo Commit**: c1c55073793289db7c37c28c762ad8ae2d4e0dfa
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
| **AOT (`dart compile exe`)** | **Tier 0: `Stock + json_serial`** | 🔴 `[ 29 / 64 / 98 ]` | **1.00x** / **1.02x** | 🔴 `[ 29 / 35 / 50 ]` | **1.00x** / **0.61x** |
| **AOT (`dart compile exe`)** | **Tier 1: `New + json_serial`** | 🔴 `[ 25 / 63 / 100 ]` | **0.98x** / **1.00x** | 🔴 `[ 31 / 58 / 100 ]` | **1.65x** / **1.00x** |
| **AOT (`dart compile exe`)** | **Tier 2: `Stock + Codable [Mock]`** | 🟡 `[ 55 / 77 / 91 ]` | **1.20x** / **1.22x** | 🟢 `[ 89 / 97 / 100 ]` | **2.76x** / **1.67x** |
| **AOT (`dart compile exe`)** | **Tier 3: `New + Codable [Native]`** | 🟢 `[ 90 / 97 / 100 ]` | **1.51x** / **1.53x** | 🟢 `[ 90 / 96 / 100 ]` | **2.73x** / **1.66x** |
| **JS (`dart2js` / Node 24 / V8)** | **Tier 0: `Stock + json_serial`** | 🔴 `[ 40 / 64 / 81 ]` | **1.00x** / **0.96x** | 🔴 `[ 28 / 41 / 55 ]` | **1.00x** / **1.09x** |
| **JS (`dart2js` / Node 24 / V8)** | **Tier 1: `New + json_serial`** | 🔴 `[ 48 / 66 / 84 ]` | **1.04x** / **1.00x** | 🔴 `[ 12 / 38 / 82 ]` | **0.92x** / **1.00x** |
| **JS (`dart2js` / Node 24 / V8)** | **Tier 2: `Stock + Codable [Mock]`** | 🟢 `[ 97 / 99 / 100 ]` | **1.56x** / **1.50x** | 🟢 `[ 91 / 98 / 100 ]` | **2.39x** / **2.61x** |
| **JS (`dart2js` / Node 24 / V8)** | **Tier 3: `New + Codable [Native]`** | 🟢 `[ 99 / 99 / 100 ]` | **1.56x** / **1.49x** | 🟢 `[ 99 / 100 / 100 ]` | **2.43x** / **2.65x** |
| **WASM (`dart2wasm` / Node 24 / V8)** | **Tier 0: `Stock + json_serial`** | 🟡 `[ 47 / 80 / 99 ]` | **1.00x** / **1.18x** | 🔴 `[ 33 / 48 / 61 ]` | **1.00x** / **0.65x** |
| **WASM (`dart2wasm` / Node 24 / V8)** | **Tier 1: `New + json_serial`** | 🔴 `[ 23 / 67 / 100 ]` | **0.85x** / **1.00x** | 🟡 `[ 50 / 75 / 99 ]` | **1.55x** / **1.00x** |
| **WASM (`dart2wasm` / Node 24 / V8)** | **Tier 2: `Stock + Codable [Mock]`** | 🔴 `[ 46 / 66 / 76 ]` | **0.83x** / **0.98x** | 🟢 `[ 93 / 96 / 100 ]` | **1.98x** / **1.28x** |
| **WASM (`dart2wasm` / Node 24 / V8)** | **Tier 3: `New + Codable [Native]`** | 🟢 `[ 90 / 97 / 100 ]` | **1.22x** / **1.44x** | 🟢 `[ 96 / 99 / 100 ]` | **2.05x** / **1.32x** |
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
| **10k Coordinates (0.39 MB)** | 3.80 ms | 3.64 ms | 3.27 ms | **2.42 ms** | **1.04x** | **1.16x** | **1.57x** | **1.50x** |
| **canada.json (2.25 MB)** | 39.07 ms | 45.05 ms | 20.54 ms | **11.20 ms** | **0.87x** | **1.90x** | **3.49x** | **4.02x** |
| **citm_catalog.json (1.73 MB)** | 7.26 ms | 7.58 ms | 5.02 ms | **4.56 ms** | **0.96x** | **1.45x** | **1.59x** | **1.66x** |
| **small.json (0.55 KB)** | 2.8 µs | 2.7 µs | 3.1 µs | **3.0 µs** | **1.04x** | **0.93x** | **0.94x** | **0.90x** |
| **twitter.json (0.62 MB)** | 2.99 ms | 2.93 ms | 3.63 ms | **3.15 ms** | **1.02x** | **0.82x** | **0.95x** | **0.93x** |
| **Geometric Mean** | — | — | — | — | **0.98x** | **1.20x** | **1.51x** | **1.53x** |
<!-- mdformat on -->


#### Detailed Breakdown: AOT Encode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Tier 0: Stock + json_serial | Tier 1: New + json_serial | Tier 2: Stock + Codable [Mock] | Tier 3: New + Codable [Native] | Tier 1 vs Tier 0 (SDK-Only) | Tier 2 vs Tier 0 (Codable on Stock) | Speedup vs Tier 0 (Stock json_serial) | Speedup vs Tier 1 (New json_serial) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 9.37 ms | 4.22 ms | 2.75 ms | **2.75 ms** | **2.22x** | **3.41x** | **3.41x** | **1.54x** |
| **canada.json (2.25 MB)** | 41.56 ms | 20.87 ms | 23.41 ms | **23.10 ms** | **1.99x** | **1.78x** | **1.80x** | **0.90x** |
| **citm_catalog.json (1.73 MB)** | 8.40 ms | 5.70 ms | 2.85 ms | **3.03 ms** | **1.47x** | **2.95x** | **2.77x** | **1.88x** |
| **small.json (0.55 KB)** | 4.8 µs | 5.2 µs | 1.6 µs | **1.7 µs** | **0.93x** | **2.95x** | **2.82x** | **3.04x** |
| **twitter.json (0.62 MB)** | 5.47 ms | 2.71 ms | 1.80 ms | **1.72 ms** | **2.02x** | **3.03x** | **3.17x** | **1.57x** |
| **Geometric Mean** | — | — | — | — | **1.65x** | **2.76x** | **2.73x** | **1.66x** |
<!-- mdformat on -->


------------------------------------------------------------------------

### 🎯 JS Target Detailed Breakdown

#### Detailed Breakdown: JS Decode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Tier 0: Stock + json_serial | Tier 1: New + json_serial | Tier 2: Stock + Codable [Mock] | Tier 3: New + Codable [Native] | Tier 1 vs Tier 0 (SDK-Only) | Tier 2 vs Tier 0 (Codable on Stock) | Speedup vs Tier 0 (Stock json_serial) | Speedup vs Tier 1 (New json_serial) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 4.00 ms | 4.00 ms | 2.45 ms | **2.47 ms** | **1.00x** | **1.63x** | **1.62x** | **1.62x** |
| **canada.json (2.25 MB)** | 36.67 ms | 31.00 ms | 14.80 ms | **15.00 ms** | **1.18x** | **2.48x** | **2.44x** | **2.07x** |
| **citm_catalog.json (1.73 MB)** | 8.33 ms | 8.25 ms | 5.75 ms | **5.83 ms** | **1.01x** | **1.45x** | **1.43x** | **1.41x** |
| **small.json (0.55 KB)** | 4.8 µs | 4.8 µs | 3.7 µs | **3.6 µs** | **1.00x** | **1.29x** | **1.33x** | **1.33x** |
| **twitter.json (0.62 MB)** | 3.59 ms | 3.47 ms | 2.91 ms | **2.94 ms** | **1.03x** | **1.23x** | **1.22x** | **1.18x** |
| **Geometric Mean** | — | — | — | — | **1.04x** | **1.56x** | **1.56x** | **1.49x** |
<!-- mdformat on -->


#### Detailed Breakdown: JS Encode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Tier 0: Stock + json_serial | Tier 1: New + json_serial | Tier 2: Stock + Codable [Mock] | Tier 3: New + Codable [Native] | Tier 1 vs Tier 0 (SDK-Only) | Tier 2 vs Tier 0 (Codable on Stock) | Speedup vs Tier 0 (Stock json_serial) | Speedup vs Tier 1 (New json_serial) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 9.00 ms | 8.00 ms | 2.52 ms | **2.53 ms** | **1.13x** | **3.56x** | **3.56x** | **3.17x** |
| **canada.json (2.25 MB)** | 36.00 ms | 37.33 ms | 21.25 ms | **19.40 ms** | **0.96x** | **1.69x** | **1.86x** | **1.92x** |
| **citm_catalog.json (1.73 MB)** | 10.25 ms | 8.25 ms | 4.00 ms | **4.00 ms** | **1.24x** | **2.56x** | **2.56x** | **2.06x** |
| **small.json (0.55 KB)** | 6.7 µs | 20.7 µs | 2.4 µs | **2.4 µs** | **0.32x** | **2.79x** | **2.75x** | **8.52x** |
| **twitter.json (0.62 MB)** | 5.25 ms | 3.54 ms | 2.90 ms | **2.90 ms** | **1.48x** | **1.81x** | **1.81x** | **1.22x** |
| **Geometric Mean** | — | — | — | — | **0.92x** | **2.39x** | **2.43x** | **2.65x** |
<!-- mdformat on -->


------------------------------------------------------------------------

### 🎯 WASM Target Detailed Breakdown

#### Detailed Breakdown: WASM Decode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Tier 0: Stock + json_serial | Tier 1: New + json_serial | Tier 2: Stock + Codable [Mock] | Tier 3: New + Codable [Native] | Tier 1 vs Tier 0 (SDK-Only) | Tier 2 vs Tier 0 (Codable on Stock) | Speedup vs Tier 0 (Stock json_serial) | Speedup vs Tier 1 (New json_serial) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 3.51 ms | 4.01 ms | 4.72 ms | **3.15 ms** | **0.88x** | **0.74x** | **1.12x** | **1.27x** |
| **canada.json (2.25 MB)** | 31.17 ms | 63.98 ms | 31.89 ms | **14.61 ms** | **0.49x** | **0.98x** | **2.13x** | **4.38x** |
| **citm_catalog.json (1.73 MB)** | 6.85 ms | 6.99 ms | 7.58 ms | **5.44 ms** | **0.98x** | **0.90x** | **1.26x** | **1.28x** |
| **small.json (0.55 KB)** | 3.4 µs | 3.3 µs | 4.3 µs | **3.4 µs** | **1.04x** | **0.79x** | **0.99x** | **0.95x** |
| **twitter.json (0.62 MB)** | 3.04 ms | 3.01 ms | 4.09 ms | **3.33 ms** | **1.01x** | **0.74x** | **0.91x** | **0.90x** |
| **Geometric Mean** | — | — | — | — | **0.85x** | **0.83x** | **1.22x** | **1.44x** |
<!-- mdformat on -->


#### Detailed Breakdown: WASM Encode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Tier 0: Stock + json_serial | Tier 1: New + json_serial | Tier 2: Stock + Codable [Mock] | Tier 3: New + Codable [Native] | Tier 1 vs Tier 0 (SDK-Only) | Tier 2 vs Tier 0 (Codable on Stock) | Speedup vs Tier 0 (Stock json_serial) | Speedup vs Tier 1 (New json_serial) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 9.91 ms | 5.41 ms | 3.33 ms | **3.29 ms** | **1.83x** | **2.98x** | **3.01x** | **1.65x** |
| **canada.json (2.25 MB)** | 54.20 ms | 24.75 ms | 26.51 ms | **24.52 ms** | **2.19x** | **2.04x** | **2.21x** | **1.01x** |
| **citm_catalog.json (1.73 MB)** | 9.89 ms | 6.35 ms | 5.10 ms | **5.31 ms** | **1.56x** | **1.94x** | **1.86x** | **1.20x** |
| **small.json (0.55 KB)** | 5.5 µs | 6.2 µs | 3.2 µs | **3.1 µs** | **0.89x** | **1.72x** | **1.77x** | **1.99x** |
| **twitter.json (0.62 MB)** | 5.34 ms | 3.34 ms | 3.53 ms | **3.27 ms** | **1.60x** | **1.51x** | **1.63x** | **1.02x** |
| **Geometric Mean** | — | — | — | — | **1.55x** | **1.98x** | **2.05x** | **1.32x** |
<!-- mdformat on -->


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

