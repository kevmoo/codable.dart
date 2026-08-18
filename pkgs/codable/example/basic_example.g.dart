// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: lines_longer_than_80_chars

part of 'basic_example.dart';

// **************************************************************************
// CodableGenerator
// **************************************************************************

// =============================================================================
// 1. Unified Schema Descriptor for Person
// =============================================================================
extension type const _$PersonSchema(int _value) {
  // String Name Constants
  static const String nameFirstName = 'firstName';
  static const String nameLastName = 'lastName';
  static const String nameDateOfBirth = 'date-of-birth';
  static const String nameMiddleName = 'middleName';
  static const String nameLastOrder = 'last-order';
  static const String nameOrders = 'orders';

  // Pre-Encoded UTF-8 Wire Bytes
  static final Uint8List nameFirstNameBytes = Uint8List.fromList(const [
    102,
    105,
    114,
    115,
    116,
    78,
    97,
    109,
    101,
  ]);
  static final Uint8List nameLastNameBytes = Uint8List.fromList(const [
    108,
    97,
    115,
    116,
    78,
    97,
    109,
    101,
  ]);
  static final Uint8List nameDateOfBirthBytes = Uint8List.fromList(const [
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
  ]);
  static final Uint8List nameMiddleNameBytes = Uint8List.fromList(const [
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
  ]);
  static final Uint8List nameLastOrderBytes = Uint8List.fromList(const [
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
  ]);
  static final Uint8List nameOrdersBytes = Uint8List.fromList(const [
    111,
    114,
    100,
    101,
    114,
    115,
  ]);

  // Key Indices for selectName()
  static const int keyFirstName = 0;
  static const int keyLastName = 1;
  static const int keyDateOfBirth = 2;
  static const String aliasDateOfBirthDob = 'dob';
  static const int aliasKeyDateOfBirthDob = 3;
  static const int keyMiddleName = 4;
  static const int keyLastOrder = 5;
  static const int keyOrders = 6;

  // Pre-Compiled JsonKeyOptions
  static final JsonKeyOptions options = JsonKeyOptions.of(const [
    _$PersonSchema.nameFirstName,
    _$PersonSchema.nameLastName,
    _$PersonSchema.nameDateOfBirth,
    _$PersonSchema.aliasDateOfBirthDob,
    _$PersonSchema.nameMiddleName,
    _$PersonSchema.nameLastOrder,
    _$PersonSchema.nameOrders,
  ]);

  // Bitmask Flags strictly for Required Fields
  static const _$PersonSchema none = _$PersonSchema(0);
  static const int _firstNameBit = 1 << 0;
  static const _$PersonSchema firstName = _$PersonSchema(_firstNameBit);
  static const int _lastNameBit = 1 << 1;
  static const _$PersonSchema lastName = _$PersonSchema(_lastNameBit);
  static const int _dateOfBirthBit = 1 << 2;
  static const _$PersonSchema dateOfBirth = _$PersonSchema(_dateOfBirthBit);

  // Composite Golden Mask for Required Fields
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
// 2. Single-Pass Streaming Deserializer for Person
// =============================================================================
Person _$PersonFromReader(JsonTokenReader reader) {
  reader.beginObject();

  String? firstName;
  String? lastName;
  DateTime? dateOfBirth;
  String? middleName;
  DateTime? lastOrder;
  var orders = const <Order>[];
  var seen = _$PersonSchema.none;

  while (reader.hasNext()) {
    switch (reader.selectName(_$PersonSchema.options)) {
      case _$PersonSchema.keyFirstName:
        if ((seen._value & _$PersonSchema.firstName._value) != 0) {
          throw const CodableException('Duplicate field "firstName"');
        }
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          firstName = reader.readString();
          seen |= _$PersonSchema.firstName;
        }
        break;
      case _$PersonSchema.keyLastName:
        if ((seen._value & _$PersonSchema.lastName._value) != 0) {
          throw const CodableException('Duplicate field "lastName"');
        }
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          lastName = reader.readString();
          seen |= _$PersonSchema.lastName;
        }
        break;
      case _$PersonSchema.keyDateOfBirth:
      case _$PersonSchema.aliasKeyDateOfBirthDob:
        if ((seen._value & _$PersonSchema.dateOfBirth._value) != 0) {
          throw const CodableException('Duplicate field "date-of-birth"');
        }
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          dateOfBirth = const DateTimeIsoDecoder().decodeFromReader(reader);
          seen |= _$PersonSchema.dateOfBirth;
        }
        break;
      case _$PersonSchema.keyMiddleName:
        if (reader.isNextNull()) {
          reader.readNull();
          middleName = null;
        } else {
          middleName = reader.readString();
        }
        break;
      case _$PersonSchema.keyLastOrder:
        if (reader.isNextNull()) {
          reader.readNull();
          lastOrder = null;
        } else {
          lastOrder = const DateTimeIsoDecoder().decodeFromReader(reader);
        }
        break;
      case _$PersonSchema.keyOrders:
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          reader.beginArray();
          final list = <Order>[];
          while (reader.hasNext()) {
            list.add(_$OrderFromReader(reader));
          }
          reader.endArray();
          orders = list;
        }
        break;
      default:
        reader.skipValue();
        break;
    }
  }
  reader.endObject();

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
// 3. Single-Pass Streaming Serializer for Person
// =============================================================================
void _$PersonToWriter(Person instance, JsonTokenWriter writer) {
  writer.beginObject();
  writer.writeNameBytes(_$PersonSchema.nameFirstNameBytes);
  writer.writeString(instance.firstName);
  writer.writeNameBytes(_$PersonSchema.nameLastNameBytes);
  writer.writeString(instance.lastName);
  writer.writeNameBytes(_$PersonSchema.nameDateOfBirthBytes);
  const DateTimeIsoDecoder().encodeToWriter(instance.dateOfBirth, writer);
  if (instance.middleName != null) {
    writer.writeNameBytes(_$PersonSchema.nameMiddleNameBytes);
    writer.writeString(instance.middleName!);
  }
  if (instance.lastOrder != null) {
    writer.writeNameBytes(_$PersonSchema.nameLastOrderBytes);
    const DateTimeIsoDecoder().encodeToWriter(instance.lastOrder!, writer);
  }
  writer.writeNameBytes(_$PersonSchema.nameOrdersBytes);
  writer.beginArray();
  for (final item in instance.orders) {
    _$OrderToWriter(item, writer);
  }
  writer.endArray();
  writer.endObject();
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

  // Pre-Encoded UTF-8 Wire Bytes
  static final Uint8List nameDateUsBytes = Uint8List.fromList(const [
    100,
    97,
    116,
    101,
    85,
    115,
  ]);
  static final Uint8List nameCountBytes = Uint8List.fromList(const [
    99,
    111,
    117,
    110,
    116,
  ]);
  static final Uint8List nameItemNumberBytes = Uint8List.fromList(const [
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
  ]);
  static final Uint8List nameIsRushedBytes = Uint8List.fromList(const [
    105,
    115,
    82,
    117,
    115,
    104,
    101,
    100,
  ]);
  static final Uint8List nameItemBytes = Uint8List.fromList(const [
    105,
    116,
    101,
    109,
  ]);
  static final Uint8List namePrepTimeMsBytes = Uint8List.fromList(const [
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
  ]);

  // Key Indices for selectName()
  static const int keyDateUs = 0;
  static const int keyCount = 1;
  static const int keyItemNumber = 2;
  static const int keyIsRushed = 3;
  static const int keyItem = 4;
  static const int keyPrepTimeMs = 5;

  // Pre-Compiled JsonKeyOptions
  static final JsonKeyOptions options = JsonKeyOptions.of(const [
    _$OrderSchema.nameDateUs,
    _$OrderSchema.nameCount,
    _$OrderSchema.nameItemNumber,
    _$OrderSchema.nameIsRushed,
    _$OrderSchema.nameItem,
    _$OrderSchema.namePrepTimeMs,
  ]);

  // Bitmask Flags strictly for Required Fields
  static const _$OrderSchema none = _$OrderSchema(0);
  static const int _dateUsBit = 1 << 0;
  static const _$OrderSchema dateUs = _$OrderSchema(_dateUsBit);

  // Composite Golden Mask for Required Fields
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
// 2. Single-Pass Streaming Deserializer for Order
// =============================================================================
Order _$OrderFromReader(JsonTokenReader reader) {
  reader.beginObject();

  int? dateUs;
  int? count;
  int? itemNumber;
  bool? isRushed;
  Item? item;
  int? prepTimeMs;
  var seen = _$OrderSchema.none;

  while (reader.hasNext()) {
    switch (reader.selectName(_$OrderSchema.options)) {
      case _$OrderSchema.keyDateUs:
        if ((seen._value & _$OrderSchema.dateUs._value) != 0) {
          throw const CodableException('Duplicate field "dateUs"');
        }
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          dateUs = reader.readInt();
          seen |= _$OrderSchema.dateUs;
        }
        break;
      case _$OrderSchema.keyCount:
        if (reader.isNextNull()) {
          reader.readNull();
          count = null;
        } else {
          count = reader.readInt();
        }
        break;
      case _$OrderSchema.keyItemNumber:
        if (reader.isNextNull()) {
          reader.readNull();
          itemNumber = null;
        } else {
          itemNumber = reader.readInt();
        }
        break;
      case _$OrderSchema.keyIsRushed:
        if (reader.isNextNull()) {
          reader.readNull();
          isRushed = null;
        } else {
          isRushed = reader.readBool();
        }
        break;
      case _$OrderSchema.keyItem:
        if (reader.isNextNull()) {
          reader.readNull();
          item = null;
        } else {
          item = _$ItemFromReader(reader);
        }
        break;
      case _$OrderSchema.keyPrepTimeMs:
        if (reader.isNextNull()) {
          reader.readNull();
          prepTimeMs = null;
        } else {
          prepTimeMs = reader.readInt();
        }
        break;
      default:
        reader.skipValue();
        break;
    }
  }
  reader.endObject();

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
// 3. Single-Pass Streaming Serializer for Order
// =============================================================================
void _$OrderToWriter(Order instance, JsonTokenWriter writer) {
  writer.beginObject();
  writer.writeNameBytes(_$OrderSchema.nameDateUsBytes);
  writer.writeInt(instance.dateUs);
  if (instance.count != null) {
    writer.writeNameBytes(_$OrderSchema.nameCountBytes);
    writer.writeInt(instance.count!);
  }
  if (instance.itemNumber != null) {
    writer.writeNameBytes(_$OrderSchema.nameItemNumberBytes);
    writer.writeInt(instance.itemNumber!);
  }
  if (instance.isRushed != null) {
    writer.writeNameBytes(_$OrderSchema.nameIsRushedBytes);
    writer.writeBool(instance.isRushed!);
  }
  if (instance.item != null) {
    writer.writeNameBytes(_$OrderSchema.nameItemBytes);
    _$ItemToWriter(instance.item!, writer);
  }
  if (instance.prepTimeMs != null) {
    writer.writeNameBytes(_$OrderSchema.namePrepTimeMsBytes);
    writer.writeInt(instance.prepTimeMs!);
  }
  writer.endObject();
}

// =============================================================================
// 1. Unified Schema Descriptor for Item
// =============================================================================
extension type const _$ItemSchema(int _value) {
  // String Name Constants
  static const String nameCount = 'count';
  static const String nameItemNumber = 'itemNumber';
  static const String nameIsRushed = 'isRushed';

  // Pre-Encoded UTF-8 Wire Bytes
  static final Uint8List nameCountBytes = Uint8List.fromList(const [
    99,
    111,
    117,
    110,
    116,
  ]);
  static final Uint8List nameItemNumberBytes = Uint8List.fromList(const [
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
  ]);
  static final Uint8List nameIsRushedBytes = Uint8List.fromList(const [
    105,
    115,
    82,
    117,
    115,
    104,
    101,
    100,
  ]);

  // Key Indices for selectName()
  static const int keyCount = 0;
  static const int keyItemNumber = 1;
  static const int keyIsRushed = 2;

  // Pre-Compiled JsonKeyOptions
  static final JsonKeyOptions options = JsonKeyOptions.of(const [
    _$ItemSchema.nameCount,
    _$ItemSchema.nameItemNumber,
    _$ItemSchema.nameIsRushed,
  ]);

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
// 2. Single-Pass Streaming Deserializer for Item
// =============================================================================
Item _$ItemFromReader(JsonTokenReader reader) {
  reader.beginObject();

  int? count;
  int? itemNumber;
  bool? isRushed;
  var seen = _$ItemSchema.none;

  while (reader.hasNext()) {
    switch (reader.selectName(_$ItemSchema.options)) {
      case _$ItemSchema.keyCount:
        if (reader.isNextNull()) {
          reader.readNull();
          count = null;
        } else {
          count = reader.readInt();
        }
        break;
      case _$ItemSchema.keyItemNumber:
        if (reader.isNextNull()) {
          reader.readNull();
          itemNumber = null;
        } else {
          itemNumber = reader.readInt();
        }
        break;
      case _$ItemSchema.keyIsRushed:
        if (reader.isNextNull()) {
          reader.readNull();
          isRushed = null;
        } else {
          isRushed = reader.readBool();
        }
        break;
      default:
        reader.skipValue();
        break;
    }
  }
  reader.endObject();

  // Inlined fast-path check
  seen.validate();

  return Item(count: count, itemNumber: itemNumber, isRushed: isRushed);
}

// =============================================================================
// 3. Single-Pass Streaming Serializer for Item
// =============================================================================
void _$ItemToWriter(Item instance, JsonTokenWriter writer) {
  writer.beginObject();
  if (instance.count != null) {
    writer.writeNameBytes(_$ItemSchema.nameCountBytes);
    writer.writeInt(instance.count!);
  }
  if (instance.itemNumber != null) {
    writer.writeNameBytes(_$ItemSchema.nameItemNumberBytes);
    writer.writeInt(instance.itemNumber!);
  }
  if (instance.isRushed != null) {
    writer.writeNameBytes(_$ItemSchema.nameIsRushedBytes);
    writer.writeBool(instance.isRushed!);
  }
  writer.endObject();
}
