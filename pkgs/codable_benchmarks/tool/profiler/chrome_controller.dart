// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:webkit_inspection_protocol/webkit_inspection_protocol.dart';

import 'exceptions.dart';

class ChromeController {
  Process? _chromeProcess;
  WipConnection? _connection;
  Directory? _tempDir;

  String _resolveChromePath() {
    final envPath =
        Platform.environment['CHROME_PATH'] ??
        Platform.environment['CHROME_EXECUTABLE'];
    if (envPath != null && envPath.isNotEmpty && File(envPath).existsSync()) {
      return envPath;
    }

    if (Platform.isLinux) {
      const candidates = [
        '/usr/bin/google-chrome',
        '/usr/bin/google-chrome-stable',
        '/usr/bin/chromium',
        '/usr/bin/chromium-browser',
      ];
      for (final candidate in candidates) {
        if (File(candidate).existsSync()) return candidate;
      }
      return 'google-chrome';
    } else if (Platform.isMacOS) {
      const macCandidates = [
        '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome',
        '/Applications/Google Chrome Canary.app/Contents/MacOS/Google Chrome Canary',
        '/Applications/Chromium.app/Contents/MacOS/Chromium',
      ];
      for (final candidate in macCandidates) {
        if (File(candidate).existsSync()) return candidate;
      }
      return 'google-chrome';
    } else if (Platform.isWindows) {
      final localAppData = Platform.environment['LOCALAPPDATA'];
      final winCandidates = [
        r'C:\Program Files\Google\Chrome\Application\chrome.exe',
        r'C:\Program Files (x86)\Google\Chrome\Application\chrome.exe',
        if (localAppData != null)
          p.join(localAppData, 'Google', 'Chrome', 'Application', 'chrome.exe'),
      ];
      for (final candidate in winCandidates) {
        if (File(candidate).existsSync()) return candidate;
      }
      return 'chrome.exe';
    }
    return 'google-chrome';
  }

  Future<void> _cleanupStaleTempDirs() async {
    try {
      final tempRoot = Directory.systemTemp;
      final now = DateTime.now();
      await for (final entity in tempRoot.list()) {
        if (entity is Directory &&
            p.basename(entity.path).startsWith('chrome_profiler_')) {
          final stat = await entity.stat();
          if (now.difference(stat.modified) > const Duration(hours: 1)) {
            await entity.delete(recursive: true);
          }
        }
      }
    } catch (_) {
      // Ignore background cleanup errors.
    }
  }

  Future<void> start(
    String url, {
    void Function(String type, String message)? onConsoleMessage,
    bool verbose = false,
  }) async {
    await _cleanupStaleTempDirs();
    final chromePath = _resolveChromePath();
    _tempDir = await Directory.systemTemp.createTemp('chrome_profiler_');

    try {
      _chromeProcess = await Process.start(chromePath, [
        '--remote-debugging-port=0',
        '--remote-allow-origins=*',
        '--headless=new',
        '--no-sandbox',
        '--disable-dev-shm-usage',
        '--disable-extensions',
        '--disable-background-networking',
        '--disable-sync',
        '--no-first-run',
        '--no-proxy-server',
        '--password-store=basic',
        '--use-mock-keychain',
        '--user-data-dir=${_tempDir!.path}',
        'about:blank',
      ]);
    } on ProcessException catch (e) {
      await _cleanupTempDir();
      throw ProfilerException(
        'Failed to start Chrome ($chromePath): ${e.message}. '
        'Ensure Google Chrome is installed or set CHROME_PATH.',
      );
    }

    if (verbose) {
      _chromeProcess?.stdout
          .transform(utf8.decoder)
          .listen((data) => print('Chrome STDOUT: $data'));
      _chromeProcess?.stderr
          .transform(utf8.decoder)
          .listen((data) => print('Chrome STDERR: $data'));
    }

    final activePortFile = File(p.join(_tempDir!.path, 'DevToolsActivePort'));

    var processExited = false;
    unawaited(_chromeProcess!.exitCode.then((_) => processExited = true));

    var attempts = 0;
    while (!await activePortFile.exists() && attempts < 150) {
      if (processExited) {
        final code = await _chromeProcess!.exitCode;
        await stop();
        throw ProfilerException(
          'Chrome process exited prematurely with code $code '
          'before creating DevToolsActivePort.',
        );
      }
      await Future<void>.delayed(const Duration(milliseconds: 100));
      attempts++;
    }

    if (!await activePortFile.exists()) {
      await stop();
      throw ProfilerException('Failed to find DevToolsActivePort file.');
    }

    final lines = await activePortFile.readAsLines();
    if (lines.isEmpty) {
      await stop();
      throw ProfilerException('DevToolsActivePort file is empty.');
    }

    final port = int.tryParse(lines[0]);
    if (port == null) {
      await stop();
      throw ProfilerException(
        'Invalid port in DevToolsActivePort: "${lines[0]}".',
      );
    }

    http.Response? response;
    for (var i = 0; i < 20; i++) {
      try {
        response = await http.get(Uri.parse('http://127.0.0.1:$port/json'));
        if (response.statusCode == 200) break;
      } catch (_) {
        // Retry
      }
      await Future<void>.delayed(const Duration(milliseconds: 200));
    }

    if (response == null || response.statusCode != 200) {
      await stop();
      throw ProfilerException(
        'Failed to connect to Chrome DevTools after retries.',
      );
    }

    final tabs = (json.decode(response.body) as List<dynamic>)
        .cast<Map<String, dynamic>>();
    if (tabs.isEmpty) {
      await stop();
      throw ProfilerException('Chrome returned an empty tab list.');
    }

    final targetTab = tabs.firstWhere(
      (tab) => tab['type'] == 'page',
      orElse: () => tabs.first,
    );
    final wsUrl = targetTab['webSocketDebuggerUrl'] as String?;
    if (wsUrl == null || wsUrl.isEmpty) {
      await stop();
      throw ProfilerException(
        'No webSocketDebuggerUrl found in Chrome target tab.',
      );
    }

    _connection = await WipConnection.connect(wsUrl);

    // Enable Runtime domain to see console logs
    await _connection
        ?.sendCommand('Runtime.enable')
        .timeout(const Duration(seconds: 10));
    _connection?.onNotification.listen((notification) {
      if (notification.method == 'Runtime.consoleAPICalled') {
        final params = notification.params;
        if (params == null) return;
        final type = params['type'] as String? ?? 'log';
        final args = params['args'] as List<dynamic>? ?? const [];
        final message = args
            .map((a) {
              if (a is Map<String, dynamic>) {
                return a['value']?.toString() ??
                    a['description']?.toString() ??
                    '';
              }
              return a.toString();
            })
            .join(' ');
        if (onConsoleMessage != null && message.isNotEmpty) {
          onConsoleMessage(type, message);
        }
      }
    });

    // Enable Page domain and navigate
    await _connection
        ?.sendCommand('Page.enable')
        .timeout(const Duration(seconds: 10));
    await _connection
        ?.sendCommand('Page.navigate', {'url': url})
        .timeout(const Duration(seconds: 10));
  }

  Future<void> startProfiling({int? intervalUs}) async {
    await _connection?.sendCommand('Profiler.enable');
    if (intervalUs != null) {
      await _connection?.sendCommand('Profiler.setSamplingInterval', {
        'interval': intervalUs,
      });
    }
    await _connection?.sendCommand('Profiler.start');
  }

  Future<Map<String, dynamic>> stopProfiling() async {
    final response = await _connection?.sendCommand('Profiler.stop');
    if (response == null || response.result == null) {
      throw ProfilerException('Profiler.stop returned empty response.');
    }
    return response.result!['profile'] as Map<String, dynamic>;
  }

  Future<WipResponse?> evaluate(
    String expression, {
    bool awaitPromise = false,
  }) async {
    return _connection?.sendCommand('Runtime.evaluate', {
      'expression': expression,
      'awaitPromise': awaitPromise,
      'returnByValue': true,
    });
  }

  Future<void> stop() async {
    try {
      await _connection?.close();
    } catch (_) {}
    _connection = null;

    if (_chromeProcess != null) {
      _chromeProcess!.kill();
      try {
        await _chromeProcess!.exitCode.timeout(
          const Duration(seconds: 3),
          onTimeout: () {
            _chromeProcess?.kill(ProcessSignal.sigkill);
            return 0;
          },
        );
      } catch (_) {}
      _chromeProcess = null;
    }

    await _cleanupTempDir();
  }

  Future<void> _cleanupTempDir() async {
    if (_tempDir != null && await _tempDir!.exists()) {
      try {
        await _tempDir!.delete(recursive: true);
      } catch (_) {}
      _tempDir = null;
    }
  }
}
