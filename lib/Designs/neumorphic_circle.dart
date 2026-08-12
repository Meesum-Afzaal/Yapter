import 'package:flutter/material.dart';
import 'package:yapter/Theme/app_theme.dart';

class NeumorphicCircle extends StatelessWidget {
  final Color? backgroundColor;
  final double size;
  final Widget child;

  const NeumorphicCircle({
    super.key,
    this.backgroundColor,
    required this.size,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final themeBackground = AppTheme.background(context);
    final lightShadow = AppTheme.lightShadow(context);
    final darkShadow = AppTheme.darkShadow(context);

    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: backgroundColor ?? themeBackground,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            offset: const Offset(-3, -3),
            color: lightShadow,
            blurRadius: 5,
          ),
          BoxShadow(
            offset: const Offset(3, 3),
            color: darkShadow,
            blurRadius: 5,
          ),
        ],
      ),
      child: child,
    );
  }
}