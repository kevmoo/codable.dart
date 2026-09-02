// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:test/test.dart';

import '../tool/profiler/hotspot_analyzer.dart';
import '../tool/profiler/profile_model.dart';

void main() {
  group('HotspotAnalyzer', () {
    test('attributes samples to meaningful callers and skips internals', () {
      // Tree structure:
      // Node 1: (root) [internal]
      //   Node 2: runBenchmark [meaningful]
      //     Node 3: JsonCodableDecoder.decode [meaningful]
      //       Node 4: _advanceProperty [meaningful]
      //         Node 5: glue.mjs [internal JS glue]
      final profile = CpuProfile(
        nodes: [
          CpuProfileNode(
            id: 1,
            callFrame: CallFrame(functionName: '(root)', url: ''),
            children: [2],
          ),
          CpuProfileNode(
            id: 2,
            callFrame: CallFrame(
              functionName: 'runBenchmark',
              url: 'package:codable_benchmarks/harness.dart',
              lineNumber: 50,
            ),
            children: [3],
          ),
          CpuProfileNode(
            id: 3,
            callFrame: CallFrame(
              functionName: 'JsonCodableDecoder.decode',
              url: 'package:codable/codable_json.dart',
              lineNumber: 100,
            ),
            children: [4],
          ),
          CpuProfileNode(
            id: 4,
            callFrame: CallFrame(
              functionName: '_advanceProperty',
              url: 'package:codable/src/json/driver_js.dart',
              lineNumber: 220,
            ),
            children: [5],
          ),
          CpuProfileNode(
            id: 5,
            callFrame: CallFrame(
              functionName: 'js_getProperty',
              url: 'http://127.0.0.1:8080/benchmark.mjs',
            ),
            children: [],
          ),
        ],
        // 6 samples on node 5 (attributes to node 4: _advanceProperty)
        // 4 samples directly on node 3 (JsonCodableDecoder.decode)
        samples: [5, 5, 5, 5, 5, 5, 3, 3, 3, 3],
      );

      final hotspots = HotspotAnalyzer.analyze(profile, topN: 5);

      expect(hotspots.length, 2);
      expect(hotspots[0].name, '_advanceProperty');
      expect(hotspots[0].samples, 6);
      expect(hotspots[0].percent, 60.0);
      expect(hotspots[0].lineNumber, 220);
      expect(
        hotspots[0].location,
        'package:codable/src/json/driver_js.dart:220',
      );

      expect(hotspots[1].name, 'JsonCodableDecoder.decode');
      expect(hotspots[1].samples, 4);
      expect(hotspots[1].percent, 40.0);
      expect(hotspots[1].lineNumber, 100);
    });

    test(
      'disambiguates functions with the same name across different files',
      () {
        final profile = CpuProfile(
          nodes: [
            CpuProfileNode(
              id: 1,
              callFrame: CallFrame(
                functionName: 'encode',
                url: 'package:codable/src/driver.dart',
                lineNumber: 50,
              ),
              children: [],
            ),
            CpuProfileNode(
              id: 2,
              callFrame: CallFrame(
                functionName: 'encode',
                url: 'package:codable_benchmarks/src/models.dart',
                lineNumber: 120,
              ),
              children: [],
            ),
          ],
          samples: [1, 1, 1, 2, 2],
        );

        final hotspots = HotspotAnalyzer.analyze(profile, topN: 5);

        expect(hotspots.length, 2);
        expect(hotspots[0].name, 'encode');
        expect(hotspots[0].url, 'package:codable/src/driver.dart');
        expect(hotspots[0].lineNumber, 50);
        expect(hotspots[0].samples, 3);
        expect(hotspots[0].percent, 60.0);

        expect(hotspots[1].name, 'encode');
        expect(hotspots[1].url, 'package:codable_benchmarks/src/models.dart');
        expect(hotspots[1].lineNumber, 120);
        expect(hotspots[1].samples, 2);
        expect(hotspots[1].percent, 40.0);
      },
    );

    test(
      'collapses raw wasm function trampolines to symbolicated Dart caller',
      () {
        // Dart caller (node 1) -> wasm trampoline (node 2) -> JS glue (node 3)
        final profile = CpuProfile(
          nodes: [
            CpuProfileNode(
              id: 1,
              callFrame: CallFrame(
                functionName: 'fromBytes',
                url: 'package:codable/src/driver.dart',
                lineNumber: 42,
              ),
              children: [2],
            ),
            CpuProfileNode(
              id: 2,
              callFrame: CallFrame(
                functionName: 'wasm-function[105]',
                url: 'http://127.0.0.1:8080/benchmark.wasm',
              ),
              children: [3],
            ),
            CpuProfileNode(
              id: 3,
              callFrame: CallFrame(
                functionName: 'js_getProperty',
                url: 'http://127.0.0.1:8080/benchmark.mjs',
              ),
              children: [],
            ),
          ],
          samples: [3, 2, 1],
        );

        final hotspots = HotspotAnalyzer.analyze(profile, topN: 5);

        expect(hotspots.length, 1);
        expect(hotspots[0].name, 'fromBytes');
        expect(hotspots[0].samples, 3);
        expect(hotspots[0].percent, 100.0);
      },
    );

    test(
      'excludes pure engine frames like (program) and (garbage collector)',
      () {
        final profile = CpuProfile(
          nodes: [
            CpuProfileNode(
              id: 1,
              callFrame: CallFrame(functionName: '(root)', url: ''),
              children: [2, 3, 4],
            ),
            CpuProfileNode(
              id: 2,
              callFrame: CallFrame(
                functionName: '(garbage collector)',
                url: '',
              ),
              children: [],
            ),
            CpuProfileNode(
              id: 3,
              callFrame: CallFrame(functionName: '(program)', url: ''),
              children: [],
            ),
            CpuProfileNode(
              id: 4,
              callFrame: CallFrame(
                functionName: 'realDartFunc',
                url: 'package:codable/codable.dart',
                lineNumber: 10,
              ),
              children: [],
            ),
          ],
          // 2 GC samples, 2 program samples, 1 real Dart sample
          samples: [2, 2, 3, 3, 4],
        );

        final hotspots = HotspotAnalyzer.analyze(profile, topN: 5);

        expect(hotspots.length, 1);
        expect(hotspots[0].name, 'realDartFunc');
        expect(hotspots[0].samples, 1);
        expect(hotspots[0].percent, 20.0); // 1 out of 5 total samples
      },
    );

    test(
      'falls back to raw wasm function when no symbolicated caller exists',
      () {
        final profile = CpuProfile(
          nodes: [
            CpuProfileNode(
              id: 1,
              callFrame: CallFrame(
                functionName: 'wasm-function[42]',
                url: 'http://127.0.0.1:8080/benchmark.wasm',
              ),
              children: [],
            ),
          ],
          samples: [1, 1],
        );

        final hotspots = HotspotAnalyzer.analyze(profile, topN: 5);

        expect(hotspots.length, 1);
        expect(hotspots[0].name, 'wasm-function[42]');
        expect(hotspots[0].samples, 2);
      },
    );

    test('formatMarkdownTable formats clean markdown', () {
      final hotspots = [
        HotFunction(
          rank: 1,
          name: '_advanceProperty',
          url: 'package:codable/src/json/driver_js.dart',
          samples: 60,
          percent: 60.0,
          lineNumber: 220,
        ),
      ];

      final table = HotspotAnalyzer.formatMarkdownTable(
        hotspots,
        totalSamples: 100,
      );
      expect(
        table,
        contains('| Rank | Function | Location | Samples | % CPU |'),
      );
      expect(
        table,
        contains(
          '| 1 | `_advanceProperty` | `package:codable/src/json/driver_js.dart:220` | 60 | 60.0% |',
        ),
      );
    });
  });
}
