import 'dart:convert';

class BookmarkExportService {
  static String exportToJson({
    required List<String> verses,
    required List<String> traditions,
    required String userRegion,
  }) {
    final payload = {
      'exportDate': DateTime.now().toIso8601String(),
      'region': userRegion,
      'versesCount': verses.length,
      'bookmarkedVerses': verses,
      'favoriteTraditions': traditions,
    };
    return const JsonEncoder.withIndent('  ').convert(payload);
  }
}
