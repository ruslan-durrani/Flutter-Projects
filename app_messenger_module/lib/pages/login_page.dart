import 'package:app_messenger_module/components/MyButton.dart';
import 'package:app_messenger_module/components/MyTextField.dart';
import 'package:app_messenger_module/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../components/GetLabel.dart';
class LoginPage extends StatefulWidget {
  final Function()? toggleAuth;
  LoginPage({super.key,
    required this.toggleAuth
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  void handleLogin(){
    FirebaseAuth.instance.signInWithEmailAndPassword(email: controllerEmail.text.trim().toString(), password: controllerPassword.text.trim().toString()).then((value) {
      Navigator.pushReplacementNamed(context, HomePage.routeName);
    });
  }

  TextEditingController controllerEmail = TextEditingController();

  TextEditingController controllerPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(title: Text("Login",style: TextStyle(fontWeight: FontWeight.bold),),centerTitle: false,backgroundColor: colorScheme.background,),
      body: Container(
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
              child: Text("L O S T - G E T",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 19),),
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
            MyTextField(hintText: "Enter password", isObscure: true, controller: controllerPassword),
            //siign in button
            MyButton(buttonText: "Log in", onTap: handleLogin),
            Container(
              width: double.maxFinite,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GetLabel(label: "Do not have account? "),
                  GestureDetector(
                    onTap: widget.toggleAuth,
                      child: GetLabel(label: "Register",isBold: true,),
                  ),
                ],
              ),
            )
            //register if not a user
          ],

        ),
      ),
    );
  }
}
