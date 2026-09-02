// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:io';

import 'package:source_maps/source_maps.dart';

import 'exceptions.dart';
import 'profile_model.dart';

String normalizeLocation(String url) {
  if (url.startsWith('org-dartlang-sdk:///dart-sdk/lib/')) {
    return url.replaceFirst('org-dartlang-sdk:///dart-sdk/lib/', 'dart:');
  }

  if (url.startsWith('org-dartlang-sdk:///lib/')) {
    return url.replaceFirst('org-dartlang-sdk:///lib/', 'dart:');
  }

  final pubCacheMatch = RegExp(
    r'\.pub-cache/(?:hosted/[^/]+|git)/([a-zA-Z0-9_-]+?)(?:-[0-9a-fA-F.]+)?/lib/(.+)',
  ).firstMatch(url);
  if (pubCacheMatch != null) {
    final pkgName = pubCacheMatch.group(1)!;
    final pathWithin = pubCacheMatch.group(2)!;
    return 'package:$pkgName/$pathWithin';
  }

  if (url.contains('/pkgs/')) {
    final index = url.indexOf('/pkgs/');
    final rest = url.substring(index + '/pkgs/'.length);
    final parts = rest.split('/');
    if (parts.length > 2 && parts[1] == 'lib') {
      final pkgName = parts[0];
      final pathWithin = parts.sublist(2).join('/');
      return 'package:$pkgName/$pathWithin';
    }
  }

  if (url.contains('packages/')) {
    final index = url.indexOf('packages/');
    final rest = url.substring(index + 'packages/'.length);
    final parts = rest.split('/');
    if (parts.length > 1 && parts[1] == 'lib') {
      parts.removeAt(1);
    }
    return 'package:${parts.join('/')}';
  }

  return url;
}

Future<Map<String, dynamic>> symbolicateProfile({
  required String profilePath,
  required String sourceMapPath,
}) async {
  final profileFile = File(profilePath);
  final mapFile = File(sourceMapPath);

  if (!await profileFile.exists()) {
    throw ProfilerException('Profile file not found: $profilePath');
  }
  if (!await mapFile.exists()) {
    throw ProfilerException('Source map file not found: $sourceMapPath');
  }

  final profileContent = await profileFile.readAsString();
  final profile = CpuProfile.fromJson(
    json.decode(profileContent) as Map<String, dynamic>,
  );

  final mapContent = await mapFile.readAsString();
  final parsedMapping = parse(mapContent);
  if (parsedMapping is! SingleMapping) {
    throw ProfilerException(
      'Expected SingleMapping source map but got ${parsedMapping.runtimeType}',
    );
  }
  final mapping = parsedMapping;

  final isWasmMap = sourceMapPath.contains('wasm');

  for (final node in profile.nodes) {
    final frame = node.callFrame;
    final line = frame.lineNumber;
    final column = frame.columnNumber;

    final shouldSymbolicate = isWasmMap
        ? frame.url.contains('.wasm')
        : frame.url.contains('.js');

    if (line != null && column != null) {
      if (shouldSymbolicate) {
        // In Wasm source maps, byte offsets are mapped along column numbers
        // on line 0. Chrome V8 reports lineNumber as 1 for Wasm frames.
        final targetLine = isWasmMap ? 0 : line;
        var span = mapping.spanFor(targetLine, column);

        // Wasm source maps often don't have an entry for the prologue.
        // If spanFor returns null (meaning we are before the first entry),
        // scan forward up to 512 bytes to snap to the first mapped instruction.
        if (span == null) {
          for (var offset = column; offset < column + 512; offset++) {
            span = mapping.spanFor(targetLine, offset);
            if (span != null) break;
          }
        }

        if (span != null) {
          if (span.text.isNotEmpty) {
            frame.functionName = span.text;
          }
          final sourceUrl = span.sourceUrl;
          if (sourceUrl != null) {
            frame.url = normalizeLocation(sourceUrl.toString());
          }
          frame.lineNumber = span.start.line + 1;
          frame.columnNumber = span.start.column + 1;
        }
      } else {
        frame.url = normalizeLocation(frame.url);
      }
    }
  }

  return profile.toJson();
}
