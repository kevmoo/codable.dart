// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:checks/checks.dart';
import 'package:codable/codable.dart';
import 'package:codable_generator/codable_generator.dart';
import 'package:test/test.dart';

void main() {
  group('Utils & String Casing Tests', () {
    test('toSnakeCase converts camelCase and PascalCase', () {
      check(toSnakeCase('id')).equals('id');
      check(toSnakeCase('userId')).equals('user_id');
      check(toSnakeCase('userProfileData')).equals('user_profile_data');
      check(toSnakeCase('UserProfile')).equals('user_profile');
      check(toSnakeCase('HTTPResponse')).equals('http_response');
    });

    test('toKebabCase converts camelCase and PascalCase', () {
      check(toKebabCase('id')).equals('id');
      check(toKebabCase('userId')).equals('user-id');
      check(toKebabCase('userProfileData')).equals('user-profile-data');
      check(toKebabCase('UserProfile')).equals('user-profile');
    });

    test('toPascalCase converts various formats', () {
      check(toPascalCase('id')).equals('Id');
      check(toPascalCase('userId')).equals('UserId');
      check(toPascalCase('user_profile')).equals('UserProfile');
      check(toPascalCase('user-profile')).equals('UserProfile');
    });

    test('toScreamingSnakeCase converts identifiers', () {
      check(toScreamingSnakeCase('id')).equals('ID');
      check(toScreamingSnakeCase('userId')).equals('USER_ID');
      check(toScreamingSnakeCase('userProfileData'))
          .equals('USER_PROFILE_DATA');
    });

    test('applyFieldRename applies correct convention', () {
      const field = 'createdAt';
      check(applyFieldRename(field, FieldRename.none)).equals('createdAt');
      check(applyFieldRename(field, FieldRename.snake)).equals('created_at');
      check(applyFieldRename(field, FieldRename.kebab)).equals('created-at');
      check(applyFieldRename(field, FieldRename.pascal)).equals('CreatedAt');
      check(applyFieldRename(field, FieldRename.screamingSnake))
          .equals('CREATED_AT');
    });

    test('encodeAsConstBytes encodes ASCII and UTF-8 strings', () {
      check(encodeAsConstBytes('id')).equals('const [105, 100]');
      check(encodeAsConstBytes('role')).equals('const [114, 111, 108, 101]');
    });

    test('toSafeIdentifierSuffix sanitizes characters', () {
      check(toSafeIdentifierSuffix('user_id')).equals('UserId');
      check(toSafeIdentifierSuffix('user-id')).equals('UserId');
      check(toSafeIdentifierSuffix('user@domain')).equals('UserDomain');
    });
  });
}
