# Cross-Language JSON Serialization Benchmark Results

* **Run Date**: `2026-09-20T02:28:19.320956Z`
* **System**: macos (Version 15.7.9 (Build 24G830)) | arm64
* **Hardware**: Apple M4 Pro (14 logical cores) | RAM: 48.0 GB
* **Toolchains & Packages**:
  * **New Dart (Custom SDK)**: `Dart SDK version: 3.14.0-json-next.e676935b72bd801c2fdec5188d1e4d8e69dcbf61 (main) (Sat Sep 19 16:14:26 2026 -0700) on "macos_arm64"`
    * `codable`: `package:codable (SDK Layer 1 native substrate)`
    * `json_serializable`: `package:json_serializable (Typed fromJson/toJson)`
    * `convert`: `dart:convert (Untyped Map/DOM)`
  * **Stock Dart (Baseline SDK)**: `Dart SDK version: 3.14.0-248.0.dev (dev) (Sat Sep 19 01:09:06 2026 -0700) on "macos_arm64"`
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
| **`small.json`** (546 B) | 🥇 **858.1 MB/s (607 ns)** | 149.4 MB/s (3.49 µs) | 337.6 MB/s (1.54 µs) | 🥉 **340.9 MB/s (1.53 µs)** | 🥈 **380.1 MB/s (1.37 µs)** | **1.13x** [ 1.11x - 1.14x ] | **2.54x** [ 2.52x - 2.57x ] |
| **`twitter.json`** (616.7 KB) | 🥇 **1246.9 MB/s (482.99 µs)** | 199.5 MB/s (3.02 ms) | 🥉 **437.6 MB/s (1.38 ms)** | 🥈 **441.9 MB/s (1.36 ms)** | 376.8 MB/s (1.60 ms) | **0.86x** [ 0.85x - 0.88x ] | **1.89x** [ 1.87x - 1.91x ] |
| **`citm_catalog.json`** (1.65 MB) | 🥇 **1523.8 MB/s (1.08 ms)** | 210.3 MB/s (7.83 ms) | 537.4 MB/s (3.07 ms) | 🥉 **538.4 MB/s (3.06 ms)** | 🥈 **721.1 MB/s (2.28 ms)** | **1.34x** [ 1.32x - 1.35x ] | **3.43x** [ 3.38x - 3.45x ] |
| **`canada.json`** (2.15 MB) | 🥇 **875.8 MB/s (2.45 ms)** | 133.3 MB/s (16.10 ms) | 108.0 MB/s (19.88 ms) | 🥉 **144.5 MB/s (14.86 ms)** | 🥈 **359.7 MB/s (5.97 ms)** | **3.33x** [ 3.32x - 3.36x ] | **2.70x** [ 2.69x - 2.73x ] |
<!-- mdformat on -->

## 1.2 ENCODE — Apples-to-Apples Typed Struct Matrix

Strongly-typed domain model serialization (Typed Structs -> UTF-8 bytes). Each cell displays **Throughput (`MiB/s`)** and **Single-Pass Latency (`ms`/`µs`)**. Medals (🥇, 🥈, 🥉) rank the top 3 typed struct contenders per dataset.

<!-- mdformat off -->
| Dataset | Rust (`serde_json` Typed) | Go (`encoding/json` Typed) | Stock Dart + `json_serializable` (Typed) | New Dart + `json_serializable` (Typed) | New Dart + `package:codable` (Typed) | `codable` vs Stock `json_serializable` | `codable` vs Go `encoding/json` |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **`small.json`** (546 B) | 🥇 **1697.7 MB/s (307 ns)** | 🥈 **916.5 MB/s (568 ns)** | 224.8 MB/s (2.32 µs) | 359.6 MB/s (1.45 µs) | 🥉 **721.6 MB/s (722 ns)** | **3.21x** [ 3.16x - 3.23x ] | **0.79x** [ 0.78x - 0.81x ] |
| **`twitter.json`** (616.7 KB) | 🥇 **2584.6 MB/s (233.02 µs)** | 🥈 **1484.8 MB/s (405.62 µs)** | 261.0 MB/s (2.31 ms) | 492.6 MB/s (1.22 ms) | 🥉 **1093.5 MB/s (550.75 µs)** | **4.19x** [ 4.12x - 4.22x ] | **0.74x** [ 0.72x - 0.74x ] |
| **`citm_catalog.json`** (1.65 MB) | 🥇 **5972.9 MB/s (275.78 µs)** | 🥈 **2865.3 MB/s (574.87 µs)** | 465.9 MB/s (3.54 ms) | 676.4 MB/s (2.44 ms) | 🥉 **1639.6 MB/s (1.00 ms)** | **3.52x** [ 3.46x - 3.58x ] | **0.57x** [ 0.56x - 0.58x ] |
| **`canada.json`** (2.15 MB) | 🥇 **1490.7 MB/s (1.44 ms)** | 🥈 **349.4 MB/s (6.14 ms)** | 110.7 MB/s (19.40 ms) | 🥉 **277.1 MB/s (7.75 ms)** | 228.5 MB/s (9.40 ms) | **2.06x** [ 2.04x - 2.08x ] | **0.65x** [ 0.65x - 0.66x ] |
<!-- mdformat on -->

## 2.1 DECODE — Complete Cross-Language Matrix (Typed Structs + Untyped DOM)

Includes both **Typed Struct** contenders (`Rust`, `Go`, `Dart json_serializable`, `Dart package:codable`) and **Untyped DOM** parsers (`Node.js V8 [Untyped JS Object]`, `Stock/New Dart std_convert [Untyped Map/DOM]`). Medals (🥇, 🥈, 🥉) indicate top 3 raw throughput across all 8 columns.

<!-- mdformat off -->
| Dataset | Rust (`serde_json` Typed) | Go (`encoding/json` Typed) | Node.js V8 (`Untyped JS Object`) | Stock Dart + `json_serializable` (`Typed`) | New Dart + `json_serializable` (`Typed`) | New Dart + `package:codable` (`Typed`) | Stock Dart `std_convert` (`Untyped Map/DOM`) | New Dart `std_convert` (`Untyped Map/DOM`) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **`small.json`** (546 B) | 🥇 **858.1 MB/s (607 ns)** | 149.4 MB/s (3.49 µs) | 🥈 **516.4 MB/s (1.01 µs)** | 337.6 MB/s (1.54 µs) | 340.9 MB/s (1.53 µs) | 380.1 MB/s (1.37 µs) | 442.3 MB/s (1.18 µs) | 🥉 **449.8 MB/s (1.16 µs)** |
| ↳ *% of Winner* | **100.0%** | 17.4% | 60.2% | 39.3% | 39.7% | 44.3% | 51.5% | 52.4% |
| **`twitter.json`** (616.7 KB) | 🥇 **1246.9 MB/s (482.99 µs)** | 199.5 MB/s (3.02 ms) | 🥈 **724.6 MB/s (831.21 µs)** | 437.6 MB/s (1.38 ms) | 441.9 MB/s (1.36 ms) | 376.8 MB/s (1.60 ms) | 488.4 MB/s (1.23 ms) | 🥉 **490.7 MB/s (1.23 ms)** |
| ↳ *% of Winner* | **100.0%** | 16.0% | 58.1% | 35.1% | 35.4% | 30.2% | 39.2% | 39.4% |
| **`citm_catalog.json`** (1.65 MB) | 🥇 **1523.8 MB/s (1.08 ms)** | 210.3 MB/s (7.83 ms) | 🥈 **839.9 MB/s (1.96 ms)** | 537.4 MB/s (3.07 ms) | 538.4 MB/s (3.06 ms) | 🥉 **721.1 MB/s (2.28 ms)** | 579.1 MB/s (2.84 ms) | 588.9 MB/s (2.80 ms) |
| ↳ *% of Winner* | **100.0%** | 13.8% | 55.1% | 35.3% | 35.3% | 47.3% | 38.0% | 38.6% |
| **`canada.json`** (2.15 MB) | 🥇 **875.8 MB/s (2.45 ms)** | 133.3 MB/s (16.10 ms) | 🥈 **513.2 MB/s (4.18 ms)** | 108.0 MB/s (19.88 ms) | 144.5 MB/s (14.86 ms) | 🥉 **359.7 MB/s (5.97 ms)** | 146.8 MB/s (14.62 ms) | 254.1 MB/s (8.45 ms) |
| ↳ *% of Winner* | **100.0%** | 15.2% | 58.6% | 12.3% | 16.5% | 41.1% | 16.8% | 29.0% |
<!-- mdformat on -->

## 2.2 ENCODE — Complete Cross-Language Matrix (Typed Structs + Untyped DOM)

Includes both **Typed Struct** contenders (`Rust`, `Go`, `Dart json_serializable`, `Dart package:codable`) and **Untyped DOM** parsers (`Node.js V8 [Untyped JS Object]`, `Stock/New Dart std_convert [Untyped Map/DOM]`). Medals (🥇, 🥈, 🥉) indicate top 3 raw throughput across all 8 columns.

<!-- mdformat off -->
| Dataset | Rust (`serde_json` Typed) | Go (`encoding/json` Typed) | Node.js V8 (`Untyped JS Object`) | Stock Dart + `json_serializable` (`Typed`) | New Dart + `json_serializable` (`Typed`) | New Dart + `package:codable` (`Typed`) | Stock Dart `std_convert` (`Untyped Map/DOM`) | New Dart `std_convert` (`Untyped Map/DOM`) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **`small.json`** (546 B) | 🥇 **1697.7 MB/s (307 ns)** | 🥈 **916.5 MB/s (568 ns)** | 715.1 MB/s (728 ns) | 224.8 MB/s (2.32 µs) | 359.6 MB/s (1.45 µs) | 🥉 **721.6 MB/s (722 ns)** | 288.8 MB/s (1.80 µs) | 554.7 MB/s (939 ns) |
| ↳ *% of Winner* | **100.0%** | 54.0% | 42.1% | 13.2% | 21.2% | 42.5% | 17.0% | 32.7% |
| **`twitter.json`** (616.7 KB) | 🥇 **2584.6 MB/s (233.02 µs)** | 🥈 **1484.8 MB/s (405.62 µs)** | 524.6 MB/s (1.15 ms) | 261.0 MB/s (2.31 ms) | 492.6 MB/s (1.22 ms) | 🥉 **1093.5 MB/s (550.75 µs)** | 311.2 MB/s (1.94 ms) | 731.5 MB/s (823.38 µs) |
| ↳ *% of Winner* | **100.0%** | 57.4% | 20.3% | 10.1% | 19.1% | 42.3% | 12.0% | 28.3% |
| **`citm_catalog.json`** (1.65 MB) | 🥇 **5972.9 MB/s (275.78 µs)** | 🥈 **2865.3 MB/s (574.87 µs)** | 1069.2 MB/s (1.54 ms) | 465.9 MB/s (3.54 ms) | 676.4 MB/s (2.44 ms) | 🥉 **1639.6 MB/s (1.00 ms)** | 609.7 MB/s (2.70 ms) | 1092.1 MB/s (1.51 ms) |
| ↳ *% of Winner* | **100.0%** | 48.0% | 17.9% | 7.8% | 11.3% | 27.5% | 10.2% | 18.3% |
| **`canada.json`** (2.15 MB) | 🥇 **1490.7 MB/s (1.44 ms)** | 🥈 **349.4 MB/s (6.14 ms)** | 🥉 **297.8 MB/s (7.21 ms)** | 110.7 MB/s (19.40 ms) | 277.1 MB/s (7.75 ms) | 228.5 MB/s (9.40 ms) | 111.5 MB/s (19.25 ms) | 287.5 MB/s (7.47 ms) |
| ↳ *% of Winner* | **100.0%** | 23.4% | 20.0% | 7.4% | 18.6% | 15.3% | 7.5% | 19.3% |
<!-- mdformat on -->

