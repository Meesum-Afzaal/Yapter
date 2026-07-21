import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yapter/Designs/flutterNeumorphic_button.dart';
import 'package:yapter/Providers/firestore_service_provider.dart';

class AddFriend extends ConsumerStatefulWidget {
  const AddFriend({super.key});

  @override
  ConsumerState<AddFriend> createState() => _AddFriendState();
}

class _AddFriendState extends ConsumerState<AddFriend> {
  String name='';
  String? number;
  String Id='';
  bool loading =false;

  @override
  Widget build(BuildContext context) {
    final theme=Theme.of(context);
    final service=ref.watch(firestoreServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text("Add Friend"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(

         children: [
          Row(
            children: [
              Expanded(
                child: NeumorphicButton(
                    backgroundColor: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(40),
                    child:
                    Center(
                      child:  TextFormField(
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(14, 0, 0, 0),
                            hintText: "Enter Phone number eg +923211234567",
                            hintStyle: theme.textTheme.bodyMedium,
                            border: InputBorder.none
                        ),
                        onChanged: (value){
                          number=value;
                        },
                      ),
                    )
                ),
              ),
              SizedBox(width: 10,),
              NeumorphicButton(
                backgroundColor: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(30),
                  child: IconButton(onPressed: ()async{
                    setState(() {
                      loading=true;
                    });
                    print(number);
                    if(number!=null){
                      final response=await service.getUser(number!);
                      if(response!=null){
                        final doc=response.docs.first;
                        final data=doc.data() as Map<String,dynamic>;
                        setState(() {
                          Id=doc.id;
                          name=data["first_name"]??'';

                        });
                      }
                      setState(() {
                        loading=false;
                      });
                    }

                  }, icon: Icon(Icons.search)
                  )
              )
            ],
          ),
           Expanded(
             child: Column(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 Id.isNotEmpty ? Column(

                   children: [
                     Text(Id),
                     Text(name),
                   ],
                 ):Text("Search for friends"),
                 loading ? CircularProgressIndicator():Text("found")



               ],
             ),
           )
         ],


        ),
      ),
    );
  }
}

