// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:codable/codable.dart';

/// Demonstrates parsing flattened collections out of deeply nested JSON
/// structures directly from the token stream without intermediate Map
/// allocations.
class NestedValueExample {
  final List<String> nestedValues;

  const NestedValueExample(this.nestedValues);

  static NestedValueExample fromReader(JsonTokenReader reader) {
    reader.beginObject();
    final values = <String>[];

    while (reader.hasNext()) {
      final key = reader.nextName();
      if (key == 'root_items') {
        reader.beginObject();
        while (reader.hasNext()) {
          final subKey = reader.nextName();
          if (subKey == 'items') {
            reader.beginArray();
            while (reader.hasNext()) {
              reader.beginObject();
              while (reader.hasNext()) {
                final itemField = reader.nextName();
                if (itemField == 'name') {
                  values.add(reader.readString());
                } else {
                  reader.skipValue();
                }
              }
              reader.endObject();
            }
            reader.endArray();
          } else {
            reader.skipValue();
          }
        }
        reader.endObject();
      } else {
        reader.skipValue();
      }
    }
    reader.endObject();

    return NestedValueExample(values);
  }

  void toWriter(JsonTokenWriter writer) {
    writer.beginObject();
    writer.writeName('root_items');
    writer.beginObject();
    writer.writeName('items');
    writer.beginArray();
    for (final val in nestedValues) {
      writer.beginObject();
      writer.writeName('name');
      writer.writeString(val);
      writer.endObject();
    }
    writer.endArray();
    writer.endObject();
    writer.endObject();
  }
}

void main() {
  const json = '''
  {
    "root_items": {
      "items": [
        {"name": "alpha"},
        {"name": "beta"},
        {"name": "gamma"}
      ]
    }
  }
  ''';

  final bytes = Uint8List.fromList(utf8.encode(json));
  final reader = JsonTokenReader.fromBytes(bytes);
  final example = NestedValueExample.fromReader(reader);

  print('Extracted items: ${example.nestedValues.join(', ')}');

  final builder = BytesBuilder();
  final writer = JsonTokenWriter.toSink(builder);
  example.toWriter(writer);
  print('Serialized root_items: ${utf8.decode(builder.toBytes())}');
}
