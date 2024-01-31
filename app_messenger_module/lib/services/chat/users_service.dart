import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UsersService{
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

        // print("Chat screen content home page"+chatUsers.toString());

        return chatUsers;
      } catch (e) {
        print('Error fetching user chats: $e');
        return [];
      }
    });
  }


  // Stream<List<Map<String, dynamic>>> getUserChatsStream() {
  //   String myUid = _auth.currentUser!.uid;
  //   return _firestore.collection('users').doc(myUid).snapshots().asyncMap((snapshot) async {
  //     var currentUser = snapshot.data() as Map<String, dynamic>;
  //
  //     List<Map<String, dynamic>> chatUsers = [];
  //     for (String chatUid in List<String>.from(currentUser['userChatsList'])) {
  //       print(chatUid);
  //       DocumentSnapshot userDocument = await _firestore.collection('users').doc(chatUid).get();
  //       chatUsers.add(userDocument.data() as Map<String, dynamic>);
  //     }
  //     print("Chat screen content home page"+chatUsers.toString());
  //     return chatUsers;
  //   });
  // }

  // Stream<List<Map<String, dynamic>>> getUserChatsStream() {
  //   return _firestore.collection("users").snapshots().map((event) {
  //     return event.docs.map((doc) {
  //       final user = doc.data();
  //       return user;
  //     }).where((user) {
  //       // Check if userChatsList exists and is not empty
  //       return user["uid"]==_auth.currentUser!.uid && user.containsKey('userChatsList') && user['userChatsList'] is List && user['userChatsList'].isNotEmpty ;
  //     }).toList();
  //   });
  // }
  //
  updateChatLists(receiverId) async {
    try {
      // Get a reference to the Firestore document
      String currentUserUId = _auth.currentUser!.uid.toString();
      print(receiverId);
      final DocumentReference documentReferenceReceiver = _firestore.collection("users").doc(receiverId.toString());
      final DocumentReference documentReferenceSender = _firestore.collection("users").doc(_auth.currentUser!.uid);

      // Get the current data from the document
      DocumentSnapshot documentSnapshotReceiver = await documentReferenceReceiver.get();
      DocumentSnapshot documentSnapshotSender = await documentReferenceSender.get();

      if (documentSnapshotReceiver.exists && documentSnapshotSender.exists) {
        // Get the existing list data from the document
        print("Available both");

        List<dynamic> existingListDataReceiver = documentSnapshotReceiver.get('userChatsList');
        List<dynamic> existingListDataSender = documentSnapshotSender.get('userChatsList');
        // print("My List: "+existingListDataSender.toList().toString());
        // print("Receiver List: "+existingListDataReceiver.toList().toString());
        // Add the new entity to the list
        if(!existingListDataReceiver.contains(currentUserUId)) {
          existingListDataReceiver.add(currentUserUId);//todo
          await documentReferenceReceiver.update({'userChatsList': existingListDataReceiver}).then((value) {
            print('My data in Receiver .');
          });

        }
        if(!existingListDataSender.contains(receiverId)) {
          existingListDataSender.add(receiverId.toString());
          await documentReferenceSender.update({'userChatsList': existingListDataSender}).then((value) {
            print('Receiver data in my list .');
          });

        }

        print('Document updated successfully.');
      } else {
        print('Document does not exist.');
      }
    } catch (error) {
      print('Error updating document: $error');
    }
  }
}