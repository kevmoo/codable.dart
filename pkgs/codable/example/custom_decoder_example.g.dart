// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_decoder_example.dart';

// **************************************************************************
// CodableGenerator
// **************************************************************************

// =============================================================================
// 1. Unified Schema Descriptor for DateTimeExample
// =============================================================================
extension type const _$DateTimeExampleSchema(int _value) {
  // String Name Constants
  static const String nameWhen = 'when';

  // Pre-Encoded UTF-8 Wire Bytes
  static final Uint8List nameWhenBytes = Uint8List.fromList(const [
    119,
    104,
    101,
    110,
  ]);

  // Key Indices for selectName()
  static const int keyWhen = 0;

  // Pre-Compiled JsonKeyOptions
  static final JsonKeyOptions options = JsonKeyOptions.of(const [
    _$DateTimeExampleSchema.nameWhen,
  ]);

  // Bitmask Flags strictly for Required Fields
  static const _$DateTimeExampleSchema none = _$DateTimeExampleSchema(0);
  static const int _whenBit = 1 << 0;
  static const _$DateTimeExampleSchema when = _$DateTimeExampleSchema(_whenBit);

  // Composite Golden Mask for Required Fields
  static const _$DateTimeExampleSchema golden = _$DateTimeExampleSchema(
    _whenBit,
  );

  @pragma('vm:prefer-inline')
  _$DateTimeExampleSchema operator |(_$DateTimeExampleSchema other) =>
      _$DateTimeExampleSchema(_value | other._value);

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
    if ((_value & _whenBit) == 0) {
      missing.add(nameWhen);
    }
    throw CodableException(
      'Missing required fields for DateTimeExample: ${missing.join(", ")}',
    );
  }
}

// =============================================================================
// 2. Single-Pass Streaming Deserializer for DateTimeExample
// =============================================================================
DateTimeExample _$DateTimeExampleFromReader(JsonTokenReader reader) {
  reader.beginObject();

  DateTime? when;
  var seen = _$DateTimeExampleSchema.none;

  while (reader.hasNext()) {
    switch (reader.selectName(_$DateTimeExampleSchema.options)) {
      case _$DateTimeExampleSchema.keyWhen:
        if ((seen._value & _$DateTimeExampleSchema.when._value) != 0) {
          throw CodableException('Duplicate field "when"');
        }
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          when = const DateTimeEpochDecoder().decodeFromReader(reader);
          seen |= _$DateTimeExampleSchema.when;
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

  return DateTimeExample(when!);
}

// =============================================================================
// 3. Single-Pass Streaming Serializer for DateTimeExample
// =============================================================================
void _$DateTimeExampleToWriter(
  DateTimeExample instance,
  JsonTokenWriter writer,
) {
  writer.beginObject();
  writer.writeNameBytes(_$DateTimeExampleSchema.nameWhenBytes);
  const DateTimeEpochDecoder().encodeToWriter(instance.when, writer);
  writer.endObject();
}

// =============================================================================
// 1. Unified Schema Descriptor for CustomResult
// =============================================================================
extension type const _$CustomResultSchema(int _value) {
  // String Name Constants
  static const String nameName = 'name';
  static const String nameSize = 'size';

  // Pre-Encoded UTF-8 Wire Bytes
  static final Uint8List nameNameBytes = Uint8List.fromList(const [
    110,
    97,
    109,
    101,
  ]);
  static final Uint8List nameSizeBytes = Uint8List.fromList(const [
    115,
    105,
    122,
    101,
  ]);

  // Key Indices for selectName()
  static const int keyName = 0;
  static const int keySize = 1;

  // Pre-Compiled JsonKeyOptions
  static final JsonKeyOptions options = JsonKeyOptions.of(const [
    _$CustomResultSchema.nameName,
    _$CustomResultSchema.nameSize,
  ]);

  // Bitmask Flags strictly for Required Fields
  static const _$CustomResultSchema none = _$CustomResultSchema(0);
  static const int _nameBit = 1 << 0;
  static const _$CustomResultSchema name = _$CustomResultSchema(_nameBit);
  static const int _sizeBit = 1 << 1;
  static const _$CustomResultSchema size = _$CustomResultSchema(_sizeBit);

  // Composite Golden Mask for Required Fields
  static const _$CustomResultSchema golden = _$CustomResultSchema(
    _nameBit | _sizeBit,
  );

  @pragma('vm:prefer-inline')
  _$CustomResultSchema operator |(_$CustomResultSchema other) =>
      _$CustomResultSchema(_value | other._value);

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
    if ((_value & _nameBit) == 0) {
      missing.add(nameName);
    }
    if ((_value & _sizeBit) == 0) {
      missing.add(nameSize);
    }
    throw CodableException(
      'Missing required fields for CustomResult: ${missing.join(", ")}',
    );
  }
}

// =============================================================================
// 2. Single-Pass Streaming Deserializer for CustomResult
// =============================================================================
CustomResult _$CustomResultFromReader(JsonTokenReader reader) {
  reader.beginObject();

  String? name;
  int? size;
  var seen = _$CustomResultSchema.none;

  while (reader.hasNext()) {
    switch (reader.selectName(_$CustomResultSchema.options)) {
      case _$CustomResultSchema.keyName:
        if ((seen._value & _$CustomResultSchema.name._value) != 0) {
          throw CodableException('Duplicate field "name"');
        }
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          name = reader.readString();
          seen |= _$CustomResultSchema.name;
        }
        break;
      case _$CustomResultSchema.keySize:
        if ((seen._value & _$CustomResultSchema.size._value) != 0) {
          throw CodableException('Duplicate field "size"');
        }
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          size = reader.readInt();
          seen |= _$CustomResultSchema.size;
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

  return CustomResult(name!, size!);
}

// =============================================================================
// 3. Single-Pass Streaming Serializer for CustomResult
// =============================================================================
void _$CustomResultToWriter(CustomResult instance, JsonTokenWriter writer) {
  writer.beginObject();
  writer.writeNameBytes(_$CustomResultSchema.nameNameBytes);
  writer.writeString(instance.name);
  writer.writeNameBytes(_$CustomResultSchema.nameSizeBytes);
  writer.writeInt(instance.size);
  writer.endObject();
}
