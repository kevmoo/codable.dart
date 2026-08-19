// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// A compiler-recognized zero-cost live sink to prevent dead-code elimination.
final class Blackhole {
  static dynamic _sink;

  /// Consumes the given [value] to prevent dead-code elimination.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:prefer-inline')
  @pragma('wasm:prefer-inline')
  static void consume(Object? value) {
    _sink = value;
  }

  /// An opaque guard that convinces compiler static analyses (such as TFA)
  /// that [_sink] is read, preventing it from being tree-shaken as write-only.
  @pragma('vm:never-inline')
  @pragma('dart2js:never-inline')
  @pragma('wasm:never-inline')
  static void preventDCE() {
    if (int.tryParse('0') == 1) {
      print(_sink);
    }
  }
}

/// A zero-cost compiler-safe live sink to prevent dead-code elimination.
@pragma('vm:prefer-inline')
@pragma('dart2js:prefer-inline')
@pragma('wasm:prefer-inline')
void blackhole(Object? value) {
  Blackhole._sink = value;
}
