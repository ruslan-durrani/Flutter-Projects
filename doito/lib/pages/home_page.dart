import 'package:doito/components/todo_list_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/build_new_task_form.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  checkBoxOnChange(changed,index){
    setState(() {
      listTileData.elementAt(index)["isChecked"] = changed;
    });
  }
  onSavedButtonPressed(String title,String description){
    setState(() {
      listTileData.add({
        "title":title,
        "description":description,
        "isChecked":false
      });
    });
  }
  void createNewTask(){
    showDialog(
        context: context,
        builder: (context){
          return buildNewTaskForm(onSavedButtonPressed: onSavedButtonPressed,);
          }
        );
  }
  List<Map<String,dynamic>> listTileData = [
    {
      "title":"Make Tutorial",
      "description":"description",
      "isChecked":true,
    },
    {
      "title":"Football Match",
      "description":"description",
      "isChecked":false,
    },
    {
      "title":"Final Year Project",
      "description":"description",
      "isChecked":true,
    }
  ];

  void deleteSlided(int index){
    setState(() {
      listTileData.removeAt(index);
    });
  }
  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(

        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0.0,
        centerTitle: true,
        title: const Text("D O I T",style: TextStyle(fontWeight: FontWeight.bold),),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,child: const Icon(Icons.add,color: Colors.white,),
      ),
      body: Container(
        child: ListView.builder(
          itemCount: listTileData.length,
          itemBuilder: (BuildContext context, int index) {
            // This function is called for each item in the list
            return TodoListTile(title: listTileData[index]["title"], isChecked: listTileData[index]["isChecked"],onChanged: (value)=>checkBoxOnChange(value,index),deleteSlided: (context)=>deleteSlided(index),);
          },
        )
      ),
    );
  }
}
