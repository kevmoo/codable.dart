// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: lines_longer_than_80_chars, unnecessary_lambdas, deprecated_member_use, unused_element

part of 'cross_format_test.dart';

// **************************************************************************
// CodableGenerator
// **************************************************************************

// =============================================================================
// 1. Unified Schema Descriptor for OrderItem
// =============================================================================
extension type const _$OrderItemSchema(int _value) {
  // String Name Constants
  static const String nameCount = 'count';
  static const String nameItemNumber = 'itemNumber';
  static const String nameIsRushed = 'isRushed';

  // Key Indices for selectKeyIndex()
  static const int keyCount = 0;
  static const int keyItemNumber = 1;
  static const int keyIsRushed = 2;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
    _$OrderItemSchema.nameCount,
    _$OrderItemSchema.nameItemNumber,
    _$OrderItemSchema.nameIsRushed,
  ]);
  static final KeyOptions keyOptions = options;

  // Bitmask Flags strictly for Required Fields
  static const _$OrderItemSchema none = _$OrderItemSchema(0);

  @pragma('vm:prefer-inline')
  _$OrderItemSchema operator |(_$OrderItemSchema other) =>
      _$OrderItemSchema(_value | other._value);

  /// Validates required fields in 1 CPU test instruction on the fast path.
  @pragma('vm:prefer-inline')
  void validate() {}
}

// =============================================================================
// 2. Companion Codable for OrderItem
// =============================================================================
final class OrderItemCodable implements Codable<OrderItem> {
  const OrderItemCodable();

  @override
  OrderItem decode(Decoder decoder) {
    final keyed = decoder.keyed(options: _$OrderItemSchema.keyOptions);

    int? count;
    int? itemNumber;
    bool? isRushed;
    var seen = _$OrderItemSchema.none;

    while (keyed.moveNextKey()) {
      switch (keyed.selectKeyIndex(_$OrderItemSchema.keyOptions)) {
        case _$OrderItemSchema.keyCount:
          if (keyed.isNextNull()) {
            keyed.readNull();
            count = null;
          } else {
            count = keyed.readInt();
          }
          break;
        case _$OrderItemSchema.keyItemNumber:
          if (keyed.isNextNull()) {
            keyed.readNull();
            itemNumber = null;
          } else {
            itemNumber = keyed.readInt();
          }
          break;
        case _$OrderItemSchema.keyIsRushed:
          if (keyed.isNextNull()) {
            keyed.readNull();
            isRushed = null;
          } else {
            isRushed = keyed.readBool();
          }
          break;
        default:
          keyed.skipValue();
          break;
      }
    }

    // Inlined fast-path check
    seen.validate();

    return OrderItem(count: count, itemNumber: itemNumber, isRushed: isRushed);
  }

  @override
  void encode(OrderItem instance, Encoder encoder) {
    final keyed = encoder.keyed();
    if (instance.count != null) {
      keyed.encodeInt(_$OrderItemSchema.nameCount, instance.count!);
    }
    if (instance.itemNumber != null) {
      keyed.encodeInt(_$OrderItemSchema.nameItemNumber, instance.itemNumber!);
    }
    if (instance.isRushed != null) {
      keyed.encodeBool(_$OrderItemSchema.nameIsRushed, instance.isRushed!);
    }
  }
}

// =============================================================================
// 1. Unified Schema Descriptor for Order
// =============================================================================
extension type const _$OrderSchema(int _value) {
  // String Name Constants
  static const String nameDateUs = 'dateUs';
  static const String nameCount = 'count';
  static const String nameItem = 'item';

  // Key Indices for selectKeyIndex()
  static const int keyDateUs = 0;
  static const int keyCount = 1;
  static const int keyItem = 2;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
    _$OrderSchema.nameDateUs,
    _$OrderSchema.nameCount,
    _$OrderSchema.nameItem,
  ]);
  static final KeyOptions keyOptions = options;

  // Bitmask Flags strictly for Required Fields
  static const _$OrderSchema none = _$OrderSchema(0);
  static const int _dateUsBit = 1 << 0;
  static const _$OrderSchema dateUs = _$OrderSchema(_dateUsBit);

  // Combined Golden Bitmask for fast single-instruction check
  static const _$OrderSchema golden = _$OrderSchema(_dateUsBit);

  @pragma('vm:prefer-inline')
  _$OrderSchema operator |(_$OrderSchema other) =>
      _$OrderSchema(_value | other._value);

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
    if ((_value & _dateUsBit) == 0) {
      missing.add(nameDateUs);
    }
    throw CodableException(
      'Missing required fields for Order: ${missing.join(", ")}',
    );
  }
}

// =============================================================================
// 2. Companion Codable for Order
// =============================================================================
final class OrderCodable implements Codable<Order> {
  const OrderCodable();

  @override
  Order decode(Decoder decoder) {
    final keyed = decoder.keyed(options: _$OrderSchema.keyOptions);

    int? dateUs;
    int? count;
    OrderItem? item;
    var seen = _$OrderSchema.none;

    while (keyed.moveNextKey()) {
      switch (keyed.selectKeyIndex(_$OrderSchema.keyOptions)) {
        case _$OrderSchema.keyDateUs:
          if ((seen._value & _$OrderSchema.dateUs._value) != 0) {
            throw const CodableException('Duplicate field "dateUs"');
          }
          dateUs = keyed.readInt();
          seen |= _$OrderSchema.dateUs;
          break;
        case _$OrderSchema.keyCount:
          if (keyed.isNextNull()) {
            keyed.readNull();
            count = null;
          } else {
            count = keyed.readInt();
          }
          break;
        case _$OrderSchema.keyItem:
          if (keyed.isNextNull()) {
            keyed.readNull();
            item = null;
          } else {
            item = const OrderItemCodable().decode(keyed.nestedDecoder());
          }
          break;
        default:
          keyed.skipValue();
          break;
      }
    }

    // Inlined fast-path check
    seen.validate();

    return Order(dateUs: dateUs!, count: count, item: item);
  }

  @override
  void encode(Order instance, Encoder encoder) {
    final keyed = encoder.keyed();
    keyed.encodeInt(_$OrderSchema.nameDateUs, instance.dateUs);
    if (instance.count != null) {
      keyed.encodeInt(_$OrderSchema.nameCount, instance.count!);
    }
    if (instance.item != null) {
      keyed.encodeValue(
        _$OrderSchema.nameItem,
        instance.item!,
        const OrderItemCodable(),
      );
    }
  }
}

// =============================================================================
// 1. Unified Schema Descriptor for Person
// =============================================================================
extension type const _$PersonSchema(int _value) {
  // String Name Constants
  static const String nameFirstName = 'firstName';
  static const String nameLastName = 'lastName';
  static const String nameDateOfBirth = 'date-of-birth';
  static const String aliasDateOfBirthDob = 'dob';
  static const String nameMiddleName = 'middleName';
  static const String nameOrders = 'orders';

  // Key Indices for selectKeyIndex()
  static const int keyFirstName = 0;
  static const int keyLastName = 1;
  static const int keyDateOfBirth = 2;
  static const int aliasKeyDateOfBirthDob = 3;
  static const int keyMiddleName = 4;
  static const int keyOrders = 5;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
    _$PersonSchema.nameFirstName,
    _$PersonSchema.nameLastName,
    _$PersonSchema.nameDateOfBirth,
    _$PersonSchema.aliasDateOfBirthDob,
    _$PersonSchema.nameMiddleName,
    _$PersonSchema.nameOrders,
  ]);
  static final KeyOptions keyOptions = options;

  // Bitmask Flags strictly for Required Fields
  static const _$PersonSchema none = _$PersonSchema(0);
  static const int _firstNameBit = 1 << 0;
  static const _$PersonSchema firstName = _$PersonSchema(_firstNameBit);
  static const int _lastNameBit = 1 << 1;
  static const _$PersonSchema lastName = _$PersonSchema(_lastNameBit);
  static const int _dateOfBirthBit = 1 << 2;
  static const _$PersonSchema dateOfBirth = _$PersonSchema(_dateOfBirthBit);

  // Combined Golden Bitmask for fast single-instruction check
  static const _$PersonSchema golden = _$PersonSchema(
    _firstNameBit | _lastNameBit | _dateOfBirthBit,
  );

  @pragma('vm:prefer-inline')
  _$PersonSchema operator |(_$PersonSchema other) =>
      _$PersonSchema(_value | other._value);

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
    if ((_value & _firstNameBit) == 0) {
      missing.add(nameFirstName);
    }
    if ((_value & _lastNameBit) == 0) {
      missing.add(nameLastName);
    }
    if ((_value & _dateOfBirthBit) == 0) {
      missing.add(nameDateOfBirth);
    }
    throw CodableException(
      'Missing required fields for Person: ${missing.join(", ")}',
    );
  }
}

// =============================================================================
// 2. Companion Codable for Person
// =============================================================================
final class PersonCodable implements Codable<Person> {
  const PersonCodable();

  @override
  Person decode(Decoder decoder) {
    final keyed = decoder.keyed(options: _$PersonSchema.keyOptions);

    String? firstName;
    String? lastName;
    DateTime? dateOfBirth;
    String? middleName;
    var orders = const <Order>[];
    var seen = _$PersonSchema.none;

    while (keyed.moveNextKey()) {
      switch (keyed.selectKeyIndex(_$PersonSchema.keyOptions)) {
        case _$PersonSchema.keyFirstName:
          if ((seen._value & _$PersonSchema.firstName._value) != 0) {
            throw const CodableException('Duplicate field "firstName"');
          }
          firstName = keyed.readString();
          seen |= _$PersonSchema.firstName;
          break;
        case _$PersonSchema.keyLastName:
          if ((seen._value & _$PersonSchema.lastName._value) != 0) {
            throw const CodableException('Duplicate field "lastName"');
          }
          lastName = keyed.readString();
          seen |= _$PersonSchema.lastName;
          break;
        case _$PersonSchema.keyDateOfBirth:
        case _$PersonSchema.aliasKeyDateOfBirthDob:
          if ((seen._value & _$PersonSchema.dateOfBirth._value) != 0) {
            throw const CodableException('Duplicate field "date-of-birth"');
          }
          dateOfBirth = keyed.decodeValue(const DateTimeIsoCodec());
          seen |= _$PersonSchema.dateOfBirth;
          break;
        case _$PersonSchema.keyMiddleName:
          if (keyed.isNextNull()) {
            keyed.readNull();
            middleName = null;
          } else {
            middleName = keyed.readString();
          }
          break;
        case _$PersonSchema.keyOrders:
          orders = const OrderCodable().decodeList(keyed.nestedDecoder());
          break;
        default:
          keyed.skipValue();
          break;
      }
    }

    // Inlined fast-path check
    seen.validate();

    return Person(
      firstName: firstName!,
      lastName: lastName!,
      dateOfBirth: dateOfBirth!,
      middleName: middleName,
      orders: orders,
    );
  }

  @override
  void encode(Person instance, Encoder encoder) {
    final keyed = encoder.keyed();
    keyed.encodeString(_$PersonSchema.nameFirstName, instance.firstName);
    keyed.encodeString(_$PersonSchema.nameLastName, instance.lastName);
    keyed.encodeValue(
      _$PersonSchema.nameDateOfBirth,
      instance.dateOfBirth,
      const DateTimeIsoCodec(),
    );
    if (instance.middleName != null) {
      keyed.encodeString(_$PersonSchema.nameMiddleName, instance.middleName!);
    }
    keyed.encodeList(
      _$PersonSchema.nameOrders,
      instance.orders,
      const OrderCodable(),
    );
  }
}

// =============================================================================
// 1. Unified Schema Descriptor for PointKey
// =============================================================================
extension type const _$PointKeySchema(int _value) {
  // String Name Constants
  static const String nameX = 'x';
  static const String nameY = 'y';

  // Key Indices for selectKeyIndex()
  static const int keyX = 0;
  static const int keyY = 1;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
    _$PointKeySchema.nameX,
    _$PointKeySchema.nameY,
  ]);
  static final KeyOptions keyOptions = options;

  // Bitmask Flags strictly for Required Fields
  static const _$PointKeySchema none = _$PointKeySchema(0);
  static const int _xBit = 1 << 0;
  static const _$PointKeySchema x = _$PointKeySchema(_xBit);
  static const int _yBit = 1 << 1;
  static const _$PointKeySchema y = _$PointKeySchema(_yBit);

  // Combined Golden Bitmask for fast single-instruction check
  static const _$PointKeySchema golden = _$PointKeySchema(_xBit | _yBit);

  @pragma('vm:prefer-inline')
  _$PointKeySchema operator |(_$PointKeySchema other) =>
      _$PointKeySchema(_value | other._value);

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
    throw CodableException(
      'Missing required fields for PointKey: ${missing.join(", ")}',
    );
  }
}

// =============================================================================
// 2. Companion Codable for PointKey
// =============================================================================
final class PointKeyCodable implements Codable<PointKey> {
  const PointKeyCodable();

  @override
  PointKey decode(Decoder decoder) {
    final keyed = decoder.keyed(options: _$PointKeySchema.keyOptions);

    int? x;
    int? y;
    var seen = _$PointKeySchema.none;

    while (keyed.moveNextKey()) {
      switch (keyed.selectKeyIndex(_$PointKeySchema.keyOptions)) {
        case _$PointKeySchema.keyX:
          if ((seen._value & _$PointKeySchema.x._value) != 0) {
            throw const CodableException('Duplicate field "x"');
          }
          x = keyed.readInt();
          seen |= _$PointKeySchema.x;
          break;
        case _$PointKeySchema.keyY:
          if ((seen._value & _$PointKeySchema.y._value) != 0) {
            throw const CodableException('Duplicate field "y"');
          }
          y = keyed.readInt();
          seen |= _$PointKeySchema.y;
          break;
        default:
          keyed.skipValue();
          break;
      }
    }

    // Inlined fast-path check
    seen.validate();

    return PointKey(x!, y!);
  }

  @override
  void encode(PointKey instance, Encoder encoder) {
    final keyed = encoder.keyed(length: 2);
    keyed.encodeInt(_$PointKeySchema.nameX, instance.x);
    keyed.encodeInt(_$PointKeySchema.nameY, instance.y);
  }
}

// =============================================================================
// 1. Unified Schema Descriptor for OpenApiSpecModel
// =============================================================================
extension type const _$OpenApiSpecModelSchema(int _value) {
  // String Name Constants
  static const String namePath = 'path';
  static const String nameMethod = 'method';
  static const String nameSchemaHash = 'schemaHash';
  static const String nameSignature = 'signature';
  static const String nameResponses = 'responses';
  static const String nameRateLimits = 'rateLimits';
  static const String nameLatencyBuckets = 'latencyBuckets';

  // Key Indices for selectKeyIndex()
  static const int keyPath = 0;
  static const int keyMethod = 1;
  static const int keySchemaHash = 2;
  static const int keySignature = 3;
  static const int keyResponses = 4;
  static const int keyRateLimits = 5;
  static const int keyLatencyBuckets = 6;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
    _$OpenApiSpecModelSchema.namePath,
    _$OpenApiSpecModelSchema.nameMethod,
    _$OpenApiSpecModelSchema.nameSchemaHash,
    _$OpenApiSpecModelSchema.nameSignature,
    _$OpenApiSpecModelSchema.nameResponses,
    _$OpenApiSpecModelSchema.nameRateLimits,
    _$OpenApiSpecModelSchema.nameLatencyBuckets,
  ]);
  static final KeyOptions keyOptions = options;

  // Enum Options for method
  static final KeyOptions methodEnumOptions = KeyOptions.of(const [
    'get',
    'post',
    'delete',
  ]);
  static final KeyOptions methodKeyOptions = methodEnumOptions;

  // Enum Options for HttpVerb
  static final KeyOptions enumHttpVerbKeyOptions = KeyOptions.of(const [
    'get',
    'post',
    'delete',
  ]);

  // Bitmask Flags strictly for Required Fields
  static const _$OpenApiSpecModelSchema none = _$OpenApiSpecModelSchema(0);
  static const int _pathBit = 1 << 0;
  static const _$OpenApiSpecModelSchema path = _$OpenApiSpecModelSchema(
    _pathBit,
  );
  static const int _methodBit = 1 << 1;
  static const _$OpenApiSpecModelSchema method = _$OpenApiSpecModelSchema(
    _methodBit,
  );
  static const int _schemaHashBit = 1 << 2;
  static const _$OpenApiSpecModelSchema schemaHash = _$OpenApiSpecModelSchema(
    _schemaHashBit,
  );

  // Combined Golden Bitmask for fast single-instruction check
  static const _$OpenApiSpecModelSchema golden = _$OpenApiSpecModelSchema(
    _pathBit | _methodBit | _schemaHashBit,
  );

  @pragma('vm:prefer-inline')
  _$OpenApiSpecModelSchema operator |(_$OpenApiSpecModelSchema other) =>
      _$OpenApiSpecModelSchema(_value | other._value);

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
    if ((_value & _methodBit) == 0) {
      missing.add(nameMethod);
    }
    if ((_value & _schemaHashBit) == 0) {
      missing.add(nameSchemaHash);
    }
    throw CodableException(
      'Missing required fields for OpenApiSpecModel: ${missing.join(", ")}',
    );
  }
}

// =============================================================================
// 2. Companion Codable for OpenApiSpecModel
// =============================================================================
final class OpenApiSpecModelCodable implements Codable<OpenApiSpecModel> {
  const OpenApiSpecModelCodable();

  @override
  OpenApiSpecModel decode(Decoder decoder) {
    final keyed = decoder.keyed(options: _$OpenApiSpecModelSchema.keyOptions);

    String? path;
    HttpVerb? method;
    Uint8List? schemaHash;
    Uint8List? signature;
    var responses = const <int, String>{};
    var rateLimits = const <HttpVerb, int>{};
    var latencyBuckets = const <String, List<int>>{};
    var seen = _$OpenApiSpecModelSchema.none;

    while (keyed.moveNextKey()) {
      switch (keyed.selectKeyIndex(_$OpenApiSpecModelSchema.keyOptions)) {
        case _$OpenApiSpecModelSchema.keyPath:
          if ((seen._value & _$OpenApiSpecModelSchema.path._value) != 0) {
            throw const CodableException('Duplicate field "path"');
          }
          path = keyed.readString();
          seen |= _$OpenApiSpecModelSchema.path;
          break;
        case _$OpenApiSpecModelSchema.keyMethod:
          if ((seen._value & _$OpenApiSpecModelSchema.method._value) != 0) {
            throw const CodableException('Duplicate field "method"');
          }
          final enumIndex = keyed.selectStringIndex(
            _$OpenApiSpecModelSchema.methodKeyOptions,
          );
          if (enumIndex >= 0 && enumIndex < HttpVerb.values.length) {
            method = HttpVerb.values[enumIndex];
          } else {
            throw const CodableException('Unknown HttpVerb value');
          }
          seen |= _$OpenApiSpecModelSchema.method;
          break;
        case _$OpenApiSpecModelSchema.keySchemaHash:
          if ((seen._value & _$OpenApiSpecModelSchema.schemaHash._value) != 0) {
            throw const CodableException('Duplicate field "schemaHash"');
          }
          schemaHash = keyed.readBytes();
          seen |= _$OpenApiSpecModelSchema.schemaHash;
          break;
        case _$OpenApiSpecModelSchema.keySignature:
          if (keyed.isNextNull()) {
            keyed.readNull();
            signature = null;
          } else {
            signature = keyed.readBytes();
          }
          break;
        case _$OpenApiSpecModelSchema.keyResponses:
          {
            final mDecoder = keyed.nestedDecoder().map();
            final m = <int, String>{};
            while (mDecoder.moveNextEntry()) {
              final key = mDecoder.keyDecoder().singleValue().readInt();
              m[key] = mDecoder.valueDecoder().singleValue().readString();
            }
            responses = m;
          }
          break;
        case _$OpenApiSpecModelSchema.keyRateLimits:
          {
            final mDecoder = keyed.nestedDecoder().map();
            final m = <HttpVerb, int>{};
            while (mDecoder.moveNextEntry()) {
              final enumIdx1 = _$OpenApiSpecModelSchema.enumHttpVerbKeyOptions
                  .indexOf(mDecoder.keyDecoder().singleValue().readString());
              if (enumIdx1 < 0) {
                throw const CodableException('Unknown HttpVerb value');
              }
              final key = HttpVerb.values[enumIdx1];
              m[key] = mDecoder.valueDecoder().singleValue().readInt();
            }
            rateLimits = m;
          }
          break;
        case _$OpenApiSpecModelSchema.keyLatencyBuckets:
          {
            final k = keyed.nestedDecoder().keyed();
            final m = <String, List<int>>{};
            while (k.moveNextKey()) {
              final key = k.nextKey();
              m[key] = k.decodeIntList();
            }
            latencyBuckets = m;
          }
          break;
        default:
          keyed.skipValue();
          break;
      }
    }

    // Inlined fast-path check
    seen.validate();

    return OpenApiSpecModel(
      path: path!,
      method: method!,
      schemaHash: schemaHash!,
      signature: signature,
      responses: responses,
      rateLimits: rateLimits,
      latencyBuckets: latencyBuckets,
    );
  }

  @override
  void encode(OpenApiSpecModel instance, Encoder encoder) {
    final keyed = encoder.keyed();
    keyed.encodeString(_$OpenApiSpecModelSchema.namePath, instance.path);
    keyed.encodeString(
      _$OpenApiSpecModelSchema.nameMethod,
      instance.method.name,
    );
    keyed.encodeBytes(
      _$OpenApiSpecModelSchema.nameSchemaHash,
      instance.schemaHash,
    );
    if (instance.signature != null) {
      keyed.encodeBytes(
        _$OpenApiSpecModelSchema.nameSignature,
        instance.signature!,
      );
    }
    {
      final m = keyed
          .nestedEncoder(_$OpenApiSpecModelSchema.nameResponses)
          .map(length: instance.responses.length);
      for (final entry in instance.responses.entries) {
        m.keyEncoder().singleValue().encodeInt(entry.key);
        m.valueEncoder().singleValue().encodeString(entry.value);
      }
    }
    {
      final m = keyed
          .nestedEncoder(_$OpenApiSpecModelSchema.nameRateLimits)
          .map(length: instance.rateLimits.length);
      for (final entry in instance.rateLimits.entries) {
        m.keyEncoder().singleValue().encodeString(entry.key.name);
        m.valueEncoder().singleValue().encodeInt(entry.value);
      }
    }
    {
      final k = keyed
          .nestedEncoder(_$OpenApiSpecModelSchema.nameLatencyBuckets)
          .keyed(length: instance.latencyBuckets.length);
      for (final entry in instance.latencyBuckets.entries) {
        k.encodeIntList(entry.key, entry.value);
      }
    }
  }
}

// =============================================================================
// 1. Unified Schema Descriptor for GridOverlayModel
// =============================================================================
extension type const _$GridOverlayModelSchema(int _value) {
  // String Name Constants
  static const String nameCells = 'cells';

  // Key Indices for selectKeyIndex()
  static const int keyCells = 0;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
    _$GridOverlayModelSchema.nameCells,
  ]);
  static final KeyOptions keyOptions = options;

  // Bitmask Flags strictly for Required Fields
  static const _$GridOverlayModelSchema none = _$GridOverlayModelSchema(0);

  @pragma('vm:prefer-inline')
  _$GridOverlayModelSchema operator |(_$GridOverlayModelSchema other) =>
      _$GridOverlayModelSchema(_value | other._value);

  /// Validates required fields in 1 CPU test instruction on the fast path.
  @pragma('vm:prefer-inline')
  void validate() {}
}

// =============================================================================
// 2. Companion Codable for GridOverlayModel
// =============================================================================
final class GridOverlayModelCodable implements Codable<GridOverlayModel> {
  const GridOverlayModelCodable();

  @override
  GridOverlayModel decode(Decoder decoder) {
    final keyed = decoder.keyed(options: _$GridOverlayModelSchema.keyOptions);

    var cells = const <PointKey, String>{};
    var seen = _$GridOverlayModelSchema.none;

    while (keyed.moveNextKey()) {
      switch (keyed.selectKeyIndex(_$GridOverlayModelSchema.keyOptions)) {
        case _$GridOverlayModelSchema.keyCells:
          {
            final mDecoder = keyed.nestedDecoder().map();
            final m = <PointKey, String>{};
            while (mDecoder.moveNextEntry()) {
              final key = const PointKeyCodable().decode(mDecoder.keyDecoder());
              m[key] = mDecoder.valueDecoder().singleValue().readString();
            }
            cells = m;
          }
          break;
        default:
          keyed.skipValue();
          break;
      }
    }

    // Inlined fast-path check
    seen.validate();

    return GridOverlayModel(cells: cells);
  }

  @override
  void encode(GridOverlayModel instance, Encoder encoder) {
    final keyed = encoder.keyed(length: 1);
    {
      final m = keyed
          .nestedEncoder(_$GridOverlayModelSchema.nameCells)
          .map(length: instance.cells.length);
      for (final entry in instance.cells.entries) {
        const PointKeyCodable().encode(entry.key, m.keyEncoder());
        m.valueEncoder().singleValue().encodeString(entry.value);
      }
    }
  }
}

// =============================================================================
// 1. Unified Schema Descriptor for StringMapBundle
// =============================================================================
extension type const _$StringMapBundleSchema(int _value) {
  // String Name Constants
  static const String nameEmptyLabels = 'emptyLabels';
  static const String nameBulkAttributes = 'bulkAttributes';
  static const String nameNullableScores = 'nullableScores';
  static const String nameSeriesByTag = 'seriesByTag';

  // Key Indices for selectKeyIndex()
  static const int keyEmptyLabels = 0;
  static const int keyBulkAttributes = 1;
  static const int keyNullableScores = 2;
  static const int keySeriesByTag = 3;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
    _$StringMapBundleSchema.nameEmptyLabels,
    _$StringMapBundleSchema.nameBulkAttributes,
    _$StringMapBundleSchema.nameNullableScores,
    _$StringMapBundleSchema.nameSeriesByTag,
  ]);
  static final KeyOptions keyOptions = options;

  // Bitmask Flags strictly for Required Fields
  static const _$StringMapBundleSchema none = _$StringMapBundleSchema(0);
  static const int _emptyLabelsBit = 1 << 0;
  static const _$StringMapBundleSchema emptyLabels = _$StringMapBundleSchema(
    _emptyLabelsBit,
  );
  static const int _bulkAttributesBit = 1 << 1;
  static const _$StringMapBundleSchema bulkAttributes = _$StringMapBundleSchema(
    _bulkAttributesBit,
  );
  static const int _nullableScoresBit = 1 << 2;
  static const _$StringMapBundleSchema nullableScores = _$StringMapBundleSchema(
    _nullableScoresBit,
  );
  static const int _seriesByTagBit = 1 << 3;
  static const _$StringMapBundleSchema seriesByTag = _$StringMapBundleSchema(
    _seriesByTagBit,
  );

  // Combined Golden Bitmask for fast single-instruction check
  static const _$StringMapBundleSchema golden = _$StringMapBundleSchema(
    _emptyLabelsBit | _bulkAttributesBit | _nullableScoresBit | _seriesByTagBit,
  );

  @pragma('vm:prefer-inline')
  _$StringMapBundleSchema operator |(_$StringMapBundleSchema other) =>
      _$StringMapBundleSchema(_value | other._value);

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
    if ((_value & _emptyLabelsBit) == 0) {
      missing.add(nameEmptyLabels);
    }
    if ((_value & _bulkAttributesBit) == 0) {
      missing.add(nameBulkAttributes);
    }
    if ((_value & _nullableScoresBit) == 0) {
      missing.add(nameNullableScores);
    }
    if ((_value & _seriesByTagBit) == 0) {
      missing.add(nameSeriesByTag);
    }
    throw CodableException(
      'Missing required fields for StringMapBundle: ${missing.join(", ")}',
    );
  }
}

// =============================================================================
// 2. Companion Codable for StringMapBundle
// =============================================================================
final class StringMapBundleCodable implements Codable<StringMapBundle> {
  const StringMapBundleCodable();

  @override
  StringMapBundle decode(Decoder decoder) {
    final keyed = decoder.keyed(options: _$StringMapBundleSchema.keyOptions);

    Map<String, String>? emptyLabels;
    Map<String, String>? bulkAttributes;
    Map<String, int?>? nullableScores;
    Map<String, List<int>>? seriesByTag;
    var seen = _$StringMapBundleSchema.none;

    while (keyed.moveNextKey()) {
      switch (keyed.selectKeyIndex(_$StringMapBundleSchema.keyOptions)) {
        case _$StringMapBundleSchema.keyEmptyLabels:
          if ((seen._value & _$StringMapBundleSchema.emptyLabels._value) != 0) {
            throw const CodableException('Duplicate field "emptyLabels"');
          }
          {
            final k = keyed.nestedDecoder().keyed();
            final m = <String, String>{};
            while (k.moveNextKey()) {
              final key = k.nextKey();
              m[key] = k.readString();
            }
            emptyLabels = m;
          }
          seen |= _$StringMapBundleSchema.emptyLabels;
          break;
        case _$StringMapBundleSchema.keyBulkAttributes:
          if ((seen._value & _$StringMapBundleSchema.bulkAttributes._value) !=
              0) {
            throw const CodableException('Duplicate field "bulkAttributes"');
          }
          {
            final k = keyed.nestedDecoder().keyed();
            final m = <String, String>{};
            while (k.moveNextKey()) {
              final key = k.nextKey();
              m[key] = k.readString();
            }
            bulkAttributes = m;
          }
          seen |= _$StringMapBundleSchema.bulkAttributes;
          break;
        case _$StringMapBundleSchema.keyNullableScores:
          if ((seen._value & _$StringMapBundleSchema.nullableScores._value) !=
              0) {
            throw const CodableException('Duplicate field "nullableScores"');
          }
          {
            final k = keyed.nestedDecoder().keyed();
            final m = <String, int?>{};
            while (k.moveNextKey()) {
              final key = k.nextKey();
              m[key] = k.readNullableInt();
            }
            nullableScores = m;
          }
          seen |= _$StringMapBundleSchema.nullableScores;
          break;
        case _$StringMapBundleSchema.keySeriesByTag:
          if ((seen._value & _$StringMapBundleSchema.seriesByTag._value) != 0) {
            throw const CodableException('Duplicate field "seriesByTag"');
          }
          {
            final k = keyed.nestedDecoder().keyed();
            final m = <String, List<int>>{};
            while (k.moveNextKey()) {
              final key = k.nextKey();
              m[key] = k.decodeIntList();
            }
            seriesByTag = m;
          }
          seen |= _$StringMapBundleSchema.seriesByTag;
          break;
        default:
          keyed.skipValue();
          break;
      }
    }

    // Inlined fast-path check
    seen.validate();

    return StringMapBundle(
      emptyLabels: emptyLabels!,
      bulkAttributes: bulkAttributes!,
      nullableScores: nullableScores!,
      seriesByTag: seriesByTag!,
    );
  }

  @override
  void encode(StringMapBundle instance, Encoder encoder) {
    final keyed = encoder.keyed(length: 4);
    {
      final k = keyed
          .nestedEncoder(_$StringMapBundleSchema.nameEmptyLabels)
          .keyed(length: instance.emptyLabels.length);
      for (final entry in instance.emptyLabels.entries) {
        k.encodeString(entry.key, entry.value);
      }
    }
    {
      final k = keyed
          .nestedEncoder(_$StringMapBundleSchema.nameBulkAttributes)
          .keyed(length: instance.bulkAttributes.length);
      for (final entry in instance.bulkAttributes.entries) {
        k.encodeString(entry.key, entry.value);
      }
    }
    {
      final k = keyed
          .nestedEncoder(_$StringMapBundleSchema.nameNullableScores)
          .keyed(length: instance.nullableScores.length);
      for (final entry in instance.nullableScores.entries) {
        if (entry.value case final val1?) {
          k.encodeInt(entry.key, val1);
        } else {
          k.encodeNull(entry.key);
        }
      }
    }
    {
      final k = keyed
          .nestedEncoder(_$StringMapBundleSchema.nameSeriesByTag)
          .keyed(length: instance.seriesByTag.length);
      for (final entry in instance.seriesByTag.entries) {
        k.encodeIntList(entry.key, entry.value);
      }
    }
  }
}

// =============================================================================
// 1. Unified Schema Descriptor for CircleShape
// =============================================================================
extension type const _$CircleShapeSchema(int _value) {
  // String Name Constants
  static const String nameRadius = 'radius';
  static const String nameKind = 'kind';

  // Key Indices for selectKeyIndex()
  static const int keyRadius = 0;
  static const int keyKind = 1;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
    _$CircleShapeSchema.nameRadius,
    _$CircleShapeSchema.nameKind,
  ]);
  static final KeyOptions keyOptions = options;

  // Bitmask Flags strictly for Required Fields
  static const _$CircleShapeSchema none = _$CircleShapeSchema(0);
  static const int _radiusBit = 1 << 0;
  static const _$CircleShapeSchema radius = _$CircleShapeSchema(_radiusBit);

  // Combined Golden Bitmask for fast single-instruction check
  static const _$CircleShapeSchema golden = _$CircleShapeSchema(_radiusBit);

  @pragma('vm:prefer-inline')
  _$CircleShapeSchema operator |(_$CircleShapeSchema other) =>
      _$CircleShapeSchema(_value | other._value);

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
      'Missing required fields for CircleShape: ${missing.join(", ")}',
    );
  }
}

// =============================================================================
// 2. Companion Codable for CircleShape
// =============================================================================
final class CircleShapeCodable implements Codable<CircleShape> {
  const CircleShapeCodable();

  @override
  CircleShape decode(Decoder decoder) {
    final keyed = decoder.keyed(options: _$CircleShapeSchema.keyOptions);

    double? radius;
    var kind = 'circle';
    var seen = _$CircleShapeSchema.none;

    while (keyed.moveNextKey()) {
      switch (keyed.selectKeyIndex(_$CircleShapeSchema.keyOptions)) {
        case _$CircleShapeSchema.keyRadius:
          if ((seen._value & _$CircleShapeSchema.radius._value) != 0) {
            throw const CodableException('Duplicate field "radius"');
          }
          radius = keyed.readDouble();
          seen |= _$CircleShapeSchema.radius;
          break;
        case _$CircleShapeSchema.keyKind:
          kind = keyed.readString();
          break;
        default:
          keyed.skipValue();
          break;
      }
    }

    // Inlined fast-path check
    seen.validate();

    return CircleShape(radius!, kind: kind);
  }

  @override
  void encode(CircleShape instance, Encoder encoder) {
    final keyed = encoder.keyed(length: 2);
    keyed.encodeDouble(_$CircleShapeSchema.nameRadius, instance.radius);
    keyed.encodeString(_$CircleShapeSchema.nameKind, instance.kind);
  }
}

// =============================================================================
// 1. Unified Schema Descriptor for RectShape
// =============================================================================
extension type const _$RectShapeSchema(int _value) {
  // String Name Constants
  static const String nameWidth = 'width';
  static const String nameHeight = 'height';
  static const String nameKind = 'kind';

  // Key Indices for selectKeyIndex()
  static const int keyWidth = 0;
  static const int keyHeight = 1;
  static const int keyKind = 2;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
    _$RectShapeSchema.nameWidth,
    _$RectShapeSchema.nameHeight,
    _$RectShapeSchema.nameKind,
  ]);
  static final KeyOptions keyOptions = options;

  // Bitmask Flags strictly for Required Fields
  static const _$RectShapeSchema none = _$RectShapeSchema(0);
  static const int _widthBit = 1 << 0;
  static const _$RectShapeSchema width = _$RectShapeSchema(_widthBit);
  static const int _heightBit = 1 << 1;
  static const _$RectShapeSchema height = _$RectShapeSchema(_heightBit);

  // Combined Golden Bitmask for fast single-instruction check
  static const _$RectShapeSchema golden = _$RectShapeSchema(
    _widthBit | _heightBit,
  );

  @pragma('vm:prefer-inline')
  _$RectShapeSchema operator |(_$RectShapeSchema other) =>
      _$RectShapeSchema(_value | other._value);

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
    if ((_value & _widthBit) == 0) {
      missing.add(nameWidth);
    }
    if ((_value & _heightBit) == 0) {
      missing.add(nameHeight);
    }
    throw CodableException(
      'Missing required fields for RectShape: ${missing.join(", ")}',
    );
  }
}

// =============================================================================
// 2. Companion Codable for RectShape
// =============================================================================
final class RectShapeCodable implements Codable<RectShape> {
  const RectShapeCodable();

  @override
  RectShape decode(Decoder decoder) {
    final keyed = decoder.keyed(options: _$RectShapeSchema.keyOptions);

    int? width;
    int? height;
    var kind = 'rect';
    var seen = _$RectShapeSchema.none;

    while (keyed.moveNextKey()) {
      switch (keyed.selectKeyIndex(_$RectShapeSchema.keyOptions)) {
        case _$RectShapeSchema.keyWidth:
          if ((seen._value & _$RectShapeSchema.width._value) != 0) {
            throw const CodableException('Duplicate field "width"');
          }
          width = keyed.readInt();
          seen |= _$RectShapeSchema.width;
          break;
        case _$RectShapeSchema.keyHeight:
          if ((seen._value & _$RectShapeSchema.height._value) != 0) {
            throw const CodableException('Duplicate field "height"');
          }
          height = keyed.readInt();
          seen |= _$RectShapeSchema.height;
          break;
        case _$RectShapeSchema.keyKind:
          kind = keyed.readString();
          break;
        default:
          keyed.skipValue();
          break;
      }
    }

    // Inlined fast-path check
    seen.validate();

    return RectShape(width!, height!, kind: kind);
  }

  @override
  void encode(RectShape instance, Encoder encoder) {
    final keyed = encoder.keyed(length: 3);
    keyed.encodeInt(_$RectShapeSchema.nameWidth, instance.width);
    keyed.encodeInt(_$RectShapeSchema.nameHeight, instance.height);
    keyed.encodeString(_$RectShapeSchema.nameKind, instance.kind);
  }
}

// =============================================================================
// 1. Unified Schema Descriptor for AuditEvent
// =============================================================================
extension type const _$AuditEventSchema(int _value) {
  // String Name Constants
  static const String nameId = 'id';
  static const String nameTimestamp = 'timestamp';
  static const String nameAction = 'action';

  // Key Indices for selectKeyIndex()
  static const int keyId = 0;
  static const int keyTimestamp = 1;
  static const int keyAction = 2;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
    _$AuditEventSchema.nameId,
    _$AuditEventSchema.nameTimestamp,
    _$AuditEventSchema.nameAction,
  ]);
  static final KeyOptions keyOptions = options;

  // Bitmask Flags strictly for Required Fields
  static const _$AuditEventSchema none = _$AuditEventSchema(0);
  static const int _idBit = 1 << 0;
  static const _$AuditEventSchema id = _$AuditEventSchema(_idBit);
  static const int _timestampBit = 1 << 1;
  static const _$AuditEventSchema timestamp = _$AuditEventSchema(_timestampBit);
  static const int _actionBit = 1 << 2;
  static const _$AuditEventSchema action = _$AuditEventSchema(_actionBit);

  // Combined Golden Bitmask for fast single-instruction check
  static const _$AuditEventSchema golden = _$AuditEventSchema(
    _idBit | _timestampBit | _actionBit,
  );

  @pragma('vm:prefer-inline')
  _$AuditEventSchema operator |(_$AuditEventSchema other) =>
      _$AuditEventSchema(_value | other._value);

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
    if ((_value & _timestampBit) == 0) {
      missing.add(nameTimestamp);
    }
    if ((_value & _actionBit) == 0) {
      missing.add(nameAction);
    }
    throw CodableException(
      'Missing required fields for AuditEvent: ${missing.join(", ")}',
    );
  }
}

// =============================================================================
// 2. Companion Codable for AuditEvent
// =============================================================================
final class AuditEventCodable implements Codable<AuditEvent> {
  const AuditEventCodable();

  @override
  AuditEvent decode(Decoder decoder) {
    final keyed = decoder.keyed(options: _$AuditEventSchema.keyOptions);

    UuidValue? id;
    DateTime? timestamp;
    String? action;
    var seen = _$AuditEventSchema.none;

    while (keyed.moveNextKey()) {
      switch (keyed.selectKeyIndex(_$AuditEventSchema.keyOptions)) {
        case _$AuditEventSchema.keyId:
          if ((seen._value & _$AuditEventSchema.id._value) != 0) {
            throw const CodableException('Duplicate field "id"');
          }
          id = keyed.decodeValue(const AdaptiveUuidCodable());
          seen |= _$AuditEventSchema.id;
          break;
        case _$AuditEventSchema.keyTimestamp:
          if ((seen._value & _$AuditEventSchema.timestamp._value) != 0) {
            throw const CodableException('Duplicate field "timestamp"');
          }
          timestamp = keyed.decodeValue(const AdaptiveDateTimeCodable());
          seen |= _$AuditEventSchema.timestamp;
          break;
        case _$AuditEventSchema.keyAction:
          if ((seen._value & _$AuditEventSchema.action._value) != 0) {
            throw const CodableException('Duplicate field "action"');
          }
          action = keyed.readString();
          seen |= _$AuditEventSchema.action;
          break;
        default:
          keyed.skipValue();
          break;
      }
    }

    // Inlined fast-path check
    seen.validate();

    return AuditEvent(id: id!, timestamp: timestamp!, action: action!);
  }

  @override
  void encode(AuditEvent instance, Encoder encoder) {
    final keyed = encoder.keyed(length: 3);
    keyed.encodeValue(
      _$AuditEventSchema.nameId,
      instance.id,
      const AdaptiveUuidCodable(),
    );
    keyed.encodeValue(
      _$AuditEventSchema.nameTimestamp,
      instance.timestamp,
      const AdaptiveDateTimeCodable(),
    );
    keyed.encodeString(_$AuditEventSchema.nameAction, instance.action);
  }
}
