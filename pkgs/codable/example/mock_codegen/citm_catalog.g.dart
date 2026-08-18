// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: lines_longer_than_80_chars

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

  // Pre-Encoded UTF-8 Wire Bytes
  static final Uint8List nameAreaNamesBytes = Uint8List.fromList(const [
    97,
    114,
    101,
    97,
    78,
    97,
    109,
    101,
    115,
  ]);
  static final Uint8List nameAudienceSubCategoryNamesBytes =
      Uint8List.fromList(const [
        97,
        117,
        100,
        105,
        101,
        110,
        99,
        101,
        83,
        117,
        98,
        67,
        97,
        116,
        101,
        103,
        111,
        114,
        121,
        78,
        97,
        109,
        101,
        115,
      ]);
  static final Uint8List nameBlockNamesBytes = Uint8List.fromList(const [
    98,
    108,
    111,
    99,
    107,
    78,
    97,
    109,
    101,
    115,
  ]);
  static final Uint8List nameEventsBytes = Uint8List.fromList(const [
    101,
    118,
    101,
    110,
    116,
    115,
  ]);
  static final Uint8List namePerformancesBytes = Uint8List.fromList(const [
    112,
    101,
    114,
    102,
    111,
    114,
    109,
    97,
    110,
    99,
    101,
    115,
  ]);
  static final Uint8List nameSeatCategoryNamesBytes = Uint8List.fromList(const [
    115,
    101,
    97,
    116,
    67,
    97,
    116,
    101,
    103,
    111,
    114,
    121,
    78,
    97,
    109,
    101,
    115,
  ]);
  static final Uint8List nameSubTopicNamesBytes = Uint8List.fromList(const [
    115,
    117,
    98,
    84,
    111,
    112,
    105,
    99,
    78,
    97,
    109,
    101,
    115,
  ]);
  static final Uint8List nameSubjectNamesBytes = Uint8List.fromList(const [
    115,
    117,
    98,
    106,
    101,
    99,
    116,
    78,
    97,
    109,
    101,
    115,
  ]);
  static final Uint8List nameTopicNamesBytes = Uint8List.fromList(const [
    116,
    111,
    112,
    105,
    99,
    78,
    97,
    109,
    101,
    115,
  ]);
  static final Uint8List nameTopicSyncedBytes = Uint8List.fromList(const [
    116,
    111,
    112,
    105,
    99,
    83,
    121,
    110,
    99,
    101,
    100,
  ]);
  static final Uint8List nameVenueNamesBytes = Uint8List.fromList(const [
    118,
    101,
    110,
    117,
    101,
    78,
    97,
    109,
    101,
    115,
  ]);

  // Key Indices for selectName()
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

  // Pre-Compiled JsonKeyOptions
  static final JsonKeyOptions options = JsonKeyOptions.of(const [
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
// 2. Single-Pass Streaming Deserializer for CitmCatalog
// =============================================================================
CitmCatalog _$CitmCatalogFromReader(JsonTokenReader reader) {
  reader.beginObject();

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

  while (reader.hasNext()) {
    switch (reader.selectName(_$CitmCatalogSchema.options)) {
      case _$CitmCatalogSchema.keyAreaNames:
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          reader.beginObject();
          final map = <String, String>{};
          while (reader.hasNext()) {
            final k = reader.nextName();
            map[k] = reader.readString();
          }
          reader.endObject();
          areaNames = map;
        }
        break;
      case _$CitmCatalogSchema.keyAudienceSubCategoryNames:
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          reader.beginObject();
          final map = <String, String>{};
          while (reader.hasNext()) {
            final k = reader.nextName();
            map[k] = reader.readString();
          }
          reader.endObject();
          audienceSubCategoryNames = map;
        }
        break;
      case _$CitmCatalogSchema.keyBlockNames:
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          reader.beginObject();
          final map = <String, String>{};
          while (reader.hasNext()) {
            final k = reader.nextName();
            map[k] = reader.readString();
          }
          reader.endObject();
          blockNames = map;
        }
        break;
      case _$CitmCatalogSchema.keyEvents:
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          reader.beginObject();
          final map = <String, CitmEvent>{};
          while (reader.hasNext()) {
            final k = reader.nextName();
            map[k] = _$CitmEventFromReader(reader);
          }
          reader.endObject();
          events = map;
        }
        break;
      case _$CitmCatalogSchema.keyPerformances:
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          reader.beginArray();
          final list = <CitmPerformance>[];
          while (reader.hasNext()) {
            list.add(_$CitmPerformanceFromReader(reader));
          }
          reader.endArray();
          performances = list;
        }
        break;
      case _$CitmCatalogSchema.keySeatCategoryNames:
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          reader.beginObject();
          final map = <String, String>{};
          while (reader.hasNext()) {
            final k = reader.nextName();
            map[k] = reader.readString();
          }
          reader.endObject();
          seatCategoryNames = map;
        }
        break;
      case _$CitmCatalogSchema.keySubTopicNames:
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          reader.beginObject();
          final map = <String, String>{};
          while (reader.hasNext()) {
            final k = reader.nextName();
            map[k] = reader.readString();
          }
          reader.endObject();
          subTopicNames = map;
        }
        break;
      case _$CitmCatalogSchema.keySubjectNames:
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          reader.beginObject();
          final map = <String, String>{};
          while (reader.hasNext()) {
            final k = reader.nextName();
            map[k] = reader.readString();
          }
          reader.endObject();
          subjectNames = map;
        }
        break;
      case _$CitmCatalogSchema.keyTopicNames:
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          reader.beginObject();
          final map = <String, String>{};
          while (reader.hasNext()) {
            final k = reader.nextName();
            map[k] = reader.readString();
          }
          reader.endObject();
          topicNames = map;
        }
        break;
      case _$CitmCatalogSchema.keyTopicSynced:
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          reader.beginObject();
          final map = <String, bool>{};
          while (reader.hasNext()) {
            final k = reader.nextName();
            map[k] = reader.readBool();
          }
          reader.endObject();
          topicSynced = map;
        }
        break;
      case _$CitmCatalogSchema.keyVenueNames:
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          reader.beginObject();
          final map = <String, String>{};
          while (reader.hasNext()) {
            final k = reader.nextName();
            map[k] = reader.readString();
          }
          reader.endObject();
          venueNames = map;
        }
        break;
      default:
        reader.skipValue();
        break;
    }
  }
  reader.endObject();

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
// 3. Single-Pass Streaming Serializer for CitmCatalog
// =============================================================================
void _$CitmCatalogToWriter(CitmCatalog instance, JsonTokenWriter writer) {
  writer.beginObject();
  writer.writeNameBytes(_$CitmCatalogSchema.nameAreaNamesBytes);
  writer.beginObject();
  for (final entry in instance.areaNames.entries) {
    final value = entry.value;
    writer.writeName(entry.key);
    writer.writeString(value);
  }
  writer.endObject();
  writer.writeNameBytes(_$CitmCatalogSchema.nameAudienceSubCategoryNamesBytes);
  writer.beginObject();
  for (final entry in instance.audienceSubCategoryNames.entries) {
    final value = entry.value;
    writer.writeName(entry.key);
    writer.writeString(value);
  }
  writer.endObject();
  writer.writeNameBytes(_$CitmCatalogSchema.nameBlockNamesBytes);
  writer.beginObject();
  for (final entry in instance.blockNames.entries) {
    final value = entry.value;
    writer.writeName(entry.key);
    writer.writeString(value);
  }
  writer.endObject();
  writer.writeNameBytes(_$CitmCatalogSchema.nameEventsBytes);
  writer.beginObject();
  for (final entry in instance.events.entries) {
    final value = entry.value;
    writer.writeName(entry.key);
    _$CitmEventToWriter(value, writer);
  }
  writer.endObject();
  writer.writeNameBytes(_$CitmCatalogSchema.namePerformancesBytes);
  writer.beginArray();
  for (final item in instance.performances) {
    _$CitmPerformanceToWriter(item, writer);
  }
  writer.endArray();
  writer.writeNameBytes(_$CitmCatalogSchema.nameSeatCategoryNamesBytes);
  writer.beginObject();
  for (final entry in instance.seatCategoryNames.entries) {
    final value = entry.value;
    writer.writeName(entry.key);
    writer.writeString(value);
  }
  writer.endObject();
  writer.writeNameBytes(_$CitmCatalogSchema.nameSubTopicNamesBytes);
  writer.beginObject();
  for (final entry in instance.subTopicNames.entries) {
    final value = entry.value;
    writer.writeName(entry.key);
    writer.writeString(value);
  }
  writer.endObject();
  writer.writeNameBytes(_$CitmCatalogSchema.nameSubjectNamesBytes);
  writer.beginObject();
  for (final entry in instance.subjectNames.entries) {
    final value = entry.value;
    writer.writeName(entry.key);
    writer.writeString(value);
  }
  writer.endObject();
  writer.writeNameBytes(_$CitmCatalogSchema.nameTopicNamesBytes);
  writer.beginObject();
  for (final entry in instance.topicNames.entries) {
    final value = entry.value;
    writer.writeName(entry.key);
    writer.writeString(value);
  }
  writer.endObject();
  writer.writeNameBytes(_$CitmCatalogSchema.nameTopicSyncedBytes);
  writer.beginObject();
  for (final entry in instance.topicSynced.entries) {
    final value = entry.value;
    writer.writeName(entry.key);
    writer.writeBool(value);
  }
  writer.endObject();
  writer.writeNameBytes(_$CitmCatalogSchema.nameVenueNamesBytes);
  writer.beginObject();
  for (final entry in instance.venueNames.entries) {
    final value = entry.value;
    writer.writeName(entry.key);
    writer.writeString(value);
  }
  writer.endObject();
  writer.endObject();
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

  // Pre-Encoded UTF-8 Wire Bytes
  static final Uint8List nameDescriptionBytes = Uint8List.fromList(const [
    100,
    101,
    115,
    99,
    114,
    105,
    112,
    116,
    105,
    111,
    110,
  ]);
  static final Uint8List nameIdBytes = Uint8List.fromList(const [105, 100]);
  static final Uint8List nameLogoBytes = Uint8List.fromList(const [
    108,
    111,
    103,
    111,
  ]);
  static final Uint8List nameNameBytes = Uint8List.fromList(const [
    110,
    97,
    109,
    101,
  ]);
  static final Uint8List nameSubTopicIdsBytes = Uint8List.fromList(const [
    115,
    117,
    98,
    84,
    111,
    112,
    105,
    99,
    73,
    100,
    115,
  ]);
  static final Uint8List nameSubjectCodeBytes = Uint8List.fromList(const [
    115,
    117,
    98,
    106,
    101,
    99,
    116,
    67,
    111,
    100,
    101,
  ]);
  static final Uint8List nameSubtitleBytes = Uint8List.fromList(const [
    115,
    117,
    98,
    116,
    105,
    116,
    108,
    101,
  ]);
  static final Uint8List nameTopicIdsBytes = Uint8List.fromList(const [
    116,
    111,
    112,
    105,
    99,
    73,
    100,
    115,
  ]);

  // Key Indices for selectName()
  static const int keyDescription = 0;
  static const int keyId = 1;
  static const int keyLogo = 2;
  static const int keyName = 3;
  static const int keySubTopicIds = 4;
  static const int keySubjectCode = 5;
  static const int keySubtitle = 6;
  static const int keyTopicIds = 7;

  // Pre-Compiled JsonKeyOptions
  static final JsonKeyOptions options = JsonKeyOptions.of(const [
    _$CitmEventSchema.nameDescription,
    _$CitmEventSchema.nameId,
    _$CitmEventSchema.nameLogo,
    _$CitmEventSchema.nameName,
    _$CitmEventSchema.nameSubTopicIds,
    _$CitmEventSchema.nameSubjectCode,
    _$CitmEventSchema.nameSubtitle,
    _$CitmEventSchema.nameTopicIds,
  ]);

  // Bitmask Flags strictly for Required Fields
  static const _$CitmEventSchema none = _$CitmEventSchema(0);
  static const int _idBit = 1 << 0;
  static const _$CitmEventSchema id = _$CitmEventSchema(_idBit);
  static const int _nameBit = 1 << 1;
  static const _$CitmEventSchema name = _$CitmEventSchema(_nameBit);

  // Composite Golden Mask for Required Fields
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
// 2. Single-Pass Streaming Deserializer for CitmEvent
// =============================================================================
CitmEvent _$CitmEventFromReader(JsonTokenReader reader) {
  reader.beginObject();

  String? description;
  int? id;
  String? logo;
  String? name;
  var subTopicIds = const <int>[];
  int? subjectCode;
  String? subtitle;
  var topicIds = const <int>[];
  var seen = _$CitmEventSchema.none;

  while (reader.hasNext()) {
    switch (reader.selectName(_$CitmEventSchema.options)) {
      case _$CitmEventSchema.keyDescription:
        if (reader.isNextNull()) {
          reader.readNull();
          description = null;
        } else {
          description = reader.readString();
        }
        break;
      case _$CitmEventSchema.keyId:
        if ((seen._value & _$CitmEventSchema.id._value) != 0) {
          throw const CodableException('Duplicate field "id"');
        }
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          id = reader.readInt();
          seen |= _$CitmEventSchema.id;
        }
        break;
      case _$CitmEventSchema.keyLogo:
        if (reader.isNextNull()) {
          reader.readNull();
          logo = null;
        } else {
          logo = reader.readString();
        }
        break;
      case _$CitmEventSchema.keyName:
        if ((seen._value & _$CitmEventSchema.name._value) != 0) {
          throw const CodableException('Duplicate field "name"');
        }
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          name = reader.readString();
          seen |= _$CitmEventSchema.name;
        }
        break;
      case _$CitmEventSchema.keySubTopicIds:
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          reader.beginArray();
          final list = <int>[];
          while (reader.hasNext()) {
            list.add(reader.readInt());
          }
          reader.endArray();
          subTopicIds = list;
        }
        break;
      case _$CitmEventSchema.keySubjectCode:
        if (reader.isNextNull()) {
          reader.readNull();
          subjectCode = null;
        } else {
          subjectCode = reader.readInt();
        }
        break;
      case _$CitmEventSchema.keySubtitle:
        if (reader.isNextNull()) {
          reader.readNull();
          subtitle = null;
        } else {
          subtitle = reader.readString();
        }
        break;
      case _$CitmEventSchema.keyTopicIds:
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          reader.beginArray();
          final list = <int>[];
          while (reader.hasNext()) {
            list.add(reader.readInt());
          }
          reader.endArray();
          topicIds = list;
        }
        break;
      default:
        reader.skipValue();
        break;
    }
  }
  reader.endObject();

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
// 3. Single-Pass Streaming Serializer for CitmEvent
// =============================================================================
void _$CitmEventToWriter(CitmEvent instance, JsonTokenWriter writer) {
  writer.beginObject();
  if (instance.description != null) {
    writer.writeNameBytes(_$CitmEventSchema.nameDescriptionBytes);
    writer.writeString(instance.description!);
  }
  writer.writeNameBytes(_$CitmEventSchema.nameIdBytes);
  writer.writeInt(instance.id);
  if (instance.logo != null) {
    writer.writeNameBytes(_$CitmEventSchema.nameLogoBytes);
    writer.writeString(instance.logo!);
  }
  writer.writeNameBytes(_$CitmEventSchema.nameNameBytes);
  writer.writeString(instance.name);
  writer.writeNameBytes(_$CitmEventSchema.nameSubTopicIdsBytes);
  writer.beginArray();
  for (final item in instance.subTopicIds) {
    writer.writeInt(item);
  }
  writer.endArray();
  if (instance.subjectCode != null) {
    writer.writeNameBytes(_$CitmEventSchema.nameSubjectCodeBytes);
    writer.writeInt(instance.subjectCode!);
  }
  if (instance.subtitle != null) {
    writer.writeNameBytes(_$CitmEventSchema.nameSubtitleBytes);
    writer.writeString(instance.subtitle!);
  }
  writer.writeNameBytes(_$CitmEventSchema.nameTopicIdsBytes);
  writer.beginArray();
  for (final item in instance.topicIds) {
    writer.writeInt(item);
  }
  writer.endArray();
  writer.endObject();
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

  // Pre-Encoded UTF-8 Wire Bytes
  static final Uint8List nameEventIdBytes = Uint8List.fromList(const [
    101,
    118,
    101,
    110,
    116,
    73,
    100,
  ]);
  static final Uint8List nameIdBytes = Uint8List.fromList(const [105, 100]);
  static final Uint8List nameLogoBytes = Uint8List.fromList(const [
    108,
    111,
    103,
    111,
  ]);
  static final Uint8List nameNameBytes = Uint8List.fromList(const [
    110,
    97,
    109,
    101,
  ]);
  static final Uint8List namePricesBytes = Uint8List.fromList(const [
    112,
    114,
    105,
    99,
    101,
    115,
  ]);
  static final Uint8List nameSeatCategoriesBytes = Uint8List.fromList(const [
    115,
    101,
    97,
    116,
    67,
    97,
    116,
    101,
    103,
    111,
    114,
    105,
    101,
    115,
  ]);
  static final Uint8List nameStartBytes = Uint8List.fromList(const [
    115,
    116,
    97,
    114,
    116,
  ]);
  static final Uint8List nameVenueCodeBytes = Uint8List.fromList(const [
    118,
    101,
    110,
    117,
    101,
    67,
    111,
    100,
    101,
  ]);

  // Key Indices for selectName()
  static const int keyEventId = 0;
  static const int keyId = 1;
  static const int keyLogo = 2;
  static const int keyName = 3;
  static const int keyPrices = 4;
  static const int keySeatCategories = 5;
  static const int keyStart = 6;
  static const int keyVenueCode = 7;

  // Pre-Compiled JsonKeyOptions
  static final JsonKeyOptions options = JsonKeyOptions.of(const [
    _$CitmPerformanceSchema.nameEventId,
    _$CitmPerformanceSchema.nameId,
    _$CitmPerformanceSchema.nameLogo,
    _$CitmPerformanceSchema.nameName,
    _$CitmPerformanceSchema.namePrices,
    _$CitmPerformanceSchema.nameSeatCategories,
    _$CitmPerformanceSchema.nameStart,
    _$CitmPerformanceSchema.nameVenueCode,
  ]);

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

  // Composite Golden Mask for Required Fields
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
// 2. Single-Pass Streaming Deserializer for CitmPerformance
// =============================================================================
CitmPerformance _$CitmPerformanceFromReader(JsonTokenReader reader) {
  reader.beginObject();

  int? eventId;
  int? id;
  String? logo;
  String? name;
  var prices = const <CitmPrice>[];
  var seatCategories = const <CitmSeatCategory>[];
  int? start;
  String? venueCode;
  var seen = _$CitmPerformanceSchema.none;

  while (reader.hasNext()) {
    switch (reader.selectName(_$CitmPerformanceSchema.options)) {
      case _$CitmPerformanceSchema.keyEventId:
        if ((seen._value & _$CitmPerformanceSchema.eventId._value) != 0) {
          throw const CodableException('Duplicate field "eventId"');
        }
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          eventId = reader.readInt();
          seen |= _$CitmPerformanceSchema.eventId;
        }
        break;
      case _$CitmPerformanceSchema.keyId:
        if ((seen._value & _$CitmPerformanceSchema.id._value) != 0) {
          throw const CodableException('Duplicate field "id"');
        }
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          id = reader.readInt();
          seen |= _$CitmPerformanceSchema.id;
        }
        break;
      case _$CitmPerformanceSchema.keyLogo:
        if (reader.isNextNull()) {
          reader.readNull();
          logo = null;
        } else {
          logo = reader.readString();
        }
        break;
      case _$CitmPerformanceSchema.keyName:
        if (reader.isNextNull()) {
          reader.readNull();
          name = null;
        } else {
          name = reader.readString();
        }
        break;
      case _$CitmPerformanceSchema.keyPrices:
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          reader.beginArray();
          final list = <CitmPrice>[];
          while (reader.hasNext()) {
            list.add(_$CitmPriceFromReader(reader));
          }
          reader.endArray();
          prices = list;
        }
        break;
      case _$CitmPerformanceSchema.keySeatCategories:
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          reader.beginArray();
          final list = <CitmSeatCategory>[];
          while (reader.hasNext()) {
            list.add(_$CitmSeatCategoryFromReader(reader));
          }
          reader.endArray();
          seatCategories = list;
        }
        break;
      case _$CitmPerformanceSchema.keyStart:
        if ((seen._value & _$CitmPerformanceSchema.start._value) != 0) {
          throw const CodableException('Duplicate field "start"');
        }
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          start = reader.readInt();
          seen |= _$CitmPerformanceSchema.start;
        }
        break;
      case _$CitmPerformanceSchema.keyVenueCode:
        if ((seen._value & _$CitmPerformanceSchema.venueCode._value) != 0) {
          throw const CodableException('Duplicate field "venueCode"');
        }
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          venueCode = reader.readString();
          seen |= _$CitmPerformanceSchema.venueCode;
        }
        break;
      default:
        reader.skipValue();
        break;
    }
  }
  reader.endObject();

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
// 3. Single-Pass Streaming Serializer for CitmPerformance
// =============================================================================
void _$CitmPerformanceToWriter(
  CitmPerformance instance,
  JsonTokenWriter writer,
) {
  writer.beginObject();
  writer.writeNameBytes(_$CitmPerformanceSchema.nameEventIdBytes);
  writer.writeInt(instance.eventId);
  writer.writeNameBytes(_$CitmPerformanceSchema.nameIdBytes);
  writer.writeInt(instance.id);
  if (instance.logo != null) {
    writer.writeNameBytes(_$CitmPerformanceSchema.nameLogoBytes);
    writer.writeString(instance.logo!);
  }
  if (instance.name != null) {
    writer.writeNameBytes(_$CitmPerformanceSchema.nameNameBytes);
    writer.writeString(instance.name!);
  }
  writer.writeNameBytes(_$CitmPerformanceSchema.namePricesBytes);
  writer.beginArray();
  for (final item in instance.prices) {
    _$CitmPriceToWriter(item, writer);
  }
  writer.endArray();
  writer.writeNameBytes(_$CitmPerformanceSchema.nameSeatCategoriesBytes);
  writer.beginArray();
  for (final item in instance.seatCategories) {
    _$CitmSeatCategoryToWriter(item, writer);
  }
  writer.endArray();
  writer.writeNameBytes(_$CitmPerformanceSchema.nameStartBytes);
  writer.writeInt(instance.start);
  writer.writeNameBytes(_$CitmPerformanceSchema.nameVenueCodeBytes);
  writer.writeString(instance.venueCode);
  writer.endObject();
}

// =============================================================================
// 1. Unified Schema Descriptor for CitmPrice
// =============================================================================
extension type const _$CitmPriceSchema(int _value) {
  // String Name Constants
  static const String nameAmount = 'amount';
  static const String nameAudienceSubCategoryId = 'audienceSubCategoryId';
  static const String nameSeatCategoryId = 'seatCategoryId';

  // Pre-Encoded UTF-8 Wire Bytes
  static final Uint8List nameAmountBytes = Uint8List.fromList(const [
    97,
    109,
    111,
    117,
    110,
    116,
  ]);
  static final Uint8List nameAudienceSubCategoryIdBytes =
      Uint8List.fromList(const [
        97,
        117,
        100,
        105,
        101,
        110,
        99,
        101,
        83,
        117,
        98,
        67,
        97,
        116,
        101,
        103,
        111,
        114,
        121,
        73,
        100,
      ]);
  static final Uint8List nameSeatCategoryIdBytes = Uint8List.fromList(const [
    115,
    101,
    97,
    116,
    67,
    97,
    116,
    101,
    103,
    111,
    114,
    121,
    73,
    100,
  ]);

  // Key Indices for selectName()
  static const int keyAmount = 0;
  static const int keyAudienceSubCategoryId = 1;
  static const int keySeatCategoryId = 2;

  // Pre-Compiled JsonKeyOptions
  static final JsonKeyOptions options = JsonKeyOptions.of(const [
    _$CitmPriceSchema.nameAmount,
    _$CitmPriceSchema.nameAudienceSubCategoryId,
    _$CitmPriceSchema.nameSeatCategoryId,
  ]);

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

  // Composite Golden Mask for Required Fields
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
// 2. Single-Pass Streaming Deserializer for CitmPrice
// =============================================================================
CitmPrice _$CitmPriceFromReader(JsonTokenReader reader) {
  reader.beginObject();

  int? amount;
  int? audienceSubCategoryId;
  int? seatCategoryId;
  var seen = _$CitmPriceSchema.none;

  while (reader.hasNext()) {
    switch (reader.selectName(_$CitmPriceSchema.options)) {
      case _$CitmPriceSchema.keyAmount:
        if ((seen._value & _$CitmPriceSchema.amount._value) != 0) {
          throw const CodableException('Duplicate field "amount"');
        }
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          amount = reader.readInt();
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
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          audienceSubCategoryId = reader.readInt();
          seen |= _$CitmPriceSchema.audienceSubCategoryId;
        }
        break;
      case _$CitmPriceSchema.keySeatCategoryId:
        if ((seen._value & _$CitmPriceSchema.seatCategoryId._value) != 0) {
          throw const CodableException('Duplicate field "seatCategoryId"');
        }
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          seatCategoryId = reader.readInt();
          seen |= _$CitmPriceSchema.seatCategoryId;
        }
        break;
      default:
        reader.skipValue();
        break;
    }
  }
  reader.endObject();

  // Inlined fast-path check
  seen.validate();

  return CitmPrice(
    amount: amount!,
    audienceSubCategoryId: audienceSubCategoryId!,
    seatCategoryId: seatCategoryId!,
  );
}

// =============================================================================
// 3. Single-Pass Streaming Serializer for CitmPrice
// =============================================================================
void _$CitmPriceToWriter(CitmPrice instance, JsonTokenWriter writer) {
  writer.beginObject();
  writer.writeNameBytes(_$CitmPriceSchema.nameAmountBytes);
  writer.writeInt(instance.amount);
  writer.writeNameBytes(_$CitmPriceSchema.nameAudienceSubCategoryIdBytes);
  writer.writeInt(instance.audienceSubCategoryId);
  writer.writeNameBytes(_$CitmPriceSchema.nameSeatCategoryIdBytes);
  writer.writeInt(instance.seatCategoryId);
  writer.endObject();
}

// =============================================================================
// 1. Unified Schema Descriptor for CitmSeatCategory
// =============================================================================
extension type const _$CitmSeatCategorySchema(int _value) {
  // String Name Constants
  static const String nameAreas = 'areas';
  static const String nameSeatCategoryId = 'seatCategoryId';

  // Pre-Encoded UTF-8 Wire Bytes
  static final Uint8List nameAreasBytes = Uint8List.fromList(const [
    97,
    114,
    101,
    97,
    115,
  ]);
  static final Uint8List nameSeatCategoryIdBytes = Uint8List.fromList(const [
    115,
    101,
    97,
    116,
    67,
    97,
    116,
    101,
    103,
    111,
    114,
    121,
    73,
    100,
  ]);

  // Key Indices for selectName()
  static const int keyAreas = 0;
  static const int keySeatCategoryId = 1;

  // Pre-Compiled JsonKeyOptions
  static final JsonKeyOptions options = JsonKeyOptions.of(const [
    _$CitmSeatCategorySchema.nameAreas,
    _$CitmSeatCategorySchema.nameSeatCategoryId,
  ]);

  // Bitmask Flags strictly for Required Fields
  static const _$CitmSeatCategorySchema none = _$CitmSeatCategorySchema(0);
  static const int _seatCategoryIdBit = 1 << 0;
  static const _$CitmSeatCategorySchema seatCategoryId =
      _$CitmSeatCategorySchema(_seatCategoryIdBit);

  // Composite Golden Mask for Required Fields
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
// 2. Single-Pass Streaming Deserializer for CitmSeatCategory
// =============================================================================
CitmSeatCategory _$CitmSeatCategoryFromReader(JsonTokenReader reader) {
  reader.beginObject();

  var areas = const <CitmArea>[];
  int? seatCategoryId;
  var seen = _$CitmSeatCategorySchema.none;

  while (reader.hasNext()) {
    switch (reader.selectName(_$CitmSeatCategorySchema.options)) {
      case _$CitmSeatCategorySchema.keyAreas:
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          reader.beginArray();
          final list = <CitmArea>[];
          while (reader.hasNext()) {
            list.add(_$CitmAreaFromReader(reader));
          }
          reader.endArray();
          areas = list;
        }
        break;
      case _$CitmSeatCategorySchema.keySeatCategoryId:
        if ((seen._value & _$CitmSeatCategorySchema.seatCategoryId._value) !=
            0) {
          throw const CodableException('Duplicate field "seatCategoryId"');
        }
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          seatCategoryId = reader.readInt();
          seen |= _$CitmSeatCategorySchema.seatCategoryId;
        }
        break;
      default:
        reader.skipValue();
        break;
    }
  }
  reader.endObject();

  // Inlined fast-path check
  seen.validate();

  return CitmSeatCategory(areas: areas, seatCategoryId: seatCategoryId!);
}

// =============================================================================
// 3. Single-Pass Streaming Serializer for CitmSeatCategory
// =============================================================================
void _$CitmSeatCategoryToWriter(
  CitmSeatCategory instance,
  JsonTokenWriter writer,
) {
  writer.beginObject();
  writer.writeNameBytes(_$CitmSeatCategorySchema.nameAreasBytes);
  writer.beginArray();
  for (final item in instance.areas) {
    _$CitmAreaToWriter(item, writer);
  }
  writer.endArray();
  writer.writeNameBytes(_$CitmSeatCategorySchema.nameSeatCategoryIdBytes);
  writer.writeInt(instance.seatCategoryId);
  writer.endObject();
}

// =============================================================================
// 1. Unified Schema Descriptor for CitmArea
// =============================================================================
extension type const _$CitmAreaSchema(int _value) {
  // String Name Constants
  static const String nameAreaId = 'areaId';
  static const String nameBlockIds = 'blockIds';

  // Pre-Encoded UTF-8 Wire Bytes
  static final Uint8List nameAreaIdBytes = Uint8List.fromList(const [
    97,
    114,
    101,
    97,
    73,
    100,
  ]);
  static final Uint8List nameBlockIdsBytes = Uint8List.fromList(const [
    98,
    108,
    111,
    99,
    107,
    73,
    100,
    115,
  ]);

  // Key Indices for selectName()
  static const int keyAreaId = 0;
  static const int keyBlockIds = 1;

  // Pre-Compiled JsonKeyOptions
  static final JsonKeyOptions options = JsonKeyOptions.of(const [
    _$CitmAreaSchema.nameAreaId,
    _$CitmAreaSchema.nameBlockIds,
  ]);

  // Bitmask Flags strictly for Required Fields
  static const _$CitmAreaSchema none = _$CitmAreaSchema(0);
  static const int _areaIdBit = 1 << 0;
  static const _$CitmAreaSchema areaId = _$CitmAreaSchema(_areaIdBit);

  // Composite Golden Mask for Required Fields
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
// 2. Single-Pass Streaming Deserializer for CitmArea
// =============================================================================
CitmArea _$CitmAreaFromReader(JsonTokenReader reader) {
  reader.beginObject();

  int? areaId;
  var blockIds = const <int>[];
  var seen = _$CitmAreaSchema.none;

  while (reader.hasNext()) {
    switch (reader.selectName(_$CitmAreaSchema.options)) {
      case _$CitmAreaSchema.keyAreaId:
        if ((seen._value & _$CitmAreaSchema.areaId._value) != 0) {
          throw const CodableException('Duplicate field "areaId"');
        }
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          areaId = reader.readInt();
          seen |= _$CitmAreaSchema.areaId;
        }
        break;
      case _$CitmAreaSchema.keyBlockIds:
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          reader.beginArray();
          final list = <int>[];
          while (reader.hasNext()) {
            list.add(reader.readInt());
          }
          reader.endArray();
          blockIds = list;
        }
        break;
      default:
        reader.skipValue();
        break;
    }
  }
  reader.endObject();

  // Inlined fast-path check
  seen.validate();

  return CitmArea(areaId: areaId!, blockIds: blockIds);
}

// =============================================================================
// 3. Single-Pass Streaming Serializer for CitmArea
// =============================================================================
void _$CitmAreaToWriter(CitmArea instance, JsonTokenWriter writer) {
  writer.beginObject();
  writer.writeNameBytes(_$CitmAreaSchema.nameAreaIdBytes);
  writer.writeInt(instance.areaId);
  writer.writeNameBytes(_$CitmAreaSchema.nameBlockIdsBytes);
  writer.beginArray();
  for (final item in instance.blockIds) {
    writer.writeInt(item);
  }
  writer.endArray();
  writer.endObject();
}
