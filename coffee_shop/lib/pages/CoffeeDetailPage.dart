import 'package:carousel_slider/carousel_slider.dart';
import 'package:coffee_shop/components/get_coffee_carousal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CoffeeDetailsPage extends StatefulWidget {
  static String routeName = "/coffee_detail";
  const CoffeeDetailsPage({super.key});
  @override
  State<CoffeeDetailsPage> createState() => _CoffeeDetailsPageState();
}

class _CoffeeDetailsPageState extends State<CoffeeDetailsPage> {
  List<String> listOfImages = [
    "./assets/expresso.png",
    "./assets/expresso.png",
    "./assets/expresso.png",
  ];
  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        backgroundColor: colorScheme.background,
        elevation: 0.0,
        leading: IconButton(onPressed: ()=>Navigator.pop(context), icon: Icon(Icons.arrow_back_rounded,color: colorScheme.inversePrimary,),)
      ),
      body: Padding(
          padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
          getCoffeeCarousal(listOfImages),
          ]
        ),
      ),
    );
  }
}
