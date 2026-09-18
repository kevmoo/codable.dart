# Cross-Language JSON Serialization Benchmark Report

**Host Hardware**: `kevmoo.c.googlers.com` (AMD EPYC 7B13, 64 logical cores, 117.9 GB RAM, Linux 6.18.14-1rodete4-amd64)  
**Audit Version**: `4.0-native-sdk-verified` (`2026-09-18T21:08:23Z`)  
**Target Codebases**: [`pkgs/codable`](file:///usr/local/google/home/kevmoo/github/kevmoo/codable.dart/pkgs/codable), [`pkgs/codable_builder`](file:///usr/local/google/home/kevmoo/github/kevmoo/codable.dart/pkgs/codable_builder), [`pkgs/codable_benchmarks`](file:///usr/local/google/home/kevmoo/github/kevmoo/codable.dart/pkgs/codable_benchmarks)  
**SDK Substrate**: Custom `dart-sdk` (`3.14.0-edge.8045fcd2294` with native C++ `JsonTokenWriter`, `JsonTokenReader`, `JsonKeyOptions`, PR #7 integer fast-path, and PR #8 IEEE-754 double fast-path escalations)  
**Raw Telemetry JSON**: [`doc/benchmarks/cross_language_benchmark_matrix.json`](file:///usr/local/google/home/kevmoo/github/kevmoo/codable.dart/doc/benchmarks/cross_language_benchmark_matrix.json) & [`json_compare_bench/results.json`](file:///usr/local/google/home/kevmoo/github/kevmoo/json_compare_bench/results.json)

---

## 1. Executive Summary

This report documents 100% locally measured and mathematically verified performance metrics of Dart's native serialization architecture (`package:codable` + `dart:convert` native kernels) compared against `package:json_serializable` (on both Stock Dart 3.12 and New Dart 3.14), native `dart:convert` (`jsonDecode`), Rust (`serde_json`), Go (`encoding/json`), Node.js (V8 C++ engine), and C++ (`simdjson`).

All benchmarks were compiled and executed natively on **`kevmoo.c.googlers.com`** (`taskset -c 16` single-core isolation) under identical system load to guarantee hardware, kernel, and memory bus consistency.

---

## 2. Multi-Language Macro Benchmark Matrix (`json_compare_bench`)

### 2.1 DECODE — Apples-to-Apples Typed Struct Matrix

Strongly-typed domain model deserialization (UTF-8 bytes -> Typed Structs). Each cell displays **Throughput (`MiB/s`)** and **Single-Pass Latency (`ms`/`µs`)**. Medals (🥇, 🥈, 🥉) rank the top 3 typed struct contenders per dataset.

<!-- mdformat off(prevent table wrapping) -->
| Dataset | Rust (`serde_json` Typed) | Go (`encoding/json` Typed) | Stock Dart + `json_serializable` (Typed) | New Dart + `json_serializable` (Typed) | New Dart + `package:codable` (Typed) | `codable` vs Stock `json_serializable` | `codable` vs Go `encoding/json` |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **`small.json`** (546 B) | 🥇 **383.4 MB/s (1.36 µs)** | 63.9 MB/s (8.15 µs) | 🥉 **174.0 MB/s (2.99 µs)** | 🥈 **177.9 MB/s (2.93 µs)** | 173.6 MB/s (3.00 µs) | **1.00x** | **2.72x** |
| **`twitter.json`** (616.7 KB) | 🥇 **465.9 MB/s (1.29 ms)** | 87.5 MB/s (6.88 ms) | 🥉 **195.6 MB/s (3.08 ms)** | 🥈 **204.8 MB/s (2.94 ms)** | 175.3 MB/s (3.44 ms) | **0.90x** | **2.00x** |
| **`citm_catalog.json`** (1.65 MB) | 🥇 **736.5 MB/s (2.24 ms)** | 83.3 MB/s (19.78 ms) | 🥉 **286.3 MB/s (5.75 ms)** | 274.8 MB/s (5.99 ms) | 🥈 **375.7 MB/s (4.38 ms)** | **1.31x** | **4.51x** |
| **`canada.json`** (2.15 MB) | 🥇 **436.9 MB/s (4.91 ms)** | 49.5 MB/s (43.40 ms) | 60.1 MB/s (35.72 ms) | 🥉 **78.0 MB/s (27.51 ms)** | 🥈 **190.8 MB/s (11.25 ms)** | **3.17x** | **3.86x** |
<!-- mdformat on -->

### 2.2 ENCODE — Apples-to-Apples Typed Struct Matrix

Strongly-typed domain model serialization (Typed Structs -> UTF-8 bytes). Each cell displays **Throughput (`MiB/s`)** and **Single-Pass Latency (`ms`/`µs`)**. Medals (🥇, 🥈, 🥉) rank the top 3 typed struct contenders per dataset.

<!-- mdformat off(prevent table wrapping) -->
| Dataset | Rust (`serde_json` Typed) | Go (`encoding/json` Typed) | Stock Dart + `json_serializable` (Typed) | New Dart + `json_serializable` (Typed) | New Dart + `package:codable` (Typed) | `codable` vs Stock `json_serializable` | `codable` vs Go `encoding/json` |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **`small.json`** (546 B) | 🥇 **940.2 MB/s (554 ns)** | 🥈 **398.1 MB/s (1.31 µs)** | 106.4 MB/s (4.89 µs) | 92.7 MB/s (5.62 µs) | 🥉 **297.1 MB/s (1.75 µs)** | **2.79x** | **0.75x** |
| **`twitter.json`** (616.7 KB) | 🥇 **1261.7 MB/s (477.34 µs)** | 🥈 **732.7 MB/s (821.99 µs)** | 114.0 MB/s (5.28 ms) | 188.6 MB/s (3.19 ms) | 🥉 **377.3 MB/s (1.60 ms)** | **3.31x** | **0.52x** |
| **`citm_catalog.json`** (1.65 MB) | 🥇 **2994.5 MB/s (550.09 µs)** | 🥈 **1291.5 MB/s (1.28 ms)** | 196.4 MB/s (8.39 ms) | 277.2 MB/s (5.94 ms) | 🥉 **594.2 MB/s (2.77 ms)** | **3.03x** | **0.46x** |
| **`canada.json`** (2.15 MB) | 🥇 **658.1 MB/s (3.26 ms)** | 🥈 **156.1 MB/s (13.75 ms)** | 48.5 MB/s (44.25 ms) | 🥉 **101.5 MB/s (21.15 ms)** | 88.3 MB/s (24.32 ms) | **1.82x** | **0.57x** |
<!-- mdformat on -->

### 2.3 DECODE — Complete Cross-Language Matrix (Typed Structs + Untyped DOM)

<!-- mdformat off(prevent table wrapping) -->
| Dataset | Rust (`serde_json` Typed) | Go (`encoding/json` Typed) | Node.js V8 (`Untyped JS Object`) | Stock Dart + `json_serializable` (`Typed`) | New Dart + `json_serializable` (`Typed`) | New Dart + `package:codable` (`Typed`) | Stock Dart `std_convert` (`Untyped Map/DOM`) | New Dart `std_convert` (`Untyped Map/DOM`) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **`small.json`** (546 B) | 🥇 **383.4 MB/s (1.36 µs)** | 63.9 MB/s (8.15 µs) | 🥈 **257.6 MB/s (2.02 µs)** | 174.0 MB/s (2.99 µs) | 177.9 MB/s (2.93 µs) | 173.6 MB/s (3.00 µs) | 204.5 MB/s (2.55 µs) | 🥉 **216.2 MB/s (2.41 µs)** |
| ↳ *% of Winner* | **100.0%** | 16.7% | 67.2% | 45.4% | 46.4% | 45.3% | 53.3% | 56.4% |
| **`twitter.json`** (616.7 KB) | 🥇 **465.9 MB/s (1.29 ms)** | 87.5 MB/s (6.88 ms) | 🥈 **421.1 MB/s (1.43 ms)** | 195.6 MB/s (3.08 ms) | 204.8 MB/s (2.94 ms) | 175.3 MB/s (3.44 ms) | 🥉 **235.8 MB/s (2.55 ms)** | 229.3 MB/s (2.63 ms) |
| ↳ *% of Winner* | **100.0%** | 18.8% | 90.4% | 42.0% | 44.0% | 37.6% | 50.6% | 49.2% |
| **`citm_catalog.json`** (1.65 MB) | 🥇 **736.5 MB/s (2.24 ms)** | 83.3 MB/s (19.78 ms) | 🥈 **476.3 MB/s (3.46 ms)** | 286.3 MB/s (5.75 ms) | 274.8 MB/s (5.99 ms) | 🥉 **375.7 MB/s (4.38 ms)** | 321.9 MB/s (5.12 ms) | 329.9 MB/s (4.99 ms) |
| ↳ *% of Winner* | **100.0%** | 11.3% | 64.7% | 38.9% | 37.3% | 51.0% | 43.7% | 44.8% |
| **`canada.json`** (2.15 MB) | 🥇 **436.9 MB/s (4.91 ms)** | 49.5 MB/s (43.40 ms) | 🥈 **227.8 MB/s (9.42 ms)** | 60.1 MB/s (35.72 ms) | 78.0 MB/s (27.51 ms) | 🥉 **190.8 MB/s (11.25 ms)** | 81.4 MB/s (26.37 ms) | 139.4 MB/s (15.40 ms) |
| ↳ *% of Winner* | **100.0%** | 11.3% | 52.1% | 13.8% | 17.9% | 43.7% | 18.6% | 31.9% |
<!-- mdformat on -->

### 2.4 ENCODE — Complete Cross-Language Matrix (Typed Structs + Untyped DOM)

<!-- mdformat off(prevent table wrapping) -->
| Dataset | Rust (`serde_json` Typed) | Go (`encoding/json` Typed) | Node.js V8 (`Untyped JS Object`) | Stock Dart + `json_serializable` (`Typed`) | New Dart + `json_serializable` (`Typed`) | New Dart + `package:codable` (`Typed`) | Stock Dart `std_convert` (`Untyped Map/DOM`) | New Dart `std_convert` (`Untyped Map/DOM`) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **`small.json`** (546 B) | 🥇 **940.2 MB/s (554 ns)** | 🥈 **398.1 MB/s (1.31 µs)** | 🥉 **349.3 MB/s (1.49 µs)** | 106.4 MB/s (4.89 µs) | 92.7 MB/s (5.62 µs) | 297.1 MB/s (1.75 µs) | 141.6 MB/s (3.68 µs) | 117.1 MB/s (4.45 µs) |
| ↳ *% of Winner* | **100.0%** | 42.3% | 37.1% | 11.3% | 9.9% | 31.6% | 15.1% | 12.5% |
| **`twitter.json`** (616.7 KB) | 🥇 **1261.7 MB/s (477.34 µs)** | 🥈 **732.7 MB/s (821.99 µs)** | 353.1 MB/s (1.71 ms) | 114.0 MB/s (5.28 ms) | 188.6 MB/s (3.19 ms) | 🥉 **377.3 MB/s (1.60 ms)** | 129.5 MB/s (4.65 ms) | 249.8 MB/s (2.41 ms) |
| ↳ *% of Winner* | **100.0%** | 58.1% | 28.0% | 9.0% | 14.9% | 29.9% | 10.3% | 19.8% |
| **`citm_catalog.json`** (1.65 MB) | 🥇 **2994.5 MB/s (550.09 µs)** | 🥈 **1291.5 MB/s (1.28 ms)** | 502.8 MB/s (3.28 ms) | 196.4 MB/s (8.39 ms) | 277.2 MB/s (5.94 ms) | 🥉 **594.2 MB/s (2.77 ms)** | 262.3 MB/s (6.28 ms) | 421.7 MB/s (3.91 ms) |
| ↳ *% of Winner* | **100.0%** | 43.1% | 16.8% | 6.6% | 9.3% | 19.8% | 8.8% | 14.1% |
| **`canada.json`** (2.15 MB) | 🥇 **658.1 MB/s (3.26 ms)** | 🥈 **156.1 MB/s (13.75 ms)** | 🥉 **122.6 MB/s (17.51 ms)** | 48.5 MB/s (44.25 ms) | 101.5 MB/s (21.15 ms) | 88.3 MB/s (24.32 ms) | 47.7 MB/s (44.98 ms) | 97.8 MB/s (21.95 ms) |
| ↳ *% of Winner* | **100.0%** | 23.7% | 18.6% | 7.4% | 15.4% | 13.4% | 7.3% | 14.9% |
<!-- mdformat on -->

---

## 3. Kostya 110.2 MB Macro Coordinate Benchmark Leaderboard

Measured natively on `/tmp/1.json` (115,076,895 bytes, 524,288 point records) via `ruby xtime.rb`:

<!-- mdformat off(prevent table wrapping) -->
| Rank | Implementation | Strategy / Architecture | Time (s) | Throughput (Decimal MB/s) | Throughput (Binary MiB/s) | Peak RSS (MB) | Slowdown vs 1st | RAM vs Baseline |
| :---: | :--- | :--- | :---: | :---: | :---: | :---: | :---: | :---: |
| 🥇 1 | **C++ (`simdjson` On-Demand)** | C++ SIMD Zero-Copy Token Stream | **0.118 s** | **972.8 MB/s** | 927.8 MiB/s | 173.7 MB | **1.00x** | 1.00x |
| 🥈 2 | **Rust (`serde_json` Pull/Custom)** | Rust Zero-Copy Pull Token Stream | **0.160 s** | **718.2 MB/s** | 684.9 MiB/s | **111.9 MB** | **1.36x** | **0.64x** |
| 🥉 3 | **Rust (`serde_json` Typed Struct)** | Rust Typed Zero-Allocation Struct | **0.169 s** | **680.6 MB/s** | 649.1 MiB/s | 123.7 MB | **1.43x** | 0.71x |
| 4 | **Dart AOT (`package:codable`)** | Dart Zero-Allocation Pull Reader | **0.564 s** | **203.9 MB/s** | 194.4 MiB/s | **119.7 MB** | **4.78x** | **0.69x** |
| 5 | **Node.js (v24.19 V8 C++)** | V8 C++ Engine `JSON.parse` | **0.567 s** | **203.0 MB/s** | 193.6 MiB/s | 443.9 MB | **4.81x** | 2.56x |
| 6 | **Go (`encoding/json`)** | Go Standard Library Reflection | **1.336 s** | **86.1 MB/s** | 82.1 MiB/s | 116.5 MB | **11.32x** | 0.67x |
| 7 | **Dart AOT (`dart:convert` Native)** | Standard `jsonDecode` + Dynamic Map | **1.439 s** | **79.9 MB/s** | 76.2 MiB/s | 554.0 MB | **12.19x** | 3.19x |
<!-- mdformat on -->
