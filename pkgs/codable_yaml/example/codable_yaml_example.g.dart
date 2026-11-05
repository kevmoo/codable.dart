// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: lines_longer_than_80_chars, unnecessary_lambdas, deprecated_member_use, unused_element

part of 'codable_yaml_example.dart';

// **************************************************************************
// CodableGenerator
// **************************************************************************

// =============================================================================
// 1. Unified Schema Descriptor for EndpointConfig
// =============================================================================
extension type const _$EndpointConfigSchema(int _value) {
  // String Name Constants
  static const String nameHost = 'host';
  static const String namePort = 'port';
  static const String nameTls = 'tls';

  // Key Indices for selectKeyIndex()
  static const int keyHost = 0;
  static const int keyPort = 1;
  static const int keyTls = 2;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
    _$EndpointConfigSchema.nameHost,
    _$EndpointConfigSchema.namePort,
    _$EndpointConfigSchema.nameTls,
  ]);
  static final KeyOptions keyOptions = options;

  // Bitmask Flags strictly for Required Fields
  static const _$EndpointConfigSchema none = _$EndpointConfigSchema(0);
  static const int _hostBit = 1 << 0;
  static const _$EndpointConfigSchema host = _$EndpointConfigSchema(_hostBit);
  static const int _portBit = 1 << 1;
  static const _$EndpointConfigSchema port = _$EndpointConfigSchema(_portBit);

  // Combined Golden Bitmask for fast single-instruction check
  static const _$EndpointConfigSchema golden = _$EndpointConfigSchema(
    _hostBit | _portBit,
  );

  @pragma('vm:prefer-inline')
  _$EndpointConfigSchema operator |(_$EndpointConfigSchema other) =>
      _$EndpointConfigSchema(_value | other._value);

  /// Validates required fields in 1 CPU test instruction on the fast path.
  @pragma('vm:prefer-inline')
  void validate() {
    if ((_value & golden._value) != golden._value) {
      _throwMissingFields();
    }
  }

  /// Out-of-line cold diagnostic reporting
  void _throwMissingFields() {
    final missing = <String>[];
    if ((_value & _hostBit) == 0) {
      missing.add(nameHost);
    }
    if ((_value & _portBit) == 0) {
      missing.add(namePort);
    }
    throw CodableException(
      'Missing required fields for EndpointConfig: ${missing.join(", ")}',
    );
  }
}

// =============================================================================
// 2. Companion Codable for EndpointConfig
// =============================================================================
final class EndpointConfigCodable implements Codable<EndpointConfig> {
  const EndpointConfigCodable();

  @override
  EndpointConfig decode(Decoder decoder) {
    final keyed = decoder.keyed(options: _$EndpointConfigSchema.keyOptions);

    String? host;
    int? port;
    var tls = true;
    var seen = _$EndpointConfigSchema.none;

    while (keyed.moveNextKey()) {
      switch (keyed.selectKeyIndex(_$EndpointConfigSchema.keyOptions)) {
        case _$EndpointConfigSchema.keyHost:
          if ((seen._value & _$EndpointConfigSchema.host._value) != 0) {
            throw const CodableException('Duplicate field "host"');
          }
          host = keyed.readString();
          seen |= _$EndpointConfigSchema.host;
          break;
        case _$EndpointConfigSchema.keyPort:
          if ((seen._value & _$EndpointConfigSchema.port._value) != 0) {
            throw const CodableException('Duplicate field "port"');
          }
          port = keyed.readInt();
          seen |= _$EndpointConfigSchema.port;
          break;
        case _$EndpointConfigSchema.keyTls:
          tls = keyed.readBool();
          break;
        default:
          keyed.skipValue();
          break;
      }
    }

    // Inlined fast-path check
    seen.validate();

    return EndpointConfig(host: host!, port: port!, tls: tls);
  }

  @override
  void encode(EndpointConfig instance, Encoder encoder) {
    final keyed = encoder.keyed(length: 3);
    keyed.encodeString(_$EndpointConfigSchema.nameHost, instance.host);
    keyed.encodeInt(_$EndpointConfigSchema.namePort, instance.port);
    keyed.encodeBool(_$EndpointConfigSchema.nameTls, instance.tls);
  }
}

// =============================================================================
// 1. Unified Schema Descriptor for GatewayManifest
// =============================================================================
extension type const _$GatewayManifestSchema(int _value) {
  // String Name Constants
  static const String nameService = 'service';
  static const String namePrimary = 'primary';
  static const String nameFallback = 'fallback';
  static const String nameStatusRoutes = 'statusRoutes';
  static const String nameAllowedOrigins = 'allowedOrigins';

  // Key Indices for selectKeyIndex()
  static const int keyService = 0;
  static const int keyPrimary = 1;
  static const int keyFallback = 2;
  static const int keyStatusRoutes = 3;
  static const int keyAllowedOrigins = 4;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
    _$GatewayManifestSchema.nameService,
    _$GatewayManifestSchema.namePrimary,
    _$GatewayManifestSchema.nameFallback,
    _$GatewayManifestSchema.nameStatusRoutes,
    _$GatewayManifestSchema.nameAllowedOrigins,
  ]);
  static final KeyOptions keyOptions = options;

  // Bitmask Flags strictly for Required Fields
  static const _$GatewayManifestSchema none = _$GatewayManifestSchema(0);
  static const int _serviceBit = 1 << 0;
  static const _$GatewayManifestSchema service = _$GatewayManifestSchema(
    _serviceBit,
  );
  static const int _primaryBit = 1 << 1;
  static const _$GatewayManifestSchema primary = _$GatewayManifestSchema(
    _primaryBit,
  );
  static const int _fallbackBit = 1 << 2;
  static const _$GatewayManifestSchema fallback = _$GatewayManifestSchema(
    _fallbackBit,
  );

  // Combined Golden Bitmask for fast single-instruction check
  static const _$GatewayManifestSchema golden = _$GatewayManifestSchema(
    _serviceBit | _primaryBit | _fallbackBit,
  );

  @pragma('vm:prefer-inline')
  _$GatewayManifestSchema operator |(_$GatewayManifestSchema other) =>
      _$GatewayManifestSchema(_value | other._value);

  /// Validates required fields in 1 CPU test instruction on the fast path.
  @pragma('vm:prefer-inline')
  void validate() {
    if ((_value & golden._value) != golden._value) {
      _throwMissingFields();
    }
  }

  /// Out-of-line cold diagnostic reporting
  void _throwMissingFields() {
    final missing = <String>[];
    if ((_value & _serviceBit) == 0) {
      missing.add(nameService);
    }
    if ((_value & _primaryBit) == 0) {
      missing.add(namePrimary);
    }
    if ((_value & _fallbackBit) == 0) {
      missing.add(nameFallback);
    }
    throw CodableException(
      'Missing required fields for GatewayManifest: ${missing.join(", ")}',
    );
  }
}

// =============================================================================
// 2. Companion Codable for GatewayManifest
// =============================================================================
final class GatewayManifestCodable implements Codable<GatewayManifest> {
  const GatewayManifestCodable();

  @override
  GatewayManifest decode(Decoder decoder) {
    final keyed = decoder.keyed(options: _$GatewayManifestSchema.keyOptions);

    String? service;
    EndpointConfig? primary;
    EndpointConfig? fallback;
    var statusRoutes = const <int, String>{};
    var allowedOrigins = const <String>[];
    var seen = _$GatewayManifestSchema.none;

    while (keyed.moveNextKey()) {
      switch (keyed.selectKeyIndex(_$GatewayManifestSchema.keyOptions)) {
        case _$GatewayManifestSchema.keyService:
          if ((seen._value & _$GatewayManifestSchema.service._value) != 0) {
            throw const CodableException('Duplicate field "service"');
          }
          service = keyed.readString();
          seen |= _$GatewayManifestSchema.service;
          break;
        case _$GatewayManifestSchema.keyPrimary:
          if ((seen._value & _$GatewayManifestSchema.primary._value) != 0) {
            throw const CodableException('Duplicate field "primary"');
          }
          primary = const EndpointConfigCodable().decode(keyed.nestedDecoder());
          seen |= _$GatewayManifestSchema.primary;
          break;
        case _$GatewayManifestSchema.keyFallback:
          if ((seen._value & _$GatewayManifestSchema.fallback._value) != 0) {
            throw const CodableException('Duplicate field "fallback"');
          }
          fallback = const EndpointConfigCodable().decode(
            keyed.nestedDecoder(),
          );
          seen |= _$GatewayManifestSchema.fallback;
          break;
        case _$GatewayManifestSchema.keyStatusRoutes:
          {
            final mDecoder = keyed.nestedDecoder().map();
            final m = <int, String>{};
            while (mDecoder.moveNextEntry()) {
              final key = mDecoder.keyDecoder().singleValue().readInt();
              m[key] = mDecoder.valueDecoder().singleValue().readString();
            }
            statusRoutes = m;
          }
          break;
        case _$GatewayManifestSchema.keyAllowedOrigins:
          allowedOrigins = keyed.decodeStringList();
          break;
        default:
          keyed.skipValue();
          break;
      }
    }

    // Inlined fast-path check
    seen.validate();

    return GatewayManifest(
      service: service!,
      primary: primary!,
      fallback: fallback!,
      statusRoutes: statusRoutes,
      allowedOrigins: allowedOrigins,
    );
  }

  @override
  void encode(GatewayManifest instance, Encoder encoder) {
    final keyed = encoder.keyed(length: 5);
    keyed.encodeString(_$GatewayManifestSchema.nameService, instance.service);
    keyed.encodeValue(
      _$GatewayManifestSchema.namePrimary,
      instance.primary,
      const EndpointConfigCodable(),
    );
    keyed.encodeValue(
      _$GatewayManifestSchema.nameFallback,
      instance.fallback,
      const EndpointConfigCodable(),
    );
    {
      final m = keyed
          .nestedEncoder(_$GatewayManifestSchema.nameStatusRoutes)
          .map(length: instance.statusRoutes.length);
      for (final entry in instance.statusRoutes.entries) {
        m.keyEncoder().singleValue().encodeInt(entry.key);
        m.valueEncoder().singleValue().encodeString(entry.value);
      }
    }
    keyed.encodeStringList(
      _$GatewayManifestSchema.nameAllowedOrigins,
      instance.allowedOrigins,
    );
  }
}
