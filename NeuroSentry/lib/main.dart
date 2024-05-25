import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mental_healthapp/features/auth/screens/splash_screen.dart';
import 'package:mental_healthapp/features/dashboard/screens/socialmedia/comment_screen.dart';
import 'package:mental_healthapp/firebase_options.dart';
import 'package:mental_healthapp/router.dart';
import 'package:mental_healthapp/shared/utils/goals_database.dart';
import 'package:mental_healthapp/theme/theme.dart';
import 'package:provider/provider.dart' as provider;

import 'features/dashboard/screens/nav_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //TODO REMOVE
  await Hive.initFlutter();
  var box = await Hive.openBox('mybox');
  await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
            channelGroupKey: 'basic_channel_group',
            channelKey: 'basic_channel',
            channelName: 'NeuroSentry Alerts',
            channelDescription:
                "Receive important alerts and reminders from NeuroSentry"),
        NotificationChannel(
          channelGroupKey: 'goal_channel_group',
          channelKey: 'goal_channel',
          channelName: 'NeuroSentry Alerts',
          channelDescription:
              "Receive important alerts and reminders from NeuroSentry",
        )
      ],
      channelGroups: [
        NotificationChannelGroup(
          channelGroupKey: 'basic_channel_group',
          channelGroupName: 'Basic Group',
        ),
      ],
      debug: true);

  runApp(
    ProviderScope(
      child: provider.MultiProvider(
        providers: [
          provider.Provider<Box>.value(value: box),
          provider.ChangeNotifierProvider(create: (_) => GoalDataBase()),
          provider.ChangeNotifierProvider(
            create: (_) => AppointmentsDB(),
          )
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      theme: EAppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      onGenerateRoute: generateRoute,
      // home: const SplashScreen(),
      home: const SplashScreen(),
    );
  }
}
