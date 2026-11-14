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
import 'package:codable_toml/codable_toml.dart';
import 'package:codable_toml/src/toml_types.dart'
    show TomlNativeDateTimeSink, TomlNativeDateTimeSource;
import 'package:codable_yaml/codable_yaml.dart';
import 'package:test/test.dart';

import '../example/codable_toml_example.dart';
import 'fuzz/toml_fuzz.dart';

part 'cross_format_test.g.dart';

// =============================================================================
// 5-Way Cross-Format Roundtrip Helpers
// (JSON <-> YAML <-> CBOR <-> MessagePack <-> TOML)
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

(T, Uint8List) _roundtripMsgPack<T>(T value, Codable<T> codable) {
  final bytes = MsgPackCodableEncoder.encode(
    value,
    codable,
    requireKnownLength: true,
  );
  return (MsgPackCodableDecoder.decode(bytes, codable), bytes);
}

(T, String, Uint8List) _roundtripToml<T>(T value, Codable<T> codable) {
  final toml = TomlCodableEncoder.encode(value, codable);
  final bytes = TomlCodableEncoder.toBytes(value, codable);
  fuzzTarget(bytes);
  final fromText = TomlCodableDecoder.decode(toml, codable);
  final fromBytes = TomlCodableDecoder.decodeBytes(bytes, codable);
  check(TomlCodableEncoder.encode(fromBytes, codable)).equals(toml);
  return (fromText, toml, bytes);
}

/// Chains [value] sequentially through all 5 formats (`JSON -> YAML -> CBOR ->
/// MessagePack -> TOML`) and back (`TOML -> JSON`), returning every hop.
List<T> _roundtripAllFiveFormats<T>(T value, Codable<T> codable) {
  final fromJson = _roundtripJson(value, codable);
  final fromYaml = _roundtripYaml(fromJson, codable);
  final (fromCbor, _) = _roundtripCbor(fromYaml, codable);
  final (fromMsgPack, _) = _roundtripMsgPack(fromCbor, codable);
  final (fromToml, _, _) = _roundtripToml(fromMsgPack, codable);
  final backToJson = _roundtripJson(fromToml, codable);
  return [fromJson, fromYaml, fromCbor, fromMsgPack, fromToml, backToJson];
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
// 1. Interleaved Field Declaration Order Models
// =============================================================================

@Codable()
final class RetryPolicy {
  final int maxAttempts;
  final double backoffMultiplier;

  const RetryPolicy({
    required this.maxAttempts,
    required this.backoffMultiplier,
  });

  @override
  bool operator ==(Object other) =>
      other is RetryPolicy &&
      other.maxAttempts == maxAttempts &&
      other.backoffMultiplier == backoffMultiplier;

  @override
  int get hashCode => Object.hash(maxAttempts, backoffMultiplier);
}

@Codable()
final class SubtableSpec {
  final String host;
  final int port;
  final bool tls;

  const SubtableSpec({
    required this.host,
    required this.port,
    required this.tls,
  });

  @override
  bool operator ==(Object other) =>
      other is SubtableSpec &&
      other.host == host &&
      other.port == port &&
      other.tls == tls;

  @override
  int get hashCode => Object.hash(host, port, tls);
}

/// Declares nested [RetryPolicy] BEFORE scalar fields inside an array-of-tables
/// item.
@Codable()
final class EndpointItem {
  final RetryPolicy retry;
  final String path;
  final int rateLimit;

  const EndpointItem({
    required this.retry,
    required this.path,
    required this.rateLimit,
  });

  @override
  bool operator ==(Object other) =>
      other is EndpointItem &&
      other.retry == retry &&
      other.path == path &&
      other.rateLimit == rateLimit;

  @override
  int get hashCode => Object.hash(retry, path, rateLimit);
}

/// Declares nested struct [subtable] and `List<EndpointItem>` [items] BEFORE
/// scalar [version], [serviceName], and [enabled].
@Codable()
final class InterleavedServiceConfig {
  final SubtableSpec subtable;
  final List<EndpointItem> items;
  final int version;
  final String serviceName;
  final bool enabled;

  const InterleavedServiceConfig({
    required this.subtable,
    required this.items,
    required this.version,
    required this.serviceName,
    required this.enabled,
  });
}

// =============================================================================
// 2. Deeply Nested Tables (a.b.c), Empty Structs, & 2D Inline-Table Fallback
// =============================================================================

@Codable()
final class EmptyMarker {
  const EmptyMarker();

  @override
  bool operator ==(Object other) => other is EmptyMarker;

  @override
  int get hashCode => 0;
}

@Codable()
final class LevelC {
  final String region;
  final int replicas;

  const LevelC({required this.region, required this.replicas});

  @override
  bool operator ==(Object other) =>
      other is LevelC && other.region == region && other.replicas == replicas;

  @override
  int get hashCode => Object.hash(region, replicas);
}

@Codable()
final class LevelB {
  final LevelC c;

  const LevelB({required this.c});

  @override
  bool operator ==(Object other) => other is LevelB && other.c == c;

  @override
  int get hashCode => c.hashCode;
}

@Codable()
final class LevelA {
  final LevelB b;

  const LevelA({required this.b});

  @override
  bool operator ==(Object other) => other is LevelA && other.b == b;

  @override
  int get hashCode => b.hashCode;
}

@Codable()
final class GridCell {
  final int x;
  final int y;
  final String tag;

  const GridCell({required this.x, required this.y, required this.tag});

  @override
  bool operator ==(Object other) =>
      other is GridCell && other.x == x && other.y == y && other.tag == tag;

  @override
  int get hashCode => Object.hash(x, y, tag);
}

@Codable()
final class StructuralHierarchyModel {
  final LevelA a;
  final AllOptionalPatch empty;
  final List<GridCell> emptyItems;
  final List<GridCell> activeItems;
  final List<List<GridCell>> matrix;
  final List<List<AllOptionalPatch>> emptyMatrix;
  final String title;

  const StructuralHierarchyModel({
    required this.a,
    required this.empty,
    required this.emptyItems,
    required this.activeItems,
    required this.matrix,
    required this.emptyMatrix,
    required this.title,
  });
}

// =============================================================================
// 3. Nullable @Codable() Fields Across Scalars, Structs, Binary & Collections
// =============================================================================

@Codable()
final class AllOptionalPatch {
  final int? alpha;
  final String? beta;
  final bool? gamma;

  const AllOptionalPatch({this.alpha, this.beta, this.gamma});

  @override
  bool operator ==(Object other) =>
      other is AllOptionalPatch &&
      other.alpha == alpha &&
      other.beta == beta &&
      other.gamma == gamma;

  @override
  int get hashCode => Object.hash(alpha, beta, gamma);
}

@Codable()
final class NullableShowcase {
  final String id;
  final int? optInt;
  final double? optDouble;
  final String? optString;
  final bool? optBool;
  final LevelC? optStruct;
  final AllOptionalPatch? optEmpty;
  final Uint8List? optBytes;
  final List<String>? optStringList;
  final List<GridCell>? optStructList;
  final Set<int>? optIntSet;
  final Map<String, int>? optStringMap;
  final Map<int, String>? optIntMap;

  const NullableShowcase({
    required this.id,
    this.optInt,
    this.optDouble,
    this.optString,
    this.optBool,
    this.optStruct,
    this.optEmpty,
    this.optBytes,
    this.optStringList,
    this.optStructList,
    this.optIntSet,
    this.optStringMap,
    this.optIntMap,
  });
}

// =============================================================================
// 4. Typed Maps, Uint8List, @CodableTuple, & SuperDecodable Sealed Hierarchies
// =============================================================================

enum HttpVerb { get, post, put, delete }

@Codable()
final class TypedFeaturesEnvelope {
  final Map<String, List<int>> stringBuckets;
  final Map<String, LevelC> namedTargets;
  final Map<int, String> statusMessages;
  final Map<HttpVerb, int> verbQuotas;
  final Uint8List binaryPayload;
  final Uint8List emptyPayload;
  final Float64List coords;
  final Float64List? normal;

  const TypedFeaturesEnvelope({
    required this.stringBuckets,
    required this.namedTargets,
    required this.statusMessages,
    required this.verbQuotas,
    required this.binaryPayload,
    required this.emptyPayload,
    @CodableTuple(2) required this.coords,
    @CodableTuple(3) this.normal,
  });
}

sealed class ShapeSpec {
  const ShapeSpec();
}

@Codable()
final class CircleSpec extends ShapeSpec {
  final LevelC? meta;
  final double radius;
  final String? label;
  final String kind;

  const CircleSpec({
    this.meta,
    required this.radius,
    this.label,
    this.kind = 'circle',
  });
}

@Codable()
final class PolygonSpec extends ShapeSpec {
  final List<int> vertices;
  final bool closed;
  final String kind;

  const PolygonSpec({
    required this.vertices,
    this.closed = true,
    this.kind = 'polygon',
  });
}

final class ShapeSpecCodable extends SuperDecodable<ShapeSpec>
    implements Codable<ShapeSpec> {
  const ShapeSpecCodable();

  @override
  String get discriminatorKey => 'kind';

  @override
  Map<String, Decodable<ShapeSpec>> get subtypes => const {
    'circle': CircleSpecCodable(),
    'polygon': PolygonSpecCodable(),
  };

  @override
  void encode(ShapeSpec value, Encoder encoder) {
    switch (value) {
      case final CircleSpec circle:
        const CircleSpecCodable().encode(circle, encoder);
      case final PolygonSpec polygon:
        const PolygonSpecCodable().encode(polygon, encoder);
    }
  }
}

@Codable()
final class PolymorphicCanvas {
  @CodableKey(codable: ShapeSpecCodable())
  final ShapeSpec hero;

  @CodableKey(codable: ShapeSpecCodable())
  final ShapeSpec? secondary;

  final String canvasId;

  const PolymorphicCanvas({
    required this.hero,
    this.secondary,
    required this.canvasId,
  });
}

// =============================================================================
// 5. TomlDateTimeCodec vs. Date-Looking Strings
// =============================================================================

@Codable()
final class TimestampCollisionModel {
  @CodableKey(codable: TomlDateTimeCodec())
  final DateTime timestamp;

  @CodableKey(codable: TomlDateTimeCodec())
  final DateTime? expiresAt;

  final String rawIsoString;
  final String rawLocalDateString;
  final String rawLocalTimeString;

  const TimestampCollisionModel({
    required this.timestamp,
    this.expiresAt,
    required this.rawIsoString,
    required this.rawLocalDateString,
    required this.rawLocalTimeString,
  });
}

final class NativeTomlDateTimeCodable implements Codable<TomlDateTime> {
  const NativeTomlDateTimeCodable();

  @override
  TomlDateTime decode(Decoder decoder) {
    final sv = decoder.singleValue();
    if (sv is TomlNativeDateTimeSource) {
      final dt = (sv as TomlNativeDateTimeSource).tryReadTomlDateTime();
      if (dt != null) return dt;
    }
    throw const TomlCodableException('Expected native TomlDateTime literal');
  }

  @override
  void encode(TomlDateTime value, Encoder encoder) {
    final sv = encoder.singleValue();
    if (sv is TomlNativeDateTimeSink) {
      (sv as TomlNativeDateTimeSink).writeTomlDateTime(value);
      return;
    }
    sv.encodeString(value.raw);
  }
}

@Codable()
final class LocalDateTimesRecord {
  @CodableKey(codable: TomlDateTimeCodec())
  final DateTime offsetInstant;

  @CodableKey(codable: TomlDateTimeCodec())
  final DateTime localWallClock;

  @CodableKey(codable: TomlDateTimeCodec())
  final DateTime calendarDay;

  @CodableKey(codable: NativeTomlDateTimeCodable())
  final TomlDateTime? dailyWindow;

  const LocalDateTimesRecord({
    required this.offsetInstant,
    required this.localWallClock,
    required this.calendarDay,
    this.dailyWindow,
  });
}

// =============================================================================
// 6. TOML v1.0 Structural Boundary Rejection Models
// =============================================================================

@Codable()
final class NullableElementListModel {
  final List<int?> values;

  const NullableElementListModel({required this.values});
}

@Codable()
final class NullableStringMapModel {
  final Map<String, int?> scores;

  const NullableStringMapModel({required this.scores});
}

@Codable()
final class NullableIntMapModel {
  final Map<int, int?> buckets;

  const NullableIntMapModel({required this.buckets});
}

@Codable()
final class CompositeMapKeyModel {
  final Map<GridCell, String> cells;

  const CompositeMapKeyModel({required this.cells});
}

// =============================================================================
// Test Suite Registration
// =============================================================================

void main() {
  _registerInterleavedOrderingTests();
  _registerHierarchyAndInlineTableTests();
  _registerNullableFieldTests();
  _registerMapsBytesTupleAndPolymorphicTests();
  _registerDateTimeVsDateStringTests();
  _registerStructuralBoundaryRejectionTests();
}

void _registerInterleavedOrderingTests() {
  group('Interleaved field declaration order & 5-way roundtrip', () {
    test(
      'emits scalars before [subtable] and [[items]] and roundtrips 5 ways',
      () {
        const config = InterleavedServiceConfig(
          subtable: SubtableSpec(host: 'db.internal', port: 5432, tls: true),
          items: [
            EndpointItem(
              retry: RetryPolicy(maxAttempts: 3, backoffMultiplier: 1.5),
              path: '/v1/orders',
              rateLimit: 250,
            ),
            EndpointItem(
              retry: RetryPolicy(maxAttempts: 5, backoffMultiplier: 2.0),
              path: '/v1/health',
              rateLimit: 1000,
            ),
          ],
          version: 4,
          serviceName: 'checkout-core',
          enabled: true,
        );

        final (_, toml, _) = _roundtripToml(
          config,
          const InterleavedServiceConfigCodable(),
        );

        final versionIdx = toml.indexOf('version = 4');
        final nameIdx = toml.indexOf('serviceName = "checkout-core"');
        final enabledIdx = toml.indexOf('enabled = true');
        final subtableIdx = toml.indexOf('[subtable]');
        final itemsIdx = toml.indexOf('[[items]]');
        final itemPathIdx = toml.indexOf('path = "/v1/orders"');
        final itemRetryIdx = toml.indexOf('[items.retry]');

        check(versionIdx).isGreaterOrEqual(0);
        check(nameIdx).isGreaterThan(versionIdx);
        check(enabledIdx).isGreaterThan(nameIdx);
        check(subtableIdx).isGreaterThan(enabledIdx);
        check(itemsIdx).isGreaterThan(subtableIdx);
        check(itemPathIdx).isGreaterThan(itemsIdx);
        check(itemRetryIdx).isGreaterThan(itemPathIdx);

        for (final r in _roundtripAllFiveFormats(
          config,
          const InterleavedServiceConfigCodable(),
        )) {
          check(r.version).equals(4);
          check(r.serviceName).equals('checkout-core');
          check(r.enabled).isTrue();
          check(r.subtable).equals(config.subtable);
          check(r.items).deepEquals(config.items);
        }
      },
    );

    test('roundtrips example ServiceManifest across all 5 formats', () {
      final manifest = ServiceManifest(
        database: const DatabaseConfig(host: 'pg-primary.internal', port: 6432),
        endpoints: const [
          EndpointRule(path: '/v1/charges', rateLimit: 500),
          EndpointRule(path: '/v1/refunds', rateLimit: 100),
        ],
        service: 'payments-edge',
        deployedAt: DateTime.utc(2026, 11, 14, 2, 30),
        statusLabels: const {200: 'ok', 429: 'throttled'},
      );

      for (final r in _roundtripAllFiveFormats(
        manifest,
        const ServiceManifestCodable(),
      )) {
        check(r.service).equals('payments-edge');
        check(r.database.host).equals('pg-primary.internal');
        check(r.database.port).equals(6432);
        check(r.endpoints.length).equals(2);
        check(r.endpoints[0].path).equals('/v1/charges');
        check(r.deployedAt).equals(DateTime.utc(2026, 11, 14, 2, 30));
        check(r.statusLabels).deepEquals(const {200: 'ok', 429: 'throttled'});
      }
    });
  });
}

void _registerHierarchyAndInlineTableTests() {
  group('Deeply nested tables, empty structs, and 2D inline tables', () {
    test('suppresses intermediate headers for a.b.c while preserving [empty] '
        'and 2D inline tables across all 5 formats', () {
      const model = StructuralHierarchyModel(
        a: LevelA(
          b: LevelB(c: LevelC(region: 'us-west1', replicas: 3)),
        ),
        empty: AllOptionalPatch(),
        emptyItems: [],
        activeItems: [
          GridCell(x: 0, y: 1, tag: 'origin'),
          GridCell(x: 2, y: 3, tag: 'edge'),
        ],
        matrix: [
          [
            GridCell(x: 10, y: 20, tag: 'r0c0'),
            GridCell(x: 30, y: 40, tag: 'r0c1'),
          ],
          [],
        ],
        emptyMatrix: [
          [AllOptionalPatch()],
        ],
        title: 'topology-v1',
      );

      final (_, toml, _) = _roundtripToml(
        model,
        const StructuralHierarchyModelCodable(),
      );

      check(toml).startsWith('emptyItems = []\n');
      check(toml).contains(
        'matrix = [[{ x = 10, y = 20, tag = "r0c0" }, '
        '{ x = 30, y = 40, tag = "r0c1" }], []]',
      );
      check(toml).contains('emptyMatrix = [[{}]]');
      check(toml).contains('title = "topology-v1"');
      check(toml).contains('[a.b.c]');
      check(toml).not((it) => it.contains('\n[a]\n'));
      check(toml).not((it) => it.contains('\n[a.b]\n'));
      check(toml).contains('\n[empty]\n');
      check(toml).contains('\n[[activeItems]]\n');

      for (final r in _roundtripAllFiveFormats(
        model,
        const StructuralHierarchyModelCodable(),
      )) {
        check(r.title).equals('topology-v1');
        check(r.a).equals(model.a);
        check(r.empty).equals(const AllOptionalPatch());
        check(r.emptyItems).isEmpty();
        check(r.activeItems).deepEquals(model.activeItems);
        check(r.matrix.length).equals(2);
        check(r.matrix[0]).deepEquals(model.matrix[0]);
        check(r.matrix[1]).isEmpty();
        check(r.emptyMatrix.length).equals(1);
        check(r.emptyMatrix[0]).deepEquals(const [AllOptionalPatch()]);
      }

      const zeroField = EmptyMarker();
      final (tomlZero, zeroTomlText, _) = _roundtripToml(
        zeroField,
        const EmptyMarkerCodable(),
      );
      check(zeroTomlText).equals('');
      check(tomlZero).equals(zeroField);
      for (final r in _roundtripAllFiveFormats(
        zeroField,
        const EmptyMarkerCodable(),
      )) {
        check(r).equals(zeroField);
      }
      check(
        const EmptyMarkerCodable().decode(
          JsonCodableDecoder.fromString('{"ignored": [1, 2], "extra": "ok"}'),
        ),
      ).equals(zeroField);
    });
  });
}

void _registerNullableFieldTests() {
  group('Nullable @Codable() fields across 5 formats', () {
    test(
      'roundtrips all-null, partial-null, and populated AllOptionalPatch',
      _testAllOptionalPatchRoundtrips,
    );

    test(
      'roundtrips NullableShowcase when optional scalars, structs, bytes, and '
      'collections are null vs populated',
      _testNullableShowcaseRoundtrips,
    );
  });
}

void _testAllOptionalPatchRoundtrips() {
  const allNull = AllOptionalPatch();
  const partial = AllOptionalPatch(beta: 'present');
  const full = AllOptionalPatch(alpha: -9, beta: 'full', gamma: false);

  final (_, emptyToml, _) = _roundtripToml(
    allNull,
    const AllOptionalPatchCodable(),
  );
  check(emptyToml).equals('');

  for (final r in _roundtripAllFiveFormats(
    allNull,
    const AllOptionalPatchCodable(),
  )) {
    check(r.alpha).isNull();
    check(r.beta).isNull();
    check(r.gamma).isNull();
  }
  for (final r in _roundtripAllFiveFormats(
    partial,
    const AllOptionalPatchCodable(),
  )) {
    check(r.alpha).isNull();
    check(r.beta).equals('present');
    check(r.gamma).isNull();
  }
  for (final r in _roundtripAllFiveFormats(
    full,
    const AllOptionalPatchCodable(),
  )) {
    check(r.alpha).equals(-9);
    check(r.beta).equals('full');
    check(r.gamma).equals(false);
  }
}

void _testNullableShowcaseRoundtrips() {
  const sparse = NullableShowcase(id: 'sparse-1');
  final populated = NullableShowcase(
    id: 'populated-2',
    optInt: 42,
    optDouble: -3.5,
    optString: 'line1\nline2',
    optBool: true,
    optStruct: const LevelC(region: 'eu-west1', replicas: 2),
    optEmpty: const AllOptionalPatch(),
    optBytes: Uint8List.fromList([0x01, 0x02, 0xfe, 0xff]),
    optStringList: const ['a', 'b'],
    optStructList: const [GridCell(x: 7, y: 8, tag: 'cell')],
    optIntSet: const {10, 20, 30},
    optStringMap: const {'k1': 100, 'k.2': 200},
    optIntMap: const {1: 'one', -2: 'minus-two'},
  );

  final (_, sparseToml, _) = _roundtripToml(
    sparse,
    const NullableShowcaseCodable(),
  );
  check(sparseToml).equals('id = "sparse-1"\n');

  for (final r in _roundtripAllFiveFormats(
    sparse,
    const NullableShowcaseCodable(),
  )) {
    _verifySparseNullableShowcase(r);
  }

  for (final r in _roundtripAllFiveFormats(
    populated,
    const NullableShowcaseCodable(),
  )) {
    _verifyPopulatedNullableShowcase(r);
  }
}

void _verifySparseNullableShowcase(NullableShowcase r) {
  check(r.id).equals('sparse-1');
  check(r.optInt).isNull();
  check(r.optDouble).isNull();
  check(r.optString).isNull();
  check(r.optBool).isNull();
  check(r.optStruct).isNull();
  check(r.optEmpty).isNull();
  check(r.optBytes).isNull();
  check(r.optStringList).isNull();
  check(r.optStructList).isNull();
  check(r.optIntSet).isNull();
  check(r.optStringMap).isNull();
  check(r.optIntMap).isNull();
}

void _verifyPopulatedNullableShowcase(NullableShowcase r) {
  check(r.id).equals('populated-2');
  check(r.optInt).equals(42);
  check(r.optDouble).equals(-3.5);
  check(r.optString).equals('line1\nline2');
  check(r.optBool).equals(true);
  check(r.optStruct).equals(const LevelC(region: 'eu-west1', replicas: 2));
  check(r.optEmpty).equals(const AllOptionalPatch());
  check(r.optBytes).isNotNull().deepEquals([0x01, 0x02, 0xfe, 0xff]);
  check(r.optStringList).isNotNull().deepEquals(['a', 'b']);
  check(r.optStructList)
      .isNotNull()
      .deepEquals(const [GridCell(x: 7, y: 8, tag: 'cell')]);
  check(r.optIntSet).isNotNull().deepEquals(const {10, 20, 30});
  check(r.optStringMap).isNotNull().deepEquals(const {'k1': 100, 'k.2': 200});
  check(r.optIntMap).isNotNull().deepEquals(const {1: 'one', -2: 'minus-two'});
}

void _registerMapsBytesTupleAndPolymorphicTests() {
  group('Typed maps, Uint8List, @CodableTuple, & SuperDecodable', () {
    test(
      'roundtrips Map<String, V>, Map<int, V>, Uint8List, & @CodableTuple',
      () {
        final env = TypedFeaturesEnvelope(
          stringBuckets: const {
            'fast': [1, 2, 5],
            'v1.dotted': [10, 20],
            '': [0],
          },
          namedTargets: const {
            'primary': LevelC(region: 'us-east1', replicas: 4),
            'eu.edge': LevelC(region: 'eu-central1', replicas: 2),
          },
          statusMessages: const {200: 'ok', 404: 'not found', -1: 'synthetic'},
          verbQuotas: const {HttpVerb.get: 5000, HttpVerb.delete: 50},
          binaryPayload: Uint8List.fromList([0x00, 0x7f, 0x80, 0xff]),
          emptyPayload: Uint8List(0),
          coords: Float64List.fromList([37.7749, -122.4194]),
          normal: Float64List.fromList([0.0, 1.0, -0.5]),
        );

        for (final r in _roundtripAllFiveFormats(
          env,
          const TypedFeaturesEnvelopeCodable(),
        )) {
          check(r.stringBuckets['fast']).isNotNull().deepEquals([1, 2, 5]);
          check(r.stringBuckets['v1.dotted']).isNotNull().deepEquals([10, 20]);
          check(r.stringBuckets['']).isNotNull().deepEquals([0]);
          check(r.namedTargets).deepEquals(env.namedTargets);
          check(r.statusMessages).deepEquals(env.statusMessages);
          check(r.verbQuotas).deepEquals(env.verbQuotas);
          check(r.binaryPayload).deepEquals([0x00, 0x7f, 0x80, 0xff]);
          check(r.emptyPayload).isEmpty();
          check(r.coords).deepEquals([37.7749, -122.4194]);
          check(r.normal).isNotNull().deepEquals([0.0, 1.0, -0.5]);
        }
      },
    );

    test('roundtrips SuperDecodable sealed hierarchy across all 5 formats', () {
      const canvas = PolymorphicCanvas(
        hero: CircleSpec(
          meta: LevelC(region: 'us-central1', replicas: 3),
          radius: 12.5,
          label: 'hero-circle',
        ),
        secondary: PolygonSpec(vertices: [3, 4, 5], closed: false),
        canvasId: 'scene-42',
      );

      for (final r in _roundtripAllFiveFormats(
        canvas,
        const PolymorphicCanvasCodable(),
      )) {
        check(r.canvasId).equals('scene-42');
        check(r.hero)
            .isA<CircleSpec>()
            .has((c) => (c.radius, c.label, c.meta), 'circle fields')
            .equals((
              12.5,
              'hero-circle',
              const LevelC(region: 'us-central1', replicas: 3),
            ));
        check(r.secondary).isA<PolygonSpec>().which(
          (it) => it
            ..has((p) => p.vertices, 'vertices').deepEquals(const [3, 4, 5])
            ..has((p) => p.closed, 'closed').equals(false),
        );
      }
    });

    test('decodes SuperDecodable when discriminator appears after keys or '
        'after dotted / out-of-order subtables', () {
      // 1. Root polymorphic table with dotted subtable + other keys BEFORE kind.
      const dottedSubtableFirstToml = '''
meta.region = "ap-northeast1"
meta.replicas = 6
radius = 8.75
label = "after-dotted-subtable"
kind = "circle"
''';
      final fromDotted = TomlCodableDecoder.decode(
        dottedSubtableFirstToml,
        const ShapeSpecCodable(),
      );
      check(fromDotted)
          .isA<CircleSpec>()
          .has((c) => (c.radius, c.label, c.meta), 'circle')
          .equals((
            8.75,
            'after-dotted-subtable',
            const LevelC(region: 'ap-northeast1', replicas: 6),
          ));

      // 2. Out-of-order [hero.meta] subtable section opened BEFORE [hero],
      // with discriminator `kind` placed last inside [hero] and [secondary].
      const outOfOrderSubtableToml = '''
canvasId = "reordered-scene"

[hero.meta]
region = "eu-north1"
replicas = 5

[hero]
radius = 19.0
label = "opened-after-subtable"
kind = "circle"

[secondary]
vertices = [6, 8, 10]
closed = true
kind = "polygon"
''';
      final scene = TomlCodableDecoder.decode(
        outOfOrderSubtableToml,
        const PolymorphicCanvasCodable(),
      );
      check(scene.canvasId).equals('reordered-scene');
      check(scene.hero)
          .isA<CircleSpec>()
          .has((c) => (c.radius, c.label, c.meta), 'hero')
          .equals((
            19.0,
            'opened-after-subtable',
            const LevelC(region: 'eu-north1', replicas: 5),
          ));
      check(scene.secondary).isA<PolygonSpec>().which(
        (it) => it
          ..has((p) => p.vertices, 'vertices').deepEquals(const [6, 8, 10])
          ..has((p) => p.closed, 'closed').equals(true),
      );
    });
  });
}

void _registerDateTimeVsDateStringTests() {
  group('TomlDateTimeCodec vs. date-looking String fields', () {
    test('emits unquoted Offset Date-Time on TOML, ISO string on JSON/YAML, '
        'epoch int on CBOR/MessagePack, and quotes date-looking Strings', () {
      final ts = DateTime.utc(2026, 11, 14, 2, 38, 22, 125);
      final exp = DateTime.utc(2026, 12, 31, 23, 59, 59);
      final model = TimestampCollisionModel(
        timestamp: ts,
        expiresAt: exp,
        rawIsoString: '2026-11-14T00:00:00Z',
        rawLocalDateString: '2026-11-14',
        rawLocalTimeString: '07:32:00',
      );

      final jsonStr = JsonCodableEncoder.encode(
        model,
        const TimestampCollisionModelCodable(),
      );
      final yamlStr = YamlCodableEncoder.encode(
        model,
        const TimestampCollisionModelCodable(),
      );
      final (_, cborBytes) = _roundtripCbor(
        model,
        const TimestampCollisionModelCodable(),
      );
      final (_, msgpackBytes) = _roundtripMsgPack(
        model,
        const TimestampCollisionModelCodable(),
      );
      final (_, tomlStr, _) = _roundtripToml(
        model,
        const TimestampCollisionModelCodable(),
      );

      // TOML: native unquoted timestamp vs quoted date-looking strings.
      check(tomlStr).contains('timestamp = 2026-11-14T02:38:22.125Z\n');
      check(tomlStr).contains('expiresAt = 2026-12-31T23:59:59.000Z\n');
      check(tomlStr).contains('rawIsoString = "2026-11-14T00:00:00Z"\n');
      check(tomlStr).contains('rawLocalDateString = "2026-11-14"\n');
      check(tomlStr).contains('rawLocalTimeString = "07:32:00"\n');

      // JSON & YAML: ISO-8601 strings.
      check(jsonStr).contains('"2026-11-14T02:38:22.125Z"');
      check(yamlStr).contains('2026-11-14T02:38:22.125Z');

      // CBOR & MessagePack: epoch milliseconds (no ASCII timestamp text for
      // `timestamp`, while `rawIsoString` remains UTF-8 text).
      final tsAscii = utf8.encode('2026-11-14T02:38');
      final rawIsoAscii = utf8.encode('2026-11-14T00:00:00Z');
      check(_containsSubsequence(cborBytes, tsAscii)).isFalse();
      check(_containsSubsequence(msgpackBytes, tsAscii)).isFalse();
      check(_containsSubsequence(cborBytes, rawIsoAscii)).isTrue();
      check(_containsSubsequence(msgpackBytes, rawIsoAscii)).isTrue();

      for (final r in _roundtripAllFiveFormats(
        model,
        const TimestampCollisionModelCodable(),
      )) {
        check(r.timestamp).equals(ts);
        check(r.expiresAt).equals(exp);
        check(r.rawIsoString).equals('2026-11-14T00:00:00Z');
        check(r.rawLocalDateString).equals('2026-11-14');
        check(r.rawLocalTimeString).equals('07:32:00');
      }
    });

    test(
      'decodes TOML offsetDateTime, localDateTime, localDate, and localTime',
      () {
        const toml = '''
offsetInstant = 1979-05-27 00:32:00-07:00
localWallClock = 2026-11-14T09:15:30.250
calendarDay = 2026-11-14
dailyWindow = 07:32:00.5
''';
        final decoded = TomlCodableDecoder.decode(
          toml,
          const LocalDateTimesRecordCodable(),
        );
        check(decoded.offsetInstant).equals(DateTime.utc(1979, 5, 27, 7, 32));
        check(decoded.localWallClock)
            .equals(DateTime(2026, 11, 14, 9, 15, 30, 250));
        check(decoded.calendarDay).equals(DateTime(2026, 11, 14));
        check(decoded.dailyWindow)
            .isNotNull()
            .has((d) => (d.kind, d.raw, d.dateTime), 'localTime')
            .equals((TomlDateTimeKind.localTime, '07:32:00.5', null));

        // Attempting to decode a date-less `localTime` into Dart `DateTime` via
        // `TomlDateTimeCodec` fails with a descriptive `TomlCodableException`.
        check(
          () => TomlCodableDecoder.decode(
            'offsetInstant = 07:32:00\n'
            'localWallClock = 2026-11-14T09:15:30\n'
            'calendarDay = 2026-11-14\n',
            const LocalDateTimesRecordCodable(),
          ),
        ).throws<TomlCodableException>().which(
          (it) => it
            ..has(
              (e) => e.path,
              'path',
            ).deepEquals(const <Object>['offsetInstant'])
            ..has((e) => e.message, 'message').contains('localTime'),
        );
      },
    );
  });
}

void _registerStructuralBoundaryRejectionTests() {
  group('TOML v1.0 structural boundary rejections', () {
    test('rejects List<int?> containing null with offending element path', () {
      const valid = NullableElementListModel(values: [1, 2, 3]);
      for (final r in _roundtripAllFiveFormats(
        valid,
        const NullableElementListModelCodable(),
      )) {
        check(r.values).deepEquals(const [1, 2, 3]);
      }

      const withNull = NullableElementListModel(values: [1, null, 3]);
      check(
        _roundtripJson(
          withNull,
          const NullableElementListModelCodable(),
        ).values,
      ).deepEquals(const [1, null, 3]);

      check(
            () => TomlCodableEncoder.encode(
              withNull,
              const NullableElementListModelCodable(),
            ),
          )
          .throws<TomlCodableException>()
          .has((e) => e.path, 'path')
          .deepEquals(const <Object>['values', 1]);
    });

    test(
      'rejects Map<String, int?> and Map<int, int?> containing null values',
      () {
        const validMap = NullableStringMapModel(scores: {'a': 10, 'b': 20});
        for (final r in _roundtripAllFiveFormats(
          validMap,
          const NullableStringMapModelCodable(),
        )) {
          check(r.scores).deepEquals(const {'a': 10, 'b': 20});
        }

        const withNullStringKey = NullableStringMapModel(
          scores: {'ok': 10, 'bad': null},
        );
        check(
              () => TomlCodableEncoder.encode(
                withNullStringKey,
                const NullableStringMapModelCodable(),
              ),
            )
            .throws<TomlCodableException>()
            .has((e) => e.path, 'path')
            .deepEquals(const <Object>['scores', 'bad']);

        const withNullIntKey = NullableIntMapModel(buckets: {1: 10, 2: null});
        check(
              () => TomlCodableEncoder.encode(
                withNullIntKey,
                const NullableIntMapModelCodable(),
              ),
            )
            .throws<TomlCodableException>()
            .has((e) => e.path, 'path')
            .deepEquals(const <Object>['buckets', '2']);
      },
    );

    test('rejects top-level List<Model> and top-level scalar roots', () {
      const cells = [
        GridCell(x: 1, y: 2, tag: 'a'),
        GridCell(x: 3, y: 4, tag: 'b'),
      ];
      final listCodable = const GridCellCodable().list;
      check(_roundtripJson(cells, listCodable)).deepEquals(cells);

      check(() => TomlCodableEncoder.encode(cells, listCodable))
          .throws<TomlCodableException>()
          .has((e) => e.message, 'message')
          .contains('root must be a table');

      check(
            () => TomlCodableEncoder.encode<int>(
              42,
              Encodable.fromFunction((v, e) => e.singleValue().encodeInt(v)),
            ),
          )
          .throws<TomlCodableException>()
          .has((e) => e.message, 'message')
          .contains('root must be a table');
    });

    test(
      'rejects composite Map<GridCell, String> keys on encode and decode',
      () {
        final composite = CompositeMapKeyModel(
          cells: {
            const GridCell(x: 0, y: 0, tag: 'origin'): 'start',
            const GridCell(x: 5, y: 9, tag: 'goal'): 'finish',
          },
        );

        // Composite map keys work on YAML, CBOR, and MessagePack.
        check(
          _roundtripYaml(composite, const CompositeMapKeyModelCodable()).cells,
        ).deepEquals(composite.cells);
        check(
          _roundtripCbor(
            composite,
            const CompositeMapKeyModelCodable(),
          ).$1.cells,
        ).deepEquals(composite.cells);
        check(
          _roundtripMsgPack(
            composite,
            const CompositeMapKeyModelCodable(),
          ).$1.cells,
        ).deepEquals(composite.cells);

        // TOML rejects composite map keys on both encode and decode.
        check(
              () => TomlCodableEncoder.encode(
                composite,
                const CompositeMapKeyModelCodable(),
              ),
            )
            .throws<TomlCodableException>()
            .has((e) => e.path, 'path')
            .deepEquals(const <Object>['cells', 0]);

        check(
              () => TomlCodableDecoder.decode(
                '[cells]\norigin = "start"\n',
                const CompositeMapKeyModelCodable(),
              ),
            )
            .throws<TomlCodableException>()
            .has((e) => e.path, 'path')
            .deepEquals(const <Object>['cells', 'origin']);
      },
    );
  });
}
