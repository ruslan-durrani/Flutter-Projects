import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:memoir/auth/auth.dart';
import 'package:memoir/pages/HomePage.dart';
import 'package:memoir/pages/login_or_register.dart';
import 'package:memoir/pages/login_page.dart';
import 'package:memoir/pages/profile_page.dart';
import 'package:memoir/pages/users_page.dart';
import 'package:memoir/theme/dark_theme.dart';
import 'package:memoir/theme/light_theme.dart';

import 'firebase_options.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  return runApp( StartApp());
}
class StartApp extends StatelessWidget {
  const StartApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      home: AuthPage(),
      routes: {
        LoginOrRegister.routeName:(context)=> LoginOrRegister(),
        HomePage.routeName:(context)=>  HomePage(),
        ProfilePage.routeName:(context)=>  ProfilePage(),
        UserPage.routeName:(context)=>   UserPage(),
      },
    );
  }
}
