import 'package:app_messenger_module/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import 'login_or_signup.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context,snapshop){
      if(snapshop.hasData){
        return HomePage();
      }
      else{
        return LoginOrSignUp();
      }
    });
  }
}
