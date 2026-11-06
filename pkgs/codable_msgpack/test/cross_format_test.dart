// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:typed_data';

import 'package:checks/checks.dart';
import 'package:codable/codable.dart';
import 'package:codable/codable_json.dart';
import 'package:codable_cbor/codable_cbor.dart';
import 'package:codable_msgpack/codable_msgpack.dart';
import 'package:codable_yaml/codable_yaml.dart';
import 'package:test/test.dart';

import '../example/codable_msgpack_example.dart';
import 'fuzz/msgpack_fuzz.dart';

part 'cross_format_test.g.dart';

// =============================================================================
// 4-Way Cross-Format Roundtrip Helpers (JSON <-> YAML <-> CBOR <-> MessagePack)
// =============================================================================

T _roundtripJson<T>(T value, Codable<T> codable) {
  final json = JsonCodableEncoder.encode(value, codable);
  return codable.decode(JsonCodableDecoder.fromString(json));
}

T _roundtripYaml<T>(T value, Codable<T> codable) {
  final yaml = YamlCodableEncoder.encode(value, codable);
  return YamlCodableDecoder.decode(yaml, codable);
}

(T, Uint8List) _roundtripCbor<T>(T value, Codable<T> codable) {
  final bytes = CborCodableEncoder.encode(value, codable);
  return (CborCodableDecoder.decode(bytes, codable), bytes);
}

(T, Uint8List) _roundtripMsgPackSinglePass<T>(T value, Codable<T> codable) {
  final bytes = MsgPackCodableEncoder.encode(
    value,
    codable,
    requireKnownLength: true,
  );
  return (MsgPackCodableDecoder.decode(bytes, codable), bytes);
}

List<T> _roundtripAllFourFormats<T>(T value, Codable<T> codable) {
  final fromJson = _roundtripJson(value, codable);
  final fromYaml = _roundtripYaml(fromJson, codable);
  final (fromCbor, _) = _roundtripCbor(fromYaml, codable);
  final (fromMsgPack, _) = _roundtripMsgPackSinglePass(fromCbor, codable);
  return [fromJson, fromYaml, fromCbor, fromMsgPack];
}

bool _containsSubsequence(Uint8List haystack, List<int> needle) {
  final limit = haystack.length - needle.length;
  for (var i = 0; i <= limit; i++) {
    if (_matchesAt(haystack, i, needle)) return true;
  }
  return false;
}

bool _matchesAt(Uint8List haystack, int offset, List<int> needle) {
  for (var j = 0; j < needle.length; j++) {
    if (haystack[offset + j] != needle[j]) return false;
  }
  return true;
}

// =============================================================================
// 1. All-Null, Partial-Null, All-Present, and >= 16 Fields (`map16` Boundary)
// =============================================================================

@Codable()
final class AllOptionalPatch {
  final int? alpha;
  final String? beta;
  final bool? gamma;

  const AllOptionalPatch({this.alpha, this.beta, this.gamma});
}

@Codable()
final class WideNullableRecord {
  final int f01;
  final String f02;
  final bool f03;
  final double f04;
  final int? f05;
  final int? f06;
  final int? f07;
  final int? f08;
  final String? f09;
  final String? f10;
  final String? f11;
  final String? f12;
  final bool? f13;
  final bool? f14;
  final double? f15;
  final double? f16;
  final int? f17;
  final String? f18;
  final bool? f19;
  final int? f20;

  const WideNullableRecord({
    required this.f01,
    required this.f02,
    required this.f03,
    required this.f04,
    this.f05,
    this.f06,
    this.f07,
    this.f08,
    this.f09,
    this.f10,
    this.f11,
    this.f12,
    this.f13,
    this.f14,
    this.f15,
    this.f16,
    this.f17,
    this.f18,
    this.f19,
    this.f20,
  });
}

// =============================================================================
// 2. Nested @Codable, List, Set, Uint8List, Float64List, Maps, and num
// =============================================================================

enum RouteMethod { get, post, put, delete }

@Codable()
final class NestedMeta {
  final String region;
  final int revision;
  final String? note;

  const NestedMeta({required this.region, required this.revision, this.note});

  @override
  bool operator ==(Object other) =>
      other is NestedMeta &&
      other.region == region &&
      other.revision == revision &&
      other.note == note;

  @override
  int get hashCode => Object.hash(region, revision, note);
}

@Codable()
final class CrossFormatEnvelope {
  final String id;
  final NestedMeta primaryMeta;
  final NestedMeta? backupMeta;
  final List<NestedMeta> history;
  final Set<String> tags;
  final Set<int> ports;
  final Uint8List payload;
  final Uint8List? signature;
  final Float64List samples;
  final Map<String, int> counters;
  final Map<int, String> statusLabels;
  final Map<RouteMethod, int> quotas;
  final num primaryMetric;
  final num secondaryMetric;
  final num? optionalMetric;

  const CrossFormatEnvelope({
    required this.id,
    required this.primaryMeta,
    this.backupMeta,
    this.history = const [],
    this.tags = const {},
    this.ports = const {},
    required this.payload,
    this.signature,
    required this.samples,
    this.counters = const {},
    this.statusLabels = const {},
    this.quotas = const {},
    required this.primaryMetric,
    required this.secondaryMetric,
    this.optionalMetric,
  });
}

// =============================================================================
// 3. SuperDecodable Polymorphic Models
// =============================================================================

sealed class ShapeNode {
  const ShapeNode();
}

@Codable()
final class CircleNode extends ShapeNode {
  final String kind;
  final double radius;
  final String? label;

  const CircleNode(this.radius, {this.label, this.kind = 'circle'});
}

@Codable()
final class PolygonNode extends ShapeNode {
  final String kind;
  final List<int> vertices;
  final bool closed;

  const PolygonNode(this.vertices, {this.closed = true, this.kind = 'polygon'});
}

final class ShapeNodeCodable extends SuperDecodable<ShapeNode>
    implements Codable<ShapeNode> {
  const ShapeNodeCodable();

  @override
  String get discriminatorKey => 'kind';

  @override
  Map<String, Decodable<ShapeNode>> get subtypes => const {
    'circle': CircleNodeCodable(),
    'polygon': PolygonNodeCodable(),
  };

  @override
  void encode(ShapeNode value, Encoder encoder) {
    switch (value) {
      case final CircleNode circle:
        const CircleNodeCodable().encode(circle, encoder);
      case final PolygonNode polygon:
        const PolygonNodeCodable().encode(polygon, encoder);
    }
  }
}

// =============================================================================
// 4. Format-Adaptive `isHumanReadable` DateTime Codec
// =============================================================================

final class AdaptiveEpochOrIsoDateTimeCodable implements Codable<DateTime> {
  const AdaptiveEpochOrIsoDateTimeCodable();

  @override
  DateTime decode(Decoder decoder) => decoder.isHumanReadable
      ? DateTime.parse(decoder.singleValue().readString()).toUtc()
      : DateTime.fromMillisecondsSinceEpoch(
          decoder.singleValue().readInt(),
          isUtc: true,
        );

  @override
  void encode(DateTime value, Encoder encoder) {
    final utc = value.toUtc();
    if (encoder.isHumanReadable) {
      encoder.singleValue().encodeString(utc.toIso8601String());
    } else {
      encoder.singleValue().encodeInt(utc.millisecondsSinceEpoch);
    }
  }
}

@Codable()
final class AdaptiveAuditEvent {
  final String actor;

  @CodableKey(codable: AdaptiveEpochOrIsoDateTimeCodable())
  final DateTime occurredAt;

  @CodableKey(codable: AdaptiveEpochOrIsoDateTimeCodable())
  final DateTime? expiresAt;

  final Uint8List traceId;

  const AdaptiveAuditEvent({
    required this.actor,
    required this.occurredAt,
    this.expiresAt,
    required this.traceId,
  });
}

// =============================================================================
// 5. Hand-Written Encodable Omitting `length`
// =============================================================================

final class DynamicProperties {
  final Map<String, int?> entries;
  final DynamicProperties? child;

  const DynamicProperties(this.entries, {this.child});
}

final class DynamicPropertiesCodable implements Codable<DynamicProperties> {
  const DynamicPropertiesCodable();

  @override
  DynamicProperties decode(Decoder decoder) {
    final keyed = decoder.keyed();
    final entries = <String, int?>{};
    DynamicProperties? child;
    while (keyed.moveNextKey()) {
      final k = keyed.nextKey();
      if (k == '_child') {
        child = keyed.decodeNullableValue(const DynamicPropertiesCodable());
      } else {
        entries[k] = keyed.readNullableInt();
      }
    }
    return DynamicProperties(entries, child: child);
  }

  @override
  void encode(DynamicProperties value, Encoder encoder) {
    final keyed = encoder.keyed(); // intentionally omits `length`
    for (final MapEntry(:key, value: v) in value.entries.entries) {
      keyed.encodeNullableInt(key, v);
    }
    keyed.encodeNullableValue(
      '_child',
      value.child,
      const DynamicPropertiesCodable(),
    );
  }
}

// =============================================================================
// Test Suite
// =============================================================================

void main() {
  _registerNullableAndMap16BoundaryTests();
  _registerCompositeFourWayTests();
  _registerZeroCopyBinarySizesTests();
  _registerPolymorphicAndAdaptiveTests();
  _registerHandWrittenKnownLengthTests();
}

void _registerNullableAndMap16BoundaryTests() {
  group('Single-pass nullable pre-counting & >= 16 field map16 boundary', () {
    test(
      'roundtrips all-null, partial-null, and all-present optional fields',
      () {
        const allNull = AllOptionalPatch();
        const partial = AllOptionalPatch(beta: 'set');
        const allPresent = AllOptionalPatch(alpha: 7, beta: 'ok', gamma: false);

        final (_, nullBytes) = _roundtripMsgPackSinglePass(
          allNull,
          const AllOptionalPatchCodable(),
        );
        check(nullBytes)
            .deepEquals(Uint8List.fromList(const [0x80])); // fixmap(0)

        final (_, partialBytes) = _roundtripMsgPackSinglePass(
          partial,
          const AllOptionalPatchCodable(),
        );
        check(partialBytes[0]).equals(0x81); // fixmap(1)

        final (_, fullBytes) = _roundtripMsgPackSinglePass(
          allPresent,
          const AllOptionalPatchCodable(),
        );
        check(fullBytes[0]).equals(0x83); // fixmap(3)

        for (final r in _roundtripAllFourFormats(
          allNull,
          const AllOptionalPatchCodable(),
        )) {
          check(r.alpha).isNull();
          check(r.beta).isNull();
          check(r.gamma).isNull();
        }
        for (final r in _roundtripAllFourFormats(
          partial,
          const AllOptionalPatchCodable(),
        )) {
          check(r.alpha).isNull();
          check(r.beta).equals('set');
          check(r.gamma).isNull();
        }
        for (final r in _roundtripAllFourFormats(
          allPresent,
          const AllOptionalPatchCodable(),
        )) {
          check(r.alpha).equals(7);
          check(r.beta).equals('ok');
          check(r.gamma).equals(false);
        }
      },
    );

    test(
      'roundtrips 20-field @Codable across fixmap(4), map16(16), map16(20)',
      () {
        const onlyRequired = WideNullableRecord(
          f01: 1,
          f02: 'two',
          f03: true,
          f04: 4.5,
        );
        const exactSixteen = WideNullableRecord(
          f01: 1,
          f02: 'two',
          f03: true,
          f04: 4.5,
          f05: 5,
          f06: 6,
          f07: 7,
          f08: 8,
          f09: '9',
          f10: '10',
          f11: '11',
          f12: '12',
          f13: false,
          f14: true,
          f15: 15.25,
          f16: -16.5,
        );
        const allTwenty = WideNullableRecord(
          f01: 1,
          f02: 'two',
          f03: true,
          f04: 4.5,
          f05: 5,
          f06: 6,
          f07: 7,
          f08: 8,
          f09: '9',
          f10: '10',
          f11: '11',
          f12: '12',
          f13: false,
          f14: true,
          f15: 15.25,
          f16: -16.5,
          f17: 17,
          f18: '18',
          f19: true,
          f20: 20,
        );

        final (_, bytes4) = _roundtripMsgPackSinglePass(
          onlyRequired,
          const WideNullableRecordCodable(),
        );
        check(bytes4[0]).equals(0x84); // fixmap(4)

        final (_, bytes16) = _roundtripMsgPackSinglePass(
          exactSixteen,
          const WideNullableRecordCodable(),
        );
        check(bytes16.sublist(0, 3))
            .deepEquals(const [0xde, 0x00, 16]); // map16(16)

        final (_, bytes20) = _roundtripMsgPackSinglePass(
          allTwenty,
          const WideNullableRecordCodable(),
        );
        check(bytes20.sublist(0, 3))
            .deepEquals(const [0xde, 0x00, 20]); // map16(20)

        for (final r in _roundtripAllFourFormats(
          exactSixteen,
          const WideNullableRecordCodable(),
        )) {
          check(r.f01).equals(1);
          check(r.f12).equals('12');
          check(r.f16).equals(-16.5);
          check(r.f17).isNull();
          check(r.f20).isNull();
        }
        for (final r in _roundtripAllFourFormats(
          allTwenty,
          const WideNullableRecordCodable(),
        )) {
          check(r.f05).equals(5);
          check(r.f17).equals(17);
          check(r.f18).equals('18');
          check(r.f19).equals(true);
          check(r.f20).equals(20);
        }
      },
    );
  });
}

void _registerCompositeFourWayTests() {
  group(
    '4-way JSON <-> YAML <-> CBOR <-> MessagePack composite roundtrips',
    () {
      test(
        'streams nested classes, List, Set, TypedData, Maps, and num in 1 pass',
        () {
          final wideCounters = <String, int>{
            for (var i = 0; i < 18; i++) 'metric_$i': i * 10 - 30,
          };
          final envelope = CrossFormatEnvelope(
            id: 'env-2026',
            primaryMeta: const NestedMeta(region: 'us-central1', revision: 12),
            history: const [
              NestedMeta(region: 'us-west1', revision: 10),
              NestedMeta(region: 'eu-west1', revision: 11, note: 'failover'),
            ],
            tags: const {'streaming', 'msgpack', 'cbor', 'zero-deps'},
            ports: const {80, 443, 8080},
            payload: Uint8List.fromList([0x00, 0x7f, 0x80, 0xff]),
            samples: Float64List.fromList([1.5, -2.25, 0.0, 1024.125]),
            counters: wideCounters,
            statusLabels: const {
              200: 'ok',
              429: 'throttled',
              503: 'unavailable',
            },
            quotas: const {RouteMethod.get: 5000, RouteMethod.post: 500},
            primaryMetric: 42,
            secondaryMetric: 3.125,
          );

          final (_, msgpackBytes) = _roundtripMsgPackSinglePass(
            envelope,
            const CrossFormatEnvelopeCodable(),
          );
          fuzzTarget(msgpackBytes);
          // Verify wideCounters (18 entries) emitted map16 (0xde 0x00 0x12)
          check(_containsSubsequence(msgpackBytes, const [0xde, 0x00, 18]))
              .isTrue();
          // Verify payload emitted native bin8 (0xc4, 0x04, ...)
          check(
            _containsSubsequence(msgpackBytes, const [
              0xc4,
              4,
              0x00,
              0x7f,
              0x80,
              0xff,
            ]),
          ).isTrue();

          for (final decoded in _roundtripAllFourFormats(
            envelope,
            const CrossFormatEnvelopeCodable(),
          )) {
            check(decoded.id).equals('env-2026');
            check(decoded.primaryMeta)
                .equals(const NestedMeta(region: 'us-central1', revision: 12));
            check(decoded.backupMeta).isNull();
            check(decoded.history).deepEquals(envelope.history);
            check(decoded.tags).deepEquals(envelope.tags);
            check(decoded.ports).deepEquals(envelope.ports);
            check(decoded.payload).deepEquals([0x00, 0x7f, 0x80, 0xff]);
            check(decoded.signature).isNull();
            check(decoded.samples).deepEquals([1.5, -2.25, 0.0, 1024.125]);
            check(decoded.counters).deepEquals(wideCounters);
            check(decoded.statusLabels).deepEquals(envelope.statusLabels);
            check(decoded.quotas).deepEquals(envelope.quotas);
            check(decoded.primaryMetric).equals(42);
            check(decoded.secondaryMetric).equals(3.125);
            check(decoded.optionalMetric).isNull();
          }
        },
      );

      test(
        'roundtrips TelemetryBatch example with composite struct map keys',
        () {
          final batch = TelemetryBatch(
            batchId: 77,
            rawSample: Uint8List.fromList([1, 2, 3, 4, 5]),
            readings: Float64List.fromList([19.5, 20.25]),
            calibrationOffsets: {
              const TelemetryCoordinate(0, 1): -0.5,
              const TelemetryCoordinate(2, 3): 1.25,
            },
          );
          final (fromMsgPack, _) = _roundtripMsgPackSinglePass(
            batch,
            const TelemetryBatchCodable(),
          );
          final (fromCbor, _) = _roundtripCbor(
            batch,
            const TelemetryBatchCodable(),
          );
          final fromYaml = _roundtripYaml(batch, const TelemetryBatchCodable());

          for (final r in [fromMsgPack, fromCbor, fromYaml]) {
            check(r.batchId).equals(77);
            check(r.rawSample).deepEquals([1, 2, 3, 4, 5]);
            check(r.readings).deepEquals([19.5, 20.25]);
            check(r.calibrationOffsets).deepEquals(batch.calibrationOffsets);
          }
        },
      );
    },
  );
}

void _registerZeroCopyBinarySizesTests() {
  group('Zero-copy Uint8List slices across bin8, bin16, and bin32', () {
    test('preserves zero-copy sublistView on @Codable Uint8List fields', () {
      for (final (size, expectedBinTag) in const [
        (32, 0xc4), // bin8
        (300, 0xc5), // bin16
        (65600, 0xc6), // bin32
      ]) {
        final raw = Uint8List.fromList(
          List<int>.generate(size, (i) => (i * 7) & 0xff),
        );
        final model = AdaptiveAuditEvent(
          actor: 'svc',
          occurredAt: DateTime.utc(2026, 11, 6),
          traceId: raw,
        );
        final wire = MsgPackCodableEncoder.encode(
          model,
          const AdaptiveAuditEventCodable(),
          requireKnownLength: true,
        );
        check(wire).contains(expectedBinTag);

        final decoded = MsgPackCodableDecoder.decode(
          wire,
          const AdaptiveAuditEventCodable(),
        );
        check(decoded.traceId.length).equals(size);
        check(decoded.traceId.offsetInBytes).isGreaterThan(0);
        wire[decoded.traceId.offsetInBytes] = 0xee;
        check(decoded.traceId[0]).equals(0xee);
      }
    });
  });
}

void _registerPolymorphicAndAdaptiveTests() {
  group('SuperDecodable polymorphism & isHumanReadable DateTime codecs', () {
    test('roundtrips polymorphic ShapeNode list across all 4 formats', () {
      const shapes = <ShapeNode>[
        CircleNode(6.25, label: 'unit'),
        PolygonNode([3, 4, 5], closed: false),
      ];
      final listCodec = const ShapeNodeCodable().list;

      for (final list in _roundtripAllFourFormats(shapes, listCodec)) {
        check(list.length).equals(2);
        check(list[0])
            .isA<CircleNode>()
            .has((c) => (c.radius, c.label), 'circle')
            .equals((6.25, 'unit'));
        check(list[1])
            .isA<PolygonNode>()
            .has((p) => (p.vertices.length, p.closed), 'polygon')
            .equals((3, false));
      }
    });

    test(
      'adapts DateTime between ISO-8601 on JSON/YAML and int on CBOR/MsgPack',
      () {
        final ts = DateTime.utc(2026, 11, 6, 1, 30, 45, 500);
        final exp = DateTime.utc(2026, 11, 7, 1, 30, 45, 500);
        final trace = Uint8List.fromList(List<int>.generate(16, (i) => i + 1));
        final event = AdaptiveAuditEvent(
          actor: 'kevmoo',
          occurredAt: ts,
          expiresAt: exp,
          traceId: trace,
        );

        final jsonStr = JsonCodableEncoder.encode(
          event,
          const AdaptiveAuditEventCodable(),
        );
        final yamlStr = YamlCodableEncoder.encode(
          event,
          const AdaptiveAuditEventCodable(),
        );
        final (_, cborBytes) = _roundtripCbor(
          event,
          const AdaptiveAuditEventCodable(),
        );
        final (_, msgpackBytes) = _roundtripMsgPackSinglePass(
          event,
          const AdaptiveAuditEventCodable(),
        );

        check(jsonStr).contains('2026-11-06T01:30:45.500Z');
        check(yamlStr).contains('2026-11-06T01:30:45.500Z');
        check(_containsSubsequence(msgpackBytes, utf8.encode('2026-11-06')))
            .isFalse();
        check(_containsSubsequence(msgpackBytes, [0xc4, 16, ...trace]))
            .isTrue();
        check(msgpackBytes.length).isLessThan(utf8.encode(jsonStr).length);
        check(cborBytes.length).isLessThan(utf8.encode(jsonStr).length);

        for (final r in _roundtripAllFourFormats(
          event,
          const AdaptiveAuditEventCodable(),
        )) {
          check(r.actor).equals('kevmoo');
          check(r.occurredAt).equals(ts);
          check(r.expiresAt).equals(exp);
          check(r.traceId).deepEquals(trace);
        }
      },
    );
  });
}

void _registerHandWrittenKnownLengthTests() {
  group('Hand-written Encodable omitting length: strict vs fallback', () {
    test('throws with requireKnownLength: true and backpatches when false', () {
      const small = DynamicProperties({'a': 1, 'omitted': null, 'b': 2});
      final largeEntries = <String, int?>{
        for (var i = 0; i < 20; i++) 'k_$i': i,
        'skip_me': null,
      };
      final largeWithNested = DynamicProperties(
        largeEntries,
        child: DynamicProperties({
          for (var i = 0; i < 17; i++) 'nested_$i': i + 100,
        }),
      );

      check(
            () => MsgPackCodableEncoder.encode(
              small,
              const DynamicPropertiesCodable(),
              requireKnownLength: true,
            ),
          )
          .throws<CodableException>()
          .has((e) => e.message, 'message')
          .contains(
            'Single-pass MessagePack encoding requires upfront container length',
          );

      final smallBytes = MsgPackCodableEncoder.encode(
        small,
        const DynamicPropertiesCodable(),
      );
      check(smallBytes[0]).equals(0x82); // fixmap(2)
      final decodedSmall = MsgPackCodableDecoder.decode(
        smallBytes,
        const DynamicPropertiesCodable(),
      );
      check(decodedSmall.entries).deepEquals({'a': 1, 'b': 2});

      final largeBytes = MsgPackCodableEncoder.encode(
        largeWithNested,
        const DynamicPropertiesCodable(),
      );
      // 20 non-null entries + 1 '_child' entry = 21 -> map16 (0xde 0x00 0x15)
      check(largeBytes.sublist(0, 3)).deepEquals(const [0xde, 0x00, 21]);
      final decodedLarge = MsgPackCodableDecoder.decode(
        largeBytes,
        const DynamicPropertiesCodable(),
      );
      check(decodedLarge.entries.length).equals(20);
      check(decodedLarge.child)
          .isNotNull()
          .has((c) => c.entries.length, 'nested entries')
          .equals(17);
    });
  });
}
