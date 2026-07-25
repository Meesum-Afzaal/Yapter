import 'package:flutter/material.dart';
import 'package:yapter/Designs/myboxdec.dart';

class NeumorphicButton extends StatefulWidget {
  final Color? backgroundColor;
  final Gradient? gradient; // Added to accept gradient background
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final Widget? child;
  final bool? isPressed;

  const NeumorphicButton({
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
  State<NeumorphicButton> createState() => _NeumorphicButtonState();
}

class _NeumorphicButtonState extends State<NeumorphicButton> {
  @override
  Widget build(BuildContext context) {
    bool isPressed = widget.isPressed ?? false;

    final offset = isPressed ? const Offset(10, 10) : const Offset(8, 8);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      transform: Matrix4.identity()..scale(isPressed ? 0.97 : 1.0),
      curve: Curves.easeInOut,
      width: widget.width,
      height: widget.height,
      decoration: MyBoxDecoration(
        color: widget.backgroundColor ?? Colors.transparent,
        gradient: widget.gradient,
        borderRadius: widget.borderRadius ?? BorderRadius.circular(15),
        boxShadow: [
          MyBoxShadow(
            offset: -offset,
            color: isPressed
                ? Colors.grey.shade400
                : Colors.white.withOpacity(0.6),
            spreadRadius: -2,
            blurRadius: isPressed ? 10 : 12,
            inset: isPressed ? true : false,
          ),
          MyBoxShadow(
            offset: offset,
            color: isPressed ? Colors.white : Colors.grey.shade400,
            spreadRadius: -2,
            blurRadius: isPressed ? 10 : 12,
            inset: isPressed ? true : false,
          ),
        ],
      ),
      child: widget.child,
    );
  }
}

