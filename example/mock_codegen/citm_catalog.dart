import 'package:codable/codable.dart';

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
    required this.areaNames,
    required this.audienceSubCategoryNames,
    required this.blockNames,
    required this.events,
    required this.performances,
    required this.seatCategoryNames,
    required this.subTopicNames,
    required this.subjectNames,
    required this.topicNames,
    required this.topicSynced,
    required this.venueNames,
  });

  static final _options = KeyOptions([
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
  ]);

  static CitmCatalog decode(Decoder decoder) {
    final keyed = decoder.keyed();
    Map<String, String>? areaNames;
    Map<String, String>? audienceSubCategoryNames;
    Map<String, String>? blockNames;
    Map<String, CitmEvent>? events;
    List<CitmPerformance>? performances;
    Map<String, String>? seatCategoryNames;
    Map<String, String>? subTopicNames;
    Map<String, String>? subjectNames;
    Map<String, String>? topicNames;
    Map<String, bool>? topicSynced;
    Map<String, String>? venueNames;

    while (keyed.hasNextKey()) {
      switch (keyed.selectKeyIndex(_options)) {
        case 0:
          areaNames = decoder.decodeStringMap();
          break;
        case 1:
          audienceSubCategoryNames = decoder.decodeStringMap();
          break;
        case 2:
          blockNames = decoder.decodeStringMap();
          break;
        case 3:
          events = decoder.decodeObjectMap(CitmEvent.decode);
          break;
        case 4:
          performances = keyed.decodeList(CitmPerformance.decode);
          break;
        case 5:
          seatCategoryNames = decoder.decodeStringMap();
          break;
        case 6:
          subTopicNames = decoder.decodeStringMap();
          break;
        case 7:
          subjectNames = decoder.decodeStringMap();
          break;
        case 8:
          topicNames = decoder.decodeStringMap();
          break;
        case 9:
          topicSynced = decoder.decodeBoolMap();
          break;
        case 10:
          venueNames = decoder.decodeStringMap();
          break;
        default:
          keyed.skipValue();
          break;
      }
    }

    return CitmCatalog(
      areaNames: areaNames ?? const {},
      audienceSubCategoryNames: audienceSubCategoryNames ?? const {},
      blockNames: blockNames ?? const {},
      events: events ?? const {},
      performances: performances ?? const [],
      seatCategoryNames: seatCategoryNames ?? const {},
      subTopicNames: subTopicNames ?? const {},
      subjectNames: subjectNames ?? const {},
      topicNames: topicNames ?? const {},
      topicSynced: topicSynced ?? const {},
      venueNames: venueNames ?? const {},
    );
  }
}

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
    required this.subTopicIds,
    this.subjectCode,
    this.subtitle,
    required this.topicIds,
  });

  static final _options = KeyOptions([
    'description',
    'id',
    'logo',
    'name',
    'subTopicIds',
    'subjectCode',
    'subtitle',
    'topicIds',
  ]);

  static CitmEvent decode(Decoder decoder) {
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
      switch (keyed.selectKeyIndex(_options)) {
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
    required this.prices,
    required this.seatCategories,
    required this.start,
    required this.venueCode,
  });

  static final _options = KeyOptions([
    'eventId',
    'id',
    'logo',
    'name',
    'prices',
    'seatCategories',
    'start',
    'venueCode',
  ]);

  static CitmPerformance decode(Decoder decoder) {
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
      switch (keyed.selectKeyIndex(_options)) {
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

class CitmPrice {
  final int amount;
  final int audienceSubCategoryId;
  final int seatCategoryId;

  const CitmPrice({
    required this.amount,
    required this.audienceSubCategoryId,
    required this.seatCategoryId,
  });

  static final _options = KeyOptions([
    'amount',
    'audienceSubCategoryId',
    'seatCategoryId',
  ]);

  static CitmPrice decode(Decoder decoder) {
    final keyed = decoder.keyed();
    int? amount;
    int? audienceSubCategoryId;
    int? seatCategoryId;

    while (keyed.hasNextKey()) {
      switch (keyed.selectKeyIndex(_options)) {
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

class CitmSeatCategory {
  final List<CitmArea> areas;
  final int seatCategoryId;

  const CitmSeatCategory({required this.areas, required this.seatCategoryId});

  static final _options = KeyOptions(['areas', 'seatCategoryId']);

  static CitmSeatCategory decode(Decoder decoder) {
    final keyed = decoder.keyed();
    List<CitmArea>? areas;
    int? seatCategoryId;

    while (keyed.hasNextKey()) {
      switch (keyed.selectKeyIndex(_options)) {
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

class CitmArea {
  final int areaId;
  final List<int> blockIds;

  const CitmArea({required this.areaId, required this.blockIds});

  static final _options = KeyOptions(['areaId', 'blockIds']);

  static CitmArea decode(Decoder decoder) {
    final keyed = decoder.keyed();
    int? areaId;
    List<int>? blockIds;

    while (keyed.hasNextKey()) {
      switch (keyed.selectKeyIndex(_options)) {
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

extension on Decoder {
  Map<String, String> decodeStringMap() {
    final map = <String, String>{};
    final keyed = this.keyed();
    while (keyed.hasNextKey()) {
      map[keyed.nextKey()] = keyed.readString();
    }
    return map;
  }

  Map<String, bool> decodeBoolMap() {
    final map = <String, bool>{};
    final keyed = this.keyed();
    while (keyed.hasNextKey()) {
      map[keyed.nextKey()] = keyed.readBool();
    }
    return map;
  }

  Map<String, T> decodeObjectMap<T>(T Function(Decoder) decode) {
    final map = <String, T>{};
    final keyed = this.keyed();
    while (keyed.hasNextKey()) {
      final key = keyed.nextKey();
      map[key] = decode(this);
    }
    return map;
  }
}
