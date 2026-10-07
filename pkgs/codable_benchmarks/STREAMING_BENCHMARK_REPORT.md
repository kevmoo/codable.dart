## 🌊 Streaming Benchmark Report (`ChunkedConversionSink` / `ByteConversionSink`)

### 📝 Provenance

- **Run Timestamp**: <span data-live="timestamp">2026-10-02T04:23:46.670Z</span>
- **Stock Dart SDK (Tier 0 & Tier 2)**: <span data-live="stock_dart_version">3.14.0-271.0.dev (dev) (Fri Sep 25 05:03:10 2026 -0700) on "linux_x64"</span>
- **New Dart SDK (Tier 1 & Tier 3)**: <span data-live="dart_version">3.14.0-271.0.dev.json-next.b1e2a8de06b07a0f94b642773c585784a8e8a911 (dev) (Thu Oct 1 20:53:39 2026 -0700) on "linux_x64"</span>
- **Repo Commit**: <span data-live="commit">1927fe6d60f802d44798756449b2a8a56fe3f484</span>
- **Host OS**: <span data-live="os">linux</span>, Hostname: <span data-live="host">bluefin</span>
- **Trials**: <span data-live="trial_count">15</span> (reporting `median` latency)

### 🏛️ The 4 Dart Serialization Tiers

- **Tier 0 (`Stock Dart + json_serializable [Chunked Sink]`)**: Out-of-the-box status-quo baseline compiled & executed on unmodified Stock Dart (`utf8.decoder.fuse(json.decoder).startChunkedConversion` on 32 KB input chunks, and `json.encoder.fuse(utf8.encoder).startChunkedConversion` for output).
- **Tier 1 (`New Dart + json_serializable [Chunked Sink]`)**: Unmodified `json_serializable` chunked converter pipeline running on the upgraded `dart-sdk-json-next` SDK.
- **Tier 2 (`Stock Dart + Codable [Mock Substrate]`)**: `package:codable` running on unmodified Stock Dart (`JsonCodableDecoder.startChunkedConversion` accumulating 32 KB chunks into `BytesBuilder(copy: false)` for `_MockJsonTokenReader`, and `JsonCodableEncoder.startChunkedConversion` streaming 32 KB chunks via `JsonTokenWriter.toSink`).
- **Tier 3 (`New Dart + Codable [Native Substrate]`)**: Full end-to-end streaming stack (`package:codable` + `dart:convert` Layer 1 native `JsonTokenReader` / `JsonUtf8TokenWriter` chunked sink substrate).

### 📊 3-Runtime Summary (4-Tier Relative Efficiency & GeoMean Speedups)

<!-- bench-stream:stream-runtime-summary:start src="benchmark_results.json#benchmarks" -->

| Target Runtime | Tier / Configuration | 📥 Decode Efficiency<br/>[ Worst / GeoMean / Best ] | 📥 Decode GeoMean<br/>(vs Tier 0 / vs Tier 1) | 📤 Encode Efficiency<br/>[ Worst / GeoMean / Best ] | 📤 Encode GeoMean<br/>(vs Tier 0 / vs Tier 1) |
| :--- | :--- | :---: | :---: | :---: | :---: |
| **AOT (`dart compile exe`)** | **Tier 0: `Stock + json_serial`** | 🔴 `[ 24 / 36 / 54 ]` | **1.00x** / **0.85x** | 🔴 `[ 22 / 28 / 35 ]` | **1.00x** / **0.39x** |
| **AOT (`dart compile exe`)** | **Tier 1: `New + json_serial`** | 🔴 `[ 33 / 43 / 55 ]` | **1.17x** / **1.00x** | 🟡 `[ 51 / 72 / 100 ]` | **2.59x** / **1.00x** |
| **AOT (`dart compile exe`)** | **Tier 2: `Stock + Codable [Mock]`** | 🔴 `[ 64 / 67 / 71 ]` | **1.86x** / **1.59x** | 🟡 `[ 77 / 87 / 100 ]` | **3.17x** / **1.22x** |
| **AOT (`dart compile exe`)** | **Tier 3: `New + Codable [Native]`** | 🟢 `[ 100 / 100 / 100 ]` | **2.76x** / **2.35x** | 🟡 `[ 77 / 87 / 99 ]` | **3.16x** / **1.22x** |
| **JS (`dart2js` / Node 24 / V8)** | **Tier 0: `Stock + json_serial`** | 🔴 `[ 26 / 32 / 39 ]` | **1.00x** / **1.01x** | 🔴 `[ 54 / 62 / 71 ]` | **1.00x** / **0.72x** |
| **JS (`dart2js` / Node 24 / V8)** | **Tier 1: `New + json_serial`** | 🔴 `[ 26 / 32 / 38 ]` | **0.99x** / **1.00x** | 🟡 `[ 73 / 85 / 100 ]` | **1.39x** / **1.00x** |
| **JS (`dart2js` / Node 24 / V8)** | **Tier 2: `Stock + Codable [Mock]`** | 🟢 `[ 96 / 98 / 100 ]` | **3.04x** / **3.07x** | 🟡 `[ 58 / 76 / 99 ]` | **1.24x** / **0.89x** |
| **JS (`dart2js` / Node 24 / V8)** | **Tier 3: `New + Codable [Native]`** | 🟢 `[ 99 / 99 / 100 ]` | **3.09x** / **3.12x** | 🟡 `[ 58 / 76 / 100 ]` | **1.23x** / **0.89x** |
| **WASM (`dart2wasm` / Node 24 / V8)** | **Tier 0: `Stock + json_serial`** | 🔴 `[ 25 / 41 / 66 ]` | **1.00x** / **0.84x** | 🔴 `[ 33 / 38 / 44 ]` | **1.00x** / **0.48x** |
| **WASM (`dart2wasm` / Node 24 / V8)** | **Tier 1: `New + json_serial`** | 🔴 `[ 34 / 48 / 69 ]` | **1.19x** / **1.00x** | 🟡 `[ 63 / 79 / 100 ]` | **2.07x** / **1.00x** |
| **WASM (`dart2wasm` / Node 24 / V8)** | **Tier 2: `Stock + Codable [Mock]`** | 🔴 `[ 55 / 59 / 62 ]` | **1.44x** / **1.21x** | 🟡 `[ 77 / 88 / 100 ]` | **2.28x** / **1.10x** |
| **WASM (`dart2wasm` / Node 24 / V8)** | **Tier 3: `New + Codable [Native]`** | 🟢 `[ 100 / 100 / 100 ]` | **2.47x** / **2.07x** | 🟡 `[ 78 / 88 / 100 ]` | **2.30x** / **1.11x** |

<!-- bench-stream:stream-runtime-summary:end -->

> **Scoring Metric**: **Relative Throughput Efficiency** (`100` = Peak Speed across all measured tiers). Calculated as `round((MinLatency / Latency) * 100)` per workload, aggregated across benchmarks using the **Geometric Mean** (Fleming & Wallace 1986).
> - **`[ Worst / GeoMean / Best ]`**: Range from lowest score (worst workload) to the geometric mean and peak dataset score
>   across the active canonical benchmarks.
> - **Badges**: 🥇 Peak across all workloads (`100`) • 🟢 `≥ 90` (Within 10% of peak) • 🟡 `70–89` (Good / moderate) • 🔴 `< 70` (Significant performance gap).

------------------------------------------------------------------------

### 🎛️ Measurement Controls & Resolution Floor

These diagnostics bound how much of the tables above is signal. Read them before crediting any ratio.

<!-- bench-stream:stream-decode-control:start src="benchmark_results.json#benchmarks" -->

| Target Runtime | Decode Control Drift (Tier 1 / Tier 0) | Per-Dataset Control Ratios |
| :--- | :---: | :--- |
| **AOT** | **0.995x** | `[0.992, 0.998]` |
| **JS** | **0.993x** | `[0.985, 1.000]` |
| **WASM** | **0.983x** | `[1.016, 0.952]` |

<!-- bench-stream:stream-decode-control:end -->

<!-- bench-stream:stream-encode-control:start src="benchmark_results.json#benchmarks" -->

| Target Runtime | Encode Control Drift (Tier 1 / Tier 0) | Per-Dataset Control Ratios |
| :--- | :---: | :--- |
| **AOT** | N/A | N/A |
| **JS** | N/A | N/A |
| **WASM** | N/A | N/A |

<!-- bench-stream:stream-encode-control:end -->

> **Decode control**: `json_serializable_literal` calls `jsonDecode(String)` plus `.fromJson()` hydration. On AOT and JS the fork alters only the UTF-8 *byte* parser (`_JsonUtf8Parser`), leaving this String path source-identical.
>
> **Encode control**: `utf8_encode_control` calls `utf8.encode(String)`. There is no JSON encode path that is source-identical across the two SDKs — the fork relocates `JsonEncoder`, `_JsonEncoderSink` and `_JsonStringStringifier` out of `json.dart` — so the encode control must be a non-JSON codec. `sdk/lib/convert/utf8.dart` is untouched and no `convert_patch.dart` references `_Utf8Encoder`.
>
> **Codebase Layout Collateral**: The source on those paths is identical in both SDKs. However, because SDK forks often relocate hundreds of lines across libraries (e.g., into `dart:_internal`), measurements may drift due to snapshot alignment and cross-library code layout shifts underneath the control. A moving control is NOT by itself proof of a contaminated run — rather, its ratio bounds **layout collateral + environmental noise**.
>
> ⚠️ **Actionable Rule: Compare each cell against its own runtime's control band, never a pooled band.** Control spread is not a fixed property of a backend, and it does not necessarily track how much of that backend the fork edited — a run in which the least-edited backend shows the widest spread and the most-edited the narrowest is evidence of apparatus noise rather than of the patch. Re-derive the band per runtime from the current run instead of carrying numbers forward from a previous one, and treat per-tier maxima from small samples as weak statistics.
>
> **Which comparisons the control actually bounds.** Tier 0 and Tier 2 run on the stock `dart` binary; Tier 1 and Tier 3 run on the fork binary. Two binaries cannot share a process, so per-build and per-process bias falls entirely on the **cross-pass** ratios — *Tier 1 vs Tier 0*, *Tier 3 vs Tier 0*, and any Tier 2 vs Tier 1/3 comparison. It **cancels** in the **same-pass** ratios: *Tier 3 vs Tier 1* (both fork) and *Tier 2 vs Tier 0* (both stock). Do not discount same-pass figures on control-drift grounds.
>
> **Sample stability**: <span data-live="stream_unstable_cells">15</span> of <span data-live="stream_total_cells">72</span> measured cells (<span data-live="stream_unstable_pct">21%</span>) are flagged `is_robust_stable: false` by the harness. Ratios involving them are marked ⚠️ in the breakdowns below and must not be quoted as measurements.

### 🎯 AOT Target Detailed Breakdown

#### Detailed Breakdown: AOT Decode Stream (32 KB Chunks)

<!-- bench-stream:aot-decode-stream:start src="benchmark_results.json#benchmarks" -->

| Workload / Dataset | Tier 0: Stock + json_serial | Tier 1: New + json_serial | Tier 2: Stock + Codable [Mock] | Tier 3: New + Codable [Native] | Tier 1 vs Tier 0 (SDK + Substrate Build) | Tier 2 vs Tier 0 (Codable on Stock) | Speedup vs Tier 0 (Stock json_serial) | Speedup vs Tier 1 (New json_serial) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 2.22 ms | 2.17 ms | 1.70 ms | **1.20 ms** | **1.02x** | **1.31x** | **1.85x** | **1.81x** |
| **canada.json (2.25 MB)** | 28.25 ms | 21.02 ms | 10.69 ms | **6.88 ms** | **1.34x** ⚠️ | **2.64x** ⚠️ | **4.11x** ⚠️ | **3.05x** ⚠️ |
| **Geometric Mean** | — | — | — | — | **1.17x** | **1.86x** | **2.76x** | **2.35x** |

<!-- bench-stream:aot-decode-stream:end -->

> ⚠️ <span data-live="aot-decode-stream-unstable">1</span> of <span data-live="aot-decode-stream-datasets">2</span> workloads in this table draw on samples flagged `is_robust_stable: false`. The Geometric Mean includes them and inherits their uncertainty.


#### Detailed Breakdown: AOT Encode Stream (BytesBuilder / ByteConversionSink)

<!-- bench-stream:aot-encode-stream:start src="benchmark_results.json#benchmarks" -->

| Workload / Dataset | Tier 0: Stock + json_serial | Tier 1: New + json_serial | Tier 2: Stock + Codable [Mock] | Tier 3: New + Codable [Native] | Tier 1 vs Tier 0 (SDK + Substrate Build) | Tier 2 vs Tier 0 (Codable on Stock) | Speedup vs Tier 0 (Stock json_serial) | Speedup vs Tier 1 (New json_serial) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 4.88 ms | 2.05 ms | 1.05 ms | **1.06 ms** | **2.38x** | **4.65x** | **4.58x** | **1.92x** |
| **canada.json (2.25 MB)** | 23.91 ms | 8.48 ms | 11.08 ms | **10.97 ms** | **2.82x** | **2.16x** | **2.18x** | **0.77x** |
| **Geometric Mean** | — | — | — | — | **2.59x** | **3.17x** | **3.16x** | **1.22x** |

<!-- bench-stream:aot-encode-stream:end -->


------------------------------------------------------------------------

### 🎯 JS Target Detailed Breakdown

#### Detailed Breakdown: JS Decode Stream (32 KB Chunks)

<!-- bench-stream:js-decode-stream:start src="benchmark_results.json#benchmarks" -->

| Workload / Dataset | Tier 0: Stock + json_serial | Tier 1: New + json_serial | Tier 2: Stock + Codable [Mock] | Tier 3: New + Codable [Native] | Tier 1 vs Tier 0 (SDK + Substrate Build) | Tier 2 vs Tier 0 (Codable on Stock) | Speedup vs Tier 0 (Stock json_serial) | Speedup vs Tier 1 (New json_serial) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 3.88 ms | 3.96 ms | 1.59 ms | **1.52 ms** | **0.98x** | **2.45x** | **2.55x** | **2.60x** |
| **canada.json (2.25 MB)** | 32.67 ms | 32.67 ms | 8.64 ms | **8.73 ms** | **1.00x** | **3.78x** ⚠️ | **3.74x** ⚠️ | **3.74x** ⚠️ |
| **Geometric Mean** | — | — | — | — | **0.99x** | **3.04x** | **3.09x** | **3.12x** |

<!-- bench-stream:js-decode-stream:end -->

> ⚠️ <span data-live="js-decode-stream-unstable">1</span> of <span data-live="js-decode-stream-datasets">2</span> workloads in this table draw on samples flagged `is_robust_stable: false`. The Geometric Mean includes them and inherits their uncertainty.


#### Detailed Breakdown: JS Encode Stream (BytesBuilder / ByteConversionSink)

<!-- bench-stream:js-encode-stream:start src="benchmark_results.json#benchmarks" -->

| Workload / Dataset | Tier 0: Stock + json_serial | Tier 1: New + json_serial | Tier 2: Stock + Codable [Mock] | Tier 3: New + Codable [Native] | Tier 1 vs Tier 0 (SDK + Substrate Build) | Tier 2 vs Tier 0 (Codable on Stock) | Speedup vs Tier 0 (Stock json_serial) | Speedup vs Tier 1 (New json_serial) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 4.95 ms | 3.65 ms | 2.68 ms | **2.66 ms** | **1.35x** | **1.85x** | **1.86x** | **1.37x** |
| **canada.json (2.25 MB)** | 17.00 ms | 12.00 ms | 20.60 ms | **20.80 ms** | **1.42x** | **0.83x** | **0.82x** | **0.58x** |
| **Geometric Mean** | — | — | — | — | **1.39x** | **1.24x** | **1.23x** | **0.89x** |

<!-- bench-stream:js-encode-stream:end -->


------------------------------------------------------------------------

### 🎯 WASM Target Detailed Breakdown

#### Detailed Breakdown: WASM Decode Stream (32 KB Chunks)

<!-- bench-stream:wasm-decode-stream:start src="benchmark_results.json#benchmarks" -->

| Workload / Dataset | Tier 0: Stock + json_serial | Tier 1: New + json_serial | Tier 2: Stock + Codable [Mock] | Tier 3: New + Codable [Native] | Tier 1 vs Tier 0 (SDK + Substrate Build) | Tier 2 vs Tier 0 (Codable on Stock) | Speedup vs Tier 0 (Stock json_serial) | Speedup vs Tier 1 (New json_serial) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 2.45 ms | 2.33 ms | 2.59 ms | **1.62 ms** | **1.05x** | **0.95x** | **1.52x** | **1.44x** |
| **canada.json (2.25 MB)** | 39.29 ms | 29.20 ms | 17.81 ms | **9.79 ms** | **1.35x** ⚠️ | **2.21x** ⚠️ | **4.01x** ⚠️ | **2.98x** ⚠️ |
| **Geometric Mean** | — | — | — | — | **1.19x** | **1.44x** | **2.47x** | **2.07x** |

<!-- bench-stream:wasm-decode-stream:end -->

> ⚠️ <span data-live="wasm-decode-stream-unstable">1</span> of <span data-live="wasm-decode-stream-datasets">2</span> workloads in this table draw on samples flagged `is_robust_stable: false`. The Geometric Mean includes them and inherits their uncertainty.


#### Detailed Breakdown: WASM Encode Stream (BytesBuilder / ByteConversionSink)

<!-- bench-stream:wasm-encode-stream:start src="benchmark_results.json#benchmarks" -->

| Workload / Dataset | Tier 0: Stock + json_serial | Tier 1: New + json_serial | Tier 2: Stock + Codable [Mock] | Tier 3: New + Codable [Native] | Tier 1 vs Tier 0 (SDK + Substrate Build) | Tier 2 vs Tier 0 (Codable on Stock) | Speedup vs Tier 0 (Stock json_serial) | Speedup vs Tier 1 (New json_serial) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **10k Coordinates (0.39 MB)** | 4.96 ms | 2.61 ms | 1.65 ms | **1.65 ms** | **1.90x** | **3.00x** | **3.01x** | **1.58x** |
| **canada.json (2.25 MB)** | 24.40 ms | 10.81 ms | 14.02 ms | **13.82 ms** | **2.26x** | **1.74x** | **1.77x** | **0.78x** |
| **Geometric Mean** | — | — | — | — | **2.07x** | **2.28x** | **2.30x** | **1.11x** |

<!-- bench-stream:wasm-encode-stream:end -->


------------------------------------------------------------------------

### 🔄 Streaming vs. Monolithic Single-Buffer Overhead (`Stream / Sink` vs. `Single Buffer`)

Compares the chunked conversion sink latency (`32 KB` slices) against the in-memory single-buffer latency (`Stream Latency / Monolithic Latency`; `1.00x` = zero streaming overhead, `< 1.00x` = streaming is faster than monolithic allocation).

<!-- bench-stream:stream-vs-mono:start src="benchmark_results.json#benchmarks" -->

| Target | Mode & Dataset | Tier 0 Ratio (Stream / Mono) | Tier 1 Ratio (Stream / Mono) | Tier 2 Ratio (Stream / Mono) | Tier 3 Ratio (Stream / Mono) |
| :--- | :--- | :---: | :---: | :---: | :---: |
| **AOT** | 📥 Decode `10k Coordinates (0.39 MB)` | `1.03x` (2.22 ms vs 2.17 ms) | `1.01x` (2.17 ms vs 2.15 ms) | `1.00x` (1.70 ms vs 1.70 ms) | **`1.00x` (1.20 ms vs 1.20 ms)** |
| **AOT** | 📥 Decode `canada.json (2.25 MB)` | `0.93x` (28.25 ms vs 30.51 ms) | `0.98x` (21.02 ms vs 21.39 ms) | `1.03x` (10.69 ms vs 10.37 ms) | **`1.08x` (6.88 ms vs 6.36 ms)** |
| **AOT** | 📤 Encode `10k Coordinates (0.39 MB)` | `0.90x` (4.88 ms vs 5.43 ms) | `0.77x` (2.05 ms vs 2.65 ms) | `0.64x` (1.05 ms vs 1.63 ms) | **`0.71x` (1.06 ms vs 1.49 ms)** |
| **AOT** | 📤 Encode `canada.json (2.25 MB)` | `0.85x` (23.91 ms vs 28.09 ms) | `0.80x` (8.48 ms vs 10.60 ms) | `0.80x` (11.08 ms vs 13.82 ms) | **`0.79x` (10.97 ms vs 13.91 ms)** |
| **JS** | 📥 Decode `10k Coordinates (0.39 MB)` | `1.51x` (3.88 ms vs 2.56 ms) | `1.54x` (3.96 ms vs 2.56 ms) | `1.05x` (1.59 ms vs 1.51 ms) | **`1.01x` (1.52 ms vs 1.51 ms)** |
| **JS** | 📥 Decode `canada.json (2.25 MB)` | `1.34x` (32.67 ms vs 24.33 ms) | `1.34x` (32.67 ms vs 24.33 ms) | `1.00x` (8.64 ms vs 8.62 ms) | **`1.01x` (8.73 ms vs 8.67 ms)** |
| **JS** | 📤 Encode `10k Coordinates (0.39 MB)` | `1.06x` (4.95 ms vs 4.67 ms) | `1.00x` (3.65 ms vs 3.64 ms) | `1.67x` (2.68 ms vs 1.60 ms) | **`1.59x` (2.66 ms vs 1.67 ms)** |
| **JS** | 📤 Encode `canada.json (2.25 MB)` | `0.90x` (17.00 ms vs 18.80 ms) | `0.94x` (12.00 ms vs 12.75 ms) | `1.63x` (20.60 ms vs 12.63 ms) | **`1.65x` (20.80 ms vs 12.63 ms)** |
| **WASM** | 📥 Decode `10k Coordinates (0.39 MB)` | `1.03x` (2.45 ms vs 2.37 ms) | `1.02x` (2.33 ms vs 2.28 ms) | `0.97x` (2.59 ms vs 2.66 ms) | **`1.00x` (1.62 ms vs 1.63 ms)** |
| **WASM** | 📥 Decode `canada.json (2.25 MB)` | `0.99x` (39.29 ms vs 39.69 ms) | `0.99x` (29.20 ms vs 29.51 ms) | `1.01x` (17.81 ms vs 17.55 ms) | **`1.05x` (9.79 ms vs 9.32 ms)** |
| **WASM** | 📤 Encode `10k Coordinates (0.39 MB)` | `0.92x` (4.96 ms vs 5.37 ms) | `0.91x` (2.61 ms vs 2.87 ms) | `0.82x` (1.65 ms vs 2.02 ms) | **`0.84x` (1.65 ms vs 1.96 ms)** |
| **WASM** | 📤 Encode `canada.json (2.25 MB)` | `0.95x` (24.40 ms vs 25.72 ms) | `0.86x` (10.81 ms vs 12.62 ms) | `0.82x` (14.02 ms vs 17.15 ms) | **`0.81x` (13.82 ms vs 16.96 ms)** |

<!-- bench-stream:stream-vs-mono:end -->

------------------------------------------------------------------------

### 🔬 Methodology & Caveats

- Every cell is the **median** of the trial count listed in the provenance
  header.
  - **Tier 0 (`Stock Dart + json_serializable`)** and **Tier 2 (`Stock Dart + Codable [Mock]`)** are compiled and executed in a dedicated Stock Dart pass with `substrate.dart` switched to `mock`.
  - **Tier 1 (`New Dart + json_serializable`)** and **Tier 3 (`New Dart + Codable [Native]`)** are compiled and executed in the `native_kernels` pass with `substrate.dart` switched to `native`.
- **Use `median`, not `min`.** `min` reports whichever configuration drew the
  single luckiest trial. On multimodal workloads that is enough to flip the
  sign of a comparison, so `--metric median` is the default. Regenerating this
  report with `--metric min` is a diagnostic, not a publication.
- **`Tier 1 vs Tier 0` is not an SDK-only comparison.** The two passes differ by
  SDK *and* by substrate build (`mock` vs `native`), because the native
  substrate re-exports symbols that only exist in the forked SDK and cannot be
  compiled by stock Dart. The binaries therefore differ in retained code and
  layout even for candidates that never call the substrate. Read that column as
  *SDK + build configuration*, never as an isolated SDK delta.
- **Stability gate**: cells the harness flagged `is_robust_stable: false` have
  their derived ratios marked ⚠️. A marked ratio is not a measurement. See the
  *Measurement Controls & Resolution Floor* section for the run-wide count and
  the unchanged-code control drift.
- **Dual Speedup Baselines**:
  - **Speedup vs Tier 0 (`Stock Dart + json_serializable`)**: Measures total end-to-end speedup over out-of-the-box Stock Dart.
  - **Speedup vs Tier 1 (`New Dart + json_serializable`)**: Measures the isolated streaming vs. DOM mapping speedup on the identical upgraded SDK.
- **Resolution limit**: at 10–15 trials this harness cannot reliably resolve
  latency deltas below roughly **10%**. Run-to-run drift is large enough to
  flip the sign of small effects. Treat any speedup between `0.90x` and
  `1.10x` as *no measured difference*.
- **Single invocation**: every cell comes from one process launch. Workloads
  whose launch-to-launch distribution is multimodal cannot be resolved at any
  estimator from a single invocation; they need repeated launches with a
  median-of-medians aggregate.

