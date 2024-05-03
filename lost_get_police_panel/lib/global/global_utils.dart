
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';

import '../firebase_options.dart';

globalInitializers() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}