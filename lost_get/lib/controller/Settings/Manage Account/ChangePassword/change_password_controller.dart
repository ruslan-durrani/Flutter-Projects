import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lost_get/business_logic_layer/ProfileSettings/Settings/ManageAccount/ChangePassword/bloc/change_password_bloc.dart';

class ChangePasswordController {
  Future<void> handlePasswordChange(
      TextEditingController oldPasswordController,
      TextEditingController newPasswordController,
      ChangePasswordBloc passwordBloc) async {
    try {
      passwordBloc.add(ChangePasswordButtonLoadingEvent());
      final currentPassword = oldPasswordController.text;
      final newPassword = newPasswordController.text;

      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Here, you need to obtain the user's current password.
        // This is typically done through a secure input form.

        // Create a credential using the user's current email and password
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: currentPassword,
        );

        // Reauthenticate the user with the credential
        await user.reauthenticateWithCredential(credential).then((value) async {
          if (value.user != null) {
            if (currentPassword == newPassword) {
              passwordBloc.add(const ChangePasswordButtonErrorEvent(
                  "Both Passwords Are Same"));
            } else {
              await user.updatePassword(newPassword).then((value) {
                passwordBloc.add(ChangePasswordButtonSuccessEvent());
              });
            }
          } else {
            passwordBloc.add(const ChangePasswordButtonErrorEvent(
                "Current Password Is Incorrect"));
          }
        });
      }
    } catch (e) {
      // Handle reauthentication failure
      passwordBloc.add(const ChangePasswordButtonErrorEvent(
          "Current Password Error Occurred"));
    }
  }
}
