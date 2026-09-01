// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:json_annotation/json_annotation.dart';

part 'citm_catalog.g.dart';

@JsonSerializable()
class CitmCatalog {
  final Map<String, String> areaNames;
  final Map<String, String> audienceSubCategoryNames;
  final Map<String, String> blockNames;
  final Map<String, CitmEvent> events;
  final List<CitmPerformance> performances;
  final Map<String, String> seatCategoryNames;
  final Map<String, String> subTopicNames;
  final Map<String, String> subjectNames;
  final Map<String, String> topicNames;
  final Map<String, bool> topicSynced;
  final Map<String, String> venueNames;

  const CitmCatalog({
    this.areaNames = const {},
    this.audienceSubCategoryNames = const {},
    this.blockNames = const {},
    this.events = const {},
    this.performances = const [],
    this.seatCategoryNames = const {},
    this.subTopicNames = const {},
    this.subjectNames = const {},
    this.topicNames = const {},
    this.topicSynced = const {},
    this.venueNames = const {},
  });

  factory CitmCatalog.fromJson(Map<String, dynamic> json) =>
      _$CitmCatalogFromJson(json);

  Map<String, dynamic> toJson() => _$CitmCatalogToJson(this);
}

@JsonSerializable()
class CitmEvent {
  final String? description;
  final int id;
  final String? logo;
  final String name;
  final List<int> subTopicIds;
  final int? subjectCode;
  final String? subtitle;
  final List<int> topicIds;

  const CitmEvent({
    this.description,
    required this.id,
    this.logo,
    required this.name,
    this.subTopicIds = const [],
    this.subjectCode,
    this.subtitle,
    this.topicIds = const [],
  });

  factory CitmEvent.fromJson(Map<String, dynamic> json) =>
      _$CitmEventFromJson(json);

  Map<String, dynamic> toJson() => _$CitmEventToJson(this);
}

@JsonSerializable()
class CitmPerformance {
  final int eventId;
  final int id;
  final String? logo;
  final String? name;
  final List<CitmPrice> prices;
  final List<CitmSeatCategory> seatCategories;
  final int start;
  final String venueCode;

  const CitmPerformance({
    required this.eventId,
    required this.id,
    this.logo,
    this.name,
    this.prices = const [],
    this.seatCategories = const [],
    required this.start,
    required this.venueCode,
  });

  factory CitmPerformance.fromJson(Map<String, dynamic> json) =>
      _$CitmPerformanceFromJson(json);

  Map<String, dynamic> toJson() => _$CitmPerformanceToJson(this);
}

@JsonSerializable()
class CitmPrice {
  final int amount;
  final int audienceSubCategoryId;
  final int seatCategoryId;

  const CitmPrice({
    required this.amount,
    required this.audienceSubCategoryId,
    required this.seatCategoryId,
  });

  factory CitmPrice.fromJson(Map<String, dynamic> json) =>
      _$CitmPriceFromJson(json);

  Map<String, dynamic> toJson() => _$CitmPriceToJson(this);
}

@JsonSerializable()
class CitmSeatCategory {
  final List<CitmArea> areas;
  final int seatCategoryId;

  const CitmSeatCategory({this.areas = const [], required this.seatCategoryId});

  factory CitmSeatCategory.fromJson(Map<String, dynamic> json) =>
      _$CitmSeatCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$CitmSeatCategoryToJson(this);
}

@JsonSerializable()
class CitmArea {
  final int areaId;
  final List<int> blockIds;

  const CitmArea({required this.areaId, this.blockIds = const []});

  factory CitmArea.fromJson(Map<String, dynamic> json) =>
      _$CitmAreaFromJson(json);

  Map<String, dynamic> toJson() => _$CitmAreaToJson(this);
}
