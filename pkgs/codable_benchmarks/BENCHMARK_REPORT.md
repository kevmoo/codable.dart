### 📊 3-Runtime Summary (Relative Efficiency Index)

<!-- mdformat off(prevent table wrapping) -->
| Target Runtime | Dart Configuration | 📥 Decode Efficiency<br/>[ Worst / GeoMean / Best ] | 📤 Encode Efficiency<br/>[ Worst / GeoMean / Best ] |
| :--- | :--- | :---: | :---: |
| **AOT (`dart compile exe`)** | **`New Dart + Codable`** | 🔴 `[ 40 / 55 / 69 ]` | 🟢 `[ 95 / 98 / 100 ]` |
| **JS (`dart2js` / Node 24 / V8)** | **`New Dart + Codable`** | 🟡 `[ 37 / 82 / 100 ]` | 🟢 `[ 100 / 100 / 100 ]` |
| **WASM (`dart2wasm` / Node 24 / V8)** | **`New Dart + Codable`** | 🟡 `[ 74 / 85 / 100 ]` | 🟢 `[ 96 / 99 / 100 ]` |
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
| **10k Coordinates (0.39 MB)** | 4.85 ms | **8.28 ms** | **0.59x** |
| **canada.json (2.25 MB)** | 41.03 ms | **59.08 ms** | **0.69x** |
| **citm_catalog.json (1.73 MB)** | 8.91 ms | **16.95 ms** | **0.53x** |
| **small.json (0.55 KB)** | 3.5 µs | **6.2 µs** | **0.57x** |
| **twitter.json (0.62 MB)** | 3.44 ms | **8.65 ms** | **0.40x** |
<!-- mdformat on -->


#### Detailed Breakdown: AOT Encode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | json_serializable | package:codable | Speedup vs json_serializable |
| :--- | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 4.87 ms | **2.86 ms** | **1.70x** |
| **canada.json (2.25 MB)** | 31.07 ms | **32.70 ms** | **0.95x** |
| **citm_catalog.json (1.73 MB)** | 6.58 ms | **3.09 ms** | **2.13x** |
| **small.json (0.55 KB)** | 5.4 µs | **5.7 µs** | **0.95x** |
| **twitter.json (0.62 MB)** | 3.21 ms | **1.93 ms** | **1.67x** |
<!-- mdformat on -->


------------------------------------------------------------------------

### 🎯 JS Target Detailed Breakdown

#### Detailed Breakdown: JS Decode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | json_serializable | package:codable | Speedup vs json_serializable |
| :--- | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 5.03 ms | **2.60 ms** | **1.93x** |
| **canada.json (2.25 MB)** | 44.86 ms | **25.34 ms** | **1.77x** |
| **citm_catalog.json (1.73 MB)** | 10.52 ms | **6.88 ms** | **1.53x** |
| **small.json (0.55 KB)** | 5.5 µs | **14.8 µs** | **0.37x** |
| **twitter.json (0.62 MB)** | 4.18 ms | **3.31 ms** | **1.26x** |
<!-- mdformat on -->


#### Detailed Breakdown: JS Encode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | json_serializable | package:codable | Speedup vs json_serializable |
| :--- | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 13.24 ms | **2.75 ms** | **4.82x** |
| **canada.json (2.25 MB)** | 36.83 ms | **25.45 ms** | **1.45x** |
| **citm_catalog.json (1.73 MB)** | 14.11 ms | **5.79 ms** | **2.44x** |
| **small.json (0.55 KB)** | 18.8 µs | **3.4 µs** | **5.53x** |
| **twitter.json (0.62 MB)** | 4.81 ms | **3.68 ms** | **1.31x** |
<!-- mdformat on -->


------------------------------------------------------------------------

### 🎯 WASM Target Detailed Breakdown

#### Detailed Breakdown: WASM Decode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | json_serializable | package:codable | Speedup vs json_serializable |
| :--- | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 4.35 ms | **4.92 ms** | **0.88x** |
| **canada.json (2.25 MB)** | 58.62 ms | **20.24 ms** | **2.90x** |
| **citm_catalog.json (1.73 MB)** | 6.85 ms | **7.91 ms** | **0.87x** |
| **small.json (0.55 KB)** | 3.6 µs | **4.9 µs** | **0.74x** |
| **twitter.json (0.62 MB)** | 3.55 ms | **4.48 ms** | **0.79x** |
<!-- mdformat on -->


#### Detailed Breakdown: WASM Encode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | json_serializable | package:codable | Speedup vs json_serializable |
| :--- | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 4.97 ms | **3.69 ms** | **1.35x** |
| **canada.json (2.25 MB)** | 39.83 ms | **25.61 ms** | **1.56x** |
| **citm_catalog.json (1.73 MB)** | 5.69 ms | **5.26 ms** | **1.08x** |
| **small.json (0.55 KB)** | 6.2 µs | **3.4 µs** | **1.84x** |
| **twitter.json (0.62 MB)** | 3.47 ms | **3.61 ms** | **0.96x** |
<!-- mdformat on -->


------------------------------------------------------------------------
