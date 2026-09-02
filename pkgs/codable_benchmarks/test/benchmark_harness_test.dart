// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:test/test.dart';

import '../tool/profiler/benchmark_harness.dart';

void main() {
  group('benchmark_harness', () {
    final decodeBenchmarks = [
      'twitter_decode',
      'citm_catalog_decode',
      'canada_decode',
      'coordinates_decode',
      'small_decode',
    ];

    final encodeBenchmarks = [
      'twitter_encode',
      'citm_catalog_encode',
      'canada_encode',
      'coordinates_encode',
      'small_encode',
    ];

    group('decode benchmarks', () {
      for (final b in decodeBenchmarks) {
        test('$b runs codable implementation', () {
          expect(
            () => runBenchmark(
              b,
              iterations: 1,
              impl: 'codable',
              warmupIterations: 0,
            ),
            returnsNormally,
          );
        });

        test('$b runs codable_reader implementation', () {
          expect(
            () => runBenchmark(
              b,
              iterations: 1,
              impl: 'codable_reader',
              warmupIterations: 0,
            ),
            returnsNormally,
          );
        });

        test('$b runs json_serializable implementation', () {
          expect(
            () => runBenchmark(
              b,
              iterations: 1,
              impl: 'json_serializable',
              warmupIterations: 0,
            ),
            returnsNormally,
          );
        });
      }
    });

    group('encode benchmarks', () {
      for (final b in encodeBenchmarks) {
        test('$b runs codable implementation', () {
          expect(
            () => runBenchmark(
              b,
              iterations: 1,
              impl: 'codable',
              warmupIterations: 0,
            ),
            returnsNormally,
          );
        });

        test('$b runs json_serializable implementation', () {
          expect(
            () => runBenchmark(
              b,
              iterations: 1,
              impl: 'json_serializable',
              warmupIterations: 0,
            ),
            returnsNormally,
          );
        });
      }
    });

    test('defaultIterationsFor returns calibrated counts', () {
      expect(defaultIterationsFor('small_decode'), 20000);
      expect(defaultIterationsFor('twitter_decode'), 500);
      expect(defaultIterationsFor('citm_catalog_decode'), 200);
      expect(defaultIterationsFor('canada_decode'), 100);
      expect(defaultIterationsFor('coordinates_decode'), 300);
    });

    test('supportedBenchmarks contains all 10 core benchmarks', () {
      expect(supportedBenchmarks.length, 10);
      expect(supportedBenchmarks, contains('twitter_decode'));
      expect(supportedBenchmarks, contains('twitter_encode'));
      expect(supportedBenchmarks, contains('citm_catalog_decode'));
      expect(supportedBenchmarks, contains('citm_catalog_encode'));
      expect(supportedBenchmarks, contains('canada_decode'));
      expect(supportedBenchmarks, contains('canada_encode'));
      expect(supportedBenchmarks, contains('coordinates_decode'));
      expect(supportedBenchmarks, contains('coordinates_encode'));
      expect(supportedBenchmarks, contains('small_decode'));
      expect(supportedBenchmarks, contains('small_encode'));
    });

    test('resolves convenient benchmark aliases without throwing', () {
      expect(() => resolveBenchmarkAction('citm_encode'), returnsNormally);
      expect(() => resolveBenchmarkAction('coord_decode'), returnsNormally);
      expect(() => resolveBenchmarkAction('coord_encode'), returnsNormally);
      expect(() => resolveBenchmarkAction('citm_decode'), returnsNormally);
    });

    test('throws on unknown benchmark', () {
      expect(
        () => resolveBenchmarkAction('unknown_benchmark'),
        throwsArgumentError,
      );
    });
  });
}
