// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

@Tags(['native-sdk'])
library;

import 'dart:io';

import 'package:test/test.dart';

/// Guards against the mock substrate drifting from the real `dart:convert`
/// API. Skipped by default; run with `dart test -P native`.
void main() {
  test('package:codable analyzes clean on the native substrate', () {
    final result = Process.runSync(Platform.resolvedExecutable, [
      'run',
      'tool/native_sdk_check.dart',
    ], workingDirectory: _repoRoot());
    if (result.exitCode == 3) {
      markTestSkipped('No private json-utf8 SDK available: ${result.stderr}');
      return;
    }
    expect(
      result.exitCode,
      0,
      reason: 'native_sdk_check failed:\n${result.stdout}\n${result.stderr}',
    );
  }, timeout: const Timeout(Duration(minutes: 5)));
}

/// Walks up from the working directory to the workspace root, wherever the
/// runner was invoked from.
String _repoRoot() {
  var dir = Directory.current;
  while (!File('${dir.path}/tool/native_sdk_check.dart').existsSync()) {
    final parent = dir.parent;
    if (parent.path == dir.path) {
      throw StateError('tool/native_sdk_check.dart not found above $dir');
    }
    dir = parent;
  }
  return dir.path;
}
