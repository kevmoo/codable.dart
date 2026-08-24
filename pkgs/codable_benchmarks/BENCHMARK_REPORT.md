### 📊 Summary of WASM Decode Benchmark Results

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Old Dart + json_serial | New Dart + json_serial | New Dart + Codable | Speedup vs Old Dart | Speedup vs New json_serial |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 3.37 ms | 3.41 ms | **7.99 ms** | **0.42x** | **0.43x** |
| **canada.json (2.25 MB)** | 39.35 ms | 40.15 ms | **45.27 ms** | **0.87x** | **0.89x** |
| **citm_catalog.json (1.73 MB)** | 5.87 ms | 6.71 ms | **23.39 ms** | **0.25x** | **0.29x** |
| **small.json (0.55 KB)** | 0.00 ms | 0.00 ms | **0.01 ms** | **0.43x** | **0.43x** |
| **twitter.json (0.62 MB)** | 3.06 ms | 3.11 ms | **8.87 ms** | **0.34x** | **0.35x** |
<!-- mdformat on -->

### 📊 Summary of WASM Encode Benchmark Results

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Old Dart + json_serial | New Dart + json_serial | New Dart + Codable | Speedup vs Old Dart | Speedup vs New json_serial |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 9.93 ms | 4.75 ms | **6.12 ms** | **1.62x** | **0.78x** |
| **canada.json (2.25 MB)** | 54.42 ms | 42.27 ms | **40.79 ms** | **1.33x** | **1.04x** |
| **citm_catalog.json (1.73 MB)** | 8.34 ms | 5.96 ms | **8.78 ms** | **0.95x** | **0.68x** |
| **small.json (0.55 KB)** | 0.01 ms | 0.01 ms | **0.00 ms** | **1.25x** | **1.25x** |
| **twitter.json (0.62 MB)** | 5.32 ms | 3.46 ms | **5.22 ms** | **1.02x** | **0.66x** |
<!-- mdformat on -->

### 📊 Summary of JS Decode Benchmark Results

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Old Dart + json_serial | New Dart + json_serial | New Dart + Codable | Speedup vs Old Dart | Speedup vs New json_serial |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 4.33 ms | 21.00 ms | **7.75 ms** | **0.56x** | **2.71x** |
| **canada.json (2.25 MB)** | 35.00 ms | 98.50 ms | **34.00 ms** | **1.03x** | **2.90x** |
| **citm_catalog.json (1.73 MB)** | 9.00 ms | 24.00 ms | **13.00 ms** | **0.69x** | **1.85x** |
| **small.json (0.55 KB)** | 0.00 ms | 0.01 ms | **0.01 ms** | **0.67x** | **2.50x** |
| **twitter.json (0.62 MB)** | 3.33 ms | 13.00 ms | **5.00 ms** | **0.67x** | **2.60x** |
<!-- mdformat on -->

### 📊 Summary of JS Encode Benchmark Results

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Old Dart + json_serial | New Dart + json_serial | New Dart + Codable | Speedup vs Old Dart | Speedup vs New json_serial |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 9.00 ms | 8.00 ms | **4.50 ms** | **2.00x** | **1.78x** |
| **canada.json (2.25 MB)** | 32.50 ms | 35.00 ms | **31.00 ms** | **1.05x** | **1.13x** |
| **citm_catalog.json (1.73 MB)** | 11.00 ms | 9.25 ms | **6.00 ms** | **1.83x** | **1.54x** |
| **small.json (0.55 KB)** | 0.01 ms | 0.01 ms | **0.01 ms** | **2.20x** | **2.60x** |
| **twitter.json (0.62 MB)** | 6.00 ms | 3.67 ms | **4.00 ms** | **1.50x** | **0.92x** |
<!-- mdformat on -->

### 📊 Summary of AOT Decode Benchmark Results

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Old Dart + json_serial | New Dart + json_serial | New Dart + Codable | Speedup vs Old Dart | Speedup vs New json_serial |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 3.85 ms | 3.67 ms | **2.48 ms** | **1.55x** | **1.48x** |
| **canada.json (2.25 MB)** | 44.25 ms | 32.26 ms | **16.36 ms** | **2.71x** | **1.97x** |
| **citm_catalog.json (1.73 MB)** | 6.20 ms | 5.84 ms | **4.40 ms** | **1.41x** | **1.33x** |
| **small.json (0.55 KB)** | 0.00 ms | 0.00 ms | **0.00 ms** | **1.00x** | **1.00x** |
| **twitter.json (0.62 MB)** | 2.90 ms | 2.86 ms | **4.82 ms** | **0.60x** | **0.59x** |
<!-- mdformat on -->

### 📊 Summary of AOT Encode Benchmark Results

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Old Dart + json_serial | New Dart + json_serial | New Dart + Codable | Speedup vs Old Dart | Speedup vs New json_serial |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 9.23 ms | 4.35 ms | **7.18 ms** | **1.29x** | **0.61x** |
| **canada.json (2.25 MB)** | 45.82 ms | 31.43 ms | **42.76 ms** | **1.07x** | **0.73x** |
| **citm_catalog.json (1.73 MB)** | 8.36 ms | 5.95 ms | **5.69 ms** | **1.47x** | **1.05x** |
| **small.json (0.55 KB)** | 0.01 ms | 0.00 ms | **0.00 ms** | **1.67x** | **1.33x** |
| **twitter.json (0.62 MB)** | 5.24 ms | 3.14 ms | **3.58 ms** | **1.46x** | **0.88x** |
<!-- mdformat on -->
