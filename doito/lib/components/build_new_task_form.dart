import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'my_text_field.dart';

class buildNewTaskForm extends StatelessWidget {
  const buildNewTaskForm({super.key});

  @override
  Widget build(BuildContext context) {
    var titleController = TextEditingController();
    var descriptionController = TextEditingController();
    var colorScheme = Theme.of(context).colorScheme;
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 25,vertical: 25),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: colorScheme.background
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Add New Task",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 17),),
          MyTextField(controller: titleController, hint: 'Enter Title', obscureText: false,),
          MyTextField(controller: descriptionController, hint: 'Enter description', obscureText: false,),

        ],
      ),
    );
  }
}
