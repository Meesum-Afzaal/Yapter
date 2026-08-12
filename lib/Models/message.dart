import 'package:cloud_firestore/cloud_firestore.dart';
class Message {
  final String messageId;
  final String senderId;
  final String receiverId;
  final String text;
  final DateTime createdAt;
  final bool seen;

  Message({
    required this.messageId,
    required this.senderId,
    required this.receiverId,
    required this.text,
    required this.createdAt,
    required this.seen,
  });

  factory Message.fromMap(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Message(
      messageId: doc.id,
      senderId: data['sender_id'] ?? '',
      receiverId: data['receiver_id'] ?? '',
      text: data['message'] ?? '',
      createdAt: (data['created_at'] as Timestamp).toDate(),
      seen: data['seen'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sender_id': senderId,
      'receiver_id': receiverId,
      'message': text,
      'created_at': FieldValue.serverTimestamp(),
      'seen': false,
    };
  }
}