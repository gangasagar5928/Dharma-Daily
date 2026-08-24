import 'package:flutter_test/flutter_test.dart';
import 'package:dharma_daily/models/rahu_kaal_helper.dart';

void main() {
  group('RahuKaalHelper Tests', () {
    test('Calculates period 2 for Monday', () {
      final monday = DateTime(2026, 8, 24);
      final sunrise = DateTime(2026, 8, 24, 6, 0);
      final sunset = DateTime(2026, 8, 24, 18, 0);

      final window = RahuKaalHelper.calculate(
        date: monday,
        sunrise: sunrise,
        sunset: sunset,
      );

      expect(window.periodIndex, 2);
      expect(window.startTime, DateTime(2026, 8, 24, 7, 30));
      expect(window.endTime, DateTime(2026, 8, 24, 9, 0));
      expect(window.formattedRange, '07:30 - 09:00');
    });

    test('Calculates period 8 for Sunday', () {
      final sunday = DateTime(2026, 8, 23);
      final sunrise = DateTime(2026, 8, 23, 6, 0);
      final sunset = DateTime(2026, 8, 23, 18, 0);

      final window = RahuKaalHelper.calculate(
        date: sunday,
        sunrise: sunrise,
        sunset: sunset,
      );

      expect(window.periodIndex, 8);
      expect(window.startTime, DateTime(2026, 8, 23, 16, 30));
      expect(window.endTime, sunset);
      expect(window.formattedRange, '16:30 - 18:00');
    });

    test('isCurrentlyActive returns true during window', () {
      final window = RahuKaalWindow(
        startTime: DateTime(2026, 8, 24, 7, 30),
        endTime: DateTime(2026, 8, 24, 9, 0),
        periodIndex: 2,
      );

      expect(window.isCurrentlyActive(DateTime(2026, 8, 24, 8, 0)), true);
      expect(window.isCurrentlyActive(DateTime(2026, 8, 24, 7, 0)), false);
      expect(window.isCurrentlyActive(DateTime(2026, 8, 24, 9, 30)), false);
    });
  });
}
