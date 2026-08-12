import 'package:flutter/material.dart';
import 'package:yapter/Designs/neumorphic_container.dart';
import 'package:yapter/Screens/Home/home.dart';
import 'package:yapter/Screens/Profile/profile.dart';
import 'package:yapter/Screens/AddFriend/add_friend.dart';
import 'package:yapter/Theme/app_theme.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int index = 0;

  final List<Widget> screens = [
    const Home(),
    const AddFriend(),
    const Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    // Gets the background from the currently active AppTheme.
    final baseColor = AppTheme.background(context);

    // Gets the appropriate text/icon color from the current theme.
    final iconColor = Theme.of(context).colorScheme.onSurface;

    return Scaffold(
      backgroundColor: baseColor,

      body: screens[index],

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  index = 0;
                });
              },
              child: NeumorphicContainer(
                height: 60,
                width: 60,
                backgroundColor: baseColor,
                isPressed: index == 0,
                child: Icon(
                  Icons.message_outlined,
                  color: iconColor,
                ),
              ),
            ),

            GestureDetector(
              onTap: () {
                setState(() {
                  index = 1;
                });
              },
              child: NeumorphicContainer(
                height: 60,
                width: 60,
                backgroundColor: baseColor,
                isPressed: index == 1,
                child: Icon(
                  Icons.person_add_alt,
                  color: iconColor,
                ),
              ),
            ),

            GestureDetector(
              onTap: () {
                setState(() {
                  index = 2;
                });
              },
              child: NeumorphicContainer(
                height: 60,
                width: 60,
                backgroundColor: baseColor,
                isPressed: index == 2,
                child: Icon(
                  Icons.person_2_outlined,
                  color: iconColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}