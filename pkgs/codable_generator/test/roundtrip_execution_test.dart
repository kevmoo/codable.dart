// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';

import 'package:checks/checks.dart';
import 'package:codable/codable.dart';
import 'package:test/test.dart';

import 'fixtures/test_models.dart';

Uint8List _encodeObject(void Function(JsonTokenWriter writer) encode) {
  final builder = BytesBuilder();
  final writer = JsonTokenWriter.toSink(builder);
  encode(writer);
  return builder.toBytes();
}

void main() {
  group('Generated Code Roundtrip & Runtime Validation Suite', () {
    group('Point (Positional Primary Constructor)', () {
      test('deserializes valid payload', () {
        final bytes = Uint8List.fromList(
          utf8.encode('{"x": 10.5, "y": -20.25}'),
        );
        final reader = JsonTokenReader.fromBytes(bytes);
        final point = Point.fromReader(reader);

        check(point.x).equals(10.5);
        check(point.y).equals(-20.25);
      });

      test('serializes to JSON writer', () {
        const point = Point(1.25, 3.75);
        final bytes = _encodeObject((w) => point.toWriter(w));
        final jsonStr = utf8.decode(bytes);

        check(jsonStr).equals('{"x":1.25,"y":3.75}');
      });

      test('skips unknown fields cleanly', () {
        final bytes = Uint8List.fromList(
          utf8.encode(
            '{"z": 99.9, "x": 1.0, "meta": {"foo": "bar"}, "y": 2.0}',
          ),
        );
        final reader = JsonTokenReader.fromBytes(bytes);
        final point = Point.fromReader(reader);

        check(point.x).equals(1.0);
        check(point.y).equals(2.0);
      });

      test('throws CodableException when required field is missing', () {
        final bytes = Uint8List.fromList(utf8.encode('{"x": 1.0}'));
        final reader = JsonTokenReader.fromBytes(bytes);

        check(() => Point.fromReader(reader))
            .throws<CodableException>()
            .has((e) => e.message, 'message')
            .contains('Missing required fields for Point: y');
      });

      test(
        'throws CodableException when multiple required fields are missing',
        () {
          final bytes = Uint8List.fromList(utf8.encode('{}'));
          final reader = JsonTokenReader.fromBytes(bytes);

          check(() => Point.fromReader(reader))
              .throws<CodableException>()
              .has((e) => e.message, 'message')
              .contains('Missing required fields for Point: x, y');
        },
      );

      test('throws CodableException on duplicate key', () {
        final bytes = Uint8List.fromList(
          utf8.encode('{"x": 1.0, "x": 2.0, "y": 3.0}'),
        );
        final reader = JsonTokenReader.fromBytes(bytes);

        check(() => Point.fromReader(reader))
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
        final reader = JsonTokenReader.fromBytes(bytes);
        final user = UserAccount.fromReader(reader);

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
        final user1 = UserAccount.fromReader(JsonTokenReader.fromBytes(bytes1));
        check(user1.emailAddress).equals('bob@example.com');
        check(user1.role).equals(UserRole.member);

        final bytes2 = Uint8List.fromList(
          utf8.encode(
            '{"id": "usr_3", "contact_email": "carol@example.com", "role": "guest"}',
          ),
        );
        final user2 = UserAccount.fromReader(JsonTokenReader.fromBytes(bytes2));
        check(user2.emailAddress).equals('carol@example.com');
        check(user2.role).equals(UserRole.guest);
      });

      test('decodes fixed coordinate tuple @CodableTuple(2)', () {
        final bytes = Uint8List.fromList(
          utf8.encode(
            '{"id": "usr_4", "email_address": "d@e.com", "role": "admin", "location": [37.7749, -122.4194]}',
          ),
        );
        final user = UserAccount.fromReader(JsonTokenReader.fromBytes(bytes));

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
        final user = UserAccount.fromReader(JsonTokenReader.fromBytes(bytes));

        // internalId should retain default value ''
        check(user.internalId).equals('');
      });

      test('throws CodableException on unknown enum value', () {
        final bytes = Uint8List.fromList(
          utf8.encode(
            '{"id": "usr_6", "email_address": "f@e.com", "role": "superadmin"}',
          ),
        );
        check(() => UserAccount.fromReader(JsonTokenReader.fromBytes(bytes)))
            .throws<CodableException>()
            .has((e) => e.message, 'message')
            .contains('Unknown UserRole value');
      });

      test('throws CodableException on tuple length mismatch', () {
        final bytes = Uint8List.fromList(
          utf8.encode(
            '{"id": "usr_t", "email_address": "t@e.com", "role": "admin", "location": [37.7749]}',
          ),
        );
        check(() => UserAccount.fromReader(JsonTokenReader.fromBytes(bytes)))
            .throws<CodableException>()
            .has((e) => e.message, 'message')
            .contains('Expected 2 elements for tuple "location", got 1');
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

        final bytes = _encodeObject(user.toWriter);
        final roundtripped = UserAccount.fromReader(
          JsonTokenReader.fromBytes(bytes),
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
        final profile1 = UserProfileCustom.fromReader(
          JsonTokenReader.fromBytes(bytes1),
        );
        check(profile1.id).equals('u1');
        check(profile1.zip).equals('90210');

        final bytes2 = Uint8List.fromList(
          utf8.encode('{"id": "u2", "zip": "94107"}'),
        );
        final profile2 = UserProfileCustom.fromReader(
          JsonTokenReader.fromBytes(bytes2),
        );
        check(profile2.id).equals('u2');
        check(profile2.zip).equals('94107');
      });

      test('roundtrips UserProfileCustom through encoder and decoder', () {
        const profile = UserProfileCustom(id: 'u3', zip: '10001');
        final bytes = _encodeObject(profile.toWriter);
        final roundtripped = UserProfileCustom.fromReader(
          JsonTokenReader.fromBytes(bytes),
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

        final bytes = _encodeObject(team.toWriter);
        final roundtripped = Team.fromReader(JsonTokenReader.fromBytes(bytes));

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

        final bytes = _encodeObject(enterprise.toWriter);
        final roundtripped = Enterprise.fromReader(
          JsonTokenReader.fromBytes(bytes),
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
  });
}
