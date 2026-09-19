// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:checks/checks.dart';
import 'package:test/test.dart';

import '../tool/generate_report.dart';

void main() {
  group('extractUnifiedResults & generateMarkdownReport', () {
    test(
      'separates stock and native_kernels tiers and renders 4-tier report',
      () {
        final benchmarks = <Map<String, Object?>>[];
        for (final target in canonicalTargets) {
          for (final ds in canonicalDatasets) {
            for (final mode in ['decode', 'encode']) {
              final group = '${ds}_$mode';
              benchmarks.addAll([
                {
                  'name': 'json_serializable',
                  'target': target,
                  'coordinates': {
                    'group': group,
                    'sdk': 'stock',
                    'runtime': target,
                  },
                  'metrics': {'min_ns': 4000000.0, 'median_ns': 4200000.0},
                  'raw_trials_ns': List.filled(15, 4000000.0),
                },
                {
                  'name': 'codable',
                  'target': target,
                  'coordinates': {
                    'group': group,
                    'sdk': 'stock',
                    'runtime': target,
                  },
                  'metrics': {'min_ns': 2500000.0, 'median_ns': 2600000.0},
                  'raw_trials_ns': List.filled(15, 2500000.0),
                },
                {
                  'name': 'json_serializable',
                  'target': target,
                  'coordinates': {
                    'group': group,
                    'sdk': 'native_kernels',
                    'runtime': target,
                  },
                  'metrics': {'min_ns': 3200000.0, 'median_ns': 3300000.0},
                  'raw_trials_ns': List.filled(15, 3200000.0),
                },
                {
                  'name': 'codable',
                  'target': target,
                  'coordinates': {
                    'group': group,
                    'sdk': 'native_kernels',
                    'runtime': target,
                  },
                  'metrics': {'min_ns': 2000000.0, 'median_ns': 2100000.0},
                  'raw_trials_ns': List.filled(15, 2000000.0),
                },
              ]);
            }
          }
        }

        final unified = extractUnifiedResults(benchmarks, metric: 'min');
        final aotCoord = unified['aot']!['coordinates_decode']!;
        check(aotCoord['stock_json_serializable']).equals(4000.0);
        check(aotCoord['stock_codable']).equals(2500.0);
        check(aotCoord['json_serializable']).equals(3200.0);
        check(aotCoord['codable']).equals(2000.0);

        final jsonRoot = {
          'timestamp': '2026-09-18T20:30:00Z',
          'environment': {
            'dart_version': '3.14.0-edge (native_kernels)',
            'stock_dart_version': '3.14.0-241.0.dev (stock)',
            'commit': 'c1c5507',
            'os': 'linux',
            'host': 'kevmoo.c.googlers.com',
          },
          'benchmarks': benchmarks,
        };

        final report = generateMarkdownReport(unified, jsonRoot, 'min');
        check(report).contains('The 4 Dart Serialization Tiers');
        check(report).contains('Stock Dart SDK (Tier 0 & Tier 2)');
        check(report).contains('Speedup vs Tier 0 (Stock json_serial)');
        check(report).contains('Speedup vs Tier 1 (New json_serial)');
        // 4000 / 3200 = 1.25x (Tier 1 vs Tier 0)
        // 4000 / 2500 = 1.60x (Tier 2 vs Tier 0)
        // 4000 / 2000 = 2.00x (Tier 3 vs Tier 0)
        // 3200 / 2000 = 1.60x (Tier 3 vs Tier 1)
        check(report).contains('**1.25x**');
        check(report).contains('**1.60x**');
        check(report).contains('**2.00x**');
      },
    );

    test('renders streaming 4-tier report and streaming vs monolithic '
        'overhead table', () {
      final benchmarks = <Map<String, Object?>>[];
      for (final target in canonicalTargets) {
        for (final ds in ['coordinates', 'canada']) {
          for (final mode in [
            'decode',
            'encode',
            'decode_stream',
            'encode_stream',
          ]) {
            final group = '${ds}_$mode';
            final isStream = mode.endsWith('_stream');
            final scale = isStream ? 1.1 : 1.0;
            benchmarks.addAll([
              {
                'name': 'json_serializable',
                'target': target,
                'coordinates': {
                  'group': group,
                  'sdk': 'stock',
                  'runtime': target,
                },
                'metrics': {
                  'min_ns': 4000000.0 * scale,
                  'median_ns': 4200000.0 * scale,
                },
                'raw_trials_ns': List.filled(15, 4200000.0 * scale),
              },
              {
                'name': 'codable',
                'target': target,
                'coordinates': {
                  'group': group,
                  'sdk': 'stock',
                  'runtime': target,
                },
                'metrics': {
                  'min_ns': 2500000.0 * scale,
                  'median_ns': 2600000.0 * scale,
                },
                'raw_trials_ns': List.filled(15, 2600000.0 * scale),
              },
              {
                'name': 'json_serializable',
                'target': target,
                'coordinates': {
                  'group': group,
                  'sdk': 'native_kernels',
                  'runtime': target,
                },
                'metrics': {
                  'min_ns': 3200000.0 * scale,
                  'median_ns': 3300000.0 * scale,
                },
                'raw_trials_ns': List.filled(15, 3300000.0 * scale),
              },
              {
                'name': 'codable',
                'target': target,
                'coordinates': {
                  'group': group,
                  'sdk': 'native_kernels',
                  'runtime': target,
                },
                'metrics': {
                  'min_ns': 2000000.0 * scale,
                  'median_ns': 2100000.0 * scale,
                },
                'raw_trials_ns': List.filled(15, 2100000.0 * scale),
              },
            ]);
          }
        }
      }

      final unified = extractUnifiedResults(benchmarks, metric: 'median');
      final jsonRoot = {
        'timestamp': '2026-09-19T19:30:00Z',
        'environment': {
          'dart_version': '3.14.0-edge (native_kernels)',
          'stock_dart_version': '3.14.0-241.0.dev (stock)',
          'commit': 'c1c5507',
          'os': 'linux',
          'host': 'kevmoo.c.googlers.com',
        },
        'benchmarks': benchmarks,
      };

      final streamReport = generateMarkdownReport(
        unified,
        jsonRoot,
        'median',
        benchmarksList: benchmarks,
        streaming: true,
      );
      check(streamReport).contains('Streaming Benchmark Report');
      check(streamReport).contains('Decode Stream (32 KB Chunks)');
      check(streamReport)
          .contains('Encode Stream (BytesBuilder / ByteConversionSink)');
      check(streamReport)
          .contains('Streaming vs. Monolithic Single-Buffer Overhead');
      check(streamReport).contains('`1.10x`');
    });
  });
}
