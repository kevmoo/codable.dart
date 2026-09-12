// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// `writeDoubleToBuffer` is only reachable from the byte-oriented writers
// (`AdaptiveJsonTokenWriter` and the mock token writer). Web targets route
// encoding through `driver_js.dart` and `JSON.stringify`, which never calls
// it, so there is nothing for this suite to verify off the VM.
@TestOn('vm')
library;

import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:checks/checks.dart';
import 'package:codable/src/json/substrate/writer_formatting.dart';
import 'package:test/test.dart';

final _buffer = Uint8List(64);

/// Formats [value] exactly as the byte writers do.
String _render(double value) {
  final written = writeDoubleToBuffer(value, _buffer, 0);
  return String.fromCharCodes(_buffer, 0, written);
}

/// Whether [absVal] only reaches the fast path by escalating to 16 digits.
///
/// Mirrors the entry conditions of `tryWriteScaledFractionDouble` so the
/// corpora below can prove they actually exercise the escalation rather than
/// passing vacuously.
bool _requiresEscalation(double absVal) {
  if (absVal < 1e-15 || absVal > 1e15) return false;
  if (absVal.truncateToDouble() == absVal) return false;
  final intPart = absVal.toInt();
  final intPartDigits = intPart == 0 ? 0 : digitCountNegative(-intPart);
  final maxFrac = 15 - intPartDigits;
  if (maxFrac <= 0 || maxFrac > 15) return false;
  if (tryScaleToExactMantissa(absVal, powersOfTen[maxFrac]) >= 0) return false;
  return tryScaleToExactMantissa(absVal, powersOfTen[maxFrac + 1]) >= 0;
}

/// Accumulates coverage so a corpus cannot silently stop testing anything.
class _Probe {
  int checked = 0;
  int escalated = 0;
  int comparedToJsonEncode = 0;
  final List<String> failures = [];

  void call(double value) {
    if (!value.isFinite || value == 0.0) return;
    checked++;
    if (_requiresEscalation(value.abs())) escalated++;

    final rendered = _render(value);

    // 1. The emitted text must reproduce the original double exactly. This is
    //    the invariant that actually matters; a violation is data corruption.
    final reparsed = double.parse(rendered);
    if (reparsed != value) {
      if (failures.length < 10) {
        failures.add(
          'round-trip: $value rendered as "$rendered" '
          'which parses back as $reparsed',
        );
      }
      return;
    }

    // 2. Where `jsonEncode` emits plain decimal notation, our output must be
    //    byte-identical to it. The fast path never emits exponent form, so
    //    values `jsonEncode` writes exponentially are excluded -- that
    //    divergence is by design and is covered separately below.
    final standard = jsonEncode(value);
    if (standard.contains('e')) return;
    comparedToJsonEncode++;
    if (rendered != standard) {
      if (failures.length < 10) {
        failures.add(
          'text: $value rendered as "$rendered", '
          'jsonEncode emits "$standard"',
        );
      }
    }
  }
}

void main() {
  group('writeDoubleToBuffer differential vs jsonEncode', () {
    test('decimals of 13..17 significant digits round-trip and match', () {
      final random = Random(20260912);
      final probe = _Probe();

      for (var i = 0; i < 120000; i++) {
        final significantDigits = 13 + random.nextInt(5);
        final digits = StringBuffer();
        if (random.nextBool()) digits.write('-');
        digits.write(1 + random.nextInt(9));
        for (var j = 1; j < significantDigits; j++) {
          digits.write(random.nextInt(10));
        }
        digits.write('e${random.nextInt(22) - 20}');
        probe(double.parse(digits.toString()));
      }

      check(probe.failures).isEmpty();
      // Guards against the corpus drifting into values that never escalate,
      // which would make this test pass without exercising the change.
      check(probe.escalated).isGreaterThan(1000);
      check(probe.comparedToJsonEncode).isGreaterThan(1000);
    });

    test('values straddling the .5 rounding boundary are exact', () {
      final random = Random(4242);
      final probe = _Probe();

      for (var intPartDigits = 0; intPartDigits <= 6; intPartDigits++) {
        final maxFrac = 15 - intPartDigits;
        final p10 = powersOfTen[maxFrac];
        for (var i = 0; i < 4000; i++) {
          final base = intPartDigits == 0
              ? random.nextDouble()
              : random.nextDouble() * pow(10, intPartDigits).toDouble();
          final floor = (base * p10).floorToDouble();
          for (final offset in const [
            0.5,
            0.4999999,
            0.5000001,
            0.49999999999,
          ]) {
            final value = (floor + offset) / p10;
            probe(value);
            probe(-value);
          }
        }
      }

      check(probe.failures).isEmpty();
      check(probe.escalated).isGreaterThan(100);
    });

    test('arbitrary bit patterns in the plain-decimal range are exact', () {
      final random = Random(99991);
      final bytes = ByteData(8);
      final probe = _Probe();

      for (var i = 0; i < 120000; i++) {
        bytes.setUint32(0, random.nextInt(0x100000000));
        bytes.setUint32(4, random.nextInt(0x100000000));
        final value = bytes.getFloat64(0);
        if (!value.isFinite) continue;
        final magnitude = value.abs();
        if (magnitude < 1e-6 || magnitude > 1e15) continue;
        probe(value);
      }

      check(probe.failures).isEmpty();
      check(probe.checked).isGreaterThan(1000);
    });

    test('GeoJSON-style coordinates round-trip and match jsonEncode', () {
      // 16-significant-digit coordinates are the population that motivated
      // the escalation; canada.json is ~86% of them.
      const coordinates = <double>[
        -65.613616999999977,
        43.420273000000009,
        -65.619720000000029,
        43.418052999999986,
        -65.625,
        43.421379999999994,
        -65.636123999999941,
        43.418603000000012,
        1.2345678901234567,
        -9.8765432109876543,
        0.1000000000000000055511151231257827,
      ];

      final probe = _Probe();
      for (final coordinate in coordinates) {
        probe(coordinate);
      }

      check(probe.failures).isEmpty();
      check(probe.escalated).isGreaterThan(0);
    });

    test('small magnitudes render as plain decimals, not exponentials', () {
      // Documented, deliberate divergence: the fast path has never emitted
      // exponent notation, and the escalation widens the set of values that
      // reach it. Output stays exact, but differs textually from jsonEncode.
      check(_render(-6.2e-15)).equals('-0.0000000000000062');
      check(jsonEncode(-6.2e-15)).equals('-6.2e-15');
      check(double.parse(_render(-6.2e-15))).equals(-6.2e-15);
    });

    test('zero, integral and out-of-range values are unaffected', () {
      check(_render(0.0)).equals('0.0');
      check(_render(-0.0)).equals('-0.0');
      check(_render(1.0)).equals('1.0');
      check(_render(-42.0)).equals('-42.0');
      for (final value in <double>[
        1e16,
        -1e16,
        1e-16,
        5e-324,
        1.7976931348623157e308,
      ]) {
        check(double.parse(_render(value))).equals(value);
      }
    });
  });
}
