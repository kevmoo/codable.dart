/// Next-generation high-performance zero-allocation serialization framework for Dart.
library;

import 'dart:convert';

export 'dart:typed_data';
export 'src/contracts/annotations.dart';
export 'src/contracts/codable.dart';
export 'src/contracts/custom_decoder.dart';
export 'src/contracts/decoder.dart';
export 'src/contracts/encoder.dart';
export 'src/contracts/exceptions.dart';
export 'src/contracts/static_key.dart';
export 'dart:convert'
    show
        JsonKeyOptions,
        JsonTokenReader,
        JsonTokenType,
        JsonTokenWriter,
        jsonUtf8,
        jsonUtf8Decode,
        jsonUtf8Encode;

/// Extension on [JsonTokenReader] providing convenience utilities.
extension JsonTokenReaderCodableExtension on JsonTokenReader {
  /// Returns `true` if the next token is a null literal without advancing the cursor.
  @pragma('vm:prefer-inline')
  @pragma('wasm:prefer-inline')
  bool isNextNull() => peek() == JsonTokenType.nullValue;
}
