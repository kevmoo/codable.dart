### 📊 Summary: WASM Target ([ min / avg / max ] Multiplier vs Fastest)

<!-- mdformat off(prevent table wrapping) -->
| Dart Configuration | 📥 Decode [ min / avg / max ] | 📤 Encode [ min / avg / max ] |
| :--- | :---: | :---: |
| **`Old Dart + json_serial`** | 🟢 `[ 1.00 / 1.04 / 1.18 ]` | 🟡 `[ 1.25 / 1.58 / 2.16 ]` |
| **`New Dart + json_serial`** | 🔴 `[ 1.54 / 2.21 / 2.67 ]` | 🟢 `[ 1.00 / 1.07 / 1.25 ]` |
| **`New Dart + Codable`** | 🔴 `[ 1.00 / 2.39 / 3.30 ]` | 🟡 `[ 1.00 / 1.29 / 1.77 ]` |
<!-- mdformat on -->

#### Detailed Breakdown: WASM Decode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Old Dart + json_serial | New Dart + json_serial | New Dart + Codable | Speedup vs Old Dart | Speedup vs New json_serial |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 3.38 ms | 8.11 ms | **7.79 ms** | **0.43x** | **1.04x** |
| **canada.json (2.25 MB)** | 38.08 ms | 49.62 ms | **32.16 ms** | **1.18x** | **1.54x** |
| **citm_catalog.json (1.73 MB)** | 5.33 ms | 12.29 ms | **17.61 ms** | **0.30x** | **0.70x** |
| **small.json (0.55 KB)** | 0.00 ms | 0.01 ms | **0.01 ms** | **0.43x** | **1.14x** |
| **twitter.json (0.62 MB)** | 2.98 ms | 6.36 ms | **9.00 ms** | **0.33x** | **0.71x** |
<!-- mdformat on -->

### 📊 Summary of WASM Encode Benchmark Results

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Old Dart + json_serial | New Dart + json_serial | New Dart + Codable | Speedup vs Old Dart | Speedup vs New json_serial |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 10.02 ms | 4.64 ms | **6.09 ms** | **1.65x** | **0.76x** |
| **canada.json (2.25 MB)** | 50.69 ms | 40.30 ms | **36.28 ms** | **1.40x** | **1.11x** |
| **citm_catalog.json (1.73 MB)** | 8.74 ms | 5.60 ms | **7.53 ms** | **1.16x** | **0.74x** |
| **small.json (0.55 KB)** | 0.01 ms | 0.01 ms | **0.00 ms** | **1.25x** | **1.25x** |
| **twitter.json (0.62 MB)** | 5.30 ms | 3.42 ms | **6.06 ms** | **0.87x** | **0.56x** |
<!-- mdformat on -->

### 📊 Summary: JS Target ([ min / avg / max ] Multiplier vs Fastest)

<!-- mdformat off(prevent table wrapping) -->
| Dart Configuration | 📥 Decode [ min / avg / max ] | 📤 Encode [ min / avg / max ] |
| :--- | :---: | :---: |
| **`Old Dart + json_serial`** | 🟡 `[ 1.00 / 1.43 / 2.71 ]` | 🔴 `[ 1.19 / 1.79 / 2.25 ]` |
| **`New Dart + json_serial`** | 🔴 `[ 3.00 / 4.67 / 8.17 ]` | 🟡 `[ 1.00 / 1.51 / 2.20 ]` |
| **`New Dart + Codable`** | 🥇 `[ 1.00 / 1.00 / 1.00 ]` | 🟢 `[ 1.00 / 1.03 / 1.14 ]` |
<!-- mdformat on -->

#### Detailed Breakdown: JS Decode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Old Dart + json_serial | New Dart + json_serial | New Dart + Codable | Speedup vs Old Dart | Speedup vs New json_serial |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 4.00 ms | 16.00 ms | **3.67 ms** | **1.09x** | **4.36x** |
| **canada.json (2.25 MB)** | 32.50 ms | 98.00 ms | **12.00 ms** | **2.71x** | **8.17x** |
| **citm_catalog.json (1.73 MB)** | 8.00 ms | 18.00 ms | **6.00 ms** | **1.33x** | **3.00x** |
| **small.json (0.55 KB)** | 0.00 ms | 0.02 ms | **0.00 ms** | **1.00x** | **4.25x** |
| **twitter.json (0.62 MB)** | 3.67 ms | 13.00 ms | **3.67 ms** | **1.00x** | **3.55x** |
<!-- mdformat on -->

### 📊 Summary of JS Encode Benchmark Results

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Old Dart + json_serial | New Dart + json_serial | New Dart + Codable | Speedup vs Old Dart | Speedup vs New json_serial |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 9.00 ms | 7.50 ms | **4.00 ms** | **2.25x** | **1.88x** |
| **canada.json (2.25 MB)** | 32.00 ms | 32.00 ms | **27.00 ms** | **1.19x** | **1.19x** |
| **citm_catalog.json (1.73 MB)** | 11.00 ms | 8.00 ms | **6.25 ms** | **1.76x** | **1.28x** |
| **small.json (0.55 KB)** | 0.01 ms | 0.01 ms | **0.01 ms** | **2.20x** | **2.20x** |
| **twitter.json (0.62 MB)** | 5.50 ms | 3.50 ms | **4.00 ms** | **1.38x** | **0.88x** |
<!-- mdformat on -->

### 📊 Summary: AOT Target ([ min / avg / max ] Multiplier vs Fastest)

<!-- mdformat off(prevent table wrapping) -->
| Dart Configuration | 📥 Decode [ min / avg / max ] | 📤 Encode [ min / avg / max ] |
| :--- | :---: | :---: |
| **`Old Dart + json_serial`** | 🟡 `[ 1.00 / 1.56 / 2.84 ]` | 🔴 `[ 1.61 / 1.83 / 2.12 ]` |
| **`New Dart + json_serial`** | 🔴 `[ 2.00 / 2.80 / 4.00 ]` | 🟢 `[ 1.00 / 1.12 / 1.33 ]` |
| **`New Dart + Codable`** | 🟢 `[ 1.00 / 1.14 / 1.71 ]` | 🟡 `[ 1.00 / 1.20 / 1.41 ]` |
<!-- mdformat on -->

#### Detailed Breakdown: AOT Decode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Old Dart + json_serial | New Dart + json_serial | New Dart + Codable | Speedup vs Old Dart | Speedup vs New json_serial |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 4.04 ms | 8.24 ms | **2.57 ms** | **1.57x** | **3.21x** |
| **canada.json (2.25 MB)** | 42.73 ms | 60.20 ms | **15.05 ms** | **2.84x** | **4.00x** |
| **citm_catalog.json (1.73 MB)** | 6.08 ms | 11.67 ms | **4.36 ms** | **1.40x** | **2.68x** |
| **small.json (0.55 KB)** | 0.00 ms | 0.01 ms | **0.00 ms** | **1.00x** | **2.00x** |
| **twitter.json (0.62 MB)** | 2.75 ms | 5.87 ms | **4.70 ms** | **0.59x** | **1.25x** |
<!-- mdformat on -->

### 📊 Summary of AOT Encode Benchmark Results

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Old Dart + json_serial | New Dart + json_serial | New Dart + Codable | Speedup vs Old Dart | Speedup vs New json_serial |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 9.62 ms | 4.83 ms | **6.80 ms** | **1.42x** | **0.71x** |
| **canada.json (2.25 MB)** | 49.70 ms | 30.80 ms | **43.30 ms** | **1.15x** | **0.71x** |
| **citm_catalog.json (1.73 MB)** | 10.01 ms | 5.87 ms | **4.71 ms** | **2.12x** | **1.25x** |
| **small.json (0.55 KB)** | 0.01 ms | 0.00 ms | **0.00 ms** | **1.67x** | **1.33x** |
| **twitter.json (0.62 MB)** | 5.27 ms | 3.04 ms | **3.55 ms** | **1.49x** | **0.86x** |
<!-- mdformat on -->
