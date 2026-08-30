import 'package:flutter_test/flutter_test.dart';
import 'package:dharma_daily/models/brahma_muhurta.dart';

void main() {
  group('BrahmaMuhurtaCalculator Tests', () {
    test('Calculates 04:24 to 05:12 window for 06:00 sunrise', () {
      final sunrise = DateTime(2026, 8, 30, 6, 0);
      final res = BrahmaMuhurtaCalculator.calculate(sunrise);
      expect(res['startTime'], '04:24');
      expect(res['endTime'], '05:12');
      expect(res['durationMinutes'], 48);
    });
  });
}
