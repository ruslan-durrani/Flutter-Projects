import 'package:flutter/material.dart';
import 'package:lost_get_police_panel/global/global_utils.dart';
import 'package:lost_get_police_panel/theme.dart';
import 'package:lost_get_police_panel/views/map_view/map_screen.dart';
import 'global/auth_stream.dart';
Future<void> main() async {
  await globalInitializers();
  runApp(StartApp());
}
class StartApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LostGet Police Administration',
      debugShowCheckedModeBanner: false,
      theme: themeData,
      themeMode: ThemeMode.system,
      // home: MapScreen(),
      home: AuthStream(),
    );
  }
}
