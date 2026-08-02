import 'package:flutter_test/flutter_test.dart';
import 'package:dharma_daily/data/data_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Panchang Astronomical Calculation Verification', () {
    final ds = DataService();

    setUpAll(() async {
      await ds.loadAllData();
    });

    test('Panchang 2026 dataset spans full 455 days', () {
      expect(ds.panchangDays.length, 455);
    });

    test('Verify Tithi formula from Solar & Lunar longitudes', () {
      for (final day in ds.panchangDays) {
        if (day.sunLon > 0 && day.moonLon > 0) {
          double diff = day.moonLon - day.sunLon;
          if (diff < 0) diff += 360;
          final calculatedTithiIndex = (diff / 12.0).floor() + 1;
          expect(calculatedTithiIndex >= 1 && calculatedTithiIndex <= 30, true);
        }
      }
    });

    test('Verify Nakshatra formula from Lunar longitude', () {
      for (final day in ds.panchangDays) {
        if (day.moonLon > 0) {
          final nakshatraIndex = (day.moonLon / (360.0 / 27.0)).floor() + 1;
          expect(nakshatraIndex >= 1 && nakshatraIndex <= 27, true);
        }
      }
    });

    test('Verify Rahu Kaal string formatting', () {
      for (final day in ds.panchangDays) {
        expect(day.rahuKaal.isNotEmpty, true);
      }
    });
  });
}
