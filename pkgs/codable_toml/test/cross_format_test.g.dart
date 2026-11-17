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
final class RetryPolicyCodable implements KeyedCodable<RetryPolicy> {
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
  int encodedFieldCount(RetryPolicy instance) => 2;

  @override
  void encodeFields(RetryPolicy instance, KeyedEncoder keyed) {
    keyed.encodeInt(_$RetryPolicySchema.nameMaxAttempts, instance.maxAttempts);
    keyed.encodeDouble(
      _$RetryPolicySchema.nameBackoffMultiplier,
      instance.backoffMultiplier,
    );
  }

  @override
  void encode(RetryPolicy instance, Encoder encoder) {
    encodeFields(instance, encoder.keyed(length: 2));
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
final class SubtableSpecCodable implements KeyedCodable<SubtableSpec> {
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
  int encodedFieldCount(SubtableSpec instance) => 3;

  @override
  void encodeFields(SubtableSpec instance, KeyedEncoder keyed) {
    keyed.encodeString(_$SubtableSpecSchema.nameHost, instance.host);
    keyed.encodeInt(_$SubtableSpecSchema.namePort, instance.port);
    keyed.encodeBool(_$SubtableSpecSchema.nameTls, instance.tls);
  }

  @override
  void encode(SubtableSpec instance, Encoder encoder) {
    encodeFields(instance, encoder.keyed(length: 3));
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
final class EndpointItemCodable implements KeyedCodable<EndpointItem> {
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
  int encodedFieldCount(EndpointItem instance) => 3;

  @override
  void encodeFields(EndpointItem instance, KeyedEncoder keyed) {
    keyed.encodeValue(
      _$EndpointItemSchema.nameRetry,
      instance.retry,
      const RetryPolicyCodable(),
    );
    keyed.encodeString(_$EndpointItemSchema.namePath, instance.path);
    keyed.encodeInt(_$EndpointItemSchema.nameRateLimit, instance.rateLimit);
  }

  @override
  void encode(EndpointItem instance, Encoder encoder) {
    encodeFields(instance, encoder.keyed(length: 3));
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
    implements KeyedCodable<InterleavedServiceConfig> {
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
  int encodedFieldCount(InterleavedServiceConfig instance) => 5;

  @override
  void encodeFields(InterleavedServiceConfig instance, KeyedEncoder keyed) {
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

  @override
  void encode(InterleavedServiceConfig instance, Encoder encoder) {
    encodeFields(instance, encoder.keyed(length: 5));
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
final class EmptyMarkerCodable implements KeyedCodable<EmptyMarker> {
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
  int encodedFieldCount(EmptyMarker instance) => 0;

  @override
  void encodeFields(EmptyMarker instance, KeyedEncoder keyed) {}

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
final class LevelCCodable implements KeyedCodable<LevelC> {
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
  int encodedFieldCount(LevelC instance) => 2;

  @override
  void encodeFields(LevelC instance, KeyedEncoder keyed) {
    keyed.encodeString(_$LevelCSchema.nameRegion, instance.region);
    keyed.encodeInt(_$LevelCSchema.nameReplicas, instance.replicas);
  }

  @override
  void encode(LevelC instance, Encoder encoder) {
    encodeFields(instance, encoder.keyed(length: 2));
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
final class LevelBCodable implements KeyedCodable<LevelB> {
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
  int encodedFieldCount(LevelB instance) => 1;

  @override
  void encodeFields(LevelB instance, KeyedEncoder keyed) {
    keyed.encodeValue(_$LevelBSchema.nameC, instance.c, const LevelCCodable());
  }

  @override
  void encode(LevelB instance, Encoder encoder) {
    encodeFields(instance, encoder.keyed(length: 1));
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
final class LevelACodable implements KeyedCodable<LevelA> {
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
  int encodedFieldCount(LevelA instance) => 1;

  @override
  void encodeFields(LevelA instance, KeyedEncoder keyed) {
    keyed.encodeValue(_$LevelASchema.nameB, instance.b, const LevelBCodable());
  }

  @override
  void encode(LevelA instance, Encoder encoder) {
    encodeFields(instance, encoder.keyed(length: 1));
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
final class GridCellCodable implements KeyedCodable<GridCell> {
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
  int encodedFieldCount(GridCell instance) => 3;

  @override
  void encodeFields(GridCell instance, KeyedEncoder keyed) {
    keyed.encodeInt(_$GridCellSchema.nameX, instance.x);
    keyed.encodeInt(_$GridCellSchema.nameY, instance.y);
    keyed.encodeString(_$GridCellSchema.nameTag, instance.tag);
  }

  @override
  void encode(GridCell instance, Encoder encoder) {
    encodeFields(instance, encoder.keyed(length: 3));
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
    implements KeyedCodable<StructuralHierarchyModel> {
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
  int encodedFieldCount(StructuralHierarchyModel instance) => 7;

  @override
  void encodeFields(StructuralHierarchyModel instance, KeyedEncoder keyed) {
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

  @override
  void encode(StructuralHierarchyModel instance, Encoder encoder) {
    encodeFields(instance, encoder.keyed(length: 7));
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
final class AllOptionalPatchCodable implements KeyedCodable<AllOptionalPatch> {
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
  int encodedFieldCount(AllOptionalPatch instance) {
    var count$ = 0;
    if (instance.alpha != null) count$++;
    if (instance.beta != null) count$++;
    if (instance.gamma != null) count$++;
    return count$;
  }

  @override
  void encodeFields(AllOptionalPatch instance, KeyedEncoder keyed) {
    final v$Alpha = instance.alpha;
    if (v$Alpha != null) {
      keyed.encodeInt(_$AllOptionalPatchSchema.nameAlpha, v$Alpha);
    }
    final v$Beta = instance.beta;
    if (v$Beta != null) {
      keyed.encodeString(_$AllOptionalPatchSchema.nameBeta, v$Beta);
    }
    final v$Gamma = instance.gamma;
    if (v$Gamma != null) {
      keyed.encodeBool(_$AllOptionalPatchSchema.nameGamma, v$Gamma);
    }
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
final class NullableShowcaseCodable implements KeyedCodable<NullableShowcase> {
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
  int encodedFieldCount(NullableShowcase instance) {
    var count$ = 1;
    if (instance.optInt != null) count$++;
    if (instance.optDouble != null) count$++;
    if (instance.optString != null) count$++;
    if (instance.optBool != null) count$++;
    if (instance.optStruct != null) count$++;
    if (instance.optEmpty != null) count$++;
    if (instance.optBytes != null) count$++;
    if (instance.optStringList != null) count$++;
    if (instance.optStructList != null) count$++;
    if (instance.optIntSet != null) count$++;
    if (instance.optStringMap != null) count$++;
    if (instance.optIntMap != null) count$++;
    return count$;
  }

  @override
  void encodeFields(NullableShowcase instance, KeyedEncoder keyed) {
    keyed.encodeString(_$NullableShowcaseSchema.nameId, instance.id);
    final v$OptInt = instance.optInt;
    if (v$OptInt != null) {
      keyed.encodeInt(_$NullableShowcaseSchema.nameOptInt, v$OptInt);
    }
    final v$OptDouble = instance.optDouble;
    if (v$OptDouble != null) {
      keyed.encodeDouble(_$NullableShowcaseSchema.nameOptDouble, v$OptDouble);
    }
    final v$OptString = instance.optString;
    if (v$OptString != null) {
      keyed.encodeString(_$NullableShowcaseSchema.nameOptString, v$OptString);
    }
    final v$OptBool = instance.optBool;
    if (v$OptBool != null) {
      keyed.encodeBool(_$NullableShowcaseSchema.nameOptBool, v$OptBool);
    }
    final v$OptStruct = instance.optStruct;
    if (v$OptStruct != null) {
      keyed.encodeValue(
        _$NullableShowcaseSchema.nameOptStruct,
        v$OptStruct,
        const LevelCCodable(),
      );
    }
    final v$OptEmpty = instance.optEmpty;
    if (v$OptEmpty != null) {
      keyed.encodeValue(
        _$NullableShowcaseSchema.nameOptEmpty,
        v$OptEmpty,
        const AllOptionalPatchCodable(),
      );
    }
    final v$OptBytes = instance.optBytes;
    if (v$OptBytes != null) {
      keyed.encodeBytes(_$NullableShowcaseSchema.nameOptBytes, v$OptBytes);
    }
    final v$OptStringList = instance.optStringList;
    if (v$OptStringList != null) {
      keyed.encodeStringList(
        _$NullableShowcaseSchema.nameOptStringList,
        v$OptStringList,
      );
    }
    final v$OptStructList = instance.optStructList;
    if (v$OptStructList != null) {
      keyed.encodeList(
        _$NullableShowcaseSchema.nameOptStructList,
        v$OptStructList,
        const GridCellCodable(),
      );
    }
    final v$OptIntSet = instance.optIntSet;
    if (v$OptIntSet != null) {
      keyed.encodeIntList(
        _$NullableShowcaseSchema.nameOptIntSet,
        v$OptIntSet.toList(),
      );
    }
    final v$OptStringMap = instance.optStringMap;
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
    final v$OptIntMap = instance.optIntMap;
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
    implements KeyedCodable<TypedFeaturesEnvelope> {
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
  int encodedFieldCount(TypedFeaturesEnvelope instance) {
    var count$ = 7;
    if (instance.normal != null) count$++;
    return count$;
  }

  @override
  void encodeFields(TypedFeaturesEnvelope instance, KeyedEncoder keyed) {
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
    final v$Normal = instance.normal;
    if (v$Normal != null) {
      keyed.encodeDoubleList(
        _$TypedFeaturesEnvelopeSchema.nameNormal,
        v$Normal,
      );
    }
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
final class CircleSpecCodable implements KeyedCodable<CircleSpec> {
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
  int encodedFieldCount(CircleSpec instance) {
    var count$ = 2;
    if (instance.meta != null) count$++;
    if (instance.label != null) count$++;
    return count$;
  }

  @override
  void encodeFields(CircleSpec instance, KeyedEncoder keyed) {
    final v$Meta = instance.meta;
    if (v$Meta != null) {
      keyed.encodeValue(
        _$CircleSpecSchema.nameMeta,
        v$Meta,
        const LevelCCodable(),
      );
    }
    keyed.encodeDouble(_$CircleSpecSchema.nameRadius, instance.radius);
    final v$Label = instance.label;
    if (v$Label != null) {
      keyed.encodeString(_$CircleSpecSchema.nameLabel, v$Label);
    }
    keyed.encodeString(_$CircleSpecSchema.nameKind, instance.kind);
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
final class PolygonSpecCodable implements KeyedCodable<PolygonSpec> {
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
  int encodedFieldCount(PolygonSpec instance) => 3;

  @override
  void encodeFields(PolygonSpec instance, KeyedEncoder keyed) {
    keyed.encodeIntList(_$PolygonSpecSchema.nameVertices, instance.vertices);
    keyed.encodeBool(_$PolygonSpecSchema.nameClosed, instance.closed);
    keyed.encodeString(_$PolygonSpecSchema.nameKind, instance.kind);
  }

  @override
  void encode(PolygonSpec instance, Encoder encoder) {
    encodeFields(instance, encoder.keyed(length: 3));
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
final class PolymorphicCanvasCodable
    implements KeyedCodable<PolymorphicCanvas> {
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
  int encodedFieldCount(PolymorphicCanvas instance) {
    var count$ = 2;
    if (instance.secondary != null) count$++;
    return count$;
  }

  @override
  void encodeFields(PolymorphicCanvas instance, KeyedEncoder keyed) {
    keyed.encodeValue(
      _$PolymorphicCanvasSchema.nameHero,
      instance.hero,
      const ShapeSpecCodable(),
    );
    final v$Secondary = instance.secondary;
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
    implements KeyedCodable<TimestampCollisionModel> {
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
  int encodedFieldCount(TimestampCollisionModel instance) {
    var count$ = 4;
    if (instance.expiresAt != null) count$++;
    return count$;
  }

  @override
  void encodeFields(TimestampCollisionModel instance, KeyedEncoder keyed) {
    keyed.encodeValue(
      _$TimestampCollisionModelSchema.nameTimestamp,
      instance.timestamp,
      const TomlDateTimeCodec(),
    );
    final v$ExpiresAt = instance.expiresAt;
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
    implements KeyedCodable<LocalDateTimesRecord> {
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
  int encodedFieldCount(LocalDateTimesRecord instance) {
    var count$ = 3;
    if (instance.dailyWindow != null) count$++;
    return count$;
  }

  @override
  void encodeFields(LocalDateTimesRecord instance, KeyedEncoder keyed) {
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
    final v$DailyWindow = instance.dailyWindow;
    if (v$DailyWindow != null) {
      keyed.encodeValue(
        _$LocalDateTimesRecordSchema.nameDailyWindow,
        v$DailyWindow,
        const TomlDateTimeCodable(),
      );
    }
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
    implements KeyedCodable<NullableElementListModel> {
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
  int encodedFieldCount(NullableElementListModel instance) => 1;

  @override
  void encodeFields(NullableElementListModel instance, KeyedEncoder keyed) {
    keyed.encodeList(
      _$NullableElementListModelSchema.nameValues,
      instance.values,
      Encodable.fromFunction((int? item, e) {
        e.singleValue().encodeNullableInt(item);
      }),
    );
  }

  @override
  void encode(NullableElementListModel instance, Encoder encoder) {
    encodeFields(instance, encoder.keyed(length: 1));
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
    implements KeyedCodable<NullableStringMapModel> {
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
  int encodedFieldCount(NullableStringMapModel instance) => 1;

  @override
  void encodeFields(NullableStringMapModel instance, KeyedEncoder keyed) {
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

  @override
  void encode(NullableStringMapModel instance, Encoder encoder) {
    encodeFields(instance, encoder.keyed(length: 1));
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
final class NullableIntMapModelCodable
    implements KeyedCodable<NullableIntMapModel> {
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
  int encodedFieldCount(NullableIntMapModel instance) => 1;

  @override
  void encodeFields(NullableIntMapModel instance, KeyedEncoder keyed) {
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

  @override
  void encode(NullableIntMapModel instance, Encoder encoder) {
    encodeFields(instance, encoder.keyed(length: 1));
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
    implements KeyedCodable<CompositeMapKeyModel> {
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
  int encodedFieldCount(CompositeMapKeyModel instance) => 1;

  @override
  void encodeFields(CompositeMapKeyModel instance, KeyedEncoder keyed) {
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

  @override
  void encode(CompositeMapKeyModel instance, Encoder encoder) {
    encodeFields(instance, encoder.keyed(length: 1));
  }
}

// =============================================================================
// 1. Unified Schema Descriptor for PagedEnvelope
// =============================================================================
extension type const _$PagedEnvelopeSchema(int _value) {
  // String Name Constants
  static const String namePage = 'page';
  static const String namePrimary = 'primary';
  static const String nameItems = 'items';
  static const String nameTagged = 'tagged';
  static const String nameNextPreview = 'nextPreview';

  // Key Indices for selectKeyIndex()
  static const int keyPage = 0;
  static const int keyPrimary = 1;
  static const int keyItems = 2;
  static const int keyTagged = 3;
  static const int keyNextPreview = 4;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
    _$PagedEnvelopeSchema.namePage,
    _$PagedEnvelopeSchema.namePrimary,
    _$PagedEnvelopeSchema.nameItems,
    _$PagedEnvelopeSchema.nameTagged,
    _$PagedEnvelopeSchema.nameNextPreview,
  ]);
  static final KeyOptions keyOptions = options;

  // Bitmask Flags strictly for Required Fields
  static const _$PagedEnvelopeSchema none = _$PagedEnvelopeSchema(0);
  static const int _pageBit = 1 << 0;
  static const _$PagedEnvelopeSchema page = _$PagedEnvelopeSchema(_pageBit);
  static const int _primaryBit = 1 << 1;
  static const _$PagedEnvelopeSchema primary = _$PagedEnvelopeSchema(
    _primaryBit,
  );

  // Combined Golden Bitmask for fast single-instruction check
  static const _$PagedEnvelopeSchema golden = _$PagedEnvelopeSchema(
    _pageBit | _primaryBit,
  );

  @pragma('vm:prefer-inline')
  _$PagedEnvelopeSchema operator |(_$PagedEnvelopeSchema other) =>
      _$PagedEnvelopeSchema(_value | other._value);

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
    if ((_value & _pageBit) == 0) {
      missing.add(namePage);
    }
    if ((_value & _primaryBit) == 0) {
      missing.add(namePrimary);
    }
    throw CodableException(
      'Missing required fields for PagedEnvelope: ${missing.join(", ")}',
    );
  }
}

// =============================================================================
// 2. Companion Codable for PagedEnvelope
// =============================================================================
final class PagedEnvelopeCodable<T> implements KeyedCodable<PagedEnvelope<T>> {
  final Codable<T> _$t;

  const PagedEnvelopeCodable(this._$t);

  @override
  PagedEnvelope<T> decode(Decoder decoder) {
    final keyed = decoder.keyed(options: _$PagedEnvelopeSchema.keyOptions);

    int? page;
    T? primary;
    List<T> items = const [];
    Map<String, T> tagged = const {};
    T? nextPreview;
    var seen = _$PagedEnvelopeSchema.none;

    while (keyed.moveNextKey()) {
      switch (keyed.selectKeyIndex(_$PagedEnvelopeSchema.keyOptions)) {
        case _$PagedEnvelopeSchema.keyPage:
          if ((seen._value & _$PagedEnvelopeSchema.page._value) != 0) {
            throw const CodableException('Duplicate field "page"');
          }
          page = keyed.readInt();
          seen |= _$PagedEnvelopeSchema.page;
          break;
        case _$PagedEnvelopeSchema.keyPrimary:
          if ((seen._value & _$PagedEnvelopeSchema.primary._value) != 0) {
            throw const CodableException('Duplicate field "primary"');
          }
          if (keyed.isNextNull() && null is T) {
            keyed.readNull();
            primary = null as T;
          } else {
            primary = keyed.decodeValue(_$t);
          }
          seen |= _$PagedEnvelopeSchema.primary;
          break;
        case _$PagedEnvelopeSchema.keyItems:
          {
            final u = keyed.nestedDecoder().unkeyed();
            final l = <T>[];
            while (u.moveNext()) {
              if (null is T && u.isNextNull()) {
                u.readNull();
                l.add(null as T);
              } else {
                l.add(_$t.decode(u.nestedDecoder()));
              }
            }
            items = l;
          }
          break;
        case _$PagedEnvelopeSchema.keyTagged:
          {
            final k = keyed.nestedDecoder().keyed();
            final m = <String, T>{};
            while (k.moveNextKey()) {
              final key = k.nextKey();
              if (null is T && k.isNextNull()) {
                k.readNull();
                m[key] = null as T;
              } else {
                m[key] = _$t.decode(k.nestedDecoder());
              }
            }
            tagged = m;
          }
          break;
        case _$PagedEnvelopeSchema.keyNextPreview:
          if (keyed.isNextNull()) {
            keyed.readNull();
            nextPreview = null;
          } else {
            nextPreview = keyed.decodeValue(_$t);
          }
          break;
        default:
          keyed.skipValue();
          break;
      }
    }

    if (null is T) {
      seen |= _$PagedEnvelopeSchema.primary;
    }
    // Inlined fast-path check
    seen.validate();

    return PagedEnvelope<T>(
      page: page!,
      primary: primary as T,
      items: items,
      tagged: tagged,
      nextPreview: nextPreview,
    );
  }

  @override
  int encodedFieldCount(PagedEnvelope<T> instance) {
    var count$ = 3;
    if (instance.primary != null) count$++;
    if (instance.nextPreview != null) count$++;
    return count$;
  }

  @override
  void encodeFields(PagedEnvelope<T> instance, KeyedEncoder keyed) {
    keyed.encodeInt(_$PagedEnvelopeSchema.namePage, instance.page);
    final v$Primary = instance.primary;
    if (v$Primary != null) {
      keyed.encodeValue(_$PagedEnvelopeSchema.namePrimary, v$Primary, _$t);
    }
    keyed.encodeList(
      _$PagedEnvelopeSchema.nameItems,
      instance.items,
      Encodable.fromFunction((T item, e) {
        if (item case final val0?) {
          _$t.encode(val0, e);
        } else {
          e.singleValue().encodeNull();
        }
      }),
    );
    {
      final k = keyed
          .nestedEncoder(_$PagedEnvelopeSchema.nameTagged)
          .keyed(length: instance.tagged.length);
      for (final entry in instance.tagged.entries) {
        if (entry.value case final val1?) {
          _$t.encode(val1, k.nestedEncoder(entry.key));
        } else {
          k.encodeNull(entry.key);
        }
      }
    }
    final v$NextPreview = instance.nextPreview;
    if (v$NextPreview != null) {
      keyed.encodeValue(
        _$PagedEnvelopeSchema.nameNextPreview,
        v$NextPreview,
        _$t,
      );
    }
  }

  @override
  void encode(PagedEnvelope<T> instance, Encoder encoder) {
    var count$ = 3;
    final v$Primary = instance.primary;
    if (v$Primary != null) count$++;
    final v$NextPreview = instance.nextPreview;
    if (v$NextPreview != null) count$++;
    final keyed = encoder.keyed(length: count$);
    keyed.encodeInt(_$PagedEnvelopeSchema.namePage, instance.page);
    if (v$Primary != null) {
      keyed.encodeValue(_$PagedEnvelopeSchema.namePrimary, v$Primary, _$t);
    }
    keyed.encodeList(
      _$PagedEnvelopeSchema.nameItems,
      instance.items,
      Encodable.fromFunction((T item, e) {
        if (item case final val0?) {
          _$t.encode(val0, e);
        } else {
          e.singleValue().encodeNull();
        }
      }),
    );
    {
      final k = keyed
          .nestedEncoder(_$PagedEnvelopeSchema.nameTagged)
          .keyed(length: instance.tagged.length);
      for (final entry in instance.tagged.entries) {
        if (entry.value case final val1?) {
          _$t.encode(val1, k.nestedEncoder(entry.key));
        } else {
          k.encodeNull(entry.key);
        }
      }
    }
    if (v$NextPreview != null) {
      keyed.encodeValue(
        _$PagedEnvelopeSchema.nameNextPreview,
        v$NextPreview,
        _$t,
      );
    }
  }
}

// =============================================================================
// 1. Polymorphic Schema Descriptor for PipelineStage
// =============================================================================
extension type const _$PipelineStageSchema(int _value) {
  static const String discriminatorKey = 'kind';
  static const String subtypeFetchStage = 'fetch_stage';
  static const String subtypeFilterStage = 'filter_expr';
}

// =============================================================================
// 2. Companion Codable for PipelineStage
// =============================================================================
final class PipelineStageCodable implements KeyedCodable<PipelineStage> {
  const PipelineStageCodable();

  @override
  PipelineStage decode(Decoder decoder) {
    final mapped = decoder.mapped();
    if (!mapped.containsKey(_$PipelineStageSchema.discriminatorKey) ||
        mapped.isNull(_$PipelineStageSchema.discriminatorKey)) {
      throw CodableException.missingKey(_$PipelineStageSchema.discriminatorKey);
    }
    final discriminator = mapped.readString(
      _$PipelineStageSchema.discriminatorKey,
    );
    return switch (discriminator) {
      _$PipelineStageSchema.subtypeFetchStage =>
        const FetchStageCodable().decode(decoder),
      _$PipelineStageSchema.subtypeFilterStage =>
        const FilterStageCodable().decode(decoder),
      _ => throw CodableException.unknownSubtype(
        discriminatorKey: _$PipelineStageSchema.discriminatorKey,
        subtypeValue: discriminator,
      ),
    };
  }

  @override
  int encodedFieldCount(PipelineStage instance) => switch (instance) {
    final FetchStage sub =>
      1 + const FetchStageCodable().encodedFieldCount(sub),
    final FilterStage sub =>
      1 + const FilterStageCodable().encodedFieldCount(sub),
  };

  @override
  void encodeFields(PipelineStage instance, KeyedEncoder keyed) {
    switch (instance) {
      case final FetchStage sub:
        keyed.encodeString(
          _$PipelineStageSchema.discriminatorKey,
          _$PipelineStageSchema.subtypeFetchStage,
        );
        const FetchStageCodable().encodeFields(sub, keyed);
      case final FilterStage sub:
        keyed.encodeString(
          _$PipelineStageSchema.discriminatorKey,
          _$PipelineStageSchema.subtypeFilterStage,
        );
        const FilterStageCodable().encodeFields(sub, keyed);
    }
  }

  @override
  void encode(PipelineStage instance, Encoder encoder) {
    switch (instance) {
      case final FetchStage sub:
        final keyed = encoder.keyed(
          length: 1 + const FetchStageCodable().encodedFieldCount(sub),
        );
        keyed.encodeString(
          _$PipelineStageSchema.discriminatorKey,
          _$PipelineStageSchema.subtypeFetchStage,
        );
        const FetchStageCodable().encodeFields(sub, keyed);
      case final FilterStage sub:
        final keyed = encoder.keyed(
          length: 1 + const FilterStageCodable().encodedFieldCount(sub),
        );
        keyed.encodeString(
          _$PipelineStageSchema.discriminatorKey,
          _$PipelineStageSchema.subtypeFilterStage,
        );
        const FilterStageCodable().encodeFields(sub, keyed);
    }
  }
}

// =============================================================================
// 1. Unified Schema Descriptor for FetchStage
// =============================================================================
extension type const _$FetchStageSchema(int _value) {
  // String Name Constants
  static const String nameSource = 'source';
  static const String nameTimeoutMs = 'timeoutMs';
  static const String nameAuthHeader = 'authHeader';

  // Key Indices for selectKeyIndex()
  static const int keySource = 0;
  static const int keyTimeoutMs = 1;
  static const int keyAuthHeader = 2;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
    _$FetchStageSchema.nameSource,
    _$FetchStageSchema.nameTimeoutMs,
    _$FetchStageSchema.nameAuthHeader,
  ]);
  static final KeyOptions keyOptions = options;

  // Bitmask Flags strictly for Required Fields
  static const _$FetchStageSchema none = _$FetchStageSchema(0);
  static const int _sourceBit = 1 << 0;
  static const _$FetchStageSchema source = _$FetchStageSchema(_sourceBit);
  static const int _timeoutMsBit = 1 << 1;
  static const _$FetchStageSchema timeoutMs = _$FetchStageSchema(_timeoutMsBit);

  // Combined Golden Bitmask for fast single-instruction check
  static const _$FetchStageSchema golden = _$FetchStageSchema(
    _sourceBit | _timeoutMsBit,
  );

  @pragma('vm:prefer-inline')
  _$FetchStageSchema operator |(_$FetchStageSchema other) =>
      _$FetchStageSchema(_value | other._value);

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
    if ((_value & _sourceBit) == 0) {
      missing.add(nameSource);
    }
    if ((_value & _timeoutMsBit) == 0) {
      missing.add(nameTimeoutMs);
    }
    throw CodableException(
      'Missing required fields for FetchStage: ${missing.join(", ")}',
    );
  }
}

// =============================================================================
// 2. Companion Codable for FetchStage
// =============================================================================
final class FetchStageCodable implements KeyedCodable<FetchStage> {
  const FetchStageCodable();

  @override
  FetchStage decode(Decoder decoder) {
    final keyed = decoder.keyed(options: _$FetchStageSchema.keyOptions);

    LevelC? source;
    int? timeoutMs;
    String? authHeader;
    var seen = _$FetchStageSchema.none;

    while (keyed.moveNextKey()) {
      switch (keyed.selectKeyIndex(_$FetchStageSchema.keyOptions)) {
        case _$FetchStageSchema.keySource:
          if ((seen._value & _$FetchStageSchema.source._value) != 0) {
            throw const CodableException('Duplicate field "source"');
          }
          source = const LevelCCodable().decode(keyed.nestedDecoder());
          seen |= _$FetchStageSchema.source;
          break;
        case _$FetchStageSchema.keyTimeoutMs:
          if ((seen._value & _$FetchStageSchema.timeoutMs._value) != 0) {
            throw const CodableException('Duplicate field "timeoutMs"');
          }
          timeoutMs = keyed.readInt();
          seen |= _$FetchStageSchema.timeoutMs;
          break;
        case _$FetchStageSchema.keyAuthHeader:
          if (keyed.isNextNull()) {
            keyed.readNull();
            authHeader = null;
          } else {
            authHeader = keyed.readString();
          }
          break;
        default:
          keyed.skipValue();
          break;
      }
    }

    // Inlined fast-path check
    seen.validate();

    return FetchStage(
      source: source!,
      timeoutMs: timeoutMs!,
      authHeader: authHeader,
    );
  }

  @override
  int encodedFieldCount(FetchStage instance) {
    var count$ = 2;
    if (instance.authHeader != null) count$++;
    return count$;
  }

  @override
  void encodeFields(FetchStage instance, KeyedEncoder keyed) {
    keyed.encodeValue(
      _$FetchStageSchema.nameSource,
      instance.source,
      const LevelCCodable(),
    );
    keyed.encodeInt(_$FetchStageSchema.nameTimeoutMs, instance.timeoutMs);
    final v$AuthHeader = instance.authHeader;
    if (v$AuthHeader != null) {
      keyed.encodeString(_$FetchStageSchema.nameAuthHeader, v$AuthHeader);
    }
  }

  @override
  void encode(FetchStage instance, Encoder encoder) {
    var count$ = 2;
    final v$AuthHeader = instance.authHeader;
    if (v$AuthHeader != null) count$++;
    final keyed = encoder.keyed(length: count$);
    keyed.encodeValue(
      _$FetchStageSchema.nameSource,
      instance.source,
      const LevelCCodable(),
    );
    keyed.encodeInt(_$FetchStageSchema.nameTimeoutMs, instance.timeoutMs);
    if (v$AuthHeader != null) {
      keyed.encodeString(_$FetchStageSchema.nameAuthHeader, v$AuthHeader);
    }
  }
}

// =============================================================================
// 1. Unified Schema Descriptor for FilterStage
// =============================================================================
extension type const _$FilterStageSchema(int _value) {
  // String Name Constants
  static const String namePredicates = 'predicates';
  static const String nameDropEmpty = 'dropEmpty';

  // Key Indices for selectKeyIndex()
  static const int keyPredicates = 0;
  static const int keyDropEmpty = 1;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
    _$FilterStageSchema.namePredicates,
    _$FilterStageSchema.nameDropEmpty,
  ]);
  static final KeyOptions keyOptions = options;

  // Bitmask Flags strictly for Required Fields
  static const _$FilterStageSchema none = _$FilterStageSchema(0);
  static const int _predicatesBit = 1 << 0;
  static const _$FilterStageSchema predicates = _$FilterStageSchema(
    _predicatesBit,
  );

  // Combined Golden Bitmask for fast single-instruction check
  static const _$FilterStageSchema golden = _$FilterStageSchema(_predicatesBit);

  @pragma('vm:prefer-inline')
  _$FilterStageSchema operator |(_$FilterStageSchema other) =>
      _$FilterStageSchema(_value | other._value);

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
    if ((_value & _predicatesBit) == 0) {
      missing.add(namePredicates);
    }
    throw CodableException(
      'Missing required fields for FilterStage: ${missing.join(", ")}',
    );
  }
}

// =============================================================================
// 2. Companion Codable for FilterStage
// =============================================================================
final class FilterStageCodable implements KeyedCodable<FilterStage> {
  const FilterStageCodable();

  @override
  FilterStage decode(Decoder decoder) {
    final keyed = decoder.keyed(options: _$FilterStageSchema.keyOptions);

    List<String>? predicates;
    bool dropEmpty = false;
    var seen = _$FilterStageSchema.none;

    while (keyed.moveNextKey()) {
      switch (keyed.selectKeyIndex(_$FilterStageSchema.keyOptions)) {
        case _$FilterStageSchema.keyPredicates:
          if ((seen._value & _$FilterStageSchema.predicates._value) != 0) {
            throw const CodableException('Duplicate field "predicates"');
          }
          predicates = keyed.decodeStringList();
          seen |= _$FilterStageSchema.predicates;
          break;
        case _$FilterStageSchema.keyDropEmpty:
          dropEmpty = keyed.readBool();
          break;
        default:
          keyed.skipValue();
          break;
      }
    }

    // Inlined fast-path check
    seen.validate();

    return FilterStage(predicates: predicates!, dropEmpty: dropEmpty);
  }

  @override
  int encodedFieldCount(FilterStage instance) => 2;

  @override
  void encodeFields(FilterStage instance, KeyedEncoder keyed) {
    keyed.encodeStringList(
      _$FilterStageSchema.namePredicates,
      instance.predicates,
    );
    keyed.encodeBool(_$FilterStageSchema.nameDropEmpty, instance.dropEmpty);
  }

  @override
  void encode(FilterStage instance, Encoder encoder) {
    encodeFields(instance, encoder.keyed(length: 2));
  }
}

// =============================================================================
// 1. Polymorphic Schema Descriptor for StageResult
// =============================================================================
extension type const _$StageResultSchema(int _value) {
  static const String discriminatorKey = 'outcome';
  static const String subtypeStageOk = 'ok';
  static const String subtypeStageFailed = 'failed';
}

// =============================================================================
// 2. Companion Codable for StageResult
// =============================================================================
final class StageResultCodable<T> implements KeyedCodable<StageResult<T>> {
  final Codable<T> _$t;

  const StageResultCodable(this._$t);

  @override
  StageResult<T> decode(Decoder decoder) {
    final mapped = decoder.mapped();
    if (!mapped.containsKey(_$StageResultSchema.discriminatorKey) ||
        mapped.isNull(_$StageResultSchema.discriminatorKey)) {
      throw CodableException.missingKey(_$StageResultSchema.discriminatorKey);
    }
    final discriminator = mapped.readString(
      _$StageResultSchema.discriminatorKey,
    );
    return switch (discriminator) {
      _$StageResultSchema.subtypeStageOk => StageOkCodable<T>(
        _$t,
      ).decode(decoder),
      _$StageResultSchema.subtypeStageFailed =>
        const StageFailedCodable().decode(decoder),
      _ => throw CodableException.unknownSubtype(
        discriminatorKey: _$StageResultSchema.discriminatorKey,
        subtypeValue: discriminator,
      ),
    };
  }

  @override
  int encodedFieldCount(StageResult<T> instance) => switch (instance) {
    final StageOk<T> sub => 1 + StageOkCodable<T>(_$t).encodedFieldCount(sub),
    final StageFailed sub =>
      1 + const StageFailedCodable().encodedFieldCount(sub),
  };

  @override
  void encodeFields(StageResult<T> instance, KeyedEncoder keyed) {
    switch (instance) {
      case final StageOk<T> sub:
        keyed.encodeString(
          _$StageResultSchema.discriminatorKey,
          _$StageResultSchema.subtypeStageOk,
        );
        StageOkCodable<T>(_$t).encodeFields(sub, keyed);
      case final StageFailed sub:
        keyed.encodeString(
          _$StageResultSchema.discriminatorKey,
          _$StageResultSchema.subtypeStageFailed,
        );
        const StageFailedCodable().encodeFields(sub, keyed);
    }
  }

  @override
  void encode(StageResult<T> instance, Encoder encoder) {
    switch (instance) {
      case final StageOk<T> sub:
        final subCodec = StageOkCodable<T>(_$t);
        final keyed = encoder.keyed(
          length: 1 + subCodec.encodedFieldCount(sub),
        );
        keyed.encodeString(
          _$StageResultSchema.discriminatorKey,
          _$StageResultSchema.subtypeStageOk,
        );
        subCodec.encodeFields(sub, keyed);
      case final StageFailed sub:
        final keyed = encoder.keyed(
          length: 1 + const StageFailedCodable().encodedFieldCount(sub),
        );
        keyed.encodeString(
          _$StageResultSchema.discriminatorKey,
          _$StageResultSchema.subtypeStageFailed,
        );
        const StageFailedCodable().encodeFields(sub, keyed);
    }
  }
}

// =============================================================================
// 1. Unified Schema Descriptor for StageOk
// =============================================================================
extension type const _$StageOkSchema(int _value) {
  // String Name Constants
  static const String nameData = 'data';
  static const String nameElapsedMs = 'elapsedMs';

  // Key Indices for selectKeyIndex()
  static const int keyData = 0;
  static const int keyElapsedMs = 1;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
    _$StageOkSchema.nameData,
    _$StageOkSchema.nameElapsedMs,
  ]);
  static final KeyOptions keyOptions = options;

  // Bitmask Flags strictly for Required Fields
  static const _$StageOkSchema none = _$StageOkSchema(0);
  static const int _dataBit = 1 << 0;
  static const _$StageOkSchema data = _$StageOkSchema(_dataBit);
  static const int _elapsedMsBit = 1 << 1;
  static const _$StageOkSchema elapsedMs = _$StageOkSchema(_elapsedMsBit);

  // Combined Golden Bitmask for fast single-instruction check
  static const _$StageOkSchema golden = _$StageOkSchema(
    _dataBit | _elapsedMsBit,
  );

  @pragma('vm:prefer-inline')
  _$StageOkSchema operator |(_$StageOkSchema other) =>
      _$StageOkSchema(_value | other._value);

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
    if ((_value & _dataBit) == 0) {
      missing.add(nameData);
    }
    if ((_value & _elapsedMsBit) == 0) {
      missing.add(nameElapsedMs);
    }
    throw CodableException(
      'Missing required fields for StageOk: ${missing.join(", ")}',
    );
  }
}

// =============================================================================
// 2. Companion Codable for StageOk
// =============================================================================
final class StageOkCodable<T> implements KeyedCodable<StageOk<T>> {
  final Codable<T> _$t;

  const StageOkCodable(this._$t);

  @override
  StageOk<T> decode(Decoder decoder) {
    final keyed = decoder.keyed(options: _$StageOkSchema.keyOptions);

    T? data;
    int? elapsedMs;
    var seen = _$StageOkSchema.none;

    while (keyed.moveNextKey()) {
      switch (keyed.selectKeyIndex(_$StageOkSchema.keyOptions)) {
        case _$StageOkSchema.keyData:
          if ((seen._value & _$StageOkSchema.data._value) != 0) {
            throw const CodableException('Duplicate field "data"');
          }
          if (keyed.isNextNull() && null is T) {
            keyed.readNull();
            data = null as T;
          } else {
            data = keyed.decodeValue(_$t);
          }
          seen |= _$StageOkSchema.data;
          break;
        case _$StageOkSchema.keyElapsedMs:
          if ((seen._value & _$StageOkSchema.elapsedMs._value) != 0) {
            throw const CodableException('Duplicate field "elapsedMs"');
          }
          elapsedMs = keyed.readInt();
          seen |= _$StageOkSchema.elapsedMs;
          break;
        default:
          keyed.skipValue();
          break;
      }
    }

    if (null is T) {
      seen |= _$StageOkSchema.data;
    }
    // Inlined fast-path check
    seen.validate();

    return StageOk<T>(data: data as T, elapsedMs: elapsedMs!);
  }

  @override
  int encodedFieldCount(StageOk<T> instance) {
    var count$ = 1;
    if (instance.data != null) count$++;
    return count$;
  }

  @override
  void encodeFields(StageOk<T> instance, KeyedEncoder keyed) {
    final v$Data = instance.data;
    if (v$Data != null) {
      keyed.encodeValue(_$StageOkSchema.nameData, v$Data, _$t);
    }
    keyed.encodeInt(_$StageOkSchema.nameElapsedMs, instance.elapsedMs);
  }

  @override
  void encode(StageOk<T> instance, Encoder encoder) {
    var count$ = 1;
    final v$Data = instance.data;
    if (v$Data != null) count$++;
    final keyed = encoder.keyed(length: count$);
    if (v$Data != null) {
      keyed.encodeValue(_$StageOkSchema.nameData, v$Data, _$t);
    }
    keyed.encodeInt(_$StageOkSchema.nameElapsedMs, instance.elapsedMs);
  }
}

// =============================================================================
// 1. Unified Schema Descriptor for StageFailed
// =============================================================================
extension type const _$StageFailedSchema(int _value) {
  // String Name Constants
  static const String nameErrorCode = 'errorCode';

  // Key Indices for selectKeyIndex()
  static const int keyErrorCode = 0;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
    _$StageFailedSchema.nameErrorCode,
  ]);
  static final KeyOptions keyOptions = options;

  // Bitmask Flags strictly for Required Fields
  static const _$StageFailedSchema none = _$StageFailedSchema(0);
  static const int _errorCodeBit = 1 << 0;
  static const _$StageFailedSchema errorCode = _$StageFailedSchema(
    _errorCodeBit,
  );

  // Combined Golden Bitmask for fast single-instruction check
  static const _$StageFailedSchema golden = _$StageFailedSchema(_errorCodeBit);

  @pragma('vm:prefer-inline')
  _$StageFailedSchema operator |(_$StageFailedSchema other) =>
      _$StageFailedSchema(_value | other._value);

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
    if ((_value & _errorCodeBit) == 0) {
      missing.add(nameErrorCode);
    }
    throw CodableException(
      'Missing required fields for StageFailed: ${missing.join(", ")}',
    );
  }
}

// =============================================================================
// 2. Companion Codable for StageFailed
// =============================================================================
final class StageFailedCodable implements KeyedCodable<StageFailed> {
  const StageFailedCodable();

  @override
  StageFailed decode(Decoder decoder) {
    final keyed = decoder.keyed(options: _$StageFailedSchema.keyOptions);

    String? errorCode;
    var seen = _$StageFailedSchema.none;

    while (keyed.moveNextKey()) {
      switch (keyed.selectKeyIndex(_$StageFailedSchema.keyOptions)) {
        case _$StageFailedSchema.keyErrorCode:
          if ((seen._value & _$StageFailedSchema.errorCode._value) != 0) {
            throw const CodableException('Duplicate field "errorCode"');
          }
          errorCode = keyed.readString();
          seen |= _$StageFailedSchema.errorCode;
          break;
        default:
          keyed.skipValue();
          break;
      }
    }

    // Inlined fast-path check
    seen.validate();

    return StageFailed(errorCode: errorCode!);
  }

  @override
  int encodedFieldCount(StageFailed instance) => 1;

  @override
  void encodeFields(StageFailed instance, KeyedEncoder keyed) {
    keyed.encodeString(_$StageFailedSchema.nameErrorCode, instance.errorCode);
  }

  @override
  void encode(StageFailed instance, Encoder encoder) {
    encodeFields(instance, encoder.keyed(length: 1));
  }
}

// =============================================================================
// 1. Unified Schema Descriptor for PipelineManifest
// =============================================================================
extension type const _$PipelineManifestSchema(int _value) {
  // String Name Constants
  static const String nameTargets = 'targets';
  static const String nameEntryStage = 'entryStage';
  static const String nameFallbackStage = 'fallbackStage';
  static const String nameStages = 'stages';
  static const String nameStageById = 'stageById';
  static const String nameLastRun = 'lastRun';
  static const String nameRetryStatus = 'retryStatus';

  // Key Indices for selectKeyIndex()
  static const int keyTargets = 0;
  static const int keyEntryStage = 1;
  static const int keyFallbackStage = 2;
  static const int keyStages = 3;
  static const int keyStageById = 4;
  static const int keyLastRun = 5;
  static const int keyRetryStatus = 6;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
    _$PipelineManifestSchema.nameTargets,
    _$PipelineManifestSchema.nameEntryStage,
    _$PipelineManifestSchema.nameFallbackStage,
    _$PipelineManifestSchema.nameStages,
    _$PipelineManifestSchema.nameStageById,
    _$PipelineManifestSchema.nameLastRun,
    _$PipelineManifestSchema.nameRetryStatus,
  ]);
  static final KeyOptions keyOptions = options;

  // Bitmask Flags strictly for Required Fields
  static const _$PipelineManifestSchema none = _$PipelineManifestSchema(0);
  static const int _targetsBit = 1 << 0;
  static const _$PipelineManifestSchema targets = _$PipelineManifestSchema(
    _targetsBit,
  );
  static const int _entryStageBit = 1 << 1;
  static const _$PipelineManifestSchema entryStage = _$PipelineManifestSchema(
    _entryStageBit,
  );
  static const int _lastRunBit = 1 << 2;
  static const _$PipelineManifestSchema lastRun = _$PipelineManifestSchema(
    _lastRunBit,
  );
  static const int _retryStatusBit = 1 << 3;
  static const _$PipelineManifestSchema retryStatus = _$PipelineManifestSchema(
    _retryStatusBit,
  );

  // Combined Golden Bitmask for fast single-instruction check
  static const _$PipelineManifestSchema golden = _$PipelineManifestSchema(
    _targetsBit | _entryStageBit | _lastRunBit | _retryStatusBit,
  );

  @pragma('vm:prefer-inline')
  _$PipelineManifestSchema operator |(_$PipelineManifestSchema other) =>
      _$PipelineManifestSchema(_value | other._value);

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
    if ((_value & _targetsBit) == 0) {
      missing.add(nameTargets);
    }
    if ((_value & _entryStageBit) == 0) {
      missing.add(nameEntryStage);
    }
    if ((_value & _lastRunBit) == 0) {
      missing.add(nameLastRun);
    }
    if ((_value & _retryStatusBit) == 0) {
      missing.add(nameRetryStatus);
    }
    throw CodableException(
      'Missing required fields for PipelineManifest: ${missing.join(", ")}',
    );
  }

  // Cached Closed Codecs
  static final StageResultCodable<int> codec0 = StageResultCodable<int>(
    Codable<int>.fromFunctions(
      decode: (d) {
        final res = d.singleValue().readInt();
        return res;
      },
      encode: (int v, e) {
        e.singleValue().encodeInt(v);
      },
    ),
  );
}

// =============================================================================
// 2. Companion Codable for PipelineManifest
// =============================================================================
final class PipelineManifestCodable implements KeyedCodable<PipelineManifest> {
  const PipelineManifestCodable();

  @override
  PipelineManifest decode(Decoder decoder) {
    final keyed = decoder.keyed(options: _$PipelineManifestSchema.keyOptions);

    PagedEnvelope<LevelC>? targets;
    PipelineStage? entryStage;
    PipelineStage? fallbackStage;
    List<PipelineStage> stages = const [];
    Map<String, PipelineStage> stageById = const {};
    StageResult<GridCell>? lastRun;
    StageResult<int>? retryStatus;
    var seen = _$PipelineManifestSchema.none;

    while (keyed.moveNextKey()) {
      switch (keyed.selectKeyIndex(_$PipelineManifestSchema.keyOptions)) {
        case _$PipelineManifestSchema.keyTargets:
          if ((seen._value & _$PipelineManifestSchema.targets._value) != 0) {
            throw const CodableException('Duplicate field "targets"');
          }
          targets = const PagedEnvelopeCodable<LevelC>(LevelCCodable())
              .decode(keyed.nestedDecoder());
          seen |= _$PipelineManifestSchema.targets;
          break;
        case _$PipelineManifestSchema.keyEntryStage:
          if ((seen._value & _$PipelineManifestSchema.entryStage._value) != 0) {
            throw const CodableException('Duplicate field "entryStage"');
          }
          entryStage = const PipelineStageCodable().decode(
            keyed.nestedDecoder(),
          );
          seen |= _$PipelineManifestSchema.entryStage;
          break;
        case _$PipelineManifestSchema.keyFallbackStage:
          if (keyed.isNextNull()) {
            keyed.readNull();
            fallbackStage = null;
          } else {
            fallbackStage = const PipelineStageCodable().decode(
              keyed.nestedDecoder(),
            );
          }
          break;
        case _$PipelineManifestSchema.keyStages:
          stages = const PipelineStageCodable().decodeList(
            keyed.nestedDecoder(),
          );
          break;
        case _$PipelineManifestSchema.keyStageById:
          {
            final k = keyed.nestedDecoder().keyed();
            final m = <String, PipelineStage>{};
            while (k.moveNextKey()) {
              final key = k.nextKey();
              m[key] = const PipelineStageCodable().decode(k.nestedDecoder());
            }
            stageById = m;
          }
          break;
        case _$PipelineManifestSchema.keyLastRun:
          if ((seen._value & _$PipelineManifestSchema.lastRun._value) != 0) {
            throw const CodableException('Duplicate field "lastRun"');
          }
          lastRun = const StageResultCodable<GridCell>(GridCellCodable())
              .decode(keyed.nestedDecoder());
          seen |= _$PipelineManifestSchema.lastRun;
          break;
        case _$PipelineManifestSchema.keyRetryStatus:
          if ((seen._value & _$PipelineManifestSchema.retryStatus._value) !=
              0) {
            throw const CodableException('Duplicate field "retryStatus"');
          }
          retryStatus = _$PipelineManifestSchema.codec0.decode(
            keyed.nestedDecoder(),
          );
          seen |= _$PipelineManifestSchema.retryStatus;
          break;
        default:
          keyed.skipValue();
          break;
      }
    }

    // Inlined fast-path check
    seen.validate();

    return PipelineManifest(
      targets: targets!,
      entryStage: entryStage!,
      fallbackStage: fallbackStage,
      stages: stages,
      stageById: stageById,
      lastRun: lastRun!,
      retryStatus: retryStatus!,
    );
  }

  @override
  int encodedFieldCount(PipelineManifest instance) {
    var count$ = 6;
    if (instance.fallbackStage != null) count$++;
    return count$;
  }

  @override
  void encodeFields(PipelineManifest instance, KeyedEncoder keyed) {
    keyed.encodeValue(
      _$PipelineManifestSchema.nameTargets,
      instance.targets,
      const PagedEnvelopeCodable<LevelC>(LevelCCodable()),
    );
    keyed.encodeValue(
      _$PipelineManifestSchema.nameEntryStage,
      instance.entryStage,
      const PipelineStageCodable(),
    );
    final v$FallbackStage = instance.fallbackStage;
    if (v$FallbackStage != null) {
      keyed.encodeValue(
        _$PipelineManifestSchema.nameFallbackStage,
        v$FallbackStage,
        const PipelineStageCodable(),
      );
    }
    keyed.encodeList(
      _$PipelineManifestSchema.nameStages,
      instance.stages,
      const PipelineStageCodable(),
    );
    {
      final k = keyed
          .nestedEncoder(_$PipelineManifestSchema.nameStageById)
          .keyed(length: instance.stageById.length);
      for (final entry in instance.stageById.entries) {
        const PipelineStageCodable().encode(
          entry.value,
          k.nestedEncoder(entry.key),
        );
      }
    }
    keyed.encodeValue(
      _$PipelineManifestSchema.nameLastRun,
      instance.lastRun,
      const StageResultCodable<GridCell>(GridCellCodable()),
    );
    keyed.encodeValue(
      _$PipelineManifestSchema.nameRetryStatus,
      instance.retryStatus,
      _$PipelineManifestSchema.codec0,
    );
  }

  @override
  void encode(PipelineManifest instance, Encoder encoder) {
    var count$ = 6;
    final v$FallbackStage = instance.fallbackStage;
    if (v$FallbackStage != null) count$++;
    final keyed = encoder.keyed(length: count$);
    keyed.encodeValue(
      _$PipelineManifestSchema.nameTargets,
      instance.targets,
      const PagedEnvelopeCodable<LevelC>(LevelCCodable()),
    );
    keyed.encodeValue(
      _$PipelineManifestSchema.nameEntryStage,
      instance.entryStage,
      const PipelineStageCodable(),
    );
    if (v$FallbackStage != null) {
      keyed.encodeValue(
        _$PipelineManifestSchema.nameFallbackStage,
        v$FallbackStage,
        const PipelineStageCodable(),
      );
    }
    keyed.encodeList(
      _$PipelineManifestSchema.nameStages,
      instance.stages,
      const PipelineStageCodable(),
    );
    {
      final k = keyed
          .nestedEncoder(_$PipelineManifestSchema.nameStageById)
          .keyed(length: instance.stageById.length);
      for (final entry in instance.stageById.entries) {
        const PipelineStageCodable().encode(
          entry.value,
          k.nestedEncoder(entry.key),
        );
      }
    }
    keyed.encodeValue(
      _$PipelineManifestSchema.nameLastRun,
      instance.lastRun,
      const StageResultCodable<GridCell>(GridCellCodable()),
    );
    keyed.encodeValue(
      _$PipelineManifestSchema.nameRetryStatus,
      instance.retryStatus,
      _$PipelineManifestSchema.codec0,
    );
  }
}
