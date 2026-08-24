### 📊 Summary of WASM Decode Benchmark Results

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Old Dart + json_serial | New Dart + json_serial | New Dart + Codable | Speedup vs Old Dart | Speedup vs New json_serial |
| :--- | :---: | :---: | :---: | :---: | :---: |
<!-- mdformat on -->

### 📊 Summary of WASM Encode Benchmark Results

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Old Dart + json_serial | New Dart + json_serial | New Dart + Codable | Speedup vs Old Dart | Speedup vs New json_serial |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 9.80 ms | 4.72 ms | **6.28 ms** | **1.56x** | **0.75x** |
| **canada.json (2.25 MB)** | 53.13 ms | 41.55 ms | **39.76 ms** | **1.34x** | **1.05x** |
| **citm_catalog.json (1.73 MB)** | 8.83 ms | 5.77 ms | **8.75 ms** | **1.01x** | **0.66x** |
| **small.json (0.55 KB)** | 0.01 ms | 0.01 ms | **0.00 ms** | **1.25x** | **1.25x** |
| **twitter.json (0.62 MB)** | 5.39 ms | 3.53 ms | **5.62 ms** | **0.96x** | **0.63x** |
<!-- mdformat on -->

### 📊 Summary of JS Decode Benchmark Results

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Old Dart + json_serial | New Dart + json_serial | New Dart + Codable | Speedup vs Old Dart | Speedup vs New json_serial |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 4.00 ms | 16.00 ms | **7.00 ms** | **0.57x** | **2.29x** |
| **canada.json (2.25 MB)** | 32.50 ms | 104.00 ms | **34.50 ms** | **0.94x** | **3.01x** |
| **citm_catalog.json (1.73 MB)** | 8.00 ms | 19.50 ms | **13.50 ms** | **0.59x** | **1.44x** |
| **small.json (0.55 KB)** | 0.00 ms | 0.02 ms | **0.01 ms** | **0.67x** | **2.83x** |
| **twitter.json (0.62 MB)** | 3.50 ms | 13.00 ms | **5.00 ms** | **0.70x** | **2.60x** |
<!-- mdformat on -->

### 📊 Summary of JS Encode Benchmark Results

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Old Dart + json_serial | New Dart + json_serial | New Dart + Codable | Speedup vs Old Dart | Speedup vs New json_serial |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 9.00 ms | 7.50 ms | **4.50 ms** | **2.00x** | **1.67x** |
| **canada.json (2.25 MB)** | 35.00 ms | 33.50 ms | **31.00 ms** | **1.13x** | **1.08x** |
| **citm_catalog.json (1.73 MB)** | 11.00 ms | 9.00 ms | **6.00 ms** | **1.83x** | **1.50x** |
| **small.json (0.55 KB)** | 0.01 ms | 0.01 ms | **0.01 ms** | **2.00x** | **2.40x** |
| **twitter.json (0.62 MB)** | 6.00 ms | 3.67 ms | **4.00 ms** | **1.50x** | **0.92x** |
<!-- mdformat on -->

### 📊 Summary of AOT Decode Benchmark Results

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Old Dart + json_serial | New Dart + json_serial | New Dart + Codable | Speedup vs Old Dart | Speedup vs New json_serial |
| :--- | :---: | :---: | :---: | :---: | :---: |
<!-- mdformat on -->

### 📊 Summary of AOT Encode Benchmark Results

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Old Dart + json_serial | New Dart + json_serial | New Dart + Codable | Speedup vs Old Dart | Speedup vs New json_serial |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 9.72 ms | 4.38 ms | **5.28 ms** | **1.84x** | **0.83x** |
| **canada.json (2.25 MB)** | 45.86 ms | 32.02 ms | **42.18 ms** | **1.09x** | **0.76x** |
| **citm_catalog.json (1.73 MB)** | 8.90 ms | 5.56 ms | **5.69 ms** | **1.56x** | **0.98x** |
| **small.json (0.55 KB)** | 0.01 ms | 0.00 ms | **0.00 ms** | **1.25x** | **1.00x** |
| **twitter.json (0.62 MB)** | 5.46 ms | 2.91 ms | **2.70 ms** | **2.02x** | **1.08x** |
<!-- mdformat on -->
