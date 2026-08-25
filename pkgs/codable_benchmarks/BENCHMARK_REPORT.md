### 📊 Summary: AOT Target ([ min / avg / max ] Multiplier vs Fastest)

<!-- mdformat off(prevent table wrapping) -->
| Dart Configuration | 📥 Decode [ min / avg / max ] | 📤 Encode [ min / avg / max ] |
| :--- | :---: | :---: |
| **`Old Dart + json_serial`** | [ 1.00 / 1.05 / 1.26 ] | [ 1.50 / 1.78 / 2.13 ] |
| **`New Dart + json_serial`** | [ 1.71 / 2.16 / 2.49 ] | [ 1.00 / 1.11 / 1.33 ] |
| **`New Dart + Codable`** | [ 1.00 / 1.43 / 1.83 ] | [ 1.00 / 1.10 / 1.27 ] |
<!-- mdformat on -->

#### Detailed Breakdown: AOT Decode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Old Dart + json_serial | New Dart + json_serial | New Dart + Codable | Speedup vs Old Dart | Speedup vs New json_serial |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 3.57 ms | 8.67 ms | **4.96 ms** | **0.72x** | **1.75x** |
| **canada.json (2.25 MB)** | 46.30 ms | 62.74 ms | **36.65 ms** | **1.26x** | **1.71x** |
| **citm_catalog.json (1.73 MB)** | 6.64 ms | 16.51 ms | **8.31 ms** | **0.80x** | **1.99x** |
| **small.json (0.55 KB)** | 0.00 ms | 0.01 ms | **0.01 ms** | **0.60x** | **1.20x** |
| **twitter.json (0.62 MB)** | 2.83 ms | 6.14 ms | **5.17 ms** | **0.55x** | **1.19x** |
<!-- mdformat on -->

### 📊 Summary of AOT Encode Benchmark Results

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Old Dart + json_serial | New Dart + json_serial | New Dart + Codable | Speedup vs Old Dart | Speedup vs New json_serial |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 9.21 ms | 4.32 ms | **5.39 ms** | **1.71x** | **0.80x** |
| **canada.json (2.25 MB)** | 48.07 ms | 32.15 ms | **40.86 ms** | **1.18x** | **0.79x** |
| **citm_catalog.json (1.73 MB)** | 9.16 ms | 6.09 ms | **5.58 ms** | **1.64x** | **1.09x** |
| **small.json (0.55 KB)** | 0.01 ms | 0.00 ms | **0.00 ms** | **1.67x** | **1.33x** |
| **twitter.json (0.62 MB)** | 5.32 ms | 2.99 ms | **2.70 ms** | **1.97x** | **1.11x** |
<!-- mdformat on -->


------------------------------------------------------------------------

### 📊 Summary: JS Target ([ min / avg / max ] Multiplier vs Fastest)

<!-- mdformat off(prevent table wrapping) -->
| Dart Configuration | 📥 Decode [ min / avg / max ] | 📤 Encode [ min / avg / max ] |
| :--- | :---: | :---: |
| **`Old Dart + json_serial`** | [ 1.00 / 1.00 / 1.00 ] | [ 1.16 / 1.54 / 1.83 ] |
| **`New Dart + json_serial`** | [ 2.38 / 3.58 / 4.25 ] | [ 1.00 / 1.46 / 2.20 ] |
| **`New Dart + Codable`** | [ 1.11 / 1.41 / 1.63 ] | [ 1.00 / 1.02 / 1.09 ] |
<!-- mdformat on -->

#### Detailed Breakdown: JS Decode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Old Dart + json_serial | New Dart + json_serial | New Dart + Codable | Speedup vs Old Dart | Speedup vs New json_serial |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 5.33 ms | 19.50 ms | **7.00 ms** | **0.76x** | **2.79x** |
| **canada.json (2.25 MB)** | 32.00 ms | 109.00 ms | **35.50 ms** | **0.90x** | **3.07x** |
| **citm_catalog.json (1.73 MB)** | 8.00 ms | 19.00 ms | **13.00 ms** | **0.62x** | **1.46x** |
| **small.json (0.55 KB)** | 0.00 ms | 0.02 ms | **0.01 ms** | **0.67x** | **2.83x** |
| **twitter.json (0.62 MB)** | 3.33 ms | 14.00 ms | **5.00 ms** | **0.67x** | **2.80x** |
<!-- mdformat on -->

### 📊 Summary of JS Encode Benchmark Results

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Old Dart + json_serial | New Dart + json_serial | New Dart + Codable | Speedup vs Old Dart | Speedup vs New json_serial |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 9.00 ms | 7.75 ms | **5.50 ms** | **1.64x** | **1.41x** |
| **canada.json (2.25 MB)** | 33.50 ms | 34.00 ms | **29.00 ms** | **1.16x** | **1.17x** |
| **citm_catalog.json (1.73 MB)** | 11.00 ms | 9.00 ms | **6.00 ms** | **1.83x** | **1.50x** |
| **small.json (0.55 KB)** | 0.01 ms | 0.01 ms | **0.01 ms** | **1.60x** | **2.20x** |
| **twitter.json (0.62 MB)** | 5.50 ms | 3.67 ms | **4.00 ms** | **1.38x** | **0.92x** |
<!-- mdformat on -->


------------------------------------------------------------------------

### 📊 Summary: WASM Target ([ min / avg / max ] Multiplier vs Fastest)

<!-- mdformat off(prevent table wrapping) -->
| Dart Configuration | 📥 Decode [ min / avg / max ] | 📤 Encode [ min / avg / max ] |
| :--- | :---: | :---: |
| **`Old Dart + json_serial`** | [ 1.00 / 1.00 / 1.00 ] | [ 1.25 / 1.57 / 2.12 ] |
| **`New Dart + json_serial`** | [ 1.39 / 2.25 / 2.67 ] | [ 1.00 / 1.09 / 1.25 ] |
| **`New Dart + Codable`** | [ 1.17 / 2.40 / 3.44 ] | [ 1.00 / 1.40 / 1.84 ] |
<!-- mdformat on -->

#### Detailed Breakdown: WASM Decode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Old Dart + json_serial | New Dart + json_serial | New Dart + Codable | Speedup vs Old Dart | Speedup vs New json_serial |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 3.54 ms | 8.27 ms | **7.03 ms** | **0.50x** | **1.18x** |
| **canada.json (2.25 MB)** | 37.70 ms | 52.43 ms | **44.10 ms** | **0.85x** | **1.19x** |
| **citm_catalog.json (1.73 MB)** | 5.76 ms | 14.28 ms | **19.81 ms** | **0.29x** | **0.72x** |
| **small.json (0.55 KB)** | 0.00 ms | 0.01 ms | **0.01 ms** | **0.43x** | **1.14x** |
| **twitter.json (0.62 MB)** | 2.94 ms | 6.93 ms | **9.02 ms** | **0.33x** | **0.77x** |
<!-- mdformat on -->

### 📊 Summary of WASM Encode Benchmark Results

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Old Dart + json_serial | New Dart + json_serial | New Dart + Codable | Speedup vs Old Dart | Speedup vs New json_serial |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 10.03 ms | 4.73 ms | **7.88 ms** | **1.27x** | **0.60x** |
| **canada.json (2.25 MB)** | 55.12 ms | 45.28 ms | **38.41 ms** | **1.44x** | **1.18x** |
| **citm_catalog.json (1.73 MB)** | 8.82 ms | 6.08 ms | **9.06 ms** | **0.97x** | **0.67x** |
| **small.json (0.55 KB)** | 0.01 ms | 0.01 ms | **0.00 ms** | **1.25x** | **1.25x** |
| **twitter.json (0.62 MB)** | 5.71 ms | 3.56 ms | **6.54 ms** | **0.87x** | **0.54x** |
<!-- mdformat on -->


------------------------------------------------------------------------

