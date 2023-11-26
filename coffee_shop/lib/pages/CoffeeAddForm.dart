import 'dart:io';

import 'package:coffee_shop/Firebase/firestore_database.dart';
import 'package:coffee_shop/components/get_image_with_loading_builder.dart';
import 'package:coffee_shop/components/get_populated_lcoal_images.dart';
import 'package:coffee_shop/components/my_button.dart';
import 'package:coffee_shop/components/my_textField.dart';
import 'package:coffee_shop/utility/my_snakbar.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../Firebase/firebase_storage.dart';

class AddCoffeeForm extends StatefulWidget {
  const AddCoffeeForm({Key? key}) : super(key: key);

  @override
  State<AddCoffeeForm> createState() => _AddCoffeeFormState();
}


class _AddCoffeeFormState extends State<AddCoffeeForm> {

  List<XFile> files = [];
  List<String> categories = [];
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
    setState(() {
      files.remove(file);
    });
  }

  void submitCoffeeItem()async{
    showSnackBar(context, "Add Item Button Pressed");
    // TODO Validate Title
    if(titleController.text.trim().length<5){
      showSnackBar(context, "Minimum title length is 5");
    }
    else if(descriptionController.text.trim().length<15){
      showSnackBar(context, "Minimum title length is 15");
    }
    // else if()
    // TODO Validate Description
    // TODO Validate Price
    // TODO Validate Category
    // TODO Validate Size
    await FirebaseStorageService.instance.uploadImages(files,).then((value) {
      showDialog(context: context, builder: (context){
        return getImageWithLoadingBuilder(context, value.first);
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    Future<List<Map<String, dynamic>>> coffeeCategories;

    @override
    void initState() {
      super.initState();
      coffeeCategories = FirestoreDatabase().getCoffeeCategories();
      print(coffeeCategories);
    }

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
                                  return getPopulatedLocalImages(MediaQuery.of(context).size,file,()=>removeSelectedCoffeeFromList(file),colorScheme);
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
