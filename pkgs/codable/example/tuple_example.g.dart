// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: lines_longer_than_80_chars, unnecessary_lambdas, deprecated_member_use, unused_element

part of 'tuple_example.dart';

// =============================================================================
// 1. Unified Schema Descriptor for CoordinatePair
// =============================================================================
extension type const _$CoordinatePairSchema(int _value) {
  // String Name Constants
  static const String nameLocation = 'location';

  // Pre-encoded UTF-8 Wire Name Bytes and StaticKeys
  static const List<int> wireNameBytesLocation = [
    34,
    108,
    111,
    99,
    97,
    116,
    105,
    111,
    110,
    34,
  ];
  static const StaticKey staticKeyLocation = StaticKey(
    nameLocation,
    keyLocation,
    wireNameBytesLocation,
  );

  // Key Indices for selectKeyIndex()
  static const int keyLocation = 0;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
    _$CoordinatePairSchema.nameLocation,
  ]);
  static final KeyOptions keyOptions = options;

  // Bitmask Flags strictly for Required Fields
  static const _$CoordinatePairSchema none = _$CoordinatePairSchema(0);

  @pragma('vm:prefer-inline')
  _$CoordinatePairSchema operator |(_$CoordinatePairSchema other) =>
      _$CoordinatePairSchema(_value | other._value);

  /// Validates required fields in 1 CPU test instruction on the fast path.
  @pragma('vm:prefer-inline')
  void validate() {}
}

// =============================================================================
// 2. Universal Keyed Deserializer for CoordinatePair
// =============================================================================
CoordinatePair _$CoordinatePairFromDecoder(Decoder decoder) {
  final keyed = decoder.keyed(options: _$CoordinatePairSchema.keyOptions);

  Float64List? location;
  var seen = _$CoordinatePairSchema.none;

  while (keyed.hasNextKey()) {
    switch (keyed.selectKeyIndex(_$CoordinatePairSchema.keyOptions)) {
      case _$CoordinatePairSchema.keyLocation:
        if (keyed.isNextNull()) {
          keyed.readNull();
          location = null;
        } else {
          location = keyed.decodeFloat64List();
        }
        break;
      default:
        keyed.skipValue();
        break;
    }
  }

  // Inlined fast-path check
  seen.validate();

  return CoordinatePair(location: location);
}

// =============================================================================
// 2b. Universal List Deserializer for CoordinatePair
// =============================================================================
List<CoordinatePair> _$CoordinatePairListFromDecoder(Decoder decoder) {
  final unkeyed = decoder.unkeyed();
  final list = <CoordinatePair>[];
  while (unkeyed.hasNext()) {
    list.add(_$CoordinatePairFromDecoder(unkeyed.nestedDecoder()));
  }
  return list;
}

// =============================================================================
// 3. Universal Serializer for CoordinatePair
// =============================================================================
void _$CoordinatePairToEncoder(CoordinatePair instance, Encoder encoder) {
  final keyed = encoder.keyed();
  if (instance.location != null) {
    keyed.encodeListKey<double>(
      _$CoordinatePairSchema.staticKeyLocation,
      List.generate(2, (i) => instance.location![i]),
      (v, e) => e.singleValue().encodeDouble(v),
    );
  }
}
