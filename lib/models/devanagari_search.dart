class DevanagariSearch {
  static String normalize(String input) {
    return input
        .replaceAll(
          RegExp(r'[ऀ-ः]'),
          '',
        ) // signs (chandrabindu, anusvara, visarga)
        .replaceAll(RegExp(r'[ऺ-ॏ]'), '') // vowel signs / virama
        .replaceAll(RegExp(r'[॑-॔]'), '') // vedic accents (udatta, anudatta)
        .replaceAll(RegExp(r'[\s\.,।॥\-]'), '')
        .trim();
  }

  static bool matches(String sourceText, String query) {
    if (query.isEmpty) return true;
    final normSource = normalize(sourceText);
    final normQuery = normalize(query);
    return normSource.contains(normQuery);
  }
}
