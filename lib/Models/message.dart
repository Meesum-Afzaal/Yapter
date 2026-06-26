import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String messageId; // Add this
  final String senderId;
  final String receiverId;
  final String text;
  final DateTime createdAt;

  Message({
    required this.messageId, // Update constructor
    required this.senderId,
    required this.receiverId,
    required this.text,
    required this.createdAt,
  });

  factory Message.fromMap(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Message(
      messageId: doc.id, // Capture the Firestore document ID here!
      senderId: data['senderId'] ?? '',
      receiverId: data['receiverId'] ?? '',
      text: data['text'] ?? '',
      createdAt: (data['created_at'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'text': text,
      'created_at': FieldValue.serverTimestamp(),
    };
  }
}