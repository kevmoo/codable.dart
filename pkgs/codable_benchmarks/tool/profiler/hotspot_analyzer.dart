// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'profile_model.dart';

class HotFunction {
  final int rank;
  final String name;
  final String url;
  final int samples;
  final double percent;
  final int? lineNumber;
  final int? wasmFunctionIndex;

  HotFunction({
    required this.rank,
    required this.name,
    required this.url,
    required this.samples,
    required this.percent,
    this.lineNumber,
    this.wasmFunctionIndex,
  });

  String get location {
    if (url.isEmpty) return '';
    if (lineNumber != null && lineNumber! > 0) {
      return '$url:$lineNumber';
    }
    return url;
  }
}

class HotspotAnalyzer {
  static List<HotFunction> analyze(CpuProfile profile, {int topN = 10}) {
    final nodeMap = <int, CpuProfileNode>{};
    final parentMap = <int, int>{};

    for (final node in profile.nodes) {
      nodeMap[node.id] = node;
      for (final childId in node.children) {
        parentMap[childId] = node.id;
      }
    }

    final exclusiveCounts = <String, int>{};
    final functionNames = <String, String>{};
    final functionUrls = <String, String>{};
    final functionLines = <String, Map<int, int>>{};
    final wasmIndices = <String, int?>{};

    bool isInternalOrInterop(CpuProfileNode node) {
      final frame = node.callFrame;
      final url = frame.url;
      final name = frame.functionName;

      // 1. Root/idle/program/GC engine frames or empty URL
      if (url.isEmpty ||
          name == '(root)' ||
          name == '(program)' ||
          name == '(idle)' ||
          name == '(garbage collector)') {
        return true;
      }

      // 2. JS glue and loader files
      if (url.endsWith('.mjs') || url.endsWith('.js')) {
        return true;
      }

      // 3. Dart SDK internal infrastructure frames
      if (url.startsWith('dart:developer') ||
          url.startsWith('dart:_internal') ||
          url.startsWith('dart:_wasm')) {
        return true;
      }

      return false;
    }

    for (final leafNodeId in profile.samples) {
      int? currentId = leafNodeId;
      CpuProfileNode? meaningfulNode;
      CpuProfileNode? rawWasmNode;

      while (currentId != null) {
        final node = nodeMap[currentId];
        if (node == null) break;

        if (!isInternalOrInterop(node)) {
          final frame = node.callFrame;
          if (frame.functionName.startsWith('wasm-function[')) {
            // Keep the first unmapped wasm node as a fallback if no
            // symbolicated Dart caller is above it on the stack.
            rawWasmNode ??= node;
          } else if (frame.functionName.isNotEmpty) {
            meaningfulNode = node;
            break;
          }
        }
        currentId = parentMap[currentId];
      }

      // If no symbolicated Dart caller was found, fall back to the unmapped
      // wasm node.
      meaningfulNode ??= rawWasmNode;

      // Skip pure engine/idle/GC samples that have no Dart or wasm caller
      if (meaningfulNode == null) continue;

      final frame = meaningfulNode.callFrame;
      var name = frame.functionName;
      if (name.isEmpty) {
        name = frame.url.isNotEmpty ? frame.url : 'unknown';
      }
      final url = frame.url;
      final key = url.isNotEmpty ? '$url::$name' : name;

      exclusiveCounts[key] = (exclusiveCounts[key] ?? 0) + 1;
      functionNames.putIfAbsent(key, () => name);
      functionUrls.putIfAbsent(key, () => url);
      if (frame.wasmFunctionIndex != null) {
        wasmIndices.putIfAbsent(key, () => frame.wasmFunctionIndex);
      }

      final line = frame.lineNumber;
      if (line != null && line > 0) {
        final lineMap = functionLines.putIfAbsent(key, () => <int, int>{});
        lineMap[line] = (lineMap[line] ?? 0) + 1;
      }
    }

    final totalSamples = profile.samples.length;
    final sorted = exclusiveCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final results = <HotFunction>[];
    for (var i = 0; i < topN && i < sorted.length; i++) {
      final entry = sorted[i];
      final key = entry.key;
      final count = entry.value;
      final percent = totalSamples > 0 ? (count / totalSamples) * 100 : 0.0;

      int? hottestLine;
      final lineMap = functionLines[key];
      if (lineMap != null && lineMap.isNotEmpty) {
        hottestLine = lineMap.entries
            .reduce((a, b) => a.value > b.value ? a : b)
            .key;
      }

      results.add(
        HotFunction(
          rank: i + 1,
          name: functionNames[key] ?? key,
          url: functionUrls[key] ?? '',
          samples: count,
          percent: percent,
          lineNumber: hottestLine,
          wasmFunctionIndex: wasmIndices[key],
        ),
      );
    }

    return results;
  }

  static String formatMarkdownTable(
    List<HotFunction> hotFunctions, {
    int totalSamples = 0,
  }) {
    final buffer = StringBuffer();
    buffer.writeln('<!-- mdformat off(prevent table wrapping) -->');
    buffer.writeln('| Rank | Function | Location | Samples | % CPU |');
    buffer.writeln('| :---: | :--- | :--- | :---: | :---: |');
    for (final h in hotFunctions) {
      final loc = h.location.isNotEmpty ? '`${h.location}`' : '-';
      final pct = h.percent.toStringAsFixed(1);
      buffer.writeln(
        '| ${h.rank} | `${h.name}` | $loc | ${h.samples} | $pct% |',
      );
    }
    buffer.writeln('<!-- mdformat on -->');
    return buffer.toString();
  }
}
