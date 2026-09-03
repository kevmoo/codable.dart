## 🚀 Isolated Before vs. After Benchmark Delta (vs pkgs/codable_benchmarks/benchmark_comparison_baseline.json)

### Target: WASM (`dart2wasm` / d8) Encode (`New Dart + Codable`)

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Pre-Change Latency | Post-Change Latency | Absolute Delta | Delta (%) [±95% MoE] | Speedup vs pkgs/codable_benchmarks/benchmark_comparison_baseline.json |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 7.12 ± 0.64 ms | 3.69 ± 0.38 ms | -3.43 ms | **-48.2%** [±4.8%] | **1.93x faster** 🏆 |
| **canada.json (2.25 MB)** | 43.43 ± 4.99 ms | 26.33 ± 3.93 ms | -17.10 ms | **-39.4%** [±7.6%] | **1.65x faster** 🏆 |
| **citm_catalog.json (1.73 MB)** | 9.67 ± 0.92 ms | 5.57 ± 0.56 ms | -4.10 ms | **-42.4%** [±5.4%] | **1.74x faster** 🏆 |
| **small.json (0.55 KB)** | 3.8 ± 0.1 µs | 3.6 ± 0.2 µs | -211 ns | **-5.6%** [±4.3%] | **1.06x faster** 🏆 |
| **twitter.json (0.62 MB)** | 8.46 ± 0.90 ms | 4.16 ± 0.93 ms | -4.30 ms | **-50.8%** [±8.1%] | **2.03x faster** 🏆 |
<!-- mdformat on -->

> **Statistical Criteria**: Effect threshold = ±5.0% &bull; Significance = Welch's two-sample t-test with Welch–Satterthwaite df (p < 0.05) &bull; MoE = 95% CI via Delta Method for ratio variance.

### Target: WASM (`dart2wasm` / d8) Decode (`New Dart + Codable`)

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Pre-Change Latency | Post-Change Latency | Absolute Delta | Delta (%) | Speedup vs Baseline |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 3.94 ms | 4.01 ms | +0.07 ms | +1.9% | 0.98x (parity) |
| **canada.json (2.25 MB)** | 33.10 ms | 14.65 ms | -18.45 ms | **-55.7%** | **2.26x faster** 🏆 |
| **citm_catalog.json (1.73 MB)** | 13.25 ms | 4.37 ms | -8.88 ms | **-67.0%** | **3.03x faster** 🏆 |
| **small.json (0.55 KB)** | 7.9 µs | 3.5 µs | -4.4 µs | **-55.7%** | **2.26x faster** 🏆 |
| **twitter.json (0.62 MB)** | 6.09 ms | 4.40 ms | -1.69 ms | **-27.8%** | **1.39x faster** 🏆 |
<!-- mdformat on -->

> **Statistical Criteria**: Effect threshold = ±5.0% &bull; Significance = Welch's two-sample t-test with Welch–Satterthwaite df (p < 0.05) &bull; MoE = 95% CI via Delta Method for ratio variance.

------------------------------------------------------------------------

### 📊 3-Runtime Summary (Relative Efficiency Index)

<!-- mdformat off(prevent table wrapping) -->
| Target Runtime | Dart Configuration | 📥 Decode Efficiency<br/>[ Worst / GeoMean / Best ] | 📤 Encode Efficiency<br/>[ Worst / GeoMean / Best ] |
| :--- | :--- | :---: | :---: |
| **AOT (`dart compile exe`)** | **`Old Dart + json_serial`** | 🔴 `[ 34 / 68 / 100 ]` | 🔴 `[ 30 / 46 / 89 ]` |
|  | **`New Dart + json_serial`** | 🟡 `[ 48 / 76 / 100 ]` | 🟡 `[ 42 / 70 / 100 ]` |
|  | **`New Dart + Codable`** | 🟡 `[ 62 / 88 / 100 ]` | 🟢 `[ 73 / 92 / 100 ]` |
| **JS (`dart2js` / Node 24 / V8)** | **`Old Dart + json_serial`** | 🟡 `[ 36 / 73 / 100 ]` | 🟡 `[ 55 / 70 / 100 ]` |
|  | **`New Dart + json_serial`** | 🟡 `[ 34 / 74 / 100 ]` | 🟡 `[ 62 / 76 / 100 ]` |
|  | **`New Dart + Codable`** | 🟢 `[ 84 / 97 / 100 ]` | 🟢 `[ 73 / 92 / 100 ]` |
| **WASM (`dart2wasm` / d8)** | **`Old Dart + json_serial`** | 🟢 `[ 89 / 95 / 100 ]` | 🔴 `[ 27 / 52 / 69 ]` |
|  | **`New Dart + json_serial`** | 🟢 `[ 90 / 97 / 100 ]` | 🟡 `[ 61 / 79 / 100 ]` |
|  | **`New Dart + Codable`** | 🟢 `[ 88 / 94 / 100 ]` | 🟢 `[ 97 / 99 / 100 ]` |
<!-- mdformat on -->

> **Scoring Metric**: **Relative Throughput Efficiency** (`100` = Peak Speed). Calculated as `round((MinLatency / Latency) * 100)` per workload, aggregated across benchmarks using the **Geometric Mean** (Fleming & Wallace 1986).
> - **`[ Worst / GeoMean / Best ]`**: Range from lowest score (worst workload) to the geometric mean and peak dataset score across the 5 canonical benchmarks (`coordinates`, `canada`, `citm_catalog`, `small`, `twitter`).
> - **Badges**: 🥇 Peak across all workloads (`100`) &bull; 🟢 `≥ 90` (Within 10% of peak) &bull; 🟡 `70–89` (Good / moderate) &bull; 🔴 `< 70` (Significant performance gap).


------------------------------------------------------------------------

### 🎯 AOT Target Detailed Breakdown

#### Detailed Breakdown: AOT Decode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Old Dart + json_serial | New Dart + json_serial | New Dart + Codable | Speedup vs Old Dart | Speedup vs New json_serial |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 4.31 ms | 3.56 ms | **2.43 ms** | **1.77x** | **1.46x** |
| **canada.json (2.25 MB)** | 44.34 ms | 31.30 ms | **15.16 ms** | **2.93x** | **2.06x** |
| **citm_catalog.json (1.73 MB)** | 5.70 ms | 5.55 ms | **4.25 ms** | **1.34x** | **1.31x** |
| **small.json (0.55 KB)** | 2.7 µs | 2.7 µs | **3.1 µs** | **0.86x** | **0.86x** |
| **twitter.json (0.62 MB)** | 2.89 ms | 2.94 ms | **4.65 ms** | **0.62x** | **0.63x** |
<!-- mdformat on -->


#### Detailed Breakdown: AOT Encode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Old Dart + json_serial | New Dart + json_serial | New Dart + Codable | Speedup vs Old Dart | Speedup vs New json_serial |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 8.78 ms | 3.92 ms | **2.65 ms** | **3.31x** | **1.48x** |
| **canada.json (2.25 MB)** | 44.19 ms | 31.37 ms | **34.48 ms** | **1.28x** | **0.91x** |
| **citm_catalog.json (1.73 MB)** | 7.94 ms | 5.87 ms | **2.45 ms** | **3.23x** | **2.39x** |
| **small.json (0.55 KB)** | 4.5 µs | 4.0 µs | **5.5 µs** | **0.82x** | **0.73x** |
| **twitter.json (0.62 MB)** | 5.23 ms | 3.16 ms | **1.82 ms** | **2.88x** | **1.74x** |
<!-- mdformat on -->

------------------------------------------------------------------------

### 🎯 JS Target Detailed Breakdown

#### Detailed Breakdown: JS Decode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Old Dart + json_serial | New Dart + json_serial | New Dart + Codable | Speedup vs Old Dart | Speedup vs New json_serial |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 4.25 ms | 4.00 ms | **4.75 ms** | **0.89x** | **0.84x** |
| **canada.json (2.25 MB)** | 36.00 ms | 38.50 ms | **13.00 ms** | **2.77x** | **2.96x** |
| **citm_catalog.json (1.73 MB)** | 8.50 ms | 8.50 ms | **6.00 ms** | **1.42x** | **1.42x** |
| **small.json (0.55 KB)** | 4.0 µs | 4.0 µs | **4.0 µs** | **1.00x** | **1.00x** |
| **twitter.json (0.62 MB)** | 3.83 ms | 3.75 ms | **3.33 ms** | **1.15x** | **1.13x** |
<!-- mdformat on -->


#### Detailed Breakdown: JS Encode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Old Dart + json_serial | New Dart + json_serial | New Dart + Codable | Speedup vs Old Dart | Speedup vs New json_serial |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 9.00 ms | 8.00 ms | **5.00 ms** | **1.80x** | **1.60x** |
| **canada.json (2.25 MB)** | 32.50 ms | 31.50 ms | **28.00 ms** | **1.16x** | **1.13x** |
| **citm_catalog.json (1.73 MB)** | 11.00 ms | 8.50 ms | **6.00 ms** | **1.83x** | **1.42x** |
| **small.json (0.55 KB)** | 8.0 µs | 13.0 µs | **11.0 µs** | **0.73x** | **1.18x** |
| **twitter.json (0.62 MB)** | 5.50 ms | 3.50 ms | **4.00 ms** | **1.38x** | **0.88x** |
<!-- mdformat on -->

------------------------------------------------------------------------

### 🎯 WASM Target Detailed Breakdown

#### Detailed Breakdown: WASM Decode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Old Dart + json_serial | New Dart + json_serial | New Dart + Codable | Speedup vs Old Dart | Speedup vs New json_serial |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 3.39 ms | 3.50 ms | **4.01 ms** | **0.85x** | **0.87x** |
| **canada.json (2.25 MB)** | 36.47 ms | 36.75 ms | **14.65 ms** | **2.49x** | **2.51x** |
| **citm_catalog.json (1.73 MB)** | 6.58 ms | 5.86 ms | **4.37 ms** | **1.51x** | **1.34x** |
| **small.json (0.55 KB)** | 3.2 µs | 3.1 µs | **3.5 µs** | **0.91x** | **0.89x** |
| **twitter.json (0.62 MB)** | 3.39 ms | 3.32 ms | **4.40 ms** | **0.77x** | **0.75x** |
<!-- mdformat on -->


#### Detailed Breakdown: WASM Encode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Old Dart + json_serial | New Dart + json_serial | New Dart + Codable | Speedup vs Old Dart | Speedup vs New json_serial |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 13.45 ms | 4.71 ms | **3.61 ms** | **3.73x** | **1.30x** |
| **canada.json (2.25 MB)** | 49.12 ms | 40.84 ms | **24.94 ms** | **1.97x** | **1.64x** |
| **citm_catalog.json (1.73 MB)** | 8.93 ms | 6.51 ms | **5.55 ms** | **1.61x** | **1.17x** |
| **small.json (0.55 KB)** | 5.3 µs | 4.7 µs | **3.6 µs** | **1.44x** | **1.30x** |
| **twitter.json (0.62 MB)** | 5.56 ms | 3.75 ms | **3.88 ms** | **1.44x** | **0.97x** |
<!-- mdformat on -->

------------------------------------------------------------------------
