import 'dart:io';

void main() {
  var files = [
    'pkgs/codable/lib/src/json/driver/driver_js.dart',
    'pkgs/codable/lib/src/json/driver/driver_streaming.dart',
  ];

  for (var file in files) {
    var content = File(file).readAsStringSync();

    var patterns = [
      r'\s*@override\s+bool containsStaticKey\(StaticKey key\) => containsKey\(key\.name\);',
      r'\s*@override\s+bool isNullKey\(StaticKey key\) => isNull\(key\.name\);',
      r'\s*@override\s+int readIntKey\(StaticKey key\) => readInt\(key\.name\);',
      r'\s*@override\s+int\?\s*readNullableIntKey\(StaticKey key\) => readNullableInt\(key\.name\);',
      r'\s*@override\s+double readDoubleKey\(StaticKey key\) => readDouble\(key\.name\);',
      r'\s*@override\s+double\?\s*readNullableDoubleKey\(StaticKey key\) =>\s*readNullableDouble\(key\.name\);',
      r'\s*@override\s+String readStringKey\(StaticKey key\) => readString\(key\.name\);',
      r'\s*@override\s+String\?\s*readNullableStringKey\(StaticKey key\) =>\s*readNullableString\(key\.name\);',
      r'\s*@override\s+bool readBoolKey\(StaticKey key\) => readBool\(key\.name\);',
      r'\s*@override\s+bool\?\s*readNullableBoolKey\(StaticKey key\) =>\s*readNullableBool\(key\.name\);',
      r'\s*@override\s+T decodeStaticKey<T>\(StaticKey key, DecoderCallback<T> decoder\) =>\s*decodeKey\(key\.name, decoder\);',
      r'\s*@override\s+T\?\s*decodeNullableStaticKey<T>\(StaticKey key, DecoderCallback<T> decoder\) =>\s*decodeNullableKey\(key\.name, decoder\);',
      r'\s*@override\s+List<T>\s*decodeListStaticKey<T>\(StaticKey key, DecoderCallback<T> decoder\) =>\s*decodeListKey\(key\.name, decoder\);',
      r'\s*@override\s+List<int> decodeIntListKey\(StaticKey key\) => decodeIntList\(key\.name\);',
      r'\s*@override\s+List<double> decodeDoubleListKey\(StaticKey key\) => decodeDoubleList\(key\.name\);',
      r'\s*@override\s+Float64List decodeFloat64ListKey\(StaticKey key\) =>\s*decodeFloat64List\(key\.name\);',
      r'\s*@override\s+List<String> decodeStringListKey\(StaticKey key\) => decodeStringList\(key\.name\);',
      r'\s*@override\s+List<bool> decodeBoolListKey\(StaticKey key\) => decodeBoolList\(key\.name\);',
    ];

    for (var pattern in patterns) {
      //print('Replacing ${pattern}');
      var before = content.length;
      content = content.replaceAll(RegExp(pattern, multiLine: true), '');
      if (before == content.length) {
        print('Pattern not matched in $file: \n$pattern');
      }
    }

    // update class signature
    content = content.replaceAll(
      'implements MappedDecoder {',
      'with MappedDecoderBase implements MappedDecoder {',
    );

    File(file).writeAsStringSync(content);
  }
}
