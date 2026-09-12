import 'dart:convert';
import 'dart:io';

void main() {
  final file = File('benchmark_results.json');
  if (!file.existsSync()) return;

  final data = jsonDecode(file.readAsStringSync());
  if (data is Map<String, dynamic>) {
    final res = Process.runSync('git', ['rev-parse', 'HEAD']);
    data['environment'] = <String, Object?>{
      'dart_version': Platform.version,
      'os': Platform.operatingSystem,
      'arch':
          Platform.version.contains('arm64') ||
              Platform.version.contains('aarch64')
          ? 'arm64'
          : (Platform.version.contains('x64') ||
                    Platform.version.contains('x86_64')
                ? 'x64'
                : 'unknown'),
      'commit': res.stdout.toString().trim(),
      'host': Platform.localHostname,
    };
    file.writeAsStringSync(const JsonEncoder.withIndent('  ').convert(data));
  }
}
