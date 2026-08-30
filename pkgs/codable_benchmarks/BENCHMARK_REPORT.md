## 🚀 Isolated Before vs. After Benchmark Delta (vs pkgs/codable_benchmarks/benchmark_comparison_baseline.json)

### Target: WASM (`dart2wasm` / d8) Encode (`New Dart + Codable`)

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Pre-Change Latency | Post-Change Latency | Absolute Delta | Delta (%) [±95% MoE] | Speedup vs pkgs/codable_benchmarks/benchmark_comparison_baseline.json |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 7.20 ± 0.51 ms | 7.58 ± 1.06 ms | +384.7 µs | +5.3% [±11.3%] | 0.95x (p ≥ 0.05) |
| **canada.json (2.25 MB)** | 41.65 ± 4.65 ms | 43.07 ± 4.15 ms | +1.43 ms | +3.4% [±10.2%] | 0.97x (p ≥ 0.05) |
| **citm_catalog.json (1.73 MB)** | 11.05 ± 1.82 ms | 10.09 ± 0.88 ms | -953.0 µs | -8.6% [±11.7%] | 1.09x (p ≥ 0.05) |
| **small.json (0.55 KB)** | 3.8 ± 0.1 µs | 3.7 ± 0.0 µs | -65 ns | -1.7% [±1.3%] | 1.02x (parity) |
| **twitter.json (0.62 MB)** | 8.12 ± 1.33 ms | 7.19 ± 0.92 ms | -934.5 µs | -11.5% [±12.4%] | 1.13x (p ≥ 0.05) |
<!-- mdformat on -->

> **Statistical Criteria**: Effect threshold = ±5.0% &bull; Significance = Welch's two-sample t-test with Welch–Satterthwaite df (p < 0.05) &bull; MoE = 95% CI via Delta Method for ratio variance.

### Target: WASM (`dart2wasm` / d8) Decode (`New Dart + Codable`)

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Pre-Change Latency | Post-Change Latency | Absolute Delta | Delta (%) [±95% MoE] | Speedup vs pkgs/codable_benchmarks/benchmark_comparison_baseline.json |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 11.53 ± 2.33 ms | 11.90 ± 2.72 ms | +365.8 µs | +3.2% [±21.0%] | 0.97x (p ≥ 0.05) |
| **canada.json (2.25 MB)** | 30.99 ± 3.51 ms | 30.83 ± 3.63 ms | -151.5 µs | -0.5% [±10.8%] | 1.00x (p ≥ 0.05) |
| **citm_catalog.json (1.73 MB)** | 19.37 ± 1.43 ms | 19.04 ± 1.25 ms | -325.1 µs | -1.7% [±6.5%] | 1.02x (p ≥ 0.05) |
| **small.json (0.55 KB)** | 7.7 ± 0.2 µs | 7.6 ± 0.1 µs | -142 ns | -1.8% [±1.8%] | 1.02x (parity) |
| **twitter.json (0.62 MB)** | 8.63 ± 1.17 ms | 8.32 ± 1.04 ms | -317.3 µs | -3.7% [±11.9%] | 1.04x (p ≥ 0.05) |
<!-- mdformat on -->

> **Statistical Criteria**: Effect threshold = ±5.0% &bull; Significance = Welch's two-sample t-test with Welch–Satterthwaite df (p < 0.05) &bull; MoE = 95% CI via Delta Method for ratio variance.

### Target: AOT (`dart compile exe`) Encode (`New Dart + Codable`)

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Pre-Change Latency | Post-Change Latency | Absolute Delta | Delta (%) [±95% MoE] | Speedup vs pkgs/codable_benchmarks/benchmark_comparison_baseline.json |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 2.59 ± 0.12 ms | 2.67 ± 0.12 ms | +77.3 µs | +3.0% [±4.6%] | 0.97x (p ≥ 0.05) |
| **canada.json (2.25 MB)** | 36.70 ± 2.78 ms | 35.90 ± 3.63 ms | -805.0 µs | -2.2% [±8.3%] | 1.02x (p ≥ 0.05) |
| **citm_catalog.json (1.73 MB)** | 3.13 ± 0.60 ms | 2.73 ± 0.77 ms | -399.5 µs | -12.8% [±20.0%] | 1.15x (p ≥ 0.05) |
| **small.json (0.55 KB)** | 5.5 ± 0.1 µs | 5.5 ± 0.1 µs | +45 ns | +0.8% [±2.1%] | 0.99x (p ≥ 0.05) |
| **twitter.json (0.62 MB)** | 1.78 ± 0.08 ms | 1.85 ± 0.15 ms | +61.7 µs | +3.5% [±6.7%] | 0.97x (p ≥ 0.05) |
<!-- mdformat on -->

> **Statistical Criteria**: Effect threshold = ±5.0% &bull; Significance = Welch's two-sample t-test with Welch–Satterthwaite df (p < 0.05) &bull; MoE = 95% CI via Delta Method for ratio variance.

### Target: AOT (`dart compile exe`) Decode (`New Dart + Codable`)

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Pre-Change Latency | Post-Change Latency | Absolute Delta | Delta (%) [±95% MoE] | Speedup vs pkgs/codable_benchmarks/benchmark_comparison_baseline.json |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 2.39 ± 0.09 ms | 2.64 ± 0.46 ms | +244.4 µs | +10.2% [±14.0%] | 0.91x (p ≥ 0.05) |
| **canada.json (2.25 MB)** | 13.82 ± 3.21 ms | 15.01 ± 3.93 ms | +1.19 ms | +8.6% [±25.4%] | 0.92x (p ≥ 0.05) |
| **citm_catalog.json (1.73 MB)** | 4.56 ± 0.41 ms | 4.57 ± 0.80 ms | +9.5 µs | +0.2% [±13.4%] | 1.00x (p ≥ 0.05) |
| **small.json (0.55 KB)** | 3.2 ± 0.1 µs | 3.1 ± 0.1 µs | -42 ns | -1.3% [±2.1%] | 1.01x (p ≥ 0.05) |
| **twitter.json (0.62 MB)** | 4.80 ± 0.12 ms | 4.66 ± 0.12 ms | -144.3 µs | -3.0% [±2.3%] | 1.03x (parity) |
<!-- mdformat on -->

> **Statistical Criteria**: Effect threshold = ±5.0% &bull; Significance = Welch's two-sample t-test with Welch–Satterthwaite df (p < 0.05) &bull; MoE = 95% CI via Delta Method for ratio variance.

### Target: JS (`dart2js` / Node 24 / V8) Encode (`New Dart + Codable`)

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Pre-Change Latency | Post-Change Latency | Absolute Delta | Delta (%) [±95% MoE] | Speedup vs pkgs/codable_benchmarks/benchmark_comparison_baseline.json |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 4.50 ± 0.24 ms | 5.00 ± 0.42 ms | +500.0 µs | **+11.1%** [±5.1%] | **0.90x (regression)** 🔴 |
| **canada.json (2.25 MB)** | 29.00 ± 4.80 ms | 28.00 ± 4.06 ms | -1.00 ms | -3.4% [±9.5%] | 1.04x (p ≥ 0.05) |
| **citm_catalog.json (1.73 MB)** | 6.75 ± 1.59 ms | 6.00 ± 1.63 ms | -750.0 µs | -11.1% [±14.3%] | 1.13x (p ≥ 0.05) |
| **small.json (0.55 KB)** | 6.0 ± 2.0 µs | 11.0 ± 2.0 µs | +5.0 µs | **+83.3%** [±31.1%] | **0.55x (regression)** 🔴 |
| **twitter.json (0.62 MB)** | 4.67 ± 0.70 ms | 4.00 ± 0.52 ms | -667.0 µs | **-14.3%** [±7.6%] | **1.17x faster** 🏆 |
<!-- mdformat on -->

> **Statistical Criteria**: Effect threshold = ±5.0% &bull; Significance = Welch's two-sample t-test with Welch–Satterthwaite df (p < 0.05) &bull; MoE = 95% CI via Delta Method for ratio variance.

### Target: JS (`dart2js` / Node 24 / V8) Decode (`New Dart + Codable`)

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Pre-Change Latency | Post-Change Latency | Absolute Delta | Delta (%) [±95% MoE] | Speedup vs pkgs/codable_benchmarks/benchmark_comparison_baseline.json |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 6.00 ± 1.94 ms | 4.75 ± 2.29 ms | -1.25 ms | -20.8% [±20.6%] | 1.26x (p ≥ 0.05) |
| **canada.json (2.25 MB)** | 12.00 ± 2.99 ms | 13.00 ± 3.04 ms | +1.00 ms | +8.3% [±16.5%] | 0.92x (p ≥ 0.05) |
| **citm_catalog.json (1.73 MB)** | 6.25 ± 1.07 ms | 6.00 ± 0.98 ms | -250.0 µs | -4.0% [±10.2%] | 1.04x (p ≥ 0.05) |
| **small.json (0.55 KB)** | 4.0 µs | 4.0 µs | +0 ns | +0.0% | 1.00x (p ≥ 0.05) |
| **twitter.json (0.62 MB)** | 3.25 ± 0.44 ms | 3.33 ± 0.71 ms | +83.0 µs | +2.6% [±11.6%] | 0.98x (p ≥ 0.05) |
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
| **WASM (`dart2wasm` / d8)** | **`Old Dart + json_serial`** | 🟢 `[ 85 / 92 / 97 ]` | 🔴 `[ 34 / 61 / 78 ]` |
|  | **`New Dart + json_serial`** | 🟢 `[ 85 / 97 / 100 ]` | 🟢 `[ 75 / 94 / 100 ]` |
|  | **`New Dart + Codable`** | 🔴 `[ 28 / 42 / 100 ]` | 🟡 `[ 55 / 70 / 100 ]` |
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
| **10k Coordinates (0.39 MB)** | 3.70 ms | 3.46 ms | **12.51 ms** | **0.30x** | **0.28x** |
| **canada.json (2.25 MB)** | 35.95 ms | 35.97 ms | **30.71 ms** | **1.17x** | **1.17x** |
| **citm_catalog.json (1.73 MB)** | 5.67 ms | 5.44 ms | **18.48 ms** | **0.31x** | **0.29x** |
| **small.json (0.55 KB)** | 3.2 µs | 3.1 µs | **7.6 µs** | **0.42x** | **0.41x** |
| **twitter.json (0.62 MB)** | 3.50 ms | 3.18 ms | **7.86 ms** | **0.45x** | **0.40x** |
<!-- mdformat on -->


#### Detailed Breakdown: WASM Encode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Old Dart + json_serial | New Dart + json_serial | New Dart + Codable | Speedup vs Old Dart | Speedup vs New json_serial |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 13.26 ms | 4.49 ms | **7.27 ms** | **1.82x** | **0.62x** |
| **canada.json (2.25 MB)** | 50.21 ms | 39.26 ms | **44.74 ms** | **1.12x** | **0.88x** |
| **citm_catalog.json (1.73 MB)** | 8.78 ms | 5.58 ms | **10.12 ms** | **0.87x** | **0.55x** |
| **small.json (0.55 KB)** | 5.2 µs | 4.9 µs | **3.7 µs** | **1.41x** | **1.33x** |
| **twitter.json (0.62 MB)** | 5.58 ms | 3.82 ms | **7.01 ms** | **0.80x** | **0.55x** |
<!-- mdformat on -->

------------------------------------------------------------------------
