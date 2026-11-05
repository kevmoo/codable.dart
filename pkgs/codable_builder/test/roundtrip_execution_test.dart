// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';

import 'package:checks/checks.dart';
import 'package:codable/codable_json.dart';
import 'package:test/test.dart';

import 'fixtures/test_models.dart';

void main() {
  group('Generated Code Roundtrip & Runtime Validation Suite', () {
    group('Point (Positional Primary Constructor)', () {
      test('deserializes valid payload', () {
        final bytes = Uint8List.fromList(
          utf8.encode('{"x": 10.5, "y": -20.25}'),
        );
        final decoder = JsonCodableDecoder.fromBytes(bytes);
        final point = const PointCodable().decode(decoder);

        check(point.x).equals(10.5);
        check(point.y).equals(-20.25);
      });

      test('serializes to JSON writer', () {
        const point = Point(1.25, 3.75);
        final bytes = JsonCodableEncoder.toBytes(point, const PointCodable());
        final jsonStr = utf8.decode(bytes);

        check(jsonStr).equals('{"x":1.25,"y":3.75}');
      });

      test('skips unknown fields cleanly', () {
        final bytes = Uint8List.fromList(
          utf8.encode(
            '{"z": 99.9, "x": 1.0, "meta": {"foo": "bar"}, "y": 2.0}',
          ),
        );
        final decoder = JsonCodableDecoder.fromBytes(bytes);
        final point = const PointCodable().decode(decoder);

        check(point.x).equals(1.0);
        check(point.y).equals(2.0);
      });

      test('throws CodableException when required field is missing', () {
        final bytes = Uint8List.fromList(utf8.encode('{"x": 1.0}'));
        final decoder = JsonCodableDecoder.fromBytes(bytes);

        check(() => const PointCodable().decode(decoder))
            .throws<CodableException>()
            .has((e) => e.message, 'message')
            .contains('Missing required fields for Point: y');
      });

      test(
        'throws CodableException when multiple required fields are missing',
        () {
          final bytes = Uint8List.fromList(utf8.encode('{}'));
          final decoder = JsonCodableDecoder.fromBytes(bytes);

          check(() => const PointCodable().decode(decoder))
              .throws<CodableException>()
              .has((e) => e.message, 'message')
              .contains('Missing required fields for Point: x, y');
        },
      );

      test('throws CodableException on duplicate key', () {
        final bytes = Uint8List.fromList(
          utf8.encode('{"x": 1.0, "x": 2.0, "y": 3.0}'),
        );
        final decoder = JsonCodableDecoder.fromBytes(bytes);

        check(() => const PointCodable().decode(decoder))
            .throws<CodableException>()
            .has((e) => e.message, 'message')
            .contains('Duplicate field "x"');
      });

      test('deserializes list of points via PointCodable().decodeList', () {
        final bytes = Uint8List.fromList(
          utf8.encode('[{"x": 1.0, "y": 2.0}, {"x": 3.5, "y": 4.5}]'),
        );
        final decoder = JsonCodableDecoder.fromBytes(bytes);
        final points = const PointCodable().decodeList(decoder);

        check(points.length).equals(2);
        check(points[0].x).equals(1.0);
        check(points[0].y).equals(2.0);
        check(points[1].x).equals(3.5);
        check(points[1].y).equals(4.5);
      });
    });

    group('UserAccount (Enums, Aliases, Tuples, Renaming, Ignored Fields)', () {
      test('deserializes primary wire format', () {
        final bytes = Uint8List.fromList(
          utf8.encode(
            '{"id": "usr_1", "email_address": "alice@example.com", "role": "admin"}',
          ),
        );
        final decoder = JsonCodableDecoder.fromBytes(bytes);
        final user = const UserAccountCodable().decode(decoder);

        check(user.id).equals('usr_1');
        check(user.emailAddress).equals('alice@example.com');
        check(user.role).equals(UserRole.admin);
        check(user.tags).length.equals(0);
        check(user.location).isNull();
        check(user.internalId).equals('');
      });

      test('resolves key aliases "email" and "contact_email"', () {
        final bytes1 = Uint8List.fromList(
          utf8.encode(
            '{"id": "usr_2", "email": "bob@example.com", "role": "member"}',
          ),
        );
        final user1 = const UserAccountCodable().decode(
          JsonCodableDecoder.fromBytes(bytes1),
        );
        check(user1.emailAddress).equals('bob@example.com');
        check(user1.role).equals(UserRole.member);

        final bytes2 = Uint8List.fromList(
          utf8.encode(
            '{"id": "usr_3", "contact_email": "carol@example.com", "role": "guest"}',
          ),
        );
        final user2 = const UserAccountCodable().decode(
          JsonCodableDecoder.fromBytes(bytes2),
        );
        check(user2.emailAddress).equals('carol@example.com');
        check(user2.role).equals(UserRole.guest);
      });

      test('decodes fixed coordinate tuple @CodableTuple(2)', () {
        final bytes = Uint8List.fromList(
          utf8.encode(
            '{"id": "usr_4", "email_address": "d@e.com", "role": "admin", "location": [37.7749, -122.4194]}',
          ),
        );
        final user = const UserAccountCodable().decode(
          JsonCodableDecoder.fromBytes(bytes),
        );

        check(user.location).isNotNull();
        check(user.location![0]).equals(37.7749);
        check(user.location![1]).equals(-122.4194);
      });

      test('ignores field marked with @CodableKey(ignore: true)', () {
        final bytes = Uint8List.fromList(
          utf8.encode(
            '{"id": "usr_5", "email_address": "e@e.com", "role": "admin", "internalId": "hacked"}',
          ),
        );
        final user = const UserAccountCodable().decode(
          JsonCodableDecoder.fromBytes(bytes),
        );

        // internalId should retain default value ''
        check(user.internalId).equals('');
      });

      test('throws CodableException on unknown enum value', () {
        final bytes = Uint8List.fromList(
          utf8.encode(
            '{"id": "usr_6", "email_address": "f@e.com", "role": "superadmin"}',
          ),
        );
        check(
              () => const UserAccountCodable().decode(
                JsonCodableDecoder.fromBytes(bytes),
              ),
            )
            .throws<CodableException>()
            .has((e) => e.message, 'message')
            .contains('Unknown UserRole value');
      });

      test('roundtrips complete UserAccount with tags and location', () {
        final loc = Float64List(2);
        loc[0] = 45.0;
        loc[1] = 90.0;
        final user = UserAccount(
          id: 'usr_7',
          emailAddress: 'g@e.com',
          role: UserRole.member,
          tags: ['developer', 'dart'],
          location: loc,
        );

        final bytes = JsonCodableEncoder.toBytes(
          user,
          const UserAccountCodable(),
        );
        final roundtripped = const UserAccountCodable().decode(
          JsonCodableDecoder.fromBytes(bytes),
        );

        check(roundtripped.id).equals('usr_7');
        check(roundtripped.emailAddress).equals('g@e.com');
        check(roundtripped.role).equals(UserRole.member);
        check(roundtripped.tags.length).equals(2);
        check(roundtripped.tags[0]).equals('developer');
        check(roundtripped.tags[1]).equals('dart');
        check(roundtripped.location).isNotNull();
        check(roundtripped.location![0]).equals(45.0);
        check(roundtripped.location![1]).equals(90.0);
      });
    });

    group('UserProfileCustom (Custom Decoders)', () {
      test('decodes numeric and string zip code representations', () {
        final bytes1 = Uint8List.fromList(
          utf8.encode('{"id": "u1", "zip": 90210}'),
        );
        final profile1 = const UserProfileCustomCodable().decode(
          JsonCodableDecoder.fromBytes(bytes1),
        );
        check(profile1.id).equals('u1');
        check(profile1.zip).equals('90210');

        final bytes2 = Uint8List.fromList(
          utf8.encode('{"id": "u2", "zip": "94107"}'),
        );
        final profile2 = const UserProfileCustomCodable().decode(
          JsonCodableDecoder.fromBytes(bytes2),
        );
        check(profile2.id).equals('u2');
        check(profile2.zip).equals('94107');
      });

      test('roundtrips UserProfileCustom through encoder and decoder', () {
        const profile = UserProfileCustom(id: 'u3', zip: '10001');
        final bytes = JsonCodableEncoder.toBytes(
          profile,
          const UserProfileCustomCodable(),
        );
        final roundtripped = const UserProfileCustomCodable().decode(
          JsonCodableDecoder.fromBytes(bytes),
        );

        check(roundtripped.id).equals('u3');
        check(roundtripped.zip).equals('10001');
      });
    });

    group('Team (Enum Collections & Nullable Element Collections)', () {
      test('roundtrips enum lists, nullable sets, and nullable maps', () {
        const team = Team(
          name: 'Core Infra',
          roles: [UserRole.admin, UserRole.guest],
          nullableTags: {'backend', null, 'distributed'},
          scores: {'latency': 10, 'errors': null, 'qps': 50000},
        );

        final bytes = JsonCodableEncoder.toBytes(team, const TeamCodable());
        final roundtripped = const TeamCodable().decode(
          JsonCodableDecoder.fromBytes(bytes),
        );

        check(roundtripped.name).equals('Core Infra');
        check(roundtripped.roles.length).equals(2);
        check(roundtripped.roles[0]).equals(UserRole.admin);
        check(roundtripped.roles[1]).equals(UserRole.guest);

        check(roundtripped.nullableTags.contains('backend')).isTrue();
        check(roundtripped.nullableTags.contains(null)).isTrue();
        check(roundtripped.nullableTags.contains('distributed')).isTrue();

        check(roundtripped.scores['latency']).equals(10);
        check(roundtripped.scores.containsKey('errors')).isTrue();
        check(roundtripped.scores['errors']).isNull();
        check(roundtripped.scores['qps']).equals(50000);
      });
    });

    group('Enterprise (Nested Models & Collections Roundtrip)', () {
      test('roundtrips complex nested structure', () {
        const enterprise = Enterprise(
          name: 'Google LLC',
          headquarter: Address(
            city: 'Mountain View',
            street: '1600 Amphitheatre Pkwy',
          ),
          branches: [
            Address(city: 'New York', street: '111 8th Ave'),
            Address(city: 'Seattle', street: '601 N 34th St'),
          ],
          categories: {'technology', 'search', 'cloud'},
          headcountByDept: {'engineering': 50000, 'sales': 20000},
        );

        final bytes = JsonCodableEncoder.toBytes(
          enterprise,
          const EnterpriseCodable(),
        );
        final roundtripped = const EnterpriseCodable().decode(
          JsonCodableDecoder.fromBytes(bytes),
        );

        check(roundtripped.name).equals('Google LLC');
        check(roundtripped.headquarter.city).equals('Mountain View');
        check(roundtripped.headquarter.street).equals('1600 Amphitheatre Pkwy');
        check(roundtripped.branches.length).equals(2);
        check(roundtripped.branches[0].city).equals('New York');
        check(roundtripped.branches[1].city).equals('Seattle');
        check(roundtripped.categories.contains('technology')).isTrue();
        check(roundtripped.categories.contains('search')).isTrue();
        check(roundtripped.categories.contains('cloud')).isTrue();
        check(roundtripped.headcountByDept['engineering']).equals(50000);
        check(roundtripped.headcountByDept['sales']).equals(20000);
      });
    });

    group('Universal Decoder Contract Execution', () {
      test('Point deserializes via Decoder.decode', () {
        final bytes = Uint8List.fromList(utf8.encode('{"x": 42.0, "y": 84.0}'));
        final decoder = JsonCodableDecoder.fromBytes(bytes);
        final point = const PointCodable().decode(decoder);

        check(point.x).equals(42.0);
        check(point.y).equals(84.0);
      });

      test('UserAccount deserializes via Decoder.decode', () {
        final bytes = Uint8List.fromList(
          utf8.encode(
            '{"id": "usr_99", "email": "user@example.com", "role": "admin"}',
          ),
        );
        final decoder = JsonCodableDecoder.fromBytes(bytes);
        final user = const UserAccountCodable().decode(decoder);

        check(user.id).equals('usr_99');
        check(user.emailAddress).equals('user@example.com');
        check(user.role).equals(UserRole.admin);
      });

      test('Enterprise nested structure deserializes via Decoder.decode', () {
        final bytes = Uint8List.fromList(
          utf8.encode(
            '{"name": "Corp", "headquarter": {"city": "Zurich", "street": "Brandschenkestrasse"}, "branches": [{"city": "London", "street": "Belgrave"}], "categories": ["tech"]}',
          ),
        );
        final decoder = JsonCodableDecoder.fromBytes(bytes);
        final enterprise = const EnterpriseCodable().decode(decoder);

        check(enterprise.name).equals('Corp');
        check(enterprise.headquarter.city).equals('Zurich');
        check(enterprise.branches.length).equals(1);
        check(enterprise.branches[0].city).equals('London');
        check(enterprise.categories.contains('tech')).isTrue();
      });

      test(
        'UserProfileCustom with CustomDecoder deserializes via Decoder.decode',
        () {
          final bytes = Uint8List.fromList(
            utf8.encode('{"id": "p1", "zip": "90210"}'),
          );
          final decoder = JsonCodableDecoder.fromBytes(bytes);
          final profile = const UserProfileCustomCodable().decode(decoder);

          check(profile.id).equals('p1');
          check(profile.zip).equals('90210');
        },
      );

      test('UserAccount with null location and alias email deserializes via Decoder.decode', () {
        final bytes = Uint8List.fromList(
          utf8.encode(
            '{"id": "usr_100", "contact_email": "alias@example.com", "role": "member", "location": null}',
          ),
        );
        final decoder = JsonCodableDecoder.fromBytes(bytes);
        final user = const UserAccountCodable().decode(decoder);

        check(user.id).equals('usr_100');
        check(user.emailAddress).equals('alias@example.com');
        check(user.role).equals(UserRole.member);
        check(user.location).isNull();
        check(user.tags).isEmpty();
      });

      test(
        'Team with nullable collections deserializes via Decoder.decode',
        () {
          final bytes = Uint8List.fromList(
            utf8.encode(
              '{"name": "Core", "roles": ["admin"], "nullableTags": ["v1", null], "scores": {"a": 10, "b": null}}',
            ),
          );
          final decoder = JsonCodableDecoder.fromBytes(bytes);
          final team = const TeamCodable().decode(decoder);

          check(team.name).equals('Core');
          check(team.roles.length).equals(1);
          check(team.roles.first).equals(UserRole.admin);
          check(team.nullableTags.contains(null)).isTrue();
          check(team.nullableTags.contains('v1')).isTrue();
          check(team.scores['a']).equals(10);
          check(team.scores['b']).isNull();
        },
      );

      test('PrimitiveCollectionsModel roundtrips specialized primitive and nested lists', () {
        final floats = Float64List.fromList([1.1, 2.2, 3.3]);
        final matrix = [
          [10.0, 20.0],
          [30.0, 40.0],
        ];
        final nestedFloats = [
          Float64List.fromList([100.0, 200.0]),
          Float64List.fromList([300.0, 400.0]),
        ];
        final model = PrimitiveCollectionsModel(
          ints: [1, 2, 3],
          doubles: [4.5, 6.7],
          strings: ['alpha', 'beta'],
          bools: [true, false, true],
          float64s: floats,
          matrix: matrix,
          nestedFloats: nestedFloats,
        );

        final bytes = JsonCodableEncoder.toBytes(
          model,
          const PrimitiveCollectionsModelCodable(),
        );
        final decoded = const PrimitiveCollectionsModelCodable().decode(
          JsonCodableDecoder.fromBytes(bytes),
        );

        check(decoded.ints).deepEquals([1, 2, 3]);
        check(decoded.doubles).deepEquals([4.5, 6.7]);
        check(decoded.strings).deepEquals(['alpha', 'beta']);
        check(decoded.bools).deepEquals([true, false, true]);
        check(decoded.float64s.length).equals(3);
        check(decoded.float64s[0]).equals(1.1);
        check(decoded.float64s[1]).equals(2.2);
        check(decoded.float64s[2]).equals(3.3);
        check(decoded.matrix.length).equals(2);
        check(decoded.matrix[0]).deepEquals([10.0, 20.0]);
        check(decoded.matrix[1]).deepEquals([30.0, 40.0]);
        check(decoded.nestedFloats.length).equals(2);
        check(decoded.nestedFloats[0][0]).equals(100.0);
        check(decoded.nestedFloats[1][1]).equals(400.0);
      });

      test('NumericMeasurement preserves int vs double across fields and collections', () {
        final model = NumericMeasurement(
          score: 42,
          optionalScore: 3.5,
          samples: const [1, 2.5, 3],
          nullableSamples: const [10, null, -4.25],
          distinctValues: {7, 8.5},
          metrics: const {'count': 99, 'rate': 0.125},
          nullableMetrics: const {'ok': 1, 'skip': null, 'latency': 12.75},
        );

        final bytes = JsonCodableEncoder.toBytes(
          model,
          const NumericMeasurementCodable(),
        );
        final jsonStr = utf8.decode(bytes);
        check(jsonStr).contains('"score":42');
        check(jsonStr).contains('"samples":[1,2.5,3]');

        final decoded = const NumericMeasurementCodable().decode(
          JsonCodableDecoder.fromBytes(bytes),
        );
        check(decoded.score).isA<int>().equals(42);
        check(decoded.optionalScore).isA<double>().equals(3.5);
        check(decoded.samples[0]).isA<int>().equals(1);
        check(decoded.samples[1]).isA<double>().equals(2.5);
        check(decoded.samples[2]).isA<int>().equals(3);
        check(decoded.nullableSamples[0]).isA<int>().equals(10);
        check(decoded.nullableSamples[1]).isNull();
        check(decoded.nullableSamples[2]).isA<double>().equals(-4.25);
        check(decoded.distinctValues.first).isA<int>().equals(7);
        check(decoded.metrics['count']).isA<int>().equals(99);
        check(decoded.metrics['rate']).isA<double>().equals(0.125);
        check(decoded.nullableMetrics['ok']).isA<int>().equals(1);
        check(decoded.nullableMetrics['skip']).isNull();
        check(decoded.nullableMetrics['latency']).isA<double>().equals(12.75);
      });

      test('CodableKeyVariantsModel executes codable, decode-only, encode-only, and paired codecs', () {
        final inputBytes = Uint8List.fromList(
          utf8.encode(
            '{"zip": 90210, "decodeOnlyZip": 10001, "upperCode": "abc", "createdAt": "2026-08-17T12:00:00.000Z"}',
          ),
        );
        final decoded = const CodableKeyVariantsModelCodable().decode(
          JsonCodableDecoder.fromBytes(inputBytes),
        );
        check(decoded.zip).equals('90210');
        check(decoded.decodeOnlyZip).equals('10001');
        check(decoded.upperCode).equals('abc');
        check(decoded.createdAt).equals(DateTime.utc(2026, 8, 17, 12));

        final outBytes = JsonCodableEncoder.toBytes(
          decoded,
          const CodableKeyVariantsModelCodable(),
        );
        final outStr = utf8.decode(outBytes);
        check(outStr).contains('"upperCode":"ABC"');
        check(outStr).contains(
          '"createdAt":${DateTime.utc(2026, 8, 17, 12).millisecondsSinceEpoch}',
        );

        final roundtripped = const CodableKeyVariantsModelCodable().decode(
          JsonCodableDecoder.fromBytes(outBytes),
        );
        check(roundtripped.zip).equals('90210');
        check(roundtripped.decodeOnlyZip).equals('10001');
        check(roundtripped.upperCode).equals('ABC');
        check(roundtripped.createdAt).equals(DateTime.utc(2026, 8, 17, 12));
      });

      test('BinaryPayloadModel roundtrips Uint8List via Base64 and decodes [int] fallback', () {
        final model = BinaryPayloadModel(
          payload: Uint8List.fromList([0, 1, 2, 254, 255]),
          signature: Uint8List.fromList([10, 20, 30]),
          chunks: [
            Uint8List.fromList([7, 8]),
            Uint8List.fromList([]),
          ],
          nullableChunks: [
            Uint8List.fromList([99]),
            null,
          ],
          namedBlobs: {
            'header': Uint8List.fromList([0xCA, 0xFE]),
          },
        );

        final encodedBytes = JsonCodableEncoder.toBytes(
          model,
          const BinaryPayloadModelCodable(),
        );
        final encodedJson = utf8.decode(encodedBytes);
        check(encodedJson)
            .contains('"payload":"${base64Encode([0, 1, 2, 254, 255])}"');

        final decoded = const BinaryPayloadModelCodable().decode(
          JsonCodableDecoder.fromBytes(encodedBytes),
        );
        check(decoded.payload).deepEquals([0, 1, 2, 254, 255]);
        check(decoded.signature).isNotNull().deepEquals([10, 20, 30]);
        check(decoded.chunks.length).equals(2);
        check(decoded.chunks[0]).deepEquals([7, 8]);
        check(decoded.chunks[1]).isEmpty();
        check(decoded.nullableChunks.length).equals(2);
        check(decoded.nullableChunks[0]).isNotNull().deepEquals([99]);
        check(decoded.nullableChunks[1]).isNull();
        check(decoded.namedBlobs['header'])
            .isNotNull()
            .deepEquals([0xCA, 0xFE]);

        final listFallbackBytes = Uint8List.fromList(
          utf8.encode('{"payload": [0, 128, 255]}'),
        );
        final fromList = const BinaryPayloadModelCodable().decode(
          JsonCodableDecoder.fromBytes(listFallbackBytes),
        );
        check(fromList.payload).deepEquals([0, 128, 255]);
        check(fromList.signature).isNull();
      });

      test('TypedKeyMapModel roundtrips Map<int, String> and Map<UserRole, int> and validates enum keys', () {
        const model = TypedKeyMapModel(
          statusMessages: {200: 'ok', 404: 'not found'},
          roleCounts: {UserRole.admin: 2, UserRole.guest: 15},
          flagWeights: {true: 1.5, false: 0.25},
          buckets: {
            'low': [1, 2],
            'high': [10, 20, 30],
          },
        );

        final encodedBytes = JsonCodableEncoder.toBytes(
          model,
          const TypedKeyMapModelCodable(),
        );
        final decoded = const TypedKeyMapModelCodable().decode(
          JsonCodableDecoder.fromBytes(encodedBytes),
        );

        check(decoded.statusMessages).deepEquals({200: 'ok', 404: 'not found'});
        check(decoded.roleCounts)
            .deepEquals({UserRole.admin: 2, UserRole.guest: 15});
        check(decoded.flagWeights).deepEquals({true: 1.5, false: 0.25});
        check(decoded.buckets['low']).isNotNull().deepEquals([1, 2]);
        check(decoded.buckets['high']).isNotNull().deepEquals([10, 20, 30]);

        final defaultsDecoded = const TypedKeyMapModelCodable().decode(
          JsonCodableDecoder.fromBytes(Uint8List.fromList(utf8.encode('{}'))),
        );
        check(defaultsDecoded.statusMessages).isEmpty();
        check(defaultsDecoded.roleCounts).isEmpty();

        final invalidEnumKey = Uint8List.fromList(
          utf8.encode('{"roleCounts": {"superadmin": 1}}'),
        );
        check(
              () => const TypedKeyMapModelCodable().decode(
                JsonCodableDecoder.fromBytes(invalidEnumKey),
              ),
            )
            .throws<CodableException>()
            .has((e) => e.message, 'message')
            .contains('Unknown UserRole value');
      });

      test('passes exact compile-time length hints to Encoder.keyed when all fields are non-nullable', () {
        int? captureKeyedLength<T>(T value, Encodable<T> codec) {
          int? captured;
          JsonCodableEncoder.toBytes<T>(
            value,
            Encodable<T>.fromFunction((val, inner) {
              codec.encode(
                val,
                _KeyedLengthSpyEncoder(inner, (len) => captured = len),
              );
            }),
          );
          return captured;
        }

        check(captureKeyedLength(const Point(1, 2), const PointCodable()))
            .equals(2);
        check(
          captureKeyedLength(
            const TypedKeyMapModel(),
            const TypedKeyMapModelCodable(),
          ),
        ).equals(4);
        check(
          captureKeyedLength(const EmptyRecord(), const EmptyRecordCodable()),
        ).equals(0);
        check(
          captureKeyedLength(
            const UserAccount(
              id: 'u1',
              emailAddress: 'a@b.c',
              role: UserRole.admin,
            ),
            const UserAccountCodable(),
          ),
        ).isNull();
      });

      test('StringKeyedNestedMapModel roundtrips enum, nullable @Codable, and nested String maps via keyed() only', () {
        const model = StringKeyedNestedMapModel(
          rolesByUser: {'alice': UserRole.admin, 'bob': UserRole.member},
          officesByCode: {
            'mtv': Address(city: 'Mountain View', street: '1600 Amphitheatre'),
            'tbd': null,
          },
          nestedCounts: {
            'us': {'ca': 10, 'ny': 5},
            'eu': {},
          },
        );

        final encodeEvents = <String>[];
        final encodedBytes =
            JsonCodableEncoder.toBytes<StringKeyedNestedMapModel>(
              model,
              Encodable.fromFunction((val, inner) {
                const StringKeyedNestedMapModelCodable().encode(
                  val,
                  _RoutingSpyEncoder(inner, encodeEvents),
                );
              }),
            );

        // Outer model keyed(3) + rolesByUser keyed(2) + officesByCode keyed(2)
        //   + Address keyed(2) + nestedCounts keyed(2) + us keyed(2) + eu keyed(0)
        check(encodeEvents).deepEquals([
          'keyed:3',
          'keyed:2',
          'keyed:2',
          'keyed:2',
          'keyed:2',
          'keyed:2',
          'keyed:0',
        ]);

        final decodeEvents = <String>[];
        final decoded = const StringKeyedNestedMapModelCodable().decode(
          _RoutingSpyDecoder(
            JsonCodableDecoder.fromBytes(encodedBytes),
            decodeEvents,
          ),
        );
        check(decodeEvents).not((it) => it.contains('map'));
        check(decoded.rolesByUser)
            .deepEquals({'alice': UserRole.admin, 'bob': UserRole.member});
        check(decoded.officesByCode['mtv']?.city).equals('Mountain View');
        check(decoded.officesByCode.containsKey('tbd')).isTrue();
        check(decoded.officesByCode['tbd']).isNull();
        check(decoded.nestedCounts['us'])
            .isNotNull()
            .deepEquals({'ca': 10, 'ny': 5});
        check(decoded.nestedCounts['eu']).isNotNull().isEmpty();

        final badEnumBytes = Uint8List.fromList(
          utf8.encode('{"rolesByUser": {"alice": "root"}}'),
        );
        check(
              () => const StringKeyedNestedMapModelCodable().decode(
                JsonCodableDecoder.fromBytes(badEnumBytes),
              ),
            )
            .throws<CodableException>()
            .has((e) => e.message, 'message')
            .contains('Unknown UserRole value');
      });

      test('routes Map<String, V> to keyed() and Map<int/Enum/bool/Composite, V> to map() at runtime', () {
        const model = TypedKeyMapModel(
          statusMessages: {200: 'ok', 404: 'missing'},
          roleCounts: {UserRole.admin: 1},
          flagWeights: {true: 1.0, false: 0.0},
          buckets: {
            'a': [1, 2],
            'b': [3],
            'c': [],
          },
        );

        final encodeEvents = <String>[];
        final encodedBytes = JsonCodableEncoder.toBytes<TypedKeyMapModel>(
          model,
          Encodable.fromFunction((val, inner) {
            const TypedKeyMapModelCodable().encode(
              val,
              _RoutingSpyEncoder(inner, encodeEvents),
            );
          }),
        );

        // Outer model keyed(4) + 3 non-String maps via map(length:) + buckets via keyed(3)
        check(encodeEvents)
            .deepEquals(['keyed:4', 'map:2', 'map:1', 'map:2', 'keyed:3']);

        final decodeEvents = <String>[];
        final decoded = const TypedKeyMapModelCodable().decode(
          _RoutingSpyDecoder(
            JsonCodableDecoder.fromBytes(encodedBytes),
            decodeEvents,
          ),
        );
        // Outer model keyed + 3 non-String maps via map + buckets via keyed
        check(decodeEvents).deepEquals(['keyed', 'map', 'map', 'map', 'keyed']);
        check(decoded.buckets['a']).isNotNull().deepEquals([1, 2]);

        // CompositeKeyMapModel routes Map<Point, String> to map(length: 1)
        final compositeEvents = <String>[];
        const composite = CompositeKeyMapModel(
          labelsByPoint: {Point(1.0, 2.0): 'origin'},
        );
        check(
          () => JsonCodableEncoder.toBytes<CompositeKeyMapModel>(
            composite,
            Encodable.fromFunction((val, inner) {
              const CompositeKeyMapModelCodable().encode(
                val,
                _RoutingSpyEncoder(inner, compositeEvents),
              );
            }),
          ),
        ).throws<CodableException>();
        check(compositeEvents).deepEquals(['keyed:1', 'map:1', 'keyed:2']);
      });
    });
  });
}

final class _KeyedLengthSpyEncoder implements Encoder {
  final Encoder _inner;
  final void Function(int? length) _onKeyed;

  _KeyedLengthSpyEncoder(this._inner, this._onKeyed);

  @override
  bool get isHumanReadable => _inner.isHumanReadable;

  @override
  Map<Object, Object?> get userInfo => _inner.userInfo;

  @override
  KeyedEncoder keyed({KeyOptions? options, int? length}) {
    _onKeyed(length);
    return _inner.keyed(options: options, length: length);
  }

  @override
  UnkeyedEncoder unkeyed({int? length}) => _inner.unkeyed(length: length);

  @override
  MapEncoder map({int? length}) => _inner.map(length: length);

  @override
  SingleValueEncoder singleValue() => _inner.singleValue();
}

final class _RoutingSpyEncoder implements Encoder {
  final Encoder _inner;
  final List<String> _events;

  _RoutingSpyEncoder(this._inner, this._events);

  @override
  bool get isHumanReadable => _inner.isHumanReadable;

  @override
  Map<Object, Object?> get userInfo => _inner.userInfo;

  @override
  KeyedEncoder keyed({KeyOptions? options, int? length}) {
    _events.add('keyed:$length');
    return _RoutingSpyKeyedEncoder(
      _inner.keyed(options: options, length: length),
      _events,
    );
  }

  @override
  UnkeyedEncoder unkeyed({int? length}) => _inner.unkeyed(length: length);

  @override
  MapEncoder map({int? length}) {
    _events.add('map:$length');
    return _RoutingSpyMapEncoder(_inner.map(length: length), _events);
  }

  @override
  SingleValueEncoder singleValue() => _inner.singleValue();
}

final class _RoutingSpyMapEncoder implements MapEncoder {
  final MapEncoder _inner;
  final List<String> _events;

  _RoutingSpyMapEncoder(this._inner, this._events);

  @override
  Encoder keyEncoder() => _RoutingSpyEncoder(_inner.keyEncoder(), _events);

  @override
  Encoder valueEncoder() => _RoutingSpyEncoder(_inner.valueEncoder(), _events);
}

final class _RoutingSpyKeyedEncoder
    with BaseKeyedEncoderMixin
    implements KeyedEncoder {
  final KeyedEncoder _inner;
  final List<String> _events;

  _RoutingSpyKeyedEncoder(this._inner, this._events);

  @override
  void encodeInt(String key, int value) => _inner.encodeInt(key, value);

  @override
  void encodeDouble(String key, double value) =>
      _inner.encodeDouble(key, value);

  @override
  void encodeString(String key, String value) =>
      _inner.encodeString(key, value);

  @override
  void encodeBool(String key, bool value) => _inner.encodeBool(key, value);

  @override
  void encodeNull(String key) => _inner.encodeNull(key);

  @override
  Encoder nestedEncoder(String key) =>
      _RoutingSpyEncoder(_inner.nestedEncoder(key), _events);
}

final class _RoutingSpyDecoder implements Decoder {
  final Decoder _inner;
  final List<String> _events;

  _RoutingSpyDecoder(this._inner, this._events);

  @override
  bool get isHumanReadable => _inner.isHumanReadable;

  @override
  Map<Object, Object?> get userInfo => _inner.userInfo;

  @override
  Uint8List? get payload => _inner.payload;

  @override
  ValueKind peekKind() => _inner.peekKind();

  @override
  KeyedDecoder keyed({KeyOptions? options}) {
    _events.add('keyed');
    return _RoutingSpyKeyedDecoder(_inner.keyed(options: options), _events);
  }

  @override
  MappedDecoder mapped() => _inner.mapped();

  @override
  MapDecoder map() {
    _events.add('map');
    return _RoutingSpyMapDecoder(_inner.map(), _events);
  }

  @override
  UnkeyedDecoder unkeyed() => _inner.unkeyed();

  @override
  SingleValueDecoder singleValue() => _inner.singleValue();

  @override
  Float64List? decodeUniformDoubleList(List<List<String>> propertyAliases) =>
      _inner.decodeUniformDoubleList(propertyAliases);
}

final class _RoutingSpyMapDecoder implements MapDecoder {
  final MapDecoder _inner;
  final List<String> _events;

  _RoutingSpyMapDecoder(this._inner, this._events);

  @override
  int? get length => _inner.length;

  @override
  bool moveNextEntry() => _inner.moveNextEntry();

  @override
  Decoder keyDecoder() => _RoutingSpyDecoder(_inner.keyDecoder(), _events);

  @override
  Decoder valueDecoder() => _RoutingSpyDecoder(_inner.valueDecoder(), _events);
}

final class _RoutingSpyKeyedDecoder
    with BaseKeyedDecoderMixin
    implements KeyedDecoder {
  final KeyedDecoder _inner;
  final List<String> _events;

  _RoutingSpyKeyedDecoder(this._inner, this._events);

  @override
  bool moveNextKey() => _inner.moveNextKey();

  @override
  String nextKey() => _inner.nextKey();

  @override
  ValueKind peekKind() => _inner.peekKind();

  @override
  void skipValue() => _inner.skipValue();

  @override
  void readNull() => _inner.readNull();

  @override
  int readInt() => _inner.readInt();

  @override
  double readDouble() => _inner.readDouble();

  @override
  num readNum() => _inner.readNum();

  @override
  String readString() => _inner.readString();

  @override
  bool readBool() => _inner.readBool();

  @override
  Decoder nestedDecoder() =>
      _RoutingSpyDecoder(_inner.nestedDecoder(), _events);
}
