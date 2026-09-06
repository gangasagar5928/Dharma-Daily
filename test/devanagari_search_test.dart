import 'package:flutter_test/flutter_test.dart';
import 'package:dharma_daily/models/devanagari_search.dart';

void main() {
  group('DevanagariSearch Tests', () {
    test('Matches text regardless of virama or matra variations', () {
      const shloka = 'कर्मण्येवाधिकारस्ते मा फलेषु कदाचन।';
      expect(DevanagariSearch.matches(shloka, 'कर्म'), true);
      expect(DevanagariSearch.matches(shloka, 'फल'), true);
    });

    test('Empty query matches all text', () {
      expect(DevanagariSearch.matches('धर्मक्षेत्रे कुरुक्षेत्रे', ''), true);
    });
  });
}
