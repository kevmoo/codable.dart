/// Core [Codable], [Encodable], and [Decodable] contracts.
library;

import 'package:meta/meta.dart';
import 'package:meta/meta_meta.dart';

import 'annotations.dart';
import 'decoder.dart';
import 'encoder.dart';

/// Base contract for companion objects or codecs that deserialize a domain
/// value of type [T] from a [Decoder].
abstract interface class Decodable<T> {
  /// Creates a [Decodable] from a standalone [decode] function.
  const factory Decodable.fromFunction(T Function(Decoder decoder) decode) =
      _FunctionDecodable<T>;

  /// Decodes an instance of [T] from [decoder].
  T decode(Decoder decoder);
}

/// Base contract for companion objects or codecs that serialize a domain
/// value of type [T] into an [Encoder].
abstract interface class Encodable<T> {
  /// Creates an [Encodable] from a standalone [encode] function.
  const factory Encodable.fromFunction(
    void Function(T value, Encoder encoder) encode,
  ) = _FunctionEncodable<T>;

  /// Encodes [value] into [encoder].
  void encode(T value, Encoder encoder);
}

/// Unified companion contract for serializing and deserializing values of type
/// [T], and the metadata annotation (`@Codable()`) designating a class for
/// code generation.
@Target({TargetKind.classType})
@optionalTypeArgs
abstract interface class Codable<T> implements Decodable<T>, Encodable<T> {
  /// Creates a `@Codable(...)` metadata annotation for code generation.
  const factory Codable({
    bool createEncoder,
    bool createDecoder,
    bool useGoldenMask,
    FieldRename fieldRename,
  }) = CodableAnnotation;

  /// Creates a [Codable] from standalone [decode] and [encode] functions.
  const factory Codable.fromFunctions({
    required T Function(Decoder decoder) decode,
    required void Function(T value, Encoder encoder) encode,
  }) = _FunctionCodable<T>;
}

final class _FunctionDecodable<T> implements Decodable<T> {
  final T Function(Decoder decoder) _decode;

  const _FunctionDecodable(this._decode);

  @override
  T decode(Decoder decoder) => _decode(decoder);
}

final class _FunctionEncodable<T> implements Encodable<T> {
  final void Function(T value, Encoder encoder) _encode;

  const _FunctionEncodable(this._encode);

  @override
  void encode(T value, Encoder encoder) => _encode(value, encoder);
}

final class _FunctionCodable<T> implements Codable<T> {
  final T Function(Decoder decoder) _decodeFn;
  final void Function(T value, Encoder encoder) _encodeFn;

  const _FunctionCodable({
    required T Function(Decoder decoder) decode,
    required void Function(T value, Encoder encoder) encode,
  }) : _decodeFn = decode,
       _encodeFn = encode;

  @override
  T decode(Decoder decoder) => _decodeFn(decoder);

  @override
  void encode(T value, Encoder encoder) => _encodeFn(value, encoder);
}

/// Extension methods for decoding lists of [T] using a [Decodable].
extension DecodableListExtension<T> on Decodable<T> {
  /// Decodes an unkeyed array of [T] from [decoder].
  List<T> decodeList(Decoder decoder) {
    final unkeyed = decoder.unkeyed();
    final list = <T>[];
    while (unkeyed.moveNext()) {
      list.add(decode(unkeyed.nestedDecoder()));
    }
    return list;
  }

  /// Returns a [Decodable] that decodes a `List<T>`.
  Decodable<List<T>> get list => _ListDecodable<T>(this);
}

/// Extension methods for encoding iterables of [T] using an [Encodable].
extension EncodableListExtension<T> on Encodable<T> {
  /// Encodes [elements] as an unkeyed array into [encoder].
  void encodeList(Iterable<T> elements, Encoder encoder) {
    encoder.unkeyed().encodeList(elements, this);
  }

  /// Returns an [Encodable] that encodes an `Iterable<T>`.
  Encodable<Iterable<T>> get list => _ListEncodable<T>(this);
}

/// Extension methods for [Codable] list adapters.
extension CodableListExtension<T> on Codable<T> {
  /// Returns a [Codable] that decodes and encodes a `List<T>`.
  Codable<List<T>> get list => _ListCodable<T>(this);
}

final class _ListDecodable<T> implements Decodable<List<T>> {
  final Decodable<T> _element;

  const _ListDecodable(this._element);

  @override
  List<T> decode(Decoder decoder) => _element.decodeList(decoder);
}

final class _ListEncodable<T> implements Encodable<Iterable<T>> {
  final Encodable<T> _element;

  const _ListEncodable(this._element);

  @override
  void encode(Iterable<T> value, Encoder encoder) =>
      _element.encodeList(value, encoder);
}

final class _ListCodable<T> implements Codable<List<T>> {
  final Codable<T> _element;

  const _ListCodable(this._element);

  @override
  List<T> decode(Decoder decoder) => _element.decodeList(decoder);

  @override
  void encode(List<T> value, Encoder encoder) =>
      _element.encodeList(value, encoder);
}
