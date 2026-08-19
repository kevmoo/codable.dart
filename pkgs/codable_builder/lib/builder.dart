// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'src/codable_builder_base.dart';

/// Builder factory for [CodableGenerator].
Builder codableBuilder(BuilderOptions options) =>
    SharedPartBuilder(const [CodableGenerator()], 'codable');
