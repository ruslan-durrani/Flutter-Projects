import 'package:flutter/cupertino.dart';
import 'package:memoir/pages/login_page.dart';
import 'package:memoir/pages/register_page.dart';

class LoginOrRegister extends StatefulWidget {
  static String routeName = "/login_register_page";
  const LoginOrRegister({super.key});
  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  bool isLogin = true;

  void toggleLog(){
    setState(() {
      isLogin = !isLogin;
    });
  }
  @override
  Widget build(BuildContext context) {
    return isLogin?LoginPage(onTap: toggleLog,):RegisterPage(onTap: toggleLog,);
  }
}
