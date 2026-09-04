### 📊 3-Runtime Summary (Relative Efficiency Index)

<!-- mdformat off(prevent table wrapping) -->
| Target Runtime | Dart Configuration | 📥 Decode Efficiency<br/>[ Worst / GeoMean / Best ] | 📤 Encode Efficiency<br/>[ Worst / GeoMean / Best ] |
| :--- | :--- | :---: | :---: |
| **AOT (`dart compile exe`)** | **`New Dart + Codable`** | 🔴 `[ 42 / 54 / 72 ]` | 🟢 `[ 88 / 96 / 100 ]` |
| **JS (`dart2js` / Node 24 / V8)** | **`New Dart + Codable`** | 🟡 `[ 37 / 82 / 100 ]` | 🟢 `[ 100 / 100 / 100 ]` |
| **WASM (`dart2wasm` / Node 24 / V8)** | **`New Dart + Codable`** | 🟡 `[ 69 / 83 / 100 ]` | 🟢 `[ 96 / 99 / 100 ]` |
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
| **10k Coordinates (0.39 MB)** | 5.02 ms | **8.14 ms** | **0.62x** |
| **canada.json (2.25 MB)** | 41.33 ms | **57.59 ms** | **0.72x** |
| **citm_catalog.json (1.73 MB)** | 8.66 ms | **17.13 ms** | **0.51x** |
| **small.json (0.55 KB)** | 2.7 µs | **5.7 µs** | **0.48x** |
| **twitter.json (0.62 MB)** | 3.68 ms | **8.73 ms** | **0.42x** |
<!-- mdformat on -->


#### Detailed Breakdown: AOT Encode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | json_serializable | package:codable | Speedup vs json_serializable |
| :--- | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 4.88 ms | **2.94 ms** | **1.66x** |
| **canada.json (2.25 MB)** | 31.45 ms | **33.14 ms** | **0.95x** |
| **citm_catalog.json (1.73 MB)** | 6.13 ms | **3.24 ms** | **1.89x** |
| **small.json (0.55 KB)** | 5.3 µs | **6.1 µs** | **0.88x** |
| **twitter.json (0.62 MB)** | 3.27 ms | **1.76 ms** | **1.85x** |
<!-- mdformat on -->


------------------------------------------------------------------------

### 🎯 JS Target Detailed Breakdown

#### Detailed Breakdown: JS Decode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | json_serializable | package:codable | Speedup vs json_serializable |
| :--- | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 5.17 ms | **2.56 ms** | **2.02x** |
| **canada.json (2.25 MB)** | 42.55 ms | **25.14 ms** | **1.69x** |
| **citm_catalog.json (1.73 MB)** | 10.79 ms | **7.19 ms** | **1.50x** |
| **small.json (0.55 KB)** | 5.5 µs | **15.2 µs** | **0.37x** |
| **twitter.json (0.62 MB)** | 4.06 ms | **3.41 ms** | **1.19x** |
<!-- mdformat on -->


#### Detailed Breakdown: JS Encode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | json_serializable | package:codable | Speedup vs json_serializable |
| :--- | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 12.96 ms | **2.59 ms** | **5.01x** |
| **canada.json (2.25 MB)** | 36.05 ms | **27.41 ms** | **1.32x** |
| **citm_catalog.json (1.73 MB)** | 13.75 ms | **5.51 ms** | **2.50x** |
| **small.json (0.55 KB)** | 18.8 µs | **3.4 µs** | **5.51x** |
| **twitter.json (0.62 MB)** | 4.60 ms | **3.50 ms** | **1.32x** |
<!-- mdformat on -->


------------------------------------------------------------------------

### 🎯 WASM Target Detailed Breakdown

#### Detailed Breakdown: WASM Decode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | json_serializable | package:codable | Speedup vs json_serializable |
| :--- | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 4.37 ms | **4.91 ms** | **0.89x** |
| **canada.json (2.25 MB)** | 58.96 ms | **20.23 ms** | **2.91x** |
| **citm_catalog.json (1.73 MB)** | 6.78 ms | **8.20 ms** | **0.83x** |
| **small.json (0.55 KB)** | 3.5 µs | **5.0 µs** | **0.69x** |
| **twitter.json (0.62 MB)** | 3.61 ms | **4.61 ms** | **0.78x** |
<!-- mdformat on -->


#### Detailed Breakdown: WASM Encode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | json_serializable | package:codable | Speedup vs json_serializable |
| :--- | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 4.85 ms | **3.33 ms** | **1.45x** |
| **canada.json (2.25 MB)** | 38.78 ms | **24.84 ms** | **1.56x** |
| **citm_catalog.json (1.73 MB)** | 6.05 ms | **5.27 ms** | **1.15x** |
| **small.json (0.55 KB)** | 6.1 µs | **3.4 µs** | **1.80x** |
| **twitter.json (0.62 MB)** | 3.46 ms | **3.60 ms** | **0.96x** |
<!-- mdformat on -->


------------------------------------------------------------------------
