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

  static SmallLocation decode(Decoder decoder) =>
      _$SmallLocationFromDecoder(decoder);
  void encode(Encoder encoder) => _$SmallLocationToEncoder(this, encoder);
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

  static SmallMetadata decode(Decoder decoder) =>
      _$SmallMetadataFromDecoder(decoder);
  void encode(Encoder encoder) => _$SmallMetadataToEncoder(this, encoder);
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

  static SmallDocument decode(Decoder decoder) =>
      _$SmallDocumentFromDecoder(decoder);
  void encode(Encoder encoder) => _$SmallDocumentToEncoder(this, encoder);
}
