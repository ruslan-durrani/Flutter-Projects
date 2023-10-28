import 'package:flutter/material.dart';

class MyPostButton extends StatelessWidget {
  Function()? onTap;
  MyPostButton({super.key,required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:const EdgeInsets.all(15),
        margin: const EdgeInsets.only(left: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(8),
        ),
        child:  Center(
          child: Icon(Icons.done,color: Theme.of(context).colorScheme.primary,),
        ),
      ),
    );
  }
}
