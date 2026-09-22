import 'dart:convert';
import 'dart:io';

import 'package:codable/codable_json.dart';
import 'package:codable/src/json/driver/driver_streaming.dart';

void main() async {
  final file = File('/tmp/1.json');
  if (!file.existsSync()) {
    print('File /tmp/1.json not found');
    exit(1);
  }

  final stream = file.openRead();

  final resultSink = ChunkedConversionSink<dynamic>.withCallback((results) {});

  // On origin/main, startChunkedConversion builds BytesBuilder(copy:false)
  // On rope-chunks branch, startChunkedConversion uses our new fromChunks boundary rope!
  final byteSink = JsonCodableDecoder.startChunkedConversion<dynamic>(
    resultSink,
    (decoder) {
      final reader = (decoder as JsonCodableDecoder).reader;
      reader.beginObject();
      while (reader.hasNext()) {
        reader.nextName();
        reader.skipValue();
      }
      reader.endObject();
      return null;
    },
  );

  print('Starting execution... PID: $pid');

  await for (final chunk in stream) {
    byteSink.add(chunk);
  }
  byteSink.close();

  print('Done!');
}
