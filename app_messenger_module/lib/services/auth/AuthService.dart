

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

   signOut()async{
    await _auth.signOut();
  }
  Future<UserCredential> signUp(String email, String password, BuildContext context) async {
    try {
      UserCredential user = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      await storeUserRecord(user); // Store user record in Firestore
      return user; // Return UserCredential after storing data
    } on FirebaseAuthException catch (e) {
      // Handle specific Firebase Auth errors
      String errorMessage = "An error occurred: ${e.code}";
      if (e.code == 'email-already-in-use') {
        errorMessage = "This email is already in use.";
      } else if (e.code == 'weak-password') {
        errorMessage = "The password is too weak.";
      }
      showDialog(context: context, builder: (context) => AlertDialog(title: Text(errorMessage)));
      rethrow; // Re-throw the exception for further handling if needed
    } catch (e) {
      // Handle other exceptions
      showDialog(context: context, builder: (context) => AlertDialog(title: Text("Error: $e")));
      rethrow; // Re-throw the exception
    }
  }

  Future<void> storeUserRecord(UserCredential user) async {
    try {

      await _firestore.collection("users").doc(user.user!.uid).set({
        "uid": user.user!.uid,
        "name": user.user!.email!.split("@").first,
        "email": user.user!.email,
      }, SetOptions(merge: true));
      print("Data added to document ${user.user!.uid}");
    } catch (e) {
      print("Error storing user data in Firestore: $e");
      throw e; // Throw the exception for further handling if needed
    }
  }


}