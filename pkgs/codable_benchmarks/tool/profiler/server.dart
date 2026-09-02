// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_static/shelf_static.dart';

import 'exceptions.dart';

class BenchmarkServer {
  HttpServer? _server;

  int get port => _server?.port ?? 0;
  String get url => 'http://127.0.0.1:$port';

  Future<int> start(String path, {int port = 0}) async {
    final staticHandler = createStaticHandler(
      path,
      defaultDocument: 'index.html',
    );

    // Inject COOP and COEP headers to enable high-resolution timers and
    // SharedArrayBuffer for Wasm, and ensure correct MIME types for streaming.
    final handler = const Pipeline()
        .addMiddleware(
          (innerHandler) => (request) async {
            final response = await innerHandler(request);
            final headers = <String, String>{
              ...response.headers,
              'Cross-Origin-Opener-Policy': 'same-origin',
              'Cross-Origin-Embedder-Policy': 'require-corp',
            };
            if (request.url.path.endsWith('.wasm')) {
              headers['Content-Type'] = 'application/wasm';
            } else if (request.url.path.endsWith('.mjs')) {
              headers['Content-Type'] = 'text/javascript';
            }
            return response.change(headers: headers);
          },
        )
        .addHandler(staticHandler);

    try {
      _server = await io.serve(handler, '127.0.0.1', port);
    } on SocketException catch (e) {
      throw ProfilerException(
        'Failed to bind benchmark server on port $port: ${e.message}. '
        'Omit --port or pass port 0 to allocate an ephemeral port.',
      );
    }
    return _server!.port;
  }

  Future<void> stop() async {
    await _server?.close(force: true);
    _server = null;
  }
}
