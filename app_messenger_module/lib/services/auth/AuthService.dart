

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //Get Current user
  User? getCurrentUser(){
    return _auth.currentUser;
  }
  // Sign in
  signIn(String email, String password, BuildContext context) async{
    try{
      UserCredential user = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      return await storeUserRecord (user).then((value) => user);
      // return user;
    }
    on FirebaseAuthException catch(e){
      showDialog(context: context, builder: (context) => AlertDialog(
        title: Text("Error: ${e.code}"),
      ));
    }
  }
  // Sign up
  signUp(String email, String password, BuildContext context) async{
    try{
      UserCredential user = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return await storeUserRecord (user).then((value) => user);
      // return user;
  }
    on FirebaseAuthException catch(e){
      showDialog(context: context, builder: (context)=> AlertDialog(
        title: Text("Error: ${e.code}"),
      ));
    }

  }
  // Sign out
   signOut()async{
    await _auth.signOut();
  }

  Future<void> storeUserRecord(  UserCredential user)async {
    try {
      await _firestore.collection("users").add(
          {
            "uid":user.user!.uid,
            "name": user.user!.email!.split("@").first,
            "email": user.user!.email,
            "userChatsList": [],
          }
      ).then((value) => print(value.toString()));
    } catch (e) {
      // Handle Firestore error here
      print("Error storing user data in Firestore: $e");
    }
  }
}