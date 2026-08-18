// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:codable/codable.dart';

part 'tuple_example.g.dart';

/// Demonstrates fixed-size array tuple unboxing via [@CodableTuple]
/// and unboxed Float64List bulk buffer scanning.
@Codable()
class CoordinatePair {
  @CodableTuple(2)
  final Float64List? location;

  const CoordinatePair({this.location});

  static CoordinatePair fromReader(JsonTokenReader reader) =>
      _$CoordinatePairFromReader(reader);
  void toWriter(JsonTokenWriter writer) =>
      _$CoordinatePairToWriter(this, writer);
}

void main() {
  final json = Uint8List.fromList(
    utf8.encode('{"location": [37.7749, -122.4194]}'),
  );
  final reader = JsonTokenReader.fromBytes(json);
  final pair = CoordinatePair.fromReader(reader);

  print('Location: ${pair.location?[0]}, ${pair.location?[1]}');

  final builder = BytesBuilder();
  final writer = JsonTokenWriter.toSink(builder);
  pair.toWriter(writer);
  print('Serialized tuple: ${utf8.decode(builder.toBytes())}');
}
