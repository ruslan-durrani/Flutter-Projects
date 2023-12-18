import 'package:flutter/material.dart';

class GetCustomDrawer extends StatelessWidget {
  const GetCustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return Drawer(
      backgroundColor: colorScheme.primary,
      child: Container(
        margin: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // CircleAvatar(
            //   radius: 50,
            //   child: Image(image: AssetImage("./assets/images/ruslan.png"),fit: BoxFit.cover,),
            // )
          ],
        ),
      ),
    );
  }
}
