import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:memoir/pages/login_or_register.dart';

import '../pages/HomePage.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context,snapshot){
        if(snapshot.hasData){//&& FirebaseAuth.instance.currentUser!.emailVerified
          return HomePage();
        }
        else{
          return LoginOrRegister();
        }
      },
    );
  }
}
