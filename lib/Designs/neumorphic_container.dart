import 'package:flutter/material.dart';
import 'package:yapter/Designs/myboxdec.dart';
import 'package:yapter/Theme/app_theme.dart';

class NeumorphicContainer extends StatefulWidget {
  final Color? backgroundColor;
  final Gradient? gradient;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final Widget? child;
  final bool? isPressed;

  const NeumorphicContainer({
    super.key,
    this.backgroundColor,
    this.gradient,
    this.width,
    this.height,
    this.borderRadius,
    required this.child,
    this.isPressed,
  });

  @override
  State<NeumorphicContainer> createState() => _NeumorphicContainerState();
}

class _NeumorphicContainerState extends State<NeumorphicContainer> {
  @override
  Widget build(BuildContext context) {
    final bool isPressed = widget.isPressed ?? false;
    final offset = isPressed ? const Offset(10, 10) : const Offset(5, 5);

    final themeBackground = AppTheme.background(context);

    final lightShadow = AppTheme.lightShadow(context);

    final darkShadow = AppTheme.darkShadow(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      transform: Matrix4.identity()..scale(isPressed ? 0.97 : 1.0),
      curve: Curves.easeInOut,
      width: widget.width,
      height: widget.height,
      decoration: MyBoxDecoration(
        color: widget.backgroundColor ?? themeBackground,
        gradient: widget.gradient,
        borderRadius: widget.borderRadius ?? BorderRadius.circular(15),
        boxShadow: [
          MyBoxShadow(
            offset: -offset,
            color: isPressed ? darkShadow : lightShadow.withOpacity(0.9),
            spreadRadius: -1,
            blurRadius: isPressed ? 10 : 12,
            inset: isPressed,
          ),

          MyBoxShadow(
            offset: offset,
            color: isPressed ? lightShadow : darkShadow,
            spreadRadius: -2,
            blurRadius: isPressed ? 10 : 12,
            inset: isPressed,
          ),
        ],
      ),

      child: widget.child,
    );
  }
}
