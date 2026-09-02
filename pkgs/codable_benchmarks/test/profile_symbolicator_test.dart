// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:source_maps/source_maps.dart';
import 'package:source_span/source_span.dart';
import 'package:test/test.dart';

import '../tool/profiler/exceptions.dart';
import '../tool/profiler/profile_symbolicator.dart';

void main() {
  group('normalizeLocation', () {
    test('normalizes org-dartlang-sdk:///dart-sdk/lib/ URLs', () {
      final url =
          'org-dartlang-sdk:///dart-sdk/lib/_internal/wasm/common/type.dart';
      expect(normalizeLocation(url), 'dart:_internal/wasm/common/type.dart');
    });

    test('normalizes org-dartlang-sdk:///lib/ URLs', () {
      final url = 'org-dartlang-sdk:///lib/core/print.dart';
      expect(normalizeLocation(url), 'dart:core/print.dart');
    });

    test('normalizes monorepo /pkgs/ workspace URLs', () {
      final url =
          'file:///workspace/pkgs/codable/lib/src/json/driver/driver_js.dart';
      expect(
        normalizeLocation(url),
        'package:codable/src/json/driver/driver_js.dart',
      );
    });

    test('normalizes package relative URLs', () {
      final url = '../../../../packages/codable/lib/src/json/driver.dart';
      expect(normalizeLocation(url), 'package:codable/src/json/driver.dart');
    });

    test('normalizes pub-cache hosted package URLs', () {
      final url =
          'file:///usr/local/google/home/kevmoo/.pub-cache/hosted/pub.dev/json_annotation-4.9.0/lib/json_annotation.dart';
      expect(
        normalizeLocation(url),
        'package:json_annotation/json_annotation.dart',
      );
    });

    test('normalizes pub-cache git package URLs', () {
      final url =
          'file:///usr/local/google/home/kevmoo/.pub-cache/git/bench_press-d6f14393fcb18724cf182e68d1538ae2787da332/lib/src/blackhole.dart';
      expect(normalizeLocation(url), 'package:bench_press/src/blackhole.dart');
    });

    test('leaves already normalized URLs intact', () {
      expect(
        normalizeLocation('package:codable/codable.dart'),
        'package:codable/codable.dart',
      );
      expect(normalizeLocation('dart:core'), 'dart:core');
    });
  });

  group('symbolicateProfile', () {
    test('throws ProfilerException when profile file not found', () async {
      expect(
        () => symbolicateProfile(
          profilePath: 'non_existent_profile.json',
          sourceMapPath: 'some.map',
        ),
        throwsA(isA<ProfilerException>()),
      );
    });

    test('throws ProfilerException when source map file not found', () async {
      final tempDir = await Directory.systemTemp.createTemp('sym_test_');
      try {
        final profileFile = File(p.join(tempDir.path, 'profile.json'));
        await profileFile.writeAsString('{"nodes":[],"samples":[]}');

        expect(
          () => symbolicateProfile(
            profilePath: profileFile.path,
            sourceMapPath: p.join(tempDir.path, 'non_existent.wasm.map'),
          ),
          throwsA(isA<ProfilerException>()),
        );
      } finally {
        await tempDir.delete(recursive: true);
      }
    });

    test(
      'symbolicates Wasm nodes using source map and updates functionName',
      () async {
        final tempDir = await Directory.systemTemp.createTemp('sym_test_');
        try {
          final builder = SourceMapBuilder()
            ..addLocation(
              SourceLocation(
                0,
                sourceUrl: Uri.parse('package:codable/codable.dart'),
                line: 0,
                column: 0,
              ),
              SourceLocation(100, line: 0, column: 100),
              'JsonCodableDecoder.decode',
            );

          final mapFile = File(p.join(tempDir.path, 'benchmark.wasm.map'));
          await mapFile.writeAsString(builder.toJson('benchmark.wasm'));

          final profileJson = {
            'nodes': [
              {
                'id': 1,
                'callFrame': {
                  'functionName': 'wasm-function[10]',
                  'url': 'http://127.0.0.1:8080/benchmark.wasm',
                  'lineNumber': 1,
                  'columnNumber': 100,
                },
                'children': <int>[],
                'hitCount': 5,
              },
            ],
            'samples': [1, 1, 1, 1, 1],
          };

          final profileFile = File(p.join(tempDir.path, 'profile.json'));
          await profileFile.writeAsString(json.encode(profileJson));

          final result = await symbolicateProfile(
            profilePath: profileFile.path,
            sourceMapPath: mapFile.path,
          );

          final nodes = (result['nodes'] as List<dynamic>?)!;
          final firstNode = nodes[0] as Map<String, dynamic>;
          final callFrame = firstNode['callFrame'] as Map<String, dynamic>;

          expect(callFrame['url'], 'package:codable/codable.dart');
          expect(callFrame['functionName'], 'JsonCodableDecoder.decode');
          expect(callFrame['lineNumber'], 1);
        } finally {
          await tempDir.delete(recursive: true);
        }
      },
    );

    test(
      'symbolicates Wasm frame via forward scanning in prologue offset',
      () async {
        final tempDir = await Directory.systemTemp.createTemp('sym_test_');
        try {
          final builder = SourceMapBuilder()
            ..addLocation(
              SourceLocation(
                0,
                sourceUrl: Uri.parse('package:codable/codable.dart'),
                line: 5,
                column: 10,
              ),
              SourceLocation(120, line: 0, column: 120),
              'prologueFunc',
            );

          final mapFile = File(p.join(tempDir.path, 'benchmark.wasm.map'));
          await mapFile.writeAsString(builder.toJson('benchmark.wasm'));

          // Sample is at byte offset 100 (in prologue, before offset 120)
          final profileJson = {
            'nodes': [
              {
                'id': 1,
                'callFrame': {
                  'functionName': 'wasm-function[20]',
                  'url': 'http://127.0.0.1:8080/benchmark.wasm',
                  'lineNumber': 1,
                  'columnNumber': 100,
                },
                'children': <int>[],
                'hitCount': 1,
              },
            ],
            'samples': [1],
          };

          final profileFile = File(p.join(tempDir.path, 'profile.json'));
          await profileFile.writeAsString(json.encode(profileJson));

          final result = await symbolicateProfile(
            profilePath: profileFile.path,
            sourceMapPath: mapFile.path,
          );

          final nodes = (result['nodes'] as List<dynamic>?)!;
          final firstNode = nodes[0] as Map<String, dynamic>;
          final callFrame = firstNode['callFrame'] as Map<String, dynamic>;

          expect(callFrame['url'], 'package:codable/codable.dart');
          expect(callFrame['functionName'], 'prologueFunc');
          expect(callFrame['lineNumber'], 6);
        } finally {
          await tempDir.delete(recursive: true);
        }
      },
    );
  });
}
