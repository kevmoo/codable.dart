import 'dart:convert';
import 'dart:typed_data';

/// Pre-compiled key lookup options for fast-path UTF-8 property matching.
///
/// Enables matching raw UTF-8 byte spans against expected JSON field names
/// without intermediate Dart `String` allocations.
final class JsonKeyOptions {
  /// The list of original string keys.
  final List<String> keys;

  /// The pre-encoded UTF-8 byte representations of each key.
  final List<Uint8List> _utf8Keys;

  JsonKeyOptions._(this.keys, this._utf8Keys);

  /// Creates a [JsonKeyOptions] lookup table from the given [keys].
  ///
  /// Throws [ArgumentError] if [keys] is empty.
  factory JsonKeyOptions.of(List<String> keys) {
    if (keys.isEmpty) {
      return JsonKeyOptions._(const [], const []);
    }
    final utf8Keys = List<Uint8List>.generate(
      keys.length,
      (i) => Uint8List.fromList(utf8.encode(keys[i])),
      growable: false,
    );
    return JsonKeyOptions._(List.unmodifiable(keys), utf8Keys);
  }


  /// The number of registered keys in this options table.
  int get length => keys.length;

  /// Matches the byte span `[start, end)` in [source] against the pre-compiled
  /// keys, returning the zero-based index of the matching key, or `-1` if unmatched.
  int selectKey(Uint8List source, int start, int end) {
    if (start < 0 || end > source.length || start > end) {
      return -1;
    }
    final spanLen = end - start;
    for (var i = 0; i < _utf8Keys.length; i++) {
      final keyBytes = _utf8Keys[i];
      if (keyBytes.length != spanLen) continue;
      var match = true;
      for (var j = 0; j < spanLen; j++) {
        if (source[start + j] != keyBytes[j]) {
          match = false;
          break;
        }
      }
      if (match) return i;
    }
    return -1;
  }
}
