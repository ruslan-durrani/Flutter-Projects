import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nexus_meet/screens/components/snackbar.dart';

class AuthService{
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<bool> signInWithGoogle(BuildContext context)async{
    bool res = false;
    try{
      final GoogleSignInAccount? _googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? _googleAuth = await _googleUser?.authentication;
      final credentials = GoogleAuthProvider.credential(
        accessToken: _googleAuth?.accessToken,
        idToken: _googleAuth?.idToken
      );
      UserCredential userCredentials = await _auth.signInWithCredential(credentials);
      User? user = userCredentials.user;
      if(user!=null){
        if(userCredentials.additionalUserInfo!.isNewUser){
          await _firestore.collection("users").doc(user.uid).set({
            "uid":user.uid,
            "username":user.displayName,
            "profilePhoto":user.photoURL
          });
        }
        res = true;
      }
      return res;
    }on FirebaseAuthException catch(e){
      showSnackbar(context, e.toString());
      return false;
    }
  }
}