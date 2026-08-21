### 📊 Summary of AOT Decode Benchmark Results

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Old Dart + json_serial | New Dart + json_serial | New Dart + Codable | Speedup vs Old Dart | Speedup vs New json_serial |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 3.54 ms | 3.79 ms | **2.78 ms** | **1.28x** | **1.36x** |
| **canada.json (2.25 MB)** | 33.97 ms | 26.61 ms | **12.50 ms** | **2.72x** | **2.13x** |
| **citm_catalog.json (1.73 MB)** | 5.84 ms | 5.98 ms | **4.61 ms** | **1.27x** | **1.30x** |
| **small.json (0.55 KB)** | 0.01 ms | 0.00 ms | **0.00 ms** | **2.67x** | **1.00x** |
| **twitter.json (0.62 MB)** | 2.95 ms | 2.85 ms | **5.83 ms** | **0.51x** | **0.49x** |
<!-- mdformat on -->

### 📊 Summary of AOT Encode Benchmark Results

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Old Dart + json_serial | New Dart + json_serial | New Dart + Codable | Speedup vs Old Dart | Speedup vs New json_serial |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 10.44 ms | 4.58 ms | **18.26 ms** | **0.57x** | **0.25x** |
| **canada.json (2.25 MB)** | 47.31 ms | 32.72 ms | **74.38 ms** | **0.64x** | **0.44x** |
| **citm_catalog.json (1.73 MB)** | 9.66 ms | 6.30 ms | **16.76 ms** | **0.58x** | **0.38x** |
| **small.json (0.55 KB)** | 0.01 ms | 0.01 ms | **0.01 ms** | **1.11x** | **0.56x** |
| **twitter.json (0.62 MB)** | 6.37 ms | 3.75 ms | **10.24 ms** | **0.62x** | **0.37x** |
<!-- mdformat on -->


### 📊 Summary of JS Decode Benchmark Results

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Old Dart + json_serial | New Dart + json_serial | New Dart + Codable | Speedup vs Old Dart | Speedup vs New json_serial |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 4.05 ms | 19.98 ms | **7.45 ms** | **0.54x** | **2.68x** |
| **canada.json (2.25 MB)** | 30.76 ms | 97.32 ms | **31.12 ms** | **0.99x** | **3.13x** |
| **citm_catalog.json (1.73 MB)** | 8.54 ms | 27.58 ms | **13.74 ms** | **0.62x** | **2.01x** |
| **small.json (0.55 KB)** | 0.00 ms | 0.04 ms | **0.02 ms** | **0.00x** | **2.00x** |
| **twitter.json (0.62 MB)** | 3.66 ms | 13.50 ms | **5.44 ms** | **0.67x** | **2.48x** |
<!-- mdformat on -->

### 📊 Summary of JS Encode Benchmark Results

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Old Dart + json_serial | New Dart + json_serial | New Dart + Codable | Speedup vs Old Dart | Speedup vs New json_serial |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 8.76 ms | 7.42 ms | **31.42 ms** | **0.28x** | **0.24x** |
| **canada.json (2.25 MB)** | 35.16 ms | 34.32 ms | **180.86 ms** | **0.19x** | **0.19x** |
| **citm_catalog.json (1.73 MB)** | 10.98 ms | 8.40 ms | **35.38 ms** | **0.31x** | **0.24x** |
| **small.json (0.55 KB)** | 0.02 ms | 0.02 ms | **0.02 ms** | **1.00x** | **1.00x** |
| **twitter.json (0.62 MB)** | 5.66 ms | 8.72 ms | **17.70 ms** | **0.32x** | **0.49x** |
<!-- mdformat on -->


### 📊 Summary of WASM Decode Benchmark Results

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Old Dart + json_serial | New Dart + json_serial | New Dart + Codable | Speedup vs Old Dart | Speedup vs New json_serial |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 3.56 ms | 3.52 ms | **7.89 ms** | **0.45x** | **0.45x** |
| **canada.json (2.25 MB)** | 38.93 ms | 38.61 ms | **43.27 ms** | **0.90x** | **0.89x** |
| **citm_catalog.json (1.73 MB)** | 6.21 ms | 6.04 ms | **20.50 ms** | **0.30x** | **0.29x** |
| **small.json (0.55 KB)** | 0.00 ms | 0.00 ms | **0.01 ms** | **0.57x** | **0.57x** |
| **twitter.json (0.62 MB)** | 3.12 ms | 3.13 ms | **9.45 ms** | **0.33x** | **0.33x** |
<!-- mdformat on -->

### 📊 Summary of WASM Encode Benchmark Results

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Old Dart + json_serial | New Dart + json_serial | New Dart + Codable | Speedup vs Old Dart | Speedup vs New json_serial |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 10.55 ms | 5.43 ms | **12.21 ms** | **0.86x** | **0.44x** |
| **canada.json (2.25 MB)** | 52.54 ms | 43.53 ms | **80.56 ms** | **0.65x** | **0.54x** |
| **citm_catalog.json (1.73 MB)** | 9.00 ms | 6.52 ms | **11.70 ms** | **0.77x** | **0.56x** |
| **small.json (0.55 KB)** | 0.01 ms | 0.01 ms | **0.01 ms** | **0.75x** | **1.75x** |
| **twitter.json (0.62 MB)** | 5.92 ms | 3.96 ms | **6.69 ms** | **0.89x** | **0.59x** |
<!-- mdformat on -->
