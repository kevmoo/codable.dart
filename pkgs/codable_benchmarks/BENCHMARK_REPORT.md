### 📝 Provenance

- **Run Timestamp**: 2026-09-12T22:48:03.596Z
- **SDK Version**: 3.14.0-edge.2c131e2363143936d92729b18d962e498c772a4d (main) (Fri Sep 11 18:19:58 2026 -0700) on "linux_x64"
- **Repo Commit**: fb2d734503fd1cbd533cc11274d22f47b63f88ff
- **Host OS**: linux, Hostname: kevmoo.c.googlers.com
- **Trials**: 15

### 📊 3-Runtime Summary (Relative Efficiency Index)

<!-- mdformat off(prevent table wrapping) -->
| Target Runtime | Dart Configuration | 📥 Decode Efficiency<br/>[ Worst / GeoMean / Best ] | 📤 Encode Efficiency<br/>[ Worst / GeoMean / Best ] |
| :--- | :--- | :---: | :---: |
| **AOT (`dart compile exe`)** | **`New Dart + Codable`** | 🟢 `[ 90 / 96 / 100 ]` | 🟢 `[ 100 / 100 / 100 ]` |
| **JS (`dart2js` / Node 24 / V8)** | **`New Dart + Codable`** | 🟢 `[ 100 / 100 / 100 ]` | 🟢 `[ 100 / 100 / 100 ]` |
| **WASM (`dart2wasm` / Node 24 / V8)** | **`New Dart + Codable`** | 🟢 `[ 93 / 97 / 100 ]` | 🟢 `[ 100 / 100 / 100 ]` |
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
| **10k Coordinates (0.39 MB)** | 3.54 ms | **2.51 ms** | **1.41x** |
| **canada.json (2.25 MB)** | 41.16 ms | **11.28 ms** | **3.65x** |
| **citm_catalog.json (1.73 MB)** | 7.23 ms | **4.57 ms** | **1.58x** |
| **small.json (0.55 KB)** | 2.7 µs | **3.0 µs** | **0.90x** |
| **twitter.json (0.62 MB)** | 2.89 ms | **3.11 ms** | **0.93x** |
<!-- mdformat on -->


#### Detailed Breakdown: AOT Encode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | json_serializable | package:codable | Speedup vs json_serializable |
| :--- | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 3.98 ms | **2.72 ms** | **1.46x** |
| **canada.json (2.25 MB)** | 26.20 ms | **22.10 ms** | **1.19x** |
| **citm_catalog.json (1.73 MB)** | 5.78 ms | **3.01 ms** | **1.92x** |
| **small.json (0.55 KB)** | 5.0 µs | **1.7 µs** | **2.90x** |
| **twitter.json (0.62 MB)** | 2.71 ms | **1.67 ms** | **1.62x** |
<!-- mdformat on -->


------------------------------------------------------------------------

### 🎯 JS Target Detailed Breakdown

#### Detailed Breakdown: JS Decode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | json_serializable | package:codable | Speedup vs json_serializable |
| :--- | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 4.09 ms | **2.50 ms** | **1.64x** |
| **canada.json (2.25 MB)** | 33.00 ms | **15.00 ms** | **2.20x** |
| **citm_catalog.json (1.73 MB)** | 8.71 ms | **5.57 ms** | **1.56x** |
| **small.json (0.55 KB)** | 4.9 µs | **3.5 µs** | **1.39x** |
| **twitter.json (0.62 MB)** | 3.45 ms | **2.90 ms** | **1.19x** |
<!-- mdformat on -->


#### Detailed Breakdown: JS Encode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | json_serializable | package:codable | Speedup vs json_serializable |
| :--- | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 8.50 ms | **2.52 ms** | **3.37x** |
| **canada.json (2.25 MB)** | 33.50 ms | **20.25 ms** | **1.65x** |
| **citm_catalog.json (1.73 MB)** | 8.38 ms | **3.94 ms** | **2.13x** |
| **small.json (0.55 KB)** | 18.4 µs | **2.4 µs** | **7.56x** |
| **twitter.json (0.62 MB)** | 3.40 ms | **2.92 ms** | **1.16x** |
<!-- mdformat on -->


------------------------------------------------------------------------

### 🎯 WASM Target Detailed Breakdown

#### Detailed Breakdown: WASM Decode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | json_serializable | package:codable | Speedup vs json_serializable |
| :--- | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 3.84 ms | **3.29 ms** | **1.17x** |
| **canada.json (2.25 MB)** | 52.03 ms | **12.90 ms** | **4.03x** |
| **citm_catalog.json (1.73 MB)** | 5.96 ms | **5.60 ms** | **1.06x** |
| **small.json (0.55 KB)** | 3.3 µs | **3.6 µs** | **0.93x** |
| **twitter.json (0.62 MB)** | 3.03 ms | **3.26 ms** | **0.93x** |
<!-- mdformat on -->


#### Detailed Breakdown: WASM Encode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | json_serializable | package:codable | Speedup vs json_serializable |
| :--- | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 5.11 ms | **3.34 ms** | **1.53x** |
| **canada.json (2.25 MB)** | 39.95 ms | **25.22 ms** | **1.58x** |
| **citm_catalog.json (1.73 MB)** | 5.85 ms | **5.30 ms** | **1.10x** |
| **small.json (0.55 KB)** | 6.0 µs | **3.1 µs** | **1.96x** |
| **twitter.json (0.62 MB)** | 3.29 ms | **3.20 ms** | **1.03x** |
<!-- mdformat on -->


------------------------------------------------------------------------

### 🔬 Methodology & Caveats

- Every cell is the **min** of the trial count listed in the provenance
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

