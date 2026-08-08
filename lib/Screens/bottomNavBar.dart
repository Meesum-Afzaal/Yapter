import 'package:flutter/material.dart';
import 'package:yapter/Designs/neumorphic_container.dart';
import 'package:yapter/Screens/Home/home.dart';
import 'package:yapter/Screens/Profile/profile.dart';
import 'package:yapter/Screens/AddFriend/add_friend.dart';
class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  Color baseColor = Color(0xFFE6EBF2);
  int index=0;
  List<Widget> screens=[
    Home(),
    AddFriend(),
    Profile()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: baseColor,
      body: screens[index],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: (){
                setState(() {
                  index=0;
                });
              },
            child:NeumorphicContainer(
              height: 60,
            width: 60,
                backgroundColor:baseColor ,
                isPressed: index==0,
                child:Icon(Icons.message_outlined,color: Colors.grey.shade800,)
            ),
            ),
            GestureDetector(
              onTap: (){
                setState(() {
                  index=1;
                });
              },
              child: NeumorphicContainer(
                  height: 60,
                  width: 60,
                  isPressed: index==1,
                  backgroundColor:baseColor ,
                  child:Icon(Icons.person_add_alt,color: Colors.grey.shade800,)),
            ),
            GestureDetector(
              onTap: (){
                setState(() {
                  index=2;
                });
              },
              child: NeumorphicContainer(
                  height: 60,
                  width: 60,
                  isPressed: index==2,
                  backgroundColor:baseColor ,
                  child:Icon(Icons.person_2_outlined,color: Colors.grey.shade800,)),
            ),

          ],
        ),
      ),

    );
  }
}
