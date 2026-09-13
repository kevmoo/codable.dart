import 'dart:convert';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:codable/src/json/substrate/mock/span_parsers.dart';
import 'package:test/test.dart';

void main() {
  test('tryParseDoubleUtf8 round-trip exact match with double.parse', () {
    final rand = math.Random(42);
    var failCount = 0;
    const trials = 100000;

    for (var i = 0; i < trials; i++) {
      final isSubnormal = rand.nextBool();
      final sign = rand.nextBool() ? 1.0 : -1.0;
      final exponent = rand.nextInt(2047) - 1023;
      final mantissa = rand.nextDouble();
      final val = isSubnormal
          ? mantissa * math.pow(2, -1022)
          : mantissa * math.pow(2, exponent);
      final finalVal = val * sign;

      final text = finalVal.toString();
      final utf8Bytes = Uint8List.fromList(utf8.encode(text));
      final parsedMock = tryParseDoubleUtf8(utf8Bytes, 0, utf8Bytes.length);
      final parsedReal = double.parse(text);

      if (parsedMock != parsedReal && !parsedReal.isNaN) {
        if (failCount < 5) {
          print('Mismatch: text=$text, real=$parsedReal, mock=$parsedMock');
        }
        failCount++;
      }
    }

    expect(
      failCount,
      0,
      reason: 'Failed $failCount conversions against randomized doubles',
    );
  });

  test('tryParseDoubleUtf8 plain decimal precision boundary', () {
    final rand = math.Random(1337);
    var failCount = 0;
    const trials = 100000;

    for (var i = 0; i < trials; i++) {
      final val = rand.nextDouble() * 1000000.0;
      // Generates very long plain decimals without exponents
      final text = val.toStringAsFixed(10);
      final utf8Bytes = Uint8List.fromList(utf8.encode(text));
      final parsedMock = tryParseDoubleUtf8(utf8Bytes, 0, utf8Bytes.length);
      final parsedReal = double.parse(text);
      if (parsedMock != parsedReal) {
        if (failCount < 5) {
          print('Mismatch: text=$text, real=$parsedReal, mock=$parsedMock');
        }
        failCount++;
      }
    }

    expect(
      failCount,
      0,
      reason:
          'Failed $failCount conversions against '
          'toStringAsFixed plain decimals',
    );
  });
}
