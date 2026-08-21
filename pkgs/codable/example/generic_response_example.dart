// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// ignore_for_file: unreachable_from_main

import 'dart:convert';

import 'package:codable/codable_json.dart';

part 'generic_response_example.g.dart';

/// Generic payload envelope demonstrating parameterized type decoding
/// without intermediate DOM map structures.
class BaseResponse<T> {
  final int status;
  final String message;
  final T data;

  const BaseResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  static BaseResponse<T> decode<T>(
    Decoder decoder,
    T Function(Decoder decoder) decodeData,
  ) {
    final keyed = decoder.keyed();
    int? status;
    String? message;
    T? data;

    while (keyed.hasNextKey()) {
      final key = keyed.nextKey();
      switch (key) {
        case 'status':
          status = keyed.readInt();
          break;
        case 'message':
          message = keyed.readString();
          break;
        case 'data':
          data = keyed.decodeValue(decodeData);
          break;
        default:
          keyed.skipValue();
          break;
      }
    }

    if (status == null || message == null || data == null) {
      throw const CodableException('Missing required fields for BaseResponse');
    }
    return BaseResponse(status: status, message: message, data: data);
  }
}

@Codable()
class Article {
  final int id;
  final String title;
  final User? author;

  const Article({required this.id, required this.title, this.author});

  static Article decode(Decoder decoder) => _$ArticleFromDecoder(decoder);
  void encode(Encoder encoder) => _$ArticleToEncoder(this, encoder);
}

@Codable()
class User {
  final int id;
  final String email;

  const User({required this.id, required this.email});

  static User decode(Decoder decoder) => _$UserFromDecoder(decoder);
  void encode(Encoder encoder) => _$UserToEncoder(this, encoder);
}

void main() {
  const json = '''
  {
    "status": 200,
    "message": "OK",
    "data": {
      "id": 101,
      "title": "High Performance Dart 4",
      "author": {
        "id": 1,
        "email": "dev@dart.dev"
      }
    }
  }
  ''';

  final bytes = Uint8List.fromList(utf8.encode(json));
  final decoder = JsonCodableDecoder.fromBytes(bytes);
  final response = BaseResponse.decode(decoder, Article.decode);

  print('Response: ${response.status} - ${response.message}');
  print('Article: ${response.data.title} by ${response.data.author?.email}');

  final outBytes = JsonCodableEncoder.toBytes(response.data.encode);
  print('Serialized article: ${utf8.decode(outBytes)}');
}
