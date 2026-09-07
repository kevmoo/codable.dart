### 📊 3-Runtime Summary (Relative Efficiency Index)

<!-- mdformat off(prevent table wrapping) -->
| Target Runtime | Dart Configuration | 📥 Decode Efficiency<br/>[ Worst / GeoMean / Best ] | 📤 Encode Efficiency<br/>[ Worst / GeoMean / Best ] |
| :--- | :--- | :---: | :---: |
| **AOT (`dart compile exe`)** | **`New Dart + Codable`** | 🟢 `[ 93 / 99 / 100 ]` | 🟢 `[ 88 / 96 / 100 ]` |
| **JS (`dart2js` / Node 24 / V8)** | **`New Dart + Codable`** | 🟡 `[ 57 / 89 / 100 ]` | 🟢 `[ 100 / 100 / 100 ]` |
| **WASM (`dart2wasm` / Node 24 / V8)** | **`New Dart + Codable`** | 🟢 `[ 83 / 92 / 100 ]` | 🟢 `[ 100 / 100 / 100 ]` |
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
| **10k Coordinates (0.39 MB)** | 4.91 ms | **2.67 ms** | **1.84x** |
| **canada.json (2.25 MB)** | 40.84 ms | **23.47 ms** | **1.74x** |
| **citm_catalog.json (1.73 MB)** | 8.86 ms | **4.62 ms** | **1.92x** |
| **small.json (0.55 KB)** | 2.8 µs | **3.0 µs** | **0.93x** |
| **twitter.json (0.62 MB)** | 3.67 ms | **3.51 ms** | **1.04x** |
<!-- mdformat on -->


#### Detailed Breakdown: AOT Encode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | json_serializable | package:codable | Speedup vs json_serializable |
| :--- | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 4.78 ms | **2.89 ms** | **1.66x** |
| **canada.json (2.25 MB)** | 30.55 ms | **33.13 ms** | **0.92x** |
| **citm_catalog.json (1.73 MB)** | 6.08 ms | **2.61 ms** | **2.33x** |
| **small.json (0.55 KB)** | 5.0 µs | **5.7 µs** | **0.88x** |
| **twitter.json (0.62 MB)** | 3.04 ms | **1.76 ms** | **1.73x** |
<!-- mdformat on -->


------------------------------------------------------------------------

### 🎯 JS Target Detailed Breakdown

#### Detailed Breakdown: JS Decode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | json_serializable | package:codable | Speedup vs json_serializable |
| :--- | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 4.99 ms | **2.56 ms** | **1.95x** |
| **canada.json (2.25 MB)** | 42.48 ms | **25.06 ms** | **1.70x** |
| **citm_catalog.json (1.73 MB)** | 10.79 ms | **6.78 ms** | **1.59x** |
| **small.json (0.55 KB)** | 5.4 µs | **9.5 µs** | **0.57x** |
| **twitter.json (0.62 MB)** | 4.08 ms | **3.23 ms** | **1.27x** |
<!-- mdformat on -->


#### Detailed Breakdown: JS Encode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | json_serializable | package:codable | Speedup vs json_serializable |
| :--- | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 14.45 ms | **2.60 ms** | **5.56x** |
| **canada.json (2.25 MB)** | 37.95 ms | **27.36 ms** | **1.39x** |
| **citm_catalog.json (1.73 MB)** | 13.92 ms | **5.40 ms** | **2.58x** |
| **small.json (0.55 KB)** | 18.1 µs | **3.4 µs** | **5.31x** |
| **twitter.json (0.62 MB)** | 4.73 ms | **3.55 ms** | **1.33x** |
<!-- mdformat on -->


------------------------------------------------------------------------

### 🎯 WASM Target Detailed Breakdown

#### Detailed Breakdown: WASM Decode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | json_serializable | package:codable | Speedup vs json_serializable |
| :--- | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 4.34 ms | **4.52 ms** | **0.96x** |
| **canada.json (2.25 MB)** | 56.91 ms | **19.17 ms** | **2.97x** |
| **citm_catalog.json (1.73 MB)** | 6.69 ms | **7.24 ms** | **0.92x** |
| **small.json (0.55 KB)** | 3.8 µs | **4.6 µs** | **0.83x** |
| **twitter.json (0.62 MB)** | 3.71 ms | **4.15 ms** | **0.90x** |
<!-- mdformat on -->


#### Detailed Breakdown: WASM Encode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | json_serializable | package:codable | Speedup vs json_serializable |
| :--- | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 4.84 ms | **3.39 ms** | **1.43x** |
| **canada.json (2.25 MB)** | 39.38 ms | **25.82 ms** | **1.52x** |
| **citm_catalog.json (1.73 MB)** | 5.64 ms | **5.23 ms** | **1.08x** |
| **small.json (0.55 KB)** | 6.0 µs | **3.6 µs** | **1.66x** |
| **twitter.json (0.62 MB)** | 3.48 ms | **3.47 ms** | **1.00x** |
<!-- mdformat on -->


------------------------------------------------------------------------
