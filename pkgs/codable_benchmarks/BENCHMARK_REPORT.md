### 📝 Provenance

- **Run Timestamp**: 2026-09-13T01:42:03.778Z
- **SDK Version**: 3.14.0-edge.8045fcd2294b259f9a87e5abd1986c954a0ffbe0 (main) (Sat Sep 12 19:08:49 2026 -0700) on "linux_x64"
- **Repo Commit**: 54928660a1957621ddccd7ffe8e142224cddd208
- **Host OS**: linux, Hostname: kevmoo.c.googlers.com
- **Trials**: 15

### 📊 3-Runtime Summary (Relative Efficiency Index)

<!-- mdformat off(prevent table wrapping) -->
| Target Runtime | Dart Configuration | 📥 Decode Efficiency<br/>[ Worst / GeoMean / Best ] | 📤 Encode Efficiency<br/>[ Worst / GeoMean / Best ] |
| :--- | :--- | :---: | :---: |
| **AOT (`dart compile exe`)** | **`New Dart + Codable`** | 🟢 `[ 89 / 96 / 100 ]` | 🟢 `[ 94 / 99 / 100 ]` |
| **JS (`dart2js` / Node 24 / V8)** | **`New Dart + Codable`** | 🟢 `[ 100 / 100 / 100 ]` | 🟢 `[ 100 / 100 / 100 ]` |
| **WASM (`dart2wasm` / Node 24 / V8)** | **`New Dart + Codable`** | 🟢 `[ 91 / 97 / 100 ]` | 🟢 `[ 94 / 99 / 100 ]` |
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
| **10k Coordinates (0.39 MB)** | 3.76 ms | **2.44 ms** | **1.54x** |
| **canada.json (2.25 MB)** | 38.60 ms | **11.27 ms** | **3.42x** |
| **citm_catalog.json (1.73 MB)** | 6.93 ms | **4.59 ms** | **1.51x** |
| **small.json (0.55 KB)** | 2.7 µs | **3.1 µs** | **0.89x** |
| **twitter.json (0.62 MB)** | 2.98 ms | **3.20 ms** | **0.93x** |
<!-- mdformat on -->


#### Detailed Breakdown: AOT Encode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | json_serializable | package:codable | Speedup vs json_serializable |
| :--- | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 4.57 ms | **2.42 ms** | **1.89x** |
| **canada.json (2.25 MB)** | 21.47 ms | **22.82 ms** | **0.94x** |
| **citm_catalog.json (1.73 MB)** | 5.70 ms | **3.04 ms** | **1.88x** |
| **small.json (0.55 KB)** | 7.0 µs | **2.2 µs** | **3.18x** |
| **twitter.json (0.62 MB)** | 3.33 ms | **1.42 ms** | **2.34x** |
<!-- mdformat on -->


------------------------------------------------------------------------

### 🎯 JS Target Detailed Breakdown

#### Detailed Breakdown: JS Decode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | json_serializable | package:codable | Speedup vs json_serializable |
| :--- | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 4.20 ms | **2.53 ms** | **1.66x** |
| **canada.json (2.25 MB)** | 31.50 ms | **13.50 ms** | **2.33x** |
| **citm_catalog.json (1.73 MB)** | 8.00 ms | **5.25 ms** | **1.52x** |
| **small.json (0.55 KB)** | 4.8 µs | **3.6 µs** | **1.32x** |
| **twitter.json (0.62 MB)** | 3.53 ms | **2.93 ms** | **1.21x** |
<!-- mdformat on -->


#### Detailed Breakdown: JS Encode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | json_serializable | package:codable | Speedup vs json_serializable |
| :--- | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 8.00 ms | **2.50 ms** | **3.20x** |
| **canada.json (2.25 MB)** | 35.00 ms | **18.67 ms** | **1.87x** |
| **citm_catalog.json (1.73 MB)** | 8.75 ms | **3.92 ms** | **2.23x** |
| **small.json (0.55 KB)** | 19.9 µs | **2.3 µs** | **8.64x** |
| **twitter.json (0.62 MB)** | 3.54 ms | **2.90 ms** | **1.22x** |
<!-- mdformat on -->


------------------------------------------------------------------------

### 🎯 WASM Target Detailed Breakdown

#### Detailed Breakdown: WASM Decode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | json_serializable | package:codable | Speedup vs json_serializable |
| :--- | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 3.80 ms | **3.13 ms** | **1.21x** |
| **canada.json (2.25 MB)** | 65.10 ms | **14.42 ms** | **4.51x** |
| **citm_catalog.json (1.73 MB)** | 6.89 ms | **5.76 ms** | **1.20x** |
| **small.json (0.55 KB)** | 3.3 µs | **3.6 µs** | **0.94x** |
| **twitter.json (0.62 MB)** | 3.03 ms | **3.34 ms** | **0.91x** |
<!-- mdformat on -->


#### Detailed Breakdown: WASM Encode

<!-- mdformat off(prevent table wrapping) -->
| Workload / Dataset | json_serializable | package:codable | Speedup vs json_serializable |
| :--- | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 5.23 ms | **3.26 ms** | **1.60x** |
| **canada.json (2.25 MB)** | 24.10 ms | **25.53 ms** | **0.94x** |
| **citm_catalog.json (1.73 MB)** | 6.10 ms | **5.34 ms** | **1.14x** |
| **small.json (0.55 KB)** | 5.9 µs | **3.1 µs** | **1.88x** |
| **twitter.json (0.62 MB)** | 3.38 ms | **3.30 ms** | **1.02x** |
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

