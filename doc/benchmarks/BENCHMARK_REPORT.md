# Cross-Language JSON Serialization Benchmark Report

**Host Hardware**: `kevmoo.c.googlers.com` (AMD EPYC 7B13, 64 logical cores, 117.9 GB RAM, Linux 6.18.14-1rodete4-amd64)  
**Audit Version**: `4.1-clean-mergebase-audit` (`2026-09-19T00:08:58Z`)  
**Target Codebases**: [`pkgs/codable`](file:///usr/local/google/home/kevmoo/github/kevmoo/codable.dart/pkgs/codable), [`pkgs/codable_builder`](file:///usr/local/google/home/kevmoo/github/kevmoo/codable.dart/pkgs/codable_builder), [`pkgs/codable_benchmarks`](file:///usr/local/google/home/kevmoo/github/kevmoo/codable.dart/pkgs/codable_benchmarks)  
**SDK Substrates**:
- **Stock Baseline (`Tier 0 / Tier 2`)**: Merge-base SDK (`3.14.0-edge.5237faee608`, built from the exact fork parent commit)
- **New SDK (`Tier 1 / Tier 3`)**: Fork HEAD (`3.14.0-edge.8045fcd2294`, adding native `dart:convert` `JsonTokenReader`, `JsonUtf8TokenWriter`, `JsonKeyOptions`, 16-digit double fast-path, 32 KB stringifier buffers, and Eisel-Lemire float parser)  
**Raw Telemetry JSON**: [`doc/benchmarks/cross_language_benchmark_matrix.json`](file:///usr/local/google/home/kevmoo/github/kevmoo/codable.dart/doc/benchmarks/cross_language_benchmark_matrix.json) & [`json_compare_bench/results.json`](file:///usr/local/google/home/kevmoo/github/kevmoo/json_compare_bench/results.json)

---

## 1. Executive Summary

This report documents 100% locally measured and mathematically verified performance metrics of Dart's native serialization architecture (`package:codable` + `dart:convert` native kernels) compared against `package:json_serializable` (on both Stock merge-base `5237faee608` and New SDK `8045fcd2294`), native `dart:convert` (`jsonDecode`), Rust (`serde_json`), Go (`encoding/json`), Node.js (V8 C++ engine), and C++ (`simdjson`).

All benchmarks were compiled and executed serially on **`kevmoo.c.googlers.com`** (`taskset -c 2` single-core isolation) on an uncontended machine (`loadavg < 1.0`) to guarantee hardware, kernel, and memory bus consistency.

---

## 2. Multi-Language Macro Benchmark Matrix (`json_compare_bench`)

Direct throughput and latency comparisons across compiled native binaries on `kevmoo.c.googlers.com`:

### 2.1 DECODE Matrix

<!-- mdformat off(prevent table wrapping) -->
| Dataset | Rust (`serde_json` Typed) | Go (`encoding/json` Typed) | Stock Dart + `json_serializable` (Typed) | New Dart + `json_serializable` (Typed) | New Dart + `package:codable` (Typed) | Node.js V8 (`Untyped JS Object`) | New Dart `std_convert` (`Untyped Map/DOM`) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **`small.json`** (546 B) | 🥇 **419.1 MB/s (1.24 µs)** | 63.2 MB/s (8.24 µs) | 178.0 MB/s (2.93 µs) | 179.4 MB/s (2.90 µs) | 171.3 MB/s (3.04 µs) | 🥈 **253.8 MB/s (2.05 µs)** | 🥉 **208.6 MB/s (2.50 µs)** |
| **`twitter.json`** (616.7 KB) | 🥇 **455.7 MB/s (1.32 ms)** | 90.4 MB/s (6.67 ms) | 202.5 MB/s (2.97 ms) | 194.9 MB/s (3.09 ms) | 178.3 MB/s (3.38 ms) | 🥈 **434.6 MB/s (1.39 ms)** | 🥉 **221.8 MB/s (2.72 ms)** |
| **`citm_catalog.json`** (1.65 MB) | 🥇 **745.1 MB/s (2.21 ms)** | 81.8 MB/s (20.14 ms) | 284.7 MB/s (5.79 ms) | 281.9 MB/s (5.84 ms) | 🥉 **380.6 MB/s (4.33 ms)** | 🥈 **479.5 MB/s (3.43 ms)** | 332.4 MB/s (4.96 ms) |
| **`canada.json`** (2.15 MB) | 🥇 **416.1 MB/s (5.16 ms)** | 46.5 MB/s (46.12 ms) | 62.6 MB/s (34.29 ms) | 81.3 MB/s (26.40 ms) | 🥉 **193.6 MB/s (11.09 ms)** | 🥈 **225.6 MB/s (9.51 ms)** | 136.8 MB/s (15.69 ms) |
<!-- mdformat on -->

### 2.2 ENCODE Matrix

<!-- mdformat off(prevent table wrapping) -->
| Dataset | Rust (`serde_json` Typed) | Go (`encoding/json` Typed) | Stock Dart + `json_serializable` (Typed) | New Dart + `json_serializable` (Typed) | New Dart + `package:codable` (Typed) | Node.js V8 (`Untyped JS Object`) | New Dart `std_convert` (`Untyped Map/DOM`) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **`small.json`** (546 B) | 🥇 **927.8 MB/s (561 ns)** | 🥈 **392.9 MB/s (1.33 µs)** | 109.8 MB/s (4.74 µs) | 93.0 MB/s (5.60 µs) | 313.0 MB/s (1.66 µs) | 🥉 **352.7 MB/s (1.48 µs)** | 116.2 MB/s (4.48 µs) |
| **`twitter.json`** (616.7 KB) | 🥇 **1259.6 MB/s (478.13 µs)** | 🥈 **724.2 MB/s (831.63 µs)** | 113.5 MB/s (5.31 ms) | 201.5 MB/s (2.99 ms) | 🥉 **389.8 MB/s (1.54 ms)** | 356.3 MB/s (1.69 ms) | 255.2 MB/s (2.36 ms) |
| **`citm_catalog.json`** (1.65 MB) | 🥇 **2817.3 MB/s (584.66 µs)** | 🥈 **1290.4 MB/s (1.28 ms)** | 197.6 MB/s (8.34 ms) | 287.8 MB/s (5.72 ms) | 🥉 **579.9 MB/s (2.84 ms)** | 501.2 MB/s (3.29 ms) | 433.1 MB/s (3.80 ms) |
| **`canada.json`** (2.15 MB) | 🥇 **686.0 MB/s (3.13 ms)** | 🥈 **158.0 MB/s (13.59 ms)** | 47.0 MB/s (45.72 ms) | 99.2 MB/s (21.64 ms) | 89.6 MB/s (23.97 ms) | 🥉 **131.2 MB/s (16.36 ms)** | 97.9 MB/s (21.92 ms) |
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
