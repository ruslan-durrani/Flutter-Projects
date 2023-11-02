import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShopPage extends StatelessWidget {
  static String routName = "/shop_page";
  const ShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Text("SHOP"),
      ),
    );
  }
}
