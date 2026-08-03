import 'package:flutter/material.dart';
import 'data/data_service.dart';
import 'data/prefs_service.dart';
import 'theme.dart';
import 'screens/home_screen.dart';
import 'screens/calendar_screen.dart';
import 'screens/library_screen.dart';
import 'screens/detail_sheets.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PrefsService.init();
  runApp(const DharmaDailyApp());
}

class DharmaDailyApp extends StatelessWidget {
  const DharmaDailyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dharma Daily',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await DataService().loadAllData();
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  void _onNavigateTab(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.asset(
                  'assets/images/app_logo.png',
                  width: 140,
                  height: 140,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 24),
              const CircularProgressIndicator(color: Colors.amber),
              const SizedBox(height: 16),
              Text(
                'Loading Dharma Daily...',
                style: TextStyle(
                  color: Colors.amber.shade200,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final screens = [
      HomeScreen(onNavigateTab: _onNavigateTab),
      const CalendarScreen(),
      const LibraryScreen(),
    ];

    return Scaffold(
      drawer: Drawer(
        child: Container(
          color: const Color(0xFF131314),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF2C1400), Color(0xFF1A0A00)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            'assets/images/app_logo.png',
                            width: 48,
                            height: 48,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'DHARMA DAILY',
                              style: TextStyle(
                                color: Colors.amber,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                letterSpacing: 1.2,
                              ),
                            ),
                            Text(
                              '॥ धर्मो रक्षति रक्षितः ॥',
                              style: TextStyle(
                                color: Colors.amberAccent,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Vedic Panchang & Sacred Literature Reader',
                      style: TextStyle(color: Colors.grey, fontSize: 11),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.home_outlined, color: Colors.amber),
                title: const Text('Home Dashboard', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  _onNavigateTab(0);
                },
              ),
              ListTile(
                leading: const Icon(Icons.calendar_month_outlined, color: Colors.amber),
                title: const Text('Panchang Calendar 2026', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  _onNavigateTab(1);
                },
              ),
              ListTile(
                leading: const Icon(Icons.auto_stories_outlined, color: Colors.amber),
                title: const Text('Sacred Scriptures & Vedas', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  _onNavigateTab(2);
                },
              ),
              ListTile(
                leading: const Icon(Icons.cloud_download_outlined, color: Colors.amber),
                title: const Text('Google Drive PDF Reader', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  _onNavigateTab(2);
                },
              ),
              const Divider(color: Colors.white24),
              ListTile(
                leading: const Icon(Icons.notifications_active_outlined, color: Colors.amber),
                title: const Text('Spiritual Reminders & Alerts', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  showNotificationSheet(context);
                },
              ),
              const Divider(color: Colors.white24),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  'Dharma Daily v1.0.0 • 100% Offline Vedic App',
                  style: TextStyle(color: Colors.grey, fontSize: 11),
                ),
              ),
            ],
          ),
        ),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined),
            activeIcon: Icon(Icons.calendar_month),
            label: 'Panchang',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_stories_outlined),
            activeIcon: Icon(Icons.auto_stories),
            label: 'Library',
          ),
        ],
      ),
    );
  }
}
