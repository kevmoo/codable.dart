// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: lines_longer_than_80_chars, unnecessary_lambdas, deprecated_member_use, unused_element

part of 'twitter.dart';

// =============================================================================
// 1. Unified Schema Descriptor for TwitterMetadata
// =============================================================================
extension type const _$TwitterMetadataSchema(int _value) {
  // String Name Constants
  static const String nameResultType = 'result_type';
  static const String nameIsoLanguageCode = 'iso_language_code';

  // Pre-encoded UTF-8 Wire Name Bytes and StaticKeys
  static const List<int> wireNameBytesResultType = [
    34,
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
    34,
  ];
  static const StaticKey staticKeyResultType = StaticKey(
    nameResultType,
    keyResultType,
    wireNameBytesResultType,
  );
  static const List<int> wireNameBytesIsoLanguageCode = [
    34,
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
    34,
  ];
  static const StaticKey staticKeyIsoLanguageCode = StaticKey(
    nameIsoLanguageCode,
    keyIsoLanguageCode,
    wireNameBytesIsoLanguageCode,
  );

  // Key Indices for selectKeyIndex()
  static const int keyResultType = 0;
  static const int keyIsoLanguageCode = 1;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
    _$TwitterMetadataSchema.nameResultType,
    _$TwitterMetadataSchema.nameIsoLanguageCode,
  ]);
  static final KeyOptions keyOptions = options;

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
// 2. Universal Keyed Deserializer for TwitterMetadata
// =============================================================================
TwitterMetadata _$TwitterMetadataFromDecoder(Decoder decoder) {
  final keyed = decoder.keyed(options: _$TwitterMetadataSchema.keyOptions);

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
// 2b. Universal List Deserializer for TwitterMetadata
// =============================================================================
List<TwitterMetadata> _$TwitterMetadataListFromDecoder(Decoder decoder) {
  final unkeyed = decoder.unkeyed();
  final list = <TwitterMetadata>[];
  while (unkeyed.hasNext()) {
    list.add(_$TwitterMetadataFromDecoder(unkeyed.nestedDecoder()));
  }
  return list;
}

// =============================================================================
// 3. Universal Serializer for TwitterMetadata
// =============================================================================
void _$TwitterMetadataToEncoder(TwitterMetadata instance, Encoder encoder) {
  final keyed = encoder.keyed();
  keyed.encodeStringKey(
    _$TwitterMetadataSchema.staticKeyResultType,
    instance.resultType,
  );
  keyed.encodeStringKey(
    _$TwitterMetadataSchema.staticKeyIsoLanguageCode,
    instance.isoLanguageCode,
  );
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

  // Pre-encoded UTF-8 Wire Name Bytes and StaticKeys
  static const List<int> wireNameBytesScreenName = [
    34,
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
    34,
  ];
  static const StaticKey staticKeyScreenName = StaticKey(
    nameScreenName,
    keyScreenName,
    wireNameBytesScreenName,
  );
  static const List<int> wireNameBytesName = [34, 110, 97, 109, 101, 34];
  static const StaticKey staticKeyName = StaticKey(
    nameName,
    keyName,
    wireNameBytesName,
  );
  static const List<int> wireNameBytesId = [34, 105, 100, 34];
  static const StaticKey staticKeyId = StaticKey(
    nameId,
    keyId,
    wireNameBytesId,
  );
  static const List<int> wireNameBytesIdStr = [
    34,
    105,
    100,
    95,
    115,
    116,
    114,
    34,
  ];
  static const StaticKey staticKeyIdStr = StaticKey(
    nameIdStr,
    keyIdStr,
    wireNameBytesIdStr,
  );
  static const List<int> wireNameBytesIndices = [
    34,
    105,
    110,
    100,
    105,
    99,
    101,
    115,
    34,
  ];
  static const StaticKey staticKeyIndices = StaticKey(
    nameIndices,
    keyIndices,
    wireNameBytesIndices,
  );

  // Key Indices for selectKeyIndex()
  static const int keyScreenName = 0;
  static const int keyName = 1;
  static const int keyId = 2;
  static const int keyIdStr = 3;
  static const int keyIndices = 4;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
    _$TwitterUserMentionSchema.nameScreenName,
    _$TwitterUserMentionSchema.nameName,
    _$TwitterUserMentionSchema.nameId,
    _$TwitterUserMentionSchema.nameIdStr,
    _$TwitterUserMentionSchema.nameIndices,
  ]);
  static final KeyOptions keyOptions = options;

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

  // Combined Golden Bitmask for fast single-instruction check
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
// 2. Universal Keyed Deserializer for TwitterUserMention
// =============================================================================
TwitterUserMention _$TwitterUserMentionFromDecoder(Decoder decoder) {
  final keyed = decoder.keyed(options: _$TwitterUserMentionSchema.keyOptions);

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
// 2b. Universal List Deserializer for TwitterUserMention
// =============================================================================
List<TwitterUserMention> _$TwitterUserMentionListFromDecoder(Decoder decoder) {
  final unkeyed = decoder.unkeyed();
  final list = <TwitterUserMention>[];
  while (unkeyed.hasNext()) {
    list.add(_$TwitterUserMentionFromDecoder(unkeyed.nestedDecoder()));
  }
  return list;
}

// =============================================================================
// 3. Universal Serializer for TwitterUserMention
// =============================================================================
void _$TwitterUserMentionToEncoder(
  TwitterUserMention instance,
  Encoder encoder,
) {
  final keyed = encoder.keyed();
  keyed.encodeStringKey(
    _$TwitterUserMentionSchema.staticKeyScreenName,
    instance.screenName,
  );
  keyed.encodeStringKey(
    _$TwitterUserMentionSchema.staticKeyName,
    instance.name,
  );
  keyed.encodeIntKey(_$TwitterUserMentionSchema.staticKeyId, instance.id);
  keyed.encodeStringKey(
    _$TwitterUserMentionSchema.staticKeyIdStr,
    instance.idStr,
  );
  keyed.encodeIntListKey(
    _$TwitterUserMentionSchema.staticKeyIndices,
    instance.indices,
  );
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

  // Pre-encoded UTF-8 Wire Name Bytes and StaticKeys
  static const List<int> wireNameBytesUrl = [34, 117, 114, 108, 34];
  static const StaticKey staticKeyUrl = StaticKey(
    nameUrl,
    keyUrl,
    wireNameBytesUrl,
  );
  static const List<int> wireNameBytesExpandedUrl = [
    34,
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
    34,
  ];
  static const StaticKey staticKeyExpandedUrl = StaticKey(
    nameExpandedUrl,
    keyExpandedUrl,
    wireNameBytesExpandedUrl,
  );
  static const List<int> wireNameBytesDisplayUrl = [
    34,
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
    34,
  ];
  static const StaticKey staticKeyDisplayUrl = StaticKey(
    nameDisplayUrl,
    keyDisplayUrl,
    wireNameBytesDisplayUrl,
  );
  static const List<int> wireNameBytesIndices = [
    34,
    105,
    110,
    100,
    105,
    99,
    101,
    115,
    34,
  ];
  static const StaticKey staticKeyIndices = StaticKey(
    nameIndices,
    keyIndices,
    wireNameBytesIndices,
  );

  // Key Indices for selectKeyIndex()
  static const int keyUrl = 0;
  static const int keyExpandedUrl = 1;
  static const int keyDisplayUrl = 2;
  static const int keyIndices = 3;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
    _$TwitterUrlSchema.nameUrl,
    _$TwitterUrlSchema.nameExpandedUrl,
    _$TwitterUrlSchema.nameDisplayUrl,
    _$TwitterUrlSchema.nameIndices,
  ]);
  static final KeyOptions keyOptions = options;

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

  // Combined Golden Bitmask for fast single-instruction check
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
// 2. Universal Keyed Deserializer for TwitterUrl
// =============================================================================
TwitterUrl _$TwitterUrlFromDecoder(Decoder decoder) {
  final keyed = decoder.keyed(options: _$TwitterUrlSchema.keyOptions);

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
// 2b. Universal List Deserializer for TwitterUrl
// =============================================================================
List<TwitterUrl> _$TwitterUrlListFromDecoder(Decoder decoder) {
  final unkeyed = decoder.unkeyed();
  final list = <TwitterUrl>[];
  while (unkeyed.hasNext()) {
    list.add(_$TwitterUrlFromDecoder(unkeyed.nestedDecoder()));
  }
  return list;
}

// =============================================================================
// 3. Universal Serializer for TwitterUrl
// =============================================================================
void _$TwitterUrlToEncoder(TwitterUrl instance, Encoder encoder) {
  final keyed = encoder.keyed();
  keyed.encodeStringKey(_$TwitterUrlSchema.staticKeyUrl, instance.url);
  keyed.encodeStringKey(
    _$TwitterUrlSchema.staticKeyExpandedUrl,
    instance.expandedUrl,
  );
  keyed.encodeStringKey(
    _$TwitterUrlSchema.staticKeyDisplayUrl,
    instance.displayUrl,
  );
  keyed.encodeIntListKey(_$TwitterUrlSchema.staticKeyIndices, instance.indices);
}

// =============================================================================
// 1. Unified Schema Descriptor for TwitterEntitiesUrls
// =============================================================================
extension type const _$TwitterEntitiesUrlsSchema(int _value) {
  // String Name Constants
  static const String nameUrls = 'urls';

  // Pre-encoded UTF-8 Wire Name Bytes and StaticKeys
  static const List<int> wireNameBytesUrls = [34, 117, 114, 108, 115, 34];
  static const StaticKey staticKeyUrls = StaticKey(
    nameUrls,
    keyUrls,
    wireNameBytesUrls,
  );

  // Key Indices for selectKeyIndex()
  static const int keyUrls = 0;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
    _$TwitterEntitiesUrlsSchema.nameUrls,
  ]);
  static final KeyOptions keyOptions = options;

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
// 2. Universal Keyed Deserializer for TwitterEntitiesUrls
// =============================================================================
TwitterEntitiesUrls _$TwitterEntitiesUrlsFromDecoder(Decoder decoder) {
  final keyed = decoder.keyed(options: _$TwitterEntitiesUrlsSchema.keyOptions);

  var urls = const <TwitterUrl>[];
  var seen = _$TwitterEntitiesUrlsSchema.none;

  while (keyed.hasNextKey()) {
    switch (keyed.selectKeyIndex(_$TwitterEntitiesUrlsSchema.keyOptions)) {
      case _$TwitterEntitiesUrlsSchema.keyUrls:
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          urls = _$TwitterUrlListFromDecoder(keyed.nestedDecoder());
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
// 2b. Universal List Deserializer for TwitterEntitiesUrls
// =============================================================================
List<TwitterEntitiesUrls> _$TwitterEntitiesUrlsListFromDecoder(
  Decoder decoder,
) {
  final unkeyed = decoder.unkeyed();
  final list = <TwitterEntitiesUrls>[];
  while (unkeyed.hasNext()) {
    list.add(_$TwitterEntitiesUrlsFromDecoder(unkeyed.nestedDecoder()));
  }
  return list;
}

// =============================================================================
// 3. Universal Serializer for TwitterEntitiesUrls
// =============================================================================
void _$TwitterEntitiesUrlsToEncoder(
  TwitterEntitiesUrls instance,
  Encoder encoder,
) {
  final keyed = encoder.keyed();
  keyed.encodeListKey(
    _$TwitterEntitiesUrlsSchema.staticKeyUrls,
    instance.urls,
    _$TwitterUrlToEncoder,
  );
}

// =============================================================================
// 1. Unified Schema Descriptor for TwitterUserEntities
// =============================================================================
extension type const _$TwitterUserEntitiesSchema(int _value) {
  // String Name Constants
  static const String nameUrl = 'url';
  static const String nameDescription = 'description';

  // Pre-encoded UTF-8 Wire Name Bytes and StaticKeys
  static const List<int> wireNameBytesUrl = [34, 117, 114, 108, 34];
  static const StaticKey staticKeyUrl = StaticKey(
    nameUrl,
    keyUrl,
    wireNameBytesUrl,
  );
  static const List<int> wireNameBytesDescription = [
    34,
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
    34,
  ];
  static const StaticKey staticKeyDescription = StaticKey(
    nameDescription,
    keyDescription,
    wireNameBytesDescription,
  );

  // Key Indices for selectKeyIndex()
  static const int keyUrl = 0;
  static const int keyDescription = 1;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
    _$TwitterUserEntitiesSchema.nameUrl,
    _$TwitterUserEntitiesSchema.nameDescription,
  ]);
  static final KeyOptions keyOptions = options;

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
// 2. Universal Keyed Deserializer for TwitterUserEntities
// =============================================================================
TwitterUserEntities _$TwitterUserEntitiesFromDecoder(Decoder decoder) {
  final keyed = decoder.keyed(options: _$TwitterUserEntitiesSchema.keyOptions);

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
          url = _$TwitterEntitiesUrlsFromDecoder(keyed.nestedDecoder());
        }
        break;
      case _$TwitterUserEntitiesSchema.keyDescription:
        if (keyed.isNextNull()) {
          keyed.readNull();
          description = null;
        } else {
          description = _$TwitterEntitiesUrlsFromDecoder(keyed.nestedDecoder());
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
// 2b. Universal List Deserializer for TwitterUserEntities
// =============================================================================
List<TwitterUserEntities> _$TwitterUserEntitiesListFromDecoder(
  Decoder decoder,
) {
  final unkeyed = decoder.unkeyed();
  final list = <TwitterUserEntities>[];
  while (unkeyed.hasNext()) {
    list.add(_$TwitterUserEntitiesFromDecoder(unkeyed.nestedDecoder()));
  }
  return list;
}

// =============================================================================
// 3. Universal Serializer for TwitterUserEntities
// =============================================================================
void _$TwitterUserEntitiesToEncoder(
  TwitterUserEntities instance,
  Encoder encoder,
) {
  final keyed = encoder.keyed();
  if (instance.url != null) {
    keyed.encodeValueKey(
      _$TwitterUserEntitiesSchema.staticKeyUrl,
      instance.url!,
      _$TwitterEntitiesUrlsToEncoder,
    );
  }
  if (instance.description != null) {
    keyed.encodeValueKey(
      _$TwitterUserEntitiesSchema.staticKeyDescription,
      instance.description!,
      _$TwitterEntitiesUrlsToEncoder,
    );
  }
}

// =============================================================================
// 1. Unified Schema Descriptor for TwitterEntities
// =============================================================================
extension type const _$TwitterEntitiesSchema(int _value) {
  // String Name Constants
  static const String nameUrls = 'urls';
  static const String nameUserMentions = 'user_mentions';

  // Pre-encoded UTF-8 Wire Name Bytes and StaticKeys
  static const List<int> wireNameBytesUrls = [34, 117, 114, 108, 115, 34];
  static const StaticKey staticKeyUrls = StaticKey(
    nameUrls,
    keyUrls,
    wireNameBytesUrls,
  );
  static const List<int> wireNameBytesUserMentions = [
    34,
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
    34,
  ];
  static const StaticKey staticKeyUserMentions = StaticKey(
    nameUserMentions,
    keyUserMentions,
    wireNameBytesUserMentions,
  );

  // Key Indices for selectKeyIndex()
  static const int keyUrls = 0;
  static const int keyUserMentions = 1;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
    _$TwitterEntitiesSchema.nameUrls,
    _$TwitterEntitiesSchema.nameUserMentions,
  ]);
  static final KeyOptions keyOptions = options;

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
// 2. Universal Keyed Deserializer for TwitterEntities
// =============================================================================
TwitterEntities _$TwitterEntitiesFromDecoder(Decoder decoder) {
  final keyed = decoder.keyed(options: _$TwitterEntitiesSchema.keyOptions);

  var urls = const <TwitterUrl>[];
  var userMentions = const <TwitterUserMention>[];
  var seen = _$TwitterEntitiesSchema.none;

  while (keyed.hasNextKey()) {
    switch (keyed.selectKeyIndex(_$TwitterEntitiesSchema.keyOptions)) {
      case _$TwitterEntitiesSchema.keyUrls:
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          urls = _$TwitterUrlListFromDecoder(keyed.nestedDecoder());
        }
        break;
      case _$TwitterEntitiesSchema.keyUserMentions:
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          userMentions = _$TwitterUserMentionListFromDecoder(
            keyed.nestedDecoder(),
          );
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
// 2b. Universal List Deserializer for TwitterEntities
// =============================================================================
List<TwitterEntities> _$TwitterEntitiesListFromDecoder(Decoder decoder) {
  final unkeyed = decoder.unkeyed();
  final list = <TwitterEntities>[];
  while (unkeyed.hasNext()) {
    list.add(_$TwitterEntitiesFromDecoder(unkeyed.nestedDecoder()));
  }
  return list;
}

// =============================================================================
// 3. Universal Serializer for TwitterEntities
// =============================================================================
void _$TwitterEntitiesToEncoder(TwitterEntities instance, Encoder encoder) {
  final keyed = encoder.keyed();
  keyed.encodeListKey(
    _$TwitterEntitiesSchema.staticKeyUrls,
    instance.urls,
    _$TwitterUrlToEncoder,
  );
  keyed.encodeListKey(
    _$TwitterEntitiesSchema.staticKeyUserMentions,
    instance.userMentions,
    _$TwitterUserMentionToEncoder,
  );
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

  // Pre-encoded UTF-8 Wire Name Bytes and StaticKeys
  static const List<int> wireNameBytesId = [34, 105, 100, 34];
  static const StaticKey staticKeyId = StaticKey(
    nameId,
    keyId,
    wireNameBytesId,
  );
  static const List<int> wireNameBytesIdStr = [
    34,
    105,
    100,
    95,
    115,
    116,
    114,
    34,
  ];
  static const StaticKey staticKeyIdStr = StaticKey(
    nameIdStr,
    keyIdStr,
    wireNameBytesIdStr,
  );
  static const List<int> wireNameBytesName = [34, 110, 97, 109, 101, 34];
  static const StaticKey staticKeyName = StaticKey(
    nameName,
    keyName,
    wireNameBytesName,
  );
  static const List<int> wireNameBytesScreenName = [
    34,
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
    34,
  ];
  static const StaticKey staticKeyScreenName = StaticKey(
    nameScreenName,
    keyScreenName,
    wireNameBytesScreenName,
  );
  static const List<int> wireNameBytesLocation = [
    34,
    108,
    111,
    99,
    97,
    116,
    105,
    111,
    110,
    34,
  ];
  static const StaticKey staticKeyLocation = StaticKey(
    nameLocation,
    keyLocation,
    wireNameBytesLocation,
  );
  static const List<int> wireNameBytesDescription = [
    34,
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
    34,
  ];
  static const StaticKey staticKeyDescription = StaticKey(
    nameDescription,
    keyDescription,
    wireNameBytesDescription,
  );
  static const List<int> wireNameBytesUrl = [34, 117, 114, 108, 34];
  static const StaticKey staticKeyUrl = StaticKey(
    nameUrl,
    keyUrl,
    wireNameBytesUrl,
  );
  static const List<int> wireNameBytesEntities = [
    34,
    101,
    110,
    116,
    105,
    116,
    105,
    101,
    115,
    34,
  ];
  static const StaticKey staticKeyEntities = StaticKey(
    nameEntities,
    keyEntities,
    wireNameBytesEntities,
  );
  static const List<int> wireNameBytesProtected = [
    34,
    112,
    114,
    111,
    116,
    101,
    99,
    116,
    101,
    100,
    34,
  ];
  static const StaticKey staticKeyProtected = StaticKey(
    nameProtected,
    keyProtected,
    wireNameBytesProtected,
  );
  static const List<int> wireNameBytesFollowersCount = [
    34,
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
    34,
  ];
  static const StaticKey staticKeyFollowersCount = StaticKey(
    nameFollowersCount,
    keyFollowersCount,
    wireNameBytesFollowersCount,
  );
  static const List<int> wireNameBytesFriendsCount = [
    34,
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
    34,
  ];
  static const StaticKey staticKeyFriendsCount = StaticKey(
    nameFriendsCount,
    keyFriendsCount,
    wireNameBytesFriendsCount,
  );
  static const List<int> wireNameBytesListedCount = [
    34,
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
    34,
  ];
  static const StaticKey staticKeyListedCount = StaticKey(
    nameListedCount,
    keyListedCount,
    wireNameBytesListedCount,
  );
  static const List<int> wireNameBytesCreatedAt = [
    34,
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
    34,
  ];
  static const StaticKey staticKeyCreatedAt = StaticKey(
    nameCreatedAt,
    keyCreatedAt,
    wireNameBytesCreatedAt,
  );
  static const List<int> wireNameBytesFavouritesCount = [
    34,
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
    34,
  ];
  static const StaticKey staticKeyFavouritesCount = StaticKey(
    nameFavouritesCount,
    keyFavouritesCount,
    wireNameBytesFavouritesCount,
  );
  static const List<int> wireNameBytesUtcOffset = [
    34,
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
    34,
  ];
  static const StaticKey staticKeyUtcOffset = StaticKey(
    nameUtcOffset,
    keyUtcOffset,
    wireNameBytesUtcOffset,
  );
  static const List<int> wireNameBytesTimeZone = [
    34,
    116,
    105,
    109,
    101,
    95,
    122,
    111,
    110,
    101,
    34,
  ];
  static const StaticKey staticKeyTimeZone = StaticKey(
    nameTimeZone,
    keyTimeZone,
    wireNameBytesTimeZone,
  );
  static const List<int> wireNameBytesGeoEnabled = [
    34,
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
    34,
  ];
  static const StaticKey staticKeyGeoEnabled = StaticKey(
    nameGeoEnabled,
    keyGeoEnabled,
    wireNameBytesGeoEnabled,
  );
  static const List<int> wireNameBytesVerified = [
    34,
    118,
    101,
    114,
    105,
    102,
    105,
    101,
    100,
    34,
  ];
  static const StaticKey staticKeyVerified = StaticKey(
    nameVerified,
    keyVerified,
    wireNameBytesVerified,
  );
  static const List<int> wireNameBytesStatusesCount = [
    34,
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
    34,
  ];
  static const StaticKey staticKeyStatusesCount = StaticKey(
    nameStatusesCount,
    keyStatusesCount,
    wireNameBytesStatusesCount,
  );
  static const List<int> wireNameBytesLang = [34, 108, 97, 110, 103, 34];
  static const StaticKey staticKeyLang = StaticKey(
    nameLang,
    keyLang,
    wireNameBytesLang,
  );
  static const List<int> wireNameBytesContributorsEnabled = [
    34,
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
    34,
  ];
  static const StaticKey staticKeyContributorsEnabled = StaticKey(
    nameContributorsEnabled,
    keyContributorsEnabled,
    wireNameBytesContributorsEnabled,
  );
  static const List<int> wireNameBytesIsTranslator = [
    34,
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
    34,
  ];
  static const StaticKey staticKeyIsTranslator = StaticKey(
    nameIsTranslator,
    keyIsTranslator,
    wireNameBytesIsTranslator,
  );
  static const List<int> wireNameBytesIsTranslationEnabled = [
    34,
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
    34,
  ];
  static const StaticKey staticKeyIsTranslationEnabled = StaticKey(
    nameIsTranslationEnabled,
    keyIsTranslationEnabled,
    wireNameBytesIsTranslationEnabled,
  );
  static const List<int> wireNameBytesProfileBackgroundColor = [
    34,
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
    34,
  ];
  static const StaticKey staticKeyProfileBackgroundColor = StaticKey(
    nameProfileBackgroundColor,
    keyProfileBackgroundColor,
    wireNameBytesProfileBackgroundColor,
  );
  static const List<int> wireNameBytesProfileBackgroundImageUrl = [
    34,
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
    34,
  ];
  static const StaticKey staticKeyProfileBackgroundImageUrl = StaticKey(
    nameProfileBackgroundImageUrl,
    keyProfileBackgroundImageUrl,
    wireNameBytesProfileBackgroundImageUrl,
  );
  static const List<int> wireNameBytesProfileBackgroundImageUrlHttps = [
    34,
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
    34,
  ];
  static const StaticKey staticKeyProfileBackgroundImageUrlHttps = StaticKey(
    nameProfileBackgroundImageUrlHttps,
    keyProfileBackgroundImageUrlHttps,
    wireNameBytesProfileBackgroundImageUrlHttps,
  );
  static const List<int> wireNameBytesProfileBackgroundTile = [
    34,
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
    34,
  ];
  static const StaticKey staticKeyProfileBackgroundTile = StaticKey(
    nameProfileBackgroundTile,
    keyProfileBackgroundTile,
    wireNameBytesProfileBackgroundTile,
  );
  static const List<int> wireNameBytesProfileImageUrl = [
    34,
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
    34,
  ];
  static const StaticKey staticKeyProfileImageUrl = StaticKey(
    nameProfileImageUrl,
    keyProfileImageUrl,
    wireNameBytesProfileImageUrl,
  );
  static const List<int> wireNameBytesProfileImageUrlHttps = [
    34,
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
    34,
  ];
  static const StaticKey staticKeyProfileImageUrlHttps = StaticKey(
    nameProfileImageUrlHttps,
    keyProfileImageUrlHttps,
    wireNameBytesProfileImageUrlHttps,
  );
  static const List<int> wireNameBytesProfileBannerUrl = [
    34,
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
    34,
  ];
  static const StaticKey staticKeyProfileBannerUrl = StaticKey(
    nameProfileBannerUrl,
    keyProfileBannerUrl,
    wireNameBytesProfileBannerUrl,
  );
  static const List<int> wireNameBytesProfileLinkColor = [
    34,
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
    34,
  ];
  static const StaticKey staticKeyProfileLinkColor = StaticKey(
    nameProfileLinkColor,
    keyProfileLinkColor,
    wireNameBytesProfileLinkColor,
  );
  static const List<int> wireNameBytesProfileSidebarBorderColor = [
    34,
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
    34,
  ];
  static const StaticKey staticKeyProfileSidebarBorderColor = StaticKey(
    nameProfileSidebarBorderColor,
    keyProfileSidebarBorderColor,
    wireNameBytesProfileSidebarBorderColor,
  );
  static const List<int> wireNameBytesProfileSidebarFillColor = [
    34,
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
    34,
  ];
  static const StaticKey staticKeyProfileSidebarFillColor = StaticKey(
    nameProfileSidebarFillColor,
    keyProfileSidebarFillColor,
    wireNameBytesProfileSidebarFillColor,
  );
  static const List<int> wireNameBytesProfileTextColor = [
    34,
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
    34,
  ];
  static const StaticKey staticKeyProfileTextColor = StaticKey(
    nameProfileTextColor,
    keyProfileTextColor,
    wireNameBytesProfileTextColor,
  );
  static const List<int> wireNameBytesProfileUseBackgroundImage = [
    34,
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
    34,
  ];
  static const StaticKey staticKeyProfileUseBackgroundImage = StaticKey(
    nameProfileUseBackgroundImage,
    keyProfileUseBackgroundImage,
    wireNameBytesProfileUseBackgroundImage,
  );
  static const List<int> wireNameBytesDefaultProfile = [
    34,
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
    34,
  ];
  static const StaticKey staticKeyDefaultProfile = StaticKey(
    nameDefaultProfile,
    keyDefaultProfile,
    wireNameBytesDefaultProfile,
  );
  static const List<int> wireNameBytesDefaultProfileImage = [
    34,
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
    34,
  ];
  static const StaticKey staticKeyDefaultProfileImage = StaticKey(
    nameDefaultProfileImage,
    keyDefaultProfileImage,
    wireNameBytesDefaultProfileImage,
  );
  static const List<int> wireNameBytesFollowing = [
    34,
    102,
    111,
    108,
    108,
    111,
    119,
    105,
    110,
    103,
    34,
  ];
  static const StaticKey staticKeyFollowing = StaticKey(
    nameFollowing,
    keyFollowing,
    wireNameBytesFollowing,
  );
  static const List<int> wireNameBytesFollowRequestSent = [
    34,
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
    34,
  ];
  static const StaticKey staticKeyFollowRequestSent = StaticKey(
    nameFollowRequestSent,
    keyFollowRequestSent,
    wireNameBytesFollowRequestSent,
  );
  static const List<int> wireNameBytesNotifications = [
    34,
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
    34,
  ];
  static const StaticKey staticKeyNotifications = StaticKey(
    nameNotifications,
    keyNotifications,
    wireNameBytesNotifications,
  );

  // Key Indices for selectKeyIndex()
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

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
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
  static final KeyOptions keyOptions = options;

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

  // Combined Golden Bitmask for fast single-instruction check
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
// 2. Universal Keyed Deserializer for TwitterUser
// =============================================================================
TwitterUser _$TwitterUserFromDecoder(Decoder decoder) {
  final keyed = decoder.keyed(options: _$TwitterUserSchema.keyOptions);

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
          entities = _$TwitterUserEntitiesFromDecoder(keyed.nestedDecoder());
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
// 2b. Universal List Deserializer for TwitterUser
// =============================================================================
List<TwitterUser> _$TwitterUserListFromDecoder(Decoder decoder) {
  final unkeyed = decoder.unkeyed();
  final list = <TwitterUser>[];
  while (unkeyed.hasNext()) {
    list.add(_$TwitterUserFromDecoder(unkeyed.nestedDecoder()));
  }
  return list;
}

// =============================================================================
// 3. Universal Serializer for TwitterUser
// =============================================================================
void _$TwitterUserToEncoder(TwitterUser instance, Encoder encoder) {
  final keyed = encoder.keyed();
  keyed.encodeIntKey(_$TwitterUserSchema.staticKeyId, instance.id);
  keyed.encodeStringKey(_$TwitterUserSchema.staticKeyIdStr, instance.idStr);
  keyed.encodeStringKey(_$TwitterUserSchema.staticKeyName, instance.name);
  keyed.encodeStringKey(
    _$TwitterUserSchema.staticKeyScreenName,
    instance.screenName,
  );
  keyed.encodeStringKey(
    _$TwitterUserSchema.staticKeyLocation,
    instance.location,
  );
  keyed.encodeStringKey(
    _$TwitterUserSchema.staticKeyDescription,
    instance.description,
  );
  if (instance.url != null) {
    keyed.encodeStringKey(_$TwitterUserSchema.staticKeyUrl, instance.url!);
  }
  if (instance.entities != null) {
    keyed.encodeValueKey(
      _$TwitterUserSchema.staticKeyEntities,
      instance.entities!,
      _$TwitterUserEntitiesToEncoder,
    );
  }
  keyed.encodeBoolKey(
    _$TwitterUserSchema.staticKeyProtected,
    instance.protected,
  );
  keyed.encodeIntKey(
    _$TwitterUserSchema.staticKeyFollowersCount,
    instance.followersCount,
  );
  keyed.encodeIntKey(
    _$TwitterUserSchema.staticKeyFriendsCount,
    instance.friendsCount,
  );
  keyed.encodeIntKey(
    _$TwitterUserSchema.staticKeyListedCount,
    instance.listedCount,
  );
  keyed.encodeStringKey(
    _$TwitterUserSchema.staticKeyCreatedAt,
    instance.createdAt,
  );
  keyed.encodeIntKey(
    _$TwitterUserSchema.staticKeyFavouritesCount,
    instance.favouritesCount,
  );
  if (instance.utcOffset != null) {
    keyed.encodeIntKey(
      _$TwitterUserSchema.staticKeyUtcOffset,
      instance.utcOffset!,
    );
  }
  if (instance.timeZone != null) {
    keyed.encodeStringKey(
      _$TwitterUserSchema.staticKeyTimeZone,
      instance.timeZone!,
    );
  }
  keyed.encodeBoolKey(
    _$TwitterUserSchema.staticKeyGeoEnabled,
    instance.geoEnabled,
  );
  keyed.encodeBoolKey(_$TwitterUserSchema.staticKeyVerified, instance.verified);
  keyed.encodeIntKey(
    _$TwitterUserSchema.staticKeyStatusesCount,
    instance.statusesCount,
  );
  keyed.encodeStringKey(_$TwitterUserSchema.staticKeyLang, instance.lang);
  keyed.encodeBoolKey(
    _$TwitterUserSchema.staticKeyContributorsEnabled,
    instance.contributorsEnabled,
  );
  keyed.encodeBoolKey(
    _$TwitterUserSchema.staticKeyIsTranslator,
    instance.isTranslator,
  );
  keyed.encodeBoolKey(
    _$TwitterUserSchema.staticKeyIsTranslationEnabled,
    instance.isTranslationEnabled,
  );
  keyed.encodeStringKey(
    _$TwitterUserSchema.staticKeyProfileBackgroundColor,
    instance.profileBackgroundColor,
  );
  keyed.encodeStringKey(
    _$TwitterUserSchema.staticKeyProfileBackgroundImageUrl,
    instance.profileBackgroundImageUrl,
  );
  keyed.encodeStringKey(
    _$TwitterUserSchema.staticKeyProfileBackgroundImageUrlHttps,
    instance.profileBackgroundImageUrlHttps,
  );
  keyed.encodeBoolKey(
    _$TwitterUserSchema.staticKeyProfileBackgroundTile,
    instance.profileBackgroundTile,
  );
  keyed.encodeStringKey(
    _$TwitterUserSchema.staticKeyProfileImageUrl,
    instance.profileImageUrl,
  );
  keyed.encodeStringKey(
    _$TwitterUserSchema.staticKeyProfileImageUrlHttps,
    instance.profileImageUrlHttps,
  );
  if (instance.profileBannerUrl != null) {
    keyed.encodeStringKey(
      _$TwitterUserSchema.staticKeyProfileBannerUrl,
      instance.profileBannerUrl!,
    );
  }
  keyed.encodeStringKey(
    _$TwitterUserSchema.staticKeyProfileLinkColor,
    instance.profileLinkColor,
  );
  keyed.encodeStringKey(
    _$TwitterUserSchema.staticKeyProfileSidebarBorderColor,
    instance.profileSidebarBorderColor,
  );
  keyed.encodeStringKey(
    _$TwitterUserSchema.staticKeyProfileSidebarFillColor,
    instance.profileSidebarFillColor,
  );
  keyed.encodeStringKey(
    _$TwitterUserSchema.staticKeyProfileTextColor,
    instance.profileTextColor,
  );
  keyed.encodeBoolKey(
    _$TwitterUserSchema.staticKeyProfileUseBackgroundImage,
    instance.profileUseBackgroundImage,
  );
  keyed.encodeBoolKey(
    _$TwitterUserSchema.staticKeyDefaultProfile,
    instance.defaultProfile,
  );
  keyed.encodeBoolKey(
    _$TwitterUserSchema.staticKeyDefaultProfileImage,
    instance.defaultProfileImage,
  );
  keyed.encodeBoolKey(
    _$TwitterUserSchema.staticKeyFollowing,
    instance.following,
  );
  keyed.encodeBoolKey(
    _$TwitterUserSchema.staticKeyFollowRequestSent,
    instance.followRequestSent,
  );
  keyed.encodeBoolKey(
    _$TwitterUserSchema.staticKeyNotifications,
    instance.notifications,
  );
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

  // Pre-encoded UTF-8 Wire Name Bytes and StaticKeys
  static const List<int> wireNameBytesMetadata = [
    34,
    109,
    101,
    116,
    97,
    100,
    97,
    116,
    97,
    34,
  ];
  static const StaticKey staticKeyMetadata = StaticKey(
    nameMetadata,
    keyMetadata,
    wireNameBytesMetadata,
  );
  static const List<int> wireNameBytesCreatedAt = [
    34,
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
    34,
  ];
  static const StaticKey staticKeyCreatedAt = StaticKey(
    nameCreatedAt,
    keyCreatedAt,
    wireNameBytesCreatedAt,
  );
  static const List<int> wireNameBytesId = [34, 105, 100, 34];
  static const StaticKey staticKeyId = StaticKey(
    nameId,
    keyId,
    wireNameBytesId,
  );
  static const List<int> wireNameBytesIdStr = [
    34,
    105,
    100,
    95,
    115,
    116,
    114,
    34,
  ];
  static const StaticKey staticKeyIdStr = StaticKey(
    nameIdStr,
    keyIdStr,
    wireNameBytesIdStr,
  );
  static const List<int> wireNameBytesText = [34, 116, 101, 120, 116, 34];
  static const StaticKey staticKeyText = StaticKey(
    nameText,
    keyText,
    wireNameBytesText,
  );
  static const List<int> wireNameBytesSource = [
    34,
    115,
    111,
    117,
    114,
    99,
    101,
    34,
  ];
  static const StaticKey staticKeySource = StaticKey(
    nameSource,
    keySource,
    wireNameBytesSource,
  );
  static const List<int> wireNameBytesTruncated = [
    34,
    116,
    114,
    117,
    110,
    99,
    97,
    116,
    101,
    100,
    34,
  ];
  static const StaticKey staticKeyTruncated = StaticKey(
    nameTruncated,
    keyTruncated,
    wireNameBytesTruncated,
  );
  static const List<int> wireNameBytesInReplyToStatusId = [
    34,
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
    34,
  ];
  static const StaticKey staticKeyInReplyToStatusId = StaticKey(
    nameInReplyToStatusId,
    keyInReplyToStatusId,
    wireNameBytesInReplyToStatusId,
  );
  static const List<int> wireNameBytesInReplyToStatusIdStr = [
    34,
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
    34,
  ];
  static const StaticKey staticKeyInReplyToStatusIdStr = StaticKey(
    nameInReplyToStatusIdStr,
    keyInReplyToStatusIdStr,
    wireNameBytesInReplyToStatusIdStr,
  );
  static const List<int> wireNameBytesInReplyToUserId = [
    34,
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
    34,
  ];
  static const StaticKey staticKeyInReplyToUserId = StaticKey(
    nameInReplyToUserId,
    keyInReplyToUserId,
    wireNameBytesInReplyToUserId,
  );
  static const List<int> wireNameBytesInReplyToUserIdStr = [
    34,
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
    34,
  ];
  static const StaticKey staticKeyInReplyToUserIdStr = StaticKey(
    nameInReplyToUserIdStr,
    keyInReplyToUserIdStr,
    wireNameBytesInReplyToUserIdStr,
  );
  static const List<int> wireNameBytesInReplyToScreenName = [
    34,
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
    34,
  ];
  static const StaticKey staticKeyInReplyToScreenName = StaticKey(
    nameInReplyToScreenName,
    keyInReplyToScreenName,
    wireNameBytesInReplyToScreenName,
  );
  static const List<int> wireNameBytesUser = [34, 117, 115, 101, 114, 34];
  static const StaticKey staticKeyUser = StaticKey(
    nameUser,
    keyUser,
    wireNameBytesUser,
  );
  static const List<int> wireNameBytesRetweetCount = [
    34,
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
    34,
  ];
  static const StaticKey staticKeyRetweetCount = StaticKey(
    nameRetweetCount,
    keyRetweetCount,
    wireNameBytesRetweetCount,
  );
  static const List<int> wireNameBytesFavoriteCount = [
    34,
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
    34,
  ];
  static const StaticKey staticKeyFavoriteCount = StaticKey(
    nameFavoriteCount,
    keyFavoriteCount,
    wireNameBytesFavoriteCount,
  );
  static const List<int> wireNameBytesEntities = [
    34,
    101,
    110,
    116,
    105,
    116,
    105,
    101,
    115,
    34,
  ];
  static const StaticKey staticKeyEntities = StaticKey(
    nameEntities,
    keyEntities,
    wireNameBytesEntities,
  );
  static const List<int> wireNameBytesFavorited = [
    34,
    102,
    97,
    118,
    111,
    114,
    105,
    116,
    101,
    100,
    34,
  ];
  static const StaticKey staticKeyFavorited = StaticKey(
    nameFavorited,
    keyFavorited,
    wireNameBytesFavorited,
  );
  static const List<int> wireNameBytesRetweeted = [
    34,
    114,
    101,
    116,
    119,
    101,
    101,
    116,
    101,
    100,
    34,
  ];
  static const StaticKey staticKeyRetweeted = StaticKey(
    nameRetweeted,
    keyRetweeted,
    wireNameBytesRetweeted,
  );
  static const List<int> wireNameBytesPossiblySensitive = [
    34,
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
    34,
  ];
  static const StaticKey staticKeyPossiblySensitive = StaticKey(
    namePossiblySensitive,
    keyPossiblySensitive,
    wireNameBytesPossiblySensitive,
  );
  static const List<int> wireNameBytesLang = [34, 108, 97, 110, 103, 34];
  static const StaticKey staticKeyLang = StaticKey(
    nameLang,
    keyLang,
    wireNameBytesLang,
  );
  static const List<int> wireNameBytesRetweetedStatus = [
    34,
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
    34,
  ];
  static const StaticKey staticKeyRetweetedStatus = StaticKey(
    nameRetweetedStatus,
    keyRetweetedStatus,
    wireNameBytesRetweetedStatus,
  );

  // Key Indices for selectKeyIndex()
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

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
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
  static final KeyOptions keyOptions = options;

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

  // Combined Golden Bitmask for fast single-instruction check
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
// 2. Universal Keyed Deserializer for TwitterStatus
// =============================================================================
TwitterStatus _$TwitterStatusFromDecoder(Decoder decoder) {
  final keyed = decoder.keyed(options: _$TwitterStatusSchema.keyOptions);

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
          metadata = _$TwitterMetadataFromDecoder(keyed.nestedDecoder());
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
          user = _$TwitterUserFromDecoder(keyed.nestedDecoder());
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
          entities = _$TwitterEntitiesFromDecoder(keyed.nestedDecoder());
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
          retweetedStatus = _$TwitterStatusFromDecoder(keyed.nestedDecoder());
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
// 2b. Universal List Deserializer for TwitterStatus
// =============================================================================
List<TwitterStatus> _$TwitterStatusListFromDecoder(Decoder decoder) {
  final unkeyed = decoder.unkeyed();
  final list = <TwitterStatus>[];
  while (unkeyed.hasNext()) {
    list.add(_$TwitterStatusFromDecoder(unkeyed.nestedDecoder()));
  }
  return list;
}

// =============================================================================
// 3. Universal Serializer for TwitterStatus
// =============================================================================
void _$TwitterStatusToEncoder(TwitterStatus instance, Encoder encoder) {
  final keyed = encoder.keyed();
  if (instance.metadata != null) {
    keyed.encodeValueKey(
      _$TwitterStatusSchema.staticKeyMetadata,
      instance.metadata!,
      _$TwitterMetadataToEncoder,
    );
  }
  keyed.encodeStringKey(
    _$TwitterStatusSchema.staticKeyCreatedAt,
    instance.createdAt,
  );
  keyed.encodeIntKey(_$TwitterStatusSchema.staticKeyId, instance.id);
  keyed.encodeStringKey(_$TwitterStatusSchema.staticKeyIdStr, instance.idStr);
  keyed.encodeStringKey(_$TwitterStatusSchema.staticKeyText, instance.text);
  keyed.encodeStringKey(_$TwitterStatusSchema.staticKeySource, instance.source);
  keyed.encodeBoolKey(
    _$TwitterStatusSchema.staticKeyTruncated,
    instance.truncated,
  );
  if (instance.inReplyToStatusId != null) {
    keyed.encodeIntKey(
      _$TwitterStatusSchema.staticKeyInReplyToStatusId,
      instance.inReplyToStatusId!,
    );
  }
  if (instance.inReplyToStatusIdStr != null) {
    keyed.encodeStringKey(
      _$TwitterStatusSchema.staticKeyInReplyToStatusIdStr,
      instance.inReplyToStatusIdStr!,
    );
  }
  if (instance.inReplyToUserId != null) {
    keyed.encodeIntKey(
      _$TwitterStatusSchema.staticKeyInReplyToUserId,
      instance.inReplyToUserId!,
    );
  }
  if (instance.inReplyToUserIdStr != null) {
    keyed.encodeStringKey(
      _$TwitterStatusSchema.staticKeyInReplyToUserIdStr,
      instance.inReplyToUserIdStr!,
    );
  }
  if (instance.inReplyToScreenName != null) {
    keyed.encodeStringKey(
      _$TwitterStatusSchema.staticKeyInReplyToScreenName,
      instance.inReplyToScreenName!,
    );
  }
  if (instance.user != null) {
    keyed.encodeValueKey(
      _$TwitterStatusSchema.staticKeyUser,
      instance.user!,
      _$TwitterUserToEncoder,
    );
  }
  keyed.encodeIntKey(
    _$TwitterStatusSchema.staticKeyRetweetCount,
    instance.retweetCount,
  );
  keyed.encodeIntKey(
    _$TwitterStatusSchema.staticKeyFavoriteCount,
    instance.favoriteCount,
  );
  if (instance.entities != null) {
    keyed.encodeValueKey(
      _$TwitterStatusSchema.staticKeyEntities,
      instance.entities!,
      _$TwitterEntitiesToEncoder,
    );
  }
  keyed.encodeBoolKey(
    _$TwitterStatusSchema.staticKeyFavorited,
    instance.favorited,
  );
  keyed.encodeBoolKey(
    _$TwitterStatusSchema.staticKeyRetweeted,
    instance.retweeted,
  );
  if (instance.possiblySensitive != null) {
    keyed.encodeBoolKey(
      _$TwitterStatusSchema.staticKeyPossiblySensitive,
      instance.possiblySensitive!,
    );
  }
  keyed.encodeStringKey(_$TwitterStatusSchema.staticKeyLang, instance.lang);
  if (instance.retweetedStatus != null) {
    keyed.encodeValueKey(
      _$TwitterStatusSchema.staticKeyRetweetedStatus,
      instance.retweetedStatus!,
      _$TwitterStatusToEncoder,
    );
  }
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

  // Pre-encoded UTF-8 Wire Name Bytes and StaticKeys
  static const List<int> wireNameBytesCompletedIn = [
    34,
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
    34,
  ];
  static const StaticKey staticKeyCompletedIn = StaticKey(
    nameCompletedIn,
    keyCompletedIn,
    wireNameBytesCompletedIn,
  );
  static const List<int> wireNameBytesMaxId = [
    34,
    109,
    97,
    120,
    95,
    105,
    100,
    34,
  ];
  static const StaticKey staticKeyMaxId = StaticKey(
    nameMaxId,
    keyMaxId,
    wireNameBytesMaxId,
  );
  static const List<int> wireNameBytesMaxIdStr = [
    34,
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
    34,
  ];
  static const StaticKey staticKeyMaxIdStr = StaticKey(
    nameMaxIdStr,
    keyMaxIdStr,
    wireNameBytesMaxIdStr,
  );
  static const List<int> wireNameBytesNextResults = [
    34,
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
    34,
  ];
  static const StaticKey staticKeyNextResults = StaticKey(
    nameNextResults,
    keyNextResults,
    wireNameBytesNextResults,
  );
  static const List<int> wireNameBytesQuery = [34, 113, 117, 101, 114, 121, 34];
  static const StaticKey staticKeyQuery = StaticKey(
    nameQuery,
    keyQuery,
    wireNameBytesQuery,
  );
  static const List<int> wireNameBytesRefreshUrl = [
    34,
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
    34,
  ];
  static const StaticKey staticKeyRefreshUrl = StaticKey(
    nameRefreshUrl,
    keyRefreshUrl,
    wireNameBytesRefreshUrl,
  );
  static const List<int> wireNameBytesCount = [34, 99, 111, 117, 110, 116, 34];
  static const StaticKey staticKeyCount = StaticKey(
    nameCount,
    keyCount,
    wireNameBytesCount,
  );
  static const List<int> wireNameBytesSinceId = [
    34,
    115,
    105,
    110,
    99,
    101,
    95,
    105,
    100,
    34,
  ];
  static const StaticKey staticKeySinceId = StaticKey(
    nameSinceId,
    keySinceId,
    wireNameBytesSinceId,
  );
  static const List<int> wireNameBytesSinceIdStr = [
    34,
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
    34,
  ];
  static const StaticKey staticKeySinceIdStr = StaticKey(
    nameSinceIdStr,
    keySinceIdStr,
    wireNameBytesSinceIdStr,
  );

  // Key Indices for selectKeyIndex()
  static const int keyCompletedIn = 0;
  static const int keyMaxId = 1;
  static const int keyMaxIdStr = 2;
  static const int keyNextResults = 3;
  static const int keyQuery = 4;
  static const int keyRefreshUrl = 5;
  static const int keyCount = 6;
  static const int keySinceId = 7;
  static const int keySinceIdStr = 8;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
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
  static final KeyOptions keyOptions = options;

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

  // Combined Golden Bitmask for fast single-instruction check
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
// 2. Universal Keyed Deserializer for TwitterSearchMetadata
// =============================================================================
TwitterSearchMetadata _$TwitterSearchMetadataFromDecoder(Decoder decoder) {
  final keyed = decoder.keyed(
    options: _$TwitterSearchMetadataSchema.keyOptions,
  );

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
// 2b. Universal List Deserializer for TwitterSearchMetadata
// =============================================================================
List<TwitterSearchMetadata> _$TwitterSearchMetadataListFromDecoder(
  Decoder decoder,
) {
  final unkeyed = decoder.unkeyed();
  final list = <TwitterSearchMetadata>[];
  while (unkeyed.hasNext()) {
    list.add(_$TwitterSearchMetadataFromDecoder(unkeyed.nestedDecoder()));
  }
  return list;
}

// =============================================================================
// 3. Universal Serializer for TwitterSearchMetadata
// =============================================================================
void _$TwitterSearchMetadataToEncoder(
  TwitterSearchMetadata instance,
  Encoder encoder,
) {
  final keyed = encoder.keyed();
  keyed.encodeDoubleKey(
    _$TwitterSearchMetadataSchema.staticKeyCompletedIn,
    instance.completedIn,
  );
  keyed.encodeIntKey(
    _$TwitterSearchMetadataSchema.staticKeyMaxId,
    instance.maxId,
  );
  keyed.encodeStringKey(
    _$TwitterSearchMetadataSchema.staticKeyMaxIdStr,
    instance.maxIdStr,
  );
  keyed.encodeStringKey(
    _$TwitterSearchMetadataSchema.staticKeyNextResults,
    instance.nextResults,
  );
  keyed.encodeStringKey(
    _$TwitterSearchMetadataSchema.staticKeyQuery,
    instance.query,
  );
  keyed.encodeStringKey(
    _$TwitterSearchMetadataSchema.staticKeyRefreshUrl,
    instance.refreshUrl,
  );
  keyed.encodeIntKey(
    _$TwitterSearchMetadataSchema.staticKeyCount,
    instance.count,
  );
  keyed.encodeIntKey(
    _$TwitterSearchMetadataSchema.staticKeySinceId,
    instance.sinceId,
  );
  keyed.encodeStringKey(
    _$TwitterSearchMetadataSchema.staticKeySinceIdStr,
    instance.sinceIdStr,
  );
}

// =============================================================================
// 1. Unified Schema Descriptor for TwitterResponse
// =============================================================================
extension type const _$TwitterResponseSchema(int _value) {
  // String Name Constants
  static const String nameStatuses = 'statuses';
  static const String nameSearchMetadata = 'search_metadata';

  // Pre-encoded UTF-8 Wire Name Bytes and StaticKeys
  static const List<int> wireNameBytesStatuses = [
    34,
    115,
    116,
    97,
    116,
    117,
    115,
    101,
    115,
    34,
  ];
  static const StaticKey staticKeyStatuses = StaticKey(
    nameStatuses,
    keyStatuses,
    wireNameBytesStatuses,
  );
  static const List<int> wireNameBytesSearchMetadata = [
    34,
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
    34,
  ];
  static const StaticKey staticKeySearchMetadata = StaticKey(
    nameSearchMetadata,
    keySearchMetadata,
    wireNameBytesSearchMetadata,
  );

  // Key Indices for selectKeyIndex()
  static const int keyStatuses = 0;
  static const int keySearchMetadata = 1;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
    _$TwitterResponseSchema.nameStatuses,
    _$TwitterResponseSchema.nameSearchMetadata,
  ]);
  static final KeyOptions keyOptions = options;

  // Bitmask Flags strictly for Required Fields
  static const _$TwitterResponseSchema none = _$TwitterResponseSchema(0);
  static const int _searchMetadataBit = 1 << 0;
  static const _$TwitterResponseSchema searchMetadata = _$TwitterResponseSchema(
    _searchMetadataBit,
  );

  // Combined Golden Bitmask for fast single-instruction check
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
// 2. Universal Keyed Deserializer for TwitterResponse
// =============================================================================
TwitterResponse _$TwitterResponseFromDecoder(Decoder decoder) {
  final keyed = decoder.keyed(options: _$TwitterResponseSchema.keyOptions);

  var statuses = const <TwitterStatus>[];
  TwitterSearchMetadata? searchMetadata;
  var seen = _$TwitterResponseSchema.none;

  while (keyed.hasNextKey()) {
    switch (keyed.selectKeyIndex(_$TwitterResponseSchema.keyOptions)) {
      case _$TwitterResponseSchema.keyStatuses:
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          statuses = _$TwitterStatusListFromDecoder(keyed.nestedDecoder());
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
          searchMetadata = _$TwitterSearchMetadataFromDecoder(
            keyed.nestedDecoder(),
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
// 2b. Universal List Deserializer for TwitterResponse
// =============================================================================
List<TwitterResponse> _$TwitterResponseListFromDecoder(Decoder decoder) {
  final unkeyed = decoder.unkeyed();
  final list = <TwitterResponse>[];
  while (unkeyed.hasNext()) {
    list.add(_$TwitterResponseFromDecoder(unkeyed.nestedDecoder()));
  }
  return list;
}

// =============================================================================
// 3. Universal Serializer for TwitterResponse
// =============================================================================
void _$TwitterResponseToEncoder(TwitterResponse instance, Encoder encoder) {
  final keyed = encoder.keyed();
  keyed.encodeListKey(
    _$TwitterResponseSchema.staticKeyStatuses,
    instance.statuses,
    _$TwitterStatusToEncoder,
  );
  keyed.encodeValueKey(
    _$TwitterResponseSchema.staticKeySearchMetadata,
    instance.searchMetadata,
    _$TwitterSearchMetadataToEncoder,
  );
}
