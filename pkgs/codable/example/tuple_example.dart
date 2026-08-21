// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:codable/codable_json.dart';

part 'tuple_example.g.dart';

/// Demonstrates fixed-size array tuple unboxing via [@CodableTuple]
/// and unboxed Float64List bulk buffer scanning.
@Codable()
class CoordinatePair {
  @CodableTuple(2)
  final Float64List? location;

  const CoordinatePair({this.location});

  static CoordinatePair decode(Decoder decoder) =>
      _$CoordinatePairFromDecoder(decoder);
  void encode(Encoder encoder) => _$CoordinatePairToEncoder(this, encoder);
}

void main() {
  final json = Uint8List.fromList(
    utf8.encode('{"location": [37.7749, -122.4194]}'),
  );
  final decoder = JsonCodableDecoder.fromBytes(json);
  final pair = CoordinatePair.decode(decoder);

  print('Location: ${pair.location?[0]}, ${pair.location?[1]}');

  final outBytes = JsonCodableEncoder.toBytes(pair.encode);
  print('Serialized tuple: ${utf8.decode(outBytes)}');
}
