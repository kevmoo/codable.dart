// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:build_verify/build_verify.dart';
import 'package:test/test.dart';

void main() {
  test(
    'ensure_build',
    () => expectBuildClean(
      packageRelativeDirectory: 'pkgs/codable',
      gitDiffPathArguments: [
        ':!pkgs/codable/lib/src/json/substrate/substrate.dart',
        ':!pubspec.lock',
      ],
    ),
    timeout: const Timeout.factor(3),
  );
}
