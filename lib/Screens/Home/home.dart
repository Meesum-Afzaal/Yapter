import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yapter/Designs/neumorphic_circle.dart';
import 'package:yapter/Designs/neumorphic_container.dart';
import 'package:yapter/Models/user.dart';
import 'package:yapter/Providers/firestore_service_provider.dart';
import 'package:yapter/Screens/ChatScreen/chat_screen.dart';
import 'package:yapter/Services/auth.dart';
import 'package:yapter/temp/tempUsers.dart';
import 'package:firebase_auth/firebase_auth.dart';
class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final Auth auth = Auth();
  List<UserDetails>? friends;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  void loadFriends()async{
    final currentUserId=FirebaseAuth.instance.currentUser!.uid;
    final response=await ref.read(firestoreServiceProvider).getFriends(currentUserId);
    setState(() {
      friends=response;
    });
  }

  @override
  Widget build(BuildContext context) {
    final users = ref.watch(userProvider);
    Color baseColor = const Color(0xFFE6EBF2);
    final onlineUsers = users.where((user) => user.isOnline).toList();

    return Scaffold(
      backgroundColor: baseColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: baseColor,
            expandedHeight: 235,
            title: Text(
              "Yapter",
              style: TextStyle(
                  color: Colors.grey.shade800, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(color: baseColor),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 70, 0, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(18, 0, 0, 0),
                            child: Text(
                              "Active now",
                              style: TextStyle(
                                  color: Colors.grey.shade800,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 120,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: onlineUsers.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding:
                                const EdgeInsets.symmetric(horizontal: 13,vertical: 10),
                                child: Column(
                                  children: [
                                    Stack(
                                      children: [

                                        NeumorphicCircle(
                                            size:65 ,
                                            backgroundColor: baseColor,
                                            child: Icon(Icons.person,color: Colors.grey.shade600,)
                                        ),
                                        Positioned(
                                          bottom: 2,
                                          right: 2,
                                          child: Container(
                                            height: 15,
                                            width: 15,
                                            decoration: BoxDecoration(
                                              color: Colors.blue,
                                              borderRadius:
                                              BorderRadius.circular(100),
                                            ),
                                            child: const Icon(
                                              Icons.check,
                                              size: 10,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      onlineUsers[index].name,
                                      style: TextStyle(
                                          color: Colors.grey.shade800,
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              );
                            }),
                      )
                    ],
                  ),
                ),
              ),
            ),
            bottom: PreferredSize(
                preferredSize: const Size.fromHeight(40),
                child: Container(
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: baseColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 10,
                        spreadRadius: -8,
                        offset: const Offset(0, -12),
                      )
                    ],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(70),
                      topRight: Radius.circular(70),
                    ),
                  ),
                  child: Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(100)),
                  ),
                )),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(25.0, 0, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Messages",
                    style: TextStyle(
                        color: Colors.grey.shade800,
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          SliverAnimatedList(
              key: _listKey,
              initialItemCount: users.length,
              itemBuilder: (context, index, animation) {
                return SizeTransition(
                  sizeFactor: animation,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(25, 18, 25, 18),
                    child: NeumorphicListItem(
                      index: index,
                      child: GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatScreen(FriendName: users[index].name)));
                        },
                        child: Center(
                          child: ListTile(
                              leading: NeumorphicCircle(
                                   size: 50,
                                  backgroundColor: baseColor,
                                  child: Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: Icon(
                                      Icons.person,
                                      color: Colors.grey.shade600,
                                    )
                                  ),
                              ),
                              title: Text(users[index].name,
                                  style: TextStyle(
                                      color: Colors.grey.shade800,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold)),
                              subtitle: Text(
                                "Hello, how are you?",
                                style: TextStyle(
                                    color: Colors.grey.shade800, fontSize: 14.0),
                              ),
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("12:00",
                                      style: TextStyle(
                                          color: Colors.grey.shade800,
                                          fontSize: 12.0)),
                                  const SizedBox(height: 5),
                                  const Icon(
                                    Icons.done_all,
                                    size: 20,
                                    color: Colors.blue,
                                  ),
                                ],
                              )),
                        ),
                      ),
                    ),
                  ),
                );
              }),
        ],
      ),
    );
  }
}

class NeumorphicListItem extends StatefulWidget {
  final int index;
  final Widget child;

  const NeumorphicListItem({super.key, required this.index, required this.child});

  @override
  State<NeumorphicListItem> createState() => _NeumorphicListItemState();
}

class _NeumorphicListItemState extends State<NeumorphicListItem> {
  bool _isPopped = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 100 * widget.index), () {
      if (mounted) {
        setState(() => _isPopped = true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return NeumorphicContainer(
      backgroundColor: const Color(0xFFE6EBF2),
      height: 70,
      width: double.infinity,
      isPressed: !_isPopped,
      child: widget.child,
    );
  }
}