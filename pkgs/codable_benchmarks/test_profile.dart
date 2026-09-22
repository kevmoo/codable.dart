import 'dart:convert';
import 'dart:io';

void main() {
  final str = File(
    '/usr/local/google/home/kevmoo/github/kevmoo/codable.dart/pkgs/codable_benchmarks/lib/src/data/canada.json',
  ).readAsStringSync();
  final sw = Stopwatch()..start();
  int count = 0;
  for (int i = 0; i < 500; i++) {
    final ast = jsonDecode(str);
    count += (ast as Map).length;
  }
  print('Decoded in ${sw.elapsedMilliseconds} ms. Count: $count');
}
