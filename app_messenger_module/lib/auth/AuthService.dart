

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // Sign in
  signIn(String email, String password, BuildContext context) async{
    try{
      UserCredential user  = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      return user;
    }
    on FirebaseAuthException catch(e){
      showDialog(context: context, builder: (context)=> AlertDialog(
        title: Text("Error: ${e.code}"),
      ));
    }
  }
  // Sign up
  signUp(String email, String password, BuildContext context) async{
    try{

      UserCredential user = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return user;
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
}