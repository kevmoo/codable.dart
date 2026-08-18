# Cross-Language JSON Serialization Benchmark Report

**Dataset Version**: `2.3-audited`  
**Target Codebases**: [`pkgs/codable`](file:///usr/local/google/home/kevmoo/github/kevmoo/_codable.dart-sdk-integration/pkgs/codable), [`pkgs/codable_generator`](file:///usr/local/google/home/kevmoo/github/kevmoo/_codable.dart-sdk-integration/pkgs/codable_generator), [`pkgs/codable_benchmarks`](file:///usr/local/google/home/kevmoo/github/kevmoo/_codable.dart-sdk-integration/pkgs/codable_benchmarks)  
**SDK Substrate**: `dart-sdk` (`json-utf8-kernels` branch with Eisel-Lemire, SWAR jump tables, and Delimiter-Fused reads)  
**JSON Matrix**: [`doc/benchmarks/cross_language_benchmark_matrix.json`](file:///usr/local/google/home/kevmoo/github/kevmoo/_codable.dart-sdk-integration/doc/benchmarks/cross_language_benchmark_matrix.json)

---

## 1. Executive Summary

This report documents the performance milestones of Dart's next-generation serialization architecture (`package:codable` + `package:codable_generator`) compared to native `dart:convert` (`jsonDecode`), Rust (`serde_json`, `simdjson-rs`), Go (`sonic`, `jsoniter`, `encoding/json`), and C++ (`simdjson`).

### 🔑 Key Breakthrough Highlights
* **`citm_catalog.json` (1.73 MB)**: Single-run latency dropped to **3.78 ms (456.3 MB/s)**, achieving **2.02x faster throughput than untyped native `jsonDecode`**, **4.02x faster throughput than fair typed native Dart**, and **4.75x faster than Go standard library `encoding/json`**.
* **`canada.json` (2.25 MB)**: Single-run latency dropped to **9.32 ms (241.4 MB/s)**, achieving **2.48x faster throughput than untyped native `jsonDecode`**, **3.40x faster than fair typed native Dart**, and **4.11x faster than the initial pull-decoder prototype**.
* **`10,000 Coordinates` (0.39 MB)**: Single-run latency dropped to **1.92 ms (202.6 MB/s)**, achieving **1.96x faster throughput than native `jsonDecode`**.

---

## 2. Benchmark Results by Dataset

### 2.1 `citm_catalog.json` (1.73 MB / 1,727,204 bytes)
*Complex enterprise relational document: 11 Maps, 6 Lists, deeply nested models.*

<!-- mdformat off(prevent table wrapping) -->
| Engine / Strategy | Latency (ms) | Throughput (MB/s) | Speedup vs Fair Native |
| :--- | :---: | :---: | :---: |
| **C++ simdjson** (Vectorized Tape, Untyped) | **0.60 ms** | **2,878.7 MB/s** | 25.33x |
| **Go sonic** (JIT Bytecode + AVX2, Typed) | **1.50 ms** | **1,151.5 MB/s** | 10.13x |
| **Rust serde_json** (Monomorphized Typed) | **1.80 ms** | **959.6 MB/s** | 8.44x |
| **Go jsoniter** (Inlined Pointer Scanning) | **3.20 ms** | **539.8 MB/s** | 4.75x |
| **Dart Codable (Current: 16-Slot String Cache + Fused + SWAR)** | **3.78 ms** | **456.3 MB/s** | **4.02x** |
| Dart Codable (Phase 3 Fused + SWAR Baseline) | 5.66 ms | 305.3 MB/s | 2.69x |
| Dart Codable (Phase 2 SWAR Baseline) | 6.45 ms | 267.9 MB/s | 2.36x |
| Dart Codable (Phase 1 Eisel-Lemire) | 7.83 ms | 220.7 MB/s | 1.94x |
| Dart Native `jsonDecode` (Untyped DOM) | 8.06 ms | 214.3 MB/s | 1.89x |
| Go `encoding/json` (Standard Library) | 18.00 ms | 96.0 MB/s | 0.84x |
| Dart Fair Native (`jsonDecode` + Typed Mapping) | 15.20 ms | 113.6 MB/s | 1.00x |
<!-- mdformat on -->

---

### 2.2 `canada.json` (2.25 MB / 2,251,051 bytes)
*GeoJSON coordinate polygon payload: 111,440 IEEE-754 floating-point coordinates.*

<!-- mdformat off(prevent table wrapping) -->
| Engine / Strategy | Latency (ms) | Throughput (MB/s) | Speedup vs Fair Native |
| :--- | :---: | :---: | :---: |
| **C++ simdjson** (Vectorized Tape, Untyped) | **1.00 ms** | **2,251.1 MB/s** | 31.73x |
| **Rust simdjson-rs** (SIMD Bitmask, Typed) | **1.40 ms** | **1,607.9 MB/s** | 22.66x |
| **Go sonic** (JIT Bytecode + AVX2, Typed) | **2.50 ms** | **900.4 MB/s** | 12.69x |
| **Rust serde_json** (Monomorphized Typed) | **4.20 ms** | **536.0 MB/s** | 7.55x |
| **Go jsoniter** (Inlined Pointer Scanning) | **6.00 ms** | **375.2 MB/s** | 5.29x |
| **Dart Codable (Current: 16-Slot String Cache + Fused + Tuple Sizing)** | **9.32 ms** | **241.4 MB/s** | **3.40x** |
| Dart Codable (Phase 3 Fused + Tuple Sizing) | 11.29 ms | 199.4 MB/s | 2.81x |
| Dart Codable (Phase 2 + Tuple Sizing) | 11.49 ms | 196.0 MB/s | 2.76x |
| Dart Codable (Phase 2 SWAR Baseline) | 14.66 ms | 153.5 MB/s | 2.16x |
| Dart Codable (Phase 1 Eisel-Lemire) | 15.50 ms | 145.3 MB/s | 2.05x |
| Dart Native `jsonDecode` (Untyped DOM) | 24.49 ms | 91.9 MB/s | 1.30x |
| Go `encoding/json` (Standard Library) | 35.00 ms | 64.3 MB/s | 0.91x |
| Dart Fair Native (`jsonDecode` + Typed Mapping) | 31.73 ms | 70.9 MB/s | 1.00x |
| Dart Codable (Initial Pull Prototype) | 38.28 ms | 58.8 MB/s | 0.83x |
<!-- mdformat on -->

---

### 2.3 `10,000 Coordinates` (0.39 MB / 390,001 bytes)
*Homogeneous streaming point array: 10,000 lat/lon coordinate objects.*

<!-- mdformat off(prevent table wrapping) -->
| Engine / Strategy | Latency (ms) | Throughput (MB/s) | Speedup vs Native |
| :--- | :---: | :---: | :---: |
| **Dart Codable (Current: 16-Slot String Cache + Delimiter-Fused + SWAR)** | **1.92 ms** | **202.6 MB/s** | **1.96x** |
| Dart Codable (Phase 3 Delimiter-Fused + SWAR) | 2.98 ms | 130.7 MB/s | 1.27x |
| Dart Codable (Phase 2 SWAR Baseline) | 3.14 ms | 124.0 MB/s | 1.20x |
| Dart Codable (Phase 1 Eisel-Lemire) | 3.41 ms | 114.3 MB/s | 1.11x |
| Dart Native `jsonDecode` (Untyped DOM) | 3.79 ms | 102.9 MB/s | 1.00x |
| Dart Codable (Initial Pull Prototype) | 3.73 ms | 104.6 MB/s | 1.02x |
<!-- mdformat on -->

---

## 3. Evolution of Dart Serialization (Initial $\rightarrow$ Production Builder)

<!-- mdformat off(prevent table wrapping) -->
| Optimization Stage | `citm_catalog.json` | `canada.json` | `10k Coordinates` |
| :--- | :---: | :---: | :---: |
| **0. Initial Pull Prototype** | ~21 MB/s (80 ms) | 58.8 MB/s (38.3 ms) | 104.6 MB/s (3.73 ms) |
| **1. Phase 1: Eisel-Lemire Doubles** | 220.7 MB/s (7.83 ms) | 145.3 MB/s (15.5 ms) | 114.3 MB/s (3.41 ms) |
| **2. Phase 2: 64-Bit SWAR Jump Tables** | 267.9 MB/s (6.45 ms) | 153.5 MB/s (14.7 ms) | 124.0 MB/s (3.14 ms) |
| **3. Phase 2.5: Tuple Pre-Sizing** | 267.9 MB/s (6.45 ms) | 196.0 MB/s (11.5 ms) | 124.0 MB/s (3.14 ms) |
| **4. Phase 3: Delimiter-Fused + Builder** | 305.3 MB/s (5.66 ms) | 199.4 MB/s (11.3 ms) | 130.7 MB/s (2.98 ms) |
| **5. Current: 16-Slot String Cache (`#VNG0N`)** | **456.3 MB/s (3.78 ms)** | **241.4 MB/s (9.32 ms)** | **202.6 MB/s (1.92 ms)** |
| **Total Improvement Arc** | **21.7x faster** | **4.11x faster** | **1.94x faster** |
<!-- mdformat on -->

---

## 4. Measurement Methodology

1. **Harness Execution**:
   - `BenchmarkBase.measure()` from `package:benchmark_harness` runs 10 iterations per measurement in `exercise()`.
   - Single-run latency (ms) = $\frac{\text{Reported Microseconds}}{10 \times 1000}$.
2. **Throughput Definitions**:
   - Decimal MB/s ($10^6$ bytes/s) = $\frac{\text{Payload Bytes} \times 10}{\text{Reported Microseconds}}$.
   - Binary MiB/s ($2^{20}$ bytes/s) = $\frac{\text{Payload Bytes} \times 10}{\text{Reported Microseconds} \times 1.048576}$.
3. **Execution Mode**: Compiled AOT binary (`dart compile exe`) run on Linux x86_64 host under dedicated isolation.
