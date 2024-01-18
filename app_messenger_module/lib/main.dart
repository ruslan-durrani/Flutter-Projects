import 'package:app_messenger_module/firebase_options.dart';
import 'package:app_messenger_module/pages/home_page.dart';
import 'package:app_messenger_module/auth/login_or_signup.dart';
import 'package:app_messenger_module/pages/login_page.dart';
import 'package:app_messenger_module/themes/light_mode.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(StartMessenger());
}

class StartMessenger extends StatelessWidget {
  const StartMessenger({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightMode,
      home: LoginOrSignUp(),
      initialRoute: '/',
      routes: {

        // '/': (context) => LoginOrSignUp(),
        HomePage.routeName: (context) => HomePage(),
      },
    );
  }
}
