// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// JSON serialization driver and streaming substrate for package:codable.
library;

import 'src/json/substrate/substrate.dart';

export 'package:codable/codable.dart';

export 'src/json/driver/json_codable_driver.dart';
export 'src/json/substrate/substrate.dart';

/// Extension on [JsonTokenReader] providing convenience utilities.
extension JsonTokenReaderCodableExtension on JsonTokenReader {
  /// Returns `true` if the next token is a null literal without advancing the
  /// cursor.
  @pragma('vm:prefer-inline')
  @pragma('wasm:prefer-inline')
  bool isNextNull() => peek() == JsonTokenType.nullValue;
}
