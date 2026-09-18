import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';

void main(List<String> args) {
  final parser = ArgParser()
    ..addOption(
      'stock-sdk',
      help: 'Optional path to Stock Dart binary to record stock_dart_version.',
    );
  final results = parser.parse(args);

  final file = File('benchmark_results.json');
  if (!file.existsSync()) return;

  final data = jsonDecode(file.readAsStringSync());
  if (data is! Map<String, dynamic>) return;

  final res = Process.runSync('git', ['rev-parse', 'HEAD']);
  final existingEnv = data['environment'] as Map<String, dynamic>?;
  final stockVersion =
      _readSdkVersion(results.option('stock-sdk')) ??
      existingEnv?['stock_dart_version'] as String?;

  data['environment'] = <String, Object?>{
    'dart_version': Platform.version,
    'stock_dart_version': ?stockVersion,
    'os': Platform.operatingSystem,
    'arch': _detectArch(Platform.version),
    'commit': res.stdout.toString().trim(),
    'host': Platform.localHostname,
  };
  file.writeAsStringSync(const JsonEncoder.withIndent('  ').convert(data));
}

String? _readSdkVersion(String? stockSdkBin) {
  if (stockSdkBin == null || stockSdkBin.isEmpty) return null;
  if (!File(stockSdkBin).existsSync()) return null;
  final verRes = Process.runSync(stockSdkBin, ['--version']);
  final rawOut = '${verRes.stdout}\n${verRes.stderr}'.trim();
  if (rawOut.isEmpty) return null;
  return rawOut.replaceFirst(RegExp(r'^Dart SDK version:\s*'), '');
}

String _detectArch(String version) {
  if (version.contains('arm64') || version.contains('aarch64')) {
    return 'arm64';
  }
  if (version.contains('x64') || version.contains('x86_64')) {
    return 'x64';
  }
  return 'unknown';
}
