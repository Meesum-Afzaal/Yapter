import 'package:flutter/material.dart';
import 'package:yapter/Services/auth.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Auth auth=Auth();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Yapter"),
        centerTitle: true,
        actions: [
          IconButton(onPressed: (){
            auth.signOut();
          },
          icon: Icon(Icons.logout),)
        ],
        
      ),
    );
  }
}
