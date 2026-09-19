import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:codable/src/json/substrate/mock/json_token_reader.dart';
import 'package:codable/src/json/substrate/mock/span_parsers.dart';

void main() {
  print('================================================================');
  print('EMPIRICAL PROOF SUITE: RED-TEAM AUDIT OF CONVO f5ab3a81');
  print('================================================================\n');

  // -------------------------------------------------------------------------
  // PROOF 1: Silent 64-Bit Integer Overflow & readNum() Corruption in
  // Tier 2 Mock Substrate (codable.dart PR #63 c1c5507)
  // -------------------------------------------------------------------------
  print('--- PROOF 1: Silent 64-Bit Integer Overflow in Mock Substrate ---');
  final testInts = [
    '9223372036854775808', // 2^63 (MAX_INT64 + 1)
    '9999999999999999999', // 19 nines
    '-9223372036854775809', // -2^63 - 1 (MIN_INT64 - 1)
    '100000000000000000000', // 10^20 (21 digits)
  ];
  for (final s in testInts) {
    final u8 = Uint8List.fromList(utf8.encode(s));
    final spanInt = tryParseIntUtf8(u8, 0, u8.length);
    final reader1 = JsonTokenReader.fromBytes(
      Uint8List.fromList(utf8.encode('[$s]')),
    )..beginArray();
    final readIntVal = reader1.readInt();

    final reader2 = JsonTokenReader.fromBytes(
      Uint8List.fromList(utf8.encode('[$s]')),
    )..beginArray();
    final readNumVal = reader2.readNum();
    final stdJsonVal = jsonDecode('[$s]')[0];

    print(
      'JSON [$s]:\n'
      '  int.tryParse("$s")            -> ${int.tryParse(s)} (expected null)\n'
      '  dart:convert jsonDecode       -> $stdJsonVal (${stdJsonVal.runtimeType})\n'
      '  codable tryParseIntUtf8       -> $spanInt (CORRUPTED INT64 OVERFLOW)\n'
      '  codable JsonTokenReader.readInt() -> $readIntVal (NO FormatException!)\n'
      '  codable JsonTokenReader.readNum() -> $readNumVal (${readNumVal.runtimeType} instead of double!)',
    );
  }

  // -------------------------------------------------------------------------
  // PROOF 2: Broken JSON State Machine in _MockJsonTokenReader (PR #63)
  // -------------------------------------------------------------------------
  print('\n--- PROOF 2: Invalid JSON Accepted by _MockJsonTokenReader ---');
  // 2a: Object with NO keys and NO colons `{123, 456}` parsed via beginObject + hasNext + readInt!
  final badObjBytes = Uint8List.fromList(utf8.encode('{123, 456}'));
  final badReader = JsonTokenReader.fromBytes(badObjBytes);
  badReader.beginObject();
  final extractedFromInvalidObject = <int>[];
  while (badReader.hasNext()) {
    extractedFromInvalidObject.add(badReader.readInt());
  }
  badReader.endObject();
  print(
    'Invalid JSON "{123, 456}" (object without keys/colons):\n'
    '  _MockJsonTokenReader extracted ints: $extractedFromInvalidObject (NO FormatException!)',
  );

  // 2b: Object with consecutive keys and no value `{"a": "b": 42}`!
  final badObj2Bytes = Uint8List.fromList(utf8.encode('{"a": "b": 42}'));
  final badReader2 = JsonTokenReader.fromBytes(badObj2Bytes);
  badReader2.beginObject();
  badReader2.hasNext();
  final k1 = badReader2.nextName();
  badReader2.hasNext();
  final k2 = badReader2.nextName();
  final v2 = badReader2.readInt();
  badReader2.endObject();
  print(
    'Invalid JSON \'{"a": "b": 42}\' (key without value):\n'
    '  _MockJsonTokenReader parsed k1="$k1", k2="$k2", v=$v2 (NO FormatException!)',
  );

  // 2c: decodeStringUtf8 & isVerbatimUtf8 accepting unescaped control chars & quotes
  final rawControlSpan = Uint8List.fromList([
    0x61,
    0x0A,
    0x00,
    0x22,
    0x62,
  ]); // a \n \0 " b
  final decodedInvalid = decodeStringUtf8(
    rawControlSpan,
    0,
    rawControlSpan.length,
  );
  final verbatimCheck = isVerbatimUtf8(
    rawControlSpan,
    0,
    rawControlSpan.length,
  );
  print(
    'Invalid UTF-8 JSON span [0x61, 0x0A (\\n), 0x00 (NUL), 0x22 ("), 0x62]:\n'
    '  isVerbatimUtf8   -> $verbatimCheck (expected false!)\n'
    '  decodeStringUtf8 -> length=${decodedInvalid.length}, codeUnits=${decodedInvalid.codeUnits} (NO FormatException!)',
  );

  // -------------------------------------------------------------------------
  // PROOF 3: generate_report.dart & run_benchmarks.dart Data Loss & Unstable
  // Cell Contamination
  // -------------------------------------------------------------------------
  print(
    '\n--- PROOF 3: codable_benchmarks Data Overwrite & Unstable Cell Inclusion ---',
  );
  // In BENCHMARK_REPORT.md (JS Encode):
  // 10k Coordinates: Tier 0 = 4520.0 us, Tier 1 = 6000.0 us (UNSTABLE ⚠️), Tier 3 = 1252.63 us
  // canada.json:     Tier 0 = 15857.14 us, Tier 1 = 27500.0 us (0.58x regression!), Tier 3 = 8823.53 us
  // citm_catalog:    Tier 0 = 4250.0 us, Tier 1 = 3454.55 us, Tier 3 = 1750.0 us
  // small.json:      Tier 0 = 2.853 us, Tier 1 = 7.441 us (0.38x regression!), Tier 3 = 0.9706 us
  // twitter.json:    Tier 0 = 2700.0 us, Tier 1 = 1520.0 us, Tier 3 = 1269.23 us
  print(
    'JS Encode Tier 1 vs Tier 0 regressions caused by dart-sdk-json-next:\n'
    '  small.json:        Stock=2.85 us -> New=7.44 us (0.38x = 2.61x SLOWER!)\n'
    '    -> Inflates "Codable Speedup vs Tier 1" from 2.94x to 7.67x!\n'
    '  canada.json:       Stock=15.86 ms -> New=27.50 ms (0.58x = 1.73x SLOWER!)\n'
    '    -> Inflates "Codable Speedup vs Tier 1" from 1.80x to 3.12x!\n'
    '  10k Coordinates:   Stock=4.52 ms -> New=6.00 ms (0.75x ⚠️ UNSTABLE)\n'
    '    -> Inflates "Codable Speedup vs Tier 1" from 3.61x to 4.79x ⚠️ (INCLUDED IN GEOMEAN = 3.06x!)',
  );
}
