import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yapter/Models/user.dart';
part 'userProvider.g.dart';
@riverpod
class UserNotifier extends _$UserNotifier{
  @override
  User? build()=>null;

  void setUser(User user){
    state=user;
  }
  void clearUser(){
    state=null;
  }

}