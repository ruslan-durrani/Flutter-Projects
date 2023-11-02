import 'package:coffee_shop/models/CoffeeShop.dart';
import 'package:coffee_shop/pages/home_page.dart';
import 'package:coffee_shop/theme/dark_theme.dart';
import 'package:coffee_shop/theme/light_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main () => runApp(StartApp());
class StartApp extends StatelessWidget {
  const StartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (context)=>CoffeeShop(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        darkTheme: darkTheme,
        home: HomePage(),
      ),);

  }
}
