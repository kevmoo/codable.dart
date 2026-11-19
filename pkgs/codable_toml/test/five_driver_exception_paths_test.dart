// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:typed_data';

import 'package:checks/checks.dart';
import 'package:codable/codable.dart';
import 'package:codable/codable_json.dart';
import 'package:codable_cbor/codable_cbor.dart';
import 'package:codable_msgpack/codable_msgpack.dart';
import 'package:codable_toml/codable_toml.dart';
import 'package:codable_yaml/codable_yaml.dart';
import 'package:test/test.dart';

final _rootKeys = KeyOptions.of(const [
  'title',
  'stage',
  'stages',
  'tuple2',
  'raw',
  'server',
  'nodes',
  'intMap',
  'strMap',
  'stageQuotas',
]);
final _serverKeys = KeyOptions.of(const ['host', 'port', 'ports']);
final _stageValues = KeyOptions.of(const ['dev', 'staging', 'prod']);

void _writeTree(Object? value, Encoder encoder) {
  switch (value) {
    case null:
      encoder.singleValue().encodeNull();
    case final bool v:
      encoder.singleValue().encodeBool(v);
    case final int v:
      encoder.singleValue().encodeInt(v);
    case final double v:
      encoder.singleValue().encodeDouble(v);
    case final String v:
      encoder.singleValue().encodeString(v);
    case final Uint8List v:
      encoder.singleValue().encodeBytes(v);
    case final List<Object?> list:
      final u = encoder.unkeyed(length: list.length);
      for (final item in list) {
        _writeTree(item, u.nestedEncoder());
      }
    case final Map<String, Object?> map:
      final k = encoder.keyed(length: map.length);
      for (final MapEntry(:key, value: val) in map.entries) {
        _writeTree(val, k.nestedEncoder(key));
      }
    case final Map<Object?, Object?> map:
      final m = encoder.map(length: map.length);
      for (final MapEntry(:key, value: val) in map.entries) {
        _writeTree(key, m.keyEncoder());
        _writeTree(val, m.valueEncoder());
      }
    default:
      throw ArgumentError('Unsupported tree node: $value');
  }
}

const _treeEncodable = Encodable<Map<String, Object?>>.fromFunction(_writeTree);

sealed class _PluginConfig {
  const _PluginConfig();
}

final class _HttpPlugin extends _PluginConfig {
  final int timeoutMs;
  const _HttpPlugin(this.timeoutMs);
}

final class _HttpPluginDecodable implements Decodable<_HttpPlugin> {
  const _HttpPluginDecodable();

  @override
  _HttpPlugin decode(Decoder decoder) {
    final k = decoder.keyed(options: KeyOptions.of(const ['timeoutMs']));
    int? timeoutMs;
    while (k.moveNextKey()) {
      if (k.selectKeyIndex(KeyOptions.of(const ['timeoutMs'])) == 0) {
        timeoutMs = k.readInt();
      } else {
        k.skipValue();
      }
    }
    if (timeoutMs == null) {
      throw const CodableException(
        'Missing required fields for HttpPlugin: timeoutMs',
      );
    }
    return _HttpPlugin(timeoutMs);
  }
}

final class _PluginSuperDecodable extends SuperDecodable<_PluginConfig> {
  const _PluginSuperDecodable();

  @override
  String get discriminatorKey => 'kind';

  @override
  Map<String, Decodable<_PluginConfig>> get subtypes => const {
    'http': _HttpPluginDecodable(),
  };
}

final class _StageDecodable implements Decodable<String> {
  const _StageDecodable();

  @override
  String decode(Decoder decoder) {
    final s = decoder.singleValue().readString();
    final idx = _stageValues.indexOf(s);
    if (idx < 0) {
      throw CodableException('Unknown Stage value: "$s"', actualValue: s);
    }
    return _stageValues[idx];
  }
}

final class _ServerDecodable implements Decodable<Map<String, Object?>> {
  const _ServerDecodable();

  @override
  Map<String, Object?> decode(Decoder decoder) {
    final k = decoder.keyed(options: _serverKeys);
    var seen = 0;
    String? host;
    int? port;
    List<int>? ports;
    while (k.moveNextKey()) {
      switch (k.selectKeyIndex(_serverKeys)) {
        case 0:
          seen |= 1;
          host = k.readString();
        case 1:
          seen |= 2;
          port = k.readInt();
        case 2:
          ports = k.decodeIntList();
        default:
          k.skipValue();
      }
    }
    if ((seen & 3) != 3) {
      throw const CodableException(
        'Missing required fields for Server: host, port',
      );
    }
    return {'host': host, 'port': port, 'ports': ports};
  }
}

Map<int, String> _decodeIntMap(Decoder decoder) {
  final m = decoder.map();
  final out = <int, String>{};
  while (m.moveNextEntry()) {
    final key = m.keyDecoder().singleValue().readInt();
    out[key] = m.valueDecoder().singleValue().readString();
  }
  return out;
}

Map<String, String> _decodeStringMapViaMapDecoder(Decoder decoder) {
  final m = decoder.map();
  final out = <String, String>{};
  while (m.moveNextEntry()) {
    final key = m.keyDecoder().singleValue().readString();
    out[key] = m.valueDecoder().singleValue().readString();
  }
  return out;
}

Map<String, int> _decodeStageQuotas(Decoder decoder) {
  final m = decoder.map();
  final out = <String, int>{};
  while (m.moveNextEntry()) {
    final key = const _StageDecodable().decode(m.keyDecoder());
    out[key] = m.valueDecoder().singleValue().readInt();
  }
  return out;
}

final class _ManifestDecodable implements Decodable<Map<String, Object?>> {
  const _ManifestDecodable();

  @override
  Map<String, Object?> decode(Decoder decoder) {
    final k = decoder.keyed(options: _rootKeys);
    var seenTitle = false;
    final out = <String, Object?>{};
    while (k.moveNextKey()) {
      switch (k.selectKeyIndex(_rootKeys)) {
        case 0:
          if (seenTitle) {
            throw const CodableException('Duplicate field "title"');
          }
          seenTitle = true;
          out['title'] = k.readString();
        case 1:
          final idx = k.selectStringIndex(_stageValues);
          if (idx < 0) throw const CodableException('Unknown Stage value');
          out['stage'] = _stageValues[idx];
        case 2:
          out['stages'] = k.decodeList(const _StageDecodable());
        case 3:
          final list = k.decodeFloat64List();
          if (list.length != 2) {
            throw CodableException(
              'Expected tuple of length 2, got ${list.length}',
            );
          }
          out['tuple2'] = list;
        case 4:
          out['raw'] = k.readBytes();
        case 5:
          out['server'] = k.decodeValue(const _ServerDecodable());
        case 6:
          out['nodes'] = k.decodeList(const _PluginSuperDecodable());
        case 7:
          out['intMap'] = _decodeIntMap(k.nestedDecoder());
        case 8:
          out['strMap'] = _decodeStringMapViaMapDecoder(k.nestedDecoder());
        case 9:
          out['stageQuotas'] = _decodeStageQuotas(k.nestedDecoder());
        default:
          k.skipValue();
      }
    }
    if (!seenTitle) {
      throw const CodableException(
        'Missing required fields for Manifest: title',
      );
    }
    return out;
  }
}

void _assertFiveDriverParity<T>(
  Map<String, Object?> document,
  Decodable<T> decodable,
  List<Object> expectedPath,
  String expectedFormatted,
) {
  final jsonBytes = JsonCodableEncoder.toBytes(document, _treeEncodable);
  final yamlText = YamlCodableEncoder.encode(document, _treeEncodable);
  final tomlText = TomlCodableEncoder.encode(document, _treeEncodable);
  final cborBytes = CborCodableEncoder.encode(document, _treeEncodable);
  final msgPackBytes = MsgPackCodableEncoder.encode(document, _treeEncodable);

  final runners = <(String, T Function())>[
    (
      'json-default',
      () => JsonCodableDecoder.decodeBytes(jsonBytes, decodable),
    ),
    (
      'json-js-dom',
      () => JsonCodableDecoder.decodeBytes(
        jsonBytes,
        decodable,
        userInfo: const {#forceJsDom: true},
      ),
    ),
    ('yaml', () => YamlCodableDecoder.decode(yamlText, decodable)),
    ('toml', () => TomlCodableDecoder.decode(tomlText, decodable)),
    ('cbor', () => CborCodableDecoder.decode(cborBytes, decodable)),
    ('msgpack', () => MsgPackCodableDecoder.decode(msgPackBytes, decodable)),
  ];

  for (final (driverName, run) in runners) {
    CodableException? caught;
    try {
      run();
    } on CodableException catch (e) {
      caught = e;
    }
    check(caught, because: 'driver=$driverName').isNotNull();
    check(caught!.path, because: 'driver=$driverName').deepEquals(expectedPath);
    check(
      caught.formattedPath,
      because: 'driver=$driverName',
    ).equals(expectedFormatted);
    if (driverName == 'yaml') {
      check(caught)
          .isA<YamlCodableException>()
          .has('span', (e) => e.span)
          .isNotNull();
    }
    if (driverName == 'toml') {
      final tomlEx = caught as TomlCodableException;
      check(tomlEx.line).isNotNull();
      check(tomlEx.column).isNotNull();
    }
  }
}

void main() {
  group(
    '5-driver CodableException.path parity (JSON, YAML, TOML, CBOR, MsgPack)',
    () {
      test(
        'nested scalar, primitive list, map key/value, and byte-list paths',
        () {
          _assertFiveDriverParity(
            <String, Object?>{
              'title': 'svc',
              'server': <String, Object?>{
                'host': 'localhost',
                'port': 'eighty',
              },
            },
            const _ManifestDecodable(),
            const ['server', 'port'],
            'server.port',
          );

          _assertFiveDriverParity(
            <String, Object?>{
              'title': 'svc',
              'server': <String, Object?>{
                'host': 'localhost',
                'port': 80,
                'ports': <Object?>[80, 443, 'bad'],
              },
            },
            const _ManifestDecodable(),
            const ['server', 'ports', 2],
            'server.ports[2]',
          );

          _assertFiveDriverParity(
            <String, Object?>{
              'title': 'svc',
              'intMap': <Object?, Object?>{200: 'ok', 'nan_key': 'fail'},
            },
            const _ManifestDecodable(),
            const ['intMap', 'nan_key'],
            'intMap.nan_key',
          );

          _assertFiveDriverParity(
            <String, Object?>{
              'title': 'svc',
              'strMap': <String, Object?>{'ok_key': 'ok', 'bad_val': 999},
            },
            const _ManifestDecodable(),
            const ['strMap', 'bad_val'],
            'strMap.bad_val',
          );

          _assertFiveDriverParity(
            <String, Object?>{
              'title': 'svc',
              'raw': <Object?>[0, 255, 256],
            },
            const _ManifestDecodable(),
            const ['raw', 2],
            'raw[2]',
          );
        },
      );

      test(
        'missing required fields, enum, List<Enum>, Map<Enum, V>, & tuple',
        () {
          _assertFiveDriverParity(
            <String, Object?>{'stage': 'dev'},
            const _ManifestDecodable(),
            const [],
            '',
          );

          _assertFiveDriverParity(
            <String, Object?>{
              'title': 'svc',
              'server': <String, Object?>{'host': 'localhost'},
            },
            const _ManifestDecodable(),
            const ['server'],
            'server',
          );

          _assertFiveDriverParity(
            <String, Object?>{'title': 'svc', 'stage': 'canary'},
            const _ManifestDecodable(),
            const ['stage'],
            'stage',
          );

          _assertFiveDriverParity(
            <String, Object?>{
              'title': 'svc',
              'stages': <Object?>['dev', 'canary'],
            },
            const _ManifestDecodable(),
            const ['stages', 1],
            'stages[1]',
          );

          _assertFiveDriverParity(
            <String, Object?>{
              'title': 'svc',
              'stageQuotas': <String, Object?>{'dev': 10, 'canary': 1},
            },
            const _ManifestDecodable(),
            const ['stageQuotas', 'canary'],
            'stageQuotas.canary',
          );

          _assertFiveDriverParity(
            <String, Object?>{
              'title': 'svc',
              'tuple2': <Object?>[1.5],
            },
            const _ManifestDecodable(),
            const ['tuple2'],
            'tuple2',
          );
        },
      );

      test(
        'nested SuperDecodable & MappedDecoder missing/unknown/subtype paths',
        () {
          _assertFiveDriverParity(
            <String, Object?>{
              'title': 'svc',
              'nodes': <Object?>[
                <String, Object?>{'kind': 'http', 'timeoutMs': 100},
                <String, Object?>{'timeoutMs': 200},
              ],
            },
            const _ManifestDecodable(),
            const ['nodes', 1, 'kind'],
            'nodes[1].kind',
          );

          _assertFiveDriverParity(
            <String, Object?>{
              'title': 'svc',
              'nodes': <Object?>[
                <String, Object?>{'kind': 'http', 'timeoutMs': 100},
                <String, Object?>{'kind': 'grpc', 'timeoutMs': 200},
              ],
            },
            const _ManifestDecodable(),
            const ['nodes', 1, 'kind'],
            'nodes[1].kind',
          );

          _assertFiveDriverParity(
            <String, Object?>{
              'title': 'svc',
              'nodes': <Object?>[
                <String, Object?>{'kind': 'http', 'timeoutMs': 100},
                <String, Object?>{'kind': 'http', 'timeoutMs': 'slow'},
              ],
            },
            const _ManifestDecodable(),
            const ['nodes', 1, 'timeoutMs'],
            'nodes[1].timeoutMs',
          );

          _assertFiveDriverParity(
            <String, Object?>{
              'title': 'svc',
              'nodes': <Object?>[
                <String, Object?>{'kind': 'http', 'timeoutMs': 100},
                <String, Object?>{'kind': 'http'},
              ],
            },
            const _ManifestDecodable(),
            const ['nodes', 1],
            'nodes[1]',
          );

          _assertFiveDriverParity(
            <String, Object?>{
              'nested': <String, Object?>{'present': 1},
            },
            Decodable.fromFunction(
              (d) =>
                  d.mapped().nestedDecoder('nested').mapped().readInt('nested'),
            ),
            const ['nested', 'nested'],
            'nested.nested',
          );
        },
      );
    },
  );
}
