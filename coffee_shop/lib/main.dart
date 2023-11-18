import 'package:coffee_shop/models/CoffeeShop.dart';
import 'package:coffee_shop/pages/WelcomePage.dart';
import 'package:coffee_shop/pages/auth_toggler.dart';
import 'package:coffee_shop/pages/home_page.dart';
import 'package:coffee_shop/pages/login_page.dart';
import 'package:coffee_shop/pages/shop_page.dart';
import 'package:coffee_shop/theme/dark_theme.dart';
import 'package:coffee_shop/theme/light_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

Future<void> main () async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const StartApp());
}
class StartApp extends StatelessWidget {
  const StartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (context)=>CoffeeShop(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        darkTheme: darkTheme,
        home: AuthTogglePage(),
        routes: {
          // LoginScreen.routeName:(context)=> LoginScreen(togglePage: () {  },),
          WelcomePage.routeName:(context)=> const WelcomePage(),
          HomePage.routeName:(context)=>  const HomePage(),
        },
      ),);

  }
}
