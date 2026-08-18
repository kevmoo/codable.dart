// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:codable/codable.dart';

part 'test_models.g.dart';

@Codable()
final class Point {
  final double x;
  final double y;

  const Point(this.x, this.y);

  static Point fromReader(JsonTokenReader reader) => _$PointFromReader(reader);
  void toWriter(JsonTokenWriter writer) => _$PointToWriter(this, writer);
}

enum UserRole { admin, member, guest }

@Codable(fieldRename: FieldRename.snake)
final class UserAccount {
  final String id;
  final String emailAddress;
  final UserRole role;
  final List<String> tags;
  final Float64List? location;
  final String internalId;

  const UserAccount({
    required this.id,
    @CodableKey(aliases: ['email', 'contact_email']) required this.emailAddress,
    required this.role,
    this.tags = const [],
    @CodableTuple(2) this.location,
    @CodableKey(ignore: true) this.internalId = '',
  });

  static UserAccount fromReader(JsonTokenReader reader) =>
      _$UserAccountFromReader(reader);
  void toWriter(JsonTokenWriter writer) => _$UserAccountToWriter(this, writer);
}

@Codable()
final class InvalidIgnoredField {
  final String secret;

  const InvalidIgnoredField({@CodableKey(ignore: true) required this.secret});
}

@Codable()
final class Address {
  final String city;
  final String street;
  const Address({required this.city, required this.street});

  static Address fromReader(JsonTokenReader reader) =>
      _$AddressFromReader(reader);
  void toWriter(JsonTokenWriter writer) => _$AddressToWriter(this, writer);
}

@Codable()
final class Enterprise {
  final String name;
  final Address headquarter;
  final List<Address> branches;
  final Set<String> categories;
  final Map<String, int> headcountByDept;

  const Enterprise({
    required this.name,
    required this.headquarter,
    this.branches = const [],
    this.categories = const {},
    this.headcountByDept = const {},
  });

  static Enterprise fromReader(JsonTokenReader reader) =>
      _$EnterpriseFromReader(reader);
  void toWriter(JsonTokenWriter writer) => _$EnterpriseToWriter(this, writer);
}

final class ZipCodeDecoder {
  const ZipCodeDecoder();

  String decodeFromReader(JsonTokenReader reader) {
    if (reader.isNextNull()) {
      reader.readNull();
      return '';
    }
    final token = reader.peek();
    if (token == JsonTokenType.number) {
      return reader.readInt().toString();
    }
    return reader.readString();
  }

  void encodeToWriter(String value, JsonTokenWriter writer) {
    final asInt = int.tryParse(value);
    if (asInt != null) {
      writer.writeInt(asInt);
    } else {
      writer.writeString(value);
    }
  }
}

@Codable()
final class UserProfileCustom {
  final String id;
  @CodableKey(customDecoder: ZipCodeDecoder())
  final String zip;

  const UserProfileCustom({required this.id, required this.zip});

  static UserProfileCustom fromReader(JsonTokenReader reader) =>
      _$UserProfileCustomFromReader(reader);
  void toWriter(JsonTokenWriter writer) =>
      _$UserProfileCustomToWriter(this, writer);
}

@Codable()
final class Team {
  final String name;
  final List<UserRole> roles;
  final Set<String?> nullableTags;
  final Map<String, int?> scores;

  const Team({
    required this.name,
    this.roles = const [],
    this.nullableTags = const {},
    this.scores = const {},
  });

  static Team fromReader(JsonTokenReader reader) => _$TeamFromReader(reader);
  void toWriter(JsonTokenWriter writer) => _$TeamToWriter(this, writer);
}

@Codable()
final class HugeModel63 {
  final int f00;
  final int f01;
  final int f02;
  final int f03;
  final int f04;
  final int f05;
  final int f06;
  final int f07;
  final int f08;
  final int f09;
  final int f10;
  final int f11;
  final int f12;
  final int f13;
  final int f14;
  final int f15;
  final int f16;
  final int f17;
  final int f18;
  final int f19;
  final int f20;
  final int f21;
  final int f22;
  final int f23;
  final int f24;
  final int f25;
  final int f26;
  final int f27;
  final int f28;
  final int f29;
  final int f30;
  final int f31;
  final int f32;
  final int f33;
  final int f34;
  final int f35;
  final int f36;
  final int f37;
  final int f38;
  final int f39;
  final int f40;
  final int f41;
  final int f42;
  final int f43;
  final int f44;
  final int f45;
  final int f46;
  final int f47;
  final int f48;
  final int f49;
  final int f50;
  final int f51;
  final int f52;
  final int f53;
  final int f54;
  final int f55;
  final int f56;
  final int f57;
  final int f58;
  final int f59;
  final int f60;
  final int f61;
  final int f62;

  const HugeModel63({
    required this.f00,
    required this.f01,
    required this.f02,
    required this.f03,
    required this.f04,
    required this.f05,
    required this.f06,
    required this.f07,
    required this.f08,
    required this.f09,
    required this.f10,
    required this.f11,
    required this.f12,
    required this.f13,
    required this.f14,
    required this.f15,
    required this.f16,
    required this.f17,
    required this.f18,
    required this.f19,
    required this.f20,
    required this.f21,
    required this.f22,
    required this.f23,
    required this.f24,
    required this.f25,
    required this.f26,
    required this.f27,
    required this.f28,
    required this.f29,
    required this.f30,
    required this.f31,
    required this.f32,
    required this.f33,
    required this.f34,
    required this.f35,
    required this.f36,
    required this.f37,
    required this.f38,
    required this.f39,
    required this.f40,
    required this.f41,
    required this.f42,
    required this.f43,
    required this.f44,
    required this.f45,
    required this.f46,
    required this.f47,
    required this.f48,
    required this.f49,
    required this.f50,
    required this.f51,
    required this.f52,
    required this.f53,
    required this.f54,
    required this.f55,
    required this.f56,
    required this.f57,
    required this.f58,
    required this.f59,
    required this.f60,
    required this.f61,
    required this.f62,
  });
}
