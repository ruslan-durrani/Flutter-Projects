import 'package:coffee_shop/components/bottom_navbar.dart';
import 'package:coffee_shop/pages/cart_page.dart';
import 'package:coffee_shop/pages/shop_page.dart';
import 'package:coffee_shop/theme/dark_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  static String routName = "/home_page";
  Widget currentPage = ShopPage();
  List<Widget> pages = [
    ShopPage(),
    CartPage()
  ];
  void onTabChange(navIndex){
    setState(() {
      currentPage = pages[navIndex];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      bottomNavigationBar:  BottomNavBar(onTabChange: onTabChange,),
      body: currentPage,
    );
  }
}
