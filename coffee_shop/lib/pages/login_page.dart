import 'package:coffee_shop/components/my_button.dart';
import 'package:coffee_shop/components/my_textField.dart';
import 'package:coffee_shop/pages/WelcomePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  static String routeName = "/login_screen";
  void Function() togglePage;
  LoginScreen({super.key,required this.togglePage, });

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    var screenHeight = MediaQuery.of(context).size.height-MediaQuery.of(context).viewPadding.top;
    return Scaffold(
      backgroundColor: colorScheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            height: screenHeight,
            width: double.maxFinite,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: Column(
                    children: [
                      Image.asset("./assets/expresso.png",scale: 4,),
                      SizedBox(height: 10,),
                      Text("How do you like your coffee?",style: TextStyle(fontWeight: FontWeight.normal,letterSpacing: 2,fontSize: 13,color: colorScheme.inversePrimary),),
                      const SizedBox(height: 20,),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Login",style: TextStyle(color: colorScheme.inversePrimary,fontWeight: FontWeight.bold,fontSize: 30),),
                      ),
                    ],
                  ),
                ),

                Column(
                  children: [
                    MyTextField(controller: emailController, hint: "Email", obscureText: false),
                    const SizedBox(height: 20,),
                    MyTextField(controller: passwordController, hint: "Password", obscureText: true),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    children: [
                      const Align(
                        alignment: Alignment.centerRight,
                        child: Text("Forgot password?",style: TextStyle(fontWeight: FontWeight.bold),),
                      ),
                      const SizedBox(height: 20,),
                      GestureDetector(
                        onTap: (){
                          Navigator.pushReplacementNamed(context, WelcomePage.routeName);
                        },
                        child: MyButton(buttonText: "Login"),
                      ),
                    ],
                  )
                ),
                Row(
                  children: [
                    Expanded(child: Divider(color: colorScheme.inversePrimary,height: 3,)),
                    GestureDetector(
                        onTap: ()=>togglePage(),
                        child: Padding(padding: EdgeInsets.symmetric(horizontal: 10),child: Text("Don't have an account",style: TextStyle(color: colorScheme.inversePrimary.withOpacity(.5),fontWeight: FontWeight.bold),),)),
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
