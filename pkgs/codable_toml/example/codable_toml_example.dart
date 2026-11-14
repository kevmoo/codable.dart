// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// ignore_for_file: unreachable_from_main

import 'package:codable/codable.dart';
import 'package:codable_toml/codable_toml.dart';

part 'codable_toml_example.g.dart';

@Codable()
final class DatabaseConfig {
  final String host;
  final int port;

  const DatabaseConfig({required this.host, this.port = 5432});
}

@Codable()
final class EndpointRule {
  final String path;
  final int rateLimit;

  const EndpointRule({required this.path, required this.rateLimit});
}

@Codable()
final class ServiceManifest {
  // Declared before scalar fields to demonstrate TOML table reordering.
  final DatabaseConfig database;
  final List<EndpointRule> endpoints;
  final String service;

  @CodableKey(codable: TomlDateTimeCodec())
  final DateTime deployedAt;

  final Map<int, String> statusLabels;

  const ServiceManifest({
    required this.database,
    this.endpoints = const [],
    required this.service,
    required this.deployedAt,
    this.statusLabels = const {},
  });
}

void main() {
  final manifest = ServiceManifest(
    database: const DatabaseConfig(host: 'pg-primary.internal'),
    endpoints: const [
      EndpointRule(path: '/v1/charges', rateLimit: 500),
      EndpointRule(path: '/v1/refunds', rateLimit: 100),
    ],
    service: 'payments-edge',
    deployedAt: DateTime.utc(2026, 11, 14, 2, 30),
    statusLabels: const {200: 'ok', 429: 'throttled'},
  );

  final toml = TomlCodableEncoder.encode(
    manifest,
    const ServiceManifestCodable(),
  );
  print(toml);

  final decoded = TomlCodableDecoder.decode(
    toml,
    const ServiceManifestCodable(),
  );
  print(
    'Decoded ${decoded.service} -> '
    '${decoded.database.host}:${decoded.database.port} '
    '(${decoded.endpoints.length} endpoints)',
  );
}
