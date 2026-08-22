// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// A universal, zero-cost compiler sink that prevents dead-code
/// elimination (DCE) across VM (AOT/JIT), dart2js, and dart2wasm without
/// adding traversal or ALU overhead.
abstract final class Blackhole {
  static dynamic _sink;

  /// Assigns [value] to the internal static sink.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:prefer-inline')
  @pragma('wasm:prefer-inline')
  static set sink(Object? value) => _sink = value;

  /// Prevents Type Flow Analysis (TFA) tree-shaking while compiling to a no-op
  /// at runtime.
  @pragma('vm:never-inline')
  @pragma('dart2js:never-inline')
  @pragma('wasm:never-inline')
  static void preventDCE() {
    if (int.tryParse('0') == 1) {
      print(_sink);
    }
  }
}

/// Sinks [value] into [Blackhole] to prevent optimizing compilers from
/// dead-code eliminating the computation that produced it.
@pragma('vm:prefer-inline')
@pragma('dart2js:prefer-inline')
@pragma('wasm:prefer-inline')
void blackhole(Object? value) {
  Blackhole._sink = value;
}
