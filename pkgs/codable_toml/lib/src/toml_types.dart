// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:codable/codable.dart';

/// The four native TOML v1.0 date/time wire kinds.
enum TomlDateTimeKind {
  /// RFC 3339 date-time with explicit offset (`1979-05-27T07:32:00Z`).
  offsetDateTime,

  /// Local date-time without offset (`1979-05-27T07:32:00`).
  localDateTime,

  /// Calendar date only (`1979-05-27`).
  localDate,

  /// Wall-clock time only (`07:32:00`).
  localTime,
}

/// Preserves exact TOML v1.0 date/time literals across Offset Date-Time,
/// Local Date-Time, Local Date, and Local Time wire forms.
final class TomlDateTime {
  /// The TOML v1.0 date/time kind.
  final TomlDateTimeKind kind;

  /// Canonical unquoted TOML v1.0 literal text (e.g. `1979-05-27T07:32:00Z`).
  final String raw;

  /// Parsed UTC/offset [DateTime] when [kind] is [TomlDateTimeKind.offsetDateTime],
  /// or local [DateTime] for [TomlDateTimeKind.localDateTime] / [TomlDateTimeKind.localDate],
  /// or `null` for [TomlDateTimeKind.localTime].
  final DateTime? dateTime;

  /// Creates a [TomlDateTime] value.
  const TomlDateTime({required this.kind, required this.raw, this.dateTime});

  /// Wraps a UTC or local [DateTime] as an RFC 3339 Offset Date-Time (`...Z`).
  factory TomlDateTime.fromDateTime(DateTime value) {
    final utc = value.toUtc();
    return TomlDateTime(
      kind: TomlDateTimeKind.offsetDateTime,
      raw: utc.toIso8601String(),
      dateTime: utc,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is TomlDateTime && other.kind == kind && other.raw == raw;

  @override
  int get hashCode => Object.hash(kind, raw);

  @override
  String toString() => raw;
}

/// Internal driver hook implemented by `TomlCodableEncoder`'s
/// `SingleValueEncoder` / `Encoder` so [TomlDateTimeCodec] can emit unquoted
/// TOML date/time literals while remaining compatible with non-TOML drivers.
abstract interface class TomlNativeDateTimeSink {
  /// Writes an unquoted native TOML date/time literal.
  void writeTomlDateTime(TomlDateTime value);
}

/// Internal driver hook implemented by `TomlCodableDecoder`'s
/// `SingleValueDecoder` / `Decoder` so [TomlDateTimeCodec] can read parsed
/// [TomlDateTime] metadata directly when decoding from TOML.
abstract interface class TomlNativeDateTimeSource {
  /// Reads a native [TomlDateTime] if the upcoming value is a TOML date/time,
  /// or `null` if it is another kind (such as a quoted ISO-8601 string).
  TomlDateTime? tryReadTomlDateTime();
}

/// Format-adaptive [Codable] companion for [DateTime] that emits native
/// unquoted RFC 3339 Offset Date-Time literals on TOML, ISO-8601 strings on
/// other human-readable formats (JSON/YAML), and epoch milliseconds on binary
/// formats (CBOR/MessagePack).
final class TomlDateTimeCodec implements Codable<DateTime> {
  /// Creates a `const` [TomlDateTimeCodec].
  const TomlDateTimeCodec();

  @override
  DateTime decode(Decoder decoder) {
    final sv = decoder.singleValue();
    if (sv is TomlNativeDateTimeSource) {
      final nativeDt = (sv as TomlNativeDateTimeSource).tryReadTomlDateTime();
      if (nativeDt != null) {
        final dt = nativeDt.dateTime;
        if (dt != null) return dt;
        throw TomlCodableException(
          'Expected Offset or Local Date-Time for DateTime, got ${nativeDt.kind} (${nativeDt.raw})',
        );
      }
    }
    return switch (sv.peekKind()) {
      ValueKind.number => DateTime.fromMillisecondsSinceEpoch(
        sv.readInt(),
        isUtc: true,
      ),
      ValueKind.string => DateTime.parse(sv.readString()),
      final kind => throw CodableException(
        'Expected DateTime literal, string, or epoch integer, got $kind',
      ),
    };
  }

  @override
  void encode(DateTime value, Encoder encoder) {
    final sv = encoder.singleValue();
    if (sv is TomlNativeDateTimeSink) {
      (sv as TomlNativeDateTimeSink).writeTomlDateTime(
        TomlDateTime.fromDateTime(value),
      );
      return;
    }
    if (encoder.isHumanReadable) {
      sv.encodeString(value.toUtc().toIso8601String());
    } else {
      sv.encodeInt(value.toUtc().millisecondsSinceEpoch);
    }
  }
}

/// Diagnostic exception thrown on invalid TOML syntax or structural mismatches.
final class TomlCodableException extends CodableException {
  /// 1-based line number where the error occurred, if available.
  final int? line;

  /// 1-based column number where the error occurred, if available.
  final int? column;

  /// Creates a [TomlCodableException].
  const TomlCodableException(
    super.message, {
    this.line,
    this.column,
    super.path,
    super.underlyingError,
  });

  @override
  String toString() {
    final loc = line != null
        ? ' (line $line${column != null ? ', column $column' : ''})'
        : '';
    return 'TomlCodableException$loc: ${super.toString()}';
  }
}
