// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Native substrate re-exporting Layer 1 SDK atoms from `dart:convert`.
// ignore_for_file: undefined_shown_name
library;

export 'dart:convert'
    show
        JsonKeyOptions,
        JsonTokenReader,
        JsonTokenType,
        JsonTokenWriter,
        JsonUtf8TokenWriter,
        jsonUtf8,
        jsonUtf8Decode,
        jsonUtf8Encode;

const bool isMockSubstrate = false;
