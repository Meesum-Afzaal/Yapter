import 'package:flutter/material.dart';
class AppTheme {
  // LIGHT
  static const Color lightBackground = Color(0xFFE0E5EC);

  static const Color lightTextPrimary = Color(0xFF4A5159);
  static const Color lightTextSecondary = Color(0xFF7A828B);

  static const Color lightShadowLight = Colors.white;
  static const Color lightShadowDark = Color(0xFFBEC4CC);

  // DARK
  static const Color darkBackground = Color(0xFF2E3239);

  static const Color darkTextPrimary = Color(0xFFD5D9DE);
  static const Color darkTextSecondary = Color(0xFF9DA5AE);

  static const Color darkShadowLight = Color(0xFF3A4048);
  static const Color darkShadowDark = Color(0xFF202328);

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: lightBackground,

      colorScheme: const ColorScheme.light(
        surface: lightBackground,
      ),

      textTheme: const TextTheme(
        bodyLarge: TextStyle(
          color: lightTextPrimary,
        ),
        bodyMedium: TextStyle(
          color: lightTextPrimary,
        ),
        bodySmall: TextStyle(
          color: lightTextSecondary,
        ),
        titleLarge: TextStyle(
          color: lightTextPrimary,
        ),
        titleMedium: TextStyle(
          color: lightTextPrimary,
        ),
        titleSmall: TextStyle(
          color: lightTextSecondary,
        ),
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: lightTextPrimary,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkBackground,

      colorScheme: const ColorScheme.dark(
        surface: darkBackground,
      ),

      textTheme: const TextTheme(
        bodyLarge: TextStyle(
          color: darkTextPrimary,
        ),
        bodyMedium: TextStyle(
          color: darkTextPrimary,
        ),
        bodySmall: TextStyle(
          color: darkTextSecondary,
        ),
        titleLarge: TextStyle(
          color: darkTextPrimary,
        ),
        titleMedium: TextStyle(
          color: darkTextPrimary,
        ),
        titleSmall: TextStyle(
          color: darkTextSecondary,
        ),
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: darkTextPrimary,
      ),
    );
  }

  static Color background(BuildContext context) {
    return Theme.of(context).scaffoldBackgroundColor;
  }

  static Color lightShadow(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkShadowLight
        : lightShadowLight;
  }

  static Color darkShadow(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkShadowDark
        : lightShadowDark;
  }

  static Color textPrimary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkTextPrimary
        : lightTextPrimary;
  }

  static Color textSecondary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkTextSecondary
        : lightTextSecondary;
  }
}