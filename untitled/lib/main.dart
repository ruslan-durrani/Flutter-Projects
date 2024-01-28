import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'ChatPage.dart';
void main() {
  initializeDateFormatting().then((_) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => const MaterialApp(
    home: ChatPage(),
  );
}
