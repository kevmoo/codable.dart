// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:path/path.dart' as p;

const nodeExecutable =
    '/usr/local/google/home/kevmoo/.local/share/mise/installs/node/24/bin/node';

Future<void> main(List<String> args) async {
  final sdkDart = Platform.resolvedExecutable;
  print('============================================================');
  print('🚀 UNIFIED MULTI-RUNTIME BENCHMARK SWEEP (AOT, JS, WASM)');
  print('SDK: $sdkDart');
  print('Version: ${Platform.version}');
  print('============================================================\n');

  final tempDir = Directory.systemTemp.createTempSync('codable_bench_sweep_');
  final jsHarness = p.join(tempDir.path, 'harness.js');
  final wasmHarness = p.join(tempDir.path, 'benchmark.wasm');
  final aotHarness = p.join(tempDir.path, 'harness.exe');
  final harnessSource = p.join('tool', 'profiler', 'benchmark_harness.dart');

  print('📦 Step 1: Compiling harnesses across all 3 targets...');

  // 1. Compile AOT
  print('  [1/3] Compiling AOT executable ($aotHarness)...');
  final aotRes = await Process.run(sdkDart, [
    'compile',
    'exe',
    harnessSource,
    '-o',
    aotHarness,
  ]);
  if (aotRes.exitCode != 0) {
    stderr.writeln('AOT compilation failed:\n${aotRes.stderr}');
    exit(1);
  }

  // 2. Compile JS
  print('  [2/3] Compiling JS module ($jsHarness)...');
  final jsRes = await Process.run(sdkDart, [
    'compile',
    'js',
    harnessSource,
    '-o',
    jsHarness,
  ]);
  if (jsRes.exitCode != 0) {
    stderr.writeln('JS compilation failed:\n${jsRes.stderr}');
    exit(1);
  }

  // 3. Compile Wasm
  print('  [3/3] Compiling Wasm module ($wasmHarness)...');
  final wasmRes = await Process.run(sdkDart, [
    'compile',
    'wasm',
    harnessSource,
    '-o',
    wasmHarness,
  ]);
  if (wasmRes.exitCode != 0) {
    stderr.writeln('Wasm compilation failed:\n${wasmRes.stderr}');
    exit(1);
  }
  print('✅ All compilers succeeded.\n');

  final results = <String, Map<String, Map<String, double>>>{
    'aot': {},
    'js': {},
    'wasm': {},
  };

  Map<String, Map<String, double>> extractJson(String output) {
    const startTag = '<<<BENCHMARK_RESULTS_JSON_START>>>';
    const endTag = '<<<BENCHMARK_RESULTS_JSON_END>>>';
    final startIndex = output.indexOf(startTag);
    final endIndex = output.indexOf(endTag);
    if (startIndex == -1 || endIndex == -1) {
      throw StateError(
        'Could not find benchmark JSON markers in output:\n$output',
      );
    }
    final jsonStr = output
        .substring(startIndex + startTag.length, endIndex)
        .trim();
    final decoded = jsonDecode(jsonStr) as Map<String, dynamic>;
    final map = <String, Map<String, double>>{};
    for (final e in decoded.entries) {
      map[e.key] = (e.value as Map<String, dynamic>).map(
        (k, v) => MapEntry(k, (v as num).toDouble()),
      );
    }
    return map;
  }

  // --- AOT Execution ---
  print('⚡ Step 2: Executing AOT Benchmark Suite (Single Process)...');
  final aotExec = await Process.run(aotHarness, ['all']);
  if (aotExec.exitCode != 0) {
    stderr.writeln('AOT execution failed:\n${aotExec.stderr}');
    exit(1);
  }
  results['aot'] = extractJson(aotExec.stdout as String);
  print(
    '  ✅ AOT suite complete: ${results['aot']!.length} benchmarks recorded.',
  );

  // --- JS Execution ---
  print('\n⚡ Step 3: Executing JS Benchmark Suite (Node 24 CLI)...');
  final jsExec = await Process.run(nodeExecutable, [jsHarness]);
  if (jsExec.exitCode != 0) {
    stderr.writeln('JS execution failed:\n${jsExec.stderr}');
    exit(1);
  }
  results['js'] = extractJson(jsExec.stdout as String);
  print('  ✅ JS suite complete: ${results['js']!.length} benchmarks recorded.');

  // --- Wasm Execution (Node 24 CLI) ---
  print('\n⚡ Step 4: Executing Wasm Benchmark Suite (Node 24 CLI)...');
  final wasmRunnerScript = p.join(tempDir.path, 'run_wasm.mjs');
  final wasmFile = File(wasmHarness);
  final mjsFile = File(p.setExtension(wasmHarness, '.mjs'));
  final runnerJs =
      '''
import * as fs from 'fs';
import { compile } from './${p.basename(mjsFile.path)}';

const bytes = fs.readFileSync('./${p.basename(wasmFile.path)}');
const app = await compile(bytes);
const inst = await app.instantiate();
inst.invokeMain('all', '', '');
''';
  await File(wasmRunnerScript).writeAsString(runnerJs);

  final wasmExec = await Process.run(nodeExecutable, [
    wasmRunnerScript,
  ], workingDirectory: tempDir.path);
  if (wasmExec.exitCode != 0) {
    stderr.writeln('Wasm execution failed:\n${wasmExec.stderr}');
    exit(1);
  }
  results['wasm'] = extractJson(wasmExec.stdout as String);
  print(
    '  ✅ Wasm suite complete: ${results['wasm']!.length} benchmarks recorded.',
  );

  print('\n============================================================');
  print('📊 CANONICAL BENCHMARK MATRIX (AOT vs JS vs WASM)');
  print('============================================================\n');

  String formatTime(double us) {
    if (us >= 1000.0) {
      return '${(us / 1000.0).toStringAsFixed(2)} ms';
    }
    return '${us.toStringAsFixed(1)} µs';
  }

  String formatSpeedup(double jsUs, double codableUs) {
    if (codableUs <= 0.0) return 'N/A';
    final ratio = jsUs / codableUs;
    return '**${ratio.toStringAsFixed(2)}x**';
  }

  final reportBuffer = StringBuffer();
  reportBuffer.writeln(
    '### 📊 3-Runtime Summary (Relative Efficiency Index)\n',
  );
  reportBuffer.writeln('<!-- mdformat off(prevent table wrapping) -->');
  reportBuffer.writeln(
    '| Target Runtime | Dart Configuration | 📥 Decode Efficiency<br/>[ Worst / GeoMean / Best ] | 📤 Encode Efficiency<br/>[ Worst / GeoMean / Best ] |',
  );
  reportBuffer.writeln('| :--- | :--- | :---: | :---: |');

  final benchmarks = [
    'coordinates_decode',
    'canada_decode',
    'citm_catalog_decode',
    'small_decode',
    'twitter_decode',
    'coordinates_encode',
    'canada_encode',
    'citm_catalog_encode',
    'small_encode',
    'twitter_encode',
  ];

  // Compute efficiency indices
  // Relative Throughput Efficiency: 100 = Peak Speed
  for (final target in ['aot', 'js', 'wasm']) {
    final decodeScores = <double>[];
    final encodeScores = <double>[];
    for (final b in benchmarks) {
      final jsTime = results[target]![b]!['json_serializable'] ?? 1.0;
      final codableTime = results[target]![b]!['codable'] ?? 1.0;
      final minTime = min(jsTime, codableTime);
      final score = (minTime / codableTime) * 100.0;
      if (b.endsWith('_decode')) {
        decodeScores.add(score);
      } else {
        encodeScores.add(score);
      }
    }
    double geomean(List<double> list) {
      final prod = list.fold(1.0, (acc, v) => acc * v);
      return pow(prod, 1.0 / list.length).toDouble();
    }

    final decGeo = geomean(decodeScores);
    final encGeo = geomean(encodeScores);

    final decWorst = decodeScores.reduce(min);
    final decBest = decodeScores.reduce(max);
    final encWorst = encodeScores.reduce(min);
    final encBest = encodeScores.reduce(max);

    String badge(double g) => g >= 90.0 ? '🟢' : (g >= 70.0 ? '🟡' : '🔴');

    final targetLabel = switch (target) {
      'aot' => '**AOT (`dart compile exe`)**',
      'js' => '**JS (`dart2js` / Node 24 / V8)**',
      'wasm' => '**WASM (`dart2wasm` / Node 24 / V8)**',
      _ => target,
    };

    final decW = decWorst.round();
    final decG = decGeo.round();
    final decB = decBest.round();
    final encW = encWorst.round();
    final encG = encGeo.round();
    final encB = encBest.round();

    reportBuffer.writeln(
      '| $targetLabel | **`New Dart + Codable`** | '
      '${badge(decGeo)} `[ $decW / $decG / $decB ]` | '
      '${badge(encGeo)} `[ $encW / $encG / $encB ]` |',
    );
  }
  reportBuffer
    ..writeln('<!-- mdformat on -->\n')
    ..writeln('${'-' * 72}\n');

  // Detailed breakdowns
  final datasetNames = {
    'coordinates': '10k Coordinates (0.39 MB)',
    'canada': 'canada.json (2.25 MB)',
    'citm_catalog': 'citm_catalog.json (1.73 MB)',
    'small': 'small.json (0.55 KB)',
    'twitter': 'twitter.json (0.62 MB)',
  };

  for (final target in ['aot', 'js', 'wasm']) {
    final title = switch (target) {
      'aot' => 'AOT Target Detailed Breakdown',
      'js' => 'JS Target Detailed Breakdown',
      'wasm' => 'WASM Target Detailed Breakdown',
      _ => target,
    };

    reportBuffer.writeln('### 🎯 $title\n');
    for (final mode in ['decode', 'encode']) {
      final modeTitle = switch (target) {
        'aot' => 'AOT ${mode[0].toUpperCase()}${mode.substring(1)}',
        'js' => 'JS ${mode[0].toUpperCase()}${mode.substring(1)}',
        'wasm' => 'WASM ${mode[0].toUpperCase()}${mode.substring(1)}',
        _ => mode,
      };

      reportBuffer.writeln('#### Detailed Breakdown: $modeTitle\n');
      reportBuffer.writeln('<!-- mdformat off(prevent table wrapping) -->');
      reportBuffer.writeln(
        '| Workload / Dataset | json_serializable | package:codable | '
        'Speedup vs json_serializable |',
      );
      reportBuffer.writeln('| :--- | :---: | :---: | :---: |');

      for (final ds in [
        'coordinates',
        'canada',
        'citm_catalog',
        'small',
        'twitter',
      ]) {
        final b = '${ds}_$mode';
        final jsVal = results[target]![b]!['json_serializable']!;
        final codableVal = results[target]![b]!['codable']!;
        final dsName = datasetNames[ds]!;
        reportBuffer.writeln(
          '| **$dsName** | ${formatTime(jsVal)} | '
          '**${formatTime(codableVal)}** | '
          '${formatSpeedup(jsVal, codableVal)} |',
        );
      }
      reportBuffer.writeln('<!-- mdformat on -->\n\n');
    }
    reportBuffer.writeln('${'-' * 72}\n');
  }

  print(reportBuffer.toString());

  // Save telemetry JSON
  final outputFile = File(p.join('benchmark_results_unified.json'));
  await outputFile.writeAsString(
    const JsonEncoder.withIndent('  ').convert(results),
  );
  print('💾 Telemetry saved to ${outputFile.path}');
}
