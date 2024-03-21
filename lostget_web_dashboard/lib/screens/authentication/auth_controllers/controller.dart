import 'dart:html';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_admin_dashboard/global/routes_navigation/models/navigation_model.dart';
import 'package:responsive_admin_dashboard/global/services/cookies.dart';
import 'package:responsive_admin_dashboard/global/services/firebase_service.dart';
import 'package:responsive_admin_dashboard/global/services/firestore_service.dart';
import 'package:responsive_admin_dashboard/screens/authentication/login/bloc/login_bloc.dart';
import '../../../global/services/shared_storage.dart';
import '../../../global/widgets/toastFlutter.dart';
import '../../users_management/models/userProfile.dart';
import '../widgets/showVerificationMessage.dart';

class AuthController {
  static handleLogin(BuildContext context) async {
    // FirebaseService().registerAdmin(UserProfile(fullName: "username", email: "ruslandurrani907@gmail.com", isAdmin: true, phoneNumber: "+0934234234", preferenceList: {}, imgUrl: "profileUrl", biography: '', dateOfBirth: '', gender: '', joinedDateTime: DateTime.now(), password: 'Qasim123@'),);
    toasterFlutter("waiting...");
    String email = context
        .read<LoginBloc>()
        .state
        .email;
    String password = context
        .read<LoginBloc>()
        .state
        .password;

    if (email.isEmpty || password.isEmpty) {
      return toasterFlutter("Please enter your email or password");
    }
    try {
      final credentialObject = await FirebaseService().userSignInWithEmailAndPassword( email,  password);
      bool isAdmin = await FireStoreService().getIsAdmin();
      if (credentialObject.user == null) {
        return toasterFlutter("No User found with this email");
      }
      else if(!isAdmin){
        await toasterFlutter("You are not an admin");
      }
      else if(credentialObject.user!.emailVerified){
        toasterFlutter("🎉 Logging in...");

        // SharedStorage.setIsLogin(true);

        
        final token_ = await FirebaseAuth.instance.currentUser?.getIdTokenResult();
        if(token_ != null){
          final idToken = token_.token;
          CookieStorage().storeTokenInCookie(idToken as String);
        }
        Navigator.of(context).pushNamedAndRemoveUntil(Navigation.DASHBOARD,(route)=>false);
      }
      else if(!(credentialObject.user!.emailVerified)){
        return showVerificationMessage(context, credentialObject);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        return toasterFlutter("User not found");
      }
      else if (e.code == "wrong-password") {
        return toasterFlutter("🔒 wrong password");
      }
      else if (e.code == "invalid-email") {
        return toasterFlutter("﹫ Invalid email address");
      }
      else{
        return toasterFlutter("Error has occurred");
      }
    }
  }
}