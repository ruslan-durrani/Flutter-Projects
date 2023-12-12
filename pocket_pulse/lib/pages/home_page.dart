import 'package:flutter/material.dart';
import 'package:pocket_pulse/components/my_button.dart';
import 'package:pocket_pulse/components/my_text_field.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var nameController = TextEditingController();
  var amountController = TextEditingController();
  void addNewExpense(){
    showDialog(context: context, builder: (context)=>AlertDialog(
      title: Text("Add new Expense",style: TextStyle(fontWeight: FontWeight.bold,color: Theme.of(context).colorScheme.inversePrimary),),
      content: Container(
        padding: EdgeInsets.symmetric(vertical: 20),
        height: MediaQuery.of(context).size.height * .4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            MyTextField(controller: nameController, hint: "Enter Expense Name", obscureText: false),
            MyTextField(controller: amountController, hint: "Enter Expense Name", obscureText: false),
            MyButton(buttonText: "Add Expense")
          ],
        ),
      )
    ));
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.background,
      floatingActionButton: FloatingActionButton(
          onPressed: ()=>addNewExpense(),
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
