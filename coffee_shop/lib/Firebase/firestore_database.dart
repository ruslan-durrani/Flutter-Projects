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
  CollectionReference coffees = FirebaseFirestore.instance.collection("Coffees");
  // Post a message
  Future<void> addCoffeeToMarket(String coffeeName,List<String> ingredients,int quantity){
    return coffees.add({
      "coffeeOwner":user!.email,
      "coffeeName":coffeeName,
      "coffeeIngredients":[],
      "coffeeQuantity":quantity,
      "coffeeImages":[],
      "coffeeTimestamp":Timestamp.now(),
      "coffeeLikes":[],
    });
  }
  Stream<QuerySnapshot> getCoffees(){
    final coffees = FirebaseFirestore.instance
        .collection("Coffees")
        .orderBy("Timestamp",descending: true)
        .snapshots();
    return coffees;
  }
// Read posts from database
}