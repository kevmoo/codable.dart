// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:codable/codable_json.dart' show isMockSubstrate;
import 'package:path/path.dart' as p;

import 'profiler/benchmark_harness.dart'
    show defaultIterationsFor, supportedBenchmarks;
import 'profiler/chrome_controller.dart';
import 'profiler/exceptions.dart';
import 'profiler/hotspot_analyzer.dart';
import 'profiler/profile_model.dart';
import 'profiler/profile_symbolicator.dart';
import 'profiler/server.dart';

String _findHarnessPath() {
  final candidate1 = p.join(
    'pkgs',
    'codable_benchmarks',
    'tool',
    'profiler',
    'benchmark_harness.dart',
  );
  if (File(candidate1).existsSync()) return candidate1;

  final candidate2 = p.join('tool', 'profiler', 'benchmark_harness.dart');
  if (File(candidate2).existsSync()) return candidate2;

  final scriptDir = p.dirname(p.fromUri(Platform.script));
  final candidate3 = p.join(scriptDir, 'profiler', 'benchmark_harness.dart');
  if (File(candidate3).existsSync()) return candidate3;

  return candidate2;
}

void main(List<String> arguments) async {
  final parser = ArgParser()
    ..addOption(
      'benchmark',
      abbr: 'b',
      defaultsTo: 'twitter_decode',
      help: 'Target benchmark (e.g. twitter_decode, citm_catalog_decode).',
    )
    ..addOption(
      'impl',
      defaultsTo: 'codable',
      allowed: ['codable', 'json_serializable', 'codable_reader', 'codable_js'],
      help:
          'Implementation candidate to profile (codable, json_serializable, '
          'codable_reader, codable_js).',
    )
    ..addFlag(
      'force-reader',
      defaultsTo: false,
      negatable: false,
      help: 'Force using JsonCodableDecoder.fromReader (now default on Wasm).',
    )
    ..addFlag(
      'force-js',
      defaultsTo: false,
      negatable: false,
      help: 'Force using legacy browser JS DOM / JSON.parse driver on Wasm.',
    )
    ..addOption(
      'iterations',
      abbr: 'i',
      help: 'Iteration count (defaults to calibrated benchmark count).',
    )
    ..addOption(
      'sampling-interval',
      abbr: 's',
      defaultsTo: '250',
      help: 'V8 CPU profiler sampling interval in microseconds.',
    )
    ..addOption(
      'output',
      abbr: 'o',
      defaultsTo: 'build/profiler',
      help: 'Output directory for build artifacts and profiles.',
    )
    ..addOption(
      'top',
      defaultsTo: '10',
      help: 'Number of top hot functions to display.',
    )
    ..addFlag(
      'compile',
      defaultsTo: true,
      help: 'Compile benchmark harness to Wasm before running.',
    )
    ..addFlag(
      'verbose',
      abbr: 'v',
      defaultsTo: false,
      negatable: false,
      help: 'Show verbose output (browser logs, compilation output).',
    )
    ..addFlag(
      'allow-mock',
      defaultsTo: false,
      negatable: false,
      help: 'Allow running benchmarks on the MOCK substrate.',
    )
    ..addFlag(
      'help',
      abbr: 'h',
      negatable: false,
      help: 'Show this usage information.',
    );

  late final ArgResults results;
  try {
    results = parser.parse(arguments);
  } catch (e) {
    stderr.writeln('Error: $e\\n');
    stderr.writeln(parser.usage);
    exitCode = 64;
    return;
  }

  if (results['help'] as bool) {
    print('Usage: dart run tool/profile_benchmark.dart [options]\n');
    print(parser.usage);
    return;
  }

  if (isMockSubstrate && !(results['allow-mock'] as bool)) {
    stderr.writeln(
      '❌ ERROR: Running benchmarks on the MOCK substrate is prohibited to '
      'prevent false optimization targets.',
    );
    stderr.writeln(
      '   Pass --allow-mock to bypass this guard if you explicitly intend to '
      'benchmark the mock payload.',
    );
    exitCode = 1;
    return;
  }

  print('\n${'=' * 60}');
  print('🎯 SUBSTRATE METADATA');
  print(
    'Mode: ${isMockSubstrate ? "MOCK (pure-Dart)" : "NATIVE (dart:convert)"}',
  );
  print('SDK Binary: ${Platform.resolvedExecutable}');
  print('SDK Version: ${Platform.version}');
  print('${'=' * 60}\n');

  final benchmark = results['benchmark'] as String;
  final normalizedBenchmark = benchmark.toLowerCase().replaceAll('-', '_');
  const validBenchmarks = {
    ...supportedBenchmarks,
    'twitter',
    'citm',
    'citm_catalog',
    'citm_decode',
    'citm_encode',
    'canada',
    'coord',
    'coord_decode',
    'coord_encode',
    'coordinates',
    'small',
  };

  if (!validBenchmarks.contains(normalizedBenchmark)) {
    stderr.writeln('Error: Unknown benchmark "$benchmark".');
    stderr.writeln('Supported benchmarks: ${supportedBenchmarks.join(', ')}\n');
    stderr.writeln(parser.usage);
    exitCode = 64;
    return;
  }

  final rawImpl = results['impl'] as String;
  final impl = (results['force-js'] as bool)
      ? 'codable_js'
      : (results['force-reader'] as bool)
      ? 'codable_reader'
      : rawImpl;
  final iterationsStr = results['iterations'] as String?;
  final iterations = iterationsStr != null
      ? int.tryParse(iterationsStr)
      : defaultIterationsFor(benchmark);
  final samplingIntervalUs =
      int.tryParse(results['sampling-interval'] as String) ?? 250;
  final outDirPath = results['output'] as String;
  final topN = int.tryParse(results['top'] as String) ?? 10;
  final shouldCompile = results['compile'] as bool;
  final verbose = results['verbose'] as bool;

  final outDir = Directory(outDirPath);
  if (!outDir.existsSync()) {
    outDir.createSync(recursive: true);
  }

  final wasmFile = File(p.join(outDir.path, 'benchmark.wasm'));
  final mapFile = File(p.join(outDir.path, 'benchmark.wasm.map'));
  final profileFile = File(p.join(outDir.path, 'profile.json'));
  final symbolicatedFile = File(
    p.join(outDir.path, 'profile_symbolicated.json'),
  );

  print('🎯 Target Benchmark : $benchmark');
  print('⚙️  Implementation   : $impl');
  print('🔁 Iterations       : $iterations');
  print('⏱️  Sampling Interval: $samplingIntervalUs µs');
  print('📁 Output Directory : ${outDir.absolute.path}\n');

  // Step 1: Compile to Wasm if needed
  if (shouldCompile || !wasmFile.existsSync()) {
    print('📦 Compiling harness to WebAssembly (with source maps)...');
    final actualHarnessPath = _findHarnessPath();

    final compileArgs = [
      'compile',
      'wasm',
      actualHarnessPath,
      '-o',
      wasmFile.path,
      '--source-maps',
    ];

    final compileProcess = await Process.run(
      Platform.resolvedExecutable,
      compileArgs,
    );
    if (compileProcess.exitCode != 0) {
      stderr.writeln('❌ Wasm compilation failed:');
      stderr.writeln(compileProcess.stderr);
      stderr.writeln(compileProcess.stdout);
      exitCode = 1;
      return;
    }
    print('✅ Compiled ${wasmFile.path} successfully.');
  } else {
    print('⚡ Using cached ${wasmFile.path} (skip compile).');
  }

  // Step 2: Create HTML harness
  final htmlFile = File(p.join(outDir.path, 'index.html'));
  await htmlFile.writeAsString('''
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>Wasm Benchmark Profiler</title>
</head>
<body>
  <h1>Wasm Benchmark Profiler</h1>
  <div id="status">Initializing...</div>
  <script type="module">
    import { compileStreaming } from './benchmark.mjs';

    const params = new URLSearchParams(window.location.search);
    const benchmark = params.get('benchmark') || 'twitter_decode';
    const iterations = params.get('iterations') || '';
    const impl = params.get('impl') || 'codable';

    window.__benchmark_status = 'loading';

    try {
      const app = await compileStreaming(fetch('./benchmark.wasm'));
      const instantiated = await app.instantiate();
      window.__benchmark_app = instantiated;
      window.__benchmark_status = 'ready';
      document.getElementById('status').innerText = 'Ready: ' + benchmark + ' (' + impl + ')';
      console.log(`[Profiler] Wasm ready: benchmark=\${benchmark}, iterations=\${iterations}, impl=\${impl}`);

      window.runBenchmark = async function() {
        window.__benchmark_status = 'running';
        document.getElementById('status').innerText = 'Running benchmark...';
        console.log(`[Profiler] Executing benchmark...`);
        const t0 = performance.now();
        try {
          instantiated.invokeMain(benchmark, String(iterations), impl);
          const dur = performance.now() - t0;
          window.__benchmark_status = 'finished';
          window.__benchmark_elapsed_ms = dur;
          document.getElementById('status').innerText = `Finished in \${dur.toFixed(2)} ms`;
          console.log(`[Profiler] Completed in \${dur.toFixed(2)} ms.`);
          return dur;
        } catch (err) {
          window.__benchmark_status = 'error';
          window.__benchmark_error = String(err);
          document.getElementById('status').innerText = 'Error: ' + err;
          console.error('[Profiler] Error executing benchmark:', err);
          throw err;
        }
      };
    } catch (err) {
      window.__benchmark_status = 'error';
      window.__benchmark_error = String(err);
      document.getElementById('status').innerText = 'Error: ' + err;
      console.error('[Profiler] Error:', err);
    }
  </script>
</body>
</html>
''');

  // Step 3: Start DevServer
  final server = BenchmarkServer();
  final port = await server.start(outDir.path);
  print('🌐 Serving build assets on http://127.0.0.1:$port');

  // Step 4: Launch Chrome & CDP Controller
  final controller = ChromeController();
  StreamSubscription<ProcessSignal>? sigintSub;
  StreamSubscription<ProcessSignal>? sigtermSub;
  if (!Platform.isWindows) {
    void handleSignal(ProcessSignal signal) async {
      try {
        stderr.writeln('\nReceived $signal, aborting profiler...');
        await controller.stop();
        await server.stop();
      } catch (_) {
        // Ignore cleanup errors on abort
      } finally {
        exit(signal == ProcessSignal.sigint ? 130 : 143);
      }
    }

    sigintSub = ProcessSignal.sigint.watch().listen(handleSignal);
    sigtermSub = ProcessSignal.sigterm.watch().listen(handleSignal);
  }

  final queryArgs = [
    'benchmark=$benchmark',
    'impl=$impl',
    if (iterations != null) 'iterations=$iterations',
  ].join('&');
  final harnessUrl = 'http://127.0.0.1:$port/index.html?$queryArgs';

  print('🚀 Launching headless Chrome and navigating to harness...');
  try {
    await controller.start(
      harnessUrl,
      onConsoleMessage: (type, message) {
        if (verbose || message.contains('[Profiler]')) {
          print('   [Chrome Console] $message');
        }
      },
      verbose: verbose,
    );

    // Step 5: Wait for Wasm ready
    final readyDeadline = DateTime.now().add(const Duration(seconds: 45));
    var isReady = false;
    while (DateTime.now().isBefore(readyDeadline)) {
      final res = await controller.evaluate('window.__benchmark_status');
      final resMap = res?.result;
      final resultObj = resMap != null
          ? resMap['result'] as Map<String, dynamic>?
          : null;
      final status = resultObj?['value'] as String?;
      if (status == 'ready') {
        isReady = true;
        break;
      }
      if (status == 'error') {
        final errRes = await controller.evaluate('window.__benchmark_error');
        final errMap = errRes?.result;
        final errObj = errMap != null
            ? errMap['result'] as Map<String, dynamic>?
            : null;
        final errMsg = errObj?['value'];
        throw ProfilerException('Browser Wasm init error: $errMsg');
      }
      await Future<void>.delayed(const Duration(milliseconds: 50));
    }

    if (!isReady) {
      throw ProfilerException('Timed out waiting for Wasm initialization.');
    }

    // Step 6: Start Profiling & Execute Benchmark
    print('🔬 Starting V8 CPU profiler ($samplingIntervalUs µs interval)...');
    await controller.startProfiling(intervalUs: samplingIntervalUs);

    print('⚡ Executing benchmark in Chrome...');
    final runRes = await controller.evaluate(
      'window.runBenchmark()',
      awaitPromise: true,
    );

    final runMap = runRes?.result;
    if (runMap != null && runMap['exceptionDetails'] != null) {
      final details = runMap['exceptionDetails'] as Map<String, dynamic>;
      final text = details['text'] ?? 'Unknown error';
      final exception = details['exception'] as Map<String, dynamic>?;
      final desc = exception?['description'] ?? text;
      throw ProfilerException('Benchmark execution failed in browser: $desc');
    }

    num? elapsedMs;
    final runObj = runMap != null
        ? runMap['result'] as Map<String, dynamic>?
        : null;
    final runVal = runObj?['value'];
    if (runVal is num) {
      elapsedMs = runVal;
    }

    print('🛑 Stopping profiler and retrieving samples...');
    final rawProfile = await controller.stopProfiling();

    await profileFile.writeAsString(json.encode(rawProfile));
    print('💾 Saved raw profile to ${profileFile.path}');

    if (elapsedMs != null) {
      print('⏱️  Benchmark duration: ${elapsedMs.toStringAsFixed(2)} ms');
    }

    // Step 7: Symbolicate Profile
    print('\n🔍 Symbolicating Wasm call frames against ${mapFile.path}...');
    final symbolicatedJson = await symbolicateProfile(
      profilePath: profileFile.path,
      sourceMapPath: mapFile.path,
    );
    await symbolicatedFile.writeAsString(json.encode(symbolicatedJson));
    print('💾 Saved symbolicated profile to ${symbolicatedFile.path}\n');

    // Step 8: Analyze and Print Hotspots
    final profile = CpuProfile.fromJson(symbolicatedJson);
    final hotspots = HotspotAnalyzer.analyze(profile, topN: topN);

    final divider = '=' * 78;
    print(divider);
    print('🔥 TOP $topN HOT DART METHODS: $benchmark ($impl)');
    print(divider);
    print('Total Profile Samples Collected: ${profile.samples.length}');
    if (elapsedMs != null) {
      print('Execution Duration: ${elapsedMs.toStringAsFixed(2)} ms');
    }
    print('');

    final markdownTable = HotspotAnalyzer.formatMarkdownTable(
      hotspots,
      totalSamples: profile.samples.length,
    );
    print(markdownTable);
    print('$divider\n');
  } on ProfilerException catch (e) {
    stderr.writeln('\n❌ Profiler error: $e');
    exitCode = 1;
  } finally {
    await sigintSub?.cancel();
    await sigtermSub?.cancel();
    await controller.stop();
    await server.stop();
  }
  exit(exitCode);
}
