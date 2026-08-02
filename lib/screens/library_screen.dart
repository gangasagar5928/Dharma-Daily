import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/data_service.dart';
import '../models/models.dart';
import 'detail_sheets.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ds = DataService();

    final filteredScriptures = ds.scriptures.where((s) {
      final matchesSearch = s.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          s.subtitle.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          s.author.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesSearch;
    }).toList();

    final filteredVedas = ds.vedas.where((v) {
      return v.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          v.nameHi.contains(_searchQuery) ||
          v.subtitle.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    final filteredPuranas = ds.puranas.where((p) {
      return p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.subtitle.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    final filteredTraditions = ds.traditions.where((t) {
      final matchesSearch = t.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          t.titleHi.contains(_searchQuery) ||
          t.subtitle.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          t.category.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCat = _selectedCategory == 'All' || t.category == _selectedCategory;
      return matchesSearch && matchesCat;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('DHARMA LIBRARY'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Colors.amber,
          labelColor: Colors.amber,
          unselectedLabelColor: Colors.grey,
          labelStyle: GoogleFonts.cinzel(fontWeight: FontWeight.bold, fontSize: 14),
          tabs: const [
            Tab(text: 'Scriptures'),
            Tab(text: 'चार वेद (Vedas)'),
            Tab(text: 'अष्टादश पुराण (Purans)'),
            Tab(text: 'Traditions & Rituals'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search scriptures, Vedas, Purans, or traditions...',
                prefixIcon: const Icon(Icons.search, color: Colors.amber),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                filled: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onChanged: (val) => setState(() => _searchQuery = val),
            ),
          ),

          // TabBarView Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // 1. Scripture List
                _buildScriptureList(context, filteredScriptures),

                // 2. Vedas List
                _buildVedasList(context, filteredVedas),

                // 3. Purans List
                _buildPuransList(context, filteredPuranas),

                // 4. Tradition List
                _buildTraditionList(context, filteredTraditions),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScriptureList(BuildContext context, List<ScriptureItem> scriptures) {
    if (scriptures.isEmpty) {
      return const Center(child: Text('No scriptures match your search.'));
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: scriptures.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final s = scriptures[index];
        return Card(
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.menu_book, color: Colors.amber, size: 28),
            ),
            title: Text(
              s.title,
              style: GoogleFonts.cinzel(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(s.subtitle, style: const TextStyle(color: Colors.amber, fontSize: 13)),
                const SizedBox(height: 6),
                Text(
                  '${s.author} • ${s.chapters.length} Chapters • ${s.flatVerses.length} Verses',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            onTap: () => showScriptureSheet(context, s),
          ),
        );
      },
    );
  }

  Widget _buildVedasList(BuildContext context, List<VedaText> vedas) {
    if (vedas.isEmpty) {
      return const Center(child: Text('No Vedas found.'));
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: vedas.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final v = vedas[index];
        return Card(
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.deepOrange.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.history_edu, color: Colors.deepOrange, size: 28),
            ),
            title: Text(
              v.nameHi,
              style: GoogleFonts.notoSansDevanagari(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.amber,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(v.subtitle, style: const TextStyle(fontSize: 13, color: Colors.grey)),
                const SizedBox(height: 6),
                Text(
                  '${v.totalMandalas} मण्डल / काण्ड • ${v.totalSuktas} ऋचाएं (Verses)',
                  style: const TextStyle(fontSize: 12, color: Colors.amberAccent),
                ),
              ],
            ),
            trailing: const Icon(Icons.picture_as_pdf, size: 22, color: Colors.amber),
            onTap: () => showVedaSheet(context, v),
          ),
        );
      },
    );
  }

  Widget _buildPuransList(BuildContext context, List<PuranText> puranas) {
    if (puranas.isEmpty) {
      return const Center(child: Text('No Purans found.'));
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: puranas.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final p = puranas[index];
        return Card(
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.purple.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.auto_stories, color: Colors.purpleAccent, size: 28),
            ),
            title: Text(
              p.name,
              style: GoogleFonts.notoSansDevanagari(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(p.subtitle, style: const TextStyle(fontSize: 13, color: Colors.grey)),
                const SizedBox(height: 6),
                Text(
                  '${p.versesCount} श्लोक (Verses)',
                  style: const TextStyle(fontSize: 12, color: Colors.purpleAccent),
                ),
              ],
            ),
            trailing: const Icon(Icons.cloud_download, size: 20, color: Colors.purpleAccent),
            onTap: () => showPuranSheet(context, p),
          ),
        );
      },
    );
  }

  Widget _buildTraditionList(BuildContext context, List<Tradition> traditions) {
    if (traditions.isEmpty) {
      return const Center(child: Text('No traditions found.'));
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: traditions.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final t = traditions[index];
        return Card(
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.nature_people_outlined, color: Colors.blueAccent, size: 28),
            ),
            title: Text(
              '${t.titleHi} (${t.title})',
              style: GoogleFonts.notoSansDevanagari(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(t.subtitleHi, style: const TextStyle(fontSize: 13, color: Colors.grey)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text('द्विभाषी (Hindi & English)', style: TextStyle(fontSize: 11, color: Colors.blueAccent)),
                    ),
                  ],
                ),
              ],
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            onTap: () => showTraditionSheet(context, t),
          ),
        );
      },
    );
  }
}
