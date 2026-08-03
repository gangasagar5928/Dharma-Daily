import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../data/data_service.dart';
import '../data/prefs_service.dart';
import '../models/models.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late DateTime _selectedDate;
  late String _selectedRegion;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _selectedRegion = PrefsService.region;
  }

  @override
  Widget build(BuildContext context) {
    final ds = DataService();
    final dateStr = DateFormat('yyyy-MM-dd').format(_selectedDate);
    final panchang = ds.getPanchangForDate(dateStr);

    return Scaffold(
      appBar: AppBar(
        title: const Text('PANCHANG CALENDAR'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.location_on_outlined),
            tooltip: 'Select Region',
            initialValue: _selectedRegion,
            onSelected: (val) async {
              await PrefsService.setRegion(val);
              setState(() => _selectedRegion = val);
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                  value: 'North India',
                  child: Text('North India (Purnimanta)')),
              PopupMenuItem(
                  value: 'South India', child: Text('South India (Amanta)')),
              PopupMenuItem(
                  value: 'Gujarat & West',
                  child: Text('Gujarat & Western India')),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Calendar Month Navigation & Date Picker
            Container(
              color: Theme.of(context).colorScheme.surface,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: CalendarDatePicker(
                initialDate: _selectedDate,
                firstDate: DateTime(2024, 1, 1),
                lastDate: DateTime(2030, 12, 31),
                onDateChanged: (date) {
                  setState(() => _selectedDate = date);
                },
              ),
            ),
            const Divider(height: 1),

            // Region Indicator Badge
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Selected Date: ${DateFormat('EEEE, d MMMM yyyy').format(_selectedDate)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Chip(
                    avatar:
                        const Icon(Icons.place, size: 14, color: Colors.amber),
                    label: Text(_selectedRegion,
                        style: const TextStyle(fontSize: 11)),
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
            ),

            // Detailed Panchang View
            if (panchang != null)
              _FullPanchangExpander(panchang: panchang)
            else
              Card(
                margin: const EdgeInsets.all(16),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      const Icon(Icons.calendar_today,
                          size: 48, color: Colors.amber),
                      const SizedBox(height: 12),
                      Text(
                        'Panchang for ${DateFormat('d MMMM yyyy').format(_selectedDate)}',
                        style: GoogleFonts.cinzel(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Detailed ephemeris calculation for this date requires the upcoming year data pack.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _FullPanchangExpander extends StatelessWidget {
  final PanchangDay panchang;

  const _FullPanchangExpander({required this.panchang});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      panchang.tithi,
                      style: GoogleFonts.cinzel(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    Text(
                      '${panchang.paksha} Paksha • ${panchang.hinduMonth} Masa',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.amber.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child:
                      const Icon(Icons.wb_sunny, color: Colors.amber, size: 28),
                ),
              ],
            ),

            if (panchang.special.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: panchang.special
                    .map((s) => Chip(
                          backgroundColor: Colors.amber.withValues(alpha: 0.2),
                          label: Text(s,
                              style: const TextStyle(
                                  color: Colors.amber,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12)),
                        ))
                    .toList(),
              ),
            ],

            const Divider(height: 28),

            // Grid of Attributes
            Text('CORE PANCHANG ELEMENTS',
                style: GoogleFonts.cinzel(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey)),
            const SizedBox(height: 12),
            _buildDetailRow(
                context, 'Tithi Name', panchang.tithiName, Icons.brightness_6),
            _buildDetailRow(
                context, 'Nakshatra', panchang.nakshatra, Icons.star_outline),
            _buildDetailRow(
                context, 'Yoga', panchang.yoga, Icons.self_improvement),
            _buildDetailRow(context, 'Karan', panchang.karan, Icons.timelapse),

            const Divider(height: 28),

            // Auspicious & Inauspicious Muhurtas
            Text('MUHURTA & TIMINGS',
                style: GoogleFonts.cinzel(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey)),
            const SizedBox(height: 12),
            _buildDetailRow(context, 'Rahu Kaal (Inauspicious)',
                panchang.rahuKaal, Icons.warning_amber_rounded,
                isAlert: true),
            _buildDetailRow(context, 'Abhijit Muhurta (Auspicious)',
                panchang.abhijitMuhurta, Icons.check_circle_outline,
                isGood: true),

            const Divider(height: 28),

            // Solar & Lunar Ephemeris
            Text('ASTRONOMICAL COORDINATES',
                style: GoogleFonts.cinzel(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey)),
            const SizedBox(height: 12),
            _buildDetailRow(
                context,
                'Sun Longitude',
                '${panchang.sunLon.toStringAsFixed(2)}°',
                Icons.wb_sunny_outlined),
            _buildDetailRow(
                context,
                'Moon Longitude',
                '${panchang.moonLon.toStringAsFixed(2)}°',
                Icons.nightlight_round),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
      BuildContext context, String label, String value, IconData icon,
      {bool isAlert = false, bool isGood = false}) {
    Color valueColor = Colors.white;
    if (isAlert) valueColor = Colors.redAccent;
    if (isGood) valueColor = Colors.greenAccent;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Icon(icon,
              size: 18,
              color: isAlert
                  ? Colors.redAccent
                  : (isGood ? Colors.greenAccent : Colors.amber)),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}
