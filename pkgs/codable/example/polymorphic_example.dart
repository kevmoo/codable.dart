// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// ignore_for_file: unreachable_from_main

import 'dart:convert';
import 'dart:typed_data';

import 'package:codable/codable_json.dart';

part 'polymorphic_example.g.dart';

/// Base sealed class for polymorphic vehicle hierarchy.
@Codable(discriminatorKey: 'type')
sealed class Vehicle {
  final int maxSpeed;

  const Vehicle({required this.maxSpeed});
}

@Codable()
class Car extends Vehicle {
  final int doors;

  const Car({required super.maxSpeed, required this.doors});
}

@Codable()
class Bicycle extends Vehicle {
  final bool hasBell;

  const Bicycle({required super.maxSpeed, required this.hasBell});
}

void main() {
  const jsonArray = '''
  [
    {"type": "car", "maxSpeed": 120, "doors": 4},
    {"type": "bicycle", "maxSpeed": 25, "hasBell": true}
  ]
  ''';

  final bytes = Uint8List.fromList(utf8.encode(jsonArray));
  final decoder = JsonCodableDecoder.fromBytes(bytes);
  final vehicles = const VehicleCodable().decodeList(decoder);

  for (final v in vehicles) {
    print('Vehicle: ${v.runtimeType} (maxSpeed: ${v.maxSpeed})');
    final outBytes = JsonCodableEncoder.toBytes<Vehicle>(
      v,
      const VehicleCodable(),
    );
    print('Serialized: ${utf8.decode(outBytes)}');
  }
}
