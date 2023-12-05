import 'package:flutter/material.dart';
class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: (){},
        backgroundColor: colorScheme.inversePrimary,
          child: Icon(Icons.add,color: colorScheme.primary,),
      ),
      body: Container(
        child: Column(
          children: [

          ],
        ),
      ),
    );
  }
}
