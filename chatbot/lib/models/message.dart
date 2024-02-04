import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String id;
  final String text;
  final DateTime createdAt;
  final String senderId; // Optional: add more sender details as needed

  Message({
    required this.id,
    required this.text,
    required this.createdAt,
    required this.senderId,
  });

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'createdAt': createdAt,
      'senderId': senderId,
    };
  }

  static Message fromMap(Map<String, dynamic> map, String id) {
    return Message(
      id: id,
      text: map['text'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      senderId: map['senderId'],
    );
  }
}
