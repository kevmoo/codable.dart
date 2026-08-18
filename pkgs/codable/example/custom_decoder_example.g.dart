// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: lines_longer_than_80_chars

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
          throw const CodableException('Duplicate field "when"');
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
