import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyLikeButton extends StatelessWidget {
  bool isLiked;
  void Function()? onPressLikeButton;
   MyLikeButton({super.key, required this.onPressLikeButton, required this.isLiked});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressLikeButton,
      child: Icon(
          isLiked?Icons.favorite:Icons.favorite_border,
        color: isLiked? Colors.red:Colors.grey,
      ),
    );
  }
}
