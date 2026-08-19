// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:json_annotation/json_annotation.dart';

part 'small.g.dart';

@JsonSerializable()
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

  factory SmallLocation.fromJson(Map<String, dynamic> json) =>
      _$SmallLocationFromJson(json);

  Map<String, dynamic> toJson() => _$SmallLocationToJson(this);
}

@JsonSerializable()
class SmallMetadata {
  final int loginCount;
  final String lastLogin;
  final SmallLocation location;

  const SmallMetadata({
    required this.loginCount,
    required this.lastLogin,
    required this.location,
  });

  factory SmallMetadata.fromJson(Map<String, dynamic> json) =>
      _$SmallMetadataFromJson(json);

  Map<String, dynamic> toJson() => _$SmallMetadataToJson(this);
}

@JsonSerializable()
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

  factory SmallDocument.fromJson(Map<String, dynamic> json) =>
      _$SmallDocumentFromJson(json);

  Map<String, dynamic> toJson() => _$SmallDocumentToJson(this);
}
