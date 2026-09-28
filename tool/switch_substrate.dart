// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

const substrateRelativePath =
    'pkgs/codable/lib/src/json/substrate/substrate.dart';

final _defaultRepoRoot = File(Platform.script.toFilePath()).parent.parent.path;

void main(List<String> args) {
  if (args.isEmpty || (args.first != 'mock' && args.first != 'native')) {
    stderr.writeln('Usage: dart run tool/switch_substrate.dart [mock|native]');
    exit(1);
  }

  final mode = args.first;
  writeSubstrate(mode);
  if (mode == 'mock') {
    stdout.writeln('Switched substrate to: MOCK (pure Dart)');
  } else {
    stdout.writeln('Switched substrate to: NATIVE (dart:convert Layer 1 SDK)');
  }
}

/// Writes the untracked `substrate.dart` dispatcher for [mode] (`mock` or
/// `native`) under [repoRoot] (defaults to the workspace root).
void writeSubstrate(String mode, {String? repoRoot}) {
  final root = repoRoot ?? _defaultRepoRoot;
  final targetFile = File('$root/$substrateRelativePath');
  targetFile.parent.createSync(recursive: true);

  if (mode == 'mock') {
    targetFile.writeAsStringSync('''
// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Active substrate dispatcher (switched to mock mode).
library;

export 'mock/substrate_mock.dart';
''');
  } else if (mode == 'native') {
    targetFile.writeAsStringSync('''
// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Active substrate dispatcher (switched to native mode).
library;

export 'substrate_native.dart';
''');
  } else {
    throw ArgumentError.value(mode, 'mode', 'Expected "mock" or "native".');
  }
}
