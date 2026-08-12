import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yapter/Screens/Profile/theme_preferences.dart';


part 'theme_provider.g.dart';

@riverpod
class ThemeNotifier extends _$ThemeNotifier {
  @override
  bool build() {
    return ThemePreferences.getDarkMode();
  }

  Future<void> toggleTheme() async {
    final newValue = !state;

    state = newValue;

    await ThemePreferences.setDarkMode(newValue);
  }
}