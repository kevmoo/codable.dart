// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:codable/codable.dart';

part 'twitter.g.dart';

@Codable(fieldRename: FieldRename.snake)
class TwitterMetadata {
  final String resultType;
  final String isoLanguageCode;

  const TwitterMetadata({this.resultType = '', this.isoLanguageCode = ''});

  static TwitterMetadata decode(Decoder decoder) =>
      _$TwitterMetadataFromDecoder(decoder);
  void encode(Encoder encoder) => _$TwitterMetadataToEncoder(this, encoder);
}

@Codable(fieldRename: FieldRename.snake)
class TwitterUserMention {
  final String screenName;
  final String name;
  final int id;
  final String idStr;
  final List<int> indices;

  const TwitterUserMention({
    required this.screenName,
    required this.name,
    required this.id,
    required this.idStr,
    this.indices = const [],
  });

  static TwitterUserMention decode(Decoder decoder) =>
      _$TwitterUserMentionFromDecoder(decoder);
  void encode(Encoder encoder) => _$TwitterUserMentionToEncoder(this, encoder);
}

@Codable(fieldRename: FieldRename.snake)
class TwitterUrl {
  final String url;
  final String expandedUrl;
  final String displayUrl;
  final List<int> indices;

  const TwitterUrl({
    required this.url,
    required this.expandedUrl,
    required this.displayUrl,
    this.indices = const [],
  });

  static TwitterUrl decode(Decoder decoder) => _$TwitterUrlFromDecoder(decoder);
  void encode(Encoder encoder) => _$TwitterUrlToEncoder(this, encoder);
}

@Codable(fieldRename: FieldRename.snake)
class TwitterEntitiesUrls {
  final List<TwitterUrl> urls;

  const TwitterEntitiesUrls({this.urls = const []});

  static TwitterEntitiesUrls decode(Decoder decoder) =>
      _$TwitterEntitiesUrlsFromDecoder(decoder);
  void encode(Encoder encoder) => _$TwitterEntitiesUrlsToEncoder(this, encoder);
}

@Codable(fieldRename: FieldRename.snake)
class TwitterUserEntities {
  final TwitterEntitiesUrls? url;
  final TwitterEntitiesUrls? description;

  const TwitterUserEntities({this.url, this.description});

  static TwitterUserEntities decode(Decoder decoder) =>
      _$TwitterUserEntitiesFromDecoder(decoder);
  void encode(Encoder encoder) => _$TwitterUserEntitiesToEncoder(this, encoder);
}

@Codable(fieldRename: FieldRename.snake)
class TwitterEntities {
  final List<TwitterUrl> urls;
  final List<TwitterUserMention> userMentions;

  const TwitterEntities({this.urls = const [], this.userMentions = const []});

  static TwitterEntities decode(Decoder decoder) =>
      _$TwitterEntitiesFromDecoder(decoder);
  void encode(Encoder encoder) => _$TwitterEntitiesToEncoder(this, encoder);
}

@Codable(fieldRename: FieldRename.snake)
class TwitterUser {
  final int id;
  final String idStr;
  final String name;
  final String screenName;
  final String location;
  final String description;
  final String? url;
  final TwitterUserEntities? entities;
  final bool protected;
  final int followersCount;
  final int friendsCount;
  final int listedCount;
  final String createdAt;
  final int favouritesCount;
  final int? utcOffset;
  final String? timeZone;
  final bool geoEnabled;
  final bool verified;
  final int statusesCount;
  final String lang;
  final bool contributorsEnabled;
  final bool isTranslator;
  final bool isTranslationEnabled;
  final String profileBackgroundColor;
  final String profileBackgroundImageUrl;
  final String profileBackgroundImageUrlHttps;
  final bool profileBackgroundTile;
  final String profileImageUrl;
  final String profileImageUrlHttps;
  final String? profileBannerUrl;
  final String profileLinkColor;
  final String profileSidebarBorderColor;
  final String profileSidebarFillColor;
  final String profileTextColor;
  final bool profileUseBackgroundImage;
  final bool defaultProfile;
  final bool defaultProfileImage;
  final bool following;
  final bool followRequestSent;
  final bool notifications;

  const TwitterUser({
    required this.id,
    required this.idStr,
    required this.name,
    required this.screenName,
    this.location = '',
    this.description = '',
    this.url,
    this.entities,
    this.protected = false,
    this.followersCount = 0,
    this.friendsCount = 0,
    this.listedCount = 0,
    required this.createdAt,
    this.favouritesCount = 0,
    this.utcOffset,
    this.timeZone,
    this.geoEnabled = false,
    this.verified = false,
    this.statusesCount = 0,
    this.lang = 'en',
    this.contributorsEnabled = false,
    this.isTranslator = false,
    this.isTranslationEnabled = false,
    this.profileBackgroundColor = '',
    this.profileBackgroundImageUrl = '',
    this.profileBackgroundImageUrlHttps = '',
    this.profileBackgroundTile = false,
    this.profileImageUrl = '',
    this.profileImageUrlHttps = '',
    this.profileBannerUrl,
    this.profileLinkColor = '',
    this.profileSidebarBorderColor = '',
    this.profileSidebarFillColor = '',
    this.profileTextColor = '',
    this.profileUseBackgroundImage = false,
    this.defaultProfile = false,
    this.defaultProfileImage = false,
    this.following = false,
    this.followRequestSent = false,
    this.notifications = false,
  });

  static TwitterUser decode(Decoder decoder) =>
      _$TwitterUserFromDecoder(decoder);
  void encode(Encoder encoder) => _$TwitterUserToEncoder(this, encoder);
}

@Codable(fieldRename: FieldRename.snake)
class TwitterStatus {
  final TwitterMetadata? metadata;
  final String createdAt;
  final int id;
  final String idStr;
  final String text;
  final String source;
  final bool truncated;
  final int? inReplyToStatusId;
  final String? inReplyToStatusIdStr;
  final int? inReplyToUserId;
  final String? inReplyToUserIdStr;
  final String? inReplyToScreenName;
  final TwitterUser? user;
  final int retweetCount;
  final int favoriteCount;
  final TwitterEntities? entities;
  final bool favorited;
  final bool retweeted;
  final bool? possiblySensitive;
  final String lang;
  final TwitterStatus? retweetedStatus;

  const TwitterStatus({
    this.metadata,
    required this.createdAt,
    required this.id,
    required this.idStr,
    required this.text,
    required this.source,
    this.truncated = false,
    this.inReplyToStatusId,
    this.inReplyToStatusIdStr,
    this.inReplyToUserId,
    this.inReplyToUserIdStr,
    this.inReplyToScreenName,
    this.user,
    this.retweetCount = 0,
    this.favoriteCount = 0,
    this.entities,
    this.favorited = false,
    this.retweeted = false,
    this.possiblySensitive,
    this.lang = 'en',
    this.retweetedStatus,
  });

  static TwitterStatus decode(Decoder decoder) =>
      _$TwitterStatusFromDecoder(decoder);
  void encode(Encoder encoder) => _$TwitterStatusToEncoder(this, encoder);
}

@Codable(fieldRename: FieldRename.snake)
class TwitterSearchMetadata {
  final double completedIn;
  final int maxId;
  final String maxIdStr;
  final String nextResults;
  final String query;
  final String refreshUrl;
  final int count;
  final int sinceId;
  final String sinceIdStr;

  const TwitterSearchMetadata({
    required this.completedIn,
    required this.maxId,
    required this.maxIdStr,
    this.nextResults = '',
    required this.query,
    this.refreshUrl = '',
    required this.count,
    this.sinceId = 0,
    this.sinceIdStr = '0',
  });

  static TwitterSearchMetadata decode(Decoder decoder) =>
      _$TwitterSearchMetadataFromDecoder(decoder);
  void encode(Encoder encoder) =>
      _$TwitterSearchMetadataToEncoder(this, encoder);
}

@Codable(fieldRename: FieldRename.snake)
class TwitterResponse {
  final List<TwitterStatus> statuses;
  final TwitterSearchMetadata searchMetadata;

  const TwitterResponse({
    this.statuses = const [],
    required this.searchMetadata,
  });

  static TwitterResponse decode(Decoder decoder) =>
      _$TwitterResponseFromDecoder(decoder);
  void encode(Encoder encoder) => _$TwitterResponseToEncoder(this, encoder);
}
