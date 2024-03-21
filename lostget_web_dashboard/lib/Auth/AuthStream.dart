
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:responsive_admin_dashboard/screens/authentication/auth_screen.dart';
import 'package:responsive_admin_dashboard/screens/dashboard/dash_board_screen.dart';

import '../screens/dashboard/dashboard_pager.dart';

class AuthStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(stream: FirebaseAuth.instance.authStateChanges(), builder: (context,snapshot){
      if(snapshot.hasData){
        return DashBoardPages();
      }
      else{
        return Authentication();
      }
    });
  }
}
