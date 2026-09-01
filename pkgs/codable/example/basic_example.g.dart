// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: lines_longer_than_80_chars, unnecessary_lambdas, deprecated_member_use, unused_element

part of 'basic_example.dart';

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
  static const String nameLastOrder = 'last-order';
  static const String nameOrders = 'orders';

  // Pre-encoded UTF-8 Wire Name Bytes and StaticKeys
  static const List<int> wireNameBytesFirstName = [
    34,
    102,
    105,
    114,
    115,
    116,
    78,
    97,
    109,
    101,
    34,
  ];
  static const StaticKey staticKeyFirstName = StaticKey(
    nameFirstName,
    keyFirstName,
    wireNameBytesFirstName,
  );
  static const List<int> wireNameBytesLastName = [
    34,
    108,
    97,
    115,
    116,
    78,
    97,
    109,
    101,
    34,
  ];
  static const StaticKey staticKeyLastName = StaticKey(
    nameLastName,
    keyLastName,
    wireNameBytesLastName,
  );
  static const List<int> wireNameBytesDateOfBirth = [
    34,
    100,
    97,
    116,
    101,
    45,
    111,
    102,
    45,
    98,
    105,
    114,
    116,
    104,
    34,
  ];
  static const StaticKey staticKeyDateOfBirth = StaticKey(
    nameDateOfBirth,
    keyDateOfBirth,
    wireNameBytesDateOfBirth,
  );
  static const List<int> wireNameBytesMiddleName = [
    34,
    109,
    105,
    100,
    100,
    108,
    101,
    78,
    97,
    109,
    101,
    34,
  ];
  static const StaticKey staticKeyMiddleName = StaticKey(
    nameMiddleName,
    keyMiddleName,
    wireNameBytesMiddleName,
  );
  static const List<int> wireNameBytesLastOrder = [
    34,
    108,
    97,
    115,
    116,
    45,
    111,
    114,
    100,
    101,
    114,
    34,
  ];
  static const StaticKey staticKeyLastOrder = StaticKey(
    nameLastOrder,
    keyLastOrder,
    wireNameBytesLastOrder,
  );
  static const List<int> wireNameBytesOrders = [
    34,
    111,
    114,
    100,
    101,
    114,
    115,
    34,
  ];
  static const StaticKey staticKeyOrders = StaticKey(
    nameOrders,
    keyOrders,
    wireNameBytesOrders,
  );

  // Key Indices for selectKeyIndex()
  static const int keyFirstName = 0;
  static const int keyLastName = 1;
  static const int keyDateOfBirth = 2;
  static const int aliasKeyDateOfBirthDob = 3;
  static const int keyMiddleName = 4;
  static const int keyLastOrder = 5;
  static const int keyOrders = 6;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
    _$PersonSchema.nameFirstName,
    _$PersonSchema.nameLastName,
    _$PersonSchema.nameDateOfBirth,
    _$PersonSchema.aliasDateOfBirthDob,
    _$PersonSchema.nameMiddleName,
    _$PersonSchema.nameLastOrder,
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
// 2. Universal Keyed Deserializer for Person
// =============================================================================
Person _$PersonFromDecoder(Decoder decoder) {
  final keyed = decoder.keyed(options: _$PersonSchema.keyOptions);

  String? firstName;
  String? lastName;
  DateTime? dateOfBirth;
  String? middleName;
  DateTime? lastOrder;
  var orders = const <Order>[];
  var seen = _$PersonSchema.none;

  while (keyed.hasNextKey()) {
    switch (keyed.selectKeyIndex(_$PersonSchema.keyOptions)) {
      case _$PersonSchema.keyFirstName:
        if ((seen._value & _$PersonSchema.firstName._value) != 0) {
          throw const CodableException('Duplicate field "firstName"');
        }
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          firstName = keyed.readString();
          seen |= _$PersonSchema.firstName;
        }
        break;
      case _$PersonSchema.keyLastName:
        if ((seen._value & _$PersonSchema.lastName._value) != 0) {
          throw const CodableException('Duplicate field "lastName"');
        }
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          lastName = keyed.readString();
          seen |= _$PersonSchema.lastName;
        }
        break;
      case _$PersonSchema.keyDateOfBirth:
      case _$PersonSchema.aliasKeyDateOfBirthDob:
        if ((seen._value & _$PersonSchema.dateOfBirth._value) != 0) {
          throw const CodableException('Duplicate field "date-of-birth"');
        }
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          dateOfBirth = keyed.decodeValue(const DateTimeIsoDecoder().decode);
          seen |= _$PersonSchema.dateOfBirth;
        }
        break;
      case _$PersonSchema.keyMiddleName:
        if (keyed.isNextNull()) {
          keyed.readNull();
          middleName = null;
        } else {
          middleName = keyed.readString();
        }
        break;
      case _$PersonSchema.keyLastOrder:
        if (keyed.isNextNull()) {
          keyed.readNull();
          lastOrder = null;
        } else {
          lastOrder = keyed.decodeValue(const DateTimeIsoDecoder().decode);
        }
        break;
      case _$PersonSchema.keyOrders:
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          orders = _$OrderListFromDecoder(keyed.nestedDecoder());
        }
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
    lastOrder: lastOrder,
    orders: orders,
  );
}

// =============================================================================
// 2b. Universal List Deserializer for Person
// =============================================================================
List<Person> _$PersonListFromDecoder(Decoder decoder) {
  final unkeyed = decoder.unkeyed();
  final list = <Person>[];
  while (unkeyed.hasNext()) {
    list.add(_$PersonFromDecoder(unkeyed.nestedDecoder()));
  }
  return list;
}

// =============================================================================
// 3. Universal Serializer for Person
// =============================================================================
void _$PersonToEncoder(Person instance, Encoder encoder) {
  final keyed = encoder.keyed();
  keyed.encodeStringKey(_$PersonSchema.staticKeyFirstName, instance.firstName);
  keyed.encodeStringKey(_$PersonSchema.staticKeyLastName, instance.lastName);
  keyed.encodeValueKey(
    _$PersonSchema.staticKeyDateOfBirth,
    instance.dateOfBirth,
    (v, e) => const DateTimeIsoDecoder().encodeToEncoder(v, e),
  );
  if (instance.middleName != null) {
    keyed.encodeStringKey(
      _$PersonSchema.staticKeyMiddleName,
      instance.middleName!,
    );
  }
  if (instance.lastOrder != null) {
    keyed.encodeValueKey(
      _$PersonSchema.staticKeyLastOrder,
      instance.lastOrder!,
      (v, e) => const DateTimeIsoDecoder().encodeToEncoder(v, e),
    );
  }
  keyed.encodeListKey(
    _$PersonSchema.staticKeyOrders,
    instance.orders,
    _$OrderToEncoder,
  );
}

// =============================================================================
// 1. Unified Schema Descriptor for Order
// =============================================================================
extension type const _$OrderSchema(int _value) {
  // String Name Constants
  static const String nameDateUs = 'dateUs';
  static const String nameCount = 'count';
  static const String nameItemNumber = 'itemNumber';
  static const String nameIsRushed = 'isRushed';
  static const String nameItem = 'item';
  static const String namePrepTimeMs = 'prepTimeMs';

  // Pre-encoded UTF-8 Wire Name Bytes and StaticKeys
  static const List<int> wireNameBytesDateUs = [
    34,
    100,
    97,
    116,
    101,
    85,
    115,
    34,
  ];
  static const StaticKey staticKeyDateUs = StaticKey(
    nameDateUs,
    keyDateUs,
    wireNameBytesDateUs,
  );
  static const List<int> wireNameBytesCount = [34, 99, 111, 117, 110, 116, 34];
  static const StaticKey staticKeyCount = StaticKey(
    nameCount,
    keyCount,
    wireNameBytesCount,
  );
  static const List<int> wireNameBytesItemNumber = [
    34,
    105,
    116,
    101,
    109,
    78,
    117,
    109,
    98,
    101,
    114,
    34,
  ];
  static const StaticKey staticKeyItemNumber = StaticKey(
    nameItemNumber,
    keyItemNumber,
    wireNameBytesItemNumber,
  );
  static const List<int> wireNameBytesIsRushed = [
    34,
    105,
    115,
    82,
    117,
    115,
    104,
    101,
    100,
    34,
  ];
  static const StaticKey staticKeyIsRushed = StaticKey(
    nameIsRushed,
    keyIsRushed,
    wireNameBytesIsRushed,
  );
  static const List<int> wireNameBytesItem = [34, 105, 116, 101, 109, 34];
  static const StaticKey staticKeyItem = StaticKey(
    nameItem,
    keyItem,
    wireNameBytesItem,
  );
  static const List<int> wireNameBytesPrepTimeMs = [
    34,
    112,
    114,
    101,
    112,
    84,
    105,
    109,
    101,
    77,
    115,
    34,
  ];
  static const StaticKey staticKeyPrepTimeMs = StaticKey(
    namePrepTimeMs,
    keyPrepTimeMs,
    wireNameBytesPrepTimeMs,
  );

  // Key Indices for selectKeyIndex()
  static const int keyDateUs = 0;
  static const int keyCount = 1;
  static const int keyItemNumber = 2;
  static const int keyIsRushed = 3;
  static const int keyItem = 4;
  static const int keyPrepTimeMs = 5;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
    _$OrderSchema.nameDateUs,
    _$OrderSchema.nameCount,
    _$OrderSchema.nameItemNumber,
    _$OrderSchema.nameIsRushed,
    _$OrderSchema.nameItem,
    _$OrderSchema.namePrepTimeMs,
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
// 2. Universal Keyed Deserializer for Order
// =============================================================================
Order _$OrderFromDecoder(Decoder decoder) {
  final keyed = decoder.keyed(options: _$OrderSchema.keyOptions);

  int? dateUs;
  int? count;
  int? itemNumber;
  bool? isRushed;
  Item? item;
  int? prepTimeMs;
  var seen = _$OrderSchema.none;

  while (keyed.hasNextKey()) {
    switch (keyed.selectKeyIndex(_$OrderSchema.keyOptions)) {
      case _$OrderSchema.keyDateUs:
        if ((seen._value & _$OrderSchema.dateUs._value) != 0) {
          throw const CodableException('Duplicate field "dateUs"');
        }
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          dateUs = keyed.readInt();
          seen |= _$OrderSchema.dateUs;
        }
        break;
      case _$OrderSchema.keyCount:
        if (keyed.isNextNull()) {
          keyed.readNull();
          count = null;
        } else {
          count = keyed.readInt();
        }
        break;
      case _$OrderSchema.keyItemNumber:
        if (keyed.isNextNull()) {
          keyed.readNull();
          itemNumber = null;
        } else {
          itemNumber = keyed.readInt();
        }
        break;
      case _$OrderSchema.keyIsRushed:
        if (keyed.isNextNull()) {
          keyed.readNull();
          isRushed = null;
        } else {
          isRushed = keyed.readBool();
        }
        break;
      case _$OrderSchema.keyItem:
        if (keyed.isNextNull()) {
          keyed.readNull();
          item = null;
        } else {
          item = _$ItemFromDecoder(keyed.nestedDecoder());
        }
        break;
      case _$OrderSchema.keyPrepTimeMs:
        if (keyed.isNextNull()) {
          keyed.readNull();
          prepTimeMs = null;
        } else {
          prepTimeMs = keyed.readInt();
        }
        break;
      default:
        keyed.skipValue();
        break;
    }
  }

  // Inlined fast-path check
  seen.validate();

  return Order(
    dateUs: dateUs!,
    count: count,
    itemNumber: itemNumber,
    isRushed: isRushed,
    item: item,
    prepTimeMs: prepTimeMs,
  );
}

// =============================================================================
// 2b. Universal List Deserializer for Order
// =============================================================================
List<Order> _$OrderListFromDecoder(Decoder decoder) {
  final unkeyed = decoder.unkeyed();
  final list = <Order>[];
  while (unkeyed.hasNext()) {
    list.add(_$OrderFromDecoder(unkeyed.nestedDecoder()));
  }
  return list;
}

// =============================================================================
// 3. Universal Serializer for Order
// =============================================================================
void _$OrderToEncoder(Order instance, Encoder encoder) {
  final keyed = encoder.keyed();
  keyed.encodeIntKey(_$OrderSchema.staticKeyDateUs, instance.dateUs);
  if (instance.count != null) {
    keyed.encodeIntKey(_$OrderSchema.staticKeyCount, instance.count!);
  }
  if (instance.itemNumber != null) {
    keyed.encodeIntKey(_$OrderSchema.staticKeyItemNumber, instance.itemNumber!);
  }
  if (instance.isRushed != null) {
    keyed.encodeBoolKey(_$OrderSchema.staticKeyIsRushed, instance.isRushed!);
  }
  if (instance.item != null) {
    keyed.encodeValueKey(
      _$OrderSchema.staticKeyItem,
      instance.item!,
      _$ItemToEncoder,
    );
  }
  if (instance.prepTimeMs != null) {
    keyed.encodeIntKey(_$OrderSchema.staticKeyPrepTimeMs, instance.prepTimeMs!);
  }
}

// =============================================================================
// 1. Unified Schema Descriptor for Item
// =============================================================================
extension type const _$ItemSchema(int _value) {
  // String Name Constants
  static const String nameCount = 'count';
  static const String nameItemNumber = 'itemNumber';
  static const String nameIsRushed = 'isRushed';

  // Pre-encoded UTF-8 Wire Name Bytes and StaticKeys
  static const List<int> wireNameBytesCount = [34, 99, 111, 117, 110, 116, 34];
  static const StaticKey staticKeyCount = StaticKey(
    nameCount,
    keyCount,
    wireNameBytesCount,
  );
  static const List<int> wireNameBytesItemNumber = [
    34,
    105,
    116,
    101,
    109,
    78,
    117,
    109,
    98,
    101,
    114,
    34,
  ];
  static const StaticKey staticKeyItemNumber = StaticKey(
    nameItemNumber,
    keyItemNumber,
    wireNameBytesItemNumber,
  );
  static const List<int> wireNameBytesIsRushed = [
    34,
    105,
    115,
    82,
    117,
    115,
    104,
    101,
    100,
    34,
  ];
  static const StaticKey staticKeyIsRushed = StaticKey(
    nameIsRushed,
    keyIsRushed,
    wireNameBytesIsRushed,
  );

  // Key Indices for selectKeyIndex()
  static const int keyCount = 0;
  static const int keyItemNumber = 1;
  static const int keyIsRushed = 2;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
    _$ItemSchema.nameCount,
    _$ItemSchema.nameItemNumber,
    _$ItemSchema.nameIsRushed,
  ]);
  static final KeyOptions keyOptions = options;

  // Bitmask Flags strictly for Required Fields
  static const _$ItemSchema none = _$ItemSchema(0);

  @pragma('vm:prefer-inline')
  _$ItemSchema operator |(_$ItemSchema other) =>
      _$ItemSchema(_value | other._value);

  /// Validates required fields in 1 CPU test instruction on the fast path.
  @pragma('vm:prefer-inline')
  void validate() {}
}

// =============================================================================
// 2. Universal Keyed Deserializer for Item
// =============================================================================
Item _$ItemFromDecoder(Decoder decoder) {
  final keyed = decoder.keyed(options: _$ItemSchema.keyOptions);

  int? count;
  int? itemNumber;
  bool? isRushed;
  var seen = _$ItemSchema.none;

  while (keyed.hasNextKey()) {
    switch (keyed.selectKeyIndex(_$ItemSchema.keyOptions)) {
      case _$ItemSchema.keyCount:
        if (keyed.isNextNull()) {
          keyed.readNull();
          count = null;
        } else {
          count = keyed.readInt();
        }
        break;
      case _$ItemSchema.keyItemNumber:
        if (keyed.isNextNull()) {
          keyed.readNull();
          itemNumber = null;
        } else {
          itemNumber = keyed.readInt();
        }
        break;
      case _$ItemSchema.keyIsRushed:
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

  return Item(count: count, itemNumber: itemNumber, isRushed: isRushed);
}

// =============================================================================
// 2b. Universal List Deserializer for Item
// =============================================================================
List<Item> _$ItemListFromDecoder(Decoder decoder) {
  final unkeyed = decoder.unkeyed();
  final list = <Item>[];
  while (unkeyed.hasNext()) {
    list.add(_$ItemFromDecoder(unkeyed.nestedDecoder()));
  }
  return list;
}

// =============================================================================
// 3. Universal Serializer for Item
// =============================================================================
void _$ItemToEncoder(Item instance, Encoder encoder) {
  final keyed = encoder.keyed();
  if (instance.count != null) {
    keyed.encodeIntKey(_$ItemSchema.staticKeyCount, instance.count!);
  }
  if (instance.itemNumber != null) {
    keyed.encodeIntKey(_$ItemSchema.staticKeyItemNumber, instance.itemNumber!);
  }
  if (instance.isRushed != null) {
    keyed.encodeBoolKey(_$ItemSchema.staticKeyIsRushed, instance.isRushed!);
  }
}
