// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// ignore_for_file: unreachable_from_main

import 'dart:convert';
import 'dart:typed_data';

import 'package:codable/codable_json.dart';

part 'generic_response_example.g.dart';

/// Generic payload envelope demonstrating parameterized `@Codable()` synthesis
/// without intermediate object tree map structures.
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

@Codable()
class Article {
  final int id;
  final String title;
  final User? author;

  const Article({required this.id, required this.title, this.author});
}

@Codable()
class User {
  final int id;
  final String email;

  const User({required this.id, required this.email});
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

  const responseCodable = BaseResponseCodable<Article>(ArticleCodable());
  final bytes = Uint8List.fromList(utf8.encode(json));
  final response = responseCodable.decode(JsonCodableDecoder.fromBytes(bytes));

  print('Response: ${response.status} - ${response.message}');
  print('Article: ${response.data.title} by ${response.data.author?.email}');

  final outBytes = JsonCodableEncoder.toBytes(response, responseCodable);
  print('Serialized response: ${utf8.decode(outBytes)}');
}
