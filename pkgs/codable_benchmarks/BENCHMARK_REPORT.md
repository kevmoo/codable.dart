### 📝 Provenance

- **Run Timestamp**: 2026-09-12T05:59:33.435Z
- **SDK Version**: 3.14.0-edge.2c131e2363143936d92729b18d962e498c772a4d (main) (Fri Sep 11 18:19:58 2026 -0700) on "linux_x64"
- **Repo Commit**: b52902aea52aa2a5bea1e0f37f58d1c002889cb3
- **Host OS**: linux, Hostname: kevmoo.c.googlers.com
- **Trials**: 10

### 📊 3-Runtime Summary (Relative Efficiency Index)

<!-- mdformat off(prevent table wrapping) -->
| Target Runtime | Dart Configuration | 📥 Decode Efficiency<br/>[ Worst / GeoMean / Best ] | 📤 Encode Efficiency<br/>[ Worst / GeoMean / Best ] |
| :--- | :--- | :---: | :---: |
| **AOT (`dart compile exe`)** | **`New Dart + Codable`** | 🟢 `[ 92 / 98 / 100 ]` | 🟢 `[ 83 / 95 / 100 ]` |
| **JS (`dart2js` / Node 24 / V8)** | **`New Dart + Codable`** | 🟢 `[ 67 / 92 / 100 ]` | 🟢 `[ 100 / 100 / 100 ]` |
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
| **10k Coordinates (0.39 MB)** | 3.69 ms | **2.69 ms** | **1.37x** |
| **canada.json (2.25 MB)** | 37.91 ms | **12.02 ms** | **3.15x** |
| **citm_catalog.json (1.73 MB)** | 7.67 ms | **4.77 ms** | **1.61x** |
| **small.json (0.55 KB)** | 2.9 µs | **3.1 µs** | **0.92x** |
| **twitter.json (0.62 MB)** | 3.33 ms | **3.27 ms** | **1.02x** |
<!-- mdformat on -->


#### Detailed Breakdown: AOT Encode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | json_serializable | package:codable | Speedup vs json_serializable |
| :--- | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 4.82 ms | **2.73 ms** | **1.76x** |
| **canada.json (2.25 MB)** | 26.60 ms | **27.93 ms** | **0.95x** |
| **citm_catalog.json (1.73 MB)** | 6.68 ms | **3.19 ms** | **2.09x** |
| **small.json (0.55 KB)** | 5.0 µs | **6.0 µs** | **0.83x** |
| **twitter.json (0.62 MB)** | 3.41 ms | **1.98 ms** | **1.72x** |
<!-- mdformat on -->


------------------------------------------------------------------------

### 🎯 JS Target Detailed Breakdown

#### Detailed Breakdown: JS Decode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | json_serializable | package:codable | Speedup vs json_serializable |
| :--- | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 4.23 ms | **2.67 ms** | **1.58x** |
| **canada.json (2.25 MB)** | 35.00 ms | **14.33 ms** | **2.44x** |
| **citm_catalog.json (1.73 MB)** | 9.67 ms | **5.86 ms** | **1.65x** |
| **small.json (0.55 KB)** | 4.9 µs | **7.3 µs** | **0.67x** |
| **twitter.json (0.62 MB)** | 3.65 ms | **3.14 ms** | **1.16x** |
<!-- mdformat on -->


#### Detailed Breakdown: JS Encode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | json_serializable | package:codable | Speedup vs json_serializable |
| :--- | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 9.90 ms | **2.63 ms** | **3.76x** |
| **canada.json (2.25 MB)** | 35.67 ms | **22.67 ms** | **1.57x** |
| **citm_catalog.json (1.73 MB)** | 9.00 ms | **4.35 ms** | **2.07x** |
| **small.json (0.55 KB)** | 21.5 µs | **3.3 µs** | **6.46x** |
| **twitter.json (0.62 MB)** | 3.52 ms | **3.12 ms** | **1.13x** |
<!-- mdformat on -->


------------------------------------------------------------------------

### 🎯 WASM Target Detailed Breakdown

#### Detailed Breakdown: WASM Decode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | json_serializable | package:codable | Speedup vs json_serializable |
| :--- | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 4.10 ms | **3.41 ms** | **1.20x** |
| **canada.json (2.25 MB)** | 57.53 ms | **15.31 ms** | **3.76x** |
| **citm_catalog.json (1.73 MB)** | 6.23 ms | **5.78 ms** | **1.08x** |
| **small.json (0.55 KB)** | 3.5 µs | **3.7 µs** | **0.94x** |
| **twitter.json (0.62 MB)** | 3.26 ms | **3.54 ms** | **0.92x** |
<!-- mdformat on -->


#### Detailed Breakdown: WASM Encode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | json_serializable | package:codable | Speedup vs json_serializable |
| :--- | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 5.09 ms | **3.52 ms** | **1.45x** |
| **canada.json (2.25 MB)** | 40.27 ms | **26.18 ms** | **1.54x** |
| **citm_catalog.json (1.73 MB)** | 6.30 ms | **5.54 ms** | **1.14x** |
| **small.json (0.55 KB)** | 6.0 µs | **4.1 µs** | **1.44x** |
| **twitter.json (0.62 MB)** | 3.52 ms | **3.53 ms** | **1.00x** |
<!-- mdformat on -->


------------------------------------------------------------------------

