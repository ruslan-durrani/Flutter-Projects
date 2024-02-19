import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lost_get/business_logic_layer/Authentication/Signup/bloc/sign_up_bloc.dart';
import 'package:lost_get/models/user_profile.dart';
import '../../data_store_layer/repository/users_repository.dart';

class SignUpController {
  Future<void> handleSignUp(
      TextEditingController fulLNameController,
      TextEditingController emailAddressController,
      TextEditingController passwordController,
      SignUpBloc signUpBloc) async {
    final fullName = fulLNameController.text;

    final emailAddress = emailAddressController.text.trim();
    final password = passwordController.text;

    try {
      signUpBloc.add(RegisterButtonClickedLoadingEvent());

      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailAddress, password: password)
          .then((credentials) async {

        if (credentials.user != null) {
          User? user = credentials.user;
          await credentials.user!.sendEmailVerification();
          UserRepository userRepository = UserRepository();

          UserProfile userProfile = UserProfile(
            fullName: fullName,
            email: emailAddress,
            isAdmin: false,
            biography: "",
            imgUrl: "",
            phoneNumber: "",
            dateOfBirth: "",
            preferenceList: <String, dynamic>{},
            gender: "",
            joinedDateTime: DateTime.now(),
            userChatsList: [],
              uid: user!.uid
          );

          await userRepository
              .createUserProfile(credentials.user!.uid, userProfile)
              .then((value) {
            signUpBloc.add(NavigateToEmailVerificationEvent(credentials));
          });
        } else {
          // User creation failed
          signUpBloc
              .add(RegisterButtonClickedErrorEvent("User Creation Failed"));
        }
      });
      // if (credentials != null) {}
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        signUpBloc
            .add(RegisterButtonClickedErrorEvent("The password is very weak"));
      } else if (e.code == 'email-already-in-use') {
        signUpBloc.add(
            RegisterButtonClickedErrorEvent("Email Address already in use"));
      } else if (e.code == 'invalid-email') {
        signUpBloc
            .add(RegisterButtonClickedErrorEvent("Invalid Email Address"));
      }
    }
  }
}
