// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:md_live/md_live.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

import '../tool/generate_report.dart';

void main() {
  test('md_live', () async {
    final uri = Isolate.resolvePackageUriSync(
      Uri.parse('package:codable_benchmarks/src/data/embedded_datasets.dart'),
    );
    final pkgDir = p.normalize(
      File.fromUri(uri!).parent.parent.parent.parent.path,
    );
    final jsonRoot = jsonDecode(
      File(p.join(pkgDir, 'benchmark_results.json')).readAsStringSync(),
    ) as Map<String, dynamic>;
    final benchmarksList = jsonRoot['benchmarks'] as List<dynamic>;
    final unifiedFile = File(p.join(pkgDir, 'benchmark_results_unified.json'));
    final monoResults = extractUnifiedResults(
      benchmarksList,
      metric: 'median',
      existingUnifiedFile: unifiedFile.existsSync() ? unifiedFile : null,
    );
    final streamResults = extractUnifiedResults(
      benchmarksList,
      metric: 'median',
    );
    final mono = buildReportMdLiveProjection(
      monoResults,
      jsonRoot,
      'median',
      benchmarksList: benchmarksList,
    );
    final stream = buildReportMdLiveProjection(
      streamResults,
      jsonRoot,
      'median',
      benchmarksList: benchmarksList,
      streaming: true,
    );
    await expectMdLiveClean(
      directoryPath: pkgDir,
      customTableRows: {...mono.customTableRows, ...stream.customTableRows},
      inlineValues: {...mono.inlineValues, ...stream.inlineValues},
    );
  });
}
