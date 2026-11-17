// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: lines_longer_than_80_chars, unnecessary_lambdas, deprecated_member_use, unused_element

part of 'contract_bugfixes_test.dart';

// **************************************************************************
// CodableGenerator
// **************************************************************************

// ignore_for_file: omit_local_variable_types

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
// 1. Unified Schema Descriptor for GridCell
// =============================================================================
extension type const _$GridCellSchema(int _value) {
  // String Name Constants
  static const String nameRow = 'row';
  static const String nameCol = 'col';
  static const String nameLabel = 'label';

  // Key Indices for selectKeyIndex()
  static const int keyRow = 0;
  static const int keyCol = 1;
  static const int keyLabel = 2;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
    _$GridCellSchema.nameRow,
    _$GridCellSchema.nameCol,
    _$GridCellSchema.nameLabel,
  ]);
  static final KeyOptions keyOptions = options;

  // Bitmask Flags strictly for Required Fields
  static const _$GridCellSchema none = _$GridCellSchema(0);
  static const int _rowBit = 1 << 0;
  static const _$GridCellSchema row = _$GridCellSchema(_rowBit);
  static const int _colBit = 1 << 1;
  static const _$GridCellSchema col = _$GridCellSchema(_colBit);

  // Combined Golden Bitmask for fast single-instruction check
  static const _$GridCellSchema golden = _$GridCellSchema(_rowBit | _colBit);

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
    if ((_value & _rowBit) == 0) {
      missing.add(nameRow);
    }
    if ((_value & _colBit) == 0) {
      missing.add(nameCol);
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

    int? row;
    int? col;
    String label = '';
    var seen = _$GridCellSchema.none;

    while (keyed.moveNextKey()) {
      switch (keyed.selectKeyIndex(_$GridCellSchema.keyOptions)) {
        case _$GridCellSchema.keyRow:
          if ((seen._value & _$GridCellSchema.row._value) != 0) {
            throw const CodableException('Duplicate field "row"');
          }
          row = keyed.readInt();
          seen |= _$GridCellSchema.row;
          break;
        case _$GridCellSchema.keyCol:
          if ((seen._value & _$GridCellSchema.col._value) != 0) {
            throw const CodableException('Duplicate field "col"');
          }
          col = keyed.readInt();
          seen |= _$GridCellSchema.col;
          break;
        case _$GridCellSchema.keyLabel:
          label = keyed.readString();
          break;
        default:
          keyed.skipValue();
          break;
      }
    }

    // Inlined fast-path check
    seen.validate();

    return GridCell(row: row!, col: col!, label: label);
  }

  @override
  int encodedFieldCount(GridCell instance) => 3;

  @override
  void encodeFields(GridCell instance, KeyedEncoder keyed) {
    keyed.encodeInt(_$GridCellSchema.nameRow, instance.row);
    keyed.encodeInt(_$GridCellSchema.nameCol, instance.col);
    keyed.encodeString(_$GridCellSchema.nameLabel, instance.label);
  }

  @override
  void encode(GridCell instance, Encoder encoder) {
    encodeFields(instance, encoder.keyed(length: 3));
  }
}

// =============================================================================
// 1. Unified Schema Descriptor for GridBoard
// =============================================================================
extension type const _$GridBoardSchema(int _value) {
  // String Name Constants
  static const String nameCells = 'cells';
  static const String nameNullableRows = 'nullableRows';

  // Key Indices for selectKeyIndex()
  static const int keyCells = 0;
  static const int keyNullableRows = 1;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
    _$GridBoardSchema.nameCells,
    _$GridBoardSchema.nameNullableRows,
  ]);
  static final KeyOptions keyOptions = options;

  // Bitmask Flags strictly for Required Fields
  static const _$GridBoardSchema none = _$GridBoardSchema(0);

  @pragma('vm:prefer-inline')
  _$GridBoardSchema operator |(_$GridBoardSchema other) =>
      _$GridBoardSchema(_value | other._value);

  /// Validates required fields in 1 CPU test instruction on the fast path.
  @pragma('vm:prefer-inline')
  void validate() {}
}

// =============================================================================
// 2. Companion Codable for GridBoard
// =============================================================================
final class GridBoardCodable implements KeyedCodable<GridBoard> {
  const GridBoardCodable();

  @override
  GridBoard decode(Decoder decoder) {
    final keyed = decoder.keyed(options: _$GridBoardSchema.keyOptions);

    List<List<GridCell>> cells = const [];
    List<List<GridCell>?> nullableRows = const [];
    var seen = _$GridBoardSchema.none;

    while (keyed.moveNextKey()) {
      switch (keyed.selectKeyIndex(_$GridBoardSchema.keyOptions)) {
        case _$GridBoardSchema.keyCells:
          {
            final u = keyed.nestedDecoder().unkeyed();
            final l = <List<GridCell>>[];
            while (u.moveNext()) {
              l.add(u.decodeList(const GridCellCodable()));
            }
            cells = l;
          }
          break;
        case _$GridBoardSchema.keyNullableRows:
          {
            final u = keyed.nestedDecoder().unkeyed();
            final l = <List<GridCell>?>[];
            while (u.moveNext()) {
              l.add(u.decodeNullableList(const GridCellCodable()));
            }
            nullableRows = l;
          }
          break;
        default:
          keyed.skipValue();
          break;
      }
    }

    // Inlined fast-path check
    seen.validate();

    return GridBoard(cells: cells, nullableRows: nullableRows);
  }

  @override
  int encodedFieldCount(GridBoard instance) => 2;

  @override
  void encodeFields(GridBoard instance, KeyedEncoder keyed) {
    keyed.encodeList(
      _$GridBoardSchema.nameCells,
      instance.cells,
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
      _$GridBoardSchema.nameNullableRows,
      instance.nullableRows,
      Encodable.fromFunction((List<GridCell>? item, e) {
        if (item case final val0?) {
          {
            final u1 = e.unkeyed(length: val0.length);
            for (final elem1 in val0) {
              const GridCellCodable().encode(elem1, u1.nestedEncoder());
            }
          }
        } else {
          e.singleValue().encodeNull();
        }
      }),
    );
  }

  @override
  void encode(GridBoard instance, Encoder encoder) {
    encodeFields(instance, encoder.keyed(length: 2));
  }
}
