@TestOn('vm')
library;

import 'dart:io';

import 'package:api_summary/api_summary.dart';
import 'package:test/scaffolding.dart';

void main() {
  test('api_summary', () {
    final inPackageDir = Directory.current.path.endsWith('pkgs/codable_toml');
    return expectApiSummaryClean(
      packagePath: inPackageDir ? null : 'pkgs/codable_toml',
    );
  });
}
