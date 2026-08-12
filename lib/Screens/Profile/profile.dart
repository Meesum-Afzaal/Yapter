import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:yapter/Designs/neumorphic_circle.dart';
import 'package:yapter/Designs/neumorphic_container.dart';
import 'package:yapter/Models/user.dart';
import 'package:yapter/Providers/firestore_service_provider.dart';
import 'package:yapter/Screens/Profile/app_preferences.dart';

class Profile extends ConsumerStatefulWidget {
  const Profile({super.key});

  @override
  ConsumerState<Profile> createState() => _ProfileState();
}

class _ProfileState extends ConsumerState<Profile> {
  UserDetails? user;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser!;

      final response = await ref
          .read(firestoreServiceProvider)
          .getUser(currentUser.phoneNumber!);

      if (response.docs.isEmpty) {
        if (mounted) {
          setState(() {
            loading = false;
          });
        }
        return;
      }

      final doc = response.docs.first;
      final data = doc.data() as Map<String, dynamic>;

      if (mounted) {
        setState(() {
          user = UserDetails(
            uid: doc.id,
            firstName: data['first_name'],
            lastName: data['last_name'],
            phoneNumber: data['phone_number'],
          );
          loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final backgroundColor = theme.colorScheme.surface;
    final textColor = theme.colorScheme.onSurface;
    final secondaryTextColor =
    theme.colorScheme.onSurface.withOpacity(0.6);

    return Scaffold(
      backgroundColor: backgroundColor,

      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 20.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [


                NeumorphicCircle(
                  backgroundColor: backgroundColor,
                  size: 120,
                  child: Icon(
                    Icons.person,
                    color: secondaryTextColor,
                    size: 80,
                  ),
                ),

                const SizedBox(height: 20),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: loading
                      ? NeumorphicCircle(
                    key: const ValueKey('profile-loading'),
                    backgroundColor: backgroundColor,
                    size: 50,
                    child: SpinKitDualRing(
                      color: secondaryTextColor,
                      size: 22,
                      lineWidth: 2.5,
                    ),
                  )
                      : Column(
                    key: const ValueKey('profile-loaded'),
                    children: [
                      Text(
                        "${user?.firstName ?? ''} ${user?.lastName ?? ''}",
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 5),

                      Text(
                        user?.phoneNumber ?? '',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: secondaryTextColor,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                NeumorphicContainer(
                  backgroundColor: backgroundColor,
                  child: ListTile(
                    leading: Icon(
                      Icons.person_outline,
                      color: secondaryTextColor,
                    ),
                    title: Text(
                      "Account Settings",
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: secondaryTextColor,
                    ),
                    onTap: () {
                      // TODO: Navigate to Account Settings
                    },
                  ),
                ),

                const SizedBox(height: 20),


                NeumorphicContainer(
                  backgroundColor: backgroundColor,
                  child: ListTile(
                    leading: Icon(
                      Icons.settings_outlined,
                      color: secondaryTextColor,
                    ),
                    title: Text(
                      "App Preferences",
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: secondaryTextColor,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AppPreferences(),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),


                NeumorphicContainer(
                  backgroundColor: backgroundColor,
                  child: ListTile(
                    leading: const Icon(
                      Icons.logout,
                      color: Colors.redAccent,
                    ),
                    title: theme.textTheme.titleMedium != null
                        ? Text(
                      "Sign Out",
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.redAccent,
                      ),
                    )
                        : const Text(
                      "Sign Out",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.redAccent,
                      ),
                    ),
                    onTap: () async {
                      await FirebaseAuth.instance.signOut();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}