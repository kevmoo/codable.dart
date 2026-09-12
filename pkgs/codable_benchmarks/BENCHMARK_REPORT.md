### 📝 Provenance

- **Run Timestamp**: 2026-09-12T20:08:01.208Z
- **SDK Version**: 3.14.0-edge.2c131e2363143936d92729b18d962e498c772a4d (main) (Fri Sep 11 18:19:58 2026 -0700) on "linux_x64"
- **Repo Commit**: aca5b1e4ab4a0a00a7583fd8ffe0c3686f716b1d
- **Host OS**: linux, Hostname: kevmoo.c.googlers.com
- **Trials**: 10

### 📊 3-Runtime Summary (Relative Efficiency Index)

<!-- mdformat off(prevent table wrapping) -->
| Target Runtime | Dart Configuration | 📥 Decode Efficiency<br/>[ Worst / GeoMean / Best ] | 📤 Encode Efficiency<br/>[ Worst / GeoMean / Best ] |
| :--- | :--- | :---: | :---: |
| **AOT (`dart compile exe`)** | **`New Dart + Codable`** | 🟢 `[ 89 / 97 / 100 ]` | 🟢 `[ 73 / 94 / 100 ]` |
| **JS (`dart2js` / Node 24 / V8)** | **`New Dart + Codable`** | 🟢 `[ 100 / 100 / 100 ]` | 🟢 `[ 100 / 100 / 100 ]` |
| **WASM (`dart2wasm` / Node 24 / V8)** | **`New Dart + Codable`** | 🟢 `[ 96 / 99 / 100 ]` | 🟢 `[ 96 / 99 / 100 ]` |
<!-- mdformat on -->

> **Scoring Metric**: **Relative Throughput Efficiency** (`100` = Peak Speed). Calculated as `round((MinLatency / Latency) * 100)` per workload, aggregated across benchmarks using the **Geometric Mean** (Fleming & Wallace 1986).
> - **`[ Worst / GeoMean / Best ]`**: Range from lowest score (worst workload) to the geometric mean and peak dataset score
>   across the 5 canonical benchmarks (`coordinates`, `canada`, `citm_catalog`, `small`, `twitter`).
> - **Badges**: 🥇 Peak across all workloads (`100`) • 🟢 `≥ 90` (Within 10% of peak) • 🟡 `70–89` (Good / moderate) • 🔴 `< 70` (Significant performance gap).

------------------------------------------------------------------------

### 🎯 AOT Target Detailed Breakdown

#### Detailed Breakdown: AOT Decode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | json_serializable | package:codable | Speedup vs json_serializable |
| :--- | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 3.92 ms | **2.61 ms** | **1.50x** |
| **canada.json (2.25 MB)** | 36.80 ms | **11.23 ms** | **3.28x** |
| **citm_catalog.json (1.73 MB)** | 8.15 ms | **4.61 ms** | **1.77x** |
| **small.json (0.55 KB)** | 2.8 µs | **3.1 µs** | **0.89x** |
| **twitter.json (0.62 MB)** | 3.09 ms | **3.14 ms** | **0.98x** |
<!-- mdformat on -->


#### Detailed Breakdown: AOT Encode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | json_serializable | package:codable | Speedup vs json_serializable |
| :--- | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 4.84 ms | **2.92 ms** | **1.66x** |
| **canada.json (2.25 MB)** | 26.36 ms | **36.22 ms** | **0.73x** |
| **citm_catalog.json (1.73 MB)** | 6.21 ms | **3.26 ms** | **1.91x** |
| **small.json (0.55 KB)** | 4.9 µs | **1.7 µs** | **2.88x** |
| **twitter.json (0.62 MB)** | 3.12 ms | **1.92 ms** | **1.63x** |
<!-- mdformat on -->


------------------------------------------------------------------------

### 🎯 JS Target Detailed Breakdown

#### Detailed Breakdown: JS Decode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | json_serializable | package:codable | Speedup vs json_serializable |
| :--- | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 4.41 ms | **2.67 ms** | **1.65x** |
| **canada.json (2.25 MB)** | 37.00 ms | **15.40 ms** | **2.40x** |
| **citm_catalog.json (1.73 MB)** | 9.39 ms | **6.11 ms** | **1.54x** |
| **small.json (0.55 KB)** | 4.7 µs | **3.6 µs** | **1.33x** |
| **twitter.json (0.62 MB)** | 3.75 ms | **3.09 ms** | **1.22x** |
<!-- mdformat on -->


#### Detailed Breakdown: JS Encode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | json_serializable | package:codable | Speedup vs json_serializable |
| :--- | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 8.00 ms | **2.63 ms** | **3.05x** |
| **canada.json (2.25 MB)** | 37.17 ms | **20.13 ms** | **1.85x** |
| **citm_catalog.json (1.73 MB)** | 9.50 ms | **4.24 ms** | **2.24x** |
| **small.json (0.55 KB)** | 21.1 µs | **3.2 µs** | **6.62x** |
| **twitter.json (0.62 MB)** | 3.55 ms | **3.12 ms** | **1.14x** |
<!-- mdformat on -->


------------------------------------------------------------------------

### 🎯 WASM Target Detailed Breakdown

#### Detailed Breakdown: WASM Decode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | json_serializable | package:codable | Speedup vs json_serializable |
| :--- | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 3.94 ms | **3.37 ms** | **1.17x** |
| **canada.json (2.25 MB)** | 54.37 ms | **14.12 ms** | **3.85x** |
| **citm_catalog.json (1.73 MB)** | 6.07 ms | **5.67 ms** | **1.07x** |
| **small.json (0.55 KB)** | 3.4 µs | **3.5 µs** | **0.96x** |
| **twitter.json (0.62 MB)** | 3.36 ms | **3.34 ms** | **1.01x** |
<!-- mdformat on -->


#### Detailed Breakdown: WASM Encode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | json_serializable | package:codable | Speedup vs json_serializable |
| :--- | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 5.16 ms | **3.45 ms** | **1.50x** |
| **canada.json (2.25 MB)** | 41.68 ms | **25.31 ms** | **1.65x** |
| **citm_catalog.json (1.73 MB)** | 6.86 ms | **5.33 ms** | **1.29x** |
| **small.json (0.55 KB)** | 6.0 µs | **3.9 µs** | **1.53x** |
| **twitter.json (0.62 MB)** | 3.38 ms | **3.53 ms** | **0.96x** |
<!-- mdformat on -->


------------------------------------------------------------------------

### 🔬 Methodology & Caveats

- Every cell is the **median** of the trial count listed in the provenance
  header, measured in a single sweep. `json_serializable` is measured in the
  same sweep and serves as the machine-state control.
- **Resolution limit**: at 10–15 trials this harness cannot reliably resolve
  latency deltas below roughly **10%**. Run-to-run drift is large enough to
  flip the sign of small effects. Treat any speedup between `0.90x` and
  `1.10x` as *no measured difference*.
- To resolve sub-10% effects, use an **interleaved same-session A/B** instead:
  compile `tool/profiler/benchmark_harness.dart` to AOT from both commits and
  alternate the two binaries in one shell loop for 3–5 rounds. Absolute
  numbers from that harness run higher than `bench_press` (different
  warmup/iteration structure), but the relative delta is stable.
- Comparing a cell against a *previous* report is only valid when the
  `json_serializable` control for that cell moved by less than the effect
  being claimed.

