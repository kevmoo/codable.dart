### 📝 Provenance

- **Run Timestamp**: 2026-09-12T22:48:03.596Z
- **SDK Version**: unknown
- **Repo Commit**: unknown
- **Host OS**: unknown, Hostname: unknown
- **Trials**: 15

### 📊 3-Runtime Summary (Relative Efficiency Index)

<!-- mdformat off(prevent table wrapping) -->
| Target Runtime | Dart Configuration | 📥 Decode Efficiency<br/>[ Worst / GeoMean / Best ] | 📤 Encode Efficiency<br/>[ Worst / GeoMean / Best ] |
| :--- | :--- | :---: | :---: |
| **AOT (`dart compile exe`)** | **`New Dart + Codable`** | 🟢 `[ 83 / 96 / 100 ]` | 🟢 `[ 100 / 100 / 100 ]` |
| **JS (`dart2js` / Node 24 / V8)** | **`New Dart + Codable`** | 🟢 `[ 100 / 100 / 100 ]` | 🟢 `[ 100 / 100 / 100 ]` |
| **WASM (`dart2wasm` / Node 24 / V8)** | **`New Dart + Codable`** | 🟢 `[ 92 / 98 / 100 ]` | 🟢 `[ 100 / 100 / 100 ]` |
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
| **10k Coordinates (0.39 MB)** | 4.49 ms | **2.72 ms** | **1.65x** |
| **canada.json (2.25 MB)** | 43.71 ms | **11.90 ms** | **3.67x** |
| **citm_catalog.json (1.73 MB)** | 7.77 ms | **4.70 ms** | **1.65x** |
| **small.json (0.55 KB)** | 2.8 µs | **3.3 µs** | **0.83x** |
| **twitter.json (0.62 MB)** | 3.16 ms | **3.20 ms** | **0.98x** |
<!-- mdformat on -->


#### Detailed Breakdown: AOT Encode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | json_serializable | package:codable | Speedup vs json_serializable |
| :--- | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 4.89 ms | **3.02 ms** | **1.62x** |
| **canada.json (2.25 MB)** | 26.99 ms | **23.53 ms** | **1.15x** |
| **citm_catalog.json (1.73 MB)** | 6.83 ms | **3.17 ms** | **2.15x** |
| **small.json (0.55 KB)** | 5.2 µs | **1.8 µs** | **2.82x** |
| **twitter.json (0.62 MB)** | 3.41 ms | **1.81 ms** | **1.89x** |
<!-- mdformat on -->


------------------------------------------------------------------------

### 🎯 JS Target Detailed Breakdown

#### Detailed Breakdown: JS Decode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | json_serializable | package:codable | Speedup vs json_serializable |
| :--- | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 4.36 ms | **2.63 ms** | **1.66x** |
| **canada.json (2.25 MB)** | 34.33 ms | **15.33 ms** | **2.24x** |
| **citm_catalog.json (1.73 MB)** | 10.29 ms | **6.00 ms** | **1.71x** |
| **small.json (0.55 KB)** | 5.0 µs | **3.6 µs** | **1.38x** |
| **twitter.json (0.62 MB)** | 3.80 ms | **3.17 ms** | **1.20x** |
<!-- mdformat on -->


#### Detailed Breakdown: JS Encode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | json_serializable | package:codable | Speedup vs json_serializable |
| :--- | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 9.00 ms | **2.73 ms** | **3.30x** |
| **canada.json (2.25 MB)** | 38.50 ms | **21.50 ms** | **1.79x** |
| **citm_catalog.json (1.73 MB)** | 8.75 ms | **4.24 ms** | **2.07x** |
| **small.json (0.55 KB)** | 21.6 µs | **3.2 µs** | **6.80x** |
| **twitter.json (0.62 MB)** | 3.50 ms | **3.12 ms** | **1.12x** |
<!-- mdformat on -->


------------------------------------------------------------------------

### 🎯 WASM Target Detailed Breakdown

#### Detailed Breakdown: WASM Decode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | json_serializable | package:codable | Speedup vs json_serializable |
| :--- | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 3.93 ms | **3.40 ms** | **1.16x** |
| **canada.json (2.25 MB)** | 55.77 ms | **14.74 ms** | **3.78x** |
| **citm_catalog.json (1.73 MB)** | 6.14 ms | **5.75 ms** | **1.07x** |
| **small.json (0.55 KB)** | 3.4 µs | **3.7 µs** | **0.92x** |
| **twitter.json (0.62 MB)** | 3.26 ms | **3.31 ms** | **0.99x** |
<!-- mdformat on -->


#### Detailed Breakdown: WASM Encode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | json_serializable | package:codable | Speedup vs json_serializable |
| :--- | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 5.21 ms | **3.43 ms** | **1.52x** |
| **canada.json (2.25 MB)** | 44.26 ms | **25.94 ms** | **1.71x** |
| **citm_catalog.json (1.73 MB)** | 6.11 ms | **5.70 ms** | **1.07x** |
| **small.json (0.55 KB)** | 6.2 µs | **3.2 µs** | **1.98x** |
| **twitter.json (0.62 MB)** | 3.56 ms | **3.37 ms** | **1.06x** |
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

