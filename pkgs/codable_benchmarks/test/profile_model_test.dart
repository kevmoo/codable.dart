// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:test/test.dart';

import '../tool/profiler/profile_model.dart';

void main() {
  group('CallFrame', () {
    test('parses wasm-function index from functionName', () {
      final frame = CallFrame.fromJson({
        'functionName': 'wasm-function[42]',
        'url': 'http://127.0.0.1/benchmark.wasm',
        'lineNumber': 1,
        'columnNumber': 1234,
      });

      expect(frame.functionName, 'wasm-function[42]');
      expect(frame.url, 'http://127.0.0.1/benchmark.wasm');
      expect(frame.wasmFunctionIndex, 42);
      expect(frame.lineNumber, 1);
      expect(frame.columnNumber, 1234);
    });

    test('preserves explicit wasmFunctionIndex if provided', () {
      final frame = CallFrame.fromJson({
        'functionName': 'customWasmFunc',
        'url': 'http://127.0.0.1/benchmark.wasm',
        'wasmFunctionIndex': 99,
      });

      expect(frame.wasmFunctionIndex, 99);
    });

    test('round-trips toJson / fromJson', () {
      final original = CallFrame(
        functionName: 'fooBar',
        url: 'package:codable/codable.dart',
        lineNumber: 10,
        columnNumber: 5,
        wasmFunctionIndex: 7,
      );

      final json = original.toJson();
      final parsed = CallFrame.fromJson(json);

      expect(parsed.functionName, original.functionName);
      expect(parsed.url, original.url);
      expect(parsed.lineNumber, original.lineNumber);
      expect(parsed.columnNumber, original.columnNumber);
      expect(parsed.wasmFunctionIndex, original.wasmFunctionIndex);
    });
  });

  group('CpuProfile and CpuProfileNode', () {
    test('parses profile nodes and samples', () {
      final json = {
        'nodes': [
          {
            'id': 1,
            'callFrame': {'functionName': '(root)', 'url': ''},
            'children': [2],
            'hitCount': 0,
          },
          {
            'id': 2,
            'callFrame': {
              'functionName': 'main',
              'url': 'http://127.0.0.1/main.dart.wasm',
              'lineNumber': 1,
              'columnNumber': 500,
            },
            'children': <int>[],
            'hitCount': 3,
          },
        ],
        'samples': [2, 2, 2],
        'timeDeltas': [100, 200, 150],
      };

      final profile = CpuProfile.fromJson(json);
      expect(profile.nodes.length, 2);
      expect(profile.nodes[0].id, 1);
      expect(profile.nodes[0].children, [2]);
      expect(profile.nodes[1].id, 2);
      expect(profile.nodes[1].callFrame.functionName, 'main');
      expect(profile.samples, [2, 2, 2]);
      expect(profile.timeDeltas, [100, 200, 150]);

      final serialized = profile.toJson();
      expect(serialized['samples'], [2, 2, 2]);
    });
  });
}
