### 📊 3-Runtime Summary (Relative Efficiency Index)

<!-- mdformat off(prevent table wrapping) -->
| Target Runtime | Dart Configuration | 📥 Decode Efficiency<br/>[ Worst / GeoMean / Best ] | 📤 Encode Efficiency<br/>[ Worst / GeoMean / Best ] |
| :--- | :--- | :---: | :---: |
| **AOT (`dart compile exe`)** | **`New Dart + Codable`** | 🟢 `[ 85 / 96 / 100 ]` | 🟢 `[ 70 / 93 / 100 ]` |
| **JS (`dart2js` / Node 24 / V8)** | **`New Dart + Codable`** | 🟢 `[ 64 / 92 / 100 ]` | 🟢 `[ 100 / 100 / 100 ]` |
| **WASM (`dart2wasm` / Node 24 / V8)** | **`New Dart + Codable`** | 🟡 `[ 76 / 90 / 100 ]` | 🟢 `[ 100 / 100 / 100 ]` |
<!-- mdformat on -->

> **Scoring Metric**: **Relative Throughput Efficiency** (`100` = Peak Speed). Calculated as `round((MinLatency / Latency) * 100)` per workload, aggregated across benchmarks using the **Geometric Mean** (Fleming & Wallace 1986).
> - **`[ Worst / GeoMean / Best ]`**: Range from lowest score (worst workload) to the geometric mean and peak dataset score
>   across the 5 canonical benchmarks (`coordinates`, `canada`, `citm_catalog`, `small`, `twitter`).
> - **Badges**: 🥇 Peak across all workloads (`100`) • 🟢 `≥ 90` (Within 10% of peak) • 🟡 `70–89` (Good / moderate) • 🔴 `< 70` (Significant performance gap).

------------------------------------------------------------------------

### 🎯 AOT Target Detailed Breakdown

#### Detailed Breakdown: AOT Decode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | json_serializable | package:codable | Speedup vs json_serializable |
| :--- | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 4.02 ms | **2.55 ms** | **1.58x** |
| **canada.json (2.25 MB)** | 37.45 ms | **10.61 ms** | **3.53x** |
| **citm_catalog.json (1.73 MB)** | 8.36 ms | **4.75 ms** | **1.76x** |
| **small.json (0.55 KB)** | 2.9 µs | **3.1 µs** | **0.94x** |
| **twitter.json (0.62 MB)** | 3.38 ms | **3.98 ms** | **0.85x** |
<!-- mdformat on -->


#### Detailed Breakdown: AOT Encode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | json_serializable | package:codable | Speedup vs json_serializable |
| :--- | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 5.55 ms | **2.89 ms** | **1.92x** |
| **canada.json (2.25 MB)** | 44.06 ms | **28.79 ms** | **1.53x** |
| **citm_catalog.json (1.73 MB)** | 9.19 ms | **3.37 ms** | **2.73x** |
| **small.json (0.55 KB)** | 4.6 µs | **6.6 µs** | **0.70x** |
| **twitter.json (0.62 MB)** | 5.74 ms | **2.00 ms** | **2.87x** |
<!-- mdformat on -->


------------------------------------------------------------------------

### 🎯 JS Target Detailed Breakdown

#### Detailed Breakdown: JS Decode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | json_serializable | package:codable | Speedup vs json_serializable |
| :--- | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 4.45 ms | **2.71 ms** | **1.64x** |
| **canada.json (2.25 MB)** | 34.67 ms | **15.00 ms** | **2.31x** |
| **citm_catalog.json (1.73 MB)** | 9.60 ms | **6.00 ms** | **1.60x** |
| **small.json (0.55 KB)** | 4.9 µs | **7.6 µs** | **0.64x** |
| **twitter.json (0.62 MB)** | 3.85 ms | **3.24 ms** | **1.19x** |
<!-- mdformat on -->


#### Detailed Breakdown: JS Encode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | json_serializable | package:codable | Speedup vs json_serializable |
| :--- | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 10.88 ms | **2.70 ms** | **4.03x** |
| **canada.json (2.25 MB)** | 40.67 ms | **22.33 ms** | **1.82x** |
| **citm_catalog.json (1.73 MB)** | 9.14 ms | **4.09 ms** | **2.23x** |
| **small.json (0.55 KB)** | 22.6 µs | **2.5 µs** | **9.20x** |
| **twitter.json (0.62 MB)** | 3.73 ms | **3.24 ms** | **1.15x** |
<!-- mdformat on -->


------------------------------------------------------------------------

### 🎯 WASM Target Detailed Breakdown

#### Detailed Breakdown: WASM Decode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | json_serializable | package:codable | Speedup vs json_serializable |
| :--- | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 3.99 ms | **4.11 ms** | **0.97x** |
| **canada.json (2.25 MB)** | 56.85 ms | **14.15 ms** | **4.02x** |
| **citm_catalog.json (1.73 MB)** | 6.72 ms | **6.76 ms** | **0.99x** |
| **small.json (0.55 KB)** | 3.4 µs | **4.3 µs** | **0.79x** |
| **twitter.json (0.62 MB)** | 3.06 ms | **4.05 ms** | **0.76x** |
<!-- mdformat on -->


#### Detailed Breakdown: WASM Encode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | json_serializable | package:codable | Speedup vs json_serializable |
| :--- | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 5.31 ms | **3.66 ms** | **1.45x** |
| **canada.json (2.25 MB)** | 47.97 ms | **26.93 ms** | **1.78x** |
| **citm_catalog.json (1.73 MB)** | 7.07 ms | **6.10 ms** | **1.16x** |
| **small.json (0.55 KB)** | 7.0 µs | **3.4 µs** | **2.04x** |
| **twitter.json (0.62 MB)** | 3.91 ms | **3.89 ms** | **1.00x** |
<!-- mdformat on -->


------------------------------------------------------------------------

