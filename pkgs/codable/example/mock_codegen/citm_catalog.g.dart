// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: lines_longer_than_80_chars, unnecessary_lambdas, deprecated_member_use, unused_element

part of 'citm_catalog.dart';

// **************************************************************************
// CodableGenerator
// **************************************************************************

// =============================================================================
// 1. Unified Schema Descriptor for CitmCatalog
// =============================================================================
extension type const _$CitmCatalogSchema(int _value) {
  // String Name Constants
  static const String nameAreaNames = 'areaNames';
  static const String nameAudienceSubCategoryNames = 'audienceSubCategoryNames';
  static const String nameBlockNames = 'blockNames';
  static const String nameEvents = 'events';
  static const String namePerformances = 'performances';
  static const String nameSeatCategoryNames = 'seatCategoryNames';
  static const String nameSubTopicNames = 'subTopicNames';
  static const String nameSubjectNames = 'subjectNames';
  static const String nameTopicNames = 'topicNames';
  static const String nameTopicSynced = 'topicSynced';
  static const String nameVenueNames = 'venueNames';

  // Key Indices for selectKeyIndex()
  static const int keyAreaNames = 0;
  static const int keyAudienceSubCategoryNames = 1;
  static const int keyBlockNames = 2;
  static const int keyEvents = 3;
  static const int keyPerformances = 4;
  static const int keySeatCategoryNames = 5;
  static const int keySubTopicNames = 6;
  static const int keySubjectNames = 7;
  static const int keyTopicNames = 8;
  static const int keyTopicSynced = 9;
  static const int keyVenueNames = 10;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
    _$CitmCatalogSchema.nameAreaNames,
    _$CitmCatalogSchema.nameAudienceSubCategoryNames,
    _$CitmCatalogSchema.nameBlockNames,
    _$CitmCatalogSchema.nameEvents,
    _$CitmCatalogSchema.namePerformances,
    _$CitmCatalogSchema.nameSeatCategoryNames,
    _$CitmCatalogSchema.nameSubTopicNames,
    _$CitmCatalogSchema.nameSubjectNames,
    _$CitmCatalogSchema.nameTopicNames,
    _$CitmCatalogSchema.nameTopicSynced,
    _$CitmCatalogSchema.nameVenueNames,
  ]);
  static final KeyOptions keyOptions = options;

  // Bitmask Flags strictly for Required Fields
  static const _$CitmCatalogSchema none = _$CitmCatalogSchema(0);

  @pragma('vm:prefer-inline')
  _$CitmCatalogSchema operator |(_$CitmCatalogSchema other) =>
      _$CitmCatalogSchema(_value | other._value);

  /// Validates required fields in 1 CPU test instruction on the fast path.
  @pragma('vm:prefer-inline')
  void validate() {}
}

// =============================================================================
// 2. Universal Keyed Deserializer for CitmCatalog
// =============================================================================
CitmCatalog _$CitmCatalogFromDecoder(Decoder decoder) {
  final keyed = decoder.keyed(options: _$CitmCatalogSchema.keyOptions);

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
  var seen = _$CitmCatalogSchema.none;

  while (keyed.hasNextKey()) {
    switch (keyed.selectKeyIndex(_$CitmCatalogSchema.keyOptions)) {
      case _$CitmCatalogSchema.keyAreaNames:
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          areaNames = keyed.decodeValue((d) {
            final m = <String, String>{};
            final k = d.keyed();
            while (k.hasNextKey()) {
              final key = k.nextKey();
              m[key] = k.readString();
            }
            return m;
          });
        }
        break;
      case _$CitmCatalogSchema.keyAudienceSubCategoryNames:
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          audienceSubCategoryNames = keyed.decodeValue((d) {
            final m = <String, String>{};
            final k = d.keyed();
            while (k.hasNextKey()) {
              final key = k.nextKey();
              m[key] = k.readString();
            }
            return m;
          });
        }
        break;
      case _$CitmCatalogSchema.keyBlockNames:
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          blockNames = keyed.decodeValue((d) {
            final m = <String, String>{};
            final k = d.keyed();
            while (k.hasNextKey()) {
              final key = k.nextKey();
              m[key] = k.readString();
            }
            return m;
          });
        }
        break;
      case _$CitmCatalogSchema.keyEvents:
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          events = keyed.decodeValue((d) {
            final m = <String, CitmEvent>{};
            final k = d.keyed();
            while (k.hasNextKey()) {
              final key = k.nextKey();
              m[key] = k.decodeValue(_$CitmEventFromDecoder);
            }
            return m;
          });
        }
        break;
      case _$CitmCatalogSchema.keyPerformances:
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          performances = keyed.decodeList(_$CitmPerformanceFromDecoder);
        }
        break;
      case _$CitmCatalogSchema.keySeatCategoryNames:
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          seatCategoryNames = keyed.decodeValue((d) {
            final m = <String, String>{};
            final k = d.keyed();
            while (k.hasNextKey()) {
              final key = k.nextKey();
              m[key] = k.readString();
            }
            return m;
          });
        }
        break;
      case _$CitmCatalogSchema.keySubTopicNames:
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          subTopicNames = keyed.decodeValue((d) {
            final m = <String, String>{};
            final k = d.keyed();
            while (k.hasNextKey()) {
              final key = k.nextKey();
              m[key] = k.readString();
            }
            return m;
          });
        }
        break;
      case _$CitmCatalogSchema.keySubjectNames:
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          subjectNames = keyed.decodeValue((d) {
            final m = <String, String>{};
            final k = d.keyed();
            while (k.hasNextKey()) {
              final key = k.nextKey();
              m[key] = k.readString();
            }
            return m;
          });
        }
        break;
      case _$CitmCatalogSchema.keyTopicNames:
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          topicNames = keyed.decodeValue((d) {
            final m = <String, String>{};
            final k = d.keyed();
            while (k.hasNextKey()) {
              final key = k.nextKey();
              m[key] = k.readString();
            }
            return m;
          });
        }
        break;
      case _$CitmCatalogSchema.keyTopicSynced:
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          topicSynced = keyed.decodeValue((d) {
            final m = <String, bool>{};
            final k = d.keyed();
            while (k.hasNextKey()) {
              final key = k.nextKey();
              m[key] = k.readBool();
            }
            return m;
          });
        }
        break;
      case _$CitmCatalogSchema.keyVenueNames:
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          venueNames = keyed.decodeValue((d) {
            final m = <String, String>{};
            final k = d.keyed();
            while (k.hasNextKey()) {
              final key = k.nextKey();
              m[key] = k.readString();
            }
            return m;
          });
        }
        break;
      default:
        keyed.skipValue();
        break;
    }
  }

  // Inlined fast-path check
  seen.validate();

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

// =============================================================================
// 3. Universal Serializer for CitmCatalog
// =============================================================================
void _$CitmCatalogToEncoder(CitmCatalog instance, Encoder encoder) {
  final keyed = encoder.keyed();
  keyed.encodeValue(_$CitmCatalogSchema.nameAreaNames, instance.areaNames, (
    map,
    e,
  ) {
    final k = e.keyed();
    for (final entry in map.entries) {
      k.encodeString(entry.key, entry.value);
    }
  });
  keyed.encodeValue(
    _$CitmCatalogSchema.nameAudienceSubCategoryNames,
    instance.audienceSubCategoryNames,
    (map, e) {
      final k = e.keyed();
      for (final entry in map.entries) {
        k.encodeString(entry.key, entry.value);
      }
    },
  );
  keyed.encodeValue(_$CitmCatalogSchema.nameBlockNames, instance.blockNames, (
    map,
    e,
  ) {
    final k = e.keyed();
    for (final entry in map.entries) {
      k.encodeString(entry.key, entry.value);
    }
  });
  keyed.encodeValue(_$CitmCatalogSchema.nameEvents, instance.events, (map, e) {
    final k = e.keyed();
    for (final entry in map.entries) {
      k.encodeValue(entry.key, entry.value, _$CitmEventToEncoder);
    }
  });
  keyed.encodeList(
    _$CitmCatalogSchema.namePerformances,
    instance.performances,
    _$CitmPerformanceToEncoder,
  );
  keyed.encodeValue(
    _$CitmCatalogSchema.nameSeatCategoryNames,
    instance.seatCategoryNames,
    (map, e) {
      final k = e.keyed();
      for (final entry in map.entries) {
        k.encodeString(entry.key, entry.value);
      }
    },
  );
  keyed.encodeValue(
    _$CitmCatalogSchema.nameSubTopicNames,
    instance.subTopicNames,
    (map, e) {
      final k = e.keyed();
      for (final entry in map.entries) {
        k.encodeString(entry.key, entry.value);
      }
    },
  );
  keyed.encodeValue(
    _$CitmCatalogSchema.nameSubjectNames,
    instance.subjectNames,
    (map, e) {
      final k = e.keyed();
      for (final entry in map.entries) {
        k.encodeString(entry.key, entry.value);
      }
    },
  );
  keyed.encodeValue(_$CitmCatalogSchema.nameTopicNames, instance.topicNames, (
    map,
    e,
  ) {
    final k = e.keyed();
    for (final entry in map.entries) {
      k.encodeString(entry.key, entry.value);
    }
  });
  keyed.encodeValue(_$CitmCatalogSchema.nameTopicSynced, instance.topicSynced, (
    map,
    e,
  ) {
    final k = e.keyed();
    for (final entry in map.entries) {
      k.encodeBool(entry.key, entry.value);
    }
  });
  keyed.encodeValue(_$CitmCatalogSchema.nameVenueNames, instance.venueNames, (
    map,
    e,
  ) {
    final k = e.keyed();
    for (final entry in map.entries) {
      k.encodeString(entry.key, entry.value);
    }
  });
}

// =============================================================================
// 1. Unified Schema Descriptor for CitmEvent
// =============================================================================
extension type const _$CitmEventSchema(int _value) {
  // String Name Constants
  static const String nameDescription = 'description';
  static const String nameId = 'id';
  static const String nameLogo = 'logo';
  static const String nameName = 'name';
  static const String nameSubTopicIds = 'subTopicIds';
  static const String nameSubjectCode = 'subjectCode';
  static const String nameSubtitle = 'subtitle';
  static const String nameTopicIds = 'topicIds';

  // Key Indices for selectKeyIndex()
  static const int keyDescription = 0;
  static const int keyId = 1;
  static const int keyLogo = 2;
  static const int keyName = 3;
  static const int keySubTopicIds = 4;
  static const int keySubjectCode = 5;
  static const int keySubtitle = 6;
  static const int keyTopicIds = 7;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
    _$CitmEventSchema.nameDescription,
    _$CitmEventSchema.nameId,
    _$CitmEventSchema.nameLogo,
    _$CitmEventSchema.nameName,
    _$CitmEventSchema.nameSubTopicIds,
    _$CitmEventSchema.nameSubjectCode,
    _$CitmEventSchema.nameSubtitle,
    _$CitmEventSchema.nameTopicIds,
  ]);
  static final KeyOptions keyOptions = options;

  // Bitmask Flags strictly for Required Fields
  static const _$CitmEventSchema none = _$CitmEventSchema(0);
  static const int _idBit = 1 << 0;
  static const _$CitmEventSchema id = _$CitmEventSchema(_idBit);
  static const int _nameBit = 1 << 1;
  static const _$CitmEventSchema name = _$CitmEventSchema(_nameBit);

  // Combined Golden Bitmask for fast single-instruction check
  static const _$CitmEventSchema golden = _$CitmEventSchema(_idBit | _nameBit);

  @pragma('vm:prefer-inline')
  _$CitmEventSchema operator |(_$CitmEventSchema other) =>
      _$CitmEventSchema(_value | other._value);

  /// Validates required fields in 1 CPU test instruction on the fast path.
  @pragma('vm:prefer-inline')
  void validate() {
    if ((_value & golden._value) != golden._value) {
      _throwMissingFields();
    }
  }

  /// Out-of-line cold diagnostic reporting
  void _throwMissingFields() {
    final missing = <String>[];
    if ((_value & _idBit) == 0) {
      missing.add(nameId);
    }
    if ((_value & _nameBit) == 0) {
      missing.add(nameName);
    }
    throw CodableException(
      'Missing required fields for CitmEvent: ${missing.join(", ")}',
    );
  }
}

// =============================================================================
// 2. Universal Keyed Deserializer for CitmEvent
// =============================================================================
CitmEvent _$CitmEventFromDecoder(Decoder decoder) {
  final keyed = decoder.keyed(options: _$CitmEventSchema.keyOptions);

  String? description;
  int? id;
  String? logo;
  String? name;
  var subTopicIds = const <int>[];
  int? subjectCode;
  String? subtitle;
  var topicIds = const <int>[];
  var seen = _$CitmEventSchema.none;

  while (keyed.hasNextKey()) {
    switch (keyed.selectKeyIndex(_$CitmEventSchema.keyOptions)) {
      case _$CitmEventSchema.keyDescription:
        if (keyed.isNextNull()) {
          keyed.readNull();
          description = null;
        } else {
          description = keyed.readString();
        }
        break;
      case _$CitmEventSchema.keyId:
        if ((seen._value & _$CitmEventSchema.id._value) != 0) {
          throw const CodableException('Duplicate field "id"');
        }
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          id = keyed.readInt();
          seen |= _$CitmEventSchema.id;
        }
        break;
      case _$CitmEventSchema.keyLogo:
        if (keyed.isNextNull()) {
          keyed.readNull();
          logo = null;
        } else {
          logo = keyed.readString();
        }
        break;
      case _$CitmEventSchema.keyName:
        if ((seen._value & _$CitmEventSchema.name._value) != 0) {
          throw const CodableException('Duplicate field "name"');
        }
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          name = keyed.readString();
          seen |= _$CitmEventSchema.name;
        }
        break;
      case _$CitmEventSchema.keySubTopicIds:
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          subTopicIds = keyed.decodeIntList();
        }
        break;
      case _$CitmEventSchema.keySubjectCode:
        if (keyed.isNextNull()) {
          keyed.readNull();
          subjectCode = null;
        } else {
          subjectCode = keyed.readInt();
        }
        break;
      case _$CitmEventSchema.keySubtitle:
        if (keyed.isNextNull()) {
          keyed.readNull();
          subtitle = null;
        } else {
          subtitle = keyed.readString();
        }
        break;
      case _$CitmEventSchema.keyTopicIds:
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          topicIds = keyed.decodeIntList();
        }
        break;
      default:
        keyed.skipValue();
        break;
    }
  }

  // Inlined fast-path check
  seen.validate();

  return CitmEvent(
    description: description,
    id: id!,
    logo: logo,
    name: name!,
    subTopicIds: subTopicIds,
    subjectCode: subjectCode,
    subtitle: subtitle,
    topicIds: topicIds,
  );
}

// =============================================================================
// 3. Universal Serializer for CitmEvent
// =============================================================================
void _$CitmEventToEncoder(CitmEvent instance, Encoder encoder) {
  final keyed = encoder.keyed();
  if (instance.description != null) {
    keyed.encodeString(
      _$CitmEventSchema.nameDescription,
      instance.description!,
    );
  }
  keyed.encodeInt(_$CitmEventSchema.nameId, instance.id);
  if (instance.logo != null) {
    keyed.encodeString(_$CitmEventSchema.nameLogo, instance.logo!);
  }
  keyed.encodeString(_$CitmEventSchema.nameName, instance.name);
  keyed.encodeIntList(_$CitmEventSchema.nameSubTopicIds, instance.subTopicIds);
  if (instance.subjectCode != null) {
    keyed.encodeInt(_$CitmEventSchema.nameSubjectCode, instance.subjectCode!);
  }
  if (instance.subtitle != null) {
    keyed.encodeString(_$CitmEventSchema.nameSubtitle, instance.subtitle!);
  }
  keyed.encodeIntList(_$CitmEventSchema.nameTopicIds, instance.topicIds);
}

// =============================================================================
// 1. Unified Schema Descriptor for CitmPerformance
// =============================================================================
extension type const _$CitmPerformanceSchema(int _value) {
  // String Name Constants
  static const String nameEventId = 'eventId';
  static const String nameId = 'id';
  static const String nameLogo = 'logo';
  static const String nameName = 'name';
  static const String namePrices = 'prices';
  static const String nameSeatCategories = 'seatCategories';
  static const String nameStart = 'start';
  static const String nameVenueCode = 'venueCode';

  // Key Indices for selectKeyIndex()
  static const int keyEventId = 0;
  static const int keyId = 1;
  static const int keyLogo = 2;
  static const int keyName = 3;
  static const int keyPrices = 4;
  static const int keySeatCategories = 5;
  static const int keyStart = 6;
  static const int keyVenueCode = 7;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
    _$CitmPerformanceSchema.nameEventId,
    _$CitmPerformanceSchema.nameId,
    _$CitmPerformanceSchema.nameLogo,
    _$CitmPerformanceSchema.nameName,
    _$CitmPerformanceSchema.namePrices,
    _$CitmPerformanceSchema.nameSeatCategories,
    _$CitmPerformanceSchema.nameStart,
    _$CitmPerformanceSchema.nameVenueCode,
  ]);
  static final KeyOptions keyOptions = options;

  // Bitmask Flags strictly for Required Fields
  static const _$CitmPerformanceSchema none = _$CitmPerformanceSchema(0);
  static const int _eventIdBit = 1 << 0;
  static const _$CitmPerformanceSchema eventId = _$CitmPerformanceSchema(
    _eventIdBit,
  );
  static const int _idBit = 1 << 1;
  static const _$CitmPerformanceSchema id = _$CitmPerformanceSchema(_idBit);
  static const int _startBit = 1 << 2;
  static const _$CitmPerformanceSchema start = _$CitmPerformanceSchema(
    _startBit,
  );
  static const int _venueCodeBit = 1 << 3;
  static const _$CitmPerformanceSchema venueCode = _$CitmPerformanceSchema(
    _venueCodeBit,
  );

  // Combined Golden Bitmask for fast single-instruction check
  static const _$CitmPerformanceSchema golden = _$CitmPerformanceSchema(
    _eventIdBit | _idBit | _startBit | _venueCodeBit,
  );

  @pragma('vm:prefer-inline')
  _$CitmPerformanceSchema operator |(_$CitmPerformanceSchema other) =>
      _$CitmPerformanceSchema(_value | other._value);

  /// Validates required fields in 1 CPU test instruction on the fast path.
  @pragma('vm:prefer-inline')
  void validate() {
    if ((_value & golden._value) != golden._value) {
      _throwMissingFields();
    }
  }

  /// Out-of-line cold diagnostic reporting
  void _throwMissingFields() {
    final missing = <String>[];
    if ((_value & _eventIdBit) == 0) {
      missing.add(nameEventId);
    }
    if ((_value & _idBit) == 0) {
      missing.add(nameId);
    }
    if ((_value & _startBit) == 0) {
      missing.add(nameStart);
    }
    if ((_value & _venueCodeBit) == 0) {
      missing.add(nameVenueCode);
    }
    throw CodableException(
      'Missing required fields for CitmPerformance: ${missing.join(", ")}',
    );
  }
}

// =============================================================================
// 2. Universal Keyed Deserializer for CitmPerformance
// =============================================================================
CitmPerformance _$CitmPerformanceFromDecoder(Decoder decoder) {
  final keyed = decoder.keyed(options: _$CitmPerformanceSchema.keyOptions);

  int? eventId;
  int? id;
  String? logo;
  String? name;
  var prices = const <CitmPrice>[];
  var seatCategories = const <CitmSeatCategory>[];
  int? start;
  String? venueCode;
  var seen = _$CitmPerformanceSchema.none;

  while (keyed.hasNextKey()) {
    switch (keyed.selectKeyIndex(_$CitmPerformanceSchema.keyOptions)) {
      case _$CitmPerformanceSchema.keyEventId:
        if ((seen._value & _$CitmPerformanceSchema.eventId._value) != 0) {
          throw const CodableException('Duplicate field "eventId"');
        }
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          eventId = keyed.readInt();
          seen |= _$CitmPerformanceSchema.eventId;
        }
        break;
      case _$CitmPerformanceSchema.keyId:
        if ((seen._value & _$CitmPerformanceSchema.id._value) != 0) {
          throw const CodableException('Duplicate field "id"');
        }
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          id = keyed.readInt();
          seen |= _$CitmPerformanceSchema.id;
        }
        break;
      case _$CitmPerformanceSchema.keyLogo:
        if (keyed.isNextNull()) {
          keyed.readNull();
          logo = null;
        } else {
          logo = keyed.readString();
        }
        break;
      case _$CitmPerformanceSchema.keyName:
        if (keyed.isNextNull()) {
          keyed.readNull();
          name = null;
        } else {
          name = keyed.readString();
        }
        break;
      case _$CitmPerformanceSchema.keyPrices:
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          prices = keyed.decodeList(_$CitmPriceFromDecoder);
        }
        break;
      case _$CitmPerformanceSchema.keySeatCategories:
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          seatCategories = keyed.decodeList(_$CitmSeatCategoryFromDecoder);
        }
        break;
      case _$CitmPerformanceSchema.keyStart:
        if ((seen._value & _$CitmPerformanceSchema.start._value) != 0) {
          throw const CodableException('Duplicate field "start"');
        }
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          start = keyed.readInt();
          seen |= _$CitmPerformanceSchema.start;
        }
        break;
      case _$CitmPerformanceSchema.keyVenueCode:
        if ((seen._value & _$CitmPerformanceSchema.venueCode._value) != 0) {
          throw const CodableException('Duplicate field "venueCode"');
        }
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          venueCode = keyed.readString();
          seen |= _$CitmPerformanceSchema.venueCode;
        }
        break;
      default:
        keyed.skipValue();
        break;
    }
  }

  // Inlined fast-path check
  seen.validate();

  return CitmPerformance(
    eventId: eventId!,
    id: id!,
    logo: logo,
    name: name,
    prices: prices,
    seatCategories: seatCategories,
    start: start!,
    venueCode: venueCode!,
  );
}

// =============================================================================
// 3. Universal Serializer for CitmPerformance
// =============================================================================
void _$CitmPerformanceToEncoder(CitmPerformance instance, Encoder encoder) {
  final keyed = encoder.keyed();
  keyed.encodeInt(_$CitmPerformanceSchema.nameEventId, instance.eventId);
  keyed.encodeInt(_$CitmPerformanceSchema.nameId, instance.id);
  if (instance.logo != null) {
    keyed.encodeString(_$CitmPerformanceSchema.nameLogo, instance.logo!);
  }
  if (instance.name != null) {
    keyed.encodeString(_$CitmPerformanceSchema.nameName, instance.name!);
  }
  keyed.encodeList(
    _$CitmPerformanceSchema.namePrices,
    instance.prices,
    _$CitmPriceToEncoder,
  );
  keyed.encodeList(
    _$CitmPerformanceSchema.nameSeatCategories,
    instance.seatCategories,
    _$CitmSeatCategoryToEncoder,
  );
  keyed.encodeInt(_$CitmPerformanceSchema.nameStart, instance.start);
  keyed.encodeString(_$CitmPerformanceSchema.nameVenueCode, instance.venueCode);
}

// =============================================================================
// 1. Unified Schema Descriptor for CitmPrice
// =============================================================================
extension type const _$CitmPriceSchema(int _value) {
  // String Name Constants
  static const String nameAmount = 'amount';
  static const String nameAudienceSubCategoryId = 'audienceSubCategoryId';
  static const String nameSeatCategoryId = 'seatCategoryId';

  // Key Indices for selectKeyIndex()
  static const int keyAmount = 0;
  static const int keyAudienceSubCategoryId = 1;
  static const int keySeatCategoryId = 2;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
    _$CitmPriceSchema.nameAmount,
    _$CitmPriceSchema.nameAudienceSubCategoryId,
    _$CitmPriceSchema.nameSeatCategoryId,
  ]);
  static final KeyOptions keyOptions = options;

  // Bitmask Flags strictly for Required Fields
  static const _$CitmPriceSchema none = _$CitmPriceSchema(0);
  static const int _amountBit = 1 << 0;
  static const _$CitmPriceSchema amount = _$CitmPriceSchema(_amountBit);
  static const int _audienceSubCategoryIdBit = 1 << 1;
  static const _$CitmPriceSchema audienceSubCategoryId = _$CitmPriceSchema(
    _audienceSubCategoryIdBit,
  );
  static const int _seatCategoryIdBit = 1 << 2;
  static const _$CitmPriceSchema seatCategoryId = _$CitmPriceSchema(
    _seatCategoryIdBit,
  );

  // Combined Golden Bitmask for fast single-instruction check
  static const _$CitmPriceSchema golden = _$CitmPriceSchema(
    _amountBit | _audienceSubCategoryIdBit | _seatCategoryIdBit,
  );

  @pragma('vm:prefer-inline')
  _$CitmPriceSchema operator |(_$CitmPriceSchema other) =>
      _$CitmPriceSchema(_value | other._value);

  /// Validates required fields in 1 CPU test instruction on the fast path.
  @pragma('vm:prefer-inline')
  void validate() {
    if ((_value & golden._value) != golden._value) {
      _throwMissingFields();
    }
  }

  /// Out-of-line cold diagnostic reporting
  void _throwMissingFields() {
    final missing = <String>[];
    if ((_value & _amountBit) == 0) {
      missing.add(nameAmount);
    }
    if ((_value & _audienceSubCategoryIdBit) == 0) {
      missing.add(nameAudienceSubCategoryId);
    }
    if ((_value & _seatCategoryIdBit) == 0) {
      missing.add(nameSeatCategoryId);
    }
    throw CodableException(
      'Missing required fields for CitmPrice: ${missing.join(", ")}',
    );
  }
}

// =============================================================================
// 2. Universal Keyed Deserializer for CitmPrice
// =============================================================================
CitmPrice _$CitmPriceFromDecoder(Decoder decoder) {
  final keyed = decoder.keyed(options: _$CitmPriceSchema.keyOptions);

  int? amount;
  int? audienceSubCategoryId;
  int? seatCategoryId;
  var seen = _$CitmPriceSchema.none;

  while (keyed.hasNextKey()) {
    switch (keyed.selectKeyIndex(_$CitmPriceSchema.keyOptions)) {
      case _$CitmPriceSchema.keyAmount:
        if ((seen._value & _$CitmPriceSchema.amount._value) != 0) {
          throw const CodableException('Duplicate field "amount"');
        }
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          amount = keyed.readInt();
          seen |= _$CitmPriceSchema.amount;
        }
        break;
      case _$CitmPriceSchema.keyAudienceSubCategoryId:
        if ((seen._value & _$CitmPriceSchema.audienceSubCategoryId._value) !=
            0) {
          throw const CodableException(
            'Duplicate field "audienceSubCategoryId"',
          );
        }
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          audienceSubCategoryId = keyed.readInt();
          seen |= _$CitmPriceSchema.audienceSubCategoryId;
        }
        break;
      case _$CitmPriceSchema.keySeatCategoryId:
        if ((seen._value & _$CitmPriceSchema.seatCategoryId._value) != 0) {
          throw const CodableException('Duplicate field "seatCategoryId"');
        }
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          seatCategoryId = keyed.readInt();
          seen |= _$CitmPriceSchema.seatCategoryId;
        }
        break;
      default:
        keyed.skipValue();
        break;
    }
  }

  // Inlined fast-path check
  seen.validate();

  return CitmPrice(
    amount: amount!,
    audienceSubCategoryId: audienceSubCategoryId!,
    seatCategoryId: seatCategoryId!,
  );
}

// =============================================================================
// 3. Universal Serializer for CitmPrice
// =============================================================================
void _$CitmPriceToEncoder(CitmPrice instance, Encoder encoder) {
  final keyed = encoder.keyed();
  keyed.encodeInt(_$CitmPriceSchema.nameAmount, instance.amount);
  keyed.encodeInt(
    _$CitmPriceSchema.nameAudienceSubCategoryId,
    instance.audienceSubCategoryId,
  );
  keyed.encodeInt(
    _$CitmPriceSchema.nameSeatCategoryId,
    instance.seatCategoryId,
  );
}

// =============================================================================
// 1. Unified Schema Descriptor for CitmSeatCategory
// =============================================================================
extension type const _$CitmSeatCategorySchema(int _value) {
  // String Name Constants
  static const String nameAreas = 'areas';
  static const String nameSeatCategoryId = 'seatCategoryId';

  // Key Indices for selectKeyIndex()
  static const int keyAreas = 0;
  static const int keySeatCategoryId = 1;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
    _$CitmSeatCategorySchema.nameAreas,
    _$CitmSeatCategorySchema.nameSeatCategoryId,
  ]);
  static final KeyOptions keyOptions = options;

  // Bitmask Flags strictly for Required Fields
  static const _$CitmSeatCategorySchema none = _$CitmSeatCategorySchema(0);
  static const int _seatCategoryIdBit = 1 << 0;
  static const _$CitmSeatCategorySchema seatCategoryId =
      _$CitmSeatCategorySchema(_seatCategoryIdBit);

  // Combined Golden Bitmask for fast single-instruction check
  static const _$CitmSeatCategorySchema golden = _$CitmSeatCategorySchema(
    _seatCategoryIdBit,
  );

  @pragma('vm:prefer-inline')
  _$CitmSeatCategorySchema operator |(_$CitmSeatCategorySchema other) =>
      _$CitmSeatCategorySchema(_value | other._value);

  /// Validates required fields in 1 CPU test instruction on the fast path.
  @pragma('vm:prefer-inline')
  void validate() {
    if ((_value & golden._value) != golden._value) {
      _throwMissingFields();
    }
  }

  /// Out-of-line cold diagnostic reporting
  void _throwMissingFields() {
    final missing = <String>[];
    if ((_value & _seatCategoryIdBit) == 0) {
      missing.add(nameSeatCategoryId);
    }
    throw CodableException(
      'Missing required fields for CitmSeatCategory: ${missing.join(", ")}',
    );
  }
}

// =============================================================================
// 2. Universal Keyed Deserializer for CitmSeatCategory
// =============================================================================
CitmSeatCategory _$CitmSeatCategoryFromDecoder(Decoder decoder) {
  final keyed = decoder.keyed(options: _$CitmSeatCategorySchema.keyOptions);

  var areas = const <CitmArea>[];
  int? seatCategoryId;
  var seen = _$CitmSeatCategorySchema.none;

  while (keyed.hasNextKey()) {
    switch (keyed.selectKeyIndex(_$CitmSeatCategorySchema.keyOptions)) {
      case _$CitmSeatCategorySchema.keyAreas:
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          areas = keyed.decodeList(_$CitmAreaFromDecoder);
        }
        break;
      case _$CitmSeatCategorySchema.keySeatCategoryId:
        if ((seen._value & _$CitmSeatCategorySchema.seatCategoryId._value) !=
            0) {
          throw const CodableException('Duplicate field "seatCategoryId"');
        }
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          seatCategoryId = keyed.readInt();
          seen |= _$CitmSeatCategorySchema.seatCategoryId;
        }
        break;
      default:
        keyed.skipValue();
        break;
    }
  }

  // Inlined fast-path check
  seen.validate();

  return CitmSeatCategory(areas: areas, seatCategoryId: seatCategoryId!);
}

// =============================================================================
// 3. Universal Serializer for CitmSeatCategory
// =============================================================================
void _$CitmSeatCategoryToEncoder(CitmSeatCategory instance, Encoder encoder) {
  final keyed = encoder.keyed();
  keyed.encodeList(
    _$CitmSeatCategorySchema.nameAreas,
    instance.areas,
    _$CitmAreaToEncoder,
  );
  keyed.encodeInt(
    _$CitmSeatCategorySchema.nameSeatCategoryId,
    instance.seatCategoryId,
  );
}

// =============================================================================
// 1. Unified Schema Descriptor for CitmArea
// =============================================================================
extension type const _$CitmAreaSchema(int _value) {
  // String Name Constants
  static const String nameAreaId = 'areaId';
  static const String nameBlockIds = 'blockIds';

  // Key Indices for selectKeyIndex()
  static const int keyAreaId = 0;
  static const int keyBlockIds = 1;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
    _$CitmAreaSchema.nameAreaId,
    _$CitmAreaSchema.nameBlockIds,
  ]);
  static final KeyOptions keyOptions = options;

  // Bitmask Flags strictly for Required Fields
  static const _$CitmAreaSchema none = _$CitmAreaSchema(0);
  static const int _areaIdBit = 1 << 0;
  static const _$CitmAreaSchema areaId = _$CitmAreaSchema(_areaIdBit);

  // Combined Golden Bitmask for fast single-instruction check
  static const _$CitmAreaSchema golden = _$CitmAreaSchema(_areaIdBit);

  @pragma('vm:prefer-inline')
  _$CitmAreaSchema operator |(_$CitmAreaSchema other) =>
      _$CitmAreaSchema(_value | other._value);

  /// Validates required fields in 1 CPU test instruction on the fast path.
  @pragma('vm:prefer-inline')
  void validate() {
    if ((_value & golden._value) != golden._value) {
      _throwMissingFields();
    }
  }

  /// Out-of-line cold diagnostic reporting
  void _throwMissingFields() {
    final missing = <String>[];
    if ((_value & _areaIdBit) == 0) {
      missing.add(nameAreaId);
    }
    throw CodableException(
      'Missing required fields for CitmArea: ${missing.join(", ")}',
    );
  }
}

// =============================================================================
// 2. Universal Keyed Deserializer for CitmArea
// =============================================================================
CitmArea _$CitmAreaFromDecoder(Decoder decoder) {
  final keyed = decoder.keyed(options: _$CitmAreaSchema.keyOptions);

  int? areaId;
  var blockIds = const <int>[];
  var seen = _$CitmAreaSchema.none;

  while (keyed.hasNextKey()) {
    switch (keyed.selectKeyIndex(_$CitmAreaSchema.keyOptions)) {
      case _$CitmAreaSchema.keyAreaId:
        if ((seen._value & _$CitmAreaSchema.areaId._value) != 0) {
          throw const CodableException('Duplicate field "areaId"');
        }
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          areaId = keyed.readInt();
          seen |= _$CitmAreaSchema.areaId;
        }
        break;
      case _$CitmAreaSchema.keyBlockIds:
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          blockIds = keyed.decodeIntList();
        }
        break;
      default:
        keyed.skipValue();
        break;
    }
  }

  // Inlined fast-path check
  seen.validate();

  return CitmArea(areaId: areaId!, blockIds: blockIds);
}

// =============================================================================
// 3. Universal Serializer for CitmArea
// =============================================================================
void _$CitmAreaToEncoder(CitmArea instance, Encoder encoder) {
  final keyed = encoder.keyed();
  keyed.encodeInt(_$CitmAreaSchema.nameAreaId, instance.areaId);
  keyed.encodeIntList(_$CitmAreaSchema.nameBlockIds, instance.blockIds);
}
