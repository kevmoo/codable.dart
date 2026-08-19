// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:io';

import 'blackhole.dart';
import 'models.dart';

/// Configuration for benchmark execution and sampling.
final class BenchmarkConfig {
  /// Target execution time per sample window in microseconds (default: 20ms).
  final int targetSampleMicros;

  /// Number of warmup iterations or samples (default: 5).
  final int warmupSamples;

  /// Number of measured sample runs (default: 10).
  final int sampleRuns;

  /// Optional JSON output file path to write results to.
  final String? outputPath;

  const BenchmarkConfig({
    this.targetSampleMicros = 20000,
    this.warmupSamples = 5,
    this.sampleRuns = 10,
    this.outputPath,
  });
}

/// A single benchmark definition.
abstract class Benchmark {
  final String name;
  final String category;
  final int payloadBytes;

  Benchmark(this.name, {this.category = 'General', this.payloadBytes = 0});

  /// Optional setup hook executed once before measurement begins.
  void setup() {}

  /// The benchmarked operation. The return value is automatically consumed
  /// by [Blackhole].
  dynamic run();

  /// Optional teardown hook executed once after measurement ends.
  void teardown() {}
}

/// Engine to execute, measure, calibrate, and report on [Benchmark]s.
final class BenchmarkRunner {
  final BenchmarkConfig config;
  final List<Benchmark> _benchmarks = [];

  BenchmarkRunner({this.config = const BenchmarkConfig()}) {
    Blackhole.preventDCE();
  }

  void add(Benchmark benchmark) {
    _benchmarks.add(benchmark);
  }

  /// Measures a single benchmark with auto-calibration.
  BenchmarkResult measure(Benchmark benchmark) {
    benchmark.setup();
    try {
      // 1. Auto-Calibrate: determine iterations per sample window
      final iterations = _calibrate(benchmark);

      // 2. Warmup
      for (var i = 0; i < config.warmupSamples; i++) {
        _measure(benchmark, iterations);
      }

      // 3. Timed Sampling
      final samplesUs = <double>[];
      for (var i = 0; i < config.sampleRuns; i++) {
        final elapsedMicros = _measure(benchmark, iterations);
        samplesUs.add(elapsedMicros / iterations);
      }

      final metrics = RunMetrics.fromSamples(
        samplesUs: samplesUs,
        payloadBytes: benchmark.payloadBytes,
        iterationsPerSample: iterations,
      );

      return BenchmarkResult(
        name: benchmark.name,
        category: benchmark.category,
        payloadBytes: benchmark.payloadBytes,
        timestamp: DateTime.now().toUtc(),
        environment: HostEnvironment.current(),
        metrics: metrics,
        rawSamplesUs: samplesUs,
      );
    } finally {
      benchmark.teardown();
    }
  }

  /// Runs all registered benchmarks and returns the suite report.
  BenchmarkSuiteReport runSuite({
    String suiteName = 'Serialization Benchmarks',
  }) {
    final results = <BenchmarkResult>[];
    for (final b in _benchmarks) {
      final res = measure(b);
      results.add(res);
      _printResult(res);
    }

    final report = BenchmarkSuiteReport(
      suiteName: suiteName,
      timestamp: DateTime.now().toUtc(),
      environment: HostEnvironment.current(),
      results: results,
    );

    if (config.outputPath != null) {
      final file = File(config.outputPath!);
      file.parent.createSync(recursive: true);
      const encoder = JsonEncoder.withIndent('  ');
      file.writeAsStringSync(encoder.convert(report.toJson()));
      print('\n[Saved benchmark results to: ${file.path}]');
    }

    return report;
  }

  int _calibrate(Benchmark b) {
    var iterations = 1;
    while (true) {
      final elapsed = _measure(b, iterations);
      if (elapsed >= config.targetSampleMicros ~/ 2) {
        final calculated = (iterations * (config.targetSampleMicros / elapsed))
            .ceil();
        return calculated > 0 ? calculated : 1;
      }
      iterations *= 2;
      if (iterations > 1000000) return iterations;
    }
  }

  int _measure(Benchmark b, int iterations) {
    final sw = Stopwatch()..start();
    for (var i = 0; i < iterations; i++) {
      Blackhole.consume(b.run());
    }
    sw.stop();
    return sw.elapsedMicroseconds;
  }

  void _printResult(BenchmarkResult res) {
    final m = res.metrics;
    final speed = m.throughputMbS > 0
        ? '${m.throughputMbS.toStringAsFixed(1).padLeft(7)} MB/s'
        : '';
    final timeMs = (m.medianUs / 1000.0).toStringAsFixed(2).padLeft(6);
    print('${res.name.padRight(42)}: $timeMs ms (median)  |  $speed');
  }
}
