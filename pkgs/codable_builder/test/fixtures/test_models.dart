// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

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
