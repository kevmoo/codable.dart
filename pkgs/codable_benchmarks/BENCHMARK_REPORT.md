### 📊 3-Runtime Summary (Relative Efficiency Index)

<!-- mdformat off(prevent table wrapping) -->
| Target Runtime | Dart Configuration | 📥 Decode Efficiency<br/>[ Worst / GeoMean / Best ] | 📤 Encode Efficiency<br/>[ Worst / GeoMean / Best ] |
| :--- | :--- | :---: | :---: |
| **AOT (`dart compile exe`)** | **`New Dart + Codable`** | 🟢 `[ 93 / 99 / 100 ]` | 🟢 `[ 82 / 95 / 100 ]` |
| **JS (`dart2js` / Node 24 / V8)** | **`New Dart + Codable`** | 🟢 `[ 66 / 92 / 100 ]` | 🟢 `[ 100 / 100 / 100 ]` |
| **WASM (`dart2wasm` / Node 24 / V8)** | **`New Dart + Codable`** | 🟢 `[ 92 / 97 / 100 ]` | 🟢 `[ 100 / 100 / 100 ]` |
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
| **10k Coordinates (0.39 MB)** | 3.75 ms | **2.62 ms** | **1.43x** |
| **canada.json (2.25 MB)** | 37.30 ms | **12.05 ms** | **3.10x** |
| **citm_catalog.json (1.73 MB)** | 7.61 ms | **4.73 ms** | **1.61x** |
| **small.json (0.55 KB)** | 2.8 µs | **3.0 µs** | **0.93x** |
| **twitter.json (0.62 MB)** | 3.12 ms | **3.13 ms** | **1.00x** |
<!-- mdformat on -->


#### Detailed Breakdown: AOT Encode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | json_serializable | package:codable | Speedup vs json_serializable |
| :--- | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 4.81 ms | **3.04 ms** | **1.58x** |
| **canada.json (2.25 MB)** | 26.80 ms | **28.11 ms** | **0.95x** |
| **citm_catalog.json (1.73 MB)** | 6.51 ms | **3.42 ms** | **1.90x** |
| **small.json (0.55 KB)** | 5.0 µs | **6.1 µs** | **0.82x** |
| **twitter.json (0.62 MB)** | 3.35 ms | **2.02 ms** | **1.66x** |
<!-- mdformat on -->


------------------------------------------------------------------------

### 🎯 JS Target Detailed Breakdown

#### Detailed Breakdown: JS Decode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | json_serializable | package:codable | Speedup vs json_serializable |
| :--- | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 4.82 ms | **2.70 ms** | **1.78x** |
| **canada.json (2.25 MB)** | 36.12 ms | **14.98 ms** | **2.41x** |
| **citm_catalog.json (1.73 MB)** | 9.36 ms | **6.17 ms** | **1.52x** |
| **small.json (0.55 KB)** | 5.0 µs | **7.5 µs** | **0.66x** |
| **twitter.json (0.62 MB)** | 3.81 ms | **3.06 ms** | **1.24x** |
<!-- mdformat on -->


#### Detailed Breakdown: JS Encode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | json_serializable | package:codable | Speedup vs json_serializable |
| :--- | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 8.35 ms | **2.60 ms** | **3.22x** |
| **canada.json (2.25 MB)** | 35.23 ms | **21.85 ms** | **1.61x** |
| **citm_catalog.json (1.73 MB)** | 8.84 ms | **4.22 ms** | **2.10x** |
| **small.json (0.55 KB)** | 20.8 µs | **2.9 µs** | **7.22x** |
| **twitter.json (0.62 MB)** | 3.62 ms | **3.06 ms** | **1.18x** |
<!-- mdformat on -->


------------------------------------------------------------------------

### 🎯 WASM Target Detailed Breakdown

#### Detailed Breakdown: WASM Decode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | json_serializable | package:codable | Speedup vs json_serializable |
| :--- | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 4.03 ms | **3.24 ms** | **1.25x** |
| **canada.json (2.25 MB)** | 56.06 ms | **14.51 ms** | **3.86x** |
| **citm_catalog.json (1.73 MB)** | 6.19 ms | **5.51 ms** | **1.12x** |
| **small.json (0.55 KB)** | 3.4 µs | **3.7 µs** | **0.92x** |
| **twitter.json (0.62 MB)** | 3.11 ms | **3.38 ms** | **0.92x** |
<!-- mdformat on -->


#### Detailed Breakdown: WASM Encode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | json_serializable | package:codable | Speedup vs json_serializable |
| :--- | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 5.42 ms | **3.38 ms** | **1.60x** |
| **canada.json (2.25 MB)** | 43.87 ms | **25.36 ms** | **1.73x** |
| **citm_catalog.json (1.73 MB)** | 6.23 ms | **5.27 ms** | **1.18x** |
| **small.json (0.55 KB)** | 6.0 µs | **3.5 µs** | **1.71x** |
| **twitter.json (0.62 MB)** | 3.62 ms | **3.29 ms** | **1.10x** |
<!-- mdformat on -->


------------------------------------------------------------------------

