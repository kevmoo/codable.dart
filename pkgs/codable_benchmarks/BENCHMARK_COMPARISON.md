### 📊 Summary of AOT Benchmark Results

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Old Dart + json_serial | New Dart + json_serial | New Dart + Codable | Speedup vs Old Dart | Speedup vs New json_serial |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 3.89 ms | 3.80 ms | **2.41 ms** | **1.61x** | **1.58x** |
| **canada.json (2.25 MB)** | 34.02 ms | 26.86 ms | **11.49 ms** | **2.96x** | **2.34x** |
| **citm_catalog.json (1.73 MB)** | 5.77 ms | 6.36 ms | **3.70 ms** | **1.56x** | **1.72x** |
| **small.json (0.55 KB)** | 0.01 ms | 0.00 ms | **0.00 ms** | **1.67x** | **1.00x** |
| **twitter.json (0.62 MB)** | 3.12 ms | 3.06 ms | **4.76 ms** | **0.65x** | **0.64x** |
<!-- mdformat on -->


### 📊 Summary of JS Benchmark Results

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Old Dart + json_serial | New Dart + json_serial | New Dart + Codable | Speedup vs Old Dart | Speedup vs New json_serial |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 4.08 ms | 19.48 ms | **2.18 ms** | **1.87x** | **8.94x** |
| **canada.json (2.25 MB)** | 30.38 ms | 100.28 ms | **21.20 ms** | **1.43x** | **4.73x** |
| **citm_catalog.json (1.73 MB)** | 8.64 ms | 27.26 ms | **4.80 ms** | **1.80x** | **5.68x** |
| **small.json (0.55 KB)** | 0.02 ms | 0.04 ms | **0.02 ms** | **1.00x** | **2.00x** |
| **twitter.json (0.62 MB)** | 3.80 ms | 13.86 ms | **5.28 ms** | **0.72x** | **2.62x** |
<!-- mdformat on -->


### 📊 Summary of WASM Benchmark Results

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Old Dart + json_serial | New Dart + json_serial | New Dart + Codable | Speedup vs Old Dart | Speedup vs New json_serial |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 3.53 ms | 3.58 ms | **4.52 ms** | **0.78x** | **0.79x** |
| **canada.json (2.25 MB)** | 38.61 ms | 37.91 ms | **13.26 ms** | **2.91x** | **2.86x** |
| **citm_catalog.json (1.73 MB)** | 5.85 ms | 6.32 ms | **6.60 ms** | **0.89x** | **0.96x** |
| **small.json (0.55 KB)** | 0.00 ms | 0.00 ms | **0.00 ms** | **1.00x** | **1.00x** |
| **twitter.json (0.62 MB)** | 3.06 ms | 3.09 ms | **6.41 ms** | **0.48x** | **0.48x** |
<!-- mdformat on -->
