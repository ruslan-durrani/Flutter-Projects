import 'package:cloud_firestore/cloud_firestore.dart';

class Message{
  final String message;
  final String senderId;
  final String receiverId;
  final String photoUrl;
  final Timestamp timeStamp;

  Message({required this.message, required this.senderId, required this.receiverId, required this.photoUrl, required this.timeStamp});
  toMap(){
    return {
      "message":this.message,
      "photoUrl":this.photoUrl,
      "senderId":this.senderId,
      "receiverId":this.receiverId,
      "timeStamp":this.timeStamp,
    };
  }
}