import 'dart:io';

import 'package:app_messenger_module/models/messageModel.dart';
import 'package:app_messenger_module/services/chat/users_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ChatService{

  // Get Firebase Instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  UsersService userService = UsersService();

  // Get User Stream
  /*
  [
  {
    email: "@"
    id: 123
  },
  {
    email: "@"
    id: 123
  },
  {
    email: "@"
    id: 123
  }
  ]
   */
  Future<String?> uploadImage(String imagePath) async {
    File file = File(imagePath);
    String fileName = 'chat_images/${DateTime.now().millisecondsSinceEpoch}_${_auth.currentUser!.uid}';

    try {
      TaskSnapshot taskSnapshot = await FirebaseStorage.instance.ref(fileName).putFile(file);
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }
  sendMessage( receiverId, {message = "",photoUrl=""}) async {
    if(photoUrl!=""){
      // save into storage
    }
    Message msg = Message(message: message, senderId: _auth.currentUser!.uid, receiverId: receiverId, photoUrl: photoUrl,timeStamp:Timestamp.now()) ;
    List<String> ids = [_auth.currentUser!.uid,receiverId];
    ids.sort();
    String chatRoomKey = ids.join("_");
    await _firestore.collection("users_chat_room").doc(chatRoomKey).collection("messages").add(
      msg.toMap()
    );
    await userService.updateChatLists(receiverId);

  }
   Stream<QuerySnapshot> getUsersMessage(receiverId)  {
    List<String> ids = [_auth.currentUser!.uid,receiverId];
    ids.sort();
    String chatRoomKey = ids.join("_");
    return  _firestore.collection("users_chat_room").doc(chatRoomKey).collection("messages").orderBy("timeStamp",descending: false).snapshots();
  }

}