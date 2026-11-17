// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: lines_longer_than_80_chars, unnecessary_lambdas, deprecated_member_use, unused_element

part of 'generic_response_example.dart';

// **************************************************************************
// CodableGenerator
// **************************************************************************

// ignore_for_file: omit_local_variable_types

// =============================================================================
// 1. Unified Schema Descriptor for BaseResponse
// =============================================================================
extension type const _$BaseResponseSchema(int _value) {
  // String Name Constants
  static const String nameStatus = 'status';
  static const String nameMessage = 'message';
  static const String nameData = 'data';

  // Key Indices for selectKeyIndex()
  static const int keyStatus = 0;
  static const int keyMessage = 1;
  static const int keyData = 2;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
    _$BaseResponseSchema.nameStatus,
    _$BaseResponseSchema.nameMessage,
    _$BaseResponseSchema.nameData,
  ]);
  static final KeyOptions keyOptions = options;

  // Bitmask Flags strictly for Required Fields
  static const _$BaseResponseSchema none = _$BaseResponseSchema(0);
  static const int _statusBit = 1 << 0;
  static const _$BaseResponseSchema status = _$BaseResponseSchema(_statusBit);
  static const int _messageBit = 1 << 1;
  static const _$BaseResponseSchema message = _$BaseResponseSchema(_messageBit);
  static const int _dataBit = 1 << 2;
  static const _$BaseResponseSchema data = _$BaseResponseSchema(_dataBit);

  // Combined Golden Bitmask for fast single-instruction check
  static const _$BaseResponseSchema golden = _$BaseResponseSchema(
    _statusBit | _messageBit | _dataBit,
  );

  @pragma('vm:prefer-inline')
  _$BaseResponseSchema operator |(_$BaseResponseSchema other) =>
      _$BaseResponseSchema(_value | other._value);

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
    if ((_value & _statusBit) == 0) {
      missing.add(nameStatus);
    }
    if ((_value & _messageBit) == 0) {
      missing.add(nameMessage);
    }
    if ((_value & _dataBit) == 0) {
      missing.add(nameData);
    }
    throw CodableException(
      'Missing required fields for BaseResponse: ${missing.join(", ")}',
    );
  }
}

// =============================================================================
// 2. Companion Codable for BaseResponse
// =============================================================================
final class BaseResponseCodable<T> implements KeyedCodable<BaseResponse<T>> {
  final Codable<T> _$t;

  const BaseResponseCodable(this._$t);

  @override
  BaseResponse<T> decode(Decoder decoder) {
    final keyed = decoder.keyed(options: _$BaseResponseSchema.keyOptions);

    int? status;
    String? message;
    T? data;
    var seen = _$BaseResponseSchema.none;

    while (keyed.moveNextKey()) {
      switch (keyed.selectKeyIndex(_$BaseResponseSchema.keyOptions)) {
        case _$BaseResponseSchema.keyStatus:
          if ((seen._value & _$BaseResponseSchema.status._value) != 0) {
            throw const CodableException('Duplicate field "status"');
          }
          status = keyed.readInt();
          seen |= _$BaseResponseSchema.status;
          break;
        case _$BaseResponseSchema.keyMessage:
          if ((seen._value & _$BaseResponseSchema.message._value) != 0) {
            throw const CodableException('Duplicate field "message"');
          }
          message = keyed.readString();
          seen |= _$BaseResponseSchema.message;
          break;
        case _$BaseResponseSchema.keyData:
          if ((seen._value & _$BaseResponseSchema.data._value) != 0) {
            throw const CodableException('Duplicate field "data"');
          }
          if (keyed.isNextNull() && null is T) {
            keyed.readNull();
            data = null as T;
          } else {
            data = keyed.decodeValue(_$t);
          }
          seen |= _$BaseResponseSchema.data;
          break;
        default:
          keyed.skipValue();
          break;
      }
    }

    if (null is T) {
      seen |= _$BaseResponseSchema.data;
    }
    // Inlined fast-path check
    seen.validate();

    return BaseResponse<T>(status: status!, message: message!, data: data as T);
  }

  @override
  int encodedFieldCount(BaseResponse<T> instance) {
    var count$ = 2;
    if (instance.data != null) count$++;
    return count$;
  }

  @override
  void encodeFields(BaseResponse<T> instance, KeyedEncoder keyed) {
    keyed.encodeInt(_$BaseResponseSchema.nameStatus, instance.status);
    keyed.encodeString(_$BaseResponseSchema.nameMessage, instance.message);
    final v$Data = instance.data;
    if (v$Data != null) {
      keyed.encodeValue(_$BaseResponseSchema.nameData, v$Data, _$t);
    }
  }

  @override
  void encode(BaseResponse<T> instance, Encoder encoder) {
    var count$ = 2;
    final v$Data = instance.data;
    if (v$Data != null) count$++;
    final keyed = encoder.keyed(length: count$);
    keyed.encodeInt(_$BaseResponseSchema.nameStatus, instance.status);
    keyed.encodeString(_$BaseResponseSchema.nameMessage, instance.message);
    if (v$Data != null) {
      keyed.encodeValue(_$BaseResponseSchema.nameData, v$Data, _$t);
    }
  }
}

// =============================================================================
// 1. Unified Schema Descriptor for Article
// =============================================================================
extension type const _$ArticleSchema(int _value) {
  // String Name Constants
  static const String nameId = 'id';
  static const String nameTitle = 'title';
  static const String nameAuthor = 'author';

  // Key Indices for selectKeyIndex()
  static const int keyId = 0;
  static const int keyTitle = 1;
  static const int keyAuthor = 2;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
    _$ArticleSchema.nameId,
    _$ArticleSchema.nameTitle,
    _$ArticleSchema.nameAuthor,
  ]);
  static final KeyOptions keyOptions = options;

  // Bitmask Flags strictly for Required Fields
  static const _$ArticleSchema none = _$ArticleSchema(0);
  static const int _idBit = 1 << 0;
  static const _$ArticleSchema id = _$ArticleSchema(_idBit);
  static const int _titleBit = 1 << 1;
  static const _$ArticleSchema title = _$ArticleSchema(_titleBit);

  // Combined Golden Bitmask for fast single-instruction check
  static const _$ArticleSchema golden = _$ArticleSchema(_idBit | _titleBit);

  @pragma('vm:prefer-inline')
  _$ArticleSchema operator |(_$ArticleSchema other) =>
      _$ArticleSchema(_value | other._value);

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
    if ((_value & _idBit) == 0) {
      missing.add(nameId);
    }
    if ((_value & _titleBit) == 0) {
      missing.add(nameTitle);
    }
    throw CodableException(
      'Missing required fields for Article: ${missing.join(", ")}',
    );
  }
}

// =============================================================================
// 2. Companion Codable for Article
// =============================================================================
final class ArticleCodable implements KeyedCodable<Article> {
  const ArticleCodable();

  @override
  Article decode(Decoder decoder) {
    final keyed = decoder.keyed(options: _$ArticleSchema.keyOptions);

    int? id;
    String? title;
    User? author;
    var seen = _$ArticleSchema.none;

    while (keyed.moveNextKey()) {
      switch (keyed.selectKeyIndex(_$ArticleSchema.keyOptions)) {
        case _$ArticleSchema.keyId:
          if ((seen._value & _$ArticleSchema.id._value) != 0) {
            throw const CodableException('Duplicate field "id"');
          }
          id = keyed.readInt();
          seen |= _$ArticleSchema.id;
          break;
        case _$ArticleSchema.keyTitle:
          if ((seen._value & _$ArticleSchema.title._value) != 0) {
            throw const CodableException('Duplicate field "title"');
          }
          title = keyed.readString();
          seen |= _$ArticleSchema.title;
          break;
        case _$ArticleSchema.keyAuthor:
          if (keyed.isNextNull()) {
            keyed.readNull();
            author = null;
          } else {
            author = const UserCodable().decode(keyed.nestedDecoder());
          }
          break;
        default:
          keyed.skipValue();
          break;
      }
    }

    // Inlined fast-path check
    seen.validate();

    return Article(id: id!, title: title!, author: author);
  }

  @override
  int encodedFieldCount(Article instance) {
    var count$ = 2;
    if (instance.author != null) count$++;
    return count$;
  }

  @override
  void encodeFields(Article instance, KeyedEncoder keyed) {
    keyed.encodeInt(_$ArticleSchema.nameId, instance.id);
    keyed.encodeString(_$ArticleSchema.nameTitle, instance.title);
    final v$Author = instance.author;
    if (v$Author != null) {
      keyed.encodeValue(
        _$ArticleSchema.nameAuthor,
        v$Author,
        const UserCodable(),
      );
    }
  }

  @override
  void encode(Article instance, Encoder encoder) {
    var count$ = 2;
    final v$Author = instance.author;
    if (v$Author != null) count$++;
    final keyed = encoder.keyed(length: count$);
    keyed.encodeInt(_$ArticleSchema.nameId, instance.id);
    keyed.encodeString(_$ArticleSchema.nameTitle, instance.title);
    if (v$Author != null) {
      keyed.encodeValue(
        _$ArticleSchema.nameAuthor,
        v$Author,
        const UserCodable(),
      );
    }
  }
}

// =============================================================================
// 1. Unified Schema Descriptor for User
// =============================================================================
extension type const _$UserSchema(int _value) {
  // String Name Constants
  static const String nameId = 'id';
  static const String nameEmail = 'email';

  // Key Indices for selectKeyIndex()
  static const int keyId = 0;
  static const int keyEmail = 1;

  // KeyOptions Table
  static final KeyOptions options = KeyOptions.of(const [
    _$UserSchema.nameId,
    _$UserSchema.nameEmail,
  ]);
  static final KeyOptions keyOptions = options;

  // Bitmask Flags strictly for Required Fields
  static const _$UserSchema none = _$UserSchema(0);
  static const int _idBit = 1 << 0;
  static const _$UserSchema id = _$UserSchema(_idBit);
  static const int _emailBit = 1 << 1;
  static const _$UserSchema email = _$UserSchema(_emailBit);

  // Combined Golden Bitmask for fast single-instruction check
  static const _$UserSchema golden = _$UserSchema(_idBit | _emailBit);

  @pragma('vm:prefer-inline')
  _$UserSchema operator |(_$UserSchema other) =>
      _$UserSchema(_value | other._value);

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
    if ((_value & _idBit) == 0) {
      missing.add(nameId);
    }
    if ((_value & _emailBit) == 0) {
      missing.add(nameEmail);
    }
    throw CodableException(
      'Missing required fields for User: ${missing.join(", ")}',
    );
  }
}

// =============================================================================
// 2. Companion Codable for User
// =============================================================================
final class UserCodable implements KeyedCodable<User> {
  const UserCodable();

  @override
  User decode(Decoder decoder) {
    final keyed = decoder.keyed(options: _$UserSchema.keyOptions);

    int? id;
    String? email;
    var seen = _$UserSchema.none;

    while (keyed.moveNextKey()) {
      switch (keyed.selectKeyIndex(_$UserSchema.keyOptions)) {
        case _$UserSchema.keyId:
          if ((seen._value & _$UserSchema.id._value) != 0) {
            throw const CodableException('Duplicate field "id"');
          }
          id = keyed.readInt();
          seen |= _$UserSchema.id;
          break;
        case _$UserSchema.keyEmail:
          if ((seen._value & _$UserSchema.email._value) != 0) {
            throw const CodableException('Duplicate field "email"');
          }
          email = keyed.readString();
          seen |= _$UserSchema.email;
          break;
        default:
          keyed.skipValue();
          break;
      }
    }

    // Inlined fast-path check
    seen.validate();

    return User(id: id!, email: email!);
  }

  @override
  int encodedFieldCount(User instance) => 2;

  @override
  void encodeFields(User instance, KeyedEncoder keyed) {
    keyed.encodeInt(_$UserSchema.nameId, instance.id);
    keyed.encodeString(_$UserSchema.nameEmail, instance.email);
  }

  @override
  void encode(User instance, Encoder encoder) {
    final keyed = encoder.keyed(length: 2);
    keyed.encodeInt(_$UserSchema.nameId, instance.id);
    keyed.encodeString(_$UserSchema.nameEmail, instance.email);
  }
}
