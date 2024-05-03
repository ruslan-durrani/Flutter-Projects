import 'package:flutter/material.dart';

class TopProfileInfo extends StatelessWidget {
  const TopProfileInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(20),
        padding: EdgeInsets.symmetric(vertical: 20),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).colorScheme.inverseSurface.withOpacity(.05)
        ),
        child: Column(
          children: [
            Image.asset("./assets/images/ruslan.png"),
            SizedBox(height: 10,),
            Text("Ruslan B",style: Theme.of(context).textTheme.displayLarge,),
            Text("Product Developer",style: Theme.of(context).textTheme.bodyMedium,)
          ],
        ),
      )
    ;
  }
}
