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
    return _firestore.collection("users").snapshots().map((event) {
      return event.docs.map((doc) {
        final user = doc.data();
        return user;
      }).where((user) {
        // Check if userChatsList exists and is not empty
        return user["uid"]==_auth.currentUser!.uid &&user.containsKey('userChatsList') && user['userChatsList'] is List && user['userChatsList'].isNotEmpty ;
      }).toList();
    });
  }


  updateChatLists(receiverId)   {
    //  await _firestore.collection("users").doc(receiverId).update({
    //   "userChatsList": FieldValue.arrayUnion([_auth.currentUser!.uid])
    // });
    print("Fucking id: "+receiverId);
     _firestore.collection("users").doc(_auth.currentUser!.uid).update({
      "userChatsList": FieldValue.arrayUnion([receiverId.toString()])
    });
  }
}