import 'package:coffee_shop/Firebase/firestore_database.dart';
import 'package:coffee_shop/components/get_image_with_loading_builder.dart';
import 'package:coffee_shop/components/get_populated_lcoal_images.dart';
import 'package:coffee_shop/components/my_button.dart';
import 'package:coffee_shop/components/my_textField.dart';
import 'package:coffee_shop/utility/my_snakbar.dart';
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
  List<String> categoryNames=[];
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController sizeController = TextEditingController();
  TextEditingController ingredientsController = TextEditingController();
  String selectedDropDownItem = "Select Category";

  Future<void> getLocalImages() async {
    List<XFile>? result = await ImagePicker().pickMultiImage();
    setState(() {
      files = result;
    });
    }
  Future<void> removeSelectedCoffeeFromList(XFile file) async{
    setState(() {
      files.remove(file);
    });
  }

  late Future<List<Map<String, dynamic>>> coffeeCategories;

  @override
  void initState() {
    super.initState();
    coffeeCategories = FirestoreDatabase().getCoffeeCategories();

  }
  void submitCoffeeItem()async{
    String title = titleController.text.trim();
    String description = descriptionController.text.trim();
    double price ;
    int quantity ;
    String coffeeCategory = selectedDropDownItem;
    if(titleController.text.trim().length<5){
      showSnackBar(context, "Minimum title length is 5"); return;
    }
    else if(descriptionController.text.trim().length<15){
      showSnackBar(context, "Minimum title length is 15");return;
    }
    else if(files.isEmpty){
      showSnackBar(context, "Please add at least 1 image of the coffee"); return;
    }
    else{
      try {
         quantity = int.parse(sizeController.text);
        if(quantity<=0){
          showSnackBar(context, "Quantity can not be negative or zero"); return;
        }
      } catch (e) {
        showSnackBar(context, "Quantity can should be integer"); return;
      }
      try {
        price = double.parse(priceController.text);
        if(price<=0){
          showSnackBar(context, "Price can not be negative or zero"); return;
        }
      } catch (e) {
        showSnackBar(context, "Price can should be integer"); return;
      }
    }
    List<String> downloadUrls = await FirebaseStorageService.instance.uploadImages(files,);
    showDialog(context: context, builder: (context){
      return  Center(child: CircularProgressIndicator(),);
    });
    await FirestoreDatabase().addCoffeeToMarket(coffeeName: title, description: description, quantity: quantity, coffeeCategory: coffeeCategory, price: price, coffeeImages: downloadUrls);
    Navigator.pop(context);
    /*
    .then((value) {
      showDialog(context: context, builder: (context){
        return getImageWithLoadingBuilder(context, value.first);
      });
    });
     */
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
                  child: Container(
                    width: double.maxFinite,
                    height: 55,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: colorScheme.secondary,
                            width: 1
                        ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: FutureBuilder(future: coffeeCategories, builder: (context,snapshot){
                      if(snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData){
                        return DropdownButton<String>(
                            padding: const EdgeInsets.all(8.0),
                            style: TextStyle(color: colorScheme.inversePrimary),
                            dropdownColor: colorScheme.primary,
                            isExpanded: true,
                            elevation: 1,
                            items: const [
                              DropdownMenuItem(value: "Select Category",child: Text("Select Category"),),
                            ],value: "Select Category", onChanged: (value){

                        });
                      }
                      else{
                        if(categoryNames.isEmpty){
                          List<Map<String, dynamic>> categories = snapshot.data!;
                          categories[0].forEach((key, value) {
                            categoryNames.add(key);
                          });
                          categoryNames.add("Select Category");
                        }
                        return DropdownButton<String>(
                            padding: const EdgeInsets.all(8.0),
                            style: TextStyle(color: colorScheme.inversePrimary),
                            dropdownColor: colorScheme.primary,
                            isExpanded: true,
                            elevation: 1,
                            items:
                              categoryNames.map((category){
                                return DropdownMenuItem(child: Text(category),value: category,);
                              }).toList(),
                            value: selectedDropDownItem, onChanged: (value){
                            setState(() {
                              print(value);
                              selectedDropDownItem = value as String;
                            });
                        });
                      }
                    }),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MyTextField(controller: priceController, hint: "Price", obscureText: false,inputType: TextInputType.number,),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MyTextField(controller: sizeController, hint: "Quantity", obscureText: false,inputType: TextInputType.number,),
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
