// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: lines_longer_than_80_chars, unnecessary_lambdas, deprecated_member_use, unused_element

part of 'cross_format_test.dart';

// **************************************************************************
// CodableGenerator
// **************************************************************************

// ignore_for_file: omit_local_variable_types

// =============================================================================
// 1. Unified Schema Descriptor for RetryPolicy
// =============================================================================
extension type const _$RetryPolicySchema(int _value) {
  // String Name Constants
  static const String nameMaxAttempts = 'maxAttempts';
  static const String nameBackoffMultiplier = 'backoffMultiplier';

  // Key Indices for selectKeyIndex()
  static const int keyMaxAttempts = 0;
  static const int keyBackoffMultiplier = 1;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
    _$RetryPolicySchema.nameMaxAttempts,
    _$RetryPolicySchema.nameBackoffMultiplier,
  ]);
  static final KeyOptions keyOptions = options;

  // Bitmask Flags strictly for Required Fields
  static const _$RetryPolicySchema none = _$RetryPolicySchema(0);
  static const int _maxAttemptsBit = 1 << 0;
  static const _$RetryPolicySchema maxAttempts = _$RetryPolicySchema(
    _maxAttemptsBit,
  );
  static const int _backoffMultiplierBit = 1 << 1;
  static const _$RetryPolicySchema backoffMultiplier = _$RetryPolicySchema(
    _backoffMultiplierBit,
  );

  // Combined Golden Bitmask for fast single-instruction check
  static const _$RetryPolicySchema golden = _$RetryPolicySchema(
    _maxAttemptsBit | _backoffMultiplierBit,
  );

  @pragma('vm:prefer-inline')
  _$RetryPolicySchema operator |(_$RetryPolicySchema other) =>
      _$RetryPolicySchema(_value | other._value);

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
    if ((_value & _maxAttemptsBit) == 0) {
      missing.add(nameMaxAttempts);
    }
    if ((_value & _backoffMultiplierBit) == 0) {
      missing.add(nameBackoffMultiplier);
    }
    throw CodableException(
      'Missing required fields for RetryPolicy: ${missing.join(", ")}',
    );
  }
}

// =============================================================================
// 2. Companion Codable for RetryPolicy
// =============================================================================
final class RetryPolicyCodable implements Codable<RetryPolicy> {
  const RetryPolicyCodable();

  @override
  RetryPolicy decode(Decoder decoder) {
    final keyed = decoder.keyed(options: _$RetryPolicySchema.keyOptions);

    int? maxAttempts;
    double? backoffMultiplier;
    var seen = _$RetryPolicySchema.none;

    while (keyed.moveNextKey()) {
      switch (keyed.selectKeyIndex(_$RetryPolicySchema.keyOptions)) {
        case _$RetryPolicySchema.keyMaxAttempts:
          if ((seen._value & _$RetryPolicySchema.maxAttempts._value) != 0) {
            throw const CodableException('Duplicate field "maxAttempts"');
          }
          maxAttempts = keyed.readInt();
          seen |= _$RetryPolicySchema.maxAttempts;
          break;
        case _$RetryPolicySchema.keyBackoffMultiplier:
          if ((seen._value & _$RetryPolicySchema.backoffMultiplier._value) !=
              0) {
            throw const CodableException('Duplicate field "backoffMultiplier"');
          }
          backoffMultiplier = keyed.readDouble();
          seen |= _$RetryPolicySchema.backoffMultiplier;
          break;
        default:
          keyed.skipValue();
          break;
      }
    }

    // Inlined fast-path check
    seen.validate();

    return RetryPolicy(
      maxAttempts: maxAttempts!,
      backoffMultiplier: backoffMultiplier!,
    );
  }

  @override
  void encode(RetryPolicy instance, Encoder encoder) {
    final keyed = encoder.keyed(length: 2);
    keyed.encodeInt(_$RetryPolicySchema.nameMaxAttempts, instance.maxAttempts);
    keyed.encodeDouble(
      _$RetryPolicySchema.nameBackoffMultiplier,
      instance.backoffMultiplier,
    );
  }
}

// =============================================================================
// 1. Unified Schema Descriptor for SubtableSpec
// =============================================================================
extension type const _$SubtableSpecSchema(int _value) {
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
    _$SubtableSpecSchema.nameHost,
    _$SubtableSpecSchema.namePort,
    _$SubtableSpecSchema.nameTls,
  ]);
  static final KeyOptions keyOptions = options;

  // Bitmask Flags strictly for Required Fields
  static const _$SubtableSpecSchema none = _$SubtableSpecSchema(0);
  static const int _hostBit = 1 << 0;
  static const _$SubtableSpecSchema host = _$SubtableSpecSchema(_hostBit);
  static const int _portBit = 1 << 1;
  static const _$SubtableSpecSchema port = _$SubtableSpecSchema(_portBit);
  static const int _tlsBit = 1 << 2;
  static const _$SubtableSpecSchema tls = _$SubtableSpecSchema(_tlsBit);

  // Combined Golden Bitmask for fast single-instruction check
  static const _$SubtableSpecSchema golden = _$SubtableSpecSchema(
    _hostBit | _portBit | _tlsBit,
  );

  @pragma('vm:prefer-inline')
  _$SubtableSpecSchema operator |(_$SubtableSpecSchema other) =>
      _$SubtableSpecSchema(_value | other._value);

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
    if ((_value & _tlsBit) == 0) {
      missing.add(nameTls);
    }
    throw CodableException(
      'Missing required fields for SubtableSpec: ${missing.join(", ")}',
    );
  }
}

// =============================================================================
// 2. Companion Codable for SubtableSpec
// =============================================================================
final class SubtableSpecCodable implements Codable<SubtableSpec> {
  const SubtableSpecCodable();

  @override
  SubtableSpec decode(Decoder decoder) {
    final keyed = decoder.keyed(options: _$SubtableSpecSchema.keyOptions);

    String? host;
    int? port;
    bool? tls;
    var seen = _$SubtableSpecSchema.none;

    while (keyed.moveNextKey()) {
      switch (keyed.selectKeyIndex(_$SubtableSpecSchema.keyOptions)) {
        case _$SubtableSpecSchema.keyHost:
          if ((seen._value & _$SubtableSpecSchema.host._value) != 0) {
            throw const CodableException('Duplicate field "host"');
          }
          host = keyed.readString();
          seen |= _$SubtableSpecSchema.host;
          break;
        case _$SubtableSpecSchema.keyPort:
          if ((seen._value & _$SubtableSpecSchema.port._value) != 0) {
            throw const CodableException('Duplicate field "port"');
          }
          port = keyed.readInt();
          seen |= _$SubtableSpecSchema.port;
          break;
        case _$SubtableSpecSchema.keyTls:
          if ((seen._value & _$SubtableSpecSchema.tls._value) != 0) {
            throw const CodableException('Duplicate field "tls"');
          }
          tls = keyed.readBool();
          seen |= _$SubtableSpecSchema.tls;
          break;
        default:
          keyed.skipValue();
          break;
      }
    }

    // Inlined fast-path check
    seen.validate();

    return SubtableSpec(host: host!, port: port!, tls: tls!);
  }

  @override
  void encode(SubtableSpec instance, Encoder encoder) {
    final keyed = encoder.keyed(length: 3);
    keyed.encodeString(_$SubtableSpecSchema.nameHost, instance.host);
    keyed.encodeInt(_$SubtableSpecSchema.namePort, instance.port);
    keyed.encodeBool(_$SubtableSpecSchema.nameTls, instance.tls);
  }
}

// =============================================================================
// 1. Unified Schema Descriptor for EndpointItem
// =============================================================================
extension type const _$EndpointItemSchema(int _value) {
  // String Name Constants
  static const String nameRetry = 'retry';
  static const String namePath = 'path';
  static const String nameRateLimit = 'rateLimit';

  // Key Indices for selectKeyIndex()
  static const int keyRetry = 0;
  static const int keyPath = 1;
  static const int keyRateLimit = 2;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
    _$EndpointItemSchema.nameRetry,
    _$EndpointItemSchema.namePath,
    _$EndpointItemSchema.nameRateLimit,
  ]);
  static final KeyOptions keyOptions = options;

  // Bitmask Flags strictly for Required Fields
  static const _$EndpointItemSchema none = _$EndpointItemSchema(0);
  static const int _retryBit = 1 << 0;
  static const _$EndpointItemSchema retry = _$EndpointItemSchema(_retryBit);
  static const int _pathBit = 1 << 1;
  static const _$EndpointItemSchema path = _$EndpointItemSchema(_pathBit);
  static const int _rateLimitBit = 1 << 2;
  static const _$EndpointItemSchema rateLimit = _$EndpointItemSchema(
    _rateLimitBit,
  );

  // Combined Golden Bitmask for fast single-instruction check
  static const _$EndpointItemSchema golden = _$EndpointItemSchema(
    _retryBit | _pathBit | _rateLimitBit,
  );

  @pragma('vm:prefer-inline')
  _$EndpointItemSchema operator |(_$EndpointItemSchema other) =>
      _$EndpointItemSchema(_value | other._value);

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
    if ((_value & _retryBit) == 0) {
      missing.add(nameRetry);
    }
    if ((_value & _pathBit) == 0) {
      missing.add(namePath);
    }
    if ((_value & _rateLimitBit) == 0) {
      missing.add(nameRateLimit);
    }
    throw CodableException(
      'Missing required fields for EndpointItem: ${missing.join(", ")}',
    );
  }
}

// =============================================================================
// 2. Companion Codable for EndpointItem
// =============================================================================
final class EndpointItemCodable implements Codable<EndpointItem> {
  const EndpointItemCodable();

  @override
  EndpointItem decode(Decoder decoder) {
    final keyed = decoder.keyed(options: _$EndpointItemSchema.keyOptions);

    RetryPolicy? retry;
    String? path;
    int? rateLimit;
    var seen = _$EndpointItemSchema.none;

    while (keyed.moveNextKey()) {
      switch (keyed.selectKeyIndex(_$EndpointItemSchema.keyOptions)) {
        case _$EndpointItemSchema.keyRetry:
          if ((seen._value & _$EndpointItemSchema.retry._value) != 0) {
            throw const CodableException('Duplicate field "retry"');
          }
          retry = const RetryPolicyCodable().decode(keyed.nestedDecoder());
          seen |= _$EndpointItemSchema.retry;
          break;
        case _$EndpointItemSchema.keyPath:
          if ((seen._value & _$EndpointItemSchema.path._value) != 0) {
            throw const CodableException('Duplicate field "path"');
          }
          path = keyed.readString();
          seen |= _$EndpointItemSchema.path;
          break;
        case _$EndpointItemSchema.keyRateLimit:
          if ((seen._value & _$EndpointItemSchema.rateLimit._value) != 0) {
            throw const CodableException('Duplicate field "rateLimit"');
          }
          rateLimit = keyed.readInt();
          seen |= _$EndpointItemSchema.rateLimit;
          break;
        default:
          keyed.skipValue();
          break;
      }
    }

    // Inlined fast-path check
    seen.validate();

    return EndpointItem(retry: retry!, path: path!, rateLimit: rateLimit!);
  }

  @override
  void encode(EndpointItem instance, Encoder encoder) {
    final keyed = encoder.keyed(length: 3);
    keyed.encodeValue(
      _$EndpointItemSchema.nameRetry,
      instance.retry,
      const RetryPolicyCodable(),
    );
    keyed.encodeString(_$EndpointItemSchema.namePath, instance.path);
    keyed.encodeInt(_$EndpointItemSchema.nameRateLimit, instance.rateLimit);
  }
}

// =============================================================================
// 1. Unified Schema Descriptor for InterleavedServiceConfig
// =============================================================================
extension type const _$InterleavedServiceConfigSchema(int _value) {
  // String Name Constants
  static const String nameSubtable = 'subtable';
  static const String nameItems = 'items';
  static const String nameVersion = 'version';
  static const String nameServiceName = 'serviceName';
  static const String nameEnabled = 'enabled';

  // Key Indices for selectKeyIndex()
  static const int keySubtable = 0;
  static const int keyItems = 1;
  static const int keyVersion = 2;
  static const int keyServiceName = 3;
  static const int keyEnabled = 4;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
    _$InterleavedServiceConfigSchema.nameSubtable,
    _$InterleavedServiceConfigSchema.nameItems,
    _$InterleavedServiceConfigSchema.nameVersion,
    _$InterleavedServiceConfigSchema.nameServiceName,
    _$InterleavedServiceConfigSchema.nameEnabled,
  ]);
  static final KeyOptions keyOptions = options;

  // Bitmask Flags strictly for Required Fields
  static const _$InterleavedServiceConfigSchema none =
      _$InterleavedServiceConfigSchema(0);
  static const int _subtableBit = 1 << 0;
  static const _$InterleavedServiceConfigSchema subtable =
      _$InterleavedServiceConfigSchema(_subtableBit);
  static const int _itemsBit = 1 << 1;
  static const _$InterleavedServiceConfigSchema items =
      _$InterleavedServiceConfigSchema(_itemsBit);
  static const int _versionBit = 1 << 2;
  static const _$InterleavedServiceConfigSchema version =
      _$InterleavedServiceConfigSchema(_versionBit);
  static const int _serviceNameBit = 1 << 3;
  static const _$InterleavedServiceConfigSchema serviceName =
      _$InterleavedServiceConfigSchema(_serviceNameBit);
  static const int _enabledBit = 1 << 4;
  static const _$InterleavedServiceConfigSchema enabled =
      _$InterleavedServiceConfigSchema(_enabledBit);

  // Combined Golden Bitmask for fast single-instruction check
  static const _$InterleavedServiceConfigSchema golden =
      _$InterleavedServiceConfigSchema(
        _subtableBit | _itemsBit | _versionBit | _serviceNameBit | _enabledBit,
      );

  @pragma('vm:prefer-inline')
  _$InterleavedServiceConfigSchema operator |(
    _$InterleavedServiceConfigSchema other,
  ) => _$InterleavedServiceConfigSchema(_value | other._value);

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
    if ((_value & _subtableBit) == 0) {
      missing.add(nameSubtable);
    }
    if ((_value & _itemsBit) == 0) {
      missing.add(nameItems);
    }
    if ((_value & _versionBit) == 0) {
      missing.add(nameVersion);
    }
    if ((_value & _serviceNameBit) == 0) {
      missing.add(nameServiceName);
    }
    if ((_value & _enabledBit) == 0) {
      missing.add(nameEnabled);
    }
    throw CodableException(
      'Missing required fields for InterleavedServiceConfig: ${missing.join(", ")}',
    );
  }
}

// =============================================================================
// 2. Companion Codable for InterleavedServiceConfig
// =============================================================================
final class InterleavedServiceConfigCodable
    implements Codable<InterleavedServiceConfig> {
  const InterleavedServiceConfigCodable();

  @override
  InterleavedServiceConfig decode(Decoder decoder) {
    final keyed = decoder.keyed(
      options: _$InterleavedServiceConfigSchema.keyOptions,
    );

    SubtableSpec? subtable;
    List<EndpointItem>? items;
    int? version;
    String? serviceName;
    bool? enabled;
    var seen = _$InterleavedServiceConfigSchema.none;

    while (keyed.moveNextKey()) {
      switch (keyed.selectKeyIndex(
        _$InterleavedServiceConfigSchema.keyOptions,
      )) {
        case _$InterleavedServiceConfigSchema.keySubtable:
          if ((seen._value &
                  _$InterleavedServiceConfigSchema.subtable._value) !=
              0) {
            throw const CodableException('Duplicate field "subtable"');
          }
          subtable = const SubtableSpecCodable().decode(keyed.nestedDecoder());
          seen |= _$InterleavedServiceConfigSchema.subtable;
          break;
        case _$InterleavedServiceConfigSchema.keyItems:
          if ((seen._value & _$InterleavedServiceConfigSchema.items._value) !=
              0) {
            throw const CodableException('Duplicate field "items"');
          }
          items = const EndpointItemCodable().decodeList(keyed.nestedDecoder());
          seen |= _$InterleavedServiceConfigSchema.items;
          break;
        case _$InterleavedServiceConfigSchema.keyVersion:
          if ((seen._value & _$InterleavedServiceConfigSchema.version._value) !=
              0) {
            throw const CodableException('Duplicate field "version"');
          }
          version = keyed.readInt();
          seen |= _$InterleavedServiceConfigSchema.version;
          break;
        case _$InterleavedServiceConfigSchema.keyServiceName:
          if ((seen._value &
                  _$InterleavedServiceConfigSchema.serviceName._value) !=
              0) {
            throw const CodableException('Duplicate field "serviceName"');
          }
          serviceName = keyed.readString();
          seen |= _$InterleavedServiceConfigSchema.serviceName;
          break;
        case _$InterleavedServiceConfigSchema.keyEnabled:
          if ((seen._value & _$InterleavedServiceConfigSchema.enabled._value) !=
              0) {
            throw const CodableException('Duplicate field "enabled"');
          }
          enabled = keyed.readBool();
          seen |= _$InterleavedServiceConfigSchema.enabled;
          break;
        default:
          keyed.skipValue();
          break;
      }
    }

    // Inlined fast-path check
    seen.validate();

    return InterleavedServiceConfig(
      subtable: subtable!,
      items: items!,
      version: version!,
      serviceName: serviceName!,
      enabled: enabled!,
    );
  }

  @override
  void encode(InterleavedServiceConfig instance, Encoder encoder) {
    final keyed = encoder.keyed(length: 5);
    keyed.encodeValue(
      _$InterleavedServiceConfigSchema.nameSubtable,
      instance.subtable,
      const SubtableSpecCodable(),
    );
    keyed.encodeList(
      _$InterleavedServiceConfigSchema.nameItems,
      instance.items,
      const EndpointItemCodable(),
    );
    keyed.encodeInt(
      _$InterleavedServiceConfigSchema.nameVersion,
      instance.version,
    );
    keyed.encodeString(
      _$InterleavedServiceConfigSchema.nameServiceName,
      instance.serviceName,
    );
    keyed.encodeBool(
      _$InterleavedServiceConfigSchema.nameEnabled,
      instance.enabled,
    );
  }
}

// =============================================================================
// 1. Unified Schema Descriptor for EmptyMarker
// =============================================================================
extension type const _$EmptyMarkerSchema(int _value) {
  // String Name Constants

  // Key Indices for selectKeyIndex()

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const []);
  static final KeyOptions keyOptions = options;

  // Bitmask Flags strictly for Required Fields
  static const _$EmptyMarkerSchema none = _$EmptyMarkerSchema(0);

  @pragma('vm:prefer-inline')
  _$EmptyMarkerSchema operator |(_$EmptyMarkerSchema other) =>
      _$EmptyMarkerSchema(_value | other._value);

  /// Validates required fields in 1 CPU test instruction on the fast path.
  @pragma('vm:prefer-inline')
  void validate() {}
}

// =============================================================================
// 2. Companion Codable for EmptyMarker
// =============================================================================
final class EmptyMarkerCodable implements Codable<EmptyMarker> {
  const EmptyMarkerCodable();

  @override
  EmptyMarker decode(Decoder decoder) {
    final keyed = decoder.keyed(options: _$EmptyMarkerSchema.keyOptions);

    var seen = _$EmptyMarkerSchema.none;

    while (keyed.moveNextKey()) {
      switch (keyed.selectKeyIndex(_$EmptyMarkerSchema.keyOptions)) {
        default:
          keyed.skipValue();
          break;
      }
    }

    // Inlined fast-path check
    seen.validate();

    return const EmptyMarker();
  }

  @override
  void encode(EmptyMarker instance, Encoder encoder) {
    encoder.keyed(length: 0);
  }
}

// =============================================================================
// 1. Unified Schema Descriptor for LevelC
// =============================================================================
extension type const _$LevelCSchema(int _value) {
  // String Name Constants
  static const String nameRegion = 'region';
  static const String nameReplicas = 'replicas';

  // Key Indices for selectKeyIndex()
  static const int keyRegion = 0;
  static const int keyReplicas = 1;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
    _$LevelCSchema.nameRegion,
    _$LevelCSchema.nameReplicas,
  ]);
  static final KeyOptions keyOptions = options;

  // Bitmask Flags strictly for Required Fields
  static const _$LevelCSchema none = _$LevelCSchema(0);
  static const int _regionBit = 1 << 0;
  static const _$LevelCSchema region = _$LevelCSchema(_regionBit);
  static const int _replicasBit = 1 << 1;
  static const _$LevelCSchema replicas = _$LevelCSchema(_replicasBit);

  // Combined Golden Bitmask for fast single-instruction check
  static const _$LevelCSchema golden = _$LevelCSchema(
    _regionBit | _replicasBit,
  );

  @pragma('vm:prefer-inline')
  _$LevelCSchema operator |(_$LevelCSchema other) =>
      _$LevelCSchema(_value | other._value);

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
    if ((_value & _regionBit) == 0) {
      missing.add(nameRegion);
    }
    if ((_value & _replicasBit) == 0) {
      missing.add(nameReplicas);
    }
    throw CodableException(
      'Missing required fields for LevelC: ${missing.join(", ")}',
    );
  }
}

// =============================================================================
// 2. Companion Codable for LevelC
// =============================================================================
final class LevelCCodable implements Codable<LevelC> {
  const LevelCCodable();

  @override
  LevelC decode(Decoder decoder) {
    final keyed = decoder.keyed(options: _$LevelCSchema.keyOptions);

    String? region;
    int? replicas;
    var seen = _$LevelCSchema.none;

    while (keyed.moveNextKey()) {
      switch (keyed.selectKeyIndex(_$LevelCSchema.keyOptions)) {
        case _$LevelCSchema.keyRegion:
          if ((seen._value & _$LevelCSchema.region._value) != 0) {
            throw const CodableException('Duplicate field "region"');
          }
          region = keyed.readString();
          seen |= _$LevelCSchema.region;
          break;
        case _$LevelCSchema.keyReplicas:
          if ((seen._value & _$LevelCSchema.replicas._value) != 0) {
            throw const CodableException('Duplicate field "replicas"');
          }
          replicas = keyed.readInt();
          seen |= _$LevelCSchema.replicas;
          break;
        default:
          keyed.skipValue();
          break;
      }
    }

    // Inlined fast-path check
    seen.validate();

    return LevelC(region: region!, replicas: replicas!);
  }

  @override
  void encode(LevelC instance, Encoder encoder) {
    final keyed = encoder.keyed(length: 2);
    keyed.encodeString(_$LevelCSchema.nameRegion, instance.region);
    keyed.encodeInt(_$LevelCSchema.nameReplicas, instance.replicas);
  }
}

// =============================================================================
// 1. Unified Schema Descriptor for LevelB
// =============================================================================
extension type const _$LevelBSchema(int _value) {
  // String Name Constants
  static const String nameC = 'c';

  // Key Indices for selectKeyIndex()
  static const int keyC = 0;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [_$LevelBSchema.nameC]);
  static final KeyOptions keyOptions = options;

  // Bitmask Flags strictly for Required Fields
  static const _$LevelBSchema none = _$LevelBSchema(0);
  static const int _cBit = 1 << 0;
  static const _$LevelBSchema c = _$LevelBSchema(_cBit);

  // Combined Golden Bitmask for fast single-instruction check
  static const _$LevelBSchema golden = _$LevelBSchema(_cBit);

  @pragma('vm:prefer-inline')
  _$LevelBSchema operator |(_$LevelBSchema other) =>
      _$LevelBSchema(_value | other._value);

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
    if ((_value & _cBit) == 0) {
      missing.add(nameC);
    }
    throw CodableException(
      'Missing required fields for LevelB: ${missing.join(", ")}',
    );
  }
}

// =============================================================================
// 2. Companion Codable for LevelB
// =============================================================================
final class LevelBCodable implements Codable<LevelB> {
  const LevelBCodable();

  @override
  LevelB decode(Decoder decoder) {
    final keyed = decoder.keyed(options: _$LevelBSchema.keyOptions);

    LevelC? c;
    var seen = _$LevelBSchema.none;

    while (keyed.moveNextKey()) {
      switch (keyed.selectKeyIndex(_$LevelBSchema.keyOptions)) {
        case _$LevelBSchema.keyC:
          if ((seen._value & _$LevelBSchema.c._value) != 0) {
            throw const CodableException('Duplicate field "c"');
          }
          c = const LevelCCodable().decode(keyed.nestedDecoder());
          seen |= _$LevelBSchema.c;
          break;
        default:
          keyed.skipValue();
          break;
      }
    }

    // Inlined fast-path check
    seen.validate();

    return LevelB(c: c!);
  }

  @override
  void encode(LevelB instance, Encoder encoder) {
    final keyed = encoder.keyed(length: 1);
    keyed.encodeValue(_$LevelBSchema.nameC, instance.c, const LevelCCodable());
  }
}

// =============================================================================
// 1. Unified Schema Descriptor for LevelA
// =============================================================================
extension type const _$LevelASchema(int _value) {
  // String Name Constants
  static const String nameB = 'b';

  // Key Indices for selectKeyIndex()
  static const int keyB = 0;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [_$LevelASchema.nameB]);
  static final KeyOptions keyOptions = options;

  // Bitmask Flags strictly for Required Fields
  static const _$LevelASchema none = _$LevelASchema(0);
  static const int _bBit = 1 << 0;
  static const _$LevelASchema b = _$LevelASchema(_bBit);

  // Combined Golden Bitmask for fast single-instruction check
  static const _$LevelASchema golden = _$LevelASchema(_bBit);

  @pragma('vm:prefer-inline')
  _$LevelASchema operator |(_$LevelASchema other) =>
      _$LevelASchema(_value | other._value);

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
    if ((_value & _bBit) == 0) {
      missing.add(nameB);
    }
    throw CodableException(
      'Missing required fields for LevelA: ${missing.join(", ")}',
    );
  }
}

// =============================================================================
// 2. Companion Codable for LevelA
// =============================================================================
final class LevelACodable implements Codable<LevelA> {
  const LevelACodable();

  @override
  LevelA decode(Decoder decoder) {
    final keyed = decoder.keyed(options: _$LevelASchema.keyOptions);

    LevelB? b;
    var seen = _$LevelASchema.none;

    while (keyed.moveNextKey()) {
      switch (keyed.selectKeyIndex(_$LevelASchema.keyOptions)) {
        case _$LevelASchema.keyB:
          if ((seen._value & _$LevelASchema.b._value) != 0) {
            throw const CodableException('Duplicate field "b"');
          }
          b = const LevelBCodable().decode(keyed.nestedDecoder());
          seen |= _$LevelASchema.b;
          break;
        default:
          keyed.skipValue();
          break;
      }
    }

    // Inlined fast-path check
    seen.validate();

    return LevelA(b: b!);
  }

  @override
  void encode(LevelA instance, Encoder encoder) {
    final keyed = encoder.keyed(length: 1);
    keyed.encodeValue(_$LevelASchema.nameB, instance.b, const LevelBCodable());
  }
}

// =============================================================================
// 1. Unified Schema Descriptor for GridCell
// =============================================================================
extension type const _$GridCellSchema(int _value) {
  // String Name Constants
  static const String nameX = 'x';
  static const String nameY = 'y';
  static const String nameTag = 'tag';

  // Key Indices for selectKeyIndex()
  static const int keyX = 0;
  static const int keyY = 1;
  static const int keyTag = 2;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
    _$GridCellSchema.nameX,
    _$GridCellSchema.nameY,
    _$GridCellSchema.nameTag,
  ]);
  static final KeyOptions keyOptions = options;

  // Bitmask Flags strictly for Required Fields
  static const _$GridCellSchema none = _$GridCellSchema(0);
  static const int _xBit = 1 << 0;
  static const _$GridCellSchema x = _$GridCellSchema(_xBit);
  static const int _yBit = 1 << 1;
  static const _$GridCellSchema y = _$GridCellSchema(_yBit);
  static const int _tagBit = 1 << 2;
  static const _$GridCellSchema tag = _$GridCellSchema(_tagBit);

  // Combined Golden Bitmask for fast single-instruction check
  static const _$GridCellSchema golden = _$GridCellSchema(
    _xBit | _yBit | _tagBit,
  );

  @pragma('vm:prefer-inline')
  _$GridCellSchema operator |(_$GridCellSchema other) =>
      _$GridCellSchema(_value | other._value);

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
    if ((_value & _xBit) == 0) {
      missing.add(nameX);
    }
    if ((_value & _yBit) == 0) {
      missing.add(nameY);
    }
    if ((_value & _tagBit) == 0) {
      missing.add(nameTag);
    }
    throw CodableException(
      'Missing required fields for GridCell: ${missing.join(", ")}',
    );
  }
}

// =============================================================================
// 2. Companion Codable for GridCell
// =============================================================================
final class GridCellCodable implements Codable<GridCell> {
  const GridCellCodable();

  @override
  GridCell decode(Decoder decoder) {
    final keyed = decoder.keyed(options: _$GridCellSchema.keyOptions);

    int? x;
    int? y;
    String? tag;
    var seen = _$GridCellSchema.none;

    while (keyed.moveNextKey()) {
      switch (keyed.selectKeyIndex(_$GridCellSchema.keyOptions)) {
        case _$GridCellSchema.keyX:
          if ((seen._value & _$GridCellSchema.x._value) != 0) {
            throw const CodableException('Duplicate field "x"');
          }
          x = keyed.readInt();
          seen |= _$GridCellSchema.x;
          break;
        case _$GridCellSchema.keyY:
          if ((seen._value & _$GridCellSchema.y._value) != 0) {
            throw const CodableException('Duplicate field "y"');
          }
          y = keyed.readInt();
          seen |= _$GridCellSchema.y;
          break;
        case _$GridCellSchema.keyTag:
          if ((seen._value & _$GridCellSchema.tag._value) != 0) {
            throw const CodableException('Duplicate field "tag"');
          }
          tag = keyed.readString();
          seen |= _$GridCellSchema.tag;
          break;
        default:
          keyed.skipValue();
          break;
      }
    }

    // Inlined fast-path check
    seen.validate();

    return GridCell(x: x!, y: y!, tag: tag!);
  }

  @override
  void encode(GridCell instance, Encoder encoder) {
    final keyed = encoder.keyed(length: 3);
    keyed.encodeInt(_$GridCellSchema.nameX, instance.x);
    keyed.encodeInt(_$GridCellSchema.nameY, instance.y);
    keyed.encodeString(_$GridCellSchema.nameTag, instance.tag);
  }
}

// =============================================================================
// 1. Unified Schema Descriptor for StructuralHierarchyModel
// =============================================================================
extension type const _$StructuralHierarchyModelSchema(int _value) {
  // String Name Constants
  static const String nameA = 'a';
  static const String nameEmpty = 'empty';
  static const String nameEmptyItems = 'emptyItems';
  static const String nameActiveItems = 'activeItems';
  static const String nameMatrix = 'matrix';
  static const String nameEmptyMatrix = 'emptyMatrix';
  static const String nameTitle = 'title';

  // Key Indices for selectKeyIndex()
  static const int keyA = 0;
  static const int keyEmpty = 1;
  static const int keyEmptyItems = 2;
  static const int keyActiveItems = 3;
  static const int keyMatrix = 4;
  static const int keyEmptyMatrix = 5;
  static const int keyTitle = 6;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
    _$StructuralHierarchyModelSchema.nameA,
    _$StructuralHierarchyModelSchema.nameEmpty,
    _$StructuralHierarchyModelSchema.nameEmptyItems,
    _$StructuralHierarchyModelSchema.nameActiveItems,
    _$StructuralHierarchyModelSchema.nameMatrix,
    _$StructuralHierarchyModelSchema.nameEmptyMatrix,
    _$StructuralHierarchyModelSchema.nameTitle,
  ]);
  static final KeyOptions keyOptions = options;

  // Bitmask Flags strictly for Required Fields
  static const _$StructuralHierarchyModelSchema none =
      _$StructuralHierarchyModelSchema(0);
  static const int _aBit = 1 << 0;
  static const _$StructuralHierarchyModelSchema a =
      _$StructuralHierarchyModelSchema(_aBit);
  static const int _emptyBit = 1 << 1;
  static const _$StructuralHierarchyModelSchema empty =
      _$StructuralHierarchyModelSchema(_emptyBit);
  static const int _emptyItemsBit = 1 << 2;
  static const _$StructuralHierarchyModelSchema emptyItems =
      _$StructuralHierarchyModelSchema(_emptyItemsBit);
  static const int _activeItemsBit = 1 << 3;
  static const _$StructuralHierarchyModelSchema activeItems =
      _$StructuralHierarchyModelSchema(_activeItemsBit);
  static const int _matrixBit = 1 << 4;
  static const _$StructuralHierarchyModelSchema matrix =
      _$StructuralHierarchyModelSchema(_matrixBit);
  static const int _emptyMatrixBit = 1 << 5;
  static const _$StructuralHierarchyModelSchema emptyMatrix =
      _$StructuralHierarchyModelSchema(_emptyMatrixBit);
  static const int _titleBit = 1 << 6;
  static const _$StructuralHierarchyModelSchema title =
      _$StructuralHierarchyModelSchema(_titleBit);

  // Combined Golden Bitmask for fast single-instruction check
  static const _$StructuralHierarchyModelSchema golden =
      _$StructuralHierarchyModelSchema(
        _aBit |
            _emptyBit |
            _emptyItemsBit |
            _activeItemsBit |
            _matrixBit |
            _emptyMatrixBit |
            _titleBit,
      );

  @pragma('vm:prefer-inline')
  _$StructuralHierarchyModelSchema operator |(
    _$StructuralHierarchyModelSchema other,
  ) => _$StructuralHierarchyModelSchema(_value | other._value);

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
    if ((_value & _aBit) == 0) {
      missing.add(nameA);
    }
    if ((_value & _emptyBit) == 0) {
      missing.add(nameEmpty);
    }
    if ((_value & _emptyItemsBit) == 0) {
      missing.add(nameEmptyItems);
    }
    if ((_value & _activeItemsBit) == 0) {
      missing.add(nameActiveItems);
    }
    if ((_value & _matrixBit) == 0) {
      missing.add(nameMatrix);
    }
    if ((_value & _emptyMatrixBit) == 0) {
      missing.add(nameEmptyMatrix);
    }
    if ((_value & _titleBit) == 0) {
      missing.add(nameTitle);
    }
    throw CodableException(
      'Missing required fields for StructuralHierarchyModel: ${missing.join(", ")}',
    );
  }
}

// =============================================================================
// 2. Companion Codable for StructuralHierarchyModel
// =============================================================================
final class StructuralHierarchyModelCodable
    implements Codable<StructuralHierarchyModel> {
  const StructuralHierarchyModelCodable();

  @override
  StructuralHierarchyModel decode(Decoder decoder) {
    final keyed = decoder.keyed(
      options: _$StructuralHierarchyModelSchema.keyOptions,
    );

    LevelA? a;
    AllOptionalPatch? empty;
    List<GridCell>? emptyItems;
    List<GridCell>? activeItems;
    List<List<GridCell>>? matrix;
    List<List<AllOptionalPatch>>? emptyMatrix;
    String? title;
    var seen = _$StructuralHierarchyModelSchema.none;

    while (keyed.moveNextKey()) {
      switch (keyed.selectKeyIndex(
        _$StructuralHierarchyModelSchema.keyOptions,
      )) {
        case _$StructuralHierarchyModelSchema.keyA:
          if ((seen._value & _$StructuralHierarchyModelSchema.a._value) != 0) {
            throw const CodableException('Duplicate field "a"');
          }
          a = const LevelACodable().decode(keyed.nestedDecoder());
          seen |= _$StructuralHierarchyModelSchema.a;
          break;
        case _$StructuralHierarchyModelSchema.keyEmpty:
          if ((seen._value & _$StructuralHierarchyModelSchema.empty._value) !=
              0) {
            throw const CodableException('Duplicate field "empty"');
          }
          empty = const AllOptionalPatchCodable().decode(keyed.nestedDecoder());
          seen |= _$StructuralHierarchyModelSchema.empty;
          break;
        case _$StructuralHierarchyModelSchema.keyEmptyItems:
          if ((seen._value &
                  _$StructuralHierarchyModelSchema.emptyItems._value) !=
              0) {
            throw const CodableException('Duplicate field "emptyItems"');
          }
          emptyItems = const GridCellCodable().decodeList(
            keyed.nestedDecoder(),
          );
          seen |= _$StructuralHierarchyModelSchema.emptyItems;
          break;
        case _$StructuralHierarchyModelSchema.keyActiveItems:
          if ((seen._value &
                  _$StructuralHierarchyModelSchema.activeItems._value) !=
              0) {
            throw const CodableException('Duplicate field "activeItems"');
          }
          activeItems = const GridCellCodable().decodeList(
            keyed.nestedDecoder(),
          );
          seen |= _$StructuralHierarchyModelSchema.activeItems;
          break;
        case _$StructuralHierarchyModelSchema.keyMatrix:
          if ((seen._value & _$StructuralHierarchyModelSchema.matrix._value) !=
              0) {
            throw const CodableException('Duplicate field "matrix"');
          }
          {
            final u = keyed.nestedDecoder().unkeyed();
            final l = <List<GridCell>>[];
            while (u.moveNext()) {
              l.add(u.decodeList(const GridCellCodable()));
            }
            matrix = l;
          }
          seen |= _$StructuralHierarchyModelSchema.matrix;
          break;
        case _$StructuralHierarchyModelSchema.keyEmptyMatrix:
          if ((seen._value &
                  _$StructuralHierarchyModelSchema.emptyMatrix._value) !=
              0) {
            throw const CodableException('Duplicate field "emptyMatrix"');
          }
          {
            final u = keyed.nestedDecoder().unkeyed();
            final l = <List<AllOptionalPatch>>[];
            while (u.moveNext()) {
              l.add(u.decodeList(const AllOptionalPatchCodable()));
            }
            emptyMatrix = l;
          }
          seen |= _$StructuralHierarchyModelSchema.emptyMatrix;
          break;
        case _$StructuralHierarchyModelSchema.keyTitle:
          if ((seen._value & _$StructuralHierarchyModelSchema.title._value) !=
              0) {
            throw const CodableException('Duplicate field "title"');
          }
          title = keyed.readString();
          seen |= _$StructuralHierarchyModelSchema.title;
          break;
        default:
          keyed.skipValue();
          break;
      }
    }

    // Inlined fast-path check
    seen.validate();

    return StructuralHierarchyModel(
      a: a!,
      empty: empty!,
      emptyItems: emptyItems!,
      activeItems: activeItems!,
      matrix: matrix!,
      emptyMatrix: emptyMatrix!,
      title: title!,
    );
  }

  @override
  void encode(StructuralHierarchyModel instance, Encoder encoder) {
    final keyed = encoder.keyed(length: 7);
    keyed.encodeValue(
      _$StructuralHierarchyModelSchema.nameA,
      instance.a,
      const LevelACodable(),
    );
    keyed.encodeValue(
      _$StructuralHierarchyModelSchema.nameEmpty,
      instance.empty,
      const AllOptionalPatchCodable(),
    );
    keyed.encodeList(
      _$StructuralHierarchyModelSchema.nameEmptyItems,
      instance.emptyItems,
      const GridCellCodable(),
    );
    keyed.encodeList(
      _$StructuralHierarchyModelSchema.nameActiveItems,
      instance.activeItems,
      const GridCellCodable(),
    );
    keyed.encodeList(
      _$StructuralHierarchyModelSchema.nameMatrix,
      instance.matrix,
      Encodable.fromFunction((List<GridCell> item, e) {
        {
          final u = e.unkeyed(length: item.length);
          for (final elem in item) {
            const GridCellCodable().encode(elem, u.nestedEncoder());
          }
        }
      }),
    );
    keyed.encodeList(
      _$StructuralHierarchyModelSchema.nameEmptyMatrix,
      instance.emptyMatrix,
      Encodable.fromFunction((List<AllOptionalPatch> item, e) {
        {
          final u = e.unkeyed(length: item.length);
          for (final elem in item) {
            const AllOptionalPatchCodable().encode(elem, u.nestedEncoder());
          }
        }
      }),
    );
    keyed.encodeString(
      _$StructuralHierarchyModelSchema.nameTitle,
      instance.title,
    );
  }
}

// =============================================================================
// 1. Unified Schema Descriptor for AllOptionalPatch
// =============================================================================
extension type const _$AllOptionalPatchSchema(int _value) {
  // String Name Constants
  static const String nameAlpha = 'alpha';
  static const String nameBeta = 'beta';
  static const String nameGamma = 'gamma';

  // Key Indices for selectKeyIndex()
  static const int keyAlpha = 0;
  static const int keyBeta = 1;
  static const int keyGamma = 2;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
    _$AllOptionalPatchSchema.nameAlpha,
    _$AllOptionalPatchSchema.nameBeta,
    _$AllOptionalPatchSchema.nameGamma,
  ]);
  static final KeyOptions keyOptions = options;

  // Bitmask Flags strictly for Required Fields
  static const _$AllOptionalPatchSchema none = _$AllOptionalPatchSchema(0);

  @pragma('vm:prefer-inline')
  _$AllOptionalPatchSchema operator |(_$AllOptionalPatchSchema other) =>
      _$AllOptionalPatchSchema(_value | other._value);

  /// Validates required fields in 1 CPU test instruction on the fast path.
  @pragma('vm:prefer-inline')
  void validate() {}
}

// =============================================================================
// 2. Companion Codable for AllOptionalPatch
// =============================================================================
final class AllOptionalPatchCodable implements Codable<AllOptionalPatch> {
  const AllOptionalPatchCodable();

  @override
  AllOptionalPatch decode(Decoder decoder) {
    final keyed = decoder.keyed(options: _$AllOptionalPatchSchema.keyOptions);

    int? alpha;
    String? beta;
    bool? gamma;
    var seen = _$AllOptionalPatchSchema.none;

    while (keyed.moveNextKey()) {
      switch (keyed.selectKeyIndex(_$AllOptionalPatchSchema.keyOptions)) {
        case _$AllOptionalPatchSchema.keyAlpha:
          if (keyed.isNextNull()) {
            keyed.readNull();
            alpha = null;
          } else {
            alpha = keyed.readInt();
          }
          break;
        case _$AllOptionalPatchSchema.keyBeta:
          if (keyed.isNextNull()) {
            keyed.readNull();
            beta = null;
          } else {
            beta = keyed.readString();
          }
          break;
        case _$AllOptionalPatchSchema.keyGamma:
          if (keyed.isNextNull()) {
            keyed.readNull();
            gamma = null;
          } else {
            gamma = keyed.readBool();
          }
          break;
        default:
          keyed.skipValue();
          break;
      }
    }

    // Inlined fast-path check
    seen.validate();

    return AllOptionalPatch(alpha: alpha, beta: beta, gamma: gamma);
  }

  @override
  void encode(AllOptionalPatch instance, Encoder encoder) {
    var count$ = 0;
    final v$Alpha = instance.alpha;
    if (v$Alpha != null) count$++;
    final v$Beta = instance.beta;
    if (v$Beta != null) count$++;
    final v$Gamma = instance.gamma;
    if (v$Gamma != null) count$++;
    final keyed = encoder.keyed(length: count$);
    if (v$Alpha != null) {
      keyed.encodeInt(_$AllOptionalPatchSchema.nameAlpha, v$Alpha);
    }
    if (v$Beta != null) {
      keyed.encodeString(_$AllOptionalPatchSchema.nameBeta, v$Beta);
    }
    if (v$Gamma != null) {
      keyed.encodeBool(_$AllOptionalPatchSchema.nameGamma, v$Gamma);
    }
  }
}

// =============================================================================
// 1. Unified Schema Descriptor for NullableShowcase
// =============================================================================
extension type const _$NullableShowcaseSchema(int _value) {
  // String Name Constants
  static const String nameId = 'id';
  static const String nameOptInt = 'optInt';
  static const String nameOptDouble = 'optDouble';
  static const String nameOptString = 'optString';
  static const String nameOptBool = 'optBool';
  static const String nameOptStruct = 'optStruct';
  static const String nameOptEmpty = 'optEmpty';
  static const String nameOptBytes = 'optBytes';
  static const String nameOptStringList = 'optStringList';
  static const String nameOptStructList = 'optStructList';
  static const String nameOptIntSet = 'optIntSet';
  static const String nameOptStringMap = 'optStringMap';
  static const String nameOptIntMap = 'optIntMap';

  // Key Indices for selectKeyIndex()
  static const int keyId = 0;
  static const int keyOptInt = 1;
  static const int keyOptDouble = 2;
  static const int keyOptString = 3;
  static const int keyOptBool = 4;
  static const int keyOptStruct = 5;
  static const int keyOptEmpty = 6;
  static const int keyOptBytes = 7;
  static const int keyOptStringList = 8;
  static const int keyOptStructList = 9;
  static const int keyOptIntSet = 10;
  static const int keyOptStringMap = 11;
  static const int keyOptIntMap = 12;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
    _$NullableShowcaseSchema.nameId,
    _$NullableShowcaseSchema.nameOptInt,
    _$NullableShowcaseSchema.nameOptDouble,
    _$NullableShowcaseSchema.nameOptString,
    _$NullableShowcaseSchema.nameOptBool,
    _$NullableShowcaseSchema.nameOptStruct,
    _$NullableShowcaseSchema.nameOptEmpty,
    _$NullableShowcaseSchema.nameOptBytes,
    _$NullableShowcaseSchema.nameOptStringList,
    _$NullableShowcaseSchema.nameOptStructList,
    _$NullableShowcaseSchema.nameOptIntSet,
    _$NullableShowcaseSchema.nameOptStringMap,
    _$NullableShowcaseSchema.nameOptIntMap,
  ]);
  static final KeyOptions keyOptions = options;

  // Bitmask Flags strictly for Required Fields
  static const _$NullableShowcaseSchema none = _$NullableShowcaseSchema(0);
  static const int _idBit = 1 << 0;
  static const _$NullableShowcaseSchema id = _$NullableShowcaseSchema(_idBit);

  // Combined Golden Bitmask for fast single-instruction check
  static const _$NullableShowcaseSchema golden = _$NullableShowcaseSchema(
    _idBit,
  );

  @pragma('vm:prefer-inline')
  _$NullableShowcaseSchema operator |(_$NullableShowcaseSchema other) =>
      _$NullableShowcaseSchema(_value | other._value);

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
    if ((_value & _idBit) == 0) {
      missing.add(nameId);
    }
    throw CodableException(
      'Missing required fields for NullableShowcase: ${missing.join(", ")}',
    );
  }
}

// =============================================================================
// 2. Companion Codable for NullableShowcase
// =============================================================================
final class NullableShowcaseCodable implements Codable<NullableShowcase> {
  const NullableShowcaseCodable();

  @override
  NullableShowcase decode(Decoder decoder) {
    final keyed = decoder.keyed(options: _$NullableShowcaseSchema.keyOptions);

    String? id;
    int? optInt;
    double? optDouble;
    String? optString;
    bool? optBool;
    LevelC? optStruct;
    AllOptionalPatch? optEmpty;
    Uint8List? optBytes;
    List<String>? optStringList;
    List<GridCell>? optStructList;
    Set<int>? optIntSet;
    Map<String, int>? optStringMap;
    Map<int, String>? optIntMap;
    var seen = _$NullableShowcaseSchema.none;

    while (keyed.moveNextKey()) {
      switch (keyed.selectKeyIndex(_$NullableShowcaseSchema.keyOptions)) {
        case _$NullableShowcaseSchema.keyId:
          if ((seen._value & _$NullableShowcaseSchema.id._value) != 0) {
            throw const CodableException('Duplicate field "id"');
          }
          id = keyed.readString();
          seen |= _$NullableShowcaseSchema.id;
          break;
        case _$NullableShowcaseSchema.keyOptInt:
          if (keyed.isNextNull()) {
            keyed.readNull();
            optInt = null;
          } else {
            optInt = keyed.readInt();
          }
          break;
        case _$NullableShowcaseSchema.keyOptDouble:
          if (keyed.isNextNull()) {
            keyed.readNull();
            optDouble = null;
          } else {
            optDouble = keyed.readDouble();
          }
          break;
        case _$NullableShowcaseSchema.keyOptString:
          if (keyed.isNextNull()) {
            keyed.readNull();
            optString = null;
          } else {
            optString = keyed.readString();
          }
          break;
        case _$NullableShowcaseSchema.keyOptBool:
          if (keyed.isNextNull()) {
            keyed.readNull();
            optBool = null;
          } else {
            optBool = keyed.readBool();
          }
          break;
        case _$NullableShowcaseSchema.keyOptStruct:
          if (keyed.isNextNull()) {
            keyed.readNull();
            optStruct = null;
          } else {
            optStruct = const LevelCCodable().decode(keyed.nestedDecoder());
          }
          break;
        case _$NullableShowcaseSchema.keyOptEmpty:
          if (keyed.isNextNull()) {
            keyed.readNull();
            optEmpty = null;
          } else {
            optEmpty = const AllOptionalPatchCodable().decode(
              keyed.nestedDecoder(),
            );
          }
          break;
        case _$NullableShowcaseSchema.keyOptBytes:
          if (keyed.isNextNull()) {
            keyed.readNull();
            optBytes = null;
          } else {
            optBytes = keyed.readBytes();
          }
          break;
        case _$NullableShowcaseSchema.keyOptStringList:
          if (keyed.isNextNull()) {
            keyed.readNull();
            optStringList = null;
          } else {
            optStringList = keyed.decodeStringList();
          }
          break;
        case _$NullableShowcaseSchema.keyOptStructList:
          if (keyed.isNextNull()) {
            keyed.readNull();
            optStructList = null;
          } else {
            optStructList = const GridCellCodable().decodeList(
              keyed.nestedDecoder(),
            );
          }
          break;
        case _$NullableShowcaseSchema.keyOptIntSet:
          if (keyed.isNextNull()) {
            keyed.readNull();
            optIntSet = null;
          } else {
            optIntSet = keyed.decodeIntList().toSet();
          }
          break;
        case _$NullableShowcaseSchema.keyOptStringMap:
          if (keyed.isNextNull()) {
            keyed.readNull();
            optStringMap = null;
          } else {
            {
              final k = keyed.nestedDecoder().keyed();
              final m = <String, int>{};
              while (k.moveNextKey()) {
                final key = k.nextKey();
                m[key] = k.readInt();
              }
              optStringMap = m;
            }
          }
          break;
        case _$NullableShowcaseSchema.keyOptIntMap:
          if (keyed.isNextNull()) {
            keyed.readNull();
            optIntMap = null;
          } else {
            {
              final mDecoder = keyed.nestedDecoder().map();
              final m = <int, String>{};
              while (mDecoder.moveNextEntry()) {
                final key = mDecoder.keyDecoder().singleValue().readInt();
                m[key] = mDecoder.valueDecoder().singleValue().readString();
              }
              optIntMap = m;
            }
          }
          break;
        default:
          keyed.skipValue();
          break;
      }
    }

    // Inlined fast-path check
    seen.validate();

    return NullableShowcase(
      id: id!,
      optInt: optInt,
      optDouble: optDouble,
      optString: optString,
      optBool: optBool,
      optStruct: optStruct,
      optEmpty: optEmpty,
      optBytes: optBytes,
      optStringList: optStringList,
      optStructList: optStructList,
      optIntSet: optIntSet,
      optStringMap: optStringMap,
      optIntMap: optIntMap,
    );
  }

  @override
  void encode(NullableShowcase instance, Encoder encoder) {
    var count$ = 1;
    final v$OptInt = instance.optInt;
    if (v$OptInt != null) count$++;
    final v$OptDouble = instance.optDouble;
    if (v$OptDouble != null) count$++;
    final v$OptString = instance.optString;
    if (v$OptString != null) count$++;
    final v$OptBool = instance.optBool;
    if (v$OptBool != null) count$++;
    final v$OptStruct = instance.optStruct;
    if (v$OptStruct != null) count$++;
    final v$OptEmpty = instance.optEmpty;
    if (v$OptEmpty != null) count$++;
    final v$OptBytes = instance.optBytes;
    if (v$OptBytes != null) count$++;
    final v$OptStringList = instance.optStringList;
    if (v$OptStringList != null) count$++;
    final v$OptStructList = instance.optStructList;
    if (v$OptStructList != null) count$++;
    final v$OptIntSet = instance.optIntSet;
    if (v$OptIntSet != null) count$++;
    final v$OptStringMap = instance.optStringMap;
    if (v$OptStringMap != null) count$++;
    final v$OptIntMap = instance.optIntMap;
    if (v$OptIntMap != null) count$++;
    final keyed = encoder.keyed(length: count$);
    keyed.encodeString(_$NullableShowcaseSchema.nameId, instance.id);
    if (v$OptInt != null) {
      keyed.encodeInt(_$NullableShowcaseSchema.nameOptInt, v$OptInt);
    }
    if (v$OptDouble != null) {
      keyed.encodeDouble(_$NullableShowcaseSchema.nameOptDouble, v$OptDouble);
    }
    if (v$OptString != null) {
      keyed.encodeString(_$NullableShowcaseSchema.nameOptString, v$OptString);
    }
    if (v$OptBool != null) {
      keyed.encodeBool(_$NullableShowcaseSchema.nameOptBool, v$OptBool);
    }
    if (v$OptStruct != null) {
      keyed.encodeValue(
        _$NullableShowcaseSchema.nameOptStruct,
        v$OptStruct,
        const LevelCCodable(),
      );
    }
    if (v$OptEmpty != null) {
      keyed.encodeValue(
        _$NullableShowcaseSchema.nameOptEmpty,
        v$OptEmpty,
        const AllOptionalPatchCodable(),
      );
    }
    if (v$OptBytes != null) {
      keyed.encodeBytes(_$NullableShowcaseSchema.nameOptBytes, v$OptBytes);
    }
    if (v$OptStringList != null) {
      keyed.encodeStringList(
        _$NullableShowcaseSchema.nameOptStringList,
        v$OptStringList,
      );
    }
    if (v$OptStructList != null) {
      keyed.encodeList(
        _$NullableShowcaseSchema.nameOptStructList,
        v$OptStructList,
        const GridCellCodable(),
      );
    }
    if (v$OptIntSet != null) {
      keyed.encodeIntList(
        _$NullableShowcaseSchema.nameOptIntSet,
        v$OptIntSet.toList(),
      );
    }
    if (v$OptStringMap != null) {
      {
        final k = keyed
            .nestedEncoder(_$NullableShowcaseSchema.nameOptStringMap)
            .keyed(length: v$OptStringMap.length);
        for (final entry in v$OptStringMap.entries) {
          k.encodeInt(entry.key, entry.value);
        }
      }
    }
    if (v$OptIntMap != null) {
      {
        final m = keyed
            .nestedEncoder(_$NullableShowcaseSchema.nameOptIntMap)
            .map(length: v$OptIntMap.length);
        for (final entry in v$OptIntMap.entries) {
          m.keyEncoder().singleValue().encodeInt(entry.key);
          m.valueEncoder().singleValue().encodeString(entry.value);
        }
      }
    }
  }
}

// =============================================================================
// 1. Unified Schema Descriptor for TypedFeaturesEnvelope
// =============================================================================
extension type const _$TypedFeaturesEnvelopeSchema(int _value) {
  // String Name Constants
  static const String nameStringBuckets = 'stringBuckets';
  static const String nameNamedTargets = 'namedTargets';
  static const String nameStatusMessages = 'statusMessages';
  static const String nameVerbQuotas = 'verbQuotas';
  static const String nameBinaryPayload = 'binaryPayload';
  static const String nameEmptyPayload = 'emptyPayload';
  static const String nameCoords = 'coords';
  static const String nameNormal = 'normal';

  // Key Indices for selectKeyIndex()
  static const int keyStringBuckets = 0;
  static const int keyNamedTargets = 1;
  static const int keyStatusMessages = 2;
  static const int keyVerbQuotas = 3;
  static const int keyBinaryPayload = 4;
  static const int keyEmptyPayload = 5;
  static const int keyCoords = 6;
  static const int keyNormal = 7;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
    _$TypedFeaturesEnvelopeSchema.nameStringBuckets,
    _$TypedFeaturesEnvelopeSchema.nameNamedTargets,
    _$TypedFeaturesEnvelopeSchema.nameStatusMessages,
    _$TypedFeaturesEnvelopeSchema.nameVerbQuotas,
    _$TypedFeaturesEnvelopeSchema.nameBinaryPayload,
    _$TypedFeaturesEnvelopeSchema.nameEmptyPayload,
    _$TypedFeaturesEnvelopeSchema.nameCoords,
    _$TypedFeaturesEnvelopeSchema.nameNormal,
  ]);
  static final KeyOptions keyOptions = options;

  // Enum Options for HttpVerb
  static final KeyOptions enumHttpVerbKeyOptions = KeyOptions.of(const [
    'get',
    'post',
    'put',
    'delete',
  ]);

  // Bitmask Flags strictly for Required Fields
  static const _$TypedFeaturesEnvelopeSchema none =
      _$TypedFeaturesEnvelopeSchema(0);
  static const int _stringBucketsBit = 1 << 0;
  static const _$TypedFeaturesEnvelopeSchema stringBuckets =
      _$TypedFeaturesEnvelopeSchema(_stringBucketsBit);
  static const int _namedTargetsBit = 1 << 1;
  static const _$TypedFeaturesEnvelopeSchema namedTargets =
      _$TypedFeaturesEnvelopeSchema(_namedTargetsBit);
  static const int _statusMessagesBit = 1 << 2;
  static const _$TypedFeaturesEnvelopeSchema statusMessages =
      _$TypedFeaturesEnvelopeSchema(_statusMessagesBit);
  static const int _verbQuotasBit = 1 << 3;
  static const _$TypedFeaturesEnvelopeSchema verbQuotas =
      _$TypedFeaturesEnvelopeSchema(_verbQuotasBit);
  static const int _binaryPayloadBit = 1 << 4;
  static const _$TypedFeaturesEnvelopeSchema binaryPayload =
      _$TypedFeaturesEnvelopeSchema(_binaryPayloadBit);
  static const int _emptyPayloadBit = 1 << 5;
  static const _$TypedFeaturesEnvelopeSchema emptyPayload =
      _$TypedFeaturesEnvelopeSchema(_emptyPayloadBit);
  static const int _coordsBit = 1 << 6;
  static const _$TypedFeaturesEnvelopeSchema coords =
      _$TypedFeaturesEnvelopeSchema(_coordsBit);

  // Combined Golden Bitmask for fast single-instruction check
  static const _$TypedFeaturesEnvelopeSchema golden =
      _$TypedFeaturesEnvelopeSchema(
        _stringBucketsBit |
            _namedTargetsBit |
            _statusMessagesBit |
            _verbQuotasBit |
            _binaryPayloadBit |
            _emptyPayloadBit |
            _coordsBit,
      );

  @pragma('vm:prefer-inline')
  _$TypedFeaturesEnvelopeSchema operator |(
    _$TypedFeaturesEnvelopeSchema other,
  ) => _$TypedFeaturesEnvelopeSchema(_value | other._value);

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
    if ((_value & _stringBucketsBit) == 0) {
      missing.add(nameStringBuckets);
    }
    if ((_value & _namedTargetsBit) == 0) {
      missing.add(nameNamedTargets);
    }
    if ((_value & _statusMessagesBit) == 0) {
      missing.add(nameStatusMessages);
    }
    if ((_value & _verbQuotasBit) == 0) {
      missing.add(nameVerbQuotas);
    }
    if ((_value & _binaryPayloadBit) == 0) {
      missing.add(nameBinaryPayload);
    }
    if ((_value & _emptyPayloadBit) == 0) {
      missing.add(nameEmptyPayload);
    }
    if ((_value & _coordsBit) == 0) {
      missing.add(nameCoords);
    }
    throw CodableException(
      'Missing required fields for TypedFeaturesEnvelope: ${missing.join(", ")}',
    );
  }
}

// =============================================================================
// 2. Companion Codable for TypedFeaturesEnvelope
// =============================================================================
final class TypedFeaturesEnvelopeCodable
    implements Codable<TypedFeaturesEnvelope> {
  const TypedFeaturesEnvelopeCodable();

  @override
  TypedFeaturesEnvelope decode(Decoder decoder) {
    final keyed = decoder.keyed(
      options: _$TypedFeaturesEnvelopeSchema.keyOptions,
    );

    Map<String, List<int>>? stringBuckets;
    Map<String, LevelC>? namedTargets;
    Map<int, String>? statusMessages;
    Map<HttpVerb, int>? verbQuotas;
    Uint8List? binaryPayload;
    Uint8List? emptyPayload;
    Float64List? coords;
    Float64List? normal;
    var seen = _$TypedFeaturesEnvelopeSchema.none;

    while (keyed.moveNextKey()) {
      switch (keyed.selectKeyIndex(_$TypedFeaturesEnvelopeSchema.keyOptions)) {
        case _$TypedFeaturesEnvelopeSchema.keyStringBuckets:
          if ((seen._value &
                  _$TypedFeaturesEnvelopeSchema.stringBuckets._value) !=
              0) {
            throw const CodableException('Duplicate field "stringBuckets"');
          }
          {
            final k = keyed.nestedDecoder().keyed();
            final m = <String, List<int>>{};
            while (k.moveNextKey()) {
              final key = k.nextKey();
              m[key] = k.decodeIntList();
            }
            stringBuckets = m;
          }
          seen |= _$TypedFeaturesEnvelopeSchema.stringBuckets;
          break;
        case _$TypedFeaturesEnvelopeSchema.keyNamedTargets:
          if ((seen._value &
                  _$TypedFeaturesEnvelopeSchema.namedTargets._value) !=
              0) {
            throw const CodableException('Duplicate field "namedTargets"');
          }
          {
            final k = keyed.nestedDecoder().keyed();
            final m = <String, LevelC>{};
            while (k.moveNextKey()) {
              final key = k.nextKey();
              m[key] = const LevelCCodable().decode(k.nestedDecoder());
            }
            namedTargets = m;
          }
          seen |= _$TypedFeaturesEnvelopeSchema.namedTargets;
          break;
        case _$TypedFeaturesEnvelopeSchema.keyStatusMessages:
          if ((seen._value &
                  _$TypedFeaturesEnvelopeSchema.statusMessages._value) !=
              0) {
            throw const CodableException('Duplicate field "statusMessages"');
          }
          {
            final mDecoder = keyed.nestedDecoder().map();
            final m = <int, String>{};
            while (mDecoder.moveNextEntry()) {
              final key = mDecoder.keyDecoder().singleValue().readInt();
              m[key] = mDecoder.valueDecoder().singleValue().readString();
            }
            statusMessages = m;
          }
          seen |= _$TypedFeaturesEnvelopeSchema.statusMessages;
          break;
        case _$TypedFeaturesEnvelopeSchema.keyVerbQuotas:
          if ((seen._value & _$TypedFeaturesEnvelopeSchema.verbQuotas._value) !=
              0) {
            throw const CodableException('Duplicate field "verbQuotas"');
          }
          {
            final mDecoder = keyed.nestedDecoder().map();
            final m = <HttpVerb, int>{};
            while (mDecoder.moveNextEntry()) {
              final rawEnum1Key = mDecoder
                  .keyDecoder()
                  .singleValue()
                  .readString();
              final enumIdx1Key = _$TypedFeaturesEnvelopeSchema
                  .enumHttpVerbKeyOptions
                  .indexOf(rawEnum1Key);
              if (enumIdx1Key < 0) {
                throw CodableException(
                  'Unknown HttpVerb value: "$rawEnum1Key"',
                  actualValue: rawEnum1Key,
                );
              }
              final key = HttpVerb.values[enumIdx1Key];
              m[key] = mDecoder.valueDecoder().singleValue().readInt();
            }
            verbQuotas = m;
          }
          seen |= _$TypedFeaturesEnvelopeSchema.verbQuotas;
          break;
        case _$TypedFeaturesEnvelopeSchema.keyBinaryPayload:
          if ((seen._value &
                  _$TypedFeaturesEnvelopeSchema.binaryPayload._value) !=
              0) {
            throw const CodableException('Duplicate field "binaryPayload"');
          }
          binaryPayload = keyed.readBytes();
          seen |= _$TypedFeaturesEnvelopeSchema.binaryPayload;
          break;
        case _$TypedFeaturesEnvelopeSchema.keyEmptyPayload:
          if ((seen._value &
                  _$TypedFeaturesEnvelopeSchema.emptyPayload._value) !=
              0) {
            throw const CodableException('Duplicate field "emptyPayload"');
          }
          emptyPayload = keyed.readBytes();
          seen |= _$TypedFeaturesEnvelopeSchema.emptyPayload;
          break;
        case _$TypedFeaturesEnvelopeSchema.keyCoords:
          if ((seen._value & _$TypedFeaturesEnvelopeSchema.coords._value) !=
              0) {
            throw const CodableException('Duplicate field "coords"');
          }
          coords = keyed.decodeFloat64List();
          if (coords.length != 2) {
            throw CodableException(
              'Expected tuple of length 2 for "coords", got ${coords.length}',
              actualValue: coords.length,
            );
          }
          seen |= _$TypedFeaturesEnvelopeSchema.coords;
          break;
        case _$TypedFeaturesEnvelopeSchema.keyNormal:
          if (keyed.isNextNull()) {
            keyed.readNull();
            normal = null;
          } else {
            normal = keyed.decodeFloat64List();
            if (normal.length != 4) {
              throw CodableException(
                'Expected tuple of length 4 for "normal", got ${normal.length}',
                actualValue: normal.length,
              );
            }
          }
          break;
        default:
          keyed.skipValue();
          break;
      }
    }

    // Inlined fast-path check
    seen.validate();

    return TypedFeaturesEnvelope(
      stringBuckets: stringBuckets!,
      namedTargets: namedTargets!,
      statusMessages: statusMessages!,
      verbQuotas: verbQuotas!,
      binaryPayload: binaryPayload!,
      emptyPayload: emptyPayload!,
      coords: coords!,
      normal: normal,
    );
  }

  @override
  void encode(TypedFeaturesEnvelope instance, Encoder encoder) {
    var count$ = 7;
    final v$Normal = instance.normal;
    if (v$Normal != null) count$++;
    final keyed = encoder.keyed(length: count$);
    {
      final k = keyed
          .nestedEncoder(_$TypedFeaturesEnvelopeSchema.nameStringBuckets)
          .keyed(length: instance.stringBuckets.length);
      for (final entry in instance.stringBuckets.entries) {
        k.encodeIntList(entry.key, entry.value);
      }
    }
    {
      final k = keyed
          .nestedEncoder(_$TypedFeaturesEnvelopeSchema.nameNamedTargets)
          .keyed(length: instance.namedTargets.length);
      for (final entry in instance.namedTargets.entries) {
        const LevelCCodable().encode(entry.value, k.nestedEncoder(entry.key));
      }
    }
    {
      final m = keyed
          .nestedEncoder(_$TypedFeaturesEnvelopeSchema.nameStatusMessages)
          .map(length: instance.statusMessages.length);
      for (final entry in instance.statusMessages.entries) {
        m.keyEncoder().singleValue().encodeInt(entry.key);
        m.valueEncoder().singleValue().encodeString(entry.value);
      }
    }
    {
      final m = keyed
          .nestedEncoder(_$TypedFeaturesEnvelopeSchema.nameVerbQuotas)
          .map(length: instance.verbQuotas.length);
      for (final entry in instance.verbQuotas.entries) {
        m.keyEncoder().singleValue().encodeString(entry.key.name);
        m.valueEncoder().singleValue().encodeInt(entry.value);
      }
    }
    keyed.encodeBytes(
      _$TypedFeaturesEnvelopeSchema.nameBinaryPayload,
      instance.binaryPayload,
    );
    keyed.encodeBytes(
      _$TypedFeaturesEnvelopeSchema.nameEmptyPayload,
      instance.emptyPayload,
    );
    keyed.encodeDoubleList(
      _$TypedFeaturesEnvelopeSchema.nameCoords,
      instance.coords,
    );
    if (v$Normal != null) {
      keyed.encodeDoubleList(
        _$TypedFeaturesEnvelopeSchema.nameNormal,
        v$Normal,
      );
    }
  }
}

// =============================================================================
// 1. Unified Schema Descriptor for CircleSpec
// =============================================================================
extension type const _$CircleSpecSchema(int _value) {
  // String Name Constants
  static const String nameMeta = 'meta';
  static const String nameRadius = 'radius';
  static const String nameLabel = 'label';
  static const String nameKind = 'kind';

  // Key Indices for selectKeyIndex()
  static const int keyMeta = 0;
  static const int keyRadius = 1;
  static const int keyLabel = 2;
  static const int keyKind = 3;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
    _$CircleSpecSchema.nameMeta,
    _$CircleSpecSchema.nameRadius,
    _$CircleSpecSchema.nameLabel,
    _$CircleSpecSchema.nameKind,
  ]);
  static final KeyOptions keyOptions = options;

  // Bitmask Flags strictly for Required Fields
  static const _$CircleSpecSchema none = _$CircleSpecSchema(0);
  static const int _radiusBit = 1 << 0;
  static const _$CircleSpecSchema radius = _$CircleSpecSchema(_radiusBit);

  // Combined Golden Bitmask for fast single-instruction check
  static const _$CircleSpecSchema golden = _$CircleSpecSchema(_radiusBit);

  @pragma('vm:prefer-inline')
  _$CircleSpecSchema operator |(_$CircleSpecSchema other) =>
      _$CircleSpecSchema(_value | other._value);

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
    if ((_value & _radiusBit) == 0) {
      missing.add(nameRadius);
    }
    throw CodableException(
      'Missing required fields for CircleSpec: ${missing.join(", ")}',
    );
  }
}

// =============================================================================
// 2. Companion Codable for CircleSpec
// =============================================================================
final class CircleSpecCodable implements Codable<CircleSpec> {
  const CircleSpecCodable();

  @override
  CircleSpec decode(Decoder decoder) {
    final keyed = decoder.keyed(options: _$CircleSpecSchema.keyOptions);

    LevelC? meta;
    double? radius;
    String? label;
    String kind = 'circle';
    var seen = _$CircleSpecSchema.none;

    while (keyed.moveNextKey()) {
      switch (keyed.selectKeyIndex(_$CircleSpecSchema.keyOptions)) {
        case _$CircleSpecSchema.keyMeta:
          if (keyed.isNextNull()) {
            keyed.readNull();
            meta = null;
          } else {
            meta = const LevelCCodable().decode(keyed.nestedDecoder());
          }
          break;
        case _$CircleSpecSchema.keyRadius:
          if ((seen._value & _$CircleSpecSchema.radius._value) != 0) {
            throw const CodableException('Duplicate field "radius"');
          }
          radius = keyed.readDouble();
          seen |= _$CircleSpecSchema.radius;
          break;
        case _$CircleSpecSchema.keyLabel:
          if (keyed.isNextNull()) {
            keyed.readNull();
            label = null;
          } else {
            label = keyed.readString();
          }
          break;
        case _$CircleSpecSchema.keyKind:
          kind = keyed.readString();
          break;
        default:
          keyed.skipValue();
          break;
      }
    }

    // Inlined fast-path check
    seen.validate();

    return CircleSpec(meta: meta, radius: radius!, label: label, kind: kind);
  }

  @override
  void encode(CircleSpec instance, Encoder encoder) {
    var count$ = 2;
    final v$Meta = instance.meta;
    if (v$Meta != null) count$++;
    final v$Label = instance.label;
    if (v$Label != null) count$++;
    final keyed = encoder.keyed(length: count$);
    if (v$Meta != null) {
      keyed.encodeValue(
        _$CircleSpecSchema.nameMeta,
        v$Meta,
        const LevelCCodable(),
      );
    }
    keyed.encodeDouble(_$CircleSpecSchema.nameRadius, instance.radius);
    if (v$Label != null) {
      keyed.encodeString(_$CircleSpecSchema.nameLabel, v$Label);
    }
    keyed.encodeString(_$CircleSpecSchema.nameKind, instance.kind);
  }
}

// =============================================================================
// 1. Unified Schema Descriptor for PolygonSpec
// =============================================================================
extension type const _$PolygonSpecSchema(int _value) {
  // String Name Constants
  static const String nameVertices = 'vertices';
  static const String nameClosed = 'closed';
  static const String nameKind = 'kind';

  // Key Indices for selectKeyIndex()
  static const int keyVertices = 0;
  static const int keyClosed = 1;
  static const int keyKind = 2;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
    _$PolygonSpecSchema.nameVertices,
    _$PolygonSpecSchema.nameClosed,
    _$PolygonSpecSchema.nameKind,
  ]);
  static final KeyOptions keyOptions = options;

  // Bitmask Flags strictly for Required Fields
  static const _$PolygonSpecSchema none = _$PolygonSpecSchema(0);
  static const int _verticesBit = 1 << 0;
  static const _$PolygonSpecSchema vertices = _$PolygonSpecSchema(_verticesBit);

  // Combined Golden Bitmask for fast single-instruction check
  static const _$PolygonSpecSchema golden = _$PolygonSpecSchema(_verticesBit);

  @pragma('vm:prefer-inline')
  _$PolygonSpecSchema operator |(_$PolygonSpecSchema other) =>
      _$PolygonSpecSchema(_value | other._value);

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
    if ((_value & _verticesBit) == 0) {
      missing.add(nameVertices);
    }
    throw CodableException(
      'Missing required fields for PolygonSpec: ${missing.join(", ")}',
    );
  }
}

// =============================================================================
// 2. Companion Codable for PolygonSpec
// =============================================================================
final class PolygonSpecCodable implements Codable<PolygonSpec> {
  const PolygonSpecCodable();

  @override
  PolygonSpec decode(Decoder decoder) {
    final keyed = decoder.keyed(options: _$PolygonSpecSchema.keyOptions);

    List<int>? vertices;
    bool closed = true;
    String kind = 'polygon';
    var seen = _$PolygonSpecSchema.none;

    while (keyed.moveNextKey()) {
      switch (keyed.selectKeyIndex(_$PolygonSpecSchema.keyOptions)) {
        case _$PolygonSpecSchema.keyVertices:
          if ((seen._value & _$PolygonSpecSchema.vertices._value) != 0) {
            throw const CodableException('Duplicate field "vertices"');
          }
          vertices = keyed.decodeIntList();
          seen |= _$PolygonSpecSchema.vertices;
          break;
        case _$PolygonSpecSchema.keyClosed:
          closed = keyed.readBool();
          break;
        case _$PolygonSpecSchema.keyKind:
          kind = keyed.readString();
          break;
        default:
          keyed.skipValue();
          break;
      }
    }

    // Inlined fast-path check
    seen.validate();

    return PolygonSpec(vertices: vertices!, closed: closed, kind: kind);
  }

  @override
  void encode(PolygonSpec instance, Encoder encoder) {
    final keyed = encoder.keyed(length: 3);
    keyed.encodeIntList(_$PolygonSpecSchema.nameVertices, instance.vertices);
    keyed.encodeBool(_$PolygonSpecSchema.nameClosed, instance.closed);
    keyed.encodeString(_$PolygonSpecSchema.nameKind, instance.kind);
  }
}

// =============================================================================
// 1. Unified Schema Descriptor for PolymorphicCanvas
// =============================================================================
extension type const _$PolymorphicCanvasSchema(int _value) {
  // String Name Constants
  static const String nameHero = 'hero';
  static const String nameSecondary = 'secondary';
  static const String nameCanvasId = 'canvasId';

  // Key Indices for selectKeyIndex()
  static const int keyHero = 0;
  static const int keySecondary = 1;
  static const int keyCanvasId = 2;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
    _$PolymorphicCanvasSchema.nameHero,
    _$PolymorphicCanvasSchema.nameSecondary,
    _$PolymorphicCanvasSchema.nameCanvasId,
  ]);
  static final KeyOptions keyOptions = options;

  // Bitmask Flags strictly for Required Fields
  static const _$PolymorphicCanvasSchema none = _$PolymorphicCanvasSchema(0);
  static const int _heroBit = 1 << 0;
  static const _$PolymorphicCanvasSchema hero = _$PolymorphicCanvasSchema(
    _heroBit,
  );
  static const int _canvasIdBit = 1 << 1;
  static const _$PolymorphicCanvasSchema canvasId = _$PolymorphicCanvasSchema(
    _canvasIdBit,
  );

  // Combined Golden Bitmask for fast single-instruction check
  static const _$PolymorphicCanvasSchema golden = _$PolymorphicCanvasSchema(
    _heroBit | _canvasIdBit,
  );

  @pragma('vm:prefer-inline')
  _$PolymorphicCanvasSchema operator |(_$PolymorphicCanvasSchema other) =>
      _$PolymorphicCanvasSchema(_value | other._value);

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
    if ((_value & _heroBit) == 0) {
      missing.add(nameHero);
    }
    if ((_value & _canvasIdBit) == 0) {
      missing.add(nameCanvasId);
    }
    throw CodableException(
      'Missing required fields for PolymorphicCanvas: ${missing.join(", ")}',
    );
  }
}

// =============================================================================
// 2. Companion Codable for PolymorphicCanvas
// =============================================================================
final class PolymorphicCanvasCodable implements Codable<PolymorphicCanvas> {
  const PolymorphicCanvasCodable();

  @override
  PolymorphicCanvas decode(Decoder decoder) {
    final keyed = decoder.keyed(options: _$PolymorphicCanvasSchema.keyOptions);

    ShapeSpec? hero;
    ShapeSpec? secondary;
    String? canvasId;
    var seen = _$PolymorphicCanvasSchema.none;

    while (keyed.moveNextKey()) {
      switch (keyed.selectKeyIndex(_$PolymorphicCanvasSchema.keyOptions)) {
        case _$PolymorphicCanvasSchema.keyHero:
          if ((seen._value & _$PolymorphicCanvasSchema.hero._value) != 0) {
            throw const CodableException('Duplicate field "hero"');
          }
          hero = keyed.decodeValue(const ShapeSpecCodable());
          seen |= _$PolymorphicCanvasSchema.hero;
          break;
        case _$PolymorphicCanvasSchema.keySecondary:
          if (keyed.isNextNull()) {
            keyed.readNull();
            secondary = null;
          } else {
            secondary = keyed.decodeValue(const ShapeSpecCodable());
          }
          break;
        case _$PolymorphicCanvasSchema.keyCanvasId:
          if ((seen._value & _$PolymorphicCanvasSchema.canvasId._value) != 0) {
            throw const CodableException('Duplicate field "canvasId"');
          }
          canvasId = keyed.readString();
          seen |= _$PolymorphicCanvasSchema.canvasId;
          break;
        default:
          keyed.skipValue();
          break;
      }
    }

    // Inlined fast-path check
    seen.validate();

    return PolymorphicCanvas(
      hero: hero!,
      secondary: secondary,
      canvasId: canvasId!,
    );
  }

  @override
  void encode(PolymorphicCanvas instance, Encoder encoder) {
    var count$ = 2;
    final v$Secondary = instance.secondary;
    if (v$Secondary != null) count$++;
    final keyed = encoder.keyed(length: count$);
    keyed.encodeValue(
      _$PolymorphicCanvasSchema.nameHero,
      instance.hero,
      const ShapeSpecCodable(),
    );
    if (v$Secondary != null) {
      keyed.encodeValue(
        _$PolymorphicCanvasSchema.nameSecondary,
        v$Secondary,
        const ShapeSpecCodable(),
      );
    }
    keyed.encodeString(
      _$PolymorphicCanvasSchema.nameCanvasId,
      instance.canvasId,
    );
  }
}

// =============================================================================
// 1. Unified Schema Descriptor for TimestampCollisionModel
// =============================================================================
extension type const _$TimestampCollisionModelSchema(int _value) {
  // String Name Constants
  static const String nameTimestamp = 'timestamp';
  static const String nameExpiresAt = 'expiresAt';
  static const String nameRawIsoString = 'rawIsoString';
  static const String nameRawLocalDateString = 'rawLocalDateString';
  static const String nameRawLocalTimeString = 'rawLocalTimeString';

  // Key Indices for selectKeyIndex()
  static const int keyTimestamp = 0;
  static const int keyExpiresAt = 1;
  static const int keyRawIsoString = 2;
  static const int keyRawLocalDateString = 3;
  static const int keyRawLocalTimeString = 4;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
    _$TimestampCollisionModelSchema.nameTimestamp,
    _$TimestampCollisionModelSchema.nameExpiresAt,
    _$TimestampCollisionModelSchema.nameRawIsoString,
    _$TimestampCollisionModelSchema.nameRawLocalDateString,
    _$TimestampCollisionModelSchema.nameRawLocalTimeString,
  ]);
  static final KeyOptions keyOptions = options;

  // Bitmask Flags strictly for Required Fields
  static const _$TimestampCollisionModelSchema none =
      _$TimestampCollisionModelSchema(0);
  static const int _timestampBit = 1 << 0;
  static const _$TimestampCollisionModelSchema timestamp =
      _$TimestampCollisionModelSchema(_timestampBit);
  static const int _rawIsoStringBit = 1 << 1;
  static const _$TimestampCollisionModelSchema rawIsoString =
      _$TimestampCollisionModelSchema(_rawIsoStringBit);
  static const int _rawLocalDateStringBit = 1 << 2;
  static const _$TimestampCollisionModelSchema rawLocalDateString =
      _$TimestampCollisionModelSchema(_rawLocalDateStringBit);
  static const int _rawLocalTimeStringBit = 1 << 3;
  static const _$TimestampCollisionModelSchema rawLocalTimeString =
      _$TimestampCollisionModelSchema(_rawLocalTimeStringBit);

  // Combined Golden Bitmask for fast single-instruction check
  static const _$TimestampCollisionModelSchema golden =
      _$TimestampCollisionModelSchema(
        _timestampBit |
            _rawIsoStringBit |
            _rawLocalDateStringBit |
            _rawLocalTimeStringBit,
      );

  @pragma('vm:prefer-inline')
  _$TimestampCollisionModelSchema operator |(
    _$TimestampCollisionModelSchema other,
  ) => _$TimestampCollisionModelSchema(_value | other._value);

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
    if ((_value & _timestampBit) == 0) {
      missing.add(nameTimestamp);
    }
    if ((_value & _rawIsoStringBit) == 0) {
      missing.add(nameRawIsoString);
    }
    if ((_value & _rawLocalDateStringBit) == 0) {
      missing.add(nameRawLocalDateString);
    }
    if ((_value & _rawLocalTimeStringBit) == 0) {
      missing.add(nameRawLocalTimeString);
    }
    throw CodableException(
      'Missing required fields for TimestampCollisionModel: ${missing.join(", ")}',
    );
  }
}

// =============================================================================
// 2. Companion Codable for TimestampCollisionModel
// =============================================================================
final class TimestampCollisionModelCodable
    implements Codable<TimestampCollisionModel> {
  const TimestampCollisionModelCodable();

  @override
  TimestampCollisionModel decode(Decoder decoder) {
    final keyed = decoder.keyed(
      options: _$TimestampCollisionModelSchema.keyOptions,
    );

    DateTime? timestamp;
    DateTime? expiresAt;
    String? rawIsoString;
    String? rawLocalDateString;
    String? rawLocalTimeString;
    var seen = _$TimestampCollisionModelSchema.none;

    while (keyed.moveNextKey()) {
      switch (keyed.selectKeyIndex(
        _$TimestampCollisionModelSchema.keyOptions,
      )) {
        case _$TimestampCollisionModelSchema.keyTimestamp:
          if ((seen._value &
                  _$TimestampCollisionModelSchema.timestamp._value) !=
              0) {
            throw const CodableException('Duplicate field "timestamp"');
          }
          timestamp = keyed.decodeValue(const TomlDateTimeCodec());
          seen |= _$TimestampCollisionModelSchema.timestamp;
          break;
        case _$TimestampCollisionModelSchema.keyExpiresAt:
          if (keyed.isNextNull()) {
            keyed.readNull();
            expiresAt = null;
          } else {
            expiresAt = keyed.decodeValue(const TomlDateTimeCodec());
          }
          break;
        case _$TimestampCollisionModelSchema.keyRawIsoString:
          if ((seen._value &
                  _$TimestampCollisionModelSchema.rawIsoString._value) !=
              0) {
            throw const CodableException('Duplicate field "rawIsoString"');
          }
          rawIsoString = keyed.readString();
          seen |= _$TimestampCollisionModelSchema.rawIsoString;
          break;
        case _$TimestampCollisionModelSchema.keyRawLocalDateString:
          if ((seen._value &
                  _$TimestampCollisionModelSchema.rawLocalDateString._value) !=
              0) {
            throw const CodableException(
              'Duplicate field "rawLocalDateString"',
            );
          }
          rawLocalDateString = keyed.readString();
          seen |= _$TimestampCollisionModelSchema.rawLocalDateString;
          break;
        case _$TimestampCollisionModelSchema.keyRawLocalTimeString:
          if ((seen._value &
                  _$TimestampCollisionModelSchema.rawLocalTimeString._value) !=
              0) {
            throw const CodableException(
              'Duplicate field "rawLocalTimeString"',
            );
          }
          rawLocalTimeString = keyed.readString();
          seen |= _$TimestampCollisionModelSchema.rawLocalTimeString;
          break;
        default:
          keyed.skipValue();
          break;
      }
    }

    // Inlined fast-path check
    seen.validate();

    return TimestampCollisionModel(
      timestamp: timestamp!,
      expiresAt: expiresAt,
      rawIsoString: rawIsoString!,
      rawLocalDateString: rawLocalDateString!,
      rawLocalTimeString: rawLocalTimeString!,
    );
  }

  @override
  void encode(TimestampCollisionModel instance, Encoder encoder) {
    var count$ = 4;
    final v$ExpiresAt = instance.expiresAt;
    if (v$ExpiresAt != null) count$++;
    final keyed = encoder.keyed(length: count$);
    keyed.encodeValue(
      _$TimestampCollisionModelSchema.nameTimestamp,
      instance.timestamp,
      const TomlDateTimeCodec(),
    );
    if (v$ExpiresAt != null) {
      keyed.encodeValue(
        _$TimestampCollisionModelSchema.nameExpiresAt,
        v$ExpiresAt,
        const TomlDateTimeCodec(),
      );
    }
    keyed.encodeString(
      _$TimestampCollisionModelSchema.nameRawIsoString,
      instance.rawIsoString,
    );
    keyed.encodeString(
      _$TimestampCollisionModelSchema.nameRawLocalDateString,
      instance.rawLocalDateString,
    );
    keyed.encodeString(
      _$TimestampCollisionModelSchema.nameRawLocalTimeString,
      instance.rawLocalTimeString,
    );
  }
}

// =============================================================================
// 1. Unified Schema Descriptor for LocalDateTimesRecord
// =============================================================================
extension type const _$LocalDateTimesRecordSchema(int _value) {
  // String Name Constants
  static const String nameOffsetInstant = 'offsetInstant';
  static const String nameLocalWallClock = 'localWallClock';
  static const String nameCalendarDay = 'calendarDay';
  static const String nameDailyWindow = 'dailyWindow';

  // Key Indices for selectKeyIndex()
  static const int keyOffsetInstant = 0;
  static const int keyLocalWallClock = 1;
  static const int keyCalendarDay = 2;
  static const int keyDailyWindow = 3;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
    _$LocalDateTimesRecordSchema.nameOffsetInstant,
    _$LocalDateTimesRecordSchema.nameLocalWallClock,
    _$LocalDateTimesRecordSchema.nameCalendarDay,
    _$LocalDateTimesRecordSchema.nameDailyWindow,
  ]);
  static final KeyOptions keyOptions = options;

  // Bitmask Flags strictly for Required Fields
  static const _$LocalDateTimesRecordSchema none = _$LocalDateTimesRecordSchema(
    0,
  );
  static const int _offsetInstantBit = 1 << 0;
  static const _$LocalDateTimesRecordSchema offsetInstant =
      _$LocalDateTimesRecordSchema(_offsetInstantBit);
  static const int _localWallClockBit = 1 << 1;
  static const _$LocalDateTimesRecordSchema localWallClock =
      _$LocalDateTimesRecordSchema(_localWallClockBit);
  static const int _calendarDayBit = 1 << 2;
  static const _$LocalDateTimesRecordSchema calendarDay =
      _$LocalDateTimesRecordSchema(_calendarDayBit);

  // Combined Golden Bitmask for fast single-instruction check
  static const _$LocalDateTimesRecordSchema golden =
      _$LocalDateTimesRecordSchema(
        _offsetInstantBit | _localWallClockBit | _calendarDayBit,
      );

  @pragma('vm:prefer-inline')
  _$LocalDateTimesRecordSchema operator |(_$LocalDateTimesRecordSchema other) =>
      _$LocalDateTimesRecordSchema(_value | other._value);

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
    if ((_value & _offsetInstantBit) == 0) {
      missing.add(nameOffsetInstant);
    }
    if ((_value & _localWallClockBit) == 0) {
      missing.add(nameLocalWallClock);
    }
    if ((_value & _calendarDayBit) == 0) {
      missing.add(nameCalendarDay);
    }
    throw CodableException(
      'Missing required fields for LocalDateTimesRecord: ${missing.join(", ")}',
    );
  }
}

// =============================================================================
// 2. Companion Codable for LocalDateTimesRecord
// =============================================================================
final class LocalDateTimesRecordCodable
    implements Codable<LocalDateTimesRecord> {
  const LocalDateTimesRecordCodable();

  @override
  LocalDateTimesRecord decode(Decoder decoder) {
    final keyed = decoder.keyed(
      options: _$LocalDateTimesRecordSchema.keyOptions,
    );

    DateTime? offsetInstant;
    DateTime? localWallClock;
    DateTime? calendarDay;
    TomlDateTime? dailyWindow;
    var seen = _$LocalDateTimesRecordSchema.none;

    while (keyed.moveNextKey()) {
      switch (keyed.selectKeyIndex(_$LocalDateTimesRecordSchema.keyOptions)) {
        case _$LocalDateTimesRecordSchema.keyOffsetInstant:
          if ((seen._value &
                  _$LocalDateTimesRecordSchema.offsetInstant._value) !=
              0) {
            throw const CodableException('Duplicate field "offsetInstant"');
          }
          offsetInstant = keyed.decodeValue(const TomlDateTimeCodec());
          seen |= _$LocalDateTimesRecordSchema.offsetInstant;
          break;
        case _$LocalDateTimesRecordSchema.keyLocalWallClock:
          if ((seen._value &
                  _$LocalDateTimesRecordSchema.localWallClock._value) !=
              0) {
            throw const CodableException('Duplicate field "localWallClock"');
          }
          localWallClock = keyed.decodeValue(const TomlDateTimeCodec());
          seen |= _$LocalDateTimesRecordSchema.localWallClock;
          break;
        case _$LocalDateTimesRecordSchema.keyCalendarDay:
          if ((seen._value & _$LocalDateTimesRecordSchema.calendarDay._value) !=
              0) {
            throw const CodableException('Duplicate field "calendarDay"');
          }
          calendarDay = keyed.decodeValue(const TomlDateTimeCodec());
          seen |= _$LocalDateTimesRecordSchema.calendarDay;
          break;
        case _$LocalDateTimesRecordSchema.keyDailyWindow:
          if (keyed.isNextNull()) {
            keyed.readNull();
            dailyWindow = null;
          } else {
            dailyWindow = keyed.decodeValue(const TomlDateTimeCodable());
          }
          break;
        default:
          keyed.skipValue();
          break;
      }
    }

    // Inlined fast-path check
    seen.validate();

    return LocalDateTimesRecord(
      offsetInstant: offsetInstant!,
      localWallClock: localWallClock!,
      calendarDay: calendarDay!,
      dailyWindow: dailyWindow,
    );
  }

  @override
  void encode(LocalDateTimesRecord instance, Encoder encoder) {
    var count$ = 3;
    final v$DailyWindow = instance.dailyWindow;
    if (v$DailyWindow != null) count$++;
    final keyed = encoder.keyed(length: count$);
    keyed.encodeValue(
      _$LocalDateTimesRecordSchema.nameOffsetInstant,
      instance.offsetInstant,
      const TomlDateTimeCodec(),
    );
    keyed.encodeValue(
      _$LocalDateTimesRecordSchema.nameLocalWallClock,
      instance.localWallClock,
      const TomlDateTimeCodec(),
    );
    keyed.encodeValue(
      _$LocalDateTimesRecordSchema.nameCalendarDay,
      instance.calendarDay,
      const TomlDateTimeCodec(),
    );
    if (v$DailyWindow != null) {
      keyed.encodeValue(
        _$LocalDateTimesRecordSchema.nameDailyWindow,
        v$DailyWindow,
        const TomlDateTimeCodable(),
      );
    }
  }
}

// =============================================================================
// 1. Unified Schema Descriptor for NullableElementListModel
// =============================================================================
extension type const _$NullableElementListModelSchema(int _value) {
  // String Name Constants
  static const String nameValues = 'values';

  // Key Indices for selectKeyIndex()
  static const int keyValues = 0;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
    _$NullableElementListModelSchema.nameValues,
  ]);
  static final KeyOptions keyOptions = options;

  // Bitmask Flags strictly for Required Fields
  static const _$NullableElementListModelSchema none =
      _$NullableElementListModelSchema(0);
  static const int _valuesBit = 1 << 0;
  static const _$NullableElementListModelSchema values =
      _$NullableElementListModelSchema(_valuesBit);

  // Combined Golden Bitmask for fast single-instruction check
  static const _$NullableElementListModelSchema golden =
      _$NullableElementListModelSchema(_valuesBit);

  @pragma('vm:prefer-inline')
  _$NullableElementListModelSchema operator |(
    _$NullableElementListModelSchema other,
  ) => _$NullableElementListModelSchema(_value | other._value);

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
    if ((_value & _valuesBit) == 0) {
      missing.add(nameValues);
    }
    throw CodableException(
      'Missing required fields for NullableElementListModel: ${missing.join(", ")}',
    );
  }
}

// =============================================================================
// 2. Companion Codable for NullableElementListModel
// =============================================================================
final class NullableElementListModelCodable
    implements Codable<NullableElementListModel> {
  const NullableElementListModelCodable();

  @override
  NullableElementListModel decode(Decoder decoder) {
    final keyed = decoder.keyed(
      options: _$NullableElementListModelSchema.keyOptions,
    );

    List<int?>? values;
    var seen = _$NullableElementListModelSchema.none;

    while (keyed.moveNextKey()) {
      switch (keyed.selectKeyIndex(
        _$NullableElementListModelSchema.keyOptions,
      )) {
        case _$NullableElementListModelSchema.keyValues:
          if ((seen._value & _$NullableElementListModelSchema.values._value) !=
              0) {
            throw const CodableException('Duplicate field "values"');
          }
          values = keyed.decodeList<int?>(
            Decodable.fromFunction((d) => d.singleValue().readNullableInt()),
          );
          seen |= _$NullableElementListModelSchema.values;
          break;
        default:
          keyed.skipValue();
          break;
      }
    }

    // Inlined fast-path check
    seen.validate();

    return NullableElementListModel(values: values!);
  }

  @override
  void encode(NullableElementListModel instance, Encoder encoder) {
    final keyed = encoder.keyed(length: 1);
    keyed.encodeList(
      _$NullableElementListModelSchema.nameValues,
      instance.values,
      Encodable.fromFunction((int? item, e) {
        e.singleValue().encodeNullableInt(item);
      }),
    );
  }
}

// =============================================================================
// 1. Unified Schema Descriptor for NullableStringMapModel
// =============================================================================
extension type const _$NullableStringMapModelSchema(int _value) {
  // String Name Constants
  static const String nameScores = 'scores';

  // Key Indices for selectKeyIndex()
  static const int keyScores = 0;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
    _$NullableStringMapModelSchema.nameScores,
  ]);
  static final KeyOptions keyOptions = options;

  // Bitmask Flags strictly for Required Fields
  static const _$NullableStringMapModelSchema none =
      _$NullableStringMapModelSchema(0);
  static const int _scoresBit = 1 << 0;
  static const _$NullableStringMapModelSchema scores =
      _$NullableStringMapModelSchema(_scoresBit);

  // Combined Golden Bitmask for fast single-instruction check
  static const _$NullableStringMapModelSchema golden =
      _$NullableStringMapModelSchema(_scoresBit);

  @pragma('vm:prefer-inline')
  _$NullableStringMapModelSchema operator |(
    _$NullableStringMapModelSchema other,
  ) => _$NullableStringMapModelSchema(_value | other._value);

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
    if ((_value & _scoresBit) == 0) {
      missing.add(nameScores);
    }
    throw CodableException(
      'Missing required fields for NullableStringMapModel: ${missing.join(", ")}',
    );
  }
}

// =============================================================================
// 2. Companion Codable for NullableStringMapModel
// =============================================================================
final class NullableStringMapModelCodable
    implements Codable<NullableStringMapModel> {
  const NullableStringMapModelCodable();

  @override
  NullableStringMapModel decode(Decoder decoder) {
    final keyed = decoder.keyed(
      options: _$NullableStringMapModelSchema.keyOptions,
    );

    Map<String, int?>? scores;
    var seen = _$NullableStringMapModelSchema.none;

    while (keyed.moveNextKey()) {
      switch (keyed.selectKeyIndex(_$NullableStringMapModelSchema.keyOptions)) {
        case _$NullableStringMapModelSchema.keyScores:
          if ((seen._value & _$NullableStringMapModelSchema.scores._value) !=
              0) {
            throw const CodableException('Duplicate field "scores"');
          }
          {
            final k = keyed.nestedDecoder().keyed();
            final m = <String, int?>{};
            while (k.moveNextKey()) {
              final key = k.nextKey();
              m[key] = k.readNullableInt();
            }
            scores = m;
          }
          seen |= _$NullableStringMapModelSchema.scores;
          break;
        default:
          keyed.skipValue();
          break;
      }
    }

    // Inlined fast-path check
    seen.validate();

    return NullableStringMapModel(scores: scores!);
  }

  @override
  void encode(NullableStringMapModel instance, Encoder encoder) {
    final keyed = encoder.keyed(length: 1);
    {
      final k = keyed
          .nestedEncoder(_$NullableStringMapModelSchema.nameScores)
          .keyed(length: instance.scores.length);
      for (final entry in instance.scores.entries) {
        if (entry.value case final val1?) {
          k.encodeInt(entry.key, val1);
        } else {
          k.encodeNull(entry.key);
        }
      }
    }
  }
}

// =============================================================================
// 1. Unified Schema Descriptor for NullableIntMapModel
// =============================================================================
extension type const _$NullableIntMapModelSchema(int _value) {
  // String Name Constants
  static const String nameBuckets = 'buckets';

  // Key Indices for selectKeyIndex()
  static const int keyBuckets = 0;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
    _$NullableIntMapModelSchema.nameBuckets,
  ]);
  static final KeyOptions keyOptions = options;

  // Bitmask Flags strictly for Required Fields
  static const _$NullableIntMapModelSchema none = _$NullableIntMapModelSchema(
    0,
  );
  static const int _bucketsBit = 1 << 0;
  static const _$NullableIntMapModelSchema buckets =
      _$NullableIntMapModelSchema(_bucketsBit);

  // Combined Golden Bitmask for fast single-instruction check
  static const _$NullableIntMapModelSchema golden = _$NullableIntMapModelSchema(
    _bucketsBit,
  );

  @pragma('vm:prefer-inline')
  _$NullableIntMapModelSchema operator |(_$NullableIntMapModelSchema other) =>
      _$NullableIntMapModelSchema(_value | other._value);

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
    if ((_value & _bucketsBit) == 0) {
      missing.add(nameBuckets);
    }
    throw CodableException(
      'Missing required fields for NullableIntMapModel: ${missing.join(", ")}',
    );
  }
}

// =============================================================================
// 2. Companion Codable for NullableIntMapModel
// =============================================================================
final class NullableIntMapModelCodable implements Codable<NullableIntMapModel> {
  const NullableIntMapModelCodable();

  @override
  NullableIntMapModel decode(Decoder decoder) {
    final keyed = decoder.keyed(
      options: _$NullableIntMapModelSchema.keyOptions,
    );

    Map<int, int?>? buckets;
    var seen = _$NullableIntMapModelSchema.none;

    while (keyed.moveNextKey()) {
      switch (keyed.selectKeyIndex(_$NullableIntMapModelSchema.keyOptions)) {
        case _$NullableIntMapModelSchema.keyBuckets:
          if ((seen._value & _$NullableIntMapModelSchema.buckets._value) != 0) {
            throw const CodableException('Duplicate field "buckets"');
          }
          {
            final mDecoder = keyed.nestedDecoder().map();
            final m = <int, int?>{};
            while (mDecoder.moveNextEntry()) {
              final key = mDecoder.keyDecoder().singleValue().readInt();
              m[key] = mDecoder.valueDecoder().singleValue().readNullableInt();
            }
            buckets = m;
          }
          seen |= _$NullableIntMapModelSchema.buckets;
          break;
        default:
          keyed.skipValue();
          break;
      }
    }

    // Inlined fast-path check
    seen.validate();

    return NullableIntMapModel(buckets: buckets!);
  }

  @override
  void encode(NullableIntMapModel instance, Encoder encoder) {
    final keyed = encoder.keyed(length: 1);
    {
      final m = keyed
          .nestedEncoder(_$NullableIntMapModelSchema.nameBuckets)
          .map(length: instance.buckets.length);
      for (final entry in instance.buckets.entries) {
        m.keyEncoder().singleValue().encodeInt(entry.key);
        m.valueEncoder().singleValue().encodeNullableInt(entry.value);
      }
    }
  }
}

// =============================================================================
// 1. Unified Schema Descriptor for CompositeMapKeyModel
// =============================================================================
extension type const _$CompositeMapKeyModelSchema(int _value) {
  // String Name Constants
  static const String nameCells = 'cells';

  // Key Indices for selectKeyIndex()
  static const int keyCells = 0;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
    _$CompositeMapKeyModelSchema.nameCells,
  ]);
  static final KeyOptions keyOptions = options;

  // Bitmask Flags strictly for Required Fields
  static const _$CompositeMapKeyModelSchema none = _$CompositeMapKeyModelSchema(
    0,
  );
  static const int _cellsBit = 1 << 0;
  static const _$CompositeMapKeyModelSchema cells =
      _$CompositeMapKeyModelSchema(_cellsBit);

  // Combined Golden Bitmask for fast single-instruction check
  static const _$CompositeMapKeyModelSchema golden =
      _$CompositeMapKeyModelSchema(_cellsBit);

  @pragma('vm:prefer-inline')
  _$CompositeMapKeyModelSchema operator |(_$CompositeMapKeyModelSchema other) =>
      _$CompositeMapKeyModelSchema(_value | other._value);

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
    if ((_value & _cellsBit) == 0) {
      missing.add(nameCells);
    }
    throw CodableException(
      'Missing required fields for CompositeMapKeyModel: ${missing.join(", ")}',
    );
  }
}

// =============================================================================
// 2. Companion Codable for CompositeMapKeyModel
// =============================================================================
final class CompositeMapKeyModelCodable
    implements Codable<CompositeMapKeyModel> {
  const CompositeMapKeyModelCodable();

  @override
  CompositeMapKeyModel decode(Decoder decoder) {
    final keyed = decoder.keyed(
      options: _$CompositeMapKeyModelSchema.keyOptions,
    );

    Map<GridCell, String>? cells;
    var seen = _$CompositeMapKeyModelSchema.none;

    while (keyed.moveNextKey()) {
      switch (keyed.selectKeyIndex(_$CompositeMapKeyModelSchema.keyOptions)) {
        case _$CompositeMapKeyModelSchema.keyCells:
          if ((seen._value & _$CompositeMapKeyModelSchema.cells._value) != 0) {
            throw const CodableException('Duplicate field "cells"');
          }
          {
            final mDecoder = keyed.nestedDecoder().map();
            final m = <GridCell, String>{};
            while (mDecoder.moveNextEntry()) {
              final key = const GridCellCodable().decode(mDecoder.keyDecoder());
              m[key] = mDecoder.valueDecoder().singleValue().readString();
            }
            cells = m;
          }
          seen |= _$CompositeMapKeyModelSchema.cells;
          break;
        default:
          keyed.skipValue();
          break;
      }
    }

    // Inlined fast-path check
    seen.validate();

    return CompositeMapKeyModel(cells: cells!);
  }

  @override
  void encode(CompositeMapKeyModel instance, Encoder encoder) {
    final keyed = encoder.keyed(length: 1);
    {
      final m = keyed
          .nestedEncoder(_$CompositeMapKeyModelSchema.nameCells)
          .map(length: instance.cells.length);
      for (final entry in instance.cells.entries) {
        const GridCellCodable().encode(entry.key, m.keyEncoder());
        m.valueEncoder().singleValue().encodeString(entry.value);
      }
    }
  }
}
