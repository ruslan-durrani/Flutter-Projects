import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:lost_get/common/service/storage_service.dart';
import 'package:lost_get/services/chat_system_services/chat_service.dart';
import 'package:workmanager/workmanager.dart';

import '../firebase_options.dart';

class Global {
  static late StorageService storageService;



  static Future init() async {
    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    await Hive.initFlutter(); // Initialize Hive


    storageService = await StorageService().init();
  }
}
