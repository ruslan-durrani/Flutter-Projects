import 'dart:html';
import 'dart:js_interop';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:intl_phone_field/phone_number.dart';

import 'package:responsive_admin_dashboard/global/services/firestore_service.dart';
import 'package:responsive_admin_dashboard/global/widgets/toastFlutter.dart';


import '../../screens/users_management/models/userProfile.dart';

class FirebaseService {
  final FirebaseAuth _firebaseAuth;
  FirebaseService({FirebaseAuth? firebaseAuth}):_firebaseAuth=firebaseAuth??FirebaseAuth.instance;
  logout() async {
    await _firebaseAuth.signOut();
  }
  getFirebaseUserToken(){
    User? user = _firebaseAuth.currentUser;
    if (user != null) {
      user.getIdToken().then((tokenResult) {
        if (tokenResult != null) {
          String token = tokenResult;
          print("User's authentication token: $token");

          // You can use the `token` for making authenticated requests or other purposes.
        } else {
          // Handle the case where `tokenResult` is null
          print("TokenResult is null.");
        }
      }).catchError((error) {
        // Handle any errors that may occur while fetching the token
        print("Error getting authentication token: $error");
      });
    } else {
      // No user is currently signed in
      print("No user is signed in.");
    }
  }
  Future<UserCredential> userSignInWithEmailAndPassword(String email, String password) async {
    return await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
  }
  Future<UserCredential> userSignInWithToken(String token) async {
    return await _firebaseAuth.signInWithCustomToken(token);
  }
  String getMyUID() {
    return _firebaseAuth.currentUser!.uid;
  }
  Future<bool> reAuthenticationOfUserCredentials(String currentPassword) async {
    final user = _firebaseAuth.currentUser;
    AuthCredential credential = EmailAuthProvider.credential(
      email: user!.email as String,
      password: currentPassword,
    );
    try {
      await user.reauthenticateWithCredential(credential);
      return true;
    } catch (error) {
      print("Error authenticating: $error");
      return false;
    }
  }

  Future<UserCredential?> createLostGetUser(email,password) async {
    try{
      final createdUser = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email!,
        password: password,
      );
      if(createdUser.user != null){
        await createdUser.user?.sendEmailVerification();
      }
      return createdUser;
    }
    on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        toasterFlutter('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {

        toasterFlutter('The account already exists for that email.');
      }
      else{
      toasterFlutter('Registration Failed ${e.code}');
      }
      return null;
    } catch (e) {
      toasterFlutter('Error during registration: $e');
      return null;
    }
  }
  Future passwordReset([String? forgotPasswordEmail]) async{
    try {
      if(_firebaseAuth.currentUser == null){
        await FirebaseAuth.instance.sendPasswordResetEmail(email: forgotPasswordEmail!);
        return true;
      }
      await _firebaseAuth.sendPasswordResetEmail(email: _firebaseAuth.currentUser!.email!);
      return true;
    } on FirebaseAuthException {
      toasterFlutter('User not found');
    } on InvalidCharactersException {
        await toasterFlutter('This is an invalid email address');

    } catch(e) {
      await toasterFlutter('Please try again');
    }
  }

  Future<UserCredential?> registerAdmin(String email, String password,) async {
      UserCredential? credentials = await createLostGetUser(
        email,
        password,
      );

      if (credentials != null) {
        return credentials;
      }
      return null;
  }

  Future<void> updateMyPassword(String newPassword) async {
    await FirebaseAuth.instance.currentUser!
        .updatePassword(newPassword.trim())
        .then((value) {
      toasterFlutter("Updated Successfully");
    }).catchError((err) {
      toasterFlutter("Cannot update $err");
    });
  }


}



