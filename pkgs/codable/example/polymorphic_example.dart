// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Demonstrates single-pass polymorphic `@Codable()` decoding and encoding over
/// a `sealed` class hierarchy with default and explicit discriminator values.
library;

import 'package:codable/codable_json.dart';

part 'polymorphic_example.g.dart';

/// Sealed base class dispatched on wire key `'type'`.
///
/// `codable_builder` discovers all concrete `@Codable()` subtypes in this
/// library and generates `const VehicleCodable()` with single-pass
/// `[discriminatorKey, ...subtypeFields]` encoding and exhaustive `switch`
/// dispatch.
@Codable(discriminatorKey: 'type')
sealed class Vehicle {
  final int maxSpeed;

  const Vehicle({required this.maxSpeed});
}

/// Uses the default discriminator value `'car'` (derived from class name).
@Codable()
class Car extends Vehicle {
  final int doors;

  const Car({required super.maxSpeed, required this.doors});
}

/// Uses the default discriminator value `'bicycle'`.
@Codable()
class Bicycle extends Vehicle {
  final bool hasBell;

  const Bicycle({required super.maxSpeed, required this.hasBell});
}

/// Overrides the wire discriminator value explicitly with `'cargo_van'`.
@Codable(discriminatorValue: 'cargo_van')
class CargoVan extends Vehicle {
  final double payloadTons;

  const CargoVan({required super.maxSpeed, required this.payloadTons});
}

void main() {
  const jsonArray = '''
  [
    {"type": "car", "maxSpeed": 120, "doors": 4},
    {"maxSpeed": 25, "hasBell": true, "type": "bicycle"},
    {"type": "cargo_van", "maxSpeed": 95, "payloadTons": 3.5}
  ]
  ''';

  final fleetCodec = const VehicleCodable().list;
  final vehicles = JsonCodableDecoder.decode(jsonArray, fleetCodec);

  for (final vehicle in vehicles) {
    final summary = switch (vehicle) {
      Car(:final doors, :final maxSpeed) =>
        'Car ($doors doors, $maxSpeed km/h)',
      Bicycle(:final hasBell, :final maxSpeed) =>
        'Bicycle (bell: $hasBell, $maxSpeed km/h)',
      CargoVan(:final payloadTons, :final maxSpeed) =>
        'CargoVan (${payloadTons}t, $maxSpeed km/h)',
    };
    final encoded = JsonCodableEncoder.encode(vehicle, const VehicleCodable());
    print('$summary -> $encoded');
  }
}
