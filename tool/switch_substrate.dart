// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

void main(List<String> args) {
  if (args.isEmpty || (args.first != 'mock' && args.first != 'native')) {
    stderr.writeln('Usage: dart run tool/switch_substrate.dart [mock|native]');
    exit(1);
  }

  final mode = args.first;
  final targetFile = File('pkgs/codable/lib/src/json/substrate/substrate.dart');

  if (mode == 'mock') {
    targetFile.writeAsStringSync('''
// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Active substrate dispatcher (switched to mock mode).
library;

export 'mock/substrate_mock.dart';
''');
    stdout.writeln('Switched substrate to: MOCK (pure Dart)');
  } else {
    targetFile.writeAsStringSync('''
// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Active substrate dispatcher (switched to native mode).
library;

export 'substrate_native.dart';
''');
    stdout.writeln('Switched substrate to: NATIVE (dart:convert Layer 1 SDK)');
  }
}
