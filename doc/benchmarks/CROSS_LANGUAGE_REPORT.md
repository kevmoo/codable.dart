# Cross-Language JSON Serialization Benchmark Results

* **Run Date**: `2026-09-19T05:32:38.880392Z`
* **System**: linux (Linux 7.1.6-1rodete1-amd64 #1 SMP PREEMPT_DYNAMIC Debian 7.1.6-1rodete1 (2026-08-05)) | x86_64
* **Hardware**: AMD EPYC 7B13 (64 logical cores) | RAM: 117.9 GB
* **Toolchains & Packages**:
  * **New Dart (Custom SDK)**: `Dart SDK version: 3.14.0-edge.8045fcd2294b259f9a87e5abd1986c954a0ffbe0 (main) (Sat Sep 12 19:08:49 2026 -0700) on "linux_x64"`
    * `codable`: `package:codable (SDK Layer 1 native substrate)`
    * `json_serializable`: `package:json_serializable (Typed fromJson/toJson)`
    * `convert`: `dart:convert (Untyped Map/DOM)`
  * **Rust**: `rustc 1.97.1 (8bab26f4f 2026-07-14)`
    * `serde_json`: `1.0.151`
    * `serde`: `1.0.229`
    * `mimalloc`: `0.1.52 (global allocator)`
  * **Go**: `go version go1.25.14 linux/amd64`
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
| **`small.json`** (546 B) | 🥇 **385.3 MB/s (1.35 µs)** ❓ | 63.0 MB/s (8.27 µs) | 🥈 **177.8 MB/s (2.93 µs)** | 160.1 MB/s (3.25 µs) | 🥉 **172.0 MB/s (3.03 µs)** | **0.97x** [ 0.96x - 1.00x ] | **2.73x** [ 2.69x - 2.82x ] |
| **`twitter.json`** (616.7 KB) | 🥇 **471.3 MB/s (1.28 ms)** | 88.5 MB/s (6.80 ms) | 🥈 **200.4 MB/s (3.01 ms)** | 🥉 **200.3 MB/s (3.01 ms)** | 174.3 MB/s (3.46 ms) | **0.87x** [ 0.85x - 0.88x ] | **1.97x** [ 1.95x - 2.02x ] |
| **`citm_catalog.json`** (1.65 MB) | 🥇 **696.5 MB/s (2.36 ms)** ❓ | 81.0 MB/s (20.32 ms) | 273.7 MB/s (6.02 ms) | 🥉 **274.1 MB/s (6.01 ms)** | 🥈 **366.7 MB/s (4.49 ms)** | **1.34x** [ 1.29x - 1.38x ] | **4.52x** [ 4.36x - 4.60x ] |
| **`canada.json`** (2.15 MB) | 🥇 **431.6 MB/s (4.97 ms)** | 48.8 MB/s (43.96 ms) | 58.3 MB/s (36.84 ms) | 🥉 **78.1 MB/s (27.49 ms)** | 🥈 **190.7 MB/s (11.26 ms)** | **3.27x** [ 3.19x - 3.28x ] | **3.90x** [ 3.83x - 3.94x ] |
<!-- mdformat on -->

## 1.2 ENCODE — Apples-to-Apples Typed Struct Matrix

Strongly-typed domain model serialization (Typed Structs -> UTF-8 bytes). Each cell displays **Throughput (`MiB/s`)** and **Single-Pass Latency (`ms`/`µs`)**. Medals (🥇, 🥈, 🥉) rank the top 3 typed struct contenders per dataset.

<!-- mdformat off -->
| Dataset | Rust (`serde_json` Typed) | Go (`encoding/json` Typed) | Stock Dart + `json_serializable` (Typed) | New Dart + `json_serializable` (Typed) | New Dart + `package:codable` (Typed) | `codable` vs Stock `json_serializable` | `codable` vs Go `encoding/json` |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **`small.json`** (546 B) | 🥇 **918.8 MB/s (567 ns)** | 🥈 **388.2 MB/s (1.34 µs)** | 102.7 MB/s (5.07 µs) | 92.0 MB/s (5.66 µs) | 🥉 **299.3 MB/s (1.74 µs)** | **2.91x** [ 2.81x - 3.00x ] | **0.77x** [ 0.74x - 0.79x ] |
| **`twitter.json`** (616.7 KB) | 🥇 **1245.4 MB/s (483.60 µs)** | 🥈 **675.5 MB/s (891.53 µs)** | 109.5 MB/s (5.50 ms) | 189.1 MB/s (3.18 ms) | 🥉 **368.7 MB/s (1.63 ms)** | **3.37x** [ 3.23x - 3.40x ] | **0.55x** [ 0.52x - 0.56x ] |
| **`citm_catalog.json`** (1.65 MB) | 🥇 **2960.8 MB/s (556.33 µs)** | 🥈 **1259.1 MB/s (1.31 ms)** | 181.9 MB/s (9.06 ms) | 272.4 MB/s (6.05 ms) | 🥉 **550.3 MB/s (2.99 ms)** ❓ | ❓ Unresolved | ❓ Unresolved |
| **`canada.json`** (2.15 MB) | 🥇 **677.2 MB/s (3.17 ms)** | 🥈 **156.2 MB/s (13.74 ms)** | 47.2 MB/s (45.45 ms) | 🥉 **99.6 MB/s (21.56 ms)** | 88.4 MB/s (24.30 ms) | **1.87x** [ 1.84x - 1.89x ] | **0.57x** [ 0.56x - 0.58x ] |
<!-- mdformat on -->

## 2.1 DECODE — Complete Cross-Language Matrix (Typed Structs + Untyped DOM)

Includes both **Typed Struct** contenders (`Rust`, `Go`, `Dart json_serializable`, `Dart package:codable`) and **Untyped DOM** parsers (`Node.js V8 [Untyped JS Object]`, `Stock/New Dart std_convert [Untyped Map/DOM]`). Medals (🥇, 🥈, 🥉) indicate top 3 raw throughput across all 8 columns.

<!-- mdformat off -->
| Dataset | Rust (`serde_json` Typed) | Go (`encoding/json` Typed) | Node.js V8 (`Untyped JS Object`) | Stock Dart + `json_serializable` (`Typed`) | New Dart + `json_serializable` (`Typed`) | New Dart + `package:codable` (`Typed`) | Stock Dart `std_convert` (`Untyped Map/DOM`) | New Dart `std_convert` (`Untyped Map/DOM`) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **`small.json`** (546 B) | 🥇 **385.3 MB/s (1.35 µs)** ❓ | 63.0 MB/s (8.27 µs) | 🥈 **247.2 MB/s (2.11 µs)** | 177.8 MB/s (2.93 µs) | 160.1 MB/s (3.25 µs) | 172.0 MB/s (3.03 µs) | 🥉 **209.9 MB/s (2.48 µs)** | 200.0 MB/s (2.60 µs) ❓ |
| ↳ *% of Winner* | **100.0%** | 16.3% | 64.2% | 46.2% | 41.5% | 44.7% | 54.5% | 51.9% |
| **`twitter.json`** (616.7 KB) | 🥇 **471.3 MB/s (1.28 ms)** | 88.5 MB/s (6.80 ms) | 🥈 **427.0 MB/s (1.41 ms)** | 200.4 MB/s (3.01 ms) | 200.3 MB/s (3.01 ms) | 174.3 MB/s (3.46 ms) | 🥉 **228.8 MB/s (2.63 ms)** | 220.7 MB/s (2.73 ms) |
| ↳ *% of Winner* | **100.0%** | 18.8% | 90.6% | 42.5% | 42.5% | 37.0% | 48.5% | 46.8% |
| **`citm_catalog.json`** (1.65 MB) | 🥇 **696.5 MB/s (2.36 ms)** ❓ | 81.0 MB/s (20.32 ms) | 🥈 **460.8 MB/s (3.57 ms)** | 273.7 MB/s (6.02 ms) | 274.1 MB/s (6.01 ms) | 🥉 **366.7 MB/s (4.49 ms)** | 295.0 MB/s (5.58 ms) ❓ | 309.8 MB/s (5.32 ms) ❓ |
| ↳ *% of Winner* | **100.0%** | 11.6% | 66.2% | 39.3% | 39.4% | 52.7% | 42.4% | 44.5% |
| **`canada.json`** (2.15 MB) | 🥇 **431.6 MB/s (4.97 ms)** | 48.8 MB/s (43.96 ms) | 🥈 **220.5 MB/s (9.74 ms)** | 58.3 MB/s (36.84 ms) | 78.1 MB/s (27.49 ms) | 🥉 **190.7 MB/s (11.26 ms)** | 77.7 MB/s (27.61 ms) | 133.3 MB/s (16.10 ms) |
| ↳ *% of Winner* | **100.0%** | 11.3% | 51.1% | 13.5% | 18.1% | 44.2% | 18.0% | 30.9% |
<!-- mdformat on -->

## 2.2 ENCODE — Complete Cross-Language Matrix (Typed Structs + Untyped DOM)

Includes both **Typed Struct** contenders (`Rust`, `Go`, `Dart json_serializable`, `Dart package:codable`) and **Untyped DOM** parsers (`Node.js V8 [Untyped JS Object]`, `Stock/New Dart std_convert [Untyped Map/DOM]`). Medals (🥇, 🥈, 🥉) indicate top 3 raw throughput across all 8 columns.

<!-- mdformat off -->
| Dataset | Rust (`serde_json` Typed) | Go (`encoding/json` Typed) | Node.js V8 (`Untyped JS Object`) | Stock Dart + `json_serializable` (`Typed`) | New Dart + `json_serializable` (`Typed`) | New Dart + `package:codable` (`Typed`) | Stock Dart `std_convert` (`Untyped Map/DOM`) | New Dart `std_convert` (`Untyped Map/DOM`) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **`small.json`** (546 B) | 🥇 **918.8 MB/s (567 ns)** | 🥈 **388.2 MB/s (1.34 µs)** | 🥉 **343.1 MB/s (1.52 µs)** | 102.7 MB/s (5.07 µs) | 92.0 MB/s (5.66 µs) | 299.3 MB/s (1.74 µs) | 138.3 MB/s (3.76 µs) | 103.3 MB/s (5.04 µs) ❓ |
| ↳ *% of Winner* | **100.0%** | 42.3% | 37.3% | 11.2% | 10.0% | 32.6% | 15.1% | 11.2% |
| **`twitter.json`** (616.7 KB) | 🥇 **1245.4 MB/s (483.60 µs)** | 🥈 **675.5 MB/s (891.53 µs)** | 335.5 MB/s (1.80 ms) | 109.5 MB/s (5.50 ms) | 189.1 MB/s (3.18 ms) | 🥉 **368.7 MB/s (1.63 ms)** | 127.5 MB/s (4.72 ms) | 249.2 MB/s (2.42 ms) |
| ↳ *% of Winner* | **100.0%** | 54.2% | 26.9% | 8.8% | 15.2% | 29.6% | 10.2% | 20.0% |
| **`citm_catalog.json`** (1.65 MB) | 🥇 **2960.8 MB/s (556.33 µs)** | 🥈 **1259.1 MB/s (1.31 ms)** | 488.5 MB/s (3.37 ms) | 181.9 MB/s (9.06 ms) | 272.4 MB/s (6.05 ms) | 🥉 **550.3 MB/s (2.99 ms)** ❓ | 238.2 MB/s (6.91 ms) ❓ | 392.6 MB/s (4.20 ms) ❓ |
| ↳ *% of Winner* | **100.0%** | 42.5% | 16.5% | 6.1% | 9.2% | 18.6% | 8.0% | 13.3% |
| **`canada.json`** (2.15 MB) | 🥇 **677.2 MB/s (3.17 ms)** | 🥈 **156.2 MB/s (13.74 ms)** | 🥉 **125.2 MB/s (17.15 ms)** | 47.2 MB/s (45.45 ms) | 99.6 MB/s (21.56 ms) | 88.4 MB/s (24.30 ms) | 46.0 MB/s (46.64 ms) | 98.2 MB/s (21.87 ms) |
| ↳ *% of Winner* | **100.0%** | 23.1% | 18.5% | 7.0% | 14.7% | 13.0% | 6.8% | 14.5% |
<!-- mdformat on -->

