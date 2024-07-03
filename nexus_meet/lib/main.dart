
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nexus_meet/screens/auth/auth_screen.dart';
import 'package:nexus_meet/screens/home/home_screen.dart';
import 'package:nexus_meet/screens/navigator/app_navigator.dart';
import 'package:nexus_meet/theme/colours.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const NexusMeet());
}

class NexusMeet extends StatelessWidget {
  const NexusMeet({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Nexus Meet",
      theme: ThemeData.dark()!.copyWith(
        scaffoldBackgroundColor: backgroundColor
      ),
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      routes: {
        '/': (context)=>AuthScreen(),
        AppNavigator.routeName: (context)=>AppNavigator(),
        // HomeScreen.routeName: (context)=>HomeScreen(),
      },
    );
  }
}
