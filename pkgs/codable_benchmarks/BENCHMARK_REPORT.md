### 📊 3-Runtime Summary (Relative Efficiency Index)

<!-- mdformat off(prevent table wrapping) -->
| Target Runtime | Dart Configuration | 📥 Decode Efficiency<br/>[ Worst / Avg / Best ] | 📤 Encode Efficiency<br/>[ Worst / Avg / Best ] |
| :--- | :--- | :---: | :---: |
| **AOT (`dart compile exe`)** | **`Old Dart + json_serial`** | 🟡 `[ 32 / 75 / 100 ]` | 🔴 `[ 32 / 53 / 80 ]` |
|  | **`New Dart + json_serial`** | 🟡 `[ 42 / 77 / 100 ]` | 🟡 `[ 50 / 78 / 100 ]` |
|  | **`New Dart + Codable`** | 🟢 `[ 52 / 90 / 100 ]` | 🟢 `[ 67 / 91 / 100 ]` |
| **JS (`dart2js` / Node 24 / V8)** | **`Old Dart + json_serial`** | 🟡 `[ 45 / 82 / 100 ]` | 🔴 `[ 49 / 60 / 77 ]` |
|  | **`New Dart + json_serial`** | 🟡 `[ 44 / 81 / 100 ]` | 🟡 `[ 45 / 73 / 100 ]` |
|  | **`New Dart + Codable`** | 🟢 `[ 91 / 98 / 100 ]` | 🟢 `[ 85 / 97 / 100 ]` |
| **WASM (`dart2wasm` / d8)** | **`Old Dart + json_serial`** | 🟢 `[ 78 / 96 / 100 ]` | 🔴 `[ 49 / 67 / 80 ]` |
|  | **`New Dart + json_serial`** | 🟢 `[ 83 / 97 / 100 ]` | 🟢 `[ 80 / 94 / 100 ]` |
|  | **`New Dart + Codable`** | 🔴 `[ 31 / 51 / 100 ]` | 🟡 `[ 55 / 80 / 100 ]` |
<!-- mdformat on -->

> **Scoring Metric**: **Relative Throughput Efficiency** (`100` = Peak Speed). Calculated as `round((MinLatency / Latency) * 100)` per workload, measuring the percentage of maximum achievable throughput delivered.
> - **`[ Worst / Avg / Best ]`**: Range from lowest score (worst workload) to the average and peak dataset score across the 5 canonical benchmarks (`coordinates`, `canada`, `citm_catalog`, `small`, `twitter`).
> - **Badges**: 🥇 Peak across all workloads (`100`) &bull; 🟢 `≥ 90` (Within 10% of peak) &bull; 🟡 `70–89` (Good / moderate) &bull; 🔴 `< 70` (Significant performance gap).


------------------------------------------------------------------------

### 🎯 AOT Target Detailed Breakdown

#### Detailed Breakdown: AOT Decode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Old Dart + json_serial | New Dart + json_serial | New Dart + Codable | Speedup vs Old Dart | Speedup vs New json_serial |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 3.72 ms | 3.71 ms | **2.45 ms** | **1.51x** | **1.51x** |
| **canada.json (2.25 MB)** | 42.12 ms | 32.11 ms | **13.50 ms** | **3.12x** | **2.38x** |
| **citm_catalog.json (1.73 MB)** | 5.97 ms | 5.59 ms | **4.51 ms** | **1.32x** | **1.24x** |
| **small.json (0.55 KB)** | 0.00 ms | 0.00 ms | **0.00 ms** | **1.00x** | **1.00x** |
| **twitter.json (0.62 MB)** | 2.71 ms | 2.76 ms | **5.16 ms** | **0.52x** | **0.53x** |
<!-- mdformat on -->


#### Detailed Breakdown: AOT Encode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Old Dart + json_serial | New Dart + json_serial | New Dart + Codable | Speedup vs Old Dart | Speedup vs New json_serial |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 10.09 ms | 4.49 ms | **3.19 ms** | **3.17x** | **1.41x** |
| **canada.json (2.25 MB)** | 46.99 ms | 34.77 ms | **38.48 ms** | **1.22x** | **0.90x** |
| **citm_catalog.json (1.73 MB)** | 8.80 ms | 7.67 ms | **3.82 ms** | **2.30x** | **2.01x** |
| **small.json (0.55 KB)** | 0.01 ms | 0.00 ms | **0.01 ms** | **0.83x** | **0.67x** |
| **twitter.json (0.62 MB)** | 5.71 ms | 3.09 ms | **2.08 ms** | **2.74x** | **1.48x** |
<!-- mdformat on -->

------------------------------------------------------------------------

### 🎯 JS Target Detailed Breakdown

#### Detailed Breakdown: JS Decode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Old Dart + json_serial | New Dart + json_serial | New Dart + Codable | Speedup vs Old Dart | Speedup vs New json_serial |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 4.00 ms | 3.75 ms | **3.33 ms** | **1.20x** | **1.13x** |
| **canada.json (2.25 MB)** | 31.00 ms | 32.00 ms | **14.00 ms** | **2.21x** | **2.29x** |
| **citm_catalog.json (1.73 MB)** | 7.50 ms | 8.00 ms | **6.00 ms** | **1.25x** | **1.33x** |
| **small.json (0.55 KB)** | 0.00 ms | 0.00 ms | **0.00 ms** | **1.00x** | **1.00x** |
| **twitter.json (0.62 MB)** | 3.33 ms | 3.50 ms | **3.67 ms** | **0.91x** | **0.95x** |
<!-- mdformat on -->


#### Detailed Breakdown: JS Encode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Old Dart + json_serial | New Dart + json_serial | New Dart + Codable | Speedup vs Old Dart | Speedup vs New json_serial |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 9.25 ms | 7.50 ms | **4.50 ms** | **2.06x** | **1.67x** |
| **canada.json (2.25 MB)** | 36.50 ms | 32.00 ms | **28.00 ms** | **1.30x** | **1.14x** |
| **citm_catalog.json (1.73 MB)** | 11.00 ms | 8.50 ms | **6.00 ms** | **1.83x** | **1.42x** |
| **small.json (0.55 KB)** | 0.01 ms | 0.01 ms | **0.01 ms** | **1.80x** | **2.20x** |
| **twitter.json (0.62 MB)** | 6.00 ms | 3.67 ms | **4.33 ms** | **1.38x** | **0.85x** |
<!-- mdformat on -->

------------------------------------------------------------------------

### 🎯 WASM Target Detailed Breakdown

#### Detailed Breakdown: WASM Decode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Old Dart + json_serial | New Dart + json_serial | New Dart + Codable | Speedup vs Old Dart | Speedup vs New json_serial |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 3.34 ms | 3.35 ms | **7.69 ms** | **0.43x** | **0.44x** |
| **canada.json (2.25 MB)** | 37.20 ms | 35.13 ms | **29.14 ms** | **1.28x** | **1.21x** |
| **citm_catalog.json (1.73 MB)** | 5.38 ms | 5.39 ms | **17.58 ms** | **0.31x** | **0.31x** |
| **small.json (0.55 KB)** | 0.00 ms | 0.00 ms | **0.01 ms** | **0.43x** | **0.43x** |
| **twitter.json (0.62 MB)** | 2.96 ms | 2.96 ms | **8.29 ms** | **0.36x** | **0.36x** |
<!-- mdformat on -->


#### Detailed Breakdown: WASM Encode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Old Dart + json_serial | New Dart + json_serial | New Dart + Codable | Speedup vs Old Dart | Speedup vs New json_serial |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 9.36 ms | 4.58 ms | **6.17 ms** | **1.52x** | **0.74x** |
| **canada.json (2.25 MB)** | 48.91 ms | 43.20 ms | **38.91 ms** | **1.26x** | **1.11x** |
| **citm_catalog.json (1.73 MB)** | 8.52 ms | 5.41 ms | **7.57 ms** | **1.13x** | **0.71x** |
| **small.json (0.55 KB)** | 0.01 ms | 0.01 ms | **0.00 ms** | **1.25x** | **1.25x** |
| **twitter.json (0.62 MB)** | 5.28 ms | 3.40 ms | **6.14 ms** | **0.86x** | **0.55x** |
<!-- mdformat on -->

------------------------------------------------------------------------
