### 📊 Summary of WASM Decode Benchmark Results

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Old Dart + json_serial | New Dart + json_serial | New Dart + Codable | Speedup vs Old Dart | Speedup vs New json_serial |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 3.81 ms | 8.68 ms | **8.25 ms** | **0.46x** | **1.05x** |
| **canada.json (2.25 MB)** | 39.23 ms | 55.36 ms | **42.55 ms** | **0.92x** | **1.30x** |
| **citm_catalog.json (1.73 MB)** | 5.76 ms | 12.50 ms | **21.91 ms** | **0.26x** | **0.57x** |
| **small.json (0.55 KB)** | 0.00 ms | 0.01 ms | **0.01 ms** | **0.57x** | **1.14x** |
| **twitter.json (0.62 MB)** | 3.13 ms | 6.66 ms | **9.38 ms** | **0.33x** | **0.71x** |
<!-- mdformat on -->

### 📊 Summary of WASM Encode Benchmark Results

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Old Dart + json_serial | New Dart + json_serial | New Dart + Codable | Speedup vs Old Dart | Speedup vs New json_serial |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 10.63 ms | 5.41 ms | **11.53 ms** | **0.92x** | **0.47x** |
| **canada.json (2.25 MB)** | 51.39 ms | 43.42 ms | **67.41 ms** | **0.76x** | **0.64x** |
| **citm_catalog.json (1.73 MB)** | 9.73 ms | 6.83 ms | **11.50 ms** | **0.85x** | **0.59x** |
| **small.json (0.55 KB)** | 0.01 ms | 0.02 ms | **0.01 ms** | **1.00x** | **2.67x** |
| **twitter.json (0.62 MB)** | 6.12 ms | 4.01 ms | **6.65 ms** | **0.92x** | **0.60x** |
<!-- mdformat on -->
