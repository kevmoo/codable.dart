// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:codable/codable.dart';
import 'package:codable/src/driver/json_codable_driver.dart';

part 'citm_catalog.g.dart';

@Codable()
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

  static CitmCatalog fromReader(JsonTokenReader reader) =>
      _$CitmCatalogFromReader(reader);
  void toWriter(JsonTokenWriter writer) => _$CitmCatalogToWriter(this, writer);

  static CitmCatalog decodeFromReader(JsonTokenReader reader) =>
      _$CitmCatalogFromReader(reader);
  void encodeToWriter(JsonTokenWriter writer) =>
      _$CitmCatalogToWriter(this, writer);

  static CitmCatalog decode(Decoder decoder) {
    if (decoder is JsonCodableDecoder) {
      return _$CitmCatalogFromReader(decoder.reader);
    }
    final keyed = decoder.keyed();
    var areaNames = const <String, String>{};
    var audienceSubCategoryNames = const <String, String>{};
    var blockNames = const <String, String>{};
    var events = const <String, CitmEvent>{};
    var performances = const <CitmPerformance>[];
    var seatCategoryNames = const <String, String>{};
    var subTopicNames = const <String, String>{};
    var subjectNames = const <String, String>{};
    var topicNames = const <String, String>{};
    var topicSynced = const <String, bool>{};
    var venueNames = const <String, String>{};

    while (keyed.hasNextKey()) {
      switch (keyed.selectKeyIndex(
        KeyOptions([
          'areaNames',
          'audienceSubCategoryNames',
          'blockNames',
          'events',
          'performances',
          'seatCategoryNames',
          'subTopicNames',
          'subjectNames',
          'topicNames',
          'topicSynced',
          'venueNames',
        ]),
      )) {
        case 0:
          areaNames = keyed.decodeValue(_decodeStringMap);
          break;
        case 1:
          audienceSubCategoryNames = keyed.decodeValue(_decodeStringMap);
          break;
        case 2:
          blockNames = keyed.decodeValue(_decodeStringMap);
          break;
        case 3:
          events = keyed.decodeValue(
            (d) => _decodeObjectMap(d, CitmEvent.decode),
          );
          break;
        case 4:
          performances = keyed.decodeList(CitmPerformance.decode);
          break;
        case 5:
          seatCategoryNames = keyed.decodeValue(_decodeStringMap);
          break;
        case 6:
          subTopicNames = keyed.decodeValue(_decodeStringMap);
          break;
        case 7:
          subjectNames = keyed.decodeValue(_decodeStringMap);
          break;
        case 8:
          topicNames = keyed.decodeValue(_decodeStringMap);
          break;
        case 9:
          topicSynced = keyed.decodeValue(_decodeBoolMap);
          break;
        case 10:
          venueNames = keyed.decodeValue(_decodeStringMap);
          break;
        default:
          keyed.skipValue();
          break;
      }
    }

    return CitmCatalog(
      areaNames: areaNames,
      audienceSubCategoryNames: audienceSubCategoryNames,
      blockNames: blockNames,
      events: events,
      performances: performances,
      seatCategoryNames: seatCategoryNames,
      subTopicNames: subTopicNames,
      subjectNames: subjectNames,
      topicNames: topicNames,
      topicSynced: topicSynced,
      venueNames: venueNames,
    );
  }
}

@Codable()
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

  static CitmEvent fromReader(JsonTokenReader reader) =>
      _$CitmEventFromReader(reader);
  void toWriter(JsonTokenWriter writer) => _$CitmEventToWriter(this, writer);

  static CitmEvent decodeFromReader(JsonTokenReader reader) =>
      _$CitmEventFromReader(reader);
  void encodeToWriter(JsonTokenWriter writer) =>
      _$CitmEventToWriter(this, writer);

  static CitmEvent decode(Decoder decoder) {
    if (decoder is JsonCodableDecoder) {
      return _$CitmEventFromReader(decoder.reader);
    }
    final keyed = decoder.keyed();
    String? description;
    int? id;
    String? logo;
    String? name;
    List<int>? subTopicIds;
    int? subjectCode;
    String? subtitle;
    List<int>? topicIds;

    while (keyed.hasNextKey()) {
      switch (keyed.selectKeyIndex(
        KeyOptions([
          'description',
          'id',
          'logo',
          'name',
          'subTopicIds',
          'subjectCode',
          'subtitle',
          'topicIds',
        ]),
      )) {
        case 0:
          description = keyed.readNullableString();
          break;
        case 1:
          id = keyed.readInt();
          break;
        case 2:
          logo = keyed.readNullableString();
          break;
        case 3:
          name = keyed.readString();
          break;
        case 4:
          subTopicIds = keyed.decodeIntList();
          break;
        case 5:
          subjectCode = keyed.readNullableInt();
          break;
        case 6:
          subtitle = keyed.readNullableString();
          break;
        case 7:
          topicIds = keyed.decodeIntList();
          break;
        default:
          keyed.skipValue();
          break;
      }
    }

    return CitmEvent(
      description: description,
      id: id ?? 0,
      logo: logo,
      name: name ?? '',
      subTopicIds: subTopicIds ?? const [],
      subjectCode: subjectCode,
      subtitle: subtitle,
      topicIds: topicIds ?? const [],
    );
  }
}

@Codable()
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

  static CitmPerformance fromReader(JsonTokenReader reader) =>
      _$CitmPerformanceFromReader(reader);
  void toWriter(JsonTokenWriter writer) =>
      _$CitmPerformanceToWriter(this, writer);

  static CitmPerformance decodeFromReader(JsonTokenReader reader) =>
      _$CitmPerformanceFromReader(reader);
  void encodeToWriter(JsonTokenWriter writer) =>
      _$CitmPerformanceToWriter(this, writer);

  static CitmPerformance decode(Decoder decoder) {
    if (decoder is JsonCodableDecoder) {
      return _$CitmPerformanceFromReader(decoder.reader);
    }
    final keyed = decoder.keyed();
    int? eventId;
    int? id;
    String? logo;
    String? name;
    List<CitmPrice>? prices;
    List<CitmSeatCategory>? seatCategories;
    int? start;
    String? venueCode;

    while (keyed.hasNextKey()) {
      switch (keyed.selectKeyIndex(
        KeyOptions([
          'eventId',
          'id',
          'logo',
          'name',
          'prices',
          'seatCategories',
          'start',
          'venueCode',
        ]),
      )) {
        case 0:
          eventId = keyed.readInt();
          break;
        case 1:
          id = keyed.readInt();
          break;
        case 2:
          logo = keyed.readNullableString();
          break;
        case 3:
          name = keyed.readNullableString();
          break;
        case 4:
          prices = keyed.decodeList(CitmPrice.decode);
          break;
        case 5:
          seatCategories = keyed.decodeList(CitmSeatCategory.decode);
          break;
        case 6:
          start = keyed.readInt();
          break;
        case 7:
          venueCode = keyed.readString();
          break;
        default:
          keyed.skipValue();
          break;
      }
    }

    return CitmPerformance(
      eventId: eventId ?? 0,
      id: id ?? 0,
      logo: logo,
      name: name,
      prices: prices ?? const [],
      seatCategories: seatCategories ?? const [],
      start: start ?? 0,
      venueCode: venueCode ?? '',
    );
  }
}

@Codable()
class CitmPrice {
  final int amount;
  final int audienceSubCategoryId;
  final int seatCategoryId;

  const CitmPrice({
    required this.amount,
    required this.audienceSubCategoryId,
    required this.seatCategoryId,
  });

  static CitmPrice fromReader(JsonTokenReader reader) =>
      _$CitmPriceFromReader(reader);
  void toWriter(JsonTokenWriter writer) => _$CitmPriceToWriter(this, writer);

  static CitmPrice decodeFromReader(JsonTokenReader reader) =>
      _$CitmPriceFromReader(reader);
  void encodeToWriter(JsonTokenWriter writer) =>
      _$CitmPriceToWriter(this, writer);

  static CitmPrice decode(Decoder decoder) {
    if (decoder is JsonCodableDecoder) {
      return _$CitmPriceFromReader(decoder.reader);
    }
    final keyed = decoder.keyed();
    int? amount;
    int? audienceSubCategoryId;
    int? seatCategoryId;

    while (keyed.hasNextKey()) {
      switch (keyed.selectKeyIndex(
        KeyOptions(['amount', 'audienceSubCategoryId', 'seatCategoryId']),
      )) {
        case 0:
          amount = keyed.readInt();
          break;
        case 1:
          audienceSubCategoryId = keyed.readInt();
          break;
        case 2:
          seatCategoryId = keyed.readInt();
          break;
        default:
          keyed.skipValue();
          break;
      }
    }

    return CitmPrice(
      amount: amount ?? 0,
      audienceSubCategoryId: audienceSubCategoryId ?? 0,
      seatCategoryId: seatCategoryId ?? 0,
    );
  }
}

@Codable()
class CitmSeatCategory {
  final List<CitmArea> areas;
  final int seatCategoryId;

  const CitmSeatCategory({this.areas = const [], required this.seatCategoryId});

  static CitmSeatCategory fromReader(JsonTokenReader reader) =>
      _$CitmSeatCategoryFromReader(reader);
  void toWriter(JsonTokenWriter writer) =>
      _$CitmSeatCategoryToWriter(this, writer);

  static CitmSeatCategory decodeFromReader(JsonTokenReader reader) =>
      _$CitmSeatCategoryFromReader(reader);
  void encodeToWriter(JsonTokenWriter writer) =>
      _$CitmSeatCategoryToWriter(this, writer);

  static CitmSeatCategory decode(Decoder decoder) {
    if (decoder is JsonCodableDecoder) {
      return _$CitmSeatCategoryFromReader(decoder.reader);
    }
    final keyed = decoder.keyed();
    List<CitmArea>? areas;
    int? seatCategoryId;

    while (keyed.hasNextKey()) {
      switch (keyed.selectKeyIndex(KeyOptions(['areas', 'seatCategoryId']))) {
        case 0:
          areas = keyed.decodeList(CitmArea.decode);
          break;
        case 1:
          seatCategoryId = keyed.readInt();
          break;
        default:
          keyed.skipValue();
          break;
      }
    }

    return CitmSeatCategory(
      areas: areas ?? const [],
      seatCategoryId: seatCategoryId ?? 0,
    );
  }
}

@Codable()
class CitmArea {
  final int areaId;
  final List<int> blockIds;

  const CitmArea({required this.areaId, this.blockIds = const []});

  static CitmArea fromReader(JsonTokenReader reader) =>
      _$CitmAreaFromReader(reader);
  void toWriter(JsonTokenWriter writer) => _$CitmAreaToWriter(this, writer);

  static CitmArea decodeFromReader(JsonTokenReader reader) =>
      _$CitmAreaFromReader(reader);
  void encodeToWriter(JsonTokenWriter writer) =>
      _$CitmAreaToWriter(this, writer);

  static CitmArea decode(Decoder decoder) {
    if (decoder is JsonCodableDecoder) {
      return _$CitmAreaFromReader(decoder.reader);
    }
    final keyed = decoder.keyed();
    int? areaId;
    List<int>? blockIds;

    while (keyed.hasNextKey()) {
      switch (keyed.selectKeyIndex(KeyOptions(['areaId', 'blockIds']))) {
        case 0:
          areaId = keyed.readInt();
          break;
        case 1:
          blockIds = keyed.decodeIntList();
          break;
        default:
          keyed.skipValue();
          break;
      }
    }

    return CitmArea(areaId: areaId ?? 0, blockIds: blockIds ?? const []);
  }
}

Map<String, String> _decodeStringMap(Decoder decoder) {
  final map = <String, String>{};
  final keyed = decoder.keyed();
  while (keyed.hasNextKey()) {
    map[keyed.nextKey()] = keyed.readString();
  }
  return map;
}

Map<String, bool> _decodeBoolMap(Decoder decoder) {
  final map = <String, bool>{};
  final keyed = decoder.keyed();
  while (keyed.hasNextKey()) {
    map[keyed.nextKey()] = keyed.readBool();
  }
  return map;
}

Map<String, T> _decodeObjectMap<T>(
  Decoder decoder,
  T Function(Decoder) decode,
) {
  final map = <String, T>{};
  final keyed = decoder.keyed();
  while (keyed.hasNextKey()) {
    final key = keyed.nextKey();
    map[key] = keyed.decodeValue(decode);
  }
  return map;
}
