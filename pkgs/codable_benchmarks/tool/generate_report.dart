// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:args/args.dart';

const List<String> canonicalTargets = ['aot', 'js', 'wasm'];

const List<String> canonicalDatasets = [
  'coordinates',
  'canada',
  'citm_catalog',
  'small',
  'twitter',
];

const Map<String, String> datasetNames = {
  'coordinates': '10k Coordinates (0.39 MB)',
  'canada': 'canada.json (2.25 MB)',
  'citm_catalog': 'citm_catalog.json (1.73 MB)',
  'small': 'small.json (0.55 KB)',
  'twitter': 'twitter.json (0.62 MB)',
};

void main(List<String> args) {
  final parser = ArgParser()
    ..addOption(
      'input',
      abbr: 'i',
      defaultsTo: 'benchmark_results.json',
      help: 'Path to bench_press output JSON file.',
    )
    ..addOption(
      'output-report',
      abbr: 'r',
      defaultsTo: 'BENCHMARK_REPORT.md',
      help: 'Path to write formatted Markdown report.',
    )
    ..addOption(
      'output-unified',
      abbr: 'u',
      defaultsTo: 'benchmark_results_unified.json',
      help: 'Path to write unified simplified telemetry JSON.',
    )
    ..addOption(
      'metric',
      abbr: 'm',
      allowed: ['min', 'median'],
      defaultsTo: 'median',
      help: 'Metric to extract for reporting (min or median).',
    )
    ..addFlag(
      'streaming',
      negatable: false,
      help: 'Generate streaming benchmark report (decode_stream / encode_stream).',
    )
    ..addFlag('help', abbr: 'h', negatable: false, help: 'Print usage.');

  final argResults = parser.parse(args);
  if (argResults.flag('help')) {
    print('Usage: dart run tool/generate_report.dart [options]');
    print(parser.usage);
    return;
  }

  final streaming = argResults.flag('streaming');
  final defaultInputPath =
      streaming && File('streaming_benchmark_results.json').existsSync()
      ? 'streaming_benchmark_results.json'
      : 'benchmark_results.json';
  final inputPath = argResults.wasParsed('input')
      ? argResults.option('input')!
      : defaultInputPath;
  final inputFile = File(inputPath);
  if (!inputFile.existsSync()) {
    stderr.writeln('Error: Input file ${inputFile.path} does not exist.');
    exit(1);
  }

  final dynamic jsonRoot = jsonDecode(inputFile.readAsStringSync());
  final benchmarksList = _extractBenchmarksList(jsonRoot, inputFile.path);
  final metricFlag = argResults.option('metric')!;

  final unifiedPath = argResults.wasParsed('output-unified')
      ? argResults.option('output-unified')!
      : (streaming
            ? 'streaming_benchmark_results_unified.json'
            : 'benchmark_results_unified.json');
  final unifiedFile = File(unifiedPath);
  final results = extractUnifiedResults(
    benchmarksList,
    metric: metricFlag,
    existingUnifiedFile: !streaming && unifiedFile.existsSync()
        ? unifiedFile
        : null,
  );

  final report = generateMarkdownReport(
    results,
    jsonRoot,
    metricFlag,
    benchmarksList: benchmarksList,
    streaming: streaming,
  );
  print(report);

  final reportPath = argResults.wasParsed('output-report')
      ? argResults.option('output-report')!
      : (streaming ? 'STREAMING_BENCHMARK_REPORT.md' : 'BENCHMARK_REPORT.md');
  final reportFile = File(reportPath);
  reportFile.writeAsStringSync(report);
  print('💾 Markdown report saved to ${reportFile.path}');

  unifiedFile.writeAsStringSync(
    '${const JsonEncoder.withIndent('  ').convert(results)}\n',
  );
  print('💾 Unified telemetry saved to ${unifiedFile.path}');
}

List<dynamic> _extractBenchmarksList(dynamic jsonRoot, String path) {
  if (jsonRoot is Map<String, dynamic> && jsonRoot['benchmarks'] is List) {
    return jsonRoot['benchmarks'] as List<dynamic>;
  }
  if (jsonRoot is List) {
    return jsonRoot;
  }
  stderr.writeln('Error: Unrecognized JSON structure in $path.');
  exit(1);
}

/// Extracts and merges benchmark latencies (in microseconds) keyed by
/// `results[target][workloadGroup][candidateKey]`.
///
/// Entries with `coordinates.sdk == 'stock'` are stored under
/// `'stock_<candidate>'` (e.g. `'stock_json_serializable'`, `'stock_codable'`),
/// while `native_kernels` entries are stored under `'<candidate>'`.
Map<String, Map<String, Map<String, double>>> extractUnifiedResults(
  List<dynamic> benchmarksList, {
  required String metric,
  File? existingUnifiedFile,
}) {
  final rawResults = <String, Map<String, Map<String, double>>>{
    for (final target in canonicalTargets) target: {},
  };

  if (existingUnifiedFile != null) {
    _preloadExistingUnified(existingUnifiedFile, rawResults);
  }

  for (final raw in benchmarksList) {
    if (raw is! Map<String, dynamic>) continue;
    _ingestBenchmarkEntry(raw, metric, rawResults);
  }

  return _sortUnifiedResults(rawResults);
}

void _preloadExistingUnified(
  File file,
  Map<String, Map<String, Map<String, double>>> out,
) {
  try {
    final decoded = jsonDecode(file.readAsStringSync());
    if (decoded is! Map<String, dynamic>) return;
    for (final target in canonicalTargets) {
      final targetMap = decoded[target];
      if (targetMap is Map<String, dynamic>) {
        _preloadTargetGroups(targetMap, out[target]!);
      }
    }
  } on Object {
    // Ignore unreadable existing file.
  }
}

void _preloadTargetGroups(
  Map<String, dynamic> targetMap,
  Map<String, Map<String, double>> targetOut,
) {
  for (final groupEntry in targetMap.entries) {
    final candMap = groupEntry.value;
    if (candMap is! Map<String, dynamic>) continue;
    final dest = targetOut.putIfAbsent(groupEntry.key, () => {});
    for (final candEntry in candMap.entries) {
      final v = candEntry.value;
      if (v is num) dest[candEntry.key] = v.toDouble();
    }
  }
}

void _ingestBenchmarkEntry(
  Map<String, dynamic> entry,
  String metric,
  Map<String, Map<String, Map<String, double>>> out,
) {
  final target = entry['target'] as String?;
  if (target == null || !out.containsKey(target)) return;

  final candidate = entry['name'] as String?;
  if (candidate == null) return;

  final coords = entry['coordinates'] as Map<String, dynamic>?;
  final group = coords?['group'] as String?;
  if (group == null) return;

  final metrics = entry['metrics'] as Map<String, dynamic>?;
  final valNs = _extractMetricNs(metrics, metric);
  if (valNs == null) return;

  final sdk = coords?['sdk'] as String?;
  final candidateKey = sdk == 'stock' ? 'stock_$candidate' : candidate;
  out[target]!.putIfAbsent(group, () => {})[candidateKey] = valNs / 1000.0;
}

double? _extractMetricNs(Map<String, dynamic>? metrics, String metric) {
  if (metrics == null) return null;
  if (metric == 'min') {
    return (metrics['min_ns'] as num?)?.toDouble() ??
        (metrics['median_ns'] as num?)?.toDouble() ??
        (metrics['mean_ns'] as num?)?.toDouble();
  }
  return (metrics['median_ns'] as num?)?.toDouble() ??
      (metrics['mean_ns'] as num?)?.toDouble();
}

/// Candidate that is not one of the compared implementations. Its movement
/// between the SDK passes bounds the measurement drift for the same run.
///
/// Note: This is *not* a pure null experiment. Even if the source on this
/// path is identical in both SDKs, the SDK under test may perform code motion
/// across library boundaries that causes snapshot or layout shifts underneath
/// the control (e.g., relocating JSON code into `dart:_internal` which links
/// into everything). Measured deviation bounds the combination of codebase
/// layout collateral and environmental noise.
const _controlCandidate = 'json_serializable_literal';

/// Encode-side counterpart to [_controlCandidate].
///
/// Like the decode control, this is not a pure null experiment when the SDK
/// under test contains broad code layout shifts. Moreover, there is no JSON
/// encode path that is source-identical across the two SDKs — the fork
/// relocates `JsonEncoder` out of `json.dart` — so the encode control has to
/// be a non-JSON codec. `sdk/lib/convert/utf8.dart` is source-identical but
/// its performance may still drift due to the same layout collateral.
const _encodeControlCandidate = 'utf8_encode_control';

String _candidateKeyFor(String candidate, String? sdk) =>
    sdk == 'stock' ? 'stock_$candidate' : candidate;

/// Cell keys (`'<target>|<group>|<candidateKey>'`) the harness flagged as not
/// robustly stable. Ratios derived from these cells are not resolvable at this
/// trial count.
Set<String> collectUnstableCells(List<dynamic> benchmarksList) {
  final unstable = <String>{};
  for (final raw in benchmarksList) {
    if (raw is! Map<String, dynamic>) continue;
    final metrics = raw['metrics'] as Map<String, dynamic>?;
    if (metrics == null || metrics['is_robust_stable'] != false) continue;
    final target = raw['target'] as String?;
    final candidate = raw['name'] as String?;
    final coords = raw['coordinates'] as Map<String, dynamic>?;
    final group = coords?['group'] as String?;
    if (target == null || candidate == null || group == null) continue;
    final key = _candidateKeyFor(candidate, coords?['sdk'] as String?);
    unstable.add('$target|$group|$key');
  }
  return unstable;
}

/// Per-target Tier 1 / Tier 0 ratios for [candidate], across the canonical
/// workloads of [mode].
///
/// [mode] is a group suffix such as `decode`, `encode`, `decode_stream` or
/// `encode_stream`. [candidate] defaults to the decode control; pass
/// [_encodeControlCandidate] for the encode tables.
Map<String, List<double>> extractControlRatios(
  List<dynamic> benchmarksList,
  String metric, {
  String mode = 'decode',
  String candidate = _controlCandidate,
}) {
  final byKey = <String, double>{};
  for (final raw in benchmarksList) {
    if (raw is! Map<String, dynamic>) continue;
    if (raw['name'] != candidate) continue;
    final target = raw['target'] as String?;
    final coords = raw['coordinates'] as Map<String, dynamic>?;
    final group = coords?['group'] as String?;
    final sdk = coords?['sdk'] as String?;
    final value = _extractMetricNs(
      raw['metrics'] as Map<String, dynamic>?,
      metric,
    );
    if (target == null || group == null || sdk == null || value == null) {
      continue;
    }
    byKey['$target|$group|$sdk'] = value;
  }

  final out = <String, List<double>>{};
  for (final target in canonicalTargets) {
    final ratios = <double>[];
    for (final ds in canonicalDatasets) {
      final stock = byKey['$target|${ds}_$mode|stock'];
      final fork = byKey['$target|${ds}_$mode|native_kernels'];
      if (stock != null && fork != null && fork > 0) ratios.add(stock / fork);
    }
    if (ratios.isNotEmpty) out[target] = ratios;
  }
  return out;
}

Map<String, Map<String, Map<String, double>>> _sortUnifiedResults(
  Map<String, Map<String, Map<String, double>>> raw,
) {
  final orderedGroups = <String>[
    for (final mode in ['decode', 'encode', 'decode_stream', 'encode_stream'])
      for (final ds in canonicalDatasets) '${ds}_$mode',
  ];

  final sorted = <String, Map<String, Map<String, double>>>{};
  for (final target in canonicalTargets) {
    final targetGroups = raw[target] ?? {};
    final sortedGroups = <String, Map<String, double>>{};
    final allGroups = <String>{...orderedGroups, ...targetGroups.keys};
    for (final group in allGroups) {
      final cands = targetGroups[group];
      if (cands == null || cands.isEmpty) continue;
      final sortedCands = <String, double>{};
      final sortedKeys = cands.keys.toList()..sort();
      for (final k in sortedKeys) {
        sortedCands[k] = cands[k]!;
      }
      sortedGroups[group] = sortedCands;
    }
    sorted[target] = sortedGroups;
  }
  return sorted;
}

bool _hasFourTierData(
  Map<String, Map<String, Map<String, double>>> results, {
  required bool streaming,
}) {
  final suffix = streaming ? '_stream' : '';
  for (final target in canonicalTargets) {
    final targetMap = results[target];
    if (targetMap == null) continue;
    for (final entry in targetMap.entries) {
      final isStreamGroup = entry.key.endsWith('_stream');
      if (streaming != isStreamGroup) continue;
      final groupMap = entry.value;
      if (groupMap.containsKey('stock_json_serializable') &&
          groupMap.containsKey('stock_codable')) {
        return true;
      }
    }
  }
  // Fallback if suffix check found nothing
  if (suffix.isEmpty) {
    for (final target in canonicalTargets) {
      final targetMap = results[target];
      if (targetMap == null) continue;
      for (final groupMap in targetMap.values) {
        if (groupMap.containsKey('stock_json_serializable') &&
            groupMap.containsKey('stock_codable')) {
          return true;
        }
      }
    }
  }
  return false;
}

List<String> _resolveActiveDatasets(
  Map<String, Map<String, Map<String, double>>> results, {
  required bool streaming,
}) {
  if (!streaming) return canonicalDatasets;
  final found = <String>[];
  for (final ds in canonicalDatasets) {
    var present = false;
    for (final target in canonicalTargets) {
      final tMap = results[target];
      if (tMap == null) continue;
      if ((tMap['${ds}_decode_stream']?.isNotEmpty ?? false) ||
          (tMap['${ds}_encode_stream']?.isNotEmpty ?? false)) {
        present = true;
        break;
      }
    }
    if (present) found.add(ds);
  }
  return found.isEmpty ? const ['coordinates', 'canada'] : found;
}

String generateMarkdownReport(
  Map<String, Map<String, Map<String, double>>> results,
  dynamic jsonRoot,
  String metric, {
  List<dynamic> benchmarksList = const [],
  bool streaming = false,
}) {
  final buf = StringBuffer();
  final hasFourTiers = _hasFourTierData(results, streaming: streaming);
  final activeDatasets = _resolveActiveDatasets(results, streaming: streaming);
  final decodeMode = streaming ? 'decode_stream' : 'decode';
  final encodeMode = streaming ? 'encode_stream' : 'encode';
  final activeBenchmarksList = benchmarksList.where((raw) {
    if (raw is! Map<String, dynamic>) return false;
    final coords = raw['coordinates'] as Map<String, dynamic>?;
    final group = coords?['group'] as String? ?? '';
    return group.endsWith('_stream') == streaming;
  }).toList();
  final unstable = collectUnstableCells(activeBenchmarksList);
  final controlRatios = extractControlRatios(
    benchmarksList,
    metric,
    mode: decodeMode,
  );
  final encodeControlRatios = extractControlRatios(
    benchmarksList,
    metric,
    mode: encodeMode,
    candidate: _encodeControlCandidate,
  );

  if (streaming) {
    buf.writeln(
      '## 🌊 Streaming Benchmark Report '
      '(`ChunkedConversionSink` / `ByteConversionSink`)\n',
    );
  }

  _writeProvenanceSection(buf, jsonRoot, metric, hasFourTiers);
  if (hasFourTiers) {
    _writeFourTierLegendSection(buf, streaming: streaming);
    _writeFourTierRuntimeSummary(
      buf,
      results,
      decodeMode: decodeMode,
      encodeMode: encodeMode,
      datasets: activeDatasets,
    );
  } else {
    _writeTwoTierRuntimeSummary(
      buf,
      results,
      decodeMode: decodeMode,
      encodeMode: encodeMode,
      datasets: activeDatasets,
    );
  }

  if (activeBenchmarksList.isNotEmpty) {
    _writeControlAndStabilitySection(
      buf,
      controlRatios,
      encodeControlRatios,
      unstable,
      activeBenchmarksList.length,
    );
  }

  for (final target in canonicalTargets) {
    _writeTargetSection(
      buf,
      target,
      results,
      hasFourTiers: hasFourTiers,
      unstable: unstable,
      decodeMode: decodeMode,
      encodeMode: encodeMode,
      datasets: activeDatasets,
    );
  }

  if (streaming) {
    _writeStreamingVsMonolithicSection(buf, results, activeDatasets);
  }

  buf.writeln(_methodologyFooter(metric));
  return buf.toString();
}

void _writeControlAndStabilitySection(
  StringBuffer buf,
  Map<String, List<double>> controlRatios,
  Map<String, List<double>> encodeControlRatios,
  Set<String> unstable,
  int totalCells,
) {
  buf.writeln('### 🎛️ Measurement Controls & Resolution Floor\n');
  buf.writeln(
    'These diagnostics bound how much of the tables above is signal. '
    'Read them before crediting any ratio.\n',
  );

  _writeControlTable(buf, 'Decode', controlRatios);
  _writeControlTable(buf, 'Encode', encodeControlRatios);

  buf.writeln(
    '> **Decode control**: `$_controlCandidate` calls `jsonDecode(String)` '
    'plus `.fromJson()` hydration. On AOT and JS the fork alters only the '
    'UTF-8 *byte* parser (`_JsonUtf8Parser`), leaving this String path '
    'source-identical.\n'
    '>\n'
    '> **Encode control**: `$_encodeControlCandidate` calls '
    '`utf8.encode(String)`. There is no JSON encode path that is '
    'source-identical across the two SDKs — the fork relocates '
    '`JsonEncoder`, `_JsonEncoderSink` and `_JsonStringStringifier` out of '
    '`json.dart` — so the encode control must be a non-JSON codec. '
    '`sdk/lib/convert/utf8.dart` is untouched and no `convert_patch.dart` '
    'references `_Utf8Encoder`.\n'
    '>\n'
    '> **Codebase Layout Collateral**: The source on those paths is '
    'identical in both SDKs. However, because SDK forks often relocate '
    'hundreds of lines across libraries (e.g., into `dart:_internal`), '
    'measurements may drift due to snapshot alignment and cross-library '
    'code layout shifts underneath the control. A moving control is NOT '
    'by itself proof of a contaminated run — rather, its ratio bounds '
    '**layout collateral + environmental noise**.\n'
    '>\n'
    '> ⚠️ **Actionable Rule: Compare each cell against its own '
    'runtime\'s control band, never a pooled band.** Control spread is '
    'not a fixed property of a backend, and it does not necessarily '
    'track how much of that backend the fork edited — a run in which '
    'the least-edited backend shows the widest spread and the '
    'most-edited the narrowest is evidence of apparatus noise rather '
    'than of the patch. Re-derive the band per runtime from the '
    'current run instead of carrying numbers forward from a previous '
    'one, and treat per-tier maxima from small samples as weak '
    'statistics.',
  );

  buf.writeln(
    '>\n'
    '> **Which comparisons the control actually bounds.** Tier 0 and Tier 2 '
    'run on the stock `dart` binary; Tier 1 and Tier 3 run on the fork '
    'binary. Two binaries cannot share a process, so per-build and '
    'per-process bias falls entirely on the **cross-pass** ratios — '
    '*Tier 1 vs Tier 0*, *Tier 3 vs Tier 0*, and any Tier 2 vs Tier 1/3 '
    'comparison. It **cancels** in the **same-pass** ratios: '
    '*Tier 3 vs Tier 1* (both fork) and *Tier 2 vs Tier 0* (both stock). '
    'Do not discount same-pass figures on control-drift grounds.',
  );

  if (unstable.isNotEmpty) {
    final pct = (unstable.length / totalCells * 100).toStringAsFixed(0);
    buf.writeln(
      '>\n> **Sample stability**: ${unstable.length} of $totalCells measured '
      'cells ($pct%) are flagged `is_robust_stable: false` by the harness. '
      'Ratios involving them are marked ⚠️ in the breakdowns below and must '
      'not be quoted as measurements.',
    );
  }
  buf.writeln();
}

/// Emits one control table: a row per canonical target, with the geomean
/// control drift and the per-dataset ratios behind it.
///
/// [label] is `Decode` or `Encode`. Targets with no control data render as
/// `N/A` rather than being dropped, so a missing control is visible in the
/// report instead of silently absent.
void _writeControlTable(
  StringBuffer buf,
  String label,
  Map<String, List<double>> ratios,
) {
  buf.writeln('<!-- mdformat off(prevent table wrapping) -->');
  buf.writeln(
    '| Target Runtime | $label Control Drift (Tier 1 / Tier 0) | Per-Dataset Control Ratios |',
  );
  buf.writeln('| :--- | :---: | :--- |');
  for (final target in canonicalTargets) {
    final targetRatios = ratios[target];
    if (targetRatios == null || targetRatios.isEmpty) {
      buf.writeln('| **${target.toUpperCase()}** | N/A | N/A |');
      continue;
    }
    final per = targetRatios.map((r) => r.toStringAsFixed(3)).join(', ');
    buf.writeln(
      '| **${target.toUpperCase()}** | '
      '**${_geomean(targetRatios).toStringAsFixed(3)}x** | `[$per]` |',
    );
  }
  buf.writeln('<!-- mdformat on -->\n');
}

void _writeProvenanceSection(
  StringBuffer buf,
  dynamic jsonRoot,
  String metric,
  bool hasFourTiers,
) {
  buf.writeln('### 📝 Provenance\n');
  if (jsonRoot is! Map<String, dynamic>) return;

  final env = jsonRoot['environment'] as Map<String, dynamic>?;
  final timestamp = jsonRoot['timestamp'] as String? ?? 'unknown';
  final dartVersion = env?['dart_version'] as String? ?? 'unknown';
  final stockDartVersion = env?['stock_dart_version'] as String?;
  final commit = env?['commit'] as String? ?? 'unknown';
  final host = env?['host'] as String? ?? 'unknown';
  final os = env?['os'] as String? ?? 'unknown';

  if (dartVersion == 'unknown' || commit == 'unknown') {
    stderr.writeln(
      'Warning: Provenance data (timestamp, sdk, commit, host) is missing or '
      'unknown. Did you run patch_environment.dart?',
    );
  }

  final trialCount = _extractTrialCount(jsonRoot['benchmarks']);

  buf.writeln('- **Run Timestamp**: $timestamp');
  if (hasFourTiers && stockDartVersion != null) {
    buf.writeln('- **Stock Dart SDK (Tier 0 & Tier 2)**: $stockDartVersion');
    buf.writeln('- **New Dart SDK (Tier 1 & Tier 3)**: $dartVersion');
  } else {
    buf.writeln('- **SDK Version**: $dartVersion');
  }
  buf.writeln('- **Repo Commit**: $commit');
  buf.writeln('- **Host OS**: $os, Hostname: $host');
  buf.writeln('- **Trials**: $trialCount (reporting `$metric` latency)\n');
}

int _extractTrialCount(dynamic benchmarks) {
  if (benchmarks is! List || benchmarks.isEmpty) return 0;
  final firstBench = benchmarks.first;
  if (firstBench is! Map<String, dynamic>) return 0;
  final rawTrials = firstBench['raw_trials_ns'];
  return rawTrials is List ? rawTrials.length : 0;
}

void _writeFourTierLegendSection(StringBuffer buf, {bool streaming = false}) {
  buf.writeln('### 🏛️ The 4 Dart Serialization Tiers\n');
  if (streaming) {
    buf.writeln(
      '- **Tier 0 (`Stock Dart + json_serializable [Chunked Sink]`)**: '
      'Out-of-the-box status-quo baseline compiled & executed on unmodified '
      'Stock Dart (`utf8.decoder.fuse(json.decoder).startChunkedConversion` '
      'on 32 KB input chunks, and `json.encoder.fuse(utf8.encoder)'
      '.startChunkedConversion` for output).\n'
      '- **Tier 1 (`New Dart + json_serializable [Chunked Sink]`)**: '
      'Unmodified `json_serializable` chunked converter pipeline running on '
      'the upgraded `dart-sdk-json-next` SDK.\n'
      '- **Tier 2 (`Stock Dart + Codable [Mock Substrate]`)**: '
      '`package:codable` running on unmodified Stock Dart '
      '(`JsonCodableDecoder.startChunkedConversion` accumulating 32 KB chunks '
      'into `BytesBuilder(copy: false)` for `_MockJsonTokenReader`, and '
      '`JsonCodableEncoder.startChunkedConversion` streaming 32 KB chunks via '
      '`JsonTokenWriter.toSink`).\n'
      '- **Tier 3 (`New Dart + Codable [Native Substrate]`)**: Full end-to-end '
      'streaming stack (`package:codable` + `dart:convert` Layer 1 native '
      '`JsonTokenReader` / `JsonUtf8TokenWriter` chunked sink substrate).\n',
    );
    return;
  }
  buf.writeln(
    '- **Tier 0 (`Stock Dart + json_serializable`)**: Out-of-the-box '
    'status-quo baseline compiled & executed on unmodified Stock Dart '
    '(`dart:convert` DOM + `json_serializable`).\n'
    '- **Tier 1 (`New Dart + json_serializable`)**: Unmodified '
    '`json_serializable` running on the upgraded `dart-sdk-json-next` SDK '
    '(15->16 digit double fast-path, 32 KB stringifier buffers, and '
    'Eisel-Lemire float parser). Measures the zero-public-API-change speedup '
    'for existing `json_serializable` users.\n'
    '- **Tier 2 (`Stock Dart + Codable [Mock Substrate]`)**: `package:codable` '
    'running on unmodified Stock Dart using the pure-Dart mock substrate '
    '(`_MockJsonTokenReader` + 64-bit Eisel-Lemire + '
    '`AdaptiveJsonTokenWriter`). Measures what `package:codable` delivers if '
    'published on Stock Dart today with zero SDK changes.\n'
    '- **Tier 3 (`New Dart + Codable [Native Substrate]`)**: Full end-to-end '
    'stack (`package:codable` + `dart:convert` Layer 1 native '
    '`JsonTokenReader` / `JsonUtf8TokenWriter` substrate).\n',
  );
}

void _writeFourTierRuntimeSummary(
  StringBuffer buf,
  Map<String, Map<String, Map<String, double>>> results, {
  String decodeMode = 'decode',
  String encodeMode = 'encode',
  List<String> datasets = canonicalDatasets,
}) {
  buf.writeln(
    '### 📊 3-Runtime Summary '
    '(4-Tier Relative Efficiency & GeoMean Speedups)\n',
  );
  buf.writeln('<!-- mdformat off(prevent table wrapping) -->');
  buf.writeln(
    '| Target Runtime | Tier / Configuration | '
    '📥 Decode Efficiency<br/>[ Worst / GeoMean / Best ] | '
    '📥 Decode GeoMean<br/>(vs Tier 0 / vs Tier 1) | '
    '📤 Encode Efficiency<br/>[ Worst / GeoMean / Best ] | '
    '📤 Encode GeoMean<br/>(vs Tier 0 / vs Tier 1) |',
  );
  buf.writeln('| :--- | :--- | :---: | :---: | :---: | :---: |');

  const tierSpecs = [
    (
      key: 'stock_json_serializable',
      label: '**Tier 0: `Stock + json_serial`**',
    ),
    (key: 'json_serializable', label: '**Tier 1: `New + json_serial`**'),
    (key: 'stock_codable', label: '**Tier 2: `Stock + Codable [Mock]`**'),
    (key: 'codable', label: '**Tier 3: `New + Codable [Native]`**'),
  ];

  for (final target in canonicalTargets) {
    for (final tier in tierSpecs) {
      _writeFourTierSummaryRow(
        buf,
        target,
        tier.key,
        tier.label,
        results,
        decodeMode: decodeMode,
        encodeMode: encodeMode,
        datasets: datasets,
      );
    }
  }

  buf
    ..writeln('<!-- mdformat on -->\n')
    ..writeln(_efficiencyIndexCallout())
    ..writeln('${'-' * 72}\n');
}

void _writeFourTierSummaryRow(
  StringBuffer buf,
  String target,
  String tierKey,
  String tierLabel,
  Map<String, Map<String, Map<String, double>>> results, {
  required String decodeMode,
  required String encodeMode,
  required List<String> datasets,
}) {
  final decEff = _computeEfficiencyScores(
    results,
    target,
    decodeMode,
    tierKey,
    datasets: datasets,
  );
  final encEff = _computeEfficiencyScores(
    results,
    target,
    encodeMode,
    tierKey,
    datasets: datasets,
  );
  final decVsT0 = _computeModeSpeedupGeoMean(
    results,
    target,
    decodeMode,
    'stock_json_serializable',
    tierKey,
    datasets: datasets,
  );
  final decVsT1 = _computeModeSpeedupGeoMean(
    results,
    target,
    decodeMode,
    'json_serializable',
    tierKey,
    datasets: datasets,
  );
  final encVsT0 = _computeModeSpeedupGeoMean(
    results,
    target,
    encodeMode,
    'stock_json_serializable',
    tierKey,
    datasets: datasets,
  );
  final encVsT1 = _computeModeSpeedupGeoMean(
    results,
    target,
    encodeMode,
    'json_serializable',
    tierKey,
    datasets: datasets,
  );

  final targetLabel = _formatTargetLabel(target);
  buf.writeln(
    '| $targetLabel | $tierLabel | '
    '${_formatEfficiencyTriplet(decEff)} | '
    '**${decVsT0.toStringAsFixed(2)}x** / **${decVsT1.toStringAsFixed(2)}x** | '
    '${_formatEfficiencyTriplet(encEff)} | '
    '**${encVsT0.toStringAsFixed(2)}x** / **${encVsT1.toStringAsFixed(2)}x** |',
  );
}

List<double> _computeEfficiencyScores(
  Map<String, Map<String, Map<String, double>>> results,
  String target,
  String mode,
  String tierKey, {
  List<String> datasets = canonicalDatasets,
}) {
  const allTierKeys = [
    'stock_json_serializable',
    'json_serializable',
    'stock_codable',
    'codable',
  ];
  final scores = <double>[];
  for (final ds in datasets) {
    final group = results[target]?['${ds}_$mode'];
    final val = group?[tierKey];
    if (group == null || val == null) continue;
    final available = [
      for (final k in allTierKeys)
        if (group[k] != null) group[k]!,
    ];
    if (available.isEmpty) continue;
    final minVal = available.reduce(min);
    scores.add((minVal / val) * 100.0);
  }
  return scores;
}

double _computeModeSpeedupGeoMean(
  Map<String, Map<String, Map<String, double>>> results,
  String target,
  String mode,
  String baseKey,
  String candKey, {
  List<String> datasets = canonicalDatasets,
}) {
  final ratios = <double>[];
  for (final ds in datasets) {
    final group = results[target]?['${ds}_$mode'];
    final baseVal = group?[baseKey];
    final candVal = group?[candKey];
    if (baseVal != null && candVal != null && candVal > 0) {
      ratios.add(baseVal / candVal);
    }
  }
  return _geomean(ratios);
}

void _writeTwoTierRuntimeSummary(
  StringBuffer buf,
  Map<String, Map<String, Map<String, double>>> results, {
  String decodeMode = 'decode',
  String encodeMode = 'encode',
  List<String> datasets = canonicalDatasets,
}) {
  buf.writeln('### 📊 3-Runtime Summary (Relative Efficiency Index)\n');
  buf.writeln('<!-- mdformat off(prevent table wrapping) -->');
  buf.writeln(
    '| Target Runtime | Dart Configuration | 📥 Decode Efficiency<br/>[ Worst / GeoMean / Best ] | 📤 Encode Efficiency<br/>[ Worst / GeoMean / Best ] |',
  );
  buf.writeln('| :--- | :--- | :---: | :---: |');

  for (final target in canonicalTargets) {
    final decodeScores = _computeEfficiencyScores(
      results,
      target,
      decodeMode,
      'codable',
      datasets: datasets,
    );
    final encodeScores = _computeEfficiencyScores(
      results,
      target,
      encodeMode,
      'codable',
      datasets: datasets,
    );
    buf.writeln(
      '| ${_formatTargetLabel(target)} | **`New Dart + Codable`** | '
      '${_formatEfficiencyTriplet(decodeScores)} | '
      '${_formatEfficiencyTriplet(encodeScores)} |',
    );
  }

  buf
    ..writeln('<!-- mdformat on -->\n')
    ..writeln(_efficiencyIndexCallout())
    ..writeln('${'-' * 72}\n');
}

String _formatTargetLabel(String target) => switch (target) {
  'aot' => '**AOT (`dart compile exe`)**',
  'js' => '**JS (`dart2js` / Node 24 / V8)**',
  'wasm' => '**WASM (`dart2wasm` / Node 24 / V8)**',
  _ => target,
};

String _formatEfficiencyTriplet(List<double> scores) {
  if (scores.isEmpty) return 'N/A';
  final geo = _geomean(scores);
  final worst = scores.reduce(min);
  final best = scores.reduce(max);
  final badge = geo >= 90.0 ? '🟢' : (geo >= 70.0 ? '🟡' : '🔴');
  return '$badge `[ ${worst.round()} / ${geo.round()} / ${best.round()} ]`';
}

double _geomean(List<double> list) {
  if (list.isEmpty) return 0.0;
  final prod = list.fold(1.0, (acc, v) => acc * v);
  return pow(prod, 1.0 / list.length).toDouble();
}

String _efficiencyIndexCallout() =>
    '> **Scoring Metric**: **Relative Throughput Efficiency** '
    '(`100` = Peak Speed across all measured tiers). Calculated as '
    '`round((MinLatency / Latency) * 100)` per workload, aggregated across '
    'benchmarks using the **Geometric Mean** (Fleming & Wallace 1986).\n'
    '> - **`[ Worst / GeoMean / Best ]`**: Range from lowest score '
    '(worst workload) to the geometric mean and peak dataset score\n'
    '>   across the active canonical benchmarks.\n'
    '> - **Badges**: 🥇 Peak across all workloads (`100`) • '
    '🟢 `≥ 90` (Within 10% of peak) • 🟡 `70–89` (Good / moderate) • '
    '🔴 `< 70` (Significant performance gap).\n';

void _writeTargetSection(
  StringBuffer buf,
  String target,
  Map<String, Map<String, Map<String, double>>> results, {
  required bool hasFourTiers,
  Set<String> unstable = const {},
  String decodeMode = 'decode',
  String encodeMode = 'encode',
  List<String> datasets = canonicalDatasets,
}) {
  final upper = target.toUpperCase();
  buf.writeln('### 🎯 $upper Target Detailed Breakdown\n');

  for (final mode in [decodeMode, encodeMode]) {
    final modeCap = switch (mode) {
      'decode_stream' => 'Decode Stream (32 KB Chunks)',
      'encode_stream' => 'Encode Stream (BytesBuilder / ByteConversionSink)',
      _ => '${mode[0].toUpperCase()}${mode.substring(1)}',
    };
    buf.writeln('#### Detailed Breakdown: $upper $modeCap\n');
    if (hasFourTiers) {
      _writeFourTierModeTable(
        buf,
        target,
        mode,
        results,
        unstable,
        datasets: datasets,
      );
    } else {
      _writeTwoTierModeTable(buf, target, mode, results, datasets: datasets);
    }
  }
  buf.writeln('${'-' * 72}\n');
}

void _writeFourTierModeTable(
  StringBuffer buf,
  String target,
  String mode,
  Map<String, Map<String, Map<String, double>>> results,
  Set<String> unstable, {
  List<String> datasets = canonicalDatasets,
}) {
  buf.writeln('<!-- mdformat off(prevent table wrapping) -->');
  buf.writeln(
    '| Workload / Dataset | '
    'Tier 0: Stock + json_serial | '
    'Tier 1: New + json_serial | '
    'Tier 2: Stock + Codable [Mock] | '
    'Tier 3: New + Codable [Native] | '
    'Tier 1 vs Tier 0 (SDK + Substrate Build) | '
    'Tier 2 vs Tier 0 (Codable on Stock) | '
    'Speedup vs Tier 0 (Stock json_serial) | '
    'Speedup vs Tier 1 (New json_serial) |',
  );
  buf.writeln(
    '| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |',
  );

  final t1VsT0Ratios = <double>[];
  final t2VsT0Ratios = <double>[];
  final t3VsT0Ratios = <double>[];
  final t3VsT1Ratios = <double>[];
  var flagged = 0;

  for (final ds in datasets) {
    final groupKey = '${ds}_$mode';
    final group = results[target]?[groupKey];
    final t0 = group?['stock_json_serializable'];
    final t1 = group?['json_serializable'];
    final t2 = group?['stock_codable'];
    final t3 = group?['codable'];
    final dsName = datasetNames[ds]!;

    bool shaky(String candidateKey) =>
        unstable.contains('$target|$groupKey|$candidateKey');

    final u0 = shaky('stock_json_serializable');
    final u1 = shaky('json_serializable');
    final u2 = shaky('stock_codable');
    final u3 = shaky('codable');
    if (u0 || u1 || u2 || u3) flagged++;

    if (t0 != null && t1 != null) t1VsT0Ratios.add(t0 / t1);
    if (t0 != null && t2 != null) t2VsT0Ratios.add(t0 / t2);
    if (t0 != null && t3 != null) t3VsT0Ratios.add(t0 / t3);
    if (t1 != null && t3 != null) t3VsT1Ratios.add(t1 / t3);

    buf.writeln(
      '| **$dsName** | '
      '${_formatNullableTime(t0)} | '
      '${_formatNullableTime(t1)} | '
      '${_formatNullableTime(t2)} | '
      '**${_formatNullableTime(t3)}** | '
      '${_formatGatedSpeedup(t0, t1, u0 || u1)} | '
      '${_formatGatedSpeedup(t0, t2, u0 || u2)} | '
      '${_formatGatedSpeedup(t0, t3, u0 || u3)} | '
      '${_formatGatedSpeedup(t1, t3, u1 || u3)} |',
    );
  }

  buf.writeln(
    '| **Geometric Mean** | — | — | — | — | '
    '${_formatRatioGeoMean(t1VsT0Ratios)} | '
    '${_formatRatioGeoMean(t2VsT0Ratios)} | '
    '${_formatRatioGeoMean(t3VsT0Ratios)} | '
    '${_formatRatioGeoMean(t3VsT1Ratios)} |',
  );
  buf.writeln('<!-- mdformat on -->\n');
  if (flagged > 0) {
    buf.writeln(
      '> ⚠️ $flagged of ${datasets.length} workloads in this table '
      'draw on samples flagged `is_robust_stable: false`. The Geometric Mean '
      'includes them and inherits their uncertainty.\n',
    );
  }
  buf.writeln();
}

void _writeTwoTierModeTable(
  StringBuffer buf,
  String target,
  String mode,
  Map<String, Map<String, Map<String, double>>> results, {
  List<String> datasets = canonicalDatasets,
}) {
  buf.writeln('<!-- mdformat off(prevent table wrapping) -->');
  buf.writeln(
    '| Workload / Dataset | json_serializable | package:codable | '
    'Speedup vs json_serializable |',
  );
  buf.writeln('| :--- | :---: | :---: | :---: |');

  for (final ds in datasets) {
    final b = '${ds}_$mode';
    final jsVal = results[target]?[b]?['json_serializable'];
    final codableVal = results[target]?[b]?['codable'];
    final dsName = datasetNames[ds]!;

    if (jsVal != null && codableVal != null) {
      buf.writeln(
        '| **$dsName** | ${_formatTime(jsVal)} | '
        '**${_formatTime(codableVal)}** | '
        '${_formatSpeedup(jsVal, codableVal)} |',
      );
    } else {
      buf.writeln('| **$dsName** | N/A | N/A | N/A |');
    }
  }
  buf.writeln('<!-- mdformat on -->\n\n');
}

void _writeStreamingVsMonolithicSection(
  StringBuffer buf,
  Map<String, Map<String, Map<String, double>>> results,
  List<String> datasets,
) {
  var hasMonolithic = false;
  for (final target in canonicalTargets) {
    for (final ds in datasets) {
      if (results[target]?.containsKey('${ds}_decode') ?? false) {
        hasMonolithic = true;
        break;
      }
    }
  }
  if (!hasMonolithic) return;

  buf.writeln(
    '### 🔄 Streaming vs. Monolithic Single-Buffer Overhead '
    '(`Stream / Sink` vs. `Single Buffer`)\n',
  );
  buf.writeln(
    'Compares the chunked conversion sink latency (`32 KB` slices) against the '
    'in-memory single-buffer latency (`Stream Latency / Monolithic Latency`; '
    '`1.00x` = zero streaming overhead, `< 1.00x` = streaming is faster than '
    'monolithic allocation).\n',
  );
  buf.writeln('<!-- mdformat off(prevent table wrapping) -->');
  buf.writeln(
    '| Target | Mode & Dataset | '
    'Tier 0 Ratio (Stream / Mono) | '
    'Tier 1 Ratio (Stream / Mono) | '
    'Tier 2 Ratio (Stream / Mono) | '
    'Tier 3 Ratio (Stream / Mono) |',
  );
  buf.writeln('| :--- | :--- | :---: | :---: | :---: | :---: |');

  for (final target in canonicalTargets) {
    final upper = target.toUpperCase();
    for (final baseMode in ['decode', 'encode']) {
      final streamMode = '${baseMode}_stream';
      final modeLabel = baseMode == 'decode' ? '📥 Decode' : '📤 Encode';
      for (final ds in datasets) {
        final monoGroup = results[target]?['${ds}_$baseMode'];
        final streamGroup = results[target]?['${ds}_$streamMode'];
        if (monoGroup == null || streamGroup == null) continue;
        String fmtRatio(String key) {
          final m = monoGroup[key];
          final s = streamGroup[key];
          if (m == null || s == null || m <= 0) return 'N/A';
          return '`${(s / m).toStringAsFixed(2)}x` '
              '(${_formatTime(s)} vs ${_formatTime(m)})';
        }

        buf.writeln(
          '| **$upper** | $modeLabel `${datasetNames[ds]}` | '
          '${fmtRatio('stock_json_serializable')} | '
          '${fmtRatio('json_serializable')} | '
          '${fmtRatio('stock_codable')} | '
          '**${fmtRatio('codable')}** |',
        );
      }
    }
  }
  buf.writeln('<!-- mdformat on -->\n');
  buf.writeln('${'-' * 72}\n');
}

String _methodologyFooter(String metric) =>
    '''
### 🔬 Methodology & Caveats

- Every cell is the **$metric** of the trial count listed in the provenance
  header.
  - **Tier 0 (`Stock Dart + json_serializable`)** and **Tier 2 (`Stock Dart + Codable [Mock]`)** are compiled and executed in a dedicated Stock Dart pass with `substrate.dart` switched to `mock`.
  - **Tier 1 (`New Dart + json_serializable`)** and **Tier 3 (`New Dart + Codable [Native]`)** are compiled and executed in the `native_kernels` pass with `substrate.dart` switched to `native`.
- **Use `median`, not `min`.** `min` reports whichever configuration drew the
  single luckiest trial. On multimodal workloads that is enough to flip the
  sign of a comparison, so `--metric median` is the default. Regenerating this
  report with `--metric min` is a diagnostic, not a publication.
- **`Tier 1 vs Tier 0` is not an SDK-only comparison.** The two passes differ by
  SDK *and* by substrate build (`mock` vs `native`), because the native
  substrate re-exports symbols that only exist in the forked SDK and cannot be
  compiled by stock Dart. The binaries therefore differ in retained code and
  layout even for candidates that never call the substrate. Read that column as
  *SDK + build configuration*, never as an isolated SDK delta.
- **Stability gate**: cells the harness flagged `is_robust_stable: false` have
  their derived ratios marked ⚠️. A marked ratio is not a measurement. See the
  *Measurement Controls & Resolution Floor* section for the run-wide count and
  the unchanged-code control drift.
- **Dual Speedup Baselines**:
  - **Speedup vs Tier 0 (`Stock Dart + json_serializable`)**: Measures total end-to-end speedup over out-of-the-box Stock Dart.
  - **Speedup vs Tier 1 (`New Dart + json_serializable`)**: Measures the isolated streaming vs. DOM mapping speedup on the identical upgraded SDK.
- **Resolution limit**: at 10–15 trials this harness cannot reliably resolve
  latency deltas below roughly **10%**. Run-to-run drift is large enough to
  flip the sign of small effects. Treat any speedup between `0.90x` and
  `1.10x` as *no measured difference*.
- **Single invocation**: every cell comes from one process launch. Workloads
  whose launch-to-launch distribution is multimodal cannot be resolved at any
  estimator from a single invocation; they need repeated launches with a
  median-of-medians aggregate.
''';

String _formatNullableTime(double? us) => us == null ? 'N/A' : _formatTime(us);

String _formatTime(double us) {
  if (us < 1000) {
    return '${us.toStringAsFixed(1)} µs';
  }
  return '${(us / 1000).toStringAsFixed(2)} ms';
}

String _formatNullableSpeedup(double? baseUs, double? candUs) =>
    (baseUs == null || candUs == null) ? 'N/A' : _formatSpeedup(baseUs, candUs);

/// Like [_formatNullableSpeedup], but appends a warning glyph when either
/// operand came from samples the harness flagged as not robustly stable.
String _formatGatedSpeedup(double? baseUs, double? candUs, bool unstable) {
  final formatted = _formatNullableSpeedup(baseUs, candUs);
  if (formatted == 'N/A' || !unstable) return formatted;
  return '$formatted ⚠️';
}

String _formatSpeedup(double baseUs, double candUs) {
  final ratio = baseUs / candUs;
  return '**${ratio.toStringAsFixed(2)}x**';
}

String _formatRatioGeoMean(List<double> ratios) =>
    ratios.isEmpty ? 'N/A' : '**${_geomean(ratios).toStringAsFixed(2)}x**';
