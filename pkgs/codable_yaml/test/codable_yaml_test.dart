// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:checks/checks.dart';
import 'package:codable/codable.dart';
import 'package:codable_yaml/codable_yaml.dart';
import 'package:source_span/source_span.dart';
import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

import '../example/codable_yaml_example.dart';

part 'codable_yaml_test.g.dart';

enum LogLevel { debug, info, warn, error }

@Codable()
final class GridCoord {
  final int row;
  final int col;

  const GridCoord(this.row, this.col);

  @override
  bool operator ==(Object other) =>
      other is GridCoord && other.row == row && other.col == col;

  @override
  int get hashCode => Object.hash(row, col);
}

@Codable(fieldRename: FieldRename.snake)
final class ServiceSpec {
  final String serviceName;
  final LogLevel logLevel;
  final int maxRetries;
  final double? sampleRate;
  final Uint8List? tlsCertDer;
  final Float64List? bounds;
  final List<String> tags;
  final Map<String, int?> featureQuotas;
  final Map<int, String> httpCodes;
  final Map<LogLevel, bool> alertByLevel;
  final Map<GridCoord, String> zoneLabels;

  const ServiceSpec({
    @CodableKey(aliases: ['name']) required this.serviceName,
    this.logLevel = LogLevel.info,
    this.maxRetries = 3,
    this.sampleRate,
    this.tlsCertDer,
    @CodableTuple(2) this.bounds,
    this.tags = const [],
    this.featureQuotas = const {},
    this.httpCodes = const {},
    this.alertByLevel = const {},
    this.zoneLabels = const {},
  });
}

void main() {
  _registerModelRoundtripTests();
  _registerAnchorAndDuplicateTests();
  _registerDiagnosticTests();
  _registerEncoderStyleTests();
  _registerCursorAndMappedTests();
}

void _registerModelRoundtripTests() {
  group('@Codable YAML roundtrips', () {
    test('roundtrips ServiceSpec in both block and flow styles', () {
      final cert = Uint8List.fromList([0x30, 0x82, 0x01, 0x0a]);
      final spec = ServiceSpec(
        serviceName: 'billing-api',
        logLevel: LogLevel.warn,
        maxRetries: 5,
        sampleRate: 0.25,
        tlsCertDer: cert,
        bounds: Float64List.fromList([-122.4, 37.8]),
        tags: const ['prod', 'true', 'null', 'multi\nline'],
        featureQuotas: const {'seats': 100, 'unlimited': null},
        httpCodes: const {200: 'ok', 503: 'maintenance'},
        alertByLevel: const {LogLevel.error: true, LogLevel.debug: false},
        zoneLabels: {
          const GridCoord(0, 0): 'west',
          const GridCoord(1, 2): 'east',
        },
      );

      final blockYaml = YamlCodableEncoder.encode(
        spec,
        const ServiceSpecCodable(),
      );
      final flowYaml = YamlCodableEncoder.encode(
        spec,
        const ServiceSpecCodable(),
        flow: true,
      );
      check(blockYaml).contains(base64Encode(cert));
      check(flowYaml.trim().startsWith('{')).isTrue();
      check(flowYaml.trim().endsWith('}')).isTrue();

      for (final encoded in [blockYaml, flowYaml]) {
        final decoded = YamlCodableDecoder.decode(
          encoded,
          const ServiceSpecCodable(),
        );
        check(decoded.serviceName).equals('billing-api');
        check(decoded.logLevel).equals(LogLevel.warn);
        check(decoded.maxRetries).equals(5);
        check(decoded.sampleRate).equals(0.25);
        check(decoded.tlsCertDer).isNotNull().deepEquals(cert);
        check(decoded.bounds).isNotNull().deepEquals([-122.4, 37.8]);
        check(decoded.tags).deepEquals(['prod', 'true', 'null', 'multi\nline']);
        check(decoded.featureQuotas)
            .deepEquals({'seats': 100, 'unlimited': null});
        check(decoded.httpCodes).deepEquals({200: 'ok', 503: 'maintenance'});
        check(decoded.alertByLevel)
            .deepEquals({LogLevel.error: true, LogLevel.debug: false});
        check(decoded.zoneLabels).deepEquals({
          const GridCoord(0, 0): 'west',
          const GridCoord(1, 2): 'east',
        });
      }
    });

    test('decodes quoted scalar map keys and byte-list fallback', () {
      const raw = '''
name: compat-svc
tls_cert_der: [1, 2, 255]
http_codes:
  "201": created
  404: missing
''';
      final decoded = YamlCodableDecoder.decode(
        raw,
        const ServiceSpecCodable(),
      );
      check(decoded.serviceName).equals('compat-svc');
      check(decoded.tlsCertDer).isNotNull().deepEquals([1, 2, 255]);
      check(decoded.httpCodes).deepEquals({201: 'created', 404: 'missing'});
    });
  });
}

void _registerAnchorAndDuplicateTests() {
  group('YAML anchors, aliases, and duplicate-key rejection', () {
    test('resolves anchors and aliases across nested @Codable models', () {
      const yamlWithAnchors = '''
service: gateway
primary: &shared
  host: internal.corp.example
  port: 8443
  tls: true
fallback: *shared
statusRoutes:
  200: &ok_label healthy
  204: *ok_label
allowedOrigins: &origins
  - https://one.example
''';
      final manifest = YamlCodableDecoder.decode(
        yamlWithAnchors,
        const GatewayManifestCodable(),
      );
      check(manifest.primary.host).equals('internal.corp.example');
      check(manifest.fallback.host).equals('internal.corp.example');
      check(manifest.fallback.port).equals(8443);
      check(manifest.statusRoutes).deepEquals({200: 'healthy', 204: 'healthy'});
      check(manifest.allowedOrigins).deepEquals(['https://one.example']);
    });

    test('rejects duplicate raw YAML mapping keys with SourceSpan', () {
      const dupYaml = '''
service_name: alpha
max_retries: 2
max_retries: 4
''';
      YamlCodableException? caught;
      try {
        YamlCodableDecoder.decode(
          dupYaml,
          const ServiceSpecCodable(),
          sourceUrl: Uri.parse('dup.yaml'),
        );
      } on YamlCodableException catch (e) {
        caught = e;
      }
      check(caught).isNotNull();
      check(caught!).isA<SourceSpanFormatException>();
      check(caught.span).isNotNull();
      check(caught.span!.start.line).equals(2);
      check(caught.toString()).contains('dup.yaml');
    });

    test('rejects logical duplicate field via @CodableKey alias', () {
      const aliasDupYaml = '''
service_name: primary-name
name: alias-name
''';
      check(
            () => YamlCodableDecoder.decode(
              aliasDupYaml,
              const ServiceSpecCodable(),
            ),
          )
          .throws<YamlCodableException>()
          .has((e) => e.message, 'message')
          .contains('Duplicate field');
    });
  });
}

void _registerDiagnosticTests() {
  group('YamlCodableException SourceSpan diagnostics', () {
    test(
      'captures exact line, column, path, and highlight on nested error',
      () {
        const invalidYaml = '''
service: router
primary:
  host: ok.example
  port: not_a_port
fallback:
  host: backup.example
  port: 80
''';
        YamlCodableException? caught;
        try {
          YamlCodableDecoder.decode(
            invalidYaml,
            const GatewayManifestCodable(),
            sourceUrl: Uri.parse('file:///router.yaml'),
          );
        } on YamlCodableException catch (e) {
          caught = e;
        }

        check(caught).isNotNull();
        final err = caught!;
        check(err).isA<CodableException>();
        check(err).isA<SourceSpanFormatException>();
        check(err.formattedPath).equals('primary.port');
        check(err.span).isNotNull();
        check(err.span!.start.line).equals(3);
        check(err.span!.start.column).equals(8);
        check(err.span!.text).equals('not_a_port');
        check(err.toString())
            .contains('line 4, column 9 of file:///router.yaml');
        check(err.toString()).contains('not_a_port');
      },
    );

    test('reports invalid enum map key span and indexed list path', () {
      const badMapKey = '''
service_name: svc
alert_by_level:
  verbose: true
''';
      YamlCodableException? keyErr;
      try {
        YamlCodableDecoder.decode(badMapKey, const ServiceSpecCodable());
      } on YamlCodableException catch (e) {
        keyErr = e;
      }
      check(keyErr).isNotNull();
      check(keyErr!.span!.text).equals('verbose');
      check(keyErr.formattedPath).equals('alert_by_level.verbose');

      const badListElem = '''
service_name: svc
tags:
  - valid
  - [nested]
''';
      YamlCodableException? listErr;
      try {
        YamlCodableDecoder.decode(badListElem, const ServiceSpecCodable());
      } on YamlCodableException catch (e) {
        listErr = e;
      }
      check(listErr).isNotNull();
      check(listErr!.formattedPath).equals('tags[1]');
    });
  });
}

void _registerEncoderStyleTests() {
  group('YamlCodableEncoder special scalars and empty collections', () {
    test('roundtrips NaN, infinities, empty containers, and null root', () {
      final specialDoubles = <double>[
        double.nan,
        double.infinity,
        double.negativeInfinity,
        -0.0,
        42.5,
      ];
      final doubleListCodec = Codable<List<double>>.fromFunctions(
        decode: (d) => [
          for (final u = d.unkeyed(); u.moveNext();) u.readDouble(),
        ],
        encode: (list, e) {
          final u = e.unkeyed(length: list.length);
          for (final item in list) {
            u.encodeDouble(item);
          }
        },
      );

      final encoded = YamlCodableEncoder.encode(
        specialDoubles,
        doubleListCodec,
      );
      check(encoded).contains('.nan');
      check(encoded).contains('.inf');
      check(encoded).contains('-.inf');

      final decoded = YamlCodableDecoder.decode(encoded, doubleListCodec);
      check(decoded[0].isNaN).isTrue();
      check(decoded[1]).equals(double.infinity);
      check(decoded[2]).equals(double.negativeInfinity);
      check(decoded[4]).equals(42.5);

      const emptySpec = ServiceSpec(serviceName: 'minimal');
      final minimalYaml = YamlCodableEncoder.encode(
        emptySpec,
        const ServiceSpecCodable(),
      );
      check(minimalYaml).contains('tags: []');
      check(minimalYaml).contains('http_codes: {}');
    });
  });
}

void _registerCursorAndMappedTests() {
  group(
    'YamlCodableDecoder.fromNode, MappedDecoder, and cursor invariants',
    () {
      test('supports fromNode, MappedDecoder random access, and userInfo', () {
        final root = loadYamlNode('''
id: 7
ratio: 1.5
active: true
label: main
emptyVal: null
nums: [10, 20.5]
bytes: AQID
''');
        final decoder = YamlCodableDecoder.fromNode(
          root,
          userInfo: const {'env': 'test'},
        );
        check(decoder.isHumanReadable).isTrue();
        check(decoder.payload).isNull();
        check(decoder.userInfo['env']).equals('test');
        check(decoder.peekKind()).equals(ValueKind.map);

        final mapped = decoder.mapped();
        check(mapped.containsKey('id')).isTrue();
        check(mapped.containsKey('missing')).isFalse();
        check(mapped.isNull('emptyVal')).isTrue();
        check(mapped.isNull('missing')).isTrue();
        check(mapped.readInt('id')).equals(7);
        check(mapped.readDouble('ratio')).equals(1.5);
        check(mapped.readNum('ratio')).equals(1.5);
        check(mapped.readBool('active')).isTrue();
        check(mapped.readString('label')).equals('main');
        check(mapped.readNullableString('emptyVal')).isNull();
        check(mapped.readBytes('bytes')).deepEquals([1, 2, 3]);
        check(mapped.decodeDoubleList('nums')).deepEquals([10.0, 20.5]);
        check(() => mapped.readInt('missing')).throws<CodableException>();
      });

      test(
        'enforces MapEncoder key/value ordering and KeyedDecoder peekKey',
        () {
          final encoder = YamlCodableEncoder();
          check(encoder.isHumanReadable).isTrue();
          final mapEnc = encoder.map();
          check(mapEnc.valueEncoder).throws<CodableException>();
          mapEnc.keyEncoder().singleValue().encodeInt(1);
          check(mapEnc.keyEncoder).throws<CodableException>();
          mapEnc.valueEncoder().singleValue().encodeString('one');

          final node = loadYamlNode('first: 1\nsecond: 2\n');
          final keyed = YamlCodableDecoder.fromNode(node).keyed();
          check(keyed.peekKey()).equals('first');
          check(keyed.nextKey()).equals('first');
          check(keyed.readInt()).equals(1);
          keyed.skipValue();
          check(keyed.moveNextKey()).isFalse();
        },
      );
    },
  );
}
