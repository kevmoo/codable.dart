## 🚀 Isolated Before vs. After Benchmark Delta (vs pkgs/codable_benchmarks/benchmark_comparison_baseline.json)

### Target: WASM (`dart2wasm` / d8) Encode (`New Dart + Codable`)

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Pre-Change Latency | Post-Change Latency | Absolute Delta | Delta (%) [±95% MoE] | Speedup vs pkgs/codable_benchmarks/benchmark_comparison_baseline.json |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 6.98 ± 0.55 ms | 7.89 ± 1.26 ms | +910.0 µs | +13.0% [±13.8%] | 0.88x (p ≥ 0.05) |
| **canada.json (2.25 MB)** | 41.63 ± 5.13 ms | 41.82 ± 4.43 ms | +191.3 µs | +0.5% [±10.9%] | 1.00x (p ≥ 0.05) |
| **citm_catalog.json (1.73 MB)** | 10.24 ± 1.40 ms | 9.46 ± 0.85 ms | -775.3 µs | -7.6% [±10.2%] | 1.08x (p ≥ 0.05) |
| **small.json (0.55 KB)** | 3.8 ± 0.1 µs | 3.7 ± 0.0 µs | -50 ns | -1.3% [±2.3%] | 1.01x (p ≥ 0.05) |
| **twitter.json (0.62 MB)** | 7.72 ± 1.68 ms | 7.40 ± 0.83 ms | -319.1 µs | -4.1% [±16.0%] | 1.04x (p ≥ 0.05) |
<!-- mdformat on -->

> **Statistical Criteria**: Effect threshold = ±5.0% &bull; Significance = Welch's two-sample t-test with Welch–Satterthwaite df (p < 0.05) &bull; MoE = 95% CI via Delta Method for ratio variance.

### Target: WASM (`dart2wasm` / d8) Decode (`New Dart + Codable`)

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Pre-Change Latency | Post-Change Latency | Absolute Delta | Delta (%) [±95% MoE] | Speedup vs pkgs/codable_benchmarks/benchmark_comparison_baseline.json |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 10.87 ± 2.51 ms | 11.23 ± 2.64 ms | +364.3 µs | +3.4% [±22.7%] | 0.97x (p ≥ 0.05) |
| **canada.json (2.25 MB)** | 32.33 ± 4.04 ms | 32.10 ± 4.20 ms | -226.4 µs | -0.7% [±12.0%] | 1.01x (p ≥ 0.05) |
| **citm_catalog.json (1.73 MB)** | 19.89 ± 1.79 ms | 20.01 ± 1.56 ms | +125.7 µs | +0.6% [±8.0%] | 0.99x (p ≥ 0.05) |
| **small.json (0.55 KB)** | 7.5 ± 0.1 µs | 7.5 ± 0.1 µs | -84 ns | -1.1% [±1.4%] | 1.01x (p ≥ 0.05) |
| **twitter.json (0.62 MB)** | 9.13 ± 0.95 ms | 8.38 ± 1.19 ms | -752.8 µs | -8.2% [±10.8%] | 1.09x (p ≥ 0.05) |
<!-- mdformat on -->

> **Statistical Criteria**: Effect threshold = ±5.0% &bull; Significance = Welch's two-sample t-test with Welch–Satterthwaite df (p < 0.05) &bull; MoE = 95% CI via Delta Method for ratio variance.

### Target: AOT (`dart compile exe`) Encode (`New Dart + Codable`)

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Pre-Change Latency | Post-Change Latency | Absolute Delta | Delta (%) [±95% MoE] | Speedup vs pkgs/codable_benchmarks/benchmark_comparison_baseline.json |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 2.59 ± 0.14 ms | 2.71 ± 0.11 ms | +111.7 µs | +4.3% [±4.7%] | 0.96x (p ≥ 0.05) |
| **canada.json (2.25 MB)** | 36.85 ± 2.91 ms | 36.55 ± 2.70 ms | -301.2 µs | -0.8% [±7.2%] | 1.01x (p ≥ 0.05) |
| **citm_catalog.json (1.73 MB)** | 2.96 ± 0.89 ms | 3.16 ± 0.65 ms | +206.6 µs | +7.0% [±26.2%] | 0.93x (p ≥ 0.05) |
| **small.json (0.55 KB)** | 5.9 ± 0.2 µs | 5.6 ± 0.1 µs | -285 ns | -4.8% [±2.9%] | 1.05x (parity) |
| **twitter.json (0.62 MB)** | 1.77 ± 0.08 ms | 1.68 ± 0.05 ms | -83.8 µs | -4.7% [±3.5%] | 1.05x (parity) |
<!-- mdformat on -->

> **Statistical Criteria**: Effect threshold = ±5.0% &bull; Significance = Welch's two-sample t-test with Welch–Satterthwaite df (p < 0.05) &bull; MoE = 95% CI via Delta Method for ratio variance.

### Target: AOT (`dart compile exe`) Decode (`New Dart + Codable`)

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Pre-Change Latency | Post-Change Latency | Absolute Delta | Delta (%) [±95% MoE] | Speedup vs pkgs/codable_benchmarks/benchmark_comparison_baseline.json |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 2.39 ± 0.10 ms | 2.45 ± 0.09 ms | +52.1 µs | +2.2% [±3.8%] | 0.98x (p ≥ 0.05) |
| **canada.json (2.25 MB)** | 14.00 ± 3.11 ms | 14.99 ± 3.94 ms | +996.2 µs | +7.1% [±24.6%] | 0.93x (p ≥ 0.05) |
| **citm_catalog.json (1.73 MB)** | 4.79 ± 0.79 ms | 4.54 ± 0.39 ms | -248.7 µs | -5.2% [±12.0%] | 1.05x (p ≥ 0.05) |
| **small.json (0.55 KB)** | 3.3 ± 0.3 µs | 3.1 ± 0.1 µs | -110 ns | -3.4% [±6.3%] | 1.04x (p ≥ 0.05) |
| **twitter.json (0.62 MB)** | 4.57 ± 0.14 ms | 4.73 ± 0.34 ms | +159.2 µs | +3.5% [±5.6%] | 0.97x (p ≥ 0.05) |
<!-- mdformat on -->

> **Statistical Criteria**: Effect threshold = ±5.0% &bull; Significance = Welch's two-sample t-test with Welch–Satterthwaite df (p < 0.05) &bull; MoE = 95% CI via Delta Method for ratio variance.

### Target: JS (`dart2js` / Node 24 / V8) Encode (`New Dart + Codable`)

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Pre-Change Latency | Post-Change Latency | Absolute Delta | Delta (%) [±95% MoE] | Speedup vs pkgs/codable_benchmarks/benchmark_comparison_baseline.json |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 4.25 ± 0.26 ms | 4.50 ± 0.26 ms | +250.0 µs | **+5.9%** [±4.0%] | **0.94x (regression)** 🔴 |
| **canada.json (2.25 MB)** | 28.00 ± 5.03 ms | 28.50 ± 4.99 ms | +500.0 µs | +1.8% [±11.4%] | 0.98x (p ≥ 0.05) |
| **citm_catalog.json (1.73 MB)** | 6.00 ± 1.29 ms | 6.25 ± 1.45 ms | +250.0 µs | +4.2% [±14.8%] | 0.96x (p ≥ 0.05) |
| **small.json (0.55 KB)** | 12.0 ± 2.0 µs | 5.0 µs | -7.0 µs | **-58.3%** [±3.3%] | **2.40x faster** 🏆 |
| **twitter.json (0.62 MB)** | 4.33 ± 0.61 ms | 4.00 ± 0.52 ms | -333.0 µs | -7.7% [±7.9%] | 1.08x (p ≥ 0.05) |
<!-- mdformat on -->

> **Statistical Criteria**: Effect threshold = ±5.0% &bull; Significance = Welch's two-sample t-test with Welch–Satterthwaite df (p < 0.05) &bull; MoE = 95% CI via Delta Method for ratio variance.

### Target: JS (`dart2js` / Node 24 / V8) Decode (`New Dart + Codable`)

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Pre-Change Latency | Post-Change Latency | Absolute Delta | Delta (%) [±95% MoE] | Speedup vs pkgs/codable_benchmarks/benchmark_comparison_baseline.json |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 4.50 ± 1.03 ms | 3.75 ± 1.46 ms | -750.0 µs | -16.7% [±16.8%] | 1.20x (p ≥ 0.05) |
| **canada.json (2.25 MB)** | 12.00 ± 3.50 ms | 13.00 ± 4.71 ms | +1.00 ms | +8.3% [±22.5%] | 0.92x (p ≥ 0.05) |
| **citm_catalog.json (1.73 MB)** | 6.00 ± 0.76 ms | 6.00 ± 0.88 ms | +0 ns | +0.0% [±8.7%] | 1.00x (p ≥ 0.05) |
| **small.json (0.55 KB)** | 4.0 µs | 4.0 µs | +0 ns | +0.0% | 1.00x (p ≥ 0.05) |
| **twitter.json (0.62 MB)** | 4.00 ± 0.80 ms | 3.25 ± 0.43 ms | -750.0 µs | **-18.8%** [±8.9%] | **1.23x faster** 🏆 |
<!-- mdformat on -->

> **Statistical Criteria**: Effect threshold = ±5.0% &bull; Significance = Welch's two-sample t-test with Welch–Satterthwaite df (p < 0.05) &bull; MoE = 95% CI via Delta Method for ratio variance.

------------------------------------------------------------------------

### 📊 3-Runtime Summary (Relative Efficiency Index)

<!-- mdformat off(prevent table wrapping) -->
| Target Runtime | Dart Configuration | 📥 Decode Efficiency<br/>[ Worst / GeoMean / Best ] | 📤 Encode Efficiency<br/>[ Worst / GeoMean / Best ] |
| :--- | :--- | :---: | :---: |
| **AOT (`dart compile exe`)** | **`Old Dart + json_serial`** | 🔴 `[ 33 / 68 / 100 ]` | 🔴 `[ 30 / 47 / 91 ]` |
|  | **`New Dart + json_serial`** | 🟡 `[ 41 / 72 / 99 ]` | 🟡 `[ 54 / 72 / 100 ]` |
|  | **`New Dart + Codable`** | 🟡 `[ 63 / 89 / 100 ]` | 🟢 `[ 74 / 92 / 100 ]` |
| **JS (`dart2js` / Node 24 / V8)** | **`Old Dart + json_serial`** | 🟡 `[ 37 / 74 / 100 ]` | 🔴 `[ 50 / 61 / 86 ]` |
|  | **`New Dart + json_serial`** | 🟡 `[ 36 / 74 / 100 ]` | 🟡 `[ 42 / 70 / 100 ]` |
|  | **`New Dart + Codable`** | 🥇 `[ 100 / 100 / 100 ]` | 🟢 `[ 88 / 97 / 100 ]` |
| **WASM (`dart2wasm` / d8)** | **`Old Dart + json_serial`** | 🟢 `[ 91 / 97 / 100 ]` | 🔴 `[ 35 / 62 / 82 ]` |
|  | **`New Dart + json_serial`** | 🟢 `[ 85 / 96 / 100 ]` | 🟢 `[ 76 / 95 / 100 ]` |
|  | **`New Dart + Codable`** | 🔴 `[ 29 / 43 / 100 ]` | 🟡 `[ 52 / 73 / 100 ]` |
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
| **10k Coordinates (0.39 MB)** | 4.04 ms | 3.64 ms | **2.43 ms** | **1.66x** | **1.49x** |
| **canada.json (2.25 MB)** | 45.41 ms | 37.10 ms | **15.03 ms** | **3.02x** | **2.47x** |
| **citm_catalog.json (1.73 MB)** | 5.91 ms | 5.61 ms | **4.38 ms** | **1.35x** | **1.28x** |
| **small.json (0.55 KB)** | 2.7 µs | 2.7 µs | **3.1 µs** | **0.88x** | **0.88x** |
| **twitter.json (0.62 MB)** | 2.85 ms | 3.16 ms | **4.53 ms** | **0.63x** | **0.70x** |
<!-- mdformat on -->


#### Detailed Breakdown: AOT Encode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Old Dart + json_serial | New Dart + json_serial | New Dart + Codable | Speedup vs Old Dart | Speedup vs New json_serial |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 8.80 ms | 4.12 ms | **2.68 ms** | **3.28x** | **1.54x** |
| **canada.json (2.25 MB)** | 43.48 ms | 31.99 ms | **36.38 ms** | **1.19x** | **0.88x** |
| **citm_catalog.json (1.73 MB)** | 8.40 ms | 5.72 ms | **3.13 ms** | **2.68x** | **1.83x** |
| **small.json (0.55 KB)** | 4.6 µs | 4.1 µs | **5.6 µs** | **0.82x** | **0.74x** |
| **twitter.json (0.62 MB)** | 5.63 ms | 3.09 ms | **1.68 ms** | **3.35x** | **1.84x** |
<!-- mdformat on -->

------------------------------------------------------------------------

### 🎯 JS Target Detailed Breakdown

#### Detailed Breakdown: JS Decode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Old Dart + json_serial | New Dart + json_serial | New Dart + Codable | Speedup vs Old Dart | Speedup vs New json_serial |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 4.00 ms | 4.00 ms | **3.75 ms** | **1.07x** | **1.07x** |
| **canada.json (2.25 MB)** | 35.50 ms | 36.50 ms | **13.00 ms** | **2.73x** | **2.81x** |
| **citm_catalog.json (1.73 MB)** | 8.00 ms | 8.50 ms | **6.00 ms** | **1.33x** | **1.42x** |
| **small.json (0.55 KB)** | 4.0 µs | 4.0 µs | **4.0 µs** | **1.00x** | **1.00x** |
| **twitter.json (0.62 MB)** | 3.75 ms | 3.50 ms | **3.25 ms** | **1.15x** | **1.08x** |
<!-- mdformat on -->


#### Detailed Breakdown: JS Encode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Old Dart + json_serial | New Dart + json_serial | New Dart + Codable | Speedup vs Old Dart | Speedup vs New json_serial |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 9.00 ms | 7.50 ms | **4.50 ms** | **2.00x** | **1.67x** |
| **canada.json (2.25 MB)** | 33.00 ms | 31.00 ms | **28.50 ms** | **1.16x** | **1.09x** |
| **citm_catalog.json (1.73 MB)** | 11.00 ms | 8.50 ms | **6.25 ms** | **1.76x** | **1.36x** |
| **small.json (0.55 KB)** | 9.0 µs | 12.0 µs | **5.0 µs** | **1.80x** | **2.40x** |
| **twitter.json (0.62 MB)** | 5.50 ms | 3.50 ms | **4.00 ms** | **1.38x** | **0.88x** |
<!-- mdformat on -->

------------------------------------------------------------------------

### 🎯 WASM Target Detailed Breakdown

#### Detailed Breakdown: WASM Decode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Old Dart + json_serial | New Dart + json_serial | New Dart + Codable | Speedup vs Old Dart | Speedup vs New json_serial |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 3.43 ms | 3.41 ms | **11.79 ms** | **0.29x** | **0.29x** |
| **canada.json (2.25 MB)** | 34.96 ms | 37.22 ms | **31.73 ms** | **1.10x** | **1.17x** |
| **citm_catalog.json (1.73 MB)** | 5.81 ms | 6.14 ms | **20.09 ms** | **0.29x** | **0.31x** |
| **small.json (0.55 KB)** | 3.3 µs | 3.1 µs | **7.4 µs** | **0.45x** | **0.42x** |
| **twitter.json (0.62 MB)** | 3.20 ms | 3.22 ms | **7.77 ms** | **0.41x** | **0.41x** |
<!-- mdformat on -->


#### Detailed Breakdown: WASM Encode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Old Dart + json_serial | New Dart + json_serial | New Dart + Codable | Speedup vs Old Dart | Speedup vs New json_serial |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 13.10 ms | 4.54 ms | **7.83 ms** | **1.67x** | **0.58x** |
| **canada.json (2.25 MB)** | 52.27 ms | 40.30 ms | **42.84 ms** | **1.22x** | **0.94x** |
| **citm_catalog.json (1.73 MB)** | 8.11 ms | 6.64 ms | **9.05 ms** | **0.90x** | **0.73x** |
| **small.json (0.55 KB)** | 5.3 µs | 4.9 µs | **3.7 µs** | **1.43x** | **1.32x** |
| **twitter.json (0.62 MB)** | 6.54 ms | 3.73 ms | **7.17 ms** | **0.91x** | **0.52x** |
<!-- mdformat on -->

------------------------------------------------------------------------
