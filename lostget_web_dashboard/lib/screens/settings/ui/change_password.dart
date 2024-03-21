import 'package:firebase/firebase.dart';
import 'package:firebase_auth/firebase_auth.dart' as fauth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_admin_dashboard/constants/constants.dart';
import 'package:responsive_admin_dashboard/global/services/firebase_service.dart';
import 'package:responsive_admin_dashboard/global/widgets/toastFlutter.dart';
import 'package:responsive_admin_dashboard/screens/add_admin/controller/passwordProvider.dart';
import 'package:responsive_admin_dashboard/screens/my_profile/widgets/widgets.dart';

class ChangePassword extends StatefulWidget {
  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  bool eyeToggleCurrent = false;
  bool eyeToggleNew = false;
  final _formKeyChangePassword = GlobalKey<FormState>();
  TextEditingController currentPassword = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  bool isSuccess = false;
  @override
  Widget build(BuildContext context) {
    final passProvider = Provider.of<PasswordProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(appPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(
                  "Reset Password",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                    "Enter your current and new password. Keep your password strong."),
              ),
              Form(
                  key: _formKeyChangePassword,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextFormField(
                          controller: currentPassword,
                          obscureText: eyeToggleCurrent,
                          validator: (value) {
                            if(value!.isEmpty){
                              return "Current password is empty";
                            }
                            else{

                            }
                          },
                          decoration: setInputDecoration(
                              hintText: "Enter Current Password",
                              labelText: "Current Password",
                              suffixIcon: InkWell(
                                onTap: () {
                                  setState(() {
                                    eyeToggleCurrent = !eyeToggleCurrent;
                                  });
                                },
                                child: Icon(
                                  eyeToggleCurrent == true
                                      ? Icons.remove_red_eye
                                      : Icons.shower,
                                  color: Colors.black,
                                ),
                              ),
                              editStatus: true),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: newPassword,
                          obscureText: eyeToggleNew,
                          validator: (value) {
                            if(value!.isEmpty){
                              return "Empty new password";
                            }
                            else if (passProvider.strength !=
                                PasswordStrength.strong) {
                              return "Please select a strong password";
                            }
                          },
                          onChanged: (value) {
                            passProvider.setStrength(value.trim());
                          },
                          decoration: setInputDecoration(
                              hintText: "Enter New Password",
                              labelText: "New Password",
                              suffixIcon: InkWell(
                                onTap: () {
                                  setState(() {
                                    eyeToggleNew = !eyeToggleNew;
                                  });
                                },
                                child: Icon(
                                  eyeToggleNew == true
                                      ? Icons.remove_red_eye
                                      : Icons.shower,
                                  color: Colors.black,
                                ),
                              ),
                              editStatus: true),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Consumer<PasswordProvider>(
                          builder: (context,passProvider,child){
                            return Visibility(
                              visible:
                              (passProvider.strength != PasswordStrength.none)
                                  ? true
                                  : false,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: 7,
                                      decoration: BoxDecoration(
                                        color: passProvider.getPasswordStrengthColor,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "${passProvider.strength.name}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color:
                                          passProvider.getPasswordStrengthColor),
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: InkWell(
                          onTap: () async {
                            if(currentPassword.text == newPassword.text){
                              toasterFlutter("Current and new password can not be same");
                              return;
                            }
                            if (_formKeyChangePassword.currentState!.validate()) {
                              toasterFlutter("Updating your password....");
                              try {
                                print(currentPassword.text);
                                bool response = await FirebaseService().reAuthenticationOfUserCredentials(currentPassword.text.trim());
                                if(response){
                                    await FirebaseService().updateMyPassword(newPassword.text.trim());
                                    newPassword.clear();
                                    currentPassword.clear();
                                    passProvider.resetPasswordStrength();
                                }
                                else{
                                  toasterFlutter("Current password is not correct");
                                }
                              } on FirebaseAuthException catch (e) {
                                toasterFlutter("Cannot update $e");
                              } catch (e) {
                                toasterFlutter("Error has occurred");
                              }

                            }
                          },
                          child: reusableButton(text: "Update Password", isPrimary: true),
                        ),
                      )
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
