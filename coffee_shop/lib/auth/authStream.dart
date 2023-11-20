import 'package:coffee_shop/pages/WelcomePage.dart';
import 'package:coffee_shop/pages/auth_toggler.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AuthStream extends StatelessWidget {
  const AuthStream({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(stream: FirebaseAuth.instance.authStateChanges(), builder: (context,snapshot){
      if(snapshot.hasData){
        return WelcomePage();
      }
      else{
        return AuthTogglePage();
      }
    });
  }
}
