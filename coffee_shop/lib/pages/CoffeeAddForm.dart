import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddCoffeeForm extends StatefulWidget {
  const AddCoffeeForm({super.key});

  @override
  State<AddCoffeeForm> createState() => _AddCoffeeFormState();
}

class _AddCoffeeFormState extends State<AddCoffeeForm> {
  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return SafeArea(
      child: Scaffold(
        backgroundColor: colorScheme.background,
        appBar: AppBar(
          elevation: 0.0,
          automaticallyImplyLeading: false,
          backgroundColor: colorScheme.background,
          actions: [
            IconButton(onPressed: ()=>Navigator.pop(context), icon: Icon(Icons.cancel,color: colorScheme.inversePrimary,))
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            children: [

            ],
          ),
        ),
      ),
    );
  }
}
