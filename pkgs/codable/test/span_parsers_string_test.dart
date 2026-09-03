// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:typed_data';

import 'package:checks/checks.dart';
import 'package:codable/src/json/substrate/mock/span_parsers.dart';
import 'package:test/test.dart';

Uint8List _toUtf8Bytes(String s) => Uint8List.fromList(utf8.encode(s));

/// Helper to wrap bytes in a larger buffer with prefix/suffix offsets.
(Uint8List, int, int) _embedInSlice(Uint8List slice, {int padding = 8}) {
  final full = Uint8List(slice.length + padding * 2);
  full.fillRange(0, padding, 0x20);
  full.setRange(padding, padding + slice.length, slice);
  full.fillRange(padding + slice.length, full.length, 0x20);
  return (full, padding, padding + slice.length);
}

void main() {
  group('decodeStringUtf8 - Pure ASCII Fast-Path', () {
    test('empty string spans', () {
      final bytes = _toUtf8Bytes('test');
      check(decodeStringUtf8(bytes, 0, 0)).equals('');
      check(decodeStringUtf8(bytes, 2, 2)).equals('');
      check(decodeStringUtf8(bytes, 4, 4)).equals('');
      check(decodeStringUtf8(Uint8List(0), 0, 0)).equals('');
    });

    test('single character ASCII strings', () {
      for (var c = 0; c < 128; c++) {
        if (c == 92) continue; // backslash is escape
        final char = String.fromCharCode(c);
        final bytes = Uint8List.fromList([c]);
        check(decodeStringUtf8(bytes, 0, 1)).equals(char);

        final (padded, start, end) = _embedInSlice(bytes);
        check(decodeStringUtf8(padded, start, end)).equals(char);
      }
    });

    test('short ASCII identifiers, timestamps, URLs, and JSON keys', () {
      const candidates = [
        'id',
        'name',
        'created_at',
        'twitterapi',
        'en',
        'GET',
        '2026-09-03T18:40:32Z',
        'https://api.twitter.com/1.1/statuses/show.json?id=210462857140252672',
        '550e8400-e29b-41d4-a716-446655440000',
        'Fri Aug 28 20:05:49 +0000 2026',
        'Coordinates(x=12.34, y=56.78, z=90.12)',
        r'The quick brown fox jumps over the lazy dog 0123456789!@#$%^&*()-_=+',
      ];

      for (final text in candidates) {
        final bytes = _toUtf8Bytes(text);
        check(decodeStringUtf8(bytes, 0, bytes.length)).equals(text);

        final (padded, start, end) = _embedInSlice(bytes);
        check(decodeStringUtf8(padded, start, end)).equals(text);
      }
    });

    test('long pure ASCII payloads (1KB to 16KB)', () {
      final buffer = StringBuffer();
      for (var i = 0; i < 500; i++) {
        buffer.write('Record_$i: status=OK, code=200, latency=1.23ms; ');
      }
      final longAscii = buffer.toString();
      final bytes = _toUtf8Bytes(longAscii);

      check(decodeStringUtf8(bytes, 0, bytes.length)).equals(longAscii);

      final (padded, start, end) = _embedInSlice(bytes, padding: 32);
      check(decodeStringUtf8(padded, start, end)).equals(longAscii);
    });
  });

  group('decodeStringUtf8 - Escaped ASCII Strings', () {
    test('standard JSON escape sequences', () {
      final cases = <String, String>{
        r'\"': '"',
        r'\\': r'\',
        r'\/': '/',
        r'\b': '\b',
        r'\f': '\f',
        r'\n': '\n',
        r'\r': '\r',
        r'\t': '\t',
        r'Hello\nWorld': 'Hello\nWorld',
        r'\"quoted\"': '"quoted"',
        r'path\\to\\file': r'path\to\file',
        r'tab\tseparated\tvalues': 'tab\tseparated\tvalues',
        r'line1\r\nline2': 'line1\r\nline2',
        r'escaped\/slash': 'escaped/slash',
        r'\b\f\n\r\t\"\\\/': '\b\f\n\r\t"\\/',
      };

      for (final entry in cases.entries) {
        final bytes = _toUtf8Bytes(entry.key);
        check(decodeStringUtf8(bytes, 0, bytes.length)).equals(entry.value);

        final (padded, start, end) = _embedInSlice(bytes);
        check(decodeStringUtf8(padded, start, end)).equals(entry.value);
      }
    });

    test('unicode escapes (\\uXXXX)', () {
      final cases = <String, String>{
        r'\u0020': ' ',
        r'\u0041': 'A',
        r'\u0000': '\x00',
        r'\u007F': '\x7F',
        r'\u00E9': 'é',
        r'\u00e9': 'é',
        r'\u03C0': 'π',
        r'\u4e16\u754c': '世界',
        r'Prefix \u0041\u0042\u0043 Suffix': 'Prefix ABC Suffix',
      };

      for (final entry in cases.entries) {
        final bytes = _toUtf8Bytes(entry.key);
        check(decodeStringUtf8(bytes, 0, bytes.length)).equals(entry.value);

        final (padded, start, end) = _embedInSlice(bytes);
        check(decodeStringUtf8(padded, start, end)).equals(entry.value);
      }
    });

    test('surrogate pair unicode escapes', () {
      final cases = <String, String>{
        r'\uD83D\uDE00': '😀',
        r'\uD83D\uDE80': '🚀',
        r'\uD83D\uDD25': '🔥',
        r'\uD83C\uDF89': '🎉',
        r'Rocket: \uD83D\uDE80, Fire: \uD83D\uDD25': 'Rocket: 🚀, Fire: 🔥',
      };

      for (final entry in cases.entries) {
        final bytes = _toUtf8Bytes(entry.key);
        check(decodeStringUtf8(bytes, 0, bytes.length)).equals(entry.value);

        final (padded, start, end) = _embedInSlice(bytes);
        check(decodeStringUtf8(padded, start, end)).equals(entry.value);
      }
    });
  });

  group('decodeStringUtf8 - Multi-byte UTF-8 Sequences', () {
    test('2-byte UTF-8 sequences (Latin-1, Greek, Cyrillic)', () {
      const candidates = [
        'café',
        'résumé',
        'naïve',
        'pi: π, omega: Ω',
        'español y català',
        'Москва, Россия',
        'Ångström unit: 10⁻¹⁰ m',
      ];

      for (final text in candidates) {
        final bytes = _toUtf8Bytes(text);
        check(decodeStringUtf8(bytes, 0, bytes.length)).equals(text);

        final (padded, start, end) = _embedInSlice(bytes);
        check(decodeStringUtf8(padded, start, end)).equals(text);
      }
    });

    test('3-byte UTF-8 sequences (CJK, Devanagari, symbols)', () {
      const candidates = [
        'こんにちは世界',
        '你好，世界！',
        '안녕하세요 세계',
        'नमस्ते दुनिया',
        'Price: 100 € or 15,000 ¥ or 20,000 ₩',
        'Arrows: ← ↑ → ↓ ↔ ↕ ↖ ↗ ↘ ↙',
        'Math: ∀x ∈ ℝ, ∃y : y > x',
      ];

      for (final text in candidates) {
        final bytes = _toUtf8Bytes(text);
        check(decodeStringUtf8(bytes, 0, bytes.length)).equals(text);

        final (padded, start, end) = _embedInSlice(bytes);
        check(decodeStringUtf8(padded, start, end)).equals(text);
      }
    });

    test('4-byte UTF-8 sequences (Emojis, Musical symbols)', () {
      const candidates = [
        '👋 Hello 🚀 Dart 🎯 Wasm 🔥',
        '🎉 🐱 👍🏽 𝄞 𠮷野家',
        'Multi-emoji: 👨‍👩‍👧‍👦 🏳️‍🌈',
      ];

      for (final text in candidates) {
        final bytes = _toUtf8Bytes(text);
        check(decodeStringUtf8(bytes, 0, bytes.length)).equals(text);

        final (padded, start, end) = _embedInSlice(bytes);
        check(decodeStringUtf8(padded, start, end)).equals(text);
      }
    });

    test('mixed multi-byte, ASCII, and escape sequences', () {
      final cases = <String, String>{
        r'Hello \uD83D\uDE00! Welcome to café \n Price: 50€':
            'Hello 😀! Welcome to café \n Price: 50€',
        r'Line1: Москва\tLine2: 東京\r\nLine3: 🚀':
            'Line1: Москва\tLine2: 東京\r\nLine3: 🚀',
        r'\"Quotes\" and \u4e16\u754c in JSON': '"Quotes" and 世界 in JSON',
      };

      for (final entry in cases.entries) {
        final bytes = _toUtf8Bytes(entry.key);
        check(decodeStringUtf8(bytes, 0, bytes.length)).equals(entry.value);

        final (padded, start, end) = _embedInSlice(bytes);
        check(decodeStringUtf8(padded, start, end)).equals(entry.value);
      }
    });
  });

  group('decodeStringUtf8 - Error Handling and Boundary Edge Cases', () {
    test('throws RangeError on invalid byte span indices', () {
      final bytes = _toUtf8Bytes('valid string');

      check(() => decodeStringUtf8(bytes, -1, 5)).throws<RangeError>();
      check(() => decodeStringUtf8(bytes, 0, 20)).throws<RangeError>();
      check(() => decodeStringUtf8(bytes, 8, 4)).throws<RangeError>();
      check(() => decodeStringUtf8(bytes, -1, -1)).throws<RangeError>();
      check(() => decodeStringUtf8(bytes, 20, 20)).throws<RangeError>();
      check(() => decodeStringUtf8(bytes, -5, -2)).throws<RangeError>();
    });

    test('throws FormatException on incomplete escape sequences', () {
      final trailingSlash = _toUtf8Bytes(r'hello\');
      check(() => decodeStringUtf8(trailingSlash, 0, trailingSlash.length))
          .throws<FormatException>();

      final incompleteUnicode = _toUtf8Bytes(r'hello\u00');
      check(
        () => decodeStringUtf8(incompleteUnicode, 0, incompleteUnicode.length),
      ).throws<FormatException>();

      final incompleteSurrogate = _toUtf8Bytes(r'\uD83D\u');
      check(
        () => decodeStringUtf8(
          incompleteSurrogate,
          0,
          incompleteSurrogate.length,
        ),
      ).throws<FormatException>();
    });

    test('throws FormatException on invalid escape characters', () {
      final invalidEscape = _toUtf8Bytes(r'hello\qworld');
      check(() => decodeStringUtf8(invalidEscape, 0, invalidEscape.length))
          .throws<FormatException>();
    });

    test('throws FormatException on invalid hex in unicode escape', () {
      final invalidHex = _toUtf8Bytes(r'\u00G1');
      check(() => decodeStringUtf8(invalidHex, 0, invalidHex.length))
          .throws<FormatException>();
    });

    test('handles unpaired and non-surrogate escapes correctly', () {
      // Unpaired high surrogate
      final highSurrogate = _toUtf8Bytes(r'\uD800');
      check(decodeStringUtf8(highSurrogate, 0, highSurrogate.length))
          .equals('\uD800');

      // Unpaired low surrogate
      final lowSurrogate = _toUtf8Bytes(r'\uDC00');
      check(decodeStringUtf8(lowSurrogate, 0, lowSurrogate.length))
          .equals('\uDC00');

      // High surrogate followed by non-surrogate unicode escape
      final highFollowedBySpace = _toUtf8Bytes(r'\uD83D\u0020');
      check(
        decodeStringUtf8(highFollowedBySpace, 0, highFollowedBySpace.length),
      ).equals('\uD83D ');

      // High surrogate followed by standard escape
      final highFollowedByNewline = _toUtf8Bytes(r'\uD83D\n');
      check(
        decodeStringUtf8(
          highFollowedByNewline,
          0,
          highFollowedByNewline.length,
        ),
      ).equals('\uD83D\n');

      // High surrogate followed by ASCII character
      final highFollowedByAscii = _toUtf8Bytes(r'\uD83Dabc');
      check(
        decodeStringUtf8(highFollowedByAscii, 0, highFollowedByAscii.length),
      ).equals('\uD83Dabc');
    });

    test('handles allowMalformed on truncated multi-byte UTF-8 sequences', () {
      // 0xE4 0xB8 is truncated 3-byte sequence (missing 3rd byte)
      final truncated3Byte = Uint8List.fromList([0x41, 0x5C, 0x6E, 0xE4, 0xB8]);
      // Should throw when allowMalformed is false
      check(
        () => decodeStringUtf8(
          truncated3Byte,
          0,
          truncated3Byte.length,
          allowMalformed: false,
        ),
      ).throws<FormatException>();

      // Should insert replacement char when allowMalformed is true
      final decoded = decodeStringUtf8(
        truncated3Byte,
        0,
        truncated3Byte.length,
        allowMalformed: true,
      );
      check(decoded).equals('A\n\uFFFD\uFFFD');
    });
  });

  group('decodeStringUtf8 - Bit-Exact Parity with jsonDecode', () {
    test('matches jsonDecode across diverse JSON strings', () {
      final testStrings = [
        '',
        'a',
        'hello world',
        '1234567890',
        'https://example.com/api?q=dart&lang=en#frag',
        r'Special chars: !@#$%^&*()_+-=[]{}|;:<>?,./~`',
        'Escapes: "double" \\backslash\\ /slash/ \b \f \n \r \t',
        'Unicode: \u0000 \u001F \u007F \u0080 \u00FF',
        'Accents: é à è ù â ê î ô û ä ë ï ö ü ñ ç',
        'Non-Latin: Ελληνικά, Русский, עברית, العربية',
        'CJK: 漢字, ひらがな, カタカナ, 한국어',
        'Symbols & Emojis: ⚡ 🚀 🔥 💡 🎯 🛠️ 📦 ✨ 🏆 𝄞',
        'Complex mixed: "Title: \\"Dart 3.0\\" — 🚀 with 100% café efficiency!"',
      ];

      for (final raw in testStrings) {
        final jsonEncoded = jsonEncode(raw);
        // Strip the enclosing quotes to get the raw unquoted string span bytes
        // in JSON
        final innerJson = jsonEncoded.substring(1, jsonEncoded.length - 1);
        final spanBytes = _toUtf8Bytes(innerJson);

        final expected = jsonDecode(jsonEncoded) as String;
        final actual = decodeStringUtf8(spanBytes, 0, spanBytes.length);

        check(actual).equals(expected);
      }
    });
  });
}
