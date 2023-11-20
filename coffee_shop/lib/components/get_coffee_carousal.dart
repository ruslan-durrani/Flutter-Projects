import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';

Widget getCoffeeCarousal(List<String> listOfImages){
  return CarouselSlider(
    options: CarouselOptions(
      height: 200.0,
      enlargeCenterPage: true,
      autoPlay: true,
      aspectRatio: 16/9,
      autoPlayCurve: Curves.fastOutSlowIn,
      enableInfiniteScroll: true,
      autoPlayAnimationDuration: Duration(milliseconds: 800),
      viewportFraction: 0.8,
    ),
    items: listOfImages.map((String imageUrl) {
      return Builder(
        builder: (BuildContext context) {
          return Container(
            padding: EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(horizontal: 5.0),
            child: Image.asset(
              imageUrl,
              fit: BoxFit.contain,
            ),
          );
        },
      );
    }).toList(),
  );
}