// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:typed_data';

import 'package:checks/checks.dart';
import 'package:codable/codable.dart';
import 'package:codable/src/driver/json_codable_driver.dart';
import 'package:test/test.dart';

/// Lightweight 128-bit UUID parsed directly from UTF-8 byte spans without
/// String allocations.
final class FastUuid {
  final int high;
  final int low;

  const FastUuid(this.high, this.low);

  factory FastUuid.fromUtf8(Uint8List bytes, int start, int end) {
    // Standard format: 8-4-4-4-12 hex chars (36 bytes)
    var h = 0;
    var l = 0;
    var hexCount = 0;

    for (var i = start; i < end; i++) {
      final b = bytes[i];
      if (b == 0x2D) continue; // skip '-'

      final int digit;
      if (b >= 0x30 && b <= 0x39) {
        digit = b - 0x30;
      } else if (b >= 0x61 && b <= 0x66) {
        digit = b - 0x61 + 10;
      } else if (b >= 0x41 && b <= 0x46) {
        digit = b - 0x41 + 10;
      } else {
        throw FormatException('Invalid hex char in UUID', bytes, i);
      }

      if (hexCount < 16) {
        h = (h << 4) | digit;
      } else {
        l = (l << 4) | digit;
      }
      hexCount++;
    }

    if (hexCount != 32) {
      throw FormatException(
        'Invalid UUID length ($hexCount hex digits)',
        bytes,
        start,
      );
    }
    return FastUuid(h, l);
  }

  @override
  bool operator ==(Object other) =>
      other is FastUuid && other.high == high && other.low == low;

  @override
  int get hashCode => Object.hash(high, low);
}

/// Parses UTC ISO-8601 (YYYY-MM-DDTHH:MM:SSZ) directly from UTF-8 byte spans.
DateTime parseIso8601UtcSpan(Uint8List bytes, int start, int end) {
  // Expected format: 2026-08-16T21:30:00Z (20 bytes)
  int d(int offset) => bytes[start + offset] - 0x30;

  final year = d(0) * 1000 + d(1) * 100 + d(2) * 10 + d(3);
  final month = d(5) * 10 + d(6);
  final day = d(8) * 10 + d(9);
  final hour = d(11) * 10 + d(12);
  final minute = d(14) * 10 + d(15);
  final second = d(17) * 10 + d(18);

  return DateTime.utc(year, month, day, hour, minute, second);
}

void main() {
  final isSpanSupported = () {
    try {
      final d = JsonCodableDecoder.fromBytes(
        Uint8List.fromList(utf8.encode('"test"')),
      );
      d.singleValue().readStringSpan();
      return true;
    } catch (_) {
      return false;
    }
  }();

  group('Zero-Copy String Span Decoding in package:codable', () {
    test('JsonCodableDecoder exposes payload buffer', () {
      final jsonBytes = Uint8List.fromList(utf8.encode('{"name": "Alice"}'));
      final decoder = JsonCodableDecoder.fromBytes(jsonBytes);

      check(decoder.payload).isNotNull().equals(jsonBytes);
    });

    test(
      'KeyedDecoder readStringSpan parses UUID and DateTime without String '
      'allocation',
      () {
        const json =
            '{"uuid": "550e8400-e29b-41d4-a716-446655440000", '
            '"created_at": "2026-08-16T21:30:00Z", "null_field": null}';
        final bytes = Uint8List.fromList(utf8.encode(json));
        final decoder = JsonCodableDecoder.fromBytes(bytes);
        final keyed = decoder.keyed();

        FastUuid? uuid;
        DateTime? createdAt;
        (int, int)? nullSpan;

        while (keyed.hasNextKey()) {
          final key = keyed.nextKey();
          switch (key) {
            case 'uuid':
              final (start, end) = keyed.readStringSpan();
              uuid = FastUuid.fromUtf8(decoder.payload!, start, end);
              break;
            case 'created_at':
              final (start, end) = keyed.readStringSpan();
              createdAt = parseIso8601UtcSpan(decoder.payload!, start, end);
              break;
            case 'null_field':
              nullSpan = keyed.readNullableStringSpan();
              break;
          }
        }

        check(uuid).equals(
          FastUuid.fromUtf8(
            Uint8List.fromList(
              utf8.encode('550e8400-e29b-41d4-a716-446655440000'),
            ),
            0,
            36,
          ),
        );
        check(createdAt).equals(DateTime.utc(2026, 8, 16, 21, 30, 0));
        check(nullSpan).isNull();
      },
      skip: !isSpanSupported
          ? 'readStringSpan is only supported in mock substrate or SDK '
                'with readStringSpan patch'
          : null,
    );

    test(
      'UnkeyedDecoder readStringSpan extracts list elements as spans',
      () {
        const json = '["2026-08-16T12:00:00Z", "2026-08-16T13:00:00Z", null]';
        final bytes = Uint8List.fromList(utf8.encode(json));
        final decoder = JsonCodableDecoder.fromBytes(bytes);
        final unkeyed = decoder.unkeyed();

        final dates = <DateTime?>[];
        while (unkeyed.hasNext()) {
          final span = unkeyed.readNullableStringSpan();
          if (span == null) {
            dates.add(null);
          } else {
            dates.add(parseIso8601UtcSpan(decoder.payload!, span.$1, span.$2));
          }
        }

        check(dates.length).equals(3);
        check(dates[0]).equals(DateTime.utc(2026, 8, 16, 12, 0, 0));
        check(dates[1]).equals(DateTime.utc(2026, 8, 16, 13, 0, 0));
        check(dates[2]).isNull();
      },
      skip: !isSpanSupported
          ? 'readStringSpan is only supported in mock substrate or SDK '
                'with readStringSpan patch'
          : null,
    );

    test(
      'SingleValueDecoder readStringSpan extracts standalone scalar span',
      () {
        const json = '"2026-08-16T15:45:00Z"';
        final bytes = Uint8List.fromList(utf8.encode(json));
        final decoder = JsonCodableDecoder.fromBytes(bytes);
        final single = decoder.singleValue();

        final (start, end) = single.readStringSpan();
        final dt = parseIso8601UtcSpan(decoder.payload!, start, end);
        check(dt).equals(DateTime.utc(2026, 8, 16, 15, 45, 0));
      },
      skip: !isSpanSupported
          ? 'readStringSpan is only supported in mock substrate or SDK '
                'with readStringSpan patch'
          : null,
    );
  });
}
