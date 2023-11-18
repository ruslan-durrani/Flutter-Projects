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

void signUpFunction(){
  //TODO Sign Up Validation

}
class _Signup_ScreenState extends State<Signup_Screen> {
  String routeName = "/signup_page";
  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    var confirmPasswordController = TextEditingController();
    return Scaffold(
      backgroundColor: colorScheme.background,
      body: Container(
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
    );
  }

}
