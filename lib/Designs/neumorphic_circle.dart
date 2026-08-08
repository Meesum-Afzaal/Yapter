import 'package:flutter/material.dart';

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
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.transparent,
        shape: BoxShape.circle,
        boxShadow: [
          const BoxShadow(
            offset: Offset(-3, -3),
            color: Colors.white,
            blurRadius: 5.0,
          ),
          BoxShadow(
            offset: const Offset(3, 3),
            color: Colors.grey.shade400,
            blurRadius: 5.0,
          ),
        ],
      ),
      child: child,
    );
  }
}