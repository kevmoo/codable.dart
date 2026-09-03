### 📊 3-Runtime Summary (Relative Efficiency Index)

<!-- mdformat off(prevent table wrapping) -->
| Target Runtime | Dart Configuration | 📥 Decode Efficiency<br/>[ Worst / GeoMean / Best ] | 📤 Encode Efficiency<br/>[ Worst / GeoMean / Best ] |
| :--- | :--- | :---: | :---: |
| **AOT (`dart compile exe`)** | **`New Dart + Codable`** | 🔴 `[ 42 / 55 / 69 ]` | 🟢 `[ 86 / 98 / 100 ]` |
| **JS (`dart2js` / Node 24 / V8)** | **`New Dart + Codable`** | 🟡 `[ 36 / 80 / 100 ]` | 🟢 `[ 100 / 100 / 100 ]` |
| **WASM (`dart2wasm` / Node 24 / V8)** | **`New Dart + Codable`** | 🔴 `[ 50 / 72 / 100 ]` | 🟢 `[ 94 / 99 / 100 ]` |
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
| **10k Coordinates (0.39 MB)** | 4.93 ms | **8.04 ms** | **0.61x** |
| **canada.json (2.25 MB)** | 38.86 ms | **56.68 ms** | **0.69x** |
| **citm_catalog.json (1.73 MB)** | 8.51 ms | **16.76 ms** | **0.51x** |
| **small.json (0.55 KB)** | 3.2 µs | **5.6 µs** | **0.57x** |
| **twitter.json (0.62 MB)** | 3.61 ms | **8.64 ms** | **0.42x** |
<!-- mdformat on -->


#### Detailed Breakdown: AOT Encode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | json_serializable | package:codable | Speedup vs json_serializable |
| :--- | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 4.84 ms | **2.81 ms** | **1.72x** |
| **canada.json (2.25 MB)** | 30.34 ms | **32.59 ms** | **0.93x** |
| **citm_catalog.json (1.73 MB)** | 6.27 ms | **3.15 ms** | **1.99x** |
| **small.json (0.55 KB)** | 5.1 µs | **5.9 µs** | **0.86x** |
| **twitter.json (0.62 MB)** | 3.04 ms | **1.75 ms** | **1.74x** |
<!-- mdformat on -->


------------------------------------------------------------------------

### 🎯 JS Target Detailed Breakdown

#### Detailed Breakdown: JS Decode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | json_serializable | package:codable | Speedup vs json_serializable |
| :--- | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 4.80 ms | **2.59 ms** | **1.85x** |
| **canada.json (2.25 MB)** | 41.50 ms | **24.31 ms** | **1.71x** |
| **citm_catalog.json (1.73 MB)** | 10.99 ms | **6.84 ms** | **1.61x** |
| **small.json (0.55 KB)** | 5.3 µs | **14.9 µs** | **0.36x** |
| **twitter.json (0.62 MB)** | 4.04 ms | **3.33 ms** | **1.21x** |
<!-- mdformat on -->


#### Detailed Breakdown: JS Encode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | json_serializable | package:codable | Speedup vs json_serializable |
| :--- | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 12.67 ms | **2.70 ms** | **4.69x** |
| **canada.json (2.25 MB)** | 40.10 ms | **27.39 ms** | **1.46x** |
| **citm_catalog.json (1.73 MB)** | 13.47 ms | **5.64 ms** | **2.39x** |
| **small.json (0.55 KB)** | 18.8 µs | **3.3 µs** | **5.68x** |
| **twitter.json (0.62 MB)** | 4.61 ms | **3.59 ms** | **1.28x** |
<!-- mdformat on -->


------------------------------------------------------------------------

### 🎯 WASM Target Detailed Breakdown

#### Detailed Breakdown: WASM Decode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | json_serializable | package:codable | Speedup vs json_serializable |
| :--- | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 4.30 ms | **6.32 ms** | **0.68x** |
| **canada.json (2.25 MB)** | 57.22 ms | **19.55 ms** | **2.93x** |
| **citm_catalog.json (1.73 MB)** | 6.69 ms | **8.32 ms** | **0.80x** |
| **small.json (0.55 KB)** | 3.4 µs | **4.9 µs** | **0.70x** |
| **twitter.json (0.62 MB)** | 3.65 ms | **7.27 ms** | **0.50x** |
<!-- mdformat on -->


#### Detailed Breakdown: WASM Encode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | json_serializable | package:codable | Speedup vs json_serializable |
| :--- | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 5.02 ms | **3.29 ms** | **1.53x** |
| **canada.json (2.25 MB)** | 39.43 ms | **25.22 ms** | **1.56x** |
| **citm_catalog.json (1.73 MB)** | 5.56 ms | **5.14 ms** | **1.08x** |
| **small.json (0.55 KB)** | 6.5 µs | **3.5 µs** | **1.86x** |
| **twitter.json (0.62 MB)** | 3.44 ms | **3.65 ms** | **0.94x** |
<!-- mdformat on -->


------------------------------------------------------------------------
