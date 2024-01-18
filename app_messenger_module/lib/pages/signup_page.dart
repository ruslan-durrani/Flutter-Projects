import 'package:app_messenger_module/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/GetLabel.dart';
import '../components/MyButton.dart';
import '../components/MyTextField.dart';

class SignUp extends StatefulWidget {
  final Function()? toggleAuth;
  SignUp({super.key,
    required this.toggleAuth
  });

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController controllerEmail = TextEditingController();

  TextEditingController controllerPassword = TextEditingController();

  TextEditingController controllerConfirmPassword = TextEditingController();

  handleSignUp() async {
    if(controllerEmail.text.trim().isEmpty){
      print("Email not valid or emply");
    }
    else if(controllerConfirmPassword.text.trim() == controllerPassword.text.trim() ){
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: controllerEmail.text.trim(), password: controllerPassword.text.trim()).then((value){
        Navigator.pushReplacementNamed(context, HomePage.routeName);

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        title: Text(
          "Sign up",
          style: TextStyle(
              fontWeight: FontWeight.bold
          ),
        ),
        centerTitle: false,
        backgroundColor: colorScheme.background,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //Logo
              Image.asset("./assets/img/msg_logo.png"),
              //descriptiojn
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  "L O S T - G E T",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 19
                  ),
                ),
              ),
              //email field
              Align(
                alignment: Alignment.centerLeft,
                child: GetLabel(label: 'Email',),
              ),
              MyTextField(hintText: "Enter email", isObscure: false, controller: controllerEmail),
              //password field
              Align(
                alignment: Alignment.centerLeft,
                child: GetLabel(label: 'Password',),
              ),
              MyTextField(
                  hintText: "Enter password",
                  isObscure: true,
                  controller: controllerPassword
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: GetLabel(
                  label: 'Confirm Password',
                ),
              ),
              MyTextField(
                  hintText: "Confirm password",
                  isObscure: true,
                  controller: controllerConfirmPassword
              ),
              //siign in button
              MyButton(
                  buttonText: "sign up",
                  onTap: handleSignUp
              ),
              Container(
                width: double.maxFinite,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GetLabel(label: "Already have account? "),
                    GestureDetector(
                      onTap: widget.toggleAuth,
                      child: GetLabel(label: "Login",isBold: true,),
                    ),
                  ],
                ),
              )
              //register if not a user
            ],

          ),
        ),
      ),
    );
  }
}
