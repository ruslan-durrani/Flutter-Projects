import 'package:coffee_shop/pages/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class BottomNavBar extends StatelessWidget {
  void Function(int) onTabChange;
   BottomNavBar({super.key,required this.onTabChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 25,top: 10,),
      child: GNav(
        onTabChange: (value)=> onTabChange(value),
        color: Theme.of(context).colorScheme.inversePrimary.withOpacity(.6),
          activeColor: Theme.of(context).colorScheme.inversePrimary,
          mainAxisAlignment: MainAxisAlignment.center,
          tabBorderRadius: 20,
          tabActiveBorder: Border.all(width: 2,color: Theme.of(context).colorScheme.inversePrimary),
          tabs: [
        GButton(
          icon: Icons.home,
          text: "Shop",
        ),
        GButton(
          icon: Icons.shopping_cart_checkout_outlined,
          text: "Cart",
        ),
        GButton(
          icon: Icons.person,
          text: "Profile",
        ),
      ]),
    );
  }
}
