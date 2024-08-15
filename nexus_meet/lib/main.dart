
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'map_screen.dart';

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

      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      home: MapScreen(),
    );
  }
}
