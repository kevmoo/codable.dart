// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:typed_data';

import 'package:codable/codable.dart';

part 'test_models.g.dart';

@Codable()
final class Point {
  final double x;
  final double y;

  const Point(this.x, this.y);
}

enum UserRole { admin, member, guest }

@Codable(fieldRename: FieldRename.snake)
final class UserAccount {
  final String id;
  final String emailAddress;
  final UserRole role;
  final List<String> tags;
  final Float64List? location;
  final String internalId;

  const UserAccount({
    required this.id,
    @CodableKey(aliases: ['email', 'contact_email']) required this.emailAddress,
    required this.role,
    this.tags = const [],
    @CodableTuple(2) this.location,
    @CodableKey(ignore: true) this.internalId = '',
  });
}

@Codable()
final class InvalidIgnoredField {
  final String secret;

  const InvalidIgnoredField({@CodableKey(ignore: true) required this.secret});
}

@Codable()
final class Address {
  final String city;
  final String street;
  const Address({required this.city, required this.street});
}

@Codable()
final class Enterprise {
  final String name;
  final Address headquarter;
  final List<Address> branches;
  final Set<String> categories;
  final Map<String, int> headcountByDept;

  const Enterprise({
    required this.name,
    required this.headquarter,
    this.branches = const [],
    this.categories = const {},
    this.headcountByDept = const {},
  });
}

final class ZipCodeDecoder implements Codable<String> {
  const ZipCodeDecoder();

  @override
  String decode(Decoder decoder) {
    final sv = decoder.singleValue();
    return switch (sv.peekKind()) {
      ValueKind.nullValue => () {
        sv.readNull();
        return '';
      }(),
      ValueKind.string => sv.readString(),
      ValueKind.number => sv.readInt().toString(),
      final kind => throw CodableException(
        'Expected string or int for zip code, found $kind',
      ),
    };
  }

  @override
  void encode(String value, Encoder encoder) {
    encoder.singleValue().encodeString(value);
  }
}

final class ZipDecodeOnly implements Decodable<String> {
  const ZipDecodeOnly();

  @override
  String decode(Decoder decoder) {
    final sv = decoder.singleValue();
    return switch (sv.peekKind()) {
      ValueKind.string => sv.readString(),
      ValueKind.number => sv.readInt().toString(),
      final kind => throw CodableException('Expected string or int, got $kind'),
    };
  }
}

final class UpperCaseStringEncoder implements Encodable<String> {
  const UpperCaseStringEncoder();

  @override
  void encode(String value, Encoder encoder) {
    encoder.singleValue().encodeString(value.toUpperCase());
  }
}

final class EpochMsDateTimeDecoder implements Decodable<DateTime> {
  const EpochMsDateTimeDecoder();

  @override
  DateTime decode(Decoder decoder) {
    final sv = decoder.singleValue();
    return switch (sv.peekKind()) {
      ValueKind.number => DateTime.fromMillisecondsSinceEpoch(
        sv.readInt(),
        isUtc: true,
      ),
      ValueKind.string => DateTime.parse(sv.readString()).toUtc(),
      final kind => throw CodableException('Expected timestamp, got $kind'),
    };
  }
}

final class EpochMsDateTimeEncoder implements Encodable<DateTime> {
  const EpochMsDateTimeEncoder();

  @override
  void encode(DateTime value, Encoder encoder) {
    encoder.singleValue().encodeInt(value.toUtc().millisecondsSinceEpoch);
  }
}

final class NotACodec {
  const NotACodec();
}

@Codable()
final class UserProfileCustom {
  final String id;
  @CodableKey(customDecoder: ZipCodeDecoder())
  final String zip;

  const UserProfileCustom({required this.id, required this.zip});
}

@Codable()
final class CodableKeyVariantsModel {
  @CodableKey(codable: ZipCodeDecoder())
  final String zip;
  @CodableKey(customDecoder: ZipDecodeOnly())
  final String decodeOnlyZip;
  @CodableKey(customEncoder: UpperCaseStringEncoder())
  final String upperCode;
  @CodableKey(
    customDecoder: EpochMsDateTimeDecoder(),
    customEncoder: EpochMsDateTimeEncoder(),
  )
  final DateTime createdAt;

  const CodableKeyVariantsModel({
    required this.zip,
    required this.decodeOnlyZip,
    required this.upperCode,
    required this.createdAt,
  });
}

@Codable()
final class NumericMeasurement {
  final num score;
  final num? optionalScore;
  final List<num> samples;
  final List<num?> nullableSamples;
  final Set<num> distinctValues;
  final Map<String, num> metrics;
  final Map<String, num?> nullableMetrics;

  const NumericMeasurement({
    required this.score,
    this.optionalScore,
    this.samples = const [],
    this.nullableSamples = const [],
    this.distinctValues = const {},
    this.metrics = const {},
    this.nullableMetrics = const {},
  });
}

@Codable()
final class InvalidCodableMissingEncoder {
  @CodableKey(codable: ZipDecodeOnly())
  final String zip;

  const InvalidCodableMissingEncoder({required this.zip});
}

@Codable()
final class InvalidCustomDecoderNotDecodable {
  @CodableKey(customDecoder: NotACodec())
  final String zip;

  const InvalidCustomDecoderNotDecodable({required this.zip});
}

@Codable()
final class InvalidCustomEncoderNotEncodable {
  @CodableKey(customEncoder: NotACodec())
  final String zip;

  const InvalidCustomEncoderNotEncodable({required this.zip});
}

@Codable()
final class InvalidDecodeOnlyNonNativeType {
  @CodableKey(customDecoder: EpochMsDateTimeDecoder())
  final DateTime createdAt;

  const InvalidDecodeOnlyNonNativeType({required this.createdAt});
}

@Codable()
final class Team {
  final String name;
  final List<UserRole> roles;
  final Set<String?> nullableTags;
  final Map<String, int?> scores;

  const Team({
    required this.name,
    this.roles = const [],
    this.nullableTags = const {},
    this.scores = const {},
  });
}

@Codable()
final class PrimitiveCollectionsModel {
  final List<int> ints;
  final List<double> doubles;
  final List<String> strings;
  final List<bool> bools;
  final Float64List float64s;
  final List<List<double>> matrix;
  final List<Float64List> nestedFloats;

  const PrimitiveCollectionsModel({
    this.ints = const [],
    this.doubles = const [],
    this.strings = const [],
    this.bools = const [],
    required this.float64s,
    this.matrix = const [],
    this.nestedFloats = const [],
  });
}

@Codable()
final class BinaryPayloadModel {
  final Uint8List payload;
  final Uint8List? signature;
  final List<Uint8List> chunks;
  final List<Uint8List?> nullableChunks;
  final Map<String, Uint8List> namedBlobs;

  const BinaryPayloadModel({
    required this.payload,
    this.signature,
    this.chunks = const [],
    this.nullableChunks = const [],
    this.namedBlobs = const {},
  });
}

@Codable()
final class TypedKeyMapModel {
  final Map<int, String> statusMessages;
  final Map<UserRole, int> roleCounts;
  final Map<bool, double> flagWeights;
  final Map<String, List<int>> buckets;

  const TypedKeyMapModel({
    this.statusMessages = const {},
    this.roleCounts = const {},
    this.flagWeights = const {},
    this.buckets = const {},
  });
}

@Codable()
final class CompositeKeyMapModel {
  final Map<Point, String> labelsByPoint;

  const CompositeKeyMapModel({this.labelsByPoint = const {}});
}

@Codable()
final class StringKeyedNestedMapModel {
  final Map<String, UserRole> rolesByUser;
  final Map<String, Address?> officesByCode;
  final Map<String, Map<String, int>> nestedCounts;

  const StringKeyedNestedMapModel({
    this.rolesByUser = const {},
    this.officesByCode = const {},
    this.nestedCounts = const {},
  });
}

@Codable()
final class NullableGetterTelemetry {
  final String id;
  final String? _rawTag;
  final int? _rawScore;
  final Address? _rawLocation;
  final void Function(String field)? onRead;

  const NullableGetterTelemetry({
    required this.id,
    String? tag,
    int? score,
    Address? location,
    @CodableKey(ignore: true) this.onRead,
  }) : _rawTag = tag,
       _rawScore = score,
       _rawLocation = location;

  String? get tag {
    onRead?.call('tag');
    return _rawTag;
  }

  int? get score {
    onRead?.call('score');
    return _rawScore;
  }

  Address? get location {
    onRead?.call('location');
    return _rawLocation;
  }
}

@Codable()
final class AllNullableModel {
  final int? a;
  final String? b;
  final List<int>? items;
  final Set<UserRole>? roles;
  final Map<String, int>? labels;
  final Map<int, String>? codes;

  const AllNullableModel({
    this.a,
    this.b,
    this.items,
    this.roles,
    this.labels,
    this.codes,
  });
}

@Codable()
final class EmptyRecord {
  const EmptyRecord();
}

@Codable()
final class HugeModel63 {
  final int f00;
  final int f01;
  final int f02;
  final int f03;
  final int f04;
  final int f05;
  final int f06;
  final int f07;
  final int f08;
  final int f09;
  final int f10;
  final int f11;
  final int f12;
  final int f13;
  final int f14;
  final int f15;
  final int f16;
  final int f17;
  final int f18;
  final int f19;
  final int f20;
  final int f21;
  final int f22;
  final int f23;
  final int f24;
  final int f25;
  final int f26;
  final int f27;
  final int f28;
  final int f29;
  final int f30;
  final int f31;
  final int f32;
  final int f33;
  final int f34;
  final int f35;
  final int f36;
  final int f37;
  final int f38;
  final int f39;
  final int f40;
  final int f41;
  final int f42;
  final int f43;
  final int f44;
  final int f45;
  final int f46;
  final int f47;
  final int f48;
  final int f49;
  final int f50;
  final int f51;
  final int f52;
  final int f53;
  final int f54;
  final int f55;
  final int f56;
  final int f57;
  final int f58;
  final int f59;
  final int f60;
  final int f61;
  final int f62;

  const HugeModel63({
    required this.f00,
    required this.f01,
    required this.f02,
    required this.f03,
    required this.f04,
    required this.f05,
    required this.f06,
    required this.f07,
    required this.f08,
    required this.f09,
    required this.f10,
    required this.f11,
    required this.f12,
    required this.f13,
    required this.f14,
    required this.f15,
    required this.f16,
    required this.f17,
    required this.f18,
    required this.f19,
    required this.f20,
    required this.f21,
    required this.f22,
    required this.f23,
    required this.f24,
    required this.f25,
    required this.f26,
    required this.f27,
    required this.f28,
    required this.f29,
    required this.f30,
    required this.f31,
    required this.f32,
    required this.f33,
    required this.f34,
    required this.f35,
    required this.f36,
    required this.f37,
    required this.f38,
    required this.f39,
    required this.f40,
    required this.f41,
    required this.f42,
    required this.f43,
    required this.f44,
    required this.f45,
    required this.f46,
    required this.f47,
    required this.f48,
    required this.f49,
    required this.f50,
    required this.f51,
    required this.f52,
    required this.f53,
    required this.f54,
    required this.f55,
    required this.f56,
    required this.f57,
    required this.f58,
    required this.f59,
    required this.f60,
    required this.f61,
    required this.f62,
  });
}

@Codable()
final class NestedModelGrid {
  final List<List<Point>> rows;
  final List<List<Point>?> nullableRows;
  final List<List<Point?>> sparseRows;
  final List<List<List<Point>>> cube;

  const NestedModelGrid({
    this.rows = const [],
    this.nullableRows = const [],
    this.sparseRows = const [],
    this.cube = const [],
  });
}

@Codable()
final class NestedCollectionMatrix {
  final List<List<Float64List>> tensor3d;
  final List<Set<Point>> pointSets;
  final Set<List<int>> intRowsSet;
  final List<List<Map<String, int>>> mapGrid;
  final List<Set<UserRole>> roleSets;

  const NestedCollectionMatrix({
    this.tensor3d = const [],
    this.pointSets = const [],
    this.intRowsSet = const {},
    this.mapGrid = const [],
    this.roleSets = const [],
  });
}

@Codable()
final class DefaultValuesModel {
  final String label;
  final String escapedNote;
  final int retryCount;
  final double factor;
  final bool enabled;
  final UserRole role;
  final List<String> tags;
  final Map<String, int> metadata;
  final Point origin;
  final String? nullableOverride;
  final String? omittedDefaultKeepCtor;
  final List<double> weights;
  final double hexDouble;
  final double zeroDouble;
  final num countNum;
  final Set<String> emptySet;
  final Map<String, int> emptyMap;
  final List<List<int>> nestedIntRows;
  final List<Map<String, int>> nestedStringIntMaps;

  const DefaultValuesModel({
    @CodableKey(defaultValue: 'guest') this.label = 'constructor_shadowed',
    @CodableKey(defaultValue: "it's \$5\n") this.escapedNote = '',
    @CodableKey(defaultValue: 42) this.retryCount = 1,
    @CodableKey(defaultValue: 2.5) this.factor = 1.0,
    @CodableKey(defaultValue: true) this.enabled = false,
    @CodableKey(defaultValue: UserRole.guest) required this.role,
    @CodableKey(defaultValue: ['alpha', 'beta']) this.tags = const [],
    @CodableKey(defaultValue: {'env': 1}) this.metadata = const {},
    @CodableKey(defaultValue: Point(1.5, -2.5))
    this.origin = const Point(0.0, 0.0),
    @CodableKey(defaultValue: null)
    this.nullableOverride = 'non_null_ctor_default',
    @CodableKey(name: 'explicit_name')
    this.omittedDefaultKeepCtor = 'kept_ctor_default',
    this.weights = const [1, 2],
    this.hexDouble = 0x10,
    this.zeroDouble = 0,
    this.countNum = 1,
    this.emptySet = const {},
    this.emptyMap = const {},
    @CodableKey(
      defaultValue: <List<int>>[
        [],
        [1],
      ],
    )
    this.nestedIntRows = const [],
    @CodableKey(defaultValue: <Map<String, int>>[{}])
    this.nestedStringIntMaps = const [],
  });
}

@Codable()
final class PortableTypedDataModel {
  final Uint8List uint8;
  final Uint8ClampedList uint8Clamped;
  final Uint16List uint16;
  final Uint32List uint32;
  final Int8List int8;
  final Int16List int16;
  final Int32List int32;
  final Float32List float32;
  final Float64List float64;
  final Int16List? nullableInt16;
  final Float32List? nullableFloat32;
  final List<Int16List> nestedInt16s;
  final List<Int16List?> sparseInt16s;
  final Map<String, Uint16List> stringKeyedUint16s;
  final Map<int, Int8List> intKeyedInt8s;

  const PortableTypedDataModel({
    required this.uint8,
    required this.uint8Clamped,
    required this.uint16,
    required this.uint32,
    required this.int8,
    required this.int16,
    required this.int32,
    required this.float32,
    required this.float64,
    this.nullableInt16,
    this.nullableFloat32,
    this.nestedInt16s = const [],
    this.sparseInt16s = const [],
    this.stringKeyedUint16s = const {},
    this.intKeyedInt8s = const {},
  });
}

@Codable()
final class Vm64BitTypedDataModel {
  final Int64List int64;
  final Uint64List uint64;
  final Int64List? nullableInt64;
  final Uint64List? nullableUint64;
  final List<Uint64List> nestedUint64s;
  final Map<String, Uint64List> namedUint64s;
  final Int64List? tupleInt64;
  final Uint64List? tupleUint64;

  const Vm64BitTypedDataModel({
    required this.int64,
    required this.uint64,
    this.nullableInt64,
    this.nullableUint64,
    this.nestedUint64s = const [],
    this.namedUint64s = const {},
    @CodableTuple(2) this.tupleInt64,
    @CodableTuple(2) this.tupleUint64,
  });
}

@Codable()
final class TupleVariantsModel {
  final List<int> intPair;
  final List<double> doubleTriple;
  final Float64List float64Pair;
  final Float32List float32Pair;
  final Int32List int32Triple;
  final List<int>? optionalIntPair;
  final Uint16List? optionalUint16Pair;

  const TupleVariantsModel({
    @CodableTuple(2) required this.intPair,
    @CodableTuple(3) required this.doubleTriple,
    @CodableTuple(2) required this.float64Pair,
    @CodableTuple(2) required this.float32Pair,
    @CodableTuple(3) required this.int32Triple,
    @CodableTuple(2) this.optionalIntPair,
    @CodableTuple(2) this.optionalUint16Pair,
  });
}

@Codable()
final class EnumCollectionsAndAliasesModel {
  final List<UserRole> roles;
  final List<UserRole?> nullableRoles;
  final Set<UserRole> roleSet;
  final Map<String, UserRole> rolesByKey;
  final Map<int, UserRole> rolesById;
  final Map<UserRole, int> countsByRole;
  final Map<UserRole, UserRole> roleTransitions;
  final Map<UserRole, UserRole?> nullableRoleTransitions;
  final String slug;

  const EnumCollectionsAndAliasesModel({
    this.roles = const [],
    this.nullableRoles = const [],
    this.roleSet = const {},
    this.rolesByKey = const {},
    this.rolesById = const {},
    this.countsByRole = const {},
    this.roleTransitions = const {},
    this.nullableRoleTransitions = const {},
    @CodableKey(aliases: ['foo-bar', 'foo_bar']) this.slug = '',
  });
}

@Codable()
final class InvalidUnknownDateTimeField {
  final DateTime at;

  const InvalidUnknownDateTimeField({required this.at});
}

@Codable()
final class InvalidUnknownUriField {
  final Uri link;

  const InvalidUnknownUriField({required this.link});
}

@Codable()
final class InvalidUnknownDynamicField {
  final dynamic anything;

  const InvalidUnknownDynamicField({this.anything});
}

@Codable()
final class InvalidUnknownObjectField {
  final Object? payload;

  const InvalidUnknownObjectField({this.payload});
}

@Codable()
final class InvalidUnknownRecordField {
  final (int, String) pair;

  const InvalidUnknownRecordField({required this.pair});
}

@Codable()
final class InvalidNestedListDateTime {
  final List<DateTime> timestamps;

  const InvalidNestedListDateTime({this.timestamps = const []});
}

@Codable()
final class InvalidNestedSetUri {
  final Set<Uri> urls;

  const InvalidNestedSetUri({this.urls = const {}});
}

@Codable()
final class InvalidNestedMapValueBigInt {
  final Map<String, BigInt> balances;

  const InvalidNestedMapValueBigInt({this.balances = const {}});
}

@Codable()
final class InvalidMapKeyDateTime {
  final Map<DateTime, int> byDate;

  const InvalidMapKeyDateTime({this.byDate = const {}});
}

@Codable()
final class InvalidMapKeyList {
  final Map<List<int>, String> byCoords;

  const InvalidMapKeyList({this.byCoords = const {}});
}

@Codable()
final class InvalidMapKeyNullable {
  final Map<String?, int> byNullableKey;

  const InvalidMapKeyNullable({this.byNullableKey = const {}});
}

@Codable()
final class InvalidNullDefaultOnNonNullable {
  final String name;

  const InvalidNullDefaultOnNonNullable({
    @CodableKey(defaultValue: null) required this.name,
  });
}

@Codable()
final class InvalidZeroLengthTuple {
  final List<double> coords;

  const InvalidZeroLengthTuple({@CodableTuple(0) required this.coords});
}

@Codable()
final class InvalidNegativeLengthTuple {
  final Float64List coords;

  const InvalidNegativeLengthTuple({@CodableTuple(-3) required this.coords});
}

@Codable()
final class InvalidNonNumericTuple {
  final List<String> names;

  const InvalidNonNumericTuple({@CodableTuple(2) required this.names});
}

@Codable()
final class InvalidScalarTuple {
  final String code;

  const InvalidScalarTuple({@CodableTuple(2) required this.code});
}

@Codable()
final class InvalidDuplicateAliasInField {
  final String name;

  const InvalidDuplicateAliasInField({
    @CodableKey(aliases: ['dup', 'dup']) required this.name,
  });
}

@Codable()
final class InvalidAliasEqualsWireName {
  final String id;

  const InvalidAliasEqualsWireName({
    @CodableKey(name: 'user_id', aliases: ['user_id']) required this.id,
  });
}

@Codable()
final class InvalidCrossFieldAliasCollision {
  final String alpha;
  final String beta;

  const InvalidCrossFieldAliasCollision({
    required this.alpha,
    @CodableKey(aliases: ['alpha']) required this.beta,
  });
}

@Codable()
final class InvalidCrossFieldAliasToAliasCollision {
  final String alpha;
  final String beta;

  const InvalidCrossFieldAliasToAliasCollision({
    @CodableKey(aliases: ['shared']) required this.alpha,
    @CodableKey(aliases: ['shared']) required this.beta,
  });
}

@Codable()
final class InvalidUint8ListTuple {
  final Uint8List magic;

  const InvalidUint8ListTuple({@CodableTuple(4) required this.magic});
}

final class BoxedSecret {
  final int id;

  const factory BoxedSecret(int id) = BoxedSecret._;

  const BoxedSecret._(this.id);
}

final class BoxedSecretCodec implements Codable<BoxedSecret> {
  const BoxedSecretCodec();

  @override
  BoxedSecret decode(Decoder decoder) =>
      BoxedSecret(decoder.singleValue().readInt());

  @override
  void encode(BoxedSecret value, Encoder encoder) =>
      encoder.singleValue().encodeInt(value.id);
}

final class BoxedSecretListCodec implements Codable<List<BoxedSecret>> {
  const BoxedSecretListCodec();

  @override
  List<BoxedSecret> decode(Decoder decoder) =>
      decoder.unkeyed().decodeList(const BoxedSecretCodec());

  @override
  void encode(List<BoxedSecret> value, Encoder encoder) =>
      const BoxedSecretCodec().encodeList(value, encoder);
}

@Codable()
final class InvalidPrivateRevivableDefault {
  final BoxedSecret secret;

  const InvalidPrivateRevivableDefault({
    @CodableKey(codable: BoxedSecretCodec(), defaultValue: BoxedSecret._(42))
    this.secret = const BoxedSecret(0),
  });
}

@Codable()
final class InvalidNestedPrivateRevivableDefault {
  final List<BoxedSecret> secrets;

  const InvalidNestedPrivateRevivableDefault({
    @CodableKey(
      codable: BoxedSecretListCodec(),
      defaultValue: [BoxedSecret._(42)],
    )
    this.secrets = const [],
  });
}
