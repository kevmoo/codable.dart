### 📊 Summary: WASM Target ([ min / avg / max ] Multiplier vs Fastest)

<!-- mdformat off(prevent table wrapping) -->
| Dart Configuration | 📥 Decode [ min / avg / max ] | 📤 Encode [ min / avg / max ] |
| :--- | :---: | :---: |
| **`Old Dart + json_serial`** | 🟢 `[ 1.00 / 1.06 / 1.28 ]` | 🟡 `[ 1.25 / 1.58 / 2.22 ]` |
| **`New Dart + json_serial`** | 🟢 `[ 1.00 / 1.04 / 1.21 ]` | 🟢 `[ 1.00 / 1.07 / 1.25 ]` |
| **`New Dart + Codable`** | 🔴 `[ 1.00 / 2.34 / 3.27 ]` | 🟡 `[ 1.00 / 1.33 / 1.85 ]` |
<!-- mdformat on -->

#### Detailed Breakdown: WASM Decode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Old Dart + json_serial | New Dart + json_serial | New Dart + Codable | Speedup vs Old Dart | Speedup vs New json_serial |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 3.34 ms | 3.35 ms | **7.69 ms** | **0.43x** | **0.44x** |
| **canada.json (2.25 MB)** | 37.20 ms | 35.13 ms | **29.14 ms** | **1.28x** | **1.21x** |
| **citm_catalog.json (1.73 MB)** | 5.38 ms | 5.39 ms | **17.58 ms** | **0.31x** | **0.31x** |
| **small.json (0.55 KB)** | 0.00 ms | 0.00 ms | **0.01 ms** | **0.43x** | **0.43x** |
| **twitter.json (0.62 MB)** | 2.96 ms | 2.96 ms | **8.29 ms** | **0.36x** | **0.36x** |
<!-- mdformat on -->

### 📊 Summary of WASM Encode Benchmark Results

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Old Dart + json_serial | New Dart + json_serial | New Dart + Codable | Speedup vs Old Dart | Speedup vs New json_serial |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 10.17 ms | 4.58 ms | **6.10 ms** | **1.67x** | **0.75x** |
| **canada.json (2.25 MB)** | 47.81 ms | 40.09 ms | **36.21 ms** | **1.32x** | **1.11x** |
| **citm_catalog.json (1.73 MB)** | 8.21 ms | 5.34 ms | **7.76 ms** | **1.06x** | **0.69x** |
| **small.json (0.55 KB)** | 0.01 ms | 0.01 ms | **0.00 ms** | **1.25x** | **1.25x** |
| **twitter.json (0.62 MB)** | 5.33 ms | 3.39 ms | **6.28 ms** | **0.85x** | **0.54x** |
<!-- mdformat on -->

### 📊 Summary: JS Target ([ min / avg / max ] Multiplier vs Fastest)

<!-- mdformat off(prevent table wrapping) -->
| Dart Configuration | 📥 Decode [ min / avg / max ] | 📤 Encode [ min / avg / max ] |
| :--- | :---: | :---: |
| **`Old Dart + json_serial`** | 🟡 `[ 1.00 / 1.42 / 2.46 ]` | 🔴 `[ 1.18 / 1.64 / 2.00 ]` |
| **`New Dart + json_serial`** | 🟡 `[ 1.00 / 1.43 / 2.63 ]` | 🟡 `[ 1.00 / 1.51 / 2.20 ]` |
| **`New Dart + Codable`** | 🟢 `[ 1.00 / 1.03 / 1.13 ]` | 🟢 `[ 1.00 / 1.03 / 1.14 ]` |
<!-- mdformat on -->

#### Detailed Breakdown: JS Decode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Old Dart + json_serial | New Dart + json_serial | New Dart + Codable | Speedup vs Old Dart | Speedup vs New json_serial |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 4.00 ms | 4.00 ms | **3.33 ms** | **1.20x** | **1.20x** |
| **canada.json (2.25 MB)** | 29.50 ms | 31.50 ms | **12.00 ms** | **2.46x** | **2.63x** |
| **citm_catalog.json (1.73 MB)** | 8.50 ms | 8.00 ms | **6.00 ms** | **1.42x** | **1.33x** |
| **small.json (0.55 KB)** | 0.00 ms | 0.00 ms | **0.00 ms** | **1.00x** | **1.00x** |
| **twitter.json (0.62 MB)** | 3.33 ms | 3.33 ms | **3.75 ms** | **0.89x** | **0.89x** |
<!-- mdformat on -->

### 📊 Summary of JS Encode Benchmark Results

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Old Dart + json_serial | New Dart + json_serial | New Dart + Codable | Speedup vs Old Dart | Speedup vs New json_serial |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 9.00 ms | 7.50 ms | **4.50 ms** | **2.00x** | **1.67x** |
| **canada.json (2.25 MB)** | 33.00 ms | 35.00 ms | **28.00 ms** | **1.18x** | **1.25x** |
| **citm_catalog.json (1.73 MB)** | 11.00 ms | 8.50 ms | **6.00 ms** | **1.83x** | **1.42x** |
| **small.json (0.55 KB)** | 0.01 ms | 0.01 ms | **0.01 ms** | **1.60x** | **2.20x** |
| **twitter.json (0.62 MB)** | 5.50 ms | 3.50 ms | **4.00 ms** | **1.38x** | **0.88x** |
<!-- mdformat on -->

### 📊 Summary: AOT Target ([ min / avg / max ] Multiplier vs Fastest)

<!-- mdformat off(prevent table wrapping) -->
| Dart Configuration | 📥 Decode [ min / avg / max ] | 📤 Encode [ min / avg / max ] |
| :--- | :---: | :---: |
| **`Old Dart + json_serial`** | 🟡 `[ 1.00 / 1.59 / 3.12 ]` | 🔴 `[ 1.60 / 1.99 / 2.50 ]` |
| **`New Dart + json_serial`** | 🟡 `[ 1.00 / 1.43 / 2.38 ]` | 🟡 `[ 1.00 / 1.26 / 2.00 ]` |
| **`New Dart + Codable`** | 🟡 `[ 1.00 / 1.18 / 1.91 ]` | 🟡 `[ 1.00 / 1.28 / 1.88 ]` |
<!-- mdformat on -->

#### Detailed Breakdown: AOT Decode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Old Dart + json_serial | New Dart + json_serial | New Dart + Codable | Speedup vs Old Dart | Speedup vs New json_serial |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 3.72 ms | 3.71 ms | **2.45 ms** | **1.51x** | **1.51x** |
| **canada.json (2.25 MB)** | 42.12 ms | 32.11 ms | **13.50 ms** | **3.12x** | **2.38x** |
| **citm_catalog.json (1.73 MB)** | 5.97 ms | 5.59 ms | **4.51 ms** | **1.32x** | **1.24x** |
| **small.json (0.55 KB)** | 0.00 ms | 0.00 ms | **0.00 ms** | **1.00x** | **1.00x** |
| **twitter.json (0.62 MB)** | 2.71 ms | 2.76 ms | **5.16 ms** | **0.52x** | **0.53x** |
<!-- mdformat on -->

### 📊 Summary of AOT Encode Benchmark Results

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | Old Dart + json_serial | New Dart + json_serial | New Dart + Codable | Speedup vs Old Dart | Speedup vs New json_serial |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 9.71 ms | 4.24 ms | **7.99 ms** | **1.22x** | **0.53x** |
| **canada.json (2.25 MB)** | 48.05 ms | 30.11 ms | **40.25 ms** | **1.19x** | **0.75x** |
| **citm_catalog.json (1.73 MB)** | 8.04 ms | 5.77 ms | **4.40 ms** | **1.83x** | **1.31x** |
| **small.json (0.55 KB)** | 0.01 ms | 0.00 ms | **0.00 ms** | **2.50x** | **2.00x** |
| **twitter.json (0.62 MB)** | 5.22 ms | 3.03 ms | **3.54 ms** | **1.47x** | **0.86x** |
<!-- mdformat on -->
