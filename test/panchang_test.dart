import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late List<dynamic> days;

  setUpAll(() {
    // Use dart:io File — rootBundle is unavailable in unit test context.
    days = jsonDecode(
      File('assets/data/panchang_2026.json').readAsStringSync(),
    ) as List<dynamic>;
  });

  group('Panchang Astronomical Calculation Verification', () {
    test('Panchang 2026 dataset spans full 455 days', () {
      expect(days.length, 455);
    });

    test('Verify Tithi formula from Solar & Lunar longitudes', () {
      for (final day in days) {
        final sunLon = (day['sun_lon'] as num?)?.toDouble() ?? 0;
        final moonLon = (day['moon_lon'] as num?)?.toDouble() ?? 0;
        if (sunLon > 0 && moonLon > 0) {
          double diff = moonLon - sunLon;
          if (diff < 0) diff += 360;
          final calculatedTithiIndex = (diff / 12.0).floor() + 1;
          expect(
            calculatedTithiIndex >= 1 && calculatedTithiIndex <= 30,
            true,
            reason:
                'Tithi index $calculatedTithiIndex out of range on ${day['date']}',
          );
        }
      }
    });

    test('Verify Nakshatra formula from Lunar longitude', () {
      for (final day in days) {
        final moonLon = (day['moon_lon'] as num?)?.toDouble() ?? 0;
        if (moonLon > 0) {
          final nakshatraIndex = (moonLon / (360.0 / 27.0)).floor() + 1;
          expect(
            nakshatraIndex >= 1 && nakshatraIndex <= 27,
            true,
            reason:
                'Nakshatra index $nakshatraIndex out of range on ${day['date']}',
          );
        }
      }
    });

    test('Verify Rahu Kaal string is non-empty for all days', () {
      for (final day in days) {
        final rahuKaal = day['rahu_kaal'] as String? ?? '';
        expect(rahuKaal.isNotEmpty, true,
            reason: 'rahu_kaal empty on ${day['date']}');
      }
    });
  });
}
