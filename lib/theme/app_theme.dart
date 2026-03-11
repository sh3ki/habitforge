import 'package:flutter/material.dart';

class AppTheme {
  // HabitForge — Indigo Ink Palette
  static const Color primary = Color(0xFF3D405B);      // Deep indigo
  static const Color secondary = Color(0xFFE07A5F);    // Warm terracotta
  static const Color accent = Color(0xFF81B29A);        // Sage green
  static const Color surface = Color(0xFFF9F7F4);       // Warm ivory
  static const Color cardBg = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF2B2D42);
  static const Color textSecondary = Color(0xFF8D99AE);
  static const Color divider = Color(0xFFEDE8E3);
  static const Color navActive = Color(0xFF4338CA);  // Deep blue-purple

  static BoxShadow get cardShadow => BoxShadow(
    color: const Color(0xFF3D405B).withOpacity(0.06),
    blurRadius: 10,
    offset: const Offset(0, 3),
  );

  // Streak indicator colors
  static const Color streakActive = Color(0xFFE07A5F);
  static const Color streakGood = Color(0xFF81B29A);
  static const Color streakBest = Color(0xFF3D405B);
  static const Color streakMissed = Color(0xFFD64045);

  // Category colors for habits
  static const List<Color> habitColors = [
    Color(0xFF3D405B),
    Color(0xFFE07A5F),
    Color(0xFF81B29A),
    Color(0xFF5C6B8A),
    Color(0xFFD4A373),
    Color(0xFF6D8B74),
    Color(0xFF9B5DE5),
    Color(0xFFE76F51),
  ];

  static ThemeData get lightTheme {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        brightness: Brightness.light,
        primary: primary,
        secondary: secondary,
        surface: surface,
      ),
    );
    return base.copyWith(
      scaffoldBackgroundColor: surface,
      textTheme: base.textTheme.copyWith(
        displayLarge: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: textPrimary),
        headlineMedium: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: textPrimary),
        titleLarge: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: textPrimary),
        titleMedium: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: textPrimary),
        bodyLarge: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: textPrimary),
        bodyMedium: const TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: textSecondary),
        labelLarge: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, letterSpacing: 0.3),
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: surface,
        foregroundColor: textPrimary,
        titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: textPrimary),
      ),
      cardTheme: CardTheme(
        elevation: 0,
        color: cardBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: divider, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: secondary,
        foregroundColor: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: secondary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF4F0EB),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: secondary, width: 1.5)),
        labelStyle: const TextStyle(color: textSecondary, fontSize: 14),
        hintStyle: const TextStyle(color: textSecondary, fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}
