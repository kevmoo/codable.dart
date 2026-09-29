/// Immutable key table definitions for indexed field access.
library;

/// Immutable key table used for high-speed indexed key matching.
final class KeyOptions {
  /// The ordered list of recognized key names.
  final List<String> keys;

  final Map<String, int> _indexMap;

  /// Cached format-specific compiled representation (e.g. JsonKeyOptions).
  Object? compiled;

  /// Creates a [KeyOptions] table from an ordered list of [keys].
  KeyOptions(List<String> keys, {this.compiled})
    : keys = List.unmodifiable(keys),
      _indexMap = {for (var i = 0; i < keys.length; i++) keys[i]: i};

  /// Constructs a [KeyOptions] table from a list of key names.
  factory KeyOptions.of(List<String> keys) => KeyOptions(keys);

  /// The index of [key], or `-1` if not recognized.
  int indexOf(String key) => _indexMap[key] ?? -1;

  /// The number of keys in the table.
  int get length => keys.length;

  /// The key name at the given [index].
  String operator [](int index) => keys[index];

  /// Whether [key] exists in the table.
  bool contains(String key) => _indexMap.containsKey(key);
}
