import 'package:flutter_test/flutter_test.dart';
import 'package:dharma_daily/models/ekadashi_parana.dart';

void main() {
  group('EkadashiParanaWindow Tests', () {
    test('Formats morning Parana interval correctly', () {
      final start = DateTime(2026, 9, 14, 6, 12);
      final end = DateTime(2026, 9, 14, 8, 35);
      final window = EkadashiParanaWindow(
        paranaStart: start,
        paranaEnd: end,
        fastingDayName: 'Parsva Ekadashi',
      );
      expect(window.formattedRange, '06:12 - 08:35');
    });
  });
}
