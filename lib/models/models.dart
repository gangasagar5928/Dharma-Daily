import 'package:flutter/material.dart';

class PanchangDay {
  final String date;
  final String weekday;
  final String paksha;
  final String tithi;
  final String tithiName;
  final String nakshatra;
  final String yoga;
  final String karan;
  final String rahuKaal;
  final String abhijitMuhurta;
  final String hinduMonth;
  final List<String> special;
  final double sunLon;
  final double moonLon;

  PanchangDay({
    required this.date,
    required this.weekday,
    required this.paksha,
    required this.tithi,
    required this.tithiName,
    required this.nakshatra,
    required this.yoga,
    required this.karan,
    required this.rahuKaal,
    required this.abhijitMuhurta,
    required this.hinduMonth,
    required this.special,
    required this.sunLon,
    required this.moonLon,
  });

  factory PanchangDay.fromJson(Map<String, dynamic> json) {
    return PanchangDay(
      date: json['date'] ?? '',
      weekday: json['weekday'] ?? '',
      paksha: json['paksha'] ?? '',
      tithi: json['tithi'] ?? '',
      tithiName: json['tithi_name'] ?? '',
      nakshatra: json['nakshatra'] ?? '',
      yoga: json['yoga'] ?? '',
      karan: json['karan'] ?? '',
      rahuKaal: json['rahu_kaal'] ?? '',
      abhijitMuhurta: json['abhijit_muhurta'] ?? '',
      hinduMonth: json['hindu_month'] ?? '',
      special: List<String>.from(json['special'] ?? []),
      sunLon: (json['sun_lon'] as num?)?.toDouble() ?? 0.0,
      moonLon: (json['moon_lon'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class Festival {
  final String id;
  final String name;
  final String date;
  final String significance;
  final String story;
  final String teenTakeaway;
  final String source;
  final String colorHex;

  Festival({
    required this.id,
    required this.name,
    required this.date,
    required this.significance,
    required this.story,
    required this.teenTakeaway,
    required this.source,
    required this.colorHex,
  });

  Color get color {
    try {
      final hex = colorHex.replaceAll('#', '');
      return Color(int.parse('FF$hex', radix: 16));
    } catch (_) {
      return Colors.amber;
    }
  }

  factory Festival.fromJson(Map<String, dynamic> json) {
    return Festival(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      date: json['date'] ?? '',
      significance: json['significance'] ?? '',
      story: json['story'] ?? '',
      teenTakeaway: json['teen_takeaway'] ?? '',
      source: json['source'] ?? '',
      colorHex: json['color'] ?? '#E65100',
    );
  }
}

class Verse {
  final int number;
  final String sanskrit;
  final String transliteration;
  final String translation;
  final String meaning;

  Verse({
    required this.number,
    required this.sanskrit,
    required this.transliteration,
    required this.translation,
    required this.meaning,
  });

  factory Verse.fromJson(Map<String, dynamic> json) {
    return Verse(
      number:
          json['verse_number'] ?? json['sutram_number'] ?? json['number'] ?? 0,
      sanskrit: json['sanskrit'] ?? json['text'] ?? '',
      transliteration: json['transliteration'] ?? '',
      translation: json['translation'] ?? '',
      meaning: json['meaning'] ?? json['explanation'] ?? '',
    );
  }
}

class Chapter {
  final int number;
  final String name;
  final String nameMeaning;
  final String summary;
  final int totalVerses;
  final List<Verse> verses;

  Chapter({
    required this.number,
    required this.name,
    required this.nameMeaning,
    required this.summary,
    required this.totalVerses,
    required this.verses,
  });

  factory Chapter.fromJson(Map<String, dynamic> json) {
    final vList = (json['verses'] as List<dynamic>?) ?? [];
    return Chapter(
      number: json['chapter'] ?? json['book'] ?? 1,
      name: json['name'] ?? '',
      nameMeaning: json['name_meaning'] ?? '',
      summary: json['summary'] ?? '',
      totalVerses: json['total_verses'] ?? vList.length,
      verses: vList.map((v) => Verse.fromJson(v)).toList(),
    );
  }
}

class ScriptureItem {
  final String id;
  final String title;
  final String subtitle;
  final String author;
  final String period;
  final String introduction;
  final List<Chapter> chapters;
  final List<Verse> flatVerses;

  ScriptureItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.author,
    required this.period,
    required this.introduction,
    required this.chapters,
    required this.flatVerses,
  });
}

class Tradition {
  final String id;
  final String title;
  final String titleHi;
  final String subtitle;
  final String subtitleHi;
  final String shortStory;
  final String shortStoryHi;
  final String historicalOrigin;
  final String historicalOriginHi;
  final String scientificLogic;
  final String scientificLogicHi;
  final String linkedScriptureId;
  final List<String> tags;
  final String category;
  final String source;

  Tradition({
    required this.id,
    required this.title,
    required this.titleHi,
    required this.subtitle,
    required this.subtitleHi,
    required this.shortStory,
    required this.shortStoryHi,
    required this.historicalOrigin,
    required this.historicalOriginHi,
    required this.scientificLogic,
    required this.scientificLogicHi,
    required this.linkedScriptureId,
    required this.tags,
    required this.category,
    required this.source,
  });

  factory Tradition.fromJson(Map<String, dynamic> json) {
    return Tradition(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      titleHi: json['title_hi'] ?? json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      subtitleHi: json['subtitle_hi'] ?? json['subtitle'] ?? '',
      shortStory: json['short_story'] ?? '',
      shortStoryHi: json['short_story_hi'] ?? json['short_story'] ?? '',
      historicalOrigin: json['historical_origin'] ?? '',
      historicalOriginHi:
          json['historical_origin_hi'] ?? json['historical_origin'] ?? '',
      scientificLogic: json['scientific_logic'] ?? '',
      scientificLogicHi:
          json['scientific_logic_hi'] ?? json['scientific_logic'] ?? '',
      linkedScriptureId: json['linked_scripture_id'] ?? '',
      tags: List<String>.from(json['tags'] ?? []),
      category: json['category'] ?? 'Daily Practice',
      source: json['source'] ?? '',
    );
  }
}

class VedaMantra {
  final int number;
  final String sanskrit;
  final String transliteration;
  final String translationHi;
  final String translationEn;

  VedaMantra({
    required this.number,
    required this.sanskrit,
    required this.transliteration,
    required this.translationHi,
    required this.translationEn,
  });

  factory VedaMantra.fromJson(Map<String, dynamic> json) {
    return VedaMantra(
      number: json['number'] ?? 1,
      sanskrit: json['sanskrit'] ?? '',
      transliteration: json['transliteration'] ?? '',
      translationHi: json['translation_hi'] ?? '',
      translationEn: json['translation_en'] ?? '',
    );
  }
}

class VedaSection {
  final String sectionName;
  final String summaryHi;
  final List<VedaMantra> mantras;

  VedaSection({
    required this.sectionName,
    required this.summaryHi,
    required this.mantras,
  });

  factory VedaSection.fromJson(Map<String, dynamic> json) {
    final mList = (json['mantras'] as List<dynamic>?) ?? [];
    return VedaSection(
      sectionName: json['section_name'] ?? '',
      summaryHi: json['summary_hi'] ?? '',
      mantras: mList.map((m) => VedaMantra.fromJson(m)).toList(),
    );
  }
}

class VedaText {
  final String id;
  final String name;
  final String nameHi;
  final String subtitle;
  final String vedicPeriod;
  final int totalMandalas;
  final int totalSuktas;
  final String summary;
  final List<VedaSection> sections;

  VedaText({
    required this.id,
    required this.name,
    required this.nameHi,
    required this.subtitle,
    required this.vedicPeriod,
    required this.totalMandalas,
    required this.totalSuktas,
    required this.summary,
    required this.sections,
  });

  factory VedaText.fromJson(Map<String, dynamic> json) {
    final sList = (json['sections'] as List<dynamic>?) ?? [];
    return VedaText(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      nameHi: json['name_hi'] ?? json['name'] ?? '',
      subtitle: json['subtitle'] ?? '',
      vedicPeriod: json['vedic_period'] ?? '',
      totalMandalas: json['total_mandalas'] ?? 0,
      totalSuktas: json['total_suktas'] ?? 0,
      summary: json['summary'] ?? '',
      sections: sList.map((s) => VedaSection.fromJson(s)).toList(),
    );
  }
}

class PuranSection {
  final String title;
  final String kathaHi;
  final String keyShloka;

  PuranSection({
    required this.title,
    required this.kathaHi,
    required this.keyShloka,
  });

  factory PuranSection.fromJson(Map<String, dynamic> json) {
    return PuranSection(
      title: json['title'] ?? '',
      kathaHi: json['katha_hi'] ?? '',
      keyShloka: json['key_shloka'] ?? '',
    );
  }
}

class PuranText {
  final String id;
  final String name;
  final String subtitle;
  final int versesCount;
  final int skandhasCount;
  final int chaptersCount;
  final String overviewHi;
  final List<PuranSection> sections;

  PuranText({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.versesCount,
    required this.skandhasCount,
    required this.chaptersCount,
    required this.overviewHi,
    required this.sections,
  });

  factory PuranText.fromJson(Map<String, dynamic> json) {
    final sList = (json['sections'] as List<dynamic>?) ?? [];
    return PuranText(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      subtitle: json['subtitle'] ?? '',
      versesCount: json['verses_count'] ?? 0,
      skandhasCount: json['skandhas_count'] ?? 1,
      chaptersCount: json['chapters_count'] ?? 1,
      overviewHi: json['overview_hi'] ?? '',
      sections: sList.map((s) => PuranSection.fromJson(s)).toList(),
    );
  }
}
