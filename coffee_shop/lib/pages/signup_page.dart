import 'package:coffee_shop/utility/my_snakbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/my_button.dart';
import '../components/my_textField.dart';
import 'WelcomePage.dart';

class Signup_Screen extends StatefulWidget {
  void Function() togglePage;
  Signup_Screen({super.key,required this.togglePage});

  @override
  State<Signup_Screen> createState() => _Signup_ScreenState();
}


class _Signup_ScreenState extends State<Signup_Screen> {
  String routeName = "/signup_page";

  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();
  Future<void> signUpFunction() async {
    //TODO Sign Up Validation
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();
    showDialog(context: context, builder: (_){
      return const Center(
        child:  CircularProgressIndicator(
          color: Colors.brown,
        ),
      );
    });
    if(email =="" || password =="" || confirmPassword == ""){
      showSnackBar(context,"Fill all the fields");
    }
    else if(password != confirmPassword){
      showSnackBar(context,"Password do not match");
    }
    else{
      try{
        await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      }
      catch (FirebaseAuthException ){
        showSnackBar(context,"Error occured");
      }
    }
    Navigator.pop(context);

  }
  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var screenHeight = MediaQuery.of(context).size.height-MediaQuery.of(context).viewPadding.top;
    return Scaffold(
      backgroundColor: colorScheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: screenHeight,
            padding: EdgeInsets.all(20),
            width: double.maxFinite,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: Column(
                    children: [
                      Image.asset("./assets/expresso.png",scale: 4,),
                      const SizedBox(height: 10,),
                      Text("How do you like your coffee?",style: TextStyle(fontWeight: FontWeight.normal,letterSpacing: 2,fontSize: 13,color: colorScheme.inversePrimary),),
                      const SizedBox(height: 20,),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Sign up",style: TextStyle(color: colorScheme.inversePrimary,fontWeight: FontWeight.bold,fontSize: 30),),
                      ),
                    ],
                  ),
                ),

                Column(
                  children: [
                    MyTextField(controller: emailController, hint: "Email", obscureText: false),
                    const SizedBox(height: 20,),
                    MyTextField(controller: passwordController, hint: "Password", obscureText: true),
                    const SizedBox(height: 20,),
                    MyTextField(controller: confirmPasswordController, hint: "Confirm Password", obscureText: true),
                  ],
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      children: [
                        const SizedBox(height: 20,),
                        GestureDetector(
                          onTap: signUpFunction,
                          child: MyButton(buttonText: "Sign up"),
                        ),
                      ],
                    )
                ),
                Row(
                  children: [
                    Expanded(child: Divider(color: colorScheme.inversePrimary,height: 3,)),
                    GestureDetector(
                        onTap: widget.togglePage,
                        child: Padding(padding: const EdgeInsets.symmetric(horizontal: 10),child: Text("Already a user?",style: TextStyle(color: colorScheme.inversePrimary.withOpacity(.5),fontWeight: FontWeight.bold),),)),
                    Expanded(child: Divider(color: colorScheme.inversePrimary,height: 3,)),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

}
