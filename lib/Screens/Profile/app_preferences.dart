import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yapter/Designs/neumorphic_circle.dart';
import 'package:yapter/Designs/neumorphic_container.dart';
import 'package:yapter/Providers/theme_provider.dart';

class AppPreferences extends ConsumerStatefulWidget {
  const AppPreferences({super.key});

  @override
  ConsumerState<AppPreferences> createState() => _AppPreferencesState();
}

class _AppPreferencesState extends ConsumerState<AppPreferences> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeNotifierProvider);

    final baseColor = Theme.of(context).scaffoldBackgroundColor;

    final textColor = Theme.of(context).textTheme.bodyLarge?.color ??
        (isDarkMode ? Colors.white : Colors.black87);

    return Scaffold(
      backgroundColor: baseColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'App Preferences',
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(
          color: textColor,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Theme Appearance',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    ref
                        .read(themeNotifierProvider.notifier)
                        .toggleTheme();
                  },
                  child: NeumorphicContainer(
                    width: 100,
                    height: 50,
                    borderRadius: BorderRadius.circular(25),
                    backgroundColor: baseColor,
                    isPressed: true,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: AnimatedAlign(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOutCubic,
                        alignment: isDarkMode
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: NeumorphicCircle(
                          size: 42,
                          backgroundColor: baseColor,
                          child: Icon(
                            isDarkMode
                                ? Icons.nightlight_round
                                : Icons.wb_sunny_rounded,
                            size: 20,
                            color: isDarkMode
                                ? Colors.indigo.shade300
                                : Colors.orange.shade400,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}