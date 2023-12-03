import 'package:doito/components/todo_list_tile.dart';
import 'package:doito/data/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../components/build_new_task_form.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _mybox = Hive.box("mybox");
  DoitoDatabase myDatabase = DoitoDatabase();

  checkBoxOnChange(changed,index){
    setState(() {
      myDatabase.toDo.elementAt(index)["isChecked"] = changed;
    });
    myDatabase.updateDatabase();
  }
  onSavedButtonPressed(String title,String description){
    setState(() {
      myDatabase.toDo.add({
        "title":title,
        "description":description,
        "isChecked":false
      });
      myDatabase.updateDatabase();
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
  @override
  void initState() {
    // TODO: Life Starts
    if(_mybox.get("DOITO")==null){
      myDatabase.createInitialData();
    }
    else{
      myDatabase.loadData();
    }

    super.initState();
  }
  // List<Map<String,dynamic>> listTileData = [
  //   {
  //     "title":"Make Tutorial",
  //     "description":"description",
  //     "isChecked":true,
  //   },
  //   {
  //     "title":"Football Match",
  //     "description":"description",
  //     "isChecked":false,
  //   },
  //   {
  //     "title":"Final Year Project",
  //     "description":"description",
  //     "isChecked":true,
  //   }
  // ];

  void deleteSlided(int index){
    setState(() {
      myDatabase.toDo.removeAt(index);
      myDatabase.updateDatabase();
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
          itemCount: myDatabase.toDo.length,
          itemBuilder: (BuildContext context, int index) {
            // This function is called for each item in the list
            return TodoListTile(title: myDatabase.toDo[index]["title"], isChecked: myDatabase.toDo[index]["isChecked"],onChanged: (value)=>checkBoxOnChange(value,index),deleteSlided: (context)=>deleteSlided(index),);
          },
        )
      ),
    );
  }
}
