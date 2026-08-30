// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'kbssd_math.dart';

/// Statistical summary result for a single benchmark execution.
class BenchmarkResult {
  final String dataset;
  final String mode;
  final String engine;
  final int fileBytes;
  final int innerIterations;
  final List<double> samples; // in microseconds per operation
  final bool isStable;
  final double convergenceThreshold;

  final double latencyMs; // Median latency
  final double meanMs;
  final double stdDevMs;
  final double p95Ms;
  final double iqrMs;
  final double minMs;
  final double maxMs;
  final double throughputMbS;

  BenchmarkResult({
    required this.dataset,
    required this.mode,
    required this.engine,
    required this.fileBytes,
    required this.innerIterations,
    required this.samples,
    required this.isStable,
    required this.convergenceThreshold,
  }) : latencyMs = calculateMedian(samples) / 1000.0,
       meanMs = calculateMean(samples) / 1000.0,
       stdDevMs = calculateStdDev(samples, calculateMean(samples)) / 1000.0,
       p95Ms =
           calculatePercentile(List<double>.from(samples)..sort(), 0.95) /
           1000.0,
       iqrMs = calculateIQR(samples) / 1000.0,
       minMs =
           (samples.isEmpty
               ? 0.0
               : (List<double>.from(samples)..sort()).first) /
           1000.0,
       maxMs =
           (samples.isEmpty ? 0.0 : (List<double>.from(samples)..sort()).last) /
           1000.0,
       throughputMbS = _calculateThroughput(
         fileBytes,
         calculateMedian(samples),
       );

  static double _calculateThroughput(int fileBytes, double medianMicros) {
    if (medianMicros <= 0.0) return 0.0;
    final seconds = medianMicros / 1000000.0;
    return (fileBytes / (1024 * 1024)) / seconds;
  }

  Map<String, dynamic> toJson() => {
    'dataset': dataset,
    'mode': mode,
    'engine': engine,
    'iterations': innerIterations,
    'samples_collected': samples.length,
    'file_bytes': fileBytes,
    'latency_ms': latencyMs,
    'mean_ms': meanMs,
    'stddev_ms': stdDevMs,
    'p95_ms': p95Ms,
    'iqr_ms': iqrMs,
    'min_ms': minMs,
    'max_ms': maxMs,
    'is_stable': isStable,
    'throughput_mb_s': throughputMbS,
  };
}
