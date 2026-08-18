// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tuple_example.dart';

// **************************************************************************
// CodableGenerator
// **************************************************************************

// =============================================================================
// 1. Unified Schema Descriptor for CoordinatePair
// =============================================================================
extension type const _$CoordinatePairSchema(int _value) {
  // String Name Constants
  static const String nameLocation = 'location';

  // Pre-Encoded UTF-8 Wire Bytes
  static final Uint8List nameLocationBytes = Uint8List.fromList(const [
    108,
    111,
    99,
    97,
    116,
    105,
    111,
    110,
  ]);

  // Key Indices for selectName()
  static const int keyLocation = 0;

  // Pre-Compiled JsonKeyOptions
  static final JsonKeyOptions options = JsonKeyOptions.of(const [
    _$CoordinatePairSchema.nameLocation,
  ]);

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
// 2. Single-Pass Streaming Deserializer for CoordinatePair
// =============================================================================
CoordinatePair _$CoordinatePairFromReader(JsonTokenReader reader) {
  reader.beginObject();

  Float64List? location;
  var seen = _$CoordinatePairSchema.none;

  while (reader.hasNext()) {
    switch (reader.selectName(_$CoordinatePairSchema.options)) {
      case _$CoordinatePairSchema.keyLocation:
        if (reader.isNextNull()) {
          reader.readNull();
          location = null;
        } else {
          reader.beginArray();
          final tuple = Float64List(2);
          var tupleIdx = 0;
          while (reader.hasNext()) {
            if (tupleIdx < 2) {
              tuple[tupleIdx++] = reader.readDouble();
            } else {
              reader.skipValue();
            }
          }
          reader.endArray();
          if (tupleIdx != 2) {
            throw CodableException(
              'Expected 2 elements for tuple "location", got $tupleIdx',
            );
          }
          location = tuple;
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

  return CoordinatePair(location: location);
}

// =============================================================================
// 3. Single-Pass Streaming Serializer for CoordinatePair
// =============================================================================
void _$CoordinatePairToWriter(CoordinatePair instance, JsonTokenWriter writer) {
  writer.beginObject();
  if (instance.location != null) {
    writer.writeNameBytes(_$CoordinatePairSchema.nameLocationBytes);
    writer.beginArray();
    writer.writeDouble(instance.location![0]);
    writer.writeDouble(instance.location![1]);
    writer.endArray();
  }
  writer.endObject();
}
