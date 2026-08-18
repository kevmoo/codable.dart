import 'dart:convert';
import 'dart:typed_data';

import 'json_key_options.dart';
import 'span_parsers.dart';

/// Top-level combined codec for UTF-8 JSON encoding and decoding.
final class JsonUtf8Codec extends Codec<Object?, List<int>> {
  final String? indent;
  final dynamic Function(dynamic object)? toEncodable;
  final Object? Function(Object? key, Object? value)? reviver;
  final bool allowMalformed;
  final int? bufferSize;

  const JsonUtf8Codec({
    this.indent,
    this.toEncodable,
    this.reviver,
    this.allowMalformed = false,
    this.bufferSize,
  });

  @override
  JsonUtf8Encoder get encoder =>
      JsonUtf8Encoder(indent, toEncodable, bufferSize);

  @override
  JsonUtf8Decoder get decoder => JsonUtf8Decoder(reviver, allowMalformed);
}

const JsonUtf8Codec jsonUtf8 = JsonUtf8Codec();

Object? jsonUtf8Decode(
  List<int> bytes, {
  Object? Function(Object? key, Object? value)? reviver,
}) => JsonUtf8Decoder(reviver).convert(bytes);

Uint8List jsonUtf8Encode(
  Object? value, {
  Object? Function(dynamic object)? toEncodable,
}) => Uint8List.fromList(JsonUtf8Encoder(null, toEncodable).convert(value));

final class JsonUtf8Decoder extends Converter<List<int>, Object?> {
  final Object? Function(Object? key, Object? value)? reviver;
  final bool allowMalformed;

  const JsonUtf8Decoder([this.reviver, this.allowMalformed = false]);

  @override
  Object? convert(List<int> input) {
    final str = utf8.decode(input, allowMalformed: allowMalformed);
    return jsonDecode(str, reviver: reviver);
  }

  @override
  ChunkedConversionSink<List<int>> startChunkedConversion(Sink<Object?> sink) {
    throw UnimplementedError();
  }

  // --- Static Micro-Tier Span Atoms ---

  static double parseDouble(Uint8List bytes, int start, int end) =>
      parseDoubleUtf8(bytes, start, end);

  static double? tryParseDouble(Uint8List bytes, int start, int end) =>
      tryParseDoubleUtf8(bytes, start, end);

  static int parseInt(Uint8List bytes, int start, int end) =>
      parseIntUtf8(bytes, start, end);

  static int? tryParseInt(Uint8List bytes, int start, int end) =>
      tryParseIntUtf8(bytes, start, end);

  static bool parseBool(Uint8List bytes, int start, int end) =>
      parseBoolUtf8(bytes, start, end);

  static bool? tryParseBool(Uint8List bytes, int start, int end) =>
      tryParseBoolUtf8(bytes, start, end);

  static bool isNull(Uint8List bytes, int start, int end) =>
      isNullUtf8(bytes, start, end);

  static bool equalsAscii(
    Uint8List bytes,
    int start,
    int end,
    String candidate,
  ) => equalsAsciiUtf8(bytes, start, end, candidate);

  static int matchKey(
    Uint8List bytes,
    int start,
    int end,
    JsonKeyOptions options,
  ) => options.selectKey(bytes, start, end);

  static bool isVerbatim(Uint8List bytes, int start, int end) =>
      isVerbatimUtf8(bytes, start, end);

  static String decodeString(Uint8List bytes, int start, int end) =>
      decodeStringUtf8(bytes, start, end);

  static int skipValue(Uint8List bytes, int offset) {
    var i = offset;
    while (i < bytes.length && bytes[i] <= 32) {
      i++;
    }
    if (i >= bytes.length) return i;
    final b = bytes[i];
    if (b == 123 || b == 91) {
      // object or array
      var depth = 1;
      final open = b;
      final close = b == 123 ? 125 : 93;
      i++;
      while (i < bytes.length && depth > 0) {
        final c = bytes[i++];
        if (c == 34) {
          while (i < bytes.length) {
            final sc = bytes[i++];
            if (sc == 92) {
              i++;
            } else if (sc == 34) {
              break;
            }
          }
        } else if (c == open) {
          depth++;
        } else if (c == close) {
          depth--;
        }
      }
      return i;
    }
    if (b == 34) {
      i++;
      while (i < bytes.length) {
        final c = bytes[i++];
        if (c == 92) {
          i++;
        } else if (c == 34) {
          break;
        }
      }
      return i;
    }
    while (i < bytes.length &&
        bytes[i] != 44 &&
        bytes[i] != 125 &&
        bytes[i] != 93 &&
        bytes[i] > 32) {
      i++;
    }
    return i;
  }

  static int skipWhitespace(Uint8List bytes, int offset) {
    var i = offset;
    while (i < bytes.length && bytes[i] <= 32) {
      i++;
    }
    return i;
  }

  static int skipString(Uint8List bytes, int offset) {
    var i = offset;
    if (i < bytes.length && bytes[i] == 34) i++;
    while (i < bytes.length) {
      final b = bytes[i++];
      if (b == 92) {
        i++;
      } else if (b == 34) {
        break;
      }
    }
    return i;
  }
}

final class JsonUtf8Encoder extends Converter<Object?, List<int>> {
  final String? indent;
  final dynamic Function(dynamic object)? toEncodable;
  final int? bufferSize;

  const JsonUtf8Encoder([this.indent, this.toEncodable, this.bufferSize]);

  @override
  List<int> convert(Object? input) {
    final str = jsonEncode(input, toEncodable: toEncodable);
    return utf8.encode(str);
  }

  // --- Static Micro-Tier Formatting Atoms ---

  static void writeString(String value, BytesBuilder sink) {
    sink.add(utf8.encode(jsonEncode(value)));
  }

  static int writeStringToBuffer(String value, Uint8List buffer, int offset) {
    final encoded = utf8.encode(jsonEncode(value));
    buffer.setRange(offset, offset + encoded.length, encoded);
    return encoded.length;
  }

  static void writeDouble(double value, BytesBuilder sink) {
    sink.add(utf8.encode(value.toString()));
  }

  static int writeDoubleToBuffer(double value, Uint8List buffer, int offset) {
    final encoded = utf8.encode(value.toString());
    buffer.setRange(offset, offset + encoded.length, encoded);
    return encoded.length;
  }

  static void writeInt(int value, BytesBuilder sink) {
    sink.add(utf8.encode(value.toString()));
  }

  static int writeIntToBuffer(int value, Uint8List buffer, int offset) {
    final encoded = utf8.encode(value.toString());
    buffer.setRange(offset, offset + encoded.length, encoded);
    return encoded.length;
  }

  static void writeBool(bool value, BytesBuilder sink) {
    sink.add(utf8.encode(value ? 'true' : 'false'));
  }

  static int writeBoolToBuffer(bool value, Uint8List buffer, int offset) {
    final encoded = utf8.encode(value ? 'true' : 'false');
    buffer.setRange(offset, offset + encoded.length, encoded);
    return encoded.length;
  }

  static void writeNull(BytesBuilder sink) {
    sink.add(const [110, 117, 108, 108]); // 'null'
  }

  static int writeNullToBuffer(Uint8List buffer, int offset) {
    buffer[offset] = 110;
    buffer[offset + 1] = 117;
    buffer[offset + 2] = 108;
    buffer[offset + 3] = 108;
    return 4;
  }

  static void writeAsciiLiteral(Uint8List asciiBytes, BytesBuilder sink) {
    sink.add(asciiBytes);
  }

  static int writeAsciiLiteralToBuffer(
    Uint8List asciiBytes,
    Uint8List buffer,
    int offset,
  ) {
    buffer.setRange(offset, offset + asciiBytes.length, asciiBytes);
    return asciiBytes.length;
  }

  static void writeRawJson(Uint8List rawJson, BytesBuilder sink) {
    sink.add(rawJson);
  }

  static int writeRawJsonToBuffer(
    Uint8List rawJson,
    Uint8List buffer,
    int offset,
  ) {
    buffer.setRange(offset, offset + rawJson.length, rawJson);
    return rawJson.length;
  }

  static int writePropertyPrefixToBuffer(
    Uint8List buffer,
    int offset,
    Uint8List asciiKey, {
    required bool isFirst,
  }) {
    var cursor = offset;
    if (!isFirst) {
      buffer[cursor++] = 44; // ','
    }
    for (var i = 0; i < asciiKey.length; i++) {
      buffer[cursor++] = asciiKey[i];
    }
    buffer[cursor++] = 58; // ':'
    return cursor - offset;
  }
}
