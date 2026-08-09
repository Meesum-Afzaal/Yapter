import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yapter/Designs/neumorphic_container.dart';
import 'package:yapter/Designs/neumorphic_circle.dart';
import 'package:yapter/Models/user.dart';
import 'package:yapter/Providers/firestore_service_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FriendRequests extends ConsumerStatefulWidget {
  List<UserDetails> requests;
   FriendRequests({
    super.key,
    required this.requests
  });

  @override
  ConsumerState<FriendRequests> createState() => _FriendRequestsState();
}

class _FriendRequestsState extends ConsumerState<FriendRequests> {


  final List<UserDetails> tempList = [
    UserDetails(uid: '1', firstName: 'Ahsan', lastName: 'Ali', phoneNumber: '+92 300 1234567'),
    UserDetails(uid: '2', firstName: 'Fatima', lastName: 'Noor', phoneNumber: '+92 333 7654321'),
    UserDetails(uid: '3', firstName: 'Zain', lastName: 'Tariq', phoneNumber: '+92 311 9876543'),
  ];


  @override
  Widget build(BuildContext context) {
    final baseColor = const Color(0xFFE6EBF2);
    final currentUserId=FirebaseAuth.instance.currentUser!.uid;


    return Scaffold(
      backgroundColor: baseColor,
      appBar: AppBar(
        backgroundColor: baseColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Requests",
          style: TextStyle(
            color: Colors.grey.shade800,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.grey.shade800),
      ),
      body: widget.requests.isEmpty ?Center(child: Text("No friend Requests"),)
          :
      ListView.builder(
        itemCount: widget.requests.length,
        padding: const EdgeInsets.symmetric(vertical: 20),
        itemBuilder: (context, index) {
          final user = widget.requests[index];

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: NeumorphicContainer(
              backgroundColor: baseColor,
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    NeumorphicCircle(
                      size: 50,
                      backgroundColor: baseColor,
                      child: Icon(Icons.person, color: Colors.grey.shade600),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${user.firstName} ${user.lastName}",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user.phoneNumber ?? "No number",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: ()async{
                            await ref.read(firestoreServiceProvider).rejectFriendRequest(currentUserId, user.uid!);
                            setState(() {
                              widget.requests.removeAt(index);
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.transparent,
                                elevation: 0,
                                content: Container(
                                  padding: const EdgeInsets.all(16.0),
                                  decoration: BoxDecoration(
                                    color: Colors.red.shade700,
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: const Text(
                                    "Friend request rejected",
                                    style: TextStyle(color: Colors.white, fontSize: 14.0),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            );
                          },
                          child: NeumorphicContainer(
                            backgroundColor: baseColor,
                            borderRadius: BorderRadius.circular(12),
                            height: 40,
                            width: 40,
                            child: Icon(Icons.close, color: Colors.red.shade400, size: 20),
                          ),
                        ),
                        const SizedBox(width: 16),
                        GestureDetector(
                          onTap: ()async{
                            print(currentUserId);
                            print(user.firstName!);
                            await ref.read(firestoreServiceProvider).acceptFriendRequest(currentUserId, user.uid!);
                            setState(() {
                              widget.requests.removeAt(index);
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.transparent,
                                elevation: 0,
                                content: Container(
                                  padding: const EdgeInsets.all(16.0),
                                  decoration: BoxDecoration(
                                    color: Colors.green.shade700,
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: const Text(
                                    "Friend request accepted!",
                                    style: TextStyle(color: Colors.white, fontSize: 14.0),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            );


                          },
                          child: NeumorphicContainer(
                            backgroundColor: baseColor,
                            borderRadius: BorderRadius.circular(12),
                            height: 40,
                            width: 40,
                            child: Icon(Icons.check, color: Colors.green.shade400, size: 20),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}