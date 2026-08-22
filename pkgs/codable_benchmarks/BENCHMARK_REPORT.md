### 📊 Summary of WASM Decode Benchmark Results

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Old Dart + json_serial | New Dart + json_serial | New Dart + Codable | Speedup vs Old Dart | Speedup vs New json_serial |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 3.37 ms | 3.38 ms | **6.82 ms** | **0.50x** | **0.50x** |
| **canada.json (2.25 MB)** | 36.20 ms | 34.71 ms | **39.11 ms** | **0.93x** | **0.89x** |
| **citm_catalog.json (1.73 MB)** | 5.41 ms | 5.32 ms | **19.70 ms** | **0.27x** | **0.27x** |
| **small.json (0.55 KB)** | 0.00 ms | 0.00 ms | **0.01 ms** | **0.43x** | **0.43x** |
| **twitter.json (0.62 MB)** | 3.00 ms | 2.97 ms | **8.86 ms** | **0.34x** | **0.34x** |
<!-- mdformat on -->

### 📊 Summary of WASM Encode Benchmark Results

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Old Dart + json_serial | New Dart + json_serial | New Dart + Codable | Speedup vs Old Dart | Speedup vs New json_serial |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 9.97 ms | 4.64 ms | **10.92 ms** | **0.91x** | **0.42x** |
| **canada.json (2.25 MB)** | 47.50 ms | 39.83 ms | **68.01 ms** | **0.70x** | **0.59x** |
| **citm_catalog.json (1.73 MB)** | 8.48 ms | 5.75 ms | **9.92 ms** | **0.86x** | **0.58x** |
| **small.json (0.55 KB)** | 0.01 ms | 0.01 ms | **0.01 ms** | **0.83x** | **0.83x** |
| **twitter.json (0.62 MB)** | 5.24 ms | 3.44 ms | **5.97 ms** | **0.88x** | **0.58x** |
<!-- mdformat on -->

### 📊 Summary of JS Decode Benchmark Results

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Old Dart + json_serial | New Dart + json_serial | New Dart + Codable | Speedup vs Old Dart | Speedup vs New json_serial |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 4.00 ms | 20.00 ms | **7.00 ms** | **0.57x** | **2.86x** |
| **canada.json (2.25 MB)** | 31.50 ms | 96.50 ms | **32.00 ms** | **0.98x** | **3.02x** |
| **citm_catalog.json (1.73 MB)** | 8.00 ms | 25.00 ms | **13.00 ms** | **0.62x** | **1.92x** |
| **small.json (0.55 KB)** | 0.00 ms | 0.01 ms | **0.01 ms** | **0.67x** | **2.50x** |
| **twitter.json (0.62 MB)** | 3.50 ms | 12.00 ms | **5.00 ms** | **0.70x** | **2.40x** |
<!-- mdformat on -->

### 📊 Summary of JS Encode Benchmark Results

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Old Dart + json_serial | New Dart + json_serial | New Dart + Codable | Speedup vs Old Dart | Speedup vs New json_serial |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 9.00 ms | 7.50 ms | **4.50 ms** | **2.00x** | **1.67x** |
| **canada.json (2.25 MB)** | 32.00 ms | 32.00 ms | **28.00 ms** | **1.14x** | **1.14x** |
| **citm_catalog.json (1.73 MB)** | 11.00 ms | 9.00 ms | **6.00 ms** | **1.83x** | **1.50x** |
| **small.json (0.55 KB)** | 0.01 ms | 0.01 ms | **0.01 ms** | **1.80x** | **2.20x** |
| **twitter.json (0.62 MB)** | 5.75 ms | 3.50 ms | **4.00 ms** | **1.44x** | **0.88x** |
<!-- mdformat on -->

### 📊 Summary of AOT Decode Benchmark Results

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Old Dart + json_serial | New Dart + json_serial | New Dart + Codable | Speedup vs Old Dart | Speedup vs New json_serial |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 4.20 ms | 3.68 ms | **4.84 ms** | **0.87x** | **0.76x** |
| **canada.json (2.25 MB)** | 40.39 ms | 31.08 ms | **31.33 ms** | **1.29x** | **0.99x** |
| **citm_catalog.json (1.73 MB)** | 6.10 ms | 5.91 ms | **7.83 ms** | **0.78x** | **0.75x** |
| **small.json (0.55 KB)** | 0.00 ms | 0.00 ms | **0.01 ms** | **0.60x** | **0.60x** |
| **twitter.json (0.62 MB)** | 2.74 ms | 2.88 ms | **4.86 ms** | **0.56x** | **0.59x** |
<!-- mdformat on -->

### 📊 Summary of AOT Encode Benchmark Results

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Old Dart + json_serial | New Dart + json_serial | New Dart + Codable | Speedup vs Old Dart | Speedup vs New json_serial |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 9.20 ms | 4.04 ms | **5.46 ms** | **1.68x** | **0.74x** |
| **canada.json (2.25 MB)** | 44.09 ms | 30.72 ms | **38.78 ms** | **1.14x** | **0.79x** |
| **citm_catalog.json (1.73 MB)** | 7.73 ms | 5.49 ms | **6.35 ms** | **1.22x** | **0.86x** |
| **small.json (0.55 KB)** | 0.01 ms | 0.00 ms | **0.00 ms** | **1.25x** | **1.00x** |
| **twitter.json (0.62 MB)** | 5.00 ms | 3.16 ms | **3.38 ms** | **1.48x** | **0.93x** |
<!-- mdformat on -->
