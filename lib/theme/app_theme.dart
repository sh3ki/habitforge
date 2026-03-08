import 'package:flutter/material.dart';

class AppTheme {
  // HabitForge Brand Colors — Warm Orange Palette
  static const Color primary = Color(0xFFFF6B35);
  static const Color primaryDark = Color(0xFFE64A19);
  static const Color secondary = Color(0xFFFFC107);
  static const Color accent = Color(0xFF4CAF50);
  static const Color surface = Color(0xFFFFFBF7);
  static const Color cardBg = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF1C1C1E);
  static const Color textSecondary = Color(0xFF8E8E93);
  static const Color divider = Color(0xFFF2EDE9);

  static BoxShadow get cardShadow => BoxShadow(
    color: const Color(0xFF000000).withOpacity(0.06),
    blurRadius: 12,
    offset: const Offset(0, 4),
  );

  // Habit frequency colors
  static const Color streakActive = Color(0xFFFF6B35);
  static const Color streakGood = Color(0xFFFFC107);
  static const Color streakBest = Color(0xFF4CAF50);
  static const Color streakMissed = Color(0xFFEF5350);

  // Category colors for habits
  static const List<Color> habitColors = [
    Color(0xFFFF6B35),
    Color(0xFFFFC107),
    Color(0xFF4CAF50),
    Color(0xFF2196F3),
    Color(0xFF9C27B0),
    Color(0xFFE91E63),
    Color(0xFF00BCD4),
    Color(0xFFFF5722),
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
        displayLarge: TextStyle(
            fontSize: 32, fontWeight: FontWeight.w800, color: textPrimary),
        headlineMedium: TextStyle(
            fontSize: 22, fontWeight: FontWeight.w700, color: textPrimary),
        titleLarge: TextStyle(
            fontSize: 18, fontWeight: FontWeight.w700, color: textPrimary),
        titleMedium: TextStyle(
            fontSize: 16, fontWeight: FontWeight.w600, color: textPrimary),
        bodyLarge: TextStyle(
            fontSize: 15, fontWeight: FontWeight.w500, color: textPrimary),
        bodyMedium: TextStyle(
            fontSize: 13, fontWeight: FontWeight.w400, color: textSecondary),
        labelLarge: TextStyle(
            fontSize: 13, fontWeight: FontWeight.w700, letterSpacing: 0.3),
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: surface,
        foregroundColor: textPrimary,
        titleTextStyle: TextStyle(
            fontSize: 20, fontWeight: FontWeight.w800, color: textPrimary),
      ),
      cardTheme: CardTheme(
        elevation: 0,
        color: cardBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: divider, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16))),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle:
              TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFFFF5F0),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: primary, width: 1.5)),
        labelStyle: TextStyle(color: textSecondary, fontSize: 14),
        hintStyle: TextStyle(color: textSecondary, fontSize: 14),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}
