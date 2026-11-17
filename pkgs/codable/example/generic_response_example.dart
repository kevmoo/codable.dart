// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Demonstrates generic `@Codable()` companion synthesis (`BaseResponse<T>` ->
/// `BaseResponseCodable<T>`) across concrete models, `.list` collections, and
/// `.nullable` payloads.
library;

import 'package:codable/codable_json.dart';

part 'generic_response_example.g.dart';

/// Generic API envelope whose companion `BaseResponseCodable<T>` accepts an
/// inner `Codable<T>` for [data].
///
/// When [T] is instantiated with a nullable type (such as `Article?`), null
/// [data] values are omitted on encode and optional on decode.
@Codable()
class BaseResponse<T> {
  final int status;
  final String message;
  final T data;

  const BaseResponse({
    required this.status,
    required this.message,
    required this.data,
  });
}

/// Nested domain model carrying an optional [author].
@Codable()
class Article {
  final int id;
  final String title;
  final User? author;

  const Article({required this.id, required this.title, this.author});
}

/// Author metadata nested inside [Article] or `BaseResponse<List<User>>`.
@Codable()
class User {
  final int id;
  final String email;

  const User({required this.id, required this.email});
}

void main() {
  // 1. Zero-allocation `const` companion for a concrete `@Codable()` payload.
  const articleCodec = BaseResponseCodable<Article>(ArticleCodable());
  const articleJson = '''
  {
    "status": 200,
    "message": "OK",
    "data": {
      "id": 101,
      "title": "High Performance Dart 4",
      "author": {"id": 1, "email": "dev@dart.dev"}
    }
  }
  ''';
  final articleRes = JsonCodableDecoder.decode(articleJson, articleCodec);
  print(
    '${articleRes.status} ${articleRes.data.title} '
    '(${articleRes.data.author?.email})',
  );
  print('Encoded: ${JsonCodableEncoder.encode(articleRes, articleCodec)}');

  // 2. Compose `.list` to decode and encode `BaseResponse<List<User>>`.
  final usersCodec = BaseResponseCodable<List<User>>(const UserCodable().list);
  const usersJson =
      '{"status":200,"message":"OK",'
      '"data":[{"id":1,"email":"ada@dart.dev"},{"id":2,"email":"bob@dart.dev"}]}';
  final usersRes = JsonCodableDecoder.decode(usersJson, usersCodec);
  print('Loaded ${usersRes.data.length} users');

  // 3. Compose `.nullable` for `BaseResponse<Article?>` (omits null `data`).
  final nullableCodec = BaseResponseCodable<Article?>(
    const ArticleCodable().nullable,
  );
  const emptyRes = BaseResponse<Article?>(
    status: 204,
    message: 'No Content',
    data: null,
  );
  final emptyJson = JsonCodableEncoder.encode(emptyRes, nullableCodec);
  print('204 envelope: $emptyJson');
}
