import 'package:shared_preferences/shared_preferences.dart';

class PrefsService {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static String get region => _prefs.getString('panchang_region') ?? 'North India';

  static Future<void> setRegion(String region) async {
    await _prefs.setString('panchang_region', region);
  }

  static List<String> get bookmarkedVerses =>
      _prefs.getStringList('bookmarked_verses') ?? [];

  static Future<void> toggleBookmark(String verseId) async {
    final list = List<String>.from(bookmarkedVerses);
    if (list.contains(verseId)) {
      list.remove(verseId);
    } else {
      list.add(verseId);
    }
    await _prefs.setStringList('bookmarked_verses', list);
  }

  static bool isBookmarked(String verseId) {
    return bookmarkedVerses.contains(verseId);
  }

  static List<String> get favoriteTraditions =>
      _prefs.getStringList('fav_traditions') ?? [];

  static Future<void> toggleFavoriteTradition(String id) async {
    final list = List<String>.from(favoriteTraditions);
    if (list.contains(id)) {
      list.remove(id);
    } else {
      list.add(id);
    }
    await _prefs.setStringList('fav_traditions', list);
  }

  static bool isFavoriteTradition(String id) {
    return favoriteTraditions.contains(id);
  }
}
