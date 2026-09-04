// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: lines_longer_than_80_chars, unnecessary_lambdas, deprecated_member_use, unused_element

part of 'citm_catalog.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CitmCatalog _$CitmCatalogFromJson(Map<String, dynamic> json) => CitmCatalog(
  areaNames:
      (json['areaNames'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ) ??
      const {},
  audienceSubCategoryNames:
      (json['audienceSubCategoryNames'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ) ??
      const {},
  blockNames:
      (json['blockNames'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ) ??
      const {},
  events:
      (json['events'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, CitmEvent.fromJson(e as Map<String, dynamic>)),
      ) ??
      const {},
  performances:
      (json['performances'] as List<dynamic>?)
          ?.map((e) => CitmPerformance.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  seatCategoryNames:
      (json['seatCategoryNames'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ) ??
      const {},
  subTopicNames:
      (json['subTopicNames'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ) ??
      const {},
  subjectNames:
      (json['subjectNames'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ) ??
      const {},
  topicNames:
      (json['topicNames'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ) ??
      const {},
  topicSynced:
      (json['topicSynced'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as bool),
      ) ??
      const {},
  venueNames:
      (json['venueNames'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ) ??
      const {},
);

Map<String, dynamic> _$CitmCatalogToJson(CitmCatalog instance) =>
    <String, dynamic>{
      'areaNames': instance.areaNames,
      'audienceSubCategoryNames': instance.audienceSubCategoryNames,
      'blockNames': instance.blockNames,
      'events': instance.events,
      'performances': instance.performances,
      'seatCategoryNames': instance.seatCategoryNames,
      'subTopicNames': instance.subTopicNames,
      'subjectNames': instance.subjectNames,
      'topicNames': instance.topicNames,
      'topicSynced': instance.topicSynced,
      'venueNames': instance.venueNames,
    };

CitmEvent _$CitmEventFromJson(Map<String, dynamic> json) => CitmEvent(
  description: json['description'] as String?,
  id: (json['id'] as num).toInt(),
  logo: json['logo'] as String?,
  name: json['name'] as String,
  subTopicIds:
      (json['subTopicIds'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList() ??
      const [],
  subjectCode: (json['subjectCode'] as num?)?.toInt(),
  subtitle: json['subtitle'] as String?,
  topicIds:
      (json['topicIds'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList() ??
      const [],
);

Map<String, dynamic> _$CitmEventToJson(CitmEvent instance) => <String, dynamic>{
  'description': instance.description,
  'id': instance.id,
  'logo': instance.logo,
  'name': instance.name,
  'subTopicIds': instance.subTopicIds,
  'subjectCode': instance.subjectCode,
  'subtitle': instance.subtitle,
  'topicIds': instance.topicIds,
};

CitmPerformance _$CitmPerformanceFromJson(Map<String, dynamic> json) =>
    CitmPerformance(
      eventId: (json['eventId'] as num).toInt(),
      id: (json['id'] as num).toInt(),
      logo: json['logo'] as String?,
      name: json['name'] as String?,
      prices:
          (json['prices'] as List<dynamic>?)
              ?.map((e) => CitmPrice.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      seatCategories:
          (json['seatCategories'] as List<dynamic>?)
              ?.map((e) => CitmSeatCategory.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      start: (json['start'] as num).toInt(),
      venueCode: json['venueCode'] as String,
    );

Map<String, dynamic> _$CitmPerformanceToJson(CitmPerformance instance) =>
    <String, dynamic>{
      'eventId': instance.eventId,
      'id': instance.id,
      'logo': instance.logo,
      'name': instance.name,
      'prices': instance.prices,
      'seatCategories': instance.seatCategories,
      'start': instance.start,
      'venueCode': instance.venueCode,
    };

CitmPrice _$CitmPriceFromJson(Map<String, dynamic> json) => CitmPrice(
  amount: (json['amount'] as num).toInt(),
  audienceSubCategoryId: (json['audienceSubCategoryId'] as num).toInt(),
  seatCategoryId: (json['seatCategoryId'] as num).toInt(),
);

Map<String, dynamic> _$CitmPriceToJson(CitmPrice instance) => <String, dynamic>{
  'amount': instance.amount,
  'audienceSubCategoryId': instance.audienceSubCategoryId,
  'seatCategoryId': instance.seatCategoryId,
};

CitmSeatCategory _$CitmSeatCategoryFromJson(Map<String, dynamic> json) =>
    CitmSeatCategory(
      areas:
          (json['areas'] as List<dynamic>?)
              ?.map((e) => CitmArea.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      seatCategoryId: (json['seatCategoryId'] as num).toInt(),
    );

Map<String, dynamic> _$CitmSeatCategoryToJson(CitmSeatCategory instance) =>
    <String, dynamic>{
      'areas': instance.areas,
      'seatCategoryId': instance.seatCategoryId,
    };

CitmArea _$CitmAreaFromJson(Map<String, dynamic> json) => CitmArea(
  areaId: (json['areaId'] as num).toInt(),
  blockIds:
      (json['blockIds'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList() ??
      const [],
);

Map<String, dynamic> _$CitmAreaToJson(CitmArea instance) => <String, dynamic>{
  'areaId': instance.areaId,
  'blockIds': instance.blockIds,
};
