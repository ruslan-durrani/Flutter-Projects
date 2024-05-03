
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:lost_get_police_panel/views/auth_view/toggleAuth.dart';
import 'package:lost_get_police_panel/views/home_view/home_view.dart';
import '../views/auth_view/login.dart';

class AuthStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(stream: FirebaseAuth.instance.authStateChanges(), builder: (context,snapshot){
      if(snapshot.hasData){
        return HomeView();
      }
      else{
        return ToggleAuth();
      }
    });
  }
}
