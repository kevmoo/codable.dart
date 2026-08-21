// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: lines_longer_than_80_chars

part of 'twitter.dart';

// **************************************************************************
// CodableGenerator
// **************************************************************************

// =============================================================================
// 1. Unified Schema Descriptor for TwitterMetadata
// =============================================================================
extension type const _$TwitterMetadataSchema(int _value) {
  // String Name Constants
  static const String nameResultType = 'result_type';
  static const String nameIsoLanguageCode = 'iso_language_code';

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
// 3. Universal Serializer for TwitterMetadata
// =============================================================================
void _$TwitterMetadataToEncoder(TwitterMetadata instance, Encoder encoder) {
  final keyed = encoder.keyed();
  keyed.encodeString(
    _$TwitterMetadataSchema.nameResultType,
    instance.resultType,
  );
  keyed.encodeString(
    _$TwitterMetadataSchema.nameIsoLanguageCode,
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
// 3. Universal Serializer for TwitterUserMention
// =============================================================================
void _$TwitterUserMentionToEncoder(
  TwitterUserMention instance,
  Encoder encoder,
) {
  final keyed = encoder.keyed();
  keyed.encodeString(
    _$TwitterUserMentionSchema.nameScreenName,
    instance.screenName,
  );
  keyed.encodeString(_$TwitterUserMentionSchema.nameName, instance.name);
  keyed.encodeInt(_$TwitterUserMentionSchema.nameId, instance.id);
  keyed.encodeString(_$TwitterUserMentionSchema.nameIdStr, instance.idStr);
  keyed.encodeIntList(_$TwitterUserMentionSchema.nameIndices, instance.indices);
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
// 3. Universal Serializer for TwitterUrl
// =============================================================================
void _$TwitterUrlToEncoder(TwitterUrl instance, Encoder encoder) {
  final keyed = encoder.keyed();
  keyed.encodeString(_$TwitterUrlSchema.nameUrl, instance.url);
  keyed.encodeString(_$TwitterUrlSchema.nameExpandedUrl, instance.expandedUrl);
  keyed.encodeString(_$TwitterUrlSchema.nameDisplayUrl, instance.displayUrl);
  keyed.encodeIntList(_$TwitterUrlSchema.nameIndices, instance.indices);
}

// =============================================================================
// 1. Unified Schema Descriptor for TwitterEntitiesUrls
// =============================================================================
extension type const _$TwitterEntitiesUrlsSchema(int _value) {
  // String Name Constants
  static const String nameUrls = 'urls';

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
// 3. Universal Serializer for TwitterEntitiesUrls
// =============================================================================
void _$TwitterEntitiesUrlsToEncoder(
  TwitterEntitiesUrls instance,
  Encoder encoder,
) {
  final keyed = encoder.keyed();
  keyed.encodeList(
    _$TwitterEntitiesUrlsSchema.nameUrls,
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
// 3. Universal Serializer for TwitterUserEntities
// =============================================================================
void _$TwitterUserEntitiesToEncoder(
  TwitterUserEntities instance,
  Encoder encoder,
) {
  final keyed = encoder.keyed();
  if (instance.url != null) {
    keyed.encodeValue(
      _$TwitterUserEntitiesSchema.nameUrl,
      instance.url!,
      _$TwitterEntitiesUrlsToEncoder,
    );
  }
  if (instance.description != null) {
    keyed.encodeValue(
      _$TwitterUserEntitiesSchema.nameDescription,
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
// 3. Universal Serializer for TwitterEntities
// =============================================================================
void _$TwitterEntitiesToEncoder(TwitterEntities instance, Encoder encoder) {
  final keyed = encoder.keyed();
  keyed.encodeList(
    _$TwitterEntitiesSchema.nameUrls,
    instance.urls,
    _$TwitterUrlToEncoder,
  );
  keyed.encodeList(
    _$TwitterEntitiesSchema.nameUserMentions,
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
// 3. Universal Serializer for TwitterUser
// =============================================================================
void _$TwitterUserToEncoder(TwitterUser instance, Encoder encoder) {
  final keyed = encoder.keyed();
  keyed.encodeInt(_$TwitterUserSchema.nameId, instance.id);
  keyed.encodeString(_$TwitterUserSchema.nameIdStr, instance.idStr);
  keyed.encodeString(_$TwitterUserSchema.nameName, instance.name);
  keyed.encodeString(_$TwitterUserSchema.nameScreenName, instance.screenName);
  keyed.encodeString(_$TwitterUserSchema.nameLocation, instance.location);
  keyed.encodeString(_$TwitterUserSchema.nameDescription, instance.description);
  if (instance.url != null) {
    keyed.encodeString(_$TwitterUserSchema.nameUrl, instance.url!);
  }
  if (instance.entities != null) {
    keyed.encodeValue(
      _$TwitterUserSchema.nameEntities,
      instance.entities!,
      _$TwitterUserEntitiesToEncoder,
    );
  }
  keyed.encodeBool(_$TwitterUserSchema.nameProtected, instance.protected);
  keyed.encodeInt(
    _$TwitterUserSchema.nameFollowersCount,
    instance.followersCount,
  );
  keyed.encodeInt(_$TwitterUserSchema.nameFriendsCount, instance.friendsCount);
  keyed.encodeInt(_$TwitterUserSchema.nameListedCount, instance.listedCount);
  keyed.encodeString(_$TwitterUserSchema.nameCreatedAt, instance.createdAt);
  keyed.encodeInt(
    _$TwitterUserSchema.nameFavouritesCount,
    instance.favouritesCount,
  );
  if (instance.utcOffset != null) {
    keyed.encodeInt(_$TwitterUserSchema.nameUtcOffset, instance.utcOffset!);
  }
  if (instance.timeZone != null) {
    keyed.encodeString(_$TwitterUserSchema.nameTimeZone, instance.timeZone!);
  }
  keyed.encodeBool(_$TwitterUserSchema.nameGeoEnabled, instance.geoEnabled);
  keyed.encodeBool(_$TwitterUserSchema.nameVerified, instance.verified);
  keyed.encodeInt(
    _$TwitterUserSchema.nameStatusesCount,
    instance.statusesCount,
  );
  keyed.encodeString(_$TwitterUserSchema.nameLang, instance.lang);
  keyed.encodeBool(
    _$TwitterUserSchema.nameContributorsEnabled,
    instance.contributorsEnabled,
  );
  keyed.encodeBool(_$TwitterUserSchema.nameIsTranslator, instance.isTranslator);
  keyed.encodeBool(
    _$TwitterUserSchema.nameIsTranslationEnabled,
    instance.isTranslationEnabled,
  );
  keyed.encodeString(
    _$TwitterUserSchema.nameProfileBackgroundColor,
    instance.profileBackgroundColor,
  );
  keyed.encodeString(
    _$TwitterUserSchema.nameProfileBackgroundImageUrl,
    instance.profileBackgroundImageUrl,
  );
  keyed.encodeString(
    _$TwitterUserSchema.nameProfileBackgroundImageUrlHttps,
    instance.profileBackgroundImageUrlHttps,
  );
  keyed.encodeBool(
    _$TwitterUserSchema.nameProfileBackgroundTile,
    instance.profileBackgroundTile,
  );
  keyed.encodeString(
    _$TwitterUserSchema.nameProfileImageUrl,
    instance.profileImageUrl,
  );
  keyed.encodeString(
    _$TwitterUserSchema.nameProfileImageUrlHttps,
    instance.profileImageUrlHttps,
  );
  if (instance.profileBannerUrl != null) {
    keyed.encodeString(
      _$TwitterUserSchema.nameProfileBannerUrl,
      instance.profileBannerUrl!,
    );
  }
  keyed.encodeString(
    _$TwitterUserSchema.nameProfileLinkColor,
    instance.profileLinkColor,
  );
  keyed.encodeString(
    _$TwitterUserSchema.nameProfileSidebarBorderColor,
    instance.profileSidebarBorderColor,
  );
  keyed.encodeString(
    _$TwitterUserSchema.nameProfileSidebarFillColor,
    instance.profileSidebarFillColor,
  );
  keyed.encodeString(
    _$TwitterUserSchema.nameProfileTextColor,
    instance.profileTextColor,
  );
  keyed.encodeBool(
    _$TwitterUserSchema.nameProfileUseBackgroundImage,
    instance.profileUseBackgroundImage,
  );
  keyed.encodeBool(
    _$TwitterUserSchema.nameDefaultProfile,
    instance.defaultProfile,
  );
  keyed.encodeBool(
    _$TwitterUserSchema.nameDefaultProfileImage,
    instance.defaultProfileImage,
  );
  keyed.encodeBool(_$TwitterUserSchema.nameFollowing, instance.following);
  keyed.encodeBool(
    _$TwitterUserSchema.nameFollowRequestSent,
    instance.followRequestSent,
  );
  keyed.encodeBool(
    _$TwitterUserSchema.nameNotifications,
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
// 3. Universal Serializer for TwitterStatus
// =============================================================================
void _$TwitterStatusToEncoder(TwitterStatus instance, Encoder encoder) {
  final keyed = encoder.keyed();
  if (instance.metadata != null) {
    keyed.encodeValue(
      _$TwitterStatusSchema.nameMetadata,
      instance.metadata!,
      _$TwitterMetadataToEncoder,
    );
  }
  keyed.encodeString(_$TwitterStatusSchema.nameCreatedAt, instance.createdAt);
  keyed.encodeInt(_$TwitterStatusSchema.nameId, instance.id);
  keyed.encodeString(_$TwitterStatusSchema.nameIdStr, instance.idStr);
  keyed.encodeString(_$TwitterStatusSchema.nameText, instance.text);
  keyed.encodeString(_$TwitterStatusSchema.nameSource, instance.source);
  keyed.encodeBool(_$TwitterStatusSchema.nameTruncated, instance.truncated);
  if (instance.inReplyToStatusId != null) {
    keyed.encodeInt(
      _$TwitterStatusSchema.nameInReplyToStatusId,
      instance.inReplyToStatusId!,
    );
  }
  if (instance.inReplyToStatusIdStr != null) {
    keyed.encodeString(
      _$TwitterStatusSchema.nameInReplyToStatusIdStr,
      instance.inReplyToStatusIdStr!,
    );
  }
  if (instance.inReplyToUserId != null) {
    keyed.encodeInt(
      _$TwitterStatusSchema.nameInReplyToUserId,
      instance.inReplyToUserId!,
    );
  }
  if (instance.inReplyToUserIdStr != null) {
    keyed.encodeString(
      _$TwitterStatusSchema.nameInReplyToUserIdStr,
      instance.inReplyToUserIdStr!,
    );
  }
  if (instance.inReplyToScreenName != null) {
    keyed.encodeString(
      _$TwitterStatusSchema.nameInReplyToScreenName,
      instance.inReplyToScreenName!,
    );
  }
  if (instance.user != null) {
    keyed.encodeValue(
      _$TwitterStatusSchema.nameUser,
      instance.user!,
      _$TwitterUserToEncoder,
    );
  }
  keyed.encodeInt(
    _$TwitterStatusSchema.nameRetweetCount,
    instance.retweetCount,
  );
  keyed.encodeInt(
    _$TwitterStatusSchema.nameFavoriteCount,
    instance.favoriteCount,
  );
  if (instance.entities != null) {
    keyed.encodeValue(
      _$TwitterStatusSchema.nameEntities,
      instance.entities!,
      _$TwitterEntitiesToEncoder,
    );
  }
  keyed.encodeBool(_$TwitterStatusSchema.nameFavorited, instance.favorited);
  keyed.encodeBool(_$TwitterStatusSchema.nameRetweeted, instance.retweeted);
  if (instance.possiblySensitive != null) {
    keyed.encodeBool(
      _$TwitterStatusSchema.namePossiblySensitive,
      instance.possiblySensitive!,
    );
  }
  keyed.encodeString(_$TwitterStatusSchema.nameLang, instance.lang);
  if (instance.retweetedStatus != null) {
    keyed.encodeValue(
      _$TwitterStatusSchema.nameRetweetedStatus,
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
// 3. Universal Serializer for TwitterSearchMetadata
// =============================================================================
void _$TwitterSearchMetadataToEncoder(
  TwitterSearchMetadata instance,
  Encoder encoder,
) {
  final keyed = encoder.keyed();
  keyed.encodeDouble(
    _$TwitterSearchMetadataSchema.nameCompletedIn,
    instance.completedIn,
  );
  keyed.encodeInt(_$TwitterSearchMetadataSchema.nameMaxId, instance.maxId);
  keyed.encodeString(
    _$TwitterSearchMetadataSchema.nameMaxIdStr,
    instance.maxIdStr,
  );
  keyed.encodeString(
    _$TwitterSearchMetadataSchema.nameNextResults,
    instance.nextResults,
  );
  keyed.encodeString(_$TwitterSearchMetadataSchema.nameQuery, instance.query);
  keyed.encodeString(
    _$TwitterSearchMetadataSchema.nameRefreshUrl,
    instance.refreshUrl,
  );
  keyed.encodeInt(_$TwitterSearchMetadataSchema.nameCount, instance.count);
  keyed.encodeInt(_$TwitterSearchMetadataSchema.nameSinceId, instance.sinceId);
  keyed.encodeString(
    _$TwitterSearchMetadataSchema.nameSinceIdStr,
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
// 3. Universal Serializer for TwitterResponse
// =============================================================================
void _$TwitterResponseToEncoder(TwitterResponse instance, Encoder encoder) {
  final keyed = encoder.keyed();
  keyed.encodeList(
    _$TwitterResponseSchema.nameStatuses,
    instance.statuses,
    _$TwitterStatusToEncoder,
  );
  keyed.encodeValue(
    _$TwitterResponseSchema.nameSearchMetadata,
    instance.searchMetadata,
    _$TwitterSearchMetadataToEncoder,
  );
}
