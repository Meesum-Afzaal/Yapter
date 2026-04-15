import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yapter/Models/user.dart';
import 'package:yapter/Services/auth.dart';
part 'userProvider.g.dart';
@riverpod
class UserNotifier extends _$UserNotifier{
  @override
  UserDetails? build()=>null;

  void setUser(UserDetails user){
    state=user;
  }
  void clearUser(){
    state=null;
  }

}
@riverpod
Stream<UserDetails?> user_auth(User_authRef ref){
  return Auth().user;

}