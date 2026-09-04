// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: lines_longer_than_80_chars, unnecessary_lambdas, deprecated_member_use, unused_element

part of 'small.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SmallLocation _$SmallLocationFromJson(Map<String, dynamic> json) =>
    SmallLocation(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      city: json['city'] as String,
      country: json['country'] as String,
    );

Map<String, dynamic> _$SmallLocationToJson(SmallLocation instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'city': instance.city,
      'country': instance.country,
    };

SmallMetadata _$SmallMetadataFromJson(Map<String, dynamic> json) =>
    SmallMetadata(
      loginCount: (json['loginCount'] as num).toInt(),
      lastLogin: json['lastLogin'] as String,
      location: SmallLocation.fromJson(
        json['location'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$SmallMetadataToJson(SmallMetadata instance) =>
    <String, dynamic>{
      'loginCount': instance.loginCount,
      'lastLogin': instance.lastLogin,
      'location': instance.location,
    };

SmallDocument _$SmallDocumentFromJson(Map<String, dynamic> json) =>
    SmallDocument(
      id: (json['id'] as num).toInt(),
      uuid: json['uuid'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      isActive: json['isActive'] as bool,
      balance: (json['balance'] as num).toDouble(),
      age: (json['age'] as num).toInt(),
      roles: (json['roles'] as List<dynamic>).map((e) => e as String).toList(),
      metadata: SmallMetadata.fromJson(
        json['metadata'] as Map<String, dynamic>,
      ),
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$SmallDocumentToJson(SmallDocument instance) =>
    <String, dynamic>{
      'id': instance.id,
      'uuid': instance.uuid,
      'name': instance.name,
      'email': instance.email,
      'isActive': instance.isActive,
      'balance': instance.balance,
      'age': instance.age,
      'roles': instance.roles,
      'metadata': instance.metadata,
      'tags': instance.tags,
    };
