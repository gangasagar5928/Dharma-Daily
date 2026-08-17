import 'package:flutter_test/flutter_test.dart';
import 'package:dharma_daily/models/choghadiya.dart';

void main() {
  group('ChoghadiyaCalculator Tests', () {
    test('Calculates 8 daytime periods for Monday', () {
      final date = DateTime(2026, 8, 17); // Monday
      final sunrise = DateTime(2026, 8, 17, 6, 0);
      final sunset = DateTime(2026, 8, 17, 18, 30);

      final periods = ChoghadiyaCalculator.calculateDayChoghadiya(
        date: date,
        sunrise: sunrise,
        sunset: sunset,
      );

      expect(periods.length, 8);
      expect(periods[0].type, ChoghadiyaType.amrit);
      expect(periods[0].nature, ChoghadiyaNature.auspicious);
      expect(periods[0].rulingPlanet, 'Moon');
      expect(periods[0].isDaytime, true);
      expect(periods[0].startTime, '06:00');
    });

    test('First Choghadiya on Sunday is Udveg', () {
      final date = DateTime(2026, 8, 16); // Sunday
      final sunrise = DateTime(2026, 8, 16, 6, 0);
      final sunset = DateTime(2026, 8, 16, 18, 30);

      final periods = ChoghadiyaCalculator.calculateDayChoghadiya(
        date: date,
        sunrise: sunrise,
        sunset: sunset,
      );

      expect(periods.first.type, ChoghadiyaType.udveg);
      expect(periods.first.nature, ChoghadiyaNature.inauspicious);
      expect(periods.first.rulingPlanet, 'Sun');
    });

    test('Auspicious Choghadiyas are correctly identified for travel', () {
      final periodAmrit = ChoghadiyaPeriod(
        type: ChoghadiyaType.amrit,
        name: 'Amrita',
        rulingPlanet: 'Moon',
        nature: ChoghadiyaNature.auspicious,
        startTime: '06:00',
        endTime: '07:30',
        isDaytime: true,
      );
      expect(periodAmrit.isGoodForTravel, true);

      final periodKaal = ChoghadiyaPeriod(
        type: ChoghadiyaType.kaal,
        name: 'Kala',
        rulingPlanet: 'Saturn',
        nature: ChoghadiyaNature.inauspicious,
        startTime: '07:30',
        endTime: '09:00',
        isDaytime: true,
      );
      expect(periodKaal.isGoodForTravel, false);
    });
  });
}
