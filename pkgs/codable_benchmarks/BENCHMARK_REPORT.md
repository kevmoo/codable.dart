### 📊 Summary of JS Decode Benchmark Results

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Old Dart + json_serial | New Dart + json_serial | New Dart + Codable | Speedup vs Old Dart | Speedup vs New json_serial |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 4.00 ms | 20.00 ms | **7.00 ms** | **0.57x** | **2.86x** |
| **canada.json (2.25 MB)** | 31.00 ms | 97.00 ms | **30.50 ms** | **1.02x** | **3.18x** |
| **citm_catalog.json (1.73 MB)** | 8.00 ms | 25.00 ms | **13.00 ms** | **0.62x** | **1.92x** |
| **small.json (0.55 KB)** | 0.00 ms | 0.01 ms | **0.01 ms** | **0.67x** | **2.50x** |
| **twitter.json (0.62 MB)** | 3.33 ms | 12.00 ms | **5.00 ms** | **0.67x** | **2.40x** |
<!-- mdformat on -->

### 📊 Summary of JS Encode Benchmark Results

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Old Dart + json_serial | New Dart + json_serial | New Dart + Codable | Speedup vs Old Dart | Speedup vs New json_serial |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 9.00 ms | 7.50 ms | **4.50 ms** | **2.00x** | **1.67x** |
| **canada.json (2.25 MB)** | 34.00 ms | 32.00 ms | **28.00 ms** | **1.21x** | **1.14x** |
| **citm_catalog.json (1.73 MB)** | 11.00 ms | 9.00 ms | **6.00 ms** | **1.83x** | **1.50x** |
| **small.json (0.55 KB)** | 0.01 ms | 0.01 ms | **0.01 ms** | **2.00x** | **2.20x** |
| **twitter.json (0.62 MB)** | 5.50 ms | 3.33 ms | **4.00 ms** | **1.38x** | **0.83x** |
<!-- mdformat on -->
