import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/models.dart';

class TopHeaderBanner extends StatelessWidget {
  final VoidCallback? onMenuTap;
  final VoidCallback? onSearchTap;
  final VoidCallback? onNotificationTap;

  const TopHeaderBanner({
    super.key,
    this.onMenuTap,
    this.onSearchTap,
    this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? Colors.amber.withValues(alpha: 0.4)
              : Colors.amber.shade700,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.6)
                : Colors.amber.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: AspectRatio(
          aspectRatio: 539 / 179,
          child: Stack(
            children: [
              // Banner Graphic
              Image.asset(
                'assets/images/top_bar_banner.png',
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),

              // Dark Theme Blend Overlay
              if (isDark)
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.10),
                        Colors.black.withValues(alpha: 0.30),
                      ],
                    ),
                  ),
                ),

              // Interactive Touch Regions over graphic icons
              Row(
                children: [
                  // Left Menu Touch Area
                  InkWell(
                    onTap: onMenuTap,
                    borderRadius: BorderRadius.circular(12),
                    child: const SizedBox(
                      width: 56,
                      height: double.infinity,
                    ),
                  ),

                  // Middle Area (Title & Verses)
                  const Expanded(
                    child: SizedBox.expand(),
                  ),

                  // Notification Touch Area
                  InkWell(
                    onTap: onNotificationTap ??
                        () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('No new notifications today.'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                    borderRadius: BorderRadius.circular(12),
                    child: const SizedBox(
                      width: 44,
                      height: double.infinity,
                    ),
                  ),

                  // Search Touch Area
                  InkWell(
                    onTap: onSearchTap,
                    borderRadius: BorderRadius.circular(12),
                    child: const SizedBox(
                      width: 44,
                      height: double.infinity,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback? onSeeAll;

  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.cinzel(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
            ],
          ),
          if (onSeeAll != null)
            TextButton(
              onPressed: onSeeAll,
              child: const Text('See All'),
            ),
        ],
      ),
    );
  }
}

class SimplePanchangCard extends StatelessWidget {
  final PanchangDay panchang;
  final VoidCallback onTap;

  const SimplePanchangCard({
    super.key,
    required this.panchang,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
                Theme.of(context).colorScheme.secondary.withValues(alpha: 0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined,
                          color: Colors.amber, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        '${panchang.weekday}, ${panchang.date}',
                        style: GoogleFonts.cinzel(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${panchang.hinduMonth} Masa',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber,
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildPanchangItem(context, 'Tithi', panchang.tithi),
                  _buildPanchangItem(context, 'Paksha', panchang.paksha),
                  _buildPanchangItem(context, 'Nakshatra', panchang.nakshatra),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildPanchangItem(context, 'Yoga', panchang.yoga),
                  _buildPanchangItem(context, 'Rahu Kaal', panchang.rahuKaal),
                  _buildPanchangItem(
                      context, 'Abhijit', panchang.abhijitMuhurta),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPanchangItem(BuildContext context, String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Colors.grey),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class HeroTraditionCard extends StatelessWidget {
  final Tradition tradition;
  final VoidCallback onTap;

  const HeroTraditionCard({
    super.key,
    required this.tradition,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.amber.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.auto_awesome,
                        color: Colors.amber, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tradition.title,
                          style: GoogleFonts.cinzel(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          tradition.subtitle,
                          style: TextStyle(
                            fontSize: 13,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                tradition.shortStory,
                style: const TextStyle(fontSize: 14, height: 1.4),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blue.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.science_outlined,
                            size: 14, color: Colors.blueAccent),
                        SizedBox(width: 4),
                        Text('Scientific Logic Inside',
                            style: TextStyle(
                                fontSize: 11, color: Colors.blueAccent)),
                      ],
                    ),
                  ),
                  const Spacer(),
                  const Text('Read Ritual Details →',
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.amber,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FestivalCard extends StatelessWidget {
  final Festival festival;
  final VoidCallback onTap;

  const FestivalCard({
    super.key,
    required this.festival,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 220,
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: festival.color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  festival.date,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: festival.color,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                festival.name,
                style: GoogleFonts.cinzel(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                festival.significance,
                style: const TextStyle(
                    fontSize: 12, color: Colors.grey, height: 1.3),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
