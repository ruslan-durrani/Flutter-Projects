import 'dart:io';

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
                GestureDetector(
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
                if (files.isNotEmpty)
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: files.map((file) {
                        return Stack(
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height * .3,
                              width: MediaQuery.of(context).size.width * .7,
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
                        );
                      }).toList(),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
