// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// ignore_for_file: unreachable_from_main

import 'dart:convert';

import 'package:codable/codable_json.dart';

part 'polymorphic_example.g.dart';

/// Base abstract class for polymorphic vehicle hierarchy.
sealed class Vehicle implements Encodable {
  final int maxSpeed;

  const Vehicle({required this.maxSpeed});

  static Vehicle decode(Decoder decoder) {
    final keyed = decoder.keyed();
    String? type;
    int? maxSpeed;
    int? doors;
    bool? hasBell;

    while (keyed.hasNextKey()) {
      final key = keyed.nextKey();
      switch (key) {
        case 'type':
          type = keyed.readString();
          break;
        case 'maxSpeed':
          maxSpeed = keyed.readInt();
          break;
        case 'doors':
          doors = keyed.readInt();
          break;
        case 'hasBell':
          hasBell = keyed.readBool();
          break;
        default:
          keyed.skipValue();
          break;
      }
    }

    if (type == null || maxSpeed == null) {
      throw const CodableException('Missing required fields for Vehicle');
    }

    if (type == 'car') {
      if (doors == null) {
        throw const CodableException('Missing doors for Car');
      }
      return Car(maxSpeed: maxSpeed, doors: doors);
    } else if (type == 'bicycle') {
      if (hasBell == null) {
        throw const CodableException('Missing hasBell for Bicycle');
      }
      return Bicycle(maxSpeed: maxSpeed, hasBell: hasBell);
    }
    throw CodableException('Unknown vehicle type: $type');
  }
}

@Codable()
class Car extends Vehicle {
  final int doors;

  const Car({required super.maxSpeed, required this.doors});

  static Car decode(Decoder decoder) => _$CarFromDecoder(decoder);
  @override
  void encode(Encoder encoder) => _$CarToEncoder(this, encoder);
}

@Codable()
class Bicycle extends Vehicle {
  final bool hasBell;

  const Bicycle({required super.maxSpeed, required this.hasBell});

  static Bicycle decode(Decoder decoder) => _$BicycleFromDecoder(decoder);
  @override
  void encode(Encoder encoder) => _$BicycleToEncoder(this, encoder);
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
  final unkeyed = decoder.unkeyed();

  final vehicles = <Vehicle>[];
  while (unkeyed.hasNext()) {
    vehicles.add(unkeyed.decodeElement(Vehicle.decode));
  }

  for (final v in vehicles) {
    print('Vehicle: ${v.runtimeType} (maxSpeed: ${v.maxSpeed})');
    final outBytes = JsonCodableEncoder.toBytes(v.encode);
    print('Serialized: ${utf8.decode(outBytes)}');
  }
}
