## 🚀 Isolated Before vs. After Benchmark Delta (vs pkgs/codable_benchmarks/benchmark_comparison_baseline.json)

### Target: WASM (`dart2wasm` / d8) Encode (`New Dart + Codable`)

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Pre-Change Latency | Post-Change Latency | Absolute Delta | Delta (%) [±95% MoE] | Speedup vs pkgs/codable_benchmarks/benchmark_comparison_baseline.json |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 7.12 ± 0.64 ms | 3.71 ± 0.50 ms | -3.40 ms | **-47.8%** [±5.6%] | **1.92x faster** 🏆 |
| **canada.json (2.25 MB)** | 43.43 ± 4.99 ms | 27.66 ± 4.63 ms | -15.76 ms | **-36.3%** [±8.6%] | **1.57x faster** 🏆 |
| **citm_catalog.json (1.73 MB)** | 9.67 ± 0.92 ms | 6.01 ± 0.36 ms | -3.66 ms | **-37.9%** [±4.9%] | **1.61x faster** 🏆 |
| **small.json (0.55 KB)** | 3.8 ± 0.1 µs | 3.6 ± 0.5 µs | -185 ns | -4.9% [±9.3%] | 1.05x (p ≥ 0.05) |
| **twitter.json (0.62 MB)** | 8.46 ± 0.90 ms | 3.64 ± 0.13 ms | -4.82 ms | **-57.0%** [±3.4%] | **2.33x faster** 🏆 |
<!-- mdformat on -->

> **Statistical Criteria**: Effect threshold = ±5.0% &bull; Significance = Welch's two-sample t-test with Welch–Satterthwaite df (p < 0.05) &bull; MoE = 95% CI via Delta Method for ratio variance.

### Target: WASM (`dart2wasm` / d8) Decode (`New Dart + Codable`)

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Pre-Change Latency | Post-Change Latency | Absolute Delta | Delta (%) [±95% MoE] | Speedup vs pkgs/codable_benchmarks/benchmark_comparison_baseline.json |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 12.53 ± 3.37 ms | 10.16 ± 1.66 ms | -2.37 ms | -18.9% [±17.4%] | 1.23x (p ≥ 0.05) |
| **canada.json (2.25 MB)** | 32.04 ± 4.09 ms | 32.41 ± 6.40 ms | +372.6 µs | +1.2% [±16.0%] | 0.99x (p ≥ 0.05) |
| **citm_catalog.json (1.73 MB)** | 22.45 ± 4.02 ms | 13.53 ± 2.52 ms | -8.93 ms | **-39.8%** [±10.5%] | **1.66x faster** 🏆 |
| **small.json (0.55 KB)** | 7.6 ± 0.1 µs | 8.1 ± 0.4 µs | +505 ns | **+6.7%** [±3.6%] | **0.94x (regression)** 🔴 |
| **twitter.json (0.62 MB)** | 10.09 ± 3.93 ms | 6.19 ± 0.65 ms | -3.90 ms | **-38.6%** [±17.7%] | **1.63x faster** 🏆 |
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
| **WASM (`dart2wasm` / d8)** | **`Old Dart + json_serial`** | 🟢 `[ 90 / 96 / 100 ]` | 🔴 `[ 27 / 51 / 66 ]` |
|  | **`New Dart + json_serial`** | 🟢 `[ 82 / 92 / 100 ]` | 🟡 `[ 57 / 77 / 92 ]` |
|  | **`New Dart + Codable`** | 🔴 `[ 34 / 50 / 100 ]` | 🥇 `[ 100 / 100 / 100 ]` |
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
| **10k Coordinates (0.39 MB)** | 3.39 ms | 4.14 ms | **9.98 ms** | **0.34x** | **0.41x** |
| **canada.json (2.25 MB)** | 35.35 ms | 37.16 ms | **31.90 ms** | **1.11x** | **1.16x** |
| **citm_catalog.json (1.73 MB)** | 6.02 ms | 5.80 ms | **13.09 ms** | **0.46x** | **0.44x** |
| **small.json (0.55 KB)** | 3.3 µs | 3.1 µs | **8.0 µs** | **0.41x** | **0.39x** |
| **twitter.json (0.62 MB)** | 3.16 ms | 3.30 ms | **6.19 ms** | **0.51x** | **0.53x** |
<!-- mdformat on -->


#### Detailed Breakdown: WASM Encode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Old Dart + json_serial | New Dart + json_serial | New Dart + Codable | Speedup vs Old Dart | Speedup vs New json_serial |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 13.17 ms | 4.60 ms | **3.59 ms** | **3.67x** | **1.28x** |
| **canada.json (2.25 MB)** | 50.74 ms | 44.00 ms | **25.25 ms** | **2.01x** | **1.74x** |
| **citm_catalog.json (1.73 MB)** | 9.70 ms | 6.68 ms | **6.12 ms** | **1.58x** | **1.09x** |
| **small.json (0.55 KB)** | 5.3 µs | 4.8 µs | **3.4 µs** | **1.57x** | **1.44x** |
| **twitter.json (0.62 MB)** | 5.42 ms | 3.92 ms | **3.60 ms** | **1.50x** | **1.09x** |
<!-- mdformat on -->

------------------------------------------------------------------------
