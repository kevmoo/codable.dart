### 📝 Provenance

- **Run Timestamp**: 2026-09-12T06:32:19.109Z
- **SDK Version**: 3.14.0-edge.2c131e2363143936d92729b18d962e498c772a4d (main) (Fri Sep 11 18:19:58 2026 -0700) on "linux_x64"
- **Repo Commit**: ecb75b0dd3594f9cd9b5cf2d0b081efdb684bfb8
- **Host OS**: linux, Hostname: kevmoo.c.googlers.com
- **Trials**: 10

### 📊 3-Runtime Summary (Relative Efficiency Index)

<!-- mdformat off(prevent table wrapping) -->
| Target Runtime | Dart Configuration | 📥 Decode Efficiency<br/>[ Worst / GeoMean / Best ] | 📤 Encode Efficiency<br/>[ Worst / GeoMean / Best ] |
| :--- | :--- | :---: | :---: |
| **AOT (`dart compile exe`)** | **`New Dart + Codable`** | 🟢 `[ 89 / 97 / 100 ]` | 🟢 `[ 90 / 98 / 100 ]` |
| **JS (`dart2js` / Node 24 / V8)** | **`New Dart + Codable`** | 🟢 `[ 100 / 100 / 100 ]` | 🟢 `[ 100 / 100 / 100 ]` |
| **WASM (`dart2wasm` / Node 24 / V8)** | **`New Dart + Codable`** | 🟢 `[ 93 / 99 / 100 ]` | 🟢 `[ 99 / 100 / 100 ]` |
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
| **10k Coordinates (0.39 MB)** | 3.97 ms | **2.54 ms** | **1.56x** |
| **canada.json (2.25 MB)** | 38.13 ms | **11.48 ms** | **3.32x** |
| **citm_catalog.json (1.73 MB)** | 7.31 ms | **4.59 ms** | **1.59x** |
| **small.json (0.55 KB)** | 2.8 µs | **3.1 µs** | **0.89x** |
| **twitter.json (0.62 MB)** | 3.01 ms | **3.14 ms** | **0.96x** |
<!-- mdformat on -->


#### Detailed Breakdown: AOT Encode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | json_serializable | package:codable | Speedup vs json_serializable |
| :--- | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 4.94 ms | **2.63 ms** | **1.88x** |
| **canada.json (2.25 MB)** | 26.58 ms | **26.86 ms** | **0.99x** |
| **citm_catalog.json (1.73 MB)** | 6.32 ms | **3.09 ms** | **2.05x** |
| **small.json (0.55 KB)** | 5.1 µs | **5.7 µs** | **0.90x** |
| **twitter.json (0.62 MB)** | 3.26 ms | **1.86 ms** | **1.76x** |
<!-- mdformat on -->


------------------------------------------------------------------------

### 🎯 JS Target Detailed Breakdown

#### Detailed Breakdown: JS Decode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | json_serializable | package:codable | Speedup vs json_serializable |
| :--- | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 4.36 ms | **2.55 ms** | **1.71x** |
| **canada.json (2.25 MB)** | 36.13 ms | **15.00 ms** | **2.41x** |
| **citm_catalog.json (1.73 MB)** | 9.19 ms | **5.82 ms** | **1.58x** |
| **small.json (0.55 KB)** | 4.8 µs | **3.6 µs** | **1.34x** |
| **twitter.json (0.62 MB)** | 3.70 ms | **3.00 ms** | **1.23x** |
<!-- mdformat on -->


#### Detailed Breakdown: JS Encode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | json_serializable | package:codable | Speedup vs json_serializable |
| :--- | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 8.00 ms | **2.55 ms** | **3.14x** |
| **canada.json (2.25 MB)** | 33.00 ms | **20.13 ms** | **1.64x** |
| **citm_catalog.json (1.73 MB)** | 8.67 ms | **4.28 ms** | **2.03x** |
| **small.json (0.55 KB)** | 21.1 µs | **2.7 µs** | **7.78x** |
| **twitter.json (0.62 MB)** | 3.55 ms | **3.11 ms** | **1.14x** |
<!-- mdformat on -->


------------------------------------------------------------------------

### 🎯 WASM Target Detailed Breakdown

#### Detailed Breakdown: WASM Decode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | json_serializable | package:codable | Speedup vs json_serializable |
| :--- | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 4.03 ms | **3.70 ms** | **1.09x** |
| **canada.json (2.25 MB)** | 55.45 ms | **14.21 ms** | **3.90x** |
| **citm_catalog.json (1.73 MB)** | 6.23 ms | **5.66 ms** | **1.10x** |
| **small.json (0.55 KB)** | 3.7 µs | **3.6 µs** | **1.02x** |
| **twitter.json (0.62 MB)** | 3.10 ms | **3.34 ms** | **0.93x** |
<!-- mdformat on -->


#### Detailed Breakdown: WASM Encode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | json_serializable | package:codable | Speedup vs json_serializable |
| :--- | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 5.10 ms | **3.50 ms** | **1.46x** |
| **canada.json (2.25 MB)** | 42.96 ms | **25.45 ms** | **1.69x** |
| **citm_catalog.json (1.73 MB)** | 6.16 ms | **5.53 ms** | **1.11x** |
| **small.json (0.55 KB)** | 5.8 µs | **3.5 µs** | **1.68x** |
| **twitter.json (0.62 MB)** | 3.43 ms | **3.45 ms** | **0.99x** |
<!-- mdformat on -->


------------------------------------------------------------------------

