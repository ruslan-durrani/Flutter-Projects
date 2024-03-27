
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:lost_get/presentation_layer/widgets/toast.dart';


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


  // Add to ChatService
  Stream<List<Map<String, dynamic>>> searchUserChats(String query) {
    String searchUpperBound = query.substring(0, query.length - 1) + String.fromCharCode(query.codeUnitAt(query.length - 1) + 1);

    return _firestore
        .collection('users')
        .where('fullName', isGreaterThanOrEqualTo: query)
        .where('fullName', isLessThan: searchUpperBound)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList());
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
      _auth.currentUser!.uid: {"unreadCount": 0,}// "notified":true
    }, SetOptions(merge: true));
    _firestore.collection("users_chat_room").doc(getChatRoomKey(receiverId)).collection("messages")
        .where("receiverId", isEqualTo: _auth.currentUser!.uid)
        .where("isRead", isEqualTo: false)
        .get().then((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        // Mark each message as read
        doc.reference.update({"isRead": true});
      }
    });
  }


  // void listenForUnreadMessages() {
  //   _firestore.collection('chat_meta')
  //       .snapshots().listen((snapshot) {
  //     for (var doc in snapshot.docs) {
  //       var chatMeta = doc.data();
  //       String currentUserUid = _auth.currentUser!.uid;
  //       if (chatMeta.containsKey(currentUserUid)) {
  //         var userMeta = chatMeta[currentUserUid];
  //         if (userMeta['unreadCount'] > 0 && !userMeta['notified']) {
  //           // Trigger a local notification
  //           NotificationService().showNotification("Hey ${_auth.currentUser!.displayName!}", "You have unread messages");
  //           // Update 'notified' to true to avoid repeated notifications
  //           doc.reference.update({
  //             "$currentUserUid.notified": true,
  //           });
  //         }
  //       }
  //     }
  //   });
  // }

  // notifyUserAboutTheNewMessage(UserProfile senderObject) async {
  //   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //   DocumentSnapshot chatMetaSnapshot = await _firestore.collection("chat_meta").doc(getChatRoomKey(senderObject.uid)).get();
  //   if (chatMetaSnapshot.exists) {
  //     Map<String, dynamic> receiverMeta = chatMetaSnapshot.get(_auth.currentUser!.uid) ?? {};
  //     int unreadCount = receiverMeta["unreadCount"] ?? 0;
  //     bool notified = receiverMeta["notified"] ?? false;
  //
  //     if (unreadCount > 0 && !notified) {
  //       // Placeholder for sending notification logic
  //
  //       await NotificationService().showNotification(senderObject.fullName!, "New messages");
  //       // After sending the notification, update the notified field to true
  //       _firestore.collection("chat_meta").doc(getChatRoomKey(senderObject.uid)).set(
  //           {
  //             _auth.currentUser!.uid: {"notified": true,}
  //           }, SetOptions(merge: true));
  //     }
  //   }
  // }


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

  Future<void> sendMessage(String receiverId, {String message = "", String photoUrl = "", String? reportedItemId}) async {
    if (photoUrl != "") {
      // save into storage
    }
    Message msg = Message(
      message: photoUrl.isEmpty?message:"Image",
      senderId: _auth.currentUser!.uid,
      receiverId: receiverId,
      photoUrl: photoUrl,
      timeStamp: Timestamp.now(),
      isRead: false,
    );
    // List<String> ids = [_auth.currentUser!.uid, receiverId];
    // ids.sort();
    String chatRoomKey = getChatRoomKey(receiverId);
    // String chatRoomKey = ids.join("_");
    await _firestore.collection("users_chat_room").doc(chatRoomKey).collection("messages").add(msg.toMap());

    _firestore.collection("chat_meta").doc(chatRoomKey).set({
      receiverId: {
        "unreadCount": FieldValue.increment(1),
      },
      "lastMsg": {
        "message":photoUrl.isEmpty?message:"image",
        "sender":_auth.currentUser!.uid
      },
      "reportedItemId":reportedItemId,
    }, SetOptions(merge: true));

    await updateChatLists(receiverId);
  }

  Future<void> deleteChatWithRecepient(receiverId) async {


    String chatRoomKey = getChatRoomKey(receiverId);

    DocumentReference usersChatRoomDoc = _firestore.collection('users_chat_room').doc(chatRoomKey);
    print(usersChatRoomDoc.id);

    DocumentReference chatsMetaDoc = _firestore.collection('chat_meta').doc(chatRoomKey);

    DocumentReference myUserDoc = _firestore.collection('users').doc(_auth.currentUser!.uid); // Adjust 'your_collection_name' to your actual collection name
    DocumentReference recepientUserDoc = _firestore.collection('users').doc(receiverId); // Adjust 'your_collection_name' to your actual collection name

    // Firestore batch write to perform all operations atomically

    try {
      await usersChatRoomDoc.delete();
      await chatsMetaDoc.delete();
      WriteBatch batch = _firestore.batch();

      // Schedule the removal of uid from userChatList array
      batch.update(myUserDoc, {'userChatsList': FieldValue.arrayRemove([receiverId])});
      batch.update(recepientUserDoc, {'userChatsList': FieldValue.arrayRemove([_auth.currentUser!.uid])});

      // Commit the batch
      await batch.commit();

    } catch (e) {
      createToast(description: "Error performing operation");
    }

    // try {
    //   await usersChatRoomDoc.delete();
    //   await chatsMetaDoc.delete();
    // } catch (e) {
    //   createToast(description: "An error has occured while deleting chat ");
    // }
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