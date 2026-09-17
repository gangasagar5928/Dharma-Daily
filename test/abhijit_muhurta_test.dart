import 'package:flutter_test/flutter_test.dart';
import 'package:dharma_daily/models/abhijit_muhurta.dart';

void main() {
  group('AbhijitMuhurtaCalculator Tests', () {
    test('Calculates 8th muhurta window around midday', () {
      final sunrise = DateTime(2026, 9, 17, 6, 0); // Thursday
      final sunset = DateTime(2026, 9, 17, 18, 0);
      final res = AbhijitMuhurtaCalculator.calculate(
        sunrise: sunrise,
        sunset: sunset,
        weekday: DateTime.thursday,
      );

      expect(res['startTime'], '11:36');
      expect(res['endTime'], '12:24');
      expect(res['isAuspicious'], true);
    });

    test('Flags Wednesday as blocked', () {
      final sunrise = DateTime(2026, 9, 16, 6, 0); // Wednesday
      final sunset = DateTime(2026, 9, 16, 18, 0);
      final res = AbhijitMuhurtaCalculator.calculate(
        sunrise: sunrise,
        sunset: sunset,
        weekday: DateTime.wednesday,
      );

      expect(res['isBlockedByWednesday'], true);
      expect(res['isAuspicious'], false);
    });
  });
}
