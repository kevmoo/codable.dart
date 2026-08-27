// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Verifies that `package:codable` still compiles against the *native*
/// substrate, i.e. the real `dart:convert` `JsonTokenReader`/`JsonTokenWriter`
/// API shipped by the private `json-utf8` Dart SDK build.
///
/// CI only exercises the mock substrate, so API drift between the mock and
/// the SDK (see #20) is invisible there. Run this before opening a PR that
/// touches `pkgs/codable/lib`:
///
///     dart run tool/native_sdk_check.dart
///     dart test pkgs/codable -P native   # same check, as a tagged test
///
/// SDK discovery, in order:
///   1. `$CODABLE_NATIVE_SDK` (path to an SDK root or its `bin/dart`).
///   2. `~/.local/share/dart-sdk-json-utf8-kernels/dart-sdk`
///   3. `~/github/dart-sdk/core/agent-json-squash/sdk/out/ReleaseX64/dart-sdk`
///
/// Exit codes: 0 = pass, 1 = analysis failed, [skippedExitCode] = no private
/// SDK found (only when `CODABLE_NATIVE_SDK` is unset).
library;

import 'dart:io';

const skippedExitCode = 3;

const _sentinelLibrary = 'lib/convert/json_utf8.dart';

final _repoRoot = File(Platform.script.toFilePath()).parent.parent.path;

void main() async {
  final dart = _findNativeDart();
  if (dart == null) {
    stderr.writeln(
      'SKIP: no private json-utf8 Dart SDK found. '
      'Set CODABLE_NATIVE_SDK to an SDK root to run this check.',
    );
    exit(skippedExitCode);
  }
  stdout.writeln('Using native SDK: $dart');

  final substrate = File(
    '$_repoRoot/pkgs/codable/lib/src/json/substrate/substrate.dart',
  );
  final original = substrate.readAsStringSync();
  var failed = false;
  try {
    _run('dart', ['run', 'tool/switch_substrate.dart', 'native']);
    _run(dart, ['pub', 'get']);
    // Infos are not fatal here: a few lints (e.g. `unnecessary_import` of
    // the substrate file) only fire in native mode and are correct for mock.
    failed = !_run(dart, [
      'analyze',
      'pkgs/codable/lib',
      'pkgs/codable_benchmarks',
    ]);
  } finally {
    substrate.writeAsStringSync(original);
    _run('dart', ['pub', 'get']);
  }
  if (failed) {
    stderr.writeln(
      'FAIL: package:codable does not compile against the native substrate. '
      'Keep pkgs/codable/lib/src/json/substrate/mock/ in sync with dart:convert.',
    );
    exit(1);
  }
  stdout.writeln('PASS: native substrate analyzes clean.');
}

String? _findNativeDart() {
  final explicit = Platform.environment['CODABLE_NATIVE_SDK'];
  if (explicit != null && explicit.isNotEmpty) {
    final dart = _dartIn(explicit);
    if (dart == null) {
      stderr.writeln(
        'CODABLE_NATIVE_SDK=$explicit is not a json-utf8 SDK '
        '(missing $_sentinelLibrary).',
      );
      exit(1);
    }
    return dart;
  }
  final home = Platform.environment['HOME'] ?? '';
  for (final candidate in [
    '$home/.local/share/dart-sdk-json-utf8-kernels/dart-sdk',
    '$home/github/dart-sdk/core/agent-json-squash/sdk/out/ReleaseX64/dart-sdk',
  ]) {
    final dart = _dartIn(candidate);
    if (dart != null) return dart;
  }
  return null;
}

/// Returns the `dart` binary for [path] (an SDK root or a `bin/dart`), or
/// `null` if it does not look like a json-utf8 SDK.
String? _dartIn(String path) {
  var root = path;
  if (path.endsWith('/bin/dart')) {
    root = path.substring(0, path.length - '/bin/dart'.length);
  }
  if (!File('$root/$_sentinelLibrary').existsSync()) return null;
  final dart = File('$root/bin/dart');
  return dart.existsSync() ? dart.path : null;
}

bool _run(String exe, List<String> args) {
  stdout.writeln('\$ ${[exe, ...args].join(' ')}');
  final result = Process.runSync(exe, args, workingDirectory: _repoRoot);
  stdout.write(result.stdout);
  stderr.write(result.stderr);
  return result.exitCode == 0;
}
