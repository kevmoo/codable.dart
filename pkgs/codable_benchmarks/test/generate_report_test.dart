// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:checks/checks.dart';
import 'package:path/path.dart' as p;
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

  group('collectSdkMismatchProblems', () {
    const versionA =
        '3.14.0-json-next.c52b7fec (main) (Mon Sep 21 10:53:03 2026 -0700) '
        'on "linux_x64"';
    const versionB =
        '3.14.0-json-next.8045fcd2 (main) (Sat Sep 12 19:08:49 2026 -0700) '
        'on "linux_x64"';
    const stockVersion =
        '3.14.0-248.0.dev (dev) (Sat Sep 19 01:09:06 2026 -0700) '
        'on "linux_x64"';

    test(
      'passes when declared SDKs match stamped versions without build cache',
      () {
        final problems = collectSdkMismatchProblems(
          {
            'environment': {
              'dart_version': versionA,
              'stock_dart_version': stockVersion,
            },
          },
          expectSdk: '/sdk/native',
          expectStockSdk: '/sdk/stock/bin/dart',
          buildDir: Directory(
            p.join(Directory.systemTemp.path, 'nonexistent_bench_press_build'),
          ),
          probeVersion: (exe) => switch (exe) {
            '/sdk/native/bin/dart' => versionA,
            '/sdk/stock/bin/dart' => stockVersion,
            _ => null,
          },
        );
        check(problems).isEmpty();
      },
    );

    test(
      'fails when declared native SDK disagrees even if build cache is absent',
      () {
        final problems = collectSdkMismatchProblems(
          {
            'environment': {'dart_version': versionA},
          },
          expectSdk: '/sdk/native-b',
          buildDir: Directory(
            p.join(Directory.systemTemp.path, 'nonexistent_bench_press_build'),
          ),
          probeVersion: (exe) =>
              exe == '/sdk/native-b/bin/dart' ? versionB : null,
        );
        check(problems).length.equals(1);
        check(problems.single)
          ..contains('native SDK:')
          ..contains('declared by caller: $versionB (/sdk/native-b)')
          ..contains('stamped in results: $versionA');
      },
    );

    test('rejects same-commit rebuild with different timestamp and prefix '
        'false-positives', () {
      const rebuiltSameCommit =
          '3.14.0-json-next.c52b7fec (main) '
          '(Mon Sep 21 14:20:11 2026 -0700) on "linux_x64"';
      final rebuildProblems = collectSdkMismatchProblems(
        {
          'environment': {'dart_version': versionA},
        },
        expectSdk: '/sdk/native',
        buildDir: Directory(
          p.join(Directory.systemTemp.path, 'nonexistent_bench_press_build'),
        ),
        probeVersion: (_) => rebuiltSameCommit,
      );
      check(rebuildProblems).length.equals(1);

      final prefixProblems = collectSdkMismatchProblems(
        {
          'environment': {
            'dart_version':
                '3.14.0-edge.8045fcd2 (main) '
                '(Sat Sep 12 19:08:49 2026 -0700)',
          },
        },
        expectSdk: '/sdk/native',
        buildDir: Directory(
          p.join(Directory.systemTemp.path, 'nonexistent_bench_press_build'),
        ),
        probeVersion: (_) => '3.14.0-edge',
      );
      check(prefixProblems).length.equals(1);
    });

    test('distinguishes unrunnable SDK and missing stamp', () {
      final problems = collectSdkMismatchProblems(
        {'environment': <String, Object?>{}},
        expectSdk: '/sdk/missing',
        expectStockSdk: '/sdk/stock',
        buildDir: Directory(
          p.join(Directory.systemTemp.path, 'nonexistent_bench_press_build'),
        ),
        probeVersion: (exe) =>
            exe == '/sdk/stock/bin/dart' ? stockVersion : null,
      );
      check(problems).length.equals(2);
      check(problems[0]).contains(
        'native SDK: could not run the declared SDK to determine its version: '
        '/sdk/missing',
      );
      check(problems[1]).contains(
        'stock SDK: results carry no version stamp to compare against '
        '$stockVersion',
      );
    });

    test('secondary cache_key scan detects stale compiled artifact', () {
      final tempDir = Directory.systemTemp.createTempSync(
        'codable_report_test_',
      );
      try {
        final fakeDart = File(p.join(tempDir.path, 'fake_dart'))
          ..writeAsStringSync('');
        File(p.join(tempDir.path, 'target.cache_key'))
            .writeAsStringSync('dartExe: ${fakeDart.path}\n');
        final problems = collectSdkMismatchProblems(
          {
            'environment': {'dart_version': versionA},
          },
          buildDir: tempDir,
          probeVersion: (exe) => exe == fakeDart.path ? versionB : null,
        );
        check(problems).length.equals(1);
        check(problems.single)
          ..contains('compiled artifact:')
          ..contains('built against:      $versionB (${fakeDart.path})')
          ..contains('stamped in results: $versionA');
      } finally {
        tempDir.deleteSync(recursive: true);
      }
    });

    test(
      'passes standalone when neither flags nor build cache are present',
      () {
        final problems = collectSdkMismatchProblems(
          {
            'environment': {'dart_version': versionA},
          },
          buildDir: Directory(
            p.join(Directory.systemTemp.path, 'nonexistent_bench_press_build'),
          ),
        );
        check(problems).isEmpty();
      },
    );
  });
}
