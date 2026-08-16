import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
      'DataService assets: all scripture/veda/purana/tradition files exist and parse',
      () {
    // Use dart:io File directly — rootBundle is not available in unit tests.
    // scriptures.json is a Map<String, List> (keyed by scripture name).
    final scripturesRaw =
        jsonDecode(File('assets/data/scriptures.json').readAsStringSync());
    expect(scripturesRaw, isA<Map>());
    expect((scripturesRaw as Map).isNotEmpty, true);

    // vedas_full.json, puranas_full.json, traditions.json are top-level Lists.
    final vedas =
        jsonDecode(File('assets/data/vedas_full.json').readAsStringSync())
            as List<dynamic>;
    final puranas =
        jsonDecode(File('assets/data/puranas_full.json').readAsStringSync())
            as List<dynamic>;
    final traditions =
        jsonDecode(File('assets/data/traditions.json').readAsStringSync())
            as List<dynamic>;

    print('Scripture sections: ${scripturesRaw.keys.length}');
    print('Loaded Vedas: ${vedas.length}');
    print('Loaded Puranas: ${puranas.length}');
    print('Loaded Traditions: ${traditions.length}');

    expect(vedas.isNotEmpty, true);
    expect(puranas.isNotEmpty, true);
    expect(traditions.isNotEmpty, true);
  });
}
