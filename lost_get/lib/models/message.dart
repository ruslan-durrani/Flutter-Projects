import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String message;
  final String senderId;
  final String receiverId;
  final String photoUrl;
  final Timestamp timeStamp;
  final bool isRead; // Add isRead field to track read status
  

  Message({
    required this.message,
    required this.senderId,
    required this.receiverId,
    required this.photoUrl,
    required this.timeStamp,
    this.isRead = false, // Default isRead to false
  });

  toMap() {
    return {
      "message": this.message,
      "photoUrl": this.photoUrl,
      "senderId": this.senderId,
      "receiverId": this.receiverId,
      "timeStamp": this.timeStamp,
      "isRead": this.isRead, // Include isRead in the map
    };
  }

  // Adding a factory constructor to create a Message object from a Firestore document
  factory Message.fromFirestore(DocumentSnapshot doc) {
    return Message(
      message: doc['message'],
      senderId: doc['senderId'],
      receiverId: doc['receiverId'],
      photoUrl: doc['photoUrl'],
      timeStamp: doc['timeStamp'],
      isRead: doc['isRead'], // Parse isRead from Firestore document
    );
  }
}
