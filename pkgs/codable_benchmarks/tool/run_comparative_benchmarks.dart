// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// ignore_for_file: lines_longer_than_80_chars, omit_local_variable_types, prefer_interpolation_to_compose_strings, unnecessary_brace_in_string_interps

import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';

final packageRoot = File(Platform.script.toFilePath()).parent.parent.path;

String _findStockDart(String? explicitPath) {
  if (explicitPath != null && explicitPath.isNotEmpty) {
    final candidate = File(explicitPath);
    if (candidate.existsSync()) return candidate.path;
    final dirCandidate = File('$explicitPath/bin/dart');
    if (dirCandidate.existsSync()) return dirCandidate.path;
    throw ArgumentError('Explicit stock Dart SDK not found at: $explicitPath');
  }

  // 1. Flutter bundled SDK (contains full AOT, JS, and WASM toolchains)
  final candidate1 = File(
    '${Platform.environment['HOME'] ?? ''}/github/flutter/bin/cache/dart-sdk/bin/dart',
  );
  if (candidate1.existsSync()) return candidate1.path;

  // 2. System Google Dartlang
  final candidate2 = File('/usr/lib/google-dartlang/bin/dart');
  if (candidate2.existsSync()) return candidate2.path;

  return Platform.resolvedExecutable;
}

String _findNewDart(String? explicitPath) {
  if (explicitPath != null && explicitPath.isNotEmpty) {
    final candidate = File(explicitPath);
    if (candidate.existsSync()) return candidate.path;
    final dirCandidate = File('$explicitPath/bin/dart');
    if (dirCandidate.existsSync()) return dirCandidate.path;
    throw ArgumentError('Explicit new Dart SDK not found at: $explicitPath');
  }

  // 1. Deployed custom json-utf8-kernels SDK
  final candidate1 = File(
    '${Platform.environment['HOME'] ?? ''}/.local/share/dart-sdk-json-utf8-kernels/dart-sdk/bin/dart',
  );
  if (candidate1.existsSync()) return candidate1.path;

  // 2. Built ReleaseX64 SDK
  final candidate2 = File(
    '${Platform.environment['HOME'] ?? ''}/github/dart-sdk/out/ReleaseX64/dart-sdk/bin/dart',
  );
  if (candidate2.existsSync()) return candidate2.path;

  return Platform.resolvedExecutable;
}

String _findNode() {
  final home = Platform.environment['HOME'] ?? '';
  final candidate1 = File('$home/.local/share/mise/installs/node/24/bin/node');
  if (candidate1.existsSync()) return candidate1.path;
  final candidate2 = File('$home/.local/share/mise/shims/node');
  if (candidate2.existsSync()) return candidate2.path;
  return 'node';
}

void main(List<String> rawArgs) async {
  final parser = ArgParser()
    ..addOption(
      'dataset',
      abbr: 'd',
      defaultsTo: 'all',
      allowed: [
        'coordinates',
        'canada',
        'citm_catalog',
        'small',
        'twitter',
        'all',
      ],
      help: 'Filter dataset',
    )
    ..addOption(
      'mode',
      abbr: 'm',
      defaultsTo: 'all',
      allowed: ['decode', 'decode_literal', 'encode', 'all'],
      help: 'Filter benchmark mode',
    )
    ..addOption(
      'target',
      abbr: 't',
      defaultsTo: 'aot',
      allowed: ['aot', 'js', 'wasm', 'jit', 'all'],
      help: 'Compilation/runtime target',
    )
    ..addOption(
      'stock-sdk',
      help: 'Path to stock/baseline Dart SDK (or bin/dart)',
    )
    ..addOption(
      'new-sdk',
      help: 'Path to custom/next-gen Dart SDK (or bin/dart)',
    )
    ..addOption(
      'iterations',
      abbr: 'n',
      defaultsTo: '50',
      help: 'Iterations per test',
    )
    ..addOption('warmup', abbr: 'w', defaultsTo: '5', help: 'Warmup iterations')
    ..addOption('output-md', help: 'Save markdown report to file')
    ..addOption('output-json', help: 'Save JSON results to file');

  final args = parser.parse(rawArgs);
  final dataset = args['dataset'] as String;
  final mode = args['mode'] as String;
  final target = args['target'] as String;
  final iters = args['iterations'] as String;
  final warmup = args['warmup'] as String;
  final outputMd = args['output-md'] as String?;
  final outputJson = args['output-json'] as String?;

  final stockDart = _findStockDart(args['stock-sdk'] as String?);
  final newDart = _findNewDart(args['new-sdk'] as String?);
  final nodeBin = _findNode();

  final targets = target == 'all' ? ['aot', 'js', 'wasm'] : [target];

  print(
    '========================================================================',
  );
  print('3-Tier Dart Serialization Comparative Benchmark Suite');
  print(
    '========================================================================',
  );
  print('Stock Dart SDK : $stockDart');
  print('New Dart SDK   : $newDart');
  print('Node Runtime   : $nodeBin');
  print('Target(s)      : ${targets.join(', ')}');
  print('Datasets       : $dataset');
  print('Modes          : $mode');
  print(
    '========================================================================\n',
  );

  final binDir = Directory('$packageRoot/build/bench_bin');
  if (!binDir.existsSync()) {
    binDir.createSync(recursive: true);
  }

  // Write wasm runner helper
  final wasmRunnerPath = '${binDir.path}/run_wasm_helper.mjs';
  File(wasmRunnerPath).writeAsStringSync('''
import * as fs from 'fs';
import { pathToFileURL } from 'url';

const wasmPath = process.argv[2];
const mjsPath = process.argv[3];
const scriptArgs = process.argv.slice(4);

const mjsModule = await import(pathToFileURL(mjsPath).href);
const bytes = fs.readFileSync(wasmPath);
const compiled = await mjsModule.compile(bytes);
const instance = await compiled.instantiate();
await instance.invokeMain(...scriptArgs);
''');

  final jsonSerialScript =
      '$packageRoot/benchmark/suites/bench_json_serializable.dart';
  final codableScript = '$packageRoot/benchmark/suites/bench_codable.dart';

  final allTargetReports = <String, String>{};
  final allTargetJson = <String, dynamic>{};

  for (final t in targets) {
    print(
      '------------------------------------------------------------------------',
    );
    print('🎯 Running Target: ${t.toUpperCase()}');
    print(
      '------------------------------------------------------------------------',
    );

    String t1Exe = jsonSerialScript;
    String t2Exe = jsonSerialScript;
    String t3Exe = codableScript;

    if (t == 'aot') {
      print('⚙️  Compiling Tier 1 (Stock + json_serial AOT)...');
      t1Exe = '${binDir.path}/stock_json_serial.exe';
      await _compileExe(stockDart, jsonSerialScript, t1Exe);

      print('⚙️  Compiling Tier 2 (New + json_serial AOT)...');
      t2Exe = '${binDir.path}/new_json_serial.exe';
      await _compileExe(newDart, jsonSerialScript, t2Exe);

      print('⚙️  Compiling Tier 3 (New + Codable AOT)...');
      t3Exe = '${binDir.path}/new_codable.exe';
      await _compileExe(newDart, codableScript, t3Exe);
    } else if (t == 'js') {
      print('⚙️  Compiling Tier 1 (Stock + json_serial JS)...');
      t1Exe = '${binDir.path}/stock_json_serial.js';
      await _compileJs(stockDart, jsonSerialScript, t1Exe);

      print('⚙️  Compiling Tier 2 (New + json_serial JS)...');
      t2Exe = '${binDir.path}/new_json_serial.js';
      await _compileJs(newDart, jsonSerialScript, t2Exe);

      print('⚙️  Compiling Tier 3 (New + Codable JS)...');
      t3Exe = '${binDir.path}/new_codable.js';
      await _compileJs(newDart, codableScript, t3Exe);
    } else if (t == 'wasm') {
      print('⚙️  Compiling Tier 1 (Stock + json_serial WASM)...');
      t1Exe = '${binDir.path}/stock_json_serial.wasm';
      await _compileWasm(stockDart, jsonSerialScript, t1Exe);

      print('⚙️  Compiling Tier 2 (New + json_serial WASM)...');
      t2Exe = '${binDir.path}/new_json_serial.wasm';
      await _compileWasm(newDart, jsonSerialScript, t2Exe);

      print('⚙️  Compiling Tier 3 (New + Codable WASM)...');
      t3Exe = '${binDir.path}/new_codable.wasm';
      await _compileWasm(newDart, codableScript, t3Exe);
    }

    // Execute Tiers
    print('🚀 Executing Tier 1: Stock Dart + json_serializable...');
    final t1Res = await _runBenchmarkTier(
      target: t,
      dartBin: stockDart,
      nodeBin: nodeBin,
      wasmRunner: wasmRunnerPath,
      targetFile: t1Exe,
      engineLabel: 'old_dart_json_serial',
      dataset: dataset,
      mode: mode,
      iters: iters,
      warmup: warmup,
    );

    print('🚀 Executing Tier 2: New Dart + json_serializable...');
    final t2Res = await _runBenchmarkTier(
      target: t,
      dartBin: newDart,
      nodeBin: nodeBin,
      wasmRunner: wasmRunnerPath,
      targetFile: t2Exe,
      engineLabel: 'new_dart_json_serial',
      dataset: dataset,
      mode: mode,
      iters: iters,
      warmup: warmup,
    );

    print('🚀 Executing Tier 3: New Dart + Codable streaming...');
    final t3Res = await _runBenchmarkTier(
      target: t,
      dartBin: newDart,
      nodeBin: nodeBin,
      wasmRunner: wasmRunnerPath,
      targetFile: t3Exe,
      engineLabel: 'new_dart_codable',
      dataset: dataset,
      mode: mode,
      iters: iters,
      warmup: warmup,
    );

    final report = _formatMarkdownReport(
      targetLabel: t.toUpperCase(),
      tier1Results: t1Res,
      tier2Results: t2Res,
      tier3Results: t3Res,
      stockDartPath: stockDart,
      newDartPath: newDart,
      nodeBinPath: nodeBin,
    );

    allTargetReports[t] = report;
    allTargetJson[t] = {
      'tier1_old_dart_json_serial': t1Res,
      'tier2_new_dart_json_serial': t2Res,
      'tier3_new_dart_codable': t3Res,
    };

    print('\n$report\n');
  }

  if (outputMd != null) {
    File(outputMd).writeAsStringSync(
      allTargetReports.values.map((s) => s.trim()).join('\n\n') + '\n',
    );
    print('📄 Saved Markdown report to: $outputMd');
  }

  if (outputJson != null) {
    final combinedJson = {
      'stock_dart_path': stockDart,
      'new_dart_path': newDart,
      'generated_at': DateTime.now().toUtc().toIso8601String(),
      'targets': allTargetJson,
    };
    File(outputJson).writeAsStringSync(
      const JsonEncoder.withIndent('  ').convert(combinedJson),
    );
    print('💾 Saved JSON results to: $outputJson');
  }
}

Future<void> _compileExe(
  String dartBin,
  String script,
  String outputExe,
) async {
  final proc = await Process.run(dartBin, [
    'compile',
    'exe',
    script,
    '-o',
    outputExe,
  ], workingDirectory: packageRoot);
  if (proc.exitCode != 0) {
    stderr.writeln('AOT compilation failed for $script with $dartBin:');
    stderr.writeln(proc.stderr);
    stderr.writeln(proc.stdout);
    exit(1);
  }
}

Future<void> _compileJs(String dartBin, String script, String outputJs) async {
  final proc = await Process.run(dartBin, [
    'compile',
    'js',
    script,
    '-o',
    outputJs,
    '-O4',
  ], workingDirectory: packageRoot);
  if (proc.exitCode != 0) {
    stderr.writeln('JS compilation failed for $script with $dartBin:');
    stderr.writeln(proc.stderr);
    stderr.writeln(proc.stdout);
    exit(1);
  }
}

Future<void> _compileWasm(
  String dartBin,
  String script,
  String outputWasm,
) async {
  final proc = await Process.run(dartBin, [
    'compile',
    'wasm',
    script,
    '-o',
    outputWasm,
    '-O2',
  ], workingDirectory: packageRoot);
  if (proc.exitCode != 0) {
    stderr.writeln('Wasm compilation failed for $script with $dartBin:');
    stderr.writeln(proc.stderr);
    stderr.writeln(proc.stdout);
    exit(1);
  }
}

Future<List<Map<String, dynamic>>> _runBenchmarkTier({
  required String target,
  required String dartBin,
  required String nodeBin,
  required String wasmRunner,
  required String targetFile,
  required String engineLabel,
  required String dataset,
  required String mode,
  required String iters,
  required String warmup,
}) async {
  String cmd;
  List<String> args;

  if (target == 'aot') {
    cmd = targetFile;
    args = [
      '-d',
      dataset,
      '-m',
      mode,
      '-n',
      iters,
      '-w',
      warmup,
      '--engine-label=$engineLabel',
      '--json',
    ];
  } else if (target == 'js') {
    cmd = nodeBin;
    args = [
      targetFile,
      '-d',
      dataset,
      '-m',
      mode,
      '-n',
      iters,
      '-w',
      warmup,
      '--engine-label=$engineLabel',
      '--json',
    ];
  } else if (target == 'wasm') {
    cmd = nodeBin;
    final mjsPath = targetFile.replaceAll(RegExp(r'\.wasm$'), '.mjs');
    args = [
      wasmRunner,
      targetFile,
      mjsPath,
      '-d',
      dataset,
      '-m',
      mode,
      '-n',
      iters,
      '-w',
      warmup,
      '--engine-label=$engineLabel',
      '--json',
    ];
  } else {
    // JIT
    cmd = dartBin;
    args = [
      'run',
      targetFile,
      '-d',
      dataset,
      '-m',
      mode,
      '-n',
      iters,
      '-w',
      warmup,
      '--engine-label=$engineLabel',
      '--json',
    ];
  }

  final proc = await Process.run(cmd, args, workingDirectory: packageRoot);

  if (proc.exitCode != 0) {
    stderr.writeln('Benchmark execution failed ($target):');
    stderr.writeln(proc.stderr);
    stderr.writeln(proc.stdout);
    exit(1);
  }

  final out = (proc.stdout as String).trim();
  try {
    final list = jsonDecode(out) as List<dynamic>;
    return list.cast<Map<String, dynamic>>();
  } catch (_) {
    final lines = out.split('\n');
    final parsedList = <Map<String, dynamic>>[];
    final lineRegex = RegExp(
      r'\[(?<engine>[\w_]+)\]\s+(?<dataset>\w+)\s+(?<mode>\w+)\s*:\s*(?<latency>[\d\.]+)\s*ms\s*\|\s*(?<throughput>[\d\.]+|Infinity)\s*MB/s',
    );
    for (final line in lines) {
      final m = lineRegex.firstMatch(line.trim());
      if (m != null) {
        parsedList.add({
          'engine': m.namedGroup('engine')!,
          'dataset': m.namedGroup('dataset')!,
          'mode': m.namedGroup('mode')!,
          'latency_ms': double.parse(m.namedGroup('latency')!),
          'throughput_mb_s': m.namedGroup('throughput') == 'Infinity'
              ? 99999.0
              : double.parse(m.namedGroup('throughput')!),
        });
      }
    }
    if (parsedList.isNotEmpty) return parsedList;
    stderr.writeln('Failed to parse JSON or text benchmark output: $out');
    rethrow;
  }
}

String _formatMarkdownReport({
  required String targetLabel,
  required List<Map<String, dynamic>> tier1Results,
  required List<Map<String, dynamic>> tier2Results,
  required List<Map<String, dynamic>> tier3Results,
  required String stockDartPath,
  required String newDartPath,
  required String nodeBinPath,
}) {
  final sb = StringBuffer();
  sb.writeln('### 📊 Summary of $targetLabel Decode Benchmark Results');
  sb.writeln('');
  sb.writeln('<!-- mdformat off(prevent table wrapping) -->');
  sb.writeln(
    '| Workload / Dataset | Old Dart + json_serial | New Dart + json_serial | New Dart + Codable | Speedup vs Old Dart | Speedup vs New json_serial |',
  );
  sb.writeln('| :--- | :---: | :---: | :---: | :---: | :---: |');

  final decodeT1 = {
    for (var r in tier1Results.where((r) => r['mode'] == 'decode'))
      r['dataset']: r,
  };
  final decodeT2 = {
    for (var r in tier2Results.where((r) => r['mode'] == 'decode'))
      r['dataset']: r,
  };
  final decodeT3 = {
    for (var r in tier3Results.where((r) => r['mode'] == 'decode'))
      r['dataset']: r,
  };

  for (final dataset in decodeT1.keys) {
    final t1 = decodeT1[dataset];
    final t2 = decodeT2[dataset];
    final t3 = decodeT3[dataset];
    if (t1 == null || t2 == null || t3 == null) continue;

    final t1Ms = (t1['latency_ms'] as num).toDouble();
    final t2Ms = (t2['latency_ms'] as num).toDouble();
    final t3Ms = (t3['latency_ms'] as num).toDouble();

    final speedupVsOld = t3Ms > 0
        ? (t1Ms / t3Ms).toStringAsFixed(2) + 'x'
        : 'N/A';
    final speedupVsNewSerial = t3Ms > 0
        ? (t2Ms / t3Ms).toStringAsFixed(2) + 'x'
        : 'N/A';

    final dsLabel = dataset == 'citm_catalog'
        ? 'citm_catalog.json (1.73 MB)'
        : dataset == 'canada'
        ? 'canada.json (2.25 MB)'
        : dataset == 'coordinates'
        ? '10k Coordinates (0.39 MB)'
        : dataset == 'small'
        ? 'small.json (0.55 KB)'
        : dataset == 'twitter'
        ? 'twitter.json (0.62 MB)'
        : dataset;

    sb.writeln(
      '| **$dsLabel** | ${t1Ms.toStringAsFixed(2)} ms | ${t2Ms.toStringAsFixed(2)} ms | **${t3Ms.toStringAsFixed(2)} ms** | **${speedupVsOld}** | **${speedupVsNewSerial}** |',
    );
  }
  sb.writeln('<!-- mdformat on -->');

  final encodeT1 = {
    for (var r in tier1Results.where((r) => r['mode'] == 'encode'))
      r['dataset']: r,
  };
  final encodeT2 = {
    for (var r in tier2Results.where((r) => r['mode'] == 'encode'))
      r['dataset']: r,
  };
  final encodeT3 = {
    for (var r in tier3Results.where((r) => r['mode'] == 'encode'))
      r['dataset']: r,
  };

  if (encodeT1.isNotEmpty) {
    sb.writeln('');
    sb.writeln('### 📊 Summary of $targetLabel Encode Benchmark Results');
    sb.writeln('');
    sb.writeln('<!-- mdformat off(prevent table wrapping) -->');
    sb.writeln(
      '| Workload / Dataset | Old Dart + json_serial | New Dart + json_serial | New Dart + Codable | Speedup vs Old Dart | Speedup vs New json_serial |',
    );
    sb.writeln('| :--- | :---: | :---: | :---: | :---: | :---: |');

    for (final dataset in encodeT1.keys) {
      final t1 = encodeT1[dataset];
      final t2 = encodeT2[dataset];
      final t3 = encodeT3[dataset];
      if (t1 == null || t2 == null || t3 == null) continue;

      final t1Ms = (t1['latency_ms'] as num).toDouble();
      final t2Ms = (t2['latency_ms'] as num).toDouble();
      final t3Ms = (t3['latency_ms'] as num).toDouble();

      final speedupVsOld = t3Ms > 0
          ? (t1Ms / t3Ms).toStringAsFixed(2) + 'x'
          : 'N/A';
      final speedupVsNewSerial = t3Ms > 0
          ? (t2Ms / t3Ms).toStringAsFixed(2) + 'x'
          : 'N/A';

      final dsLabel = dataset == 'citm_catalog'
          ? 'citm_catalog.json (1.73 MB)'
          : dataset == 'canada'
          ? 'canada.json (2.25 MB)'
          : dataset == 'coordinates'
          ? '10k Coordinates (0.39 MB)'
          : dataset == 'small'
          ? 'small.json (0.55 KB)'
          : dataset == 'twitter'
          ? 'twitter.json (0.62 MB)'
          : dataset;

      sb.writeln(
        '| **$dsLabel** | ${t1Ms.toStringAsFixed(2)} ms | ${t2Ms.toStringAsFixed(2)} ms | **${t3Ms.toStringAsFixed(2)} ms** | **${speedupVsOld}** | **${speedupVsNewSerial}** |',
      );
    }
    sb.writeln('<!-- mdformat on -->');
  }

  return sb.toString();
}
