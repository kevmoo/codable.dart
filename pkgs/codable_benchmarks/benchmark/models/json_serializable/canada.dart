// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:json_annotation/json_annotation.dart';

part 'canada.g.dart';

@JsonSerializable()
class CanadaProperties {
  final String name;

  const CanadaProperties({this.name = ''});

  factory CanadaProperties.fromJson(Map<String, dynamic> json) =>
      _$CanadaPropertiesFromJson(json);

  Map<String, dynamic> toJson() => _$CanadaPropertiesToJson(this);
}

@JsonSerializable()
class CanadaGeometry {
  final String type;
  final List<List<List<double>>> coordinates;

  const CanadaGeometry({required this.type, required this.coordinates});

  factory CanadaGeometry.fromJson(Map<String, dynamic> json) =>
      _$CanadaGeometryFromJson(json);

  Map<String, dynamic> toJson() => _$CanadaGeometryToJson(this);
}

@JsonSerializable()
class CanadaFeature {
  final String type;
  final CanadaProperties properties;
  final CanadaGeometry geometry;

  const CanadaFeature({
    required this.type,
    required this.properties,
    required this.geometry,
  });

  factory CanadaFeature.fromJson(Map<String, dynamic> json) =>
      _$CanadaFeatureFromJson(json);

  Map<String, dynamic> toJson() => _$CanadaFeatureToJson(this);
}

@JsonSerializable()
class CanadaFeatureCollection {
  final String type;
  final List<CanadaFeature> features;

  const CanadaFeatureCollection({required this.type, required this.features});

  factory CanadaFeatureCollection.fromJson(Map<String, dynamic> json) =>
      _$CanadaFeatureCollectionFromJson(json);

  Map<String, dynamic> toJson() => _$CanadaFeatureCollectionToJson(this);
}
