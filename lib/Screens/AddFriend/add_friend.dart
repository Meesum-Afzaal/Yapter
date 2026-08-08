import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yapter/Designs/neumorphic_circle.dart';
import 'package:yapter/Designs/neumorphic_container.dart';
import 'package:yapter/Models/user.dart';
import 'package:yapter/Providers/firestore_service_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:yapter/Screens/AddFriend/friend_requests.dart';

class AddFriend extends ConsumerStatefulWidget {
  const AddFriend({super.key});

  @override
  ConsumerState<AddFriend> createState() => _AddFriendState();
}

class _AddFriendState extends ConsumerState<AddFriend> {
  UserDetails? _userDetails;
  String? number;
  bool loading = false;
  DateTime? joined_at;
  bool searchActive=false;
  final currentUserId= FirebaseAuth.instance.currentUser!.uid;
  List<UserDetails>? requests;
  bool requestLoad=true;
  @override
  void initState() {
    super.initState();
    loadFriendRequests();
  }

  void loadFriendRequests() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final _requests = await ref.read(firestoreServiceProvider).getFriendRequests(userId);

      setState(() {
        requests = _requests;
        requestLoad = false;
      });

  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final service = ref.watch(firestoreServiceProvider);
    return Scaffold(
      appBar: AppBar(
          title: Text("Add Friend"),
        actions: [
              Padding(
                padding: EdgeInsetsGeometry.fromLTRB(0, 0, 5, 0),
                child:requestLoad ?SizedBox(height:20,width: 20,child: CircularProgressIndicator(color: Colors.blue)): Stack(
                  children: [
                    IconButton(
                        onPressed: (){
                          Navigator.push(context,MaterialPageRoute(builder: (context)=>FriendRequests(requests: requests!,)));
                        },
                        icon:Icon(Icons.group_add_outlined)

                              ),
                    Positioned(
                      top: 2,
                      right: 2,
                      child: Container(
                        height: 18,
                        width: 28,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blue
                        ),
                        child: Center(
                          child: requests!.isEmpty ? Text("0",style: TextStyle(color: Colors.white,fontSize: 10),):Text("${requests!.length}",style: TextStyle(color: Colors.white,fontSize: 10),),
                        ),
                      ),
                    )
                  ],
                ),
              )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: NeumorphicContainer(
                    backgroundColor: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(40),
                    child: Center(
                      child: TextFormField(
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(14, 0, 0, 0),
                          hintText: "Enter Phone number eg +923211234567",
                          hintStyle: theme.textTheme.bodyMedium,
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {
                          number = value;
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                NeumorphicContainer(
                  backgroundColor: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(30),
                  child: IconButton(
                    onPressed: () async {

                        setState(() {
                          searchActive = true;
                          loading = true;
                        });

                        if (number == null || number!.isEmpty) {
                          setState(() => loading = false);
                          return;
                        }

                        final response = await service.getUser(number!);

                        if (response.docs.isEmpty) {
                          setState(() {
                            _userDetails = null;
                            loading = false;
                          });
                          return;
                        }

                        final doc = response.docs.first;
                        final data = doc.data() as Map<String, dynamic>;

                        setState(() {
                          _userDetails = UserDetails(
                            uid: doc.id,
                            firstName: data['first_name'],
                            lastName: data['last_name'],
                            phoneNumber: data['phone_number'],
                          );

                          joined_at = (data['created_at'] as Timestamp)
                              .toDate();
                          loading = false;
                        });
                    },
                    icon: Icon(Icons.search,color: Colors.blue,),
                  ),
                ),
              ],
            ),
            SizedBox(height: 40),
            Expanded(
              child: Column(
                mainAxisAlignment: searchActive ? MainAxisAlignment.start:MainAxisAlignment.center,
                children: [
                  searchActive ?
                  AnimatedSize(
                    duration: Duration(milliseconds: 250),
                    child: NeumorphicContainer(
                      backgroundColor: theme.colorScheme.surface,
                      isPressed:loading,
                      child: loading
                          ? Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: CircularProgressIndicator(),
                            )
                          : Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: _userDetails==null? Text("User does not exist!"):Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                 Row(
                                   children: [
                                     NeumorphicCircle(
                                         size: 55.0,
                                         backgroundColor: theme.colorScheme.surface,
                                         child: Icon(Icons.person,color: Colors.grey.shade600,)
                                     ),
                                     SizedBox(width: 15.0,),
                                     Column(
                                       crossAxisAlignment: CrossAxisAlignment.start,
                                       children: [
                                         Text(
                                           "${_userDetails!.firstName} ${_userDetails!.lastName}",
                                           style: theme.textTheme.bodyLarge,
                                         ),
                                         Text(
                                           "${_userDetails!.phoneNumber}",
                                           style: theme.textTheme.bodySmall,
                                         )
                                       ],
                                     )
                                   ],

                                 ),
                                  Padding(
                                    padding: EdgeInsetsGeometry.fromLTRB(0, 0, 6.0, 0),
                                    child: NeumorphicContainer(
                                      backgroundColor: theme.colorScheme.surface,
                                      child: Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: IconButton(
                                          onPressed: () {
                                           if(currentUserId==_userDetails!.uid){
                                             ScaffoldMessenger.of(context).showSnackBar(
                                               SnackBar(
                                                 backgroundColor: Colors.transparent,
                                                   elevation: 0,
                                                   content:Container(

                                                     padding: EdgeInsets.all(16.0),
                                                       decoration: BoxDecoration(
                                                         color: Colors.black87,
                                                         borderRadius: BorderRadius.circular(50)
                                                       ),
                                                       child: Text("You cannot send request to yourself!",style: TextStyle(color: Colors.white,fontSize: 14.0),),


                                                   )
                                               ),
                                             );
                                             return;
                                           }
                                           service.addFriend(currentUserId,_userDetails!.uid);
                                          },
                                          icon: Icon(
                                            size: 30,
                                            Icons.person_add_alt_1_outlined,
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ),
                  ):
                      Column(
                        children: [
                          Icon(Icons.search,color: Colors.blue,size: 60,),
                          Text("Search for Friends",style: theme.textTheme.bodyMedium,)
                        ],
                      )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
