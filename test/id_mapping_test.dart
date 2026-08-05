import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Verify 100% ID alignment between drive_sources.json and full texts', () {
    final driveFile = File('assets/data/drive_sources.json');
    final puranasFile = File('assets/data/puranas_full.json');
    final vedasFile = File('assets/data/vedas_full.json');

    final driveJson = jsonDecode(driveFile.readAsStringSync()) as Map<String, dynamic>;
    final puranasJson = jsonDecode(puranasFile.readAsStringSync()) as List<dynamic>;
    final vedasJson = jsonDecode(vedasFile.readAsStringSync()) as List<dynamic>;

    final drivePuranIds = (driveJson['puranas'] as List).map((e) => e['id'] as String).toSet();
    final driveVedaIds = (driveJson['vedas'] as List).map((e) => e['id'] as String).toSet();

    // Verify Purans
    for (final p in puranasJson) {
      final id = p['id'] as String;
      expect(drivePuranIds.contains(id), isTrue, reason: 'Puran ID "$id" missing or mismatched in drive_sources.json!');
    }

    // Verify Vedas
    for (final v in vedasJson) {
      final id = v['id'] as String;
      expect(driveVedaIds.contains(id), isTrue, reason: 'Veda ID "$id" missing or mismatched in drive_sources.json!');
    }

    print('SUCCESS: All ${puranasJson.length} Purans and ${vedasJson.length} Vedas match 100% with Drive sources!');
  });
}
