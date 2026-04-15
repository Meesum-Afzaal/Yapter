import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yapter/Providers/userProvider.dart';
import 'package:yapter/Screens/Authenticate/register.dart';
import 'package:yapter/Screens/Home/home.dart';
class Wrapper extends ConsumerWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final user=ref.watch(user_authProvider);
    return user.when(data: (user){
      if(user==null){
        return Register();
      }
      else{
        return Home();
      }
    }, error: (e,_)=>Text(e.toString()),
        loading: ()=>Center(child: CircularProgressIndicator()));
  }
}
