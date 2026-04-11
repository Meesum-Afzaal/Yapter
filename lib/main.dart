import 'package:flutter/material.dart';
import 'package:yapter/Screens/wrapper.dart';

void main() {
  runApp(const Yapter());
}

class Yapter extends StatelessWidget {
  const Yapter({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      debugShowCheckedModeBanner: false,
      home: const Wrapper(),
    );
  }
}
