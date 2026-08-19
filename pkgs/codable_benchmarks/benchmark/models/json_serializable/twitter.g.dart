// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: lines_longer_than_80_chars

part of 'twitter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TwitterMetadata _$TwitterMetadataFromJson(Map<String, dynamic> json) =>
    TwitterMetadata(
      resultType: json['result_type'] as String? ?? '',
      isoLanguageCode: json['iso_language_code'] as String? ?? '',
    );

Map<String, dynamic> _$TwitterMetadataToJson(TwitterMetadata instance) =>
    <String, dynamic>{
      'result_type': instance.resultType,
      'iso_language_code': instance.isoLanguageCode,
    };

TwitterUserMention _$TwitterUserMentionFromJson(Map<String, dynamic> json) =>
    TwitterUserMention(
      screenName: json['screen_name'] as String,
      name: json['name'] as String,
      id: (json['id'] as num).toInt(),
      idStr: json['id_str'] as String,
      indices:
          (json['indices'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
    );

Map<String, dynamic> _$TwitterUserMentionToJson(TwitterUserMention instance) =>
    <String, dynamic>{
      'screen_name': instance.screenName,
      'name': instance.name,
      'id': instance.id,
      'id_str': instance.idStr,
      'indices': instance.indices,
    };

TwitterUrl _$TwitterUrlFromJson(Map<String, dynamic> json) => TwitterUrl(
  url: json['url'] as String,
  expandedUrl: json['expanded_url'] as String,
  displayUrl: json['display_url'] as String,
  indices:
      (json['indices'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList() ??
      const [],
);

Map<String, dynamic> _$TwitterUrlToJson(TwitterUrl instance) =>
    <String, dynamic>{
      'url': instance.url,
      'expanded_url': instance.expandedUrl,
      'display_url': instance.displayUrl,
      'indices': instance.indices,
    };

TwitterEntitiesUrls _$TwitterEntitiesUrlsFromJson(Map<String, dynamic> json) =>
    TwitterEntitiesUrls(
      urls:
          (json['urls'] as List<dynamic>?)
              ?.map((e) => TwitterUrl.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$TwitterEntitiesUrlsToJson(
  TwitterEntitiesUrls instance,
) => <String, dynamic>{'urls': instance.urls};

TwitterUserEntities _$TwitterUserEntitiesFromJson(Map<String, dynamic> json) =>
    TwitterUserEntities(
      url: json['url'] == null
          ? null
          : TwitterEntitiesUrls.fromJson(json['url'] as Map<String, dynamic>),
      description: json['description'] == null
          ? null
          : TwitterEntitiesUrls.fromJson(
              json['description'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$TwitterUserEntitiesToJson(
  TwitterUserEntities instance,
) => <String, dynamic>{
  'url': instance.url,
  'description': instance.description,
};

TwitterEntities _$TwitterEntitiesFromJson(Map<String, dynamic> json) =>
    TwitterEntities(
      urls:
          (json['urls'] as List<dynamic>?)
              ?.map((e) => TwitterUrl.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      userMentions:
          (json['user_mentions'] as List<dynamic>?)
              ?.map(
                (e) => TwitterUserMention.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
    );

Map<String, dynamic> _$TwitterEntitiesToJson(TwitterEntities instance) =>
    <String, dynamic>{
      'urls': instance.urls,
      'user_mentions': instance.userMentions,
    };

TwitterUser _$TwitterUserFromJson(Map<String, dynamic> json) => TwitterUser(
  id: (json['id'] as num).toInt(),
  idStr: json['id_str'] as String,
  name: json['name'] as String,
  screenName: json['screen_name'] as String,
  location: json['location'] as String? ?? '',
  description: json['description'] as String? ?? '',
  url: json['url'] as String?,
  entities: json['entities'] == null
      ? null
      : TwitterUserEntities.fromJson(json['entities'] as Map<String, dynamic>),
  protected: json['protected'] as bool? ?? false,
  followersCount: (json['followers_count'] as num?)?.toInt() ?? 0,
  friendsCount: (json['friends_count'] as num?)?.toInt() ?? 0,
  listedCount: (json['listed_count'] as num?)?.toInt() ?? 0,
  createdAt: json['created_at'] as String,
  favouritesCount: (json['favourites_count'] as num?)?.toInt() ?? 0,
  utcOffset: (json['utc_offset'] as num?)?.toInt(),
  timeZone: json['time_zone'] as String?,
  geoEnabled: json['geo_enabled'] as bool? ?? false,
  verified: json['verified'] as bool? ?? false,
  statusesCount: (json['statuses_count'] as num?)?.toInt() ?? 0,
  lang: json['lang'] as String? ?? 'en',
  contributorsEnabled: json['contributors_enabled'] as bool? ?? false,
  isTranslator: json['is_translator'] as bool? ?? false,
  isTranslationEnabled: json['is_translation_enabled'] as bool? ?? false,
  profileBackgroundColor: json['profile_background_color'] as String? ?? '',
  profileBackgroundImageUrl:
      json['profile_background_image_url'] as String? ?? '',
  profileBackgroundImageUrlHttps:
      json['profile_background_image_url_https'] as String? ?? '',
  profileBackgroundTile: json['profile_background_tile'] as bool? ?? false,
  profileImageUrl: json['profile_image_url'] as String? ?? '',
  profileImageUrlHttps: json['profile_image_url_https'] as String? ?? '',
  profileBannerUrl: json['profile_banner_url'] as String?,
  profileLinkColor: json['profile_link_color'] as String? ?? '',
  profileSidebarBorderColor:
      json['profile_sidebar_border_color'] as String? ?? '',
  profileSidebarFillColor: json['profile_sidebar_fill_color'] as String? ?? '',
  profileTextColor: json['profile_text_color'] as String? ?? '',
  profileUseBackgroundImage:
      json['profile_use_background_image'] as bool? ?? false,
  defaultProfile: json['default_profile'] as bool? ?? false,
  defaultProfileImage: json['default_profile_image'] as bool? ?? false,
  following: json['following'] as bool? ?? false,
  followRequestSent: json['follow_request_sent'] as bool? ?? false,
  notifications: json['notifications'] as bool? ?? false,
);

Map<String, dynamic> _$TwitterUserToJson(
  TwitterUser instance,
) => <String, dynamic>{
  'id': instance.id,
  'id_str': instance.idStr,
  'name': instance.name,
  'screen_name': instance.screenName,
  'location': instance.location,
  'description': instance.description,
  'url': instance.url,
  'entities': instance.entities,
  'protected': instance.protected,
  'followers_count': instance.followersCount,
  'friends_count': instance.friendsCount,
  'listed_count': instance.listedCount,
  'created_at': instance.createdAt,
  'favourites_count': instance.favouritesCount,
  'utc_offset': instance.utcOffset,
  'time_zone': instance.timeZone,
  'geo_enabled': instance.geoEnabled,
  'verified': instance.verified,
  'statuses_count': instance.statusesCount,
  'lang': instance.lang,
  'contributors_enabled': instance.contributorsEnabled,
  'is_translator': instance.isTranslator,
  'is_translation_enabled': instance.isTranslationEnabled,
  'profile_background_color': instance.profileBackgroundColor,
  'profile_background_image_url': instance.profileBackgroundImageUrl,
  'profile_background_image_url_https': instance.profileBackgroundImageUrlHttps,
  'profile_background_tile': instance.profileBackgroundTile,
  'profile_image_url': instance.profileImageUrl,
  'profile_image_url_https': instance.profileImageUrlHttps,
  'profile_banner_url': instance.profileBannerUrl,
  'profile_link_color': instance.profileLinkColor,
  'profile_sidebar_border_color': instance.profileSidebarBorderColor,
  'profile_sidebar_fill_color': instance.profileSidebarFillColor,
  'profile_text_color': instance.profileTextColor,
  'profile_use_background_image': instance.profileUseBackgroundImage,
  'default_profile': instance.defaultProfile,
  'default_profile_image': instance.defaultProfileImage,
  'following': instance.following,
  'follow_request_sent': instance.followRequestSent,
  'notifications': instance.notifications,
};

TwitterStatus _$TwitterStatusFromJson(Map<String, dynamic> json) =>
    TwitterStatus(
      metadata: json['metadata'] == null
          ? null
          : TwitterMetadata.fromJson(json['metadata'] as Map<String, dynamic>),
      createdAt: json['created_at'] as String,
      id: (json['id'] as num).toInt(),
      idStr: json['id_str'] as String,
      text: json['text'] as String,
      source: json['source'] as String,
      truncated: json['truncated'] as bool? ?? false,
      inReplyToStatusId: (json['in_reply_to_status_id'] as num?)?.toInt(),
      inReplyToStatusIdStr: json['in_reply_to_status_id_str'] as String?,
      inReplyToUserId: (json['in_reply_to_user_id'] as num?)?.toInt(),
      inReplyToUserIdStr: json['in_reply_to_user_id_str'] as String?,
      inReplyToScreenName: json['in_reply_to_screen_name'] as String?,
      user: json['user'] == null
          ? null
          : TwitterUser.fromJson(json['user'] as Map<String, dynamic>),
      retweetCount: (json['retweet_count'] as num?)?.toInt() ?? 0,
      favoriteCount: (json['favorite_count'] as num?)?.toInt() ?? 0,
      entities: json['entities'] == null
          ? null
          : TwitterEntities.fromJson(json['entities'] as Map<String, dynamic>),
      favorited: json['favorited'] as bool? ?? false,
      retweeted: json['retweeted'] as bool? ?? false,
      possiblySensitive: json['possibly_sensitive'] as bool?,
      lang: json['lang'] as String? ?? 'en',
      retweetedStatus: json['retweeted_status'] == null
          ? null
          : TwitterStatus.fromJson(
              json['retweeted_status'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$TwitterStatusToJson(TwitterStatus instance) =>
    <String, dynamic>{
      'metadata': instance.metadata,
      'created_at': instance.createdAt,
      'id': instance.id,
      'id_str': instance.idStr,
      'text': instance.text,
      'source': instance.source,
      'truncated': instance.truncated,
      'in_reply_to_status_id': instance.inReplyToStatusId,
      'in_reply_to_status_id_str': instance.inReplyToStatusIdStr,
      'in_reply_to_user_id': instance.inReplyToUserId,
      'in_reply_to_user_id_str': instance.inReplyToUserIdStr,
      'in_reply_to_screen_name': instance.inReplyToScreenName,
      'user': instance.user,
      'retweet_count': instance.retweetCount,
      'favorite_count': instance.favoriteCount,
      'entities': instance.entities,
      'favorited': instance.favorited,
      'retweeted': instance.retweeted,
      'possibly_sensitive': instance.possiblySensitive,
      'lang': instance.lang,
      'retweeted_status': instance.retweetedStatus,
    };

TwitterSearchMetadata _$TwitterSearchMetadataFromJson(
  Map<String, dynamic> json,
) => TwitterSearchMetadata(
  completedIn: (json['completed_in'] as num).toDouble(),
  maxId: (json['max_id'] as num).toInt(),
  maxIdStr: json['max_id_str'] as String,
  nextResults: json['next_results'] as String? ?? '',
  query: json['query'] as String,
  refreshUrl: json['refresh_url'] as String? ?? '',
  count: (json['count'] as num).toInt(),
  sinceId: (json['since_id'] as num?)?.toInt() ?? 0,
  sinceIdStr: json['since_id_str'] as String? ?? '0',
);

Map<String, dynamic> _$TwitterSearchMetadataToJson(
  TwitterSearchMetadata instance,
) => <String, dynamic>{
  'completed_in': instance.completedIn,
  'max_id': instance.maxId,
  'max_id_str': instance.maxIdStr,
  'next_results': instance.nextResults,
  'query': instance.query,
  'refresh_url': instance.refreshUrl,
  'count': instance.count,
  'since_id': instance.sinceId,
  'since_id_str': instance.sinceIdStr,
};

TwitterResponse _$TwitterResponseFromJson(Map<String, dynamic> json) =>
    TwitterResponse(
      statuses:
          (json['statuses'] as List<dynamic>?)
              ?.map((e) => TwitterStatus.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      searchMetadata: TwitterSearchMetadata.fromJson(
        json['search_metadata'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$TwitterResponseToJson(TwitterResponse instance) =>
    <String, dynamic>{
      'statuses': instance.statuses,
      'search_metadata': instance.searchMetadata,
    };
