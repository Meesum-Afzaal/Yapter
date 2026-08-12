import 'package:firebase_database/firebase_database.dart';
class TypingService{
  final DatabaseReference _database=FirebaseDatabase.instance.ref();

  Stream<DatabaseEvent> getTypingStatus(String chatid,String friendUid){
    return _database.child('typing/$chatid/$friendUid').onValue;
  }
  Future<void> settyping(String chatId,String currentUserUid,bool value)async{
    await _database.child('typing/$chatId/$currentUserUid').set(value);
    
    
  }
}