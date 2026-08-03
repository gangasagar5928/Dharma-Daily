import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/data_service.dart';
import '../widgets/widgets.dart';
import 'detail_sheets.dart';

class HomeScreen extends StatelessWidget {
  final Function(int) onNavigateTab;

  const HomeScreen({super.key, required this.onNavigateTab});

  @override
  Widget build(BuildContext context) {
    final ds = DataService();
    final todayStr = DateTime.now().toIso8601String().substring(0, 10);
    final todayPanchang = ds.getPanchangForDate(todayStr) ?? (ds.panchangDays.isNotEmpty ? ds.panchangDays.first : null);
    final dailyVerse = ds.getRandomDailyVerse();
    final upcomingFestivals = ds.getUpcomingFestivals(limit: 6);
    final featuredTradition = ds.traditions.isNotEmpty ? ds.traditions.first : null;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Custom Top Header Banner
              TopHeaderBanner(
                onMenuTap: () => Scaffold.of(context).openDrawer(),
                onSearchTap: () => onNavigateTab(2), // Navigate to Library search
                onNotificationTap: () => showNotificationSheet(context),
              ),

              // Today's Panchang Summary Card
              if (todayPanchang != null) ...[
                SectionHeader(
                  title: "Today's Panchang",
                  subtitle: "Vedic Astronomical Calendar",
                  onSeeAll: () => onNavigateTab(1),
                ),
                SimplePanchangCard(
                  panchang: todayPanchang,
                  onTap: () => onNavigateTab(1),
                ),
              ],

              const SizedBox(height: 12),

              // Daily Verse / Wisdom Card
              SectionHeader(
                title: "Daily Shloka",
                subtitle: "Wisdom of the Day",
              ),
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.format_quote, color: Colors.amber, size: 28),
                          const SizedBox(width: 8),
                          Text(
                            'Bhagavad Gita Verse ${dailyVerse.number}',
                            style: GoogleFonts.cinzel(
                              fontWeight: FontWeight.bold,
                              color: Colors.amber,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      SelectableText(
                        dailyVerse.sanskrit,
                        style: GoogleFonts.notoSansDevanagari(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber.shade200,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        dailyVerse.translation,
                        style: const TextStyle(fontSize: 14, height: 1.4),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Upcoming Festivals
              if (upcomingFestivals.isNotEmpty) ...[
                SectionHeader(
                  title: "Upcoming Festivals",
                  subtitle: "Sacred Celebrations",
                ),
                SizedBox(
                  height: 140,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    itemCount: upcomingFestivals.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final f = upcomingFestivals[index];
                      return FestivalCard(
                        festival: f,
                        onTap: () => showFestivalSheet(context, f),
                      );
                    },
                  ),
                ),
              ],

              const SizedBox(height: 12),

              // Featured Tradition
              if (featuredTradition != null) ...[
                SectionHeader(
                  title: "Featured Ritual",
                  subtitle: "Ancient Wisdom & Modern Science",
                  onSeeAll: () => onNavigateTab(2), // Library tab
                ),
                HeroTraditionCard(
                  tradition: featuredTradition,
                  onTap: () => showTraditionSheet(context, featuredTradition),
                ),
              ],

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
