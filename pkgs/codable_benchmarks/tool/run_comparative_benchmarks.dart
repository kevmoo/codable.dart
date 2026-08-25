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

const _canonicalDatasets = [
  'coordinates',
  'canada',
  'citm_catalog',
  'small',
  'twitter',
];

const _benchmarkModes = ['decode', 'encode'];

const _targetLabels = {
  'aot': 'AOT (`dart compile exe`)',
  'js': 'JS (`dart2js` / Node 24 / V8)',
  'wasm': 'WASM (`dart2wasm` / d8)',
};

const _datasetLabels = {
  'citm_catalog': 'citm_catalog.json (1.73 MB)',
  'canada': 'canada.json (2.25 MB)',
  'coordinates': '10k Coordinates (0.39 MB)',
  'small': 'small.json (0.55 KB)',
  'twitter': 'twitter.json (0.62 MB)',
};

ArgParser _buildArgParser() => ArgParser()
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
  ..addOption('new-sdk', help: 'Path to custom/next-gen Dart SDK (or bin/dart)')
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
    help: 'Concurrent benchmark worker tasks (use 1 for statistical fidelity)',
  )
  ..addOption(
    'from-json',
    help: 'Path to benchmark JSON results to format into Markdown without re-running',
  )
  ..addOption('output-md', help: 'Save markdown report to file')
  ..addOption('output-json', help: 'Save JSON results to file');

File _resolveFile(String p) {
  if (p.startsWith('/')) return File(p);
  final fromCwd = File('${Directory.current.path}/$p');
  if (fromCwd.existsSync()) return fromCwd;
  return File('$packageRoot/$p');
}

void _handleFromJson(String fromJsonPath, String? outputMd) {
  final file = _resolveFile(fromJsonPath);
  if (!file.existsSync()) {
    stderr.writeln('Error: JSON file not found at: ${file.path}');
    exit(1);
  }
  final rawData = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
  final targetsData = rawData['targets'] as Map<String, dynamic>? ?? {};
  final combinedMd = StringBuffer();
  final targetsMap = Map<String, Map<String, dynamic>>.from(targetsData);

  combinedMd.writeln(_formatCombined3RuntimeSummaryTable(targetsMap));
  combinedMd.writeln(
    '------------------------------------------------------------------------\n',
  );

  for (final tKey in ['aot', 'js', 'wasm']) {
    if (!targetsData.containsKey(tKey)) continue;
    final tLabel = tKey.toUpperCase();
    final tMap = targetsData[tKey] as Map<String, dynamic>;
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

  final rendered = combinedMd.toString().trim() + '\n';
  print(rendered);

  if (outputMd != null) {
    final mdFile = _resolveFile(outputMd);
    mdFile.writeAsStringSync(rendered);
    print('>> Saved Markdown report to: ${mdFile.path}');
  }
}

void main(List<String> rawArgs) async {
  final parser = _buildArgParser();
  final args = parser.parse(rawArgs);
  final fromJsonPath = args['from-json'] as String?;
  final outputMd = args['output-md'] as String?;
  final outputJson = args['output-json'] as String?;

  if (fromJsonPath != null) {
    _handleFromJson(fromJsonPath, outputMd);
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
  _ensureWasmRunner(wasmRunnerPath);

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

    final (:t1Exe, :t2Exe, :t3Exe) = await _compileTargetBinaries(
      target: t,
      stockDart: stockDart,
      newDart: newDart,
      binDirPath: binDir.path,
      jsonSerialScript: jsonSerialScript,
      codableScript: codableScript,
    );

    final (:t1Results, :t2Results, :t3Results) = await _runTargetBenchmarks(
      target: t,
      targetDatasets: targetDatasets,
      targetModes: targetModes,
      stockDart: stockDart,
      newDart: newDart,
      nodeBin: nodeBin,
      wasmRunnerPath: wasmRunnerPath,
      t1Exe: t1Exe,
      t2Exe: t2Exe,
      t3Exe: t3Exe,
      iters: iters,
      warmup: warmup,
      concurrency: concurrency,
    );

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

  _saveBenchmarkOutputs(
    outputJson: outputJson,
    outputMd: outputMd,
    allTargetJson: allTargetJson,
    allTargetReports: allTargetReports,
    stockDart: stockDart,
    newDart: newDart,
    nodeBin: nodeBin,
  );
}

void _ensureWasmRunner(String wasmRunnerPath) {
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
}

Future<({String t1Exe, String t2Exe, String t3Exe})> _compileTargetBinaries({
  required String target,
  required String stockDart,
  required String newDart,
  required String binDirPath,
  required String jsonSerialScript,
  required String codableScript,
}) async {
  final ext = switch (target) {
    'aot' => 'exe',
    'js' => 'js',
    'wasm' => 'wasm',
    _ => 'dart',
  };

  final t1Exe = '$binDirPath/stock_json_serial.$ext';
  final t2Exe = '$binDirPath/new_json_serial.$ext';
  final t3Exe = '$binDirPath/new_codable.$ext';

  print(
    '⚙️  Compiling Tier 1, 2, and 3 (${target.toUpperCase()}) concurrently...',
  );

  final compileFn = switch (target) {
    'aot' => _compileExe,
    'js' => _compileJs,
    'wasm' => _compileWasm,
    _ => (String _, String _, String _) async {},
  };

  await Future.wait([
    compileFn(stockDart, jsonSerialScript, t1Exe),
    compileFn(newDart, jsonSerialScript, t2Exe),
    compileFn(newDart, codableScript, t3Exe),
  ]);

  return (t1Exe: t1Exe, t2Exe: t2Exe, t3Exe: t3Exe);
}

Future<
  ({
    List<Map<String, dynamic>> t1Results,
    List<Map<String, dynamic>> t2Results,
    List<Map<String, dynamic>> t3Results,
  })
>
_runTargetBenchmarks({
  required String target,
  required List<String> targetDatasets,
  required List<String> targetModes,
  required String stockDart,
  required String newDart,
  required String nodeBin,
  required String wasmRunnerPath,
  required String t1Exe,
  required String t2Exe,
  required String t3Exe,
  required String iters,
  required String warmup,
  required int concurrency,
}) async {
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
      target: target,
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
      target: target,
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
      target: target,
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

  return (t1Results: t1Results, t2Results: t2Results, t3Results: t3Results);
}

Map<String, dynamic> _saveJsonReport({
  required String? outputJson,
  required Map<String, Map<String, dynamic>> allTargetJson,
  required String stockDart,
  required String newDart,
}) {
  if (outputJson == null) return Map<String, dynamic>.from(allTargetJson);

  Map<String, dynamic> mergedTargets = {};
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
  return mergedTargets;
}

void _saveMarkdownReport({
  required String outputMd,
  required Map<String, dynamic> mergedTargets,
  required String stockDart,
  required String newDart,
  required String nodeBin,
}) {
  final combinedMd = StringBuffer();
  final targetsMap = <String, Map<String, dynamic>>{};
  for (final entry in mergedTargets.entries) {
    if (entry.value is Map) {
      targetsMap[entry.key] = Map<String, dynamic>.from(entry.value as Map);
    }
  }

  combinedMd.writeln(_formatCombined3RuntimeSummaryTable(targetsMap));
  combinedMd.writeln(
    '------------------------------------------------------------------------\n',
  );

  final orderedTargetKeys = [
    'aot',
    'js',
    'wasm',
    ...mergedTargets.keys.where((k) => !['aot', 'js', 'wasm'].contains(k)),
  ];

  for (final tKey in orderedTargetKeys) {
    final tData = mergedTargets[tKey];
    if (tData is! Map) continue;
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
    combinedMd.writeln(rep.trim());
    combinedMd.writeln(
      '\n------------------------------------------------------------------------\n',
    );
  }

  File(outputMd).writeAsStringSync('${combinedMd.toString().trim()}\n');
  print('📄 Saved Markdown report to: $outputMd');
}

void _saveBenchmarkOutputs({
  required String? outputJson,
  required String? outputMd,
  required Map<String, Map<String, dynamic>> allTargetJson,
  required Map<String, String> allTargetReports,
  required String stockDart,
  required String newDart,
  required String nodeBin,
}) {
  final mergedTargets = _saveJsonReport(
    outputJson: outputJson,
    allTargetJson: allTargetJson,
    stockDart: stockDart,
    newDart: newDart,
  );

  if (outputMd != null) {
    _saveMarkdownReport(
      outputMd: outputMd,
      mergedTargets: mergedTargets,
      stockDart: stockDart,
      newDart: newDart,
      nodeBin: nodeBin,
    );
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

List<Map<String, dynamic>> _parseTextBenchmarkOutput(String out) {
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
  return parsedList;
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
  final (cmd, args) = switch (target) {
    'aot' => (
      targetFile,
      [
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
      ],
    ),
    'js' => (
      nodeBin,
      [
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
      ],
    ),
    'wasm' => (
      nodeBin,
      [
        wasmRunner,
        targetFile,
        targetFile.replaceAll(RegExp(r'\.wasm$'), '.mjs'),
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
      ],
    ),
    _ => (
      dartBin,
      [
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
      ],
    ),
  };

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
    final parsedList = _parseTextBenchmarkOutput(out);
    if (parsedList.isNotEmpty) return parsedList;
    stderr.writeln('Failed to parse JSON or text benchmark output: $out');
    rethrow;
  }
}

Map<String, Map<String, double>> _extractDatasetLatencies(
  Map<String, List<Map<String, dynamic>>> tierMap,
  String mode,
  List<String> datasets,
) {
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
  return dsMap;
}

void _addDatasetScores(
  Map<String, Map<String, List<double>>> tableStats,
  Map<String, double> lats,
  Iterable<String> configKeys,
  String mode,
) {
  final minLat = lats.values.reduce((a, b) => a < b ? a : b);
  if (minLat <= 0) return;

  for (final c in configKeys) {
    final lat = lats[c];
    if (lat == null || lat <= 0) continue;
    final eff = ((minLat / lat) * 100).roundToDouble();
    tableStats[c]![mode]!.add(eff);
  }
}

void _populateModeEfficiency(
  Map<String, Map<String, List<double>>> tableStats,
  Map<String, Map<String, double>> dsMap,
  List<String> datasets,
  Iterable<String> configKeys,
  String mode,
) {
  for (final ds in datasets) {
    final lats = dsMap[ds];
    if (lats == null || lats.isEmpty) continue;
    _addDatasetScores(tableStats, lats, configKeys, mode);
  }
}

Map<String, Map<String, List<double>>> _calculateTargetEfficiencyStats(
  Map<String, List<Map<String, dynamic>>> tierMap,
  List<String> datasets,
  List<String> modes,
) {
  final tableStats = <String, Map<String, List<double>>>{
    for (final c in tierMap.keys) c: {'decode': [], 'encode': []},
  };

  for (final mode in modes) {
    final dsMap = _extractDatasetLatencies(tierMap, mode, datasets);
    _populateModeEfficiency(tableStats, dsMap, datasets, tierMap.keys, mode);
  }

  return tableStats;
}

String _formatEfficiencyStats(List<double> scores) {
  if (scores.isEmpty) return 'N/A';
  final worst = scores.reduce((a, b) => a < b ? a : b).round();
  final avg = (scores.reduce((a, b) => a + b) / scores.length).round();
  final best = scores.reduce((a, b) => a > b ? a : b).round();

  final emoji = switch ((worst, avg)) {
    (100, 100) when best == 100 => '🥇 ',
    (_, >= 90) => '🟢 ',
    (_, >= 70) => '🟡 ',
    _ => '🔴 ',
  };

  return '$emoji`[ $worst / $avg / $best ]`';
}

String _formatCombined3RuntimeSummaryTable(
  Map<String, Map<String, dynamic>> targetsData,
) {
  final sb = StringBuffer();
  sb.writeln('### 📊 3-Runtime Summary (Relative Efficiency Index)');
  sb.writeln('');
  sb.writeln('<!-- mdformat off(prevent table wrapping) -->');
  sb.writeln(
    '| Target Runtime | Dart Configuration | 📥 Decode Efficiency<br/>[ Worst / Avg / Best ] | 📤 Encode Efficiency<br/>[ Worst / Avg / Best ] |',
  );
  sb.writeln('| :--- | :--- | :---: | :---: |');

  for (final tKey in ['aot', 'js', 'wasm']) {
    if (!targetsData.containsKey(tKey)) continue;
    final tMap = targetsData[tKey]!;
    final tierMap = {
      'Old Dart + json_serial':
          (tMap['tier1_old_dart_json_serial'] as List? ?? [])
              .cast<Map<String, dynamic>>(),
      'New Dart + json_serial':
          (tMap['tier2_new_dart_json_serial'] as List? ?? [])
              .cast<Map<String, dynamic>>(),
      'New Dart + Codable': (tMap['tier3_new_dart_codable'] as List? ?? [])
          .cast<Map<String, dynamic>>(),
    };

    final tableStats = _calculateTargetEfficiencyStats(
      tierMap,
      _canonicalDatasets,
      _benchmarkModes,
    );
    var isFirstRow = true;
    final tLabelFormatted = '**${_targetLabels[tKey] ?? tKey.toUpperCase()}**';

    for (final c in tierMap.keys) {
      final decScores = tableStats[c]!['decode']!;
      final encScores = tableStats[c]!['encode']!;
      final rtCol = isFirstRow ? tLabelFormatted : '';
      sb.writeln(
        '| $rtCol | **`$c`** | ${_formatEfficiencyStats(decScores)} | ${_formatEfficiencyStats(encScores)} |',
      );
      isFirstRow = false;
    }
  }

  sb.writeln('<!-- mdformat on -->');
  sb.writeln('');
  sb.writeln(
    '> **Scoring Metric**: **Relative Throughput Efficiency** (`100` = Peak Speed). '
    'Calculated as `round((MinLatency / Latency) * 100)` per workload, '
    'measuring the percentage of maximum achievable throughput delivered.\n'
    '> - **`[ Worst / Avg / Best ]`**: Range from lowest score (worst workload) to the average and peak dataset score across the 5 canonical benchmarks (`coordinates`, `canada`, `citm_catalog`, `small`, `twitter`).\n'
    '> - **Badges**: 🥇 Peak across all workloads (`100`) &bull; 🟢 `≥ 90` (Within 10% of peak) &bull; 🟡 `70–89` (Good / moderate) &bull; 🔴 `< 70` (Significant performance gap).',
  );
  sb.writeln('');
  return sb.toString();
}

String _formatDetailedBreakdownTable({
  required String targetLabel,
  required String mode,
  required List<Map<String, dynamic>> tier1Results,
  required List<Map<String, dynamic>> tier2Results,
  required List<Map<String, dynamic>> tier3Results,
}) {
  final sb = StringBuffer();
  final modeLabel = mode == 'decode' ? 'Decode' : 'Encode';
  sb.writeln('#### Detailed Breakdown: $targetLabel $modeLabel');
  sb.writeln('');
  sb.writeln('<!-- mdformat off(prevent table wrapping) -->');
  sb.writeln(
    '| Workload / Dataset | Old Dart + json_serial | New Dart + json_serial | New Dart + Codable | Speedup vs Old Dart | Speedup vs New json_serial |',
  );
  sb.writeln('| :--- | :---: | :---: | :---: | :---: | :---: |');

  final t1Map = {
    for (var r in tier1Results.where((r) => r['mode'] == mode)) r['dataset']: r,
  };
  final t2Map = {
    for (var r in tier2Results.where((r) => r['mode'] == mode)) r['dataset']: r,
  };
  final t3Map = {
    for (var r in tier3Results.where((r) => r['mode'] == mode)) r['dataset']: r,
  };

  for (final dataset in t1Map.keys) {
    final t1 = t1Map[dataset];
    final t2 = t2Map[dataset];
    final t3 = t3Map[dataset];
    if (t1 == null || t2 == null || t3 == null) continue;

    final t1Ms = (t1['latency_ms'] as num).toDouble();
    final t2Ms = (t2['latency_ms'] as num).toDouble();
    final t3Ms = (t3['latency_ms'] as num).toDouble();

    final speedupVsOld = t3Ms > 0
        ? '${(t1Ms / t3Ms).toStringAsFixed(2)}x'
        : 'N/A';
    final speedupVsNewSerial = t3Ms > 0
        ? '${(t2Ms / t3Ms).toStringAsFixed(2)}x'
        : 'N/A';

    final dsLabel = _datasetLabels[dataset] ?? dataset;

    sb.writeln(
      '| **$dsLabel** | ${t1Ms.toStringAsFixed(2)} ms | ${t2Ms.toStringAsFixed(2)} ms | **${t3Ms.toStringAsFixed(2)} ms** | **${speedupVsOld}** | **${speedupVsNewSerial}** |',
    );
  }
  sb.writeln('<!-- mdformat on -->');
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
  sb.writeln('### 🎯 $targetLabel Target Detailed Breakdown');
  sb.writeln('');
  sb.writeln(
    _formatDetailedBreakdownTable(
      targetLabel: targetLabel,
      mode: 'decode',
      tier1Results: tier1Results,
      tier2Results: tier2Results,
      tier3Results: tier3Results,
    ),
  );
  sb.writeln('');
  sb.writeln(
    _formatDetailedBreakdownTable(
      targetLabel: targetLabel,
      mode: 'encode',
      tier1Results: tier1Results,
      tier2Results: tier2Results,
      tier3Results: tier3Results,
    ),
  );
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
