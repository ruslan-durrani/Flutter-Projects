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
import 'package:flutter/cupertino.dart';

class FirestoreDatabase{
  // Current Logged In User
  User? user = FirebaseAuth.instance.currentUser;
  // Get Collection of Posts from firebase
  CollectionReference coffees = FirebaseFirestore.instance.collection("Coffees");

  CollectionReference categories = FirebaseFirestore.instance.collection("Coffee_Categories");
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
  Future<List<Map<String, dynamic>>> getCoffeeCategories() async {
    try {
      final coffeeCategories = await FirebaseFirestore.instance
          .collection("Coffee_Categories")
          .get();

      List<Map<String, dynamic>> categoriesList = coffeeCategories.docs
          .map((DocumentSnapshot<Map<String, dynamic>> document) {
        return document.data() as Map<String, dynamic>;
      }).toList();
      return categoriesList;
    } catch (e) {
      throw e;
    }
  }

// Read categories from database
}


/**
 * addCategories() async {
    await categories.add({
    "Espresso":[
    "Espresso",
    "Double Espresso",
    "Americano",
    "Macchiato"
    ],
    "Latte":[
    "Latte",
    "Caramel Latte",
    "Vanilla Latte",
    "Mocha Latte"
    ],
    "Cappuccino":[
    "Cappuccino",
    "Hazelnut Cappuccino",
    "Chocolate Cappuccino",
    ],
    "Flat White":[
    "Flat White",
    "Coconut Flat White",
    ],
    "Cold Brew":[
    "Cold Brew",
    "Nitro Cold Brew",
    "Vanilla Cold Brew"
    ],
    "Iced Coffee":[
    "Iced Coffee",
    "Iced Americano",
    "Iced Latte"
    ],
    "Specialty Drinks":[
    "Chai Latte",
    "Matcha Latte",
    "Turmeric Latte",
    "Golden Milk"
    ],
    "Milk Alternatives":[
    "Almond Milk Latte",
    "Soy Milk Latte",
    "Oat Milk Latte"
    ],
    "Decaf Options":[
    "Decaf Espresso",
    "Decaf Latte"
    ],
    "Customizable Options":[
    "Create-Your-Own",
    "Choose Your Milk"
    ],
    "Tea":[
    "Hot Tea",
    "Iced Tea",
    "Chai Tea Latte"
    ],
    }).then((value) => print("Success"));
    }
 */