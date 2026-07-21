import 'package:flutter/material.dart';

class AppTheme {
  // 1. Private Color Palette (Keeps your code clean)
  static const Color _neuBackground = Color(0xFFE6EBF2);
  static const Color _primaryBlue = Color(0xFF0A84FF);
  static const Color _textMain = Color(0xFF1A1C20);
  static const Color _textFaded = Color(0xFF7A8A9E);

  // 2. The Global Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: _neuBackground,


      colorScheme: const ColorScheme.light(
        primary: _primaryBlue,
        onPrimary: Colors.white,
        secondary: _primaryBlue,
        surface: _neuBackground,
        onSurface: _textMain,
      ),

      textTheme: const TextTheme(
        titleLarge: TextStyle(
          color: _textMain,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
        titleMedium: TextStyle(
          color: _textMain,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          color: _textMain,
          fontSize: 15,
        ),
        labelSmall: TextStyle(
          color: _textFaded,
          fontSize: 11,
        ),
      ),
 appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: _textMain),
      ),

      // Globally styles default icons
      iconTheme: const IconThemeData(
        color: _textFaded,
        size: 24,
      ),
    );
  }
}