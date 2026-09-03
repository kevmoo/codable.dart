### 📊 3-Runtime Summary (Relative Efficiency Index)

<!-- mdformat off(prevent table wrapping) -->
| Target Runtime | Dart Configuration | 📥 Decode Efficiency<br/>[ Worst / GeoMean / Best ] | 📤 Encode Efficiency<br/>[ Worst / GeoMean / Best ] |
| :--- | :--- | :---: | :---: |
| **AOT (`dart compile exe`)** | **`New Dart + Codable`** | 🔴 `[ 42 / 56 / 70 ]` | 🟢 `[ 86 / 137 / 213 ]` |
| **JS (`dart2js` / Node 24 / V8)** | **`New Dart + Codable`** | 🟡 `[ 36 / 118 / 197 ]` | 🟢 `[ 136 / 268 / 541 ]` |
| **WASM (`dart2wasm` / Chrome)** | **`New Dart + Codable`** | 🔴 `[ 63 / 88 / 260 ]` | 🟡 `[ 67 / 99 / 155 ]` |
<!-- mdformat on -->

> **Scoring Metric**: **Relative Throughput Efficiency** (`100` = Peak Speed). Calculated as `round((MinLatency / Latency) * 100)` per workload, aggregated across benchmarks using the **Geometric Mean** (Fleming & Wallace 1986).
> - **`[ Worst / GeoMean / Best ]`**: Range from lowest score (worst workload) to the geometric mean and peak dataset score across the 5 canonical benchmarks (`coordinates`, `canada`, `citm_catalog`, `small`, `twitter`).
> - **Badges**: 🥇 Peak across all workloads (`100`) &bull; 🟢 `≥ 90` (Within 10% of peak) &bull; 🟡 `70–89` (Good / moderate) &bull; 🔴 `< 70` (Significant performance gap).


------------------------------------------------------------------------

### 🎯 AOT Target Detailed Breakdown

#### Detailed Breakdown: AOT Decode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | json_serializable | package:codable | Speedup vs json_serializable |
| :--- | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 4.89 ms | **7.75 ms** | **0.63x** |
| **canada.json (2.25 MB)** | 38.81 ms | **55.55 ms** | **0.70x** |
| **citm_catalog.json (1.73 MB)** | 9.67 ms | **16.47 ms** | **0.59x** |
| **small.json (0.55 KB)** | 2.8 µs | **5.6 µs** | **0.50x** |
| **twitter.json (0.62 MB)** | 3.75 ms | **8.94 ms** | **0.42x** |
<!-- mdformat on -->


#### Detailed Breakdown: AOT Encode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | json_serializable | package:codable | Speedup vs json_serializable |
| :--- | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 4.52 ms | **2.91 ms** | **1.55x** |
| **canada.json (2.25 MB)** | 30.73 ms | **31.66 ms** | **0.97x** |
| **citm_catalog.json (1.73 MB)** | 6.38 ms | **3.00 ms** | **2.13x** |
| **small.json (0.55 KB)** | 4.9 µs | **5.7 µs** | **0.86x** |
| **twitter.json (0.62 MB)** | 3.06 ms | **1.78 ms** | **1.72x** |
<!-- mdformat on -->


------------------------------------------------------------------------

### 🎯 JS Target Detailed Breakdown

#### Detailed Breakdown: JS Decode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | json_serializable | package:codable | Speedup vs json_serializable |
| :--- | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 5.10 ms | **2.59 ms** | **1.97x** |
| **canada.json (2.25 MB)** | 43.31 ms | **24.14 ms** | **1.79x** |
| **citm_catalog.json (1.73 MB)** | 10.34 ms | **6.88 ms** | **1.50x** |
| **small.json (0.55 KB)** | 5.8 µs | **16.2 µs** | **0.36x** |
| **twitter.json (0.62 MB)** | 4.12 ms | **3.40 ms** | **1.21x** |
<!-- mdformat on -->


#### Detailed Breakdown: JS Encode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | json_serializable | package:codable | Speedup vs json_serializable |
| :--- | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 12.25 ms | **2.57 ms** | **4.76x** |
| **canada.json (2.25 MB)** | 41.54 ms | **25.87 ms** | **1.61x** |
| **citm_catalog.json (1.73 MB)** | 13.60 ms | **5.48 ms** | **2.48x** |
| **small.json (0.55 KB)** | 17.3 µs | **3.2 µs** | **5.41x** |
| **twitter.json (0.62 MB)** | 4.87 ms | **3.58 ms** | **1.36x** |
<!-- mdformat on -->


------------------------------------------------------------------------

### 🎯 WASM Target Detailed Breakdown

#### Detailed Breakdown: WASM Decode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | json_serializable | package:codable | Speedup vs json_serializable |
| :--- | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 3.51 ms | **5.08 ms** | **0.69x** |
| **canada.json (2.25 MB)** | 45.05 ms | **17.31 ms** | **2.60x** |
| **citm_catalog.json (1.73 MB)** | 5.69 ms | **7.66 ms** | **0.74x** |
| **small.json (0.55 KB)** | 3.3 µs | **5.3 µs** | **0.63x** |
| **twitter.json (0.62 MB)** | 3.40 ms | **5.44 ms** | **0.63x** |
<!-- mdformat on -->


#### Detailed Breakdown: WASM Encode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | json_serializable | package:codable | Speedup vs json_serializable |
| :--- | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 4.28 ms | **3.54 ms** | **1.21x** |
| **canada.json (2.25 MB)** | 26.90 ms | **24.04 ms** | **1.12x** |
| **citm_catalog.json (1.73 MB)** | 5.13 ms | **7.71 ms** | **0.67x** |
| **small.json (0.55 KB)** | 6.5 µs | **4.2 µs** | **1.55x** |
| **twitter.json (0.62 MB)** | 3.19 ms | **4.75 ms** | **0.67x** |
<!-- mdformat on -->


------------------------------------------------------------------------
