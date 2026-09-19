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
| **`small.json`** (546 B) | 385.3 MB/s (1.35 µs) ❓ | 63.0 MB/s (8.27 µs) | N/A | 🥈 **173.9 MB/s (2.99 µs)** | 🥉 **172.1 MB/s (3.03 µs)** | N/A | **2.73x** [ 2.68x - 2.82x ] |
| **`twitter.json`** (616.7 KB) | 🥇 **471.3 MB/s (1.28 ms)** | 88.5 MB/s (6.80 ms) | N/A | 🥈 **200.6 MB/s (3.00 ms)** | 🥉 **175.4 MB/s (3.43 ms)** | N/A | **1.98x** [ 1.91x - 2.01x ] |
| **`citm_catalog.json`** (1.65 MB) | 696.5 MB/s (2.36 ms) ❓ | 81.0 MB/s (20.32 ms) | N/A | 🥉 **278.9 MB/s (5.91 ms)** | 🥈 **368.9 MB/s (4.46 ms)** | N/A | **4.55x** [ 4.42x - 4.63x ] |
| **`canada.json`** (2.15 MB) | 🥇 **431.6 MB/s (4.97 ms)** | 48.8 MB/s (43.96 ms) | N/A | 🥉 **78.4 MB/s (27.37 ms)** | 🥈 **190.6 MB/s (11.26 ms)** | N/A | **3.90x** [ 3.82x - 3.96x ] |
<!-- mdformat on -->

## 1.2 ENCODE — Apples-to-Apples Typed Struct Matrix

Strongly-typed domain model serialization (Typed Structs -> UTF-8 bytes). Each cell displays **Throughput (`MiB/s`)** and **Single-Pass Latency (`ms`/`µs`)**. Medals (🥇, 🥈, 🥉) rank the top 3 typed struct contenders per dataset.

<!-- mdformat off -->
| Dataset | Rust (`serde_json` Typed) | Go (`encoding/json` Typed) | Stock Dart + `json_serializable` (Typed) | New Dart + `json_serializable` (Typed) | New Dart + `package:codable` (Typed) | `codable` vs Stock `json_serializable` | `codable` vs Go `encoding/json` |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **`small.json`** (546 B) | 🥇 **918.8 MB/s (567 ns)** | 🥈 **388.2 MB/s (1.34 µs)** | N/A | 91.5 MB/s (5.69 µs) | 🥉 **303.9 MB/s (1.71 µs)** | N/A | **0.78x** [ 0.75x - 0.81x ] |
| **`twitter.json`** (616.7 KB) | 🥇 **1245.4 MB/s (483.60 µs)** | 🥈 **675.5 MB/s (891.53 µs)** | N/A | 190.9 MB/s (3.15 ms) | 🥉 **378.0 MB/s (1.59 ms)** | N/A | **0.56x** [ 0.54x - 0.58x ] |
| **`citm_catalog.json`** (1.65 MB) | 🥇 **2960.8 MB/s (556.33 µs)** | 🥈 **1259.1 MB/s (1.31 ms)** | N/A | 281.6 MB/s (5.85 ms) | 🥉 **562.2 MB/s (2.93 ms)** | N/A | **0.45x** [ 0.43x - 0.46x ] |
| **`canada.json`** (2.15 MB) | 🥇 **677.2 MB/s (3.17 ms)** | 🥈 **156.2 MB/s (13.74 ms)** | N/A | 🥉 **100.5 MB/s (21.37 ms)** | 89.6 MB/s (23.96 ms) | N/A | **0.57x** [ 0.57x - 0.59x ] |
<!-- mdformat on -->

## 2.1 DECODE — Complete Cross-Language Matrix (Typed Structs + Untyped DOM)

Includes both **Typed Struct** contenders (`Rust`, `Go`, `Dart json_serializable`, `Dart package:codable`) and **Untyped DOM** parsers (`Node.js V8 [Untyped JS Object]`, `Stock/New Dart std_convert [Untyped Map/DOM]`). Medals (🥇, 🥈, 🥉) indicate top 3 raw throughput across all 8 columns.

<!-- mdformat off -->
| Dataset | Rust (`serde_json` Typed) | Go (`encoding/json` Typed) | Node.js V8 (`Untyped JS Object`) | Stock Dart + `json_serializable` (`Typed`) | New Dart + `json_serializable` (`Typed`) | New Dart + `package:codable` (`Typed`) | Stock Dart `std_convert` (`Untyped Map/DOM`) | New Dart `std_convert` (`Untyped Map/DOM`) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **`small.json`** (546 B) | 385.3 MB/s (1.35 µs) ❓ | 63.0 MB/s (8.27 µs) | 🥈 **247.2 MB/s (2.11 µs)** | N/A | 173.9 MB/s (2.99 µs) | 172.1 MB/s (3.03 µs) | N/A | 🥉 **205.9 MB/s (2.53 µs)** |
| ↳ *% of Winner* | **100.0%** | 16.3% | 64.2% | N/A | 45.1% | 44.7% | N/A | 53.5% |
| **`twitter.json`** (616.7 KB) | 🥇 **471.3 MB/s (1.28 ms)** | 88.5 MB/s (6.80 ms) | 🥈 **427.0 MB/s (1.41 ms)** | N/A | 200.6 MB/s (3.00 ms) | 175.4 MB/s (3.43 ms) | N/A | 🥉 **232.7 MB/s (2.59 ms)** |
| ↳ *% of Winner* | **100.0%** | 18.8% | 90.6% | N/A | 42.6% | 37.2% | N/A | 49.4% |
| **`citm_catalog.json`** (1.65 MB) | 696.5 MB/s (2.36 ms) ❓ | 81.0 MB/s (20.32 ms) | 🥈 **460.8 MB/s (3.57 ms)** | N/A | 278.9 MB/s (5.91 ms) | 🥉 **368.9 MB/s (4.46 ms)** | N/A | 316.4 MB/s (5.21 ms) |
| ↳ *% of Winner* | **100.0%** | 11.6% | 66.2% | N/A | 40.0% | 53.0% | N/A | 45.4% |
| **`canada.json`** (2.15 MB) | 🥇 **431.6 MB/s (4.97 ms)** | 48.8 MB/s (43.96 ms) | 🥈 **220.5 MB/s (9.74 ms)** | N/A | 78.4 MB/s (27.37 ms) | 🥉 **190.6 MB/s (11.26 ms)** | N/A | 134.3 MB/s (15.98 ms) |
| ↳ *% of Winner* | **100.0%** | 11.3% | 51.1% | N/A | 18.2% | 44.2% | N/A | 31.1% |
<!-- mdformat on -->

## 2.2 ENCODE — Complete Cross-Language Matrix (Typed Structs + Untyped DOM)

Includes both **Typed Struct** contenders (`Rust`, `Go`, `Dart json_serializable`, `Dart package:codable`) and **Untyped DOM** parsers (`Node.js V8 [Untyped JS Object]`, `Stock/New Dart std_convert [Untyped Map/DOM]`). Medals (🥇, 🥈, 🥉) indicate top 3 raw throughput across all 8 columns.

<!-- mdformat off -->
| Dataset | Rust (`serde_json` Typed) | Go (`encoding/json` Typed) | Node.js V8 (`Untyped JS Object`) | Stock Dart + `json_serializable` (`Typed`) | New Dart + `json_serializable` (`Typed`) | New Dart + `package:codable` (`Typed`) | Stock Dart `std_convert` (`Untyped Map/DOM`) | New Dart `std_convert` (`Untyped Map/DOM`) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **`small.json`** (546 B) | 🥇 **918.8 MB/s (567 ns)** | 🥈 **388.2 MB/s (1.34 µs)** | 🥉 **343.1 MB/s (1.52 µs)** | N/A | 91.5 MB/s (5.69 µs) | 303.9 MB/s (1.71 µs) | N/A | 114.7 MB/s (4.54 µs) |
| ↳ *% of Winner* | **100.0%** | 42.3% | 37.3% | N/A | 10.0% | 33.1% | N/A | 12.5% |
| **`twitter.json`** (616.7 KB) | 🥇 **1245.4 MB/s (483.60 µs)** | 🥈 **675.5 MB/s (891.53 µs)** | 335.5 MB/s (1.80 ms) | N/A | 190.9 MB/s (3.15 ms) | 🥉 **378.0 MB/s (1.59 ms)** | N/A | 241.9 MB/s (2.49 ms) |
| ↳ *% of Winner* | **100.0%** | 54.2% | 26.9% | N/A | 15.3% | 30.3% | N/A | 19.4% |
| **`citm_catalog.json`** (1.65 MB) | 🥇 **2960.8 MB/s (556.33 µs)** | 🥈 **1259.1 MB/s (1.31 ms)** | 488.5 MB/s (3.37 ms) | N/A | 281.6 MB/s (5.85 ms) | 🥉 **562.2 MB/s (2.93 ms)** | N/A | 414.1 MB/s (3.98 ms) |
| ↳ *% of Winner* | **100.0%** | 42.5% | 16.5% | N/A | 9.5% | 19.0% | N/A | 14.0% |
| **`canada.json`** (2.15 MB) | 🥇 **677.2 MB/s (3.17 ms)** | 🥈 **156.2 MB/s (13.74 ms)** | 🥉 **125.2 MB/s (17.15 ms)** | N/A | 100.5 MB/s (21.37 ms) | 89.6 MB/s (23.96 ms) | N/A | 99.9 MB/s (21.49 ms) |
| ↳ *% of Winner* | **100.0%** | 23.1% | 18.5% | N/A | 14.8% | 13.2% | N/A | 14.8% |
<!-- mdformat on -->

