// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';

import 'package:checks/checks.dart';
import 'package:codable/codable_json.dart';
import 'package:test/test.dart';

import 'fixtures/test_models.dart';

Uint8List _encodeObject(void Function(Encoder encoder) encode) {
  return JsonCodableEncoder.toBytes(encode);
}

void main() {
  group('Generated Code Roundtrip & Runtime Validation Suite', () {
    group('Point (Positional Primary Constructor)', () {
      test('deserializes valid payload', () {
        final bytes = Uint8List.fromList(
          utf8.encode('{"x": 10.5, "y": -20.25}'),
        );
        final decoder = JsonCodableDecoder.fromBytes(bytes);
        final point = Point.decode(decoder);

        check(point.x).equals(10.5);
        check(point.y).equals(-20.25);
      });

      test('serializes to JSON writer', () {
        const point = Point(1.25, 3.75);
        final bytes = _encodeObject((e) => point.encode(e));
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
        final point = Point.decode(decoder);

        check(point.x).equals(1.0);
        check(point.y).equals(2.0);
      });

      test('throws CodableException when required field is missing', () {
        final bytes = Uint8List.fromList(utf8.encode('{"x": 1.0}'));
        final decoder = JsonCodableDecoder.fromBytes(bytes);

        check(() => Point.decode(decoder))
            .throws<CodableException>()
            .has((e) => e.message, 'message')
            .contains('Missing required fields for Point: y');
      });

      test(
        'throws CodableException when multiple required fields are missing',
        () {
          final bytes = Uint8List.fromList(utf8.encode('{}'));
          final decoder = JsonCodableDecoder.fromBytes(bytes);

          check(() => Point.decode(decoder))
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

        check(() => Point.decode(decoder))
            .throws<CodableException>()
            .has((e) => e.message, 'message')
            .contains('Duplicate field "x"');
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
        final user = UserAccount.decode(decoder);

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
        final user1 = UserAccount.decode(JsonCodableDecoder.fromBytes(bytes1));
        check(user1.emailAddress).equals('bob@example.com');
        check(user1.role).equals(UserRole.member);

        final bytes2 = Uint8List.fromList(
          utf8.encode(
            '{"id": "usr_3", "contact_email": "carol@example.com", "role": "guest"}',
          ),
        );
        final user2 = UserAccount.decode(JsonCodableDecoder.fromBytes(bytes2));
        check(user2.emailAddress).equals('carol@example.com');
        check(user2.role).equals(UserRole.guest);
      });

      test('decodes fixed coordinate tuple @CodableTuple(2)', () {
        final bytes = Uint8List.fromList(
          utf8.encode(
            '{"id": "usr_4", "email_address": "d@e.com", "role": "admin", "location": [37.7749, -122.4194]}',
          ),
        );
        final user = UserAccount.decode(JsonCodableDecoder.fromBytes(bytes));

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
        final user = UserAccount.decode(JsonCodableDecoder.fromBytes(bytes));

        // internalId should retain default value ''
        check(user.internalId).equals('');
      });

      test('throws CodableException on unknown enum value', () {
        final bytes = Uint8List.fromList(
          utf8.encode(
            '{"id": "usr_6", "email_address": "f@e.com", "role": "superadmin"}',
          ),
        );
        check(() => UserAccount.decode(JsonCodableDecoder.fromBytes(bytes)))
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

        final bytes = _encodeObject(user.encode);
        final roundtripped = UserAccount.decode(
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
        final profile1 = UserProfileCustom.decode(
          JsonCodableDecoder.fromBytes(bytes1),
        );
        check(profile1.id).equals('u1');
        check(profile1.zip).equals('90210');

        final bytes2 = Uint8List.fromList(
          utf8.encode('{"id": "u2", "zip": "94107"}'),
        );
        final profile2 = UserProfileCustom.decode(
          JsonCodableDecoder.fromBytes(bytes2),
        );
        check(profile2.id).equals('u2');
        check(profile2.zip).equals('94107');
      });

      test('roundtrips UserProfileCustom through encoder and decoder', () {
        const profile = UserProfileCustom(id: 'u3', zip: '10001');
        final bytes = _encodeObject((e) => profile.encode(e));
        final roundtripped = UserProfileCustom.decode(
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

        final bytes = _encodeObject((e) => team.encode(e));
        final roundtripped = Team.decode(JsonCodableDecoder.fromBytes(bytes));

        check(roundtripped.name).equals('Core Infra');
        check(roundtripped.roles.length).equals(2);
        check(roundtripped.roles[0]).equals(UserRole.admin);
        check(roundtripped.roles[1]).equals(UserRole.guest);

        check(roundtripped.nullableTags.contains('backend')).isTrue();
        check(roundtripped.nullableTags.contains(null)).isTrue();
        check(roundtripped.nullableTags.contains('distributed')).isTrue();

        check(roundtripped.scores['latency']).equals(10);
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

        final bytes = _encodeObject((e) => enterprise.encode(e));
        final roundtripped = Enterprise.decode(
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
        final point = Point.decode(decoder);

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
        final user = UserAccount.decode(decoder);

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
        final enterprise = Enterprise.decode(decoder);

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
          final profile = UserProfileCustom.decode(decoder);

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
        final user = UserAccount.decode(decoder);

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
          final team = Team.decode(decoder);

          check(team.name).equals('Core');
          check(team.roles.length).equals(1);
          check(team.roles.first).equals(UserRole.admin);
          check(team.nullableTags.contains(null)).isTrue();
          check(team.nullableTags.contains('v1')).isTrue();
          check(team.scores['a']).equals(10);
          check(team.scores['b']).isNull();
        },
      );
    });
  });
}
