// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Zero-dependency TOML v1.0 serialization driver for `package:codable`.
library;

export 'src/toml_decoder.dart' show TomlCodableDecoder;
export 'src/toml_encoder.dart' show TomlCodableEncoder;
export 'src/toml_types.dart'
    show
        TomlCodableException,
        TomlDateTime,
        TomlDateTimeCodec,
        TomlDateTimeKind;
