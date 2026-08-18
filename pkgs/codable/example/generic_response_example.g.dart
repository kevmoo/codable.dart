// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: lines_longer_than_80_chars

part of 'generic_response_example.dart';

// **************************************************************************
// CodableGenerator
// **************************************************************************

// =============================================================================
// 1. Unified Schema Descriptor for Article
// =============================================================================
extension type const _$ArticleSchema(int _value) {
  // String Name Constants
  static const String nameId = 'id';
  static const String nameTitle = 'title';
  static const String nameAuthor = 'author';

  // Pre-Encoded UTF-8 Wire Bytes
  static final Uint8List nameIdBytes = Uint8List.fromList(const [105, 100]);
  static final Uint8List nameTitleBytes = Uint8List.fromList(const [
    116,
    105,
    116,
    108,
    101,
  ]);
  static final Uint8List nameAuthorBytes = Uint8List.fromList(const [
    97,
    117,
    116,
    104,
    111,
    114,
  ]);

  // Key Indices for selectName()
  static const int keyId = 0;
  static const int keyTitle = 1;
  static const int keyAuthor = 2;

  // Pre-Compiled JsonKeyOptions
  static final JsonKeyOptions options = JsonKeyOptions.of(const [
    _$ArticleSchema.nameId,
    _$ArticleSchema.nameTitle,
    _$ArticleSchema.nameAuthor,
  ]);

  // Bitmask Flags strictly for Required Fields
  static const _$ArticleSchema none = _$ArticleSchema(0);
  static const int _idBit = 1 << 0;
  static const _$ArticleSchema id = _$ArticleSchema(_idBit);
  static const int _titleBit = 1 << 1;
  static const _$ArticleSchema title = _$ArticleSchema(_titleBit);

  // Composite Golden Mask for Required Fields
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
// 2. Single-Pass Streaming Deserializer for Article
// =============================================================================
Article _$ArticleFromReader(JsonTokenReader reader) {
  reader.beginObject();

  int? id;
  String? title;
  User? author;
  var seen = _$ArticleSchema.none;

  while (reader.hasNext()) {
    switch (reader.selectName(_$ArticleSchema.options)) {
      case _$ArticleSchema.keyId:
        if ((seen._value & _$ArticleSchema.id._value) != 0) {
          throw const CodableException('Duplicate field "id"');
        }
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          id = reader.readInt();
          seen |= _$ArticleSchema.id;
        }
        break;
      case _$ArticleSchema.keyTitle:
        if ((seen._value & _$ArticleSchema.title._value) != 0) {
          throw const CodableException('Duplicate field "title"');
        }
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          title = reader.readString();
          seen |= _$ArticleSchema.title;
        }
        break;
      case _$ArticleSchema.keyAuthor:
        if (reader.isNextNull()) {
          reader.readNull();
          author = null;
        } else {
          author = _$UserFromReader(reader);
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

  return Article(id: id!, title: title!, author: author);
}

// =============================================================================
// 3. Single-Pass Streaming Serializer for Article
// =============================================================================
void _$ArticleToWriter(Article instance, JsonTokenWriter writer) {
  writer.beginObject();
  writer.writeNameBytes(_$ArticleSchema.nameIdBytes);
  writer.writeInt(instance.id);
  writer.writeNameBytes(_$ArticleSchema.nameTitleBytes);
  writer.writeString(instance.title);
  if (instance.author != null) {
    writer.writeNameBytes(_$ArticleSchema.nameAuthorBytes);
    _$UserToWriter(instance.author!, writer);
  }
  writer.endObject();
}

// =============================================================================
// 1. Unified Schema Descriptor for User
// =============================================================================
extension type const _$UserSchema(int _value) {
  // String Name Constants
  static const String nameId = 'id';
  static const String nameEmail = 'email';

  // Pre-Encoded UTF-8 Wire Bytes
  static final Uint8List nameIdBytes = Uint8List.fromList(const [105, 100]);
  static final Uint8List nameEmailBytes = Uint8List.fromList(const [
    101,
    109,
    97,
    105,
    108,
  ]);

  // Key Indices for selectName()
  static const int keyId = 0;
  static const int keyEmail = 1;

  // Pre-Compiled JsonKeyOptions
  static final JsonKeyOptions options = JsonKeyOptions.of(const [
    _$UserSchema.nameId,
    _$UserSchema.nameEmail,
  ]);

  // Bitmask Flags strictly for Required Fields
  static const _$UserSchema none = _$UserSchema(0);
  static const int _idBit = 1 << 0;
  static const _$UserSchema id = _$UserSchema(_idBit);
  static const int _emailBit = 1 << 1;
  static const _$UserSchema email = _$UserSchema(_emailBit);

  // Composite Golden Mask for Required Fields
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
// 2. Single-Pass Streaming Deserializer for User
// =============================================================================
User _$UserFromReader(JsonTokenReader reader) {
  reader.beginObject();

  int? id;
  String? email;
  var seen = _$UserSchema.none;

  while (reader.hasNext()) {
    switch (reader.selectName(_$UserSchema.options)) {
      case _$UserSchema.keyId:
        if ((seen._value & _$UserSchema.id._value) != 0) {
          throw const CodableException('Duplicate field "id"');
        }
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          id = reader.readInt();
          seen |= _$UserSchema.id;
        }
        break;
      case _$UserSchema.keyEmail:
        if ((seen._value & _$UserSchema.email._value) != 0) {
          throw const CodableException('Duplicate field "email"');
        }
        if (reader.isNextNull()) {
          reader.readNull();
        } else {
          email = reader.readString();
          seen |= _$UserSchema.email;
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

  return User(id: id!, email: email!);
}

// =============================================================================
// 3. Single-Pass Streaming Serializer for User
// =============================================================================
void _$UserToWriter(User instance, JsonTokenWriter writer) {
  writer.beginObject();
  writer.writeNameBytes(_$UserSchema.nameIdBytes);
  writer.writeInt(instance.id);
  writer.writeNameBytes(_$UserSchema.nameEmailBytes);
  writer.writeString(instance.email);
  writer.endObject();
}
