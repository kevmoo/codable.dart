/// Immutable key descriptor and key table definitions for indexed field access.
library;

/// Immutable descriptor for an object field key carrying name, index, and wire hints.
final class StaticKey {
  /// The standard logical name of the key.
  final String name;

  /// The unique zero-based sequential index of the key within its domain model.
  final int index;

  /// Optional format-specific wire metadata or alternative aliases.
  final Object? wireMetadata;

  /// Creates a [StaticKey] with the given [name], [index], and optional [wireMetadata].
  const StaticKey(this.name, this.index, [this.wireMetadata]);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StaticKey &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          index == other.index;

  @override
  int get hashCode => Object.hash(name, index);

  @override
  String toString() => 'StaticKey($name, index: $index)';
}

/// Immutable key table used for high-speed indexed key matching.
final class KeyOptions {
  /// The ordered list of recognized key names.
  final List<String> keys;

  final Map<String, int> _indexMap;

  /// Creates a [KeyOptions] table from an ordered list of [keys].
  KeyOptions(List<String> keys)
    : keys = List.unmodifiable(keys),
      _indexMap = {for (var i = 0; i < keys.length; i++) keys[i]: i};

  /// Constructs a [KeyOptions] table from a list of key names.
  factory KeyOptions.of(List<String> keys) => KeyOptions(keys);

  /// Constructs a [KeyOptions] table from a list of [StaticKey] descriptors.
  factory KeyOptions.fromStaticKeys(List<StaticKey> staticKeys) =>
      KeyOptions(staticKeys.map((k) => k.name).toList(growable: false));

  /// Returns the index of [key], or `-1` if not recognized.
  int indexOf(String key) => _indexMap[key] ?? -1;

  /// Returns the number of keys in the table.
  int get length => keys.length;

  /// Returns the key name at the given [index].
  String operator [](int index) => keys[index];

  /// Returns `true` if [key] exists in the table.
  bool contains(String key) => _indexMap.containsKey(key);
}
