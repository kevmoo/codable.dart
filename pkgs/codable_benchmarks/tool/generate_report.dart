// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:args/args.dart';
import 'package:md_live/md_live.dart';
import 'package:path/path.dart' as p;

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
      'expect-sdk',
      help:
          'Path to the Dart SDK the caller intends these results to '
          'describe. The report is refused if it disagrees with '
          'environment.dart_version.',
    )
    ..addOption(
      'expect-stock-sdk',
      help:
          'Path to the Stock Dart SDK the caller intends these results to '
          'describe, checked against environment.stock_dart_version.',
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

  _assertMeasuredSdkMatchesReported(
    jsonRoot,
    expectSdk: argResults.option('expect-sdk'),
    expectStockSdk: argResults.option('expect-stock-sdk'),
  );
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

  final reportPath = argResults.wasParsed('output-report')
      ? argResults.option('output-report')!
      : (streaming ? 'STREAMING_BENCHMARK_REPORT.md' : 'BENCHMARK_REPORT.md');
  final reportFile = File(reportPath);
  final report = _renderOrProjectReportFile(
    reportFile: reportFile,
    inputFile: inputFile,
    results: results,
    jsonRoot: jsonRoot,
    metric: metricFlag,
    benchmarksList: benchmarksList,
    streaming: streaming,
  );
  print(report);

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

String _renderOrProjectReportFile({
  required File reportFile,
  required File inputFile,
  required Map<String, Map<String, Map<String, double>>> results,
  required dynamic jsonRoot,
  required String metric,
  required List<dynamic> benchmarksList,
  required bool streaming,
}) {
  final srcFilePath = p.relative(inputFile.path, from: reportFile.parent.path);
  if (reportFile.existsSync()) {
    final existingMd = reportFile.readAsStringSync();
    final namespaces = extractSentinelNamespaces(existingMd);
    if (namespaces.isNotEmpty) {
      final (:customTableRows, :inlineValues) = buildReportMdLiveProjection(
        results,
        jsonRoot,
        metric,
        benchmarksList: benchmarksList,
        streaming: streaming,
      );
      final jsonByPath = jsonRoot is Map<String, dynamic>
          ? <String, Map<String, dynamic>>{srcFilePath: jsonRoot}
          : const <String, Map<String, dynamic>>{};
      return projectSentinelMarkdown(
        existingMd,
        namespace: namespaces.first,
        jsonByPath: jsonByPath,
        customTableRows: customTableRows,
        inlineValues: inlineValues,
      );
    }
  }
  return generateMarkdownReport(
    results,
    jsonRoot,
    metric,
    benchmarksList: benchmarksList,
    streaming: streaming,
    srcFilePath: srcFilePath,
  );
}

List<Map<String, dynamic>> _filterActiveBenchmarks(
  List<dynamic> benchmarksList, {
  required bool streaming,
}) => [
  for (final raw in benchmarksList)
    if (raw is Map<String, dynamic> &&
        ((raw['coordinates'] as Map<String, dynamic>?)?['group'] as String? ??
                    '')
                .endsWith('_stream') ==
            streaming)
      raw,
];

/// Computes `customTableRows` and `inlineValues` for either
/// `BENCHMARK_REPORT.md` (`streaming: false`) or
/// `STREAMING_BENCHMARK_REPORT.md` (`streaming: true`).
({
  Map<String, List<List<String>>> customTableRows,
  Map<String, Object> inlineValues,
})
buildReportMdLiveProjection(
  Map<String, Map<String, Map<String, double>>> results,
  dynamic jsonRoot,
  String metric, {
  List<dynamic> benchmarksList = const [],
  bool streaming = false,
}) {
  final hasFourTiers = _hasFourTierData(results, streaming: streaming);
  final activeDatasets = _resolveActiveDatasets(results, streaming: streaming);
  final (decodeMode, encodeMode, prefix, inlinePrefix) = streaming
      ? ('decode_stream', 'encode_stream', 'stream-', 'stream_')
      : ('decode', 'encode', '', '');
  final activeBenchmarks = _filterActiveBenchmarks(
    benchmarksList,
    streaming: streaming,
  );
  final unstable = collectUnstableCells(activeBenchmarks);

  final customTableRows = <String, List<List<String>>>{
    '${prefix}runtime-summary': hasFourTiers
        ? _buildFourTierSummaryRows(
            results,
            decodeMode: decodeMode,
            encodeMode: encodeMode,
            datasets: activeDatasets,
          )
        : _buildTwoTierSummaryRows(
            results,
            decodeMode: decodeMode,
            encodeMode: encodeMode,
            datasets: activeDatasets,
          ),
    '${prefix}decode-control': _buildControlRows(
      extractControlRatios(benchmarksList, metric, mode: decodeMode),
    ),
    '${prefix}encode-control': _buildControlRows(
      extractControlRatios(
        benchmarksList,
        metric,
        mode: encodeMode,
        candidate: _encodeControlCandidate,
      ),
    ),
  };

  final inlineValues = _extractProvenanceInlineValues(jsonRoot);
  final totalCells = activeBenchmarks.length;
  final pct = (unstable.length / max(1, totalCells) * 100).toStringAsFixed(0);
  inlineValues['${inlinePrefix}unstable_cells'] = unstable.length;
  inlineValues['${inlinePrefix}total_cells'] = totalCells;
  inlineValues['${inlinePrefix}unstable_pct'] = '$pct%';

  for (final target in canonicalTargets) {
    for (final mode in [decodeMode, encodeMode]) {
      final tableId = '$target-${mode.replaceAll('_', '-')}';
      if (hasFourTiers) {
        final (:rows, :flagged) = _buildFourTierModeTableData(
          target,
          mode,
          results,
          unstable,
          datasets: activeDatasets,
        );
        customTableRows[tableId] = rows;
        inlineValues['$tableId-unstable'] = flagged;
        inlineValues['$tableId-datasets'] = activeDatasets.length;
      } else {
        customTableRows[tableId] = _buildTwoTierModeRows(
          target,
          mode,
          results,
          datasets: activeDatasets,
        );
      }
    }
  }

  if (streaming) {
    final streamVsMono = _buildStreamingVsMonolithicRows(
      results,
      activeDatasets,
    );
    if (streamVsMono.isNotEmpty) {
      customTableRows['stream-vs-mono'] = streamVsMono;
    }
  }

  return (customTableRows: customTableRows, inlineValues: inlineValues);
}

Map<String, Object> _extractProvenanceInlineValues(dynamic jsonRoot) {
  if (jsonRoot is! Map<String, dynamic>) return <String, Object>{};
  final env = jsonRoot['environment'] as Map<String, dynamic>?;
  return <String, Object>{
    'timestamp': jsonRoot['timestamp'] as String? ?? 'unknown',
    'dart_version': env?['dart_version'] as String? ?? 'unknown',
    'stock_dart_version': env?['stock_dart_version'] as String? ?? 'unknown',
    'commit': env?['commit'] as String? ?? 'unknown',
    'host': env?['host'] as String? ?? 'unknown',
    'os': env?['os'] as String? ?? 'unknown',
    'trial_count': _extractTrialCount(jsonRoot['benchmarks']),
  };
}

String generateMarkdownReport(
  Map<String, Map<String, Map<String, double>>> results,
  dynamic jsonRoot,
  String metric, {
  List<dynamic> benchmarksList = const [],
  bool streaming = false,
  String srcFilePath = 'benchmark_results.json',
}) {
  final buf = StringBuffer();
  final namespace = streaming ? 'bench-stream' : 'bench';
  final src = '$srcFilePath#benchmarks';
  final hasFourTiers = _hasFourTierData(results, streaming: streaming);
  final decodeMode = streaming ? 'decode_stream' : 'decode';
  final encodeMode = streaming ? 'encode_stream' : 'encode';
  final activeBenchmarks = _filterActiveBenchmarks(
    benchmarksList,
    streaming: streaming,
  );
  final (:customTableRows, :inlineValues) = buildReportMdLiveProjection(
    results,
    jsonRoot,
    metric,
    benchmarksList: benchmarksList,
    streaming: streaming,
  );
  final prefix = streaming ? 'stream-' : '';

  if (streaming) {
    buf.writeln(
      '## 🌊 Streaming Benchmark Report '
      '(`ChunkedConversionSink` / `ByteConversionSink`)\n',
    );
  }

  _writeProvenanceSection(buf, jsonRoot, metric, hasFourTiers, inlineValues);
  if (hasFourTiers) {
    _writeFourTierLegendSection(buf, streaming: streaming);
    buf.writeln(
      '### 📊 3-Runtime Summary '
      '(4-Tier Relative Efficiency & GeoMean Speedups)\n',
    );
    _writeSentinelTable(
      buf,
      namespace: namespace,
      sentinelId: '${prefix}runtime-summary',
      src: src,
      headers: _fourTierSummaryHeaders,
      alignments: _fourTierSummaryAlignments,
      rows: customTableRows['${prefix}runtime-summary']!,
    );
  } else {
    buf.writeln('### 📊 3-Runtime Summary (Relative Efficiency Index)\n');
    _writeSentinelTable(
      buf,
      namespace: namespace,
      sentinelId: '${prefix}runtime-summary',
      src: src,
      headers: _twoTierSummaryHeaders,
      alignments: _twoTierSummaryAlignments,
      rows: customTableRows['${prefix}runtime-summary']!,
    );
  }
  buf
    ..writeln(_efficiencyIndexCallout())
    ..writeln('${'-' * 72}\n');

  if (activeBenchmarks.isNotEmpty) {
    _writeControlAndStabilitySection(
      buf,
      namespace: namespace,
      src: src,
      prefix: prefix,
      inlinePrefix: streaming ? 'stream_' : '',
      customTableRows: customTableRows,
      inlineValues: inlineValues,
    );
  }

  for (final target in canonicalTargets) {
    _writeTargetSection(
      buf,
      target,
      namespace: namespace,
      src: src,
      hasFourTiers: hasFourTiers,
      decodeMode: decodeMode,
      encodeMode: encodeMode,
      customTableRows: customTableRows,
      inlineValues: inlineValues,
    );
  }

  if (streaming && customTableRows.containsKey('stream-vs-mono')) {
    _writeStreamingVsMonolithicSection(
      buf,
      namespace: namespace,
      src: src,
      rows: customTableRows['stream-vs-mono']!,
    );
  }

  buf.writeln(_methodologyFooter(metric));
  return buf.toString();
}

void _writeSentinelTable(
  StringBuffer buf, {
  required String namespace,
  required String sentinelId,
  required String src,
  required List<String> headers,
  required List<String> alignments,
  required List<List<String>> rows,
}) {
  buf
    ..writeln(
      renderSentinelTableBlock(
        namespace: namespace,
        sentinelId: sentinelId,
        src: src,
        headers: headers,
        alignments: alignments,
        rows: rows,
      ),
    )
    ..writeln();
}

const List<String> _controlTableAlignments = [':---', ':---:', ':---'];

void _writeControlAndStabilitySection(
  StringBuffer buf, {
  required String namespace,
  required String src,
  required String prefix,
  required String inlinePrefix,
  required Map<String, List<List<String>>> customTableRows,
  required Map<String, Object> inlineValues,
}) {
  buf.writeln('### 🎛️ Measurement Controls & Resolution Floor\n');
  buf.writeln(
    'These diagnostics bound how much of the tables above is signal. '
    'Read them before crediting any ratio.\n',
  );

  _writeSentinelTable(
    buf,
    namespace: namespace,
    sentinelId: '${prefix}decode-control',
    src: src,
    headers: const [
      'Target Runtime',
      'Decode Control Drift (Tier 1 / Tier 0)',
      'Per-Dataset Control Ratios',
    ],
    alignments: _controlTableAlignments,
    rows: customTableRows['${prefix}decode-control']!,
  );
  _writeSentinelTable(
    buf,
    namespace: namespace,
    sentinelId: '${prefix}encode-control',
    src: src,
    headers: const [
      'Target Runtime',
      'Encode Control Drift (Tier 1 / Tier 0)',
      'Per-Dataset Control Ratios',
    ],
    alignments: _controlTableAlignments,
    rows: customTableRows['${prefix}encode-control']!,
  );

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

  final unstableCount = inlineValues['${inlinePrefix}unstable_cells'] as int;
  if (unstableCount > 0) {
    final uSpan = renderLiveSpan(
      '${inlinePrefix}unstable_cells',
      unstableCount,
    );
    final tSpan = renderLiveSpan(
      '${inlinePrefix}total_cells',
      inlineValues['${inlinePrefix}total_cells']!,
    );
    final pSpan = renderLiveSpan(
      '${inlinePrefix}unstable_pct',
      inlineValues['${inlinePrefix}unstable_pct']!,
    );
    buf.writeln(
      '>\n> **Sample stability**: $uSpan of $tSpan measured '
      'cells ($pSpan) are flagged `is_robust_stable: false` by the harness. '
      'Ratios involving them are marked ⚠️ in the breakdowns below and must '
      'not be quoted as measurements.',
    );
  }
  buf.writeln();
}

List<List<String>> _buildControlRows(Map<String, List<double>> ratios) => [
  for (final target in canonicalTargets)
    if (ratios[target] case final targetRatios? when targetRatios.isNotEmpty)
      [
        '**${target.toUpperCase()}**',
        '**${_geomean(targetRatios).toStringAsFixed(3)}x**',
        '`[${targetRatios.map((r) => r.toStringAsFixed(3)).join(', ')}]`',
      ]
    else
      ['**${target.toUpperCase()}**', 'N/A', 'N/A'],
];

void _writeProvenanceSection(
  StringBuffer buf,
  dynamic jsonRoot,
  String metric,
  bool hasFourTiers,
  Map<String, Object> inlineValues,
) {
  buf.writeln('### 📝 Provenance\n');
  if (jsonRoot is! Map<String, dynamic>) return;

  final dartVersion = inlineValues['dart_version'] as String;
  final commit = inlineValues['commit'] as String;
  final env = jsonRoot['environment'] as Map<String, dynamic>?;
  final stockDartVersion = env?['stock_dart_version'] as String?;

  if (dartVersion == 'unknown' || commit == 'unknown') {
    stderr.writeln(
      'Warning: Provenance data (timestamp, sdk, commit, host) is missing or '
      'unknown. Did you run patch_environment.dart?',
    );
  }

  buf.writeln(
    '- **Run Timestamp**: '
    '${renderLiveSpan('timestamp', inlineValues['timestamp']!)}',
  );
  if (hasFourTiers && stockDartVersion != null) {
    buf.writeln(
      '- **Stock Dart SDK (Tier 0 & Tier 2)**: '
      '${renderLiveSpan('stock_dart_version', stockDartVersion)}',
    );
    buf.writeln(
      '- **New Dart SDK (Tier 1 & Tier 3)**: '
      '${renderLiveSpan('dart_version', dartVersion)}',
    );
  } else {
    buf.writeln(
      '- **SDK Version**: ${renderLiveSpan('dart_version', dartVersion)}',
    );
  }
  buf.writeln('- **Repo Commit**: ${renderLiveSpan('commit', commit)}');
  buf.writeln(
    '- **Host OS**: ${renderLiveSpan('os', inlineValues['os']!)}, '
    'Hostname: ${renderLiveSpan('host', inlineValues['host']!)}',
  );
  buf.writeln(
    '- **Trials**: ${renderLiveSpan('trial_count', inlineValues['trial_count']!)} '
    '(reporting `$metric` latency)\n',
  );
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

const List<String> _fourTierSummaryHeaders = [
  'Target Runtime',
  'Tier / Configuration',
  '📥 Decode Efficiency<br/>[ Worst / GeoMean / Best ]',
  '📥 Decode GeoMean<br/>(vs Tier 0 / vs Tier 1)',
  '📤 Encode Efficiency<br/>[ Worst / GeoMean / Best ]',
  '📤 Encode GeoMean<br/>(vs Tier 0 / vs Tier 1)',
];

const List<String> _fourTierSummaryAlignments = [
  ':---',
  ':---',
  ':---:',
  ':---:',
  ':---:',
  ':---:',
];

List<List<String>> _buildFourTierSummaryRows(
  Map<String, Map<String, Map<String, double>>> results, {
  String decodeMode = 'decode',
  String encodeMode = 'encode',
  List<String> datasets = canonicalDatasets,
}) {
  const tierSpecs = [
    (
      key: 'stock_json_serializable',
      label: '**Tier 0: `Stock + json_serial`**',
    ),
    (key: 'json_serializable', label: '**Tier 1: `New + json_serial`**'),
    (key: 'stock_codable', label: '**Tier 2: `Stock + Codable [Mock]`**'),
    (key: 'codable', label: '**Tier 3: `New + Codable [Native]`**'),
  ];
  final rows = <List<String>>[];
  for (final target in canonicalTargets) {
    final targetLabel = _formatTargetLabel(target);
    for (final tier in tierSpecs) {
      final decEff = _computeEfficiencyScores(
        results,
        target,
        decodeMode,
        tier.key,
        datasets: datasets,
      );
      final encEff = _computeEfficiencyScores(
        results,
        target,
        encodeMode,
        tier.key,
        datasets: datasets,
      );
      final decVsT0 = _computeModeSpeedupGeoMean(
        results,
        target,
        decodeMode,
        'stock_json_serializable',
        tier.key,
        datasets: datasets,
      );
      final decVsT1 = _computeModeSpeedupGeoMean(
        results,
        target,
        decodeMode,
        'json_serializable',
        tier.key,
        datasets: datasets,
      );
      final encVsT0 = _computeModeSpeedupGeoMean(
        results,
        target,
        encodeMode,
        'stock_json_serializable',
        tier.key,
        datasets: datasets,
      );
      final encVsT1 = _computeModeSpeedupGeoMean(
        results,
        target,
        encodeMode,
        'json_serializable',
        tier.key,
        datasets: datasets,
      );
      rows.add([
        targetLabel,
        tier.label,
        _formatEfficiencyTriplet(decEff),
        '**${decVsT0.toStringAsFixed(2)}x** / '
            '**${decVsT1.toStringAsFixed(2)}x**',
        _formatEfficiencyTriplet(encEff),
        '**${encVsT0.toStringAsFixed(2)}x** / '
            '**${encVsT1.toStringAsFixed(2)}x**',
      ]);
    }
  }
  return rows;
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

const List<String> _twoTierSummaryHeaders = [
  'Target Runtime',
  'Dart Configuration',
  '📥 Decode Efficiency<br/>[ Worst / GeoMean / Best ]',
  '📤 Encode Efficiency<br/>[ Worst / GeoMean / Best ]',
];

const List<String> _twoTierSummaryAlignments = [
  ':---',
  ':---',
  ':---:',
  ':---:',
];

List<List<String>> _buildTwoTierSummaryRows(
  Map<String, Map<String, Map<String, double>>> results, {
  String decodeMode = 'decode',
  String encodeMode = 'encode',
  List<String> datasets = canonicalDatasets,
}) => [
  for (final target in canonicalTargets)
    [
      _formatTargetLabel(target),
      '**`New Dart + Codable`**',
      _formatEfficiencyTriplet(
        _computeEfficiencyScores(
          results,
          target,
          decodeMode,
          'codable',
          datasets: datasets,
        ),
      ),
      _formatEfficiencyTriplet(
        _computeEfficiencyScores(
          results,
          target,
          encodeMode,
          'codable',
          datasets: datasets,
        ),
      ),
    ],
];

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

const List<String> _fourTierModeHeaders = [
  'Workload / Dataset',
  'Tier 0: Stock + json_serial',
  'Tier 1: New + json_serial',
  'Tier 2: Stock + Codable [Mock]',
  'Tier 3: New + Codable [Native]',
  'Tier 1 vs Tier 0 (SDK + Substrate Build)',
  'Tier 2 vs Tier 0 (Codable on Stock)',
  'Speedup vs Tier 0 (Stock json_serial)',
  'Speedup vs Tier 1 (New json_serial)',
];

const List<String> _fourTierModeAlignments = [
  ':---',
  ':---:',
  ':---:',
  ':---:',
  ':---:',
  ':---:',
  ':---:',
  ':---:',
  ':---:',
];

const List<String> _twoTierModeHeaders = [
  'Workload / Dataset',
  'json_serializable',
  'package:codable',
  'Speedup vs json_serializable',
];

const List<String> _twoTierModeAlignments = [':---', ':---:', ':---:', ':---:'];

void _writeTargetSection(
  StringBuffer buf,
  String target, {
  required String namespace,
  required String src,
  required bool hasFourTiers,
  required String decodeMode,
  required String encodeMode,
  required Map<String, List<List<String>>> customTableRows,
  required Map<String, Object> inlineValues,
}) {
  final upper = target.toUpperCase();
  buf.writeln('### 🎯 $upper Target Detailed Breakdown\n');

  for (final mode in [decodeMode, encodeMode]) {
    final modeCap = switch (mode) {
      'decode_stream' => 'Decode Stream (32 KB Chunks)',
      'encode_stream' => 'Encode Stream (BytesBuilder / ByteConversionSink)',
      _ => '${mode[0].toUpperCase()}${mode.substring(1)}',
    };
    final tableId = '$target-${mode.replaceAll('_', '-')}';
    buf.writeln('#### Detailed Breakdown: $upper $modeCap\n');
    _writeSentinelTable(
      buf,
      namespace: namespace,
      sentinelId: tableId,
      src: src,
      headers: hasFourTiers ? _fourTierModeHeaders : _twoTierModeHeaders,
      alignments: hasFourTiers
          ? _fourTierModeAlignments
          : _twoTierModeAlignments,
      rows: customTableRows[tableId]!,
    );
    if (hasFourTiers) {
      final flagged = inlineValues['$tableId-unstable'] as int? ?? 0;
      if (flagged > 0) {
        final fSpan = renderLiveSpan('$tableId-unstable', flagged);
        final dSpan = renderLiveSpan(
          '$tableId-datasets',
          inlineValues['$tableId-datasets']!,
        );
        buf.writeln(
          '> ⚠️ $fSpan of $dSpan workloads in this table '
          'draw on samples flagged `is_robust_stable: false`. The Geometric '
          'Mean includes them and inherits their uncertainty.\n',
        );
      }
      buf.writeln();
    }
  }
  buf.writeln('${'-' * 72}\n');
}

({
  List<String> row,
  bool isFlagged,
  double? t1VsT0,
  double? t2VsT0,
  double? t3VsT0,
  double? t3VsT1,
})
_evaluateFourTierDatasetRow(
  String target,
  String groupKey,
  String ds,
  Map<String, double>? group,
  Set<String> unstable,
) {
  final t0 = group?['stock_json_serializable'];
  final t1 = group?['json_serializable'];
  final t2 = group?['stock_codable'];
  final t3 = group?['codable'];
  final u0 = unstable.contains('$target|$groupKey|stock_json_serializable');
  final u1 = unstable.contains('$target|$groupKey|json_serializable');
  final u2 = unstable.contains('$target|$groupKey|stock_codable');
  final u3 = unstable.contains('$target|$groupKey|codable');

  return (
    row: [
      '**${datasetNames[ds]}**',
      _formatNullableTime(t0),
      _formatNullableTime(t1),
      _formatNullableTime(t2),
      '**${_formatNullableTime(t3)}**',
      formatSpeedupRatio(t0, t1, unstable: u0 || u1),
      formatSpeedupRatio(t0, t2, unstable: u0 || u2),
      formatSpeedupRatio(t0, t3, unstable: u0 || u3),
      formatSpeedupRatio(t1, t3, unstable: u1 || u3),
    ],
    isFlagged: u0 || u1 || u2 || u3,
    t1VsT0: (t0 != null && t1 != null) ? t0 / t1 : null,
    t2VsT0: (t0 != null && t2 != null) ? t0 / t2 : null,
    t3VsT0: (t0 != null && t3 != null) ? t0 / t3 : null,
    t3VsT1: (t1 != null && t3 != null) ? t1 / t3 : null,
  );
}

({List<List<String>> rows, int flagged}) _buildFourTierModeTableData(
  String target,
  String mode,
  Map<String, Map<String, Map<String, double>>> results,
  Set<String> unstable, {
  List<String> datasets = canonicalDatasets,
}) {
  final rows = <List<String>>[];
  final t1VsT0Ratios = <double>[];
  final t2VsT0Ratios = <double>[];
  final t3VsT0Ratios = <double>[];
  final t3VsT1Ratios = <double>[];
  var flagged = 0;

  for (final ds in datasets) {
    final groupKey = '${ds}_$mode';
    final eval = _evaluateFourTierDatasetRow(
      target,
      groupKey,
      ds,
      results[target]?[groupKey],
      unstable,
    );
    rows.add(eval.row);
    if (eval.isFlagged) flagged++;
    if (eval.t1VsT0 case final r?) t1VsT0Ratios.add(r);
    if (eval.t2VsT0 case final r?) t2VsT0Ratios.add(r);
    if (eval.t3VsT0 case final r?) t3VsT0Ratios.add(r);
    if (eval.t3VsT1 case final r?) t3VsT1Ratios.add(r);
  }

  rows.add([
    '**Geometric Mean**',
    '—',
    '—',
    '—',
    '—',
    _formatRatioGeoMean(t1VsT0Ratios),
    _formatRatioGeoMean(t2VsT0Ratios),
    _formatRatioGeoMean(t3VsT0Ratios),
    _formatRatioGeoMean(t3VsT1Ratios),
  ]);
  return (rows: rows, flagged: flagged);
}

List<List<String>> _buildTwoTierModeRows(
  String target,
  String mode,
  Map<String, Map<String, Map<String, double>>> results, {
  List<String> datasets = canonicalDatasets,
}) => [
  for (final ds in datasets)
    if ((
          results[target]?['${ds}_$mode']?['json_serializable'],
          results[target]?['${ds}_$mode']?['codable'],
        )
        case (final jsVal?, final codableVal?))
      [
        '**${datasetNames[ds]}**',
        _formatTime(jsVal),
        '**${_formatTime(codableVal)}**',
        formatSpeedupRatio(jsVal, codableVal),
      ]
    else
      ['**${datasetNames[ds]}**', 'N/A', 'N/A', 'N/A'],
];

String _formatStreamVsMonoRatio(
  Map<String, double> monoGroup,
  Map<String, double> streamGroup,
  String key,
) {
  final m = monoGroup[key];
  final s = streamGroup[key];
  if (m == null || s == null || m <= 0) return 'N/A';
  return '`${(s / m).toStringAsFixed(2)}x` '
      '(${_formatTime(s)} vs ${_formatTime(m)})';
}

List<List<String>> _buildStreamingVsMonolithicRows(
  Map<String, Map<String, Map<String, double>>> results,
  List<String> datasets,
) {
  final rows = <List<String>>[];
  for (final target in canonicalTargets) {
    final upper = target.toUpperCase();
    for (final baseMode in ['decode', 'encode']) {
      final modeLabel = baseMode == 'decode' ? '📥 Decode' : '📤 Encode';
      for (final ds in datasets) {
        final monoGroup = results[target]?['${ds}_$baseMode'];
        final streamGroup = results[target]?['${ds}_${baseMode}_stream'];
        if (monoGroup == null || streamGroup == null) continue;
        rows.add([
          '**$upper**',
          '$modeLabel `${datasetNames[ds]}`',
          _formatStreamVsMonoRatio(
            monoGroup,
            streamGroup,
            'stock_json_serializable',
          ),
          _formatStreamVsMonoRatio(monoGroup, streamGroup, 'json_serializable'),
          _formatStreamVsMonoRatio(monoGroup, streamGroup, 'stock_codable'),
          '**${_formatStreamVsMonoRatio(monoGroup, streamGroup, 'codable')}**',
        ]);
      }
    }
  }
  return rows;
}

void _writeStreamingVsMonolithicSection(
  StringBuffer buf, {
  required String namespace,
  required String src,
  required List<List<String>> rows,
}) {
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
  _writeSentinelTable(
    buf,
    namespace: namespace,
    sentinelId: 'stream-vs-mono',
    src: src,
    headers: const [
      'Target',
      'Mode & Dataset',
      'Tier 0 Ratio (Stream / Mono)',
      'Tier 1 Ratio (Stream / Mono)',
      'Tier 2 Ratio (Stream / Mono)',
      'Tier 3 Ratio (Stream / Mono)',
    ],
    alignments: const [':---', ':---', ':---:', ':---:', ':---:', ':---:'],
    rows: rows,
  );
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

String _formatRatioGeoMean(List<double> ratios) =>
    ratios.isEmpty ? 'N/A' : formatSpeedupRatio(_geomean(ratios), 1);

/// Refuses to emit a report when the SDK that produced the measurements
/// disagrees with the SDK stamped into the results.
///
/// `environment.dart_version` is written by whichever `dart` *launched* the
/// harness, which is not necessarily the SDK bench_press compiled and ran.
/// When those diverge the report describes one SDK while claiming another,
/// silently invalidating any A/B built on it.
///
/// [expectSdk] and [expectStockSdk] are the SDKs the caller says these results
/// describe. They are the authoritative check: unlike bench_press's build
/// cache, they cannot be removed by cleaning `.dart_tool`, so a report
/// generated after `rm -rf .dart_tool/bench_press/build` is still verified.
///
/// The build cache is still consulted as a secondary signal when present.
void _assertMeasuredSdkMatchesReported(
  dynamic jsonRoot, {
  String? expectSdk,
  String? expectStockSdk,
}) {
  final problems = collectSdkMismatchProblems(
    jsonRoot,
    expectSdk: expectSdk,
    expectStockSdk: expectStockSdk,
  );
  if (problems.isEmpty) return;

  stderr.writeln(
    '\nERROR: SDK mismatch — this report would describe measurements taken '
    'with a different SDK than it claims.\n',
  );
  for (final problem in problems) {
    stderr.writeln('  $problem');
  }
  stderr.writeln(
    '\nbench_press compiles against its config\'s `sdk` axis, which outranks '
    'CODABLE_NATIVE_SDK and DART_SDK. Point the config at the SDK you intend '
    'to measure, delete .dart_tool/bench_press/build, and re-run.\n'
    'Refusing to generate a report.',
  );
  exit(1);
}

/// Collects human-readable descriptions of any disagreements between the SDKs
/// stamped in [jsonRoot]'s `environment` block, the caller-declared SDK paths
/// ([expectSdk], [expectStockSdk]), and any surviving `bench_press`
/// `.cache_key` build artifacts under [buildDir].
List<String> collectSdkMismatchProblems(
  dynamic jsonRoot, {
  String? expectSdk,
  String? expectStockSdk,
  Directory? buildDir,
  String? Function(String dartExe) probeVersion = _probeDartVersion,
}) {
  if (jsonRoot is! Map<String, dynamic>) return const [];
  final env = jsonRoot['environment'] as Map<String, dynamic>?;
  final reported = env?['dart_version'] as String?;

  final problems = <String>[];

  void checkDeclared(String? sdkPath, String? stamped, String label) {
    if (sdkPath == null || sdkPath.isEmpty) return;
    final version = probeVersion(_dartBinFor(sdkPath));
    if (version == null) {
      problems.add(
        '$label: could not run the declared SDK to determine its version: '
        '$sdkPath',
      );
      return;
    }
    if (stamped == null || stamped.isEmpty) {
      problems.add(
        '$label: results carry no version stamp to compare against '
        '$version (did patch_environment.dart run?)',
      );
      return;
    }
    if (!_matchesStampedVersion(stamped, version)) {
      problems.add(
        '$label:\n'
        '    declared by caller: $version ($sdkPath)\n'
        '    stamped in results: $stamped',
      );
    }
  }

  checkDeclared(expectSdk, reported, 'native SDK');
  checkDeclared(
    expectStockSdk,
    env?['stock_dart_version'] as String?,
    'stock SDK',
  );

  // Secondary signal: whatever bench_press last compiled against, if its build
  // cache survives. Absent after a clean, which is why it cannot be the only
  // check.
  if (reported != null && reported.isNotEmpty) {
    final effectiveBuildDir =
        buildDir ?? Directory(p.join('.dart_tool', 'bench_press', 'build'));
    if (effectiveBuildDir.existsSync()) {
      final measured = <String, String>{};
      for (final entity in effectiveBuildDir.listSync(recursive: true)) {
        if (entity is! File || !entity.path.endsWith('.cache_key')) continue;
        for (final line in entity.readAsLinesSync()) {
          if (!line.startsWith('dartExe:')) continue;
          final dartExe = line.substring('dartExe:'.length).trim();
          if (dartExe.isEmpty || !File(dartExe).existsSync()) break;
          final version = probeVersion(dartExe);
          if (version != null) measured[dartExe] = version;
          break;
        }
      }
      for (final e in measured.entries) {
        if (!_matchesStampedVersion(reported, e.value)) {
          problems.add(
            'compiled artifact:\n'
            '    built against:      ${e.value} (${e.key})\n'
            '    stamped in results: $reported',
          );
        }
      }
    }
  }

  return problems;
}

bool _matchesStampedVersion(String stamped, String probed) =>
    stamped == probed || stamped.startsWith('$probed ');

/// Resolves [sdkPath] to a `dart` executable, accepting either an SDK root or
/// the executable itself.
String _dartBinFor(String sdkPath) {
  if (sdkPath.endsWith('${p.separator}dart') || sdkPath.endsWith('/dart')) {
    return sdkPath;
  }
  return p.join(sdkPath, 'bin', 'dart');
}

String? _probeDartVersion(String dartExe) {
  try {
    final result = Process.runSync(dartExe, ['--version']);
    if (result.exitCode != 0) return null;
    final text = '${result.stdout}\n${result.stderr}'.trim();
    final match = RegExp(
      r'^Dart SDK version:\s*(.+)$',
      multiLine: true,
    ).firstMatch(text);
    return match?.group(1)?.trim();
  } on ProcessException {
    return null;
  }
}
