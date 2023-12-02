import 'package:doito/components/my_button.dart';
import 'package:flutter/material.dart';

import 'my_text_field.dart';

class buildNewTaskForm extends StatefulWidget {
  final Function onSavedButtonPressed;
  const buildNewTaskForm({super.key,required this.onSavedButtonPressed, });

  @override
  State<buildNewTaskForm> createState() => _buildNewTaskFormState();
}

class _buildNewTaskFormState extends State<buildNewTaskForm> {
  var titleController = TextEditingController();
  var descriptionController = TextEditingController();
  handleSave(){
        widget.onSavedButtonPressed(titleController.text.trim(),descriptionController.text.trim());
        Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Dialog.fullscreen(
          backgroundColor: Colors.transparent,
          child: Container(
            alignment: Alignment.centerLeft,

            width: MediaQuery.of(context).size.height,
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: colorScheme.background
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Add New Task",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 17),),
                Padding(
                  padding: const EdgeInsets.only(top:20.0),
                  child: MyTextField(controller: titleController, hint: 'Enter Title', obscureText: false,),
                ),
                Padding(
                  padding: const EdgeInsets.only(top:20.0,bottom: 20),
                  child: MyTextField(controller: descriptionController, hint: 'Enter Description', obscureText: false,isMultiLine: true,),
                ),
                Row(
                  children: [
                    Expanded(child: GestureDetector(
                      onTap: handleSave,
                      child: MyButton(buttonText: "Save"),
                    ),),
                    SizedBox(width: 10,),
                    Expanded(child: GestureDetector(
                      onTap:()=>Navigator.pop(context),
                      child: MyButton(buttonText: "Cancel",isPrimary: false,),
                    ),),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
