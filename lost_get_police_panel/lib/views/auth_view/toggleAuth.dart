import 'package:flutter/material.dart';
import 'package:lost_get_police_panel/views/auth_view/register.dart';

import 'login.dart';

class ToggleAuth extends StatefulWidget {
   ToggleAuth({super.key});

  @override
  State<ToggleAuth> createState() => _ToggleAuthState();
}

class _ToggleAuthState extends State<ToggleAuth> {
  bool isLogin = true;
  toggleAuth(){
    setState(() {
      isLogin = !isLogin;
    });
  }

  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return isLogin?Login(toggleFunc: toggleAuth,):Register(toggleFunc: toggleAuth,);
  }
}
