import 'package:coffee_shop/pages/login_page.dart';
import 'package:coffee_shop/pages/signup_page.dart';
import 'package:flutter/cupertino.dart';

class AuthTogglePage extends StatefulWidget {

  AuthTogglePage({super.key});

  @override
  State<AuthTogglePage> createState() => _AuthTogglePageState();
}

class _AuthTogglePageState extends State<AuthTogglePage> {
  bool isLoginRegister = true;
  void togglePage(){
    setState(() {
      isLoginRegister=!isLoginRegister;
    });
  }
  @override
  Widget build(BuildContext context) {
    return isLoginRegister?LoginScreen(togglePage: togglePage,):Signup_Screen(togglePage: togglePage,);
  }
}
