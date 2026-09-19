import 'dart:convert';
import 'dart:typed_data';

import 'package:bench_press/bench_press.dart';
import 'package:codable_benchmarks/src/data/embedded_datasets.dart';
import 'package:codable_benchmarks/src/models/json_serializable/canada.dart'
    as js_canada;

final utf8JsonDecoder = utf8.decoder.fuse(json.decoder);

String _sinkMode = 'no-retain';
Object? _retainedOne;
final List<Object?> _ringBuffer = List.filled(8, null);
int _ringIndex = 0;
int _sink = 0;

@pragma('vm:never-inline')
@pragma('dart2js:noInline')
@pragma('wasm:never-inline')
void _consumeResult(Object? value) {
  if (value == null) return;
  if (_sinkMode == 'no-retain') {
    Blackhole.consume(value.hashCode);
  } else if (_sinkMode == 'retain-one') {
    _retainedOne = value;
    _sink += _retainedOne.hashCode;
  } else if (_sinkMode == 'retain-many') {
    _ringBuffer[_ringIndex] = value;
    _ringIndex = (_ringIndex + 1) % _ringBuffer.length;
    _sink += _ringBuffer.last.hashCode;
  }
}

class Data {
  final String name;
  final Uint8List bytes;
  Data(this.name) : bytes = getDatasetBytes(name);
}

void main(List<String> args) async {
  if (args.contains('retain-one'))
    _sinkMode = 'retain-one';
  else if (args.contains('retain-many'))
    _sinkMode = 'retain-many';

  final d = Data('canada');

  final groups = BenchmarkGroup.matrix<Data>(
    cases: [d],
    name: (d) => '${d.name}_decode',
    config: BenchmarkConfig(
      forceRun: true,
      warmupMode: WarmupMode.totalIterations(5),
      calibratedBatchIterations: 20,
    ),
    throughput: (d) => Throughput.bytes(d.bytes.length),
    candidates: {
      'json_serializable': (d) {
        final dynamic jsonAst = utf8JsonDecoder.convert(d.bytes);
        _consumeResult(
          js_canada.CanadaFeatureCollection.fromJson(
            jsonAst as Map<String, dynamic>,
          ),
        );
      },
    },
  );

  await mainBenchmarkSuite(groups.toList(), args);
}
