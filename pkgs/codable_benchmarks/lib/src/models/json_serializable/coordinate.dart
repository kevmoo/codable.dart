// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:json_annotation/json_annotation.dart';

part 'coordinate.g.dart';

@JsonSerializable()
class Coordinate {
  final double latitude;
  final double longitude;

  const Coordinate({required this.latitude, required this.longitude});

  factory Coordinate.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('lat') || json.containsKey('lon')) {
      return Coordinate(
        latitude: ((json['latitude'] ?? json['lat']) as num).toDouble(),
        longitude: ((json['longitude'] ?? json['lon']) as num).toDouble(),
      );
    }
    return _$CoordinateFromJson(json);
  }

  Map<String, dynamic> toJson() => _$CoordinateToJson(this);
}
