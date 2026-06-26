import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yapter/Models/message.dart';
part 'chat_notifier.g.dart';
@riverpod
class ChatNotifer extends _$ChatNotifer{
  DocumentSnapshot? lastDoc;
  bool hasMore=true;
  @override
  List<Message> build(String chatId){
    final stream=FirebaseFirestore.instance.collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('created_at', descending: true)
        .limit(30)
        .snapshots();
        final subscription=stream.listen((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        lastDoc = snapshot.docs.last;
        hasMore = true;
      }
      else {
        hasMore = false;
      }
      state = snapshot.docs.map((e) => Message.fromMap(e)).toList();
    });
        ref.onDispose(() => subscription.cancel());
        return [];



  }
    void loadMoreMessages(String chatId)async{
      if(!hasMore){
        return;
      }
      final snapshot=await FirebaseFirestore.instance.collection('chats')
          .doc(chatId)
          .collection('messages')
          .orderBy('created_at', descending: true)
          .startAfterDocument(lastDoc!)
          .limit(30)
          .get();
      if(snapshot.docs.isNotEmpty){
        lastDoc=snapshot.docs.last;
        hasMore=true;
      }
      else{
        hasMore=false;
      }
      final List<Message> currentMessages=state;
      final List<Message> newMessages = snapshot.docs.map((e) => Message.fromMap(e)).toList();
      final existingIds = currentMessages.map((m) => m.messageId).toSet();
      final uniqueMessages = newMessages
          .where((m) => !existingIds.contains(m.messageId))
          .toList();

      state = [...currentMessages, ...uniqueMessages];

  }
}