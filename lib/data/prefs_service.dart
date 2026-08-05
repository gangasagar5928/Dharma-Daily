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

  // Notification Preferences
  static bool get panchangAlert => _prefs.getBool('panchang_alert') ?? true;
  static Future<void> setPanchangAlert(bool value) async => await _prefs.setBool('panchang_alert', value);

  static bool get shlokaAlert => _prefs.getBool('shloka_alert') ?? true;
  static Future<void> setShlokaAlert(bool value) async => await _prefs.setBool('shloka_alert', value);

  static bool get festivalAlert => _prefs.getBool('festival_alert') ?? true;
  static Future<void> setFestivalAlert(bool value) async => await _prefs.setBool('festival_alert', value);

  // Theme Preference (0: System, 1: Dark, 2: Light)
  static int get themeModeIndex => _prefs.getInt('theme_mode') ?? 1; // Default Dark
  static Future<void> setThemeModeIndex(int index) async => await _prefs.setInt('theme_mode', index);
}
