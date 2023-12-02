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
  void createNewTask(){
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context){
          return buildNewTaskForm();
        }
        );
    // showBottomSheet(context: context, builder: (context){
    //   return buildNewTaskForm();
    // });
  }
  List<Map<String,dynamic>> listTileData = [
    {
      "title":"Make Tutorial",
      "isChecked":true,
    },
    {
      "title":"Football Match",
      "isChecked":false,
    },
    {
      "title":"Final Year Project",
      "isChecked":true,
    }
  ];

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
            return TodoListTile(title: listTileData[index]["title"], isChecked: listTileData[index]["isChecked"],onChanged: (value)=>checkBoxOnChange(value,index),);
          },
        )
      ),
    );
  }
}
