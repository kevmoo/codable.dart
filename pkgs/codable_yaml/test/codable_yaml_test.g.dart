// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: lines_longer_than_80_chars, unnecessary_lambdas, deprecated_member_use, unused_element

part of 'codable_yaml_test.dart';

// **************************************************************************
// CodableGenerator
// **************************************************************************

// =============================================================================
// 1. Unified Schema Descriptor for GridCoord
// =============================================================================
extension type const _$GridCoordSchema(int _value) {
  // String Name Constants
  static const String nameRow = 'row';
  static const String nameCol = 'col';

  // Key Indices for selectKeyIndex()
  static const int keyRow = 0;
  static const int keyCol = 1;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
    _$GridCoordSchema.nameRow,
    _$GridCoordSchema.nameCol,
  ]);
  static final KeyOptions keyOptions = options;

  // Bitmask Flags strictly for Required Fields
  static const _$GridCoordSchema none = _$GridCoordSchema(0);
  static const int _rowBit = 1 << 0;
  static const _$GridCoordSchema row = _$GridCoordSchema(_rowBit);
  static const int _colBit = 1 << 1;
  static const _$GridCoordSchema col = _$GridCoordSchema(_colBit);

  // Combined Golden Bitmask for fast single-instruction check
  static const _$GridCoordSchema golden = _$GridCoordSchema(_rowBit | _colBit);

  @pragma('vm:prefer-inline')
  _$GridCoordSchema operator |(_$GridCoordSchema other) =>
      _$GridCoordSchema(_value | other._value);

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
    if ((_value & _rowBit) == 0) {
      missing.add(nameRow);
    }
    if ((_value & _colBit) == 0) {
      missing.add(nameCol);
    }
    throw CodableException(
      'Missing required fields for GridCoord: ${missing.join(", ")}',
    );
  }
}

// =============================================================================
// 2. Companion Codable for GridCoord
// =============================================================================
final class GridCoordCodable implements Codable<GridCoord> {
  const GridCoordCodable();

  @override
  GridCoord decode(Decoder decoder) {
    final keyed = decoder.keyed(options: _$GridCoordSchema.keyOptions);

    int? row;
    int? col;
    var seen = _$GridCoordSchema.none;

    while (keyed.moveNextKey()) {
      switch (keyed.selectKeyIndex(_$GridCoordSchema.keyOptions)) {
        case _$GridCoordSchema.keyRow:
          if ((seen._value & _$GridCoordSchema.row._value) != 0) {
            throw const CodableException('Duplicate field "row"');
          }
          row = keyed.readInt();
          seen |= _$GridCoordSchema.row;
          break;
        case _$GridCoordSchema.keyCol:
          if ((seen._value & _$GridCoordSchema.col._value) != 0) {
            throw const CodableException('Duplicate field "col"');
          }
          col = keyed.readInt();
          seen |= _$GridCoordSchema.col;
          break;
        default:
          keyed.skipValue();
          break;
      }
    }

    // Inlined fast-path check
    seen.validate();

    return GridCoord(row!, col!);
  }

  @override
  void encode(GridCoord instance, Encoder encoder) {
    final keyed = encoder.keyed(length: 2);
    keyed.encodeInt(_$GridCoordSchema.nameRow, instance.row);
    keyed.encodeInt(_$GridCoordSchema.nameCol, instance.col);
  }
}

// =============================================================================
// 1. Unified Schema Descriptor for ServiceSpec
// =============================================================================
extension type const _$ServiceSpecSchema(int _value) {
  // String Name Constants
  static const String nameServiceName = 'service_name';
  static const String aliasServiceNameName = 'name';
  static const String nameLogLevel = 'log_level';
  static const String nameMaxRetries = 'max_retries';
  static const String nameSampleRate = 'sample_rate';
  static const String nameTlsCertDer = 'tls_cert_der';
  static const String nameBounds = 'bounds';
  static const String nameTags = 'tags';
  static const String nameFeatureQuotas = 'feature_quotas';
  static const String nameHttpCodes = 'http_codes';
  static const String nameAlertByLevel = 'alert_by_level';
  static const String nameZoneLabels = 'zone_labels';

  // Key Indices for selectKeyIndex()
  static const int keyServiceName = 0;
  static const int aliasKeyServiceNameName = 1;
  static const int keyLogLevel = 2;
  static const int keyMaxRetries = 3;
  static const int keySampleRate = 4;
  static const int keyTlsCertDer = 5;
  static const int keyBounds = 6;
  static const int keyTags = 7;
  static const int keyFeatureQuotas = 8;
  static const int keyHttpCodes = 9;
  static const int keyAlertByLevel = 10;
  static const int keyZoneLabels = 11;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
    _$ServiceSpecSchema.nameServiceName,
    _$ServiceSpecSchema.aliasServiceNameName,
    _$ServiceSpecSchema.nameLogLevel,
    _$ServiceSpecSchema.nameMaxRetries,
    _$ServiceSpecSchema.nameSampleRate,
    _$ServiceSpecSchema.nameTlsCertDer,
    _$ServiceSpecSchema.nameBounds,
    _$ServiceSpecSchema.nameTags,
    _$ServiceSpecSchema.nameFeatureQuotas,
    _$ServiceSpecSchema.nameHttpCodes,
    _$ServiceSpecSchema.nameAlertByLevel,
    _$ServiceSpecSchema.nameZoneLabels,
  ]);
  static final KeyOptions keyOptions = options;

  // Enum Options for logLevel
  static final KeyOptions logLevelEnumOptions = KeyOptions.of(const [
    'debug',
    'info',
    'warn',
    'error',
  ]);
  static final KeyOptions logLevelKeyOptions = logLevelEnumOptions;

  // Enum Options for LogLevel
  static final KeyOptions enumLogLevelKeyOptions = KeyOptions.of(const [
    'debug',
    'info',
    'warn',
    'error',
  ]);

  // Bitmask Flags strictly for Required Fields
  static const _$ServiceSpecSchema none = _$ServiceSpecSchema(0);
  static const int _serviceNameBit = 1 << 0;
  static const _$ServiceSpecSchema serviceName = _$ServiceSpecSchema(
    _serviceNameBit,
  );

  // Combined Golden Bitmask for fast single-instruction check
  static const _$ServiceSpecSchema golden = _$ServiceSpecSchema(
    _serviceNameBit,
  );

  @pragma('vm:prefer-inline')
  _$ServiceSpecSchema operator |(_$ServiceSpecSchema other) =>
      _$ServiceSpecSchema(_value | other._value);

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
    if ((_value & _serviceNameBit) == 0) {
      missing.add(nameServiceName);
    }
    throw CodableException(
      'Missing required fields for ServiceSpec: ${missing.join(", ")}',
    );
  }
}

// =============================================================================
// 2. Companion Codable for ServiceSpec
// =============================================================================
final class ServiceSpecCodable implements Codable<ServiceSpec> {
  const ServiceSpecCodable();

  @override
  ServiceSpec decode(Decoder decoder) {
    final keyed = decoder.keyed(options: _$ServiceSpecSchema.keyOptions);

    String? serviceName;
    var logLevel = LogLevel.info;
    var maxRetries = 3;
    double? sampleRate;
    Uint8List? tlsCertDer;
    Float64List? bounds;
    var tags = const <String>[];
    var featureQuotas = const <String, int?>{};
    var httpCodes = const <int, String>{};
    var alertByLevel = const <LogLevel, bool>{};
    var zoneLabels = const <GridCoord, String>{};
    var seen = _$ServiceSpecSchema.none;

    while (keyed.moveNextKey()) {
      switch (keyed.selectKeyIndex(_$ServiceSpecSchema.keyOptions)) {
        case _$ServiceSpecSchema.keyServiceName:
        case _$ServiceSpecSchema.aliasKeyServiceNameName:
          if ((seen._value & _$ServiceSpecSchema.serviceName._value) != 0) {
            throw const CodableException('Duplicate field "service_name"');
          }
          serviceName = keyed.readString();
          seen |= _$ServiceSpecSchema.serviceName;
          break;
        case _$ServiceSpecSchema.keyLogLevel:
          final enumIndex = keyed.selectStringIndex(
            _$ServiceSpecSchema.logLevelKeyOptions,
          );
          if (enumIndex >= 0 && enumIndex < LogLevel.values.length) {
            logLevel = LogLevel.values[enumIndex];
          } else {
            throw const CodableException('Unknown LogLevel value');
          }
          break;
        case _$ServiceSpecSchema.keyMaxRetries:
          maxRetries = keyed.readInt();
          break;
        case _$ServiceSpecSchema.keySampleRate:
          if (keyed.isNextNull()) {
            keyed.readNull();
            sampleRate = null;
          } else {
            sampleRate = keyed.readDouble();
          }
          break;
        case _$ServiceSpecSchema.keyTlsCertDer:
          if (keyed.isNextNull()) {
            keyed.readNull();
            tlsCertDer = null;
          } else {
            tlsCertDer = keyed.readBytes();
          }
          break;
        case _$ServiceSpecSchema.keyBounds:
          if (keyed.isNextNull()) {
            keyed.readNull();
            bounds = null;
          } else {
            bounds = keyed.decodeFloat64List();
          }
          break;
        case _$ServiceSpecSchema.keyTags:
          tags = keyed.decodeStringList();
          break;
        case _$ServiceSpecSchema.keyFeatureQuotas:
          {
            final k = keyed.nestedDecoder().keyed();
            final m = <String, int?>{};
            while (k.moveNextKey()) {
              final key = k.nextKey();
              m[key] = k.readNullableInt();
            }
            featureQuotas = m;
          }
          break;
        case _$ServiceSpecSchema.keyHttpCodes:
          {
            final mDecoder = keyed.nestedDecoder().map();
            final m = <int, String>{};
            while (mDecoder.moveNextEntry()) {
              final key = mDecoder.keyDecoder().singleValue().readInt();
              m[key] = mDecoder.valueDecoder().singleValue().readString();
            }
            httpCodes = m;
          }
          break;
        case _$ServiceSpecSchema.keyAlertByLevel:
          {
            final mDecoder = keyed.nestedDecoder().map();
            final m = <LogLevel, bool>{};
            while (mDecoder.moveNextEntry()) {
              final enumIdx1 = _$ServiceSpecSchema.enumLogLevelKeyOptions
                  .indexOf(mDecoder.keyDecoder().singleValue().readString());
              if (enumIdx1 < 0) {
                throw const CodableException('Unknown LogLevel value');
              }
              final key = LogLevel.values[enumIdx1];
              m[key] = mDecoder.valueDecoder().singleValue().readBool();
            }
            alertByLevel = m;
          }
          break;
        case _$ServiceSpecSchema.keyZoneLabels:
          {
            final mDecoder = keyed.nestedDecoder().map();
            final m = <GridCoord, String>{};
            while (mDecoder.moveNextEntry()) {
              final key = const GridCoordCodable().decode(
                mDecoder.keyDecoder(),
              );
              m[key] = mDecoder.valueDecoder().singleValue().readString();
            }
            zoneLabels = m;
          }
          break;
        default:
          keyed.skipValue();
          break;
      }
    }

    // Inlined fast-path check
    seen.validate();

    return ServiceSpec(
      serviceName: serviceName!,
      logLevel: logLevel,
      maxRetries: maxRetries,
      sampleRate: sampleRate,
      tlsCertDer: tlsCertDer,
      bounds: bounds,
      tags: tags,
      featureQuotas: featureQuotas,
      httpCodes: httpCodes,
      alertByLevel: alertByLevel,
      zoneLabels: zoneLabels,
    );
  }

  @override
  void encode(ServiceSpec instance, Encoder encoder) {
    final keyed = encoder.keyed();
    keyed.encodeString(
      _$ServiceSpecSchema.nameServiceName,
      instance.serviceName,
    );
    keyed.encodeString(
      _$ServiceSpecSchema.nameLogLevel,
      instance.logLevel.name,
    );
    keyed.encodeInt(_$ServiceSpecSchema.nameMaxRetries, instance.maxRetries);
    if (instance.sampleRate != null) {
      keyed.encodeDouble(
        _$ServiceSpecSchema.nameSampleRate,
        instance.sampleRate!,
      );
    }
    if (instance.tlsCertDer != null) {
      keyed.encodeBytes(
        _$ServiceSpecSchema.nameTlsCertDer,
        instance.tlsCertDer!,
      );
    }
    if (instance.bounds != null) {
      keyed.encodeDoubleList(_$ServiceSpecSchema.nameBounds, instance.bounds!);
    }
    keyed.encodeStringList(_$ServiceSpecSchema.nameTags, instance.tags);
    {
      final k = keyed
          .nestedEncoder(_$ServiceSpecSchema.nameFeatureQuotas)
          .keyed(length: instance.featureQuotas.length);
      for (final entry in instance.featureQuotas.entries) {
        if (entry.value case final val1?) {
          k.encodeInt(entry.key, val1);
        } else {
          k.encodeNull(entry.key);
        }
      }
    }
    {
      final m = keyed
          .nestedEncoder(_$ServiceSpecSchema.nameHttpCodes)
          .map(length: instance.httpCodes.length);
      for (final entry in instance.httpCodes.entries) {
        m.keyEncoder().singleValue().encodeInt(entry.key);
        m.valueEncoder().singleValue().encodeString(entry.value);
      }
    }
    {
      final m = keyed
          .nestedEncoder(_$ServiceSpecSchema.nameAlertByLevel)
          .map(length: instance.alertByLevel.length);
      for (final entry in instance.alertByLevel.entries) {
        m.keyEncoder().singleValue().encodeString(entry.key.name);
        m.valueEncoder().singleValue().encodeBool(entry.value);
      }
    }
    {
      final m = keyed
          .nestedEncoder(_$ServiceSpecSchema.nameZoneLabels)
          .map(length: instance.zoneLabels.length);
      for (final entry in instance.zoneLabels.entries) {
        const GridCoordCodable().encode(entry.key, m.keyEncoder());
        m.valueEncoder().singleValue().encodeString(entry.value);
      }
    }
  }
}
