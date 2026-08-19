// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:io';

import 'package:checks/checks.dart';
import 'package:codable_benchmarks/codable_benchmarks.dart';
import 'package:test/test.dart';

class _MockCounterBenchmark extends Benchmark {
  int count = 0;

  _MockCounterBenchmark()
    : super('MockCounter', category: 'Testing', payloadBytes: 1000);

  @override
  void setup() {
    count = 0;
  }

  @override
  dynamic run() {
    count++;
    return count;
  }
}

void main() {
  group('In-Tree Benchmark Harness', () {
    test('Blackhole consumes objects safely', () {
      Blackhole.preventDCE();
      Blackhole.consume(42);
      Blackhole.consume('test_string');
      Blackhole.consume({'a': 1, 'b': 2});
      blackhole([1, 2, 3]);
    });

    test('RunMetrics calculates statistics and throughput accurately', () {
      final samples = [10.0, 12.0, 14.0, 16.0, 18.0];
      final metrics = RunMetrics.fromSamples(
        samplesUs: samples,
        payloadBytes: 1000000, // 1 MB
        iterationsPerSample: 1,
      );

      check(metrics.samplesCount).equals(5);
      check(metrics.minUs).equals(10.0);
      check(metrics.maxUs).equals(18.0);
      check(metrics.medianUs).equals(14.0);
      check(metrics.meanUs).equals(14.0);
      check(metrics.stdDevUs).isGreaterThan(0.0);
      check(metrics.throughputMbS).isGreaterThan(70000.0); // 10^6 bytes / 14 us

      // JSON roundtrip
      final json = metrics.toJson();
      final decoded = RunMetrics.fromJson(json);
      check(decoded.medianUs).equals(metrics.medianUs);
      check(decoded.throughputMbS).equals(metrics.throughputMbS);
    });

    test('BenchmarkRunner executes, calibrates, and writes JSON report', () {
      final tmpDir = Directory.systemTemp.createTempSync('bench_harness_test_');
      final outputFile = '${tmpDir.path}/report.json';

      try {
        final runner = BenchmarkRunner(
          config: BenchmarkConfig(
            targetSampleMicros: 1000,
            warmupSamples: 2,
            sampleRuns: 5,
            outputPath: outputFile,
          ),
        );

        final bench = _MockCounterBenchmark();
        runner.add(bench);

        final report = runner.runSuite(suiteName: 'Test Suite');

        check(report.suiteName).equals('Test Suite');
        check(report.results).length.equals(1);
        check(report.results.first.name).equals('MockCounter');
        check(report.results.first.metrics.samplesCount).equals(5);

        // Assert file written
        final file = File(outputFile);
        check(file.existsSync()).isTrue();
        final content = file.readAsStringSync();
        check(content).contains('MockCounter');
        check(content).contains('throughput_mb_s');

        // Parse back
        final parsedMap = jsonDecode(content) as Map<String, dynamic>;
        final parsed = BenchmarkSuiteReport.fromJson(parsedMap);
        check(parsed.suiteName).equals('Test Suite');
        check(parsed.results.first.name).equals('MockCounter');
      } finally {
        tmpDir.deleteSync(recursive: true);
      }
    });
  });
}
