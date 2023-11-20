import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: Colors.transparent,
       body: Drawer(
        backgroundColor: colorScheme.background,
        shadowColor: colorScheme.secondary,
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              alignment: Alignment.topRight,
              width: double.maxFinite,
              child: IconButton(
                onPressed: ()=>Navigator.pop(context),
                icon: Icon(Icons.transit_enterexit_rounded,color: colorScheme.inversePrimary,),
              ),
            )
          ],
        ),
      ),
    );

  }
}
