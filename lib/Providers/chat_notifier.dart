import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yapter/Models/message.dart';
import 'package:yapter/Providers/firestore_service_provider.dart';

part 'chat_notifier.g.dart';

@riverpod
class ChatNotifer extends _$ChatNotifer {
  DocumentSnapshot? lastDoc;
  bool hasMore = true;

  @override
  List<Message> build(String chatId) {
    final stream = FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('created_at', descending: true)
        .limit(30)
        .snapshots();

    final subscription = stream.listen((snapshot) async {
      if (snapshot.docs.isNotEmpty) {
        lastDoc = snapshot.docs.last;
      }

      final newMessages = snapshot.docs
          .map((doc) => Message.fromMap(doc))
          .toList();

      final messagesById = <String, Message>{};

      for (final message in state) {
        messagesById[message.messageId] = message;
      }

      for (final message in newMessages) {
        messagesById[message.messageId] = message;
      }

      final mergedList = messagesById.values.toList();

      mergedList.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      state = mergedList;

      final currentUserId = FirebaseAuth.instance.currentUser?.uid;

      if (currentUserId != null) {
        await ref
            .read(firestoreServiceProvider)
            .markMessagesSeen(
          chatId,
          currentUserId,
        );
      }
    });

    ref.onDispose(() {
      subscription.cancel();
    });

    return [];
  }

  Future<void> loadMoreMessages(String chatId) async {
    if (!hasMore || lastDoc == null) {
      return;
    }

    final snapshot = await FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('created_at', descending: true)
        .startAfterDocument(lastDoc!)
        .limit(30)
        .get();

    if (snapshot.docs.isEmpty) {
      hasMore = false;
      return;
    }

    lastDoc = snapshot.docs.last;

    if (snapshot.docs.length < 30) {
      hasMore = false;
    }

    final newMessages = snapshot.docs
        .map((doc) => Message.fromMap(doc))
        .toList();

    final existingIds = state
        .map((message) => message.messageId)
        .toSet();

    final uniqueMessages = newMessages
        .where(
          (message) =>
      !existingIds.contains(message.messageId),
    )
        .toList();

    state = [
      ...state,
      ...uniqueMessages,
    ];
  }
}