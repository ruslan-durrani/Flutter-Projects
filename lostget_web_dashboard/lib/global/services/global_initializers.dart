
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:responsive_admin_dashboard/global/services/shared_storage.dart';

import '../../firebase_options.dart';
import 'firebase_service.dart';

globalInitializers() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseService();
  await SharedStorage().init();
}