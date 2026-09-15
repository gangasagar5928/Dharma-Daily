import 'package:flutter_test/flutter_test.dart';
import 'package:dharma_daily/models/regional_festival.dart';

void main() {
  group('RegionalFestivalFilter Tests', () {
    test('Returns state-specific festivals for South India', () {
      final list = RegionalFestivalFilter.getRegionFestivals(IndianRegion.southIndia);
      expect(list, contains('Pongal'));
      expect(list, contains('Onam'));
    });
    test('Returns state-specific festivals for West India', () {
      final list = RegionalFestivalFilter.getRegionFestivals(IndianRegion.westIndia);
      expect(list, contains('Gudi Padwa'));
      expect(list, contains('Ganesh Chaturthi'));
    });
  });
}
