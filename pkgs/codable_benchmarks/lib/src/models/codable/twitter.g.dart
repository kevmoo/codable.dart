// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: lines_longer_than_80_chars, unnecessary_lambdas, deprecated_member_use, unused_element

part of 'twitter.dart';

// **************************************************************************
// CodableGenerator
// **************************************************************************

// ignore_for_file: omit_local_variable_types

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
// 2. Companion Codable for TwitterMetadata
// =============================================================================
final class TwitterMetadataCodable implements KeyedCodable<TwitterMetadata> {
  const TwitterMetadataCodable();

  @override
  TwitterMetadata decode(Decoder decoder) {
    final keyed = decoder.keyed(options: _$TwitterMetadataSchema.keyOptions);

    String resultType = '';
    String isoLanguageCode = '';
    var seen = _$TwitterMetadataSchema.none;

    while (keyed.moveNextKey()) {
      switch (keyed.selectKeyIndex(_$TwitterMetadataSchema.keyOptions)) {
        case _$TwitterMetadataSchema.keyResultType:
          resultType = keyed.readString();
          break;
        case _$TwitterMetadataSchema.keyIsoLanguageCode:
          isoLanguageCode = keyed.readString();
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

  @override
  int encodedFieldCount(TwitterMetadata instance) => 2;

  @override
  void encodeFields(TwitterMetadata instance, KeyedEncoder keyed) {
    keyed.encodeString(
      _$TwitterMetadataSchema.nameResultType,
      instance.resultType,
    );
    keyed.encodeString(
      _$TwitterMetadataSchema.nameIsoLanguageCode,
      instance.isoLanguageCode,
    );
  }

  @override
  void encode(TwitterMetadata instance, Encoder encoder) {
    encodeFields(instance, encoder.keyed(length: 2));
  }
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
// 2. Companion Codable for TwitterUserMention
// =============================================================================
final class TwitterUserMentionCodable
    implements KeyedCodable<TwitterUserMention> {
  const TwitterUserMentionCodable();

  @override
  TwitterUserMention decode(Decoder decoder) {
    final keyed = decoder.keyed(options: _$TwitterUserMentionSchema.keyOptions);

    String? screenName;
    String? name;
    int? id;
    String? idStr;
    List<int> indices = const [];
    var seen = _$TwitterUserMentionSchema.none;

    while (keyed.moveNextKey()) {
      switch (keyed.selectKeyIndex(_$TwitterUserMentionSchema.keyOptions)) {
        case _$TwitterUserMentionSchema.keyScreenName:
          if ((seen._value & _$TwitterUserMentionSchema.screenName._value) !=
              0) {
            throw const CodableException('Duplicate field "screen_name"');
          }
          screenName = keyed.readString();
          seen |= _$TwitterUserMentionSchema.screenName;
          break;
        case _$TwitterUserMentionSchema.keyName:
          if ((seen._value & _$TwitterUserMentionSchema.name._value) != 0) {
            throw const CodableException('Duplicate field "name"');
          }
          name = keyed.readString();
          seen |= _$TwitterUserMentionSchema.name;
          break;
        case _$TwitterUserMentionSchema.keyId:
          if ((seen._value & _$TwitterUserMentionSchema.id._value) != 0) {
            throw const CodableException('Duplicate field "id"');
          }
          id = keyed.readInt();
          seen |= _$TwitterUserMentionSchema.id;
          break;
        case _$TwitterUserMentionSchema.keyIdStr:
          if ((seen._value & _$TwitterUserMentionSchema.idStr._value) != 0) {
            throw const CodableException('Duplicate field "id_str"');
          }
          idStr = keyed.readString();
          seen |= _$TwitterUserMentionSchema.idStr;
          break;
        case _$TwitterUserMentionSchema.keyIndices:
          indices = keyed.decodeIntList();
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

  @override
  int encodedFieldCount(TwitterUserMention instance) => 5;

  @override
  void encodeFields(TwitterUserMention instance, KeyedEncoder keyed) {
    keyed.encodeString(
      _$TwitterUserMentionSchema.nameScreenName,
      instance.screenName,
    );
    keyed.encodeString(_$TwitterUserMentionSchema.nameName, instance.name);
    keyed.encodeInt(_$TwitterUserMentionSchema.nameId, instance.id);
    keyed.encodeString(_$TwitterUserMentionSchema.nameIdStr, instance.idStr);
    keyed.encodeIntList(
      _$TwitterUserMentionSchema.nameIndices,
      instance.indices,
    );
  }

  @override
  void encode(TwitterUserMention instance, Encoder encoder) {
    encodeFields(instance, encoder.keyed(length: 5));
  }
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
// 2. Companion Codable for TwitterUrl
// =============================================================================
final class TwitterUrlCodable implements KeyedCodable<TwitterUrl> {
  const TwitterUrlCodable();

  @override
  TwitterUrl decode(Decoder decoder) {
    final keyed = decoder.keyed(options: _$TwitterUrlSchema.keyOptions);

    String? url;
    String? expandedUrl;
    String? displayUrl;
    List<int> indices = const [];
    var seen = _$TwitterUrlSchema.none;

    while (keyed.moveNextKey()) {
      switch (keyed.selectKeyIndex(_$TwitterUrlSchema.keyOptions)) {
        case _$TwitterUrlSchema.keyUrl:
          if ((seen._value & _$TwitterUrlSchema.url._value) != 0) {
            throw const CodableException('Duplicate field "url"');
          }
          url = keyed.readString();
          seen |= _$TwitterUrlSchema.url;
          break;
        case _$TwitterUrlSchema.keyExpandedUrl:
          if ((seen._value & _$TwitterUrlSchema.expandedUrl._value) != 0) {
            throw const CodableException('Duplicate field "expanded_url"');
          }
          expandedUrl = keyed.readString();
          seen |= _$TwitterUrlSchema.expandedUrl;
          break;
        case _$TwitterUrlSchema.keyDisplayUrl:
          if ((seen._value & _$TwitterUrlSchema.displayUrl._value) != 0) {
            throw const CodableException('Duplicate field "display_url"');
          }
          displayUrl = keyed.readString();
          seen |= _$TwitterUrlSchema.displayUrl;
          break;
        case _$TwitterUrlSchema.keyIndices:
          indices = keyed.decodeIntList();
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

  @override
  int encodedFieldCount(TwitterUrl instance) => 4;

  @override
  void encodeFields(TwitterUrl instance, KeyedEncoder keyed) {
    keyed.encodeString(_$TwitterUrlSchema.nameUrl, instance.url);
    keyed.encodeString(
      _$TwitterUrlSchema.nameExpandedUrl,
      instance.expandedUrl,
    );
    keyed.encodeString(_$TwitterUrlSchema.nameDisplayUrl, instance.displayUrl);
    keyed.encodeIntList(_$TwitterUrlSchema.nameIndices, instance.indices);
  }

  @override
  void encode(TwitterUrl instance, Encoder encoder) {
    encodeFields(instance, encoder.keyed(length: 4));
  }
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
// 2. Companion Codable for TwitterEntitiesUrls
// =============================================================================
final class TwitterEntitiesUrlsCodable
    implements KeyedCodable<TwitterEntitiesUrls> {
  const TwitterEntitiesUrlsCodable();

  @override
  TwitterEntitiesUrls decode(Decoder decoder) {
    final keyed = decoder.keyed(
      options: _$TwitterEntitiesUrlsSchema.keyOptions,
    );

    List<TwitterUrl> urls = const [];
    var seen = _$TwitterEntitiesUrlsSchema.none;

    while (keyed.moveNextKey()) {
      switch (keyed.selectKeyIndex(_$TwitterEntitiesUrlsSchema.keyOptions)) {
        case _$TwitterEntitiesUrlsSchema.keyUrls:
          urls = const TwitterUrlCodable().decodeList(keyed.nestedDecoder());
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

  @override
  int encodedFieldCount(TwitterEntitiesUrls instance) => 1;

  @override
  void encodeFields(TwitterEntitiesUrls instance, KeyedEncoder keyed) {
    keyed.encodeList(
      _$TwitterEntitiesUrlsSchema.nameUrls,
      instance.urls,
      const TwitterUrlCodable(),
    );
  }

  @override
  void encode(TwitterEntitiesUrls instance, Encoder encoder) {
    encodeFields(instance, encoder.keyed(length: 1));
  }
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
// 2. Companion Codable for TwitterUserEntities
// =============================================================================
final class TwitterUserEntitiesCodable
    implements KeyedCodable<TwitterUserEntities> {
  const TwitterUserEntitiesCodable();

  @override
  TwitterUserEntities decode(Decoder decoder) {
    final keyed = decoder.keyed(
      options: _$TwitterUserEntitiesSchema.keyOptions,
    );

    TwitterEntitiesUrls? url;
    TwitterEntitiesUrls? description;
    var seen = _$TwitterUserEntitiesSchema.none;

    while (keyed.moveNextKey()) {
      switch (keyed.selectKeyIndex(_$TwitterUserEntitiesSchema.keyOptions)) {
        case _$TwitterUserEntitiesSchema.keyUrl:
          if (keyed.isNextNull()) {
            keyed.readNull();
            url = null;
          } else {
            url = const TwitterEntitiesUrlsCodable().decode(
              keyed.nestedDecoder(),
            );
          }
          break;
        case _$TwitterUserEntitiesSchema.keyDescription:
          if (keyed.isNextNull()) {
            keyed.readNull();
            description = null;
          } else {
            description = const TwitterEntitiesUrlsCodable().decode(
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

    return TwitterUserEntities(url: url, description: description);
  }

  @override
  int encodedFieldCount(TwitterUserEntities instance) {
    var count$ = 0;
    if (instance.url != null) count$++;
    if (instance.description != null) count$++;
    return count$;
  }

  @override
  void encodeFields(TwitterUserEntities instance, KeyedEncoder keyed) {
    final v$Url = instance.url;
    if (v$Url != null) {
      keyed.encodeValue(
        _$TwitterUserEntitiesSchema.nameUrl,
        v$Url,
        const TwitterEntitiesUrlsCodable(),
      );
    }
    final v$Description = instance.description;
    if (v$Description != null) {
      keyed.encodeValue(
        _$TwitterUserEntitiesSchema.nameDescription,
        v$Description,
        const TwitterEntitiesUrlsCodable(),
      );
    }
  }

  @override
  void encode(TwitterUserEntities instance, Encoder encoder) {
    var count$ = 0;
    final v$Url = instance.url;
    if (v$Url != null) count$++;
    final v$Description = instance.description;
    if (v$Description != null) count$++;
    final keyed = encoder.keyed(length: count$);
    if (v$Url != null) {
      keyed.encodeValue(
        _$TwitterUserEntitiesSchema.nameUrl,
        v$Url,
        const TwitterEntitiesUrlsCodable(),
      );
    }
    if (v$Description != null) {
      keyed.encodeValue(
        _$TwitterUserEntitiesSchema.nameDescription,
        v$Description,
        const TwitterEntitiesUrlsCodable(),
      );
    }
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
// 2. Companion Codable for TwitterEntities
// =============================================================================
final class TwitterEntitiesCodable implements KeyedCodable<TwitterEntities> {
  const TwitterEntitiesCodable();

  @override
  TwitterEntities decode(Decoder decoder) {
    final keyed = decoder.keyed(options: _$TwitterEntitiesSchema.keyOptions);

    List<TwitterUrl> urls = const [];
    List<TwitterUserMention> userMentions = const [];
    var seen = _$TwitterEntitiesSchema.none;

    while (keyed.moveNextKey()) {
      switch (keyed.selectKeyIndex(_$TwitterEntitiesSchema.keyOptions)) {
        case _$TwitterEntitiesSchema.keyUrls:
          urls = const TwitterUrlCodable().decodeList(keyed.nestedDecoder());
          break;
        case _$TwitterEntitiesSchema.keyUserMentions:
          userMentions = const TwitterUserMentionCodable().decodeList(
            keyed.nestedDecoder(),
          );
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

  @override
  int encodedFieldCount(TwitterEntities instance) => 2;

  @override
  void encodeFields(TwitterEntities instance, KeyedEncoder keyed) {
    keyed.encodeList(
      _$TwitterEntitiesSchema.nameUrls,
      instance.urls,
      const TwitterUrlCodable(),
    );
    keyed.encodeList(
      _$TwitterEntitiesSchema.nameUserMentions,
      instance.userMentions,
      const TwitterUserMentionCodable(),
    );
  }

  @override
  void encode(TwitterEntities instance, Encoder encoder) {
    encodeFields(instance, encoder.keyed(length: 2));
  }
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
// 2. Companion Codable for TwitterUser
// =============================================================================
final class TwitterUserCodable implements KeyedCodable<TwitterUser> {
  const TwitterUserCodable();

  @override
  TwitterUser decode(Decoder decoder) {
    final keyed = decoder.keyed(options: _$TwitterUserSchema.keyOptions);

    int? id;
    String? idStr;
    String? name;
    String? screenName;
    String location = '';
    String description = '';
    String? url;
    TwitterUserEntities? entities;
    bool protected = false;
    int followersCount = 0;
    int friendsCount = 0;
    int listedCount = 0;
    String? createdAt;
    int favouritesCount = 0;
    int? utcOffset;
    String? timeZone;
    bool geoEnabled = false;
    bool verified = false;
    int statusesCount = 0;
    String lang = 'en';
    bool contributorsEnabled = false;
    bool isTranslator = false;
    bool isTranslationEnabled = false;
    String profileBackgroundColor = '';
    String profileBackgroundImageUrl = '';
    String profileBackgroundImageUrlHttps = '';
    bool profileBackgroundTile = false;
    String profileImageUrl = '';
    String profileImageUrlHttps = '';
    String? profileBannerUrl;
    String profileLinkColor = '';
    String profileSidebarBorderColor = '';
    String profileSidebarFillColor = '';
    String profileTextColor = '';
    bool profileUseBackgroundImage = false;
    bool defaultProfile = false;
    bool defaultProfileImage = false;
    bool following = false;
    bool followRequestSent = false;
    bool notifications = false;
    var seen = _$TwitterUserSchema.none;

    while (keyed.moveNextKey()) {
      switch (keyed.selectKeyIndex(_$TwitterUserSchema.keyOptions)) {
        case _$TwitterUserSchema.keyId:
          if ((seen._value & _$TwitterUserSchema.id._value) != 0) {
            throw const CodableException('Duplicate field "id"');
          }
          id = keyed.readInt();
          seen |= _$TwitterUserSchema.id;
          break;
        case _$TwitterUserSchema.keyIdStr:
          if ((seen._value & _$TwitterUserSchema.idStr._value) != 0) {
            throw const CodableException('Duplicate field "id_str"');
          }
          idStr = keyed.readString();
          seen |= _$TwitterUserSchema.idStr;
          break;
        case _$TwitterUserSchema.keyName:
          if ((seen._value & _$TwitterUserSchema.name._value) != 0) {
            throw const CodableException('Duplicate field "name"');
          }
          name = keyed.readString();
          seen |= _$TwitterUserSchema.name;
          break;
        case _$TwitterUserSchema.keyScreenName:
          if ((seen._value & _$TwitterUserSchema.screenName._value) != 0) {
            throw const CodableException('Duplicate field "screen_name"');
          }
          screenName = keyed.readString();
          seen |= _$TwitterUserSchema.screenName;
          break;
        case _$TwitterUserSchema.keyLocation:
          location = keyed.readString();
          break;
        case _$TwitterUserSchema.keyDescription:
          description = keyed.readString();
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
            entities = const TwitterUserEntitiesCodable().decode(
              keyed.nestedDecoder(),
            );
          }
          break;
        case _$TwitterUserSchema.keyProtected:
          protected = keyed.readBool();
          break;
        case _$TwitterUserSchema.keyFollowersCount:
          followersCount = keyed.readInt();
          break;
        case _$TwitterUserSchema.keyFriendsCount:
          friendsCount = keyed.readInt();
          break;
        case _$TwitterUserSchema.keyListedCount:
          listedCount = keyed.readInt();
          break;
        case _$TwitterUserSchema.keyCreatedAt:
          if ((seen._value & _$TwitterUserSchema.createdAt._value) != 0) {
            throw const CodableException('Duplicate field "created_at"');
          }
          createdAt = keyed.readString();
          seen |= _$TwitterUserSchema.createdAt;
          break;
        case _$TwitterUserSchema.keyFavouritesCount:
          favouritesCount = keyed.readInt();
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
          geoEnabled = keyed.readBool();
          break;
        case _$TwitterUserSchema.keyVerified:
          verified = keyed.readBool();
          break;
        case _$TwitterUserSchema.keyStatusesCount:
          statusesCount = keyed.readInt();
          break;
        case _$TwitterUserSchema.keyLang:
          lang = keyed.readString();
          break;
        case _$TwitterUserSchema.keyContributorsEnabled:
          contributorsEnabled = keyed.readBool();
          break;
        case _$TwitterUserSchema.keyIsTranslator:
          isTranslator = keyed.readBool();
          break;
        case _$TwitterUserSchema.keyIsTranslationEnabled:
          isTranslationEnabled = keyed.readBool();
          break;
        case _$TwitterUserSchema.keyProfileBackgroundColor:
          profileBackgroundColor = keyed.readString();
          break;
        case _$TwitterUserSchema.keyProfileBackgroundImageUrl:
          profileBackgroundImageUrl = keyed.readString();
          break;
        case _$TwitterUserSchema.keyProfileBackgroundImageUrlHttps:
          profileBackgroundImageUrlHttps = keyed.readString();
          break;
        case _$TwitterUserSchema.keyProfileBackgroundTile:
          profileBackgroundTile = keyed.readBool();
          break;
        case _$TwitterUserSchema.keyProfileImageUrl:
          profileImageUrl = keyed.readString();
          break;
        case _$TwitterUserSchema.keyProfileImageUrlHttps:
          profileImageUrlHttps = keyed.readString();
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
          profileLinkColor = keyed.readString();
          break;
        case _$TwitterUserSchema.keyProfileSidebarBorderColor:
          profileSidebarBorderColor = keyed.readString();
          break;
        case _$TwitterUserSchema.keyProfileSidebarFillColor:
          profileSidebarFillColor = keyed.readString();
          break;
        case _$TwitterUserSchema.keyProfileTextColor:
          profileTextColor = keyed.readString();
          break;
        case _$TwitterUserSchema.keyProfileUseBackgroundImage:
          profileUseBackgroundImage = keyed.readBool();
          break;
        case _$TwitterUserSchema.keyDefaultProfile:
          defaultProfile = keyed.readBool();
          break;
        case _$TwitterUserSchema.keyDefaultProfileImage:
          defaultProfileImage = keyed.readBool();
          break;
        case _$TwitterUserSchema.keyFollowing:
          following = keyed.readBool();
          break;
        case _$TwitterUserSchema.keyFollowRequestSent:
          followRequestSent = keyed.readBool();
          break;
        case _$TwitterUserSchema.keyNotifications:
          notifications = keyed.readBool();
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

  @override
  int encodedFieldCount(TwitterUser instance) {
    var count$ = 35;
    if (instance.url != null) count$++;
    if (instance.entities != null) count$++;
    if (instance.utcOffset != null) count$++;
    if (instance.timeZone != null) count$++;
    if (instance.profileBannerUrl != null) count$++;
    return count$;
  }

  @override
  void encodeFields(TwitterUser instance, KeyedEncoder keyed) {
    keyed.encodeInt(_$TwitterUserSchema.nameId, instance.id);
    keyed.encodeString(_$TwitterUserSchema.nameIdStr, instance.idStr);
    keyed.encodeString(_$TwitterUserSchema.nameName, instance.name);
    keyed.encodeString(_$TwitterUserSchema.nameScreenName, instance.screenName);
    keyed.encodeString(_$TwitterUserSchema.nameLocation, instance.location);
    keyed.encodeString(
      _$TwitterUserSchema.nameDescription,
      instance.description,
    );
    final v$Url = instance.url;
    if (v$Url != null) {
      keyed.encodeString(_$TwitterUserSchema.nameUrl, v$Url);
    }
    final v$Entities = instance.entities;
    if (v$Entities != null) {
      keyed.encodeValue(
        _$TwitterUserSchema.nameEntities,
        v$Entities,
        const TwitterUserEntitiesCodable(),
      );
    }
    keyed.encodeBool(_$TwitterUserSchema.nameProtected, instance.protected);
    keyed.encodeInt(
      _$TwitterUserSchema.nameFollowersCount,
      instance.followersCount,
    );
    keyed.encodeInt(
      _$TwitterUserSchema.nameFriendsCount,
      instance.friendsCount,
    );
    keyed.encodeInt(_$TwitterUserSchema.nameListedCount, instance.listedCount);
    keyed.encodeString(_$TwitterUserSchema.nameCreatedAt, instance.createdAt);
    keyed.encodeInt(
      _$TwitterUserSchema.nameFavouritesCount,
      instance.favouritesCount,
    );
    final v$UtcOffset = instance.utcOffset;
    if (v$UtcOffset != null) {
      keyed.encodeInt(_$TwitterUserSchema.nameUtcOffset, v$UtcOffset);
    }
    final v$TimeZone = instance.timeZone;
    if (v$TimeZone != null) {
      keyed.encodeString(_$TwitterUserSchema.nameTimeZone, v$TimeZone);
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
    keyed.encodeBool(
      _$TwitterUserSchema.nameIsTranslator,
      instance.isTranslator,
    );
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
    final v$ProfileBannerUrl = instance.profileBannerUrl;
    if (v$ProfileBannerUrl != null) {
      keyed.encodeString(
        _$TwitterUserSchema.nameProfileBannerUrl,
        v$ProfileBannerUrl,
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

  @override
  void encode(TwitterUser instance, Encoder encoder) {
    var count$ = 35;
    final v$Url = instance.url;
    if (v$Url != null) count$++;
    final v$Entities = instance.entities;
    if (v$Entities != null) count$++;
    final v$UtcOffset = instance.utcOffset;
    if (v$UtcOffset != null) count$++;
    final v$TimeZone = instance.timeZone;
    if (v$TimeZone != null) count$++;
    final v$ProfileBannerUrl = instance.profileBannerUrl;
    if (v$ProfileBannerUrl != null) count$++;
    final keyed = encoder.keyed(length: count$);
    keyed.encodeInt(_$TwitterUserSchema.nameId, instance.id);
    keyed.encodeString(_$TwitterUserSchema.nameIdStr, instance.idStr);
    keyed.encodeString(_$TwitterUserSchema.nameName, instance.name);
    keyed.encodeString(_$TwitterUserSchema.nameScreenName, instance.screenName);
    keyed.encodeString(_$TwitterUserSchema.nameLocation, instance.location);
    keyed.encodeString(
      _$TwitterUserSchema.nameDescription,
      instance.description,
    );
    if (v$Url != null) {
      keyed.encodeString(_$TwitterUserSchema.nameUrl, v$Url);
    }
    if (v$Entities != null) {
      keyed.encodeValue(
        _$TwitterUserSchema.nameEntities,
        v$Entities,
        const TwitterUserEntitiesCodable(),
      );
    }
    keyed.encodeBool(_$TwitterUserSchema.nameProtected, instance.protected);
    keyed.encodeInt(
      _$TwitterUserSchema.nameFollowersCount,
      instance.followersCount,
    );
    keyed.encodeInt(
      _$TwitterUserSchema.nameFriendsCount,
      instance.friendsCount,
    );
    keyed.encodeInt(_$TwitterUserSchema.nameListedCount, instance.listedCount);
    keyed.encodeString(_$TwitterUserSchema.nameCreatedAt, instance.createdAt);
    keyed.encodeInt(
      _$TwitterUserSchema.nameFavouritesCount,
      instance.favouritesCount,
    );
    if (v$UtcOffset != null) {
      keyed.encodeInt(_$TwitterUserSchema.nameUtcOffset, v$UtcOffset);
    }
    if (v$TimeZone != null) {
      keyed.encodeString(_$TwitterUserSchema.nameTimeZone, v$TimeZone);
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
    keyed.encodeBool(
      _$TwitterUserSchema.nameIsTranslator,
      instance.isTranslator,
    );
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
    if (v$ProfileBannerUrl != null) {
      keyed.encodeString(
        _$TwitterUserSchema.nameProfileBannerUrl,
        v$ProfileBannerUrl,
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
// 2. Companion Codable for TwitterStatus
// =============================================================================
final class TwitterStatusCodable implements KeyedCodable<TwitterStatus> {
  const TwitterStatusCodable();

  @override
  TwitterStatus decode(Decoder decoder) {
    final keyed = decoder.keyed(options: _$TwitterStatusSchema.keyOptions);

    TwitterMetadata? metadata;
    String? createdAt;
    int? id;
    String? idStr;
    String? text;
    String? source;
    bool truncated = false;
    int? inReplyToStatusId;
    String? inReplyToStatusIdStr;
    int? inReplyToUserId;
    String? inReplyToUserIdStr;
    String? inReplyToScreenName;
    TwitterUser? user;
    int retweetCount = 0;
    int favoriteCount = 0;
    TwitterEntities? entities;
    bool favorited = false;
    bool retweeted = false;
    bool? possiblySensitive;
    String lang = 'en';
    TwitterStatus? retweetedStatus;
    var seen = _$TwitterStatusSchema.none;

    while (keyed.moveNextKey()) {
      switch (keyed.selectKeyIndex(_$TwitterStatusSchema.keyOptions)) {
        case _$TwitterStatusSchema.keyMetadata:
          if (keyed.isNextNull()) {
            keyed.readNull();
            metadata = null;
          } else {
            metadata = const TwitterMetadataCodable().decode(
              keyed.nestedDecoder(),
            );
          }
          break;
        case _$TwitterStatusSchema.keyCreatedAt:
          if ((seen._value & _$TwitterStatusSchema.createdAt._value) != 0) {
            throw const CodableException('Duplicate field "created_at"');
          }
          createdAt = keyed.readString();
          seen |= _$TwitterStatusSchema.createdAt;
          break;
        case _$TwitterStatusSchema.keyId:
          if ((seen._value & _$TwitterStatusSchema.id._value) != 0) {
            throw const CodableException('Duplicate field "id"');
          }
          id = keyed.readInt();
          seen |= _$TwitterStatusSchema.id;
          break;
        case _$TwitterStatusSchema.keyIdStr:
          if ((seen._value & _$TwitterStatusSchema.idStr._value) != 0) {
            throw const CodableException('Duplicate field "id_str"');
          }
          idStr = keyed.readString();
          seen |= _$TwitterStatusSchema.idStr;
          break;
        case _$TwitterStatusSchema.keyText:
          if ((seen._value & _$TwitterStatusSchema.text._value) != 0) {
            throw const CodableException('Duplicate field "text"');
          }
          text = keyed.readString();
          seen |= _$TwitterStatusSchema.text;
          break;
        case _$TwitterStatusSchema.keySource:
          if ((seen._value & _$TwitterStatusSchema.source._value) != 0) {
            throw const CodableException('Duplicate field "source"');
          }
          source = keyed.readString();
          seen |= _$TwitterStatusSchema.source;
          break;
        case _$TwitterStatusSchema.keyTruncated:
          truncated = keyed.readBool();
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
            user = const TwitterUserCodable().decode(keyed.nestedDecoder());
          }
          break;
        case _$TwitterStatusSchema.keyRetweetCount:
          retweetCount = keyed.readInt();
          break;
        case _$TwitterStatusSchema.keyFavoriteCount:
          favoriteCount = keyed.readInt();
          break;
        case _$TwitterStatusSchema.keyEntities:
          if (keyed.isNextNull()) {
            keyed.readNull();
            entities = null;
          } else {
            entities = const TwitterEntitiesCodable().decode(
              keyed.nestedDecoder(),
            );
          }
          break;
        case _$TwitterStatusSchema.keyFavorited:
          favorited = keyed.readBool();
          break;
        case _$TwitterStatusSchema.keyRetweeted:
          retweeted = keyed.readBool();
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
          lang = keyed.readString();
          break;
        case _$TwitterStatusSchema.keyRetweetedStatus:
          if (keyed.isNextNull()) {
            keyed.readNull();
            retweetedStatus = null;
          } else {
            retweetedStatus = const TwitterStatusCodable().decode(
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

  @override
  int encodedFieldCount(TwitterStatus instance) {
    var count$ = 11;
    if (instance.metadata != null) count$++;
    if (instance.inReplyToStatusId != null) count$++;
    if (instance.inReplyToStatusIdStr != null) count$++;
    if (instance.inReplyToUserId != null) count$++;
    if (instance.inReplyToUserIdStr != null) count$++;
    if (instance.inReplyToScreenName != null) count$++;
    if (instance.user != null) count$++;
    if (instance.entities != null) count$++;
    if (instance.possiblySensitive != null) count$++;
    if (instance.retweetedStatus != null) count$++;
    return count$;
  }

  @override
  void encodeFields(TwitterStatus instance, KeyedEncoder keyed) {
    final v$Metadata = instance.metadata;
    if (v$Metadata != null) {
      keyed.encodeValue(
        _$TwitterStatusSchema.nameMetadata,
        v$Metadata,
        const TwitterMetadataCodable(),
      );
    }
    keyed.encodeString(_$TwitterStatusSchema.nameCreatedAt, instance.createdAt);
    keyed.encodeInt(_$TwitterStatusSchema.nameId, instance.id);
    keyed.encodeString(_$TwitterStatusSchema.nameIdStr, instance.idStr);
    keyed.encodeString(_$TwitterStatusSchema.nameText, instance.text);
    keyed.encodeString(_$TwitterStatusSchema.nameSource, instance.source);
    keyed.encodeBool(_$TwitterStatusSchema.nameTruncated, instance.truncated);
    final v$InReplyToStatusId = instance.inReplyToStatusId;
    if (v$InReplyToStatusId != null) {
      keyed.encodeInt(
        _$TwitterStatusSchema.nameInReplyToStatusId,
        v$InReplyToStatusId,
      );
    }
    final v$InReplyToStatusIdStr = instance.inReplyToStatusIdStr;
    if (v$InReplyToStatusIdStr != null) {
      keyed.encodeString(
        _$TwitterStatusSchema.nameInReplyToStatusIdStr,
        v$InReplyToStatusIdStr,
      );
    }
    final v$InReplyToUserId = instance.inReplyToUserId;
    if (v$InReplyToUserId != null) {
      keyed.encodeInt(
        _$TwitterStatusSchema.nameInReplyToUserId,
        v$InReplyToUserId,
      );
    }
    final v$InReplyToUserIdStr = instance.inReplyToUserIdStr;
    if (v$InReplyToUserIdStr != null) {
      keyed.encodeString(
        _$TwitterStatusSchema.nameInReplyToUserIdStr,
        v$InReplyToUserIdStr,
      );
    }
    final v$InReplyToScreenName = instance.inReplyToScreenName;
    if (v$InReplyToScreenName != null) {
      keyed.encodeString(
        _$TwitterStatusSchema.nameInReplyToScreenName,
        v$InReplyToScreenName,
      );
    }
    final v$User = instance.user;
    if (v$User != null) {
      keyed.encodeValue(
        _$TwitterStatusSchema.nameUser,
        v$User,
        const TwitterUserCodable(),
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
    final v$Entities = instance.entities;
    if (v$Entities != null) {
      keyed.encodeValue(
        _$TwitterStatusSchema.nameEntities,
        v$Entities,
        const TwitterEntitiesCodable(),
      );
    }
    keyed.encodeBool(_$TwitterStatusSchema.nameFavorited, instance.favorited);
    keyed.encodeBool(_$TwitterStatusSchema.nameRetweeted, instance.retweeted);
    final v$PossiblySensitive = instance.possiblySensitive;
    if (v$PossiblySensitive != null) {
      keyed.encodeBool(
        _$TwitterStatusSchema.namePossiblySensitive,
        v$PossiblySensitive,
      );
    }
    keyed.encodeString(_$TwitterStatusSchema.nameLang, instance.lang);
    final v$RetweetedStatus = instance.retweetedStatus;
    if (v$RetweetedStatus != null) {
      keyed.encodeValue(
        _$TwitterStatusSchema.nameRetweetedStatus,
        v$RetweetedStatus,
        const TwitterStatusCodable(),
      );
    }
  }

  @override
  void encode(TwitterStatus instance, Encoder encoder) {
    var count$ = 11;
    final v$Metadata = instance.metadata;
    if (v$Metadata != null) count$++;
    final v$InReplyToStatusId = instance.inReplyToStatusId;
    if (v$InReplyToStatusId != null) count$++;
    final v$InReplyToStatusIdStr = instance.inReplyToStatusIdStr;
    if (v$InReplyToStatusIdStr != null) count$++;
    final v$InReplyToUserId = instance.inReplyToUserId;
    if (v$InReplyToUserId != null) count$++;
    final v$InReplyToUserIdStr = instance.inReplyToUserIdStr;
    if (v$InReplyToUserIdStr != null) count$++;
    final v$InReplyToScreenName = instance.inReplyToScreenName;
    if (v$InReplyToScreenName != null) count$++;
    final v$User = instance.user;
    if (v$User != null) count$++;
    final v$Entities = instance.entities;
    if (v$Entities != null) count$++;
    final v$PossiblySensitive = instance.possiblySensitive;
    if (v$PossiblySensitive != null) count$++;
    final v$RetweetedStatus = instance.retweetedStatus;
    if (v$RetweetedStatus != null) count$++;
    final keyed = encoder.keyed(length: count$);
    if (v$Metadata != null) {
      keyed.encodeValue(
        _$TwitterStatusSchema.nameMetadata,
        v$Metadata,
        const TwitterMetadataCodable(),
      );
    }
    keyed.encodeString(_$TwitterStatusSchema.nameCreatedAt, instance.createdAt);
    keyed.encodeInt(_$TwitterStatusSchema.nameId, instance.id);
    keyed.encodeString(_$TwitterStatusSchema.nameIdStr, instance.idStr);
    keyed.encodeString(_$TwitterStatusSchema.nameText, instance.text);
    keyed.encodeString(_$TwitterStatusSchema.nameSource, instance.source);
    keyed.encodeBool(_$TwitterStatusSchema.nameTruncated, instance.truncated);
    if (v$InReplyToStatusId != null) {
      keyed.encodeInt(
        _$TwitterStatusSchema.nameInReplyToStatusId,
        v$InReplyToStatusId,
      );
    }
    if (v$InReplyToStatusIdStr != null) {
      keyed.encodeString(
        _$TwitterStatusSchema.nameInReplyToStatusIdStr,
        v$InReplyToStatusIdStr,
      );
    }
    if (v$InReplyToUserId != null) {
      keyed.encodeInt(
        _$TwitterStatusSchema.nameInReplyToUserId,
        v$InReplyToUserId,
      );
    }
    if (v$InReplyToUserIdStr != null) {
      keyed.encodeString(
        _$TwitterStatusSchema.nameInReplyToUserIdStr,
        v$InReplyToUserIdStr,
      );
    }
    if (v$InReplyToScreenName != null) {
      keyed.encodeString(
        _$TwitterStatusSchema.nameInReplyToScreenName,
        v$InReplyToScreenName,
      );
    }
    if (v$User != null) {
      keyed.encodeValue(
        _$TwitterStatusSchema.nameUser,
        v$User,
        const TwitterUserCodable(),
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
    if (v$Entities != null) {
      keyed.encodeValue(
        _$TwitterStatusSchema.nameEntities,
        v$Entities,
        const TwitterEntitiesCodable(),
      );
    }
    keyed.encodeBool(_$TwitterStatusSchema.nameFavorited, instance.favorited);
    keyed.encodeBool(_$TwitterStatusSchema.nameRetweeted, instance.retweeted);
    if (v$PossiblySensitive != null) {
      keyed.encodeBool(
        _$TwitterStatusSchema.namePossiblySensitive,
        v$PossiblySensitive,
      );
    }
    keyed.encodeString(_$TwitterStatusSchema.nameLang, instance.lang);
    if (v$RetweetedStatus != null) {
      keyed.encodeValue(
        _$TwitterStatusSchema.nameRetweetedStatus,
        v$RetweetedStatus,
        const TwitterStatusCodable(),
      );
    }
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
// 2. Companion Codable for TwitterSearchMetadata
// =============================================================================
final class TwitterSearchMetadataCodable
    implements KeyedCodable<TwitterSearchMetadata> {
  const TwitterSearchMetadataCodable();

  @override
  TwitterSearchMetadata decode(Decoder decoder) {
    final keyed = decoder.keyed(
      options: _$TwitterSearchMetadataSchema.keyOptions,
    );

    double? completedIn;
    int? maxId;
    String? maxIdStr;
    String nextResults = '';
    String? query;
    String refreshUrl = '';
    int? count;
    int sinceId = 0;
    String sinceIdStr = '0';
    var seen = _$TwitterSearchMetadataSchema.none;

    while (keyed.moveNextKey()) {
      switch (keyed.selectKeyIndex(_$TwitterSearchMetadataSchema.keyOptions)) {
        case _$TwitterSearchMetadataSchema.keyCompletedIn:
          if ((seen._value &
                  _$TwitterSearchMetadataSchema.completedIn._value) !=
              0) {
            throw const CodableException('Duplicate field "completed_in"');
          }
          completedIn = keyed.readDouble();
          seen |= _$TwitterSearchMetadataSchema.completedIn;
          break;
        case _$TwitterSearchMetadataSchema.keyMaxId:
          if ((seen._value & _$TwitterSearchMetadataSchema.maxId._value) != 0) {
            throw const CodableException('Duplicate field "max_id"');
          }
          maxId = keyed.readInt();
          seen |= _$TwitterSearchMetadataSchema.maxId;
          break;
        case _$TwitterSearchMetadataSchema.keyMaxIdStr:
          if ((seen._value & _$TwitterSearchMetadataSchema.maxIdStr._value) !=
              0) {
            throw const CodableException('Duplicate field "max_id_str"');
          }
          maxIdStr = keyed.readString();
          seen |= _$TwitterSearchMetadataSchema.maxIdStr;
          break;
        case _$TwitterSearchMetadataSchema.keyNextResults:
          nextResults = keyed.readString();
          break;
        case _$TwitterSearchMetadataSchema.keyQuery:
          if ((seen._value & _$TwitterSearchMetadataSchema.query._value) != 0) {
            throw const CodableException('Duplicate field "query"');
          }
          query = keyed.readString();
          seen |= _$TwitterSearchMetadataSchema.query;
          break;
        case _$TwitterSearchMetadataSchema.keyRefreshUrl:
          refreshUrl = keyed.readString();
          break;
        case _$TwitterSearchMetadataSchema.keyCount:
          if ((seen._value & _$TwitterSearchMetadataSchema.count._value) != 0) {
            throw const CodableException('Duplicate field "count"');
          }
          count = keyed.readInt();
          seen |= _$TwitterSearchMetadataSchema.count;
          break;
        case _$TwitterSearchMetadataSchema.keySinceId:
          sinceId = keyed.readInt();
          break;
        case _$TwitterSearchMetadataSchema.keySinceIdStr:
          sinceIdStr = keyed.readString();
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

  @override
  int encodedFieldCount(TwitterSearchMetadata instance) => 9;

  @override
  void encodeFields(TwitterSearchMetadata instance, KeyedEncoder keyed) {
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
    keyed.encodeInt(
      _$TwitterSearchMetadataSchema.nameSinceId,
      instance.sinceId,
    );
    keyed.encodeString(
      _$TwitterSearchMetadataSchema.nameSinceIdStr,
      instance.sinceIdStr,
    );
  }

  @override
  void encode(TwitterSearchMetadata instance, Encoder encoder) {
    encodeFields(instance, encoder.keyed(length: 9));
  }
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
// 2. Companion Codable for TwitterResponse
// =============================================================================
final class TwitterResponseCodable implements KeyedCodable<TwitterResponse> {
  const TwitterResponseCodable();

  @override
  TwitterResponse decode(Decoder decoder) {
    final keyed = decoder.keyed(options: _$TwitterResponseSchema.keyOptions);

    List<TwitterStatus> statuses = const [];
    TwitterSearchMetadata? searchMetadata;
    var seen = _$TwitterResponseSchema.none;

    while (keyed.moveNextKey()) {
      switch (keyed.selectKeyIndex(_$TwitterResponseSchema.keyOptions)) {
        case _$TwitterResponseSchema.keyStatuses:
          statuses = const TwitterStatusCodable().decodeList(
            keyed.nestedDecoder(),
          );
          break;
        case _$TwitterResponseSchema.keySearchMetadata:
          if ((seen._value & _$TwitterResponseSchema.searchMetadata._value) !=
              0) {
            throw const CodableException('Duplicate field "search_metadata"');
          }
          searchMetadata = const TwitterSearchMetadataCodable().decode(
            keyed.nestedDecoder(),
          );
          seen |= _$TwitterResponseSchema.searchMetadata;
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

  @override
  int encodedFieldCount(TwitterResponse instance) => 2;

  @override
  void encodeFields(TwitterResponse instance, KeyedEncoder keyed) {
    keyed.encodeList(
      _$TwitterResponseSchema.nameStatuses,
      instance.statuses,
      const TwitterStatusCodable(),
    );
    keyed.encodeValue(
      _$TwitterResponseSchema.nameSearchMetadata,
      instance.searchMetadata,
      const TwitterSearchMetadataCodable(),
    );
  }

  @override
  void encode(TwitterResponse instance, Encoder encoder) {
    encodeFields(instance, encoder.keyed(length: 2));
  }
}
