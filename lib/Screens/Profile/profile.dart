import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:yapter/Designs/neumorphic_circle.dart';
import 'package:yapter/Designs/neumorphic_container.dart';
import 'package:yapter/Models/user.dart';
import 'package:yapter/Providers/firestore_service_provider.dart';

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

  void loadUser() async {
    final _user = FirebaseAuth.instance.currentUser!;
    final response = await ref.read(firestoreServiceProvider).getUser(_user.phoneNumber!);
    final doc = response.docs.first;
    final data = doc.data() as Map<String, dynamic>;

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,

      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                NeumorphicCircle(
                  backgroundColor: theme.colorScheme.surface,
                  size: 120,
                  child: Icon(Icons.person, color: Colors.grey.shade600, size: 80),
                ),
                const SizedBox(height: 20),


                loading
                    ? const CircularProgressIndicator()
                    : Column(
                  children: [
                    Text(
                      "${user!.firstName} ${user!.lastName}",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user!.phoneNumber ?? "",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),


                NeumorphicContainer(
                  backgroundColor: theme.colorScheme.surface,
                  child: ListTile(
                    leading: Icon(Icons.person_outline, color: Colors.grey.shade700),
                    title: Text(
                      "Account Settings",
                      style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey.shade700),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey.shade500),
                    onTap: () {
                      // TODO: Navigate to Account Settings
                    },
                  ),
                ),
                const SizedBox(height: 20),

                NeumorphicContainer(
                  backgroundColor: theme.colorScheme.surface,
                  child: ListTile(
                    leading: Icon(Icons.settings_outlined, color: Colors.grey.shade700),
                    title: Text(
                      "App Preferences",
                      style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey.shade700),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey.shade500),
                    onTap: () {
                      // TODO: Navigate to App Preferences
                    },
                  ),
                ),
                const SizedBox(height: 20),

                NeumorphicContainer(
                  backgroundColor: theme.colorScheme.surface,
                  child: ListTile(
                    leading: const Icon(Icons.logout, color: Colors.redAccent),
                    title: const Text(
                      "Sign Out",
                      style: TextStyle(fontWeight: FontWeight.w600, color: Colors.redAccent),
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