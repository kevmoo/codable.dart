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

  final candidate1 = File(
    '${Platform.environment['HOME'] ?? ''}/github/flutter/bin/cache/dart-sdk/bin/dart',
  );
  if (candidate1.existsSync()) return candidate1.path;

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

  final candidate1 = File(
    '${Platform.environment['HOME'] ?? ''}/.local/share/dart-sdk-json-utf8-kernels/dart-sdk/bin/dart',
  );
  if (candidate1.existsSync()) return candidate1.path;

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
    ..addOption(
      'concurrency',
      abbr: 'j',
      defaultsTo: '1',
      help:
          'Concurrent benchmark worker tasks (use 1 for statistical fidelity)',
    )
    ..addOption(
      'from-json',
      help: 'Path to benchmark JSON results to format into Markdown without re-running',
    )
    ..addOption('output-md', help: 'Save markdown report to file')
    ..addOption('output-json', help: 'Save JSON results to file');

  final args = parser.parse(rawArgs);
  final fromJsonPath = args['from-json'] as String?;
  final outputMd = args['output-md'] as String?;
  final outputJson = args['output-json'] as String?;

  if (fromJsonPath != null) {
    File resolveFile(String p) {
      if (p.startsWith('/')) return File(p);
      final fromCwd = File('${Directory.current.path}/$p');
      if (fromCwd.existsSync()) return fromCwd;
      return File('$packageRoot/$p');
    }

    final file = resolveFile(fromJsonPath);
    if (!file.existsSync()) {
      stderr.writeln('Error: JSON file not found at: ${file.path}');
      exit(1);
    }
    final rawData = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
    final targetsData = rawData['targets'] as Map<String, dynamic>? ?? {};
    final combinedMd = StringBuffer();

    for (final entry in targetsData.entries) {
      final tLabel = entry.key.toUpperCase();
      final tMap = entry.value as Map<String, dynamic>;
      final t1 = (tMap['tier1_old_dart_json_serial'] as List<dynamic>? ?? [])
          .cast<Map<String, dynamic>>();
      final t2 = (tMap['tier2_new_dart_json_serial'] as List<dynamic>? ?? [])
          .cast<Map<String, dynamic>>();
      final t3 = (tMap['tier3_new_dart_codable'] as List<dynamic>? ?? [])
          .cast<Map<String, dynamic>>();

      final report = _formatMarkdownReport(
        targetLabel: tLabel,
        tier1Results: t1,
        tier2Results: t2,
        tier3Results: t3,
        stockDartPath: rawData['stock_dart_path'] as String? ?? 'stock',
        newDartPath: rawData['new_dart_path'] as String? ?? 'new',
        nodeBinPath: 'node',
      );
      combinedMd.writeln(report);
      combinedMd.writeln(
        '\n------------------------------------------------------------------------\n',
      );
    }

    final rendered = combinedMd.toString();
    print(rendered);

    if (outputMd != null) {
      final mdFile = resolveFile(outputMd);
      mdFile.writeAsStringSync(rendered);
      print('>> Saved Markdown report to: ${mdFile.path}');
    }
    return;
  }

  final dataset = args['dataset'] as String;
  final mode = args['mode'] as String;
  final target = args['target'] as String;
  final iters = args['iterations'] as String;
  final warmup = args['warmup'] as String;
  final concurrency = int.tryParse(args['concurrency'] as String? ?? '8') ?? 8;

  final stockDart = _findStockDart(args['stock-sdk'] as String?);
  final newDart = _findNewDart(args['new-sdk'] as String?);
  final nodeBin = _findNode();

  print(
    '========================================================================',
  );
  print(
    '3-Tier Dart Serialization Comparative Benchmark Suite (Statistical KBSSD)',
  );
  print(
    '========================================================================',
  );
  print('Stock Dart SDK : $stockDart');
  print('New Dart SDK   : $newDart');
  print('Node Runtime   : $nodeBin');
  print('Target(s)      : $target');
  print('Datasets       : $dataset');
  print('Modes          : $mode');
  print('Concurrency    : $concurrency');
  print(
    '========================================================================\n',
  );

  final binDir = Directory('$packageRoot/build/bench_bin');
  if (!binDir.existsSync()) {
    binDir.createSync(recursive: true);
  }

  final wasmRunnerPath = '$packageRoot/bin/run_wasm.mjs';
  if (!File(wasmRunnerPath).existsSync()) {
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
  }

  final targets = target == 'all' ? ['aot', 'js', 'wasm'] : [target];
  final jsonSerialScript =
      '$packageRoot/benchmark/suites/bench_json_serializable.dart';
  final codableScript = '$packageRoot/benchmark/suites/bench_codable.dart';

  final allTargetReports = <String, String>{};
  final allTargetJson = <String, Map<String, dynamic>>{};

  final targetDatasets = dataset == 'all'
      ? ['coordinates', 'canada', 'citm_catalog', 'small', 'twitter']
      : [dataset];

  final targetModes = mode == 'all'
      ? ['decode', 'decode_literal', 'encode']
      : [mode];

  for (final t in targets) {
    print(
      '------------------------------------------------------------------------',
    );
    print('🎯 Running Target: ${t.toUpperCase()}');
    print(
      '------------------------------------------------------------------------',
    );

    String t1Exe = '';
    String t2Exe = '';
    String t3Exe = '';

    if (t == 'aot') {
      t1Exe = '${binDir.path}/stock_json_serial.exe';
      t2Exe = '${binDir.path}/new_json_serial.exe';
      t3Exe = '${binDir.path}/new_codable.exe';
      print('⚙️  Compiling Tier 1, 2, and 3 (AOT) concurrently...');
      await Future.wait([
        _compileExe(stockDart, jsonSerialScript, t1Exe),
        _compileExe(newDart, jsonSerialScript, t2Exe),
        _compileExe(newDart, codableScript, t3Exe),
      ]);
    } else if (t == 'js') {
      t1Exe = '${binDir.path}/stock_json_serial.js';
      t2Exe = '${binDir.path}/new_json_serial.js';
      t3Exe = '${binDir.path}/new_codable.js';
      print('⚙️  Compiling Tier 1, 2, and 3 (JS) concurrently...');
      await Future.wait([
        _compileJs(stockDart, jsonSerialScript, t1Exe),
        _compileJs(newDart, jsonSerialScript, t2Exe),
        _compileJs(newDart, codableScript, t3Exe),
      ]);
    } else if (t == 'wasm') {
      t1Exe = '${binDir.path}/stock_json_serial.wasm';
      t2Exe = '${binDir.path}/new_json_serial.wasm';
      t3Exe = '${binDir.path}/new_codable.wasm';
      print('⚙️  Compiling Tier 1, 2, and 3 (WASM) concurrently...');
      await Future.wait([
        _compileWasm(stockDart, jsonSerialScript, t1Exe),
        _compileWasm(newDart, jsonSerialScript, t2Exe),
        _compileWasm(newDart, codableScript, t3Exe),
      ]);
    }

    final workloadUnits = <({String dataset, String mode})>[];
    for (final ds in targetDatasets) {
      for (final m in targetModes) {
        workloadUnits.add((dataset: ds, mode: m));
      }
    }

    final resultsByUnit =
        <
          String,
          ({
            List<Map<String, dynamic>> t1,
            List<Map<String, dynamic>> t2,
            List<Map<String, dynamic>> t3,
          })
        >{};

    print(
      '🚀 Executing ${workloadUnits.length} Benchmark Units across $concurrency workers...',
    );
    await _runInParallel(workloadUnits, concurrency, (unit) async {
      final t1Res = await _runBenchmarkTier(
        target: t,
        dartBin: stockDart,
        nodeBin: nodeBin,
        wasmRunner: wasmRunnerPath,
        targetFile: t1Exe,
        engineLabel: 'old_dart_json_serial',
        dataset: unit.dataset,
        mode: unit.mode,
        iters: iters,
        warmup: warmup,
      );

      final t2Res = await _runBenchmarkTier(
        target: t,
        dartBin: newDart,
        nodeBin: nodeBin,
        wasmRunner: wasmRunnerPath,
        targetFile: t2Exe,
        engineLabel: 'new_dart_json_serial',
        dataset: unit.dataset,
        mode: unit.mode,
        iters: iters,
        warmup: warmup,
      );

      final t3Res = await _runBenchmarkTier(
        target: t,
        dartBin: newDart,
        nodeBin: nodeBin,
        wasmRunner: wasmRunnerPath,
        targetFile: t3Exe,
        engineLabel: 'new_dart_codable',
        dataset: unit.dataset,
        mode: unit.mode,
        iters: iters,
        warmup: warmup,
      );

      resultsByUnit['${unit.dataset}:${unit.mode}'] = (
        t1: t1Res,
        t2: t2Res,
        t3: t3Res,
      );
    });

    final t1Results = <Map<String, dynamic>>[];
    final t2Results = <Map<String, dynamic>>[];
    final t3Results = <Map<String, dynamic>>[];

    for (final ds in targetDatasets) {
      for (final m in targetModes) {
        final res = resultsByUnit['$ds:$m'];
        if (res != null) {
          t1Results.addAll(res.t1);
          t2Results.addAll(res.t2);
          t3Results.addAll(res.t3);
        }
      }
    }

    final report = _formatMarkdownReport(
      targetLabel: t.toUpperCase(),
      tier1Results: t1Results,
      tier2Results: t2Results,
      tier3Results: t3Results,
      stockDartPath: stockDart,
      newDartPath: newDart,
      nodeBinPath: nodeBin,
    );

    allTargetReports[t] = report;
    allTargetJson[t] = {
      'tier1_old_dart_json_serial': t1Results,
      'tier2_new_dart_json_serial': t2Results,
      'tier3_new_dart_codable': t3Results,
    };

    print('\n$report\n');
  }

  Map<String, dynamic> mergedTargets = {};
  if (outputJson != null) {
    final jsonFile = File(outputJson);
    if (jsonFile.existsSync()) {
      try {
        final decoded = jsonDecode(jsonFile.readAsStringSync());
        if (decoded is Map && decoded['targets'] is Map) {
          mergedTargets = Map<String, dynamic>.from(decoded['targets'] as Map);
        }
      } catch (_) {}
    }
    mergedTargets.addAll(allTargetJson);

    final combinedJson = {
      'stock_dart_path': stockDart,
      'new_dart_path': newDart,
      'generated_at': DateTime.now().toUtc().toIso8601String(),
      'targets': mergedTargets,
    };
    jsonFile.writeAsStringSync(
      const JsonEncoder.withIndent('  ').convert(combinedJson),
    );
    print('💾 Saved JSON results to: $outputJson');
  } else {
    mergedTargets.addAll(allTargetJson);
  }

  if (outputMd != null) {
    final allReports = <String>[];
    final orderedTargetKeys = [
      'wasm',
      'js',
      'aot',
      ...mergedTargets.keys.where((k) => !['wasm', 'js', 'aot'].contains(k)),
    ];

    for (final tKey in orderedTargetKeys) {
      if (!mergedTargets.containsKey(tKey)) continue;
      if (allTargetReports.containsKey(tKey)) {
        allReports.add(allTargetReports[tKey]!.trim());
      } else {
        final tData = mergedTargets[tKey];
        if (tData is Map) {
          final t1 =
              (tData['tier1_old_dart_json_serial'] as List?)
                  ?.cast<Map<String, dynamic>>() ??
              [];
          final t2 =
              (tData['tier2_new_dart_json_serial'] as List?)
                  ?.cast<Map<String, dynamic>>() ??
              [];
          final t3 =
              (tData['tier3_new_dart_codable'] as List?)
                  ?.cast<Map<String, dynamic>>() ??
              [];
          final rep = _formatMarkdownReport(
            targetLabel: tKey.toUpperCase(),
            tier1Results: t1,
            tier2Results: t2,
            tier3Results: t3,
            stockDartPath: stockDart,
            newDartPath: newDart,
            nodeBinPath: nodeBin,
          );
          allReports.add(rep.trim());
        }
      }
    }

    File(outputMd).writeAsStringSync(allReports.join('\n\n') + '\n');
    print('📄 Saved Markdown report to: $outputMd');
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
    '-O3',
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
    '-O3',
  ], workingDirectory: packageRoot);
  if (proc.exitCode != 0) {
    stderr.writeln('WASM compilation failed for $script with $dartBin:');
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
      r'\[(?<engine>[\w_]+)\]\s+(?<dataset>\w+)\s+(?<mode>\w+)\s*:\s*(?<latency>[\d\.]+)\s*ms\s*(?:\(±(?<stddev>[\d\.]+)\s*ms\))?\s*\|\s*(?<throughput>[\d\.]+|Infinity)\s*MB/s',
    );
    for (final line in lines) {
      final m = lineRegex.firstMatch(line.trim());
      if (m != null) {
        parsedList.add({
          'engine': m.namedGroup('engine')!,
          'dataset': m.namedGroup('dataset')!,
          'mode': m.namedGroup('mode')!,
          'latency_ms': double.parse(m.namedGroup('latency')!),
          'stddev_ms': m.namedGroup('stddev') != null
              ? double.parse(m.namedGroup('stddev')!)
              : 0.0,
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

String _formatRuntimeSummaryTable({
  required String targetLabel,
  required List<Map<String, dynamic>> tier1Results,
  required List<Map<String, dynamic>> tier2Results,
  required List<Map<String, dynamic>> tier3Results,
}) {
  final sb = StringBuffer();
  sb.writeln(
    '### 📊 Summary: $targetLabel Target ([ min / avg / max ] Multiplier vs Fastest)',
  );
  sb.writeln('');
  sb.writeln('<!-- mdformat off(prevent table wrapping) -->');
  sb.writeln(
    '| Dart Configuration | 📥 Decode [ min / avg / max ] | 📤 Encode [ min / avg / max ] |',
  );
  sb.writeln('| :--- | :---: | :---: |');

  final tierMap = {
    'Old Dart + json_serial': tier1Results,
    'New Dart + json_serial': tier2Results,
    'New Dart + Codable': tier3Results,
  };

  final datasets = [
    'coordinates',
    'canada',
    'citm_catalog',
    'small',
    'twitter',
  ];
  final modes = ['decode', 'encode'];
  final tableStats = <String, Map<String, List<double>>>{
    for (final c in tierMap.keys) c: {'decode': [], 'encode': []},
  };

  for (final mode in modes) {
    final dsMap = <String, Map<String, double>>{};
    for (final entry in tierMap.entries) {
      for (final b in entry.value) {
        if (b['mode'] != mode) continue;
        final ds = b['dataset'] as String?;
        if (ds == null || !datasets.contains(ds)) continue;
        final lat = (b['latency_ms'] as num?)?.toDouble();
        if (lat == null) continue;
        dsMap.putIfAbsent(ds, () => {})[entry.key] = lat;
      }
    }

    for (final ds in datasets) {
      final lats = dsMap[ds] ?? {};
      if (lats.isEmpty) continue;
      final minLat = lats.values.reduce((a, b) => a < b ? a : b);
      if (minLat <= 0) continue;

      for (final c in tierMap.keys) {
        final lat = lats[c];
        if (lat != null) {
          tableStats[c]![mode]!.add(lat / minLat);
        }
      }
    }
  }

  for (final c in tierMap.keys) {
    final decMults = tableStats[c]!['decode']!;
    final encMults = tableStats[c]!['encode']!;

    String formatStats(List<double> mults) {
      if (mults.isEmpty) return 'N/A';
      final minM = mults.reduce((a, b) => a < b ? a : b);
      final avgM = mults.reduce((a, b) => a + b) / mults.length;
      final maxM = mults.reduce((a, b) => a > b ? a : b);
      return '[ ${minM.toStringAsFixed(2)} / ${avgM.toStringAsFixed(2)} / ${maxM.toStringAsFixed(2)} ]';
    }

    sb.writeln(
      '| **`$c`** | ${formatStats(decMults)} | ${formatStats(encMults)} |',
    );
  }

  sb.writeln('<!-- mdformat on -->');
  sb.writeln('');
  return sb.toString();
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
  sb.write(
    _formatRuntimeSummaryTable(
      targetLabel: targetLabel,
      tier1Results: tier1Results,
      tier2Results: tier2Results,
      tier3Results: tier3Results,
    ),
  );

  sb.writeln('#### Detailed Breakdown: $targetLabel Decode');
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

Future<void> _runInParallel<T>(
  List<T> items,
  int concurrency,
  Future<void> Function(T item) worker,
) async {
  if (items.isEmpty) return;
  var nextIndex = 0;
  Future<void> runWorker() async {
    while (true) {
      final idx = nextIndex++;
      if (idx >= items.length) break;
      await worker(items[idx]);
    }
  }

  final workerCount = concurrency.clamp(1, items.length);
  final futures = List.generate(workerCount, (_) => runWorker());
  await Future.wait(futures);
}
