import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData light() {
    return ThemeData(
      brightness: Brightness.light,
      textTheme: GoogleFonts.interTextTheme(),
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF5B6EF5),
        secondary: Color(0xFFFF8F3C),
        onSurface: Colors.black87,
      ),
      scaffoldBackgroundColor: const Color(0xFFF7F7FC),
    );
  }

  static ThemeData dark() {
    return ThemeData(
      brightness: Brightness.dark,
      textTheme: GoogleFonts.interTextTheme(
        ThemeData(brightness: Brightness.dark).textTheme,
      ),
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF5B6EF5),
        secondary: Color(0xFFFF8F3C),
        onSurface: Colors.white70,
      ),
      scaffoldBackgroundColor: const Color(0xFF0E0E12),
    );
  }
}
