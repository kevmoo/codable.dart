// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: lines_longer_than_80_chars, unnecessary_lambdas, deprecated_member_use, unused_element

part of 'cross_format_test.dart';

// **************************************************************************
// CodableGenerator
// **************************************************************************

// =============================================================================
// 1. Unified Schema Descriptor for AllOptionalPatch
// =============================================================================
extension type const _$AllOptionalPatchSchema(int _value) {
  // String Name Constants
  static const String nameAlpha = 'alpha';
  static const String nameBeta = 'beta';
  static const String nameGamma = 'gamma';

  // Key Indices for selectKeyIndex()
  static const int keyAlpha = 0;
  static const int keyBeta = 1;
  static const int keyGamma = 2;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
    _$AllOptionalPatchSchema.nameAlpha,
    _$AllOptionalPatchSchema.nameBeta,
    _$AllOptionalPatchSchema.nameGamma,
  ]);
  static final KeyOptions keyOptions = options;

  // Bitmask Flags strictly for Required Fields
  static const _$AllOptionalPatchSchema none = _$AllOptionalPatchSchema(0);

  @pragma('vm:prefer-inline')
  _$AllOptionalPatchSchema operator |(_$AllOptionalPatchSchema other) =>
      _$AllOptionalPatchSchema(_value | other._value);

  /// Validates required fields in 1 CPU test instruction on the fast path.
  @pragma('vm:prefer-inline')
  void validate() {}
}

// =============================================================================
// 2. Companion Codable for AllOptionalPatch
// =============================================================================
final class AllOptionalPatchCodable implements Codable<AllOptionalPatch> {
  const AllOptionalPatchCodable();

  @override
  AllOptionalPatch decode(Decoder decoder) {
    final keyed = decoder.keyed(options: _$AllOptionalPatchSchema.keyOptions);

    int? alpha;
    String? beta;
    bool? gamma;
    var seen = _$AllOptionalPatchSchema.none;

    while (keyed.moveNextKey()) {
      switch (keyed.selectKeyIndex(_$AllOptionalPatchSchema.keyOptions)) {
        case _$AllOptionalPatchSchema.keyAlpha:
          if (keyed.isNextNull()) {
            keyed.readNull();
            alpha = null;
          } else {
            alpha = keyed.readInt();
          }
          break;
        case _$AllOptionalPatchSchema.keyBeta:
          if (keyed.isNextNull()) {
            keyed.readNull();
            beta = null;
          } else {
            beta = keyed.readString();
          }
          break;
        case _$AllOptionalPatchSchema.keyGamma:
          if (keyed.isNextNull()) {
            keyed.readNull();
            gamma = null;
          } else {
            gamma = keyed.readBool();
          }
          break;
        default:
          keyed.skipValue();
          break;
      }
    }

    // Inlined fast-path check
    seen.validate();

    return AllOptionalPatch(alpha: alpha, beta: beta, gamma: gamma);
  }

  @override
  void encode(AllOptionalPatch instance, Encoder encoder) {
    var count$ = 0;
    final v$Alpha = instance.alpha;
    if (v$Alpha != null) count$++;
    final v$Beta = instance.beta;
    if (v$Beta != null) count$++;
    final v$Gamma = instance.gamma;
    if (v$Gamma != null) count$++;
    final keyed = encoder.keyed(length: count$);
    if (v$Alpha != null) {
      keyed.encodeInt(_$AllOptionalPatchSchema.nameAlpha, v$Alpha);
    }
    if (v$Beta != null) {
      keyed.encodeString(_$AllOptionalPatchSchema.nameBeta, v$Beta);
    }
    if (v$Gamma != null) {
      keyed.encodeBool(_$AllOptionalPatchSchema.nameGamma, v$Gamma);
    }
  }
}

// =============================================================================
// 1. Unified Schema Descriptor for WideNullableRecord
// =============================================================================
extension type const _$WideNullableRecordSchema(int _value) {
  // String Name Constants
  static const String nameF01 = 'f01';
  static const String nameF02 = 'f02';
  static const String nameF03 = 'f03';
  static const String nameF04 = 'f04';
  static const String nameF05 = 'f05';
  static const String nameF06 = 'f06';
  static const String nameF07 = 'f07';
  static const String nameF08 = 'f08';
  static const String nameF09 = 'f09';
  static const String nameF10 = 'f10';
  static const String nameF11 = 'f11';
  static const String nameF12 = 'f12';
  static const String nameF13 = 'f13';
  static const String nameF14 = 'f14';
  static const String nameF15 = 'f15';
  static const String nameF16 = 'f16';
  static const String nameF17 = 'f17';
  static const String nameF18 = 'f18';
  static const String nameF19 = 'f19';
  static const String nameF20 = 'f20';

  // Key Indices for selectKeyIndex()
  static const int keyF01 = 0;
  static const int keyF02 = 1;
  static const int keyF03 = 2;
  static const int keyF04 = 3;
  static const int keyF05 = 4;
  static const int keyF06 = 5;
  static const int keyF07 = 6;
  static const int keyF08 = 7;
  static const int keyF09 = 8;
  static const int keyF10 = 9;
  static const int keyF11 = 10;
  static const int keyF12 = 11;
  static const int keyF13 = 12;
  static const int keyF14 = 13;
  static const int keyF15 = 14;
  static const int keyF16 = 15;
  static const int keyF17 = 16;
  static const int keyF18 = 17;
  static const int keyF19 = 18;
  static const int keyF20 = 19;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
    _$WideNullableRecordSchema.nameF01,
    _$WideNullableRecordSchema.nameF02,
    _$WideNullableRecordSchema.nameF03,
    _$WideNullableRecordSchema.nameF04,
    _$WideNullableRecordSchema.nameF05,
    _$WideNullableRecordSchema.nameF06,
    _$WideNullableRecordSchema.nameF07,
    _$WideNullableRecordSchema.nameF08,
    _$WideNullableRecordSchema.nameF09,
    _$WideNullableRecordSchema.nameF10,
    _$WideNullableRecordSchema.nameF11,
    _$WideNullableRecordSchema.nameF12,
    _$WideNullableRecordSchema.nameF13,
    _$WideNullableRecordSchema.nameF14,
    _$WideNullableRecordSchema.nameF15,
    _$WideNullableRecordSchema.nameF16,
    _$WideNullableRecordSchema.nameF17,
    _$WideNullableRecordSchema.nameF18,
    _$WideNullableRecordSchema.nameF19,
    _$WideNullableRecordSchema.nameF20,
  ]);
  static final KeyOptions keyOptions = options;

  // Bitmask Flags strictly for Required Fields
  static const _$WideNullableRecordSchema none = _$WideNullableRecordSchema(0);
  static const int _f01Bit = 1 << 0;
  static const _$WideNullableRecordSchema f01 = _$WideNullableRecordSchema(
    _f01Bit,
  );
  static const int _f02Bit = 1 << 1;
  static const _$WideNullableRecordSchema f02 = _$WideNullableRecordSchema(
    _f02Bit,
  );
  static const int _f03Bit = 1 << 2;
  static const _$WideNullableRecordSchema f03 = _$WideNullableRecordSchema(
    _f03Bit,
  );
  static const int _f04Bit = 1 << 3;
  static const _$WideNullableRecordSchema f04 = _$WideNullableRecordSchema(
    _f04Bit,
  );

  // Combined Golden Bitmask for fast single-instruction check
  static const _$WideNullableRecordSchema golden = _$WideNullableRecordSchema(
    _f01Bit | _f02Bit | _f03Bit | _f04Bit,
  );

  @pragma('vm:prefer-inline')
  _$WideNullableRecordSchema operator |(_$WideNullableRecordSchema other) =>
      _$WideNullableRecordSchema(_value | other._value);

  /// Validates required fields in 1 CPU test instruction on the fast path.
  @pragma('vm:prefer-inline')
  void validate() {
    if ((_value & golden._value) != golden._value) {
      _throwMissingFields();
    }
  }

  /// Out-of-line cold diagnostic reporting
  void _throwMissingFields() {
    final missing = <String>[];
    if ((_value & _f01Bit) == 0) {
      missing.add(nameF01);
    }
    if ((_value & _f02Bit) == 0) {
      missing.add(nameF02);
    }
    if ((_value & _f03Bit) == 0) {
      missing.add(nameF03);
    }
    if ((_value & _f04Bit) == 0) {
      missing.add(nameF04);
    }
    throw CodableException(
      'Missing required fields for WideNullableRecord: ${missing.join(", ")}',
    );
  }
}

// =============================================================================
// 2. Companion Codable for WideNullableRecord
// =============================================================================
final class WideNullableRecordCodable implements Codable<WideNullableRecord> {
  const WideNullableRecordCodable();

  @override
  WideNullableRecord decode(Decoder decoder) {
    final keyed = decoder.keyed(options: _$WideNullableRecordSchema.keyOptions);

    int? f01;
    String? f02;
    bool? f03;
    double? f04;
    int? f05;
    int? f06;
    int? f07;
    int? f08;
    String? f09;
    String? f10;
    String? f11;
    String? f12;
    bool? f13;
    bool? f14;
    double? f15;
    double? f16;
    int? f17;
    String? f18;
    bool? f19;
    int? f20;
    var seen = _$WideNullableRecordSchema.none;

    while (keyed.moveNextKey()) {
      switch (keyed.selectKeyIndex(_$WideNullableRecordSchema.keyOptions)) {
        case _$WideNullableRecordSchema.keyF01:
          if ((seen._value & _$WideNullableRecordSchema.f01._value) != 0) {
            throw const CodableException('Duplicate field "f01"');
          }
          f01 = keyed.readInt();
          seen |= _$WideNullableRecordSchema.f01;
          break;
        case _$WideNullableRecordSchema.keyF02:
          if ((seen._value & _$WideNullableRecordSchema.f02._value) != 0) {
            throw const CodableException('Duplicate field "f02"');
          }
          f02 = keyed.readString();
          seen |= _$WideNullableRecordSchema.f02;
          break;
        case _$WideNullableRecordSchema.keyF03:
          if ((seen._value & _$WideNullableRecordSchema.f03._value) != 0) {
            throw const CodableException('Duplicate field "f03"');
          }
          f03 = keyed.readBool();
          seen |= _$WideNullableRecordSchema.f03;
          break;
        case _$WideNullableRecordSchema.keyF04:
          if ((seen._value & _$WideNullableRecordSchema.f04._value) != 0) {
            throw const CodableException('Duplicate field "f04"');
          }
          f04 = keyed.readDouble();
          seen |= _$WideNullableRecordSchema.f04;
          break;
        case _$WideNullableRecordSchema.keyF05:
          if (keyed.isNextNull()) {
            keyed.readNull();
            f05 = null;
          } else {
            f05 = keyed.readInt();
          }
          break;
        case _$WideNullableRecordSchema.keyF06:
          if (keyed.isNextNull()) {
            keyed.readNull();
            f06 = null;
          } else {
            f06 = keyed.readInt();
          }
          break;
        case _$WideNullableRecordSchema.keyF07:
          if (keyed.isNextNull()) {
            keyed.readNull();
            f07 = null;
          } else {
            f07 = keyed.readInt();
          }
          break;
        case _$WideNullableRecordSchema.keyF08:
          if (keyed.isNextNull()) {
            keyed.readNull();
            f08 = null;
          } else {
            f08 = keyed.readInt();
          }
          break;
        case _$WideNullableRecordSchema.keyF09:
          if (keyed.isNextNull()) {
            keyed.readNull();
            f09 = null;
          } else {
            f09 = keyed.readString();
          }
          break;
        case _$WideNullableRecordSchema.keyF10:
          if (keyed.isNextNull()) {
            keyed.readNull();
            f10 = null;
          } else {
            f10 = keyed.readString();
          }
          break;
        case _$WideNullableRecordSchema.keyF11:
          if (keyed.isNextNull()) {
            keyed.readNull();
            f11 = null;
          } else {
            f11 = keyed.readString();
          }
          break;
        case _$WideNullableRecordSchema.keyF12:
          if (keyed.isNextNull()) {
            keyed.readNull();
            f12 = null;
          } else {
            f12 = keyed.readString();
          }
          break;
        case _$WideNullableRecordSchema.keyF13:
          if (keyed.isNextNull()) {
            keyed.readNull();
            f13 = null;
          } else {
            f13 = keyed.readBool();
          }
          break;
        case _$WideNullableRecordSchema.keyF14:
          if (keyed.isNextNull()) {
            keyed.readNull();
            f14 = null;
          } else {
            f14 = keyed.readBool();
          }
          break;
        case _$WideNullableRecordSchema.keyF15:
          if (keyed.isNextNull()) {
            keyed.readNull();
            f15 = null;
          } else {
            f15 = keyed.readDouble();
          }
          break;
        case _$WideNullableRecordSchema.keyF16:
          if (keyed.isNextNull()) {
            keyed.readNull();
            f16 = null;
          } else {
            f16 = keyed.readDouble();
          }
          break;
        case _$WideNullableRecordSchema.keyF17:
          if (keyed.isNextNull()) {
            keyed.readNull();
            f17 = null;
          } else {
            f17 = keyed.readInt();
          }
          break;
        case _$WideNullableRecordSchema.keyF18:
          if (keyed.isNextNull()) {
            keyed.readNull();
            f18 = null;
          } else {
            f18 = keyed.readString();
          }
          break;
        case _$WideNullableRecordSchema.keyF19:
          if (keyed.isNextNull()) {
            keyed.readNull();
            f19 = null;
          } else {
            f19 = keyed.readBool();
          }
          break;
        case _$WideNullableRecordSchema.keyF20:
          if (keyed.isNextNull()) {
            keyed.readNull();
            f20 = null;
          } else {
            f20 = keyed.readInt();
          }
          break;
        default:
          keyed.skipValue();
          break;
      }
    }

    // Inlined fast-path check
    seen.validate();

    return WideNullableRecord(
      f01: f01!,
      f02: f02!,
      f03: f03!,
      f04: f04!,
      f05: f05,
      f06: f06,
      f07: f07,
      f08: f08,
      f09: f09,
      f10: f10,
      f11: f11,
      f12: f12,
      f13: f13,
      f14: f14,
      f15: f15,
      f16: f16,
      f17: f17,
      f18: f18,
      f19: f19,
      f20: f20,
    );
  }

  @override
  void encode(WideNullableRecord instance, Encoder encoder) {
    var count$ = 4;
    final v$F05 = instance.f05;
    if (v$F05 != null) count$++;
    final v$F06 = instance.f06;
    if (v$F06 != null) count$++;
    final v$F07 = instance.f07;
    if (v$F07 != null) count$++;
    final v$F08 = instance.f08;
    if (v$F08 != null) count$++;
    final v$F09 = instance.f09;
    if (v$F09 != null) count$++;
    final v$F10 = instance.f10;
    if (v$F10 != null) count$++;
    final v$F11 = instance.f11;
    if (v$F11 != null) count$++;
    final v$F12 = instance.f12;
    if (v$F12 != null) count$++;
    final v$F13 = instance.f13;
    if (v$F13 != null) count$++;
    final v$F14 = instance.f14;
    if (v$F14 != null) count$++;
    final v$F15 = instance.f15;
    if (v$F15 != null) count$++;
    final v$F16 = instance.f16;
    if (v$F16 != null) count$++;
    final v$F17 = instance.f17;
    if (v$F17 != null) count$++;
    final v$F18 = instance.f18;
    if (v$F18 != null) count$++;
    final v$F19 = instance.f19;
    if (v$F19 != null) count$++;
    final v$F20 = instance.f20;
    if (v$F20 != null) count$++;
    final keyed = encoder.keyed(length: count$);
    keyed.encodeInt(_$WideNullableRecordSchema.nameF01, instance.f01);
    keyed.encodeString(_$WideNullableRecordSchema.nameF02, instance.f02);
    keyed.encodeBool(_$WideNullableRecordSchema.nameF03, instance.f03);
    keyed.encodeDouble(_$WideNullableRecordSchema.nameF04, instance.f04);
    if (v$F05 != null) {
      keyed.encodeInt(_$WideNullableRecordSchema.nameF05, v$F05);
    }
    if (v$F06 != null) {
      keyed.encodeInt(_$WideNullableRecordSchema.nameF06, v$F06);
    }
    if (v$F07 != null) {
      keyed.encodeInt(_$WideNullableRecordSchema.nameF07, v$F07);
    }
    if (v$F08 != null) {
      keyed.encodeInt(_$WideNullableRecordSchema.nameF08, v$F08);
    }
    if (v$F09 != null) {
      keyed.encodeString(_$WideNullableRecordSchema.nameF09, v$F09);
    }
    if (v$F10 != null) {
      keyed.encodeString(_$WideNullableRecordSchema.nameF10, v$F10);
    }
    if (v$F11 != null) {
      keyed.encodeString(_$WideNullableRecordSchema.nameF11, v$F11);
    }
    if (v$F12 != null) {
      keyed.encodeString(_$WideNullableRecordSchema.nameF12, v$F12);
    }
    if (v$F13 != null) {
      keyed.encodeBool(_$WideNullableRecordSchema.nameF13, v$F13);
    }
    if (v$F14 != null) {
      keyed.encodeBool(_$WideNullableRecordSchema.nameF14, v$F14);
    }
    if (v$F15 != null) {
      keyed.encodeDouble(_$WideNullableRecordSchema.nameF15, v$F15);
    }
    if (v$F16 != null) {
      keyed.encodeDouble(_$WideNullableRecordSchema.nameF16, v$F16);
    }
    if (v$F17 != null) {
      keyed.encodeInt(_$WideNullableRecordSchema.nameF17, v$F17);
    }
    if (v$F18 != null) {
      keyed.encodeString(_$WideNullableRecordSchema.nameF18, v$F18);
    }
    if (v$F19 != null) {
      keyed.encodeBool(_$WideNullableRecordSchema.nameF19, v$F19);
    }
    if (v$F20 != null) {
      keyed.encodeInt(_$WideNullableRecordSchema.nameF20, v$F20);
    }
  }
}

// =============================================================================
// 1. Unified Schema Descriptor for NestedMeta
// =============================================================================
extension type const _$NestedMetaSchema(int _value) {
  // String Name Constants
  static const String nameRegion = 'region';
  static const String nameRevision = 'revision';
  static const String nameNote = 'note';

  // Key Indices for selectKeyIndex()
  static const int keyRegion = 0;
  static const int keyRevision = 1;
  static const int keyNote = 2;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
    _$NestedMetaSchema.nameRegion,
    _$NestedMetaSchema.nameRevision,
    _$NestedMetaSchema.nameNote,
  ]);
  static final KeyOptions keyOptions = options;

  // Bitmask Flags strictly for Required Fields
  static const _$NestedMetaSchema none = _$NestedMetaSchema(0);
  static const int _regionBit = 1 << 0;
  static const _$NestedMetaSchema region = _$NestedMetaSchema(_regionBit);
  static const int _revisionBit = 1 << 1;
  static const _$NestedMetaSchema revision = _$NestedMetaSchema(_revisionBit);

  // Combined Golden Bitmask for fast single-instruction check
  static const _$NestedMetaSchema golden = _$NestedMetaSchema(
    _regionBit | _revisionBit,
  );

  @pragma('vm:prefer-inline')
  _$NestedMetaSchema operator |(_$NestedMetaSchema other) =>
      _$NestedMetaSchema(_value | other._value);

  /// Validates required fields in 1 CPU test instruction on the fast path.
  @pragma('vm:prefer-inline')
  void validate() {
    if ((_value & golden._value) != golden._value) {
      _throwMissingFields();
    }
  }

  /// Out-of-line cold diagnostic reporting
  void _throwMissingFields() {
    final missing = <String>[];
    if ((_value & _regionBit) == 0) {
      missing.add(nameRegion);
    }
    if ((_value & _revisionBit) == 0) {
      missing.add(nameRevision);
    }
    throw CodableException(
      'Missing required fields for NestedMeta: ${missing.join(", ")}',
    );
  }
}

// =============================================================================
// 2. Companion Codable for NestedMeta
// =============================================================================
final class NestedMetaCodable implements Codable<NestedMeta> {
  const NestedMetaCodable();

  @override
  NestedMeta decode(Decoder decoder) {
    final keyed = decoder.keyed(options: _$NestedMetaSchema.keyOptions);

    String? region;
    int? revision;
    String? note;
    var seen = _$NestedMetaSchema.none;

    while (keyed.moveNextKey()) {
      switch (keyed.selectKeyIndex(_$NestedMetaSchema.keyOptions)) {
        case _$NestedMetaSchema.keyRegion:
          if ((seen._value & _$NestedMetaSchema.region._value) != 0) {
            throw const CodableException('Duplicate field "region"');
          }
          region = keyed.readString();
          seen |= _$NestedMetaSchema.region;
          break;
        case _$NestedMetaSchema.keyRevision:
          if ((seen._value & _$NestedMetaSchema.revision._value) != 0) {
            throw const CodableException('Duplicate field "revision"');
          }
          revision = keyed.readInt();
          seen |= _$NestedMetaSchema.revision;
          break;
        case _$NestedMetaSchema.keyNote:
          if (keyed.isNextNull()) {
            keyed.readNull();
            note = null;
          } else {
            note = keyed.readString();
          }
          break;
        default:
          keyed.skipValue();
          break;
      }
    }

    // Inlined fast-path check
    seen.validate();

    return NestedMeta(region: region!, revision: revision!, note: note);
  }

  @override
  void encode(NestedMeta instance, Encoder encoder) {
    var count$ = 2;
    final v$Note = instance.note;
    if (v$Note != null) count$++;
    final keyed = encoder.keyed(length: count$);
    keyed.encodeString(_$NestedMetaSchema.nameRegion, instance.region);
    keyed.encodeInt(_$NestedMetaSchema.nameRevision, instance.revision);
    if (v$Note != null) {
      keyed.encodeString(_$NestedMetaSchema.nameNote, v$Note);
    }
  }
}

// =============================================================================
// 1. Unified Schema Descriptor for CrossFormatEnvelope
// =============================================================================
extension type const _$CrossFormatEnvelopeSchema(int _value) {
  // String Name Constants
  static const String nameId = 'id';
  static const String namePrimaryMeta = 'primaryMeta';
  static const String nameBackupMeta = 'backupMeta';
  static const String nameHistory = 'history';
  static const String nameTags = 'tags';
  static const String namePorts = 'ports';
  static const String namePayload = 'payload';
  static const String nameSignature = 'signature';
  static const String nameSamples = 'samples';
  static const String nameCounters = 'counters';
  static const String nameStatusLabels = 'statusLabels';
  static const String nameQuotas = 'quotas';
  static const String namePrimaryMetric = 'primaryMetric';
  static const String nameSecondaryMetric = 'secondaryMetric';
  static const String nameOptionalMetric = 'optionalMetric';

  // Key Indices for selectKeyIndex()
  static const int keyId = 0;
  static const int keyPrimaryMeta = 1;
  static const int keyBackupMeta = 2;
  static const int keyHistory = 3;
  static const int keyTags = 4;
  static const int keyPorts = 5;
  static const int keyPayload = 6;
  static const int keySignature = 7;
  static const int keySamples = 8;
  static const int keyCounters = 9;
  static const int keyStatusLabels = 10;
  static const int keyQuotas = 11;
  static const int keyPrimaryMetric = 12;
  static const int keySecondaryMetric = 13;
  static const int keyOptionalMetric = 14;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
    _$CrossFormatEnvelopeSchema.nameId,
    _$CrossFormatEnvelopeSchema.namePrimaryMeta,
    _$CrossFormatEnvelopeSchema.nameBackupMeta,
    _$CrossFormatEnvelopeSchema.nameHistory,
    _$CrossFormatEnvelopeSchema.nameTags,
    _$CrossFormatEnvelopeSchema.namePorts,
    _$CrossFormatEnvelopeSchema.namePayload,
    _$CrossFormatEnvelopeSchema.nameSignature,
    _$CrossFormatEnvelopeSchema.nameSamples,
    _$CrossFormatEnvelopeSchema.nameCounters,
    _$CrossFormatEnvelopeSchema.nameStatusLabels,
    _$CrossFormatEnvelopeSchema.nameQuotas,
    _$CrossFormatEnvelopeSchema.namePrimaryMetric,
    _$CrossFormatEnvelopeSchema.nameSecondaryMetric,
    _$CrossFormatEnvelopeSchema.nameOptionalMetric,
  ]);
  static final KeyOptions keyOptions = options;

  // Enum Options for RouteMethod
  static final KeyOptions enumRouteMethodKeyOptions = KeyOptions.of(const [
    'get',
    'post',
    'put',
    'delete',
  ]);

  // Bitmask Flags strictly for Required Fields
  static const _$CrossFormatEnvelopeSchema none = _$CrossFormatEnvelopeSchema(
    0,
  );
  static const int _idBit = 1 << 0;
  static const _$CrossFormatEnvelopeSchema id = _$CrossFormatEnvelopeSchema(
    _idBit,
  );
  static const int _primaryMetaBit = 1 << 1;
  static const _$CrossFormatEnvelopeSchema primaryMeta =
      _$CrossFormatEnvelopeSchema(_primaryMetaBit);
  static const int _payloadBit = 1 << 2;
  static const _$CrossFormatEnvelopeSchema payload =
      _$CrossFormatEnvelopeSchema(_payloadBit);
  static const int _samplesBit = 1 << 3;
  static const _$CrossFormatEnvelopeSchema samples =
      _$CrossFormatEnvelopeSchema(_samplesBit);
  static const int _primaryMetricBit = 1 << 4;
  static const _$CrossFormatEnvelopeSchema primaryMetric =
      _$CrossFormatEnvelopeSchema(_primaryMetricBit);
  static const int _secondaryMetricBit = 1 << 5;
  static const _$CrossFormatEnvelopeSchema secondaryMetric =
      _$CrossFormatEnvelopeSchema(_secondaryMetricBit);

  // Combined Golden Bitmask for fast single-instruction check
  static const _$CrossFormatEnvelopeSchema golden = _$CrossFormatEnvelopeSchema(
    _idBit |
        _primaryMetaBit |
        _payloadBit |
        _samplesBit |
        _primaryMetricBit |
        _secondaryMetricBit,
  );

  @pragma('vm:prefer-inline')
  _$CrossFormatEnvelopeSchema operator |(_$CrossFormatEnvelopeSchema other) =>
      _$CrossFormatEnvelopeSchema(_value | other._value);

  /// Validates required fields in 1 CPU test instruction on the fast path.
  @pragma('vm:prefer-inline')
  void validate() {
    if ((_value & golden._value) != golden._value) {
      _throwMissingFields();
    }
  }

  /// Out-of-line cold diagnostic reporting
  void _throwMissingFields() {
    final missing = <String>[];
    if ((_value & _idBit) == 0) {
      missing.add(nameId);
    }
    if ((_value & _primaryMetaBit) == 0) {
      missing.add(namePrimaryMeta);
    }
    if ((_value & _payloadBit) == 0) {
      missing.add(namePayload);
    }
    if ((_value & _samplesBit) == 0) {
      missing.add(nameSamples);
    }
    if ((_value & _primaryMetricBit) == 0) {
      missing.add(namePrimaryMetric);
    }
    if ((_value & _secondaryMetricBit) == 0) {
      missing.add(nameSecondaryMetric);
    }
    throw CodableException(
      'Missing required fields for CrossFormatEnvelope: ${missing.join(", ")}',
    );
  }
}

// =============================================================================
// 2. Companion Codable for CrossFormatEnvelope
// =============================================================================
final class CrossFormatEnvelopeCodable implements Codable<CrossFormatEnvelope> {
  const CrossFormatEnvelopeCodable();

  @override
  CrossFormatEnvelope decode(Decoder decoder) {
    final keyed = decoder.keyed(
      options: _$CrossFormatEnvelopeSchema.keyOptions,
    );

    String? id;
    NestedMeta? primaryMeta;
    NestedMeta? backupMeta;
    var history = const <NestedMeta>[];
    var tags = const <String>{};
    var ports = const <int>{};
    Uint8List? payload;
    Uint8List? signature;
    Float64List? samples;
    var counters = const <String, int>{};
    var statusLabels = const <int, String>{};
    var quotas = const <RouteMethod, int>{};
    num? primaryMetric;
    num? secondaryMetric;
    num? optionalMetric;
    var seen = _$CrossFormatEnvelopeSchema.none;

    while (keyed.moveNextKey()) {
      switch (keyed.selectKeyIndex(_$CrossFormatEnvelopeSchema.keyOptions)) {
        case _$CrossFormatEnvelopeSchema.keyId:
          if ((seen._value & _$CrossFormatEnvelopeSchema.id._value) != 0) {
            throw const CodableException('Duplicate field "id"');
          }
          id = keyed.readString();
          seen |= _$CrossFormatEnvelopeSchema.id;
          break;
        case _$CrossFormatEnvelopeSchema.keyPrimaryMeta:
          if ((seen._value & _$CrossFormatEnvelopeSchema.primaryMeta._value) !=
              0) {
            throw const CodableException('Duplicate field "primaryMeta"');
          }
          primaryMeta = const NestedMetaCodable().decode(keyed.nestedDecoder());
          seen |= _$CrossFormatEnvelopeSchema.primaryMeta;
          break;
        case _$CrossFormatEnvelopeSchema.keyBackupMeta:
          if (keyed.isNextNull()) {
            keyed.readNull();
            backupMeta = null;
          } else {
            backupMeta = const NestedMetaCodable().decode(
              keyed.nestedDecoder(),
            );
          }
          break;
        case _$CrossFormatEnvelopeSchema.keyHistory:
          history = const NestedMetaCodable().decodeList(keyed.nestedDecoder());
          break;
        case _$CrossFormatEnvelopeSchema.keyTags:
          tags = keyed.decodeStringList().toSet();
          break;
        case _$CrossFormatEnvelopeSchema.keyPorts:
          ports = keyed.decodeIntList().toSet();
          break;
        case _$CrossFormatEnvelopeSchema.keyPayload:
          if ((seen._value & _$CrossFormatEnvelopeSchema.payload._value) != 0) {
            throw const CodableException('Duplicate field "payload"');
          }
          payload = keyed.readBytes();
          seen |= _$CrossFormatEnvelopeSchema.payload;
          break;
        case _$CrossFormatEnvelopeSchema.keySignature:
          if (keyed.isNextNull()) {
            keyed.readNull();
            signature = null;
          } else {
            signature = keyed.readBytes();
          }
          break;
        case _$CrossFormatEnvelopeSchema.keySamples:
          if ((seen._value & _$CrossFormatEnvelopeSchema.samples._value) != 0) {
            throw const CodableException('Duplicate field "samples"');
          }
          samples = keyed.decodeFloat64List();
          seen |= _$CrossFormatEnvelopeSchema.samples;
          break;
        case _$CrossFormatEnvelopeSchema.keyCounters:
          {
            final k = keyed.nestedDecoder().keyed();
            final m = <String, int>{};
            while (k.moveNextKey()) {
              final key = k.nextKey();
              m[key] = k.readInt();
            }
            counters = m;
          }
          break;
        case _$CrossFormatEnvelopeSchema.keyStatusLabels:
          {
            final mDecoder = keyed.nestedDecoder().map();
            final m = <int, String>{};
            while (mDecoder.moveNextEntry()) {
              final key = mDecoder.keyDecoder().singleValue().readInt();
              m[key] = mDecoder.valueDecoder().singleValue().readString();
            }
            statusLabels = m;
          }
          break;
        case _$CrossFormatEnvelopeSchema.keyQuotas:
          {
            final mDecoder = keyed.nestedDecoder().map();
            final m = <RouteMethod, int>{};
            while (mDecoder.moveNextEntry()) {
              final enumIdx1 = _$CrossFormatEnvelopeSchema
                  .enumRouteMethodKeyOptions
                  .indexOf(mDecoder.keyDecoder().singleValue().readString());
              if (enumIdx1 < 0) {
                throw const CodableException('Unknown RouteMethod value');
              }
              final key = RouteMethod.values[enumIdx1];
              m[key] = mDecoder.valueDecoder().singleValue().readInt();
            }
            quotas = m;
          }
          break;
        case _$CrossFormatEnvelopeSchema.keyPrimaryMetric:
          if ((seen._value &
                  _$CrossFormatEnvelopeSchema.primaryMetric._value) !=
              0) {
            throw const CodableException('Duplicate field "primaryMetric"');
          }
          primaryMetric = keyed.readNum();
          seen |= _$CrossFormatEnvelopeSchema.primaryMetric;
          break;
        case _$CrossFormatEnvelopeSchema.keySecondaryMetric:
          if ((seen._value &
                  _$CrossFormatEnvelopeSchema.secondaryMetric._value) !=
              0) {
            throw const CodableException('Duplicate field "secondaryMetric"');
          }
          secondaryMetric = keyed.readNum();
          seen |= _$CrossFormatEnvelopeSchema.secondaryMetric;
          break;
        case _$CrossFormatEnvelopeSchema.keyOptionalMetric:
          if (keyed.isNextNull()) {
            keyed.readNull();
            optionalMetric = null;
          } else {
            optionalMetric = keyed.readNum();
          }
          break;
        default:
          keyed.skipValue();
          break;
      }
    }

    // Inlined fast-path check
    seen.validate();

    return CrossFormatEnvelope(
      id: id!,
      primaryMeta: primaryMeta!,
      backupMeta: backupMeta,
      history: history,
      tags: tags,
      ports: ports,
      payload: payload!,
      signature: signature,
      samples: samples!,
      counters: counters,
      statusLabels: statusLabels,
      quotas: quotas,
      primaryMetric: primaryMetric!,
      secondaryMetric: secondaryMetric!,
      optionalMetric: optionalMetric,
    );
  }

  @override
  void encode(CrossFormatEnvelope instance, Encoder encoder) {
    var count$ = 12;
    final v$BackupMeta = instance.backupMeta;
    if (v$BackupMeta != null) count$++;
    final v$Signature = instance.signature;
    if (v$Signature != null) count$++;
    final v$OptionalMetric = instance.optionalMetric;
    if (v$OptionalMetric != null) count$++;
    final keyed = encoder.keyed(length: count$);
    keyed.encodeString(_$CrossFormatEnvelopeSchema.nameId, instance.id);
    keyed.encodeValue(
      _$CrossFormatEnvelopeSchema.namePrimaryMeta,
      instance.primaryMeta,
      const NestedMetaCodable(),
    );
    if (v$BackupMeta != null) {
      keyed.encodeValue(
        _$CrossFormatEnvelopeSchema.nameBackupMeta,
        v$BackupMeta,
        const NestedMetaCodable(),
      );
    }
    keyed.encodeList(
      _$CrossFormatEnvelopeSchema.nameHistory,
      instance.history,
      const NestedMetaCodable(),
    );
    keyed.encodeStringList(
      _$CrossFormatEnvelopeSchema.nameTags,
      instance.tags.toList(),
    );
    keyed.encodeIntList(
      _$CrossFormatEnvelopeSchema.namePorts,
      instance.ports.toList(),
    );
    keyed.encodeBytes(
      _$CrossFormatEnvelopeSchema.namePayload,
      instance.payload,
    );
    if (v$Signature != null) {
      keyed.encodeBytes(_$CrossFormatEnvelopeSchema.nameSignature, v$Signature);
    }
    keyed.encodeDoubleList(
      _$CrossFormatEnvelopeSchema.nameSamples,
      instance.samples,
    );
    {
      final k = keyed
          .nestedEncoder(_$CrossFormatEnvelopeSchema.nameCounters)
          .keyed(length: instance.counters.length);
      for (final entry in instance.counters.entries) {
        k.encodeInt(entry.key, entry.value);
      }
    }
    {
      final m = keyed
          .nestedEncoder(_$CrossFormatEnvelopeSchema.nameStatusLabels)
          .map(length: instance.statusLabels.length);
      for (final entry in instance.statusLabels.entries) {
        m.keyEncoder().singleValue().encodeInt(entry.key);
        m.valueEncoder().singleValue().encodeString(entry.value);
      }
    }
    {
      final m = keyed
          .nestedEncoder(_$CrossFormatEnvelopeSchema.nameQuotas)
          .map(length: instance.quotas.length);
      for (final entry in instance.quotas.entries) {
        m.keyEncoder().singleValue().encodeString(entry.key.name);
        m.valueEncoder().singleValue().encodeInt(entry.value);
      }
    }
    switch (instance.primaryMetric) {
      case final int v:
        keyed.encodeInt(_$CrossFormatEnvelopeSchema.namePrimaryMetric, v);
      case final v:
        keyed.encodeDouble(
          _$CrossFormatEnvelopeSchema.namePrimaryMetric,
          v.toDouble(),
        );
    }
    switch (instance.secondaryMetric) {
      case final int v:
        keyed.encodeInt(_$CrossFormatEnvelopeSchema.nameSecondaryMetric, v);
      case final v:
        keyed.encodeDouble(
          _$CrossFormatEnvelopeSchema.nameSecondaryMetric,
          v.toDouble(),
        );
    }
    if (v$OptionalMetric != null) {
      switch (v$OptionalMetric) {
        case final int v:
          keyed.encodeInt(_$CrossFormatEnvelopeSchema.nameOptionalMetric, v);
        case final v:
          keyed.encodeDouble(
            _$CrossFormatEnvelopeSchema.nameOptionalMetric,
            v.toDouble(),
          );
      }
    }
  }
}

// =============================================================================
// 1. Unified Schema Descriptor for CircleNode
// =============================================================================
extension type const _$CircleNodeSchema(int _value) {
  // String Name Constants
  static const String nameRadius = 'radius';
  static const String nameLabel = 'label';
  static const String nameKind = 'kind';

  // Key Indices for selectKeyIndex()
  static const int keyRadius = 0;
  static const int keyLabel = 1;
  static const int keyKind = 2;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
    _$CircleNodeSchema.nameRadius,
    _$CircleNodeSchema.nameLabel,
    _$CircleNodeSchema.nameKind,
  ]);
  static final KeyOptions keyOptions = options;

  // Bitmask Flags strictly for Required Fields
  static const _$CircleNodeSchema none = _$CircleNodeSchema(0);
  static const int _radiusBit = 1 << 0;
  static const _$CircleNodeSchema radius = _$CircleNodeSchema(_radiusBit);

  // Combined Golden Bitmask for fast single-instruction check
  static const _$CircleNodeSchema golden = _$CircleNodeSchema(_radiusBit);

  @pragma('vm:prefer-inline')
  _$CircleNodeSchema operator |(_$CircleNodeSchema other) =>
      _$CircleNodeSchema(_value | other._value);

  /// Validates required fields in 1 CPU test instruction on the fast path.
  @pragma('vm:prefer-inline')
  void validate() {
    if ((_value & golden._value) != golden._value) {
      _throwMissingFields();
    }
  }

  /// Out-of-line cold diagnostic reporting
  void _throwMissingFields() {
    final missing = <String>[];
    if ((_value & _radiusBit) == 0) {
      missing.add(nameRadius);
    }
    throw CodableException(
      'Missing required fields for CircleNode: ${missing.join(", ")}',
    );
  }
}

// =============================================================================
// 2. Companion Codable for CircleNode
// =============================================================================
final class CircleNodeCodable implements Codable<CircleNode> {
  const CircleNodeCodable();

  @override
  CircleNode decode(Decoder decoder) {
    final keyed = decoder.keyed(options: _$CircleNodeSchema.keyOptions);

    double? radius;
    String? label;
    var kind = 'circle';
    var seen = _$CircleNodeSchema.none;

    while (keyed.moveNextKey()) {
      switch (keyed.selectKeyIndex(_$CircleNodeSchema.keyOptions)) {
        case _$CircleNodeSchema.keyRadius:
          if ((seen._value & _$CircleNodeSchema.radius._value) != 0) {
            throw const CodableException('Duplicate field "radius"');
          }
          radius = keyed.readDouble();
          seen |= _$CircleNodeSchema.radius;
          break;
        case _$CircleNodeSchema.keyLabel:
          if (keyed.isNextNull()) {
            keyed.readNull();
            label = null;
          } else {
            label = keyed.readString();
          }
          break;
        case _$CircleNodeSchema.keyKind:
          kind = keyed.readString();
          break;
        default:
          keyed.skipValue();
          break;
      }
    }

    // Inlined fast-path check
    seen.validate();

    return CircleNode(radius!, label: label, kind: kind);
  }

  @override
  void encode(CircleNode instance, Encoder encoder) {
    var count$ = 2;
    final v$Label = instance.label;
    if (v$Label != null) count$++;
    final keyed = encoder.keyed(length: count$);
    keyed.encodeDouble(_$CircleNodeSchema.nameRadius, instance.radius);
    if (v$Label != null) {
      keyed.encodeString(_$CircleNodeSchema.nameLabel, v$Label);
    }
    keyed.encodeString(_$CircleNodeSchema.nameKind, instance.kind);
  }
}

// =============================================================================
// 1. Unified Schema Descriptor for PolygonNode
// =============================================================================
extension type const _$PolygonNodeSchema(int _value) {
  // String Name Constants
  static const String nameVertices = 'vertices';
  static const String nameClosed = 'closed';
  static const String nameKind = 'kind';

  // Key Indices for selectKeyIndex()
  static const int keyVertices = 0;
  static const int keyClosed = 1;
  static const int keyKind = 2;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
    _$PolygonNodeSchema.nameVertices,
    _$PolygonNodeSchema.nameClosed,
    _$PolygonNodeSchema.nameKind,
  ]);
  static final KeyOptions keyOptions = options;

  // Bitmask Flags strictly for Required Fields
  static const _$PolygonNodeSchema none = _$PolygonNodeSchema(0);
  static const int _verticesBit = 1 << 0;
  static const _$PolygonNodeSchema vertices = _$PolygonNodeSchema(_verticesBit);

  // Combined Golden Bitmask for fast single-instruction check
  static const _$PolygonNodeSchema golden = _$PolygonNodeSchema(_verticesBit);

  @pragma('vm:prefer-inline')
  _$PolygonNodeSchema operator |(_$PolygonNodeSchema other) =>
      _$PolygonNodeSchema(_value | other._value);

  /// Validates required fields in 1 CPU test instruction on the fast path.
  @pragma('vm:prefer-inline')
  void validate() {
    if ((_value & golden._value) != golden._value) {
      _throwMissingFields();
    }
  }

  /// Out-of-line cold diagnostic reporting
  void _throwMissingFields() {
    final missing = <String>[];
    if ((_value & _verticesBit) == 0) {
      missing.add(nameVertices);
    }
    throw CodableException(
      'Missing required fields for PolygonNode: ${missing.join(", ")}',
    );
  }
}

// =============================================================================
// 2. Companion Codable for PolygonNode
// =============================================================================
final class PolygonNodeCodable implements Codable<PolygonNode> {
  const PolygonNodeCodable();

  @override
  PolygonNode decode(Decoder decoder) {
    final keyed = decoder.keyed(options: _$PolygonNodeSchema.keyOptions);

    List<int>? vertices;
    var closed = true;
    var kind = 'polygon';
    var seen = _$PolygonNodeSchema.none;

    while (keyed.moveNextKey()) {
      switch (keyed.selectKeyIndex(_$PolygonNodeSchema.keyOptions)) {
        case _$PolygonNodeSchema.keyVertices:
          if ((seen._value & _$PolygonNodeSchema.vertices._value) != 0) {
            throw const CodableException('Duplicate field "vertices"');
          }
          vertices = keyed.decodeIntList();
          seen |= _$PolygonNodeSchema.vertices;
          break;
        case _$PolygonNodeSchema.keyClosed:
          closed = keyed.readBool();
          break;
        case _$PolygonNodeSchema.keyKind:
          kind = keyed.readString();
          break;
        default:
          keyed.skipValue();
          break;
      }
    }

    // Inlined fast-path check
    seen.validate();

    return PolygonNode(vertices!, closed: closed, kind: kind);
  }

  @override
  void encode(PolygonNode instance, Encoder encoder) {
    final keyed = encoder.keyed(length: 3);
    keyed.encodeIntList(_$PolygonNodeSchema.nameVertices, instance.vertices);
    keyed.encodeBool(_$PolygonNodeSchema.nameClosed, instance.closed);
    keyed.encodeString(_$PolygonNodeSchema.nameKind, instance.kind);
  }
}

// =============================================================================
// 1. Unified Schema Descriptor for AdaptiveAuditEvent
// =============================================================================
extension type const _$AdaptiveAuditEventSchema(int _value) {
  // String Name Constants
  static const String nameActor = 'actor';
  static const String nameOccurredAt = 'occurredAt';
  static const String nameExpiresAt = 'expiresAt';
  static const String nameTraceId = 'traceId';

  // Key Indices for selectKeyIndex()
  static const int keyActor = 0;
  static const int keyOccurredAt = 1;
  static const int keyExpiresAt = 2;
  static const int keyTraceId = 3;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
    _$AdaptiveAuditEventSchema.nameActor,
    _$AdaptiveAuditEventSchema.nameOccurredAt,
    _$AdaptiveAuditEventSchema.nameExpiresAt,
    _$AdaptiveAuditEventSchema.nameTraceId,
  ]);
  static final KeyOptions keyOptions = options;

  // Bitmask Flags strictly for Required Fields
  static const _$AdaptiveAuditEventSchema none = _$AdaptiveAuditEventSchema(0);
  static const int _actorBit = 1 << 0;
  static const _$AdaptiveAuditEventSchema actor = _$AdaptiveAuditEventSchema(
    _actorBit,
  );
  static const int _occurredAtBit = 1 << 1;
  static const _$AdaptiveAuditEventSchema occurredAt =
      _$AdaptiveAuditEventSchema(_occurredAtBit);
  static const int _traceIdBit = 1 << 2;
  static const _$AdaptiveAuditEventSchema traceId = _$AdaptiveAuditEventSchema(
    _traceIdBit,
  );

  // Combined Golden Bitmask for fast single-instruction check
  static const _$AdaptiveAuditEventSchema golden = _$AdaptiveAuditEventSchema(
    _actorBit | _occurredAtBit | _traceIdBit,
  );

  @pragma('vm:prefer-inline')
  _$AdaptiveAuditEventSchema operator |(_$AdaptiveAuditEventSchema other) =>
      _$AdaptiveAuditEventSchema(_value | other._value);

  /// Validates required fields in 1 CPU test instruction on the fast path.
  @pragma('vm:prefer-inline')
  void validate() {
    if ((_value & golden._value) != golden._value) {
      _throwMissingFields();
    }
  }

  /// Out-of-line cold diagnostic reporting
  void _throwMissingFields() {
    final missing = <String>[];
    if ((_value & _actorBit) == 0) {
      missing.add(nameActor);
    }
    if ((_value & _occurredAtBit) == 0) {
      missing.add(nameOccurredAt);
    }
    if ((_value & _traceIdBit) == 0) {
      missing.add(nameTraceId);
    }
    throw CodableException(
      'Missing required fields for AdaptiveAuditEvent: ${missing.join(", ")}',
    );
  }
}

// =============================================================================
// 2. Companion Codable for AdaptiveAuditEvent
// =============================================================================
final class AdaptiveAuditEventCodable implements Codable<AdaptiveAuditEvent> {
  const AdaptiveAuditEventCodable();

  @override
  AdaptiveAuditEvent decode(Decoder decoder) {
    final keyed = decoder.keyed(options: _$AdaptiveAuditEventSchema.keyOptions);

    String? actor;
    DateTime? occurredAt;
    DateTime? expiresAt;
    Uint8List? traceId;
    var seen = _$AdaptiveAuditEventSchema.none;

    while (keyed.moveNextKey()) {
      switch (keyed.selectKeyIndex(_$AdaptiveAuditEventSchema.keyOptions)) {
        case _$AdaptiveAuditEventSchema.keyActor:
          if ((seen._value & _$AdaptiveAuditEventSchema.actor._value) != 0) {
            throw const CodableException('Duplicate field "actor"');
          }
          actor = keyed.readString();
          seen |= _$AdaptiveAuditEventSchema.actor;
          break;
        case _$AdaptiveAuditEventSchema.keyOccurredAt:
          if ((seen._value & _$AdaptiveAuditEventSchema.occurredAt._value) !=
              0) {
            throw const CodableException('Duplicate field "occurredAt"');
          }
          occurredAt = keyed.decodeValue(
            const AdaptiveEpochOrIsoDateTimeCodable(),
          );
          seen |= _$AdaptiveAuditEventSchema.occurredAt;
          break;
        case _$AdaptiveAuditEventSchema.keyExpiresAt:
          if (keyed.isNextNull()) {
            keyed.readNull();
            expiresAt = null;
          } else {
            expiresAt = keyed.decodeValue(
              const AdaptiveEpochOrIsoDateTimeCodable(),
            );
          }
          break;
        case _$AdaptiveAuditEventSchema.keyTraceId:
          if ((seen._value & _$AdaptiveAuditEventSchema.traceId._value) != 0) {
            throw const CodableException('Duplicate field "traceId"');
          }
          traceId = keyed.readBytes();
          seen |= _$AdaptiveAuditEventSchema.traceId;
          break;
        default:
          keyed.skipValue();
          break;
      }
    }

    // Inlined fast-path check
    seen.validate();

    return AdaptiveAuditEvent(
      actor: actor!,
      occurredAt: occurredAt!,
      expiresAt: expiresAt,
      traceId: traceId!,
    );
  }

  @override
  void encode(AdaptiveAuditEvent instance, Encoder encoder) {
    var count$ = 3;
    final v$ExpiresAt = instance.expiresAt;
    if (v$ExpiresAt != null) count$++;
    final keyed = encoder.keyed(length: count$);
    keyed.encodeString(_$AdaptiveAuditEventSchema.nameActor, instance.actor);
    keyed.encodeValue(
      _$AdaptiveAuditEventSchema.nameOccurredAt,
      instance.occurredAt,
      const AdaptiveEpochOrIsoDateTimeCodable(),
    );
    if (v$ExpiresAt != null) {
      keyed.encodeValue(
        _$AdaptiveAuditEventSchema.nameExpiresAt,
        v$ExpiresAt,
        const AdaptiveEpochOrIsoDateTimeCodable(),
      );
    }
    keyed.encodeBytes(_$AdaptiveAuditEventSchema.nameTraceId, instance.traceId);
  }
}
