import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yapter/Designs/flutterNeumorphic_button.dart';
import 'package:yapter/Services/auth.dart';
import 'package:yapter/temp/tempUsers.dart';


class Home extends ConsumerStatefulWidget{
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final Auth auth=Auth();
  @override
  Widget build(BuildContext context) {
    final users = ref.watch(userProvider);
    Color baseColor = Color(0xFFE6EBF2);
    final onlineUsers=users.where((user) => user.isOnline).toList();
    return Scaffold(
      backgroundColor: baseColor,

      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: baseColor,

            expandedHeight: 235,
            actions: [
              IconButton(onPressed: (){
                auth.signOut();
              }, icon: Icon(Icons.logout,color: Colors.grey.shade800,))
            ],
         

            title: Text("Yapter",style: TextStyle(color: Colors.grey.shade800 ,fontWeight: FontWeight.bold),),
            centerTitle: true,
            flexibleSpace: FlexibleSpaceBar(
              background:     Container(
                decoration: BoxDecoration(
                  color:baseColor
                  
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 70, 0, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(18,0, 0, 0),
                            child: Text("Active now",style: TextStyle(color: Colors.grey.shade800,fontSize: 18,fontWeight: FontWeight.bold),),
                          ),
                        ],
                      ),
                      SizedBox(height: 10,),
                      SizedBox(
                        height: 110,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: onlineUsers.length,
                            itemBuilder: (context,index){
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Column(
                              children: [
                                Stack(
                                  children: [
                                    CircleAvatar(
                                      radius: 38,
                                      backgroundImage: NetworkImage(onlineUsers[index].image),

                                    ),
                                    Positioned(
                                      bottom: 2,
                                      right: 2,
                                      child: Container(
                                        height: 15,
                                        width: 15,
                                        decoration: BoxDecoration(
                                          color: Colors.green ,
                                          borderRadius: BorderRadius.circular(100),
                                        ),
                                        child: Icon(Icons.check,size: 10,color: Colors.white,),

                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5,),
                                Text(onlineUsers[index].name,style: TextStyle(color: Colors.grey.shade800,fontSize: 11,fontWeight: FontWeight.bold),)
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
            bottom: PreferredSize(preferredSize: Size.fromHeight(40),
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
                        offset: Offset(0, -12),

                      )
                    ],
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(70),
                      topRight: Radius.circular(70),

                    ),


                  ),
                  child: Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(100)
                    ),
                  ),

                )),

          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(25.0, 0, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Messages",style: TextStyle(color: Colors.grey.shade800,fontSize: 22.0,fontWeight: FontWeight.bold),),
                ],
              ),
            ),
          ),

          SliverAnimatedList(
              key: _listKey,
                initialItemCount: users.length,
                itemBuilder: (context,index,animation){
                return SizeTransition(
                  sizeFactor: animation,
                      child: Padding(
                            padding: const EdgeInsets.fromLTRB(25, 18, 25, 18),
                            child: NeumorphicButton(
                              backgroundColor: baseColor,
                              height: 70,
                              width: double.infinity,
                              isPressed: false,


                              child: Center(
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(users[index].image),
                                  ),
                                  title: Text(users[index].name,style: TextStyle(color: Colors.grey.shade800,fontSize: 16.0,fontWeight: FontWeight.bold)),
                                  subtitle: Text("Hello, how are you?",style: TextStyle(color: Colors.grey.shade800,fontSize: 14.0),),
                                  trailing: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("12:00",style: TextStyle(color: Colors.grey.shade800,fontSize: 12.0)),
                                      SizedBox(height: 5,),
                                      Icon(Icons.done_all,size: 20,color: Colors.blue,)
                                    ],
                                  )



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
