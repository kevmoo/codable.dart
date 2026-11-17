// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: lines_longer_than_80_chars, unnecessary_lambdas, deprecated_member_use, unused_element

part of 'codable_toml_example.dart';

// **************************************************************************
// CodableGenerator
// **************************************************************************

// ignore_for_file: omit_local_variable_types

// =============================================================================
// 1. Unified Schema Descriptor for DatabaseConfig
// =============================================================================
extension type const _$DatabaseConfigSchema(int _value) {
  // String Name Constants
  static const String nameHost = 'host';
  static const String namePort = 'port';

  // Key Indices for selectKeyIndex()
  static const int keyHost = 0;
  static const int keyPort = 1;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
    _$DatabaseConfigSchema.nameHost,
    _$DatabaseConfigSchema.namePort,
  ]);
  static final KeyOptions keyOptions = options;

  // Bitmask Flags strictly for Required Fields
  static const _$DatabaseConfigSchema none = _$DatabaseConfigSchema(0);
  static const int _hostBit = 1 << 0;
  static const _$DatabaseConfigSchema host = _$DatabaseConfigSchema(_hostBit);

  // Combined Golden Bitmask for fast single-instruction check
  static const _$DatabaseConfigSchema golden = _$DatabaseConfigSchema(_hostBit);

  @pragma('vm:prefer-inline')
  _$DatabaseConfigSchema operator |(_$DatabaseConfigSchema other) =>
      _$DatabaseConfigSchema(_value | other._value);

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
    throw CodableException(
      'Missing required fields for DatabaseConfig: ${missing.join(", ")}',
    );
  }
}

// =============================================================================
// 2. Companion Codable for DatabaseConfig
// =============================================================================
final class DatabaseConfigCodable implements KeyedCodable<DatabaseConfig> {
  const DatabaseConfigCodable();

  @override
  DatabaseConfig decode(Decoder decoder) {
    final keyed = decoder.keyed(options: _$DatabaseConfigSchema.keyOptions);

    String? host;
    int port = 5432;
    var seen = _$DatabaseConfigSchema.none;

    while (keyed.moveNextKey()) {
      switch (keyed.selectKeyIndex(_$DatabaseConfigSchema.keyOptions)) {
        case _$DatabaseConfigSchema.keyHost:
          if ((seen._value & _$DatabaseConfigSchema.host._value) != 0) {
            throw const CodableException('Duplicate field "host"');
          }
          host = keyed.readString();
          seen |= _$DatabaseConfigSchema.host;
          break;
        case _$DatabaseConfigSchema.keyPort:
          port = keyed.readInt();
          break;
        default:
          keyed.skipValue();
          break;
      }
    }

    // Inlined fast-path check
    seen.validate();

    return DatabaseConfig(host: host!, port: port);
  }

  @override
  int encodedFieldCount(DatabaseConfig instance) => 2;

  @override
  void encodeFields(DatabaseConfig instance, KeyedEncoder keyed) {
    keyed.encodeString(_$DatabaseConfigSchema.nameHost, instance.host);
    keyed.encodeInt(_$DatabaseConfigSchema.namePort, instance.port);
  }

  @override
  void encode(DatabaseConfig instance, Encoder encoder) {
    final keyed = encoder.keyed(length: 2);
    keyed.encodeString(_$DatabaseConfigSchema.nameHost, instance.host);
    keyed.encodeInt(_$DatabaseConfigSchema.namePort, instance.port);
  }
}

// =============================================================================
// 1. Unified Schema Descriptor for EndpointRule
// =============================================================================
extension type const _$EndpointRuleSchema(int _value) {
  // String Name Constants
  static const String namePath = 'path';
  static const String nameRateLimit = 'rateLimit';

  // Key Indices for selectKeyIndex()
  static const int keyPath = 0;
  static const int keyRateLimit = 1;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
    _$EndpointRuleSchema.namePath,
    _$EndpointRuleSchema.nameRateLimit,
  ]);
  static final KeyOptions keyOptions = options;

  // Bitmask Flags strictly for Required Fields
  static const _$EndpointRuleSchema none = _$EndpointRuleSchema(0);
  static const int _pathBit = 1 << 0;
  static const _$EndpointRuleSchema path = _$EndpointRuleSchema(_pathBit);
  static const int _rateLimitBit = 1 << 1;
  static const _$EndpointRuleSchema rateLimit = _$EndpointRuleSchema(
    _rateLimitBit,
  );

  // Combined Golden Bitmask for fast single-instruction check
  static const _$EndpointRuleSchema golden = _$EndpointRuleSchema(
    _pathBit | _rateLimitBit,
  );

  @pragma('vm:prefer-inline')
  _$EndpointRuleSchema operator |(_$EndpointRuleSchema other) =>
      _$EndpointRuleSchema(_value | other._value);

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
    if ((_value & _pathBit) == 0) {
      missing.add(namePath);
    }
    if ((_value & _rateLimitBit) == 0) {
      missing.add(nameRateLimit);
    }
    throw CodableException(
      'Missing required fields for EndpointRule: ${missing.join(", ")}',
    );
  }
}

// =============================================================================
// 2. Companion Codable for EndpointRule
// =============================================================================
final class EndpointRuleCodable implements KeyedCodable<EndpointRule> {
  const EndpointRuleCodable();

  @override
  EndpointRule decode(Decoder decoder) {
    final keyed = decoder.keyed(options: _$EndpointRuleSchema.keyOptions);

    String? path;
    int? rateLimit;
    var seen = _$EndpointRuleSchema.none;

    while (keyed.moveNextKey()) {
      switch (keyed.selectKeyIndex(_$EndpointRuleSchema.keyOptions)) {
        case _$EndpointRuleSchema.keyPath:
          if ((seen._value & _$EndpointRuleSchema.path._value) != 0) {
            throw const CodableException('Duplicate field "path"');
          }
          path = keyed.readString();
          seen |= _$EndpointRuleSchema.path;
          break;
        case _$EndpointRuleSchema.keyRateLimit:
          if ((seen._value & _$EndpointRuleSchema.rateLimit._value) != 0) {
            throw const CodableException('Duplicate field "rateLimit"');
          }
          rateLimit = keyed.readInt();
          seen |= _$EndpointRuleSchema.rateLimit;
          break;
        default:
          keyed.skipValue();
          break;
      }
    }

    // Inlined fast-path check
    seen.validate();

    return EndpointRule(path: path!, rateLimit: rateLimit!);
  }

  @override
  int encodedFieldCount(EndpointRule instance) => 2;

  @override
  void encodeFields(EndpointRule instance, KeyedEncoder keyed) {
    keyed.encodeString(_$EndpointRuleSchema.namePath, instance.path);
    keyed.encodeInt(_$EndpointRuleSchema.nameRateLimit, instance.rateLimit);
  }

  @override
  void encode(EndpointRule instance, Encoder encoder) {
    final keyed = encoder.keyed(length: 2);
    keyed.encodeString(_$EndpointRuleSchema.namePath, instance.path);
    keyed.encodeInt(_$EndpointRuleSchema.nameRateLimit, instance.rateLimit);
  }
}

// =============================================================================
// 1. Unified Schema Descriptor for ServiceManifest
// =============================================================================
extension type const _$ServiceManifestSchema(int _value) {
  // String Name Constants
  static const String nameDatabase = 'database';
  static const String nameEndpoints = 'endpoints';
  static const String nameService = 'service';
  static const String nameDeployedAt = 'deployedAt';
  static const String nameStatusLabels = 'statusLabels';

  // Key Indices for selectKeyIndex()
  static const int keyDatabase = 0;
  static const int keyEndpoints = 1;
  static const int keyService = 2;
  static const int keyDeployedAt = 3;
  static const int keyStatusLabels = 4;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
    _$ServiceManifestSchema.nameDatabase,
    _$ServiceManifestSchema.nameEndpoints,
    _$ServiceManifestSchema.nameService,
    _$ServiceManifestSchema.nameDeployedAt,
    _$ServiceManifestSchema.nameStatusLabels,
  ]);
  static final KeyOptions keyOptions = options;

  // Bitmask Flags strictly for Required Fields
  static const _$ServiceManifestSchema none = _$ServiceManifestSchema(0);
  static const int _databaseBit = 1 << 0;
  static const _$ServiceManifestSchema database = _$ServiceManifestSchema(
    _databaseBit,
  );
  static const int _serviceBit = 1 << 1;
  static const _$ServiceManifestSchema service = _$ServiceManifestSchema(
    _serviceBit,
  );
  static const int _deployedAtBit = 1 << 2;
  static const _$ServiceManifestSchema deployedAt = _$ServiceManifestSchema(
    _deployedAtBit,
  );

  // Combined Golden Bitmask for fast single-instruction check
  static const _$ServiceManifestSchema golden = _$ServiceManifestSchema(
    _databaseBit | _serviceBit | _deployedAtBit,
  );

  @pragma('vm:prefer-inline')
  _$ServiceManifestSchema operator |(_$ServiceManifestSchema other) =>
      _$ServiceManifestSchema(_value | other._value);

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
    if ((_value & _databaseBit) == 0) {
      missing.add(nameDatabase);
    }
    if ((_value & _serviceBit) == 0) {
      missing.add(nameService);
    }
    if ((_value & _deployedAtBit) == 0) {
      missing.add(nameDeployedAt);
    }
    throw CodableException(
      'Missing required fields for ServiceManifest: ${missing.join(", ")}',
    );
  }
}

// =============================================================================
// 2. Companion Codable for ServiceManifest
// =============================================================================
final class ServiceManifestCodable implements KeyedCodable<ServiceManifest> {
  const ServiceManifestCodable();

  @override
  ServiceManifest decode(Decoder decoder) {
    final keyed = decoder.keyed(options: _$ServiceManifestSchema.keyOptions);

    DatabaseConfig? database;
    List<EndpointRule> endpoints = const [];
    String? service;
    DateTime? deployedAt;
    Map<int, String> statusLabels = const {};
    var seen = _$ServiceManifestSchema.none;

    while (keyed.moveNextKey()) {
      switch (keyed.selectKeyIndex(_$ServiceManifestSchema.keyOptions)) {
        case _$ServiceManifestSchema.keyDatabase:
          if ((seen._value & _$ServiceManifestSchema.database._value) != 0) {
            throw const CodableException('Duplicate field "database"');
          }
          database = const DatabaseConfigCodable().decode(
            keyed.nestedDecoder(),
          );
          seen |= _$ServiceManifestSchema.database;
          break;
        case _$ServiceManifestSchema.keyEndpoints:
          endpoints = const EndpointRuleCodable().decodeList(
            keyed.nestedDecoder(),
          );
          break;
        case _$ServiceManifestSchema.keyService:
          if ((seen._value & _$ServiceManifestSchema.service._value) != 0) {
            throw const CodableException('Duplicate field "service"');
          }
          service = keyed.readString();
          seen |= _$ServiceManifestSchema.service;
          break;
        case _$ServiceManifestSchema.keyDeployedAt:
          if ((seen._value & _$ServiceManifestSchema.deployedAt._value) != 0) {
            throw const CodableException('Duplicate field "deployedAt"');
          }
          deployedAt = keyed.decodeValue(const TomlDateTimeCodec());
          seen |= _$ServiceManifestSchema.deployedAt;
          break;
        case _$ServiceManifestSchema.keyStatusLabels:
          {
            final mDecoder = keyed.nestedDecoder().map();
            final m = <int, String>{};
            while (mDecoder.moveNextEntry()) {
              final key = mDecoder.keyDecoder().singleValue().readInt();
              m[key] = mDecoder.valueDecoder().singleValue().readString();
            }
            statusLabels = m;
          }
          break;
        default:
          keyed.skipValue();
          break;
      }
    }

    // Inlined fast-path check
    seen.validate();

    return ServiceManifest(
      database: database!,
      endpoints: endpoints,
      service: service!,
      deployedAt: deployedAt!,
      statusLabels: statusLabels,
    );
  }

  @override
  int encodedFieldCount(ServiceManifest instance) => 5;

  @override
  void encodeFields(ServiceManifest instance, KeyedEncoder keyed) {
    keyed.encodeValue(
      _$ServiceManifestSchema.nameDatabase,
      instance.database,
      const DatabaseConfigCodable(),
    );
    keyed.encodeList(
      _$ServiceManifestSchema.nameEndpoints,
      instance.endpoints,
      const EndpointRuleCodable(),
    );
    keyed.encodeString(_$ServiceManifestSchema.nameService, instance.service);
    keyed.encodeValue(
      _$ServiceManifestSchema.nameDeployedAt,
      instance.deployedAt,
      const TomlDateTimeCodec(),
    );
    {
      final m = keyed
          .nestedEncoder(_$ServiceManifestSchema.nameStatusLabels)
          .map(length: instance.statusLabels.length);
      for (final entry in instance.statusLabels.entries) {
        m.keyEncoder().singleValue().encodeInt(entry.key);
        m.valueEncoder().singleValue().encodeString(entry.value);
      }
    }
  }

  @override
  void encode(ServiceManifest instance, Encoder encoder) {
    final keyed = encoder.keyed(length: 5);
    keyed.encodeValue(
      _$ServiceManifestSchema.nameDatabase,
      instance.database,
      const DatabaseConfigCodable(),
    );
    keyed.encodeList(
      _$ServiceManifestSchema.nameEndpoints,
      instance.endpoints,
      const EndpointRuleCodable(),
    );
    keyed.encodeString(_$ServiceManifestSchema.nameService, instance.service);
    keyed.encodeValue(
      _$ServiceManifestSchema.nameDeployedAt,
      instance.deployedAt,
      const TomlDateTimeCodec(),
    );
    {
      final m = keyed
          .nestedEncoder(_$ServiceManifestSchema.nameStatusLabels)
          .map(length: instance.statusLabels.length);
      for (final entry in instance.statusLabels.entries) {
        m.keyEncoder().singleValue().encodeInt(entry.key);
        m.valueEncoder().singleValue().encodeString(entry.value);
      }
    }
  }
}
