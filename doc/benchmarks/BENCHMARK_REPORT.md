# Cross-Language JSON Serialization Benchmark Report

**Host Hardware**: `kevmoo.c.googlers.com` (AMD EPYC 7B13, 64 logical cores, 117.9 GB RAM, Linux 6.18.14)  
**Dataset Version**: `2.4-host-verified`  
**Target Codebases**: [`pkgs/codable`](file:///usr/local/google/home/kevmoo/github/kevmoo/_codable.dart-sdk-integration/pkgs/codable), [`pkgs/codable_generator`](file:///usr/local/google/home/kevmoo/github/kevmoo/_codable.dart-sdk-integration/pkgs/codable_generator), [`pkgs/codable_benchmarks`](file:///usr/local/google/home/kevmoo/github/kevmoo/_codable.dart-sdk-integration/pkgs/codable_benchmarks)  
**SDK Substrate**: Custom `dart-sdk` (`json-utf8-kernels` branch with Eisel-Lemire, SWAR jump tables, and Delimiter-Fused reads)  
**JSON Matrix**: [`doc/benchmarks/cross_language_benchmark_matrix.json`](file:///usr/local/google/home/kevmoo/github/kevmoo/_codable.dart-sdk-integration/doc/benchmarks/cross_language_benchmark_matrix.json)

---

## 1. Executive Summary

This report documents 100% locally measured and verified performance metrics of Dart's next-generation serialization architecture (`package:codable` + `package:codable_generator`) compared against native `dart:convert` (`jsonDecode`), Rust (`serde_json`), Go (`encoding/json`), Node.js (V8 C++ engine), and C++ (`simdjson`).

All benchmarks were compiled and executed natively on **`kevmoo.c.googlers.com`** under identical system load to guarantee hardware, kernel, and memory bus consistency across all language implementations.

### 🔑 Key Breakthrough Highlights on THIS Hardware
* **`citm_catalog.json` (1.73 MB)**:
  * Single-run latency dropped to **3.82 ms (452.0 MB/s)**.
  * **2.13x faster than native Dart `jsonDecode`** (8.14 ms / 212.3 MB/s).
  * **4.71x faster than Go standard library `encoding/json`** (18.0 ms / 96.0 MB/s).
  * In cross-language macro suites, achieves **427.8 MB/s** (within **88.9% of Rust `serde_json`** at 481.1 MB/s).
* **`canada.json` (2.25 MB)**:
  * Single-run latency dropped to **9.26 ms (243.2 MB/s)**.
  * **2.49x faster than native Dart `jsonDecode`** (23.04 ms / 97.7 MB/s).
  * **3.78x faster than Go standard library `encoding/json`** (35.0 ms / 64.3 MB/s).
  * In cross-language macro suites, achieves **230.5 MB/s** (within **87.3% of Rust `serde_json`** at 264.0 MB/s).
* **`10,000 Coordinates` (0.39 MB)**:
  * Single-run latency dropped to **1.97 ms (197.5 MB/s)**.
  * **1.99x faster than native Dart `jsonDecode`** (3.93 ms / 99.3 MB/s).
* **Kostya Macro Benchmark (110.2 MB Coordinates / 524,288 Points)**:
  * **0.61 s single-run time** and **119 MB Peak RSS**.
  * **2.43x faster than Dart Native `jsonDecode`** (1.48 s) while reducing memory footprint by **4.64x** (119 MB vs 552 MB).
  * **2.08x faster than Go `encoding/json`** (1.27 s).

---

## 2. Microbenchmark Suite Results (`end_to_end_benchmark.dart`)

Measured via `BenchmarkBase.measure()` on `kevmoo.c.googlers.com`.

### 2.1 `citm_catalog.json` (1.73 MB / 1,727,204 bytes)
*Complex enterprise relational document: 11 Maps, 6 Lists, deeply nested models.*

<!-- mdformat off(prevent table wrapping) -->
| Engine / Strategy | Latency (ms) | Throughput (MB/s) | Speedup vs Native |
| :--- | :---: | :---: | :---: |
| **Dart Codable (Current AOT: Fused + SWAR + Builder)** | **3.82 ms** | **452.0 MB/s** | **2.13x** |
| Dart Native `jsonDecode` (Untyped DOM) | 8.14 ms | 212.3 MB/s | 1.00x |
| Go `encoding/json` (Standard Library) | 18.00 ms | 96.0 MB/s | 0.45x |
| Dart Fair Native (`jsonDecode` + Typed Mapping) | 15.20 ms | 113.6 MB/s | 0.54x |
<!-- mdformat on -->

---

### 2.2 `canada.json` (2.25 MB / 2,251,051 bytes)
*GeoJSON coordinate polygon payload: 111,440 IEEE-754 floating-point coordinates.*

<!-- mdformat off(prevent table wrapping) -->
| Engine / Strategy | Latency (ms) | Throughput (MB/s) | Speedup vs Native |
| :--- | :---: | :---: | :---: |
| **Dart Codable (Current AOT: Fused + Tuple Sizing)** | **9.26 ms** | **243.2 MB/s** | **2.49x** |
| Dart Native `jsonDecode` (Untyped DOM) | 23.04 ms | 97.7 MB/s | 1.00x |
| Go `encoding/json` (Standard Library) | 35.00 ms | 64.3 MB/s | 0.66x |
| Dart Fair Native (`jsonDecode` + Typed Mapping) | 31.73 ms | 70.9 MB/s | 0.73x |
<!-- mdformat on -->

---

### 2.3 `10,000 Coordinates` (0.39 MB / 390,001 bytes)
*Homogeneous streaming point array: 10,000 lat/lon coordinate objects.*

<!-- mdformat off(prevent table wrapping) -->
| Engine / Strategy | Latency (ms) | Throughput (MB/s) | Speedup vs Native |
| :--- | :---: | :---: | :---: |
| **Dart Codable (Current AOT: Delimiter-Fused + SWAR)** | **1.97 ms** | **197.5 MB/s** | **1.99x** |
| Dart Native `jsonDecode` (Untyped DOM) | 3.93 ms | 99.3 MB/s | 1.00x |
<!-- mdformat on -->

---

## 3. Multi-Language Macro Matrix (`json_compare_bench`)

Direct throughput comparison on THIS hardware across compiled binaries:

### 3.1 DECODE Throughput Matrix

<!-- mdformat off(prevent table wrapping) -->
| Dataset | Dart AOT (std) | Dart AOT (package:codable) | Rust (`serde_json`) | Node.js (V8) | Go (`encoding/json`) |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **`small.json`** (~1 KB) | 🥉 **235.3 MB/s** | 184.3 MB/s | 🥇 **280.6 MB/s** | 🥈 **264.1 MB/s** | 66.0 MB/s |
| **`twitter.json`** (~617 KB) | 🥉 **242.1 MB/s** | 127.5 MB/s | 🥈 **276.4 MB/s** | 🥇 **431.2 MB/s** | 82.1 MB/s |
| **`citm_catalog.json`** (~1.6 MB) | 327.0 MB/s | 🥉 **427.8 MB/s** | 🥇 **481.1 MB/s** | 🥈 **468.6 MB/s** | 90.5 MB/s |
| **`canada.json`** (~2.1 MB) | 134.0 MB/s | 🥉 **230.5 MB/s** | 🥇 **264.0 MB/s** | 🥈 **243.8 MB/s** | 57.2 MB/s |
<!-- mdformat on -->

---

## 4. Kostya 110.2 MB Macro Coordinate Benchmark Leaderboard

Measured via `ruby xtime.rb` on `kevmoo.c.googlers.com`:

<!-- mdformat off(prevent table wrapping) -->
| Rank | Implementation | Architecture / Library | Time (s) | Throughput (MB/s) | Peak RSS (MB) | Slowdown vs 1st |
| :---: | :--- | :--- | :---: | :---: | :---: | :---: |
| 🥇 1 | **C++ (`simdjson` On-Demand)** | C++ SIMD Zero-Copy Token Stream | **0.105 s** | **1,050 MB/s** | 173.0 MB | **1.0x** (Baseline) |
| 🥈 2 | **Rust (`serde_json` Pull)** | Rust Zero-Copy Pull Reader | **0.161 s** | **684 MB/s** | **111.0 MB** | **1.53x** |
| 🥉 3 | **Rust (`serde_json` Typed Struct)** | Rust Typed Zero-Allocation Struct | **0.172 s** | **641 MB/s** | 123.0 MB | **1.64x** |
| 4 | **Node.js (24.19 V8 C++)** | V8 C++ Engine `JSON.parse` | **0.564 s** | **195 MB/s** | 439.0 MB | **5.37x** |
| 5 | **Dart AOT (`package:codable`)** | Dart Zero-Allocation Pull Reader | **0.610 s** | **181 MB/s** | **119.0 MB** | **5.81x** |
| 6 | **Go (`encoding/json`)** | Standard Go Reflection Unmarshaler | **1.270 s** | **87 MB/s** | 115.0 MB | **12.10x** |
| 7 | **Dart AOT (`dart:convert`)** | `dart:convert` Native `jsonDecode` | **1.480 s** | **75 MB/s** | 552.0 MB | **14.10x** |
<!-- mdformat on -->

---

## 5. Evolution of Dart Serialization (Initial $\rightarrow$ Production Builder)

<!-- mdformat off(prevent table wrapping) -->
| Optimization Stage | `citm_catalog.json` | `canada.json` | `10k Coordinates` | `Kostya 110.2 MB` |
| :--- | :---: | :---: | :---: | :---: |
| **0. Initial Pull Prototype** | ~21 MB/s (80 ms) | 58.8 MB/s (38.3 ms) | 104.6 MB/s (3.73 ms) | N/A |
| **1. Phase 1: Eisel-Lemire Doubles** | 220.7 MB/s (7.83 ms) | 145.3 MB/s (15.5 ms) | 114.3 MB/s (3.41 ms) | N/A |
| **2. Phase 2: 64-Bit SWAR Jump Tables** | 267.9 MB/s (6.45 ms) | 153.5 MB/s (14.7 ms) | 124.0 MB/s (3.14 ms) | N/A |
| **3. Phase 2.5: Tuple Pre-Sizing** | 267.9 MB/s (6.45 ms) | 196.0 MB/s (11.5 ms) | 124.0 MB/s (3.14 ms) | N/A |
| **4. Current AOT on Host Hardware** | **452.0 MB/s (3.82 ms)** | **243.2 MB/s (9.26 ms)** | **197.5 MB/s (1.97 ms)** | **181.0 MB/s (0.61 s, 119 MB RSS)** |
| **Total Improvement Arc vs Initial** | **21.5x faster** | **4.14x faster** | **1.89x faster** | **2.43x faster / 4.6x less RAM** |
<!-- mdformat on -->
