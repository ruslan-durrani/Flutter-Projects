import 'package:app_messenger_module/firebase_options.dart';
import 'package:app_messenger_module/pages/chat_screen.dart';
import 'package:app_messenger_module/pages/home_page.dart';
import 'package:app_messenger_module/pages/login_page.dart';
import 'package:app_messenger_module/pages/settings_page.dart';
import 'package:app_messenger_module/pages/users_page.dart';
import 'package:app_messenger_module/services/auth/auth_gate.dart';
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
      home: AuthGate(),
      initialRoute: '/',
      routes: {

        // '/': (context) => LoginOrSignUp(),
        HomePage.routeName: (context) => HomePage(),
        UserLists.routeName: (context) => UserLists(),
        SettingsPage.routeName: (context) => SettingsPage(),
        ChatScreen.routeName: (context) => ChatScreen(),
      },
    );
  }
}
