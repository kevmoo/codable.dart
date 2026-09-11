// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Deprecated runner facade.
///
/// Canonical benchmarks in package:codable now execute via
/// `package:bench_press`:
///
/// ```bash
/// dart run bench_press run benchmark/
/// dart run tool/generate_report.dart
/// ```
library;

import 'dart:io';

import 'package:codable/src/json/substrate/substrate.dart';
import 'package:path/path.dart' as p;

Future<void> main(List<String> args) async {
  stderr.writeln('''
========================================================================
⚠️ DEPRECATION NOTICE: run_full_suite.dart is deprecated!
Canonical benchmarks in package:codable now execute via package:bench_press:

  dart run bench_press run benchmark/

And reports are generated via:

  dart run tool/generate_report.dart
========================================================================
''');

  if (isMockSubstrate) {
    stderr.writeln(
      '⚠️ FATAL: benchmarks cannot run on the mock substrate.\n'
      'Canonical benchmarks MUST run against the native SDK substrate.\n'
      'Switch with: dart run tool/switch_substrate.dart native\n',
    );
    exit(1);
  }

  print('⚡ Delegating to package:bench_press run benchmark/ ...\n');
  final sdkDart = Platform.resolvedExecutable;
  final bpRes = await Process.start(sdkDart, [
    'run',
    'bench_press',
    'run',
    '--force-run',
    'benchmark/',
  ], mode: ProcessStartMode.inheritStdio);
  final bpExit = await bpRes.exitCode;
  if (bpExit != 0) {
    stderr.writeln('bench_press execution exited with code $bpExit');
    exit(bpExit);
  }

  print('\n⚡ Generating canonical BENCHMARK_REPORT.md ...\n');
  final genScript = p.join('tool', 'generate_report.dart');
  final genRes = await Process.start(sdkDart, [
    'run',
    genScript,
  ], mode: ProcessStartMode.inheritStdio);
  final genExit = await genRes.exitCode;
  exit(genExit);
}
