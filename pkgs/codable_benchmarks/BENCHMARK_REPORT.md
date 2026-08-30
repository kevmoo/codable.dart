## 🚀 Isolated Before vs. After Benchmark Delta (vs pkgs/codable_benchmarks/benchmark_comparison_baseline.json)

### Target: WASM (`dart2wasm` / d8) Encode (`New Dart + Codable`)

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Pre-Change Latency | Post-Change Latency | Absolute Delta | Delta (%) [±95% MoE] | Speedup vs pkgs/codable_benchmarks/benchmark_comparison_baseline.json |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 7.20 ± 0.51 ms | 6.64 ± 0.75 ms | -562.5 µs | -7.8% [±8.3%] | 1.08x (p ≥ 0.05) |
| **canada.json (2.25 MB)** | 41.65 ± 4.65 ms | 39.72 ± 4.22 ms | -1.93 ms | -4.6% [±9.8%] | 1.05x (p ≥ 0.05) |
| **citm_catalog.json (1.73 MB)** | 11.05 ± 1.82 ms | 10.00 ± 1.45 ms | -1.05 ms | -9.5% [±13.3%] | 1.11x (p ≥ 0.05) |
| **small.json (0.55 KB)** | 3.8 ± 0.1 µs | 3.8 ± 0.0 µs | +9 ns | +0.2% [±1.2%] | 1.00x (p ≥ 0.05) |
| **twitter.json (0.62 MB)** | 8.12 ± 1.33 ms | 7.04 ± 0.72 ms | -1.08 ms | **-13.3%** [±11.5%] | **1.15x faster** 🏆 |
<!-- mdformat on -->

> **Statistical Criteria**: Effect threshold = ±5.0% &bull; Significance = Welch's two-sample t-test with Welch–Satterthwaite df (p < 0.05) &bull; MoE = 95% CI via Delta Method for ratio variance.

### Target: WASM (`dart2wasm` / d8) Decode (`New Dart + Codable`)

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Pre-Change Latency | Post-Change Latency | Absolute Delta | Delta (%) [±95% MoE] | Speedup vs pkgs/codable_benchmarks/benchmark_comparison_baseline.json |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 11.53 ± 2.33 ms | 11.47 ± 2.27 ms | -62.7 µs | -0.5% [±18.7%] | 1.01x (p ≥ 0.05) |
| **canada.json (2.25 MB)** | 30.99 ± 3.51 ms | 31.71 ± 4.12 ms | +725.8 µs | +2.3% [±11.8%] | 0.98x (p ≥ 0.05) |
| **citm_catalog.json (1.73 MB)** | 19.37 ± 1.43 ms | 19.18 ± 1.59 ms | -189.0 µs | -1.0% [±7.3%] | 1.01x (p ≥ 0.05) |
| **small.json (0.55 KB)** | 7.7 ± 0.2 µs | 7.6 ± 0.2 µs | -94 ns | -1.2% [±2.0%] | 1.01x (p ≥ 0.05) |
| **twitter.json (0.62 MB)** | 8.63 ± 1.17 ms | 8.13 ± 0.99 ms | -498.6 µs | -5.8% [±11.5%] | 1.06x (p ≥ 0.05) |
<!-- mdformat on -->

> **Statistical Criteria**: Effect threshold = ±5.0% &bull; Significance = Welch's two-sample t-test with Welch–Satterthwaite df (p < 0.05) &bull; MoE = 95% CI via Delta Method for ratio variance.

### Target: AOT (`dart compile exe`) Encode (`New Dart + Codable`)

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Pre-Change Latency | Post-Change Latency | Absolute Delta | Delta (%) [±95% MoE] | Speedup vs pkgs/codable_benchmarks/benchmark_comparison_baseline.json |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 2.59 ± 0.12 ms | 2.81 ± 0.33 ms | +215.5 µs | +8.3% [±9.5%] | 0.92x (p ≥ 0.05) |
| **canada.json (2.25 MB)** | 36.70 ± 2.78 ms | 36.23 ± 2.90 ms | -469.2 µs | -1.3% [±7.3%] | 1.01x (p ≥ 0.05) |
| **citm_catalog.json (1.73 MB)** | 3.13 ± 0.60 ms | 2.93 ± 0.63 ms | -196.9 µs | -6.3% [±18.1%] | 1.07x (p ≥ 0.05) |
| **small.json (0.55 KB)** | 5.5 ± 0.1 µs | 6.6 ± 0.6 µs | +1.1 µs | **+19.4%** [±7.4%] | **0.84x (regression)** 🔴 |
| **twitter.json (0.62 MB)** | 1.78 ± 0.08 ms | 1.75 ± 0.09 ms | -36.1 µs | -2.0% [±4.6%] | 1.02x (p ≥ 0.05) |
<!-- mdformat on -->

> **Statistical Criteria**: Effect threshold = ±5.0% &bull; Significance = Welch's two-sample t-test with Welch–Satterthwaite df (p < 0.05) &bull; MoE = 95% CI via Delta Method for ratio variance.

### Target: AOT (`dart compile exe`) Decode (`New Dart + Codable`)

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Pre-Change Latency | Post-Change Latency | Absolute Delta | Delta (%) [±95% MoE] | Speedup vs pkgs/codable_benchmarks/benchmark_comparison_baseline.json |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 2.39 ± 0.09 ms | 2.40 ± 0.08 ms | +9.7 µs | +0.4% [±3.4%] | 1.00x (p ≥ 0.05) |
| **canada.json (2.25 MB)** | 13.82 ± 3.21 ms | 14.73 ± 4.17 ms | +911.9 µs | +6.6% [±26.2%] | 0.94x (p ≥ 0.05) |
| **citm_catalog.json (1.73 MB)** | 4.56 ± 0.41 ms | 4.52 ± 0.33 ms | -40.7 µs | -0.9% [±7.6%] | 1.01x (p ≥ 0.05) |
| **small.json (0.55 KB)** | 3.2 ± 0.1 µs | 3.1 ± 0.0 µs | -98 ns | -3.1% [±1.7%] | 1.03x (parity) |
| **twitter.json (0.62 MB)** | 4.80 ± 0.12 ms | 4.74 ± 0.32 ms | -60.7 µs | -1.3% [±4.9%] | 1.01x (p ≥ 0.05) |
<!-- mdformat on -->

> **Statistical Criteria**: Effect threshold = ±5.0% &bull; Significance = Welch's two-sample t-test with Welch–Satterthwaite df (p < 0.05) &bull; MoE = 95% CI via Delta Method for ratio variance.

### Target: JS (`dart2js` / Node 24 / V8) Encode (`New Dart + Codable`)

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Pre-Change Latency | Post-Change Latency | Absolute Delta | Delta (%) [±95% MoE] | Speedup vs pkgs/codable_benchmarks/benchmark_comparison_baseline.json |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 4.50 ± 0.24 ms | 4.00 ± 0.16 ms | -500.0 µs | **-11.1%** [±2.7%] | **1.13x faster** 🏆 |
| **canada.json (2.25 MB)** | 29.00 ± 4.80 ms | 27.00 ± 6.05 ms | -2.00 ms | -6.9% [±11.6%] | 1.07x (p ≥ 0.05) |
| **citm_catalog.json (1.73 MB)** | 6.75 ± 1.59 ms | 6.00 ± 1.45 ms | -750.0 µs | -11.1% [±13.4%] | 1.13x (p ≥ 0.05) |
| **small.json (0.55 KB)** | 6.0 ± 2.0 µs | 9.0 ± 4.0 µs | +3.0 µs | **+50.0%** [±38.2%] | **0.67x (regression)** 🔴 |
| **twitter.json (0.62 MB)** | 4.67 ± 0.70 ms | 4.00 ± 0.53 ms | -667.0 µs | **-14.3%** [±7.6%] | **1.17x faster** 🏆 |
<!-- mdformat on -->

> **Statistical Criteria**: Effect threshold = ±5.0% &bull; Significance = Welch's two-sample t-test with Welch–Satterthwaite df (p < 0.05) &bull; MoE = 95% CI via Delta Method for ratio variance.

### Target: JS (`dart2js` / Node 24 / V8) Decode (`New Dart + Codable`)

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Pre-Change Latency | Post-Change Latency | Absolute Delta | Delta (%) [±95% MoE] | Speedup vs pkgs/codable_benchmarks/benchmark_comparison_baseline.json |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 6.00 ± 1.94 ms | 4.25 ± 1.45 ms | -1.75 ms | **-29.2%** [±14.9%] | **1.41x faster** 🏆 |
| **canada.json (2.25 MB)** | 12.00 ± 2.99 ms | 12.00 ± 3.03 ms | +0 ns | +0.0% [±15.9%] | 1.00x (p ≥ 0.05) |
| **citm_catalog.json (1.73 MB)** | 6.25 ± 1.07 ms | 6.25 ± 0.78 ms | +0 ns | +0.0% [±9.5%] | 1.00x (p ≥ 0.05) |
| **small.json (0.55 KB)** | 4.0 µs | 4.0 µs | +0 ns | +0.0% | 1.00x (p ≥ 0.05) |
| **twitter.json (0.62 MB)** | 3.25 ± 0.44 ms | 3.25 ± 0.13 ms | +0 ns | +0.0% [±6.6%] | 1.00x (p ≥ 0.05) |
<!-- mdformat on -->

> **Statistical Criteria**: Effect threshold = ±5.0% &bull; Significance = Welch's two-sample t-test with Welch–Satterthwaite df (p < 0.05) &bull; MoE = 95% CI via Delta Method for ratio variance.

------------------------------------------------------------------------

### 📊 3-Runtime Summary (Relative Efficiency Index)

<!-- mdformat off(prevent table wrapping) -->
| Target Runtime | Dart Configuration | 📥 Decode Efficiency<br/>[ Worst / GeoMean / Best ] | 📤 Encode Efficiency<br/>[ Worst / GeoMean / Best ] |
| :--- | :--- | :---: | :---: |
| **AOT (`dart compile exe`)** | **`Old Dart + json_serial`** | 🔴 `[ 32 / 69 / 100 ]` | 🔴 `[ 31 / 46 / 91 ]` |
|  | **`New Dart + json_serial`** | 🟡 `[ 46 / 75 / 100 ]` | 🔴 `[ 45 / 69 / 100 ]` |
|  | **`New Dart + Codable`** | 🟡 `[ 59 / 88 / 100 ]` | 🟡 `[ 62 / 89 / 100 ]` |
| **JS (`dart2js` / Node 24 / V8)** | **`Old Dart + json_serial`** | 🟡 `[ 33 / 74 / 100 ]` | 🔴 `[ 44 / 67 / 100 ]` |
|  | **`New Dart + json_serial`** | 🟡 `[ 33 / 76 / 100 ]` | 🟡 `[ 47 / 71 / 100 ]` |
|  | **`New Dart + Codable`** | 🟢 `[ 94 / 99 / 100 ]` | 🟢 `[ 88 / 95 / 100 ]` |
| **WASM (`dart2wasm` / d8)** | **`Old Dart + json_serial`** | 🟢 `[ 78 / 90 / 100 ]` | 🔴 `[ 36 / 65 / 81 ]` |
|  | **`New Dart + json_serial`** | 🟢 `[ 88 / 96 / 100 ]` | 🟢 `[ 76 / 93 / 100 ]` |
|  | **`New Dart + Codable`** | 🔴 `[ 31 / 44 / 100 ]` | 🟡 `[ 59 / 78 / 100 ]` |
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
| **10k Coordinates (0.39 MB)** | 4.02 ms | 3.55 ms | **2.38 ms** | **1.69x** | **1.49x** |
| **canada.json (2.25 MB)** | 44.88 ms | 31.37 ms | **14.57 ms** | **3.08x** | **2.15x** |
| **citm_catalog.json (1.73 MB)** | 5.46 ms | 5.49 ms | **4.38 ms** | **1.25x** | **1.25x** |
| **small.json (0.55 KB)** | 2.7 µs | 2.7 µs | **3.1 µs** | **0.89x** | **0.89x** |
| **twitter.json (0.62 MB)** | 2.78 ms | 2.86 ms | **4.70 ms** | **0.59x** | **0.61x** |
<!-- mdformat on -->


#### Detailed Breakdown: AOT Encode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Old Dart + json_serial | New Dart + json_serial | New Dart + Codable | Speedup vs Old Dart | Speedup vs New json_serial |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 8.74 ms | 4.27 ms | **2.67 ms** | **3.27x** | **1.60x** |
| **canada.json (2.25 MB)** | 44.27 ms | 31.34 ms | **35.33 ms** | **1.25x** | **0.89x** |
| **citm_catalog.json (1.73 MB)** | 8.82 ms | 6.14 ms | **2.79 ms** | **3.16x** | **2.20x** |
| **small.json (0.55 KB)** | 4.5 µs | 4.1 µs | **6.7 µs** | **0.68x** | **0.62x** |
| **twitter.json (0.62 MB)** | 5.40 ms | 3.07 ms | **1.75 ms** | **3.09x** | **1.76x** |
<!-- mdformat on -->

------------------------------------------------------------------------

### 🎯 JS Target Detailed Breakdown

#### Detailed Breakdown: JS Decode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Old Dart + json_serial | New Dart + json_serial | New Dart + Codable | Speedup vs Old Dart | Speedup vs New json_serial |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 4.00 ms | 4.00 ms | **4.25 ms** | **0.94x** | **0.94x** |
| **canada.json (2.25 MB)** | 36.50 ms | 36.00 ms | **12.00 ms** | **3.04x** | **3.00x** |
| **citm_catalog.json (1.73 MB)** | 8.50 ms | 8.00 ms | **6.25 ms** | **1.36x** | **1.28x** |
| **small.json (0.55 KB)** | 4.0 µs | 4.0 µs | **4.0 µs** | **1.00x** | **1.00x** |
| **twitter.json (0.62 MB)** | 3.50 ms | 3.33 ms | **3.25 ms** | **1.08x** | **1.03x** |
<!-- mdformat on -->


#### Detailed Breakdown: JS Encode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Old Dart + json_serial | New Dart + json_serial | New Dart + Codable | Speedup vs Old Dart | Speedup vs New json_serial |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 9.00 ms | 8.50 ms | **4.00 ms** | **2.25x** | **2.13x** |
| **canada.json (2.25 MB)** | 32.00 ms | 34.50 ms | **27.00 ms** | **1.19x** | **1.28x** |
| **citm_catalog.json (1.73 MB)** | 11.00 ms | 8.50 ms | **6.00 ms** | **1.83x** | **1.42x** |
| **small.json (0.55 KB)** | 8.0 µs | 12.0 µs | **9.0 µs** | **0.89x** | **1.33x** |
| **twitter.json (0.62 MB)** | 5.50 ms | 3.50 ms | **4.00 ms** | **1.38x** | **0.88x** |
<!-- mdformat on -->

------------------------------------------------------------------------

### 🎯 WASM Target Detailed Breakdown

#### Detailed Breakdown: WASM Decode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Old Dart + json_serial | New Dart + json_serial | New Dart + Codable | Speedup vs Old Dart | Speedup vs New json_serial |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 4.58 ms | 3.59 ms | **11.54 ms** | **0.40x** | **0.31x** |
| **canada.json (2.25 MB)** | 36.40 ms | 35.58 ms | **31.41 ms** | **1.16x** | **1.13x** |
| **citm_catalog.json (1.73 MB)** | 5.56 ms | 5.92 ms | **17.99 ms** | **0.31x** | **0.33x** |
| **small.json (0.55 KB)** | 3.1 µs | 3.1 µs | **7.6 µs** | **0.41x** | **0.41x** |
| **twitter.json (0.62 MB)** | 3.40 ms | 3.11 ms | **7.60 ms** | **0.45x** | **0.41x** |
<!-- mdformat on -->


#### Detailed Breakdown: WASM Encode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Old Dart + json_serial | New Dart + json_serial | New Dart + Codable | Speedup vs Old Dart | Speedup vs New json_serial |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 12.73 ms | 4.58 ms | **6.27 ms** | **2.03x** | **0.73x** |
| **canada.json (2.25 MB)** | 47.69 ms | 42.64 ms | **38.41 ms** | **1.24x** | **1.11x** |
| **citm_catalog.json (1.73 MB)** | 8.43 ms | 6.40 ms | **9.35 ms** | **0.90x** | **0.68x** |
| **small.json (0.55 KB)** | 5.4 µs | 4.9 µs | **3.8 µs** | **1.42x** | **1.31x** |
| **twitter.json (0.62 MB)** | 5.61 ms | 4.06 ms | **6.94 ms** | **0.81x** | **0.59x** |
<!-- mdformat on -->

------------------------------------------------------------------------
