import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brand Palette
  static const Color primarySaffron = Color(0xFFE65100);
  static const Color accentGold = Color(0xFFFFB300);
  static const Color deepCrimson = Color(0xFF880E4F);
  static const Color darkBg = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkCard = Color(0xFF282828);
  static const Color lightBg = Color(0xFFFAFAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFF3F4F6);

  static ThemeData get darkTheme {
    final baseTextTheme = ThemeData.dark().textTheme;
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkBg,
      colorScheme: const ColorScheme.dark(
        primary: primarySaffron,
        secondary: accentGold,
        tertiary: deepCrimson,
        surface: darkSurface,
        onSurface: Colors.white,
        onPrimary: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: darkSurface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.cinzel(
          color: accentGold,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
        iconTheme: const IconThemeData(color: accentGold),
      ),
      cardTheme: CardThemeData(
        color: darkCard,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      textTheme: GoogleFonts.outfitTextTheme(baseTextTheme).copyWith(
        displayLarge: GoogleFonts.cinzel(color: accentGold, fontWeight: FontWeight.bold),
        headlineMedium: GoogleFonts.cinzel(color: Colors.white, fontWeight: FontWeight.w600),
        titleLarge: GoogleFonts.cinzel(color: accentGold, fontWeight: FontWeight.w600),
        bodyLarge: GoogleFonts.outfit(color: Colors.white70, fontSize: 16),
        bodyMedium: GoogleFonts.outfit(color: Colors.white60, fontSize: 14),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: darkSurface,
        selectedItemColor: accentGold,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
    );
  }

  static ThemeData get lightTheme {
    final baseTextTheme = ThemeData.light().textTheme;
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: lightBg,
      colorScheme: const ColorScheme.light(
        primary: primarySaffron,
        secondary: accentGold,
        tertiary: deepCrimson,
        surface: lightSurface,
        onSurface: Colors.black87,
        onPrimary: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: lightSurface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.cinzel(
          color: primarySaffron,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
        iconTheme: const IconThemeData(color: primarySaffron),
      ),
      cardTheme: CardThemeData(
        color: lightCard,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      textTheme: GoogleFonts.outfitTextTheme(baseTextTheme).copyWith(
        displayLarge: GoogleFonts.cinzel(color: primarySaffron, fontWeight: FontWeight.bold),
        headlineMedium: GoogleFonts.cinzel(color: Colors.black87, fontWeight: FontWeight.w600),
        titleLarge: GoogleFonts.cinzel(color: primarySaffron, fontWeight: FontWeight.w600),
        bodyLarge: GoogleFonts.outfit(color: Colors.black87, fontSize: 16),
        bodyMedium: GoogleFonts.outfit(color: Colors.black54, fontSize: 14),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: lightSurface,
        selectedItemColor: primarySaffron,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
    );
  }
}
