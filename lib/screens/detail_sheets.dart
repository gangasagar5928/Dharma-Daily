import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/models.dart';
import '../data/prefs_service.dart';
import 'drive_pdf_screen.dart';

void showScriptureSheet(BuildContext context, ScriptureItem scripture) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => ScriptureDetailSheet(scripture: scripture),
  );
}

void showTraditionSheet(BuildContext context, Tradition tradition) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => TraditionDetailSheet(tradition: tradition),
  );
}

void showFestivalSheet(BuildContext context, Festival festival) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => FestivalDetailSheet(festival: festival),
  );
}

void showVedaSheet(BuildContext context, VedaText veda) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => VedaDetailSheet(veda: veda),
  );
}

void showPuranSheet(BuildContext context, PuranText puran) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => PuranDetailSheet(puran: puran),
  );
}

void showNotificationSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const NotificationDetailSheet(),
  );
}

class NotificationDetailSheet extends StatefulWidget {
  const NotificationDetailSheet({super.key});

  @override
  State<NotificationDetailSheet> createState() => _NotificationDetailSheetState();
}

class _NotificationDetailSheetState extends State<NotificationDetailSheet> {
  late bool _dailyShlokaAlert;
  late bool _panchangTithiAlert;
  late bool _festivalAlert;

  @override
  void initState() {
    super.initState();
    _dailyShlokaAlert = PrefsService.shlokaAlert;
    _panchangTithiAlert = PrefsService.panchangAlert;
    _festivalAlert = PrefsService.festivalAlert;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                const Icon(Icons.notifications_active, color: Colors.amber, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Dharma Daily Notifications',
                    style: GoogleFonts.cinzel(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildNotificationCard(
                  title: '🌅 Morning Panchang & Tithi Reminder',
                  subtitle: 'Daily 06:00 AM notification for Tithi, Rahu Kaal & Muhurta',
                  value: _panchangTithiAlert,
                  onChanged: (val) async {
                    await PrefsService.setPanchangAlert(val);
                    setState(() => _panchangTithiAlert = val);
                  },
                ),
                const SizedBox(height: 12),
                _buildNotificationCard(
                  title: '📜 Daily Shloka & Wisdom Verse',
                  subtitle: 'Daily 08:00 AM notification featuring Bhagavad Gita wisdom',
                  value: _dailyShlokaAlert,
                  onChanged: (val) async {
                    await PrefsService.setShlokaAlert(val);
                    setState(() => _dailyShlokaAlert = val);
                  },
                ),
                const SizedBox(height: 12),
                _buildNotificationCard(
                  title: '🚩 Upcoming Hindu Festival Alerts',
                  subtitle: '1-day advance reminder for Vrats, Ekadashi & Major Festivals',
                  value: _festivalAlert,
                  onChanged: (val) async {
                    await PrefsService.setFestivalAlert(val);
                    setState(() => _festivalAlert = val);
                  },
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.amber.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.amber),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Notifications are active and set according to local system time.',
                          style: TextStyle(fontSize: 13, height: 1.3),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Card(
      elevation: 2,
      child: SwitchListTile(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        value: value,
        activeColor: Colors.amber,
        onChanged: onChanged,
      ),
    );
  }
}

class ScriptureDetailSheet extends StatefulWidget {
  final ScriptureItem scripture;
  const ScriptureDetailSheet({super.key, required this.scripture});

  @override
  State<ScriptureDetailSheet> createState() => _ScriptureDetailSheetState();
}

class _ScriptureDetailSheetState extends State<ScriptureDetailSheet> {
  int _selectedChapterIndex = 0;

  @override
  Widget build(BuildContext context) {
    final currentChapter = widget.scripture.chapters.isNotEmpty
        ? widget.scripture.chapters[_selectedChapterIndex]
        : null;

    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Drag handle & Header
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.scripture.title,
                        style: GoogleFonts.cinzel(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      Text(
                        widget.scripture.subtitle,
                        style: const TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Chapter Selector if multiple chapters
          if (widget.scripture.chapters.length > 1)
            Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.scripture.chapters.length,
                itemBuilder: (context, index) {
                  final isSelected = index == _selectedChapterIndex;
                  final ch = widget.scripture.chapters[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                    child: ChoiceChip(
                      label: Text('Ch ${ch.number}: ${ch.name}'),
                      selected: isSelected,
                      onSelected: (val) {
                        if (val) setState(() => _selectedChapterIndex = index);
                      },
                    ),
                  );
                },
              ),
            ),

          // Verse List
          Expanded(
            child: currentChapter == null
                ? const Center(child: Text('No verses available'))
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: currentChapter.verses.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final verse = currentChapter.verses[index];
                      final verseKey = '${widget.scripture.id}_${currentChapter.number}_${verse.number}';
                      final isBookmarked = PrefsService.isBookmarked(verseKey);

                      return Card(
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.amber.withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      'Verse ${verse.number}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.amber,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                                      color: isBookmarked ? Colors.amber : Colors.grey,
                                      size: 20,
                                    ),
                                    onPressed: () async {
                                      await PrefsService.toggleBookmark(verseKey);
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              SelectableText(
                                verse.sanskrit,
                                style: GoogleFonts.notoSansDevanagari(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  height: 1.5,
                                  color: Colors.amber.shade200,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              if (verse.transliteration.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                SelectableText(
                                  verse.transliteration,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                              const Divider(height: 20),
                              SelectableText(
                                verse.translation,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (verse.meaning.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    verse.meaning,
                                    style: const TextStyle(fontSize: 13, height: 1.4),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class TraditionDetailSheet extends StatefulWidget {
  final Tradition tradition;
  const TraditionDetailSheet({super.key, required this.tradition});

  @override
  State<TraditionDetailSheet> createState() => _TraditionDetailSheetState();
}

class _TraditionDetailSheetState extends State<TraditionDetailSheet> {
  String _language = 'hi'; // Default Hindi / Bilingual

  @override
  Widget build(BuildContext context) {
    final t = widget.tradition;
    final isFav = PrefsService.isFavoriteTradition(t.id);

    final title = _language == 'hi' ? t.titleHi : t.title;
    final subtitle = _language == 'hi' ? t.subtitleHi : t.subtitle;
    final shortStory = _language == 'hi' ? t.shortStoryHi : t.shortStory;
    final historicalOrigin = _language == 'hi' ? t.historicalOriginHi : t.historicalOrigin;
    final scientificLogic = _language == 'hi' ? t.scientificLogicHi : t.scientificLogic;

    return Container(
      height: MediaQuery.of(context).size.height * 0.88,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.cinzel(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: const TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: Colors.red),
                  onPressed: () async {
                    await PrefsService.toggleFavoriteTradition(t.id);
                    setState(() {});
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // Language Selector Bar
          Container(
            color: Colors.amber.withValues(alpha: 0.1),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Row(
              children: [
                const Icon(Icons.translate, size: 18, color: Colors.amber),
                const SizedBox(width: 8),
                const Text('Language / भाषा:', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                const Spacer(),
                ChoiceChip(
                  label: const Text('हिंदी (Hindi)'),
                  selected: _language == 'hi',
                  onSelected: (val) {
                    if (val) setState(() => _language = 'hi');
                  },
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('English'),
                  selected: _language == 'en',
                  onSelected: (val) {
                    if (val) setState(() => _language = 'en');
                  },
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle(_language == 'hi' ? 'परंपरा एवं अभ्यास (Overview)' : 'Overview & Practice'),
                  Text(
                    shortStory,
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.5,
                      fontFamily: _language == 'hi' ? 'NotoSansDevanagari' : null,
                    ),
                  ),
                  const SizedBox(height: 20),

                  _buildSectionTitle(_language == 'hi' ? 'ऐतिहासिक उद्गम (Historical Origin)' : 'Historical Origin'),
                  Text(
                    historicalOrigin,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: Colors.grey,
                      fontFamily: _language == 'hi' ? 'NotoSansDevanagari' : null,
                    ),
                  ),
                  const SizedBox(height: 20),

                  _buildSectionTitle(_language == 'hi' ? 'वैज्ञानिक एवं स्वास्थ्य तर्क (Scientific Logic)' : 'Scientific & Health Logic'),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.blue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.science, color: Colors.blueAccent, size: 22),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            scientificLogic,
                            style: TextStyle(
                              fontSize: 14,
                              height: 1.4,
                              fontFamily: _language == 'hi' ? 'NotoSansDevanagari' : null,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  if (t.source.isNotEmpty) ...[
                    _buildSectionTitle(_language == 'hi' ? 'शास्त्र प्रमाण (Scriptural Source)' : 'Scriptural Reference'),
                    Text(t.source, style: const TextStyle(fontSize: 13, fontStyle: FontStyle.italic, color: Colors.amber)),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: GoogleFonts.cinzel(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}

class VedaDetailSheet extends StatefulWidget {
  final VedaText veda;
  const VedaDetailSheet({super.key, required this.veda});

  @override
  State<VedaDetailSheet> createState() => _VedaDetailSheetState();
}

class _VedaDetailSheetState extends State<VedaDetailSheet> {
  int _selectedSectionIndex = 0;

  @override
  Widget build(BuildContext context) {
    final v = widget.veda;
    final currentSection = v.sections.isNotEmpty ? v.sections[_selectedSectionIndex] : null;

    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        v.nameHi,
                        style: GoogleFonts.notoSansDevanagari(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber,
                        ),
                      ),
                      Text(
                        v.subtitle,
                        style: const TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.picture_as_pdf, color: Colors.amber),
                  tooltip: 'Read Full PDF Scan (Google Drive)',
                  onPressed: () async {
                    await DriveSourcesService().load();
                    final sources = DriveSourcesService().vedas;
                    final source = sources.firstWhere(
                      (s) => s.id == v.id,
                      orElse: () => sources.isNotEmpty ? sources.first : const DriveSource(id: 'rigved', name: 'ऋग्वेद', nameEn: 'Rigveda', fileId: '1ULeopB6k19pC9OhoW7pXwiK1WunSbE34'),
                    );
                    if (context.mounted) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => DrivePdfScreen(source: source)),
                      );
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Section / Sukta Navigator
          if (v.sections.length > 1)
            Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: v.sections.length,
                itemBuilder: (context, index) {
                  final isSelected = index == _selectedSectionIndex;
                  final sec = v.sections[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                    child: ChoiceChip(
                      label: Text(sec.sectionName, style: const TextStyle(fontSize: 12)),
                      selected: isSelected,
                      onSelected: (val) {
                        if (val) setState(() => _selectedSectionIndex = index);
                      },
                    ),
                  );
                },
              ),
            ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Overview Box
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.amber.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Chip(
                              avatar: const Icon(Icons.history_edu, size: 14, color: Colors.amber),
                              label: Text('काल: ${v.vedicPeriod}', style: const TextStyle(fontSize: 11)),
                            ),
                            const SizedBox(width: 8),
                            Chip(
                              avatar: const Icon(Icons.format_list_numbered, size: 14, color: Colors.amber),
                              label: Text('${v.totalMandalas} मण्डल • ${v.totalSuktas} सूक्त', style: const TextStyle(fontSize: 11)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          v.summary,
                          style: GoogleFonts.notoSansDevanagari(fontSize: 14, height: 1.4),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Section Title & Summary
                  if (currentSection != null) ...[
                    Text(
                      currentSection.sectionName,
                      style: GoogleFonts.cinzel(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.amber),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      currentSection.summaryHi,
                      style: GoogleFonts.notoSansDevanagari(fontSize: 13, color: Colors.grey),
                    ),
                    const SizedBox(height: 16),

                    // Mantras List
                    ...currentSection.mantras.map((mantra) {
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.amber.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  'मंत्र ${mantra.number}',
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.amber),
                                ),
                              ),
                              const SizedBox(height: 12),
                              SelectableText(
                                mantra.sanskrit,
                                style: GoogleFonts.notoSansDevanagari(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  height: 1.5,
                                  color: Colors.amber.shade200,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              if (mantra.transliteration.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                SelectableText(
                                  mantra.transliteration,
                                  style: const TextStyle(fontSize: 13, fontStyle: FontStyle.italic, color: Colors.grey),
                                ),
                              ],
                              const Divider(height: 20),
                              Text('अर्थ (Hindi):', style: GoogleFonts.cinzel(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.amber)),
                              const SizedBox(height: 4),
                              SelectableText(
                                mantra.translationHi,
                                style: GoogleFonts.notoSansDevanagari(fontSize: 14, height: 1.4),
                              ),
                              if (mantra.translationEn.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                Text('English Translation:', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                const SizedBox(height: 2),
                                SelectableText(
                                  mantra.translationEn,
                                  style: const TextStyle(fontSize: 13, fontStyle: FontStyle.italic),
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PuranDetailSheet extends StatefulWidget {
  final PuranText puran;
  const PuranDetailSheet({super.key, required this.puran});

  @override
  State<PuranDetailSheet> createState() => _PuranDetailSheetState();
}

class _PuranDetailSheetState extends State<PuranDetailSheet> {
  int _selectedSectionIndex = 0;

  @override
  Widget build(BuildContext context) {
    final p = widget.puran;
    final currentSection = p.sections.isNotEmpty ? p.sections[_selectedSectionIndex] : null;

    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        p.name,
                        style: GoogleFonts.notoSansDevanagari(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.purpleAccent,
                        ),
                      ),
                      Text(
                        p.subtitle,
                        style: const TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.picture_as_pdf, color: Colors.purpleAccent),
                  tooltip: 'Read Full PDF Scan (Google Drive)',
                  onPressed: () async {
                    await DriveSourcesService().load();
                    final sources = DriveSourcesService().puranas;
                    final source = sources.firstWhere(
                      (s) => s.id == p.id,
                      orElse: () => sources.isNotEmpty ? sources.first : const DriveSource(id: 'bhagwat-puran', name: 'श्रीमद्भागवत पुराण', nameEn: 'Shrimad Bhagavat Purana', fileId: '1Fi2X70V8_FO5NBBoi4tespwt0cloHTWA'),
                    );
                    if (context.mounted) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => DrivePdfScreen(source: source)),
                      );
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Section Navigator
          if (p.sections.length > 1)
            Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: p.sections.length,
                itemBuilder: (context, index) {
                  final isSelected = index == _selectedSectionIndex;
                  final sec = p.sections[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                    child: ChoiceChip(
                      label: Text(sec.title, style: const TextStyle(fontSize: 12)),
                      selected: isSelected,
                      onSelected: (val) {
                        if (val) setState(() => _selectedSectionIndex = index);
                      },
                    ),
                  );
                },
              ),
            ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Overview Box
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.purple.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.purple.withValues(alpha: 0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Chip(
                              avatar: const Icon(Icons.auto_stories, size: 14, color: Colors.purpleAccent),
                              label: Text('${p.versesCount} श्लोक', style: const TextStyle(fontSize: 11)),
                            ),
                            const SizedBox(width: 8),
                            Chip(
                              avatar: const Icon(Icons.account_tree, size: 14, color: Colors.purpleAccent),
                              label: Text('${p.skandhasCount} स्कन्ध/खण्ड • ${p.chaptersCount} अध्याय', style: const TextStyle(fontSize: 11)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          p.overviewHi,
                          style: GoogleFonts.notoSansDevanagari(fontSize: 14, height: 1.4),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Section Details
                  if (currentSection != null) ...[
                    Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              currentSection.title,
                              style: GoogleFonts.notoSansDevanagari(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.purpleAccent,
                              ),
                            ),
                            const SizedBox(height: 12),

                            if (currentSection.keyShloka.isNotEmpty) ...[
                              Text('मूल श्लोक:', style: GoogleFonts.cinzel(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.amber)),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.amber.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: SelectableText(
                                  currentSection.keyShloka,
                                  style: GoogleFonts.notoSansDevanagari(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.amber.shade200,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(height: 14),
                            ],

                            Text('पौराणिक कथा एवं सार (Hindi Katha):', style: GoogleFonts.cinzel(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.purpleAccent)),
                            const SizedBox(height: 6),
                            SelectableText(
                              currentSection.kathaHi,
                              style: GoogleFonts.notoSansDevanagari(fontSize: 15, height: 1.5),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FestivalDetailSheet extends StatelessWidget {
  final Festival festival;
  const FestivalDetailSheet({super.key, required this.festival});

  @override
  Widget build(BuildContext context) {
    final f = festival;
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        f.name,
                        style: GoogleFonts.cinzel(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: f.color,
                        ),
                      ),
                      Text(
                        'Date: ${f.date}',
                        style: const TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle(context, 'Significance'),
                  Text(f.significance, style: const TextStyle(fontSize: 15, height: 1.5)),
                  const SizedBox(height: 20),

                  _buildSectionTitle(context, 'The Story & Mythology'),
                  Text(f.story, style: const TextStyle(fontSize: 14, height: 1.5, color: Colors.grey)),
                  const SizedBox(height: 20),

                  if (f.teenTakeaway.isNotEmpty) ...[
                    _buildSectionTitle(context, 'Youth & Modern Takeaway'),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.amber.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.lightbulb_outline, color: Colors.amber, size: 22),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              f.teenTakeaway,
                              style: const TextStyle(fontSize: 14, height: 1.4),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: GoogleFonts.cinzel(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
    );
  }
}
