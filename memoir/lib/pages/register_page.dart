import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:memoir/components/my_button.dart';
import 'package:memoir/components/my_textField.dart';
import 'package:memoir/helper/helper_functions.dart';

class RegisterPage extends StatefulWidget {
  void Function() onTap;
  RegisterPage({super.key,required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmController = TextEditingController();

  Future<void> registerAccount() async {
    // TODO Loading Circle
    showDialog(context: context, builder: (context)=>  Center(
      child: CircularProgressIndicator(color: Theme.of(context).colorScheme.inversePrimary,),
    ));


    // if(usernameController.text.length <5){
    //   Navigator.pop(context);
    //   displayMessageToUser(context, "Please enter a valid username");
    // }
    // else
      if(emailController.text.isEmpty){
      Navigator.pop(context);
      displayMessageToUser(context, "Email can't be empty");
    }
    else if( passwordController.text!=passwordConfirmController.text || passwordController.text.length <8){
      Navigator.pop(context);
      displayMessageToUser(context, "Keep string and valid Password");
    }
    else{
      try{
        UserCredential? userCredentials = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailController.text, password: passwordController.text);
        FirebaseAuth.instance.currentUser?.sendEmailVerification().then((value){
          displayMessageToUser(context, "Verification email has been sent to you");
        });
        createUserDocument(userCredentials);
        if(mounted) {
          Navigator.pop(context);
        }
      }
      on FirebaseAuthException catch (e){
        Navigator.pop(context);
        displayMessageToUser(context, e.code);
      }
    }
  }
  Future<void> createUserDocument(UserCredential? userCredential)async {
    if(userCredential != null && userCredential.user != null){
      return await FirebaseFirestore.instance
          .collection("Users")
          .doc(userCredential.user!.email)
          .set({
            "email":emailController.text,
            "username":emailController.text.split("@")[0],
            "bio":"Empty bio..."
          });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
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
              Form(child: Column(
                children: [
                  //TODO Username TextField
                  // MyTextField(controller: usernameController, hintText: "Username", obscureText:false ),
                  // const SizedBox(
                  //   height: 10,
                  // ),
                  //TODO Email TextField
                  MyTextField(controller: emailController, hintText: "Email", obscureText:false ),
                  const SizedBox(
                    height: 10,
                  ),
                  //TODO Password TextField
                  MyTextField(controller: passwordController, hintText: "Password", obscureText:true ),
                  const SizedBox(
                    height: 10,
                  ),
                  //TODO Confirm Password TextField
                  MyTextField(controller: passwordConfirmController, hintText: "Confirm Password", obscureText:true ),
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
              //TODO Register Button
              MyButton(text: "Register", onTap: registerAccount),
              const SizedBox(
                height: 25,
              ),
              //TODO Already have an account, create one
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account? ",style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),),
                  GestureDetector(onTap: widget.onTap,child: Text("Login Here",style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary,fontWeight: FontWeight.bold),)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
