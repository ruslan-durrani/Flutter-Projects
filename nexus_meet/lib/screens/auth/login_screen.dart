import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nexus_meet/screens/components/custome_button.dart';
import 'package:nexus_meet/screens/home/home_screen.dart';
import 'package:nexus_meet/services/auth_service.dart';
import 'package:nexus_meet/theme/paddings.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen(Function() toggleAuth, {super.key});

  @override
  Widget build(BuildContext context) {
    AuthService _authService = AuthService();
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: horizontalPad,vertical: verticalPad),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text("Start or join a meeting",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 24),),
            Image.asset("./assets/images/onboarding.jpg"),
            CustomeButton(text: "Google Sign in", onPress: ()async{
              bool isSuccessfull = await _authService.signInWithGoogle(context);
              print("True is $isSuccessfull");
              if(isSuccessfull){
                Navigator.pushReplacementNamed(context, HomeScreen.routeName);
              }
              FirebaseAuth.instance.signOut();
            },),
          ],
        ),
      )
    );
  }
}
