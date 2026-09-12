// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:args/args.dart';

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
    ..addFlag('help', abbr: 'h', negatable: false, help: 'Print usage.');

  final argResults = parser.parse(args);
  if (argResults.flag('help')) {
    print('Usage: dart run tool/generate_report.dart [options]');
    print(parser.usage);
    return;
  }

  final inputFile = File(argResults.option('input')!);
  if (!inputFile.existsSync()) {
    stderr.writeln('Error: Input file ${inputFile.path} does not exist.');
    exit(1);
  }

  final dynamic jsonRoot = jsonDecode(inputFile.readAsStringSync());
  final List<dynamic> benchmarksList;
  if (jsonRoot is Map<String, dynamic> && jsonRoot['benchmarks'] is List) {
    benchmarksList = jsonRoot['benchmarks'] as List<dynamic>;
  } else if (jsonRoot is List) {
    benchmarksList = jsonRoot;
  } else {
    stderr.writeln('Error: Unrecognized JSON structure in ${inputFile.path}.');
    exit(1);
  }

  // results[target][workload][candidate] = medianMicroseconds
  final results = <String, Map<String, Map<String, double>>>{
    'aot': {},
    'js': {},
    'wasm': {},
  };

  for (final raw in benchmarksList) {
    final entry = raw as Map<String, dynamic>;
    final target = entry['target'] as String?;
    if (target == null || !results.containsKey(target)) continue;

    final candidate = entry['name'] as String?;
    if (candidate == null) continue;

    final coords = entry['coordinates'] as Map<String, dynamic>?;
    final group = coords?['group'] as String?;
    if (group == null) continue;

    final metrics = entry['metrics'] as Map<String, dynamic>?;
    if (metrics == null) continue;

    final medianNs =
        (metrics['median_ns'] as num?)?.toDouble() ??
        (metrics['mean_ns'] as num?)?.toDouble();
    if (medianNs == null) continue;

    final medianUs = medianNs / 1000.0;
    results[target]!.putIfAbsent(group, () => {})[candidate] = medianUs;
  }

  final report = generateMarkdownReport(results, jsonRoot);
  print(report);

  final reportFile = File(argResults.option('output-report')!);
  reportFile.writeAsStringSync(report);
  print('💾 Markdown report saved to ${reportFile.path}');

  final unifiedFile = File(argResults.option('output-unified')!);
  unifiedFile.writeAsStringSync(
    const JsonEncoder.withIndent('  ').convert(results),
  );
  print('💾 Unified telemetry saved to ${unifiedFile.path}');
}

String generateMarkdownReport(
  Map<String, Map<String, Map<String, double>>> results,
  dynamic jsonRoot,
) {
  final buf = StringBuffer();

  buf.writeln('### 📝 Provenance\n');
  if (jsonRoot is Map<String, dynamic>) {
    final env = jsonRoot['environment'] as Map<String, dynamic>?;
    final timestamp = jsonRoot['timestamp'] as String? ?? 'unknown';

    final dartVersion = env?['dart_version'] ?? 'unknown';
    final commit = env?['commit'] ?? 'unknown';
    final host = env?['host'] ?? 'unknown';
    final os = env?['os'] ?? 'unknown';

    int trialCount = 0;
    if (jsonRoot['benchmarks'] is List &&
        (jsonRoot['benchmarks'] as List).isNotEmpty) {
      final firstBench = (jsonRoot['benchmarks'] as List)[0];
      if (firstBench['raw_trials_ns'] is List) {
        trialCount = (firstBench['raw_trials_ns'] as List).length;
      }
    }

    buf.writeln('- **Run Timestamp**: $timestamp');
    buf.writeln('- **SDK Version**: $dartVersion');
    buf.writeln('- **Repo Commit**: $commit');
    buf.writeln('- **Host OS**: $os, Hostname: $host');
    buf.writeln('- **Trials**: $trialCount');
    buf.writeln('');
  }

  buf.writeln('### 📊 3-Runtime Summary (Relative Efficiency Index)\n');
  buf.writeln('<!-- mdformat off(prevent table wrapping) -->');
  buf.writeln(
    '| Target Runtime | Dart Configuration | 📥 Decode Efficiency<br/>[ Worst / GeoMean / Best ] | 📤 Encode Efficiency<br/>[ Worst / GeoMean / Best ] |',
  );
  buf.writeln('| :--- | :--- | :---: | :---: |');

  final canonicalDatasets = [
    'coordinates',
    'canada',
    'citm_catalog',
    'small',
    'twitter',
  ];

  for (final target in ['aot', 'js', 'wasm']) {
    final decodeScores = <double>[];
    final encodeScores = <double>[];

    for (final ds in canonicalDatasets) {
      final decGroup = '${ds}_decode';
      final encGroup = '${ds}_encode';

      final decJs = results[target]?[decGroup]?['json_serializable'] ?? 1.0;
      final decCodable = results[target]?[decGroup]?['codable'] ?? 1.0;
      final decMin = min(decJs, decCodable);
      decodeScores.add((decMin / decCodable) * 100.0);

      final encJs = results[target]?[encGroup]?['json_serializable'] ?? 1.0;
      final encCodable = results[target]?[encGroup]?['codable'] ?? 1.0;
      final encMin = min(encJs, encCodable);
      encodeScores.add((encMin / encCodable) * 100.0);
    }

    double geomean(List<double> list) {
      if (list.isEmpty) return 0.0;
      final prod = list.fold(1.0, (acc, v) => acc * v);
      return pow(prod, 1.0 / list.length).toDouble();
    }

    final decGeo = geomean(decodeScores);
    final encGeo = geomean(encodeScores);

    final decWorst = decodeScores.isEmpty ? 0.0 : decodeScores.reduce(min);
    final decBest = decodeScores.isEmpty ? 0.0 : decodeScores.reduce(max);
    final encWorst = encodeScores.isEmpty ? 0.0 : encodeScores.reduce(min);
    final encBest = encodeScores.isEmpty ? 0.0 : encodeScores.reduce(max);

    String badge(double g) => g >= 90.0 ? '🟢' : (g >= 70.0 ? '🟡' : '🔴');

    final targetLabel = switch (target) {
      'aot' => '**AOT (`dart compile exe`)**',
      'js' => '**JS (`dart2js` / Node 24 / V8)**',
      'wasm' => '**WASM (`dart2wasm` / Node 24 / V8)**',
      _ => target,
    };

    buf.writeln(
      '| $targetLabel | **`New Dart + Codable`** | '
      '${badge(decGeo)} `[ ${decWorst.round()} / ${decGeo.round()} / ${decBest.round()} ]` | '
      '${badge(encGeo)} `[ ${encWorst.round()} / ${encGeo.round()} / ${encBest.round()} ]` |',
    );
  }

  buf
    ..writeln('<!-- mdformat on -->\n')
    ..writeln(
      '> **Scoring Metric**: **Relative Throughput Efficiency** '
      '(`100` = Peak Speed). Calculated as '
      '`round((MinLatency / Latency) * 100)` per workload, aggregated across '
      'benchmarks using the **Geometric Mean** (Fleming & Wallace 1986).\n'
      '> - **`[ Worst / GeoMean / Best ]`**: Range from lowest score '
      '(worst workload) to the geometric mean and peak dataset score\n'
      '>   across the 5 canonical benchmarks (`coordinates`, `canada`, '
      '`citm_catalog`, `small`, `twitter`).\n'
      '> - **Badges**: 🥇 Peak across all workloads (`100`) • '
      '🟢 `≥ 90` (Within 10% of peak) • 🟡 `70–89` (Good / moderate) • '
      '🔴 `< 70` (Significant performance gap).\n',
    )
    ..writeln('${'-' * 72}\n');

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

    buf.writeln('### 🎯 $title\n');
    for (final mode in ['decode', 'encode']) {
      final modeTitle = switch (target) {
        'aot' => 'AOT ${mode[0].toUpperCase()}${mode.substring(1)}',
        'js' => 'JS ${mode[0].toUpperCase()}${mode.substring(1)}',
        'wasm' => 'WASM ${mode[0].toUpperCase()}${mode.substring(1)}',
        _ => mode,
      };

      buf.writeln('#### Detailed Breakdown: $modeTitle\n');
      buf.writeln('<!-- mdformat off(prevent table wrapping) -->');
      buf.writeln(
        '| Workload / Dataset | json_serializable | package:codable | '
        'Speedup vs json_serializable |',
      );
      buf.writeln('| :--- | :---: | :---: | :---: |');

      for (final ds in canonicalDatasets) {
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
    buf.writeln('${'-' * 72}\n');
  }

  return buf.toString();
}

String _formatTime(double us) {
  if (us < 1000) {
    return '${us.toStringAsFixed(1)} µs';
  } else {
    return '${(us / 1000).toStringAsFixed(2)} ms';
  }
}

String _formatSpeedup(double baseUs, double candUs) {
  final ratio = baseUs / candUs;
  return '**${ratio.toStringAsFixed(2)}x**';
}
