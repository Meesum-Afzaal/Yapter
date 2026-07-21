import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yapter/Screens/wrapper.dart';
import 'package:yapter/Theme/app_theme.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ProviderScope(child: const Yapter()));
}

class Yapter extends StatelessWidget {
  const Yapter({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightTheme,

      debugShowCheckedModeBanner: false,
      home: const Wrapper(),
    );
  }
}
