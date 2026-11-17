// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:typed_data';

import 'package:checks/checks.dart';
import 'package:codable/codable_driver.dart';
import 'package:codable/codable_json.dart';
import 'package:codable/src/json/driver/dart_object_decoder.dart';
import 'package:codable/src/json/driver/driver_streaming.dart' as streaming;
import 'package:test/test.dart';

import 'domain_models_test.dart' as domain;

final _fleetKeys = KeyOptions.of(const ['name', 'lead', 'vehicles', 'coords']);
final _enumBoxKeys = KeyOptions.of(const ['role', 'roles', 'quotas']);
final _roleValues = KeyOptions.of(const ['admin', 'member', 'viewer']);

final class _Fleet {
  final String name;
  final domain.Vehicle? lead;
  final List<domain.Vehicle> vehicles;
  final Float64List? coords;

  const _Fleet({
    required this.name,
    this.lead,
    this.vehicles = const [],
    this.coords,
  });
}

final class _FleetCodable implements Decodable<_Fleet> {
  const _FleetCodable();

  @override
  _Fleet decode(Decoder decoder) {
    final keyed = decoder.keyed(options: _fleetKeys);
    var seen = 0;
    String? name;
    domain.Vehicle? lead;
    var vehicles = const <domain.Vehicle>[];
    Float64List? coords;

    while (keyed.moveNextKey()) {
      switch (keyed.selectKeyIndex(_fleetKeys)) {
        case 0:
          if ((seen & 1) != 0) {
            throw const CodableException('Duplicate field "name"');
          }
          seen |= 1;
          name = keyed.readString();
        case 1:
          lead = keyed.decodeNullableValue(
            const domain.VehicleSuperDecodable(),
          );
        case 2:
          vehicles = keyed.decodeList(const domain.VehicleSuperDecodable());
        case 3:
          final list = keyed.decodeFloat64List();
          if (list.length != 3) {
            throw CodableException(
              'Expected tuple of length 3, got ${list.length}',
            );
          }
          coords = list;
        default:
          keyed.skipValue();
      }
    }
    if ((seen & 1) == 0) {
      throw const CodableException('Missing required fields for Fleet: name');
    }
    return _Fleet(name: name!, lead: lead, vehicles: vehicles, coords: coords);
  }
}

String _decodeRoleName(int index, String? fallback) {
  if (index >= 0) return _roleValues[index];
  throw CodableException(
    'Unknown Role value: "$fallback"',
    actualValue: fallback,
  );
}

final class _RoleDecodable implements Decodable<String> {
  const _RoleDecodable();

  @override
  String decode(Decoder decoder) {
    final raw = decoder.singleValue().readString();
    return _decodeRoleName(_roleValues.indexOf(raw), raw);
  }
}

final class _EnumBoxDecodable implements Decodable<Map<String, Object?>> {
  const _EnumBoxDecodable();

  @override
  Map<String, Object?> decode(Decoder decoder) {
    final keyed = decoder.keyed(options: _enumBoxKeys);
    String? role;
    List<String>? roles;
    Map<String, int>? quotas;

    while (keyed.moveNextKey()) {
      switch (keyed.selectKeyIndex(_enumBoxKeys)) {
        case 0:
          final idx = keyed.selectStringIndex(_roleValues);
          role = idx >= 0
              ? _roleValues[idx]
              : throw const CodableException('Unknown Role value');
        case 1:
          roles = keyed.decodeList(const _RoleDecodable());
        case 2:
          final m = keyed.nestedDecoder().map();
          final out = <String, int>{};
          while (m.moveNextEntry()) {
            final k = const _RoleDecodable().decode(m.keyDecoder());
            out[k] = m.valueDecoder().singleValue().readInt();
          }
          quotas = out;
        default:
          keyed.skipValue();
      }
    }
    return {'role': role, 'roles': roles, 'quotas': quotas};
  }
}

typedef _JsonRunner = T Function<T>(String json, Decodable<T> decodable);

T _decodeDefault<T>(String json, Decodable<T> decodable) =>
    JsonCodableDecoder.decode(json, decodable);

T _decodeBytesDefault<T>(String json, Decodable<T> decodable) =>
    JsonCodableDecoder.decodeBytes(
      Uint8List.fromList(utf8.encode(json)),
      decodable,
    );

T _decodeJsDom<T>(String json, Decodable<T> decodable) =>
    JsonCodableDecoder.decodeBytes(
      Uint8List.fromList(utf8.encode(json)),
      decodable,
      userInfo: const {#forceJsDom: true},
    );

T _decodeStreamingExplicit<T>(String json, Decodable<T> decodable) =>
    streaming.JsonCodableDecoder.decode(json, decodable);

T _decodeChunked<T>(String json, Decodable<T> decodable) {
  final results = <T>[];
  final outSink = ChunkedConversionSink<T>.withCallback(results.addAll);
  final byteSink = JsonCodableDecoder.startChunkedConversion(
    outSink,
    decodable,
  );
  final bytes = utf8.encode(json);
  final split = bytes.length ~/ 2;
  byteSink.addSlice(bytes, 0, split, false);
  byteSink.addSlice(bytes, split, bytes.length, true);
  return results.single;
}

T _decodeDartObjectTree<T>(String json, Decodable<T> decodable) {
  final parsed = jsonDecode(json);
  final state = DartObjectErrorState();
  final decoder = DartObjectDecoder(parsed, errorState: state);
  try {
    return decodable.decode(decoder);
  } on CodableException catch (e) {
    final enriched = enrichCodableException(
      e,
      alreadyAttributed: state.attributedError,
      containerPath: () => state.containerPath,
      leafPath: state.buildLeafPath,
    );
    if (identical(enriched, e)) rethrow;
    throw enriched;
  }
}

final _allRunners = <(String, _JsonRunner)>[
  ('decode', _decodeDefault),
  ('decodeBytes', _decodeBytesDefault),
  ('forceJsDom', _decodeJsDom),
  ('streaming', _decodeStreamingExplicit),
  ('chunked', _decodeChunked),
  ('dartObject', _decodeDartObjectTree),
];

void _expectPath<T>(
  String json,
  Decodable<T> decodable,
  List<Object> expectedPath,
  String expectedFormatted, {
  Object? expectedActualValue = _skipCheck,
}) {
  for (final (name, runner) in _allRunners) {
    CodableException? caught;
    try {
      runner(json, decodable);
    } on CodableException catch (e) {
      caught = e;
    }
    check(caught, because: 'runner=$name').isNotNull();
    check(caught!.path, because: 'runner=$name').deepEquals(expectedPath);
    check(
      caught.formattedPath,
      because: 'runner=$name',
    ).equals(expectedFormatted);
    if (expectedFormatted.isNotEmpty) {
      check(
        caught.toString(),
        because: 'runner=$name',
      ).contains('at path $expectedFormatted');
    }
    if (!identical(expectedActualValue, _skipCheck)) {
      check(
        caught.actualValue,
        because: 'runner=$name',
      ).equals(expectedActualValue);
    }
  }
}

const Object _skipCheck = Object();

void main() {
  _registerScalarAndListMismatchTests();
  _registerMissingDuplicateTupleAndEnumTests();
  _registerPolymorphicSuperDecodableTests();
  _registerUniformDoubleListAndMalformedJsonTests();
}

void _registerScalarAndListMismatchTests() {
  group('JSON CodableException.path — scalar, map, & byte mismatches', () {
    test('reports nested object, list, and primitive-list paths', () {
      _expectPath(
        '{"id": "u1", "email": "a@b.c", "role": "admin", "zip": 90210, '
            '"tags": ["ok", 42]}',
        const domain.UserProfileCodable(),
        const ['tags', 1],
        'tags[1]',
        expectedActualValue: 42,
      );

      _expectPath(
        '{"packetId": 1, "regionZip": 2, "statusCode": "ok", "reading": 3, '
            '"delta": "not_double", "history": [], "counters": {}, '
            '"vehicle": {"type": "car", "maxSpeed": 100, "doors": 4}}',
        const domain.TelemetryPacketCodable(),
        const ['delta'],
        'delta',
        expectedActualValue: 'not_double',
      );

      _expectPath(
        '{"name": "alpha", "coords": [1.0, "bad", 3.0]}',
        const _FleetCodable(),
        const ['coords', 1],
        'coords[1]',
        expectedActualValue: 'bad',
      );
    });

    test('reports Map<K, V> key and value paths plus byte-array indices', () {
      final intMapDec = Decodable.fromFunction((Decoder d) {
        final m = d.mapped().nestedDecoder('scores').map();
        final out = <int, int>{};
        while (m.moveNextEntry()) {
          final k = m.keyDecoder().singleValue().readInt();
          out[k] = m.valueDecoder().singleValue().readInt();
        }
        return out;
      });

      _expectPath(
        '{"scores": {"10": 1, "bad_key": 2}}',
        intMapDec,
        const ['scores', 'bad_key'],
        'scores.bad_key',
        expectedActualValue: 'bad_key',
      );

      _expectPath(
        '{"scores": {"10": 1, "20": "bad_val"}}',
        intMapDec,
        const ['scores', '20'],
        'scores.20',
        expectedActualValue: 'bad_val',
      );

      final bytesDec = Decodable.fromFunction(
        (Decoder d) => d.mapped().readBytes('raw'),
      );
      _expectPath(
        '{"raw": [1, 2, 300]}',
        bytesDec,
        const ['raw', 2],
        'raw[2]',
        expectedActualValue: 300,
      );
      _expectPath(
        '{"raw": "%%%not-base64%%%"}',
        bytesDec,
        const ['raw'],
        'raw',
        expectedActualValue: '%%%not-base64%%%',
      );
    });

    test('recovers unknown property name on cold rescan in KeyedDecoder', () {
      final knownOpts = KeyOptions.of(const ['known']);
      final unknownReader = Decodable.fromFunction((Decoder d) {
        final k = d.keyed();
        while (k.moveNextKey()) {
          final idx = k.selectKeyIndex(knownOpts);
          if (idx == 0) {
            k.readInt();
          } else {
            // Intentionally read int on unknown key instead of skipping.
            k.readInt();
          }
        }
      });

      _expectPath(
        '{"known": 1, "mystery_field": "oops"}',
        unknownReader,
        const ['mystery_field'],
        'mystery_field',
        expectedActualValue: 'oops',
      );
    });
  });
}

void _registerMissingDuplicateTupleAndEnumTests() {
  group('JSON CodableException.path — missing, duplicate, tuple, & enum', () {
    test('reports container path on missing required fields', () {
      _expectPath(
        '{"email": "a@b.c", "role": "admin", "zip": "90210"}',
        const domain.UserProfileCodable(),
        const [],
        '',
      );

      final nestedUsers = Decodable.fromFunction((Decoder d) {
        final k = d.keyed(options: KeyOptions.of(const ['users']));
        while (k.moveNextKey()) {
          if (k.selectKeyIndex(KeyOptions.of(const ['users'])) == 0) {
            return k.decodeList(const domain.UserProfileCodable());
          }
          k.skipValue();
        }
        return const <domain.UserProfile>[];
      });

      _expectPath(
        '{"users": ['
            '{"id": "u1", "email": "a@b.c", "role": "admin", "zip": "1"}, '
            '{"id": "u2", "role": "admin", "zip": "2"}'
            ']}',
        nestedUsers,
        const ['users', 1],
        'users[1]',
      );

      _expectPath(
        '{"server": {}}',
        Decodable.fromFunction(
          (d) => d.mapped().nestedDecoder('server').mapped().readInt('port'),
        ),
        const ['server', 'port'],
        'server.port',
      );
    });

    test('reports field path on duplicate keys, tuples, and enums', () {
      // Note: JSON.parse deduplicates identical keys in JS DOM before Dart sees
      // them, whereas distinct @CodableKey aliases ("lat" + "latitude") hit
      // every driver mode including JS DOM!
      _expectPath(
        '{"latitude": 1.0, "lat": 2.0, "longitude": 3.0}',
        const domain.CoordinateCodable(),
        const ['lat'],
        'lat',
      );

      _expectPath(
        '{"name": "fleet-1", "coords": [1.0, 2.0]}',
        const _FleetCodable(),
        const ['coords'],
        'coords',
      );

      _expectPath('{"role": "superadmin"}', const _EnumBoxDecodable(), const [
        'role',
      ], 'role');

      _expectPath(
        '{"roles": ["admin", "ghost"]}',
        const _EnumBoxDecodable(),
        const ['roles', 1],
        'roles[1]',
        expectedActualValue: 'ghost',
      );

      _expectPath(
        '{"quotas": {"admin": 5, "ghost": 1}}',
        const _EnumBoxDecodable(),
        const ['quotas', 'ghost'],
        'quotas.ghost',
        expectedActualValue: 'ghost',
      );
    });

    test('preserves legitimate repeated adjacent segments (a.a & [0][0])', () {
      _expectPath(
        '{"a": {}}',
        Decodable.fromFunction(
          (d) => d.mapped().nestedDecoder('a').mapped().readInt('a'),
        ),
        const ['a', 'a'],
        'a.a',
      );

      _expectPath(
        '[[1]]',
        Decodable.fromFunction((d) {
          final outer = d.unkeyed();
          outer.moveNext();
          outer.decodeElement(
            Decodable.fromFunction(
              (_) => throw const CodableException('Inner fail', path: [0]),
            ),
          );
        }),
        const [0, 0],
        '[0][0]',
      );
    });
  });
}

void _registerPolymorphicSuperDecodableTests() {
  group('JSON CodableException.path — SuperDecodable root & nested', () {
    test('attributes missing, null, non-string, and unknown subtype tags', () {
      _expectPath(
        '{"maxSpeed": 120}',
        const domain.VehicleSuperDecodable(),
        const ['type'],
        'type',
      );
      _expectPath(
        '{"type": "hovercraft", "maxSpeed": 80}',
        const domain.VehicleSuperDecodable(),
        const ['type'],
        'type',
        expectedActualValue: 'hovercraft',
      );

      _expectPath(
        '{"name": "f1", "lead": {"type": "hovercraft"}}',
        const _FleetCodable(),
        const ['lead', 'type'],
        'lead.type',
        expectedActualValue: 'hovercraft',
      );

      _expectPath(
        '{"name": "f1", "vehicles": ['
            '{"type": "car", "maxSpeed": 120, "doors": 4}, '
            '{"maxSpeed": 90}'
            ']}',
        const _FleetCodable(),
        const ['vehicles', 1, 'type'],
        'vehicles[1].type',
      );

      _expectPath(
        '{"name": "f1", "vehicles": ['
            '{"type": "car", "maxSpeed": 120, "doors": 4}, '
            '{"type": null, "maxSpeed": 90}'
            ']}',
        const _FleetCodable(),
        const ['vehicles', 1, 'type'],
        'vehicles[1].type',
      );

      _expectPath(
        '{"name": "f1", "vehicles": ['
            '{"type": "car", "maxSpeed": 120, "doors": 4}, '
            '{"type": 404, "maxSpeed": 90}'
            ']}',
        const _FleetCodable(),
        const ['vehicles', 1, 'type'],
        'vehicles[1].type',
        expectedActualValue: 404,
      );

      _expectPath(
        '{"name": "f1", "vehicles": ['
            '{"type": "car", "maxSpeed": 120, "doors": 4}, '
            '{"type": "submarine", "maxSpeed": 50}'
            ']}',
        const _FleetCodable(),
        const ['vehicles', 1, 'type'],
        'vehicles[1].type',
        expectedActualValue: 'submarine',
      );
    });

    test('attributes subtype field mismatch and missing subtype fields', () {
      _expectPath(
        '{"name": "f1", "vehicles": ['
            '{"type": "car", "maxSpeed": 120, "doors": 4}, '
            '{"type": "car", "maxSpeed": 120, "doors": "four"}'
            ']}',
        const _FleetCodable(),
        const ['vehicles', 1, 'doors'],
        'vehicles[1].doors',
        expectedActualValue: 'four',
      );

      _expectPath(
        '{"name": "f1", "vehicles": ['
            '{"type": "car", "maxSpeed": 120, "doors": 4}, '
            '{"type": "car", "maxSpeed": 120}'
            ']}',
        const _FleetCodable(),
        const ['vehicles', 1],
        'vehicles[1]',
      );
    });
  });
}

void _registerUniformDoubleListAndMalformedJsonTests() {
  group('JSON uniform double list & FormatException boundary', () {
    test('decodeUniformDoubleList attributes element and property paths', () {
      final coordsDec = const domain.CoordinateCodable().list;

      _expectPath(
        '[{"lat": 1.0, "lon": 2.0}, {"lat": 3.0, "lon": "east"}]',
        coordsDec,
        const [1, 'lon'],
        '[1].lon',
        expectedActualValue: 'east',
      );

      _expectPath('[{"lat": 1.0, "lon": 2.0}, {"lat": 3.0}]', coordsDec, const [
        1,
      ], '[1]');

      _expectPath(
        '[{"lat": 1.0, "lon": 2.0}, {"latitude": 3.0, "lat": 4.0, "lon": 5.0}]',
        coordsDec,
        const [1, 'lat'],
        '[1].lat',
      );
    });

    test('preserves FormatException on malformed JSON and invalid UTF-8', () {
      for (final malformed in const [
        '{bad',
        '[{"lat": 1.0, "lon": 2.0}',
        '[{"lat": tru, "lon": 2.0}]',
        '',
      ]) {
        check(
          () => JsonCodableDecoder.decode(
            malformed,
            const domain.CoordinateCodable().list,
          ),
        ).throws<FormatException>();
        check(
          () => streaming.JsonCodableDecoder.decode(
            malformed,
            const domain.CoordinateCodable().list,
          ),
        ).throws<FormatException>();
      }
      for (final malformedScalar in const ['{bad', '[1, 2', 'tru', '']) {
        check(
          () => JsonCodableDecoder.decode(
            malformedScalar,
            Decodable.fromFunction((d) => d.singleValue().readInt()),
          ),
        ).throws<FormatException>();
      }

      final invalidUtf8 = Uint8List.fromList(const [0x7b, 0x22, 0xff, 0x22]);
      check(
        () => JsonCodableDecoder.decodeBytes(
          invalidUtf8,
          const domain.CoordinateCodable(),
        ),
      ).throws<FormatException>();
    });
  });
}
