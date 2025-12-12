import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Pastel Color Palette
  static const Color pastelBlue = Color(0xFFAEC6CF);
  static const Color pastelGreen = Color(0xFF77DD77);
  static const Color pastelPurple = Color(0xFFB39EB5);
  static const Color pastelYellow = Color(0xFFFDFD96);
  static const Color pastelPink = Color(0xFFFFB7B2);
  static const Color creamBackground = Color(0xFFFEFBF5);
  static const Color darkText = Color(0xFF4A4A4A);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: creamBackground,
      colorScheme: ColorScheme.fromSeed(
        seedColor: pastelBlue,
        surface: creamBackground, // Replaced background
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.fredoka(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: darkText,
        ),
        headlineMedium: GoogleFonts.fredoka(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: darkText,
        ),
        bodyLarge: GoogleFonts.nunito(
          fontSize: 18,
          color: darkText,
        ),
        bodyMedium: GoogleFonts.nunito(
          fontSize: 16,
          color: darkText.withValues(alpha: 0.8),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.fredoka(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: darkText,
        ),
        iconTheme: const IconThemeData(color: darkText),
      ),
      /*
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: Colors.white,
      ),
      */
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: pastelBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: GoogleFonts.fredoka(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
