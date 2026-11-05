// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:typed_data';

import 'package:checks/checks.dart';
import 'package:codable/codable.dart';
import 'package:codable/codable_json.dart';
import 'package:codable_cbor/codable_cbor.dart';
import 'package:codable_yaml/codable_yaml.dart';
import 'package:test/test.dart';

part 'cross_format_test.g.dart';

// =============================================================================
// Cross-Format Roundtrip Helpers
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
  final decoded = CborCodableDecoder.decode(bytes, codable);
  return (decoded, bytes);
}

void _assertNoIndefiniteMarkers(Uint8List cborBytes) {
  check(cborBytes).not((it) => it.contains(0x9f));
  check(cborBytes).not((it) => it.contains(0xbf));
  check(cborBytes).not((it) => it.contains(0xff));
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
// 1. Generated @Codable() Models Across JSON <-> YAML <-> CBOR
// =============================================================================

enum HttpVerb { get, post, delete }

final class DateTimeIsoCodec implements Codable<DateTime> {
  const DateTimeIsoCodec();

  @override
  DateTime decode(Decoder decoder) =>
      DateTime.parse(decoder.singleValue().readString()).toUtc();

  @override
  void encode(DateTime value, Encoder encoder) =>
      encoder.singleValue().encodeString(value.toUtc().toIso8601String());
}

@Codable()
final class OrderItem {
  final int? count;
  final int? itemNumber;
  final bool? isRushed;

  const OrderItem({this.count, this.itemNumber, this.isRushed});
}

@Codable()
final class Order {
  final int dateUs;
  final int? count;
  final OrderItem? item;

  const Order({required this.dateUs, this.count, this.item});
}

@Codable()
final class Person {
  final String firstName;
  final String? middleName;
  final String lastName;

  @CodableKey(
    name: 'date-of-birth',
    aliases: ['dob'],
    codable: DateTimeIsoCodec(),
  )
  final DateTime dateOfBirth;

  final List<Order> orders;

  const Person({
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    this.middleName,
    this.orders = const [],
  });
}

@Codable()
final class PointKey {
  final int x;
  final int y;

  const PointKey(this.x, this.y);

  @override
  bool operator ==(Object other) =>
      other is PointKey && other.x == x && other.y == y;

  @override
  int get hashCode => Object.hash(x, y);
}

@Codable()
final class OpenApiSpecModel {
  final String path;
  final HttpVerb method;
  final Uint8List schemaHash;
  final Uint8List? signature;
  final Map<int, String> responses;
  final Map<HttpVerb, int> rateLimits;
  final Map<String, List<int>> latencyBuckets;

  const OpenApiSpecModel({
    required this.path,
    required this.method,
    required this.schemaHash,
    this.signature,
    this.responses = const {},
    this.rateLimits = const {},
    this.latencyBuckets = const {},
  });
}

@Codable()
final class GridOverlayModel {
  final Map<PointKey, String> cells;

  const GridOverlayModel({this.cells = const {}});
}

// =============================================================================
// 2. Composite Record Keys: Map<(int, String), int> via MapDecoder / MapEncoder
// =============================================================================

final class RecordKeyMapCodable implements Codable<Map<(int, String), int>> {
  const RecordKeyMapCodable();

  @override
  Map<(int, String), int> decode(Decoder decoder) {
    final m = decoder.map();
    final out = <(int, String), int>{};
    while (m.moveNextEntry()) {
      final keySeq = m.keyDecoder().unkeyed();
      if (!keySeq.moveNext()) {
        throw const CodableException('Missing tuple element 0');
      }
      final shard = keySeq.readInt();
      if (!keySeq.moveNext()) {
        throw const CodableException('Missing tuple element 1');
      }
      final region = keySeq.readString();
      out[(shard, region)] = m.valueDecoder().singleValue().readInt();
    }
    return out;
  }

  @override
  void encode(Map<(int, String), int> value, Encoder encoder) {
    final m = encoder.map(length: value.length);
    for (final MapEntry(key: (shard, region), value: count) in value.entries) {
      final keySeq = m.keyEncoder().unkeyed(length: 2);
      keySeq
        ..encodeInt(shard)
        ..encodeString(region);
      m.valueEncoder().singleValue().encodeInt(count);
    }
  }
}

// =============================================================================
// 3. String-Keyed Maps via KeyedEncoder(length:) & KeyedDecoder (Option A)
// =============================================================================

@Codable()
final class StringMapBundle {
  final Map<String, String> emptyLabels;
  final Map<String, String> bulkAttributes;
  final Map<String, int?> nullableScores;
  final Map<String, List<int>> seriesByTag;

  const StringMapBundle({
    required this.emptyLabels,
    required this.bulkAttributes,
    required this.nullableScores,
    required this.seriesByTag,
  });
}

// =============================================================================
// 4. Dynamic Omitted Nullable Fields (1-byte & Multi-byte CBOR Backpatching)
// =============================================================================

final class SparseSlots {
  final List<int?> slots;
  final SparseSlots? nested;

  const SparseSlots(this.slots, {this.nested});
}

final class SparseSlotsCodable implements Codable<SparseSlots> {
  final int totalSlots;

  const SparseSlotsCodable(this.totalSlots);

  @override
  SparseSlots decode(Decoder decoder) {
    final keyed = decoder.keyed();
    final slots = List<int?>.filled(totalSlots, null);
    SparseSlots? nested;
    while (keyed.moveNextKey()) {
      final k = keyed.nextKey();
      if (k == 'nested') {
        nested = keyed.decodeNullableValue(SparseSlotsCodable(totalSlots));
      } else if (k.startsWith('s')) {
        final idx = int.parse(k.substring(1));
        slots[idx] = keyed.readNullableInt();
      } else {
        keyed.skipValue();
      }
    }
    return SparseSlots(slots, nested: nested);
  }

  @override
  void encode(SparseSlots value, Encoder encoder) {
    final keyed = encoder.keyed();
    for (var i = 0; i < value.slots.length; i++) {
      keyed.encodeNullableInt('s$i', value.slots[i]);
    }
    keyed.encodeNullableValue(
      'nested',
      value.nested,
      SparseSlotsCodable(totalSlots),
    );
  }
}

// =============================================================================
// 5. SuperDecodable Polymorphic Hierarchy
// =============================================================================

sealed class Shape {
  const Shape();
}

@Codable()
final class CircleShape extends Shape {
  final String kind;
  final double radius;
  const CircleShape(this.radius, {this.kind = 'circle'});
}

@Codable()
final class RectShape extends Shape {
  final String kind;
  final int width;
  final int height;
  const RectShape(this.width, this.height, {this.kind = 'rect'});
}

final class ShapeCodable extends SuperDecodable<Shape>
    implements Codable<Shape> {
  const ShapeCodable();

  @override
  String get discriminatorKey => 'kind';

  @override
  Map<String, Decodable<Shape>> get subtypes => const {
    'circle': CircleShapeCodable(),
    'rect': RectShapeCodable(),
  };

  @override
  void encode(Shape value, Encoder encoder) {
    switch (value) {
      case final CircleShape circle:
        const CircleShapeCodable().encode(circle, encoder);
      case final RectShape rect:
        const RectShapeCodable().encode(rect, encoder);
    }
  }
}

// =============================================================================
// 6. Format-Adaptive `isHumanReadable` Uuid & DateTime Codecs
// =============================================================================

final class UuidValue {
  final Uint8List bytes;

  UuidValue(this.bytes) {
    if (bytes.length != 16) {
      throw CodableException('Expected 16-byte UUID, got ${bytes.length}');
    }
  }

  factory UuidValue.parse(String text) {
    final hex = text.replaceAll('-', '');
    if (text.length != 36 || hex.length != 32) {
      throw CodableException('Invalid canonical UUID string: "$text"');
    }
    final out = Uint8List(16);
    for (var i = 0; i < 16; i++) {
      final byteVal = int.tryParse(hex.substring(i * 2, i * 2 + 2), radix: 16);
      if (byteVal == null) {
        throw CodableException('Invalid hex in UUID: "$text"');
      }
      out[i] = byteVal;
    }
    return UuidValue(out);
  }

  String toCanonicalString() {
    final sb = StringBuffer();
    for (var i = 0; i < 16; i++) {
      if (i == 4 || i == 6 || i == 8 || i == 10) sb.write('-');
      sb.write(bytes[i].toRadixString(16).padLeft(2, '0'));
    }
    return sb.toString();
  }

  @override
  bool operator ==(Object other) =>
      other is UuidValue && _matchesAt(bytes, 0, other.bytes);

  @override
  int get hashCode => Object.hashAll(bytes);
}

final class AdaptiveUuidCodable implements Codable<UuidValue> {
  const AdaptiveUuidCodable();

  @override
  UuidValue decode(Decoder decoder) => decoder.isHumanReadable
      ? UuidValue.parse(decoder.singleValue().readString())
      : UuidValue(decoder.singleValue().readBytes());

  @override
  void encode(UuidValue value, Encoder encoder) {
    if (encoder.isHumanReadable) {
      encoder.singleValue().encodeString(value.toCanonicalString());
    } else {
      encoder.singleValue().encodeBytes(value.bytes);
    }
  }
}

final class AdaptiveDateTimeCodable implements Codable<DateTime> {
  const AdaptiveDateTimeCodable();

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
final class AuditEvent {
  @CodableKey(codable: AdaptiveUuidCodable())
  final UuidValue id;

  @CodableKey(codable: AdaptiveDateTimeCodable())
  final DateTime timestamp;

  final String action;

  const AuditEvent({
    required this.id,
    required this.timestamp,
    required this.action,
  });
}

final class _ProbeCompiledTable {
  final List<int> codeUnits;
  _ProbeCompiledTable(List<String> keys)
    : codeUnits = [for (final k in keys) k.length];
}

// =============================================================================
// Test Suite
// =============================================================================

void main() {
  _registerGeneratedModelTests();
  _registerStringKeyedMapTests();
  _registerCompiledKeyOptionsTests();
  _registerScalarMapAndBytesTests();
  _registerCompositeMapTests();
  _registerBackpatchingTests();
  _registerPolymorphicTests();
  _registerYamlDiagnosticTests();
  _registerHumanReadableTests();
  _registerCborFidelityAndTruncationTests();
}

void _registerGeneratedModelTests() {
  group('Cross-format @Codable generated model roundtrip', () {
    test('Person/Order/OrderItem roundtrips across JSON, YAML, and CBOR', () {
      final person = Person(
        firstName: 'Ada',
        lastName: 'Lovelace',
        dateOfBirth: DateTime.utc(1815, 12, 10),
        orders: const [
          Order(
            dateUs: 1700000000123,
            count: 3,
            item: OrderItem(count: 3, itemNumber: 99, isRushed: true),
          ),
        ],
      );

      final fromJson1 = _roundtripJson(person, const PersonCodable());
      final (fromCbor, cborBytes) = _roundtripCbor(
        person,
        const PersonCodable(),
      );
      final fromYaml = _roundtripYaml(person, const PersonCodable());
      final fromJson2 = _roundtripJson(person, const PersonCodable());

      _assertNoIndefiniteMarkers(cborBytes);
      for (final decoded in [fromJson1, fromCbor, fromYaml, fromJson2]) {
        check(decoded.firstName).equals('Ada');
        check(decoded.middleName).isNull();
        check(decoded.lastName).equals('Lovelace');
        check(decoded.dateOfBirth).equals(DateTime.utc(1815, 12, 10));
        check(decoded.orders.length).equals(1);
        check(decoded.orders.single.dateUs).equals(1700000000123);
        check(decoded.orders.single.item?.itemNumber).equals(99);
      }
    });
  });
}

void _registerStringKeyedMapTests() {
  group('Map<String, V> via KeyedEncoder(length:) and KeyedDecoder', () {
    test(
      'roundtrips empty (length: 0), >= 25 entries, nullable, and list maps',
      () {
        final bulk = <String, String>{
          for (var i = 0; i < 30; i++) 'k_$i': 'val_$i',
        };
        final bundle = StringMapBundle(
          emptyLabels: const {},
          bulkAttributes: bulk,
          nullableScores: const {'alpha': 7, 'beta': null, 'gamma': -4},
          seriesByTag: const {
            'latencies': [12, 24, 48],
            'empty': [],
          },
        );

        final fromJson = _roundtripJson(bundle, const StringMapBundleCodable());
        final fromYaml = _roundtripYaml(bundle, const StringMapBundleCodable());
        final (fromCbor, cborBytes) = _roundtripCbor(
          bundle,
          const StringMapBundleCodable(),
        );

        _assertNoIndefiniteMarkers(cborBytes);
        check(_containsSubsequence(cborBytes, const [0xb8, 30])).isTrue();

        for (final r in [fromJson, fromYaml, fromCbor]) {
          check(r.emptyLabels).isEmpty();
          check(r.bulkAttributes).deepEquals(bulk);
          check(r.nullableScores)
              .deepEquals({'alpha': 7, 'beta': null, 'gamma': -4});
          check(r.nullableScores.containsKey('beta')).isTrue();
          check(r.seriesByTag).deepEquals({
            'latencies': [12, 24, 48],
            'empty': <int>[],
          });
        }
      },
    );

    test(
      'encodes standalone empty Map<String, String> as 1-byte CBOR 0xa0',
      () {
        final rootStringMapCodec = Codable<Map<String, String>>.fromFunctions(
          decode: (d) {
            final k = d.keyed();
            return {for (; k.moveNextKey();) k.nextKey(): k.readString()};
          },
          encode: (v, e) {
            final k = e.keyed(length: v.length);
            for (final MapEntry(:key, :value) in v.entries) {
              k.encodeString(key, value);
            }
          },
        );
        final (fromCbor, cborBytes) = _roundtripCbor(
          const <String, String>{},
          rootStringMapCodec,
        );
        check(cborBytes).deepEquals(Uint8List.fromList([0xa0]));
        check(fromCbor).isEmpty();
        check(_roundtripJson(const <String, String>{}, rootStringMapCodec))
            .isEmpty();
        check(_roundtripYaml(const <String, String>{}, rootStringMapCodec))
            .isEmpty();
      },
    );
  });
}

void _registerCompiledKeyOptionsTests() {
  group('KeyOptions.compiled<T> multi-driver caching', () {
    test('caches distinct compiled tables across JSON, CBOR, and YAML', () {
      final spec = OpenApiSpecModel(
        path: '/v2/cache',
        method: HttpVerb.delete,
        schemaHash: Uint8List.fromList([1, 2, 3, 4]),
        responses: const {204: 'no content'},
        rateLimits: const {HttpVerb.delete: 50},
      );
      final jsonStr = JsonCodableEncoder.encode(
        spec,
        const OpenApiSpecModelCodable(),
      );
      final jsonUtf8 = Uint8List.fromList(utf8.encode(jsonStr));
      final cborBytes = CborCodableEncoder.encode(
        spec,
        const OpenApiSpecModelCodable(),
      );
      final yamlStr = YamlCodableEncoder.encode(
        spec,
        const OpenApiSpecModelCodable(),
      );

      final sharedOptions = _$OpenApiSpecModelSchema.keyOptions;
      var probeCompiles = 0;
      _ProbeCompiledTable compileProbe(List<String> keys) {
        probeCompiles++;
        return _ProbeCompiledTable(keys);
      }

      final firstProbe = sharedOptions.compiled<_ProbeCompiledTable>(
        compileProbe,
      );
      for (var round = 0; round < 3; round++) {
        final j1 = const OpenApiSpecModelCodable().decode(
          JsonCodableDecoder.fromString(jsonStr),
        );
        final c1 = CborCodableDecoder.decode(
          cborBytes,
          const OpenApiSpecModelCodable(),
        );
        final j2 = const OpenApiSpecModelCodable().decode(
          JsonCodableDecoder.fromBytes(jsonUtf8),
        );
        final y1 = YamlCodableDecoder.decode(
          yamlStr,
          const OpenApiSpecModelCodable(),
        );
        for (final r in [j1, c1, j2, y1]) {
          check(r.path).equals('/v2/cache');
          check(r.method).equals(HttpVerb.delete);
          check(r.responses).deepEquals({204: 'no content'});
        }
        final cachedProbe = sharedOptions.compiled<_ProbeCompiledTable>(
          compileProbe,
        );
        check(identical(firstProbe, cachedProbe)).isTrue();
      }
      check(probeCompiles).equals(1);
    });
  });
}

void _registerScalarMapAndBytesTests() {
  group('@Codable Map<int/Enum, V> and Uint8List across JSON, YAML, CBOR', () {
    test(
      'emits raw CBOR bstr + int keys and Base64 + text keys on JSON/YAML',
      () {
        final rawBytes = Uint8List.fromList([for (var i = 1; i <= 20; i++) i]);
        final spec = OpenApiSpecModel(
          path: '/v1/items',
          method: HttpVerb.post,
          schemaHash: rawBytes,
          responses: const {200: 'ok', 404: 'not found'},
          rateLimits: const {HttpVerb.get: 1000, HttpVerb.post: 250},
          latencyBuckets: const {
            'p50': [5, 10],
          },
        );

        final jsonText = JsonCodableEncoder.encode(
          spec,
          const OpenApiSpecModelCodable(),
        );
        final yamlText = YamlCodableEncoder.encode(
          spec,
          const OpenApiSpecModelCodable(),
        );
        final (fromCbor, cborBytes) = _roundtripCbor(
          spec,
          const OpenApiSpecModelCodable(),
        );

        check(jsonText).contains(base64Encode(rawBytes));
        check(yamlText).contains(base64Encode(rawBytes));
        check(_containsSubsequence(cborBytes, [0x54, ...rawBytes])).isTrue();
        check(_containsSubsequence(cborBytes, const [0x18, 0xc8])).isTrue();
        check(_containsSubsequence(cborBytes, const [0x19, 0x01, 0x94]))
            .isTrue();
        _assertNoIndefiniteMarkers(cborBytes);

        final fromJson = const OpenApiSpecModelCodable().decode(
          JsonCodableDecoder.fromString(jsonText),
        );
        final fromYaml = YamlCodableDecoder.decode(
          yamlText,
          const OpenApiSpecModelCodable(),
        );

        for (final r in [fromJson, fromYaml, fromCbor]) {
          check(r.path).equals('/v1/items');
          check(r.method).equals(HttpVerb.post);
          check(r.schemaHash).deepEquals(rawBytes);
          check(r.signature).isNull();
          check(r.responses).deepEquals({200: 'ok', 404: 'not found'});
          check(r.rateLimits)
              .deepEquals({HttpVerb.get: 1000, HttpVerb.post: 250});
          check(r.latencyBuckets).deepEquals({
            'p50': [5, 10],
          });
        }
      },
    );

    test(
      'decodes unquoted int keys and [0..255] byte lists, rejecting >255',
      () {
        const handWrittenYaml = '''
path: /health
method: get
schemaHash: [0, 127, 255]
responses:
  200: ok
  404: not found
rateLimits:
  delete: 10
''';
        final decoded = YamlCodableDecoder.decode(
          handWrittenYaml,
          const OpenApiSpecModelCodable(),
        );
        check(decoded.schemaHash).deepEquals([0, 127, 255]);
        check(decoded.responses).deepEquals({200: 'ok', 404: 'not found'});
        check(decoded.rateLimits).deepEquals({HttpVerb.delete: 10});

        check(
          () => YamlCodableDecoder.decode(
            'path: /x\nmethod: get\nschemaHash: [0, 256]\n',
            const OpenApiSpecModelCodable(),
          ),
        ).throws<YamlCodableException>();

        check(
          () => const OpenApiSpecModelCodable().decode(
            JsonCodableDecoder.fromString(
              '{"path":"/x","method":"get","schemaHash":[-1]}',
            ),
          ),
        ).throws<CodableException>();
      },
    );
  });
}

void _registerCompositeMapTests() {
  group('Composite Map<Struct, V> and Map<Record, V> keys', () {
    test(
      'Map<PointKey, String> roundtrips on CBOR/YAML and rejects on JSON',
      () {
        final overlay = GridOverlayModel(
          cells: {
            const PointKey(0, 0): 'origin',
            const PointKey(-5, 12): 'beacon',
          },
        );

        final (fromCbor, cborBytes) = _roundtripCbor(
          overlay,
          const GridOverlayModelCodable(),
        );
        _assertNoIndefiniteMarkers(cborBytes);
        check(fromCbor.cells).deepEquals(overlay.cells);

        final fromYaml = _roundtripYaml(
          overlay,
          const GridOverlayModelCodable(),
        );
        check(fromYaml.cells).deepEquals(overlay.cells);

        check(
          () => JsonCodableEncoder.encode(
            overlay,
            const GridOverlayModelCodable(),
          ),
        ).throws<CodableException>();
      },
    );

    test('Map<(int, String), int> Record keys roundtrip on CBOR and YAML', () {
      final shards = <(int, String), int>{
        (0, 'us-west'): 120,
        (1, 'eu-central'): 85,
      };

      final (fromCbor, cborBytes) = _roundtripCbor(
        shards,
        const RecordKeyMapCodable(),
      );
      _assertNoIndefiniteMarkers(cborBytes);
      check(fromCbor).deepEquals(shards);

      final fromYaml = _roundtripYaml(shards, const RecordKeyMapCodable());
      check(fromYaml).deepEquals(shards);

      check(
        () => JsonCodableEncoder.encode(shards, const RecordKeyMapCodable()),
      ).throws<CodableException>();
    });
  });
}

Codable<List<int>> _unknownLengthIntListCodec(int expectedLength) =>
    Codable<List<int>>.fromFunctions(
      decode: (d) {
        final u = d.unkeyed();
        check(u.length).equals(expectedLength);
        return [for (; u.moveNext();) u.readInt()];
      },
      encode: (values, e) {
        final u = e.unkeyed();
        for (final item in values) {
          u.encodeInt(item);
        }
      },
    );

List<int?> _prefixSlots(int total, int populated, int Function(int) valueAt) =>
    List<int?>.generate(total, (i) => i < populated ? valueAt(i) : null);

void _testOneByteBackpatch() {
  final slots = List<int?>.filled(30, null);
  for (var i = 0; i < 5; i++) {
    slots[i * 4] = i + 100;
  }
  final model = SparseSlots(slots);
  const codec = SparseSlotsCodable(30);

  final (fromCbor, cborBytes) = _roundtripCbor(model, codec);
  final fromJson = _roundtripJson(model, codec);
  final fromYaml = _roundtripYaml(model, codec);

  check(cborBytes[0]).equals(0xa5);
  _assertNoIndefiniteMarkers(cborBytes);
  check(fromCbor.slots).deepEquals(slots);
  check(fromJson.slots).deepEquals(slots);
  check(fromYaml.slots).deepEquals(slots);
}

void _testShiftedBackpatch() {
  final outerSlots = _prefixSlots(30, 26, (i) => i * 10);
  final innerSlots = _prefixSlots(30, 25, (i) => i + 1);
  final model = SparseSlots(outerSlots, nested: SparseSlots(innerSlots));
  const codec = SparseSlotsCodable(30);

  final (fromCbor, cborBytes) = _roundtripCbor(model, codec);
  final fromJson = _roundtripJson(model, codec);
  final fromYaml = _roundtripYaml(model, codec);

  check(cborBytes[0]).equals(0xb8);
  check(cborBytes[1]).equals(27);
  _assertNoIndefiniteMarkers(cborBytes);
  check(fromCbor.slots).deepEquals(outerSlots);
  check(fromCbor.nested)
      .isNotNull()
      .has((n) => n.slots, 'slots')
      .deepEquals(innerSlots);
  check(fromJson.slots).deepEquals(outerSlots);
  check(fromYaml.nested)
      .isNotNull()
      .has((n) => n.slots, 'slots')
      .deepEquals(innerSlots);
}

void _registerBackpatchingTests() {
  group('CBOR definite-length backpatching for omitted nullable fields', () {
    test(
      'patches 1-byte header in O(1) when 0 < count < 24',
      _testOneByteBackpatch,
    );
    test(
      'shifts buffer right and patches 2-byte header when count >= 25',
      _testShiftedBackpatch,
    );
    test('patches 3-byte array header when unknown-length iterable >= 256', () {
      final values = List<int>.generate(260, (i) => i % 20);
      final (decoded, cborBytes) = _roundtripCbor(
        values,
        _unknownLengthIntListCodec(260),
      );
      check(cborBytes[0]).equals(0x99);
      check(cborBytes[1]).equals(0x01);
      check(cborBytes[2]).equals(0x04);
      _assertNoIndefiniteMarkers(cborBytes);
      check(decoded).deepEquals(values);
    });
  });
}

void _registerPolymorphicTests() {
  group('SuperDecodable polymorphism across JSON, YAML, and CBOR', () {
    test('mapped() -> keyed() handoff decodes subtypes in all 3 formats', () {
      const shapes = <Shape>[CircleShape(4.5), RectShape(16, 9)];
      final listCodec = const ShapeCodable().list;

      final fromJson = _roundtripJson(shapes, listCodec);
      final fromYaml = _roundtripYaml(shapes, listCodec);
      final (fromCbor, cborBytes) = _roundtripCbor(shapes, listCodec);
      _assertNoIndefiniteMarkers(cborBytes);

      for (final list in [fromJson, fromYaml, fromCbor]) {
        check(list.length).equals(2);
        check(list[0])
            .isA<CircleShape>()
            .has((c) => c.radius, 'radius')
            .equals(4.5);
        check(list[1])
            .isA<RectShape>()
            .has((r) => (r.width, r.height), 'dims')
            .equals((16, 9));
      }

      final paddedJson =
          '{"padding":"${'x' * 2200}","width":32,"height":64,"kind":"rect"}';
      final trailingJson = const ShapeCodable().decode(
        JsonCodableDecoder.fromString(paddedJson),
      );
      check(trailingJson)
          .isA<RectShape>()
          .has((r) => (r.width, r.height), 'dims')
          .equals((32, 64));

      final trailingYaml = YamlCodableDecoder.decode(
        'radius: 12.25\nkind: circle\n',
        const ShapeCodable(),
      );
      check(trailingYaml)
          .isA<CircleShape>()
          .has((c) => c.radius, 'radius')
          .equals(12.25);
    });
  });
}

void _registerYamlDiagnosticTests() {
  group('YAML SourceSpan diagnostics in cross-format models', () {
    test('reports scalar span, nested path, and missing field span', () {
      const badTypeYaml = '''
firstName: Grace
lastName: Hopper
dob: '1906-12-09T00:00:00.000Z'
orders:
  - dateUs: 100
    count: wrong_int
''';
      YamlCodableException? caught;
      try {
        YamlCodableDecoder.decode(
          badTypeYaml,
          const PersonCodable(),
          sourceUrl: Uri.parse('person.yaml'),
        );
      } on YamlCodableException catch (e) {
        caught = e;
      }

      check(caught).isNotNull();
      final span = caught!.span!;
      check(span.start.line).equals(5);
      check(span.start.column).equals(11);
      check(span.text).equals('wrong_int');
      check(caught.formattedPath).equals('orders[0].count');
      check(caught.toString()).contains('line 6, column 12 of person.yaml');

      const missingFieldYaml = '''
# incomplete operation
path: /v1/orders
schemaHash: AQID
''';
      YamlCodableException? missingErr;
      try {
        YamlCodableDecoder.decode(
          missingFieldYaml,
          const OpenApiSpecModelCodable(),
        );
      } on YamlCodableException catch (e) {
        missingErr = e;
      }
      check(missingErr).isNotNull();
      check(missingErr!.span!.start.line).equals(1);
      check(missingErr.message).contains('Missing required fields');
    });
  });
}

void _registerHumanReadableTests() {
  group('Format-adaptive isHumanReadable Uuid and DateTime codecs', () {
    test('switches between strings on JSON/YAML and binary/int on CBOR', () {
      const uuidStr = '550e8400-e29b-41d4-a716-446655440000';
      final uuid = UuidValue.parse(uuidStr);
      final ts = DateTime.utc(2026, 11, 5, 4, 30, 15, 250);
      final event = AuditEvent(id: uuid, timestamp: ts, action: 'login');

      final jsonText = JsonCodableEncoder.encode(
        event,
        const AuditEventCodable(),
      );
      final yamlText = YamlCodableEncoder.encode(
        event,
        const AuditEventCodable(),
      );
      final (fromCbor, cborBytes) = _roundtripCbor(
        event,
        const AuditEventCodable(),
      );

      check(jsonText).contains(uuidStr);
      check(jsonText).contains('2026-11-05T04:30:15.250Z');
      check(yamlText).contains(uuidStr);
      check(yamlText).contains('2026-11-05T04:30:15.250Z');

      check(_containsSubsequence(cborBytes, [0x50, ...uuid.bytes])).isTrue();
      check(cborBytes).contains(0x1b);
      check(cborBytes.length).isLessThan(utf8.encode(jsonText).length);
      _assertNoIndefiniteMarkers(cborBytes);

      final fromJson = const AuditEventCodable().decode(
        JsonCodableDecoder.fromString(jsonText),
      );
      final fromYaml = YamlCodableDecoder.decode(
        yamlText,
        const AuditEventCodable(),
      );

      for (final decoded in [fromJson, fromYaml, fromCbor]) {
        check(decoded.id).equals(uuid);
        check(decoded.timestamp).equals(ts);
        check(decoded.action).equals('login');
      }
    });
  });
}

void _registerCborFidelityAndTruncationTests() {
  group('CBOR RFC 8949 float16/float32, spans, and truncation bounds', () {
    test('decodes RFC 8949 float16/float32 vectors and UTF-8 string spans', () {
      final floatVec = Uint8List.fromList([
        0x83,
        0xf9,
        0x3e,
        0x00,
        0xf9,
        0xfc,
        0x00,
        0xfa,
        0x47,
        0xc3,
        0x50,
        0x00,
      ]);
      final floats = CborCodableDecoder.decode(
        floatVec,
        Decodable.fromFunction((d) {
          final u = d.unkeyed();
          return [for (; u.moveNext();) u.readDouble()];
        }),
      );
      check(floats).deepEquals([1.5, double.negativeInfinity, 100000.0]);

      final strBytes = CborCodableEncoder.encode<String>(
        'codable-cbor',
        Encodable<String>.fromFunction(
          (v, e) => e.singleValue().encodeString(v),
        ),
      );
      final spanText = CborCodableDecoder.decode(
        strBytes,
        Decodable.fromFunction((d) {
          final (start, end) = d.singleValue().readStringSpan();
          return utf8.decode(d.payload!.sublist(start, end));
        }),
      );
      check(spanText).equals('codable-cbor');
    });

    test('rejects every truncated prefix of an encoded CBOR model cleanly', () {
      final valid = CborCodableEncoder.encode(
        OpenApiSpecModel(
          path: '/v1/bounds',
          method: HttpVerb.get,
          schemaHash: Uint8List.fromList([10, 20, 30, 40]),
          responses: const {200: 'ok'},
        ),
        const OpenApiSpecModelCodable(),
      );
      for (var len = 0; len < valid.length; len++) {
        final truncated = valid.sublist(0, len);
        check(
          () => CborCodableDecoder.decode(
            truncated,
            const OpenApiSpecModelCodable(),
          ),
        ).throws<CodableException>();
      }
    });
  });
}
