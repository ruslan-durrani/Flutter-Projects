import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../models/message.dart';

class ChatService{

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<List<Map<String,dynamic>>> getUserStream(){
    return _firestore.collection("users").snapshots().map((event){
      return event.docs.map((doc){
        final user = doc.data();
        return user;
      }).where((element) => element["uid"]!=_auth.currentUser!.uid).toList();
    });
  }

  Stream<List<Map<String, dynamic>>> getUserChatsStream() {
    String myUid = _auth.currentUser!.uid;
    return _firestore.collection('users').doc(myUid).snapshots().asyncMap((snapshot) async {
      try {
        var currentUser = snapshot.data();
        if (currentUser == null) throw Exception('Current user data is null');
        List<String> userChatsList = List<String>.from(currentUser['userChatsList']);
        List<Future<DocumentSnapshot>> futures = [];

        for (String chatUid in userChatsList) {
          futures.add(_firestore.collection('users').doc(chatUid).get());
        }
        List<DocumentSnapshot> userDocuments = await Future.wait(futures);
        List<Map<String, dynamic>> chatUsers = userDocuments.map((doc) => doc.data() as Map<String, dynamic>).toList();

        // List<Map<String, dynamic>> chatUsers = userDocuments.map((doc) => doc.data() as Map<String, dynamic>).toList();
        return chatUsers;
      } catch (e) {
        print('Error fetching user chats: $e');
        return [];
      }
    });
  }
  Future<void> markMessagesAsRead(String receiverId) async {
    _firestore.collection("chat_meta").doc(getChatRoomKey(receiverId)).set({
      receiverId: {"unreadCount": 0}
    }, SetOptions(merge: true));
    _firestore.collection("users_chat_room").doc(getChatRoomKey(receiverId)).collection("messages")
        .where("receiverId", isEqualTo: receiverId)
        .where("isRead", isEqualTo: false)
        .get().then((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        doc.reference.update({"isRead": true});
      }
    });
  }




  updateChatLists(String receiverId) async {
    try {
      // Get the current user's UID
      String currentUserUId = _auth.currentUser!.uid.toString();

      // References to the Firestore documents for both the receiver and the sender
      final DocumentReference documentReferenceReceiver = _firestore.collection("users").doc(receiverId);
      final DocumentReference documentReferenceSender = _firestore.collection("users").doc(currentUserUId);

      // Get the current data from both documents
      DocumentSnapshot documentSnapshotReceiver = await documentReferenceReceiver.get();
      DocumentSnapshot documentSnapshotSender = await documentReferenceSender.get();

      if (documentSnapshotReceiver.exists && documentSnapshotSender.exists) {
        List<dynamic> existingListDataReceiver = documentSnapshotReceiver.get('userChatsList');
        List<dynamic> existingListDataSender = documentSnapshotSender.get('userChatsList');

        // Update receiver's chat list
        // Remove currentUserUId if it exists to avoid duplication
        existingListDataReceiver.removeWhere((item) => item == currentUserUId);
        // Insert the currentUserUId at the start of the list
        existingListDataReceiver.insert(0, currentUserUId);
        await documentReferenceReceiver.update({'userChatsList': existingListDataReceiver});

        // Update sender's chat list
        // Remove receiverId if it exists to avoid duplication
        existingListDataSender.removeWhere((item) => item == receiverId);
        // Insert the receiverId at the start of the list
        existingListDataSender.insert(0, receiverId);
        await documentReferenceSender.update({'userChatsList': existingListDataSender});

        print("Chat lists updated successfully.");
      } else {
        print("One of the documents does not exist.");
      }
    } catch (error) {
      print("Error updating chat lists: $error");
    }
  }



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

  Future<void> sendMessage(String receiverId, {String message = "", String photoUrl = ""}) async {
    if (photoUrl != "") {
      // save into storage
    }
    Message msg = Message(
      message: message,
      senderId: _auth.currentUser!.uid,
      receiverId: receiverId,
      photoUrl: photoUrl,
      timeStamp: Timestamp.now(),
      isRead: false,
    );
    List<String> ids = [_auth.currentUser!.uid, receiverId];
    ids.sort();
    String chatRoomKey = ids.join("_");
    await _firestore.collection("users_chat_room").doc(chatRoomKey).collection("messages").add(msg.toMap());

    // Increment unread message count for the receiver
    _firestore.collection("chat_meta").doc(chatRoomKey).set({
      receiverId: {"unreadCount": FieldValue.increment(1)}
    }, SetOptions(merge: true));

    await updateChatLists(receiverId);
  }
  getChatRoomKey(receiverId){
    List<String> ids = [_auth.currentUser!.uid,receiverId];
    ids.sort();
    String chatRoomKey = ids.join("_");
    return chatRoomKey;
  }
  Stream<QuerySnapshot> getUsersMessage(receiverId)  {

    return  _firestore.collection("users_chat_room").doc(getChatRoomKey(receiverId)).collection("messages").orderBy("timeStamp",descending: false).snapshots();
  }

}