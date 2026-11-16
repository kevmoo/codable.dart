// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// ignore_for_file: unreachable_from_main

import 'dart:convert';

import 'package:codable/codable_json.dart';

part 'polymorphic_example.g.dart';

/// Base abstract class for polymorphic vehicle hierarchy.
sealed class Vehicle {
  final int maxSpeed;

  const Vehicle({required this.maxSpeed});
}

/// Companion [Codable] for polymorphic [Vehicle] hierarchy.
final class VehicleCodable implements Codable<Vehicle> {
  const VehicleCodable();

  @override
  Vehicle decode(Decoder decoder) {
    final mapped = decoder.mapped();
    if (!mapped.containsKey('type')) {
      throw const CodableException(
        'Missing discriminator key "type" for Vehicle',
      );
    }
    final type = mapped.readString('type');
    return switch (type) {
      'car' => const CarCodable().decode(decoder),
      'bicycle' => const BicycleCodable().decode(decoder),
      _ => throw CodableException.unknownSubtype(
        discriminatorKey: 'type',
        subtypeValue: type,
      ),
    };
  }

  List<Vehicle> decodeList(Decoder decoder) {
    final unkeyed = decoder.unkeyed();
    final list = <Vehicle>[];
    while (unkeyed.moveNext()) {
      list.add(unkeyed.decodeElement(this));
    }
    return list;
  }

  @override
  void encode(Vehicle value, Encoder encoder) {
    final keyed = encoder.keyed(length: 3);
    switch (value) {
      case Car():
        keyed
          ..encodeString('type', 'car')
          ..encodeInt(_$CarSchema.nameMaxSpeed, value.maxSpeed)
          ..encodeInt(_$CarSchema.nameDoors, value.doors);
      case Bicycle():
        keyed
          ..encodeString('type', 'bicycle')
          ..encodeInt(_$BicycleSchema.nameMaxSpeed, value.maxSpeed)
          ..encodeBool(_$BicycleSchema.nameHasBell, value.hasBell);
    }
  }
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
    final outBytes = JsonCodableEncoder.toBytes(v, const VehicleCodable());
    print('Serialized: ${utf8.decode(outBytes)}');
  }
}
