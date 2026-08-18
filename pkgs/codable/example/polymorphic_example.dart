// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// ignore_for_file: unreachable_from_main

import 'dart:convert';

import 'package:codable/codable.dart';
import 'package:codable/src/driver/json_codable_driver.dart';

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

  static Car fromReader(JsonTokenReader reader) => _$CarFromReader(reader);
  void toWriter(JsonTokenWriter writer) => _$CarToWriter(this, writer);

  @override
  void encode(Encoder encoder) {
    final keyed = encoder.keyed();
    keyed.encodeString('type', 'car');
    keyed.encodeInt('maxSpeed', maxSpeed);
    keyed.encodeInt('doors', doors);
  }
}

@Codable()
class Bicycle extends Vehicle {
  final bool hasBell;

  const Bicycle({required super.maxSpeed, required this.hasBell});

  static Bicycle fromReader(JsonTokenReader reader) =>
      _$BicycleFromReader(reader);
  void toWriter(JsonTokenWriter writer) => _$BicycleToWriter(this, writer);

  @override
  void encode(Encoder encoder) {
    final keyed = encoder.keyed();
    keyed.encodeString('type', 'bicycle');
    keyed.encodeInt('maxSpeed', maxSpeed);
    keyed.encodeBool('hasBell', hasBell);
  }
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
    final builder = BytesBuilder();
    final writer = JsonTokenWriter.toSink(builder);
    if (v is Car) {
      v.toWriter(writer);
    } else if (v is Bicycle) {
      v.toWriter(writer);
    }
    print('Serialized: ${utf8.decode(builder.toBytes())}');
  }
}
