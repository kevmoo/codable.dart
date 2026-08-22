// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io' show stderr;
import 'dart:math' as math;

import 'benchmark_result.dart';
import 'blackhole.dart';
import 'kbssd_math.dart';

/// Configuration for [BenchmarkRunner].
class RunnerConfig {
  /// Target elapsed time in microseconds for a single measurement sample.
  final int targetSampleMicros;

  /// Minimum number of converged samples to collect.
  final int minSamples;

  /// Maximum total samples before terminating if non-converged.
  final int maxSamples;

  /// Maximum total execution time in microseconds per workload.
  final int maxTotalMicros;

  /// Target relative Standard Error of the Mean (SEM) threshold
  /// (e.g. 0.05 = 5%).
  final double targetRelativeError;

  /// Sliding window size for MMD steady-state convergence.
  final int windowSize;

  /// Number of consecutive stable window comparisons required.
  final int stabilityRequired;

  /// Symmetric window trimming percentage.
  final double trimPercentage;

  /// Pre-calibration warmup duration in microseconds to stabilize JIT/AOT execution.
  final int warmupMicros;

  const RunnerConfig({
    this.targetSampleMicros = 10000, // 10 ms
    this.minSamples = 30,
    this.maxSamples = 100,
    this.maxTotalMicros = 3000000, // 3 seconds
    this.targetRelativeError = 0.05,
    this.windowSize = 10,
    this.stabilityRequired = 5,
    this.trimPercentage = 0.10,
    this.warmupMicros = 100000, // 100 ms
  });
}

/// Adaptive statistical benchmark runner with KBSSD convergence detection.
class BenchmarkRunner {
  final String dataset;
  final String mode;
  final String engine;
  final int fileBytes;
  final RunnerConfig config;

  BenchmarkRunner({
    required this.dataset,
    required this.mode,
    required this.engine,
    required this.fileBytes,
    this.config = const RunnerConfig(),
  }) {
    Blackhole.preventDCE();
  }

  void _log(String message) {
    try {
      stderr.writeln('[$engine:$dataset:$mode] $message');
    } catch (_) {
      // Ignore if stderr is unavailable (e.g. browser context)
    }
  }

  /// Calibrates inner loop iteration count to achieve target sample window.
  int calibrate(void Function() benchmark) {
    // 1. Warmup Epoch (triggers V8 JIT tier-up and AOT branch training)
    final warmupWatch = Stopwatch()..start();
    while (warmupWatch.elapsedMicroseconds < config.warmupMicros) {
      benchmark();
    }
    warmupWatch.stop();

    // 2. Adaptive Loop Doubling
    var iterations = 1;
    while (true) {
      final sw = Stopwatch()..start();
      for (var i = 0; i < iterations; i++) {
        benchmark();
      }
      sw.stop();

      final elapsed = sw.elapsedMicroseconds;
      if (elapsed >= config.targetSampleMicros || iterations >= 1000000) {
        return iterations;
      }
      if (elapsed == 0) {
        iterations *= 10;
      } else {
        final ratio = (config.targetSampleMicros / elapsed).ceil();
        iterations = math.max(iterations * 2, iterations * ratio);
      }
    }
  }

  /// Runs the benchmark with calibrated iterations and returns a
  /// [BenchmarkResult].
  BenchmarkResult run(void Function() benchmark) {
    final iterations = calibrate(benchmark);
    final buffer = <double>[];
    final totalWatch = Stopwatch()..start();
    final windowSize = math.max(2, config.windowSize);
    final coldBufferSize = windowSize * 2;

    int measure() {
      final sw = Stopwatch()..start();
      for (var i = 0; i < iterations; i++) {
        benchmark();
      }
      sw.stop();
      return sw.elapsedMicroseconds;
    }

    // 1. Fill Initial Cold Buffer
    while (buffer.length < coldBufferSize) {
      final elapsed = measure();
      buffer.add(elapsed / iterations);
    }

    // 2. Compute Bounded Convergence Threshold
    final coldBuffer = List<double>.from(buffer)..sort();
    final coldMedian = calculateMedian(coldBuffer);
    final coldMAD = calculateMAD(coldBuffer, coldMedian);
    final rawRelativeMAD = coldMedian > 0 ? (coldMAD / coldMedian) : 0.01;
    // Clamp threshold to [1%, 5%] to prevent noise reward/penalty
    final convergenceThreshold = rawRelativeMAD.clamp(0.01, 0.05);

    var stabilityCount = 0;
    var converged = false;
    final steadySamples = <double>[];

    // 3. Sliding Window Convergence Detection
    while (buffer.length < config.maxSamples) {
      if (totalWatch.elapsedMicroseconds > config.maxTotalMicros) {
        break;
      }

      final elapsed = measure();
      final perOpMicros = elapsed / iterations;
      buffer.add(perOpMicros);

      if (buffer.length > coldBufferSize) {
        buffer.removeAt(0);
      }

      final past = trimWindow(
        buffer.sublist(0, windowSize),
        config.trimPercentage,
      );
      final present = trimWindow(
        buffer.sublist(windowSize),
        config.trimPercentage,
      );

      final combined = past + present;
      final sigma = estimateSigma(combined);
      final combinedMedian = calculateMedian(combined);
      final mmd = calculateMMD(
        past,
        present,
        sigma,
        medianFloor: combinedMedian,
      );

      final isSteady =
          mmd < convergenceThreshold ||
          checkSEM(present, targetRelativeError: config.targetRelativeError);
      if (isSteady) {
        stabilityCount++;
        steadySamples.add(perOpMicros);
      } else {
        stabilityCount = 0;
        steadySamples.clear();
      }

      if (stabilityCount >= config.stabilityRequired &&
          steadySamples.length >= config.minSamples) {
        converged = true;
        break;
      }
    }

    final finalSamples = steadySamples.length >= config.minSamples
        ? steadySamples
        : buffer.sublist(math.max(0, buffer.length - config.minSamples));

    if (!converged) {
      _log(
        'Warning: Benchmark did not reach strict steady-state convergence; '
        'utilizing last ${finalSamples.length} samples.',
      );
    }

    return BenchmarkResult(
      dataset: dataset,
      mode: mode,
      engine: engine,
      fileBytes: fileBytes,
      innerIterations: iterations,
      samples: finalSamples,
      isStable: converged,
      convergenceThreshold: convergenceThreshold,
    );
  }
}
