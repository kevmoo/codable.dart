// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

@TestOn('vm')
library;

import 'dart:io';

import 'package:build_verify/build_verify.dart';
import 'package:checks/checks.dart';
import 'package:test/test.dart';

void main() {
  test('ensure_build', () {
    final inPackageDir = Directory.current.path.endsWith('pkgs/codable');
    expectBuildClean(
      packageRelativeDirectory: inPackageDir ? 'pkgs/codable' : null,
      gitDiffPathArguments: [':!pubspec.lock'],
    );
  }, timeout: const Timeout.factor(3));

  test('substrate.dart is not tracked by git', () {
    final inPackageDir = Directory.current.path.endsWith('pkgs/codable');
    final targetPath = inPackageDir
        ? 'lib/src/json/substrate/substrate.dart'
        : 'pkgs/codable/lib/src/json/substrate/substrate.dart';
    final result = Process.runSync('git', [
      'ls-files',
      '--error-unmatch',
      targetPath,
    ]);
    check(
      result.exitCode,
      because:
          'substrate.dart must remain untracked (generated via '
          'tool/switch_substrate.dart).',
    ).not((it) => it.equals(0));
  });
}
