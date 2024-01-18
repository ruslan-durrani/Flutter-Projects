import 'package:app_messenger_module/pages/login_page.dart';
import 'package:app_messenger_module/pages/signup_page.dart';
import 'package:flutter/cupertino.dart';

class LoginOrSignUp extends StatefulWidget {
  LoginOrSignUp({super.key});

  @override
  State<LoginOrSignUp> createState() => _LoginOrSignUpState();
}

class _LoginOrSignUpState extends State<LoginOrSignUp> {
  bool isLogin = true;
  toggleAuthPage(){
    setState(() {
      isLogin = !isLogin;
    });
  }
  @override
  Widget build(BuildContext context) {
    if(isLogin){
      return LoginPage( toggleAuth: toggleAuthPage,);
    }
    else{
      return SignUp(toggleAuth:  toggleAuthPage,);
    }
  }
}
