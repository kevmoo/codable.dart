# Cross-Language JSON Serialization Benchmark Results

* **Run Date**: `2026-09-19T12:39:39.665069Z`
* **System**: macos (Version 15.7.9 (Build 24G830)) | arm64
* **Hardware**: Apple M4 Pro (14 logical cores) | RAM: 48.0 GB
* **Toolchains & Packages**:
  * **New Dart (Custom SDK)**: `Dart SDK version: 3.14.0-json-next.04411fb24e8ed6395eb858265d1214c192d23419 (main) (Fri Sep 18 23:25:20 2026 -0700) on "macos_arm64"`
    * `codable`: `package:codable (SDK Layer 1 native substrate)`
    * `json_serializable`: `package:json_serializable (Typed fromJson/toJson)`
    * `convert`: `dart:convert (Untyped Map/DOM)`
  * **Stock Dart (Baseline SDK)**: `Dart SDK version: 3.14.0-247.0.dev (dev) (Fri Sep 18 21:02:24 2026 -0700) on "macos_arm64"`
    * `json_serializable`: `package:json_serializable (Typed fromJson/toJson)`
    * `convert`: `Standard Library (Untyped Map/DOM)`
  * **Rust**: `rustc 1.98.1 (48a229cea 2026-09-01)`
    * `serde_json`: `1.0.151`
    * `serde`: `1.0.229`
    * `mimalloc`: `0.1.52 (global allocator)`
  * **Go**: `go version go1.25.14 darwin/arm64`
    * `encoding/json`: `Standard Library`
  * **Node.js**: `v24.21.0 (V8 13.6.233.17-node.53)`
    * `v8_builtin`: `V8 C++ Built-in (Untyped JS Object)`

> [!IMPORTANT]
> **Typed Struct Serialization vs. Untyped DOM Parsing**:
> * **Typed Struct Serialization (`Rust serde_json`, `Go encoding/json`, `Stock Dart + json_serializable`, `New Dart + json_serializable`, `New Dart + package:codable`)**: Deserializes raw UTF-8 bytes (`Uint8List` / `&[u8]` / `[]byte`) into strongly-typed domain model objects (`SmallDocument`, `TwitterResponse`, `CitmCatalog`, `CanadaFeatureCollection`) and serializes those strongly-typed models back to UTF-8 bytes.
> * **Untyped DOM Parsing (`Node.js V8`, `Stock Dart std_convert`, `New Dart std_convert`)**: Only parses UTF-8 bytes into an untyped dynamic AST (`Map<String, dynamic>` in Dart or raw V8 JS `Object` in Node.js), completely skipping typed `.fromJson(...)` / `.toJson()` model hydration and validation.
> * **`New Dart + package:codable`**: Uses single-pass streaming pull/push readers/writers (`JsonCodableDecoder.fromBytes` / `JsonCodableEncoder.toBytes`) backed by the native `dart:convert` Layer 1 UTF-8 token substrate, bypassing intermediate `Map<String, dynamic>` AST allocation entirely.

## 1.1 DECODE — Apples-to-Apples Typed Struct Matrix

Strongly-typed domain model deserialization (UTF-8 bytes -> Typed Structs). Each cell displays **Throughput (`MiB/s`)** and **Single-Pass Latency (`ms`/`µs`)**. Medals (🥇, 🥈, 🥉) rank the top 3 typed struct contenders per dataset.

<!-- mdformat off -->
| Dataset | Rust (`serde_json` Typed) | Go (`encoding/json` Typed) | Stock Dart + `json_serializable` (Typed) | New Dart + `json_serializable` (Typed) | New Dart + `package:codable` (Typed) | `codable` vs Stock `json_serializable` | `codable` vs Go `encoding/json` |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **`small.json`** (546 B) | 🥇 **842.2 MB/s (618 ns)** | 163.1 MB/s (3.19 µs) | 🥉 **387.0 MB/s (1.35 µs)** | 386.2 MB/s (1.35 µs) | 🥈 **433.3 MB/s (1.20 µs)** | **1.12x** [ 1.11x - 1.13x ] | **2.66x** [ 2.59x - 2.80x ] |
| **`twitter.json`** (616.7 KB) | 🥇 **1414.8 MB/s (425.69 µs)** | 225.9 MB/s (2.67 ms) | 🥈 **511.3 MB/s (1.18 ms)** | 🥉 **504.2 MB/s (1.19 ms)** | 438.3 MB/s (1.37 ms) | **0.86x** [ 0.84x - 0.87x ] | **1.94x** [ 1.91x - 1.95x ] |
| **`citm_catalog.json`** (1.65 MB) | 🥇 **1441.7 MB/s (1.14 ms)** | 213.1 MB/s (7.73 ms) | 🥉 **585.5 MB/s (2.81 ms)** | 563.7 MB/s (2.92 ms) | 🥈 **745.3 MB/s (2.21 ms)** | **1.27x** [ 1.27x - 1.31x ] | **3.50x** [ 3.41x - 3.55x ] |
| **`canada.json`** (2.15 MB) | 🥇 **946.0 MB/s (2.27 ms)** | 152.0 MB/s (14.12 ms) | 147.5 MB/s (14.55 ms) | 🥉 **200.1 MB/s (10.73 ms)** | 🥈 **441.7 MB/s (4.86 ms)** | **2.99x** [ 2.96x - 3.03x ] | **2.91x** [ 2.86x - 2.93x ] |
<!-- mdformat on -->

## 1.2 ENCODE — Apples-to-Apples Typed Struct Matrix

Strongly-typed domain model serialization (Typed Structs -> UTF-8 bytes). Each cell displays **Throughput (`MiB/s`)** and **Single-Pass Latency (`ms`/`µs`)**. Medals (🥇, 🥈, 🥉) rank the top 3 typed struct contenders per dataset.

<!-- mdformat off -->
| Dataset | Rust (`serde_json` Typed) | Go (`encoding/json` Typed) | Stock Dart + `json_serializable` (Typed) | New Dart + `json_serializable` (Typed) | New Dart + `package:codable` (Typed) | `codable` vs Stock `json_serializable` | `codable` vs Go `encoding/json` |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **`small.json`** (546 B) | 🥇 **1825.9 MB/s (285 ns)** ❓ | 🥈 **868.0 MB/s (600 ns)** | 247.3 MB/s (2.11 µs) | 273.2 MB/s (1.91 µs) | 🥉 **793.2 MB/s (656 ns)** | **3.21x** [ 3.17x - 3.25x ] | **0.91x** [ 0.89x - 0.93x ] |
| **`twitter.json`** (616.7 KB) | 🥇 **2788.5 MB/s (215.98 µs)** | 🥈 **1592.1 MB/s (378.29 µs)** | 283.7 MB/s (2.12 ms) | 539.0 MB/s (1.12 ms) | 🥉 **1207.0 MB/s (498.97 µs)** | **4.26x** [ 4.19x - 4.42x ] | **0.76x** [ 0.75x - 0.77x ] |
| **`citm_catalog.json`** (1.65 MB) | 🥇 **6202.7 MB/s (265.56 µs)** | 🥈 **3008.4 MB/s (547.53 µs)** | 518.9 MB/s (3.17 ms) | 751.2 MB/s (2.19 ms) | 🥉 **1827.1 MB/s (901.52 µs)** | **3.52x** [ 3.41x - 3.58x ] | **0.61x** [ 0.58x - 0.61x ] |
| **`canada.json`** (2.15 MB) | 🥇 **1516.5 MB/s (1.42 ms)** | 🥈 **363.9 MB/s (5.90 ms)** | 120.4 MB/s (17.83 ms) | 🥉 **316.2 MB/s (6.79 ms)** | 252.5 MB/s (8.50 ms) | **2.10x** [ 2.09x - 2.10x ] | **0.69x** [ 0.69x - 0.70x ] |
<!-- mdformat on -->

## 2.1 DECODE — Complete Cross-Language Matrix (Typed Structs + Untyped DOM)

Includes both **Typed Struct** contenders (`Rust`, `Go`, `Dart json_serializable`, `Dart package:codable`) and **Untyped DOM** parsers (`Node.js V8 [Untyped JS Object]`, `Stock/New Dart std_convert [Untyped Map/DOM]`). Medals (🥇, 🥈, 🥉) indicate top 3 raw throughput across all 8 columns.

<!-- mdformat off -->
| Dataset | Rust (`serde_json` Typed) | Go (`encoding/json` Typed) | Node.js V8 (`Untyped JS Object`) | Stock Dart + `json_serializable` (`Typed`) | New Dart + `json_serializable` (`Typed`) | New Dart + `package:codable` (`Typed`) | Stock Dart `std_convert` (`Untyped Map/DOM`) | New Dart `std_convert` (`Untyped Map/DOM`) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **`small.json`** (546 B) | 🥇 **842.2 MB/s (618 ns)** | 163.1 MB/s (3.19 µs) | 🥈 **638.3 MB/s (816 ns)** | 387.0 MB/s (1.35 µs) | 386.2 MB/s (1.35 µs) | 433.3 MB/s (1.20 µs) | 🥉 **499.3 MB/s (1.04 µs)** | 492.2 MB/s (1.06 µs) |
| ↳ *% of Winner* | **100.0%** | 19.4% | 75.8% | 46.0% | 45.9% | 51.5% | 59.3% | 58.4% |
| **`twitter.json`** (616.7 KB) | 🥇 **1414.8 MB/s (425.69 µs)** | 225.9 MB/s (2.67 ms) | 🥈 **1048.3 MB/s (574.53 µs)** | 511.3 MB/s (1.18 ms) | 504.2 MB/s (1.19 ms) | 438.3 MB/s (1.37 ms) | 🥉 **574.7 MB/s (1.05 ms)** | 554.4 MB/s (1.09 ms) |
| ↳ *% of Winner* | **100.0%** | 16.0% | 74.1% | 36.1% | 35.6% | 31.0% | 40.6% | 39.2% |
| **`citm_catalog.json`** (1.65 MB) | 🥇 **1441.7 MB/s (1.14 ms)** | 213.1 MB/s (7.73 ms) | 🥈 **1094.5 MB/s (1.51 ms)** | 585.5 MB/s (2.81 ms) | 563.7 MB/s (2.92 ms) | 🥉 **745.3 MB/s (2.21 ms)** | 697.3 MB/s (2.36 ms) | 706.1 MB/s (2.33 ms) |
| ↳ *% of Winner* | **100.0%** | 14.8% | 75.9% | 40.6% | 39.1% | 51.7% | 48.4% | 49.0% |
| **`canada.json`** (2.15 MB) | 🥇 **946.0 MB/s (2.27 ms)** | 152.0 MB/s (14.12 ms) | 🥈 **612.8 MB/s (3.50 ms)** | 147.5 MB/s (14.55 ms) | 200.1 MB/s (10.73 ms) | 🥉 **441.7 MB/s (4.86 ms)** | 189.6 MB/s (11.32 ms) | 322.8 MB/s (6.65 ms) |
| ↳ *% of Winner* | **100.0%** | 16.1% | 64.8% | 15.6% | 21.2% | 46.7% | 20.0% | 34.1% |
<!-- mdformat on -->

## 2.2 ENCODE — Complete Cross-Language Matrix (Typed Structs + Untyped DOM)

Includes both **Typed Struct** contenders (`Rust`, `Go`, `Dart json_serializable`, `Dart package:codable`) and **Untyped DOM** parsers (`Node.js V8 [Untyped JS Object]`, `Stock/New Dart std_convert [Untyped Map/DOM]`). Medals (🥇, 🥈, 🥉) indicate top 3 raw throughput across all 8 columns.

<!-- mdformat off -->
| Dataset | Rust (`serde_json` Typed) | Go (`encoding/json` Typed) | Node.js V8 (`Untyped JS Object`) | Stock Dart + `json_serializable` (`Typed`) | New Dart + `json_serializable` (`Typed`) | New Dart + `package:codable` (`Typed`) | Stock Dart `std_convert` (`Untyped Map/DOM`) | New Dart `std_convert` (`Untyped Map/DOM`) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **`small.json`** (546 B) | 🥇 **1825.9 MB/s (285 ns)** ❓ | 🥉 **868.0 MB/s (600 ns)** | 🥈 **917.6 MB/s (567 ns)** | 247.3 MB/s (2.11 µs) | 273.2 MB/s (1.91 µs) | 793.2 MB/s (656 ns) | 320.0 MB/s (1.63 µs) | 336.5 MB/s (1.55 µs) |
| ↳ *% of Winner* | **100.0%** | 47.5% | 50.3% | 13.5% | 15.0% | 43.4% | 17.5% | 18.4% |
| **`twitter.json`** (616.7 KB) | 🥇 **2788.5 MB/s (215.98 µs)** | 🥈 **1592.1 MB/s (378.29 µs)** | 1089.9 MB/s (552.60 µs) ❓ | 283.7 MB/s (2.12 ms) | 539.0 MB/s (1.12 ms) | 🥉 **1207.0 MB/s (498.97 µs)** | 342.6 MB/s (1.76 ms) | 724.8 MB/s (830.96 µs) |
| ↳ *% of Winner* | **100.0%** | 57.1% | 39.1% | 10.2% | 19.3% | 43.3% | 12.3% | 26.0% |
| **`citm_catalog.json`** (1.65 MB) | 🥇 **6202.7 MB/s (265.56 µs)** | 🥈 **3008.4 MB/s (547.53 µs)** | 🥉 **2070.5 MB/s (795.57 µs)** | 518.9 MB/s (3.17 ms) | 751.2 MB/s (2.19 ms) | 1827.1 MB/s (901.52 µs) | 682.5 MB/s (2.41 ms) | 1218.3 MB/s (1.35 ms) |
| ↳ *% of Winner* | **100.0%** | 48.5% | 33.4% | 8.4% | 12.1% | 29.5% | 11.0% | 19.6% |
| **`canada.json`** (2.15 MB) | 🥇 **1516.5 MB/s (1.42 ms)** | 🥈 **363.9 MB/s (5.90 ms)** | 🥉 **346.4 MB/s (6.20 ms)** | 120.4 MB/s (17.83 ms) | 316.2 MB/s (6.79 ms) | 252.5 MB/s (8.50 ms) | 120.3 MB/s (17.85 ms) | 317.3 MB/s (6.77 ms) |
| ↳ *% of Winner* | **100.0%** | 24.0% | 22.8% | 7.9% | 20.8% | 16.7% | 7.9% | 20.9% |
<!-- mdformat on -->

