import 'package:flutter/material.dart';
import 'package:yapter/Designs/myboxdec.dart';

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
  State<NeumorphicContainer> createState() => _NeumorphicButtonState();
}

class _NeumorphicButtonState extends State<NeumorphicContainer> {
  @override
  Widget build(BuildContext context) {
    bool isPressed = widget.isPressed ?? false;

    final offset = isPressed ? const Offset(10, 10) : const Offset(5, 5);

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
                : Colors.white.withOpacity(0.9),
            spreadRadius: -1,
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

