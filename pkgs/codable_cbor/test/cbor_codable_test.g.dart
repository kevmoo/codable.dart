// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: lines_longer_than_80_chars, unnecessary_lambdas, deprecated_member_use, unused_element

part of 'cbor_codable_test.dart';

// **************************************************************************
// CodableGenerator
// **************************************************************************

// =============================================================================
// 1. Unified Schema Descriptor for CborEnvelope
// =============================================================================
extension type const _$CborEnvelopeSchema(int _value) {
  // String Name Constants
  static const String nameId = 'id';
  static const String namePriority = 'priority';
  static const String nameBody = 'body';
  static const String nameDigest = 'digest';
  static const String nameHeaders = 'headers';
  static const String nameMetrics = 'metrics';

  // Key Indices for selectKeyIndex()
  static const int keyId = 0;
  static const int keyPriority = 1;
  static const int keyBody = 2;
  static const int keyDigest = 3;
  static const int keyHeaders = 4;
  static const int keyMetrics = 5;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
    _$CborEnvelopeSchema.nameId,
    _$CborEnvelopeSchema.namePriority,
    _$CborEnvelopeSchema.nameBody,
    _$CborEnvelopeSchema.nameDigest,
    _$CborEnvelopeSchema.nameHeaders,
    _$CborEnvelopeSchema.nameMetrics,
  ]);
  static final KeyOptions keyOptions = options;

  // Enum Options for priority
  static final KeyOptions priorityEnumOptions = KeyOptions.of(const [
    'low',
    'normal',
    'urgent',
  ]);
  static final KeyOptions priorityKeyOptions = priorityEnumOptions;

  // Bitmask Flags strictly for Required Fields
  static const _$CborEnvelopeSchema none = _$CborEnvelopeSchema(0);
  static const int _idBit = 1 << 0;
  static const _$CborEnvelopeSchema id = _$CborEnvelopeSchema(_idBit);
  static const int _bodyBit = 1 << 1;
  static const _$CborEnvelopeSchema body = _$CborEnvelopeSchema(_bodyBit);

  // Combined Golden Bitmask for fast single-instruction check
  static const _$CborEnvelopeSchema golden = _$CborEnvelopeSchema(
    _idBit | _bodyBit,
  );

  @pragma('vm:prefer-inline')
  _$CborEnvelopeSchema operator |(_$CborEnvelopeSchema other) =>
      _$CborEnvelopeSchema(_value | other._value);

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
    if ((_value & _bodyBit) == 0) {
      missing.add(nameBody);
    }
    throw CodableException(
      'Missing required fields for CborEnvelope: ${missing.join(", ")}',
    );
  }
}

// =============================================================================
// 2. Companion Codable for CborEnvelope
// =============================================================================
final class CborEnvelopeCodable implements Codable<CborEnvelope> {
  const CborEnvelopeCodable();

  @override
  CborEnvelope decode(Decoder decoder) {
    final keyed = decoder.keyed(options: _$CborEnvelopeSchema.keyOptions);

    int? id;
    var priority = FramePriority.normal;
    Uint8List? body;
    Uint8List? digest;
    var headers = const <int, String>{};
    var metrics = const <double>[];
    var seen = _$CborEnvelopeSchema.none;

    while (keyed.moveNextKey()) {
      switch (keyed.selectKeyIndex(_$CborEnvelopeSchema.keyOptions)) {
        case _$CborEnvelopeSchema.keyId:
          if ((seen._value & _$CborEnvelopeSchema.id._value) != 0) {
            throw const CodableException('Duplicate field "id"');
          }
          id = keyed.readInt();
          seen |= _$CborEnvelopeSchema.id;
          break;
        case _$CborEnvelopeSchema.keyPriority:
          final enumIndex = keyed.selectStringIndex(
            _$CborEnvelopeSchema.priorityKeyOptions,
          );
          if (enumIndex >= 0 && enumIndex < FramePriority.values.length) {
            priority = FramePriority.values[enumIndex];
          } else {
            throw const CodableException('Unknown FramePriority value');
          }
          break;
        case _$CborEnvelopeSchema.keyBody:
          if ((seen._value & _$CborEnvelopeSchema.body._value) != 0) {
            throw const CodableException('Duplicate field "body"');
          }
          body = keyed.readBytes();
          seen |= _$CborEnvelopeSchema.body;
          break;
        case _$CborEnvelopeSchema.keyDigest:
          if (keyed.isNextNull()) {
            keyed.readNull();
            digest = null;
          } else {
            digest = keyed.readBytes();
          }
          break;
        case _$CborEnvelopeSchema.keyHeaders:
          {
            final mDecoder = keyed.nestedDecoder().map();
            final m = <int, String>{};
            while (mDecoder.moveNextEntry()) {
              final key = mDecoder.keyDecoder().singleValue().readInt();
              m[key] = mDecoder.valueDecoder().singleValue().readString();
            }
            headers = m;
          }
          break;
        case _$CborEnvelopeSchema.keyMetrics:
          metrics = keyed.decodeDoubleList();
          break;
        default:
          keyed.skipValue();
          break;
      }
    }

    // Inlined fast-path check
    seen.validate();

    return CborEnvelope(
      id: id!,
      priority: priority,
      body: body!,
      digest: digest,
      headers: headers,
      metrics: metrics,
    );
  }

  @override
  void encode(CborEnvelope instance, Encoder encoder) {
    var count$ = 5;
    final v$Digest = instance.digest;
    if (v$Digest != null) count$++;
    final keyed = encoder.keyed(length: count$);
    keyed.encodeInt(_$CborEnvelopeSchema.nameId, instance.id);
    keyed.encodeString(
      _$CborEnvelopeSchema.namePriority,
      instance.priority.name,
    );
    keyed.encodeBytes(_$CborEnvelopeSchema.nameBody, instance.body);
    if (v$Digest != null) {
      keyed.encodeBytes(_$CborEnvelopeSchema.nameDigest, v$Digest);
    }
    {
      final m = keyed
          .nestedEncoder(_$CborEnvelopeSchema.nameHeaders)
          .map(length: instance.headers.length);
      for (final entry in instance.headers.entries) {
        m.keyEncoder().singleValue().encodeInt(entry.key);
        m.valueEncoder().singleValue().encodeString(entry.value);
      }
    }
    keyed.encodeDoubleList(_$CborEnvelopeSchema.nameMetrics, instance.metrics);
  }
}
