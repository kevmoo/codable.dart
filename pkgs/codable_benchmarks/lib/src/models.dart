// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';
import 'dart:math' as math;

/// Host environment metadata where the benchmark was executed.
final class HostEnvironment {
  final String os;
  final String dartSdkVersion;
  final String platform;

  HostEnvironment({
    required this.os,
    required this.dartSdkVersion,
    required this.platform,
  });

  HostEnvironment.current()
    : os = Platform.operatingSystem,
      dartSdkVersion = Platform.version.split(' ').first,
      platform = const bool.fromEnvironment('dart.vm.product')
          ? 'aot_product'
          : const bool.fromEnvironment('dart.library.js_interop')
          ? 'web'
          : 'vm_jit';

  factory HostEnvironment.fromJson(Map<String, dynamic> json) =>
      HostEnvironment(
        os: json['os'] as String? ?? 'unknown',
        dartSdkVersion: json['dart_sdk_version'] as String? ?? 'unknown',
        platform: json['platform'] as String? ?? 'unknown',
      );

  Map<String, dynamic> toJson() => {
    'os': os,
    'dart_sdk_version': dartSdkVersion,
    'platform': platform,
  };
}

/// Statistical metrics calculated across multiple sample runs.
final class RunMetrics {
  final int samplesCount;
  final double meanUs;
  final double medianUs;
  final double minUs;
  final double maxUs;
  final double stdDevUs;
  final double cv;
  final List<double> confidenceInterval95;
  final double throughputMbS;
  final double throughputMibS;

  RunMetrics({
    required this.samplesCount,
    required this.meanUs,
    required this.medianUs,
    required this.minUs,
    required this.maxUs,
    required this.stdDevUs,
    required this.cv,
    required this.confidenceInterval95,
    required this.throughputMbS,
    required this.throughputMibS,
  });

  factory RunMetrics.fromSamples({
    required List<double> samplesUs,
    required int payloadBytes,
    required int iterationsPerSample,
  }) {
    assert(samplesUs.isNotEmpty, 'samplesUs cannot be empty');
    final sorted = List<double>.from(samplesUs)..sort();
    final count = sorted.length;
    final minUs = sorted.first;
    final maxUs = sorted.last;

    final medianUs = count.isOdd
        ? sorted[count ~/ 2]
        : (sorted[(count ~/ 2) - 1] + sorted[count ~/ 2]) / 2.0;

    final sum = sorted.reduce((a, b) => a + b);
    final meanUs = sum / count;

    var varianceSum = 0.0;
    for (final x in sorted) {
      final diff = x - meanUs;
      varianceSum += diff * diff;
    }
    final stdDevUs = count > 1 ? math.sqrt(varianceSum / (count - 1)) : 0.0;
    final cv = meanUs > 0 ? (stdDevUs / meanUs) : 0.0;

    // 95% Confidence Interval = mean +- 1.96 * (stdDev / sqrt(N))
    final margin = count > 1 ? (1.96 * (stdDevUs / math.sqrt(count))) : 0.0;
    final ci95 = [meanUs - margin, meanUs + margin];

    // Throughput (MB/s = 10^6 bytes/s, MiB/s = 2^20 bytes/s)
    // medianUs is time per single iteration
    final throughputMbS = medianUs > 0
        ? (payloadBytes / medianUs) // bytes / microseconds == MB/s
        : 0.0;
    final throughputMibS = throughputMbS / 1.048576;

    return RunMetrics(
      samplesCount: count,
      meanUs: double.parse(meanUs.toStringAsFixed(2)),
      medianUs: double.parse(medianUs.toStringAsFixed(2)),
      minUs: double.parse(minUs.toStringAsFixed(2)),
      maxUs: double.parse(maxUs.toStringAsFixed(2)),
      stdDevUs: double.parse(stdDevUs.toStringAsFixed(2)),
      cv: double.parse(cv.toStringAsFixed(4)),
      confidenceInterval95: [
        double.parse(ci95[0].toStringAsFixed(2)),
        double.parse(ci95[1].toStringAsFixed(2)),
      ],
      throughputMbS: double.parse(throughputMbS.toStringAsFixed(2)),
      throughputMibS: double.parse(throughputMibS.toStringAsFixed(2)),
    );
  }

  factory RunMetrics.fromJson(Map<String, dynamic> json) => RunMetrics(
    samplesCount: json['samples_count'] as int,
    meanUs: (json['mean_us'] as num).toDouble(),
    medianUs: (json['median_us'] as num).toDouble(),
    minUs: (json['min_us'] as num).toDouble(),
    maxUs: (json['max_us'] as num).toDouble(),
    stdDevUs: (json['std_dev_us'] as num).toDouble(),
    cv: (json['cv'] as num).toDouble(),
    confidenceInterval95: (json['confidence_interval_95'] as List<dynamic>)
        .map((e) => (e as num).toDouble())
        .toList(),
    throughputMbS: (json['throughput_mb_s'] as num).toDouble(),
    throughputMibS: (json['throughput_mib_s'] as num).toDouble(),
  );

  Map<String, dynamic> toJson() => {
    'samples_count': samplesCount,
    'mean_us': meanUs,
    'median_us': medianUs,
    'min_us': minUs,
    'max_us': maxUs,
    'std_dev_us': stdDevUs,
    'cv': cv,
    'confidence_interval_95': confidenceInterval95,
    'throughput_mb_s': throughputMbS,
    'throughput_mib_s': throughputMibS,
  };
}

/// A complete benchmark result record.
final class BenchmarkResult {
  final String name;
  final String category;
  final int payloadBytes;
  final DateTime timestamp;
  final HostEnvironment environment;
  final RunMetrics metrics;
  final List<double> rawSamplesUs;

  BenchmarkResult({
    required this.name,
    required this.category,
    required this.payloadBytes,
    required this.timestamp,
    required this.environment,
    required this.metrics,
    required this.rawSamplesUs,
  });

  factory BenchmarkResult.fromJson(Map<String, dynamic> json) =>
      BenchmarkResult(
        name: json['name'] as String,
        category: json['category'] as String? ?? 'General',
        payloadBytes: json['payload_bytes'] as int? ?? 0,
        timestamp: DateTime.parse(json['timestamp'] as String),
        environment: HostEnvironment.fromJson(
          json['environment'] as Map<String, dynamic>,
        ),
        metrics: RunMetrics.fromJson(json['metrics'] as Map<String, dynamic>),
        rawSamplesUs: (json['raw_samples_us'] as List<dynamic>)
            .map((e) => (e as num).toDouble())
            .toList(),
      );

  Map<String, dynamic> toJson() => {
    'name': name,
    'category': category,
    'payload_bytes': payloadBytes,
    'timestamp': timestamp.toIso8601String(),
    'environment': environment.toJson(),
    'metrics': metrics.toJson(),
    'raw_samples_us': rawSamplesUs,
  };
}

/// A collection of benchmark results representing a complete suite execution.
final class BenchmarkSuiteReport {
  final String suiteName;
  final DateTime timestamp;
  final HostEnvironment environment;
  final List<BenchmarkResult> results;

  BenchmarkSuiteReport({
    required this.suiteName,
    required this.timestamp,
    required this.environment,
    required this.results,
  });

  factory BenchmarkSuiteReport.fromJson(Map<String, dynamic> json) =>
      BenchmarkSuiteReport(
        suiteName: json['suite_name'] as String,
        timestamp: DateTime.parse(json['timestamp'] as String),
        environment: HostEnvironment.fromJson(
          json['environment'] as Map<String, dynamic>,
        ),
        results: (json['results'] as List<dynamic>)
            .map((e) => BenchmarkResult.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
    'suite_name': suiteName,
    'timestamp': timestamp.toIso8601String(),
    'environment': environment.toJson(),
    'results': results.map((r) => r.toJson()).toList(),
  };
}
