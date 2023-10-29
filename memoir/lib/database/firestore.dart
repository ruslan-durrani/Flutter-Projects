/*
    This database stores posts that users have published in the app.
    It is  stored in a collection called Posts in Firebase.

    Each post has:
      - Email of user
      - Post Message Content
      - Time stamp
 */
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreDatabase{
  // Current Logged In User
  User? user = FirebaseAuth.instance.currentUser;
  // Get Collection of Posts from firebase
  CollectionReference memoirs = FirebaseFirestore.instance.collection("Memoirs");
  // Post a message
  Future<void> postMemoir(String message){
    return memoirs.add({
      "UserEmail":user!.email,
      "MemoirMessage":message,
      "Timestamp":Timestamp.now()
    });
  }
  Stream<QuerySnapshot> getMemoirs(){
    final memoirs = FirebaseFirestore.instance
        .collection("Memoirs")
        .orderBy("Timestamp",descending: true)
        .snapshots();
    return memoirs;
  }
  // Read posts from database
}