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

  /// Parsed UTC [DateTime] when [kind] is [TomlDateTimeKind.offsetDateTime] or
  /// [TomlDateTimeKind.localDate], local [DateTime] when [kind] is
  /// [TomlDateTimeKind.localDateTime], or `null` when [kind] is
  /// [TomlDateTimeKind.localTime].
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

/// Driver hook implemented by `TomlCodableEncoder`'s `SingleValueEncoder` so
/// [TomlDateTimeCodec] and [TomlDateTime] codecs can emit unquoted TOML
/// date/time literals while remaining compatible with non-TOML drivers.
abstract interface class TomlNativeDateTimeSink {
  /// Writes an unquoted native TOML date/time literal.
  void writeTomlDateTime(TomlDateTime value);
}

/// Driver hook implemented by `TomlCodableDecoder` and its
/// `SingleValueDecoder` so [TomlDateTimeCodec] and [TomlDateTime] codecs can
/// read parsed [TomlDateTime] metadata directly when decoding from TOML.
abstract interface class TomlNativeDateTimeSource {
  /// Reads a native [TomlDateTime] if the upcoming value is a TOML date/time,
  /// or `null` if it is another kind (such as a quoted ISO-8601 string).
  TomlDateTime? tryReadTomlDateTime();
}

DateTime _parseIsoDateTimeString(String raw) {
  try {
    return DateTime.parse(raw);
  } on FormatException catch (e) {
    throw CodableException(
      'Invalid ISO-8601 DateTime: ${e.message}',
      actualValue: raw,
      underlyingError: e,
    );
  }
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
    if (sv case final TomlNativeDateTimeSource source) {
      final nativeDt = source.tryReadTomlDateTime();
      if (nativeDt != null) {
        final dt = nativeDt.dateTime;
        if (dt != null) return dt;
        throw TomlCodableException(
          'Expected Offset or Local Date-Time for DateTime, got ${nativeDt.kind}',
          actualValue: nativeDt,
        );
      }
    }
    return switch (sv.peekKind()) {
      ValueKind.number => DateTime.fromMillisecondsSinceEpoch(
        sv.readInt(),
        isUtc: true,
      ),
      ValueKind.string => _parseIsoDateTimeString(sv.readString()),
      final kind => throw CodableException(
        'Expected DateTime literal, string, or epoch integer, got $kind',
      ),
    };
  }

  @override
  void encode(DateTime value, Encoder encoder) {
    final sv = encoder.singleValue();
    if (sv case final TomlNativeDateTimeSink sink) {
      sink.writeTomlDateTime(TomlDateTime.fromDateTime(value));
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
    super.actualValue,
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
