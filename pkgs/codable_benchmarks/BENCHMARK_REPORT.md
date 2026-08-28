### 📊 3-Runtime Summary (Relative Efficiency Index)

<!-- mdformat off(prevent table wrapping) -->
| Target Runtime | Dart Configuration | 📥 Decode Efficiency<br/>[ Worst / Avg / Best ] | 📤 Encode Efficiency<br/>[ Worst / Avg / Best ] |
| :--- | :--- | :---: | :---: |
| **AOT (`dart compile exe`)** | **`Old Dart + json_serial`** | 🟡 `[ 32 / 72 / 100 ]` | 🔴 `[ 35 / 55 / 100 ]` |
|  | **`New Dart + json_serial`** | 🟡 `[ 39 / 73 / 100 ]` | 🟡 `[ 54 / 78 / 100 ]` |
|  | **`New Dart + Codable`** | 🟢 `[ 62 / 92 / 100 ]` | 🟢 `[ 83 / 93 / 100 ]` |
| **JS (`dart2js` / Node 24 / V8)** | **`Old Dart + json_serial`** | 🟡 `[ 42 / 80 / 100 ]` | 🔴 `[ 50 / 59 / 85 ]` |
|  | **`New Dart + json_serial`** | 🟡 `[ 41 / 75 / 95 ]` | 🟡 `[ 42 / 73 / 100 ]` |
|  | **`New Dart + Codable`** | 🟢 `[ 78 / 96 / 100 ]` | 🟢 `[ 92 / 98 / 100 ]` |
| **WASM (`dart2wasm` / d8)** | **`Old Dart + json_serial`** | 🟢 `[ 95 / 98 / 100 ]` | 🔴 `[ 50 / 65 / 75 ]` |
|  | **`New Dart + json_serial`** | 🟢 `[ 98 / 99 / 100 ]` | 🟢 `[ 80 / 95 / 100 ]` |
|  | **`New Dart + Codable`** | 🔴 `[ 27 / 48 / 100 ]` | 🟡 `[ 53 / 75 / 100 ]` |
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
| **10k Coordinates (0.39 MB)** | 4.37 ms | 4.02 ms | **2.40 ms** | **1.82x** | **1.68x** |
| **canada.json (2.25 MB)** | 45.71 ms | 37.82 ms | **14.78 ms** | **3.09x** | **2.56x** |
| **citm_catalog.json (1.73 MB)** | 6.13 ms | 6.58 ms | **4.44 ms** | **1.38x** | **1.48x** |
| **small.json (0.55 KB)** | 0.00 ms | 0.00 ms | **0.00 ms** | **1.00x** | **1.00x** |
| **twitter.json (0.62 MB)** | 2.95 ms | 2.93 ms | **4.76 ms** | **0.62x** | **0.62x** |
<!-- mdformat on -->


#### Detailed Breakdown: AOT Encode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Old Dart + json_serial | New Dart + json_serial | New Dart + Codable | Speedup vs Old Dart | Speedup vs New json_serial |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 9.85 ms | 4.54 ms | **3.50 ms** | **2.82x** | **1.30x** |
| **canada.json (2.25 MB)** | 49.05 ms | 32.72 ms | **39.34 ms** | **1.25x** | **0.83x** |
| **citm_catalog.json (1.73 MB)** | 9.54 ms | 6.75 ms | **3.63 ms** | **2.62x** | **1.86x** |
| **small.json (0.55 KB)** | 0.01 ms | 0.01 ms | **0.01 ms** | **0.83x** | **0.83x** |
| **twitter.json (0.62 MB)** | 5.46 ms | 3.19 ms | **1.92 ms** | **2.84x** | **1.66x** |
<!-- mdformat on -->

------------------------------------------------------------------------

### 🎯 JS Target Detailed Breakdown

#### Detailed Breakdown: JS Decode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Old Dart + json_serial | New Dart + json_serial | New Dart + Codable | Speedup vs Old Dart | Speedup vs New json_serial |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 4.00 ms | 4.00 ms | **3.63 ms** | **1.10x** | **1.10x** |
| **canada.json (2.25 MB)** | 33.00 ms | 34.50 ms | **14.00 ms** | **2.36x** | **2.46x** |
| **citm_catalog.json (1.73 MB)** | 9.00 ms | 8.75 ms | **6.00 ms** | **1.50x** | **1.46x** |
| **small.json (0.55 KB)** | 0.00 ms | 0.01 ms | **0.00 ms** | **1.00x** | **1.25x** |
| **twitter.json (0.62 MB)** | 3.50 ms | 3.67 ms | **4.50 ms** | **0.78x** | **0.81x** |
<!-- mdformat on -->


#### Detailed Breakdown: JS Encode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Old Dart + json_serial | New Dart + json_serial | New Dart + Codable | Speedup vs Old Dart | Speedup vs New json_serial |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 10.00 ms | 8.00 ms | **5.00 ms** | **2.00x** | **1.60x** |
| **canada.json (2.25 MB)** | 35.50 ms | 33.00 ms | **30.00 ms** | **1.18x** | **1.10x** |
| **citm_catalog.json (1.73 MB)** | 12.00 ms | 9.00 ms | **6.00 ms** | **2.00x** | **1.50x** |
| **small.json (0.55 KB)** | 0.01 ms | 0.01 ms | **0.01 ms** | **2.00x** | **2.40x** |
| **twitter.json (0.62 MB)** | 6.00 ms | 3.67 ms | **4.00 ms** | **1.50x** | **0.92x** |
<!-- mdformat on -->

------------------------------------------------------------------------

### 🎯 WASM Target Detailed Breakdown

#### Detailed Breakdown: WASM Decode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Old Dart + json_serial | New Dart + json_serial | New Dart + Codable | Speedup vs Old Dart | Speedup vs New json_serial |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 3.37 ms | 3.40 ms | **7.91 ms** | **0.43x** | **0.43x** |
| **canada.json (2.25 MB)** | 37.63 ms | 37.10 ms | **36.53 ms** | **1.03x** | **1.02x** |
| **citm_catalog.json (1.73 MB)** | 5.98 ms | 6.13 ms | **18.11 ms** | **0.33x** | **0.34x** |
| **small.json (0.55 KB)** | 0.00 ms | 0.00 ms | **0.01 ms** | **0.38x** | **0.38x** |
| **twitter.json (0.62 MB)** | 3.22 ms | 3.05 ms | **11.35 ms** | **0.28x** | **0.27x** |
<!-- mdformat on -->


#### Detailed Breakdown: WASM Encode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Old Dart + json_serial | New Dart + json_serial | New Dart + Codable | Speedup vs Old Dart | Speedup vs New json_serial |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 9.28 ms | 4.67 ms | **7.97 ms** | **1.16x** | **0.59x** |
| **canada.json (2.25 MB)** | 54.14 ms | 41.44 ms | **40.39 ms** | **1.34x** | **1.03x** |
| **citm_catalog.json (1.73 MB)** | 8.24 ms | 5.83 ms | **9.29 ms** | **0.89x** | **0.63x** |
| **small.json (0.55 KB)** | 0.01 ms | 0.01 ms | **0.00 ms** | **1.50x** | **1.25x** |
| **twitter.json (0.62 MB)** | 5.29 ms | 3.35 ms | **6.27 ms** | **0.84x** | **0.53x** |
<!-- mdformat on -->

------------------------------------------------------------------------
