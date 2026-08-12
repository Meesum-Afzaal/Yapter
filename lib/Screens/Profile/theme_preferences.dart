import 'package:hive_ce_flutter/hive_ce_flutter.dart';

class ThemePreferences {
  static const String _boxName = 'app_preferences';
  static const String _darkModeKey = 'dark_mode';

  static Future<void> init() async {
    await Hive.openBox(_boxName);
  }

  static bool getDarkMode() {
    final box = Hive.box(_boxName);

    return box.get(
      _darkModeKey,
      defaultValue: false,
    );
  }

  static Future<void> setDarkMode(bool isDarkMode) async {
    final box = Hive.box(_boxName);

    await box.put(
      _darkModeKey,
      isDarkMode,
    );
  }
}