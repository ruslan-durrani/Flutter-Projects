import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

        // List<Map<String, dynamic>> chatUsers = userDocuments.map((doc) => doc.data() as Map<String, dynamic>).toList();
        return chatUsers;
      } catch (e) {
        print('Error fetching user chats: $e');
        return [];
      }
    });
  }


  updateChatLists(receiverId) async {
    try {
      // Get a reference to the Firestore document
      String currentUserUId = _auth.currentUser!.uid.toString();
      final DocumentReference documentReferenceReceiver = _firestore.collection("users").doc(receiverId.toString());
      final DocumentReference documentReferenceSender = _firestore.collection("users").doc(_auth.currentUser!.uid);

      // Get the current data from the document
      DocumentSnapshot documentSnapshotReceiver = await documentReferenceReceiver.get();
      DocumentSnapshot documentSnapshotSender = await documentReferenceSender.get();

      if (documentSnapshotReceiver.exists && documentSnapshotSender.exists) {
        List<dynamic> existingListDataReceiver = documentSnapshotReceiver.get('userChatsList');
        List<dynamic> existingListDataSender = documentSnapshotSender.get('userChatsList');
        if(!existingListDataReceiver.contains(currentUserUId)) {
          existingListDataReceiver.add(currentUserUId);//todo
          await documentReferenceReceiver.update({'userChatsList': existingListDataReceiver});
          print("Saved 1");
        }
        if(!existingListDataSender.contains(receiverId)) {
          existingListDataSender.add(receiverId.toString());
          await documentReferenceSender.update({'userChatsList': existingListDataSender});
          print("Saved 2");
        }
      } else {

      }
    } catch (error) {
      print("Errp: $error");
    }
  }
}