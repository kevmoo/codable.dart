// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: lines_longer_than_80_chars, unnecessary_lambdas, deprecated_member_use, unused_element

part of 'generic_response_example.dart';

// =============================================================================
// 1. Unified Schema Descriptor for Article
// =============================================================================
extension type const _$ArticleSchema(int _value) {
  // String Name Constants
  static const String nameId = 'id';
  static const String nameTitle = 'title';
  static const String nameAuthor = 'author';

  // Pre-encoded UTF-8 Wire Name Bytes and StaticKeys
  static const List<int> wireNameBytesId = [34, 105, 100, 34];
  static const StaticKey staticKeyId = StaticKey(
    nameId,
    keyId,
    wireNameBytesId,
  );
  static const List<int> wireNameBytesTitle = [34, 116, 105, 116, 108, 101, 34];
  static const StaticKey staticKeyTitle = StaticKey(
    nameTitle,
    keyTitle,
    wireNameBytesTitle,
  );
  static const List<int> wireNameBytesAuthor = [
    34,
    97,
    117,
    116,
    104,
    111,
    114,
    34,
  ];
  static const StaticKey staticKeyAuthor = StaticKey(
    nameAuthor,
    keyAuthor,
    wireNameBytesAuthor,
  );

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
// 2. Universal Keyed Deserializer for Article
// =============================================================================
Article _$ArticleFromDecoder(Decoder decoder) {
  final keyed = decoder.keyed(options: _$ArticleSchema.keyOptions);

  int? id;
  String? title;
  User? author;
  var seen = _$ArticleSchema.none;

  while (keyed.hasNextKey()) {
    switch (keyed.selectKeyIndex(_$ArticleSchema.keyOptions)) {
      case _$ArticleSchema.keyId:
        if ((seen._value & _$ArticleSchema.id._value) != 0) {
          throw const CodableException('Duplicate field "id"');
        }
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          id = keyed.readInt();
          seen |= _$ArticleSchema.id;
        }
        break;
      case _$ArticleSchema.keyTitle:
        if ((seen._value & _$ArticleSchema.title._value) != 0) {
          throw const CodableException('Duplicate field "title"');
        }
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          title = keyed.readString();
          seen |= _$ArticleSchema.title;
        }
        break;
      case _$ArticleSchema.keyAuthor:
        if (keyed.isNextNull()) {
          keyed.readNull();
          author = null;
        } else {
          author = _$UserFromDecoder(keyed.nestedDecoder());
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

// =============================================================================
// 2b. Universal List Deserializer for Article
// =============================================================================
List<Article> _$ArticleListFromDecoder(Decoder decoder) {
  final unkeyed = decoder.unkeyed();
  final list = <Article>[];
  while (unkeyed.hasNext()) {
    list.add(_$ArticleFromDecoder(unkeyed.nestedDecoder()));
  }
  return list;
}

// =============================================================================
// 3. Universal Serializer for Article
// =============================================================================
void _$ArticleToEncoder(Article instance, Encoder encoder) {
  final keyed = encoder.keyed();
  keyed.encodeIntKey(_$ArticleSchema.staticKeyId, instance.id);
  keyed.encodeStringKey(_$ArticleSchema.staticKeyTitle, instance.title);
  if (instance.author != null) {
    keyed.encodeValueKey(
      _$ArticleSchema.staticKeyAuthor,
      instance.author!,
      _$UserToEncoder,
    );
  }
}

// =============================================================================
// 1. Unified Schema Descriptor for User
// =============================================================================
extension type const _$UserSchema(int _value) {
  // String Name Constants
  static const String nameId = 'id';
  static const String nameEmail = 'email';

  // Pre-encoded UTF-8 Wire Name Bytes and StaticKeys
  static const List<int> wireNameBytesId = [34, 105, 100, 34];
  static const StaticKey staticKeyId = StaticKey(
    nameId,
    keyId,
    wireNameBytesId,
  );
  static const List<int> wireNameBytesEmail = [34, 101, 109, 97, 105, 108, 34];
  static const StaticKey staticKeyEmail = StaticKey(
    nameEmail,
    keyEmail,
    wireNameBytesEmail,
  );

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
// 2. Universal Keyed Deserializer for User
// =============================================================================
User _$UserFromDecoder(Decoder decoder) {
  final keyed = decoder.keyed(options: _$UserSchema.keyOptions);

  int? id;
  String? email;
  var seen = _$UserSchema.none;

  while (keyed.hasNextKey()) {
    switch (keyed.selectKeyIndex(_$UserSchema.keyOptions)) {
      case _$UserSchema.keyId:
        if ((seen._value & _$UserSchema.id._value) != 0) {
          throw const CodableException('Duplicate field "id"');
        }
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          id = keyed.readInt();
          seen |= _$UserSchema.id;
        }
        break;
      case _$UserSchema.keyEmail:
        if ((seen._value & _$UserSchema.email._value) != 0) {
          throw const CodableException('Duplicate field "email"');
        }
        if (keyed.isNextNull()) {
          keyed.readNull();
        } else {
          email = keyed.readString();
          seen |= _$UserSchema.email;
        }
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

// =============================================================================
// 2b. Universal List Deserializer for User
// =============================================================================
List<User> _$UserListFromDecoder(Decoder decoder) {
  final unkeyed = decoder.unkeyed();
  final list = <User>[];
  while (unkeyed.hasNext()) {
    list.add(_$UserFromDecoder(unkeyed.nestedDecoder()));
  }
  return list;
}

// =============================================================================
// 3. Universal Serializer for User
// =============================================================================
void _$UserToEncoder(User instance, Encoder encoder) {
  final keyed = encoder.keyed();
  keyed.encodeIntKey(_$UserSchema.staticKeyId, instance.id);
  keyed.encodeStringKey(_$UserSchema.staticKeyEmail, instance.email);
}
