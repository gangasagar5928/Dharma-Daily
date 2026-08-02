import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../models/models.dart';

class DataService {
  static final DataService _instance = DataService._internal();
  factory DataService() => _instance;
  DataService._internal();

  List<PanchangDay> _panchangDays = [];
  List<Festival> _festivals = [];
  List<ScriptureItem> _scriptures = [];
  List<Tradition> _traditions = [];
  List<VedaText> _vedas = [];
  List<PuranText> _puranas = [];

  List<PanchangDay> get panchangDays => _panchangDays;
  List<Festival> get festivals => _festivals;
  List<ScriptureItem> get scriptures => _scriptures;
  List<Tradition> get traditions => _traditions;
  List<VedaText> get vedas => _vedas;
  List<PuranText> get puranas => _puranas;

  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  Future<void> loadAllData() async {
    if (_isLoaded) return;

    try {
      // 1. Panchang
      try {
        final panchangStr = await rootBundle.loadString('assets/data/panchang_2026.json');
        final List<dynamic> panchangJson = json.decode(panchangStr);
        _panchangDays = panchangJson.map((e) => PanchangDay.fromJson(e)).toList();
      } catch (e) {
        debugPrint('Error loading Panchang: $e');
      }

      // 2. Festivals
      try {
        final festivalsStr = await rootBundle.loadString('assets/data/festivals.json');
        final List<dynamic> festivalsJson = json.decode(festivalsStr);
        _festivals = festivalsJson.map((e) => Festival.fromJson(e)).toList();
      } catch (e) {
        debugPrint('Error loading Festivals: $e');
      }

      // 3. Traditions
      try {
        final traditionsStr = await rootBundle.loadString('assets/data/traditions.json');
        final List<dynamic> traditionsJson = json.decode(traditionsStr);
        _traditions = traditionsJson.map((e) => Tradition.fromJson(e)).toList();
      } catch (e) {
        debugPrint('Error loading Traditions: $e');
      }

      // 4. Scriptures
      try {
        final scripturesStr = await rootBundle.loadString('assets/data/scriptures.json');
        final Map<String, dynamic> scripturesJson = json.decode(scripturesStr);
        _scriptures = _parseScriptures(scripturesJson);
      } catch (e) {
        debugPrint('Error loading Scriptures: $e');
      }

      // 5. Full Offline Vedas
      try {
        final vedasStr = await rootBundle.loadString('assets/data/vedas_full.json');
        final List<dynamic> vedasJson = json.decode(vedasStr);
        _vedas = vedasJson.map((e) => VedaText.fromJson(e)).toList();
      } catch (e) {
        debugPrint('Error loading Vedas full: $e');
      }

      // 6. Full Offline Purans
      try {
        final puranasStr = await rootBundle.loadString('assets/data/puranas_full.json');
        final List<dynamic> puranasJson = json.decode(puranasStr);
        _puranas = puranasJson.map((e) => PuranText.fromJson(e)).toList();
      } catch (e) {
        debugPrint('Error loading Purans full: $e');
      }

      _isLoaded = true;
    } catch (e) {
      debugPrint('Error loading data: $e');
    }
  }

  List<ScriptureItem> _parseScriptures(Map<String, dynamic> json) {
    final List<ScriptureItem> items = [];

    // 1. Bhagavad Gita
    if (json.containsKey('bhagavad_gita') && json['bhagavad_gita'] is List) {
      final List<dynamic> chaptersJson = json['bhagavad_gita'];
      final chapters = chaptersJson.map((c) => Chapter.fromJson(c)).toList();
      final flatVerses = chapters.expand((c) => c.verses).toList();
      items.add(ScriptureItem(
        id: 'bhagavad_gita',
        title: 'Bhagavad Gita',
        subtitle: 'The Divine Song of Wisdom (700 Shlokas)',
        author: 'Sage Vyasa',
        period: 'Ancient Vedic Era',
        introduction: 'The 700-verse Hindu scripture that is part of the epic Mahabharata, imparting timeless spiritual wisdom on duty, yoga, and devotion.',
        chapters: chapters,
        flatVerses: flatVerses,
      ));
    }

    // 2. Yoga Sutras
    if (json.containsKey('yoga_sutras') && json['yoga_sutras'] is Map) {
      final Map<String, dynamic> sys = json['yoga_sutras'];
      final List<dynamic> chList = (sys['chapters'] as List<dynamic>?) ?? [];
      final chapters = chList.map((c) {
        final sutras = (c['sutras'] as List<dynamic>?) ?? [];
        final verses = sutras.map((s) => Verse(
          number: (s['sutra_number'] as num?)?.toInt() ?? 0,
          sanskrit: s['sanskrit'] ?? s['text'] ?? '',
          transliteration: s['transliteration'] ?? '',
          translation: s['translation'] ?? '',
          meaning: s['explanation'] ?? s['meaning'] ?? '',
        )).toList();
        return Chapter(
          number: (c['chapter'] as num?)?.toInt() ?? 1,
          name: c['name'] ?? '',
          nameMeaning: c['name_meaning'] ?? '',
          summary: c['summary'] ?? '',
          totalVerses: verses.length,
          verses: verses,
        );
      }).toList();
      items.add(ScriptureItem(
        id: 'yoga_sutras',
        title: sys['book_name'] ?? 'Yoga Sutras of Patanjali',
        subtitle: 'The Foundation of Ashtanga Yoga (196 Sutras)',
        author: sys['author'] ?? 'Maharishi Patanjali',
        period: sys['period'] ?? 'c. 400 CE',
        introduction: sys['introduction'] ?? 'A collection of 196 Sanskrit sutras on the theory and practice of Yoga.',
        chapters: chapters,
        flatVerses: chapters.expand((c) => c.verses).toList(),
      ));
    }

    // 3. Hanuman Chalisa
    if (json.containsKey('hanuman_chalisa') && json['hanuman_chalisa'] is Map) {
      final Map<String, dynamic> hc = json['hanuman_chalisa'];
      final List<Verse> verses = [];

      void parseAndAddVerse(dynamic data, int defaultNum) {
        if (data is Map<String, dynamic>) {
          verses.add(Verse(
            number: (data['doha_number'] ?? data['chaupai_number'] ?? defaultNum) as int? ?? defaultNum,
            sanskrit: data['sanskrit'] ?? data['text'] ?? '',
            transliteration: data['transliteration'] ?? '',
            translation: data['translation'] ?? '',
            meaning: data['meaning'] ?? data['explanation'] ?? '',
          ));
        } else if (data is List) {
          int count = defaultNum;
          for (var item in data) {
            if (item is Map<String, dynamic>) {
              verses.add(Verse(
                number: (item['doha_number'] ?? item['chaupai_number'] ?? count++) as int? ?? count,
                sanskrit: item['sanskrit'] ?? item['text'] ?? '',
                transliteration: item['transliteration'] ?? '',
                translation: item['translation'] ?? '',
                meaning: item['meaning'] ?? item['explanation'] ?? '',
              ));
            }
          }
        }
      }

      if (hc.containsKey('doha_opening')) parseAndAddVerse(hc['doha_opening'], 1);
      if (hc.containsKey('doha_pre')) parseAndAddVerse(hc['doha_pre'], 2);
      if (hc.containsKey('chaupais')) parseAndAddVerse(hc['chaupais'], 3);
      if (hc.containsKey('doha_closing')) parseAndAddVerse(hc['doha_closing'], 44);

      items.add(ScriptureItem(
        id: 'hanuman_chalisa',
        title: hc['name'] ?? 'Hanuman Chalisa',
        subtitle: '40 Hymns of Devotion & Courage',
        author: hc['author'] ?? 'Goswami Tulsidas',
        period: hc['period'] ?? '16th Century',
        introduction: hc['introduction'] ?? 'A devotional hymn addressed to Lord Hanuman, recited daily by millions for strength and peace.',
        chapters: [
          Chapter(
            number: 1,
            name: 'Complete Stotram',
            nameMeaning: 'Dohas & 40 Chaupais',
            summary: 'Full 40 verse devotional prayer',
            totalVerses: verses.length,
            verses: verses,
          )
        ],
        flatVerses: verses,
      ));
    }

    // 4. Upanishads
    if (json.containsKey('upanishads') && json['upanishads'] is Map) {
      final Map<String, dynamic> up = json['upanishads'];
      final List<dynamic> texts = (up['texts'] as List<dynamic>?) ?? [];
      int chCount = 1;
      final chapters = texts.map((t) {
        final versesJson = (t['verses'] as List<dynamic>?) ?? [];
        final verses = versesJson.map((v) => Verse.fromJson(v)).toList();
        return Chapter(
          number: chCount++,
          name: t['name'] ?? '',
          nameMeaning: t['affiliation'] ?? t['veda'] ?? '',
          summary: 'Principal Upanishad text',
          totalVerses: verses.length,
          verses: verses,
        );
      }).toList();

      items.add(ScriptureItem(
        id: 'upanishads',
        title: up['name'] ?? 'Principal Upanishads',
        subtitle: 'Core Philosophical Texts of Vedanta',
        author: 'Ancient Rishis',
        period: '800 - 500 BCE',
        introduction: up['introduction'] ?? 'Philosophical texts exploring Brahman, Atman, and the nature of ultimate reality.',
        chapters: chapters,
        flatVerses: chapters.expand((c) => c.verses).toList(),
      ));
    }

    // 5. Chanakya Niti
    if (json.containsKey('chanakya_niti') && json['chanakya_niti'] is Map) {
      final Map<String, dynamic> cn = json['chanakya_niti'];
      final List<dynamic> shlokas = (cn['shlokas'] as List<dynamic>?) ?? [];
      final verses = shlokas.map((s) => Verse.fromJson(s)).toList();
      items.add(ScriptureItem(
        id: 'chanakya_niti',
        title: cn['name'] ?? 'Chanakya Niti',
        subtitle: 'Maxims on Governance, Ethics & Life',
        author: cn['author'] ?? 'Chanakya (Kautilya)',
        period: cn['period'] ?? 'c. 300 BCE',
        introduction: cn['introduction'] ?? 'Practical maxims on political science, personal strategy, and ethical living.',
        chapters: [
          Chapter(
            number: 1,
            name: 'Essential Niti Shlokas',
            nameMeaning: 'Practical Wisdom',
            summary: 'Selected Niti maxims',
            totalVerses: verses.length,
            verses: verses,
          )
        ],
        flatVerses: verses,
      ));
    }

    // 6. Vivekachudamani
    if (json.containsKey('vivekachudamani') && json['vivekachudamani'] is Map) {
      final Map<String, dynamic> vc = json['vivekachudamani'];
      final List<dynamic> vList = (vc['verses'] as List<dynamic>?) ?? [];
      final verses = vList.map((v) => Verse.fromJson(v)).toList();
      items.add(ScriptureItem(
        id: 'vivekachudamani',
        title: vc['name'] ?? 'Vivekachudamani',
        subtitle: 'Crest-Jewel of Discrimination',
        author: vc['author'] ?? 'Adi Shankaracharya',
        period: vc['period'] ?? '8th Century CE',
        introduction: vc['introduction'] ?? 'A seminal Advaita Vedanta text expounding discrimination between the Real and Unreal.',
        chapters: [
          Chapter(
            number: 1,
            name: 'Key Advaita Verses',
            nameMeaning: 'Wisdom of Non-Duality',
            summary: 'Selected verses on Self-Realization',
            totalVerses: verses.length,
            verses: verses,
          )
        ],
        flatVerses: verses,
      ));
    }

    return items;
  }

  PanchangDay? getPanchangForDate(String dateStr) {
    try {
      return _panchangDays.firstWhere(
        (p) => p.date == dateStr,
        orElse: () => _panchangDays.isNotEmpty ? _panchangDays.first : PanchangDay(
          date: dateStr,
          weekday: 'Unknown',
          paksha: 'Shukla',
          tithi: 'Pratipada',
          tithiName: 'Pratipada',
          nakshatra: 'Rohini',
          yoga: 'Shubha',
          karan: 'Kaulava',
          rahuKaal: '10:30 - 12:00',
          abhijitMuhurta: '11:45 - 12:30',
          hinduMonth: 'Chaitra',
          special: [],
          sunLon: 0,
          moonLon: 0,
        ),
      );
    } catch (_) {
      return null;
    }
  }

  List<Festival> getUpcomingFestivals({int limit = 5}) {
    final todayStr = DateTime.now().toIso8601String().substring(0, 10);
    final upcoming = _festivals.where((f) => f.date.compareTo(todayStr) >= 0).toList();
    if (upcoming.isEmpty) return _festivals.take(limit).toList();
    return upcoming.take(limit).toList();
  }

  Verse getRandomDailyVerse() {
    if (_scriptures.isEmpty) {
      return Verse(
        number: 47,
        sanskrit: 'कर्मण्येवाधिकारस्ते मा फलेषु कदाचन।',
        transliteration: 'Karmanye vadhikaraste ma phaleshu kadachana.',
        translation: 'You have a right to perform your prescribed duties, but you are not entitled to the fruits of your actions.',
        meaning: 'Focus fully on action without attachment to outcomes or anxiety about rewards.',
      );
    }
    final gita = _scriptures.firstWhere(
      (s) => s.id == 'bhagavad_gita',
      orElse: () => _scriptures.first,
    );
    if (gita.flatVerses.isEmpty) {
      return Verse(
        number: 1,
        sanskrit: 'ॐ नमः शिवाय',
        transliteration: 'Om Namah Shivaya',
        translation: 'I bow to the Inner Self',
        meaning: 'Sacred ancient chant',
      );
    }
    final dayOfYear = DateTime.now().difference(DateTime(DateTime.now().year, 1, 1)).inDays;
    final index = dayOfYear % gita.flatVerses.length;
    return gita.flatVerses[index];
  }
}
