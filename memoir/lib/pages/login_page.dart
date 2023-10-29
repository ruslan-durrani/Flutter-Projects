import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:memoir/components/my_button.dart';
import 'package:memoir/components/my_textField.dart';

import '../helper/helper_functions.dart';

class LoginPage extends StatefulWidget {
  void Function() onTap;
  LoginPage({super.key,required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  Future<void> loginToAccount() async {
    // TODO Loading Circle
    showDialog(context: context, builder: (context)=>  Center(
      child: CircularProgressIndicator(color: Theme.of(context).colorScheme.inversePrimary,),
    ));
    if(emailController.text.isEmpty){
      Navigator.pop(context);
      displayMessageToUser(context, "Email field can't empty");
    }
    else if(passwordController.text.isEmpty){
      Navigator.pop(context);
      displayMessageToUser(context, "Password field can't empty");
    }
    else{
      try{
        UserCredential? user = await FirebaseAuth.instance.signInWithEmailAndPassword(email: emailController.text, password: passwordController.text);
        Navigator.pop(context);
        if(user.user!.emailVerified == true){
          displayMessageToUser(context, "You are verified User");
        }
        else{
          displayMessageToUser(context, "You are not a verified User");
        }
      }
      on FirebaseAuthException catch (e){
        Navigator.pop(context);
        displayMessageToUser(context, e.code);
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      resizeToAvoidBottomInset:false,
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(18.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //TODO Logo
              Icon(
                Icons.person,
                size: 80,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              const SizedBox(
                height: 25,
              ),
              //TODO App Name
              Text(
                "M E M O I R",
                style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).colorScheme.inversePrimary
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              //TODO Email TextField
              Form(child: Column(
                children: [
                  MyTextField(controller: emailController, hintText: "Email", obscureText:false ),
                  const SizedBox(
                    height: 10,
                  ),
                  //TODO Password TextField
                  MyTextField(controller: passwordController, hintText: "Password", obscureText:true ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              )),
              //TODO Forget Password
              Align(
                alignment: Alignment.centerRight,
                child: Text("Forgot password?",style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),),
              ),
              const SizedBox(
                height: 25,
              ),
              //TODO SignIn Button
              MyButton(text: "Sign In", onTap: loginToAccount),
              const SizedBox(
                height: 25,
              ),
              //TODO don't have an account, create one
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account? ",style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),),
                  GestureDetector(onTap: widget.onTap,child: Text("Register Here",style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary,fontWeight: FontWeight.bold),)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
