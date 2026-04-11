import 'package:flutter/material.dart';
import 'package:yapter/Designs/myboxdec.dart';

class NeumorphicButton extends StatefulWidget {
  final Color backgroundColor;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final Widget? child;
  final bool? isPressed;




  const NeumorphicButton({
    super.key,
    required this.backgroundColor,
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

    final offset = isPressed ? const Offset(5, 5):const Offset(10,10) ;

    return  AnimatedContainer(
        duration: Duration(milliseconds: 200),
        transform: Matrix4.identity()..scale(isPressed ? 0.97 : 1.0),
        curve: Curves.easeInOut,
        width: widget.width ?? 200,
        height: widget.height ?? 200,
        decoration: MyBoxDecoration(
          color: widget.backgroundColor,
          borderRadius: widget.borderRadius ?? BorderRadius.circular(15),
          boxShadow: [
            MyBoxShadow(
              offset: -offset,
              color: isPressed ?   Colors.grey.shade400:Colors.white,
              blurRadius: isPressed ? 8:20,
              inset: isPressed ? true : false,
            ),
            MyBoxShadow(
              offset:offset,
              color: isPressed ? Colors.white :Colors.grey.shade400,
              blurRadius: isPressed ?  8:20 ,
              inset: isPressed ? true : false,
            ),
          ],
        ),
        child: widget.child,

    );

  }
}