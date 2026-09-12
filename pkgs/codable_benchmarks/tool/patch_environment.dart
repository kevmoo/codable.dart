import 'dart:convert';
import 'dart:io';

void main() {
  final file = File('benchmark_results.json');
  if (!file.existsSync()) return;

  final data = jsonDecode(file.readAsStringSync());
  if (data is Map<String, dynamic>) {
    data['environment'] = {
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
    };
    // Include commit info
    final res = Process.runSync('git', ['rev-parse', 'HEAD']);
    data['environment']['commit'] = res.stdout.toString().trim();
    data['environment']['host'] = Platform.localHostname;
    file.writeAsStringSync(const JsonEncoder.withIndent('  ').convert(data));
  }
}
