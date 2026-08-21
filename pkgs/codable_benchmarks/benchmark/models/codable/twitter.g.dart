// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: lines_longer_than_80_chars

part of 'twitter.dart';

// =============================================================================
// 1. Unified Schema Descriptor for TwitterMetadata
// =============================================================================
extension type const _$TwitterMetadataSchema(int _value) {
  // String Name Constants
  static const String nameResultType = 'result_type';
  static const String nameIsoLanguageCode = 'iso_language_code';

  // Pre-Encoded UTF-8 Wire Bytes
  static final Uint8List nameResultTypeBytes = Uint8List.fromList(const [
    114,
    101,
    115,
    117,
    108,
    116,
    95,
    116,
    121,
    112,
    101,
  ]);
  static final Uint8List nameIsoLanguageCodeBytes = Uint8List.fromList(const [
    105,
    115,
    111,
    95,
    108,
    97,
    110,
    103,
    117,
    97,
    103,
    101,
    95,
    99,
    111,
    100,
    101,
  ]);

  // Key Indices for selectName()
  static const int keyResultType = 0;
  static const int keyIsoLanguageCode = 1;

  // Pre-Compiled JsonKeyOptions
  static final JsonKeyOptions options = JsonKeyOptions.of(const [
    _$TwitterMetadataSchema.nameResultType,
    _$TwitterMetadataSchema.nameIsoLanguageCode,
  ]);
  static final KeyOptions keyOptions = KeyOptions(
    options.keys,
    compiled: options,
  );

  // Bitmask Flags strictly for Required Fields
  static const _$TwitterMetadataSchema none = _$TwitterMetadataSchema(0);

  @pragma('vm:prefer-inline')
  _$TwitterMetadataSchema operator |(_$TwitterMetadataSchema other) =>
      _$TwitterMetadataSchema(_value | other._value);

  /// Validates required fields in 1 CPU test instruction on the fast path.
  @pragma('vm:prefer-inline')
  void validate() {}
}

// =============================================================================
// 2. Single-Pass Streaming Deserializer for TwitterMetadata
// =============================================================================
TwitterMetadata _$TwitterMetadataFromReader(JsonTokenReader reader) {
  reader.beginObject();

  var resultType = '';
  var isoLanguageCode = '';
  var seen = _$TwitterMetadataSchema.none;

  while (reader.hasNext()) {
    switch (reader.selectName(_$TwitterMetadataSchema.options)) {
      case _$TwitterMetadataSchema.keyResultType:
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          resultType = reader.readString();
        }
        break;
      case _$TwitterMetadataSchema.keyIsoLanguageCode:
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          isoLanguageCode = reader.readString();
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

  return TwitterMetadata(
    resultType: resultType,
    isoLanguageCode: isoLanguageCode,
  );
}

// =============================================================================
// 3. Universal Keyed Deserializer for TwitterMetadata
// =============================================================================
TwitterMetadata _$TwitterMetadataFromDecoder(Decoder decoder) {
  final keyed = decoder.keyed();

  var resultType = '';
  var isoLanguageCode = '';
  var seen = _$TwitterMetadataSchema.none;

  while (keyed.hasNextKey()) {
    switch (keyed.selectKeyIndex(_$TwitterMetadataSchema.keyOptions)) {
      case _$TwitterMetadataSchema.keyResultType:
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          resultType = keyed.readString();
        }
        break;
      case _$TwitterMetadataSchema.keyIsoLanguageCode:
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          isoLanguageCode = keyed.readString();
        }
        break;
      default:
        keyed.skipValue();
        break;
    }
  }

  // Inlined fast-path check
  seen.validate();

  return TwitterMetadata(
    resultType: resultType,
    isoLanguageCode: isoLanguageCode,
  );
}

// =============================================================================
// 3. Single-Pass Streaming Serializer for TwitterMetadata
// =============================================================================
void _$TwitterMetadataToWriter(
  TwitterMetadata instance,
  JsonTokenWriter writer,
) {
  writer.beginObject();
  writer.writeNameBytes(_$TwitterMetadataSchema.nameResultTypeBytes);
  writer.writeString(instance.resultType);
  writer.writeNameBytes(_$TwitterMetadataSchema.nameIsoLanguageCodeBytes);
  writer.writeString(instance.isoLanguageCode);
  writer.endObject();
}

// =============================================================================
// 1. Unified Schema Descriptor for TwitterUserMention
// =============================================================================
extension type const _$TwitterUserMentionSchema(int _value) {
  // String Name Constants
  static const String nameScreenName = 'screen_name';
  static const String nameName = 'name';
  static const String nameId = 'id';
  static const String nameIdStr = 'id_str';
  static const String nameIndices = 'indices';

  // Pre-Encoded UTF-8 Wire Bytes
  static final Uint8List nameScreenNameBytes = Uint8List.fromList(const [
    115,
    99,
    114,
    101,
    101,
    110,
    95,
    110,
    97,
    109,
    101,
  ]);
  static final Uint8List nameNameBytes = Uint8List.fromList(const [
    110,
    97,
    109,
    101,
  ]);
  static final Uint8List nameIdBytes = Uint8List.fromList(const [105, 100]);
  static final Uint8List nameIdStrBytes = Uint8List.fromList(const [
    105,
    100,
    95,
    115,
    116,
    114,
  ]);
  static final Uint8List nameIndicesBytes = Uint8List.fromList(const [
    105,
    110,
    100,
    105,
    99,
    101,
    115,
  ]);

  // Key Indices for selectName()
  static const int keyScreenName = 0;
  static const int keyName = 1;
  static const int keyId = 2;
  static const int keyIdStr = 3;
  static const int keyIndices = 4;

  // Pre-Compiled JsonKeyOptions
  static final JsonKeyOptions options = JsonKeyOptions.of(const [
    _$TwitterUserMentionSchema.nameScreenName,
    _$TwitterUserMentionSchema.nameName,
    _$TwitterUserMentionSchema.nameId,
    _$TwitterUserMentionSchema.nameIdStr,
    _$TwitterUserMentionSchema.nameIndices,
  ]);
  static final KeyOptions keyOptions = KeyOptions(
    options.keys,
    compiled: options,
  );

  // Bitmask Flags strictly for Required Fields
  static const _$TwitterUserMentionSchema none = _$TwitterUserMentionSchema(0);
  static const int _screenNameBit = 1 << 0;
  static const _$TwitterUserMentionSchema screenName =
      _$TwitterUserMentionSchema(_screenNameBit);
  static const int _nameBit = 1 << 1;
  static const _$TwitterUserMentionSchema name = _$TwitterUserMentionSchema(
    _nameBit,
  );
  static const int _idBit = 1 << 2;
  static const _$TwitterUserMentionSchema id = _$TwitterUserMentionSchema(
    _idBit,
  );
  static const int _idStrBit = 1 << 3;
  static const _$TwitterUserMentionSchema idStr = _$TwitterUserMentionSchema(
    _idStrBit,
  );

  // Composite Golden Mask for Required Fields
  static const _$TwitterUserMentionSchema golden = _$TwitterUserMentionSchema(
    _screenNameBit | _nameBit | _idBit | _idStrBit,
  );

  @pragma('vm:prefer-inline')
  _$TwitterUserMentionSchema operator |(_$TwitterUserMentionSchema other) =>
      _$TwitterUserMentionSchema(_value | other._value);

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
    if ((_value & _screenNameBit) == 0) {
      missing.add(nameScreenName);
    }
    if ((_value & _nameBit) == 0) {
      missing.add(nameName);
    }
    if ((_value & _idBit) == 0) {
      missing.add(nameId);
    }
    if ((_value & _idStrBit) == 0) {
      missing.add(nameIdStr);
    }
    throw CodableException(
      'Missing required fields for TwitterUserMention: ${missing.join(", ")}',
    );
  }
}

// =============================================================================
// 2. Single-Pass Streaming Deserializer for TwitterUserMention
// =============================================================================
TwitterUserMention _$TwitterUserMentionFromReader(JsonTokenReader reader) {
  reader.beginObject();

  String? screenName;
  String? name;
  int? id;
  String? idStr;
  var indices = const <int>[];
  var seen = _$TwitterUserMentionSchema.none;

  while (reader.hasNext()) {
    switch (reader.selectName(_$TwitterUserMentionSchema.options)) {
      case _$TwitterUserMentionSchema.keyScreenName:
        if ((seen._value & _$TwitterUserMentionSchema.screenName._value) != 0) {
          throw const CodableException('Duplicate field "screen_name"');
        }
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          screenName = reader.readString();
          seen |= _$TwitterUserMentionSchema.screenName;
        }
        break;
      case _$TwitterUserMentionSchema.keyName:
        if ((seen._value & _$TwitterUserMentionSchema.name._value) != 0) {
          throw const CodableException('Duplicate field "name"');
        }
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          name = reader.readString();
          seen |= _$TwitterUserMentionSchema.name;
        }
        break;
      case _$TwitterUserMentionSchema.keyId:
        if ((seen._value & _$TwitterUserMentionSchema.id._value) != 0) {
          throw const CodableException('Duplicate field "id"');
        }
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          id = reader.readInt();
          seen |= _$TwitterUserMentionSchema.id;
        }
        break;
      case _$TwitterUserMentionSchema.keyIdStr:
        if ((seen._value & _$TwitterUserMentionSchema.idStr._value) != 0) {
          throw const CodableException('Duplicate field "id_str"');
        }
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          idStr = reader.readString();
          seen |= _$TwitterUserMentionSchema.idStr;
        }
        break;
      case _$TwitterUserMentionSchema.keyIndices:
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          reader.beginArray();
          final list = <int>[];
          while (reader.hasNext()) {
            list.add(reader.readInt());
          }
          reader.endArray();
          indices = list;
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

  return TwitterUserMention(
    screenName: screenName!,
    name: name!,
    id: id!,
    idStr: idStr!,
    indices: indices,
  );
}

// =============================================================================
// 3. Universal Keyed Deserializer for TwitterUserMention
// =============================================================================
TwitterUserMention _$TwitterUserMentionFromDecoder(Decoder decoder) {
  final keyed = decoder.keyed();

  String? screenName;
  String? name;
  int? id;
  String? idStr;
  var indices = const <int>[];
  var seen = _$TwitterUserMentionSchema.none;

  while (keyed.hasNextKey()) {
    switch (keyed.selectKeyIndex(_$TwitterUserMentionSchema.keyOptions)) {
      case _$TwitterUserMentionSchema.keyScreenName:
        if ((seen._value & _$TwitterUserMentionSchema.screenName._value) != 0) {
          throw const CodableException('Duplicate field "screen_name"');
        }
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          screenName = keyed.readString();
          seen |= _$TwitterUserMentionSchema.screenName;
        }
        break;
      case _$TwitterUserMentionSchema.keyName:
        if ((seen._value & _$TwitterUserMentionSchema.name._value) != 0) {
          throw const CodableException('Duplicate field "name"');
        }
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          name = keyed.readString();
          seen |= _$TwitterUserMentionSchema.name;
        }
        break;
      case _$TwitterUserMentionSchema.keyId:
        if ((seen._value & _$TwitterUserMentionSchema.id._value) != 0) {
          throw const CodableException('Duplicate field "id"');
        }
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          id = keyed.readInt();
          seen |= _$TwitterUserMentionSchema.id;
        }
        break;
      case _$TwitterUserMentionSchema.keyIdStr:
        if ((seen._value & _$TwitterUserMentionSchema.idStr._value) != 0) {
          throw const CodableException('Duplicate field "id_str"');
        }
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          idStr = keyed.readString();
          seen |= _$TwitterUserMentionSchema.idStr;
        }
        break;
      case _$TwitterUserMentionSchema.keyIndices:
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          indices = keyed.decodeIntList();
        }
        break;
      default:
        keyed.skipValue();
        break;
    }
  }

  // Inlined fast-path check
  seen.validate();

  return TwitterUserMention(
    screenName: screenName!,
    name: name!,
    id: id!,
    idStr: idStr!,
    indices: indices,
  );
}

// =============================================================================
// 3. Single-Pass Streaming Serializer for TwitterUserMention
// =============================================================================
void _$TwitterUserMentionToWriter(
  TwitterUserMention instance,
  JsonTokenWriter writer,
) {
  writer.beginObject();
  writer.writeNameBytes(_$TwitterUserMentionSchema.nameScreenNameBytes);
  writer.writeString(instance.screenName);
  writer.writeNameBytes(_$TwitterUserMentionSchema.nameNameBytes);
  writer.writeString(instance.name);
  writer.writeNameBytes(_$TwitterUserMentionSchema.nameIdBytes);
  writer.writeInt(instance.id);
  writer.writeNameBytes(_$TwitterUserMentionSchema.nameIdStrBytes);
  writer.writeString(instance.idStr);
  writer.writeNameBytes(_$TwitterUserMentionSchema.nameIndicesBytes);
  writer.beginArray();
  for (final item in instance.indices) {
    writer.writeInt(item);
  }
  writer.endArray();
  writer.endObject();
}

// =============================================================================
// 1. Unified Schema Descriptor for TwitterUrl
// =============================================================================
extension type const _$TwitterUrlSchema(int _value) {
  // String Name Constants
  static const String nameUrl = 'url';
  static const String nameExpandedUrl = 'expanded_url';
  static const String nameDisplayUrl = 'display_url';
  static const String nameIndices = 'indices';

  // Pre-Encoded UTF-8 Wire Bytes
  static final Uint8List nameUrlBytes = Uint8List.fromList(const [
    117,
    114,
    108,
  ]);
  static final Uint8List nameExpandedUrlBytes = Uint8List.fromList(const [
    101,
    120,
    112,
    97,
    110,
    100,
    101,
    100,
    95,
    117,
    114,
    108,
  ]);
  static final Uint8List nameDisplayUrlBytes = Uint8List.fromList(const [
    100,
    105,
    115,
    112,
    108,
    97,
    121,
    95,
    117,
    114,
    108,
  ]);
  static final Uint8List nameIndicesBytes = Uint8List.fromList(const [
    105,
    110,
    100,
    105,
    99,
    101,
    115,
  ]);

  // Key Indices for selectName()
  static const int keyUrl = 0;
  static const int keyExpandedUrl = 1;
  static const int keyDisplayUrl = 2;
  static const int keyIndices = 3;

  // Pre-Compiled JsonKeyOptions
  static final JsonKeyOptions options = JsonKeyOptions.of(const [
    _$TwitterUrlSchema.nameUrl,
    _$TwitterUrlSchema.nameExpandedUrl,
    _$TwitterUrlSchema.nameDisplayUrl,
    _$TwitterUrlSchema.nameIndices,
  ]);
  static final KeyOptions keyOptions = KeyOptions(
    options.keys,
    compiled: options,
  );

  // Bitmask Flags strictly for Required Fields
  static const _$TwitterUrlSchema none = _$TwitterUrlSchema(0);
  static const int _urlBit = 1 << 0;
  static const _$TwitterUrlSchema url = _$TwitterUrlSchema(_urlBit);
  static const int _expandedUrlBit = 1 << 1;
  static const _$TwitterUrlSchema expandedUrl = _$TwitterUrlSchema(
    _expandedUrlBit,
  );
  static const int _displayUrlBit = 1 << 2;
  static const _$TwitterUrlSchema displayUrl = _$TwitterUrlSchema(
    _displayUrlBit,
  );

  // Composite Golden Mask for Required Fields
  static const _$TwitterUrlSchema golden = _$TwitterUrlSchema(
    _urlBit | _expandedUrlBit | _displayUrlBit,
  );

  @pragma('vm:prefer-inline')
  _$TwitterUrlSchema operator |(_$TwitterUrlSchema other) =>
      _$TwitterUrlSchema(_value | other._value);

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
    if ((_value & _urlBit) == 0) {
      missing.add(nameUrl);
    }
    if ((_value & _expandedUrlBit) == 0) {
      missing.add(nameExpandedUrl);
    }
    if ((_value & _displayUrlBit) == 0) {
      missing.add(nameDisplayUrl);
    }
    throw CodableException(
      'Missing required fields for TwitterUrl: ${missing.join(", ")}',
    );
  }
}

// =============================================================================
// 2. Single-Pass Streaming Deserializer for TwitterUrl
// =============================================================================
TwitterUrl _$TwitterUrlFromReader(JsonTokenReader reader) {
  reader.beginObject();

  String? url;
  String? expandedUrl;
  String? displayUrl;
  var indices = const <int>[];
  var seen = _$TwitterUrlSchema.none;

  while (reader.hasNext()) {
    switch (reader.selectName(_$TwitterUrlSchema.options)) {
      case _$TwitterUrlSchema.keyUrl:
        if ((seen._value & _$TwitterUrlSchema.url._value) != 0) {
          throw const CodableException('Duplicate field "url"');
        }
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          url = reader.readString();
          seen |= _$TwitterUrlSchema.url;
        }
        break;
      case _$TwitterUrlSchema.keyExpandedUrl:
        if ((seen._value & _$TwitterUrlSchema.expandedUrl._value) != 0) {
          throw const CodableException('Duplicate field "expanded_url"');
        }
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          expandedUrl = reader.readString();
          seen |= _$TwitterUrlSchema.expandedUrl;
        }
        break;
      case _$TwitterUrlSchema.keyDisplayUrl:
        if ((seen._value & _$TwitterUrlSchema.displayUrl._value) != 0) {
          throw const CodableException('Duplicate field "display_url"');
        }
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          displayUrl = reader.readString();
          seen |= _$TwitterUrlSchema.displayUrl;
        }
        break;
      case _$TwitterUrlSchema.keyIndices:
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          reader.beginArray();
          final list = <int>[];
          while (reader.hasNext()) {
            list.add(reader.readInt());
          }
          reader.endArray();
          indices = list;
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

  return TwitterUrl(
    url: url!,
    expandedUrl: expandedUrl!,
    displayUrl: displayUrl!,
    indices: indices,
  );
}

// =============================================================================
// 3. Universal Keyed Deserializer for TwitterUrl
// =============================================================================
TwitterUrl _$TwitterUrlFromDecoder(Decoder decoder) {
  final keyed = decoder.keyed();

  String? url;
  String? expandedUrl;
  String? displayUrl;
  var indices = const <int>[];
  var seen = _$TwitterUrlSchema.none;

  while (keyed.hasNextKey()) {
    switch (keyed.selectKeyIndex(_$TwitterUrlSchema.keyOptions)) {
      case _$TwitterUrlSchema.keyUrl:
        if ((seen._value & _$TwitterUrlSchema.url._value) != 0) {
          throw const CodableException('Duplicate field "url"');
        }
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          url = keyed.readString();
          seen |= _$TwitterUrlSchema.url;
        }
        break;
      case _$TwitterUrlSchema.keyExpandedUrl:
        if ((seen._value & _$TwitterUrlSchema.expandedUrl._value) != 0) {
          throw const CodableException('Duplicate field "expanded_url"');
        }
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          expandedUrl = keyed.readString();
          seen |= _$TwitterUrlSchema.expandedUrl;
        }
        break;
      case _$TwitterUrlSchema.keyDisplayUrl:
        if ((seen._value & _$TwitterUrlSchema.displayUrl._value) != 0) {
          throw const CodableException('Duplicate field "display_url"');
        }
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          displayUrl = keyed.readString();
          seen |= _$TwitterUrlSchema.displayUrl;
        }
        break;
      case _$TwitterUrlSchema.keyIndices:
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          indices = keyed.decodeIntList();
        }
        break;
      default:
        keyed.skipValue();
        break;
    }
  }

  // Inlined fast-path check
  seen.validate();

  return TwitterUrl(
    url: url!,
    expandedUrl: expandedUrl!,
    displayUrl: displayUrl!,
    indices: indices,
  );
}

// =============================================================================
// 3. Single-Pass Streaming Serializer for TwitterUrl
// =============================================================================
void _$TwitterUrlToWriter(TwitterUrl instance, JsonTokenWriter writer) {
  writer.beginObject();
  writer.writeNameBytes(_$TwitterUrlSchema.nameUrlBytes);
  writer.writeString(instance.url);
  writer.writeNameBytes(_$TwitterUrlSchema.nameExpandedUrlBytes);
  writer.writeString(instance.expandedUrl);
  writer.writeNameBytes(_$TwitterUrlSchema.nameDisplayUrlBytes);
  writer.writeString(instance.displayUrl);
  writer.writeNameBytes(_$TwitterUrlSchema.nameIndicesBytes);
  writer.beginArray();
  for (final item in instance.indices) {
    writer.writeInt(item);
  }
  writer.endArray();
  writer.endObject();
}

// =============================================================================
// 1. Unified Schema Descriptor for TwitterEntitiesUrls
// =============================================================================
extension type const _$TwitterEntitiesUrlsSchema(int _value) {
  // String Name Constants
  static const String nameUrls = 'urls';

  // Pre-Encoded UTF-8 Wire Bytes
  static final Uint8List nameUrlsBytes = Uint8List.fromList(const [
    117,
    114,
    108,
    115,
  ]);

  // Key Indices for selectName()
  static const int keyUrls = 0;

  // Pre-Compiled JsonKeyOptions
  static final JsonKeyOptions options = JsonKeyOptions.of(const [
    _$TwitterEntitiesUrlsSchema.nameUrls,
  ]);
  static final KeyOptions keyOptions = KeyOptions(
    options.keys,
    compiled: options,
  );

  // Bitmask Flags strictly for Required Fields
  static const _$TwitterEntitiesUrlsSchema none = _$TwitterEntitiesUrlsSchema(
    0,
  );

  @pragma('vm:prefer-inline')
  _$TwitterEntitiesUrlsSchema operator |(_$TwitterEntitiesUrlsSchema other) =>
      _$TwitterEntitiesUrlsSchema(_value | other._value);

  /// Validates required fields in 1 CPU test instruction on the fast path.
  @pragma('vm:prefer-inline')
  void validate() {}
}

// =============================================================================
// 2. Single-Pass Streaming Deserializer for TwitterEntitiesUrls
// =============================================================================
TwitterEntitiesUrls _$TwitterEntitiesUrlsFromReader(JsonTokenReader reader) {
  reader.beginObject();

  var urls = const <TwitterUrl>[];
  var seen = _$TwitterEntitiesUrlsSchema.none;

  while (reader.hasNext()) {
    switch (reader.selectName(_$TwitterEntitiesUrlsSchema.options)) {
      case _$TwitterEntitiesUrlsSchema.keyUrls:
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          reader.beginArray();
          final list = <TwitterUrl>[];
          while (reader.hasNext()) {
            list.add(_$TwitterUrlFromReader(reader));
          }
          reader.endArray();
          urls = list;
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

  return TwitterEntitiesUrls(urls: urls);
}

// =============================================================================
// 3. Universal Keyed Deserializer for TwitterEntitiesUrls
// =============================================================================
TwitterEntitiesUrls _$TwitterEntitiesUrlsFromDecoder(Decoder decoder) {
  final keyed = decoder.keyed();

  var urls = const <TwitterUrl>[];
  var seen = _$TwitterEntitiesUrlsSchema.none;

  while (keyed.hasNextKey()) {
    switch (keyed.selectKeyIndex(_$TwitterEntitiesUrlsSchema.keyOptions)) {
      case _$TwitterEntitiesUrlsSchema.keyUrls:
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          urls = keyed.decodeList(_$TwitterUrlFromDecoder);
        }
        break;
      default:
        keyed.skipValue();
        break;
    }
  }

  // Inlined fast-path check
  seen.validate();

  return TwitterEntitiesUrls(urls: urls);
}

// =============================================================================
// 3. Single-Pass Streaming Serializer for TwitterEntitiesUrls
// =============================================================================
void _$TwitterEntitiesUrlsToWriter(
  TwitterEntitiesUrls instance,
  JsonTokenWriter writer,
) {
  writer.beginObject();
  writer.writeNameBytes(_$TwitterEntitiesUrlsSchema.nameUrlsBytes);
  writer.beginArray();
  for (final item in instance.urls) {
    _$TwitterUrlToWriter(item, writer);
  }
  writer.endArray();
  writer.endObject();
}

// =============================================================================
// 1. Unified Schema Descriptor for TwitterUserEntities
// =============================================================================
extension type const _$TwitterUserEntitiesSchema(int _value) {
  // String Name Constants
  static const String nameUrl = 'url';
  static const String nameDescription = 'description';

  // Pre-Encoded UTF-8 Wire Bytes
  static final Uint8List nameUrlBytes = Uint8List.fromList(const [
    117,
    114,
    108,
  ]);
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

  // Key Indices for selectName()
  static const int keyUrl = 0;
  static const int keyDescription = 1;

  // Pre-Compiled JsonKeyOptions
  static final JsonKeyOptions options = JsonKeyOptions.of(const [
    _$TwitterUserEntitiesSchema.nameUrl,
    _$TwitterUserEntitiesSchema.nameDescription,
  ]);
  static final KeyOptions keyOptions = KeyOptions(
    options.keys,
    compiled: options,
  );

  // Bitmask Flags strictly for Required Fields
  static const _$TwitterUserEntitiesSchema none = _$TwitterUserEntitiesSchema(
    0,
  );

  @pragma('vm:prefer-inline')
  _$TwitterUserEntitiesSchema operator |(_$TwitterUserEntitiesSchema other) =>
      _$TwitterUserEntitiesSchema(_value | other._value);

  /// Validates required fields in 1 CPU test instruction on the fast path.
  @pragma('vm:prefer-inline')
  void validate() {}
}

// =============================================================================
// 2. Single-Pass Streaming Deserializer for TwitterUserEntities
// =============================================================================
TwitterUserEntities _$TwitterUserEntitiesFromReader(JsonTokenReader reader) {
  reader.beginObject();

  TwitterEntitiesUrls? url;
  TwitterEntitiesUrls? description;
  var seen = _$TwitterUserEntitiesSchema.none;

  while (reader.hasNext()) {
    switch (reader.selectName(_$TwitterUserEntitiesSchema.options)) {
      case _$TwitterUserEntitiesSchema.keyUrl:
        if (reader.isNextNull()) {
          reader.readNull();
          url = null;
        } else {
          url = _$TwitterEntitiesUrlsFromReader(reader);
        }
        break;
      case _$TwitterUserEntitiesSchema.keyDescription:
        if (reader.isNextNull()) {
          reader.readNull();
          description = null;
        } else {
          description = _$TwitterEntitiesUrlsFromReader(reader);
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

  return TwitterUserEntities(url: url, description: description);
}

// =============================================================================
// 3. Universal Keyed Deserializer for TwitterUserEntities
// =============================================================================
TwitterUserEntities _$TwitterUserEntitiesFromDecoder(Decoder decoder) {
  final keyed = decoder.keyed();

  TwitterEntitiesUrls? url;
  TwitterEntitiesUrls? description;
  var seen = _$TwitterUserEntitiesSchema.none;

  while (keyed.hasNextKey()) {
    switch (keyed.selectKeyIndex(_$TwitterUserEntitiesSchema.keyOptions)) {
      case _$TwitterUserEntitiesSchema.keyUrl:
        if (keyed.isNextNull()) {
          keyed.readNull();
          url = null;
        } else {
          url = keyed.decodeValue(_$TwitterEntitiesUrlsFromDecoder);
        }
        break;
      case _$TwitterUserEntitiesSchema.keyDescription:
        if (keyed.isNextNull()) {
          keyed.readNull();
          description = null;
        } else {
          description = keyed.decodeValue(_$TwitterEntitiesUrlsFromDecoder);
        }
        break;
      default:
        keyed.skipValue();
        break;
    }
  }

  // Inlined fast-path check
  seen.validate();

  return TwitterUserEntities(url: url, description: description);
}

// =============================================================================
// 3. Single-Pass Streaming Serializer for TwitterUserEntities
// =============================================================================
void _$TwitterUserEntitiesToWriter(
  TwitterUserEntities instance,
  JsonTokenWriter writer,
) {
  writer.beginObject();
  if (instance.url != null) {
    writer.writeNameBytes(_$TwitterUserEntitiesSchema.nameUrlBytes);
    _$TwitterEntitiesUrlsToWriter(instance.url!, writer);
  }
  if (instance.description != null) {
    writer.writeNameBytes(_$TwitterUserEntitiesSchema.nameDescriptionBytes);
    _$TwitterEntitiesUrlsToWriter(instance.description!, writer);
  }
  writer.endObject();
}

// =============================================================================
// 1. Unified Schema Descriptor for TwitterEntities
// =============================================================================
extension type const _$TwitterEntitiesSchema(int _value) {
  // String Name Constants
  static const String nameUrls = 'urls';
  static const String nameUserMentions = 'user_mentions';

  // Pre-Encoded UTF-8 Wire Bytes
  static final Uint8List nameUrlsBytes = Uint8List.fromList(const [
    117,
    114,
    108,
    115,
  ]);
  static final Uint8List nameUserMentionsBytes = Uint8List.fromList(const [
    117,
    115,
    101,
    114,
    95,
    109,
    101,
    110,
    116,
    105,
    111,
    110,
    115,
  ]);

  // Key Indices for selectName()
  static const int keyUrls = 0;
  static const int keyUserMentions = 1;

  // Pre-Compiled JsonKeyOptions
  static final JsonKeyOptions options = JsonKeyOptions.of(const [
    _$TwitterEntitiesSchema.nameUrls,
    _$TwitterEntitiesSchema.nameUserMentions,
  ]);
  static final KeyOptions keyOptions = KeyOptions(
    options.keys,
    compiled: options,
  );

  // Bitmask Flags strictly for Required Fields
  static const _$TwitterEntitiesSchema none = _$TwitterEntitiesSchema(0);

  @pragma('vm:prefer-inline')
  _$TwitterEntitiesSchema operator |(_$TwitterEntitiesSchema other) =>
      _$TwitterEntitiesSchema(_value | other._value);

  /// Validates required fields in 1 CPU test instruction on the fast path.
  @pragma('vm:prefer-inline')
  void validate() {}
}

// =============================================================================
// 2. Single-Pass Streaming Deserializer for TwitterEntities
// =============================================================================
TwitterEntities _$TwitterEntitiesFromReader(JsonTokenReader reader) {
  reader.beginObject();

  var urls = const <TwitterUrl>[];
  var userMentions = const <TwitterUserMention>[];
  var seen = _$TwitterEntitiesSchema.none;

  while (reader.hasNext()) {
    switch (reader.selectName(_$TwitterEntitiesSchema.options)) {
      case _$TwitterEntitiesSchema.keyUrls:
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          reader.beginArray();
          final list = <TwitterUrl>[];
          while (reader.hasNext()) {
            list.add(_$TwitterUrlFromReader(reader));
          }
          reader.endArray();
          urls = list;
        }
        break;
      case _$TwitterEntitiesSchema.keyUserMentions:
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          reader.beginArray();
          final list = <TwitterUserMention>[];
          while (reader.hasNext()) {
            list.add(_$TwitterUserMentionFromReader(reader));
          }
          reader.endArray();
          userMentions = list;
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

  return TwitterEntities(urls: urls, userMentions: userMentions);
}

// =============================================================================
// 3. Universal Keyed Deserializer for TwitterEntities
// =============================================================================
TwitterEntities _$TwitterEntitiesFromDecoder(Decoder decoder) {
  final keyed = decoder.keyed();

  var urls = const <TwitterUrl>[];
  var userMentions = const <TwitterUserMention>[];
  var seen = _$TwitterEntitiesSchema.none;

  while (keyed.hasNextKey()) {
    switch (keyed.selectKeyIndex(_$TwitterEntitiesSchema.keyOptions)) {
      case _$TwitterEntitiesSchema.keyUrls:
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          urls = keyed.decodeList(_$TwitterUrlFromDecoder);
        }
        break;
      case _$TwitterEntitiesSchema.keyUserMentions:
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          userMentions = keyed.decodeList(_$TwitterUserMentionFromDecoder);
        }
        break;
      default:
        keyed.skipValue();
        break;
    }
  }

  // Inlined fast-path check
  seen.validate();

  return TwitterEntities(urls: urls, userMentions: userMentions);
}

// =============================================================================
// 3. Single-Pass Streaming Serializer for TwitterEntities
// =============================================================================
void _$TwitterEntitiesToWriter(
  TwitterEntities instance,
  JsonTokenWriter writer,
) {
  writer.beginObject();
  writer.writeNameBytes(_$TwitterEntitiesSchema.nameUrlsBytes);
  writer.beginArray();
  for (final item in instance.urls) {
    _$TwitterUrlToWriter(item, writer);
  }
  writer.endArray();
  writer.writeNameBytes(_$TwitterEntitiesSchema.nameUserMentionsBytes);
  writer.beginArray();
  for (final item in instance.userMentions) {
    _$TwitterUserMentionToWriter(item, writer);
  }
  writer.endArray();
  writer.endObject();
}

// =============================================================================
// 1. Unified Schema Descriptor for TwitterUser
// =============================================================================
extension type const _$TwitterUserSchema(int _value) {
  // String Name Constants
  static const String nameId = 'id';
  static const String nameIdStr = 'id_str';
  static const String nameName = 'name';
  static const String nameScreenName = 'screen_name';
  static const String nameLocation = 'location';
  static const String nameDescription = 'description';
  static const String nameUrl = 'url';
  static const String nameEntities = 'entities';
  static const String nameProtected = 'protected';
  static const String nameFollowersCount = 'followers_count';
  static const String nameFriendsCount = 'friends_count';
  static const String nameListedCount = 'listed_count';
  static const String nameCreatedAt = 'created_at';
  static const String nameFavouritesCount = 'favourites_count';
  static const String nameUtcOffset = 'utc_offset';
  static const String nameTimeZone = 'time_zone';
  static const String nameGeoEnabled = 'geo_enabled';
  static const String nameVerified = 'verified';
  static const String nameStatusesCount = 'statuses_count';
  static const String nameLang = 'lang';
  static const String nameContributorsEnabled = 'contributors_enabled';
  static const String nameIsTranslator = 'is_translator';
  static const String nameIsTranslationEnabled = 'is_translation_enabled';
  static const String nameProfileBackgroundColor = 'profile_background_color';
  static const String nameProfileBackgroundImageUrl =
      'profile_background_image_url';
  static const String nameProfileBackgroundImageUrlHttps =
      'profile_background_image_url_https';
  static const String nameProfileBackgroundTile = 'profile_background_tile';
  static const String nameProfileImageUrl = 'profile_image_url';
  static const String nameProfileImageUrlHttps = 'profile_image_url_https';
  static const String nameProfileBannerUrl = 'profile_banner_url';
  static const String nameProfileLinkColor = 'profile_link_color';
  static const String nameProfileSidebarBorderColor =
      'profile_sidebar_border_color';
  static const String nameProfileSidebarFillColor =
      'profile_sidebar_fill_color';
  static const String nameProfileTextColor = 'profile_text_color';
  static const String nameProfileUseBackgroundImage =
      'profile_use_background_image';
  static const String nameDefaultProfile = 'default_profile';
  static const String nameDefaultProfileImage = 'default_profile_image';
  static const String nameFollowing = 'following';
  static const String nameFollowRequestSent = 'follow_request_sent';
  static const String nameNotifications = 'notifications';

  // Pre-Encoded UTF-8 Wire Bytes
  static final Uint8List nameIdBytes = Uint8List.fromList(const [105, 100]);
  static final Uint8List nameIdStrBytes = Uint8List.fromList(const [
    105,
    100,
    95,
    115,
    116,
    114,
  ]);
  static final Uint8List nameNameBytes = Uint8List.fromList(const [
    110,
    97,
    109,
    101,
  ]);
  static final Uint8List nameScreenNameBytes = Uint8List.fromList(const [
    115,
    99,
    114,
    101,
    101,
    110,
    95,
    110,
    97,
    109,
    101,
  ]);
  static final Uint8List nameLocationBytes = Uint8List.fromList(const [
    108,
    111,
    99,
    97,
    116,
    105,
    111,
    110,
  ]);
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
  static final Uint8List nameUrlBytes = Uint8List.fromList(const [
    117,
    114,
    108,
  ]);
  static final Uint8List nameEntitiesBytes = Uint8List.fromList(const [
    101,
    110,
    116,
    105,
    116,
    105,
    101,
    115,
  ]);
  static final Uint8List nameProtectedBytes = Uint8List.fromList(const [
    112,
    114,
    111,
    116,
    101,
    99,
    116,
    101,
    100,
  ]);
  static final Uint8List nameFollowersCountBytes = Uint8List.fromList(const [
    102,
    111,
    108,
    108,
    111,
    119,
    101,
    114,
    115,
    95,
    99,
    111,
    117,
    110,
    116,
  ]);
  static final Uint8List nameFriendsCountBytes = Uint8List.fromList(const [
    102,
    114,
    105,
    101,
    110,
    100,
    115,
    95,
    99,
    111,
    117,
    110,
    116,
  ]);
  static final Uint8List nameListedCountBytes = Uint8List.fromList(const [
    108,
    105,
    115,
    116,
    101,
    100,
    95,
    99,
    111,
    117,
    110,
    116,
  ]);
  static final Uint8List nameCreatedAtBytes = Uint8List.fromList(const [
    99,
    114,
    101,
    97,
    116,
    101,
    100,
    95,
    97,
    116,
  ]);
  static final Uint8List nameFavouritesCountBytes = Uint8List.fromList(const [
    102,
    97,
    118,
    111,
    117,
    114,
    105,
    116,
    101,
    115,
    95,
    99,
    111,
    117,
    110,
    116,
  ]);
  static final Uint8List nameUtcOffsetBytes = Uint8List.fromList(const [
    117,
    116,
    99,
    95,
    111,
    102,
    102,
    115,
    101,
    116,
  ]);
  static final Uint8List nameTimeZoneBytes = Uint8List.fromList(const [
    116,
    105,
    109,
    101,
    95,
    122,
    111,
    110,
    101,
  ]);
  static final Uint8List nameGeoEnabledBytes = Uint8List.fromList(const [
    103,
    101,
    111,
    95,
    101,
    110,
    97,
    98,
    108,
    101,
    100,
  ]);
  static final Uint8List nameVerifiedBytes = Uint8List.fromList(const [
    118,
    101,
    114,
    105,
    102,
    105,
    101,
    100,
  ]);
  static final Uint8List nameStatusesCountBytes = Uint8List.fromList(const [
    115,
    116,
    97,
    116,
    117,
    115,
    101,
    115,
    95,
    99,
    111,
    117,
    110,
    116,
  ]);
  static final Uint8List nameLangBytes = Uint8List.fromList(const [
    108,
    97,
    110,
    103,
  ]);
  static final Uint8List nameContributorsEnabledBytes = Uint8List.fromList(
    const [
      99,
      111,
      110,
      116,
      114,
      105,
      98,
      117,
      116,
      111,
      114,
      115,
      95,
      101,
      110,
      97,
      98,
      108,
      101,
      100,
    ],
  );
  static final Uint8List nameIsTranslatorBytes = Uint8List.fromList(const [
    105,
    115,
    95,
    116,
    114,
    97,
    110,
    115,
    108,
    97,
    116,
    111,
    114,
  ]);
  static final Uint8List nameIsTranslationEnabledBytes = Uint8List.fromList(
    const [
      105,
      115,
      95,
      116,
      114,
      97,
      110,
      115,
      108,
      97,
      116,
      105,
      111,
      110,
      95,
      101,
      110,
      97,
      98,
      108,
      101,
      100,
    ],
  );
  static final Uint8List nameProfileBackgroundColorBytes = Uint8List.fromList(
    const [
      112,
      114,
      111,
      102,
      105,
      108,
      101,
      95,
      98,
      97,
      99,
      107,
      103,
      114,
      111,
      117,
      110,
      100,
      95,
      99,
      111,
      108,
      111,
      114,
    ],
  );
  static final Uint8List nameProfileBackgroundImageUrlBytes =
      Uint8List.fromList(const [
        112,
        114,
        111,
        102,
        105,
        108,
        101,
        95,
        98,
        97,
        99,
        107,
        103,
        114,
        111,
        117,
        110,
        100,
        95,
        105,
        109,
        97,
        103,
        101,
        95,
        117,
        114,
        108,
      ]);
  static final Uint8List nameProfileBackgroundImageUrlHttpsBytes =
      Uint8List.fromList(const [
        112,
        114,
        111,
        102,
        105,
        108,
        101,
        95,
        98,
        97,
        99,
        107,
        103,
        114,
        111,
        117,
        110,
        100,
        95,
        105,
        109,
        97,
        103,
        101,
        95,
        117,
        114,
        108,
        95,
        104,
        116,
        116,
        112,
        115,
      ]);
  static final Uint8List nameProfileBackgroundTileBytes = Uint8List.fromList(
    const [
      112,
      114,
      111,
      102,
      105,
      108,
      101,
      95,
      98,
      97,
      99,
      107,
      103,
      114,
      111,
      117,
      110,
      100,
      95,
      116,
      105,
      108,
      101,
    ],
  );
  static final Uint8List nameProfileImageUrlBytes = Uint8List.fromList(const [
    112,
    114,
    111,
    102,
    105,
    108,
    101,
    95,
    105,
    109,
    97,
    103,
    101,
    95,
    117,
    114,
    108,
  ]);
  static final Uint8List nameProfileImageUrlHttpsBytes = Uint8List.fromList(
    const [
      112,
      114,
      111,
      102,
      105,
      108,
      101,
      95,
      105,
      109,
      97,
      103,
      101,
      95,
      117,
      114,
      108,
      95,
      104,
      116,
      116,
      112,
      115,
    ],
  );
  static final Uint8List nameProfileBannerUrlBytes = Uint8List.fromList(const [
    112,
    114,
    111,
    102,
    105,
    108,
    101,
    95,
    98,
    97,
    110,
    110,
    101,
    114,
    95,
    117,
    114,
    108,
  ]);
  static final Uint8List nameProfileLinkColorBytes = Uint8List.fromList(const [
    112,
    114,
    111,
    102,
    105,
    108,
    101,
    95,
    108,
    105,
    110,
    107,
    95,
    99,
    111,
    108,
    111,
    114,
  ]);
  static final Uint8List nameProfileSidebarBorderColorBytes =
      Uint8List.fromList(const [
        112,
        114,
        111,
        102,
        105,
        108,
        101,
        95,
        115,
        105,
        100,
        101,
        98,
        97,
        114,
        95,
        98,
        111,
        114,
        100,
        101,
        114,
        95,
        99,
        111,
        108,
        111,
        114,
      ]);
  static final Uint8List nameProfileSidebarFillColorBytes = Uint8List.fromList(
    const [
      112,
      114,
      111,
      102,
      105,
      108,
      101,
      95,
      115,
      105,
      100,
      101,
      98,
      97,
      114,
      95,
      102,
      105,
      108,
      108,
      95,
      99,
      111,
      108,
      111,
      114,
    ],
  );
  static final Uint8List nameProfileTextColorBytes = Uint8List.fromList(const [
    112,
    114,
    111,
    102,
    105,
    108,
    101,
    95,
    116,
    101,
    120,
    116,
    95,
    99,
    111,
    108,
    111,
    114,
  ]);
  static final Uint8List nameProfileUseBackgroundImageBytes =
      Uint8List.fromList(const [
        112,
        114,
        111,
        102,
        105,
        108,
        101,
        95,
        117,
        115,
        101,
        95,
        98,
        97,
        99,
        107,
        103,
        114,
        111,
        117,
        110,
        100,
        95,
        105,
        109,
        97,
        103,
        101,
      ]);
  static final Uint8List nameDefaultProfileBytes = Uint8List.fromList(const [
    100,
    101,
    102,
    97,
    117,
    108,
    116,
    95,
    112,
    114,
    111,
    102,
    105,
    108,
    101,
  ]);
  static final Uint8List nameDefaultProfileImageBytes = Uint8List.fromList(
    const [
      100,
      101,
      102,
      97,
      117,
      108,
      116,
      95,
      112,
      114,
      111,
      102,
      105,
      108,
      101,
      95,
      105,
      109,
      97,
      103,
      101,
    ],
  );
  static final Uint8List nameFollowingBytes = Uint8List.fromList(const [
    102,
    111,
    108,
    108,
    111,
    119,
    105,
    110,
    103,
  ]);
  static final Uint8List nameFollowRequestSentBytes = Uint8List.fromList(const [
    102,
    111,
    108,
    108,
    111,
    119,
    95,
    114,
    101,
    113,
    117,
    101,
    115,
    116,
    95,
    115,
    101,
    110,
    116,
  ]);
  static final Uint8List nameNotificationsBytes = Uint8List.fromList(const [
    110,
    111,
    116,
    105,
    102,
    105,
    99,
    97,
    116,
    105,
    111,
    110,
    115,
  ]);

  // Key Indices for selectName()
  static const int keyId = 0;
  static const int keyIdStr = 1;
  static const int keyName = 2;
  static const int keyScreenName = 3;
  static const int keyLocation = 4;
  static const int keyDescription = 5;
  static const int keyUrl = 6;
  static const int keyEntities = 7;
  static const int keyProtected = 8;
  static const int keyFollowersCount = 9;
  static const int keyFriendsCount = 10;
  static const int keyListedCount = 11;
  static const int keyCreatedAt = 12;
  static const int keyFavouritesCount = 13;
  static const int keyUtcOffset = 14;
  static const int keyTimeZone = 15;
  static const int keyGeoEnabled = 16;
  static const int keyVerified = 17;
  static const int keyStatusesCount = 18;
  static const int keyLang = 19;
  static const int keyContributorsEnabled = 20;
  static const int keyIsTranslator = 21;
  static const int keyIsTranslationEnabled = 22;
  static const int keyProfileBackgroundColor = 23;
  static const int keyProfileBackgroundImageUrl = 24;
  static const int keyProfileBackgroundImageUrlHttps = 25;
  static const int keyProfileBackgroundTile = 26;
  static const int keyProfileImageUrl = 27;
  static const int keyProfileImageUrlHttps = 28;
  static const int keyProfileBannerUrl = 29;
  static const int keyProfileLinkColor = 30;
  static const int keyProfileSidebarBorderColor = 31;
  static const int keyProfileSidebarFillColor = 32;
  static const int keyProfileTextColor = 33;
  static const int keyProfileUseBackgroundImage = 34;
  static const int keyDefaultProfile = 35;
  static const int keyDefaultProfileImage = 36;
  static const int keyFollowing = 37;
  static const int keyFollowRequestSent = 38;
  static const int keyNotifications = 39;

  // Pre-Compiled JsonKeyOptions
  static final JsonKeyOptions options = JsonKeyOptions.of(const [
    _$TwitterUserSchema.nameId,
    _$TwitterUserSchema.nameIdStr,
    _$TwitterUserSchema.nameName,
    _$TwitterUserSchema.nameScreenName,
    _$TwitterUserSchema.nameLocation,
    _$TwitterUserSchema.nameDescription,
    _$TwitterUserSchema.nameUrl,
    _$TwitterUserSchema.nameEntities,
    _$TwitterUserSchema.nameProtected,
    _$TwitterUserSchema.nameFollowersCount,
    _$TwitterUserSchema.nameFriendsCount,
    _$TwitterUserSchema.nameListedCount,
    _$TwitterUserSchema.nameCreatedAt,
    _$TwitterUserSchema.nameFavouritesCount,
    _$TwitterUserSchema.nameUtcOffset,
    _$TwitterUserSchema.nameTimeZone,
    _$TwitterUserSchema.nameGeoEnabled,
    _$TwitterUserSchema.nameVerified,
    _$TwitterUserSchema.nameStatusesCount,
    _$TwitterUserSchema.nameLang,
    _$TwitterUserSchema.nameContributorsEnabled,
    _$TwitterUserSchema.nameIsTranslator,
    _$TwitterUserSchema.nameIsTranslationEnabled,
    _$TwitterUserSchema.nameProfileBackgroundColor,
    _$TwitterUserSchema.nameProfileBackgroundImageUrl,
    _$TwitterUserSchema.nameProfileBackgroundImageUrlHttps,
    _$TwitterUserSchema.nameProfileBackgroundTile,
    _$TwitterUserSchema.nameProfileImageUrl,
    _$TwitterUserSchema.nameProfileImageUrlHttps,
    _$TwitterUserSchema.nameProfileBannerUrl,
    _$TwitterUserSchema.nameProfileLinkColor,
    _$TwitterUserSchema.nameProfileSidebarBorderColor,
    _$TwitterUserSchema.nameProfileSidebarFillColor,
    _$TwitterUserSchema.nameProfileTextColor,
    _$TwitterUserSchema.nameProfileUseBackgroundImage,
    _$TwitterUserSchema.nameDefaultProfile,
    _$TwitterUserSchema.nameDefaultProfileImage,
    _$TwitterUserSchema.nameFollowing,
    _$TwitterUserSchema.nameFollowRequestSent,
    _$TwitterUserSchema.nameNotifications,
  ]);
  static final KeyOptions keyOptions = KeyOptions(
    options.keys,
    compiled: options,
  );

  // Bitmask Flags strictly for Required Fields
  static const _$TwitterUserSchema none = _$TwitterUserSchema(0);
  static const int _idBit = 1 << 0;
  static const _$TwitterUserSchema id = _$TwitterUserSchema(_idBit);
  static const int _idStrBit = 1 << 1;
  static const _$TwitterUserSchema idStr = _$TwitterUserSchema(_idStrBit);
  static const int _nameBit = 1 << 2;
  static const _$TwitterUserSchema name = _$TwitterUserSchema(_nameBit);
  static const int _screenNameBit = 1 << 3;
  static const _$TwitterUserSchema screenName = _$TwitterUserSchema(
    _screenNameBit,
  );
  static const int _createdAtBit = 1 << 4;
  static const _$TwitterUserSchema createdAt = _$TwitterUserSchema(
    _createdAtBit,
  );

  // Composite Golden Mask for Required Fields
  static const _$TwitterUserSchema golden = _$TwitterUserSchema(
    _idBit | _idStrBit | _nameBit | _screenNameBit | _createdAtBit,
  );

  @pragma('vm:prefer-inline')
  _$TwitterUserSchema operator |(_$TwitterUserSchema other) =>
      _$TwitterUserSchema(_value | other._value);

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
    if ((_value & _idStrBit) == 0) {
      missing.add(nameIdStr);
    }
    if ((_value & _nameBit) == 0) {
      missing.add(nameName);
    }
    if ((_value & _screenNameBit) == 0) {
      missing.add(nameScreenName);
    }
    if ((_value & _createdAtBit) == 0) {
      missing.add(nameCreatedAt);
    }
    throw CodableException(
      'Missing required fields for TwitterUser: ${missing.join(", ")}',
    );
  }
}

// =============================================================================
// 2. Single-Pass Streaming Deserializer for TwitterUser
// =============================================================================
TwitterUser _$TwitterUserFromReader(JsonTokenReader reader) {
  reader.beginObject();

  int? id;
  String? idStr;
  String? name;
  String? screenName;
  var location = '';
  var description = '';
  String? url;
  TwitterUserEntities? entities;
  var protected = false;
  var followersCount = 0;
  var friendsCount = 0;
  var listedCount = 0;
  String? createdAt;
  var favouritesCount = 0;
  int? utcOffset;
  String? timeZone;
  var geoEnabled = false;
  var verified = false;
  var statusesCount = 0;
  var lang = 'en';
  var contributorsEnabled = false;
  var isTranslator = false;
  var isTranslationEnabled = false;
  var profileBackgroundColor = '';
  var profileBackgroundImageUrl = '';
  var profileBackgroundImageUrlHttps = '';
  var profileBackgroundTile = false;
  var profileImageUrl = '';
  var profileImageUrlHttps = '';
  String? profileBannerUrl;
  var profileLinkColor = '';
  var profileSidebarBorderColor = '';
  var profileSidebarFillColor = '';
  var profileTextColor = '';
  var profileUseBackgroundImage = false;
  var defaultProfile = false;
  var defaultProfileImage = false;
  var following = false;
  var followRequestSent = false;
  var notifications = false;
  var seen = _$TwitterUserSchema.none;

  while (reader.hasNext()) {
    switch (reader.selectName(_$TwitterUserSchema.options)) {
      case _$TwitterUserSchema.keyId:
        if ((seen._value & _$TwitterUserSchema.id._value) != 0) {
          throw const CodableException('Duplicate field "id"');
        }
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          id = reader.readInt();
          seen |= _$TwitterUserSchema.id;
        }
        break;
      case _$TwitterUserSchema.keyIdStr:
        if ((seen._value & _$TwitterUserSchema.idStr._value) != 0) {
          throw const CodableException('Duplicate field "id_str"');
        }
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          idStr = reader.readString();
          seen |= _$TwitterUserSchema.idStr;
        }
        break;
      case _$TwitterUserSchema.keyName:
        if ((seen._value & _$TwitterUserSchema.name._value) != 0) {
          throw const CodableException('Duplicate field "name"');
        }
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          name = reader.readString();
          seen |= _$TwitterUserSchema.name;
        }
        break;
      case _$TwitterUserSchema.keyScreenName:
        if ((seen._value & _$TwitterUserSchema.screenName._value) != 0) {
          throw const CodableException('Duplicate field "screen_name"');
        }
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          screenName = reader.readString();
          seen |= _$TwitterUserSchema.screenName;
        }
        break;
      case _$TwitterUserSchema.keyLocation:
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          location = reader.readString();
        }
        break;
      case _$TwitterUserSchema.keyDescription:
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          description = reader.readString();
        }
        break;
      case _$TwitterUserSchema.keyUrl:
        if (reader.isNextNull()) {
          reader.readNull();
          url = null;
        } else {
          url = reader.readString();
        }
        break;
      case _$TwitterUserSchema.keyEntities:
        if (reader.isNextNull()) {
          reader.readNull();
          entities = null;
        } else {
          entities = _$TwitterUserEntitiesFromReader(reader);
        }
        break;
      case _$TwitterUserSchema.keyProtected:
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          protected = reader.readBool();
        }
        break;
      case _$TwitterUserSchema.keyFollowersCount:
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          followersCount = reader.readInt();
        }
        break;
      case _$TwitterUserSchema.keyFriendsCount:
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          friendsCount = reader.readInt();
        }
        break;
      case _$TwitterUserSchema.keyListedCount:
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          listedCount = reader.readInt();
        }
        break;
      case _$TwitterUserSchema.keyCreatedAt:
        if ((seen._value & _$TwitterUserSchema.createdAt._value) != 0) {
          throw const CodableException('Duplicate field "created_at"');
        }
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          createdAt = reader.readString();
          seen |= _$TwitterUserSchema.createdAt;
        }
        break;
      case _$TwitterUserSchema.keyFavouritesCount:
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          favouritesCount = reader.readInt();
        }
        break;
      case _$TwitterUserSchema.keyUtcOffset:
        if (reader.isNextNull()) {
          reader.readNull();
          utcOffset = null;
        } else {
          utcOffset = reader.readInt();
        }
        break;
      case _$TwitterUserSchema.keyTimeZone:
        if (reader.isNextNull()) {
          reader.readNull();
          timeZone = null;
        } else {
          timeZone = reader.readString();
        }
        break;
      case _$TwitterUserSchema.keyGeoEnabled:
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          geoEnabled = reader.readBool();
        }
        break;
      case _$TwitterUserSchema.keyVerified:
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          verified = reader.readBool();
        }
        break;
      case _$TwitterUserSchema.keyStatusesCount:
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          statusesCount = reader.readInt();
        }
        break;
      case _$TwitterUserSchema.keyLang:
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          lang = reader.readString();
        }
        break;
      case _$TwitterUserSchema.keyContributorsEnabled:
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          contributorsEnabled = reader.readBool();
        }
        break;
      case _$TwitterUserSchema.keyIsTranslator:
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          isTranslator = reader.readBool();
        }
        break;
      case _$TwitterUserSchema.keyIsTranslationEnabled:
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          isTranslationEnabled = reader.readBool();
        }
        break;
      case _$TwitterUserSchema.keyProfileBackgroundColor:
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          profileBackgroundColor = reader.readString();
        }
        break;
      case _$TwitterUserSchema.keyProfileBackgroundImageUrl:
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          profileBackgroundImageUrl = reader.readString();
        }
        break;
      case _$TwitterUserSchema.keyProfileBackgroundImageUrlHttps:
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          profileBackgroundImageUrlHttps = reader.readString();
        }
        break;
      case _$TwitterUserSchema.keyProfileBackgroundTile:
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          profileBackgroundTile = reader.readBool();
        }
        break;
      case _$TwitterUserSchema.keyProfileImageUrl:
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          profileImageUrl = reader.readString();
        }
        break;
      case _$TwitterUserSchema.keyProfileImageUrlHttps:
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          profileImageUrlHttps = reader.readString();
        }
        break;
      case _$TwitterUserSchema.keyProfileBannerUrl:
        if (reader.isNextNull()) {
          reader.readNull();
          profileBannerUrl = null;
        } else {
          profileBannerUrl = reader.readString();
        }
        break;
      case _$TwitterUserSchema.keyProfileLinkColor:
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          profileLinkColor = reader.readString();
        }
        break;
      case _$TwitterUserSchema.keyProfileSidebarBorderColor:
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          profileSidebarBorderColor = reader.readString();
        }
        break;
      case _$TwitterUserSchema.keyProfileSidebarFillColor:
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          profileSidebarFillColor = reader.readString();
        }
        break;
      case _$TwitterUserSchema.keyProfileTextColor:
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          profileTextColor = reader.readString();
        }
        break;
      case _$TwitterUserSchema.keyProfileUseBackgroundImage:
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          profileUseBackgroundImage = reader.readBool();
        }
        break;
      case _$TwitterUserSchema.keyDefaultProfile:
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          defaultProfile = reader.readBool();
        }
        break;
      case _$TwitterUserSchema.keyDefaultProfileImage:
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          defaultProfileImage = reader.readBool();
        }
        break;
      case _$TwitterUserSchema.keyFollowing:
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          following = reader.readBool();
        }
        break;
      case _$TwitterUserSchema.keyFollowRequestSent:
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          followRequestSent = reader.readBool();
        }
        break;
      case _$TwitterUserSchema.keyNotifications:
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          notifications = reader.readBool();
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

  return TwitterUser(
    id: id!,
    idStr: idStr!,
    name: name!,
    screenName: screenName!,
    location: location,
    description: description,
    url: url,
    entities: entities,
    protected: protected,
    followersCount: followersCount,
    friendsCount: friendsCount,
    listedCount: listedCount,
    createdAt: createdAt!,
    favouritesCount: favouritesCount,
    utcOffset: utcOffset,
    timeZone: timeZone,
    geoEnabled: geoEnabled,
    verified: verified,
    statusesCount: statusesCount,
    lang: lang,
    contributorsEnabled: contributorsEnabled,
    isTranslator: isTranslator,
    isTranslationEnabled: isTranslationEnabled,
    profileBackgroundColor: profileBackgroundColor,
    profileBackgroundImageUrl: profileBackgroundImageUrl,
    profileBackgroundImageUrlHttps: profileBackgroundImageUrlHttps,
    profileBackgroundTile: profileBackgroundTile,
    profileImageUrl: profileImageUrl,
    profileImageUrlHttps: profileImageUrlHttps,
    profileBannerUrl: profileBannerUrl,
    profileLinkColor: profileLinkColor,
    profileSidebarBorderColor: profileSidebarBorderColor,
    profileSidebarFillColor: profileSidebarFillColor,
    profileTextColor: profileTextColor,
    profileUseBackgroundImage: profileUseBackgroundImage,
    defaultProfile: defaultProfile,
    defaultProfileImage: defaultProfileImage,
    following: following,
    followRequestSent: followRequestSent,
    notifications: notifications,
  );
}

// =============================================================================
// 3. Universal Keyed Deserializer for TwitterUser
// =============================================================================
TwitterUser _$TwitterUserFromDecoder(Decoder decoder) {
  final keyed = decoder.keyed();

  int? id;
  String? idStr;
  String? name;
  String? screenName;
  var location = '';
  var description = '';
  String? url;
  TwitterUserEntities? entities;
  var protected = false;
  var followersCount = 0;
  var friendsCount = 0;
  var listedCount = 0;
  String? createdAt;
  var favouritesCount = 0;
  int? utcOffset;
  String? timeZone;
  var geoEnabled = false;
  var verified = false;
  var statusesCount = 0;
  var lang = 'en';
  var contributorsEnabled = false;
  var isTranslator = false;
  var isTranslationEnabled = false;
  var profileBackgroundColor = '';
  var profileBackgroundImageUrl = '';
  var profileBackgroundImageUrlHttps = '';
  var profileBackgroundTile = false;
  var profileImageUrl = '';
  var profileImageUrlHttps = '';
  String? profileBannerUrl;
  var profileLinkColor = '';
  var profileSidebarBorderColor = '';
  var profileSidebarFillColor = '';
  var profileTextColor = '';
  var profileUseBackgroundImage = false;
  var defaultProfile = false;
  var defaultProfileImage = false;
  var following = false;
  var followRequestSent = false;
  var notifications = false;
  var seen = _$TwitterUserSchema.none;

  while (keyed.hasNextKey()) {
    switch (keyed.selectKeyIndex(_$TwitterUserSchema.keyOptions)) {
      case _$TwitterUserSchema.keyId:
        if ((seen._value & _$TwitterUserSchema.id._value) != 0) {
          throw const CodableException('Duplicate field "id"');
        }
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          id = keyed.readInt();
          seen |= _$TwitterUserSchema.id;
        }
        break;
      case _$TwitterUserSchema.keyIdStr:
        if ((seen._value & _$TwitterUserSchema.idStr._value) != 0) {
          throw const CodableException('Duplicate field "id_str"');
        }
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          idStr = keyed.readString();
          seen |= _$TwitterUserSchema.idStr;
        }
        break;
      case _$TwitterUserSchema.keyName:
        if ((seen._value & _$TwitterUserSchema.name._value) != 0) {
          throw const CodableException('Duplicate field "name"');
        }
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          name = keyed.readString();
          seen |= _$TwitterUserSchema.name;
        }
        break;
      case _$TwitterUserSchema.keyScreenName:
        if ((seen._value & _$TwitterUserSchema.screenName._value) != 0) {
          throw const CodableException('Duplicate field "screen_name"');
        }
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          screenName = keyed.readString();
          seen |= _$TwitterUserSchema.screenName;
        }
        break;
      case _$TwitterUserSchema.keyLocation:
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          location = keyed.readString();
        }
        break;
      case _$TwitterUserSchema.keyDescription:
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          description = keyed.readString();
        }
        break;
      case _$TwitterUserSchema.keyUrl:
        if (keyed.isNextNull()) {
          keyed.readNull();
          url = null;
        } else {
          url = keyed.readString();
        }
        break;
      case _$TwitterUserSchema.keyEntities:
        if (keyed.isNextNull()) {
          keyed.readNull();
          entities = null;
        } else {
          entities = keyed.decodeValue(_$TwitterUserEntitiesFromDecoder);
        }
        break;
      case _$TwitterUserSchema.keyProtected:
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          protected = keyed.readBool();
        }
        break;
      case _$TwitterUserSchema.keyFollowersCount:
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          followersCount = keyed.readInt();
        }
        break;
      case _$TwitterUserSchema.keyFriendsCount:
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          friendsCount = keyed.readInt();
        }
        break;
      case _$TwitterUserSchema.keyListedCount:
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          listedCount = keyed.readInt();
        }
        break;
      case _$TwitterUserSchema.keyCreatedAt:
        if ((seen._value & _$TwitterUserSchema.createdAt._value) != 0) {
          throw const CodableException('Duplicate field "created_at"');
        }
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          createdAt = keyed.readString();
          seen |= _$TwitterUserSchema.createdAt;
        }
        break;
      case _$TwitterUserSchema.keyFavouritesCount:
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          favouritesCount = keyed.readInt();
        }
        break;
      case _$TwitterUserSchema.keyUtcOffset:
        if (keyed.isNextNull()) {
          keyed.readNull();
          utcOffset = null;
        } else {
          utcOffset = keyed.readInt();
        }
        break;
      case _$TwitterUserSchema.keyTimeZone:
        if (keyed.isNextNull()) {
          keyed.readNull();
          timeZone = null;
        } else {
          timeZone = keyed.readString();
        }
        break;
      case _$TwitterUserSchema.keyGeoEnabled:
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          geoEnabled = keyed.readBool();
        }
        break;
      case _$TwitterUserSchema.keyVerified:
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          verified = keyed.readBool();
        }
        break;
      case _$TwitterUserSchema.keyStatusesCount:
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          statusesCount = keyed.readInt();
        }
        break;
      case _$TwitterUserSchema.keyLang:
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          lang = keyed.readString();
        }
        break;
      case _$TwitterUserSchema.keyContributorsEnabled:
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          contributorsEnabled = keyed.readBool();
        }
        break;
      case _$TwitterUserSchema.keyIsTranslator:
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          isTranslator = keyed.readBool();
        }
        break;
      case _$TwitterUserSchema.keyIsTranslationEnabled:
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          isTranslationEnabled = keyed.readBool();
        }
        break;
      case _$TwitterUserSchema.keyProfileBackgroundColor:
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          profileBackgroundColor = keyed.readString();
        }
        break;
      case _$TwitterUserSchema.keyProfileBackgroundImageUrl:
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          profileBackgroundImageUrl = keyed.readString();
        }
        break;
      case _$TwitterUserSchema.keyProfileBackgroundImageUrlHttps:
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          profileBackgroundImageUrlHttps = keyed.readString();
        }
        break;
      case _$TwitterUserSchema.keyProfileBackgroundTile:
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          profileBackgroundTile = keyed.readBool();
        }
        break;
      case _$TwitterUserSchema.keyProfileImageUrl:
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          profileImageUrl = keyed.readString();
        }
        break;
      case _$TwitterUserSchema.keyProfileImageUrlHttps:
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          profileImageUrlHttps = keyed.readString();
        }
        break;
      case _$TwitterUserSchema.keyProfileBannerUrl:
        if (keyed.isNextNull()) {
          keyed.readNull();
          profileBannerUrl = null;
        } else {
          profileBannerUrl = keyed.readString();
        }
        break;
      case _$TwitterUserSchema.keyProfileLinkColor:
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          profileLinkColor = keyed.readString();
        }
        break;
      case _$TwitterUserSchema.keyProfileSidebarBorderColor:
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          profileSidebarBorderColor = keyed.readString();
        }
        break;
      case _$TwitterUserSchema.keyProfileSidebarFillColor:
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          profileSidebarFillColor = keyed.readString();
        }
        break;
      case _$TwitterUserSchema.keyProfileTextColor:
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          profileTextColor = keyed.readString();
        }
        break;
      case _$TwitterUserSchema.keyProfileUseBackgroundImage:
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          profileUseBackgroundImage = keyed.readBool();
        }
        break;
      case _$TwitterUserSchema.keyDefaultProfile:
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          defaultProfile = keyed.readBool();
        }
        break;
      case _$TwitterUserSchema.keyDefaultProfileImage:
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          defaultProfileImage = keyed.readBool();
        }
        break;
      case _$TwitterUserSchema.keyFollowing:
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          following = keyed.readBool();
        }
        break;
      case _$TwitterUserSchema.keyFollowRequestSent:
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          followRequestSent = keyed.readBool();
        }
        break;
      case _$TwitterUserSchema.keyNotifications:
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          notifications = keyed.readBool();
        }
        break;
      default:
        keyed.skipValue();
        break;
    }
  }

  // Inlined fast-path check
  seen.validate();

  return TwitterUser(
    id: id!,
    idStr: idStr!,
    name: name!,
    screenName: screenName!,
    location: location,
    description: description,
    url: url,
    entities: entities,
    protected: protected,
    followersCount: followersCount,
    friendsCount: friendsCount,
    listedCount: listedCount,
    createdAt: createdAt!,
    favouritesCount: favouritesCount,
    utcOffset: utcOffset,
    timeZone: timeZone,
    geoEnabled: geoEnabled,
    verified: verified,
    statusesCount: statusesCount,
    lang: lang,
    contributorsEnabled: contributorsEnabled,
    isTranslator: isTranslator,
    isTranslationEnabled: isTranslationEnabled,
    profileBackgroundColor: profileBackgroundColor,
    profileBackgroundImageUrl: profileBackgroundImageUrl,
    profileBackgroundImageUrlHttps: profileBackgroundImageUrlHttps,
    profileBackgroundTile: profileBackgroundTile,
    profileImageUrl: profileImageUrl,
    profileImageUrlHttps: profileImageUrlHttps,
    profileBannerUrl: profileBannerUrl,
    profileLinkColor: profileLinkColor,
    profileSidebarBorderColor: profileSidebarBorderColor,
    profileSidebarFillColor: profileSidebarFillColor,
    profileTextColor: profileTextColor,
    profileUseBackgroundImage: profileUseBackgroundImage,
    defaultProfile: defaultProfile,
    defaultProfileImage: defaultProfileImage,
    following: following,
    followRequestSent: followRequestSent,
    notifications: notifications,
  );
}

// =============================================================================
// 3. Single-Pass Streaming Serializer for TwitterUser
// =============================================================================
void _$TwitterUserToWriter(TwitterUser instance, JsonTokenWriter writer) {
  writer.beginObject();
  writer.writeNameBytes(_$TwitterUserSchema.nameIdBytes);
  writer.writeInt(instance.id);
  writer.writeNameBytes(_$TwitterUserSchema.nameIdStrBytes);
  writer.writeString(instance.idStr);
  writer.writeNameBytes(_$TwitterUserSchema.nameNameBytes);
  writer.writeString(instance.name);
  writer.writeNameBytes(_$TwitterUserSchema.nameScreenNameBytes);
  writer.writeString(instance.screenName);
  writer.writeNameBytes(_$TwitterUserSchema.nameLocationBytes);
  writer.writeString(instance.location);
  writer.writeNameBytes(_$TwitterUserSchema.nameDescriptionBytes);
  writer.writeString(instance.description);
  if (instance.url != null) {
    writer.writeNameBytes(_$TwitterUserSchema.nameUrlBytes);
    writer.writeString(instance.url!);
  }
  if (instance.entities != null) {
    writer.writeNameBytes(_$TwitterUserSchema.nameEntitiesBytes);
    _$TwitterUserEntitiesToWriter(instance.entities!, writer);
  }
  writer.writeNameBytes(_$TwitterUserSchema.nameProtectedBytes);
  writer.writeBool(instance.protected);
  writer.writeNameBytes(_$TwitterUserSchema.nameFollowersCountBytes);
  writer.writeInt(instance.followersCount);
  writer.writeNameBytes(_$TwitterUserSchema.nameFriendsCountBytes);
  writer.writeInt(instance.friendsCount);
  writer.writeNameBytes(_$TwitterUserSchema.nameListedCountBytes);
  writer.writeInt(instance.listedCount);
  writer.writeNameBytes(_$TwitterUserSchema.nameCreatedAtBytes);
  writer.writeString(instance.createdAt);
  writer.writeNameBytes(_$TwitterUserSchema.nameFavouritesCountBytes);
  writer.writeInt(instance.favouritesCount);
  if (instance.utcOffset != null) {
    writer.writeNameBytes(_$TwitterUserSchema.nameUtcOffsetBytes);
    writer.writeInt(instance.utcOffset!);
  }
  if (instance.timeZone != null) {
    writer.writeNameBytes(_$TwitterUserSchema.nameTimeZoneBytes);
    writer.writeString(instance.timeZone!);
  }
  writer.writeNameBytes(_$TwitterUserSchema.nameGeoEnabledBytes);
  writer.writeBool(instance.geoEnabled);
  writer.writeNameBytes(_$TwitterUserSchema.nameVerifiedBytes);
  writer.writeBool(instance.verified);
  writer.writeNameBytes(_$TwitterUserSchema.nameStatusesCountBytes);
  writer.writeInt(instance.statusesCount);
  writer.writeNameBytes(_$TwitterUserSchema.nameLangBytes);
  writer.writeString(instance.lang);
  writer.writeNameBytes(_$TwitterUserSchema.nameContributorsEnabledBytes);
  writer.writeBool(instance.contributorsEnabled);
  writer.writeNameBytes(_$TwitterUserSchema.nameIsTranslatorBytes);
  writer.writeBool(instance.isTranslator);
  writer.writeNameBytes(_$TwitterUserSchema.nameIsTranslationEnabledBytes);
  writer.writeBool(instance.isTranslationEnabled);
  writer.writeNameBytes(_$TwitterUserSchema.nameProfileBackgroundColorBytes);
  writer.writeString(instance.profileBackgroundColor);
  writer.writeNameBytes(_$TwitterUserSchema.nameProfileBackgroundImageUrlBytes);
  writer.writeString(instance.profileBackgroundImageUrl);
  writer.writeNameBytes(
    _$TwitterUserSchema.nameProfileBackgroundImageUrlHttpsBytes,
  );
  writer.writeString(instance.profileBackgroundImageUrlHttps);
  writer.writeNameBytes(_$TwitterUserSchema.nameProfileBackgroundTileBytes);
  writer.writeBool(instance.profileBackgroundTile);
  writer.writeNameBytes(_$TwitterUserSchema.nameProfileImageUrlBytes);
  writer.writeString(instance.profileImageUrl);
  writer.writeNameBytes(_$TwitterUserSchema.nameProfileImageUrlHttpsBytes);
  writer.writeString(instance.profileImageUrlHttps);
  if (instance.profileBannerUrl != null) {
    writer.writeNameBytes(_$TwitterUserSchema.nameProfileBannerUrlBytes);
    writer.writeString(instance.profileBannerUrl!);
  }
  writer.writeNameBytes(_$TwitterUserSchema.nameProfileLinkColorBytes);
  writer.writeString(instance.profileLinkColor);
  writer.writeNameBytes(_$TwitterUserSchema.nameProfileSidebarBorderColorBytes);
  writer.writeString(instance.profileSidebarBorderColor);
  writer.writeNameBytes(_$TwitterUserSchema.nameProfileSidebarFillColorBytes);
  writer.writeString(instance.profileSidebarFillColor);
  writer.writeNameBytes(_$TwitterUserSchema.nameProfileTextColorBytes);
  writer.writeString(instance.profileTextColor);
  writer.writeNameBytes(_$TwitterUserSchema.nameProfileUseBackgroundImageBytes);
  writer.writeBool(instance.profileUseBackgroundImage);
  writer.writeNameBytes(_$TwitterUserSchema.nameDefaultProfileBytes);
  writer.writeBool(instance.defaultProfile);
  writer.writeNameBytes(_$TwitterUserSchema.nameDefaultProfileImageBytes);
  writer.writeBool(instance.defaultProfileImage);
  writer.writeNameBytes(_$TwitterUserSchema.nameFollowingBytes);
  writer.writeBool(instance.following);
  writer.writeNameBytes(_$TwitterUserSchema.nameFollowRequestSentBytes);
  writer.writeBool(instance.followRequestSent);
  writer.writeNameBytes(_$TwitterUserSchema.nameNotificationsBytes);
  writer.writeBool(instance.notifications);
  writer.endObject();
}

// =============================================================================
// 1. Unified Schema Descriptor for TwitterStatus
// =============================================================================
extension type const _$TwitterStatusSchema(int _value) {
  // String Name Constants
  static const String nameMetadata = 'metadata';
  static const String nameCreatedAt = 'created_at';
  static const String nameId = 'id';
  static const String nameIdStr = 'id_str';
  static const String nameText = 'text';
  static const String nameSource = 'source';
  static const String nameTruncated = 'truncated';
  static const String nameInReplyToStatusId = 'in_reply_to_status_id';
  static const String nameInReplyToStatusIdStr = 'in_reply_to_status_id_str';
  static const String nameInReplyToUserId = 'in_reply_to_user_id';
  static const String nameInReplyToUserIdStr = 'in_reply_to_user_id_str';
  static const String nameInReplyToScreenName = 'in_reply_to_screen_name';
  static const String nameUser = 'user';
  static const String nameRetweetCount = 'retweet_count';
  static const String nameFavoriteCount = 'favorite_count';
  static const String nameEntities = 'entities';
  static const String nameFavorited = 'favorited';
  static const String nameRetweeted = 'retweeted';
  static const String namePossiblySensitive = 'possibly_sensitive';
  static const String nameLang = 'lang';
  static const String nameRetweetedStatus = 'retweeted_status';

  // Pre-Encoded UTF-8 Wire Bytes
  static final Uint8List nameMetadataBytes = Uint8List.fromList(const [
    109,
    101,
    116,
    97,
    100,
    97,
    116,
    97,
  ]);
  static final Uint8List nameCreatedAtBytes = Uint8List.fromList(const [
    99,
    114,
    101,
    97,
    116,
    101,
    100,
    95,
    97,
    116,
  ]);
  static final Uint8List nameIdBytes = Uint8List.fromList(const [105, 100]);
  static final Uint8List nameIdStrBytes = Uint8List.fromList(const [
    105,
    100,
    95,
    115,
    116,
    114,
  ]);
  static final Uint8List nameTextBytes = Uint8List.fromList(const [
    116,
    101,
    120,
    116,
  ]);
  static final Uint8List nameSourceBytes = Uint8List.fromList(const [
    115,
    111,
    117,
    114,
    99,
    101,
  ]);
  static final Uint8List nameTruncatedBytes = Uint8List.fromList(const [
    116,
    114,
    117,
    110,
    99,
    97,
    116,
    101,
    100,
  ]);
  static final Uint8List nameInReplyToStatusIdBytes = Uint8List.fromList(const [
    105,
    110,
    95,
    114,
    101,
    112,
    108,
    121,
    95,
    116,
    111,
    95,
    115,
    116,
    97,
    116,
    117,
    115,
    95,
    105,
    100,
  ]);
  static final Uint8List nameInReplyToStatusIdStrBytes = Uint8List.fromList(
    const [
      105,
      110,
      95,
      114,
      101,
      112,
      108,
      121,
      95,
      116,
      111,
      95,
      115,
      116,
      97,
      116,
      117,
      115,
      95,
      105,
      100,
      95,
      115,
      116,
      114,
    ],
  );
  static final Uint8List nameInReplyToUserIdBytes = Uint8List.fromList(const [
    105,
    110,
    95,
    114,
    101,
    112,
    108,
    121,
    95,
    116,
    111,
    95,
    117,
    115,
    101,
    114,
    95,
    105,
    100,
  ]);
  static final Uint8List nameInReplyToUserIdStrBytes = Uint8List.fromList(
    const [
      105,
      110,
      95,
      114,
      101,
      112,
      108,
      121,
      95,
      116,
      111,
      95,
      117,
      115,
      101,
      114,
      95,
      105,
      100,
      95,
      115,
      116,
      114,
    ],
  );
  static final Uint8List nameInReplyToScreenNameBytes = Uint8List.fromList(
    const [
      105,
      110,
      95,
      114,
      101,
      112,
      108,
      121,
      95,
      116,
      111,
      95,
      115,
      99,
      114,
      101,
      101,
      110,
      95,
      110,
      97,
      109,
      101,
    ],
  );
  static final Uint8List nameUserBytes = Uint8List.fromList(const [
    117,
    115,
    101,
    114,
  ]);
  static final Uint8List nameRetweetCountBytes = Uint8List.fromList(const [
    114,
    101,
    116,
    119,
    101,
    101,
    116,
    95,
    99,
    111,
    117,
    110,
    116,
  ]);
  static final Uint8List nameFavoriteCountBytes = Uint8List.fromList(const [
    102,
    97,
    118,
    111,
    114,
    105,
    116,
    101,
    95,
    99,
    111,
    117,
    110,
    116,
  ]);
  static final Uint8List nameEntitiesBytes = Uint8List.fromList(const [
    101,
    110,
    116,
    105,
    116,
    105,
    101,
    115,
  ]);
  static final Uint8List nameFavoritedBytes = Uint8List.fromList(const [
    102,
    97,
    118,
    111,
    114,
    105,
    116,
    101,
    100,
  ]);
  static final Uint8List nameRetweetedBytes = Uint8List.fromList(const [
    114,
    101,
    116,
    119,
    101,
    101,
    116,
    101,
    100,
  ]);
  static final Uint8List namePossiblySensitiveBytes = Uint8List.fromList(const [
    112,
    111,
    115,
    115,
    105,
    98,
    108,
    121,
    95,
    115,
    101,
    110,
    115,
    105,
    116,
    105,
    118,
    101,
  ]);
  static final Uint8List nameLangBytes = Uint8List.fromList(const [
    108,
    97,
    110,
    103,
  ]);
  static final Uint8List nameRetweetedStatusBytes = Uint8List.fromList(const [
    114,
    101,
    116,
    119,
    101,
    101,
    116,
    101,
    100,
    95,
    115,
    116,
    97,
    116,
    117,
    115,
  ]);

  // Key Indices for selectName()
  static const int keyMetadata = 0;
  static const int keyCreatedAt = 1;
  static const int keyId = 2;
  static const int keyIdStr = 3;
  static const int keyText = 4;
  static const int keySource = 5;
  static const int keyTruncated = 6;
  static const int keyInReplyToStatusId = 7;
  static const int keyInReplyToStatusIdStr = 8;
  static const int keyInReplyToUserId = 9;
  static const int keyInReplyToUserIdStr = 10;
  static const int keyInReplyToScreenName = 11;
  static const int keyUser = 12;
  static const int keyRetweetCount = 13;
  static const int keyFavoriteCount = 14;
  static const int keyEntities = 15;
  static const int keyFavorited = 16;
  static const int keyRetweeted = 17;
  static const int keyPossiblySensitive = 18;
  static const int keyLang = 19;
  static const int keyRetweetedStatus = 20;

  // Pre-Compiled JsonKeyOptions
  static final JsonKeyOptions options = JsonKeyOptions.of(const [
    _$TwitterStatusSchema.nameMetadata,
    _$TwitterStatusSchema.nameCreatedAt,
    _$TwitterStatusSchema.nameId,
    _$TwitterStatusSchema.nameIdStr,
    _$TwitterStatusSchema.nameText,
    _$TwitterStatusSchema.nameSource,
    _$TwitterStatusSchema.nameTruncated,
    _$TwitterStatusSchema.nameInReplyToStatusId,
    _$TwitterStatusSchema.nameInReplyToStatusIdStr,
    _$TwitterStatusSchema.nameInReplyToUserId,
    _$TwitterStatusSchema.nameInReplyToUserIdStr,
    _$TwitterStatusSchema.nameInReplyToScreenName,
    _$TwitterStatusSchema.nameUser,
    _$TwitterStatusSchema.nameRetweetCount,
    _$TwitterStatusSchema.nameFavoriteCount,
    _$TwitterStatusSchema.nameEntities,
    _$TwitterStatusSchema.nameFavorited,
    _$TwitterStatusSchema.nameRetweeted,
    _$TwitterStatusSchema.namePossiblySensitive,
    _$TwitterStatusSchema.nameLang,
    _$TwitterStatusSchema.nameRetweetedStatus,
  ]);
  static final KeyOptions keyOptions = KeyOptions(
    options.keys,
    compiled: options,
  );

  // Bitmask Flags strictly for Required Fields
  static const _$TwitterStatusSchema none = _$TwitterStatusSchema(0);
  static const int _createdAtBit = 1 << 0;
  static const _$TwitterStatusSchema createdAt = _$TwitterStatusSchema(
    _createdAtBit,
  );
  static const int _idBit = 1 << 1;
  static const _$TwitterStatusSchema id = _$TwitterStatusSchema(_idBit);
  static const int _idStrBit = 1 << 2;
  static const _$TwitterStatusSchema idStr = _$TwitterStatusSchema(_idStrBit);
  static const int _textBit = 1 << 3;
  static const _$TwitterStatusSchema text = _$TwitterStatusSchema(_textBit);
  static const int _sourceBit = 1 << 4;
  static const _$TwitterStatusSchema source = _$TwitterStatusSchema(_sourceBit);

  // Composite Golden Mask for Required Fields
  static const _$TwitterStatusSchema golden = _$TwitterStatusSchema(
    _createdAtBit | _idBit | _idStrBit | _textBit | _sourceBit,
  );

  @pragma('vm:prefer-inline')
  _$TwitterStatusSchema operator |(_$TwitterStatusSchema other) =>
      _$TwitterStatusSchema(_value | other._value);

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
    if ((_value & _createdAtBit) == 0) {
      missing.add(nameCreatedAt);
    }
    if ((_value & _idBit) == 0) {
      missing.add(nameId);
    }
    if ((_value & _idStrBit) == 0) {
      missing.add(nameIdStr);
    }
    if ((_value & _textBit) == 0) {
      missing.add(nameText);
    }
    if ((_value & _sourceBit) == 0) {
      missing.add(nameSource);
    }
    throw CodableException(
      'Missing required fields for TwitterStatus: ${missing.join(", ")}',
    );
  }
}

// =============================================================================
// 2. Single-Pass Streaming Deserializer for TwitterStatus
// =============================================================================
TwitterStatus _$TwitterStatusFromReader(JsonTokenReader reader) {
  reader.beginObject();

  TwitterMetadata? metadata;
  String? createdAt;
  int? id;
  String? idStr;
  String? text;
  String? source;
  var truncated = false;
  int? inReplyToStatusId;
  String? inReplyToStatusIdStr;
  int? inReplyToUserId;
  String? inReplyToUserIdStr;
  String? inReplyToScreenName;
  TwitterUser? user;
  var retweetCount = 0;
  var favoriteCount = 0;
  TwitterEntities? entities;
  var favorited = false;
  var retweeted = false;
  bool? possiblySensitive;
  var lang = 'en';
  TwitterStatus? retweetedStatus;
  var seen = _$TwitterStatusSchema.none;

  while (reader.hasNext()) {
    switch (reader.selectName(_$TwitterStatusSchema.options)) {
      case _$TwitterStatusSchema.keyMetadata:
        if (reader.isNextNull()) {
          reader.readNull();
          metadata = null;
        } else {
          metadata = _$TwitterMetadataFromReader(reader);
        }
        break;
      case _$TwitterStatusSchema.keyCreatedAt:
        if ((seen._value & _$TwitterStatusSchema.createdAt._value) != 0) {
          throw const CodableException('Duplicate field "created_at"');
        }
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          createdAt = reader.readString();
          seen |= _$TwitterStatusSchema.createdAt;
        }
        break;
      case _$TwitterStatusSchema.keyId:
        if ((seen._value & _$TwitterStatusSchema.id._value) != 0) {
          throw const CodableException('Duplicate field "id"');
        }
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          id = reader.readInt();
          seen |= _$TwitterStatusSchema.id;
        }
        break;
      case _$TwitterStatusSchema.keyIdStr:
        if ((seen._value & _$TwitterStatusSchema.idStr._value) != 0) {
          throw const CodableException('Duplicate field "id_str"');
        }
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          idStr = reader.readString();
          seen |= _$TwitterStatusSchema.idStr;
        }
        break;
      case _$TwitterStatusSchema.keyText:
        if ((seen._value & _$TwitterStatusSchema.text._value) != 0) {
          throw const CodableException('Duplicate field "text"');
        }
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          text = reader.readString();
          seen |= _$TwitterStatusSchema.text;
        }
        break;
      case _$TwitterStatusSchema.keySource:
        if ((seen._value & _$TwitterStatusSchema.source._value) != 0) {
          throw const CodableException('Duplicate field "source"');
        }
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          source = reader.readString();
          seen |= _$TwitterStatusSchema.source;
        }
        break;
      case _$TwitterStatusSchema.keyTruncated:
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          truncated = reader.readBool();
        }
        break;
      case _$TwitterStatusSchema.keyInReplyToStatusId:
        if (reader.isNextNull()) {
          reader.readNull();
          inReplyToStatusId = null;
        } else {
          inReplyToStatusId = reader.readInt();
        }
        break;
      case _$TwitterStatusSchema.keyInReplyToStatusIdStr:
        if (reader.isNextNull()) {
          reader.readNull();
          inReplyToStatusIdStr = null;
        } else {
          inReplyToStatusIdStr = reader.readString();
        }
        break;
      case _$TwitterStatusSchema.keyInReplyToUserId:
        if (reader.isNextNull()) {
          reader.readNull();
          inReplyToUserId = null;
        } else {
          inReplyToUserId = reader.readInt();
        }
        break;
      case _$TwitterStatusSchema.keyInReplyToUserIdStr:
        if (reader.isNextNull()) {
          reader.readNull();
          inReplyToUserIdStr = null;
        } else {
          inReplyToUserIdStr = reader.readString();
        }
        break;
      case _$TwitterStatusSchema.keyInReplyToScreenName:
        if (reader.isNextNull()) {
          reader.readNull();
          inReplyToScreenName = null;
        } else {
          inReplyToScreenName = reader.readString();
        }
        break;
      case _$TwitterStatusSchema.keyUser:
        if (reader.isNextNull()) {
          reader.readNull();
          user = null;
        } else {
          user = _$TwitterUserFromReader(reader);
        }
        break;
      case _$TwitterStatusSchema.keyRetweetCount:
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          retweetCount = reader.readInt();
        }
        break;
      case _$TwitterStatusSchema.keyFavoriteCount:
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          favoriteCount = reader.readInt();
        }
        break;
      case _$TwitterStatusSchema.keyEntities:
        if (reader.isNextNull()) {
          reader.readNull();
          entities = null;
        } else {
          entities = _$TwitterEntitiesFromReader(reader);
        }
        break;
      case _$TwitterStatusSchema.keyFavorited:
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          favorited = reader.readBool();
        }
        break;
      case _$TwitterStatusSchema.keyRetweeted:
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          retweeted = reader.readBool();
        }
        break;
      case _$TwitterStatusSchema.keyPossiblySensitive:
        if (reader.isNextNull()) {
          reader.readNull();
          possiblySensitive = null;
        } else {
          possiblySensitive = reader.readBool();
        }
        break;
      case _$TwitterStatusSchema.keyLang:
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          lang = reader.readString();
        }
        break;
      case _$TwitterStatusSchema.keyRetweetedStatus:
        if (reader.isNextNull()) {
          reader.readNull();
          retweetedStatus = null;
        } else {
          retweetedStatus = _$TwitterStatusFromReader(reader);
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

  return TwitterStatus(
    metadata: metadata,
    createdAt: createdAt!,
    id: id!,
    idStr: idStr!,
    text: text!,
    source: source!,
    truncated: truncated,
    inReplyToStatusId: inReplyToStatusId,
    inReplyToStatusIdStr: inReplyToStatusIdStr,
    inReplyToUserId: inReplyToUserId,
    inReplyToUserIdStr: inReplyToUserIdStr,
    inReplyToScreenName: inReplyToScreenName,
    user: user,
    retweetCount: retweetCount,
    favoriteCount: favoriteCount,
    entities: entities,
    favorited: favorited,
    retweeted: retweeted,
    possiblySensitive: possiblySensitive,
    lang: lang,
    retweetedStatus: retweetedStatus,
  );
}

// =============================================================================
// 3. Universal Keyed Deserializer for TwitterStatus
// =============================================================================
TwitterStatus _$TwitterStatusFromDecoder(Decoder decoder) {
  final keyed = decoder.keyed();

  TwitterMetadata? metadata;
  String? createdAt;
  int? id;
  String? idStr;
  String? text;
  String? source;
  var truncated = false;
  int? inReplyToStatusId;
  String? inReplyToStatusIdStr;
  int? inReplyToUserId;
  String? inReplyToUserIdStr;
  String? inReplyToScreenName;
  TwitterUser? user;
  var retweetCount = 0;
  var favoriteCount = 0;
  TwitterEntities? entities;
  var favorited = false;
  var retweeted = false;
  bool? possiblySensitive;
  var lang = 'en';
  TwitterStatus? retweetedStatus;
  var seen = _$TwitterStatusSchema.none;

  while (keyed.hasNextKey()) {
    switch (keyed.selectKeyIndex(_$TwitterStatusSchema.keyOptions)) {
      case _$TwitterStatusSchema.keyMetadata:
        if (keyed.isNextNull()) {
          keyed.readNull();
          metadata = null;
        } else {
          metadata = keyed.decodeValue(_$TwitterMetadataFromDecoder);
        }
        break;
      case _$TwitterStatusSchema.keyCreatedAt:
        if ((seen._value & _$TwitterStatusSchema.createdAt._value) != 0) {
          throw const CodableException('Duplicate field "created_at"');
        }
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          createdAt = keyed.readString();
          seen |= _$TwitterStatusSchema.createdAt;
        }
        break;
      case _$TwitterStatusSchema.keyId:
        if ((seen._value & _$TwitterStatusSchema.id._value) != 0) {
          throw const CodableException('Duplicate field "id"');
        }
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          id = keyed.readInt();
          seen |= _$TwitterStatusSchema.id;
        }
        break;
      case _$TwitterStatusSchema.keyIdStr:
        if ((seen._value & _$TwitterStatusSchema.idStr._value) != 0) {
          throw const CodableException('Duplicate field "id_str"');
        }
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          idStr = keyed.readString();
          seen |= _$TwitterStatusSchema.idStr;
        }
        break;
      case _$TwitterStatusSchema.keyText:
        if ((seen._value & _$TwitterStatusSchema.text._value) != 0) {
          throw const CodableException('Duplicate field "text"');
        }
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          text = keyed.readString();
          seen |= _$TwitterStatusSchema.text;
        }
        break;
      case _$TwitterStatusSchema.keySource:
        if ((seen._value & _$TwitterStatusSchema.source._value) != 0) {
          throw const CodableException('Duplicate field "source"');
        }
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          source = keyed.readString();
          seen |= _$TwitterStatusSchema.source;
        }
        break;
      case _$TwitterStatusSchema.keyTruncated:
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          truncated = keyed.readBool();
        }
        break;
      case _$TwitterStatusSchema.keyInReplyToStatusId:
        if (keyed.isNextNull()) {
          keyed.readNull();
          inReplyToStatusId = null;
        } else {
          inReplyToStatusId = keyed.readInt();
        }
        break;
      case _$TwitterStatusSchema.keyInReplyToStatusIdStr:
        if (keyed.isNextNull()) {
          keyed.readNull();
          inReplyToStatusIdStr = null;
        } else {
          inReplyToStatusIdStr = keyed.readString();
        }
        break;
      case _$TwitterStatusSchema.keyInReplyToUserId:
        if (keyed.isNextNull()) {
          keyed.readNull();
          inReplyToUserId = null;
        } else {
          inReplyToUserId = keyed.readInt();
        }
        break;
      case _$TwitterStatusSchema.keyInReplyToUserIdStr:
        if (keyed.isNextNull()) {
          keyed.readNull();
          inReplyToUserIdStr = null;
        } else {
          inReplyToUserIdStr = keyed.readString();
        }
        break;
      case _$TwitterStatusSchema.keyInReplyToScreenName:
        if (keyed.isNextNull()) {
          keyed.readNull();
          inReplyToScreenName = null;
        } else {
          inReplyToScreenName = keyed.readString();
        }
        break;
      case _$TwitterStatusSchema.keyUser:
        if (keyed.isNextNull()) {
          keyed.readNull();
          user = null;
        } else {
          user = keyed.decodeValue(_$TwitterUserFromDecoder);
        }
        break;
      case _$TwitterStatusSchema.keyRetweetCount:
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          retweetCount = keyed.readInt();
        }
        break;
      case _$TwitterStatusSchema.keyFavoriteCount:
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          favoriteCount = keyed.readInt();
        }
        break;
      case _$TwitterStatusSchema.keyEntities:
        if (keyed.isNextNull()) {
          keyed.readNull();
          entities = null;
        } else {
          entities = keyed.decodeValue(_$TwitterEntitiesFromDecoder);
        }
        break;
      case _$TwitterStatusSchema.keyFavorited:
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          favorited = keyed.readBool();
        }
        break;
      case _$TwitterStatusSchema.keyRetweeted:
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          retweeted = keyed.readBool();
        }
        break;
      case _$TwitterStatusSchema.keyPossiblySensitive:
        if (keyed.isNextNull()) {
          keyed.readNull();
          possiblySensitive = null;
        } else {
          possiblySensitive = keyed.readBool();
        }
        break;
      case _$TwitterStatusSchema.keyLang:
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          lang = keyed.readString();
        }
        break;
      case _$TwitterStatusSchema.keyRetweetedStatus:
        if (keyed.isNextNull()) {
          keyed.readNull();
          retweetedStatus = null;
        } else {
          retweetedStatus = keyed.decodeValue(_$TwitterStatusFromDecoder);
        }
        break;
      default:
        keyed.skipValue();
        break;
    }
  }

  // Inlined fast-path check
  seen.validate();

  return TwitterStatus(
    metadata: metadata,
    createdAt: createdAt!,
    id: id!,
    idStr: idStr!,
    text: text!,
    source: source!,
    truncated: truncated,
    inReplyToStatusId: inReplyToStatusId,
    inReplyToStatusIdStr: inReplyToStatusIdStr,
    inReplyToUserId: inReplyToUserId,
    inReplyToUserIdStr: inReplyToUserIdStr,
    inReplyToScreenName: inReplyToScreenName,
    user: user,
    retweetCount: retweetCount,
    favoriteCount: favoriteCount,
    entities: entities,
    favorited: favorited,
    retweeted: retweeted,
    possiblySensitive: possiblySensitive,
    lang: lang,
    retweetedStatus: retweetedStatus,
  );
}

// =============================================================================
// 3. Single-Pass Streaming Serializer for TwitterStatus
// =============================================================================
void _$TwitterStatusToWriter(TwitterStatus instance, JsonTokenWriter writer) {
  writer.beginObject();
  if (instance.metadata != null) {
    writer.writeNameBytes(_$TwitterStatusSchema.nameMetadataBytes);
    _$TwitterMetadataToWriter(instance.metadata!, writer);
  }
  writer.writeNameBytes(_$TwitterStatusSchema.nameCreatedAtBytes);
  writer.writeString(instance.createdAt);
  writer.writeNameBytes(_$TwitterStatusSchema.nameIdBytes);
  writer.writeInt(instance.id);
  writer.writeNameBytes(_$TwitterStatusSchema.nameIdStrBytes);
  writer.writeString(instance.idStr);
  writer.writeNameBytes(_$TwitterStatusSchema.nameTextBytes);
  writer.writeString(instance.text);
  writer.writeNameBytes(_$TwitterStatusSchema.nameSourceBytes);
  writer.writeString(instance.source);
  writer.writeNameBytes(_$TwitterStatusSchema.nameTruncatedBytes);
  writer.writeBool(instance.truncated);
  if (instance.inReplyToStatusId != null) {
    writer.writeNameBytes(_$TwitterStatusSchema.nameInReplyToStatusIdBytes);
    writer.writeInt(instance.inReplyToStatusId!);
  }
  if (instance.inReplyToStatusIdStr != null) {
    writer.writeNameBytes(_$TwitterStatusSchema.nameInReplyToStatusIdStrBytes);
    writer.writeString(instance.inReplyToStatusIdStr!);
  }
  if (instance.inReplyToUserId != null) {
    writer.writeNameBytes(_$TwitterStatusSchema.nameInReplyToUserIdBytes);
    writer.writeInt(instance.inReplyToUserId!);
  }
  if (instance.inReplyToUserIdStr != null) {
    writer.writeNameBytes(_$TwitterStatusSchema.nameInReplyToUserIdStrBytes);
    writer.writeString(instance.inReplyToUserIdStr!);
  }
  if (instance.inReplyToScreenName != null) {
    writer.writeNameBytes(_$TwitterStatusSchema.nameInReplyToScreenNameBytes);
    writer.writeString(instance.inReplyToScreenName!);
  }
  if (instance.user != null) {
    writer.writeNameBytes(_$TwitterStatusSchema.nameUserBytes);
    _$TwitterUserToWriter(instance.user!, writer);
  }
  writer.writeNameBytes(_$TwitterStatusSchema.nameRetweetCountBytes);
  writer.writeInt(instance.retweetCount);
  writer.writeNameBytes(_$TwitterStatusSchema.nameFavoriteCountBytes);
  writer.writeInt(instance.favoriteCount);
  if (instance.entities != null) {
    writer.writeNameBytes(_$TwitterStatusSchema.nameEntitiesBytes);
    _$TwitterEntitiesToWriter(instance.entities!, writer);
  }
  writer.writeNameBytes(_$TwitterStatusSchema.nameFavoritedBytes);
  writer.writeBool(instance.favorited);
  writer.writeNameBytes(_$TwitterStatusSchema.nameRetweetedBytes);
  writer.writeBool(instance.retweeted);
  if (instance.possiblySensitive != null) {
    writer.writeNameBytes(_$TwitterStatusSchema.namePossiblySensitiveBytes);
    writer.writeBool(instance.possiblySensitive!);
  }
  writer.writeNameBytes(_$TwitterStatusSchema.nameLangBytes);
  writer.writeString(instance.lang);
  if (instance.retweetedStatus != null) {
    writer.writeNameBytes(_$TwitterStatusSchema.nameRetweetedStatusBytes);
    _$TwitterStatusToWriter(instance.retweetedStatus!, writer);
  }
  writer.endObject();
}

// =============================================================================
// 1. Unified Schema Descriptor for TwitterSearchMetadata
// =============================================================================
extension type const _$TwitterSearchMetadataSchema(int _value) {
  // String Name Constants
  static const String nameCompletedIn = 'completed_in';
  static const String nameMaxId = 'max_id';
  static const String nameMaxIdStr = 'max_id_str';
  static const String nameNextResults = 'next_results';
  static const String nameQuery = 'query';
  static const String nameRefreshUrl = 'refresh_url';
  static const String nameCount = 'count';
  static const String nameSinceId = 'since_id';
  static const String nameSinceIdStr = 'since_id_str';

  // Pre-Encoded UTF-8 Wire Bytes
  static final Uint8List nameCompletedInBytes = Uint8List.fromList(const [
    99,
    111,
    109,
    112,
    108,
    101,
    116,
    101,
    100,
    95,
    105,
    110,
  ]);
  static final Uint8List nameMaxIdBytes = Uint8List.fromList(const [
    109,
    97,
    120,
    95,
    105,
    100,
  ]);
  static final Uint8List nameMaxIdStrBytes = Uint8List.fromList(const [
    109,
    97,
    120,
    95,
    105,
    100,
    95,
    115,
    116,
    114,
  ]);
  static final Uint8List nameNextResultsBytes = Uint8List.fromList(const [
    110,
    101,
    120,
    116,
    95,
    114,
    101,
    115,
    117,
    108,
    116,
    115,
  ]);
  static final Uint8List nameQueryBytes = Uint8List.fromList(const [
    113,
    117,
    101,
    114,
    121,
  ]);
  static final Uint8List nameRefreshUrlBytes = Uint8List.fromList(const [
    114,
    101,
    102,
    114,
    101,
    115,
    104,
    95,
    117,
    114,
    108,
  ]);
  static final Uint8List nameCountBytes = Uint8List.fromList(const [
    99,
    111,
    117,
    110,
    116,
  ]);
  static final Uint8List nameSinceIdBytes = Uint8List.fromList(const [
    115,
    105,
    110,
    99,
    101,
    95,
    105,
    100,
  ]);
  static final Uint8List nameSinceIdStrBytes = Uint8List.fromList(const [
    115,
    105,
    110,
    99,
    101,
    95,
    105,
    100,
    95,
    115,
    116,
    114,
  ]);

  // Key Indices for selectName()
  static const int keyCompletedIn = 0;
  static const int keyMaxId = 1;
  static const int keyMaxIdStr = 2;
  static const int keyNextResults = 3;
  static const int keyQuery = 4;
  static const int keyRefreshUrl = 5;
  static const int keyCount = 6;
  static const int keySinceId = 7;
  static const int keySinceIdStr = 8;

  // Pre-Compiled JsonKeyOptions
  static final JsonKeyOptions options = JsonKeyOptions.of(const [
    _$TwitterSearchMetadataSchema.nameCompletedIn,
    _$TwitterSearchMetadataSchema.nameMaxId,
    _$TwitterSearchMetadataSchema.nameMaxIdStr,
    _$TwitterSearchMetadataSchema.nameNextResults,
    _$TwitterSearchMetadataSchema.nameQuery,
    _$TwitterSearchMetadataSchema.nameRefreshUrl,
    _$TwitterSearchMetadataSchema.nameCount,
    _$TwitterSearchMetadataSchema.nameSinceId,
    _$TwitterSearchMetadataSchema.nameSinceIdStr,
  ]);
  static final KeyOptions keyOptions = KeyOptions(
    options.keys,
    compiled: options,
  );

  // Bitmask Flags strictly for Required Fields
  static const _$TwitterSearchMetadataSchema none =
      _$TwitterSearchMetadataSchema(0);
  static const int _completedInBit = 1 << 0;
  static const _$TwitterSearchMetadataSchema completedIn =
      _$TwitterSearchMetadataSchema(_completedInBit);
  static const int _maxIdBit = 1 << 1;
  static const _$TwitterSearchMetadataSchema maxId =
      _$TwitterSearchMetadataSchema(_maxIdBit);
  static const int _maxIdStrBit = 1 << 2;
  static const _$TwitterSearchMetadataSchema maxIdStr =
      _$TwitterSearchMetadataSchema(_maxIdStrBit);
  static const int _queryBit = 1 << 3;
  static const _$TwitterSearchMetadataSchema query =
      _$TwitterSearchMetadataSchema(_queryBit);
  static const int _countBit = 1 << 4;
  static const _$TwitterSearchMetadataSchema count =
      _$TwitterSearchMetadataSchema(_countBit);

  // Composite Golden Mask for Required Fields
  static const _$TwitterSearchMetadataSchema golden =
      _$TwitterSearchMetadataSchema(
        _completedInBit | _maxIdBit | _maxIdStrBit | _queryBit | _countBit,
      );

  @pragma('vm:prefer-inline')
  _$TwitterSearchMetadataSchema operator |(
    _$TwitterSearchMetadataSchema other,
  ) => _$TwitterSearchMetadataSchema(_value | other._value);

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
    if ((_value & _completedInBit) == 0) {
      missing.add(nameCompletedIn);
    }
    if ((_value & _maxIdBit) == 0) {
      missing.add(nameMaxId);
    }
    if ((_value & _maxIdStrBit) == 0) {
      missing.add(nameMaxIdStr);
    }
    if ((_value & _queryBit) == 0) {
      missing.add(nameQuery);
    }
    if ((_value & _countBit) == 0) {
      missing.add(nameCount);
    }
    throw CodableException(
      'Missing required fields for TwitterSearchMetadata: ${missing.join(", ")}',
    );
  }
}

// =============================================================================
// 2. Single-Pass Streaming Deserializer for TwitterSearchMetadata
// =============================================================================
TwitterSearchMetadata _$TwitterSearchMetadataFromReader(
  JsonTokenReader reader,
) {
  reader.beginObject();

  double? completedIn;
  int? maxId;
  String? maxIdStr;
  var nextResults = '';
  String? query;
  var refreshUrl = '';
  int? count;
  var sinceId = 0;
  var sinceIdStr = '0';
  var seen = _$TwitterSearchMetadataSchema.none;

  while (reader.hasNext()) {
    switch (reader.selectName(_$TwitterSearchMetadataSchema.options)) {
      case _$TwitterSearchMetadataSchema.keyCompletedIn:
        if ((seen._value & _$TwitterSearchMetadataSchema.completedIn._value) !=
            0) {
          throw const CodableException('Duplicate field "completed_in"');
        }
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          completedIn = reader.readDouble();
          seen |= _$TwitterSearchMetadataSchema.completedIn;
        }
        break;
      case _$TwitterSearchMetadataSchema.keyMaxId:
        if ((seen._value & _$TwitterSearchMetadataSchema.maxId._value) != 0) {
          throw const CodableException('Duplicate field "max_id"');
        }
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          maxId = reader.readInt();
          seen |= _$TwitterSearchMetadataSchema.maxId;
        }
        break;
      case _$TwitterSearchMetadataSchema.keyMaxIdStr:
        if ((seen._value & _$TwitterSearchMetadataSchema.maxIdStr._value) !=
            0) {
          throw const CodableException('Duplicate field "max_id_str"');
        }
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          maxIdStr = reader.readString();
          seen |= _$TwitterSearchMetadataSchema.maxIdStr;
        }
        break;
      case _$TwitterSearchMetadataSchema.keyNextResults:
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          nextResults = reader.readString();
        }
        break;
      case _$TwitterSearchMetadataSchema.keyQuery:
        if ((seen._value & _$TwitterSearchMetadataSchema.query._value) != 0) {
          throw const CodableException('Duplicate field "query"');
        }
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          query = reader.readString();
          seen |= _$TwitterSearchMetadataSchema.query;
        }
        break;
      case _$TwitterSearchMetadataSchema.keyRefreshUrl:
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          refreshUrl = reader.readString();
        }
        break;
      case _$TwitterSearchMetadataSchema.keyCount:
        if ((seen._value & _$TwitterSearchMetadataSchema.count._value) != 0) {
          throw const CodableException('Duplicate field "count"');
        }
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          count = reader.readInt();
          seen |= _$TwitterSearchMetadataSchema.count;
        }
        break;
      case _$TwitterSearchMetadataSchema.keySinceId:
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          sinceId = reader.readInt();
        }
        break;
      case _$TwitterSearchMetadataSchema.keySinceIdStr:
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          sinceIdStr = reader.readString();
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

  return TwitterSearchMetadata(
    completedIn: completedIn!,
    maxId: maxId!,
    maxIdStr: maxIdStr!,
    nextResults: nextResults,
    query: query!,
    refreshUrl: refreshUrl,
    count: count!,
    sinceId: sinceId,
    sinceIdStr: sinceIdStr,
  );
}

// =============================================================================
// 3. Universal Keyed Deserializer for TwitterSearchMetadata
// =============================================================================
TwitterSearchMetadata _$TwitterSearchMetadataFromDecoder(Decoder decoder) {
  final keyed = decoder.keyed();

  double? completedIn;
  int? maxId;
  String? maxIdStr;
  var nextResults = '';
  String? query;
  var refreshUrl = '';
  int? count;
  var sinceId = 0;
  var sinceIdStr = '0';
  var seen = _$TwitterSearchMetadataSchema.none;

  while (keyed.hasNextKey()) {
    switch (keyed.selectKeyIndex(_$TwitterSearchMetadataSchema.keyOptions)) {
      case _$TwitterSearchMetadataSchema.keyCompletedIn:
        if ((seen._value & _$TwitterSearchMetadataSchema.completedIn._value) !=
            0) {
          throw const CodableException('Duplicate field "completed_in"');
        }
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          completedIn = keyed.readDouble();
          seen |= _$TwitterSearchMetadataSchema.completedIn;
        }
        break;
      case _$TwitterSearchMetadataSchema.keyMaxId:
        if ((seen._value & _$TwitterSearchMetadataSchema.maxId._value) != 0) {
          throw const CodableException('Duplicate field "max_id"');
        }
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          maxId = keyed.readInt();
          seen |= _$TwitterSearchMetadataSchema.maxId;
        }
        break;
      case _$TwitterSearchMetadataSchema.keyMaxIdStr:
        if ((seen._value & _$TwitterSearchMetadataSchema.maxIdStr._value) !=
            0) {
          throw const CodableException('Duplicate field "max_id_str"');
        }
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          maxIdStr = keyed.readString();
          seen |= _$TwitterSearchMetadataSchema.maxIdStr;
        }
        break;
      case _$TwitterSearchMetadataSchema.keyNextResults:
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          nextResults = keyed.readString();
        }
        break;
      case _$TwitterSearchMetadataSchema.keyQuery:
        if ((seen._value & _$TwitterSearchMetadataSchema.query._value) != 0) {
          throw const CodableException('Duplicate field "query"');
        }
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          query = keyed.readString();
          seen |= _$TwitterSearchMetadataSchema.query;
        }
        break;
      case _$TwitterSearchMetadataSchema.keyRefreshUrl:
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          refreshUrl = keyed.readString();
        }
        break;
      case _$TwitterSearchMetadataSchema.keyCount:
        if ((seen._value & _$TwitterSearchMetadataSchema.count._value) != 0) {
          throw const CodableException('Duplicate field "count"');
        }
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          count = keyed.readInt();
          seen |= _$TwitterSearchMetadataSchema.count;
        }
        break;
      case _$TwitterSearchMetadataSchema.keySinceId:
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          sinceId = keyed.readInt();
        }
        break;
      case _$TwitterSearchMetadataSchema.keySinceIdStr:
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          sinceIdStr = keyed.readString();
        }
        break;
      default:
        keyed.skipValue();
        break;
    }
  }

  // Inlined fast-path check
  seen.validate();

  return TwitterSearchMetadata(
    completedIn: completedIn!,
    maxId: maxId!,
    maxIdStr: maxIdStr!,
    nextResults: nextResults,
    query: query!,
    refreshUrl: refreshUrl,
    count: count!,
    sinceId: sinceId,
    sinceIdStr: sinceIdStr,
  );
}

// =============================================================================
// 3. Single-Pass Streaming Serializer for TwitterSearchMetadata
// =============================================================================
void _$TwitterSearchMetadataToWriter(
  TwitterSearchMetadata instance,
  JsonTokenWriter writer,
) {
  writer.beginObject();
  writer.writeNameBytes(_$TwitterSearchMetadataSchema.nameCompletedInBytes);
  writer.writeDouble(instance.completedIn);
  writer.writeNameBytes(_$TwitterSearchMetadataSchema.nameMaxIdBytes);
  writer.writeInt(instance.maxId);
  writer.writeNameBytes(_$TwitterSearchMetadataSchema.nameMaxIdStrBytes);
  writer.writeString(instance.maxIdStr);
  writer.writeNameBytes(_$TwitterSearchMetadataSchema.nameNextResultsBytes);
  writer.writeString(instance.nextResults);
  writer.writeNameBytes(_$TwitterSearchMetadataSchema.nameQueryBytes);
  writer.writeString(instance.query);
  writer.writeNameBytes(_$TwitterSearchMetadataSchema.nameRefreshUrlBytes);
  writer.writeString(instance.refreshUrl);
  writer.writeNameBytes(_$TwitterSearchMetadataSchema.nameCountBytes);
  writer.writeInt(instance.count);
  writer.writeNameBytes(_$TwitterSearchMetadataSchema.nameSinceIdBytes);
  writer.writeInt(instance.sinceId);
  writer.writeNameBytes(_$TwitterSearchMetadataSchema.nameSinceIdStrBytes);
  writer.writeString(instance.sinceIdStr);
  writer.endObject();
}

// =============================================================================
// 1. Unified Schema Descriptor for TwitterResponse
// =============================================================================
extension type const _$TwitterResponseSchema(int _value) {
  // String Name Constants
  static const String nameStatuses = 'statuses';
  static const String nameSearchMetadata = 'search_metadata';

  // Pre-Encoded UTF-8 Wire Bytes
  static final Uint8List nameStatusesBytes = Uint8List.fromList(const [
    115,
    116,
    97,
    116,
    117,
    115,
    101,
    115,
  ]);
  static final Uint8List nameSearchMetadataBytes = Uint8List.fromList(const [
    115,
    101,
    97,
    114,
    99,
    104,
    95,
    109,
    101,
    116,
    97,
    100,
    97,
    116,
    97,
  ]);

  // Key Indices for selectName()
  static const int keyStatuses = 0;
  static const int keySearchMetadata = 1;

  // Pre-Compiled JsonKeyOptions
  static final JsonKeyOptions options = JsonKeyOptions.of(const [
    _$TwitterResponseSchema.nameStatuses,
    _$TwitterResponseSchema.nameSearchMetadata,
  ]);
  static final KeyOptions keyOptions = KeyOptions(
    options.keys,
    compiled: options,
  );

  // Bitmask Flags strictly for Required Fields
  static const _$TwitterResponseSchema none = _$TwitterResponseSchema(0);
  static const int _searchMetadataBit = 1 << 0;
  static const _$TwitterResponseSchema searchMetadata = _$TwitterResponseSchema(
    _searchMetadataBit,
  );

  // Composite Golden Mask for Required Fields
  static const _$TwitterResponseSchema golden = _$TwitterResponseSchema(
    _searchMetadataBit,
  );

  @pragma('vm:prefer-inline')
  _$TwitterResponseSchema operator |(_$TwitterResponseSchema other) =>
      _$TwitterResponseSchema(_value | other._value);

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
    if ((_value & _searchMetadataBit) == 0) {
      missing.add(nameSearchMetadata);
    }
    throw CodableException(
      'Missing required fields for TwitterResponse: ${missing.join(", ")}',
    );
  }
}

// =============================================================================
// 2. Single-Pass Streaming Deserializer for TwitterResponse
// =============================================================================
TwitterResponse _$TwitterResponseFromReader(JsonTokenReader reader) {
  reader.beginObject();

  var statuses = const <TwitterStatus>[];
  TwitterSearchMetadata? searchMetadata;
  var seen = _$TwitterResponseSchema.none;

  while (reader.hasNext()) {
    switch (reader.selectName(_$TwitterResponseSchema.options)) {
      case _$TwitterResponseSchema.keyStatuses:
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          reader.beginArray();
          final list = <TwitterStatus>[];
          while (reader.hasNext()) {
            list.add(_$TwitterStatusFromReader(reader));
          }
          reader.endArray();
          statuses = list;
        }
        break;
      case _$TwitterResponseSchema.keySearchMetadata:
        if ((seen._value & _$TwitterResponseSchema.searchMetadata._value) !=
            0) {
          throw const CodableException('Duplicate field "search_metadata"');
        }
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          searchMetadata = _$TwitterSearchMetadataFromReader(reader);
          seen |= _$TwitterResponseSchema.searchMetadata;
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

  return TwitterResponse(statuses: statuses, searchMetadata: searchMetadata!);
}

// =============================================================================
// 3. Universal Keyed Deserializer for TwitterResponse
// =============================================================================
TwitterResponse _$TwitterResponseFromDecoder(Decoder decoder) {
  final keyed = decoder.keyed();

  var statuses = const <TwitterStatus>[];
  TwitterSearchMetadata? searchMetadata;
  var seen = _$TwitterResponseSchema.none;

  while (keyed.hasNextKey()) {
    switch (keyed.selectKeyIndex(_$TwitterResponseSchema.keyOptions)) {
      case _$TwitterResponseSchema.keyStatuses:
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          statuses = keyed.decodeList(_$TwitterStatusFromDecoder);
        }
        break;
      case _$TwitterResponseSchema.keySearchMetadata:
        if ((seen._value & _$TwitterResponseSchema.searchMetadata._value) !=
            0) {
          throw const CodableException('Duplicate field "search_metadata"');
        }
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          searchMetadata = keyed.decodeValue(
            _$TwitterSearchMetadataFromDecoder,
          );
          seen |= _$TwitterResponseSchema.searchMetadata;
        }
        break;
      default:
        keyed.skipValue();
        break;
    }
  }

  // Inlined fast-path check
  seen.validate();

  return TwitterResponse(statuses: statuses, searchMetadata: searchMetadata!);
}

// =============================================================================
// 3. Single-Pass Streaming Serializer for TwitterResponse
// =============================================================================
void _$TwitterResponseToWriter(
  TwitterResponse instance,
  JsonTokenWriter writer,
) {
  writer.beginObject();
  writer.writeNameBytes(_$TwitterResponseSchema.nameStatusesBytes);
  writer.beginArray();
  for (final item in instance.statuses) {
    _$TwitterStatusToWriter(item, writer);
  }
  writer.endArray();
  writer.writeNameBytes(_$TwitterResponseSchema.nameSearchMetadataBytes);
  _$TwitterSearchMetadataToWriter(instance.searchMetadata, writer);
  writer.endObject();
}
