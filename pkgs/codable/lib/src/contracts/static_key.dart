/// Immutable key table definitions for indexed field access.
library;

import 'package:meta/meta.dart';

/// Immutable key table used for high-speed indexed key matching.
final class KeyOptions {
  /// The ordered list of recognized key names.
  final List<String> keys;

  final Map<String, int> _indexMap;

  Object? _primaryCompiled;
  List<Object>? _secondaryCompiled;

  /// Creates a [KeyOptions] table from an ordered list of [keys].
  KeyOptions(List<String> keys)
    : keys = List.unmodifiable(keys),
      _indexMap = {for (var i = 0; i < keys.length; i++) keys[i]: i};

  /// Constructs a [KeyOptions] table from a list of key names.
  factory KeyOptions.of(List<String> keys) => KeyOptions(keys);

  /// Returns the cached compiled representation of type [T] for this table,
  /// computing and caching it via [compile] on first access.
  ///
  /// Multiple format drivers can safely cache distinct compiled types [T] on
  /// the same shared [KeyOptions] instance without colliding.
  @pragma('vm:prefer-inline')
  @pragma('wasm:prefer-inline')
  @pragma('dart2js:prefer-inline')
  T compiled<T extends Object>(T Function(List<String> keys) compile) {
    final primary = _primaryCompiled;
    if (primary is T) return primary;
    return _compiledSlow<T>(compile);
  }

  @pragma('vm:never-inline')
  @pragma('wasm:never-inline')
  T _compiledSlow<T extends Object>(T Function(List<String> keys) compile) {
    if (_primaryCompiled == null) {
      final created = compile(keys);
      _primaryCompiled = created;
      return created;
    }
    final secondary = _secondaryCompiled ??= <Object>[];
    for (var i = 0; i < secondary.length; i++) {
      final item = secondary[i];
      if (item is T) return item;
    }
    final created = compile(keys);
    secondary.add(created);
    return created;
  }

  /// The index of [key], or `-1` if not recognized.
  int indexOf(String key) => _indexMap[key] ?? -1;

  /// The number of keys in the table.
  int get length => keys.length;

  /// The key name at the given [index].
  String operator [](int index) => keys[index];

  /// Whether [key] exists in the table.
  bool contains(String key) => _indexMap.containsKey(key);
}

/// Internal read-only fast-path cache accessor enabling `package:codable`'s
/// built-in JSON driver to emit a monomorphic static `is` test without
/// dynamic type-argument subtype checks in WasmGC.
@internal
extension InternalKeyOptionsCache on KeyOptions {
  /// The primary cached compiled representation, if populated.
  @pragma('vm:prefer-inline')
  @pragma('wasm:prefer-inline')
  @pragma('dart2js:prefer-inline')
  Object? get primaryCompiled => _primaryCompiled;
}
