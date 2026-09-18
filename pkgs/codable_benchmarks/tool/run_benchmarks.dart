// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:args/args.dart';
import 'package:path/path.dart' as p;

Future<void> main(List<String> args) async {
  final parser = ArgParser()
    ..addOption(
      'pin-cpu',
      help: 'CPU core to pin to using taskset (Linux only).',
    )
    ..addOption(
      'stock-sdk',
      help:
          'Path to Stock Dart SDK or dart executable '
          '(e.g. ~/github/flutter/bin/dart) to run a Stock Dart pass in mock '
          'substrate mode alongside the native_kernels pass.',
    )
    ..addFlag(
      'dry-run',
      abbr: 'd',
      help: 'Print the command that would be run, then exit.',
    )
    ..addFlag('help', abbr: 'h', negatable: false, help: 'Print usage.');

  final results = parser.parse(args);

  if (results.flag('help')) {
    print(
      'Usage: dart run tool/run_benchmarks.dart [options] '
      '[-- bench_press flags]',
    );
    print(parser.usage);
    exit(0);
  }

  final home =
      Platform.environment['HOME'] ?? Platform.environment['USERPROFILE'] ?? '';

  final nodePath =
      _findExecutable(['$home/.local/share/mise/installs/node/24/bin/node']) ??
      _which('node');
  final d8Path =
      _findExecutable(['$home/.jsvu/bin/d8', '$home/.jsvu/d8']) ?? _which('d8');

  final sdkPath = _findNativeSdk(home);
  if (sdkPath == null) {
    stderr.writeln(
      'Error: Mandatory Dart SDK native_kernels not found.\n'
      'Set CODABLE_NATIVE_SDK or install to '
      '~/.local/share/dart-sdk-json-utf8-kernels/dart-sdk.',
    );
    exit(1);
  }

  final rawStockSdk =
      results.option('stock-sdk') ?? Platform.environment['CODABLE_STOCK_SDK'];
  ({String sdkRoot, String dartBin})? stockSdk;
  if (rawStockSdk != null && rawStockSdk.isNotEmpty) {
    stockSdk = _resolveStockSdk(rawStockSdk, home);
    if (stockSdk == null) {
      stderr.writeln('Error: Stock Dart SDK not found at "$rawStockSdk".');
      exit(1);
    }
  }

  final scriptFile = File(Platform.script.toFilePath());
  final benchmarkPkgDir = scriptFile.parent.parent.path;
  final workspaceRoot = p.dirname(p.dirname(benchmarkPkgDir));

  final pinCpu = results.option('pin-cpu');
  final nativeCmd = _buildBenchPressCommand(
    dartBin: sdkPath,
    pinCpu: pinCpu,
    nodePath: nodePath,
    d8Path: d8Path,
    extraArgs: results.rest,
  );

  if (results.flag('dry-run')) {
    _printDryRun(
      benchmarkPkgDir: benchmarkPkgDir,
      stockSdk: stockSdk,
      pinCpu: pinCpu,
      nodePath: nodePath,
      d8Path: d8Path,
      extraArgs: results.rest,
      nativeCmd: nativeCmd,
    );
    exit(0);
  }

  if (stockSdk != null) {
    await _runStockPass(
      stockSdk: stockSdk,
      nativeDartBin: sdkPath,
      workspaceRoot: workspaceRoot,
      benchmarkPkgDir: benchmarkPkgDir,
      pinCpu: pinCpu,
      nodePath: nodePath,
      d8Path: d8Path,
      extraArgs: results.rest,
    );
  }

  print('🚀 Running native_kernels benchmarks (Tier 1 & Tier 3)...');
  await _runCheckedProcess(
    nativeCmd.executable,
    nativeCmd.arguments,
    workingDirectory: benchmarkPkgDir,
    errorLabel: 'Benchmark run',
  );

  print('\n📝 Patching environment...');
  final patchArgs = <String>[
    'run',
    'tool/patch_environment.dart',
    if (stockSdk != null) ...['--stock-sdk', stockSdk.dartBin],
  ];
  await _runCheckedProcess(
    sdkPath,
    patchArgs,
    workingDirectory: benchmarkPkgDir,
    errorLabel: 'patch_environment.dart',
  );

  print('\n📊 Generating reports...');
  await _runCheckedProcess(
    sdkPath,
    ['run', 'tool/generate_report.dart', '--metric', 'min'],
    workingDirectory: benchmarkPkgDir,
    errorLabel: 'generate_report.dart',
  );

  print('\n✅ Local benchmarks completed successfully.');
}

String? _findExecutable(List<String> paths) {
  for (final path in paths) {
    if (File(path).existsSync()) {
      return path;
    }
  }
  return null;
}

String? _which(String command) {
  final res = Process.runSync('which', [command]);
  if (res.exitCode == 0) {
    return res.stdout.toString().trim();
  }
  return null;
}

String? _findNativeSdk(String home) {
  final explicit = Platform.environment['CODABLE_NATIVE_SDK'];
  if (explicit != null && explicit.isNotEmpty) {
    final dart = explicit.endsWith('/bin/dart')
        ? explicit
        : '$explicit/bin/dart';
    if (File(dart).existsSync()) return dart;
  }
  final candidate =
      '$home/.local/share/dart-sdk-json-utf8-kernels/dart-sdk/bin/dart';
  if (File(candidate).existsSync()) return candidate;
  return null;
}

({String sdkRoot, String dartBin})? _resolveStockSdk(
  String rawPath,
  String home,
) {
  final expanded = rawPath.startsWith('~')
      ? rawPath.replaceFirst('~', home)
      : rawPath;
  final normalized = p.normalize(p.absolute(expanded));

  // Case 1: Path to flutter/bin/dart -> flutter/bin/cache/dart-sdk
  final parentDir = p.dirname(normalized);
  final flutterCacheFromBin = p.join(parentDir, 'cache', 'dart-sdk');
  if (_isValidSdkRoot(flutterCacheFromBin)) {
    return (
      sdkRoot: flutterCacheFromBin,
      dartBin: p.join(flutterCacheFromBin, 'bin', 'dart'),
    );
  }

  // Case 2: Path to standard dart-sdk/bin/dart
  final grandParentDir = p.dirname(parentDir);
  if (_isValidSdkRoot(grandParentDir)) {
    return (
      sdkRoot: grandParentDir,
      dartBin: p.join(grandParentDir, 'bin', 'dart'),
    );
  }

  // Case 3: Path to flutter root directory -> flutter/bin/cache/dart-sdk
  final flutterCacheFromRoot = p.join(normalized, 'bin', 'cache', 'dart-sdk');
  if (_isValidSdkRoot(flutterCacheFromRoot)) {
    return (
      sdkRoot: flutterCacheFromRoot,
      dartBin: p.join(flutterCacheFromRoot, 'bin', 'dart'),
    );
  }

  // Case 4: Path directly to a dart-sdk root directory
  if (_isValidSdkRoot(normalized)) {
    return (sdkRoot: normalized, dartBin: p.join(normalized, 'bin', 'dart'));
  }

  return null;
}

bool _isValidSdkRoot(String dirPath) =>
    Directory(dirPath).existsSync() &&
    File(p.join(dirPath, 'bin', 'dart')).existsSync() &&
    (File(p.join(dirPath, 'version')).existsSync() ||
        File(p.join(dirPath, 'lib', 'libraries.json')).existsSync());

({String executable, List<String> arguments}) _buildBenchPressCommand({
  required String dartBin,
  required String? pinCpu,
  required String? nodePath,
  required String? d8Path,
  required List<String> extraArgs,
  String? configPath,
}) {
  final prefix = <String>[];
  if (pinCpu != null) {
    if (Platform.isLinux) {
      prefix.addAll(['taskset', '-c', pinCpu]);
    } else {
      stderr.writeln(
        'Warning: --pin-cpu is only supported on Linux. Ignoring.',
      );
    }
  }

  final executable = prefix.isEmpty ? dartBin : prefix.first;
  final arguments = <String>[
    if (prefix.isNotEmpty) ...[...prefix.skip(1), dartBin],
    'run',
    'bench_press',
    'run',
    if (configPath != null) ...['-c', configPath],
    if (nodePath != null) ...['--node-path', nodePath],
    if (d8Path != null) ...['--d8-path', d8Path],
    ...extraArgs,
  ];
  return (executable: executable, arguments: arguments);
}

void _printDryRun({
  required String benchmarkPkgDir,
  required ({String sdkRoot, String dartBin})? stockSdk,
  required String? pinCpu,
  required String? nodePath,
  required String? d8Path,
  required List<String> extraArgs,
  required ({String executable, List<String> arguments}) nativeCmd,
}) {
  if (stockSdk != null) {
    final stockCmd = _buildBenchPressCommand(
      dartBin: stockSdk.dartBin,
      pinCpu: pinCpu,
      nodePath: nodePath,
      d8Path: d8Path,
      extraArgs: extraArgs,
      configPath: '.dart_tool/bench_press_stock.yaml',
    );
    print('Dry-run (Stock Pass - Tier 0 & Tier 2 in mock substrate):');
    print('  1. dart run tool/switch_substrate.dart mock');
    print('  2. ${stockCmd.executable} ${stockCmd.arguments.join(' ')}');
    print('  3. dart run tool/switch_substrate.dart native');
  }
  final cmd = [nativeCmd.executable, ...nativeCmd.arguments].join(' ');
  print('Dry-run (Native Kernels Pass - cwd: $benchmarkPkgDir): $cmd');
  print('         => followed by patch_environment.dart');
  print('         => followed by generate_report.dart');
}

Future<void> _runStockPass({
  required ({String sdkRoot, String dartBin}) stockSdk,
  required String nativeDartBin,
  required String workspaceRoot,
  required String benchmarkPkgDir,
  required String? pinCpu,
  required String? nodePath,
  required String? d8Path,
  required List<String> extraArgs,
}) async {
  final tempConfigFile = File(
    p.join(benchmarkPkgDir, '.dart_tool', 'bench_press_stock.yaml'),
  );
  final buildCacheDir = Directory(
    p.join(benchmarkPkgDir, '.dart_tool', 'bench_press', 'build'),
  );

  print(
    '\n🔄 Switching substrate to MOCK for Stock Dart pass '
    '(${stockSdk.sdkRoot})...',
  );
  await _runCheckedProcess(
    nativeDartBin,
    ['run', 'tool/switch_substrate.dart', 'mock'],
    workingDirectory: workspaceRoot,
    errorLabel: 'switch_substrate.dart mock',
  );

  try {
    if (buildCacheDir.existsSync()) {
      buildCacheDir.deleteSync(recursive: true);
    }
    tempConfigFile.parent.createSync(recursive: true);
    tempConfigFile.writeAsStringSync('''
version: 1
defaults:
  targets: [aot, wasm, js]
  trials: 15
matrix:
  baseline:
    sdk: stock
    runtime: aot
  axes:
    sdk:
      stock: "${stockSdk.sdkRoot}"
    runtime:
      - aot
      - wasm
      - js
''');

    final stockCmd = _buildBenchPressCommand(
      dartBin: stockSdk.dartBin,
      pinCpu: pinCpu,
      nodePath: nodePath,
      d8Path: d8Path,
      extraArgs: extraArgs,
      configPath: tempConfigFile.path,
    );

    print('🚀 Running Stock Dart benchmarks (Tier 0 & Tier 2)...');
    await _runCheckedProcess(
      stockCmd.executable,
      stockCmd.arguments,
      workingDirectory: benchmarkPkgDir,
      errorLabel: 'Stock Dart benchmark run',
    );
  } finally {
    if (tempConfigFile.existsSync()) {
      tempConfigFile.deleteSync();
    }
    if (buildCacheDir.existsSync()) {
      buildCacheDir.deleteSync(recursive: true);
    }
    print('\n🔄 Restoring substrate to NATIVE...');
    await _runCheckedProcess(
      nativeDartBin,
      ['run', 'tool/switch_substrate.dart', 'native'],
      workingDirectory: workspaceRoot,
      errorLabel: 'switch_substrate.dart native',
    );
  }
}

Future<void> _runCheckedProcess(
  String executable,
  List<String> arguments, {
  required String workingDirectory,
  required String errorLabel,
}) async {
  final process = await Process.start(
    executable,
    arguments,
    workingDirectory: workingDirectory,
    mode: ProcessStartMode.inheritStdio,
  );
  final exitCode = await process.exitCode;
  if (exitCode != 0) {
    stderr.writeln('❌ $errorLabel failed with code $exitCode');
    exit(exitCode);
  }
}
