import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lost_get/common/constants/constant.dart';
import 'package:lost_get/common/global.dart';
import 'package:lost_get/models/user_profile.dart';

import 'package:lost_get/presentation_layer/widgets/toast.dart';

import '../../business_logic_layer/Authentication/Signin/bloc/sign_in_bloc.dart';
import '../../data_store_layer/repository/users_repository.dart';

class SignInController {
  final UserRepository _userRepository = UserRepository();
  Future<void> handleSignIn(
      context,
      String type,
      SignInBloc signInBloc,
      TextEditingController emailAddressController,
      TextEditingController passwordController) async {
    try {
      if (type == 'email') {
        String emailAddress = emailAddressController.text;
        String password = passwordController.text;

        try {
          signInBloc.add(LoginButtonLoadingEvent());
          await FirebaseAuth.instance
              .signInWithEmailAndPassword(
                  email: emailAddress, password: password)
              .then(
            (userCredential) async {
              final user = userCredential.user;
              if (user != null && user.emailVerified) {
                String? idToken = await user.getIdToken();

                Global.storageService
                    .setString(
                        AppConstants.STORAGE_USER_TOKEN_KEY, idToken.toString())
                    .whenComplete(() {
                  signInBloc.add(LoginButtonSuccessEvent());
                });
              }

              if (!user!.emailVerified) {
                signInBloc.add(LoginButtonErrorEvent("User not verfied"));
              }
            },
          );
        } on FirebaseAuthException catch (e) {
          if (e.code == "user-not-found") {
            signInBloc
                .add(LoginButtonErrorEvent("No user found for that email"));
          } else if (e.code == "wrong-password") {
            signInBloc.add(LoginButtonErrorEvent("Email or password is wrong"));
          } else if (e.code == 'invalid-email') {
            signInBloc.add(LoginButtonErrorEvent("Email or password is wrong"));
          }
          //
        }
      } else if (type == 'google') {
        try {
          final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
          signInBloc.add(LoginButtonLoadingEvent());
          if (googleUser == null) {
            // User canceled the sign-in
            signInBloc.add(LoginButtonErrorEvent("Google sign-in canceled"));
            return;
          }

          final GoogleSignInAuthentication googleAuth =
              await googleUser.authentication;

          // Create a new credential
          final credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );

          await FirebaseAuth.instance
              .signInWithCredential(credential)
              .then((userCredential) async {
            // ignore: unnecessary_null_comparison
            if (userCredential != null) {
              bool isNewUser =
                  await _userRepository.isNewUser(userCredential.user!.uid);

              if (isNewUser) {
                User? user = userCredential.user;
                String? fullName = user!.displayName;
                String? emailAddress = user.email;

                UserProfile userProfile = UserProfile(
                    fullName: fullName,
                    email: emailAddress,
                    isAdmin: false,
                    biography: "",
                    imgUrl: "",
                    phoneNumber: "",
                    dateOfBirth: "",
                    preferenceList: [],
                    gender: "",
                    joinedDateTime: DateTime.now(),
                    userChatsList: [],
                  uid: user.uid
                );

                await _userRepository.createUserProfile(
                    userCredential.user!.uid, userProfile);
              }
              String? idToken = await userCredential.user!.getIdToken();
              print("Id token got from sign in $idToken");

              Global.storageService
                  .setString(
                      AppConstants.STORAGE_USER_TOKEN_KEY, idToken.toString())
                  .whenComplete(
                      () => signInBloc.add(LoginButtonSuccessEvent()));
            }
          });
        } catch (e) {
          signInBloc.add(LoginButtonErrorEvent(e.toString()));
        }
      }
    } catch (e) {
      signInBloc.add(LoginButtonErrorEvent(e.toString()));
      // pass
    }
  }

  static Future<UserCredential?> autoSignIn() async {
    String? idToken = Global.storageService.getTokenId();

    if (idToken != null) {
      try {
        print("Token before sign in: $idToken");
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCustomToken(idToken);

        return userCredential;
      } catch (e) {
        createToast(description: "Some Error Occurred");

        return null;
      }
    } else {
      return null;
    }
  }

  Future<bool> signOut() async {
    GoogleSignIn().isSignedIn().then((value) async {
      if (value) {
        await GoogleSignIn().disconnect();
      }
    });
    await FirebaseAuth.instance.signOut();
    return true;
  }

  Future<String> resetEmail(String newEmail) async {
    String message = '';
    User? firebaseuser = FirebaseAuth.instance.currentUser;
    firebaseuser
        ?.updateEmail(newEmail)
        .then((value) => message = 'success')
        .catchError((onerror) => message = 'error');
    return message;
  }
}
