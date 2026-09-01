// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: lines_longer_than_80_chars

part of 'canada.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CanadaProperties _$CanadaPropertiesFromJson(Map<String, dynamic> json) =>
    CanadaProperties(name: json['name'] as String? ?? '');

Map<String, dynamic> _$CanadaPropertiesToJson(CanadaProperties instance) =>
    <String, dynamic>{'name': instance.name};

CanadaGeometry _$CanadaGeometryFromJson(Map<String, dynamic> json) =>
    CanadaGeometry(
      type: json['type'] as String,
      coordinates: (json['coordinates'] as List<dynamic>)
          .map(
            (e) => (e as List<dynamic>)
                .map(
                  (e) => (e as List<dynamic>)
                      .map((e) => (e as num).toDouble())
                      .toList(),
                )
                .toList(),
          )
          .toList(),
    );

Map<String, dynamic> _$CanadaGeometryToJson(CanadaGeometry instance) =>
    <String, dynamic>{
      'type': instance.type,
      'coordinates': instance.coordinates,
    };

CanadaFeature _$CanadaFeatureFromJson(Map<String, dynamic> json) =>
    CanadaFeature(
      type: json['type'] as String,
      properties: CanadaProperties.fromJson(
        json['properties'] as Map<String, dynamic>,
      ),
      geometry: CanadaGeometry.fromJson(
        json['geometry'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$CanadaFeatureToJson(CanadaFeature instance) =>
    <String, dynamic>{
      'type': instance.type,
      'properties': instance.properties,
      'geometry': instance.geometry,
    };

CanadaFeatureCollection _$CanadaFeatureCollectionFromJson(
  Map<String, dynamic> json,
) => CanadaFeatureCollection(
  type: json['type'] as String,
  features: (json['features'] as List<dynamic>)
      .map((e) => CanadaFeature.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$CanadaFeatureCollectionToJson(
  CanadaFeatureCollection instance,
) => <String, dynamic>{'type': instance.type, 'features': instance.features};
