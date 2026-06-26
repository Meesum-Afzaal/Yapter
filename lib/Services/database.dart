import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class FirestoreService {
  final CollectionReference usersCollections=FirebaseFirestore.instance.collection('users');
  final CollectionReference chatCollections=FirebaseFirestore.instance.collection('chats');


  Future<void> addUser(String uid,String firstName,String lastName,String phoneNumber)async{
    usersCollections.doc(uid).set(
      {
        'first_name':firstName,
        'last_name':lastName,
        'phone_number':phoneNumber,
        'is_online':true,
        'created_at':DateTime.now(),
      }
    );
  }
  Future<void> createChat(String userId1,String userId2)async{
    List<String> userIds = [userId1, userId2];
    userIds.sort();
    final chatId = userIds.join('_');
    chatCollections.doc(chatId).set(
      {
        'users':[userId1,userId2],
        'created_at':DateTime.now(),
      }
    );

  }
  Future<void> addFriend(String currentUserId, String friendId) async {
    await usersCollections.doc(currentUserId).collection("friends").doc(friendId).set({
      "uid": friendId,
      "status": "pending",
      "created_at": DateTime.now(),
    });
    await usersCollections.doc(friendId).collection("friends").doc(currentUserId).set({
      "uid": currentUserId,
      "status": "received",
      "created_at": DateTime.now(),
    });
  }
  Future<void> acceptFriendRequest(String currentUserId, String friendId) async {
    await usersCollections.doc(currentUserId).collection("friends").doc(friendId).update({
      "status": "accepted",
    });
    await usersCollections.doc(friendId).collection("friends").doc(currentUserId).update({
      "status": "accepted",
    });
    createChat(currentUserId, friendId);
  }
  Future<void> rejectFriendRequest(String currentUserId, String friendId) async {
    await usersCollections.doc(currentUserId).collection("friends").doc(friendId).delete();
    await usersCollections.doc(friendId).collection("friends").doc(currentUserId).delete();
  }

  Future<QuerySnapshot> getFriendRequests(String userId) async {
    final friendRequests = await usersCollections.doc(userId).collection("friends").where("status", isEqualTo: "pending").get();

    return friendRequests;


  }
  Future<QuerySnapshot> getFriends(String userId) async {
    final friends = await usersCollections.doc(userId).collection("friends").where("status", isEqualTo: "accepted").get();
    return friends;
  }
  Future<void> sendMessage(String senderId, String receiverId, String message) async {
    List<String> userIds = [senderId, receiverId];
    userIds.sort();
    final chatId = userIds.join('_');
    await chatCollections.doc(chatId).collection("messages").add(
      {
        "sender_id": senderId,
        "receiver_id": receiverId,
        "message": message,
        "created_at": DateTime.now(),
      }
    );

  }


}