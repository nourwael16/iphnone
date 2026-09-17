import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primarySky = Color(0xFF4FC3F7);
  static const Color primaryPurple = Color(0xFF9C27B0);
  static const Color accentYellow = Color(0xFFFFD54F);
  static const Color accentOrange = Color(0xFFFF8A65);
  static const Color accentGreen = Color(0xFF81C784);
  static const Color accentPink = Color(0xFFFF80AB);
  static const Color bgCloud = Color(0xFFF0F8FF);
  static const Color textDark = Color(0xFF2C3E50);

  static ThemeData get lightTheme {
    final baseText = GoogleFonts.fredokaTextTheme();

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: bgCloud,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primarySky,
        primary: primarySky,
        secondary: accentOrange,
        tertiary: accentYellow,
        surface: bgCloud,
      ),
      textTheme: baseText.copyWith(
        displayLarge: GoogleFonts.fredoka(
          fontSize: 48,
          fontWeight: FontWeight.bold,
          color: textDark,
        ),
        displayMedium: GoogleFonts.fredoka(
          fontSize: 36,
          fontWeight: FontWeight.bold,
          color: textDark,
        ),
        titleLarge: GoogleFonts.fredoka(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: textDark,
        ),
        bodyLarge: GoogleFonts.fredoka(
          fontSize: 18,
          color: textDark,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 6,
        shadowColor: Colors.black.withOpacity(0.12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 6,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          textStyle: GoogleFonts.fredoka(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
