// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// ignore_for_file: unreachable_from_main

import 'package:codable/codable.dart';
import 'package:codable_yaml/codable_yaml.dart';

part 'codable_yaml_example.g.dart';

@Codable()
final class EndpointConfig {
  final String host;
  final int port;
  final bool tls;

  const EndpointConfig({
    required this.host,
    required this.port,
    this.tls = true,
  });
}

@Codable()
final class GatewayManifest {
  final String service;
  final EndpointConfig primary;
  final EndpointConfig fallback;
  final Map<int, String> statusRoutes;
  final List<String> allowedOrigins;

  const GatewayManifest({
    required this.service,
    required this.primary,
    required this.fallback,
    this.statusRoutes = const {},
    this.allowedOrigins = const [],
  });
}

void main() {
  const source = '''
service: edge-router
primary: &default_endpoint
  host: edge.example.com
  port: 443
fallback: *default_endpoint
statusRoutes:
  200: ok
  429: rate_limited
allowedOrigins:
  - https://app.example.com
''';

  final manifest = YamlCodableDecoder.decode(
    source,
    const GatewayManifestCodable(),
    sourceUrl: Uri.parse('gateway.yaml'),
  );

  print(
    'Loaded ${manifest.service} -> '
    '${manifest.primary.host}:${manifest.primary.port}',
  );

  final emitted = YamlCodableEncoder.encode(
    manifest,
    const GatewayManifestCodable(),
  );
  print(emitted);
}
