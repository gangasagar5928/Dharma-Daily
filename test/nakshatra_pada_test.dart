import 'package:flutter_test/flutter_test.dart';
import 'package:dharma_daily/models/nakshatra_pada.dart';

void main() {
  group('NakshatraPada Tests', () {
    test('0 degrees calculates Ashwini Pada 1', () {
      final res = NakshatraPada.calculate(0.0);
      expect(res.nakshatraName, 'Ashwini');
      expect(res.pada, 1);
    });

    test('3.5 degrees calculates Ashwini Pada 2', () {
      final res = NakshatraPada.calculate(3.5);
      expect(res.nakshatraName, 'Ashwini');
      expect(res.pada, 2);
    });

    test('13.34 degrees calculates Bharani Pada 1', () {
      final res = NakshatraPada.calculate(13.34);
      expect(res.nakshatraName, 'Bharani');
      expect(res.pada, 1);
    });
  });
}
