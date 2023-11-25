import 'dart:io';

import 'package:coffee_shop/components/my_button.dart';
import 'package:coffee_shop/components/my_textField.dart';
import 'package:coffee_shop/utility/my_snakbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddCoffeeForm extends StatefulWidget {
  const AddCoffeeForm({Key? key}) : super(key: key);

  @override
  State<AddCoffeeForm> createState() => _AddCoffeeFormState();
}

class _AddCoffeeFormState extends State<AddCoffeeForm> {
  List<XFile> files = [];
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController sizeController = TextEditingController();
  TextEditingController ingredientsController = TextEditingController();


  Future<void> getLocalImages() async {
    List<XFile>? result = await ImagePicker().pickMultiImage();
    if (result != null) {
      setState(() {
        files = result;
      });
    }
  }

  Future<void> removeSelectedCoffeeFromList(XFile file) async{
    // files.remove(file);
    setState(() {
      files.remove(file);
    });
  }


  void submitCoffeeItem()async{
    showSnackBar(context, "Add Item Button Pressed");
  }
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
          title:  Text("Add Coffee To Your Shop",style: TextStyle(
              fontSize: 18,fontWeight: FontWeight.bold,color: colorScheme.inversePrimary
          ),
          ),
          actions: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.cancel, color: colorScheme.inversePrimary),
            )
          ],
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(8),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MyTextField(controller: titleController, hint: "Enter Item Name", obscureText: false),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MyTextField(isMultiLine: true,controller: descriptionController, hint: "Coffee Description", obscureText: false,),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MyTextField(controller: categoryController, hint: "Select Category", obscureText: false),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MyTextField(controller: priceController, hint: "Price", obscureText: false),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MyTextField(controller: sizeController, hint: "Quantity", obscureText: false),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                            onTap: getLocalImages,
                            child: Stack(
                              children: [
                                CircleAvatar(
                                  backgroundColor: colorScheme.secondary,
                                  radius: 50,
                                  child: Icon(Icons.coffee, color: colorScheme.inversePrimary),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: CircleAvatar(
                                    backgroundColor: colorScheme.inversePrimary,
                                    child: Icon(Icons.add,color: colorScheme.secondary,),
                                  ),
                                )
                              ],
                            )
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              if (files.isNotEmpty)
                                ...files.map((file) {
                                  return Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Stack(
                                      children: [
                                        Container(
                                          decoration:BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          height: MediaQuery.of(context).size.width * .3,
                                          width: MediaQuery.of(context).size.width * .3,
                                          margin: const EdgeInsets.all(5),
                                          child: Image.file(File(file.path),fit: BoxFit.fill,),
                                        ),
                                        Positioned(
                                          bottom:8,right:12,
                                          child: GestureDetector(
                                            onTap: () => removeSelectedCoffeeFromList(file),
                                            child: CircleAvatar(
                                              radius: 12,
                                              backgroundColor: colorScheme.secondary,
                                              child: Icon(
                                                Icons.cancel,color: colorScheme.inversePrimary,),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                }).toList(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: submitCoffeeItem,
                      child: MyButton(buttonText: "Add Coffee"),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
