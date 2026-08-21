### 📊 Summary of AOT Benchmark Results

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Old Dart + json_serial | New Dart + json_serial | New Dart + Codable | Speedup vs Old Dart | Speedup vs New json_serial |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 3.87 ms | 3.74 ms | **2.84 ms** | **1.36x** | **1.32x** |
| **canada.json (2.25 MB)** | 34.75 ms | 28.19 ms | **12.04 ms** | **2.89x** | **2.34x** |
| **citm_catalog.json (1.73 MB)** | 5.81 ms | 5.84 ms | **4.64 ms** | **1.25x** | **1.26x** |
| **small.json (0.55 KB)** | 0.00 ms | 0.00 ms | **0.01 ms** | **0.80x** | **0.60x** |
| **twitter.json (0.62 MB)** | 2.86 ms | 2.83 ms | **4.70 ms** | **0.61x** | **0.60x** |
<!-- mdformat on -->


### 📊 Summary of JS Benchmark Results

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Old Dart + json_serial | New Dart + json_serial | New Dart + Codable | Speedup vs Old Dart | Speedup vs New json_serial |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 4.24 ms | 20.06 ms | **5.98 ms** | **0.71x** | **3.36x** |
| **canada.json (2.25 MB)** | 36.92 ms | 99.40 ms | **36.48 ms** | **1.01x** | **2.72x** |
| **citm_catalog.json (1.73 MB)** | 9.72 ms | 29.10 ms | **11.82 ms** | **0.82x** | **2.46x** |
| **small.json (0.55 KB)** | 0.02 ms | 0.04 ms | **0.02 ms** | **1.00x** | **2.00x** |
| **twitter.json (0.62 MB)** | 3.92 ms | 13.56 ms | **5.68 ms** | **0.69x** | **2.39x** |
<!-- mdformat on -->


### 📊 Summary of WASM Benchmark Results

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Old Dart + json_serial | New Dart + json_serial | New Dart + Codable | Speedup vs Old Dart | Speedup vs New json_serial |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 3.59 ms | 3.83 ms | **7.27 ms** | **0.49x** | **0.53x** |
| **canada.json (2.25 MB)** | 39.74 ms | 38.75 ms | **42.81 ms** | **0.93x** | **0.91x** |
| **citm_catalog.json (1.73 MB)** | 5.82 ms | 6.05 ms | **19.73 ms** | **0.29x** | **0.31x** |
| **small.json (0.55 KB)** | 0.00 ms | 0.00 ms | **0.01 ms** | **0.57x** | **0.57x** |
| **twitter.json (0.62 MB)** | 3.23 ms | 3.12 ms | **10.01 ms** | **0.32x** | **0.31x** |
<!-- mdformat on -->
