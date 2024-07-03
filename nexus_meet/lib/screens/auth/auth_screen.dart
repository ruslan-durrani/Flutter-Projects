import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nexus_meet/screens/auth/login_screen.dart';
import 'package:nexus_meet/screens/auth/signup_screen.dart';
import 'package:nexus_meet/screens/home/home_screen.dart';
import 'package:nexus_meet/screens/navigator/app_navigator.dart';
import 'package:nexus_meet/theme/colours.dart';

class AuthScreen extends StatefulWidget {
  AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;

  toggleAuth(){
    setState(() {
      isLogin = !isLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(stream: FirebaseAuth.instance.authStateChanges(), builder: (context,snapshot){
      if(snapshot.connectionState==ConnectionState.waiting){
        return const CircularProgressIndicator(color: buttonColor,);
      }
      else if(snapshot.hasData){
        return AppNavigator();
      }
      return isLogin?LoginScreen(toggleAuth):SignupScreen(toggleAuth);
    });
  }
}
