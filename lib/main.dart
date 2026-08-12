import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yapter/Providers/theme_provider.dart';
import 'package:yapter/Screens/Profile/theme_preferences.dart';
import 'package:yapter/Screens/wrapper.dart';
import 'package:yapter/Theme/app_theme.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  await ThemePreferences.init();
  runApp(ProviderScope(child: const Yapter()));
}
class Yapter extends ConsumerWidget {
  const Yapter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeNotifierProvider);

    return MaterialApp(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,

      themeMode: isDarkMode
          ? ThemeMode.dark
          : ThemeMode.light,

      debugShowCheckedModeBanner: false,
      home: const Wrapper(),
    );
  }
}