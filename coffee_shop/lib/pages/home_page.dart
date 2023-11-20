import 'package:coffee_shop/components/bottom_navbar.dart';
import 'package:coffee_shop/pages/cart_page.dart';
import 'package:coffee_shop/pages/profile_page.dart';
import 'package:coffee_shop/pages/shop_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/my_drawer.dart';

class HomePage extends StatefulWidget {
  static String routeName = "/home_page";
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  static String routName = "/home_page";
  Widget currentPage = ShopPage();
  List<Widget> pages = [
    const ShopPage(),
    const CartPage(),
    const ProfileScreen(),
  ];
  void onTabChange(navIndex){
    setState(() {
      currentPage = pages[navIndex];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      backgroundColor: Theme.of(context).colorScheme.background,
      bottomNavigationBar:  BottomNavBar(onTabChange: onTabChange,),
      body: currentPage,
    );
  }
}
