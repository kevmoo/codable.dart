// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:codable/codable.dart';

part 'small.g.dart';

@Codable()
class SmallLocation {
  final double latitude;
  final double longitude;
  final String city;
  final String country;

  const SmallLocation({
    required this.latitude,
    required this.longitude,
    required this.city,
    required this.country,
  });

  static SmallLocation fromReader(JsonTokenReader reader) =>
      _$SmallLocationFromReader(reader);
  void toWriter(JsonTokenWriter writer) =>
      _$SmallLocationToWriter(this, writer);

  static SmallLocation decode(Decoder decoder) =>
      _$SmallLocationFromDecoder(decoder);
}

@Codable()
class SmallMetadata {
  final int loginCount;
  final String lastLogin;
  final SmallLocation location;

  const SmallMetadata({
    required this.loginCount,
    required this.lastLogin,
    required this.location,
  });

  static SmallMetadata fromReader(JsonTokenReader reader) =>
      _$SmallMetadataFromReader(reader);
  void toWriter(JsonTokenWriter writer) =>
      _$SmallMetadataToWriter(this, writer);

  static SmallMetadata decode(Decoder decoder) =>
      _$SmallMetadataFromDecoder(decoder);
}

@Codable()
class SmallDocument {
  final int id;
  final String uuid;
  final String name;
  final String email;
  final bool isActive;
  final double balance;
  final int age;
  final List<String> roles;
  final SmallMetadata metadata;
  final List<String> tags;

  const SmallDocument({
    required this.id,
    required this.uuid,
    required this.name,
    required this.email,
    required this.isActive,
    required this.balance,
    required this.age,
    required this.roles,
    required this.metadata,
    required this.tags,
  });

  static SmallDocument fromReader(JsonTokenReader reader) =>
      _$SmallDocumentFromReader(reader);
  void toWriter(JsonTokenWriter writer) =>
      _$SmallDocumentToWriter(this, writer);

  static SmallDocument decode(Decoder decoder) =>
      _$SmallDocumentFromDecoder(decoder);
}
