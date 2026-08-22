// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: lines_longer_than_80_chars, unnecessary_lambdas, deprecated_member_use, unused_element

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

  // Pre-encoded UTF-8 Wire Name Bytes and StaticKeys
  static const List<int> wireNameBytesWhen = [34, 119, 104, 101, 110, 34];
  static const StaticKey staticKeyWhen = StaticKey(
    nameWhen,
    keyWhen,
    wireNameBytesWhen,
  );

  // Key Indices for selectKeyIndex()
  static const int keyWhen = 0;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
    _$DateTimeExampleSchema.nameWhen,
  ]);
  static final KeyOptions keyOptions = options;

  // Bitmask Flags strictly for Required Fields
  static const _$DateTimeExampleSchema none = _$DateTimeExampleSchema(0);
  static const int _whenBit = 1 << 0;
  static const _$DateTimeExampleSchema when = _$DateTimeExampleSchema(_whenBit);

  // Combined Golden Bitmask for fast single-instruction check
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
// 2. Universal Keyed Deserializer for DateTimeExample
// =============================================================================
DateTimeExample _$DateTimeExampleFromDecoder(Decoder decoder) {
  final keyed = decoder.keyed(options: _$DateTimeExampleSchema.keyOptions);

  DateTime? when;
  var seen = _$DateTimeExampleSchema.none;

  while (keyed.hasNextKey()) {
    switch (keyed.selectKeyIndex(_$DateTimeExampleSchema.keyOptions)) {
      case _$DateTimeExampleSchema.keyWhen:
        if ((seen._value & _$DateTimeExampleSchema.when._value) != 0) {
          throw const CodableException('Duplicate field "when"');
        }
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          when = keyed.decodeValue(const DateTimeEpochDecoder().decode);
          seen |= _$DateTimeExampleSchema.when;
        }
        break;
      default:
        keyed.skipValue();
        break;
    }
  }

  // Inlined fast-path check
  seen.validate();

  return DateTimeExample(when!);
}

// =============================================================================
// 3. Universal Serializer for DateTimeExample
// =============================================================================
void _$DateTimeExampleToEncoder(DateTimeExample instance, Encoder encoder) {
  final keyed = encoder.keyed();
  keyed.encodeValueKey(
    _$DateTimeExampleSchema.staticKeyWhen,
    instance.when,
    (v, e) => const DateTimeEpochDecoder().encodeToEncoder(v, e),
  );
}
