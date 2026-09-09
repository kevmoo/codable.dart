// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';
import 'dart:typed_data';

import 'package:codable/src/json/substrate/mock/substrate_mock.dart';
import 'package:test/test.dart';

void main() {
  final fixturesDir = _findFixturesDir();
  final parsingDir = Directory('${fixturesDir.path}/test_parsing');

  if (!parsingDir.existsSync()) {
    test('fixtures present', () {
      fail('JSONTestSuite fixtures not found at ${parsingDir.path}');
    });
    return;
  }

  final files =
      parsingDir
          .listSync()
          .whereType<File>()
          .where((f) => f.path.endsWith('.json'))
          .toList()
        ..sort(
          (a, b) => a.uri.pathSegments.last.compareTo(b.uri.pathSegments.last),
        );

  final yFiles = files
      .where((f) => f.uri.pathSegments.last.startsWith('y_'))
      .toList();
  final nFiles = files
      .where((f) => f.uri.pathSegments.last.startsWith('n_'))
      .toList();
  final iFiles = files
      .where((f) => f.uri.pathSegments.last.startsWith('i_'))
      .toList();

  group('JSONTestSuite (RFC 8259 Conformance)', () {
    group('y_* (valid JSON must accept)', () {
      for (final file in yFiles) {
        final name = file.uri.pathSegments.last;
        test(name, () {
          final bytes = file.readAsBytesSync();
          expect(
            () => _parseFully(bytes),
            returnsNormally,
            reason: 'File $name must be accepted by RFC 8259 compliant parser',
          );
        });
      }
    });

    group('n_* (invalid JSON must reject)', () {
      for (final file in nFiles) {
        final name = file.uri.pathSegments.last;
        test(name, () {
          final bytes = file.readAsBytesSync();
          expect(
            () => _parseFully(bytes),
            throwsA(isA<FormatException>()),
            reason: 'File $name must be rejected with FormatException',
          );
        });
      }
    });

    group('i_* (indeterminate / implementation-defined)', () {
      for (final file in iFiles) {
        final name = file.uri.pathSegments.last;
        test(name, () {
          final bytes = file.readAsBytesSync();
          try {
            _parseFully(bytes);
          } on FormatException {
            // Rejection is acceptable for indeterminate files
          } catch (e) {
            fail('File $name threw unexpected non-FormatException: $e');
          }
        });
      }
    });
  });
}

void _parseFully(Uint8List bytes) {
  final reader = JsonTokenReader.fromBytes(bytes);
  _consumeJsonValue(reader, 0);
  if (reader.peek() != JsonTokenType.endOfDocument) {
    throw FormatException(
      'Trailing tokens remaining in document: ${reader.peek()}',
    );
  }
}

void _consumeJsonValue(JsonTokenReader reader, [int depth = 0]) {
  if (depth > 1000) {
    throw FormatException('Exceeded maximum nesting depth: $depth');
  }
  final token = reader.peek();
  switch (token) {
    case JsonTokenType.beginObject:
      reader.beginObject();
      while (reader.hasNext()) {
        reader.nextName();
        _consumeJsonValue(reader, depth + 1);
      }
      reader.endObject();
    case JsonTokenType.beginArray:
      reader.beginArray();
      while (reader.hasNext()) {
        _consumeJsonValue(reader, depth + 1);
      }
      reader.endArray();
    case JsonTokenType.string:
      reader.readString();
    case JsonTokenType.number:
      reader.readNum();
    case JsonTokenType.boolean:
      reader.readBool();
    case JsonTokenType.nullValue:
      reader.readNull();
    case JsonTokenType.none:
    case JsonTokenType.endObject:
    case JsonTokenType.endArray:
    case JsonTokenType.propertyName:
    case JsonTokenType.endOfDocument:
      throw FormatException('Unexpected token: $token');
  }
}

Directory _findFixturesDir() {
  var dir = Directory.current;
  while (!Directory('${dir.path}/test/fixtures/json_test_suite').existsSync()) {
    if (Directory('${dir.path}/pkgs/codable/test/fixtures/json_test_suite')
        .existsSync()) {
      return Directory(
        '${dir.path}/pkgs/codable/test/fixtures/json_test_suite',
      );
    }
    final parent = dir.parent;
    if (parent.path == dir.path) {
      throw StateError(
        'Could not find fixtures directory above ${Directory.current.path}',
      );
    }
    dir = parent;
  }
  return Directory('${dir.path}/test/fixtures/json_test_suite');
}
