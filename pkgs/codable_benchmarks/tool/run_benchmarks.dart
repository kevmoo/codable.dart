import 'dart:io';

import 'package:args/args.dart';

Future<void> main(List<String> args) async {
  final parser = ArgParser()
    ..addOption(
      'pin-cpu',
      help: 'CPU core to pin to using taskset (Linux only).',
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

  String? findExecutable(List<String> paths) {
    for (final path in paths) {
      if (File(path).existsSync()) {
        return path;
      }
    }
    return null;
  }

  String? which(String command) {
    final res = Process.runSync('which', [command]);
    if (res.exitCode == 0) {
      return res.stdout.toString().trim();
    }
    return null;
  }

  final home = Platform.environment['HOME']!;

  // Find node 24
  final candidateNodePaths = [
    '$home/.local/share/mise/installs/node/24/bin/node',
  ];
  final nodePath = findExecutable(candidateNodePaths) ?? which('node');

  // Find d8
  final candidateD8Paths = ['$home/.jsvu/bin/d8', '$home/.jsvu/d8'];
  final d8Path = findExecutable(candidateD8Paths) ?? which('d8');

  // Find native_kernels SDK
  final sdkPath =
      '$home/.local/share/dart-sdk-json-utf8-kernels/dart-sdk/bin/dart';

  if (!File(sdkPath).existsSync()) {
    stderr.writeln(
      'Warning: Mandatory Dart SDK native_kernels not found at $sdkPath',
    );
  }

  final executionList = <String>[];

  // Optional pin CPU (taskset)
  if (results.option('pin-cpu') != null) {
    if (Platform.isLinux) {
      executionList.addAll(['taskset', '-c', results.option('pin-cpu')!]);
    } else {
      stderr.writeln(
        'Warning: --pin-cpu is only supported on Linux. Ignoring.',
      );
    }
  }

  final executable = executionList.isEmpty ? sdkPath : executionList.first;
  final arguments = <String>[];
  if (executionList.isNotEmpty) {
    arguments.addAll(executionList.skip(1));
    arguments.add(sdkPath);
  }

  arguments.addAll(['run', 'bench_press', 'run']);

  if (nodePath != null) {
    arguments.addAll(['--node-path', nodePath]);
  }

  if (d8Path != null) {
    arguments.addAll(['--d8-path', d8Path]);
  }

  arguments.addAll(results.rest);

  if (results.flag('dry-run')) {
    final cmd = [executable, ...arguments].join(' ');
    print('Dry-run: $cmd');
    print('         => followed by patch_environment.dart');
    print('         => followed by generate_report.dart');
    exit(0);
  }

  print('🚀 Running benchmarks...');
  final process = await Process.start(
    executable,
    arguments,
    mode: ProcessStartMode.inheritStdio,
  );

  final exitCode = await process.exitCode;
  if (exitCode != 0) {
    stderr.writeln('❌ Benchmark run failed with code $exitCode');
    exit(exitCode);
  }

  print('\n📝 Patching environment...');
  final patchProcess = await Process.start(sdkPath, [
    'run',
    'tool/patch_environment.dart',
  ], mode: ProcessStartMode.inheritStdio);
  final patchExitCode = await patchProcess.exitCode;
  if (patchExitCode != 0) {
    stderr.writeln('❌ patch_environment.dart failed with code $patchExitCode');
    exit(patchExitCode);
  }

  // Make sure we generate the report using min metric as explicitly asked.
  print('\n📊 Generating reports...');
  final reportProcess = await Process.start(sdkPath, [
    'run',
    'tool/generate_report.dart',
    '--metric',
    'min',
  ], mode: ProcessStartMode.inheritStdio);
  final reportExitCode = await reportProcess.exitCode;
  if (reportExitCode != 0) {
    stderr.writeln('❌ generate_report.dart failed with code $reportExitCode');
    exit(reportExitCode);
  }

  print('\n✅ Local benchmarks completed successfully.');
}
